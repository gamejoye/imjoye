import router from '@ohos.router';
import { login, fetchUser } from '../api/httpApi';
import { AUTHENTICATION_TOKEN } from '../common/constants/appStorageKeys';
import { IUser } from '../common/types/User.type';
import promptAction from '@ohos.promptAction';
import { isSuccess } from '../common/utils/http';

@Entry
@Component
struct Login {
  @State email: string = '';
  @State password: string = '';

  handleOnLogin = async () => {
    if(this.email === '' || this.password === '') return;

    const loginRes = await login({ email: this.email, password: this.password });
    if(!isSuccess(loginRes.statusCode)) {
      promptAction.showToast({
        message: loginRes.message,
        duration: 1000,
      });
      return;
    }

    const { id, token } = loginRes.data;
    PersistentStorage.PersistProp<string>(AUTHENTICATION_TOKEN, token);
    const fetchRes = await fetchUser(id);
    if(!isSuccess(fetchRes.statusCode)) {
      promptAction.showToast({
        message: fetchRes.message,
        duration: 1000,
      });
      return;
    }
    AppStorage.SetOrCreate<IUser>('user', fetchRes.data);
    router.replaceUrl({
      url: 'pages/HomePage'
    }, (err) => {

    })
  }

  handleJumpToRegister = () => {
    router.pushUrl({
      url: 'pages/Register'
    }, (err) => {

    })
  }

  build() {
    Row() {
      Column() {
        Image($r('app.media.logo'))
          .width(200)
          .interpolation(ImageInterpolation.High)
          .borderRadius(50)
        TextInput({ placeholder: '输入你的邮箱' }).margin({ top: 20 })
          .onChange((value) => {
            this.email = value;
          })
        TextInput({ placeholder: '输入你的密码' }).type(InputType.Password).margin({ top: 20 })
          .onChange((value) => {
            this.password = value;
          })
        Button('登录').width(150).margin({ top: 20 }).onClick(this.handleOnLogin)
        Button('前往注册').width(150).margin({ top: 20 }).onClick(this.handleJumpToRegister)
      }.padding(20)
    }
    .width('100%')
  }
}