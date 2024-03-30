import router from '@ohos.router';
import { IUser } from '../common/types/User.type';
import { mockUser_gamejoye } from '../mock/mockUsers';

@Entry
@Component
struct Login {

  handleOnLogin = () => {
    AppStorage.SetOrCreate<IUser>('user', mockUser_gamejoye);
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

          })
        TextInput({ placeholder: '输入你的密码' }).type(InputType.Password).margin({ top: 20 })
          .onChange((value) => {

          })
        Button('登录').width(150).margin({ top: 20 }).onClick(this.handleOnLogin)
        Button('前往注册').width(150).margin({ top: 20 }).onClick(this.handleJumpToRegister)
      }.padding(20)
    }
    .width('100%')
  }
}