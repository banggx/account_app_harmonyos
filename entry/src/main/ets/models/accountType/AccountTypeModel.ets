/**
 * 支持类型
 */
export default class AccountTypeModel {
  /**
   * id
   */
  id: number;
  /**
   * 名称
   */
  name: ResourceStr;
  /**
   * icon
   */
  icon: ResourceStr;
  /**
   * active 激活色值
   */
  activeColor: ResourceStr;

  constructor(id: number, name: ResourceStr, icon: ResourceStr, activeColor: ResourceStr) {
    this.id = id;
    this.name = name;
    this.icon = icon;
    this.activeColor = activeColor;
  }
}
