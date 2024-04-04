import { IChatChannel } from '../types/ChatChannel.type';
import { IChatroom } from '../types/Chatroom.type';
import { ClientChatroom } from '../views/ClientChatroom';

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
  private value: IChatChannel;

  constructor(chatroom: IChatChannel) {
    this.value = chatroom;
  }

  adapt(): ClientChatroom {
    const clientChatroom: ClientChatroom = {
      id: this.value.chatroom.id,
      type: this.value.chatroom.type,
      name: this.value.chatroom.name,
      createTime: this.value.chatroom.createTime,
      latestVisitTime: this.value.latestVisitTime,
    }
    return clientChatroom;
  }
}