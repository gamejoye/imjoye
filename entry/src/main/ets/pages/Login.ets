import router from '@ohos.router';
import { login, fetchUser } from '../api/httpApi';
import { USER } from '../common/constants/appStorageKeys';
import { IUser } from '../common/types/User.type';
import promptAction from '@ohos.promptAction';
import { isSuccess } from '../common/utils/http';
import { AUTHENTICATION_TOKEN, USER_ID } from '../common/constants/userInforPreferences';
import { UserInfoPreferenceUtil } from '../common/utils/userInfoPreference';

@Entry
@Component
struct Login {
  @State email: string = '';
  @State password: string = '';
  @State status: 'idle' | 'loading' | 'fail' | 'success' = 'idle';
  handleOnLogin = async () => {
    if (this.email === '' || this.password === '') return;

    this.status = 'loading';
    const loginRes = await login({ email: this.email, password: this.password });
    if (!isSuccess(loginRes.statusCode)) {
      promptAction.showToast({
        message: loginRes.message,
        duration: 1000,
      });
      this.status = 'fail';
      return;
    }

    const { id, token } = loginRes.data;
    await UserInfoPreferenceUtil.storeUserInfo(getContext(), { [AUTHENTICATION_TOKEN]: token, [USER_ID]: id });

    const fetchRes = await fetchUser({ id });
    if (!isSuccess(fetchRes.statusCode)) {
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
      Column({ space: '20vp' }) {
        Image($r('app.media.logo'))
          .width($r('app.float.login_logo_size'))
          .height($r('app.float.login_logo_size'))
          .margin({
            bottom: $r('app.float.login_logo_margin_bottom'),
            top: $r('app.float.login_logo_margin_top')
          })
          .interpolation(ImageInterpolation.High)
          .borderRadius($r('app.float.login_logo_border_radius'))
        TextInput({ placeholder: '输入你的邮箱' })
          .height($r('app.float.login_input_height'))
          .onChange((value) => {
            this.email = value;
          })
        TextInput({ placeholder: '输入你的密码' }).type(InputType.Password)
          .height($r('app.float.login_input_height'))
          .onChange((value) => {
            this.password = value;
          })
        Button('登录')
          .width($r('app.float.login_button_width'))
          .enabled(this.status !== 'loading')
          .onClick(this.handleOnLogin)
        Text('前往登录')
          .fontColor($r('app.color.blue_text_color'))
          .fontSize($r('app.float.little_text_size'))
          .fontWeight(FontWeight.Medium)
          .onClick(this.handleJumpToRegister)
        if (this.status === 'loading') {
          LoadingProgress()
            .color($r('app.color.grey_loading_progress_color'))
            .height($r('app.float.loading_progress_size'))
            .height($r('app.float.loading_progress_size'))
        }
      }
      .padding($r('app.float.login_column_padding'))
    }
    .width('100%')
  }
}