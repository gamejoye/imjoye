import { IUser } from '../common/types/User.type';

@Component
export struct FriendTab {
  @StorageLink('user') user: IUser = null;
  build() {
    Column() {

    }
  }
}