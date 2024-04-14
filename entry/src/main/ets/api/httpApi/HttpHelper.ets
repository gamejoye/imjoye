import http from '@ohos.net.http';
import { AUTHENTICATION_TOKEN } from '../../common/constants/userInforPreferences';
import { getUserInfo } from '../../common/utils/userInfoPreference';

class HttpHelper {
  async request(url: string, options: http.HttpRequestOptions) {
    const httpRequest = http.createHttp();
    let headers = options.header;
    if (!headers) headers = {};
    const userInfo = await getUserInfo();
    const token = userInfo[AUTHENTICATION_TOKEN];
    headers['Authorization'] = 'Bearer ' + token;
    options.header = headers;
    const response = await httpRequest.request(url, options);
    httpRequest.destroy();
    return response;
  }
}

const httpHelper = new HttpHelper();
export default httpHelper as HttpHelper;