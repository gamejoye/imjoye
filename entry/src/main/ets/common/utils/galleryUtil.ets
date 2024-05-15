import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';

type OpenGallery = {
  dataShare: Array<string>;
  internalCache: Array<string>;
}

export  class GalleryUtil {
  context: Context;
  photoPicker: picker.PhotoViewPicker;

  constructor(context, photoPicker: picker.PhotoViewPicker) {
    this.context = context;
    this.photoPicker = photoPicker;
  }

  restoreImage(srcPath: string, imageName: string) {
    const cacheDir = this.context.cacheDir;
    const dstPath = cacheDir + '/' + imageName;
    const srcFile = fs.openSync(srcPath);
    const dstFile = fs.openSync(dstPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.copyFileSync(srcFile.fd, dstFile.fd);
    fs.closeSync(srcFile);
    fs.closeSync(dstFile);
    return 'internal://cache/' + imageName;
  }

  async openGallery(): Promise<OpenGallery> {
    try {
      const PhotoSelectOptions = new picker.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      PhotoSelectOptions.maxSelectNumber = 1;
      const result = await this.photoPicker.select(PhotoSelectOptions);
      const internalCache = result.photoUris.map((uri, i) => {
        const imageName = 'image' + i + '.jpg';
        return this.restoreImage(uri, imageName);
      });
      return {
        internalCache,
        dataShare: result.photoUris,
      };
    } catch (err) {
      console.error('PhotoViewPicker failed with err: ' + err);
    }
  }
}
