package com.tongqu.client.utils;

import java.util.Calendar;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;

import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.lord.R;

public class PushMessageService extends Service {

	@Override
	public IBinder onBind(Intent intent) {
		// TODO Auto-generated method stub
		return null;
	}

	public void onCreate() {
		// TODO: Actions to perform when service is created.
		mHandler.sendEmptyMessage(CHECK);
	}

	public void onStart(Intent intent, int startId) {
		// TODO: Actions to perform when service is started.
	}

	static int SEND_DAY = 0;
	final static int CHECK = 1;
	// 开启一个线程
	Handler mHandler = new Handler() {

		@Override
		public void handleMessage(Message msg) {
			// TODO Auto-generated method stub
			super.handleMessage(msg);
			switch (msg.what) {
			case CHECK:
				Calendar c = Calendar.getInstance();
				int day = c.get(Calendar.DAY_OF_MONTH);
				int hour = c.get(Calendar.HOUR_OF_DAY);

				// 获取SharedPreferences对象
				Context ctx = TQLuaAndroidConsole.getGameSceneInstance();
				SharedPreferences sp = ctx.getSharedPreferences("SP", MODE_PRIVATE);
				int lastDay = sp.getInt("LAST_DAY", 0);
				if (lastDay == 0) {
					break;
				}
				if (hour == 12 && lastDay != day) {
					if (SEND_DAY != day) {
						SEND_DAY = day;
						NotificationManager notificationManager = (NotificationManager) this.getSystemService(android.content.Context.NOTIFICATION_SERVICE);
						// 定义Notification的各种属性
						Notification notification = new Notification(R.drawable.icon, "疯狂斗地主签到提醒", System.currentTimeMillis());
						notification.icon = R.drawable.icon;
						notification.tickerText = "您今天还未登录游戏，别忘了领取";
						notification.defaults = Notification.DEFAULT_LIGHTS;
						Intent intent = null;
						if (TQLuaAndroidConsole.getGameSceneInstance() != null) {
							intent = new Intent(TQLuaAndroidConsole.getGameSceneInstance(), TQLuaAndroidConsole.getGameMainSceneClass());
						} else {
							intent = new Intent(TQLuaAndroidConsole.getGameSceneInstance(), TQLuaAndroidConsole.getLoadActivityClass());
						}
						// 获取PendingIntent,点击时发送该Intent
						PendingIntent pIntent = PendingIntent.getActivity(TQLuaAndroidConsole.getGameSceneInstance(), 0, intent, 0);
						notificationManager.notify(0, notification);

					}
				} else {
					mHandler.sendEmptyMessageDelayed(CHECK, 60000);
				}
				break;
			}
		}

		private NotificationManager getSystemService(String notificationService) {
			// TODO Auto-generated method stub
			return null;
		}

	};

	public static void SaveLastDay(int last_day) {
		// 获取SharedPreferences对象
		Pub.LOG("储存最后登录日期，自己在运行中");
		Context ctx = TQLuaAndroidConsole.getGameSceneInstance();
		SharedPreferences sp = ctx.getSharedPreferences("SP", MODE_PRIVATE);
		// 存入数据
		Editor editor = sp.edit();
		editor.putInt("LAST_DAY", last_day);
		editor.commit();

	}
}
