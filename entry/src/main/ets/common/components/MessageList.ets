import { IMessageState } from '../types/MessageState.type';
import { IUser } from '../types/User.type';
import { Spin } from './Spin';

@Component
export struct MessageList {
  @Link messages: Array<IMessageState>;
  listScroller: Scroller;
  @StorageLink('user') user: IUser = null;

  keyGenerator(messageState: IMessageState): string {
    const { message, status } = messageState;
    const id = typeof message.id === 'number' ? message.id : message.temporaryId;
    return id + '_' + status;
  }

  @Builder MessageBubble(messageState: IMessageState, isLeft: boolean) {
    Flex({ direction: isLeft ? FlexDirection.Row : FlexDirection.RowReverse }) {
      Image(messageState.message.from.avatarUrl)
        .width($r('app.float.chat_window_avatar_size'))
        .height($r('app.float.chat_window_avatar_size'))
        .margin({
          left: $r('app.float.chat_window_avatar_margin_left'),
          right: $r('app.float.chat_window_avatar_margin_right'),
        })
        .borderRadius($r('app.float.chat_window_avatar_border_radius'))
        .flexShrink(0)

      Flex({
        direction: isLeft ? FlexDirection.Row : FlexDirection.RowReverse,
        alignItems: ItemAlign.Center
      }) {
        Text(messageState.message.content)
          .fontSize($r('app.float.normal_text_size'))
          .backgroundColor(isLeft ? $r('app.color.chat_window_message_left_color') : $r('app.color.chat_window_message_right_color'))
          .padding($r('app.float.chat_window_message_padding'))
          .borderRadius($r('app.float.chat_window_message_border_radius'))
          .constraintSize({ maxWidth: $r('app.float.chat_window_message_max_width') })

        if (messageState.status === 'loading') {
          Spin({ delay: 500 })
        } else if (messageState.status === 'fail') {
          Button({ type: ButtonType.Circle }) {
            Image($r('app.media.exclamation'))
              .width($r('app.float.chat_window_message_fail_button_svg_size'))
              .height($r('app.float.chat_window_message_fail_button_svg_size'))
          }
          .width($r('app.float.chat_window_message_fail_button_size'))
          .height($r('app.float.chat_window_message_fail_button_size'))
          .margin({
            left: $r('app.float.chat_window_message_fail_button_horizontal_margin'),
            right: $r('app.float.chat_window_message_fail_button_horizontal_margin')
          })
          .backgroundColor($r('app.color.red_badge_color'))
        }
      }
    }
    .margin({
      top: $r('app.float.chat_window_message_bubble_margin_top'),
      bottom: $r('app.float.chat_window_message_bubble_margin_bottom'),
    })
  }

  build() {
    List({ scroller: this.listScroller }) {
      ForEach(this.messages, (messageState: IMessageState) => {
        ListItem() {
          this.MessageBubble(messageState, messageState.message.from.id !== this.user.id);
        }
      }, (messageState: IMessageState) => this.keyGenerator(messageState))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.container_background_color'))
  }
}
