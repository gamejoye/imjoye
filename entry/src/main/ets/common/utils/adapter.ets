import { IChatChannel } from '../types/ChatChannel.type';
import { IUser } from '../types/User.type';
import { ClientUser } from '../database/rdb/ClientUser';
import { ClientChatroom } from '../database/rdb/ClientChatroom';
import { ClientUserChatroom } from '../database/rdb/ClientUserChatroom';

export class Adapter {
  private static value: unknown;

  static from<Source>(originData: Source) {
    this.value = originData;
    return this;
  }

  static to<Input, Output>(mapFn: (input: Input) => Output): Output {
    return mapFn(this.value as Input);
  }
}

export class ClientChatroomAdapter {
  private channel: IChatChannel;

  constructor(channel: IChatChannel) {
    this.channel = channel;
  }

  adapt(): ClientChatroom {
    const clientChatroom: ClientChatroom = {
      id: this.channel.chatroom.id,
      type: this.channel.chatroom.type,
      name: this.channel.chatroom.name,
      avatarUrl: this.channel.chatroom.avatarUrl,
      createTime: this.channel.chatroom.createTime,
    }
    return clientChatroom;
  }
}

export class ChatChannelAdapter {
  private chatroom: ClientChatroom;
  private userChatroom: ClientUserChatroom;

  constructor(
    chatroom: ClientChatroom,
    userChatroom: ClientUserChatroom
  ) {
    this.chatroom = chatroom;
    this.userChatroom = userChatroom;
  }

  adapt(): IChatChannel {
    /**
     * TODO
     * 1. rdb获取本地消息
     * 2. rdb获取unreadMessageCount
     */
    const channel: IChatChannel = {
      latestMessage: null,
      latestVisitTime: this.userChatroom.latestVisitTime,
      unreadMessageCount: 0,
      onlineUserIds: [],
      chatroom: {
        id: this.chatroom.id,
        type: this.chatroom.type,
        name: this.chatroom.name,
        avatarUrl: this.chatroom.avatarUrl,
        createTime: this.chatroom.createTime,
      }
    }
    return channel;
  }
}

export class ClientUserAdapter {
  private user: IUser;

  constructor(user: IUser) {
    this.user = user;
  }

  adapt(): ClientUser {
    const clientUser: ClientUser = {
      id: this.user.id,
      username: this.user.username,
      email: this.user.email,
      avatarUrl: this.user.avatarUrl,
      description: this.user.description,
      createTime: this.user.createTime,
    }
    return clientUser;
  }
}