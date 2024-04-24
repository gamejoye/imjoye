import router from '@ohos.router';
import emitter from '@ohos.events.emitter';
import { fetchMessages, createMessage } from '../api/httpApi';
import { IMessage } from '../common/types/Message.type'
import { IUser } from '../common/types/User.type';
import { MessageList } from '../common/components/MessageList';
import { clientChatroomService } from '../common/database/rdb/services';
import { getCurrentDatetime } from '../common/utils/datetime';
import { EmitterEvent } from '../common/constants/emitterEvent';
import { isSuccess } from '../common/utils/http';
import promptAction from '@ohos.promptAction';
import { IChatroom } from '../common/types/Chatroom.type';
import { IEmitterMessage } from '../common/types/EmitterMessage.type';

function messageSorter(message1: IMessage, message2: IMessage) {
  const date1 = new Date(message1.createTime);
  const date2 = new Date(message2.createTime);
  return date1.getTime() - date2.getTime();
}

@Entry
@Component
struct ChatWindow {
  @State @Watch('onMessageListUpdated') messages: IMessage[] = [];
  @State draft: string = '';
  @StorageLink('user') user: IUser = null;
  private listScroller: Scroller = new Scroller();
  private chatroom: IChatroom = router.getParams()['chatroom'];

  async aboutToAppear() {
    emitter.on({
      eventId: EmitterEvent.NEW_MESSAGE,
    }, ({ data }: { data: IEmitterMessage }) => {
      const message: IMessage = JSON.parse(data.plainText);
      this.messages = [...this.messages, message].sort(messageSorter);
    })
  }

  async onPageShow() {
    const { statusCode, data: messages, message } = await fetchMessages({ roomId: this.chatroom.id });
    if(!isSuccess(statusCode)) {
      promptAction.showToast({
        message,
        duration: 1000,
      })
    }
    this.messages = messages.sort(messageSorter);
  }

  aboutToDisappear() {
    emitter.off(EmitterEvent.NEW_MESSAGE);
    clientChatroomService.updateLatestVisitTime(this.chatroom, getCurrentDatetime())
  }

  handleOnBack() {
    router.back({
      url: 'pages/HomePage',
    })
  }

  onMessageListUpdated() {
    this.listScroller.scrollToIndex(this.messages.length - 1);
  }

  async handleOnMessageSubmit() {
    await createMessage({
      content: this.draft,
      userId: this.user.id,
      chatroomId: this.chatroom.id,
    })
    this.draft = '';
  }

  @Builder ChatroomStatusBuild(chatroom: IChatroom) {
    Flex({
      direction: FlexDirection.Column
    }) {
      Text(chatroom.name)
        .width('100%')
        .height('50%')
        .fontSize($r('app.float.big_text_size'))
      Row({ space: 6 }) {
        // 聊天室用户在线情况
        Circle({
          height: 10,
          width: 10
        })
          .fill($r('app.color.green_user_status_color'))
        Text('用户在线')
      }
      .width('100%')
      .height('50%')
    }
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
    }) {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center
      }) {
        Image($r('app.media.back'))
          .height('100%')
          .onClick(this.handleOnBack)
        this.ChatroomStatusBuild(this.chatroom)
      }
      .height($r('app.float.chat_window_header_height'))
      .padding({
        top: $r('app.float.chat_window_header_vertical_padding'),
        bottom: $r('app.float.chat_window_header_vertical_padding'),
        left: $r('app.float.chat_window_header_horizontal_padding'),
        right: $r('app.float.chat_window_header_horizontal_padding'),
      })
      .flexShrink(0)

      MessageList({
        messages: $messages,
        listScroller: this.listScroller
      })

      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Start
      }) {
        Scroll() {
          TextArea({ text: this.draft, placeholder: '友好交流~' })
            .onChange((val) => {
              this.draft = val;
            })
        }
        .scrollBar(BarState.Off)

        Button('发送')
          .width($r('app.float.chat_window_send_message_button_width'))
          .type(ButtonType.Normal)
          .borderRadius($r('app.float.normal_button_border_radius'))
          .enabled(this.draft !== '')
          .onClick(() => this.handleOnMessageSubmit())
          .margin({
            left: $r('app.float.chat_window_send_message_button_horizontal_margin'),
            right: $r('app.float.chat_window_send_message_button_horizontal_margin')
          })
      }
      .padding($r('app.float.chat_window_footer_padding'))
      .constraintSize({
        minHeight: $r('app.float.chat_window_footer_min_height'),
        maxHeight: $r('app.float.chat_window_footer_max_height')
      })
    }
    .width('100%')
    .height('100%')
  }
}