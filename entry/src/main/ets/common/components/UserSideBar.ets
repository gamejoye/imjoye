import router from '@ohos.router';
import { USER } from '../constants/appStorageKeys';
import { IUser } from '../types/User.type';
import { deleteUserInfo } from '../utils/userInfoPreference';

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
          Image($r('app.media.close'))
            .onClick(() => this.closeUserSideBar())
            .height(30)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height(30)

        Row({ space: 6 }) {
          Image(this.user.avatarUrl)
            .height(60)
            .width(60)
            .borderRadius(50)
          Column({ space: 6}) {
            Text(this.user.username)
              .width('100%')
              .fontSize(24)
              .maxLines(1)
            Text(this.user.email)
              .width('100%')
              .fontColor('#80808080')
              .maxLines(1)
          }
        }
        .width('100%')

        Divider().strokeWidth(4)
        Column({ space: 6 }) {
          Text('个性签名')
            .fontSize(24)

          Text(this.user.description)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(5)
            .fontSize(12)
            .padding(10)
            .width('100%')

        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        Divider().strokeWidth(4)
        Button({ type: ButtonType.Normal }) {
          Text('退出登录')
            .fontSize(24)
        }
        .width('100%')
        .padding(10)
        .onClick(() => {
          this.dialogController.open();
        })
      }
      .height('100%')
      .width('100%')
      .padding({ top: 5, bottom: 5, left: '6%', right: '6%' })
      .backgroundColor('#aabbcc')
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
            await deleteUserInfo();
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
