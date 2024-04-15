import { FriendshipType } from '../common/constants/friendshipType'
import { IFriendInfo } from '../common/types/FriendInfo.type'
import { mockUser_mikasa } from './mockUsers'

export const mockFriendInfo_mikasa: IFriendInfo = {
  user: mockUser_mikasa,
  status: FriendshipType.ACCEPT,
  createTime: '2024-03-29 15:53:30',
  updateTime: '2024-03-29 15:59:55',
}