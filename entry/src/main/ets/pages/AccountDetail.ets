import router from '@ohos.router';
import dayjs from 'dayjs';
import Navigator from '../components/Navigator';
import AccountItem from '../components/AccountItem';
import { AccountType, GroupByDate } from '../models/account/account';
import AccountService from '../service/account';
import BreakpointConstants from '../common/breakpoint';

@Entry
@Component
struct AccountDetail {
  @State accountType: AccountType = AccountType.EXPENSES;
  @State accountList: GroupByDate[] = [];
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;

  async aboutToAppear() {
    const params = (router.getParams() || {}) as any;
    const { startTime, endTime, accountType } = params;
    this.accountType = accountType;
    const res = await AccountService.getRangeAccountByType(startTime, endTime, accountType);
    this.accountList = AccountService.groupByDate(res);
  }

  @Builder GroupHeader(item: GroupByDate) {
    Column() {
      Row({ space: 8 }) {
        Text(dayjs(item.time).format('MM月DD日'))
          .fontSize(18)
          .fontColor($r('app.color.font_3'))
        Blank()
        if (this.accountType === AccountType.EXPENSES) {
          Text('支出: ' + item.expenses.toFixed(2))
            .fontColor($r('app.color.font_2'))
            .fontSize(12)
        } else {
          Text('收入: ' + item.income.toFixed(2))
            .fontColor($r('app.color.font_2'))
            .fontSize(12)
        }
      }.height(40)
      .width('100%')
      Divider().color($r('app.color.grey_1'))
    }.width('100%')
  }

  build() {
    Column() {
      Navigator({ title: $r('app.string.detail') })
      Column() {
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
                    }
                  })
                }.divider({ strokeWidth: 1, color: $r('app.color.grey_1') })
              })
            }.divider({ strokeWidth: 1, color: $r('app.color.grey_1') })
            Divider().color($r('app.color.grey_1'))
          }
        }.width(BreakpointConstants.max_content_size.getValue(this.currentBreakpoint))
        .backgroundColor($r('app.color.white'))
        .borderRadius(16)
        .padding(16)
      }.padding({ left: 24, right: 24 })
      .margin({ top: 16 })
    }.width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg'))
  }
}