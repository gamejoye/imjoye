import { IChatRoom } from '../types/ChatRoom';
import { IUser } from '../types/User';
export function pickChatRoomName(chatRoom: IChatRoom) {
  if(chatRoom.type === 'MULTIPLE') return chatRoom.name;
  const { username } = AppStorage.Get<IUser>('user');
  const names = chatRoom.name.split('-');
  return names[0] !== username ? names[0] : names[1];
}