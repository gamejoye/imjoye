import http from '@ohos.net.http'
import { IChatChannelState } from '../../features/chat/ChatChannel'
type FetchChatroomSummaryParams = {
  latestVisitTimes: Array<{ id: number, latestVisitTime: string }>;
}

export async function fetchChatroomSummaries(
    params: FetchChatroomSummaryParams
): Promise<IChatChannelState[]> {
  const httpRequest = http.createHttp();
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await httpRequest.request(apiUrl.get() + 'chatrooms/summaries', {
    method: http.RequestMethod.POST,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
    // 当使用POST请求时此字段用于传递内容
    extraData: params
  });
  httpRequest.destroy();
  return JSON.parse(response.result as string);
}