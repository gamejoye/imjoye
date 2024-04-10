import router from '@ohos.router';
import emitter from '@ohos.events.emitter';
import { fetchMessages, createMessage } from '../api/httpApi';
import { IMessage } from '../common/types/Message.type'
import { IUser } from '../common/types/User.type';
import { pickChatroomName } from '../common/utils/pickChatRoomName';
import { IChatChannel } from '../common/types/ChatChannel.type';
import { MessageList } from '../features/message/MessageList';
import { clientChatroomService } from '../common/database/rdb/services';
import { getCurrentDatetime } from '../common/utils/datetime';
import { EmitterEvent } from '../common/constants/emitterEvent';
import { isSuccess } from '../common/utils/http';
import promptAction from '@ohos.promptAction';


function messageSorter(message1: IMessage, message2: IMessage) {
  const date1 = new Date(message1.createTime);
  const date2 = new Date(message2.createTime);
  return date1.getTime() - date2.getTime();
}

@Entry
@Component
struct ChatWindow {
  @State messages: IMessage[] = [];
  @State draft: string = '';
  @StorageLink('user') user: IUser = null;
  private listScroller: Scroller = new Scroller();
  private chatChannel: IChatChannel = router.getParams()['chatChannel'];

  async aboutToAppear() {
    emitter.on({
      eventId: EmitterEvent.NEW_MESSAGE,
    }, ({ data }: { data: { plainText: string } }) => {
      const message: IMessage = JSON.parse(data.plainText);
      this.messages = [...this.messages, message].sort(messageSorter);
    })
  }

  async onPageShow() {
    const { statusCode, data: messages, message } = await fetchMessages({ roomId: this.chatChannel.chatroom.id });
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
    clientChatroomService.updateLatestVisitTime(this.chatChannel.chatroom, getCurrentDatetime())
  }

  handleOnBack() {
    router.back({
      url: 'pages/HomePage',
    })
  }

  async handleOnMessageSubmit() {
    await createMessage({
      content: this.draft,
      userId: this.user.id,
      chatroomId: this.chatChannel.chatroom.id,
    })
    this.draft = '';
  }

  @Builder ChatroomStatusBuild(chatChannel: IChatChannel) {
    Flex({
      direction: FlexDirection.Column
    }) {
      Text(pickChatroomName(chatChannel.chatroom))
        .width('100%')
        .height('50%')
        .fontSize(20)
      Row({ space: 6 }) {
        // 聊天室用户在线情况
        Circle({ height: 10, width: 10})
          .fill('green')
        Text('用户在线')
      }
      .width('100%')
      .height('50%')
    }
    .height(60)
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
          .height(48)
          .width(48)
          .onClick(this.handleOnBack)
        this.ChatroomStatusBuild(this.chatChannel)
      }
      .constraintSize({ minHeight: 60, maxHeight: 60 })

      MessageList({ messages: $messages, listScroller: this.listScroller })

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
          .width(80)
          .type(ButtonType.Normal)
          .borderRadius(8)
          .enabled(this.draft !== '')
          .onClick(() => this.handleOnMessageSubmit())
      }
      .padding(6)
      .constraintSize({ maxHeight: 240 })
    }
    .width('100%')
    .height('99%')
  }
}