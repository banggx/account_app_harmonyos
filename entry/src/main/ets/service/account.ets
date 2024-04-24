import dayjs from 'dayjs';
import AccountModel from '../models/account/accountModel';
import { AccountInfo, AccountType, GroupByDate, StatsByDate, StatsByType } from '../models/account/account';
import AccountPO from '../models/account/accountPO';
import AccountTypeItem from '../models/accountType/accountType';
import { Logger } from '../utils/Logger';

class AccountService {
  /**
   * 插入一条记录
   * @param info
   * @returns
   */
  insert(info: AccountInfo) {
    const createTime = dayjs().startOf('day').toDate().getTime();
    return AccountModel.insert({ ...info, createTime });
  }

  /**
   * 根据id删除一条记录
   */
  deleteById(id: number) {
    return AccountModel.deleteById(id);
  }

  /**
   * 按月份获取记账记录
   */
  getAccountByMonth(time: string | number) {
    const startMonth = dayjs(time).startOf('month').toDate().getTime();
    const endMonth = dayjs(time).endOf('month').toDate().getTime();
    return AccountModel.queryByDateRange(startMonth, endMonth);
  }

  /**
   * 按年份获取账单记录
   */
  getAccountByYear(time: string | number) {
    const startMonth = dayjs(time).startOf('year').toDate().getTime();
    const endMonth = dayjs(time).endOf('year').toDate().getTime();
    return AccountModel.queryByDateRange(startMonth, endMonth);
  }

  /**
   * 查询指定日期范围内收入/支出的账单数据
   */
  getRangeAccountByType(startTime: number, endTime: number, type: AccountType) {
    return AccountModel.queryRangeAndType(startTime, endTime, type);
  }

  groupByDate(records: AccountPO[]): GroupByDate[] {
    const groupRes = records.reduce<Record<number, GroupByDate>>((map, item) => {
      const dateTime = item.time;
      if (!map[dateTime]) {
        map[dateTime] = {
          time: dateTime,
          expenses: 0,
          income: 0,
          records: []
        }
      }
      const { type, accountType, amount } = item;
      if (accountType === AccountType.EXPENSES) {
        map[dateTime].expenses += amount;
      } else {
        map[dateTime].income += amount;
      }
      const typeInfo = AccountTypeItem.getById(type, accountType);
      map[dateTime].records.push({
        ...item,
        info: typeInfo
      } as any)
      return map;
    }, {});
    return Object.values(groupRes).sort((a, b) => {
      return b.time - a.time
    });
  }

  statsConsume(records: AccountPO[]) {
    let expenses = 0;
    let income = 0;
    records.forEach(record => {
      if (record.accountType === AccountType.EXPENSES) {
        expenses += record.amount;
      } else {
        income += record.amount;
      }
    });
    return {
      expenses,
      income
    }
  }

  /**
   * 按日期统计消费
   */
  statsConsumeByDate(records: AccountPO[]) {
    const groupRes = records.reduce<Record<number, StatsByDate>>((map, item) => {
      const dateTime = item.time;
      if (!map[dateTime]) {
        map[dateTime] = {
          time: dateTime,
          expenses: 0,
          income: 0,
        }
      }
      const { accountType, amount } = item;
      if (accountType === AccountType.EXPENSES) {
        map[dateTime].expenses += amount;
      } else {
        map[dateTime].income += amount;
      }
      return map;
    }, {});
    const statsList = Object.values(groupRes).sort((a, b) => {
      return b.time - a.time
    })
    let totalExpenses = 0;
    let totalIncome = 0;
    statsList.forEach(item => {
      totalExpenses += item.expenses;
      totalIncome += item.income;
    })
    return {
      expenses: totalExpenses,
      income: totalIncome,
      data: {
        expenses: statsList.filter(item => item.expenses),
        income: statsList.filter(item => item.income),
      }
    }
  }

  /**
   * 按类型统计消费
   */
  statsConsumeByType(records: AccountPO[]) {
    const expensesStats: Record<number, StatsByType> = {};
    const incomeStats: Record<number, StatsByType> = {};
    records.forEach((item) => {
      const activeStats = item.accountType === AccountType.EXPENSES ? expensesStats : incomeStats;
      let current: StatsByType = activeStats[item.type];
      if (!current) {
        current = {
          count: 1,
          amount: item.amount,
          info: AccountTypeItem.getById(item.type, item.accountType)
        }
      } else {
        current.amount += item.amount;
        current.count += 1;
      }
      activeStats[item.type] = current;
    });
    const totalExpenses = Object.values(expensesStats).reduce((total, item) => total + item.amount, 0);
    const totalIncome = Object.values(incomeStats).reduce((total, item) => total + item.amount, 0);

    return {
      expenses: totalExpenses,
      income: totalIncome,
      data: {
        expenses: Object.values(expensesStats),
        income: Object.values(incomeStats),
      }
    }
  }

  /**
   * 按月份统计消费
   */
  statsConsumeByMonth(records: AccountPO[]) {
    const groupRes = records.reduce<Record<number, StatsByDate>>((map, item) => {
      const month = dayjs(item.time).get('month');
      if (!map[month]) {
        map[month] = {
          time: dayjs(item.time).startOf('month').valueOf(),
          expenses: 0,
          income: 0,
        }
      }
      const { accountType, amount } = item;
      if (accountType === AccountType.EXPENSES) {
        map[month].expenses += amount;
      } else {
        map[month].income += amount;
      }
      return map;
    }, {});
    const statsList = Object.values(groupRes).sort((a, b) => {
      return b.time - a.time
    })
    let totalExpenses = 0;
    let totalIncome = 0;
    statsList.forEach(item => {
      totalExpenses += item.expenses;
      totalIncome += item.income;
    });
    return {
      expenses: totalExpenses,
      income: totalIncome,
      data: {
        expenses: statsList.filter(item => item.expenses),
        income: statsList.filter(item => item.income),
      }
    }
  }
}

export default new AccountService();