import http from '@ohos.net.http'
import { IMessage } from '../../common/types/Message.type'
import { IResponse } from '../../common/types/Response.type'
import HttpHelper from './HttpHelper'

type FetchMessagesParams = {
  roomId: number;
}
export async function fetchMessages(
    params: FetchMessagesParams,
): Promise<IResponse<Array<IMessage>>> {
  const { roomId } = params;
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(apiUrl.get() + 'messages?room_id=' + roomId, {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
  });
  return JSON.parse(response.result as string);
}

type CreateMessageParams = {
  content: string;
  userId: number;
  chatroomId: number;
}

export async function createMessage(
    params: CreateMessageParams
): Promise<IResponse<IMessage>> {
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