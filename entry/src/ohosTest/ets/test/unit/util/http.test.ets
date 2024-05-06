import { describe, expect, it } from '@ohos/hypium'
import { isSuccess } from '../../../../../main/ets/common/utils/http'

export default function httpTest() {
  describe('httpUtilTest', function () {

    it('isSuccessWorkCorrectly', 0, (done) => {
      expect(isSuccess(200)).assertTrue();
      expect(isSuccess(201)).assertTrue();

      expect(isSuccess(20)).assertFalse();
      expect(isSuccess(2000)).assertFalse();
      expect(isSuccess(300)).assertFalse();
      done();
    })
  })
}
