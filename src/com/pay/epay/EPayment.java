package com.pay.epay;

import java.util.HashMap;

import com.android.essdk.eyou.EpayCallback;
import com.android.essdk.eyou.EpaySdk;
import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.utils.Pub;

public class EPayment {

	public static EPayment mEPayment;

	public static EPayment getInstance() {
		if (mEPayment == null) {
			mEPayment = new EPayment();
		}
		return mEPayment;
	}

	/**
	 * 启动支付
	 *
	 * @param map
	 */
	public void startPay(final HashMap<String, String> map) {
		new Thread(new Runnable() {
			@Override
			public void run() {
				// 支付接口调用

				// v2.5.0之后参数增加到四个，最后一个控制SDK加载进度条是否增加，true显示，false不显示
				// EpaySdk.getInstance().pay(MainActivity.this, map,
				// mCallBack);
				EpaySdk.getInstance().pay(TQLuaAndroidConsole.getGameSceneInstance(), map, mCallBack, true);
			}
		}).start();
	}

	/**
	 * 支付回调
	 */
	private EpayCallback mCallBack = new EpayCallback() {

		@Override
		public void onEpayBuyProductOK(String appfeeId, String okCode) {
			Pub.LOG("支付成功！响应码：" + okCode + "，计费id：" + appfeeId);
			// 勿在此做UI线程操作，比如Toast
		}

		@Override
		public void onEpayBuyProductFaild(String appfeeId, String errorCode) {
			Pub.LOG("支付失败！响应码：" + errorCode + "，计费id：" + appfeeId);
			// 勿在此做UI线程操作
		}

	};
}
