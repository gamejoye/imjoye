import router from '@ohos.router';

@Entry
@Component
struct Register {

  handleOnRegister = () => {
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

          })
        TextInput({ placeholder: '你的密码' }).type(InputType.Password).margin({ top: 20 })
          .onChange((value) => {

          })
        TextInput({ placeholder: '再次验证你的密码' }).type(InputType.Password).margin({ top: 20 })
          .onChange((value) => {

          })
        Button('注册').width(150).margin({ top: 20 }).onClick(this.handleOnRegister)
        Button('前往登录').width(150).margin({ top: 20 }).onClick(this.handleJumpToLogin)
      }.padding(20)
    }
    .width('100%')
  }
}