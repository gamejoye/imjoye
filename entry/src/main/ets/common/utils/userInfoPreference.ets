import dataPreferences from '@ohos.data.preferences';
import { AUTHENTICATION_TOKEN, USER_ID } from '../constants/userInforPreferences';

export interface IUserInfoPreference {
  [AUTHENTICATION_TOKEN]: string;
  [USER_ID]: number;
}


class UserInfoPreferenceUtil {
  userInfo: string;

  constructor() {
    this.userInfo = 'userInfo';
  }

  async getUserInfo(context: Context): Promise<IUserInfoPreference> {
    const preferences = await dataPreferences.getPreferences(context, 'userInfo');
    const userInfo: IUserInfoPreference = {
      authenticatedToken: await preferences.get(AUTHENTICATION_TOKEN, '') as string,
      userId: await preferences.get(USER_ID, -1) as number,
    }
    return userInfo;
  }

  async storeUserInfo(context: Context, { authenticatedToken, userId }: IUserInfoPreference) {
    const preferences = await dataPreferences.getPreferences(context, 'userInfo');
    preferences.put(AUTHENTICATION_TOKEN, authenticatedToken);
    preferences.put(USER_ID, userId);
    preferences.flush();
  }

  async deleteUserInfo(context: Context) {
    await dataPreferences.deletePreferences(context, 'userInfo');
  }
}


const util = new UserInfoPreferenceUtil();

export {
  util as UserInfoPreferenceUtil
}
