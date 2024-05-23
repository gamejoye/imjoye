import { fetchUser } from '../api/httpApi';
import { USER } from '../common/constants/appStorageKeys';
import { IUser } from '../common/types/User.type';
import { isSuccess } from '../common/utils/http';
import router from '@ohos.router';
import { AUTHENTICATION_TOKEN, USER_ID } from '../common/constants/userInforPreferences';
import { UserInfoPreferenceUtil } from '../common/utils/userInfoPreference';

@Entry
@Component
struct LoadingPage {
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
    const userInfo = await UserInfoPreferenceUtil.getUserInfo(getContext());

    const token = userInfo[AUTHENTICATION_TOKEN];
    const userId = userInfo[USER_ID];
    if(!token || userId === -1) {
      router.replaceUrl({
        url: 'pages/Login',
      }, (err) => { });
      return;
    }

    const { statusCode, data: user } = await fetchUser({
      id: userId,
    });
    if(isSuccess(statusCode)) {
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
    clearInterval(this.intervalId);
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.big_text_size'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.grey_text_color'))
      }
      .width('100%')
    }
    .height('100%')
  }
}