import { IMessage } from './Message.type';

export interface  IMessageState {
  status: 'loading' | 'success' | 'fail';
  message: IMessage;
}