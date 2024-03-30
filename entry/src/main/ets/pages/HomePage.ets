
import { MessageTab } from '../features/chat/MessageTab';
@Entry
@Component
struct HomePage {
  @State currentIndex: number = 0;
  private tabsController : TabsController = new TabsController();

  @Builder TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
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
          MessageTab()
        }
        .tabBar(this.TabBuilder('消息', 0, $r('app.media.selected_message'), $r('app.media.message')))

        TabContent() {
          Column() {
            Text('好友列表').fontSize(30)
          }
        }
        .tabBar(this.TabBuilder('好友', 1, $r('app.media.selected_user'), $r('app.media.user')))
      }
      .onChange((index) => {
        this.currentIndex = index;
      })
    }
    .height('100%')
    .width('100%')
  }
}