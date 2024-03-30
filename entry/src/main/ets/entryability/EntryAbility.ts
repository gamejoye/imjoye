import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import webSocket from '@ohos.net.webSocket';
import { CHAT_CHANNELS } from '../common/constants/appStorageKeys';
import { ChatChannel, IChatChannelState } from '../features/chat/ChatChannel';

export default class EntryAbility extends UIAbility {
  ws: webSocket.WebSocket = null;

  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    /**
     * 设置全局ChatChannels对象
     * TODO 把ChatChannels.state存在本地磁盘
     */
    AppStorage.SetOrCreate<Record<string, ChatChannel>>(CHAT_CHANNELS, {});

    // TODO 在应用一启动就监听websocket
    // const defaultIpAddress = "wss://echo.websocket.org/";
    // this.ws = webSocket.createWebSocket();
    // this.ws.on('open', (err, value) => {
    //   console.log("on open, status:" + JSON.stringify(value));
    // });
    //
    // this.ws.on('message', (err, value) => {
    //   if(typeof value !== 'string') {
    //     value = String.fromCharCode.apply(null, new Uint16Array(value));
    //   }
    //   try {
    //     const result: unknown = JSON.parse(value as string);
    //     // 调用ChatChannel.dispatch
    //
    //   } catch (e) {
    //
    //   }
    // });
    //
    // this.ws.on('error', (err) => {
    //   console.log("on error, error:" + JSON.stringify(err));
    // });
    //
    // this.ws.connect(defaultIpAddress, (err, value) => {
    //   if (!err) {
    //     console.log("Connected successfully");
    //   } else {
    //     console.log("Connection failed. Err:" + JSON.stringify(err));
    //   }
    // });
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    if(this.ws) {
      this.ws.on('close', (err, value) => {
        console.log("on close, code is " + value.code + ", reason is " + value.reason);
      });
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability

    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Login', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
