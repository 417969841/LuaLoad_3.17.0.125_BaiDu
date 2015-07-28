package com.pay.unionpay;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.pm.PackageInfo;

import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.utils.DownloadFollowUp;
import com.tongqu.client.utils.Downloader;
import com.tongqu.client.utils.Pub;
import com.unionpay.UPPayAssistEx;

public class UnionPayment {

	public static UnionPayment mUnionPayment;
	private final static String MODE = "00";//新银联 00为正式环境.01为测试环境
	public static UnionPayment getInstance() {
		if (mUnionPayment == null) {
			mUnionPayment = new UnionPayment();
		}
		return mUnionPayment;
	}

	// 插件下载地址
	public static final String UNION_URL = "http://f.99sai.com/unionpay/UnionPay_PayNow.apk";

	/**
	 * 是否支持支付
	 *
	 * @return
	 */
	public boolean isPaySupported() {
		PackageInfo pkg = Pub.getPkgInfoByName("com.unionpay.uppay");
		if (pkg == null) {
			return false;
		} else {
			return true;
		}
	}

	public int mnCallLuaFunction;

	/**
	 * lua调用获取新银联订单信息
	 *
	 * @return
	 */
	/*
	 * public void luaCallUnionPayGetOrderID(int callLuaFunction) {
	 * mnCallLuaFunction = callLuaFunction; getUnionPayOrderInfo(); }
	 */

	public String merchantOrderId;
	public String merchantOrderTime;

	/**
	 * 从Lua获取订单号后存在这里 支付的时候需要订单号
	 * */
	/*
	 * public void setOrder(String orderId){ this.order = orderId; }
	 */
	/**
	 * 在获取订单后以后 调用此方法去新银联支付
	 * */

	public void unionPay(String orderID) {
		// “00” – 银联正式环境
		// “01” – 银联测试环境，该环境中不发生真实交易

		int ret = UPPayAssistEx.startPay(TQLuaAndroidConsole.getGameSceneInstance(), null, null, orderID, MODE);
		Pub.LOG("ret is =================================== " + ret);
		if (ret == UPPayAssistEx.PLUGIN_NOT_FOUND) {
			// 需要重新安装控件
			Pub.LOG(" plugin not found or need upgrade!!!");

			AlertDialog.Builder builder = new AlertDialog.Builder(TQLuaAndroidConsole.getGameSceneInstance());
			builder.setTitle("提示");
			builder.setMessage("完成购买需要安装银联支付控件，是否安装？");

			builder.setNegativeButton("确定", new DialogInterface.OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					dialog.dismiss();
					Downloader.getInst().getDownloadFile(UNION_URL, "download", DownloadFollowUp.getInst().mDownloadActionHandler, DownloadFollowUp.DOWNLOAD_ACTION_A, false, true);
				}
			});

			builder.setPositiveButton("取消", new DialogInterface.OnClickListener() {

				@Override
				public void onClick(DialogInterface dialog, int which) {
					dialog.dismiss();
				}
			});
			builder.create().show();

		} else {
			Pub.LOG("ret is " + ret);
		}
	}
}
