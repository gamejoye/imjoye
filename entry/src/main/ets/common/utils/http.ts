import http from '@ohos.net.http';
export function isSuccess(statusCode: http.ResponseCode): boolean {
  if ((statusCode + '').length !== 3) return false;
  return (statusCode + '').startsWith('2');
}