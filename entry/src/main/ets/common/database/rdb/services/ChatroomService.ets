import { ClientChatroom } from '../../../views';
import { IChatroomService } from '../interface/ChatroomService.interface';
import relationStore from '@ohos.data.relationalStore';
import RdbHelper from '../RdbHelper';
import { CLIENT_CHATROOM } from '../../../constants/databaseTables';
import { IChatroom } from '../../../types/Chatroom.type';
import emitter from '@ohos.events.emitter';
import { EmitterEvent } from '../../../constants/emitterEvent';
import { ChatroomType } from '../../../constants/chatroomType';

class ChatroomService implements IChatroomService {
  async updateLatestVisitTime(chatroom: IChatroom, visitTime: string): Promise<ClientChatroom> {
    const valueBucket: relationStore.ValuesBucket = {
      ...chatroom,
      'latestVisitTime': visitTime,
    }
    const predicates = new relationStore.RdbPredicates(CLIENT_CHATROOM);
    predicates.equalTo('id', chatroom.id);
    let result = await RdbHelper.query(predicates);
    if(result.rowCount) {
      await RdbHelper.update(valueBucket, predicates);
    } else {
      await RdbHelper.insert(CLIENT_CHATROOM, [valueBucket]);
    }
    result = await RdbHelper.query(predicates);
    emitter.emit({
      eventId: EmitterEvent.CLIENT_CHATROOM_UPDATE,
    });
    result.goToFirstRow();
    return this.resultToClientChatroom(result);
  }
  async storeAll(clientChatrooms: Array<ClientChatroom>): Promise<void> {
    const promises = clientChatrooms.map(async (clientChatroom) => {
      const predicates = new relationStore.RdbPredicates(CLIENT_CHATROOM);
      predicates.equalTo('id', clientChatroom.id);
      const result = await RdbHelper.query(predicates);
      const valueBucket = this.clientChatroomToValueBucket(clientChatroom);
      if(result.rowCount) {
        RdbHelper.update(valueBucket, predicates);
      } else {
        RdbHelper.insert(CLIENT_CHATROOM, [valueBucket]);
      }
    });
    await Promise.all(promises);
  }
  async getAll(): Promise<Array<ClientChatroom>> {
    const result = await RdbHelper.queryAll(CLIENT_CHATROOM);
    const n = result.rowCount;
    const clientChatrooms: Array<ClientChatroom> = [];
    for(let i = 0; i < n; i++) {
      result.goToRow(i);
      clientChatrooms.push(this.resultToClientChatroom(result));
    }
    return clientChatrooms;
  }

  private resultToClientChatroom(result: relationStore.ResultSet): ClientChatroom {
    const clientChatroom: ClientChatroom = {
      id: result.getLong(result.getColumnIndex('id')),
      type: result.getString(result.getColumnIndex('type')) as ChatroomType,
      name: result.getString(result.getColumnIndex('name')),
      avatarUrl: result.getString(result.getColumnIndex('avatarUrl')),
      createTime: result.getString(result.getColumnIndex('createTime')),
      latestVisitTime: result.getString(result.getColumnIndex('latestVisitTime')),
    };
    return clientChatroom;
  }

  private clientChatroomToValueBucket(clientChatroom: ClientChatroom): relationStore.ValuesBucket {
    return { ...clientChatroom };
  }
}

const clientChatroomService = new ChatroomService();
export {
  clientChatroomService,
}