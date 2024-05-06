import { describe, expect, it } from '@ohos/hypium'
import {
  ChatChannelAdapter,
  ClientChatroomAdapter,
  ClientUserAdapter
} from '../../../../../main/ets/common/utils/adapter'
import { existingChatrooms, user0ChatChannels, userChatrooms } from '../../mocks/Chatrooms'
import { existingUsers } from '../../mocks/Users'

export default function adapterTest() {
  describe('AdapterTest', function () {

    it('ClientUserAdapterWorkCorrectly', 0, () => {
      const user = existingUsers[0];
      const clientUser = (new ClientUserAdapter(user)).getClientUser();
      expect(clientUser.id).assertEqual(user.id);
      expect(clientUser.username).assertEqual(user.username);
      expect(clientUser.email).assertEqual(user.email);
      expect(clientUser.avatarUrl).assertEqual(user.avatarUrl);
      expect(clientUser.description).assertEqual(user.description);
      expect(clientUser.createTime).assertEqual(user.createTime);
    })

    it('ClientChatroomAdapterWorkCorrectly', 0, () => {
      const user = existingUsers[0];
      const channel = user0ChatChannels[0];
      const adapter = (new ClientChatroomAdapter(user, channel));
      const clientChatroom = adapter.getClientChatroom();
      expect(clientChatroom.id).assertEqual(channel.chatroom.id);
      expect(clientChatroom.type).assertEqual(channel.chatroom.type);
      expect(clientChatroom.avatarUrl).assertEqual(channel.chatroom.avatarUrl);
      expect(clientChatroom.name).assertEqual(channel.chatroom.name);
      expect(clientChatroom.createTime).assertEqual(channel.chatroom.createTime);

      const clientUserChatroom = adapter.getClientUserChatroom();
      expect(clientUserChatroom.userId).assertEqual(user.id);
      expect(clientUserChatroom.chatroomId).assertEqual(channel.chatroom.id);
      expect(clientUserChatroom.joinTime).assertEqual(channel.joinTime);
      expect(clientUserChatroom.latestVisitTime).assertEqual(channel.latestVisitTime);
    })

    it('ChannelAdapterWorkCorrectly', 0, () => {
      const user = existingUsers[0];
      const chatroom = existingChatrooms[0];
      const userChatroom = userChatrooms[0];
      expect(userChatroom.userId).assertEqual(user.id);
      expect(userChatroom.chatroomId).assertEqual(chatroom.id);

      const adapter = (new ChatChannelAdapter(chatroom, userChatroom));
      const channel = adapter.getChatChannel();
      expect(channel.latestVisitTime).assertEqual(userChatroom.latestVisitTime);
      expect(channel.joinTime).assertEqual(userChatroom.joinTime);
      expect(channel.chatroom.id).assertEqual(userChatroom.chatroomId);
      expect(channel.chatroom).assertDeepEquals(chatroom);
    })

    it('ChannelAdapterAndClientChatroomAdapterWorkCorrectly', 0, () => {
      const user = existingUsers[0];
      const channel = user0ChatChannels[0];
      const adapter = (new ClientChatroomAdapter(user, channel));
      const clientChatroom = adapter.getClientChatroom();
      const clientUserChatroom = adapter.getClientUserChatroom();

      const adaptedChannel = (new ChatChannelAdapter(clientChatroom, clientUserChatroom)).getChatChannel();
      expect(adaptedChannel).assertDeepEquals(channel);
    })
  })
}
