import { ClientUserChatroom } from '../../../../main/ets/common/database/rdb/ClientUserChatroom/ClientUserChatroom';
import { IChatChannel } from '../../../../main/ets/common/types/ChatChannel.type';
import { IChatroom } from '../../../../main/ets/common/types/Chatroom.type'

export const existingChatrooms: Array<IChatroom> = [
  {
    id: 1,
    type: 'SINGLE',
    name: null,
    avatarUrl: null,
    createTime: '2024-03-29 15:54:07',
  },
  {
    id: 2,
    type: 'MULTIPLE',
    name: '爱之诗',
    avatarUrl: 'https://avatars.githubusercontent.com/u/88575063?v=4',
    createTime: '2024-03-29 15:55:20',
  },
  {
    id: 3,
    type: 'SINGLE',
    name: null,
    avatarUrl: null,
    createTime: '2024-03-30 01:20:18',
  },
]

export const user0ChatChannels: Array<IChatChannel> = [
  {
    chatroom: existingChatrooms[0],
    latestMessage: null,
    joinTime: '2024-03-29 15:55:52',
    latestVisitTime: '2024-05-06 01:38:02',
    unreadMessageCount: 0,
    onlineUserIds: [],
  },
  {
    chatroom: existingChatrooms[1],
    latestMessage: null,
    joinTime: '2024-03-29 15:56:09',
    latestVisitTime: '2024-05-06 01:38:02',
    unreadMessageCount: 0,
    onlineUserIds: [],
  },
  {
    chatroom: existingChatrooms[2],
    latestMessage: null,
    joinTime: '2024-03-30 01:20:34',
    latestVisitTime: '2024-05-06 01:38:02',
    unreadMessageCount: 0,
    onlineUserIds: [],
  },
];

export const userChatrooms: Array<ClientUserChatroom> = [
  {
    userId: 1,
    chatroomId: 1,
    joinTime: '2024-03-29 15:55:52',
    latestVisitTime: '2024-05-06 01:38:02',
  },
  {
    userId: 1,
    chatroomId: 2,
    joinTime: '2024-03-29 15:56:09',
    latestVisitTime: '2024-05-06 01:38:02',
  },
  {
    userId: 1,
    chatroomId: 3,
    joinTime: '2024-03-30 01:20:34',
    latestVisitTime: '2024-05-06 01:38:02',
  },
  {
    userId: 2,
    chatroomId: 1,
    joinTime: '2024-03-29 15:55:55',
    latestVisitTime: '2024-05-06 01:38:02',
  },
  {
    userId: 2,
    chatroomId: 2,
    joinTime: '2024-03-29 15:56:28',
    latestVisitTime: '2024-05-06 01:38:02',
  },
  {
    userId: 3,
    chatroomId: 2,
    joinTime: '2024-03-29 15:56:32',
    latestVisitTime: '2024-05-06 01:38:02',
  },
  {
    userId: 3,
    chatroomId: 3,
    joinTime: '2024-03-30 01:20:40',
    latestVisitTime: '2024-05-06 01:38:02',
  },
]
