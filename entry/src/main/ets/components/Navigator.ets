import router from '@ohos.router'
@Component
export default struct AccountNavigator {
  private title: ResourceStr = $r('app.string.back');

  build() {
    Row(){
      Row({ space: 8 }) {
        Image($r('app.media.arrow_left'))
          .height(14)
          .objectFit(ImageFit.Cover)
          .fillColor($r('app.color.white'))
        Text(this.title)
          .fontSize(16)
          .fontWeight(500)
          .fontColor($r('app.color.white'))
      }.onClick(() => {
        router.back();
      })
    }.width('100%')
    .height(44)
    .padding({ left: 24 })
  }
}