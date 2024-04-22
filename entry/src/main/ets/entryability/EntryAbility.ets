import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import RdbHelper from '../common/database/rdb/RdbHelper';

export default class EntryAbility extends UIAbility {

  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    /**
     * TODO 环境变量初始化
     */
    Environment.EnvProp('apiUrl', 'http://192.168.43.71:8080/');
    Environment.EnvProp('webSocketUrl', 'ws://192.168.43.71:5173/');

    RdbHelper.initRdb(this.context);
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/LoadingPage', (err, data) => {
      if(err) {
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
