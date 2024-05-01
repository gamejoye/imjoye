import WorkSchedulerExtensionAbility from '@ohos.WorkSchedulerExtensionAbility';
import workScheduler from '@ohos.resourceschedule.workScheduler';
import backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager';

export default class KeepLiveWorkSchedulerExtensionAbility extends WorkSchedulerExtensionAbility {
  onWorkStart(workInfo: workScheduler.WorkInfo) {
    console.log(`onWorkStart, workInfo = ${JSON.stringify(workInfo)}`);
  }

  // 延迟任务结束回调
  onWorkStop(workInfo: workScheduler.WorkInfo) {
    console.log(`onWorkStop, workInfo is ${JSON.stringify(workInfo)}`);
  }
}