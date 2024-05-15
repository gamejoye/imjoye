import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import ConfigUtil from '../../../../../main/ets/common/utils/configUtil'

const delegator = abilityDelegatorRegistry.getAbilityDelegator();

export default function configUtilTest() {
  describe('configUtilTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('configEnvironmentCorrectly', 0, async () => {
      const context = (await delegator.getCurrentTopAbility()).context;
      const util = new ConfigUtil(context);
      const config = await util.getConfig();
      expect(config.apiUrl).not().assertNull();
      expect(config.apiUrl).not().assertUndefined();
      expect(config.webSocketUrl).not().assertNull();
      expect(config.webSocketUrl).not().assertUndefined();

      util.loadEnvironment(config);
      const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
      const webSocketUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('webSocketUrl');
      expect(apiUrl.get()).assertEqual(config.apiUrl);
      expect(webSocketUrl.get()).assertEqual(config.webSocketUrl);
    })
  })
}