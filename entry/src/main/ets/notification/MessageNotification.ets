import notificationManager from '@ohos.notificationManager';
import wantAgent from '@ohos.app.ability.wantAgent';
import { IMessage } from '../common/types/Message.type';

class MessageNotificationManager {
  async publish(message: IMessage): Promise<void> {
    console.log("PUBLISH: ", JSON.stringify(message));
    const wantAgentInfo = {
      wants: [
        {
          bundleName: 'com.gamejoye.imjoye',
          abilityName: 'EntryAbility',
          parameters: {
            chatroom: message.chatroom
          }
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };
    const wantAgentObj = await wantAgent.getWantAgent(wantAgentInfo);
    notificationManager.publish({
      id: message.id,
      content: {
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: message.from.username,
          text: message.content,
          additionalText: '你好， 这是additionalText',
        }
      },
      wantAgent: wantAgentObj,
    });
  }
}

const manager = new MessageNotificationManager();
export {
  manager as MessageNotificationManager,
}
