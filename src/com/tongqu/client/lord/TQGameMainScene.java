/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 ****************************************************************************/
package com.tongqu.client.lord;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;
import java.util.HashMap;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Display;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.Toast;

import com.duoku.platform.single.DKPlatform;
import com.duoku.platform.single.callback.IDKSDKCallBack;
import com.pay.alipay.AliPayment;
import com.pay.smsunicom.SMSUnicomPayment;
import com.pay.weixinpay.WeiXinPayment;
import com.testin.agent.TestinAgent;
import com.tongqu.client.entity.ImageInfo;
import com.tongqu.client.game.LuaUpdateConsole;
import com.tongqu.client.game.TQGameAndroidBridge;
import com.tongqu.client.utils.DownloadFollowUp;
import com.tongqu.client.utils.Downloader;
import com.tongqu.client.utils.Pub;
import com.tongqu.client.utils.res.DownloadTask;
import com.tongqu.client.utils.res.HttpEngine;
import com.tongqu.client.utils.res.RemoteResMgr;
import com.umeng.analytics.MobclickAgent;

public class TQGameMainScene extends Cocos2dxActivity {

	private static TQGameMainScene instance;

	public static TQGameMainScene getInstance() {
		return instance;
	}

	public static int WIDTH = 0;
	public static int HEIGHT = 0;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		instance = this;
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON); // 应用运行时，保持屏幕高亮，不锁屏
		// 获取c++错误日志
		// CppLogCatch.getLog();
		// 自动捕获异常退出
		MobclickAgent.onError(this);
		// 在线发送策略配置 ，客户端的数据发送策略，将按照网页上配置的情况来设置
		MobclickAgent.updateOnlineConfig(this);
		// Testin异常捕获
		TestinAgent.init(this, "5d8046991c2a9f91b308fd70564bc27a");
		Display display = getWindowManager().getDefaultDisplay();
		WIDTH = display.getWidth();
		HEIGHT = display.getHeight();
		if (HEIGHT > WIDTH) {
			int temp = HEIGHT;
			HEIGHT = WIDTH;
			WIDTH = temp;
		}
		DKPlatform.getInstance().bdgameInit(this, new IDKSDKCallBack() {
			@Override
			public void onResponse(String paramString) {
				Log.d("GameMainActivity","bggameInit success");

			}
		});
		WeiXinPayment.getInstance();
		AliPayment.getInstance();
		SMSUnicomPayment.getInstance();
		Downloader.getInst();

		LuaUpdateConsole.logicScriptLoadDir();

		TQGameAndroidBridge.getInstance().scriptManage();
	}

	static {
		System.loadLibrary("cocos2dlua");
	}

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		MobclickAgent.onResume(this);
		TestinAgent.onResume(this);// 此行必须放在super.onResume后
		TQGameAndroidBridge.getInstance().onResume();
	}

	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
		MobclickAgent.onPause(this);
		TQGameAndroidBridge.getInstance().onPause();
	}

	@Override
	protected void onStop() {
		// TODO Auto-generated method stub
		super.onStop();
		TestinAgent.onStop(this);// 此行必须放在super.onStop后
	}

	// 下载的需要安装APK存放路径
	public static final String DIR_DOWNLOAD_APK = "download";

	public static final int UPDATA_BACKGROUND_DOWNLORD = 1;// 后台下载
	public static final int UPDATA_DOWNLORD = 2;// 更新下载

	public static String msApkData;

	public static Handler downloadHandler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case UPDATA_BACKGROUND_DOWNLORD:
				int netType = Pub.getConnectionType();
				if (netType == Pub.NET_WIFI) {
					Downloader.getInst().getDownloadFile((String) msg.obj, DIR_DOWNLOAD_APK, DownloadFollowUp.getInst().mDownloadActionHandler, DownloadFollowUp.DOWNLOAD_ACTION_E, true, false);
				}
				break;
			case UPDATA_DOWNLORD:
				Downloader.getInst().getDownloadFile((String) msg.obj, DIR_DOWNLOAD_APK, DownloadFollowUp.getInst().mDownloadActionHandler, DownloadFollowUp.DOWNLOAD_ACTION_A, false, true);
				break;
			default:
				break;
			}
		}
	};

	private static LinearLayout webViewLayout;
	private static WebView m_webView;

	/**
	 * 显示webview
	 *
	 * @param x
	 * @param y
	 * @param width
	 * @param height
	 * @param url
	 */
	public static void displayWebView(final float x, final float y, final float width, final float height, final String url, final String sCode) {
		getInstance().runOnUiThread(new Runnable() {
			public void run() {
				// GameApplication.getCurrentActivity()为成员变量，是当前的Activity。
				// m_webView是WebView类型的成员变量
				webViewLayout = new LinearLayout(getInstance());
				getInstance().addContentView(webViewLayout, new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));
				m_webView = new WebView(getInstance());
				m_webView.setVisibility(View.VISIBLE);
				webViewLayout.addView(m_webView);

				LinearLayout.LayoutParams linearParams = (LinearLayout.LayoutParams) m_webView.getLayoutParams();
				// 可选的webview位置，x,y,width,height可任意填写，也可以做为函数参数传入。
				float ScaleX = (float) WIDTH / (float) 1136;
				float ScaleY = (float) HEIGHT / (float) 640;
				linearParams.width = (int) (width * ScaleX);
				linearParams.height = (int) (height * ScaleY);
				linearParams.leftMargin = (int) (x * ScaleX);// 左
				linearParams.topMargin = HEIGHT - ((int) (y * ScaleY) + linearParams.height);// 上
				m_webView.setLayoutParams(linearParams);
				// 可选的webview配置
				m_webView.setBackgroundColor(0);
				m_webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
				m_webView.getSettings().setAppCacheEnabled(false);
				m_webView.getSettings().setJavaScriptEnabled(true);
				if (url != null && !url.equals("")) {
					m_webView.loadUrl(url);
				} else if (sCode != null && !sCode.equals("")) {
					m_webView.loadDataWithBaseURL("", sCode, "text/html", "UTF-8", "");
				}
			}
		});
	}

	/**
	 * 隐藏webview
	 */
	public static void removeWebView() {
		getInstance().runOnUiThread(new Runnable() {
			public void run() {
				if (m_webView != null && webViewLayout != null) {
					m_webView.setVisibility(View.INVISIBLE);
					webViewLayout.removeView(m_webView);
					// m_webView.destroy();
				}
			}
		});
	}

	public static int userid;
	public static String password;
	public static long TimeDifference = 0;
	public static int uploadingPhotoCallBackFunction;

	/**
	 * 设置用户ID
	 *
	 * @param userID
	 */
	public static void setUserID(float userID) {
		userid = (int) userID;
		TestinAgent.setUserInfo("userid:" + userid);
	}

	/**
	 * 上传头像
	 *
	 * @param userID
	 * @param str
	 */
	public static void uploadingPhoto(float userID, String str, final int luaCallbackFunction) {
		userid = (int) userID;
		password = str;
		uploadingPhotoCallBackFunction = luaCallbackFunction;
		getInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				new AlertDialog.Builder(getInstance()).setTitle("方式选择").setItems(new String[] { "相册", "拍照" }, new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
						selectPortrait(which);
					}
				}).show();
			}
		});
	}

	// 头像选取相关
	// 照片
	public ByteArrayOutputStream mPhotoStream;
	private static String mTmpPhotoFileName;
	public static final String IMAGE_UNSPECIFIED = "image/*";
	public static final int NONE = 0;
	public static final int PHOTOHRAPH = 1;// 拍照
	public static final int PHOTOZOOM = 2; // 缩放
	public static final int PHOTORESOULT = 3;// 结果

	public static final int MODE_GALLERY = 0;// 上传图片来源 相册
	public static final int MODE_CAMERA = 1;// 上传图片来源 拍照

	public static void selectPortrait(int mode) {
		try {
			switch (mode) {
			case MODE_GALLERY:
				Intent intent = new Intent(Intent.ACTION_PICK, null);
				intent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, IMAGE_UNSPECIFIED);
				getInstance().startActivityForResult(intent, PHOTOZOOM);
				break;
			case MODE_CAMERA:
				intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
				mTmpPhotoFileName = "temp" + System.currentTimeMillis() + ".jpg";
				intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(new File(Environment.getExternalStorageDirectory(), mTmpPhotoFileName)));
				getInstance().startActivityForResult(intent, PHOTOHRAPH);
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void onActivityResult(final int requestCode, final int resultCode, final Intent data) {
		try {

			// TODO Auto-generated method stub
			if (resultCode == NONE) {
				return;
			}
			// 拍照
			if (requestCode == PHOTOHRAPH) {
				// 设置文件保存路径这里放在跟目录下
				File picture = new File(Environment.getExternalStorageDirectory(), mTmpPhotoFileName);
				startPhotoZoom(Uri.fromFile(picture));
			}

			if (data == null) {
				return;
			}
			// 读取相册缩放图片
			if (requestCode == PHOTOZOOM) {
				startPhotoZoom(data.getData());
			}
			// 处理结果
			if (requestCode == PHOTORESOULT) {
				Bundle extras = data.getExtras();
				if (extras != null) {
					Bitmap photo = extras.getParcelable("data");
					mPhotoStream = new ByteArrayOutputStream();
					photo.compress(Bitmap.CompressFormat.JPEG, 75, mPhotoStream);// (0
					if (mPhotoStream != null) {
						Message msg = new Message();
						msg.what = HANDLER_MSG_UPLOAD_PHOTO;
						uploadHandler.sendMessage(msg);
					}
				}
			}

			// // --------------- 新银联返回结果 -----------------
			// String msg = "";
			// /*
			// * 支付控件返回字符串:success、fail、cancel 分别代表支付成功，支付失败，支付取消
			// */
			// String str = data.getExtras().getString("pay_result");
			// if (str.equalsIgnoreCase("success")) {
			// msg = "支付成功！";
			// } else if (str.equalsIgnoreCase("fail")) {
			// msg = "支付失败！";
			// } else if (str.equalsIgnoreCase("cancel")) {
			// msg = "用户取消了支付";
			// }
			// if (!msg.equals("")) {
			// Toast.makeText(getInstance(), msg,
			// Toast.LENGTH_LONG).show();
			// }

			super.onActivityResult(requestCode, resultCode, data);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void startPhotoZoom(final Uri uri) {
		try {
			Intent intent = new Intent("com.android.camera.action.CROP");
			intent.setDataAndType(uri, IMAGE_UNSPECIFIED);
			intent.putExtra("crop", "true");
			// aspectX aspectY 是宽高的比例
			intent.putExtra("aspectX", 1);
			intent.putExtra("aspectY", 1);
			// outputX outputY 是裁剪图片宽高
			intent.putExtra("outputX", 100);
			intent.putExtra("outputY", 100);
			intent.putExtra("return-data", true);
			getInstance().startActivityForResult(intent, PHOTORESOULT);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static final int HANDLER_MSG_UPLOAD_PHOTO = 1;
	public static final String URL_UPLOAD_PHOTO = "http://db.tongqutongqu.cn/tqAdmin/fileUploadManager!upload.do";

	public Handler uploadHandler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			if (msg.what == HANDLER_MSG_UPLOAD_PHOTO) {
				Pub.showProgressDialog("头像上传中...");
				// 上传照片
				InputStream is = new ByteArrayInputStream(mPhotoStream.toByteArray());
				String sFileName = userid + "_" + password;
				Boolean b = HttpEngine.getHttpEngine().uploadFile(URL_UPLOAD_PHOTO, is, sFileName);
				if (b) {
					Pub.closeProgressDialog();
					mPhotoStream = null;
					Toast.makeText(getInstance(), "头像上传服务器成功", Toast.LENGTH_LONG).show();
					getInstance().runOnGLThread(new Runnable() {
						@Override
						public void run() {
							Cocos2dxLuaJavaBridge.callLuaFunctionWithString(uploadingPhotoCallBackFunction, "");
							Cocos2dxLuaJavaBridge.releaseLuaFunction(uploadingPhotoCallBackFunction);
						}
					});
				} else {
					Pub.closeProgressDialog();
					mPhotoStream = null;
					Toast.makeText(getInstance(), "头像上传服务器失败", Toast.LENGTH_LONG).show();
				}
			}
		}
	};

	// 下载图片队列
	public static HashMap<String, ImageInfo> malImageInfoList = new HashMap<String, ImageInfo>();

	/**
	 * 图片是否存在
	 *
	 * @param imageUrl
	 * @return
	 */
	public static boolean picExists(String imageUrl) {
		if (imageUrl != null && !imageUrl.equals("")) {
			if (Pub.getFileSuffix(imageUrl).equals(".jpg")) {
				if (imageUrl.contains(RemoteResMgr.PHOTO_URL)) {
					// 头像
					imageUrl += "!convert2png";
				} else {
					String DelSuffix = Pub.getFileDelSuffix(imageUrl);
					imageUrl = DelSuffix + ".png";
				}
			}
			if (RemoteResMgr.exists(imageUrl)) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	/**
	 * lua调用的下载图片的方法
	 *
	 * @param url
	 * @param luaCallbackFunction
	 */
	public static void downloadImage(String imageUrl, final float nResID, final int luaCallbackFunction) {
		if (imageUrl != null && !imageUrl.equals("")) {
			if (Pub.getFileSuffix(imageUrl).equals(".jpg")) {
				if (imageUrl.contains(RemoteResMgr.PHOTO_URL)) {
					// 头像
					imageUrl += "!convert2png";
				} else {
					String DelSuffix = Pub.getFileDelSuffix(imageUrl);
					imageUrl = DelSuffix + ".png";
				}
			}
			final String url = imageUrl;
			if (RemoteResMgr.exists(url)) {
				getInstance().runOnGLThread(new Runnable() {
					@Override
					public void run() {
						String info = (int) nResID + "#" + RemoteResMgr.getPicPath(url);
						Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaCallbackFunction, info);
						Cocos2dxLuaJavaBridge.releaseLuaFunction(luaCallbackFunction);
					}
				});
			} else {
				getInstance().runOnUiThread(new Runnable() {
					@Override
					public void run() {
						ImageInfo info = new ImageInfo();
						info.url = url;
						info.nResID = (int) nResID;
						info.luaCallbackFunction = luaCallbackFunction;
						malImageInfoList.put(info.url + info.nResID, info);
						RemoteResMgr.requestRes(info.url, mResHandler, info.nResID, true);
					}
				});
			}
		}
	}

	public static Handler mResHandler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			final DownloadTask task = (DownloadTask) msg.obj;
			try {
				getInstance().runOnGLThread(new Runnable() {
					@Override
					public void run() {
						if (task != null) {
							if (malImageInfoList.get(task.mUrl + task.mResID) != null) {
								String info = task.mResID + "#" + RemoteResMgr.getPicPath(task.mUrl);
								Cocos2dxLuaJavaBridge.callLuaFunctionWithString(malImageInfoList.get(task.mUrl + task.mResID).luaCallbackFunction, info);
								Cocos2dxLuaJavaBridge.releaseLuaFunction(malImageInfoList.get(task.mUrl + task.mResID).luaCallbackFunction);
								malImageInfoList.remove(task.mUrl + task.mResID);
							}
						}
					}
				});
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	};

	public boolean onKeyDown(int keyCoder, KeyEvent event) {
		// 重载函数，android手机实体返回键回调函数
		if (m_webView != null && m_webView.getVisibility() == View.VISIBLE) {
			// webview显示
			if (m_webView.canGoBack() && keyCoder == KeyEvent.KEYCODE_BACK) {
				// 如果网页能回退则后退，如果不能后退移除WebView
				m_webView.goBack();
			} else {
				// removeWebView();
			}
			return false;
		} else {
			return super.onKeyDown(keyCoder, event);
		}
	}

	public static final int UNZIP_PROGRESS_UPDATE = 1;// 解压进度
	public static final int UNZIP_SUCCESS = 2;// 解压完成

	public static Handler mLoadhandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			// TODO Auto-generated method stub
			super.handleMessage(msg);
			switch (msg.what) {
			case UNZIP_PROGRESS_UPDATE:
				// 解压完成
				Bundle bundle = msg.getData();
				final int max = bundle.getInt("max");// 最大值
				final int Progress = bundle.getInt("Progress");// 当前值
				// Pub.LOG("最大值 max === " + max);
				// Pub.LOG("当前值 Progress === " + Progress);
				// Lua function 跑在 GL 线程
				if (LuaUpdateConsole.unZipProgressCallback > 0) {
					getInstance().runOnGLThread(new Runnable() {
						@Override
						public void run() {
							Cocos2dxLuaJavaBridge.callLuaFunctionWithString(LuaUpdateConsole.unZipProgressCallback, Progress + "#" + max);
							// 移除
							// Cocos2dxLuaJavaBridge.releaseLuaFunction(nDownloadCompleteCallBackFunc);
						}
					});
				}
				break;
			case UNZIP_SUCCESS:
				// 解压完成
				LuaUpdateConsole.setUnZipDone(true);
				break;
			default:
				break;
			}
		}
	};
}
