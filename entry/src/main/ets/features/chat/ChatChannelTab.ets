import { IUser } from '../../common/types/User.type';
import { IChatChannel } from '../../common/types/ChatChannel.type';
import { pickChatroomName } from '../../common/utils/pickChatRoomName';
import router from '@ohos.router';

@Component
export struct ChatChannelTab {
  @StorageLink('user') user: IUser = null;
  @Link chatChannels: IChatChannel[];

  @Builder UserStatusBuilder(status: 'online', user: IUser) {
    Column({ space: 6}) {
      Text(user.username)
        .width('100%')
        .height('50%')
        .fontSize(20)
      Row({ space: 6}) {
        Circle({ width: 10, height: 10})
          .fill(status === 'online' ? 'green' : 'blue')
        Text('在线')
      }
      .width('100%')
      .height('50%')
    }
  }

  handleOnJumpChatRoom(chatChannel: IChatChannel) {
    router.pushUrl({
      url: 'pages/ChatWindow',
      params: {
        chatChannel
      }
    })
  }

  chatChannelListKeyGenerator(chatChannel: IChatChannel) {
    return chatChannel.chatroom.id + '_' + (chatChannel.latestMessage?.id ?? '') + '_' + chatChannel.unreadMessageCount;
  }

  build() {
    Column() {
      Row() {
        Row({ space: 6 }) {
          Image(this.user.avatarUrl)
            .height(48)
            .width(48)
            .borderRadius(50)
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
      .height('8%')
      .width('100%')
      .padding({ left: '5%', right: '5%', top: 6, bottom: 6})

      Column() {
        List() {
          ForEach(this.chatChannels, (chatChannel: IChatChannel) => {
            ListItem() {
              Row({ space: 6 }) {
                Badge({
                  count: chatChannel.unreadMessageCount,
                  position: BadgePosition.RightTop,
                  style: { badgeSize: 16, badgeColor: '#FA2A2D' }
                }) {
                  Image($r('app.media.logo'))
                    .width(48)
                    .height(48)
                    .borderRadius(50)
                }

                Column() {
                  Text(pickChatroomName(chatChannel.chatroom))
                    .width('100%')
                    .height('50%')
                    .fontSize(24)
                  Text(chatChannel.latestMessage?.content ?? '')
                    .width('100%')
                    .height('50%')
                    .fontSize(16)
                }.padding({ top: 10, bottom: 10 })
              }
              .height(72)
              .padding({ left: '5%', right: '5%' })
              .backgroundColor('#FFFFFF')
              .onClick(() => this.handleOnJumpChatRoom(chatChannel))
            }
          }, (chatChannel: IChatChannel) => this.chatChannelListKeyGenerator(chatChannel))
        }
        .height('100%')
        .width("100%")
        .backgroundColor('#F1F3F5')
      }
    }
    .width('100%')
    .height('100%')
  }
}