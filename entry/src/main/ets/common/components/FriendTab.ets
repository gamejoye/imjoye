import { IUser } from '../../common/types/User.type';
import { pinyin4js } from '@ohos/pinyin4js';
import router from '@ohos.router';

type IFriendsGroup = {
  title: string;
  friends: IUser[];
}

@Component
export struct FriendTab {
  @StorageLink('user') user: IUser = null;
  @Link friends: IUser[];
  @Link show: boolean;

  friendListKeyGenerator(friend: IUser) {
    return friend.id + '_';
  }

  showUserSideBar() {
    animateTo({ duration: 500, curve: Curve.Ease }, () => {
      this.show = true;
    })
  }

  getFriendsGroups(friends: IUser[]): IFriendsGroup[] {
    const friendsGroupMap = new Map<string, IUser[]>();
    friends.forEach((friend) => {
      let title = pinyin4js.convertToPinyinString(friend.username, '', pinyin4js.WITHOUT_TONE).substring(0, 1).toUpperCase();
      if(!title || title.charCodeAt(0) >= 'Z'.charCodeAt(0) || title.charCodeAt(0) <= 'A'.charCodeAt(0)) title = '#';
      if(!friendsGroupMap.has(title)) {
        friendsGroupMap.set(title, [friend]);
      } else {
        friendsGroupMap.get(title).push(friend);
      }
    });
    const friendsGroups = [...friendsGroupMap.entries()].map(([title, friends]) => {
      return {
        title,
        friends,
      };
    });
    return friendsGroups.sort((groupA, groupB) => groupA.title.charCodeAt(0) - groupB.title.charCodeAt(0));
  }

  handleOnJumpToFriendInfoDetail(friend: IUser) {
    router.pushUrl({
      url: 'pages/FriendInfoDetail',
      params: {
        'friendId': friend.id,
      }
    });
  }

  @Builder UserStatusBuilder() {
    Column({ space: 6}) {
      Text('联系人')
        .width('100%')
        .height('100%')
        .fontSize(20)
    }
  }

  @Builder ItemHead(text: string) {
    Text(text)
      .fontSize(16)
      .backgroundColor('#fff1f3f5')
      .width('100%')
      .padding(5)
  }

  build() {
    Column() {
      Row() {
        Row({ space: 6 }) {
          Image(this.user.avatarUrl)
            .height(48)
            .width(48)
            .borderRadius(50)
            .onClick(() => this.showUserSideBar())

          this.UserStatusBuilder()
        }
        .width('50%')
        .justifyContent(FlexAlign.Start)

        Row() {
          Image($r('app.media.user_plus'))
            .height('100%')
        }
        .width('50%')
        .justifyContent(FlexAlign.End)
      }
      .justifyContent(FlexAlign.Start)
      .height('8%')
      .width('100%')
      .padding({ left: '5%', right: '5%', top: 6, bottom: 6})

      Column() {
        Search({ placeholder: '搜索好友' })
          .height(40)
          .width('100%')
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .onSubmit((value: string) => {

          })
          .onChange((value: string) => {

          })
      }
      .width('100%')
      .padding({ left: '5%', right: '5%' })
      .backgroundColor('#FFFFFF')

      Column() {
        List() {
          ForEach(this.getFriendsGroups(this.friends), (friendsGroup: IFriendsGroup) => {
            ListItemGroup({ header: this.ItemHead(friendsGroup.title) }) {
              ForEach(friendsGroup.friends, (friend: IUser) => {
                ListItem() {
                  Row({ space: 6 }) {
                    Image(friend.avatarUrl)
                      .width(32)
                      .height(32)
                      .borderRadius(50)
                    Text(friend.username)
                  }
                  .width('100%')
                  .height(40)
                  .padding({ left: '5%', right: '5%' })
                  .backgroundColor('#FFFFFF')
                  .onClick(() => this.handleOnJumpToFriendInfoDetail(friend))
                }
              }, (friend: IUser) => this.friendListKeyGenerator(friend))
            }
          })
        }
        .height('100%')
        .width("100%")
        .backgroundColor('#F1F3F5')
        .divider({
          strokeWidth: 1,
          color: '#ffe9f0f0'
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}