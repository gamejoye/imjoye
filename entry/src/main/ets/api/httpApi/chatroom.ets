import http from '@ohos.net.http'
import HttpHelper from './HttpHelper'
import { paths } from '../../../../../../sdk/api'

export async function fetchChatroomSummaries(
  body: paths['/chatrooms/summaries']['post']['requestBody']['content']['application/json'],
): Promise<paths['/chatrooms/summaries']['post']['responses']['200']['content']['application/json']> {
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(`${apiUrl.get()}chatrooms/summaries`, {
    method: http.RequestMethod.POST,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
    // 当使用POST请求时此字段用于传递内容
    extraData: body
  });
  return JSON.parse(response.result as string);
}

export async function fetchChatroomByFriendId(
  query: paths['/chatrooms']['get']['parameters']['query'],
): Promise<paths['/chatrooms']['get']['responses']['200']['content']['application/json']> {
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(`${apiUrl.get()}chatrooms?friend_id=${query.friend_id}`, {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
  });
  return JSON.parse(response.result as string);
}

export async function fetchChatroomSummary(
  path: paths['/chatrooms/summaries/{chatroomId}']['get']['parameters']['path'],
  query: paths['/chatrooms/summaries/{chatroomId}']['get']['parameters']['query'],
): Promise<paths['/chatrooms/summaries/{chatroomId}']['get']['responses']['200']['content']['application/json']> {
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const timestamp= query.timestamp;
  const chatroomId = path.chatroomId;
  const encodedTimestamp = encodeURIComponent(timestamp);
  const response = await HttpHelper.request(`${apiUrl.get()}chatrooms/summaries/${chatroomId}?timestamp=${encodedTimestamp}`, {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
  });
  return JSON.parse(response.result as string);
}
