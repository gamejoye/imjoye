import http from '@ohos.net.http';
import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { AUTHENTICATION_TOKEN } from '../../common/constants/userInforPreferences';

class HttpHelper {
  async request(url: string, options: http.HttpRequestOptions) {
    const httpRequest = http.createHttp();
    let headers = options.header;
    if (!headers) headers = {};
    const preferences = await dataPreferences.getPreferences(getContext() as common.UIAbilityContext, 'userInfo');
    const token = await preferences.get(AUTHENTICATION_TOKEN, '');
    headers['Authorization'] = 'Bearer ' + token;
    options.header = headers;
    const response = await httpRequest.request(url, options);
    httpRequest.destroy();
    return response;
  }
}

const httpHelper = new HttpHelper();
export default httpHelper as HttpHelper;