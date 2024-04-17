import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';

type OpenGallery = {
  dataShare: Array<string>;
  internalCache: Array<string>;
}

export async function openGallery(): Promise<OpenGallery> {
  try {
    const photoPicker = new picker.PhotoViewPicker();
    const PhotoSelectOptions = new picker.PhotoSelectOptions();
    PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
    PhotoSelectOptions.maxSelectNumber = 1;
    const result = await photoPicker.select(PhotoSelectOptions);
    const context = getContext(this);
    const cacheDir = context.cacheDir;
    const internalCache = result.photoUris.map((uri, i) => {
      const imageName = 'image' + i + '.jpg';
      const dstPath = cacheDir + '/' + imageName;
      const srcFile = fs.openSync(uri);
      const dstFile = fs.openSync(dstPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.copyFileSync(srcFile.fd, dstFile.fd);
      fs.closeSync(srcFile);
      fs.closeSync(dstFile);
      return 'internal://cache/' +  imageName;
    });
    return {
      internalCache,
      dataShare: result.photoUris,
    };
  } catch (err) {
    console.error('PhotoViewPicker failed with err: ' + err);
  }
}
