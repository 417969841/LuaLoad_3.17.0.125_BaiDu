package com.tongqu.client.game;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.pm.PackageInfo;
import android.os.Message;
import android.view.Gravity;
import android.widget.Toast;

import com.tongqu.client.entity.User;
import com.tongqu.client.lord.R;
import com.tongqu.client.utils.CalcDirectoryMD5;
import com.tongqu.client.utils.DownloadFollowUp;
import com.tongqu.client.utils.FilesUtil;
import com.tongqu.client.utils.Pub;

public class TQGameAndroidBridge {
	private static final String zipDownloadDir = "." + Pub.getAndroidPackagekName() + File.separator + "download";// 下载的zip包存放目录
	private static final String ScriptDir = "." + Pub.getAndroidPackagekName() + File.separator + "LuaScript";// 脚本文件存放目录
	private static final String zipFilePath = Pub.getTrendsSaveFilePath(zipDownloadDir);// 下载的zip包的路径
	private static final String ScriptFilePath = Pub.getTrendsSaveFilePath(ScriptDir);// 脚本文件存放的路径

	public static boolean isLoadSDScript = false;// 是否加载SD卡中的脚本
	public static boolean isCopySDScript = false;// 是否复制脚本到SD卡中
	public static boolean isScriptVerSame = false;// 游戏包内外的版本号是否相同

	public static int luaCallBackExitFunction = -1;// 回调lua关闭程序方法

	public static int onStopLuaCallBackFunc = -100; // onStop回调lua方法
	public static int onRestartLuaCallBackFunc = -100; // onRestart回调lua方法
	private boolean isThisActivityOnPause = false; // 是否切出游戏界面

	public static boolean isInstalled = true;// 下载完游戏是否立即安装
	public static String sGameID = "";// 游戏ID
	public static int nDownloadCompleteCallBackFunc = -1;// 下载完成回调的方法

	private static TQGameAndroidBridge instance;

	public static TQGameAndroidBridge getInstance() {
		if (instance == null) {
			instance = new TQGameAndroidBridge();
		}
		return instance;
	}

