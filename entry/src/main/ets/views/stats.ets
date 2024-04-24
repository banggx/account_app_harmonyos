import router from '@ohos.router';
import dayjs from 'dayjs';
import StatsHeader from '../components/stats/StatsHeader';
import StatsDetailHeader from '../components/stats/StatsDetailHeader';
import { StatsType, CategoryType } from '../models/stats/stats';
import { AccountType, GroupByDate, StatsByDate, StatsByType } from '../models/account/account';
import AccountService from '../service/account';

@Extend(Text) function fontBasicStyle(size: number, lineHeight: number, color: ResourceStr) {
  .fontSize(size)
  .fontColor(color)
  .lineHeight(lineHeight)
}

@Component
export default struct Stats {
  @Prop @Watch('statsAccountData') isPageShow: boolean;
  @State @Watch('statsAccountData') statsType: StatsType = StatsType.MONTH;
  @State @Watch('statsAccountData') time: number = dayjs().valueOf();
  @State accountType: AccountType = AccountType.EXPENSES;
  @State accountList: GroupByDate[] = [];
  @State expenses: number = 0;
  @State income: number = 0;
  @State statsData: { expenses: any[], income: any[] } = null;
  categoryType: CategoryType = CategoryType.DATE;

  /**
   * 按日期统计月账单数据
   */
  async statsMonthData() {
    const res = await AccountService.getAccountByMonth(this.time);
    const { expenses, income, data } =
        this.categoryType === CategoryType.DATE
          ? AccountService.statsConsumeByDate(res)
          : AccountService.statsConsumeByType(res);
    this.expenses = expenses;
    this.income = income;
    this.statsData = data;
  }

  async statsYearData() {
    const res = await AccountService.getAccountByYear(this.time);
    const { expenses, income, data } =
        this.categoryType === CategoryType.DATE
        ? AccountService.statsConsumeByMonth(res)
        : AccountService.statsConsumeByType(res);
    this.expenses = expenses;
    this.income = income;
    this.statsData = data;
  }

  async statsAccountData() {
    if (!this.isPageShow) {
      return;
    }
    if (this.statsType === StatsType.MONTH) {
      this.statsMonthData();
    } else {
      this.statsYearData();
    }
  }

  aboutToAppear() {
    this.statsAccountData()
  }

  getRenderRecord() {
    if (!this.statsData) {
      return [];
    }
    if (this.accountType === AccountType.EXPENSES) {
      return this.statsData.expenses;
    } else {
      return this.statsData.income;
    }
  }

  toAccountDetail(time: number) {
    let startTime: number, endTime: number;
    if (this.statsType === StatsType.MONTH) {
      startTime = dayjs(time).startOf('day').valueOf();
      endTime = dayjs(time).endOf('day').valueOf()
    } else {
      startTime = dayjs(time).startOf('month').valueOf();
      endTime = dayjs(time).endOf('month').valueOf();
    }
    router.pushUrl({
      url: 'pages/AccountDetail',
      params: {
        startTime: startTime,
        endTime: endTime,
        accountType: this.accountType,
      }
    })
  }

  @Builder TotalStats() {
    Row() {
      Column({ space: 8 }) {
        Text(this.statsType === StatsType.MONTH ? '本月支出(元)' : '本年支出(元)')
          .fontBasicStyle(12, 14, this.accountType === AccountType.EXPENSES ? $r('app.color.font_1') : $r('app.color.font_2'))
        if (this.expenses) {
          Text('¥ ' + this.expenses.toFixed(2)).fontBasicStyle(24, 30, this.accountType === AccountType.EXPENSES ? $r('app.color.font_1') : $r('app.color.font_2'))
        } else {
          Text($r('app.string.no_expenses')).fontBasicStyle(24, 30, this.accountType === AccountType.EXPENSES ? $r('app.color.font_1') : $r('app.color.font_2'))
        }
      }.layoutWeight(1)
      .onClick(() => {
        this.accountType = AccountType.EXPENSES;
      })
      Column({ space: 8 }) {
        Text(this.statsType === StatsType.MONTH ? '本年收入(元)' : '本年收入(元)')
          .fontBasicStyle(12, 14, this.accountType === AccountType.INCOME ? $r('app.color.font_1') : $r('app.color.font_2'))
        if (this.income) {
          Text('¥ ' + this.income).fontBasicStyle(24, 30, this.accountType === AccountType.INCOME ? $r('app.color.font_1') : $r('app.color.font_2'))
        } else {
          Text($r('app.string.no_income')).fontBasicStyle(24, 30, this.accountType === AccountType.INCOME ? $r('app.color.font_1') : $r('app.color.font_2'))
        }
      }.layoutWeight(1)
      .onClick(() => {
        this.accountType = AccountType.INCOME;
      })
    }.width('100%')
  }

