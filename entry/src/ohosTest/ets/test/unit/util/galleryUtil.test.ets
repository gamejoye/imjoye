import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import picker from '@ohos.file.picker';
import { GalleryUtil } from '../../../../../main/ets/common/utils/galleryUtil';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();

export default function galleryUtilTest() {
  describe('galleryUtilTest', () => {
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
    it('openGalleryWorkCorrectly', 0, async (done) => {
      /**
       * 测试需要验证的一些常量
       */
      const context = (await delegator.getCurrentTopAbility()).context;
      const srcPhotoUri = 'srcPhotoUri';
      const dstPhotoUri = 'dstPhotoUri';

      /**
       * mock select函数
       */
      const photoPickerMocker = new MockKit();
      const photoPicker = new picker.PhotoViewPicker();
      const mockedSelect = photoPickerMocker.mockFunc(photoPicker, photoPicker.select);
      when(mockedSelect)(ArgumentMatchers.any).afterReturn({
        photoUris: [srcPhotoUri],
        isOriginalPhoto: true,
      });

      /**
       * mock restoreImage
       */
      const utilMocker = new MockKit();
      const util = (new GalleryUtil(context, photoPicker));
      const mockedRestoreImage = utilMocker.mockFunc(util, util.restoreImage);
      when(mockedRestoreImage)(srcPhotoUri).afterReturn(dstPhotoUri);

      /**
       * assert
       */
      const { dataShare, internalCache } = await util.openGallery();
      expect(dataShare.length).assertEqual(internalCache.length);
      expect(dataShare.length).assertEqual(1);
      expect(dataShare[0]).assertEqual(srcPhotoUri);
      expect(internalCache[0]).assertEqual(dstPhotoUri);

      const options = new picker.PhotoSelectOptions();
      options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      options.maxSelectNumber = 1;
      photoPickerMocker.verify('photoPickerSelect', [options]).once();
      done();
    })
  })
}