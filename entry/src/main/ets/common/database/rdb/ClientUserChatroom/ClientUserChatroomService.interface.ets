import { ClientUserChatroom } from './ClientUserChatroom';

export interface IClientUserChatroomService {
  getByUserIdAndChatroomId(userId: number, chatroomId: number): Promise<ClientUserChatroom>;

  save(userChatroom: ClientUserChatroom): Promise<void>;
}