import { ChatRoomList } from '../common/components/ChatRoomList';
import { IUser } from '../common/types/User';

@Component
export struct MessageTab {
  @StorageLink('user') user: IUser = null;
  @State arr: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  build() {
    Column() {
      Row() {
        Row() {
          Image(this.user?.avatarUrl || $r('app.media.avatar'))
            .height('100%')
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
      .height('5%')
      .width('100%')
      .padding({ left: '5%', right: '5%', top: 6, bottom: 6})


      ChatRoomList({ chatRoomList: [] })
        .height('95%')
        .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}