package com.tongqu.client.utils;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.os.SystemClock;

import com.tongqu.client.game.TQLuaAndroidConsole;

public class AlarmUtils {
	public static AlarmUtils alarmUtils = null;

	public static final String ALARM_ACTION = TQLuaAndroidConsole.PackageName + ".alarm";

	public static AlarmUtils getInstance() {
		if (alarmUtils == null) {
			alarmUtils = new AlarmUtils();
		}
		return alarmUtils;
	}

	public static void luaCallSetAlarmUtils(final String NotificationID, final String BeforeMillions, final String ActionID, final String Title, final String Content) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				AlarmUtils.getInstance().addAlarm(Integer.parseInt(NotificationID), Long.parseLong(BeforeMillions), Integer.parseInt(ActionID), Title, Content);
			}
		});
	}

	public static void luaCallSetLastDay(final String LastDay) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				AlarmUtils.getInstance().SaveLastDay(Integer.parseInt(LastDay));
			}
		});
	}

	public static void luaCallRemoveAlarm(final String NotificationID) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				AlarmUtils.getInstance().removeAlarm2(Integer.parseInt(NotificationID));
			}
		});
	}

	public static void addAlarm(int NotificationID, long BeforeMillions, int ActionID, String Title, String Content) {
		// 闹钟
		Pub.LOG(BeforeMillions + "elapsedRealtime" + System.currentTimeMillis());
		AlarmManager am = (AlarmManager) TQLuaAndroidConsole.getGameSceneInstance().getSystemService(Context.ALARM_SERVICE);
		Intent intent = new Intent(ALARM_ACTION);
		Bundle b = new Bundle();
		b.putInt("NotificationID", NotificationID);
		b.putInt("NotificationPushMessage", 1);
		b.putLong("BeforeMillions", BeforeMillions);
		b.putInt("ActionID", ActionID);
		b.putString("Title", Title);
		b.putString("Content", Content);
		intent.putExtras(b);
		PendingIntent mAlarmSender = PendingIntent.getBroadcast(TQLuaAndroidConsole.getGameSceneInstance(), NotificationID + 5000, intent, 0);

		am.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, SystemClock.elapsedRealtime() + BeforeMillions, mAlarmSender);
		// am.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, time, mAlarmSender);
		// Pub.LOG("增加闹钟:" + (time - SystemClock.elapsedRealtime()) + "毫秒    " +
		// ((time - SystemClock.elapsedRealtime()) / 1000) + "秒后生效。     " + "" +
		// " sMatchInstanceID=" + sMatchInstanceID);
	}

	public static void removeAlarm2(int NotificationID) {
		if (NotificationID == 0) {
			return;
		}
		AlarmManager am = (AlarmManager) TQLuaAndroidConsole.getGameSceneInstance().getSystemService(Context.ALARM_SERVICE);
		Intent intent = new Intent(ALARM_ACTION);
		PendingIntent mAlarmSender = PendingIntent.getBroadcast(TQLuaAndroidConsole.getGameSceneInstance(), NotificationID + 5000, intent, 0);
		Pub.LOG("移除闹钟：" + mAlarmSender);
		am.cancel(mAlarmSender);

	}

	public static void SaveLastDay(int last_day) {
		// 获取SharedPreferences对象
		Pub.LOG("储存最后登录日期，自己在运行中");
		Context ctx = TQLuaAndroidConsole.getGameSceneInstance();
		SharedPreferences sp = ctx.getSharedPreferences("SP", ctx.MODE_PRIVATE);
		// 存入数据
		Editor editor = sp.edit();
		editor.putInt("LAST_DAY", last_day);
		editor.commit();
	}
}
