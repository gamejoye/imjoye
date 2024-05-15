import { describe, expect, it } from '@ohos/hypium'
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { USER_ID, AUTHENTICATION_TOKEN } from '../../../../../main/ets/common/constants/userInforPreferences'
import { UserInfoPreferenceUtil, IUserInfoPreference } from '../../../../../main/ets/common/utils/userInfoPreference'

const delegator = abilityDelegatorRegistry.getAbilityDelegator();

export default function userInfoPreferenceUtilTest() {
  describe('userInfoPreferenceUtilTest', function () {

    it('utilShouldWorkCorrectly', 0, async (done) => {
      const context = (await delegator.getCurrentTopAbility()).context;

      let userInfo = await UserInfoPreferenceUtil.getUserInfo(context);
      expect(userInfo[AUTHENTICATION_TOKEN]).assertEqual('');
      expect(userInfo[USER_ID]).assertEqual(-1);

      const token = 'token should be stored';
      const userId = 777;
      const userInfoToStored: IUserInfoPreference = {
        [AUTHENTICATION_TOKEN]: token,
        [USER_ID]: userId,
      };

      await UserInfoPreferenceUtil.storeUserInfo(context, userInfoToStored);
      userInfo = await UserInfoPreferenceUtil.getUserInfo(context);
      expect(userInfo[AUTHENTICATION_TOKEN]).assertEqual(token);
      expect(userInfo[USER_ID]).assertEqual(userId);

      await UserInfoPreferenceUtil.deleteUserInfo(context);
      userInfo = await UserInfoPreferenceUtil.getUserInfo(context);
      expect(userInfo[AUTHENTICATION_TOKEN]).assertEqual('');
      expect(userInfo[USER_ID]).assertEqual(-1);

      done();
    })
  })
}
