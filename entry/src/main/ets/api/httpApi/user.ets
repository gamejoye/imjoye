import http from '@ohos.net.http'
import HttpHelper from './HttpHelper';
import { IUser } from '../../common/types/User.type';
import { IResponse } from '../../common/types/Response.type';
import { IFriendInfo } from '../../common/types/FriendInfo.type';
import { paths } from '../../../../../../sdk/api'

export async function fetchUser(
  path: paths['/users/{id}']['get']['parameters']['path'],
): Promise<IResponse<IUser>> {
  const id = path.id;
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(`${apiUrl.get()}users/${id}/`, {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    }
  });
  return JSON.parse(response.result as string);
}

export async function fetchFriends(
  path: paths['/users/{id}/friends']['get']['parameters']['path'],
): Promise<IResponse<Array<IUser>>> {
  const id = path.id;
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(`${apiUrl.get()}users/${id}/friends`, {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    }
  });
  return JSON.parse(response.result as string);
}

export async function fetchFriendInfo(
  path: paths['/users/{id}/friends/{friendId}']['get']['parameters']['path'],
): Promise<IResponse<IFriendInfo>> {
  const { id, friendId } = path;
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  const response = await HttpHelper.request(`${apiUrl.get()}users/${id}/friends/${friendId}`, {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json',
      expectDataType: http.HttpDataType.STRING,
    }
  });
  return JSON.parse(response.result as string);
}