export class TableColumn {
  name: string;
  type: string;
  length?: number;
  nullable?: boolean;
  primary?: boolean;
  autoincrement?: boolean;

  constructor(name: string, type: string, length?: number, nullable?: boolean,
              primary?: boolean, autoincrement?: boolean) {
    this.name = name;
    this.type = type;
    this.primary = primary;
    this.length = length;
    this.nullable = nullable;
    this.autoincrement = autoincrement;
  }
}