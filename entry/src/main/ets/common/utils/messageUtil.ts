export function getMessageTemporaryId(usedTemporaryIds: Array<number>) {
  let x = -1;
  const usedTemporaryIdsSet: Set<number> = new Set();
  usedTemporaryIds.forEach((id) => {
    usedTemporaryIdsSet.add(id);
  });
  while (usedTemporaryIdsSet.has(x)) x--;
  return x;
}