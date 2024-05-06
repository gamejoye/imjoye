import router from '@ohos.router';
import emitter from '@ohos.events.emitter';
import { fetchMessages, createMessage } from '../api/httpApi';
import { IMessage } from '../common/types/Message.type'
import { IUser } from '../common/types/User.type';
import { MessageList } from '../common/components/MessageList';
import { ClientUserChatroomService } from '../common/database/rdb/ClientUserChatroom';
import { getCurrentDatetime } from '../common/utils/datetime';
import { EmitterEvent } from '../common/constants/emitterEvent';
import { isSuccess } from '../common/utils/http';
import promptAction from '@ohos.promptAction';
import { IChatroom } from '../common/types/Chatroom.type';
import { IClientChatroomUpdate, IEmitterMessage } from '../common/types/EmitterMessage.type';
import { IMessageState } from '../common/types/MessageState.type';
import { getMessageTemporaryId } from '../common/utils';

function messageStateSorter(messageState1: IMessageState, messageState2: IMessageState) {
  const date1 = new Date(messageState1.message.createTime);
  const date2 = new Date(messageState2.message.createTime);
  return date1.getTime() - date2.getTime();
}

@Entry
@Component
struct ChatWindow {
  @State @Watch('onMessageListUpdate') messageStates: Array<IMessageState> = [];
  @State draft: string = '';
  @StorageLink('user') user: IUser = null;
  private listScroller: Scroller = new Scroller();
  private chatroom: IChatroom = router.getParams()['chatroom'];

  async aboutToAppear() {
    emitter.on({
      eventId: EmitterEvent.NEW_MESSAGE,
    }, ({ data }: { data: IEmitterMessage }) => {
      const message: IMessage = JSON.parse(data.plainText);
      if (message.chatroom.id !== this.chatroom.id) return;

      const index = this.messageStates.findIndex((mss) => (
        typeof mss.message.temporaryId === 'number' &&
        mss.message.temporaryId === message.temporaryId)
      );
      if (index === -1) {
        const messageState: IMessageState = {
          status: 'success',
          message
        };
        this.messageStates.push(messageState);
        this.messageStates.sort(messageStateSorter);
      } else {
        this.messageStates[index] = {
          message: message,
          status: 'success',
        }
      }
    });
  }

  async onPageShow() {
    const { statusCode, data: messages, message } = await fetchMessages({ roomId: this.chatroom.id });
    if(!isSuccess(statusCode)) {
      promptAction.showToast({
        message,
        duration: 1000,
      })
    }
    this.messageStates = messages
      .map((message) => {
        const mss: IMessageState = {
          status: 'success',
          message,
        };
        return mss;
      })
      .sort(messageStateSorter);
  }

  async aboutToDisappear() {
    emitter.off(EmitterEvent.NEW_MESSAGE);
    const latestVisitTime = getCurrentDatetime();
    await ClientUserChatroomService.save({
      userId: this.user.id,
      chatroomId: this.chatroom.id,
      latestVisitTime,
    });
    const payload: IClientChatroomUpdate = {
      id: this.chatroom.id,
      timestamp: latestVisitTime,
    };
    const emitterData: IEmitterMessage = {
      plainText: JSON.stringify(payload),
    };
    emitter.emit({
      eventId: EmitterEvent.CLIENT_CHATROOM_UPDATE,
    }, {
      data: emitterData,
    });
  }

  handleOnBack() {
    router.back({
      url: 'pages/HomePage',
    })
  }

  onMessageListUpdate() {
    this.listScroller.scrollToIndex(this.messageStates.length - 1);
  }

  async handleOnMessageSubmit() {
    const temporaryId = getMessageTemporaryId(
      this.messageStates
        .map((mss) => mss.message.temporaryId)
        .filter((tid) => tid !== null)
    );
    const partialMessage: IMessage = {
      id: null as any,
      temporaryId,
      chatroom: this.chatroom,
      from: this.user,
      content: this.draft,
      createTime: getCurrentDatetime(),
    };
    const messageState: IMessageState = {
      status: 'loading',
      message: partialMessage,
    };
    this.draft = '';
    this.messageStates.push(messageState);
    this.messageStates.sort(messageStateSorter);
    createMessage({
      temporaryId,
      content: partialMessage.content,
      userId: partialMessage.from.id,
      chatroomId: partialMessage.chatroom.id,
    });
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
        messages: $messageStates,
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