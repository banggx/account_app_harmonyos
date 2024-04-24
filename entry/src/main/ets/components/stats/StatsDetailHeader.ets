import { CategoryType } from '../../models/stats/stats'
@Component
export default struct StatsDetailHeader {
  @State categoryType: CategoryType = CategoryType.DATE;
  onChange: (type: CategoryType) => void;

  build() {
    Row() {
      Text($r('app.string.statistics_details'))
        .fontColor(18)
        .lineHeight(25)
        .fontColor($r('app.color.font_3'))
        .fontWeight(500)
        .layoutWeight(1)
      Button(this.categoryType === CategoryType.DATE ? $r('app.string.by_category') : $r('app.string.by_date'))
        .backgroundColor(this.categoryType === CategoryType.DATE ? $r('app.color.orange') : $r('app.color.green'))
        .onClick(() => {
          this.categoryType = this.categoryType === CategoryType.DATE ? CategoryType.TYPE : CategoryType.DATE;
          if (this.onChange) {
            this.onChange(this.categoryType);
          }
        })
    }.width('100%')
  }
}