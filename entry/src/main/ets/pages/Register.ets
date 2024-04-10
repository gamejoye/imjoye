import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { register } from '../api/httpApi/auth';
import { isSuccess } from '../common/utils/http';

@Entry
@Component
struct Register {
  @State username: string = '';
  @State email: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';

  handleOnRegister = async () => {
    if(this.password !== this.confirmPassword) {
      promptAction.showToast({
        message: '两次密码输入不一致',
        duration: 1000,
      });
      return;
    }

    if([this.username, this.email, this.password, this.confirmPassword].some((val) => val === '')) {
      promptAction.showToast({
        message: '信息填写不完整',
        duration: 1000,
      });
      return;
    }

    const { statusCode, message } = await register({
      username: this.username,
      email: this.email,
      password: this.password,
      avatarUrl: '',
    });
    if(!isSuccess(statusCode)) {
      promptAction.showToast({
        message,
        duration: 1000,
      });
      return;
    }

    promptAction.showToast(({
      message: '用户注册成功',
      duration: 1000,
    }))
    router.back({
      url: 'pages/Login'
    })
  }

  handleJumpToLogin = () => {
    router.back({
      url: 'pages/Login'
    })
  }

  build() {
    Row() {
      Column() {
        Image($r('app.media.logo'))
          .width(200)
          .interpolation(ImageInterpolation.High)
          .borderRadius(50)
        TextInput({ placeholder: '你的邮箱' }).margin({ top: 20 })
          .onChange((value) => {
            this.email = value;
          })
        TextInput({ placeholder: '你的用户名' }).margin({ top: 20 })
          .onChange((value) => {
            this.username = value;
          })
        TextInput({ placeholder: '你的密码' }).type(InputType.Password).margin({ top: 20 })
          .onChange((value) => {
            this.password = value;
          })
        TextInput({ placeholder: '再次验证你的密码' }).type(InputType.Password).margin({ top: 20 })
          .onChange((value) => {
            this.confirmPassword = value;
          })
        Button('注册').width(150).margin({ top: 20 }).onClick(this.handleOnRegister)
        Button('前往登录').width(150).margin({ top: 20 }).onClick(this.handleJumpToLogin)
      }.padding(20)
    }
    .width('100%')
  }
}