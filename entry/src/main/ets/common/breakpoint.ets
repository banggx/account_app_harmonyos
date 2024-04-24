declare interface BreakpointTypeOptions<T> {
  sm?: T;
  md?: T;
  lg?: T;
}

export class BreakpointType<T> {
  options: BreakpointTypeOptions<T>;

  constructor(options: BreakpointTypeOptions<T>) {
    this.options = options;
  }

  getValue(breakpoint: string): T {
    return this.options[breakpoint];
  }
}
export default class BreakpointConstants {
  /**
   * 小屏幕设备的 BreakPoints 标记
   */
  static readonly BREAKPOINT_SM: string = 'sm';

  /**
   * 中等设备的 Breakpoint 标记
   */
  static readonly BREAKPOINT_MD: string = 'md';

  /**
   * 大屏设备的 Breakpoints 标记
   */
  static readonly BREAKPOINT_LG: string = 'lg';

  /**
   * 当前设备的 Breakpoints 标记 存储的 key
   */
  static readonly CURRENT_BREAKPOINT: string = 'currentBreakpoint';

  /**
   * 小屏设备宽度范围
   */
  static readonly RANGE_SM: string = '(320vp<=width<600vp)';

  /**
   * 中屏设备宽度范围
   */
  static readonly RANGE_MD: string = '(600vp<=width<840vp)';

  /**
   * 大屏幕设备宽度范围
   */
  static readonly RANGE_LG: string = '(840vp<=width)';

  /**
   * 不同设备下的bar位置
   */
  static readonly bar_position: BreakpointType<BarPosition> = new BreakpointType<BarPosition>({
    [BreakpointConstants.BREAKPOINT_SM]: BarPosition.End,
    [BreakpointConstants.BREAKPOINT_MD]: BarPosition.Start,
    [BreakpointConstants.BREAKPOINT_LG]: BarPosition.Start,
  });

  /**
   * 不同尺寸设备的 bar 是否垂直
   */
  static readonly bar_vertical: BreakpointType<boolean> = new BreakpointType({
    [BreakpointConstants.BREAKPOINT_SM]: false,
    [BreakpointConstants.BREAKPOINT_MD]: true,
    [BreakpointConstants.BREAKPOINT_LG]: true,
  });

  static readonly addBtn_stack_align: BreakpointType<Alignment> = new BreakpointType({
    [BreakpointConstants.BREAKPOINT_SM]: Alignment.Bottom,
    [BreakpointConstants.BREAKPOINT_MD]: Alignment.Start,
    [BreakpointConstants.BREAKPOINT_LG]: Alignment.Start,
  });

  static readonly addBtn_stack_size: BreakpointType<number> = new BreakpointType({
    [BreakpointConstants.BREAKPOINT_SM]: 60,
    [BreakpointConstants.BREAKPOINT_MD]: 100,
    [BreakpointConstants.BREAKPOINT_LG]: 120,
  });

  /**
   * 不同尺寸设备 stats 统计数据展示数量
   */
  static readonly max_content_size: BreakpointType<Length> = new BreakpointType({
    [BreakpointConstants.BREAKPOINT_SM]: '100%',
    [BreakpointConstants.BREAKPOINT_MD]: '80%',
    [BreakpointConstants.BREAKPOINT_LG]: '60%',
  })
}