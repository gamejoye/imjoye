import webSocket from '@ohos.net.webSocket';
import emitter from '@ohos.events.emitter';
import { WebSocketEvent } from '../../common/constants/websocketEvent';
import { IMessage } from '../../common/types/Message.type';
import { IWebSocketMessage } from '../../common/types/WebSocketMessage.type';
import { AUTHORIZATION } from '../../common/constants/websocketHeaders';
import { getUserInfo } from '../../common/utils/userInfoPreference';
import { AUTHENTICATION_TOKEN } from '../../common/constants/userInforPreferences';
import { EmitterEvent } from '../../common/constants/emitterEvent';
import { IEmitterMessage } from '../../common/types/EmitterMessage.type';

export class WebSocketService {
  ws: webSocket.WebSocket;

  constructor() {
    this.ws = null;
  }

   async start() {
    this.ws = webSocket.createWebSocket();
    const target : SubscribedAbstractProperty<string> = AppStorage.Prop('webSocketUrl');
    this.ws.on('open', (err, value) => {
      console.log("on open, status:" + JSON.stringify(value));
    });

    this.ws.on('message', async (err, value) => {
      if(typeof value !== 'string') {
        value = String.fromCharCode.apply(null, new Uint16Array(value));
      }
      const result: IWebSocketMessage<unknown> = JSON.parse(value as string);
      switch (result.event) {
        case WebSocketEvent.MESSAGE_ACK: {
          const message = result.payload as IMessage;
          const emitterData: IEmitterMessage = {
            plainText: JSON.stringify(message)
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

          // TODO auto retry
          this.ws.send(JSON.stringify(messageAckSyn));
          break;
        }
        case WebSocketEvent.MESSAGE_NOTIFY_SYN: {
          const message = result.payload as IMessage;
          const emitterData: IEmitterMessage = {
            plainText: JSON.stringify(message),
          };
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
          this.ws.send(JSON.stringify(notifyAck));
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

    const userInfo = await getUserInfo();
    this.ws.connect(
      target.get(),
      {
        header:
        {
          [AUTHORIZATION]: userInfo[AUTHENTICATION_TOKEN],
        }
      },
      (err, value) => {
        if (!err) {
          console.log("Connected successfully");
        } else {
          console.log("Connection failed. Err:" + JSON.stringify(err));
        }
    });
  }

  stop() {
    this.ws.close();
  }
}