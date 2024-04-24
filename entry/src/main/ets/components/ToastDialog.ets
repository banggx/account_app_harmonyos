@CustomDialog
export default struct ToastDialog {
  controller: CustomDialogController;
  message: string = '';
  type: 'error' | 'success' = 'success';

  getTypeImage() {
    switch (this.type) {
      case 'success':
        return $r('app.media.success')
      case 'error':
        return $r('app.media.error')
    }
  }

  getTypeColor() {
    switch (this.type) {
      case 'success':
        return $r('app.color.green')
      case 'error':
        return $r('app.color.red')
    }
  }

  build() {
    Column({ space: 12 }) {
      Image(this.getTypeImage())
        .width(45)
        .height(45)
        .fillColor(this.getTypeColor())
      Text(this.message)
        .fontSize(15)
        .lineHeight(21)
        .fontColor($r('app.color.font_1'))
        .textAlign(TextAlign.Center)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }.width(160)
    .padding(24)
    .backgroundColor($r('app.color.grey_3'))
    .borderRadius(12)
  }
}

@Component
export struct Toast {
  createDialog(message: string, type: 'success' | 'error' = 'success'): CustomDialogController {
    const dialogController = new CustomDialogController({
      builder: ToastDialog({
        type,
        message
      }),
      alignment: DialogAlignment.Center,
      customStyle: true,
    })
    return dialogController
  }

  success(message: string, duration = 2000) {
    const dialog = this.createDialog(message, 'success');
    dialog.open();
    setTimeout(() => {
      dialog.close()
    }, duration);
  }

  error(message: string, duration = 2000) {
    const dialog = this.createDialog(message, 'error');
    dialog.open();
    setTimeout(() => {
      dialog.close()
    }, duration);
  }

  build() {}
}