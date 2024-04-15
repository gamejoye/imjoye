import { FriendshipType } from '../constants/friendshipType';
import { IUser } from './User.type';

export interface IFriendInfo {
  user: IUser;
  status: FriendshipType;
  createTime: string;
  updateTime: string;
}