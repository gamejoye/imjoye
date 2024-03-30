import { WebSocketEvent } from '../../common/constants/websocketEvent';
import { BasicChannel } from '../../common/types/BasicChannel.type';
import { IChatroom } from '../../common/types/Chatroom.type';
import { IMessage } from '../../common/types/Message.type';
import { IUser } from '../../common/types/User.type';

export interface IChatChannelState {
  latestMessage: IMessage | null;
  latestVisitTime: string;
  unreadMessageCount: number;
  onlineUserIds: number[];
  chatroom: IChatroom;
}

export interface IChatChannelListener {
  onNewMessage(message: IMessage): void;
  onUserOnline(user: IUser): void;
  onUserOffline(user: IUser): void;
  onUserJoin(user: IUser): void;
  onUserDeparture(user: IUser): void;
}

export class ChatChannel extends BasicChannel<IChatChannelState> {
  constructor(state, chatChannelListener: IChatChannelListener) {
    super(state);
    this.on(WebSocketEvent.NEW_MESSAGE, chatChannelListener.onNewMessage);
    this.on(WebSocketEvent.USER_ONLINE, chatChannelListener.onUserOnline);
    this.on(WebSocketEvent.USER_OFFLINE, chatChannelListener.onUserOffline);
    this.on(WebSocketEvent.USER_JOIN, chatChannelListener.onUserJoin);
    this.on(WebSocketEvent.USER_DEPARTURE, chatChannelListener.onUserDeparture);
  }
}