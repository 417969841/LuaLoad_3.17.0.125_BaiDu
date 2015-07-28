package com.tongqu.client.lord;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.duoku.platform.single.DKPlatform;
import com.duoku.platform.single.DKPlatformSettings;
import com.duoku.platform.single.DkErrorCode;
import com.duoku.platform.single.DkProtocolKeys;
import com.duoku.platform.single.callback.IDKSDKCallBack;
import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.utils.Pub;




public class BaiDuBaseActivity extends Activity {
	public static int javaCallBackLua = 0;
	private static BaiDuBaseActivity instance;

	public static BaiDuBaseActivity getInstance() {
		return instance;
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		//初始化函数
		DKPlatform.getInstance().init(this, true, DKPlatformSettings.SdkMode.SDK_PAY,null,null,new IDKSDKCallBack(){
			@Override
			public void onResponse(String paramString) {
				Log.d("GameMainActivity", paramString);
				try {
					JSONObject jsonObject = new JSONObject(paramString);
					// 返回的操作状态码
					int mFunctionCode = jsonObject.getInt(DkProtocolKeys.FUNCTION_CODE);

					// 初始化完成
					if (mFunctionCode == DkErrorCode.BDG_CROSSRECOMMEND_INIT_FINSIH) {

						Intent intent = new Intent(BaiDuBaseActivity.this,
								TQLuaAndroidConsole.getGameMainSceneClass());
						startActivity(intent);
						finish();

					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * 回调lua
	 */
	public static void javaCallbackTOlua() {
		TQGameMainScene.getInstance().runOnGLThread(new Runnable() {
			@Override
			public void run() {

				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(
						javaCallBackLua, "");
				Cocos2dxLuaJavaBridge.releaseLuaFunction(javaCallBackLua);
			}
		});
	}

	public static void baiDuExitGame(final int callBack) {
		TQGameMainScene.getInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				javaCallBackLua = callBack;
				Pub.LOG("baiduExitGame ======== ");
				DKPlatform.getInstance().bdgameExit(
						TQLuaAndroidConsole.getGameSceneInstance(),
						new IDKSDKCallBack() {
							// @Override
							public void onResponse(String paramString) {
								Toast.makeText(
										TQLuaAndroidConsole.getGameSceneInstance(),
										"退出游戏", Toast.LENGTH_LONG).show();
								TQLuaAndroidConsole.getGameSceneInstance().finish();
								javaCallbackTOlua();
							}
						});
			}
		});
	}

}