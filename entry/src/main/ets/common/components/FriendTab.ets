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
    Column({ space: 6 }) {
      Text('联系人')
        .width('100%')
        .height('100%')
        .fontSize($r('app.float.big_text_size'))
    }
  }

  @Builder ItemHead(text: string) {
    Text(text)
      .fontSize($r('app.float.normal_text_size'))
      .backgroundColor($r('app.color.friend_tab_items_head_background_color'))
      .width('100%')
      .padding($r('app.float.friend_tab_items_head_padding'))
  }

  build() {
    Column() {
      Row() {
        Row({ space: 6 }) {
          Image(this.user.avatarUrl)
            .height($r('app.float.friend_tab_user_nav_avatar_size'))
            .width($r('app.float.friend_tab_user_nav_avatar_size'))
            .borderRadius($r('app.float.friend_tab_user_nav_avatar_border_radius'))
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
      .height($r('app.float.friend_tab_user_nav_height'))
      .width('100%')
      .padding({
        left: $r('app.float.friend_tab_user_nav_horizontal_padding'),
        right: $r('app.float.friend_tab_user_nav_horizontal_padding'),
        top: $r('app.float.friend_tab_user_nav_vertical_padding'),
        bottom: $r('app.float.friend_tab_user_nav_vertical_padding')
      })

      Column() {
        Search({ placeholder: '搜索好友' })
          .height($r('app.float.friend_tab_search_height'))
          .width('100%')
          .placeholderColor($r('app.color.grey_text_color'))
          .placeholderFont({
            size: $r('app.float.small_text_size'),
          })
          .textFont({
            size: $r('app.float.small_text_size'),
          })
          .onSubmit((value: string) => {

          })
          .onChange((value: string) => {

          })
      }
      .width('100%')
      .padding({
        left: $r('app.float.friend_tab_search_horizontal_padding'),
        right: $r('app.float.friend_tab_search_horizontal_padding')
      })
      .backgroundColor($r('app.color.container_item_background_color'))

      Column() {
        List() {
          ForEach(this.getFriendsGroups(this.friends), (friendsGroup: IFriendsGroup) => {
            ListItemGroup({ header: this.ItemHead(friendsGroup.title) }) {
              ForEach(friendsGroup.friends, (friend: IUser) => {
                ListItem() {
                  Row({ space: 6 }) {
                    Image(friend.avatarUrl)
                      .width($r('app.float.friend_tab_items_avatar_size'))
                      .height($r('app.float.friend_tab_items_avatar_size'))
                      .borderRadius($r('app.float.friend_tab_items_avatar_border_radius'))
                    Text(friend.username)
                  }
                  .width('100%')
                  .height($r('app.float.friend_tab_items_height'))
                  .padding({
                    left: $r('app.float.friend_tab_items_vertical_padding'),
                    right: $r('app.float.friend_tab_items_vertical_padding'),
                  })
                  .backgroundColor($r('app.color.container_item_background_color'))
                  .onClick(() => this.handleOnJumpToFriendInfoDetail(friend))
                }
              }, (friend: IUser) => this.friendListKeyGenerator(friend))
            }
          })
        }
        .height('100%')
        .width("100%")
        .backgroundColor($r('app.color.container_background_color'))
      }
    }
    .width('100%')
    .height('100%')
  }
}