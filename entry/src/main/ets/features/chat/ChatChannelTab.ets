import { ChatChannelList } from './ChatChannelList';
import { IUser } from '../../common/types/User.type';
import { IChatChannelState } from './ChatChannel';
import { fetchChatroomSummaries } from '../../api/httpApi/chatroom';

@Component
export struct ChatChannelTab {
  @StorageLink('user') user: IUser = null;
  @State chatChannels: IChatChannelState[] = [];

  async aboutToAppear() {
    const chatChannels = await fetchChatroomSummaries({
      latestVisitTimes: [],
    });
    this.chatChannels = chatChannels;
  }

  @Builder UserStatusBuilder(status: 'online', user: IUser) {
    Column({ space: 6}) {
      Text(user.username)
        .width('100%')
        .height('50%')
        .fontSize(20)
      Row({ space: 6}) {
        Circle({ width: 10, height: 10})
          .fill(status === 'online' ? 'green' : 'blue')
        Text('在线')
      }
      .width('100%')
      .height('50%')
    }
  }

  build() {
    Column() {
      Row() {
        Row({ space: 6 }) {
          Image(this.user.avatarUrl)
            .height(48)
            .width(48)
            .borderRadius(50)
          this.UserStatusBuilder('online', this.user)
        }
        .width('50%')
        .justifyContent(FlexAlign.Start)

        Row() {
          Image($r('app.media.plus'))
            .height('100%')
        }
        .width('50%')
        .justifyContent(FlexAlign.End)
      }
      .justifyContent(FlexAlign.Start)
      .height('8%')
      .width('100%')
      .padding({ left: '5%', right: '5%', top: 6, bottom: 6})

      ChatChannelList({ chatChannelList: $chatChannels })
        .height('92%')
        .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}