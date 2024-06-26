import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { register } from '../api/httpApi/auth';
import { isSuccess } from '../common/utils/http';
import { GalleryUtil } from '../common/utils/galleryUtil';
import PermissionRequester from '../permissions/PermissionRequester';
import { uploadAvatar } from '../api/httpApi/file';
import picker from '@ohos.file.picker';

@Entry
@Component
struct Register {
  @State username: string = '';
  @State email: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State avatarUrl: string = '';
  @State internalAvatarUrl: string = '';
  @State status: 'idle' | 'loading' | 'fail' | 'success' = 'idle';
  @State uploadedSize: number = 0;
  @State totalSize: number = 0;

  handleOnRegister = async () => {
    if(this.password !== this.confirmPassword) {
      promptAction.showToast({
        message: '两次密码输入不一致',
        duration: 1000,
      });
      return;
    }

    if([this.username, this.email, this.password, this.confirmPassword, this.avatarUrl].some((val) => val === '')) {
      promptAction.showToast({
        message: '信息填写不完整',
        duration: 1000,
      });
      return;
    }

    this.status = 'loading';
    const avatarResponse = await uploadAvatar(this.internalAvatarUrl,
      {
        onProgress: (uploadedSize, totalSize) => {
          this.uploadedSize = uploadedSize;
          this.totalSize = totalSize;
        }
      }
    );
    if(!isSuccess(avatarResponse.statusCode)) {
      promptAction.showToast({
        message: avatarResponse.message,
        duration: 1000,
      });
      this.status = 'fail';
      return;
    }
    const avatar = avatarResponse.data;

    const { statusCode, message } = await register({
      username: this.username,
      email: this.email,
      password: this.password,
      avatarUrl: avatar,
    });
    if(!isSuccess(statusCode)) {
      promptAction.showToast({
        message,
        duration: 1000,
      });
      this.status = 'fail';
      return;
    }

    promptAction.showToast(({
      message: '用户注册成功',
      duration: 1000,
    }))
    this.status = 'success';
    router.back({
      url: 'pages/Login'
    })
  }

  handleJumpToLogin = () => {
    if (this.status === 'loading') return;
    router.back({
      url: 'pages/Login'
    })
  }

  handleOnOpenGallery = async () => {
    const accept = await PermissionRequester.requestMediaPermission();
    if (accept) {
      const { dataShare, internalCache } = await new GalleryUtil(
        getContext(),
        new picker.PhotoViewPicker()
      ).openGallery();
      if (dataShare.length > 0) {
        this.avatarUrl = dataShare[0];
        this.internalAvatarUrl = internalCache[0];
      } else {
        promptAction.showToast({
          message: '选取图片失败',
          duration: 1000,
        });
      }
    } else {
      promptAction.showToast({
        message: '获取访问相册权限失败',
        duration: 1000,
      });
    }
  }

  build() {
    Row() {
      Column({ space: 20 }) {
        Image(this.avatarUrl ? this.avatarUrl : $r('app.media.plus'))
          .height($r('app.float.register_avatar_size'))
          .height($r('app.float.register_avatar_size'))
          .border({ width: 1 })
          .objectFit(ImageFit.Cover)
          .borderRadius($r('app.float.register_avatar_border_radius'))
          .onClick(() => this.handleOnOpenGallery())

        TextInput({ placeholder: '你的邮箱' })
          .height($r('app.float.register_input_height'))
          .onChange((value) => {
            this.email = value;
          })
        TextInput({ placeholder: '你的用户名' })
          .height($r('app.float.register_input_height'))
          .onChange((value) => {
            this.username = value;
          })
        TextInput({ placeholder: '你的密码' }).type(InputType.Password)
          .height($r('app.float.register_input_height'))
          .onChange((value) => {
            this.password = value;
          })
        TextInput({ placeholder: '再次验证你的密码' }).type(InputType.Password)
          .height($r('app.float.register_input_height'))
          .onChange((value) => {
            this.confirmPassword = value;
          })
        Button('注册')
          .width($r('app.float.register_button_width'))
          .enabled(this.status !== 'loading')
          .onClick(this.handleOnRegister)
        Text('前往登录')
          .fontColor($r('app.color.blue_text_color'))
          .fontSize($r('app.float.little_text_size'))
          .fontWeight(FontWeight.Medium)
          .onClick(this.handleJumpToLogin)
        if (this.status === 'loading') {
          Progress({value: this.uploadedSize, total: this.totalSize})
          LoadingProgress()
            .color($r('app.color.grey_loading_progress_color'))
            .height($r('app.float.loading_progress_size'))
            .height($r('app.float.loading_progress_size'))
        }
      }
      .padding($r('app.float.register_column_padding'))
    }
    .width('100%')
  }
}