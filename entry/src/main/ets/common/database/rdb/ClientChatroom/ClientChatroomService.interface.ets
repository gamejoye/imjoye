import { IChatChannel } from '../../../types/ChatChannel.type';
import { IUser } from '../../../types/User.type';
import { ClientChatroom } from './ClientChatroom';

export interface IClientChatroomService {
  getChatChannels(user: IUser): Promise<Array<IChatChannel>>;

  save(user: IUser, channels: Array<IChatChannel>): Promise<Array<ClientChatroom>>;

  update(user: IUser, channel: IChatChannel): Promise<ClientChatroom>;
}
