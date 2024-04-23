import { IMessage } from '../types/Message.type'
import { IUser } from '../types/User.type';

@Component
export struct MessageList {
  @Link messages: IMessage[];
  listScroller: Scroller;
  @StorageLink('user') user: IUser = null;

  @Builder MessageBubble(message: IMessage, isLeft: boolean) {
    Flex({ direction: isLeft ? FlexDirection.Row : FlexDirection.RowReverse }) {
      Image(message.from.avatarUrl)
        .width($r('app.float.chat_window_avatar_size'))
        .height($r('app.float.chat_window_avatar_size'))
        .margin({
          left: $r('app.float.chat_window_avatar_margin_left'),
          right: $r('app.float.chat_window_avatar_margin_right'),
        })
        .borderRadius($r('app.float.chat_window_avatar_border_radius'))
        .flexShrink(0)

      Text(message.content)
        .fontSize($r('app.float.normal_text_size'))
        .backgroundColor(isLeft ? $r('app.color.chat_window_message_left_color') : $r('app.color.chat_window_message_right_color'))
        .padding($r('app.float.chat_window_message_padding'))
        .borderRadius($r('app.float.chat_window_message_border_radius'))
        .flexBasis('auto')
        .constraintSize({ maxWidth: $r('app.float.chat_window_message_max_width') })
    }
    .margin({
      top: $r('app.float.chat_window_message_bubble_margin_top'),
      bottom: $r('app.float.chat_window_message_bubble_margin_bottom'),
    })
  }

  build() {
    List({ scroller: this.listScroller }) {
      ForEach(this.messages, (message: IMessage) => {
        ListItem() {
          this.MessageBubble(message, message.from.id !== this.user.id);
        }
      }, (message: IMessage) => message.id + '')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.container_background_color'))
  }
}