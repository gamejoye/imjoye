import { IChatRoom } from './ChatRoom';
import { IUser } from './User';

export interface IMessage {
  id: number;
  room: IChatRoom;
  from: IUser;
  content: string;
  createTime: string;
}