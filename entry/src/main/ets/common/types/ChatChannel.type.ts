import { IChatroom } from './Chatroom.type';
import { IMessage } from './Message.type';

export interface IChatChannel {
  latestMessage: IMessage | null;
  latestVisitTime: string;
  unreadMessageCount: number;
  onlineUserIds: number[];
  chatroom: IChatroom;
}