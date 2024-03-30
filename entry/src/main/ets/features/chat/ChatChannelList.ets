
import { pickChatroomName } from '../../common/utils/pickChatRoomName';
import { IChatChannelState } from './ChatChannel';

@Component
export struct ChatChannelList {
  @Link chatChannelList: IChatChannelState[];

  build() {
    Column() {
      List() {
        ForEach(this.chatChannelList, (chatChannel: IChatChannelState) => {
          ListItem() {
            Row({ space: 6 }) {
              Image($r('app.media.logo'))
                .width(60)
                .height(60)
                .borderRadius(50)

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
          }
        }, (chatChannel: IChatChannelState) => chatChannel.chatroom.id + '')
      }
      .height('100%')
      .width("100%")
      .backgroundColor('#F1F3F5')
    }
  }
}