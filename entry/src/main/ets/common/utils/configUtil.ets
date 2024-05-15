import bundleManager from '@ohos.bundle.bundleManager';
import util from '@ohos.util';
import { IConfig } from '../types/Config.type';

export default class ConfigUtil {
  context: Context;

  constructor(context: Context) {
    this.context = context;
  }

  async getConfig(): Promise<IConfig> {
    const bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    const provisionType = bundleInfo.appInfo.appProvisionType;
    const rawFile = await this.context.resourceManager.getRawFileContent(`${provisionType}.json`);
    const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    const configStr = textDecoder.decodeWithStream(rawFile, { stream: false });
    const config = JSON.parse(configStr);
    return config;
  }

  loadEnvironment(config: IConfig) {
    Environment.EnvProp('apiUrl', config['apiUrl']);
    Environment.EnvProp('webSocketUrl', config['webSocketUrl']);
  }
}
