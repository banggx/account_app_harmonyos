
import relationalStore from '@ohos.data.relationalStore';
import { AccountType, ColumnInfo, ColumnType } from './account';
import AccountPO from './accountPO';
import DBUtil from '../../utils/DBUtil';

/**
 * 数据库建表语句
 */
const CREATE_TABLE_SQL: string = `
  CREATE TABLE IF NOT EXISTS account (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type INTEGER NOT NULL,
    account_type INTEGER NOT NULL,
    amount DOUBLE NOT NULL,
    create_time INTEGER NOT NULL,
    description STRING,
    time INTEGER NOT NULL
  )`;
const COLUMNS: ColumnInfo[] = [
  { name: 'id', columnName: 'id', type: ColumnType.LONG },
  { name: 'type', columnName: 'type', type: ColumnType.LONG },
  { name: 'accountType', columnName: 'account_type', type: ColumnType.LONG },
  { name: 'amount', columnName: 'amount', type: ColumnType.DOUBLE },
  { name: 'createTime', columnName: 'create_time', type: ColumnType.LONG },
  { name: 'time', columnName: 'time', type: ColumnType.LONG },
  { name: 'description', columnName: 'description', type: ColumnType.STRING },
];
const TABLE_NAME = 'account';
const ID_COLUMN = 'id';
const DATE_COLUMN = 'time';
const TYPE_COLUMN = 'account_type';

class AccountModel {
  getCreateTableSql(): string {
    return CREATE_TABLE_SQL;
  }

  insert(record: AccountPO) {
    return DBUtil.insert(TABLE_NAME, record, COLUMNS);
  }

  deleteById(id: number) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
    predicates.equalTo(ID_COLUMN, id);
    return DBUtil.delete(predicates);
  }

  queryByDateRange(startDate: number, endDate: number) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
    predicates
      .greaterThanOrEqualTo(DATE_COLUMN, startDate)
      .and()
      .lessThanOrEqualTo(DATE_COLUMN, endDate);
    return DBUtil.queryForList<AccountPO>(predicates, COLUMNS);
  }

  queryRangeAndType(startDate: number, endDate: number, type: AccountType) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
    predicates
      .greaterThanOrEqualTo(DATE_COLUMN, startDate)
      .and()
      .lessThanOrEqualTo(DATE_COLUMN, endDate)
      .and()
      .equalTo(TYPE_COLUMN, type);
    return DBUtil.queryForList<AccountPO>(predicates, COLUMNS);
  }

  update(id: number, record: AccountPO) {
    const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
    predicates.equalTo(ID_COLUMN, id);
    return DBUtil.update(predicates, record, COLUMNS);
  }
}

const accountModel = new AccountModel();

export default accountModel as AccountModel;