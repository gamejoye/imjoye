import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import RdbHelper from '../common/database/rdb/RdbHelper';
import router from '@ohos.router';
import ConfigUtil from '../common/utils/configUtil';

export default class EntryAbility extends UIAbility {
  async onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    console.log("want: ", JSON.stringify(want), JSON.stringify(launchParam));

    const configUtil = new ConfigUtil(this.context);
    const config = await configUtil.getConfig();
    configUtil.loadEnvironment(config);

    await RdbHelper.initRdb(this.context);
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onNewWant(want) {
    const chatroom = want.parameters?.chatroom;
    if (chatroom) {
      /**
       * MessageNotification 触发onNewWant
       */
      const state = router.getState();
      if (state.name === 'ChatWindow') {
        router.replaceUrl({
          url: 'pages/ChatWindow',
          params: {
            'chatroom': chatroom
          }
        });
      } else {
        router.pushUrl({
          url: 'pages/ChatWindow',
          params: {
            'chatroom': chatroom
          }
        }, router.RouterMode.Single);
      }
    }
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/LoadingPage', (err, data) => {
      if (err) {
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate err', JSON.stringify(err));
      }
      hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate success', JSON.stringify(data));
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
