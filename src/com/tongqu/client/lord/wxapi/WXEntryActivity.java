package com.tongqu.client.lord.wxapi;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.Menu;
import android.widget.Toast;

import com.pay.weixinpay.Constants;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXWebpageObject;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.lord.R;
import com.tongqu.client.utils.Pub;
import com.tongqu.client.utils.WXShareUtils;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler{

	// IWXAPI 是第三方app和微信通信的openapi接口
    private IWXAPI api;
    int isCircle;
    int userID;
    String showTitle;
    String showMessage;
    private static String AppDownLoadURL = "";

    //设置微信分享的app下载URL
    public static void setWeChatShareAppDownLoadURL(String sAppDownLoadURL){
    	AppDownLoadURL = sAppDownLoadURL;
    	Pub.LOG("test setWeChatShareAppDownLoadURL URI == " + AppDownLoadURL);
    }

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		api = WXAPIFactory.createWXAPI(this, Constants.APP_ID, false);
		setContentView(R.layout.activity_wxentry);
		// 通过WXAPIFactory工厂，获取IWXAPI的实例
    	api.registerApp(Constants.APP_ID);
    	Intent intent = getIntent();
    	api.handleIntent(getIntent(), this);
    	isCircle = intent.getIntExtra("isCircle", 2);
    	userID = intent.getIntExtra("userID", 0);
    	showTitle = intent.getStringExtra("showTitle");
    	showMessage = intent.getStringExtra("showMessage");
    	Pub.LOG("WXEntryActivity onCreate isCircle === " + isCircle);
    	if (api.isWXAppInstalled() == false){
    		Toast.makeText(this, "不装微信不能分享给好友哦！", Toast.LENGTH_LONG).show();
    		finish();
    	}
    	if(isCircle == 2){
    		return;
    	}

    	WXWebpageObject webpage = new WXWebpageObject();
		webpage.webpageUrl = AppDownLoadURL;
		WXMediaMessage msg = new WXMediaMessage(webpage);
//		msg.title = "你敢来我敢送！玩一局就送2元话费咯！";
//		msg.description = "2015年最好玩的斗地主游戏来啦！现在登录游戏就送2元话费，我已经拿到了，快来试试吧！";
		msg.title = showTitle;
		msg.description = showMessage;
		//图片不能超过32K,否则无法弹出微信页面
		Bitmap thumb = BitmapFactory.decodeResource(getResources(), R.drawable.icon_72);
		msg.thumbData = WXShareUtils.getInstance().bmpToByteArray(thumb, true);
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = buildTransaction("webpage");
		req.message = msg;
		if(isCircle == 1){
			//分享到朋友圈
			req.scene = SendMessageToWX.Req.WXSceneTimeline;//isTimelineCb.isChecked() ? SendMessageToWX.Req.WXSceneTimeline : SendMessageToWX.Req.WXSceneSession;
		}else{
			//分享到好友
			req.scene = SendMessageToWX.Req.WXSceneSession;
		}
		req.openId = null;//getOpenId();
		api.sendReq(req);
		finish();
	}

	private String buildTransaction(final String type) {
		return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.wxentry, menu);
		return true;
	}

	@Override
	public void onReq(BaseReq req) {
		// TODO Auto-generated method stub
		Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "req openid = " + req.openId, Toast.LENGTH_SHORT).show();
	}

	@Override
	public void onResp(BaseResp resp) {
		// TODO Auto-generated method stub
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
		final String callBackString = result;
		TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
			@Override
			public void run() {
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(WXShareUtils.getInstance().getCallBack(), callBackString);
				Cocos2dxLuaJavaBridge.releaseLuaFunction(WXShareUtils.getInstance().getCallBack());
			}
		});
		finish();
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		switch (requestCode) {

		case 0x101: {
	    	WXWebpageObject webpage = new WXWebpageObject();
			webpage.webpageUrl = AppDownLoadURL;
			WXMediaMessage msg = new WXMediaMessage(webpage);
			msg.title = "你敢来我敢送！玩一局就送2元话费咯！";
			msg.description = "2015年最好玩的斗地主游戏来啦！现在登录游戏就送2元话费，我已经拿到了，快来试试吧！";
			Bitmap thumb = BitmapFactory.decodeResource(getResources(), R.drawable.icon);
			msg.thumbData = WXShareUtils.getInstance().bmpToByteArray(thumb, true);
			SendMessageToWX.Req req = new SendMessageToWX.Req();
			req.transaction = buildTransaction("webpage");
			req.message = msg;
			if(isCircle == 1){
				//分享到朋友圈
				req.scene = SendMessageToWX.Req.WXSceneTimeline;//isTimelineCb.isChecked() ? SendMessageToWX.Req.WXSceneTimeline : SendMessageToWX.Req.WXSceneSession;
			}else{
				//分享到好友
				req.scene = SendMessageToWX.Req.WXSceneSession;
			}
			req.openId = null;//getOpenId();
			api.sendReq(req);
			finish();
			break;
		}
		default:
			break;
		}
	}

}
