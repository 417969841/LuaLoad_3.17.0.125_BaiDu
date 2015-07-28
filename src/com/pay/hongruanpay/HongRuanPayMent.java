package com.pay.hongruanpay;

import android.widget.Toast;

import com.arcsoft.hpay100.HPaySdkAPI;
import com.arcsoft.hpay100.HPaySdkCallback;
import com.arcsoft.hpay100.HPaySdkResult;
import com.tongqu.client.game.TQLuaAndroidConsole;

public class HongRuanPayMent {
	public static HongRuanPayMent mHongRuanPayMent;
	public String Paycode = "";
	public String productName = "";
	public int Price = 0;
	public String money = "";
	public String merid = "2000030";
	public String appid = "7f62d3cac0bf11e49c0dc6a10b512583";
	public String channel = "360"; // 合作方传入渠道范例
	public String orderid = "";
	public Boolean isHongRuanSDKinitFinish = false;
	public static HongRuanPayMent getInstance() {
		if (mHongRuanPayMent == null) {
			mHongRuanPayMent = new HongRuanPayMent();
		}
		return mHongRuanPayMent;
	}
	public void HongRuanPaySDKinit() {

		HPaySdkAPI.initHPaySdk(TQLuaAndroidConsole.getGameSceneInstance(), merid, appid, channel);
		isHongRuanSDKinitFinish = true;
	}
	public void HongRuanPaySDKPayMent() {
		HPaySdkAPI.startHPaySdk(TQLuaAndroidConsole.getGameSceneInstance(), orderid,Paycode, Price,
				money + "元", productName, new HPaySdk());
	}
	private class HPaySdk implements HPaySdkCallback {
		@Override
		public void payResult(HPaySdkResult sdkResult) {
			switch (sdkResult.getPayStatus()) {
			case HPaySdkResult.PAY_STATUS_SUCCESS:
				// 短信发送成功，下发道具
				Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "下发道具成功", Toast.LENGTH_LONG)
						.show();
				break;
			case HPaySdkResult.PAY_STATUS_FAILED:
				// 短信发送失败,不下发道具，
				// 错误原因
				String msg = sdkResult.getFailedMsg();
				// int errorType =
				// sdkResult.getFailedType();
				Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), msg, Toast.LENGTH_LONG)
						.show();
				break;
			case HPaySdkResult.PAY_STATUS_CANCEL:
				// 支付取消
				Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "支付取消", Toast.LENGTH_LONG)
						.show();
				break;
			}
		}

	}
}
