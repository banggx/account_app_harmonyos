import { AccountType, ItemRecordInfo } from '../models/account/account';

@Component
export default struct AccountItem {
  private account: ItemRecordInfo;

  build() {
    Row({ space: 8 }) {
      Column() {
        Image(this.account.info.icon)
          .width(14)
          .fillColor($r('app.color.white'))
      }.width(30)
      .height(30)
      .backgroundColor(this.account.info.activeColor)
      .borderRadius(15)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      Column({ space: 2 }) {
        Text(this.account.info.name)
          .fontColor($r('app.color.font_3'))
          .fontSize(16)
        if (this.account.description) {
          Text(this.account.description)
            .fontSize(12)
            .lineHeight(14)
            .fontColor($r('app.color.font_2'))
        }
      }.alignItems(HorizontalAlign.Start)
      Blank()
      Text(this.account.amount.toFixed(2))
        .fontColor(this.account.accountType === AccountType.EXPENSES ? $r('app.color.font_2') : $r('app.color.red'))
        .fontWeight(500)
        .fontSize(16)
    }.width('100%')
    .height(50)
  }
}