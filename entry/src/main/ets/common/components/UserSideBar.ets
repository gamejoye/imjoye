import router from '@ohos.router';
import { USER } from '../constants/appStorageKeys';
import { IUser } from '../types/User.type';
import { UserInfoPreferenceUtil } from '../utils/userInfoPreference';

@Component
export struct UserSideBar {
  @Link show: boolean;
  @BuilderParam customContent: () => void;
  @StorageLink(USER) user: IUser = null;

  dialogController: CustomDialogController = new CustomDialogController({
    builder: ConfirmUserLogout({}),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })

  closeUserSideBar() {
    animateTo(({ duration: 1000, curve: Curve.Ease }), () => {
      this.show = false;
    })
  }

  build() {
    SideBarContainer(SideBarContainerType.Overlay) {
      // 侧边栏内容
      Column({ space: 12 }) {
        Row() {
          Text('用户信息')
            .fontSize($r('app.float.normal_text_size'))
          Image($r('app.media.close'))
            .height('100%')
            .onClick(() => this.closeUserSideBar())
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height($r('app.float.user_side_bar_header_height'))

        Row({ space: 6 }) {
          Image(this.user.avatarUrl)
            .height($r('app.float.user_side_bar_avatar_size'))
            .width($r('app.float.user_side_bar_avatar_size'))
            .borderRadius($r('app.float.user_side_bar_avatar_border_radius'))
          Column({ space: 6}) {
            Text(this.user.username)
              .width('100%')
              .fontSize($r('app.float.big_text_size'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Text(this.user.email)
              .width('100%')
              .fontColor($r('app.color.grey_text_color'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
        }
        .width('100%')

        Divider()
          .strokeWidth('2vp')
        Column({ space: 6 }) {
          Text('个性签名')
            .fontSize($r('app.float.big_text_size'))

          Text(this.user.description)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(5)
            .fontSize($r('app.float.small_text_size'))
            .padding($r('app.float.user_side_bar_description_horizontal_padding'))
            .width('100%')
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        Blank()
        Button({ type: ButtonType.Normal }) {
          Text('退出登录')
            .fontSize($r('app.float.big_text_size'))
        }
        .width($r('app.float.user_side_bar_logout_button_width'))
        .padding($r('app.float.user_side_bar_logout_button_padding'))
        .borderRadius($r('app.float.normal_button_border_radius'))
        .onClick(() => {
          this.dialogController.open();
        })
      }
      .height('100%')
      .width('100%')
      .border({
        width: $r('app.float.normal_border_width'),
        color: $r('app.color.grey_border')
      })
      .padding({
        top: $r('app.float.user_side_bar_top_padding'),
        bottom: $r('app.float.user_side_bar_bottom_padding'),
        left: $r('app.float.user_side_bar_horizontal_padding'),
        right: $r('app.float.user_side_bar_horizontal_padding'),
      })
      .backgroundColor($r('app.color.user_side_bar_container_background_color'))
      this.customContent()
    }
    .showSideBar(this.show)
    .showControlButton(false)
    .sideBarWidth('100%')
    .width('100%')
    .height('100%')
  }
}

@CustomDialog
struct ConfirmUserLogout {
  controller: CustomDialogController
  build() {
    Column({ space: 6 }) {
      Text('确定退出吗？')
        .fontSize(24)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Text('确定')
          .fontColor(Color.Red)
          .fontSize(16)
          .padding(10)
          .onClick(async () => {
            await UserInfoPreferenceUtil.deleteUserInfo(getContext());
            this.controller.close();
            router.clear();
            router.replaceUrl({
              url: 'pages/LoadingPage'
            }, (err) => {});
          })

        Text('取消')
          .fontColor(Color.Black)
          .fontSize(16)
          .padding(10)
          .onClick(() => {
            this.controller.close();
          })
      }
      .margin({ bottom: 10 })
    }
    .padding({ top: 6, bottom: 6 })
  }
}
