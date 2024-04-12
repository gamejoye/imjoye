import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { AUTHENTICATION_TOKEN, USER_ID } from '../constants/userInforPreferences';

export interface IUserInfoPreference {
  [AUTHENTICATION_TOKEN]: string;
  [USER_ID]: number;
}

export async function getUserInfo(): Promise<IUserInfoPreference> {
  const preferences = await dataPreferences.getPreferences(getContext() as common.UIAbilityContext, 'userInfo');
  const userInfo: IUserInfoPreference = {
    authenticatedToken: await preferences.get(AUTHENTICATION_TOKEN, '') as string,
    userId: await preferences.get(USER_ID, -1) as number,
  }
  return userInfo;
}

export async function storeUserInfo({ authenticatedToken, userId }: IUserInfoPreference) {
  const preferences = await dataPreferences.getPreferences(getContext() as common.UIAbilityContext, 'userInfo');
  preferences.put(AUTHENTICATION_TOKEN, authenticatedToken);
  preferences.put(USER_ID, userId);
  preferences.flush();
}

export async function deleteUserInfo() {
  await dataPreferences.deletePreferences(getContext() as common.UIAbilityContext, 'userInfo');
}