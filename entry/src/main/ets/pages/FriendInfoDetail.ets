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
            .fontSize($r('app.float.big_text_size'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.grey_text_color'))
        }
        .width('100%')
      }
      .height('100%')

    } else if (this.friendInfoStatus === 'fail') {
      Row() {
        Column() {
          Text('好友信息获取失败...')
            .fontSize($r('app.float.big_text_size'))
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
      }
      .height('100%')
    } else {
      Flex({ direction: FlexDirection.Column }) {
        Flex({ direction: FlexDirection.Row }) {
          Image(this.friendInfo.user.avatarUrl)
            .width($r('app.float.friend_info_detail_avatar_size'))
            .height($r('app.float.friend_info_detail_avatar_size'))
            .margin({
              left: $r('app.float.friend_info_detail_avatar_horizontal_margin'),
              right: $r('app.float.friend_info_detail_avatar_horizontal_margin')
            })
            .borderRadius($r('app.float.friend_info_detail_avatar_border_radius'))
            .flexShrink(0)

          Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.Center,
          }) {
            Text(this.friendInfo.user.username)
              .fontSize($r('app.float.big_text_size'))
            Divider()
            Text(`UID: ${this.friendInfo.user.id}`)
              .fontSize($r('app.float.normal_text_size'))
              .fontColor($r('app.color.grey_text_color'))
            Divider()
            Text(`邮箱: ${this.friendInfo.user.email}`)
              .fontSize($r('app.float.normal_text_size'))
              .fontColor($r('app.color.grey_text_color'))
          }
        }
        .height($r('app.float.friend_info_detail_header_height'))
        .margin({
          top: $r('app.float.friend_info_detail_flex_vertical_margin'),
          bottom: $r('app.float.friend_info_detail_flex_vertical_margin')
        })

        Flex({ alignItems: ItemAlign.Center }) {
          Text(this.friendInfo.user.description)
            .fontSize($r('app.float.normal_text_size'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .flexGrow(1)
          Image($r('app.media.next'))
            .width('28vp')
            .height('28vp')
        }
        .height($r('app.float.friend_info_detail_item_height'))
        .padding({
          top: $r('app.float.friend_info_detail_item_vertical_padding'),
          bottom: $r('app.float.friend_info_detail_item_vertical_padding'),
          left: $r('app.float.friend_info_detail_item_horizontal_padding'),
          right: $r('app.float.friend_info_detail_item_horizontal_padding')
        })
        Divider()

        Flex()
          .flexGrow(1)

        Flex({
          direction: FlexDirection.Row,
          justifyContent: FlexAlign.SpaceAround,
          alignItems: ItemAlign.Center
        }) {
          Button({ type: ButtonType.Normal }) {
            Text('设置')
              .fontSize($r('app.float.big_text_size'))
          }
          .width($r('app.float.friend_info_detail_send_message_button_width'))
          .padding($r('app.float.friend_info_detail_send_message_button_padding'))
          .borderRadius($r('app.float.normal_button_border_radius'))
          .backgroundColor($r('app.color.container_item_background_color'))
          .border({
            width: $r('app.float.normal_border_width'),
            color: $r('app.color.grey_border')
          })

          Button({ type: ButtonType.Normal }) {
            Text('发送消息')
              .fontSize($r('app.float.big_text_size'))
          }
          .width($r('app.float.friend_info_detail_send_message_button_width'))
          .padding($r('app.float.friend_info_detail_send_message_button_padding'))
          .borderRadius($r('app.float.normal_button_border_radius'))
          .onClick(() => this.handleOnJumpToChatWindow())
        }
        .height($r('app.float.friend_info_detail_footer_height'))
        .padding({
          top: $r('app.float.friend_info_detail_footer_vertical_padding'),
          bottom: $r('app.float.friend_info_detail_footer_vertical_padding'),
          left: $r('app.float.friend_info_detail_footer_horizontal_padding'),
          right: $r('app.float.friend_info_detail_footer_horizontal_padding')
        })
      }
      .height('100%')
      .width('100%')
      .padding({
        top: $r('app.float.friend_info_detail_vertical_padding'),
        bottom: $r('app.float.friend_info_detail_vertical_padding'),
        left: $r('app.float.friend_info_detail_horizontal_padding'),
        right: $r('app.float.friend_info_detail_horizontal_padding'),
      })
      .backgroundColor($r('app.color.container_background_color'))
    }
  }
}
