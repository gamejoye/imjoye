import common from '@ohos.app.ability.common';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';

class PermissionRequester {
  async requestMediaPermission(): Promise<boolean> {
    const context = getContext(this) as common.UIAbilityContext;
    const atManager = abilityAccessCtrl.createAtManager();
    const info = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
    if(info && info.appInfo) {
      const result = atManager.verifyAccessTokenSync(info.appInfo.accessTokenId, "ohos.permission.READ_MEDIA");
      if (abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED == result) {
        return true;
      }
    }
    const result = await atManager.requestPermissionsFromUser(context, ['ohos.permission.READ_MEDIA']);
    const accept = result.authResults[0] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
    return accept;
  }
}

const permissionRequester = new PermissionRequester();

export default permissionRequester as PermissionRequester;