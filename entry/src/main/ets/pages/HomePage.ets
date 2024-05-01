import emitter from '@ohos.events.emitter';
import { fetchChatroomSummaries, fetchChatroomSummary } from '../api/httpApi/chatroom';
import { IChatChannel } from '../common/types/ChatChannel.type';
import { IMessage } from '../common/types/Message.type';
import { ChatChannelTab } from '../common/components/ChatChannelTab';
import { ClientChatroomService } from '../common/database/rdb/ClientChatroom';
import { EmitterEvent } from '../common/constants/emitterEvent';
import { isSuccess } from '../common/utils/http';
import promptAction from '@ohos.promptAction';
import { UserSideBar } from '../common/components/UserSideBar';
import { WebSocketService } from '../api/webSocketApi/service';
import { FriendTab } from '../common/components/FriendTab';
import { IUser } from '../common/types/User.type';
import { fetchFriends } from '../api/httpApi/user';
import { USER } from '../common/constants/appStorageKeys';
import { IClientChatroomUpdate, IEmitterMessage } from '../common/types/EmitterMessage.type';
import { WebsocketHandler } from '../api/webSocketApi/handler/WebsocketHandler';
import workScheduler from '@ohos.resourceschedule.workScheduler';

function chatChannelStateSorter(state1: IChatChannel, state2: IChatChannel) {
  const date1 = new Date(state1.latestMessage?.createTime);
  const date2 = new Date(state2.latestMessage?.createTime);
  return date2.getTime() - date1.getTime();
}

@Entry
@Component
struct HomePage {
  @StorageLink(USER) user: IUser = null;
  @State currentIndex: number = 0;
  @State chatChannels: IChatChannel[] = [];
  @State friends: IUser[] = [];
  @State userSideBarShow: boolean = false;
  @State allUnreadMessageCount: number = 0;
  private tabsController: TabsController = new TabsController();
  webSocketService: WebSocketService = null;

  async aboutToAppear() {
    const channels = await ClientChatroomService.getChatChannels(this.user);
    console.log("从本地数据库获取的channels: ", JSON.stringify(channels));
    this.chatChannels = channels.sort(chatChannelStateSorter);

    this.loadChatChannels();
    this.loadFriends();

    emitter.on({
      eventId: EmitterEvent.NEW_MESSAGE,
    }, ({ data }: { data: IEmitterMessage }) => {
      const message: IMessage = JSON.parse(data.plainText);
      this.chatChannels = this.chatChannels.map(
        (chatChannel) => {
          if (chatChannel.chatroom.id !== message.chatroom.id) return chatChannel;
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
    }, async ({ data }: { data: IEmitterMessage }) => {
      // TODO 更新 chatChannel
      const payload: IClientChatroomUpdate = JSON.parse(data.plainText);
      const { statusCode, data: channel, message } = await fetchChatroomSummary({
        id: payload.id,
        timestamp: payload.timestamp
      });
      if(!isSuccess(statusCode)) {
        promptAction.showToast({
          message,
          duration: 1000,
        });
        return;
      }
      const index = this.chatChannels.findIndex((chatChannel) => chatChannel.chatroom.id === channel.chatroom.id);
      if (index === -1) {
        this.chatChannels.push(channel);
      } else {
        this.chatChannels[index] = channel;
      }
      this.chatChannels.sort(chatChannelStateSorter);
    })

    this.webSocketService = new WebSocketService(new WebsocketHandler());
    this.webSocketService.start();
  }

  aboutToDisappear() {
    emitter.off(EmitterEvent.NEW_MESSAGE);
    emitter.off(EmitterEvent.CLIENT_CHATROOM_UPDATE);
    if (this.webSocketService !== null) {
      this.webSocketService.stop();
      this.webSocketService = null;
    }
  }

  async loadChatChannels() {
    const latestVisitTimes = this.chatChannels.map((channel) => ({
      id: channel.chatroom.id,
      latestVisitTime: channel.latestVisitTime
    })).filter(({ latestVisitTime}) => latestVisitTime !== null);
    console.log('loadChatChannels: ', JSON.stringify(latestVisitTimes));
    const { statusCode, data: chatChannels, message } = await fetchChatroomSummaries({
      latestVisitTimes,
    });
    if (!isSuccess(statusCode)) {
      promptAction.showToast({
        message,
        duration: 1000,
      })
    } else {
      this.chatChannels = chatChannels.sort(chatChannelStateSorter);
      this.allUnreadMessageCount = this.chatChannels
        .map(state => state.unreadMessageCount)
        .reduce((unreadCount, currentSum) => unreadCount + currentSum, 0);

      ClientChatroomService.save(this.user, this.chatChannels);
    }
  }

  async loadFriends() {
    const { statusCode, data: friends, message } = await fetchFriends(this.user.id);
    if (!isSuccess(statusCode)) {
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

  @Builder TabBuilder($$: {
    title: string,
    targetIndex: number,
    badgeCount: number,
    selectedImg: Resource,
    normalImg: Resource
  }) {
    Column() {
      Badge({
        count: $$.badgeCount,
        style: {
          badgeSize: 16,
          badgeColor: $r('app.color.red_badge_color')
        }
      }) {
        Image(this.currentIndex === $$.targetIndex ? $$.selectedImg : $$.normalImg)
          .height($r('app.float.home_page_tar_image_size'))
          .width($r('app.float.home_page_tar_image_size'))
      }

      Text($$.title)
        .fontColor(this.currentIndex === $$.targetIndex ? $r('app.color.blue_text_color') : $r('app.color.grey_text_color'))
    }
    .width('100%')
    .height($r('app.float.home_page_tar_size'))
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
          Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
            TabContent() {
              ChatChannelTab({
                chatChannels: $chatChannels,
                show: $userSideBarShow,
              })
            }
            .tabBar(this.TabBuilder({
              title: '消息',
              targetIndex: 0,
              badgeCount: this.allUnreadMessageCount,
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
              badgeCount: 0,
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