import preferences from '@ohos.data.preferences';
import * as CONSTANTS from '../common/constants';
import { Logger } from './Logger';

class PreferenceUtils {
  private pref: preferences.Preferences;

  async loadPreference(context) {
    try {
      this.pref = await preferences.getPreferences(context, CONSTANTS.H_STORE)
      Logger.debug(`加载 Preference [${CONSTANTS.H_STORE}] 成功`);
    } catch(err) {
      Logger.debug(`加载 Preference [${CONSTANTS.H_STORE}] 失败`, err);
    }
  }

  async putPreferenceValue(key: string, value: preferences.ValueType) {
    if (!this.pref) {
      Logger.debug(`Preference [${CONSTANTS.H_STORE}] 尚未初始化`);
      return;
    }
    try {
      // 写入数据
      await this.pref.put(key, value);
      // 刷盘
      await this.pref.flush();
      Logger.debug(`保存 Preference [${key} = ${value}] 成功`);
    } catch (err) {
      Logger.debug(`保存 Preference [${key} = ${value}] 失败`, err);
    }
  }

  async getPreferenceValue(key: string, defaultValue: preferences.ValueType) {
    if (!this.pref) {
      Logger.debug(`Preference [${CONSTANTS.H_STORE}] 尚未初始化`);
      return;
    }
    try {
      const value = await this.pref.get(key, defaultValue);
      Logger.debug(`读取 Preference [${key} = ${value}] 成功`);
      return value;
    } catch(err) {
      Logger.debug(`读取 Preference [${key}] 失败`, err);
    }
  }
}

export default new PreferenceUtils();