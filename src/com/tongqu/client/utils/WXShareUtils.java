package com.tongqu.client.utils;

import java.io.ByteArrayOutputStream;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.widget.Toast;

import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.lord.wxapi.WXEntryActivity;


public class WXShareUtils implements IWXAPIEventHandler{

	public static WXShareUtils mWXShareUtils;
	public static WXShareUtils getInstance() {
		if (mWXShareUtils == null) {
			mWXShareUtils = new WXShareUtils();
		}
		return mWXShareUtils;
	}

	private IWXAPI api;

	private int shareCallBack;

	public static byte[] bmpToByteArray(final Bitmap bmp, final boolean needRecycle) {
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		bmp.compress(CompressFormat.PNG, 100, output);
		if (needRecycle) {
			bmp.recycle();
		}

		byte[] result = output.toByteArray();
		try {
			output.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/***************************微信分享*************************/
	/**
	 * 调用微信分享功能
	 * @param isCircle 是否分享到朋友圈,1为朋友圈,0为好友
	 * @return
	 */
	public static void luaCallWXShare(final float isCircle,final float userID, final int callBack, final String showTitle, final String showMessage) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				WXShareUtils.getInstance().shareToWX((int)isCircle,(int)userID,callBack,showTitle,showMessage);
			}
		});
	}

	/**
	 * 调用微信分享功能
	 * @param isCircle 是否分享到朋友圈,1为朋友圈,0为好友
	 */
	public void shareToWX(int isCircle,int userID,int callBack,String showTitle,String showMessage){
		shareCallBack = callBack;

		//判断是否安装了微信

		Intent intent = new Intent(TQLuaAndroidConsole.getGameSceneInstance(),WXEntryActivity.class);
		intent.putExtra("isCircle", isCircle);
		intent.putExtra("userID", userID);
		intent.putExtra("showTitle", showTitle);
		intent.putExtra("showMessage", showMessage);
		TQLuaAndroidConsole.getGameSceneInstance().startActivity(intent);

	}

	private String buildTransaction(final String type) {
		return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
	}

	@Override
	public void onReq(BaseReq req) {
		// TODO Auto-generated method stub
		Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "req openid = " + req.openId, Toast.LENGTH_SHORT).show();

	}

	@Override
	public void onResp(BaseResp resp) {
		// TODO Auto-generated method stub
		Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "openid = " + resp.openId, Toast.LENGTH_SHORT).show();

		if (resp.getType() == ConstantsAPI.COMMAND_SENDAUTH) {
			Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "code = " + ((SendAuth.Resp) resp).code, Toast.LENGTH_SHORT).show();
		}

		String result = "";

		switch (resp.errCode) {
		case BaseResp.ErrCode.ERR_OK:
			result = "OK";
			break;
		case BaseResp.ErrCode.ERR_USER_CANCEL:
			result = "CANCEL";
			break;
		case BaseResp.ErrCode.ERR_AUTH_DENIED:
			result = "DENIED";
			break;
		default:
			result = "OTHER";
			break;
		}
		final String parameters = result;
		TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
			@Override
			public void run() {
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(shareCallBack, parameters);
				Cocos2dxLuaJavaBridge.releaseLuaFunction(shareCallBack);
			}
		});

		Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), result, Toast.LENGTH_LONG).show();
	}

	public int getCallBack(){
		return shareCallBack;
	}
}
