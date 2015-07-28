package com.tongqu.client.game;

import java.util.Calendar;
import java.util.List;

import android.app.ActivityManager;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.app.ActivityManager.RunningTaskInfo;
import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.SystemClock;
import android.text.TextUtils;

import com.tongqu.client.config.GameConfig;
import com.tongqu.client.lord.R;
import com.tongqu.client.utils.Pub;

public class MatchAlarmBroadCast extends BroadcastReceiver {

	public static final String ALARM_ACTION = Pub.getAndroidPackagekName() + ".alarm";

	public static final int ALARM_ACTION_DIALOG = 1;// 闹钟提示类型：弹框
	public static final int ALARM_ACTION_NOTIFICATION = 2;// 闹钟提示类型：通知

	@Override
	public void onReceive(Context context, Intent intent) {
		// TODO Auto-generated method stub
		// 判断是不是系统推送消息
		if (intent.getIntExtra("NotificationPushMessage", 0) == 1) {
			// 判断闹钟类型
			if (intent.getIntExtra("ActionID", 0) == 2) {
				Calendar c = Calendar.getInstance();
				int day = c.get(Calendar.DAY_OF_MONTH);
				int hour = c.get(Calendar.HOUR_OF_DAY);
				Context ctx = TQLuaAndroidConsole.getGameSceneInstance();
				SharedPreferences sp = ctx.getSharedPreferences("SP", ctx.MODE_PRIVATE);
				int lastDay = sp.getInt("LAST_DAY", 0);
				if (lastDay == 0) {
					return;
				}
				if (day != lastDay) {
					NotificationManager notificationManager = (NotificationManager) context.getSystemService(context.NOTIFICATION_SERVICE);
					// android.content.Context.NOTIFICATION_SERVICE
					// 定义Notification的各种属性
					Notification notification = new Notification();
					notification.icon = R.drawable.icon;
					notification.tickerText = intent.getStringExtra("Content");
					notification.defaults = Notification.DEFAULT_LIGHTS;
					notification.when = System.currentTimeMillis();
					notification.flags |= Notification.FLAG_AUTO_CANCEL; // 点击清除按钮或点击通知后会自动消失
					Intent intentPendingIntent = null;
					if (TQLuaAndroidConsole.getGameSceneInstance() != null) {
						intentPendingIntent = new Intent(context, TQLuaAndroidConsole.getGameMainSceneClass());
					} else {
						intentPendingIntent = new Intent(context, TQLuaAndroidConsole.getLoadActivityClass());
					}
					// 获取PendingIntent,点击时发送该Intent
					PendingIntent pIntent = PendingIntent.getActivity(TQLuaAndroidConsole.getGameSceneInstance(), 0, intentPendingIntent, 0);
					notification.setLatestEventInfo(context, intent.getStringExtra("Title"), intent.getStringExtra("Content"), pIntent);
					notificationManager.notify(0, notification);
				} else {
				}

			}
			// 闹钟类型
			else if (intent.getIntExtra("ActionID", 0) == 1) {
				NotificationManager notificationManager = (NotificationManager) context.getSystemService(context.NOTIFICATION_SERVICE);
				// android.content.Context.NOTIFICATION_SERVICE
				// 定义Notification的各种属性
				Notification notification = new Notification();
				notification.icon = R.drawable.icon;
				notification.tickerText = intent.getStringExtra("Content");
				notification.defaults = Notification.DEFAULT_LIGHTS;
				notification.when = System.currentTimeMillis();
				notification.flags |= Notification.FLAG_AUTO_CANCEL; // 点击清除按钮或点击通知后会自动消失
				Intent intentPendingIntent = null;
				if (TQLuaAndroidConsole.getGameSceneInstance() != null) {
					intentPendingIntent = new Intent(context, TQLuaAndroidConsole.getGameMainSceneClass());
				} else {
					intentPendingIntent = new Intent(context, TQLuaAndroidConsole.getLoadActivityClass());
				}
				// 获取PendingIntent,点击时发送该Intent
				PendingIntent pIntent = PendingIntent.getActivity(TQLuaAndroidConsole.getGameSceneInstance(), 0, intentPendingIntent, 0);
				notification.setLatestEventInfo(context, intent.getStringExtra("Title"), intent.getStringExtra("Content"), pIntent);
				notificationManager.notify(0, notification);
			}

			// 再次创建新的闹钟
			if (intent.getIntExtra("ActionID", 0) == 1) {

			} else if (intent.getIntExtra("ActionID", 0) == 2) {
				Calendar c = Calendar.getInstance();
				int day = c.get(Calendar.DAY_OF_MONTH);
				int hour = c.get(Calendar.HOUR_OF_DAY);
				Context ctx = TQLuaAndroidConsole.getGameSceneInstance();
				SharedPreferences sp = ctx.getSharedPreferences("SP", ctx.MODE_PRIVATE);
				int lastDay = sp.getInt("LAST_DAY", 0);
				if (lastDay == 0) {
					return;
				}
				AlarmManager am = (AlarmManager) TQLuaAndroidConsole.getGameSceneInstance().getSystemService(Context.ALARM_SERVICE);
				Intent intent_re = new Intent(ALARM_ACTION);
				Bundle b = new Bundle();
				b.putInt("NotificationID", intent.getIntExtra("NotificationID", 0));
				b.putInt("NotificationPushMessage", 1);
				b.putLong("BeforeMillions", 86400000);
				b.putInt("ActionID", intent.getIntExtra("ActionID", 1));
				b.putString("Title", intent.getStringExtra("Title"));
				b.putString("Content", intent.getStringExtra("Content"));
				intent.putExtras(b);
				PendingIntent mAlarmSender = PendingIntent.getBroadcast(TQLuaAndroidConsole.getGameSceneInstance(), intent.getIntExtra("NotificationID", 0) + 5000, intent_re, 0);
				am.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, SystemClock.elapsedRealtime() + 86400000, mAlarmSender);
			}

		} else if (ALARM_ACTION.equals(intent.getAction())) {
			int flag = intent.getIntExtra("flag", 999);
			Pub.LOG("收到闹钟启动广播 flag = " + flag);
			Bundle b = intent.getExtras();
			int gameid = b.getInt("gameid");
			int matchid = b.getInt("matchid");
			long beginTime = b.getLong("beginTime");
			long howLong = b.getLong("howLong");
			String matchtitle = b.getString("matchtitle");
			String matchInstanceID = b.getString("matchInstanceID");
			if (flag == ALARM_ACTION_DIALOG) {
				// 弹框
				// 通过有没有Activity来判断当前进程是为正常游戏还是通过广播启动的
				if (TQLuaAndroidConsole.getGameSceneInstance() != null && isRunningForeground(context)) {
					Pub.LOG("闹钟弹框，自己在运行中");
					return;
				} else {
					Pub.LOG("闹钟弹框，自己没运行");
				}
				if (isTongquAppRunning(context)) {
					Pub.LOG("闹钟弹框，自己不在运行中，其他同趣产品在运行");
					Pub.LOG("退出");
					System.exit(0);
					return;
				}
				Pub.LOG("currentTimeMillis is " + System.currentTimeMillis() + ";beginTime " + beginTime + ";howLong " + howLong);
				if (System.currentTimeMillis() > beginTime + howLong + 10000) {
					Pub.LOG("闹铃过期,不显示");
				} else {
					startNewMatchPrompt(context, flag, gameid, matchid, matchtitle, matchInstanceID);
				}
			} else if (flag == ALARM_ACTION_NOTIFICATION) {
				// 通知
				if (TQLuaAndroidConsole.getGameSceneInstance() != null && isRunningForeground(context)) {
					Pub.LOG("闹钟通知，自己在运行中");
				} else {
					Pub.LOG("currentTimeMillis is " + System.currentTimeMillis() + ";beginTime " + beginTime + ";howLong " + howLong);
					if (System.currentTimeMillis() > beginTime + howLong + 10000) {
						Pub.LOG("闹铃过期,不显示");
					} else {
						showNotifaction(context, matchtitle);
					}
				}
			} else if (flag == 3) {
				// 通过有没有Activity来判断当前进程是为正常游戏还是通过广播启动的
				if (TQLuaAndroidConsole.getGameSceneInstance() != null) {
					Pub.LOG("闹钟3，自己在运行中");
					return;
				} else {
					Pub.LOG("闹钟3，自己没运行");
				}

				if (isTongquAppRunning(context)) {
					Pub.LOG("闹钟3，自己不在运行中，其他同趣产品在运行");
					Pub.LOG("退出");
					System.exit(0);
					return;
				}
				startGame(context);
			}
		}
	}

	/**
	 * 通知提示进游戏
	 *
	 * @param context
	 * @param matchtitle
	 */
	private void showNotifaction(Context context, String matchtitle) {
		// TODO Auto-generated method stub
		int ID = 1;
		String service = context.NOTIFICATION_SERVICE;
		NotificationManager nManager = (NotificationManager) context.getSystemService(service);
		Notification notification = new Notification();
		String tickerText = context.getResources().getString(R.string.app_name); // 通知提示
		long when = System.currentTimeMillis();
		notification.icon = R.drawable.icon;// 设置通知的图标
		notification.tickerText = tickerText; // 显示在状态栏中的文字
		notification.when = when;
		notification.flags |= Notification.FLAG_AUTO_CANCEL; // 点击清除按钮或点击通知后会自动消失
		notification.defaults = Notification.DEFAULT_SOUND; // 调用系统自带声音
		Intent intent = null;
		if (TQLuaAndroidConsole.getGameSceneInstance() != null) {
			intent = new Intent(context, TQLuaAndroidConsole.getGameMainSceneClass());
		} else {
			intent = new Intent(context, TQLuaAndroidConsole.getLoadActivityClass());
		}
		// 获取PendingIntent,点击时发送该Intent
		PendingIntent pIntent = PendingIntent.getActivity(context, 0, intent, 0);
		// 设置通知的标题和内容
		notification.setLatestEventInfo(context, tickerText, "您报名的【" + matchtitle + "】比赛将在5分钟后开始，请做好准备！", pIntent);
		nManager.notify(ID, notification);
	}

	private void startGame(Context context) {
		Intent intent = new Intent();
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		Bundle bundle = new Bundle();
		intent.putExtras(bundle);
		intent.setClass(context, MatchAlarmPromptActivity.class);
		context.startActivity(intent);
	}

	/**
	 * 弹框提示进游戏
	 *
	 * @param context
	 * @param flag
	 * @param gameid
	 * @param matchid
	 * @param matchtitle
	 * @param matchInstanceID
	 */
	private void startNewMatchPrompt(Context context, int flag, int gameid, int matchid, String matchtitle, String matchInstanceID) {
		Intent intent = new Intent();
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		Bundle bundle = new Bundle();
		bundle.putInt("gameid", gameid);
		bundle.putInt("matchid", matchid);
		bundle.putString("matchtitle", matchtitle);
		bundle.putString("matchInstanceID", matchInstanceID);
		intent.putExtras(bundle);
		intent.setClass(context, MatchAlarmPromptActivity.class);
		context.startActivity(intent);
	}

	/**
	 * 是否有同趣游戏在运行中
	 *
	 * @return
	 */
	private boolean isTongquAppRunning(Context context) {
		Pub.LOG("isTongquAppRunning");
		ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
		// 获取正在运行的应用
		List<RunningAppProcessInfo> run = am.getRunningAppProcesses();
		int i = 0;
		for (RunningAppProcessInfo ra : run) {
			// Pub.LOG("i=" + i);
			// i++;
			// 这里主要是过滤系统的应用和电话应用
			if (ra.processName.equals("system") || ra.processName.equals("com.android.phone")) {
				continue;
			}
			if (ra.processName.indexOf("com.tongqu.client") >= 0 && ra.processName.indexOf("com.tongqu.client." + GameConfig.APP_NAME) == -1) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 判断游戏是在前台运行还是在后台运行
	 *
	 * @return
	 */
	public static boolean isBackground(Context context) {
		ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
		List<RunningAppProcessInfo> appProcesses = activityManager.getRunningAppProcesses();
		for (RunningAppProcessInfo appProcess : appProcesses) {
			if (appProcess.processName.equals(context.getPackageName())) {
				if (appProcess.importance == RunningAppProcessInfo.IMPORTANCE_BACKGROUND) {
					Pub.LOG("isBackground false 后台 " + appProcess.processName);
					return false;
				} else {
					Pub.LOG("isBackground true 前台 " + appProcess.processName);
					return true;
				}
			}
		}
		Pub.LOG("isBackground false over");
		return false;
	}

	/**
	 * 判断游戏是在前台运行还是在后台运行
	 *
	 * @return
	 */
	private boolean isRunningForeground(Context context) {
		ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
		ComponentName cn = am.getRunningTasks(1).get(0).topActivity;
		String currentPackageName = cn.getPackageName();
		if (!TextUtils.isEmpty(currentPackageName) && currentPackageName.equals(context.getPackageName())) {
			Pub.LOG("isRunningForeground true 前台 ");
			return true;
		}
		Pub.LOG("isRunningForeground false 后台 ");
		return false;
	}

	/**
	 * 指定Activity是否为屏幕显示
	 *
	 * @param sActivityName
	 * @return
	 */
	private boolean isTopActivity(Context context, String sActivityName) {
		// "com.tongqu.client." + Const.APP_NAME + ".LordActivity";
		ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
		List<RunningTaskInfo> tasksInfo = activityManager.getRunningTasks(1);
		if (tasksInfo.size() > 0) {
			String sCurrActivity = tasksInfo.get(0).topActivity.getClassName();
			Pub.LOG("当前Activity是：" + sCurrActivity);
			// 应用程序位于堆栈的顶层
			if (sActivityName.equals(sCurrActivity)) {
				return true;
			}
		}
		return false;
	}

	// ///////////////////////////////
	/**
	 * 添加闹钟
	 *
	 * @param nGameID
	 * @param nMatchID
	 * @param nAlertTime倒计时时间
	 * @param sMatchInstanceID
	 * @param matchTitle
	 */
	public static void addAlarm(int nGameID, int nMatchID, long nAlertTime, String sMatchInstanceID, String matchTitle) {
		// 闹钟
		Pub.LOG("闹钟 addAlarm =================== nAlertTime == " + nAlertTime);
		AlarmManager am = (AlarmManager) TQLuaAndroidConsole.getGameSceneInstance().getSystemService(Context.ALARM_SERVICE);
		for (int i = 1; i < 3; i++) {
			long time;
			if (i == 1) {
				// 弹框提示
				time = nAlertTime - 120 * 1000;// 两分钟
			} else {
				// 通知提示
				time = nAlertTime - 300 * 1000;// 五分钟
			}
			time = time + SystemClock.elapsedRealtime();
			if (time < SystemClock.elapsedRealtime() + 10000) {
				Pub.LOG("闹钟已经过期，不再增加   time == " + time);
				continue;
			}
			Intent intent = new Intent(ALARM_ACTION);
			Bundle b = new Bundle();
			b.putInt("gameid", nGameID);
			b.putInt("matchid", nMatchID);
			b.putString("matchtitle", matchTitle);
			b.putString("matchInstanceID", sMatchInstanceID);
			b.putLong("beginTime", System.currentTimeMillis());
			b.putLong("howLong", time - SystemClock.elapsedRealtime());
			b.putInt("currgameid", GameConfig.GAME_ID);
			b.putString("apkname", "com.tongqu.client." + GameConfig.APP_NAME);
			intent.putExtra("flag", i);
			intent.putExtras(b);
			int requestCode = nMatchID * 10000 + i;
			PendingIntent mAlarmSender = PendingIntent.getBroadcast(TQLuaAndroidConsole.getGameSceneInstance(), requestCode, intent, 0);
			am.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, time, mAlarmSender);
			Pub.LOG("elapsedRealtime is " + SystemClock.elapsedRealtime() + ";time is " + time);
			Pub.LOG("增加闹钟:" + (time - SystemClock.elapsedRealtime()) + "毫秒    " + ((time - SystemClock.elapsedRealtime()) / 1000) + "秒后生效。     " + "" + " sMatchInstanceID=" + sMatchInstanceID);
		}
	}

	/**
	 * 删除闹钟
	 *
	 * @param nGameID
	 * @param nMatchID
	 */
	public static void removeAlarm(int nGameID, int nMatchID) {
		AlarmManager am = (AlarmManager) TQLuaAndroidConsole.getGameSceneInstance().getSystemService(Context.ALARM_SERVICE);
		for (int i = 1; i < 3; i++) {
			int requestCode = nMatchID * 10000 + i;
			Intent intent = new Intent(ALARM_ACTION);
			PendingIntent mAlarmSender = PendingIntent.getBroadcast(TQLuaAndroidConsole.getGameSceneInstance(), requestCode, intent, 0);
			Pub.LOG("移除闹钟：" + mAlarmSender);
			am.cancel(mAlarmSender);
		}
	}

}
