import AccountTypeModel from '../accountType/AccountTypeModel';

export enum AccountExpensesType {
  MEALS,    // 餐食
  MEDICAL,  // 医疗
  TRANSPORT, // 交通
  HOUSE,    // 住房
  TOBACCO,  // 烟酒零食
  STUDY,    // 学习
  COMMUNICATE, // 通讯
  SOCIAL,    // 社交
  INVEST,    // 投资
  SHOPPING,  // 购物
  ENTERTAINMENT,  // 娱乐
  LOAN,      // 外借
  OTHER,    // 其他
}

export enum AccountIncomeType {
  SALARY,  // 工资
  BONUS,   // 奖金
  INTEREST,  // 利息
  INVEST,    // 投资
  PART_TIME, // 兼职
  RED_ENVELOP, // 红包转账
  BORROW,    // 借入
  OTHER,     //  其他
}

export enum AccountType {
  EXPENSES,
  INCOME,
}

export interface AccountInfo {
  type: AccountExpensesType | AccountIncomeType;
  accountType: AccountType;
  amount: number;
  time: number;
  description?: string;
}

// 数据库映射字段
export enum ColumnType {
  LONG,
  DOUBLE,
  STRING,
  BLOB,
}
export interface ColumnInfo {
  name: string;
  columnName: string;
  type: ColumnType;
}

export interface ItemRecordInfo {
  id: number;
  type: number;
  accountType: number;
  description?: string;
  createTime: number;
  amount: number;
  time: number;
  info: AccountTypeModel;
}

export interface GroupByDate {
  time: number;
  expenses: number;
  income: number;
  records: ItemRecordInfo[]
}

export interface StatsByDate {
  time: number;
  expenses: number;
  income: number;
}

export interface StatsByType {
  amount: number;
  count: number;
  info: AccountTypeModel;
}