import router from '@ohos.router';
import { login, fetchUser } from '../api/httpApi';
import { USER } from '../common/constants/appStorageKeys';
import { IUser } from '../common/types/User.type';
import promptAction from '@ohos.promptAction';
import { isSuccess } from '../common/utils/http';
import { AUTHENTICATION_TOKEN, USER_ID } from '../common/constants/userInforPreferences';
import { storeUserInfo } from '../common/utils/userInfoPreference';

@Entry
@Component
struct Login {
  @State email: string = '';
  @State password: string = '';
  @State status: 'idle' | 'loading' | 'fail' | 'success' = 'idle';

  handleOnLogin = async () => {
    if(this.email === '' || this.password === '') return;

    this.status = 'loading';
    const loginRes = await login({ email: this.email, password: this.password });
    if(!isSuccess(loginRes.statusCode)) {
      promptAction.showToast({
        message: loginRes.message,
        duration: 1000,
      });
      this.status = 'fail';
      return;
    }

    const { id, token } = loginRes.data;
    await storeUserInfo({ [AUTHENTICATION_TOKEN]: token, [USER_ID]: id });

    const fetchRes = await fetchUser(id);
    if(!isSuccess(fetchRes.statusCode)) {
      promptAction.showToast({
        message: fetchRes.message,
        duration: 1000,
      });
      this.status = 'fail';
      return;
    }
    AppStorage.SetOrCreate<IUser>(USER, fetchRes.data);
    this.status = 'success';
    router.replaceUrl({
      url: 'pages/HomePage'
    }, (err) => {

    })
  }

  handleJumpToRegister = () => {
    if (this.status === 'loading') return;
    router.pushUrl({
      url: 'pages/Register'
    }, (err) => {

    })
  }

  build() {
    Row() {
      Column({ space: 20 }) {
        Image($r('app.media.logo'))
          .width(150)
          .interpolation(ImageInterpolation.High)
          .borderRadius(50)
          .margin({ bottom: 40 })
        TextInput({ placeholder: '输入你的邮箱' })
          .height(45)
          .onChange((value) => {
            this.email = value;
          })
        TextInput({ placeholder: '输入你的密码' }).type(InputType.Password)
          .height(45)
          .onChange((value) => {
            this.password = value;
          })
        Button('登录')
          .width(150)
          .enabled(this.status !== 'loading')
          .onClick(this.handleOnLogin)
        Text('前往登录')
          .fontColor('#007DFF')
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .onClick(this.handleJumpToRegister)
        if (this.status === 'loading') {
          LoadingProgress()
            .color(Color.Grey)
            .height(30)
            .width(30)
        }
      }
      .padding(20)
    }
    .width('100%')
  }
}