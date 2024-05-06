import webSocket from '@ohos.net.webSocket';
import { WebSocketEvent } from '../../common/constants/websocketEvent';
import { IMessage } from '../../common/types/Message.type';
import { IWebSocketMessage } from '../../common/types/WebSocketMessage.type';
import { AUTHORIZATION } from '../../common/constants/websocketHeaders';
import { UserInfoPreferenceUtil } from '../../common/utils/userInfoPreference';
import { AUTHENTICATION_TOKEN } from '../../common/constants/userInforPreferences';
import { IWebsocketHandler } from './handler/WebsocketHandler.interface';

export class WebSocketService {
  ws: webSocket.WebSocket;
  websocketHandler: IWebsocketHandler;

  constructor(websocketHandler: IWebsocketHandler) {
    this.websocketHandler = websocketHandler;
    this.ws = webSocket.createWebSocket();
  }

  async start() {
    const target: SubscribedAbstractProperty<string> = AppStorage.Prop('webSocketUrl');

    this.ws.on('open', (err, value) => {
      console.log('********* open', JSON.stringify(err), JSON.stringify(value));
      this.websocketHandler.handleOnOpen(this.ws);
    });

    this.ws.on('close', (err, value) => {
      console.log('********* close', JSON.stringify(err), JSON.stringify(value));
      this.websocketHandler.handleOnClose(this.ws);
    })

    this.ws.on('message', async (err, value) => {
      if (typeof value !== 'string') {
        value = String.fromCharCode.apply(null, new Uint16Array(value));
      }
      const result: IWebSocketMessage<unknown> = JSON.parse(value as string);
      switch (result.event) {
        case WebSocketEvent.MESSAGE_ACK: {
          const message = result.payload as IMessage;
          this.websocketHandler.handleOnMessageAck(this.ws, message);
          break;
        }
        case WebSocketEvent.MESSAGE_NOTIFY_SYN: {
          const message = result.payload as IMessage;
          this.websocketHandler.handleOnMessageNotifySyn(this.ws, message);
          break;
        }
        case WebSocketEvent.PING: {
          this.websocketHandler.handleOnPong(this.ws);
          break;
        }
        default: {
          break;
        }
      }
    });

    this.ws.on('error', (err) => {
      this.websocketHandler.handleOnError(this.ws, err);
    });

    const userInfo = await UserInfoPreferenceUtil.getUserInfo(getContext());
    this.ws.connect(
      target.get(),
      {
        header: { [AUTHORIZATION]: userInfo[AUTHENTICATION_TOKEN] }
      },
      (err, value) => {
        if (!err) {
          console.log("Connected successfully");
        } else {
          console.log("Connection failed. Err:" + JSON.stringify(err));
        }
      }
    );
  }

  stop() {
    console.log('STOP STOP STOP STOP ************* ');
    this.ws.close();
  }
}