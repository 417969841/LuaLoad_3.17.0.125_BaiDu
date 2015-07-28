package com.pay;

import java.util.HashMap;

import com.pay.alipay.AliPayment;
import com.pay.epay.EPayment;
import com.pay.hongruanpay.HongRuanPayMent;
import com.pay.purse.SMSPursePayment;
import com.pay.smsunicom.SMSUnicomPayment;
import com.pay.unionpay.UnionPayment;
import com.pay.weixinpay.WeiXinPayment;
import com.pay.yinbeipay.YinBeiPayMent;
import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.utils.Pub;

public class PaymentConfig {

	/*************************** 联通 ********************************/

	/**
	 * 设置联通支付的
	 *
	 * @param name
	 * @param price
	 * @param payCode
	 */
	public static void luaCallSetSMSUnicomData(final String name, final float price, final String payCode) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				SMSUnicomPayment.getInstance().setSMSUnicomData(name, (int) price, payCode);
			}
		});
	}

	/**
	 * 获取订单号以后,联通MM支付
	 *
	 * @param orderId
	 * @param callBackLua
	 */
	public static void luaCallSMSUnicomPayResult(final String orderId, final int callBackLua) {
		// 确保 Lua function 跑在 GL 线程，Java 代码跑在 UI 线程。
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				SMSUnicomPayment.getInstance().readDBID_EXCHANGE_SMSUnicom(orderId, callBackLua);
			}
		});
	}

	/*************************** 手机钱包 ********************************/
	/**
	 * 设置手机钱包支付的
	 *
	 * @param payCode
	 */
	public static void luaCallSetPursePayData(final String payCode, final String serverMsg) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				SMSPursePayment.getInstance().setInfo(payCode, serverMsg);
			}
		});
	}

	/**
	 * 获取订单号以后,手机钱包支付
	 *
	 * @param orderId
	 */
	public static void luaCallPursePayResult(final String orderId) {
		// 确保 Lua function 跑在 GL 线程，Java 代码跑在 UI 线程。
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				SMSPursePayment.getInstance().smsPursePay(orderId);
			}
		});
	}

	/**
	 * 获取手机钱包正则表达式
	 *
	 */
	public static void luaCallPurseRegexData(final String regex) {
		// 确保 Lua function 跑在 GL 线程，Java 代码跑在 UI 线程。
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				SMSPursePayment.getInstance().setRegex(regex);
			}
		});
	}

	/*************************** 支付宝支付 ********************************/

	/**
	 * 是否支持支付宝支付
	 *
	 * @return
	 */
	public static boolean luaCallAliPayIsPaySupported() {
		return AliPayment.getInstance().isPaySupported();
	}

	/**
	 * 获取支付宝订单号
	 *
	 */
	public static void luaCallAliPayGetOrderInfo(final String goodsName, final String goodsDetail, final String goodsPriceDetail, final float mnDiscount, final float mnSubtype, final float price, final int callLuaFunction) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				AliPayment.getInstance().luaCallAliPayGetOrderID(goodsName, goodsDetail, goodsPriceDetail, (int) mnDiscount, (int) mnSubtype, (int) price, callLuaFunction);
			}
		});
	}

	/**
	 * 获取订单号以后,回调支付宝支付
	 *
	 * @param sign
	 */
	public static void luaCallAliPayResult(final String orderID, final String PARTNER, final String SELLER, final String RSA_PRIVATE, final String RSA_ALIPAY_PUBLIC, final String SERVER_URL, final String SERVICE, final String PAYMENT_TYPE, final String INPUT_CHARSET, final int callBackLua) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				HashMap<String, String> aliPayMap = new HashMap<String, String>();
				aliPayMap.put("PARTNER", PARTNER);
				aliPayMap.put("SELLER", SELLER);
				aliPayMap.put("RSA_PRIVATE", RSA_PRIVATE);
				aliPayMap.put("RSA_ALIPAY_PUBLIC", RSA_ALIPAY_PUBLIC);
				aliPayMap.put("SERVER_URL", SERVER_URL);
				aliPayMap.put("SERVICE", SERVICE);
				aliPayMap.put("PAYMENT_TYPE", PAYMENT_TYPE);
				aliPayMap.put("INPUT_CHARSET", INPUT_CHARSET);
				AliPayment.getInstance().readDBID_EXCHANGE_AliPay(orderID, aliPayMap, callBackLua);
			}
		});
	}

	/*************************** 微信支付 ********************************/

	/**
	 * 是否支持微信支付
	 *
	 * @return
	 */
	public static boolean luaCallWeiXinIsPaySupported() {
		return WeiXinPayment.getInstance().isPaySupported();
	}

	/**
	 * 微信支付回调
	 *
	 * @param appid
	 * @param partnerid
	 * @param prepayid
	 * @param noncestr
	 * @param timestamp
	 * @param packageValue
	 * @param appkey
	 * @param callBackLua
	 */
	public static void luaCallWeiXinPayResult(final String appid, final String partnerid, final String prepayid, final String noncestr, final String timestamp, final String packageValue, final String sign, final int callBackLua) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				HashMap<String, String> weixinMap = new HashMap<String, String>();
				weixinMap.put("appid", appid);
				weixinMap.put("partnerid", partnerid);
				weixinMap.put("prepayid", prepayid);
				weixinMap.put("noncestr", noncestr);
				weixinMap.put("timestamp", timestamp);
				weixinMap.put("package", packageValue);
				weixinMap.put("sign", sign);
				WeiXinPayment.getInstance().sendPayReq(weixinMap);
			}
		});
	}

	/*************************** 新银联 ********************************/

	/**
	 * 是否支持新银联支付
	 *
	 * @return
	 */
	public static boolean luaCallNewUnionIsPaySupported() {
		return UnionPayment.getInstance().isPaySupported();
	}

	/**
	 * 获取订单号以后,新银联支付
	 *
	 * @param orderId
	 * @param callBackLua
	 */
	public static void luaCallNewUnionPayResult(final String orderId) {
		// 确保 Lua function 跑在 GL 线程，Java 代码跑在 UI 线程。
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				UnionPayment.getInstance().unionPay(orderId);
			}
		});
	}

	/**
	 * 获取订单号以后,银贝壳
	 *
	 * @param orderId
	 * @param callBackLua
	 */
	public static void luaCallYINBEIKEPayResult(final String goodsName, final String PayCode, final String price, final String orderId) {
		// 确保 Lua function 跑在 GL 线程，Java 代码跑在 UI 线程。
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				YinBeiPayMent.getInstance().productName = goodsName;
				YinBeiPayMent.getInstance().Paycode = PayCode;
				int mprice = 0;
				mprice = Integer.parseInt(price);
				mprice = mprice / 100;
				YinBeiPayMent.getInstance().money = mprice + "";
				YinBeiPayMent.getInstance().orderid = orderId;

				YinBeiPayMent.getInstance().YinBeiSDKinit();

			}
		});
	}

	/**
	 * 获取订单号以后,银贝壳
	 *
	 * @param orderId
	 * @param callBackLua
	 */
	public static void luaCallHongRPayResult(final String goodsName, final String PayCode, final String price, final String orderId) {
		// 确保 Lua function 跑在 GL 线程，Java 代码跑在 UI 线程。
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				HongRuanPayMent.getInstance().productName = goodsName;
				HongRuanPayMent.getInstance().Paycode = PayCode;
				int mprice = 0;

				mprice = Integer.parseInt(price);
				HongRuanPayMent.getInstance().Price = mprice;
				mprice = mprice / 100;
				HongRuanPayMent.getInstance().money = mprice + "";
				HongRuanPayMent.getInstance().orderid = orderId;

				if (HongRuanPayMent.getInstance().isHongRuanSDKinitFinish) {
					HongRuanPayMent.getInstance().HongRuanPaySDKPayMent();
				} else {
					HongRuanPayMent.getInstance().HongRuanPaySDKinit();
				}

			}
		});
	}

	/*************************** 宜支付 ********************************/

	/**
	 * 获取订单号以后,新银联支付
	 *
	 * @param orderId
	 * @param callBackLua
	 */
	public static void luaCallEPayResult(final String partnerId, final String key, final String appFeeId, final String money, final String tradeId, final String appId, final String qn, final String tradeName) {
		// 确保 Lua function 跑在 GL 线程，Java 代码跑在 UI 线程。
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Pub.LOG("partnerId == " + partnerId);
				Pub.LOG("key == " + key);
				Pub.LOG("appFeeId == " + appFeeId);
				Pub.LOG("money == " + money);
				Pub.LOG("tradeId == " + tradeId);
				Pub.LOG("appId == " + appId);
				Pub.LOG("qn == " + qn);
				Pub.LOG("tradeName == " + tradeName);
				/* 准备调用接口需要的数据，建议直接copy以下key */
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("partnerId", partnerId);
				map.put("key", key);
				map.put("appFeeId", appFeeId);
				map.put("money", money);
				map.put("tradeId", tradeId);
				map.put("appId", appId);
				map.put("qn", qn);
				map.put("tradeName", tradeName);
				EPayment.getInstance().startPay(map);
			}
		});
	}

}
