import { describe, beforeEach, afterEach, it, expect, beforeAll, afterAll } from '@ohos/hypium'
import RdbHelper from '../../../../../main/ets/common/database/rdb/RdbHelper'
import { CLIENT_USER, } from '../../../../../main/ets/common/constants/databaseTables'
import { ClientUserService } from '../../../../../main/ets/common/database/rdb/ClientUser/ClientUserService'
import { existingUsers } from '../../mocks/Users'
import { ClientUserAdapter } from '../../../../../main/ets/common/utils/adapter'
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { startAbility } from '../../../common/utils/ability'

const delegator = abilityDelegatorRegistry.getAbilityDelegator();

export default function ClientUserServiceTest() {
  describe('LocalDatabaseClientUserServiceTest', function () {
    beforeAll(async (done) => {
      await startAbility(delegator, 'com.gamejoye.imjoye', 'EntryAbility');
      done();
    })
    beforeEach(async (done) => {
      const context = (await delegator.getCurrentTopAbility()).context;
      await RdbHelper.initRdb(context);
      done();
    })
    afterEach(async (done) => {
      await RdbHelper.deleteTable(CLIENT_USER);
      done();
    })
    afterAll(async (done) => {
      done();
    })
    it('InsertAndFetchDataCorrectly', 0, async (done) => {
      for (const user of existingUsers) {
        await ClientUserService.save(user);
      }
      for (const user of existingUsers) {
        const clientUser = await ClientUserService.getById(user.id);
        expect(clientUser).not().assertNull();
        expect(clientUser).not().assertUndefined();
        const adaptedUser = new ClientUserAdapter(user).getClientUser();
        expect(adaptedUser).assertDeepEquals(user);
      }
      done();
    })
  })
}
