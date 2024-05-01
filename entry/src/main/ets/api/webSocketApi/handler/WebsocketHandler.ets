import emitter from '@ohos.events.emitter';
import webSocket from '@ohos.net.webSocket';
import { EmitterEvent } from '../../../common/constants/emitterEvent';
import { WebSocketEvent } from '../../../common/constants/websocketEvent';
import { IEmitterMessage } from '../../../common/types/EmitterMessage.type';
import { IMessage } from '../../../common/types/Message.type';
import { IWebSocketMessage } from '../../../common/types/WebSocketMessage.type';
import { MessageNotificationManager } from '../../../notification';
import { IWebsocketHandler } from './WebsocketHandler.interface';

export class WebsocketHandler implements IWebsocketHandler {
  intervalId: number;
  timeoutIds: Array<number>;
  interval = 500;

  async handleOnOpen(ws: webSocket.WebSocket): Promise<void> {
    console.log("handleOnOpen");
    this.timeoutIds = [];

    this.intervalId = setInterval(() => {
      const ping: IWebSocketMessage<string> = {
        event: WebSocketEvent.PING,
        payload: 'ping',
      };
      const currentTime = new Date().getTime();
      const timeoutId = setTimeout(() => {
        // TODO auto reconnect
      }, currentTime + this.interval);
      this.timeoutIds.push(timeoutId);
      ws.send(JSON.stringify(ping));
    }, this.interval);
  }

  async handleOnError(ws: webSocket.WebSocket, error: Error): Promise<void> {
    console.log("handleOpError", JSON.stringify(error));
    clearInterval(this.intervalId);
  }

  async handleOnClose(ws: webSocket.WebSocket): Promise<void> {
    console.log("handleOpClose");
    clearInterval(this.intervalId);
  }

  async handleOnPong(ws: webSocket.WebSocket): Promise<void> {
    console.log("************** 接收到PONG事件 **************");
    this.timeoutIds.forEach((timeoutId) => {
      clearTimeout(timeoutId);
    });
    this.timeoutIds = [];
    const timeoutId = setTimeout(() => {
      // TODO auto reconnect
    }, this.interval);
    this.timeoutIds.push(timeoutId);
  }

  async handleOnMessageAck(ws: webSocket.WebSocket, message: IMessage): Promise<void> {
    const emitterData: IEmitterMessage = {
      plainText: JSON.stringify(message),
    };
    emitter.emit({
      eventId: EmitterEvent.NEW_MESSAGE,
    }, {
      data: emitterData,
    });

    const messageAckSyn: IWebSocketMessage<IMessage> = {
      event: WebSocketEvent.MESSAGE_ACK_SYN,
      payload: message,
    };
    ws.send(JSON.stringify(messageAckSyn));
  }

  async handleOnMessageNotifySyn(ws: webSocket.WebSocket, message: IMessage): Promise<void> {
    console.log("handleOnMessageAck PUBLISH PENDING");
    await MessageNotificationManager.publish(message);
    console.log("handleOnMessageAck PUBLISH DONE");
    const emitterData: IEmitterMessage = {
      plainText: JSON.stringify(message),
    };
    console.log('**********************', JSON.stringify(message));
    emitter.emit({
      eventId: EmitterEvent.NEW_MESSAGE,
    }, {
      data: emitterData,
    });

    const notifyAck: IWebSocketMessage<IMessage> = {
      event: WebSocketEvent.MESSAGE_NOTIFY_ACK,
      payload: message,
    };

    // TODO auto retry
    ws.send(JSON.stringify(notifyAck));
  }
}
