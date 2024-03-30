import { IChatroom } from './Chatroom.type';
import { IUser } from './User.type';

export interface IMessage {
  id: number;
  room: IChatroom;
  from: IUser;
  content: string;
  createTime: string;
}