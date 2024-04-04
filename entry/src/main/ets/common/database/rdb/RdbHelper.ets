import { IRdbHelper } from './interface/RdbHelper.interface';
import relationStore from '@ohos.data.relationalStore';
import { TableColumn } from '../../types/TableColumn.type';
import { CLIENT_CHATROOM } from '../../constants/databaseTables';

class RdbHelper implements IRdbHelper {
  private databaseName: string;
  private store: relationStore.RdbStore = {} as relationStore.RdbStore;
  private config: relationStore.StoreConfig = {  name: '', securityLevel: relationStore.SecurityLevel.S1 } as relationStore.StoreConfig;

  constructor(databaseName: string) {
    this.databaseName = databaseName;
  }

  getDbName(): string {
    return this.databaseName;
  }

  initRdb(context: Context): Promise<IRdbHelper> {
    this.config = {
      name: this.databaseName,
      securityLevel: relationStore.SecurityLevel.S1,
    };
    return new Promise((resolve, reject) => {
      relationStore
        .getRdbStore(context, this.config)
        .then((store) => {
          this.store = store;
          this.createClientChatroomTable();
        })
        .then(() => {
          resolve(this);
        })
        .catch((reason) => {
          reject(reason);
        })
    })
  }

  executeSql(sql: string): Promise<void> {
    console.log(`executeSql: [${sql}]`);
    return this.store.executeSql(sql);
  }

  createTable(tableName: string, columns: Array<TableColumn>): Promise<void> {
    let sql = `CREATE TABLE IF NOT EXISTS ${tableName} (`;
    for(const column of columns) {
      sql = sql + `${column.name} ${column.type}`;
      if(column.length && column.length > 0) sql = sql + `(${column.length})`;
      if(!column.nullable) sql = sql + ` NOT NULL`;
      if(column.primary) sql = sql + ` PRIMARY KEY`;
      if(column.autoincrement) sql = sql + ` AUTOINCREMENT`;
      sql = sql + ', ';
    }
    sql = sql.substring(0, sql.length - 2);
    sql = sql + ')';
    console.log(`execute CreateTable Sql: [${sql}]`);
    return this.store.executeSql(sql).catch(e => console.log('********** createTable错误 : ', JSON.stringify(e)));
  }

  deleteTable(tableName: string): Promise<void> {
    const sql = `DROP TABLE IF EXISTS ${tableName}`;
    console.log(`execute DropTable Sql: [${sql}]`);
    return this.store.executeSql(sql);
  }

  insert(tableName: string, values: Array<relationStore.ValuesBucket>): Promise<Array<number>> {
    console.log(`execute Insert Sql`);
    return Promise
      .all(values.map((value) => this.store.insert(tableName, value)))
      .then((ids) => {
        console.log(`success insert data: ${JSON.stringify(values)}`);
        return ids;
      })
      .catch((err) => {
        console.log(`failed insert data: ${JSON.stringify(err)}`);
        return [];
      });
  }

  update(valueBucket: relationStore.ValuesBucket, rdbPredicate: relationStore.RdbPredicates): Promise<number> {
    console.log(`execute Update Sql [${JSON.stringify(valueBucket)}]`);
    return this.store.update(valueBucket, rdbPredicate);
  }

  query(rdbPredicates: relationStore.RdbPredicates, columns?: Array<string>): Promise<relationStore.ResultSet> {
    console.log(`execute Query Sql`);
    return this.store.query(rdbPredicates, columns);
  }

  queryAll(tableName: string): Promise<relationStore.ResultSet> {
    console.log(`execute QueryAll Sql`);
    return this.store.querySql(`SELECT * FROM ${tableName}`);
  }

  queryBySql(sql: string, bindArgs?: Array<relationStore.ValueType>): Promise<relationStore.ResultSet> {
    console.log(`execute QueryBySql [${sql}]`);
    return this.store.querySql(sql, bindArgs);
  }

  delete(rdbPredicates: relationStore.RdbPredicates): Promise<number> {
    console.log(`execute Delete Sql`);
    return this.store.delete(rdbPredicates);
  }

  transaction(): void {
    console.log(`start transaction`);
    return this.store.beginTransaction();
  }

  commit(): void {
    console.log(`transaction commit`);
    return this.store.commit();
  }

  private createClientChatroomTable(): Promise<void> {
    console.log('create clientchatroom table');
    return this.createTable(CLIENT_CHATROOM, [{
      name: 'id',
      type: 'INTEGER',
      nullable: false,
      primary: true,
      autoincrement: true,
    }, {
      name: 'type',
      type: 'VARCHAR',
      length: 128,
      nullable: false,
    }, {
      name: 'name',
      type: 'VARCHAR',
      length: 1024,
      nullable: false,
    }, {
      name: 'createTime',
      type: 'DATETIME',
      nullable: false,
    }, {
      name: 'latestVisitTime',
      type: 'DATETIME',
      nullable: true,
    }])
  }
}

const rdbHelper = new RdbHelper('imjoye');

export default rdbHelper as RdbHelper;