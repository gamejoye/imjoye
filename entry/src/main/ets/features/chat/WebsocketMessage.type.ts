import http from '@ohos.net.http';
import { WebSocketEvent } from '../../common/constants/websocketEvent';
import { IMessage } from '../../common/types/Message.type';
import { IUser } from '../../common/types/User.type';

export interface IBasicWebSocketMessage<S> {
  code: http.ResponseCode;
  event: WebSocketEvent;
  error: Error | null;
  payload: S;
}

export interface IChatWebSocketMessage extends IBasicWebSocketMessage<IMessage> { }
export interface IUserWebSocketMessage extends IBasicWebSocketMessage<IUser> { }