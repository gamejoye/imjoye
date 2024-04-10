import http from '@ohos.net.http';

export interface IResponse<T> {
  statusCode: http.ResponseCode;
  data: T;
  message: string;
}
