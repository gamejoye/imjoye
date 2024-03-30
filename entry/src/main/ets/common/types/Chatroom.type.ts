export interface IChatroom {
  id: number;
  type: 'SINGLE' | 'MULTIPLE';
  name: string;
  createTime: string;
}
