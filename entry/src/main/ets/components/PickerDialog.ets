@CustomDialog
export default struct PickerDialog {
  controller: CustomDialogController;
  private options: { label: string; value: any }[];
  private onChange?: (value: any) => void;
  @State selected: number = 0;

  getSelectRange() {
    return this.options.map(item => item.label);
  }

  build() {
    Column() {
      TextPicker({ range: this.getSelectRange(), selected: this.selected })
        .onChange((_, index: number) => {
          this.selected = index;
        })
      Row({ space: 12 }) {
        Button($r('app.string.cancel'))
          .type(ButtonType.Normal)
          .borderRadius(4)
          .backgroundColor($r('app.color.grey_3'))
          .layoutWeight(1)
          .onClick(() => {
            this.controller.close()
          })
        Button($r('app.string.confirm'))
          .type(ButtonType.Normal)
          .borderRadius(4)
          .backgroundColor($r('app.color.green'))
          .layoutWeight(1)
          .onClick(() => {
            if (this.onChange) {
              this.onChange(this.options[this.selected].value)
            }
            this.controller.close();
          })
      }.width('100%')
    }.width('90%')
    .padding(24)
    .borderRadius(12)
    .backgroundColor($r('app.color.white'))
  }
}