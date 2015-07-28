package com.tongqu.client.utils;

import android.content.Intent;
import android.content.IntentFilter;

import com.tongqu.client.game.BatteryBroadCast;
import com.tongqu.client.game.MatchAlarmBroadCast;
import com.tongqu.client.game.TQLuaAndroidConsole;

public class BroadCastUtils {

	public static BroadCastUtils mBroadCastUtils;
	public static BroadCastUtils getInstance() {
		if (mBroadCastUtils == null) {
			mBroadCastUtils = new BroadCastUtils();
		}
		return mBroadCastUtils;
	}

	//添加闹钟
	public static void luaCallAddAlarm(final String nGameID, final String nMatchID, final String nAlertTime, final String sMatchInstanceID, final String matchTitle) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				int gameID = Integer.parseInt(nGameID);
				int matchID = Integer.parseInt(nMatchID);
				long alertTime = Long.parseLong(nAlertTime);
				Pub.LOG("luaCallAddAlarm done");
				MatchAlarmBroadCast.addAlarm(gameID, matchID, alertTime, sMatchInstanceID, matchTitle);
//				WXShareUtils.getInstance().shareToWX((int)isCircle,(int)userID,callBack);
			}
		});
	}

	//删除闹钟
	public static void luaCallremoveAlarm(final String nGameID, final String nMatchID) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				int gameID = Integer.parseInt(nGameID);
				int matchID = Integer.parseInt(nMatchID);
				Pub.LOG("luaCallremoveAlarm done");
				MatchAlarmBroadCast.removeAlarm(gameID, matchID);
//				WXShareUtils.getInstance().shareToWX((int)isCircle,(int)userID,callBack);
			}
		});
	}

	//获取电池电量
	public static void luaCallGetBattery(final int callback){
		Pub.LOG("luaCallGetBattery");
		IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		BatteryBroadCast batteryReceiver = new BatteryBroadCast();
        TQLuaAndroidConsole.getGameSceneInstance().registerReceiver(batteryReceiver, intentFilter);
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				BatteryBroadCast.setBatteryPowerToLua(callback);
			}
		});
	}
}
