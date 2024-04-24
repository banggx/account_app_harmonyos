import AccountTypeModel from '../../models/accountType/AccountTypeModel';
import DatePickerDialog from '../DatePickerDialog';
import AccountService from '../../service/account';
import { AccountType } from '../../models/account/account';
import { Toast } from '../ToastDialog';
import dayjs from 'dayjs';

@Component
export default struct AccountForm {
  private accountTypeList: AccountTypeModel[] = [];
  private accountType: AccountType = AccountType.EXPENSES;
  @State selectedDate: number = dayjs().startOf('day').valueOf();
  @State selectType: AccountTypeModel = null;
  @State amount: number = undefined;
  @State description: string = undefined;
  controller: CustomDialogController = new CustomDialogController({
    builder: DatePickerDialog({
      selectedDate: new Date(this.selectedDate),
      onChange: (date: number) => {
        this.selectedDate = date;
      }
    })
  })

  async onSave() {
    if (!this.amount || !this.selectType) {
      new Toast().error('请填写完账单金额和类型')
      return;
    }
    await AccountService.insert({
      accountType: this.accountType,
      type: this.selectType.id,
      amount: this.amount,
      time: this.selectedDate,
      description: this.description
    });
    new Toast().success('保存记账记录成功');
    this.resetAccountForm();
  }

  resetAccountForm() {
    this.accountType = null;
    this.description = undefined;
    this.amount = undefined;
    this.selectedDate = dayjs().startOf('day').valueOf();
  }

  build() {
    Column({ space: 32 }) {
      Column() {
        Row() {
          Text($r('app.string.bill_amount'))
          TextInput({ placeholder: '¥ 0.00', text: this.amount?.toString() })
            .type(InputType.Number)
            .placeholderColor($r('app.color.font_2'))
            .width(120)
            .textAlign(TextAlign.End)
            .layoutWeight(1)
            .backgroundColor($r('app.color.white'))
            .onChange((value) => {
              if (value) {
                this.amount = parseFloat(value);
              } else {
                this.amount = 0;
              }
            })
        }.width('100%')
        Divider().color($r('app.color.grey_1'))
          .margin({ top: 14, bottom: 14 })
        Grid() {
          ForEach(this.accountTypeList, (item: AccountTypeModel) => {
            GridItem() {
              Column({ space: 4 }) {
                Column() {
                  Image(item.icon)
                    .width(16)
                    .objectFit(ImageFit.Contain)
                    .fillColor(this.selectType?.id === item.id ? $r('app.color.white') : $r('app.color.font_2'))
                }.width(36)
                .height(36)
                .borderRadius(18)
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .backgroundColor(this.selectType?.id === item.id ? item.activeColor :$r('app.color.grey_1'))
                Text(item.name).fontSize(12)
                  .fontColor($r('app.color.font_2'))
                  .lineHeight(15)
              }.onClick(() => {
                this.selectType = item;
              })
            }.width('25%')
          })
        }.rowsTemplate('1rf 1rf 1rf 1rf')
        .minCount(4)
        .rowsGap(16)
        .width('100%')
        Divider().color($r('app.color.grey_1'))
          .margin({ top: 14, bottom: 4 })
        Row({ space: 20 }) {
          Row({ space: 4 }) {
            Image($r('app.media.date'))
              .width(14)
              .objectFit(ImageFit.Contain)
            Text(dayjs(this.selectedDate).format('YYYY-MM-DD'))
              .fontSize(12)
              .fontColor($r('app.color.font_3'))
              .lineHeight(17)
          }.onClick(() => {
            this.controller.open();
          })
          TextInput({ placeholder: '请输入备注信息...', text: this.description })
            .placeholderColor($r('app.color.font_2'))
            .placeholderFont({ size: 12 })
            .fontSize(12)
            .layoutWeight(1)
            .backgroundColor($r('app.color.white'))
            .onChange((val) => {
              this.description = val;
            })
        }.height(40).padding({ left: 10 })
        Divider().color($r('app.color.grey_1'))
          .margin({ top: 4 })
      }.width('100%')
      .padding(16)
      .backgroundColor($r('app.color.white'))
      .borderRadius(16)
      Row({ space: 12 }) {
        Button($r('app.string.save'))
          .backgroundColor($r('app.color.green'))
          .fontColor($r('app.color.white'))
          .type(ButtonType.Normal)
          .borderRadius(4)
          .layoutWeight(1)
          .onClick(this.onSave.bind(this))
        Button($r('app.string.make_another_note'))
          .backgroundColor($r('app.color.grey_2'))
          .fontColor($r('app.color.white'))
          .type(ButtonType.Normal)
          .borderRadius(4)
          .onClick(this.resetAccountForm.bind(this))
      }
    }.width('100%')
  }
}