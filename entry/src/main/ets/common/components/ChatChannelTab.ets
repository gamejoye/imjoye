import { IUser } from '../types/User.type';
import { IChatChannel } from '../types/ChatChannel.type';
import router from '@ohos.router';

@Component
export struct ChatChannelTab {
  @StorageLink('user') user: IUser = null;
  @Link chatChannels: IChatChannel[];
  @Link show: boolean;

  @Builder UserStatusBuilder(status: 'online', user: IUser) {
    Column({ space: 6 }) {
      Text(user.username)
        .width('100%')
        .height('50%')
        .fontSize($r('app.float.normal_text_size'))
      Row({ space: 6}) {
        Circle({
          width: 10,
          height: 10
        })
          .fill($r('app.color.green_user_status_color'))
        Text('在线')
          .fontSize($r('app.float.normal_text_size'))
      }
      .width('100%')
      .height('50%')
    }
  }

  handleOnJumpChatRoom(chatChannel: IChatChannel) {
    router.pushUrl({
      url: 'pages/ChatWindow',
      params: {
        'chatroom': chatChannel.chatroom
      }
    })
  }

  chatChannelListKeyGenerator(chatChannel: IChatChannel) {
    return chatChannel.chatroom.id + '_' + (chatChannel.latestMessage?.id ?? '') + '_' + chatChannel.unreadMessageCount;
  }

  showUserSideBar() {
    animateTo({ duration: 500, curve: Curve.Ease }, () => {
      this.show = true;
    })
  }

  build() {
    Column() {
      Row() {
        Row({ space: 6 }) {
          Image(this.user.avatarUrl)
            .height($r('app.float.chat_channel_avatar_size'))
            .width($r('app.float.chat_channel_avatar_size'))
            .borderRadius($r('app.float.chat_channel_avatar_border_radius'))
            .onClick(() => this.showUserSideBar())

          this.UserStatusBuilder('online', this.user)
        }
        .width('50%')
        .justifyContent(FlexAlign.Start)

        Row() {
          Image($r('app.media.plus'))
            .height('100%')
        }
        .width('50%')
        .justifyContent(FlexAlign.End)
      }
      .justifyContent(FlexAlign.Start)
      .height($r('app.float.chat_channel_user_nav_height'))
      .width('100%')
      .padding({
        left: $r('app.float.chat_channel_user_nav_horizontal_padding'),
        right: $r('app.float.chat_channel_user_nav_horizontal_padding'),
        top: $r('app.float.chat_channel_user_nav_vertical_padding'),
        bottom: $r('app.float.chat_channel_user_nav_vertical_padding')
      })

      Column() {
        List() {
          ForEach(this.chatChannels, (chatChannel: IChatChannel) => {
            ListItem() {
              Row({ space: 6 }) {
                Badge({
                  count: chatChannel.unreadMessageCount,
                  style: {
                    badgeSize: 16,
                    badgeColor: $r('app.color.red_badge_color')
                  }
                }) {
                  Image(chatChannel.chatroom.avatarUrl)
                    .width($r('app.float.chat_channel_chat_room_avatar_size'))
                    .height($r('app.float.chat_channel_chat_room_avatar_size'))
                    .borderRadius($r('app.float.chat_channel_avatar_border_radius'))
                }

                Column() {
                  Text(chatChannel.chatroom.name)
                    .width('100%')
                    .height('50%')
                    .fontSize($r('app.float.big_text_size'))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(chatChannel.latestMessage?.content ?? '')
                    .width('100%')
                    .height('50%')
                    .fontSize($r('app.float.normal_text_size'))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
              }
              .height($r('app.float.chat_channel_list_row_height'))
              .padding({
                left: $r('app.float.chat_channel_list_row_horizontal_padding'),
                right: $r('app.float.chat_channel_list_row_horizontal_padding'),
                top: $r('app.float.chat_channel_list_row_vertical_padding'),
                bottom: $r('app.float.chat_channel_list_row_vertical_padding'),
              })
              .backgroundColor($r('app.color.container_item_background_color'))
              .onClick(() => this.handleOnJumpChatRoom(chatChannel))
            }
          }, (chatChannel: IChatChannel) => this.chatChannelListKeyGenerator(chatChannel))
        }
        .height('100%')
        .width('100%')
        .backgroundColor($r('app.color.container_background_color'))
        .divider({
          strokeWidth: $r('app.float.chat_channel_list_divider_width'),
          color: $r('app.color.grey_chat_channel_list_divider_color')
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}