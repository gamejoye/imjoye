import { describe, beforeEach, afterEach, it, expect, beforeAll, afterAll } from '@ohos/hypium'
import RdbHelper from '../../../../../main/ets/common/database/rdb/RdbHelper'
import { CLIENT_CHATROOM, CLIENT_USER_CHATROOM } from '../../../../../main/ets/common/constants/databaseTables'
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { startAbility } from '../../../common/utils/ability'
import { ClientChatroomService } from '../../../../../main/ets/common/database/rdb/ClientChatroom'
import { user0ChatChannels } from '../../mocks/Chatrooms'
import { existingUsers } from '../../mocks/Users'
import { ClientChatroomAdapter } from '../../../../../main/ets/common/utils/adapter'
import { getCurrentDatetime } from '../../../../../main/ets/common/utils/datetime'
import { IChatChannel } from '../../../../../main/ets/common/types/ChatChannel.type'

const delegator = abilityDelegatorRegistry.getAbilityDelegator();

export default function ClientChatroomServiceTest() {
  describe('LocalDatabaseClientChatroomServiceTest', function () {
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
      await RdbHelper.deleteTable(CLIENT_CHATROOM);
      await RdbHelper.deleteTable(CLIENT_USER_CHATROOM);
      done();
    })
    afterAll(async (done) => {
      done();
    })

    it('InsertAndFetchDataCorrectly', 0, async (done) => {
      const user = existingUsers[0];
      await ClientChatroomService.save(user, user0ChatChannels);

      const user0LocalChatChannels = await ClientChatroomService.getChatChannels(user);
      for (const currentExistingChannel of user0ChatChannels) {
        const { chatroom } = currentExistingChannel;
        const channelFromLocal = user0LocalChatChannels.find((channel) => channel.chatroom.id === chatroom.id);
        expect(channelFromLocal).not().assertUndefined();

        const clientChatroomFromLocal = new ClientChatroomAdapter(user, channelFromLocal).getClientChatroom();
        const clientChatroomFromExisting =  new ClientChatroomAdapter(user, currentExistingChannel).getClientChatroom();
        expect(clientChatroomFromLocal).assertDeepEquals(clientChatroomFromExisting);
        expect(channelFromLocal.latestVisitTime).assertEqual(currentExistingChannel.latestVisitTime);
      }
      done();
    })

    it('FetchDataFromDifferentUserCorrectly', 0, async (done) => {
      const user = existingUsers[0];
      await ClientChatroomService.save(user, user0ChatChannels);

      const other = existingUsers[1];
      const otherChannels = await ClientChatroomService.getChatChannels(other);
      expect(otherChannels.length).assertEqual(0);

      const channels = await ClientChatroomService.getChatChannels(user);
      expect(channels.length).assertLarger(0);
      done();
    })

    it('UpdateCorrectly', 0, async (done) => {
      const currentTime = getCurrentDatetime();
      const user0 = existingUsers[0];

      await ClientChatroomService.save(user0, user0ChatChannels);

      const updatedChannel: IChatChannel = {
        ...user0ChatChannels[0],
        latestVisitTime: currentTime,
      };
      await ClientChatroomService.update(user0, updatedChannel);
      const channels = await ClientChatroomService.getChatChannels(user0);
      const channelToBeTested = channels.find((channel) => channel.chatroom.id === updatedChannel.chatroom.id);
      expect(channelToBeTested).not().assertNull();
      expect(channelToBeTested).not().assertUndefined();
      expect(updatedChannel).assertDeepEquals(channelToBeTested);
      expect(channelToBeTested.latestVisitTime).assertEqual(currentTime);
      done();
    })
  })
}
