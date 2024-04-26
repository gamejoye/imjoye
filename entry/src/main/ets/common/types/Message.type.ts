import { IChatroom } from './Chatroom.type';
import { IUser } from './User.type';

export interface IMessage {
  id: number;
  temporaryId: number;
  chatroom: IChatroom;
  from: IUser;
  content: string;
  createTime: string;
}