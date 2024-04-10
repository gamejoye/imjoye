import http from '@ohos.net.http';
import { AUTHENTICATION_TOKEN } from '../../common/constants/appStorageKeys';

class HttpHelper {
  async request(url: string, options: http.HttpRequestOptions) {
    const httpRequest = http.createHttp();
    let headers = options.header;
    if (!headers) headers = {};
    headers['Authorization'] = 'Bearer ' + AppStorage.Get<string>(AUTHENTICATION_TOKEN);
    options.header = headers;
    const response = await httpRequest.request(url, options);
    httpRequest.destroy();
    return response;
  }
}

const httpHelper = new HttpHelper();
export default httpHelper as HttpHelper;