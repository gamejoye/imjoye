import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { fetchChatroomByFriendId } from '../api/httpApi/chatroom';
import { USER } from '../common/constants/appStorageKeys';
import { IFriendInfo } from '../common/types/FriendInfo.type';
import { IUser } from '../common/types/User.type';
import { isSuccess } from '../common/utils/http';
import { fetchFriendInfo } from '../api/httpApi/user';

@Entry
@Component
struct FriendInfoDetail {
  @StorageLink(USER) user: IUser = null;
  @State friendInfo: IFriendInfo = null;
  @State friendInfoStatus: 'idle' | 'loading' | 'fail' | 'success' = 'idle';
  private friendId: number = router.getParams()['friendId'];

  async aboutToAppear() {
    this.friendInfoStatus = 'loading';
    const { statusCode, data: friendInfo, message } = await fetchFriendInfo(this.user.id, this.friendId);
    if(!isSuccess(statusCode)) {
      promptAction.showToast({
        message,
        duration: 1000,
      });
      this.friendInfoStatus = 'fail';
      return;
    }
    this.friendInfoStatus = 'success';
    this.friendInfo = friendInfo;
  }

  async handleOnJumpToChatWindow() {
    const { statusCode, data: chatroom, message } = await fetchChatroomByFriendId({
      friendId: this.friendId,
    });
    if(!isSuccess(statusCode)) {
      promptAction.showToast({
        message,
        duration: 1000,
      });
      return;
    }
    router.pushUrl({
      url: 'pages/ChatWindow',
      params: {
        'chatroom': chatroom
      }
    })
  }

  build() {
    if(this.friendInfoStatus === 'idle' || this.friendInfoStatus === 'loading') {
      Row() {
        Column() {
          Text('正在加载数据...')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#80808080')
            .opacity(0.5)
        }
        .width('100%')
      }
      .height('100%')

    } else if(this.friendInfoStatus === 'fail') {
      Row() {
        Column() {
          Text('好友信息获取失败...')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
      }
      .height('100%')
    } else {
      Flex({ direction: FlexDirection.Column }) {
        Flex({ direction: FlexDirection.Row }) {
          Image(this.friendInfo.user.avatarUrl)
            .width(150)
            .height(150)
            .margin({ left: '10px', right: '10px' })
            .borderRadius(100)
            .flexShrink(0)

          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
            Text(this.friendInfo.user.username)
              .fontSize(24)
            Divider().strokeWidth(3)
            Text(`UID: ${this.friendInfo.user.id}`)
              .fontSize(16)
              .fontColor('#80808080')
            Divider().strokeWidth(3)
            Text(`邮箱: ${this.friendInfo.user.email}`)
              .fontSize(16)
              .fontColor('#80808080')
          }
        }
        .height(150)
        .margin({ bottom: 10 })

        Flex({ direction: FlexDirection.Row }) {
          Image(this.friendInfo.user.avatarUrl)
            .width(80)
            .height(80)
            .margin({ left: '10px', right: '10px' })
            .borderWidth(3)
            .borderColor('#aabbcc')
            .flexShrink(0)
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
            Text('Description')
            Divider().strokeWidth(3)
            Text(this.friendInfo.user.description)
              .maxLines(3);
          }
          .height(80)
          .borderWidth(3)
          .borderColor('#aabbcc')
        }
        .height(80)

        Flex()
          .flexGrow(1)

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Button({ type: ButtonType.Normal, stateEffect: true }) {
            Image($r('app.media.plus'))
              .width(60)
              .height(60)
          }
          .width(80)
          .height(80)
          .borderWidth(3)
          .borderColor('#aabbcc')
          .backgroundColor('#F1F3F5')

          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Image($r('app.media.email'))
              .width(80)
              .height(80)
          }
          .width(120)
          .height(120)
          .margin({ left: '10px', right: '10px' })
          .onClick(() => this.handleOnJumpToChatWindow())

          Button({ type: ButtonType.Normal, stateEffect: true }) {
            Image($r('app.media.setting'))
              .width(60)
              .height(60)
          }
          .width(80)
          .height(80)
          .borderWidth(3)
          .borderColor('#aabbcc')
          .backgroundColor('#F1F3F5')
        }
        .height(150)
      }
      .height('100%')
      .width('100%')
      .padding({ top: 5, bottom: 5, left: '6%', right: '6%' })
      .backgroundColor('#F1F3F5')
    }
  }
}
