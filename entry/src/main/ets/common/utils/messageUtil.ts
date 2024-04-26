import { IMessageState } from '../types/MessageState.type';

export function getMessageTemporaryId(messageStates: Array<IMessageState>) {
  let x = -1;
  const usedTemporaryIds: Set<number> = new Set();
  messageStates.forEach((messageState) => {
    if(typeof messageState.message.temporaryId === 'number') {
      usedTemporaryIds.add(messageState.message.temporaryId);
    }
  });
  while (usedTemporaryIds.has(x)) x--;
  return x;
}