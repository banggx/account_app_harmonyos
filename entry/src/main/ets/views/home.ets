import dayjs from 'dayjs';
import { GroupByDate } from '../models/account/account';
import AccountService from '../service/account';
import { Toast } from '../components/ToastDialog';
import AccountItem from '../components/AccountItem';

@Extend(Text) function infoFont(fontSize: number, lineHeight: number) {
  .fontSize(fontSize)
  .lineHeight(lineHeight)
  .fontColor($r('app.color.font_1'))
}

@Component
export default struct Home {
  @Prop @Watch('handlePageShow') isPageShow: boolean;
  @State accountList: GroupByDate[] = [];
  @State expenses: number = 0;
  @State income: number = 0;

  async queryCurrentMonthAccountRecords() {
    const currentTime = dayjs().valueOf();
    const res = await AccountService.getAccountByMonth(currentTime);
    const groupRes = AccountService.groupByDate(res);
    this.accountList = groupRes;
    const { expenses, income } = AccountService.statsConsume(res);
    this.expenses = expenses;
    this.income = income;
  }

  handlePageShow() {
    if (this.isPageShow) {
      this.queryCurrentMonthAccountRecords();
    }
  }

  aboutToAppear() {
    this.queryCurrentMonthAccountRecords();
  }

  deleteRecord(id: number) {
    AccountService.deleteById(id).then(() => {
      this.queryCurrentMonthAccountRecords();
    }).catch(res => {
      new Toast().error('删除记录失败');
    })
  }

  @Builder GroupHeader(item: GroupByDate) {
    Column() {
      Row({ space: 8 }) {
        Text(dayjs(item.time).format('MM月DD日'))
          .fontSize(18)
          .fontColor($r('app.color.font_3'))
        Blank()
        Text('支出: ' + item.expenses.toFixed(2))
          .fontColor($r('app.color.font_2'))
          .fontSize(12)
        Text('收入: ' + item.income.toFixed(2))
          .fontColor($r('app.color.font_2'))
          .fontSize(12)
      }.height(40)
      .width('100%')
      Divider().color($r('app.color.grey_1'))
    }.width('100%')
  }

  @Builder AccountItemOperate(record: GroupByDate['records'][number]) {
    Row() {
      Button('删除')
        .type(ButtonType.Normal)
        .padding({ left: 12, right: 12 })
        .backgroundColor($r('app.color.red'))
        .onClick(() => {
          this.deleteRecord(record.id)
        })
    }.height('100%')
    .margin({ left: 12 })
  }

  build() {
    Column({ space: 12 }) {
      Text($r('app.string.month_expenses')).infoFont(12, 15)
      if (this.expenses) {
        Text('¥ ' + this.expenses.toFixed(2)).infoFont(36, 50)
      } else {
        Text($r('app.string.month_no_expenses')).infoFont(36, 50)
      }
      Row() {
        Text('本月收入(元): ').infoFont(12, 15)
        if (this.income) {
          Text('¥ ' + this.income.toFixed(2)).infoFont(16, 22)
        } else {
          Text($r('app.string.month_no_income')).infoFont(16, 22)
        }
      }.alignItems(VerticalAlign.Center)
      Column() {
        if (this.accountList.length) {
          List() {
            ForEach(this.accountList, (item) => {
              ListItemGroup({
                header: this.GroupHeader(item)
              }) {
                ForEach(item.records, (record) => {
                  ListItem() {
                    AccountItem({ account: record })
                  }.swipeAction({ end: this.AccountItemOperate(record) })
                })
              }.divider({ strokeWidth: 1, color: $r('app.color.grey_1') })
            })
          }.divider({ strokeWidth: 1, color: $r('app.color.grey_1') })
          Divider().color($r('app.color.grey_1'))
        } else {
          Column({ space: 24 }) {
            Image($r('app.media.empty'))
              .width(100)
              .objectFit(ImageFit.Contain)
            Text($r('app.string.empty_tip'))
              .fontSize(12)
              .lineHeight(17)
              .fontColor($r('app.color.font_2'))
          }.width('100%')
            .margin({ top: 50 })
        }
      }.width('100%')
      .backgroundColor($r('app.color.white'))
      .layoutWeight(1)
      .borderRadius(16)
      .padding(16)
    }.width('100%')
    .height('100%')
    .padding(18)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }
}