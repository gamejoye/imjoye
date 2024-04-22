import emitter from '@ohos.events.emitter';
import { fetchChatroomSummaries } from '../api/httpApi/chatroom';
import { IChatChannel } from '../common/types/ChatChannel.type';
import { IMessage } from '../common/types/Message.type';
import { ChatChannelTab } from '../common/components/ChatChannelTab';
import { clientChatroomService } from '../common/database/rdb/services';
import { EmitterEvent } from '../common/constants/emitterEvent';
import { Adapter, ClientChatroomAdapter } from '../common/utils/adapter';
import { ClientChatroom } from '../common/views/ClientChatroom';
import { isSuccess } from '../common/utils/http';
import promptAction from '@ohos.promptAction';
import { UserSideBar } from '../common/components/UserSideBar';
import { WebSocketService } from '../api/webSocketApi/service';
import { FriendTab } from '../common/components/FriendTab';
import { IUser } from '../common/types/User.type';
import { fetchFriends } from '../api/httpApi/user';
import { USER } from '../common/constants/appStorageKeys';
import { IEmitterMessage } from '../common/types/EmitterMessage.type';

function chatChannelStateSorter(state1: IChatChannel, state2: IChatChannel) {
  const date1 = new Date(state1.latestMessage.createTime);
  const date2 = new Date(state2.latestMessage.createTime);
  return date2.getTime() - date1.getTime();
}

@Entry
@Component
struct HomePage {
  @StorageLink(USER) user: IUser = null;
  @State currentIndex: number = 0;
  @State chatChannels: IChatChannel[] = [];    // TODO 从本地磁盘获取上次存的chatChannels.state
  @State friends: IUser[] = [];
  @State userSideBarShow: boolean = false;
  @State allUnreadMessageCount: number = 0;
  private tabsController : TabsController = new TabsController();

  webSocketService: WebSocketService = null;

  async aboutToAppear() {
    emitter.on({
      eventId: EmitterEvent.NEW_MESSAGE,
    }, ({ data }: { data: IEmitterMessage }) => {
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

    emitter.on({
      eventId: EmitterEvent.CLIENT_CHATROOM_UPDATE,
    }, ({ data }) => {
      this.loadChatChannels();
    })

    this.webSocketService = new WebSocketService();
    this.webSocketService.start();
  }

  onPageShow() {
    this.loadChatChannels();
    this.loadFriends();
  }

  aboutToDisappear() {
    emitter.off(EmitterEvent.NEW_MESSAGE);
    let clientChatrooms = this.chatChannels.map(
      (chatChannel) => Adapter
        .from<IChatChannel>(chatChannel)
        .to<IChatChannel, ClientChatroom>((chatChannel) => new ClientChatroomAdapter(chatChannel).adapt())
    );
    clientChatrooms = clientChatrooms.filter((clientChatroom) => {
      if(typeof  clientChatroom.latestVisitTime !== 'string') return false;
      return clientChatroom.latestVisitTime !== "";
    });
    clientChatroomService.storeAll(clientChatrooms);

    if(this.webSocketService !== null) {
      this.webSocketService.stop();
      this.webSocketService = null;
    }
  }

  async loadChatChannels() {
    const latestVisitTimes = (await clientChatroomService.getAll()).map(clientRoom => {
      return {
        id: clientRoom.id,
        latestVisitTime: clientRoom.latestVisitTime,
      }
    });
    const { statusCode, data: chatChannels, message } = await fetchChatroomSummaries({
      latestVisitTimes,
    });
    if(!isSuccess(statusCode)) {
      promptAction.showToast({
        message,
        duration: 1000,
      })
    } else {
      this.chatChannels = chatChannels;
      this.allUnreadMessageCount = this.chatChannels
        .map(state => state.unreadMessageCount)
        .reduce((unreadCount, currentSum) => unreadCount + currentSum, 0);
    }
  }

  async loadFriends() {
    const { statusCode, data: friends, message } = await fetchFriends(this.user.id);
    if(!isSuccess(statusCode)) {
      promptAction.showToast({
        message,
        duration: 1000,
      })
    } else {
      this.friends = friends;
    }
  }

  showUserSideBar() {
    this.userSideBarShow = true;
  }

  closeUserSideBar() {
    this.userSideBarShow = false;
  }

  @Builder TabBuilder($$: {title: string, targetIndex: number, badgeCount: number, selectedImg: Resource, normalImg: Resource }) {
    Column() {
      Badge({
        count: $$.badgeCount,
        style: { badgeSize: 16, badgeColor: '#FA2A2D' }
      }) {
        Image(this.currentIndex === $$.targetIndex ? $$.selectedImg : $$.normalImg)
          .size({ width: 25, height: 25 })
      }
        Text($$.title)
          .fontColor(this.currentIndex === $$.targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = $$.targetIndex;
      this.tabsController.changeIndex($$.targetIndex);
    })
  }

  build() {
    Column() {
      UserSideBar({ show: $userSideBarShow }) {
        Column() {
          Tabs({barPosition: BarPosition.End, controller: this.tabsController}) {
            TabContent() {
              ChatChannelTab({
                chatChannels: $chatChannels,
                show: $userSideBarShow,
              })
            }
            .tabBar(this.TabBuilder({
              title: '消息',
              targetIndex: 0,
              badgeCount:  this.allUnreadMessageCount,
              normalImg: $r('app.media.message'),
              selectedImg: $r('app.media.selected_message'),
            }))

            TabContent() {
              FriendTab({
                friends: $friends,
                show: $userSideBarShow
              })
            }
            .tabBar(this.TabBuilder({
              title: '好友',
              targetIndex: 1,
              badgeCount:  0,
              normalImg: $r('app.media.user'),
              selectedImg: $r('app.media.selected_user'),
            }))
          }
          .onChange((index) => {
            this.currentIndex = index;
          })
        }
        .height('100%')
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}