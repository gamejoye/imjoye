export interface IChatRoom {
  id: number;
  type: 'SINGLE' | 'MULTIPLE';
  name: string;
  createTime: string;
}
