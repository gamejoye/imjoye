import http from '@ohos.net.http'
import { IResponse } from '../../common/types/Response.type'
import HttpHelper from './HttpHelper'

type LoginRequestBody = {
  email: string;
  password: string;
}

type LoginResponse = {
  id: number;
  token: string;
}

export async function login(
    body: LoginRequestBody
): Promise<IResponse<LoginResponse>> {
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(apiUrl.get() + 'auth/login', {
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