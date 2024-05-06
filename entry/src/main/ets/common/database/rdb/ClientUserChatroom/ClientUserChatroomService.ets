import { IClientUserChatroomService } from './ClientUserChatroomService.interface';
import { ClientUserChatroom } from './ClientUserChatroom';
import relationStore from '@ohos.data.relationalStore';
import { CLIENT_USER_CHATROOM } from '../../../constants/databaseTables';
import RdbHelper from '../RdbHelper';
import { ClientChatroom } from '../ClientChatroom/ClientChatroom';

class ClientUserChatroomService implements IClientUserChatroomService {
  async getByUserIdAndChatroomId(userId: number, chatroomId: number): Promise<ClientUserChatroom | null> {
    const predicates = new relationStore.RdbPredicates(CLIENT_USER_CHATROOM);
    predicates.equalTo('userId', userId);
    predicates.equalTo('chatroomId', chatroomId);
    const result = await RdbHelper.query(predicates);
    if (!result.goToFirstRow()) {
      return null;
    }
    return this.resultToUserChatroom(result);
  }

  async save(userChatroom: Partial<ClientUserChatroom>): Promise<void> {
    const { userId, chatroomId } = userChatroom;
    if (userId === undefined || chatroomId === undefined) {
      throw new Error('save userChatroom require userId and chatroomId');
    }
    const predicates = new relationStore.RdbPredicates(CLIENT_USER_CHATROOM);
    predicates.equalTo('userId', userId);
    predicates.equalTo('chatroomId', chatroomId);
    const result = await RdbHelper.query(predicates);
    const valueBucket = this.getUserChatroomBucket(userChatroom);
    if (result.rowCount) {
      await RdbHelper.update(valueBucket, predicates);
    } else {
      await RdbHelper.insert(CLIENT_USER_CHATROOM, [valueBucket]);
    }
  }

  private getUserChatroomBucket(userChatroom: Partial<ClientUserChatroom>): relationStore.ValuesBucket {
    return { ...userChatroom };
  }

  private resultToUserChatroom(result: relationStore.ResultSet): ClientUserChatroom {
    const clientUserChatroom: ClientUserChatroom = {
      userId: result.getLong(result.getColumnIndex('userId')),
      chatroomId: result.getLong(result.getColumnIndex('chatroomId')),
      joinTime: result.getString(result.getColumnIndex('joinTime')),
      latestVisitTime: result.getString(result.getColumnIndex('latestVisitTime')),
    };
    return clientUserChatroom;
  }
}

const service = new ClientUserChatroomService();
export {
  service as ClientUserChatroomService,
};
