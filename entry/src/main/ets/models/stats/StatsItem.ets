import { StatsType } from './stats';
import dayjs from 'dayjs';

export interface OptionsItem<T> {
  label: string;
  value: T;
};
export class StatsItem {
  static getStatsTypeDateList(type: StatsType, firstUseTime: number): OptionsItem<number>[] {
    const result: OptionsItem<number>[] = [];
    if (type === StatsType.MONTH) {
      for (let i = 0; i < 12; i++) {
        result.push({ label: `${i + 1}月`, value: i });
      }
    } else {
      const startYear = dayjs(firstUseTime || '2020-01-01').year();
      const currentYear = dayjs().year();
      for (let year = startYear; year <= currentYear; year++) {
        result.push({ label: `${year}年`, value: year })
      }
    }
    return result;
  }
}