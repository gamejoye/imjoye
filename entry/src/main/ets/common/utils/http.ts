import http from '@ohos.net.http';
export function isSuccess(statusCode: http.ResponseCode): boolean {
  return (statusCode + '').startsWith('2');
}