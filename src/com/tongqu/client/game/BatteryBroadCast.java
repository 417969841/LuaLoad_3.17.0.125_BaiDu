package com.tongqu.client.game;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.tongqu.client.utils.Pub;

public class BatteryBroadCast  extends BroadcastReceiver {
	private static int BatteryPower = -1;
	private static int batteryCallBack;

	@Override
	public void onReceive(Context arg0, Intent arg1) {
		// TODO Auto-generated method stub
		if(Intent.ACTION_BATTERY_CHANGED.equals(arg1.getAction())){
			//获取当前电量
			int level = arg1.getIntExtra("level", 0);
			Pub.LOG("BatteryBroadCast level is " + level);
			//电量的总刻度
			int scale = arg1.getIntExtra("scale", 100);
			Pub.LOG("BatteryBroadCast scale is " + scale);
			//把它转成百分比
			BatteryPower = (level*100)/scale;
		}
	}

	public static void setBatteryPowerToLua(final int callback){
		batteryCallBack = callback;
		TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
			@Override
			public void run() {
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(batteryCallBack, BatteryPower + "");
				Cocos2dxLuaJavaBridge.releaseLuaFunction(batteryCallBack);
			}
		});
	}



}


