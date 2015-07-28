package com.tongqu.client.utils;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import com.tongqu.client.game.TQLuaAndroidConsole;

public class MiniGameUtils {

	public static MiniGameUtils mMiniGameUtils;
	public static MiniGameUtils getInstance() {
		if (mMiniGameUtils == null) {
			mMiniGameUtils = new MiniGameUtils();
		}
		return mMiniGameUtils;
	}

	/***************************下载小游戏完整版 lua调用方法*************************/

	public static void luaCallDownloadMiniGame(final String url,final int callBack) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				MiniGameUtils.getInstance().downloadMiniGame(url,callBack);
			}
		});
	}

	/************************下载小游戏***************************/
	public void downloadMiniGame(final String url,final int callBack){
		Downloader.getInst().getDownloadFile(url, "download", DownloadFollowUp.getInst().mDownloadActionHandler, DownloadFollowUp.DOWNLOAD_ACTION_A, false, true);
		TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
			@Override
			public void run() {
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callBack, "");
				Cocos2dxLuaJavaBridge.releaseLuaFunction(callBack);
			}
		});
	}
}
