export class ClientChatroom {
  id: number;
  type: 'SINGLE' | 'MULTIPLE';
  avatarUrl: string | null;
  name: string;
  createTime: string;
}