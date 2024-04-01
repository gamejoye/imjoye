import http from '@ohos.net.http';
import { IMessage } from '../../common/types/Message.type';

type FetchMessagesParams = {
  roomId: number;
}
export async function fetchMessages(
    params: FetchMessagesParams,
): Promise<Array<IMessage>> {
  const { roomId } = params;
  const httpRequest = http.createHttp();
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await httpRequest.request(apiUrl.get() + 'messages?room_id=' + roomId, {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
  });
  httpRequest.destroy();
  return JSON.parse(response.result as string);
}

type CreateMessageParams = {
  content: string;
  userId: number;
  chatroomId: number;
}

export async function createMessage(
    params: CreateMessageParams
): Promise<IMessage> {
  const httpRequest = http.createHttp();
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await httpRequest.request(apiUrl.get() + 'messages', {
    method: http.RequestMethod.POST,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
    extraData: {
      content: params.content,
      from: {
        id: params.userId,
      },
      chatroom: {
        id: params.chatroomId,
      },
    }
  });
  httpRequest.destroy();
  return JSON.parse(response.result as string);
}