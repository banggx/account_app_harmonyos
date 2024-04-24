import relationalStore from '@ohos.data.relationalStore';
import common from '@ohos.app.ability.common';
import { Logger } from './Logger';
import { ColumnType, ColumnInfo } from '../models/account/account';

const DB_FILENAME: string = 'account.db';
class DBUtil {
  rdbStore: relationalStore.RdbStore;

  initDB(context: common.UIAbilityContext): Promise<void> {
    const config: relationalStore.StoreConfig = {
      name: DB_FILENAME,
      securityLevel: relationalStore.SecurityLevel.S1,
    };
    return new Promise<void>((resolve, reject) => {
      relationalStore.getRdbStore(context, config)
        .then(rdbStore => {
          this.rdbStore = rdbStore;
          Logger.debug('rdbStore 初始化完成');
          resolve();
        })
        .catch(err => {
          Logger.debug('rdbStore 初始化异常', err);
          reject(err);
        })
    })
  }

  createTable(createSQL: string): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      this.rdbStore.executeSql(createSQL)
        .then(() => {
          Logger.debug('数据表创建成功', createSQL);
          resolve();
        })
        .catch(err => {
          Logger.debug('数据表创建失败', err);
          reject();
        })
    })
  }

  insert(tableName: string, obj: any, columns: ColumnInfo[]): Promise<number> {
    return new Promise<number>((resolve, reject) => {
      this.rdbStore.insert(tableName, this.buildValueBucket(obj, columns), (err, id) => {
        if (err) {
          Logger.debug('新增数据失败', err)
          reject(err);
        } else {
          Logger.debug('新增数据成功, 新增ID: ', id);
          resolve(id);
        }
      });
    })
  }

  delete(predicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise<number>((resolve, reject) => {
      this.rdbStore.delete(predicates, (err, rows) => {
        if (err) {
          Logger.debug('新增数据失败', err)
          reject(err);
        } else {
          Logger.debug('新增数据成功, 删除行数: ', rows);
          resolve(rows);
        }
      });
    })
  }

  update(predicates: relationalStore.RdbPredicates, obj: any, columns: ColumnInfo[]): Promise<number> {
    return new Promise<number>((resolve, reject) => {
      this.rdbStore.update(this.buildValueBucket(obj, columns), predicates, (err, rows) => {
        if (err) {
          Logger.debug('更新数据失败', err)
          reject(err);
        } else {
          Logger.debug('更新数据成功, 更新行数: ', rows);
          resolve(rows);
        }
      });
    })
  }

  queryForList<T>(predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<T[]> {
    return new Promise<T[]>((resolve, reject) => {
      this.rdbStore.query(predicates, columns.map(info => info.columnName), (err, result) => {
        if (err) {
          Logger.debug('查询数据失败', err)
          reject(err);
        } else {
          Logger.debug('查询数据成功, 查询总数: ', result.rowCount);
          resolve(this.parseResultSet<T>(result, columns));
        }
      });
    })
  }

  buildValueBucket(obj: any, columns: ColumnInfo[]): relationalStore.ValuesBucket {
    const value = {};
    columns.forEach(info => {
      const val = obj[info.name];
      if (val !== undefined) {
        value[info.columnName] = val;
      }
    });
    return value;
  }

  parseResultSet<T>(result: relationalStore.ResultSet, columns: ColumnInfo[]): T[] {
    const arr = [];
    if (result.rowCount <= 0) {
      return arr;
    }
    while (!result.isAtLastRow) {
      result.goToNextRow();
      const obj = {};
      columns.forEach(info => {
        let val = null;
        switch (info.type) {
          case ColumnType.LONG:
            val = result.getLong(result.getColumnIndex(info.columnName));
            break;
          case ColumnType.DOUBLE:
            val = result.getDouble(result.getColumnIndex(info.columnName));
            break;
          case ColumnType.STRING:
            val = result.getString(result.getColumnIndex(info.columnName));
            break;
          case ColumnType.BLOB:
            val = result.getBlob(result.getColumnIndex(info.columnName));
            break;
        }
        obj[info.name] = val;
      })
      arr.push(obj);
    }
    return arr;
  }
}

export default new DBUtil();