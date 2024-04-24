export interface IChatroom {
  id: number;
  type: 'SINGLE' | 'MULTIPLE';
  name: string;
  avatarUrl: string;
  createTime: string;
}
