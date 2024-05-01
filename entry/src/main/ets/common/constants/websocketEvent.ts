export enum WebSocketEvent {
  CHAT = 1,
  NEW_MESSAGE = 2,
  USER_ONLINE = 3,
  USER_OFFLINE = 4,
  USER_JOIN = 5,
  USER_DEPARTURE = 6,
  MESSAGE_SYN = 7,            // 用户发送消息事件
  MESSAGE_ACK = 8,            // [服务器]对于[用户发送消息事件]的确认
  MESSAGE_ACK_SYN = 9,        // [用户]对于[服务器]发送的于[用户发送消息事件的确认]的回应
  MESSAGE_NOTIFY_SYN = 10,    // 通知用户有新消息
  MESSAGE_NOTIFY_ACK = 11,    // 用户对于有新消息的确认
  PING = 12,                  // 客户端心跳发送包
  PONG = 13,                  // 服务器端心跳响应包
}