import { IUser } from '../common/types/User';

@Component
export struct FriendTab {
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


      List({ space: 12 }) {
        ForEach(this.arr, (item) => {
          ListItem() {
            Text("NavRouter" + item)
              .width("100%")
              .height(72)
              .backgroundColor('#FFFFFF')
              .borderRadius(24)
              .fontSize(16)
              .fontWeight(500)
              .textAlign(TextAlign.Center)
          }
        }, item => item)
      }
      .height('95%')
      .width("100%")
      .padding({ left: '5%', right: '5%', top: 12 })
      .backgroundColor('#F1F3F5')
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}