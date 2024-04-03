import emitter from '@ohos.events.emitter';
import { fetchChatroomSummaries } from '../api/httpApi/chatroom';
import { WebSocketEvent } from '../common/constants/websocketEvent';
import { IChatChannel } from '../common/types/ChatChannel.type';
import { IMessage } from '../common/types/Message.type';
import { ChatChannelTab } from '../features/chat/ChatChannelTab';

function chatChannelStateSorter(state1: IChatChannel, state2: IChatChannel) {
  const date1 = new Date(state1.latestMessage.createTime);
  const date2 = new Date(state2.latestMessage.createTime);
  return date2.getTime() - date1.getTime();
}

@Entry
@Component
struct HomePage {
  @State currentIndex: number = 0;
  @State chatChannels: IChatChannel[] = [];    // TODO 从本地磁盘获取上次存的chatChannels.state
  private tabsController : TabsController = new TabsController();
  @State allUnreadMessageCount: number = this.chatChannels
    .map(state => state.unreadMessageCount)
    .reduce((unreadCount, currentSum) => unreadCount + currentSum, 0);

  async aboutToAppear() {
    emitter.on({
      eventId: WebSocketEvent.NEW_MESSAGE,
    }, ({ data }: { data: { plainText: string } }) => {
      const message: IMessage = JSON.parse(data.plainText);
      this.chatChannels = this.chatChannels.map(
        (chatChannel) => {
          if(chatChannel.chatroom.id !== message.chatroom.id) return chatChannel;
          return {
            ...chatChannel,
            unreadMessageCount: chatChannel.unreadMessageCount + 1,
            latestMessage: message
          }
        }
      ).sort(chatChannelStateSorter);
    })
  }

  async onPageShow() {
    const chatChannels = await fetchChatroomSummaries({
      latestVisitTimes: [],
    });
    this.chatChannels = chatChannels.sort(chatChannelStateSorter);
  }

  aboutToDisappear() {
    emitter.off(WebSocketEvent.NEW_MESSAGE);
    // TODO 将chatChannels.state 存在本地磁盘
  }

  @Builder TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource, badgeCount: number) {
    Column() {
      Badge({
        count: badgeCount,
        style: { badgeSize: 16, badgeColor: '#FA2A2D' }
      }) {
        Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
          .size({ width: 25, height: 25 })
      }
        Text(title)
          .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(targetIndex);
    })
  }

  build() {
    Column() {
      Tabs({barPosition: BarPosition.End, controller: this.tabsController}) {
        TabContent() {
          ChatChannelTab({ chatChannels: $chatChannels })
        }
        .tabBar(this.TabBuilder('消息', 0, $r('app.media.selected_message'), $r('app.media.message'), this.allUnreadMessageCount))

        TabContent() {
          Column() {
            Text('好友列表')
          }
        }
        .tabBar(this.TabBuilder('好友', 1, $r('app.media.selected_user'), $r('app.media.user'), 0))
      }
      .onChange((index) => {
        this.currentIndex = index;
      })
    }
    .height('100%')
    .width('100%')
  }
}