import dayjs from 'dayjs';
import { StatsType } from '../../models/stats/stats';
import PickerDialog from '../PickerDialog';
import { OptionsItem, StatsItem } from '../../models/stats/StatsItem';
import PreferenceUtil from '../../utils/PreferenceUtil';
import * as CONSTANTS from '../../common/constants';

@Component
export default struct StatsHeader {
  @Link type: StatsType;
  @Link time: number;
  @State selected: number = 0;
  private firstUseTime: number = 0;
  private statsTypeOptions = [
    { label: '月账单', value: StatsType.MONTH },
    { label: '年账单', value: StatsType.YEAR }
  ];
  controller = new CustomDialogController({
    builder: PickerDialog({
      options: this.statsTypeOptions,
      onChange: (type) => {
        this.type = type;
        this.time = dayjs().valueOf();
      }
    }),
    customStyle: true
  })

  async aboutToAppear() {
    this.firstUseTime = await PreferenceUtil.getPreferenceValue(CONSTANTS.PREF_USER_FIRST_KEY, 0) as number;
  }

  getStatsTypeLabel() {
    return this.statsTypeOptions.find(item => item.value === this.type).label;
  }

  getStatsTypeList() {
    const typeList = StatsItem.getStatsTypeDateList(this.type, this.firstUseTime);
    let currentValue;
    if (this.type === StatsType.MONTH) {
      currentValue = dayjs().month();
    } else {
      currentValue = dayjs().year();
    }
    this.selected = typeList.findIndex(item => item.value === currentValue) || 0;
    return typeList;
  }

  selectAccountTime(item: OptionsItem<number>, index: number) {
    this.selected = index;
    let date = dayjs();
    if (this.type === StatsType.MONTH) {
      date = date.set('month', item.value);
    } else {
      date = date.set('year', item.value);
    }
    this.time = date.valueOf();
  }

  build() {
    Row({ space: 16 }) {
      Row({ space: 5 }) {
        Text(this.getStatsTypeLabel())
          .fontSize(18)
          .lineHeight(25)
          .fontColor($r('app.color.font_1'))
        Image($r('app.media.arrow_down'))
          .width(14)
          .objectFit(ImageFit.Contain)
          .fillColor($r('app.color.font_1'))
      }.onClick(() => {
        this.controller.open();
      })
      List({ space: 12, initialIndex: this.selected }) {
        ForEach(this.getStatsTypeList(), (item, index) => {
          ListItem() {
            Text(item.label)
              .fontSize(18)
              .lineHeight(25)
              .fontWeight(500)
              .fontColor(this.selected === index ?  $r('app.color.font_1') : $r('app.color.font_2'))
              .padding({ left: 10, right: 10 })
              .onClick(() => this.selectAccountTime(item, index))
          }
        })
      }.listDirection(Axis.Horizontal)
      .alignListItem(ListItemAlign.Center)
      .layoutWeight(1)
      .height('100%')
    }.width('100%')
    .height(44)
  }
}