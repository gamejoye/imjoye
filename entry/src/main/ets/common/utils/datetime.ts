export const DATETIME_FORMAT = 'YYYY-MM-DD HH:mm:ss';

export function formatDate(date: Date) {
  const year = date.getFullYear();
  // getMonth() 返回的月份从0开始，所以需要+1
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');
  const hours = date.getHours().toString().padStart(2, '0');
  const minutes = date.getMinutes().toString().padStart(2, '0');
  const seconds = date.getSeconds().toString().padStart(2, '0');

  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

export function getCurrentDatetime() {
  return formatDate(new Date());
}
