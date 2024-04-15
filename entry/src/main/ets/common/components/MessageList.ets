import { IMessage } from '../types/Message.type'
import { IUser } from '../types/User.type';

@Component
export struct MessageList {
  @Link messages: IMessage[];
  listScroller: Scroller;
  @StorageLink('user') user: IUser = null;

  @Builder MessageBubble(message: IMessage, isLeft: boolean) {
    Flex({ direction: isLeft ? FlexDirection.Row : FlexDirection.RowReverse }) {
      // 用户头像
      Image(message.from.avatarUrl)
        .width('120px')
        .height('120px')
        .margin({ left: '10px', right: '10px' })
        .borderRadius(50)

      Flex({ direction: isLeft ? FlexDirection.Row : FlexDirection.RowReverse, justifyContent: FlexAlign.Start }) {
        // 文本消息
        Text(message.content)
          .fontSize('14fp')
          .backgroundColor(isLeft ? '#cccccc' : '#ff6c8bef')
          .padding(10)
          .borderRadius(10)
          .margin(isLeft ? { right: '140px' } : { left: '140px'})
      }
    }.margin({ top: '20px', bottom: '20px' })
  }

  build() {
    Flex({
      direction: FlexDirection.ColumnReverse
    }) {
      List({ scroller: this.listScroller }) {
        ForEach(this.messages, (message: IMessage) => {
          ListItem() {
            this.MessageBubble(message, message.from.id !== this.user.id);
          }
        }, (message: IMessage) => message.id + '')
      }
    }
    .width('100%')
    .backgroundColor('#F1F3F5')
  }
}