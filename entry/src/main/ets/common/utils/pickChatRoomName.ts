import { ChatroomType } from '../constants/chatroomType';
import { IChatroom } from '../types/Chatroom.type';
import { IUser } from '../types/User.type';
export function pickChatroomName(chatroom: IChatroom) {
  if(chatroom.type === ChatroomType.MULTIPLE) return chatroom.name;
  const { username } = AppStorage.Get<IUser>('user');
  const roomName = chatroom.name;
  if(roomName.startsWith(username)) return roomName.substring(username.length + 1);
  return roomName.substring(0, roomName.length - username.length - 1);
}