import galleryUtilTest from './unit/util/galleryUtil.test'
import configUtilTest from './unit/util/configUtil.test'
import ClientChatroomServiceTest from './unit/database/ClientChatroomService.test'
import ClientUserServiceTest from './unit/database/ClientUserService.test'
import adapterTest from './unit/util/adapter.test'
import httpTest from './unit/util/http.test'
import messageUtilTest from './unit/util/messageUtil.test'
import userInfoPreferenceUtilTest from './unit/util/userInfoPreference.test'

export default function testsuite() {
  ClientUserServiceTest()
  ClientChatroomServiceTest()
  messageUtilTest()
  httpTest()
  adapterTest()
  userInfoPreferenceUtilTest()
  configUtilTest()
  galleryUtilTest()
}