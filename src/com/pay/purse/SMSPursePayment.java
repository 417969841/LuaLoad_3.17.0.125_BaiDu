package com.pay.purse;

import android.app.AlertDialog;
import android.app.PendingIntent;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.Message;
import android.telephony.SmsManager;

import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.game.TqBroadCast;
import com.tongqu.client.utils.Pub;

public class SMSPursePayment {

	public static String OVER_TIME_TEXT = "支付信息获取失败,未能成功充值.";
	public static String PAY_TEXT = "确认购买?";
	private final static int OVER_TIME = 1;
	private static SMSPursePayment instance = null;
	public static String SMS_SEND_ACTIOIN = "SMS_SEND_ACTIOIN"; // 自定义Action常熟
	// public static String SMS_MATCHES =
	// "确认支付请回复数字[0-9]+，您将通过话费购买百度酷币[0-9]+元充值，费用[0-9]+元（赠返话费不能使用）详询4006125880";
	public static String[] SMS_MATCHES;
	public static boolean HAS_GET_MATCHES = false;
	// public static int BEGIN_INT;
	// public static int END_INT;
	public static String APP_CODE; // 计费代码
	public static String SERVER_MSG; // 短信内容
	public static String smsText;

	public static SMSPursePayment getInstance() {
		if (instance == null) {
			instance = new SMSPursePayment();
		}
		return instance;
	}

	public SMSPursePayment() {
	}

	/**
	 * 发短信去支付
	 *
	 * @param orderId
	 */
	public void smsPursePay(String orderId) {
		Pub.LOG("SERVET_MSG === " + SERVER_MSG + ";APP_CODE === " + APP_CODE + ";orderId is " + orderId);
		smsText = SERVER_MSG + orderId;
		AlertDialog confirmDialog;
		AlertDialog.Builder confirmBuilder;
		confirmBuilder = new AlertDialog.Builder(TQLuaAndroidConsole.getGameSceneInstance());
		confirmBuilder.setTitle("提示").setIcon(android.R.drawable.stat_notify_error);
		confirmBuilder.setMessage(PAY_TEXT);
		confirmBuilder.setPositiveButton("取消", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				//
				dialog.dismiss();
			}
		}).setNegativeButton("确定", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				//
				SmsManager smsMgr = SmsManager.getDefault();
				// 建立自定义Action常数的Intent(给PendingIntent参数之用)
				Intent itSend = new Intent(SMS_SEND_ACTIOIN);
				// sentIntent参数为传送后接受的广播信息PendingIntent
				PendingIntent mSendPI = PendingIntent.getBroadcast(TQLuaAndroidConsole.getGameSceneInstance(), 0, itSend, 0);
				smsMgr.sendTextMessage(APP_CODE, null, smsText, mSendPI, null);
				mHander.sendEmptyMessageDelayed(OVER_TIME, 120 * 1000);
			}
		});
		confirmDialog = confirmBuilder.create();
		confirmDialog.show();
		// mHander.sendEmptyMessage(SHOW_DIALOG);
		// SmsManager smsMgr = SmsManager.getDefault();
		// 建立自定义Action常数的Intent(给PendingIntent参数之用)
		// Intent itSend = new Intent(SMS_SEND_ACTIOIN);
		// sentIntent参数为传送后接受的广播信息PendingIntent
		// PendingIntent mSendPI =
		// PendingIntent.getBroadcast(TQLuaAndroidConsole.getGameSceneInstance(), 0, itSend,
		// 0);
		// smsMgr.sendTextMessage(APP_CODE, null, smsText, mSendPI, null);
		// PayUtils.getInstance().showGamePayPrompt();
		// mHander.sendEmptyMessageDelayed(OVER_TIME, 120 * 1000);
	}

	Handler mHander = new Handler() {

		@Override
		public void handleMessage(Message msg) {

			// TODO Auto-generated method stub
			super.handleMessage(msg);
			switch (msg.what) {
			case OVER_TIME:
				AlertDialog dialog;
				AlertDialog.Builder builder;
				builder = new AlertDialog.Builder(TQLuaAndroidConsole.getGameSceneInstance());
				builder.setTitle("提示").setIcon(android.R.drawable.stat_notify_error);
				builder.setMessage(OVER_TIME_TEXT);
				builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						//
						dialog.dismiss();
					}
				});
				dialog = builder.create();
				dialog.show();
				break;
			}
		}

	};

	public void setRegex(String regex) {
		// 把服务器发来的字符串存在本地SharedPreferences里,下次短信来了找不到正则表达式则从本地读取
		SharedPreferences settings = TQLuaAndroidConsole.getGameSceneInstance().getSharedPreferences(TqBroadCast.PREFS_NAME, 0);
		SharedPreferences.Editor editor = settings.edit();
		editor.putString("matches", regex);
		editor.commit();

		String[] result = regex.split("_");
		SMSPursePayment.SMS_MATCHES = result;
		for (int i = 0; i < SMSPursePayment.SMS_MATCHES.length; i++) {
			Pub.LOG("SMS_MATCHES " + SMSPursePayment.SMS_MATCHES[i]);
		}
		// SMSPursePayment.BEGIN_INT = Integer.parseInt(result[1]);
		// SMSPursePayment.END_INT = Integer.parseInt(result[2]);
		SMSPursePayment.HAS_GET_MATCHES = true;
	}

	public void setInfo(String appCode, String serverMsg) {
		APP_CODE = appCode;
		SERVER_MSG = serverMsg;
	}

	public void removeHandler() {
		mHander.removeMessages(OVER_TIME);
	}

}
