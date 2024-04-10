import http from '@ohos.net.http'
import HttpHelper from './HttpHelper';
import { IUser } from '../../common/types/User.type';
import { IResponse } from '../../common/types/Response.type';

export async function fetchUser(id: number): Promise<IResponse<IUser>> {
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(apiUrl.get() + 'users/' + id, {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    }
  });
  return JSON.parse(response.result as string);
}