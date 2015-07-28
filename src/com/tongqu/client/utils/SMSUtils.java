package com.tongqu.client.utils;

import java.util.List;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.telephony.SmsManager;

import com.tongqu.client.game.TQLuaAndroidConsole;

public class SMSUtils {

	/**
	 * 发送短信
	 *
	 * @param mobile号码
	 * @param message内容
	 */
	public static void sendSms(String mobile, String message) {
		try {
			if (mobile == null || message == null) {
				return;
			}
			// 处理返回的发送状态
			String SENT_SMS_ACTION = "SENT_SMS_ACTION";
			Intent sentIntent = new Intent(SENT_SMS_ACTION);
			PendingIntent sentPI = PendingIntent.getBroadcast(TQLuaAndroidConsole.getGameSceneInstance(), 0, sentIntent, 0);
			// register the Broadcast Receivers
			TQLuaAndroidConsole.getGameSceneInstance().registerReceiver(new BroadcastReceiver() {
				@Override
				public void onReceive(Context _context, Intent _intent) {
					try {
						switch (getResultCode()) {
						case Activity.RESULT_OK:
							break;
						case SmsManager.RESULT_ERROR_GENERIC_FAILURE:
							break;
						case SmsManager.RESULT_ERROR_RADIO_OFF:
							break;
						case SmsManager.RESULT_ERROR_NULL_PDU:
							break;
						}
						TQLuaAndroidConsole.getGameSceneInstance().unregisterReceiver(this);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}, new IntentFilter(SENT_SMS_ACTION));

			// 处理返回的接收状态
			String DELIVERED_SMS_ACTION = "DELIVERED_SMS_ACTION";
			// create the deilverIntent parameter
			Intent deliverIntent = new Intent(DELIVERED_SMS_ACTION);
			PendingIntent deliverPI = PendingIntent.getBroadcast(TQLuaAndroidConsole.getGameSceneInstance(), 0, deliverIntent, 0);
			TQLuaAndroidConsole.getGameSceneInstance().registerReceiver(new BroadcastReceiver() {
				@Override
				public void onReceive(Context _context, Intent _intent) {
					try {
						TQLuaAndroidConsole.getGameSceneInstance().unregisterReceiver(this);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}, new IntentFilter(DELIVERED_SMS_ACTION));

			// 获取短信管理器
			SmsManager sms = SmsManager.getDefault();
			// 拆分短信内容（手机短信长度限制）
			// 如果短信没有超过限制长度，则返回一个长度的List。
			List<String> texts = sms.divideMessage(message);
			// 发送拆分后的内容
			for (String text : texts) {
				sms.sendTextMessage(mobile, null, text, sentPI, deliverPI);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 发送二进制短信
	 *
	 * @param mobile
	 * @param port
	 * @param message
	 */
	public static void sendDataSms(String mobile, float port, String message) {

		if (mobile == null || message == null) {
			return;
		}

		String SENT_SMS_ACTION = "SENT_SMS_ACTION";
		Intent sentIntent = new Intent(SENT_SMS_ACTION);
		PendingIntent sentPI = PendingIntent.getBroadcast(TQLuaAndroidConsole.getGameSceneInstance(), 0, sentIntent, 0);
		// register the Broadcast Receivers
		TQLuaAndroidConsole.getGameSceneInstance().registerReceiver(new BroadcastReceiver() {
			@Override
			public void onReceive(Context _context, Intent _intent) {
				try {
					switch (getResultCode()) {
					case Activity.RESULT_OK:
						break;
					case SmsManager.RESULT_ERROR_GENERIC_FAILURE:
						break;
					case SmsManager.RESULT_ERROR_RADIO_OFF:
						break;
					case SmsManager.RESULT_ERROR_NULL_PDU:
						break;
					}
					TQLuaAndroidConsole.getGameSceneInstance().unregisterReceiver(this);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}, new IntentFilter(SENT_SMS_ACTION));

		// 处理返回的接收状态
		String DELIVERED_SMS_ACTION = "DELIVERED_SMS_ACTION";
		// create the deilverIntent parameter
		Intent deliverIntent = new Intent(DELIVERED_SMS_ACTION);
		PendingIntent deliverPI = PendingIntent.getBroadcast(TQLuaAndroidConsole.getGameSceneInstance(), 0, deliverIntent, 0);
		TQLuaAndroidConsole.getGameSceneInstance().registerReceiver(new BroadcastReceiver() {
			@Override
			public void onReceive(Context _context, Intent _intent) {
				try {
					TQLuaAndroidConsole.getGameSceneInstance().unregisterReceiver(this);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}, new IntentFilter(DELIVERED_SMS_ACTION));

		SmsManager smsm = SmsManager.getDefault();
		smsm.sendDataMessage(mobile, null, (short) port, Base64.decode(message), sentPI, deliverPI);
	}
}
