import http from '@ohos.net.http'
import HttpHelper from './HttpHelper'
import { paths } from '../../../../../../sdk/api'

export async function login(
    body: paths['/auth/login']['post']['requestBody']['content']['application/json']
): Promise<paths['/auth/login']['post']['responses']['201']['content']['application/json']> {
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

export async function register(
  body: paths['/auth/register']['post']['requestBody']['content']['application/json']
): Promise<paths['/auth/register']['post']['responses']['201']['content']['application/json']> {
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(apiUrl.get() + 'auth/register', {
    method: http.RequestMethod.POST,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    },
    extraData: body
  });
  return JSON.parse(response.result as string);
}