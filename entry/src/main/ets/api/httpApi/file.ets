import request from '@ohos.request';
import { IResponse } from '../../common/types/Response.type';
import { isSuccess } from '../../common/utils/http';

type IHandlers = {
  onProgress?: (uploadedSize: number, totalSize: number) => void,
  onComplete?: () => void;
}

export function uploadAvatar(path: string, handlers?: IHandlers): Promise<IResponse<string>> {
  const avatars: Array<request.File> = [{
    name: 'file',
    filename: 'file.jpg',
    uri: path,
    type: 'jpg'
  }];
  const apiUrl: SubscribedAbstractProperty<string> = AppStorage.Prop('apiUrl');
  return new Promise<IResponse<string>>((resolve, reject) => {
    // try {
      request.uploadFile(getContext(), {
        url: `${apiUrl.get()}users/avatar/upload`,
        method: 'POST',
        files: avatars,
        header: {
          'Content-Type': 'multipart/form-data'
        },
        data: [],
      }).then((response) => {
        response.on('headerReceive', (headers) => {
          const headerArr = (headers as unknown as string).split('\n');
          for(let i = 0; i < headerArr.length; i++) {
            const headerStr = headerArr[i];
            const index = headerStr.indexOf(':');
            if(index !== -1 && headerStr.substring(0, index).trim() === 'status') {
              const value = headerStr.substring(index + 1).trim();
              const status: IResponse<string> = JSON.parse(value);
              return resolve(status);
            }
          }
        })
        if (handlers && handlers.onProgress) {
          response.on('progress', handlers.onProgress);
        }
      })
  });
}