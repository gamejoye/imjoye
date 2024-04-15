import http from '@ohos.net.http'
import { IChatChannel } from '../../common/types/ChatChannel.type'
import { IChatroom } from '../../common/types/Chatroom.type'
import { IResponse } from '../../common/types/Response.type'
import HttpHelper from './HttpHelper'

type FetchChatroomSummariesParams = {
  latestVisitTimes: Array<{ id: number, latestVisitTime: string }>;
}

export async function fetchChatroomSummaries(
    params: FetchChatroomSummariesParams
): Promise<IResponse<Array<IChatChannel>>> {
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(`${apiUrl.get()}chatrooms/summaries`, {
    method: http.RequestMethod.POST,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
    // 当使用POST请求时此字段用于传递内容
    extraData: params
  });
  return JSON.parse(response.result as string);
}

type FetchChatroomByFriendIdParams = {
 friendId: number
}

export async function fetchChatroomByFriendId(
  params: FetchChatroomByFriendIdParams,
): Promise<IResponse<IChatroom>> {
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(`${apiUrl.get()}chatrooms?friend_id=${params.friendId}`, {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
    extraData: params
  });
  return JSON.parse(response.result as string);
}