import mediaQuery from '@ohos.mediaquery';
import BreakpointConstant from '../common/breakpoint';

export default class BreakpointSystem {
  private smListener: mediaQuery.MediaQueryListener = mediaQuery.matchMediaSync(BreakpointConstant.RANGE_SM);
  private mdListener: mediaQuery.MediaQueryListener = mediaQuery.matchMediaSync(BreakpointConstant.RANGE_MD);
  private lgListener: mediaQuery.MediaQueryListener = mediaQuery.matchMediaSync(BreakpointConstant.RANGE_LG);

  updateBreakpoint(breakpoint: string) {
    AppStorage.SetOrCreate(BreakpointConstant.CURRENT_BREAKPOINT, breakpoint);
  }

  smListenerCallback(result: mediaQuery.MediaQueryResult) {
    if (result.matches) {
      this.updateBreakpoint(BreakpointConstant.BREAKPOINT_SM);
    }
  }

  mdListenerCallback(result: mediaQuery.MediaQueryResult) {
    if (result.matches) {
      this.updateBreakpoint(BreakpointConstant.BREAKPOINT_MD);
    }
  }

  lgListenerCallback(result: mediaQuery.MediaQueryResult) {
    if (result.matches) {
      this.updateBreakpoint(BreakpointConstant.BREAKPOINT_LG);
    }
  }

  register() {
    this.smListener.on('change', this.smListenerCallback.bind(this));
    this.mdListener.on('change', this.mdListenerCallback.bind(this));
    this.lgListener.on('change', this.lgListenerCallback.bind(this));
  }

  unRegister() {
    this.smListener.off('change', this.smListenerCallback.bind(this));
    this.mdListener.off('change', this.mdListenerCallback.bind(this));
    this.lgListener.off('change', this.lgListenerCallback.bind(this));
  }
}