import webSocket from '@ohos.net.webSocket';
import emitter from '@ohos.events.emitter';
import { WebSocketEvent } from '../../common/constants/websocketEvent';
import { IMessage } from '../../common/types/Message.type';
import { IWebSocketMessage } from '../../common/types/WebSocketMessage.type';

export class WebSocketService {
  ws: webSocket.WebSocket;

  constructor() {
    this.ws = null;
  }

  start() {
    this.ws = webSocket.createWebSocket();
    const target : SubscribedAbstractProperty<string> = AppStorage.Prop('webSocketUrl');
    this.ws.on('open', (err, value) => {
      console.log("on open, status:" + JSON.stringify(value));
    });

    this.ws.on('message', (err, value) => {
      if(typeof value !== 'string') {
        value = String.fromCharCode.apply(null, new Uint16Array(value));
      }
      const result: IWebSocketMessage<unknown> = JSON.parse(value as string);
      switch (result.event) {
        case WebSocketEvent.NEW_MESSAGE: {
          const message = result.payload as IMessage;
          emitter.emit({
            eventId: WebSocketEvent.NEW_MESSAGE,
          }, {
            data: {
              plainText: JSON.stringify(message)
            },
          });
          break;
        }
        default: {
          break;
        }
      }
    });

    this.ws.on('error', (err) => {
      console.log("on error, error:" + JSON.stringify(err));
    });

    this.ws.connect(target.get(), (err, value) => {
      if (!err) {
        console.log("Connected successfully");
      } else {
        console.log("Connection failed. Err:" + JSON.stringify(err));
      }
    });
  }
}