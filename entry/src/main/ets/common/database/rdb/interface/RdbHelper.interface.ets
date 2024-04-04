import relationStore from '@ohos.data.relationalStore';
import { TableColumn } from '../../../types/TableColumn.type';

export interface IRdbHelper {
  getDbName(): string;

  initRdb(context: Context): Promise<IRdbHelper>;

  executeSql(sql: string): Promise<void>;

  createTable(tableName: string, columns: Array<TableColumn>): Promise<void>;

  deleteTable(tableName: string): Promise<void>;

  insert(tableName: string, values: Array<relationStore.ValuesBucket>): Promise<Array<number>>;

  update(value: relationStore.ValuesBucket, rdbPredicates: relationStore.RdbPredicates): Promise<number>;

  query(rdbPredicates: relationStore.RdbPredicates, columns?: Array<string>): Promise<relationStore.ResultSet>;

  queryAll(tableName: string): Promise<relationStore.ResultSet>;

  queryBySql(sql: string, bindArgs?: Array<relationStore.ValueType>): Promise<relationStore.ResultSet>;

  delete(rdbPredicates: relationStore.RdbPredicates): Promise<number>;
}