import { IChatroom } from '../../../types/Chatroom.type';
import { ClientChatroom } from '../../../views';

export interface IChatroomService {
  getAll(): Promise<Array<ClientChatroom>>;
  storeAll(clientChatrooms: Array<ClientChatroom>): Promise<void>;
  updateLatestVisitTime(chatroom: IChatroom, visitTime: string): Promise<ClientChatroom>;
}
