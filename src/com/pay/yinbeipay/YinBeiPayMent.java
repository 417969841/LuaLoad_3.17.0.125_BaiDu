package com.pay.yinbeipay;

import java.util.HashMap;
import java.util.Map;

import android.widget.Toast;

import com.tongqu.client.game.TQLuaAndroidConsole;
import com.unicom.unicomallsmspayment.Payment;
import com.unicom.unicomallsmspayment.PaymentListener;

public class YinBeiPayMent {
	public String appKey = "87c5877f55437c53dad611b7";
	public String Paycode = "";
	public String productName = "";
	public String money = "";
	public String gameName = "疯狂斗地主";
	public String cpName = "北京同趣同趣科技有限公司";
	private static final String serviceTel = "18210234002";
	public   String orderid ="";
	public static YinBeiPayMent mYinBeiPayMent;
	private final static String MODE = "00";//新银联 00为正式环境.01为测试环境
	public static YinBeiPayMent getInstance() {
		if (mYinBeiPayMent == null) {
			mYinBeiPayMent = new YinBeiPayMent();
		}
		return mYinBeiPayMent;
	}
	public void YinBeiSDKinit() {
		final Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("appKey", appKey);
		dataMap.put("productId", Paycode);
		dataMap.put("productName", productName);
		dataMap.put("money", money);
		dataMap.put("serviceTel", serviceTel);
		dataMap.put("gameName", gameName);
		dataMap.put("cpName", cpName);
		dataMap.put("customorderno", orderid);
		Payment.pay(TQLuaAndroidConsole.getGameSceneInstance(), dataMap, new PaymentListener() {
			@Override
			public void paymentResult(int resultCode, String resultStr) {
				if (resultCode == 0) {
					// 支付成功
					Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "支付成功", Toast.LENGTH_SHORT).show();
				} else {
					// 支付失败
					Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), resultStr, Toast.LENGTH_SHORT).show();
				}
			}
		});
	}
}
