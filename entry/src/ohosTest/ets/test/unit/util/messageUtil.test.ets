import { describe, expect, it } from '@ohos/hypium'
import { getMessageTemporaryId } from '../../../../../main/ets/common/utils/messageUtil'

export default function messageUtilTest() {
  describe('messageUtilTest', function () {

    it('getMessageTemporaryIdCorrectly', 0, (done) => {
      expect(getMessageTemporaryId([])).assertEqual(-1);
      expect(getMessageTemporaryId([-1])).assertEqual(-2);
      expect(getMessageTemporaryId([-1, -2])).assertEqual(-3);
      expect(getMessageTemporaryId([-1, -2, -3])).assertEqual(-4);
      expect(getMessageTemporaryId([-1, -2, -3, -4])).assertEqual(-5);

      expect(getMessageTemporaryId([-1, -3])).assertEqual(-2);
      expect(getMessageTemporaryId([-1, -2, -4, -5 -6, -7])).assertEqual(-3);
      expect(getMessageTemporaryId([-2, -4, -5 -6, -7])).assertEqual(-1);
      done();
    })
  })
}
