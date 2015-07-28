package com.tongqu.client.entity;

public class ProductDetail {
	public String goodsName;// 商品名称
	public String goodsDetail;// 商品的具体描述
	public String goodsPriceDetail;// 本次支付的总费

	public int goodsCount = 1;// 商品数量(默认为1)
	public String payCode;// 支付代码
	public String serverMsg;// 短信格式(华建特有)
	public int mnDiscount;// 优惠百分比(%) 例：10
	public int mnSubtype = 0;// 支付子类型 默认为0
	public int price;// 价格(单位：分)

	/**
	 * 得到商品价格（分），返回0则表示获取价格失败
	 *
	 * @return
	 */
	public int getPrice() {
		try {
			if (goodsPriceDetail != null) {
				price = Integer.parseInt(goodsPriceDetail.replace("价格:￥", "").replace(".", ""));
			}
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		return price;
	}
}