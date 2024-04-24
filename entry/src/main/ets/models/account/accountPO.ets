/**
 * 记录的数据库持久化对象
 */
export default class AccountPO {
  /**
   * 记录id
   */
  id?: number;
  /**
   * 记录类型
   */
  type: number;
  /**
   * 收支类型
   */
  accountType: number;
  /**
   * 记录描述
   */
  description?: string = '';
  /**
   * 记录的创建时间
   */
  createTime?: number;
  /**
   * 金额
   */
  amount: number;
  /**
   * 记录日期
   */
  time: number;
}