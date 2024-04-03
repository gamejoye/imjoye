import { IChatroom } from './Chatroom.type';
import { IMessage } from './Message.type';

export interface IChatChannelState {
  latestMessage: IMessage | null;
  latestVisitTime: string;
  unreadMessageCount: number;
  onlineUserIds: number[];
  chatroom: IChatroom;
}