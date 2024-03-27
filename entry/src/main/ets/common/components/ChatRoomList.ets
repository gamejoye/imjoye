import { IChatRoom } from '../types/ChatRoom';

@Component
export struct ChatRoomList {
  chatRoomList: IChatRoom[];

  build() {
    Column() {
      List({ space: 12 }) {
        ForEach(this.chatRoomList, (charRoom: IChatRoom) => {
          ListItem() {
            Text("NavRouter" + charRoom)
              .width("100%")
              .height(72)
              .backgroundColor('#FFFFFF')
              .borderRadius(24)
              .fontSize(16)
              .fontWeight(500)
              .textAlign(TextAlign.Center)
          }
        }, item => item)
      }
      .height('100%')
      .width("100%")
      .padding({ left: '5%', right: '5%', top: 12 })
      .backgroundColor('#F1F3F5')
    }
  }
}