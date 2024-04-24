import hilog from '@ohos.hilog';

export class Logger {
  private static domain: number = 0xFF00;
  private static prefix: string = '[account-app]';
  private static format: string = '%{public}s';
  private static formatLogs(args: any[]): string[] {
    const logs = args.map(arg => {
      if (typeof arg === 'object') {
        return JSON.stringify(arg);
      }
      return arg.toString();
    });
    return logs;
  }

  static debug(...args: any[]): void {
    hilog.debug(Logger.domain, Logger.prefix, Array(args.length).fill(Logger.format).join(', '), Logger.formatLogs(args));
  }

  static info(...args: any[]): void {
    hilog.info(Logger.domain, Logger.prefix, Array(args.length).fill(Logger.format).join(', '), Logger.formatLogs(args));
  }

  static warn(...args: any[]): void {
    hilog.warn(Logger.domain, Logger.prefix, Array(args.length).fill(Logger.format).join(', '), Logger.formatLogs(args));
  }

  static error(...args: any[]): void {
    hilog.error(Logger.domain, Logger.prefix, Array(args.length).fill(Logger.format).join(', '), Logger.formatLogs(args));
  }
}