  @Builder DateStatsItem(item: StatsByDate) {
    Row({ space: 20 }) {
      Column({ space: 2 }) {
        Text(dayjs(item.time).format(this.statsType === StatsType.MONTH ? 'DD日' : 'MM月'))
          .fontBasicStyle(16, 22, $r('app.color.font_3'))
          .fontWeight(500)
        Text(dayjs(item.time).format(this.statsType === StatsType.MONTH ? 'YYYY.MM' : 'YYYY'))
          .fontBasicStyle(12, 15, $r('app.color.font_2'))
      }.alignItems(HorizontalAlign.Start)
      Column({ space: 4 }) {
        Text(this.accountType === AccountType.EXPENSES ? '-' + item.expenses.toFixed(2) : item.income.toFixed(2))
          .fontBasicStyle(16, 20, $r('app.color.font_3'))
          .fontWeight(500)
        Row({ space: 8 }) {
          Text(this.accountType === AccountType.EXPENSES ? $r('app.string.all_expenses') : $r('app.string.all_income'))
            .fontBasicStyle(12, 15, this.accountType === AccountType.EXPENSES ? $r('app.color.green') : $r('app.color.orange'))
          Text(this.accountType === AccountType.EXPENSES ? this.expenses.toFixed(2) : this.income.toFixed(2))
            .fontBasicStyle(12, 15, $r('app.color.font_2'))
        }
      }.alignItems(HorizontalAlign.Start).layoutWeight(1)
      Image($r('app.media.arrow_left'))
        .rotate({ angle: 180 })
        .height(14)
        .objectFit(ImageFit.Contain)
        .fillColor($r('app.color.font_2'))
    }.width('100%')
    .padding({ top: 10, bottom: 10 })
    .onClick(() => this.toAccountDetail(item.time))
  }

  @Builder TypeStatsItem(item: StatsByType) {
    Row({ space: 8 }) {
      Column() {
        Image(item.info.icon)
          .height(14)
          .objectFit(ImageFit.Contain)
          .fillColor($r('app.color.white'))
      }.width(30)
      .height(30)
      .backgroundColor(item.info.activeColor)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .borderRadius(15)
      Column({ space: 4 }) {
        Row({ space: 8 }) {
          Text(item.info.name)
            .fontBasicStyle(16, 22, $r('app.color.font_3'))
            .fontWeight(500)
          Text(item.count + '笔')
            .fontBasicStyle(12, 15, $r('app.color.font_2'))
          Blank()
          Text(item.amount.toFixed(2))
            .fontBasicStyle(16, 22, $r('app.color.font_1'))
            .fontWeight(500)
        }.width('100%')
        Progress({
          value: item.amount / (this.accountType === AccountType.EXPENSES ? this.expenses : this.income) * 100,
          type: ProgressType.Linear,
          total: 100,
        }).width('100%')
          .color(item.info.activeColor)
          .style({ strokeWidth: 4 })
      }.layoutWeight(1)
    }.width('100%')
    .padding({ top: 10, bottom: 10 })
  }

  build() {
    Column({ space: 20 }){
      StatsHeader({ type: $statsType, time: $time })
      this.TotalStats()
      Column() {
        StatsDetailHeader({
          onChange: (type) => {
            this.statsData = null;
            this.categoryType = type;
            this.statsAccountData();
          }
        })
        if (this.getRenderRecord().length) {
          Divider().color($r('app.color.grey_1')).margin({ top: 14 })
          List() {
            ForEach(this.getRenderRecord(), (item) => {
              ListItem() {
                if (this.categoryType === CategoryType.DATE) {
                  this.DateStatsItem(item);
                } else {
                  this.TypeStatsItem(item)
                }
              }
            })
          }.divider({ color: $r('app.color.grey_1'), strokeWidth: 1 })
        }
      }.width('100%')
      .backgroundColor($r('app.color.white'))
      .borderRadius(16)
      .padding(16)
    }.width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
  }
}