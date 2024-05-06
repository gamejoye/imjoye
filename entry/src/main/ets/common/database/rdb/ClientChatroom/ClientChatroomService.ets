import { IClientChatroomService } from './ClientChatroomService.interface';
import relationStore from '@ohos.data.relationalStore';
import RdbHelper from '../RdbHelper';
import { CLIENT_CHATROOM, CLIENT_USER_CHATROOM } from '../../../constants/databaseTables';
import { ChatroomType } from '../../../constants/chatroomType';
import { IUser } from '../../../types/User.type';
import { IChatChannel } from '../../../types/ChatChannel.type';
import { ChatChannelAdapter, ClientChatroomAdapter } from '../../../utils';
import { ClientUserChatroomService } from '../ClientUserChatroom/ClientUserChatroomService';
import { ClientChatroom } from './ClientChatroom';

class ClientChatroomService implements IClientChatroomService {
  async getChatChannels(user: IUser): Promise<Array<IChatChannel>> {
    const clientChatrooms = await this.getAll(user);
    const channels: Array<IChatChannel> = (await Promise.all(
      clientChatrooms.map(async (clientChatroom, index) => {
        const userChatroom =
          await ClientUserChatroomService.getByUserIdAndChatroomId(user.id, clientChatroom.id);
        if (!userChatroom) {
          return null;
        }
        const channel = (new ChatChannelAdapter(clientChatroom, userChatroom)).getChatChannel();
        return channel;
      })
    )).filter((channel) => channel !== null);
    return channels;
  }

  async save(user: IUser, channels: Array<IChatChannel>): Promise<void> {
    await RdbHelper.performTransaction<void>(async () => {
      await Promise.all(channels.map(async (channel) => {
        const adapter = (new ClientChatroomAdapter(user, channel));
        const chatroom = adapter.getClientChatroom();
        const userChatroom = adapter.getClientUserChatroom();
        /**
         * 1. 处理 ClientChatroom
         */
        const predicates = new relationStore.RdbPredicates(CLIENT_CHATROOM);
        predicates.equalTo('id', chatroom.id);
        const result = await RdbHelper.query(predicates);
        const valueBucket = this.getClientChatroomBucket(chatroom);
        if (result.rowCount) {
          await RdbHelper.update(valueBucket, predicates);
        } else {
          await RdbHelper.insert(CLIENT_CHATROOM, [valueBucket]);
        }
        /**
         * 2. 处理 UserChatroom
         */
        await ClientUserChatroomService.save(userChatroom);
      }));
    });
  }

  async update(user: IUser, channel: IChatChannel): Promise<void> {
    const adapter = new ClientChatroomAdapter(user, channel);
    const chatroom = adapter.getClientChatroom();
    const userChatroom = adapter.getClientUserChatroom();
    return RdbHelper.performTransaction<void>(async () => {
      const valueBucket = this.getClientChatroomBucket(chatroom);
      const predicates = new relationStore.RdbPredicates(CLIENT_CHATROOM);
      predicates.equalTo('id', chatroom.id);
      const result = await RdbHelper.query(predicates);
      if (result.rowCount) {
        await RdbHelper.update(valueBucket, predicates);
      } else {
        await RdbHelper.insert(CLIENT_CHATROOM, [valueBucket]);
      }
      ClientUserChatroomService.save(userChatroom)
    });
  }

  private async getAll(user: IUser): Promise<Array<ClientChatroom>> {
    const userChatroomPredicates = new relationStore.RdbPredicates(CLIENT_USER_CHATROOM);
    userChatroomPredicates.equalTo('userId', user.id);
    const userChatroomResult = await RdbHelper.query(userChatroomPredicates);
    const n = userChatroomResult.rowCount;
    const clientChatrooms = (await Promise.all(
      Array(n).fill(0).map(async (_, i) => {
        userChatroomResult.goToRow(i);
        const chatroomId = userChatroomResult.getLong(userChatroomResult.getColumnIndex('chatroomId'));
        const predicates = new relationStore.RdbPredicates(CLIENT_CHATROOM);
        predicates.equalTo('id', chatroomId);
        const result = await RdbHelper.query(predicates);
        if (result.goToFirstRow()) {
          return this.resultToClientChatroom(result);
        }
        return null;
      }),
    )).filter((chatroom) => chatroom !== null);
    return clientChatrooms;
  }

  private getClientChatroomBucket(chatroom: ClientChatroom): relationStore.ValuesBucket {
    const valueBucket: ClientChatroom = {
      'id': chatroom.id,
      'type': chatroom.type,
      'avatarUrl': chatroom.avatarUrl,
      'name': chatroom.name,
      'createTime': chatroom.createTime
    };
    return { ...valueBucket };
  }

  private resultToClientChatroom(result: relationStore.ResultSet): ClientChatroom {
    const clientChatroom: ClientChatroom = {
      id: result.getLong(result.getColumnIndex('id')),
      type: result.getString(result.getColumnIndex('type')) as ChatroomType,
      name: result.getString(result.getColumnIndex('name')),
      avatarUrl: result.getString(result.getColumnIndex('avatarUrl')),
      createTime: result.getString(result.getColumnIndex('createTime')),
    };
    if (result.isColumnNull(result.getColumnIndex('name'))) {
      clientChatroom.name = null;
    }
    if (result.isColumnNull(result.getColumnIndex('avatarUrl'))) {
      clientChatroom.avatarUrl = null;
    }
    return clientChatroom;
  }
}

const service = new ClientChatroomService();

export {
  service as ClientChatroomService, }