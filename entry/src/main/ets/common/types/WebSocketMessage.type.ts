import { WebSocketEvent } from '../constants/websocketEvent';

export interface IWebSocketMessage<T> {
  event: WebSocketEvent;
  payload: T;
};