	public void onResume() {
		if (isThisActivityOnPause) {
			if (onRestartLuaCallBackFunc != -100) {
				isThisActivityOnPause = false;
				TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
					@Override
					public void run() {
						Cocos2dxLuaJavaBridge.callLuaFunctionWithString(onRestartLuaCallBackFunc, "");
					}
				});
			}
		}
	}

	public void onPause() {
		if (onStopLuaCallBackFunc != -100) {
			TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
				@Override
				public void run() {
					Cocos2dxLuaJavaBridge.callLuaFunctionWithString(onStopLuaCallBackFunc, "");
				}
			});
			isThisActivityOnPause = true;
		}
	}

	/**
	 * 初始化lua方法
	 */
	public static void initOnStopAndRestartLuaCallBackFunc(int onstopLuaCall, int restartLuaCall) {
		onStopLuaCallBackFunc = onstopLuaCall;
		onRestartLuaCallBackFunc = restartLuaCall;
	}

	/**
	 * 脚本管理
	 */
	public void scriptManage() {
		new Thread(new Runnable() {
			public void run() {
				if (isCopySDScript) {
					// 复制脚本到SD卡中
					copyFile();
				}
				// if (isLoadSDScript) {
				// // 若加载SD卡中的脚本，则可以计算MD5
				// getScriptMD5();
				// }
				// if (isScriptVerSame) {
				// // 检测脚本是否完整
				// if (!logicScriptSize()) {
				// // 不完整，重新复制脚本到SD卡中
				// // copyFile();
				// }
				// }
			}
		}).start();
	}

	/**
	 * 删除脚本版本文件
	 */
	public void deleteScriptVersion() {
		File zipFile = new File(getScriptFilePath() + "scriptVersion.json");
		if (zipFile.isFile() && zipFile.exists()) {
			zipFile.delete();
		}
	}

	/**
	 * 获取是否从SD卡加载脚本文件
	 *
	 * @return
	 */
	public static boolean getLoadSDScript() {
		Pub.LOG("isLoadSDScript ======= " + isLoadSDScript);
		return isLoadSDScript;
	}

	/**
	 * 计算脚本资源的文件大小是否相同
	 */
	public boolean logicScriptSize() {
		boolean isSame = false;
		long startTime = System.currentTimeMillis();
		// Pub.contrastAssets("cached_res");
		long scriptSizeFromAssets = Integer.parseInt((Pub.getScriptDataFromAssets("scriptSize")));
		Pub.LOG("包内：scriptSizeFromAssets === " + scriptSizeFromAssets);

		Pub.LOG("校验所用的时间Assets......................." + (System.currentTimeMillis() - startTime));
		startTime = System.currentTimeMillis();
		Pub.contrastSD(ScriptFilePath);
		long scriptSizeFromSD = Pub.sdFileSize;
		Pub.LOG("包外：scriptSizeFromSD ================= " + scriptSizeFromSD);
		Pub.LOG("校验所用的时间SD......................." + (System.currentTimeMillis() - startTime));
		if (scriptSizeFromAssets == scriptSizeFromSD) {
			isSame = true;
		} else {
			isSame = false;
		}
		return isSame;
	}

	/**
	 * 复制文件
	 */
	public void copyFile() {
		long startTime = System.currentTimeMillis();
		// 复制脚本到SD卡
		Pub.CopyAssets("cached_res", ScriptFilePath);
		Pub.LOG("复制所用的时间......................." + (System.currentTimeMillis() - startTime));
		// 复制脚本版本号到SD卡
		Pub.copyBigDataToSD("scriptVersion.json", ScriptFilePath, "scriptVersion.json");
	}

	/**
	 * 获取SD中游戏脚本的MD5
	 *
	 * @return
	 */
	public String getScriptMD5() {
		String SDFilesMD5 = "";
		long startTime = System.currentTimeMillis();
		if (CalcDirectoryMD5.sbMD5 != null && CalcDirectoryMD5.sbMD5.length() == 0) {
			CalcDirectoryMD5.getDirMD5(new File(ScriptFilePath), true);
		}
		if (CalcDirectoryMD5.sbMD5 != null && CalcDirectoryMD5.sbMD5.length() > 0) {
			SDFilesMD5 = CalcDirectoryMD5.getStringMD5(CalcDirectoryMD5.sbMD5);
			Pub.LOG("获取SD中游戏脚本的MD5 == SDFilesMD5 ============ " + SDFilesMD5);
		}
		Pub.LOG("获取SD中游戏脚本的MD5所用的时间SD......................." + (System.currentTimeMillis() - startTime));

		return SDFilesMD5;
	}

	/**
	 * 下载的zip包存放目录
	 *
	 * @return
	 */
	public static String getZipDownloadDir() {
		return zipDownloadDir;
	}

	/**
	 * 下载的zip包的路径
	 *
	 * @return
	 */
	public static String getZipFilePath() {
		return zipFilePath;
	}

	/**
	 * 脚本文件存放的路径
	 *
	 * @return
	 */
	public static String getScriptFilePath() {
		return ScriptFilePath;
	}

	/**
	 * 设置回调lua的方法
	 *
	 * @param luaCallbackFunction
	 */
	public static void setLuaCallBackFunction(int luaCallbackFunction) {
		luaCallBackExitFunction = luaCallbackFunction;
	}

	/**
	 * 关闭游戏
	 */
	public static void exitGame() {
		TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
			@Override
			public void run() {
				if (luaCallBackExitFunction >= 0) {
					Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaCallBackExitFunction, "");
					Cocos2dxLuaJavaBridge.releaseLuaFunction(luaCallBackExitFunction);
				}
			}
		});
	}

	/**
	 * 显示toast
	 *
	 * @param showMsg
	 * @param type
	 */
	public static void showToast(final String showMsg, final float type) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			public void run() {
				Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), showMsg, (int) type).show();
			}
		});
	}

	/**
	 * SD卡上存储用户数据
	 *
	 * @param nickname
	 * @param password
	 * @param userID
	 */
	public static void SaveShareUserData(String nickname, String password, String userID) {
		FilesUtil.getInstance().writeUserMsg(nickname, password, userID);
	}

	/**
	 * SD卡上读取用户数据
	 */
	public static String LoadShareUserData() {
		User userFromSD = FilesUtil.getInstance().readUserMsg();
		String luaCallBackData = "";
		if (userFromSD != null && userFromSD.nickname != null && userFromSD.password != null && userFromSD.userid != 0) {
			luaCallBackData = userFromSD.nickname + "#" + userFromSD.password + "#" + userFromSD.userid;
		}
		return luaCallBackData;
	}

	public static void downAppUpdate(final boolean isUserInitiative, final float updateType, final String updateTxt, final String updataAwardTxt, final String updateAppSizeTxt, final String NotificationTxt, final String updateUrl) {

		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			public void run() {
				Pub.LOG("updateType === " + updateType);
				Pub.LOG("updateUrl === " + updateUrl);
				switch ((int) updateType) {
				case 0:
					Pub.LOG("当前游戏不需要升级");
					if (isUserInitiative) {
						Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "您当前是最新版本，无需更新！", Toast.LENGTH_LONG).show();
					}
					break;
				case 1:
					Pub.LOG("当前游戏建议升级");
					if (!isUserInitiative) {
						long UpdataAppTime = 0;
						// 读取数据
						if (FilesUtil.getInstance().fileOpen(FilesUtil.READ, FilesUtil.UpdataAppTime)) {// 有存档
							DataInputStream is = FilesUtil.getInstance().dataIn;
							try {
								UpdataAppTime = is.readLong();
							} catch (IOException e) {
								e.printStackTrace();
							}
							FilesUtil.getInstance().fileClose();
						}
						if (System.currentTimeMillis() - UpdataAppTime < 3600 * 1000) {
							Pub.LOG("最近一小时已经提醒过升级，不再提醒");
							startBackgroundDownlord(TQLuaAndroidConsole.getGameSceneInstance().UPDATA_BACKGROUND_DOWNLORD, updateUrl);
							break;
						}
						// 存储数据
						if (FilesUtil.getInstance().fileOpen(FilesUtil.WRITE, FilesUtil.UpdataAppTime)) {
							DataOutputStream os = FilesUtil.getInstance().dataOut;
							try {
								os.writeLong(System.currentTimeMillis());
							} catch (IOException e) {
								e.printStackTrace();
							}
							FilesUtil.getInstance().fileClose();
						}
					}
					DownloadFollowUp.getInst().updateNotificationTxt = NotificationTxt;
					processRemindUpdate(false, updateTxt, updataAwardTxt, updateAppSizeTxt, updateUrl);
					break;
				case 2:
					Pub.LOG("当前游戏强制升级");
					DownloadFollowUp.getInst().updateNotificationTxt = NotificationTxt;
					processRemindUpdate(true, updateTxt, updataAwardTxt, updateAppSizeTxt, updateUrl);
					break;
				case 3:
					break;
				default:
					break;
				}
			}
		});
	}

	/**
	 * 提示升级流程
	 *
	 * @param bForceUpdate
	 *            是否强升
	 * @param updateTxt
	 *            更新信息
	 * @param updateUrl
	 *            appUrl
	 * @param updataAwardTxt
	 *            升级奖励
	 * @param updateAppSizeTxt
	 *            升级尺寸
	 */
	private static void processRemindUpdate(boolean bForceUpdate, String updateTxt, String updataAwardTxt, String updateAppSizeTxt, String url) {
		HallUpdataPopWindow mHallUpdataPopWindow = new HallUpdataPopWindow(TQLuaAndroidConsole.getGameSceneInstance(), bForceUpdate, updateTxt, updataAwardTxt, updateAppSizeTxt, url);
		mHallUpdataPopWindow.showAtLocation(TQLuaAndroidConsole.getGameSceneInstance().getWindow().getDecorView(), Gravity.CENTER, 0, 0);
	}

	/**
	 * 后台升级版本
	 */
	public static void startBackgroundDownlord(int what, String downUrl) {
		Message msg = TQLuaAndroidConsole.getGameSceneInstance().downloadHandler.obtainMessage();
		msg.what = what;
		msg.obj = downUrl;
		TQLuaAndroidConsole.getGameSceneInstance().downloadHandler.sendMessageDelayed(msg, 1000);
	}

	/**
	 * 信息提示框
	 *
	 * @param text
	 */
	public static void showAndroidDialog(final String text) {
		try {
			// 确保 Lua function 跑在 GL 线程，Java 代码跑在 UI 线程。
			TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					AlertDialog.Builder builder = new AlertDialog.Builder(TQLuaAndroidConsole.getGameSceneInstance());
					builder.setTitle("提示");
					builder.setMessage(text);
					builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							dialog.cancel();
						}
					});
					builder.setIcon(R.drawable.icon);
					builder.create();
					builder.show();
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 被踢下线
	 *
	 * @param text
	 */
	public static void showNetKickOffDialog(final String text) {
		try {
			// 确保 Lua function 跑在 GL 线程，Java 代码跑在 UI 线程。
			TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					// 被踢下线
					AlertDialog.Builder alertbBuilder = new AlertDialog.Builder(TQLuaAndroidConsole.getGameSceneInstance());
					alertbBuilder.setTitle("提示").setMessage(text).setPositiveButton("确定", new DialogInterface.OnClickListener() {
						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.cancel();
							exitGame();
						}
					}).create();
					alertbBuilder.setIcon(R.drawable.icon);
					alertbBuilder.show();
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void showAlertDialog(final String title, final String message, final int luaCallbackFunction) {
		// 确保 Lua function 跑在 GL 线程，Java 代码跑在 UI 线程。
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				AlertDialog alertDialog = new AlertDialog.Builder(TQLuaAndroidConsole.getGameSceneInstance()).create();
				alertDialog.setTitle(title);
				alertDialog.setMessage(message);
				alertDialog.setButton("确定", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
							@Override
							public void run() {
								Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaCallbackFunction, "CLICKED");
								Cocos2dxLuaJavaBridge.releaseLuaFunction(luaCallbackFunction);
							}
						});
					}
				});
				alertDialog.setButton2("取消", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						dialog.dismiss();
					}
				});
				alertDialog.setIcon(R.drawable.icon);
				alertDialog.show();
			}
		});
	}

	/**
	 * 根据包名判断该游戏是否安装
	 *
	 * @param packName
	 *            应用包名
	 * @param sGameID
	 *            应用ID
	 * @return String 1 安装 0 没有安装
	 */
	public static int getAppIsInstalledByPackName(String packName, String sGameID) {
		int isInstalledApp = 0; // 是否安装游戏 1 是 0 否
		PackageInfo pkg = Pub.getPkgInfoByName(packName);
		if (pkg == null) {
			isInstalledApp = 0;
		} else {
			isInstalledApp = 1;
		}
		return isInstalledApp;
	}

	/**
	 * 设置下载完App后的信息
	 *
	 * @param String
	 *            GameID 游戏ID
	 * @param int luaCallbackFunction
	 * @param boolean falg 是否立即安装
	 */
	public static void setDownloadAppCompleteInfo(String GameID, int luaCallbackFunction, boolean flag) {
		sGameID = GameID;
		nDownloadCompleteCallBackFunc = luaCallbackFunction;
		isInstalled = flag;
	}

	public static void callbackDownloadComplete(final String filePath) {
		// 确保 Lua function 跑在 GL 线程，Java 代码跑在 UI 线程。
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				// Lua function 跑在 GL 线程
				TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
					@Override
					public void run() {
						Cocos2dxLuaJavaBridge.callLuaFunctionWithString(nDownloadCompleteCallBackFunc, sGameID + "#" + filePath);
						// 移除
						Cocos2dxLuaJavaBridge.releaseLuaFunction(nDownloadCompleteCallBackFunc);
					}
				});
			}
		});
	}

	// 安装应用
	public static void installApp(String filePath) {
		Pub.LOG("需要安装的应用路径 ==" + filePath);
		DownloadFollowUp.getInst().installAPK(filePath);
	}

}
