export class ClientChatroom {
  id: number;
  type: 'SINGLE' | 'MULTIPLE';
  name: string;
  createTime: string;

  latestVisitTime: string;
}