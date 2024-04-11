import { fetchUser } from '../api/httpApi';
import { USER } from '../common/constants/appStorageKeys';
import { IUser } from '../common/types/User.type';
import { isSuccess } from '../common/utils/http';
import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { WebSocketService } from '../api/webSocketApi/service';
import router from '@ohos.router';
import { AUTHENTICATION_TOKEN, USER_ID } from '../common/constants/userInforPreferences';

@Entry
@Component
struct LoadingPage {
  webSocketService: WebSocketService = null;
  @State message: string = '正在加载数据.';
  intervalId: number;

  async aboutToAppear() {
    this.intervalId = setInterval(() => {
      const first = this.message.indexOf('.');
      if(this.message.length - first == 3) {
        this.message = this.message.substring(0, first + 1);
      } else {
        this.message = this.message + '.';
      }
    }, 1000);
    const preferences = await dataPreferences.getPreferences(getContext() as common.UIAbilityContext, 'userInfo');
    const hasAuthenticationToken = await preferences.has(AUTHENTICATION_TOKEN);
    const hasUserId = await preferences.has(USER_ID);

    if(!hasAuthenticationToken || !hasUserId) {
      router.replaceUrl({
        url: 'pages/Login',
      }, (err) => { });
      return;
    }
    const authenticationToken = await preferences.get(AUTHENTICATION_TOKEN, '') as string;
    const userId = await preferences.get(USER_ID, -1) as number;

    const { statusCode, data: user } = await fetchUser(userId);
    if(isSuccess(statusCode)) {
      this.webSocketService = new WebSocketService();
      this.webSocketService.start();
      AppStorage.SetOrCreate<IUser>(USER, user);
      router.replaceUrl({
        url: 'pages/HomePage',
      }, (err) => { });
    } else {
      router.replaceUrl({
        url: 'pages/Login',
      }, (err) => { });
    }
  }

  aboutToDisappear() {
    if(this.webSocketService !== null) {
      // TODO ws资源释放
    }
    clearInterval(this.intervalId);
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#80808080')
          .opacity(0.5)
      }
      .width('100%')
    }
    .height('100%')
  }
}