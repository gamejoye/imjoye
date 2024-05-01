import webSocket from '@ohos.net.webSocket';
import { IMessage } from '../../../common/types/Message.type';

export interface IWebsocketHandler {
  handleOnOpen(ws: webSocket.WebSocket): Promise<void>;
  handleOnMessageAck(ws: webSocket.WebSocket, message: IMessage): Promise<void>;
  handleOnMessageNotifySyn(ws: webSocket.WebSocket, message: IMessage): Promise<void>;
  handleOnPong(ws: webSocket.WebSocket): Promise<void>;
  handleOnClose(ws: webSocket.WebSocket): Promise<void>;
  handleOnError(ws: webSocket.WebSocket, error: Error): Promise<void>;
}
