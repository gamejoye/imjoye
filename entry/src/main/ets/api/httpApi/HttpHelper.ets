import http from '@ohos.net.http';
import { AUTHENTICATION_TOKEN } from '../../common/constants/appStorageKeys';
import dataPreferences from '@ohos.data.preferences';

class HttpHelper {
  async request(url: string, options: http.HttpRequestOptions) {
    const httpRequest = http.createHttp();
    let headers = options.header;
    if (!headers) headers = {};
    const preferences = dataPreferences.getPreferences(getContext)
    headers['Authorization'] = 'Bearer ' +
    options.header = headers;
    const response = await httpRequest.request(url, options);
    httpRequest.destroy();
    return response;
  }
}

const httpHelper = new HttpHelper();
export default httpHelper as HttpHelper;