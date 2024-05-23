import http from '@ohos.net.http'
import HttpHelper from './HttpHelper'
import { paths } from '../../../../../../sdk/api'

export async function fetchMessages(
    query: paths['/messages']['get']['parameters']['query'],
): Promise<paths['/messages']['get']['responses']['200']['content']['application/json']> {
  const { room_id } = query;
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(apiUrl.get() + 'messages?room_id=' + room_id, {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
  });
  return JSON.parse(response.result as string);
}

export async function createMessage(
    body: paths['/messages']['post']['requestBody']['content']['application/json']
): Promise<paths['/messages']['post']['responses']['201']['content']['application/json']> {
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(apiUrl.get() + 'messages', {
    method: http.RequestMethod.POST,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
    extraData: body
  });
  return JSON.parse(response.result as string);
}