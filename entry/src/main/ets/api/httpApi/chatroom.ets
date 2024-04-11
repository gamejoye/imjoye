import http from '@ohos.net.http'
import { IChatChannel } from '../../common/types/ChatChannel.type'
import { IResponse } from '../../common/types/Response.type'
import HttpHelper from './HttpHelper'

type FetchChatroomSummaryParams = {
  latestVisitTimes: Array<{ id: number, latestVisitTime: string }>;
}

export async function fetchChatroomSummaries(
    params: FetchChatroomSummaryParams
): Promise<IResponse<Array<IChatChannel>>> {
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(apiUrl.get() + 'chatrooms/summaries', {
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