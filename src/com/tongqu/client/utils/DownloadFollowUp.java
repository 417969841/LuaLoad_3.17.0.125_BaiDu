package com.tongqu.client.utils;

import java.io.File;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;

import com.tongqu.client.game.LuaCallDownloadControler;
import com.tongqu.client.game.TQGameAndroidBridge;
import com.tongqu.client.game.TQLuaAndroidConsole;

/**
 * 下载完成后的操作
 */
public class DownloadFollowUp {

	/**
	 * 安装：即表示下载后自动执行安装操作，不需要用户确认。一般在户客户端下载或强制更新时使用。
	 */
	public static final int DOWNLOAD_ACTION_A = 0;
	/**
	 * 特殊处理：即表示在执行完下载操作后对所下载目标进行有针对性的特殊操作。需等待用户触发或其他需求。
	 */
	public static final int DOWNLOAD_ACTION_B = 1;
	/**
	 * 解压：即表示下载完成后自动进行解压操作，无需用户主动执行操作。一般用于小游戏的下载或更新。
	 */
	public static final int DOWNLOAD_ACTION_C = 2;
	/**
	 * 删除：即表示该目标在完成下载后即刻删除，不做任何其他处理。一般用于自动下载APK功能。
	 */
	public static final int DOWNLOAD_ACTION_D = 3;
	/**
	 * 通知：即表示下载成功后不做操作，只对用户进行弹通知操作。
	 */
	public static final int DOWNLOAD_ACTION_E = 4;
	/**
	 * 弹Toast：即表示下载成功后不做操作，只对用户进行弹Toast操作。
	 */
	public static final int DOWNLOAD_ACTION_F = 5;
	/**
	 * 弹启动询问：即表示下载成功后对用户进行启动询问，若用户同意则直接进入所启动程序。一般用于小游戏下载、更新或主体游戏更新。
	 */
	public static final int DOWNLOAD_ACTION_G = 6;
	/**
	 * lua升级文件下载
	 */
	public static final int DOWNLOAD_ACTION_H = 7;
	/**
	 * 下载异常
	 */
	public static final int DOWNLOAD_Exception = 100;
	/**
	 * lua升级下载异常
	 */
	public static final int DOWNLOAD_Lua_Exception = 101;

	private static DownloadFollowUp mInstance;

	public static DownloadFollowUp getInst() {
		if (mInstance == null) {
			mInstance = new DownloadFollowUp();
		}
		return mInstance;
	}

	public boolean isDownTableEmotiom = false;// 牌桌动画文件是都下载解压完毕

	public boolean isDownTableMusic = false;// 牌桌音乐文件是都下载解压完毕

	public boolean isUpdatePad = false;// 下载的是否是PAD版本

	/**
	 * 下载完成后的动作
	 */
	public Handler mDownloadActionHandler = new Handler() {
		public void handleMessage(android.os.Message msg) {

			Bundle bundle = msg.getData();
			final int DownloadType = bundle.getInt("DownloadType");// 下载类型
			final String DownloadUrl = bundle.getString("DownloadUrl");// 下载地址
			final String FilePath = bundle.getString("FilePath");// 存放路径
			final String DirPath = bundle.getString("DirPath");// 存放目录

			if (DownloadUrl == null || FilePath == null || DirPath == null) {
				return;
			}

			Pub.LOG("下载完成  DownloadUrl == " + DownloadUrl);
			Pub.LOG("下载完成  msg.what == " + msg.what);

			switch (msg.what) {
			case DOWNLOAD_ACTION_A:
				// 安装
				if (isUpdatePad) {
					isUpdatePad = false;
					// deleteAPK();
				}
				// 回调下载完成
				if (!TQGameAndroidBridge.isInstalled) {
					Pub.LOG("下载完成，没有立即安装");
					TQGameAndroidBridge.callbackDownloadComplete(FilePath);
				} else {
					Pub.LOG("下载完成，立即安装");
					installAPK(FilePath);
				}
				break;
			case DOWNLOAD_ACTION_B:
				// 特殊处理(输出日志)
				// if (LoadActivity.logicZipIsDown()) {
				// TQLuaAndroidConsole.getGameSceneInstance().callbackUpdataExitDialog();
				// }

				break;
			case DOWNLOAD_ACTION_C:
				// 解压
				switch (DownloadType) {
				case Downloader.Download_Complete:// 本地没有下载完成
				case Downloader.Directly_Complete:// 本地已有直接完成
					new Thread(new Runnable() {
						@Override
						public void run() {
							// TODO Auto-generated method stub
							Pub.unZip(FilePath, DirPath);
							// if (DownloadUrl.equals(Const.URL_TABLE_EMOTION))
							// {
							// isDownTableEmotiom = true;
							// } else if
							// (DownloadUrl.equals(Const.URL_LORD_MUSIC)) {
							// isDownTableMusic = true;
							// // if (ActivityConsole.getCurrentActivity()
							// // instanceof
							// // LordActivity) {
							// //
							// Toast.makeText(ActivityConsole.getCurrentActivity(),
							// // "声音特效加载完毕！重新进入一次牌桌即可听到可爱真人发声。",
							// // Toast.LENGTH_LONG).show();
							// // }
							// }
						}
					}).start();
					break;
				default:
					break;
				}

				break;
			case DOWNLOAD_ACTION_D:
				// 删除

				break;
			case DOWNLOAD_ACTION_E:
				// 通知栏
				// 只下载不安装，弹通知
				showNotificationMessage(FilePath);
				break;
			case DOWNLOAD_ACTION_F:
				// Toast

				break;
			case DOWNLOAD_ACTION_G:
				// 弹启动询问

				break;
			case DOWNLOAD_ACTION_H:
				// lua升级文件下载
				LuaCallDownloadControler.callBackLuaUpdateDone();
				break;
			case DOWNLOAD_Exception:
				// 文件下载异常
				break;
			case DOWNLOAD_Lua_Exception:
				// lua升级下载异常
				LuaCallDownloadControler.callBackLuaUpdateException(DownloadUrl);
				break;
			}
		}
	};

	/**
	 * 装APK
	 *
	 * @param sPackageName
	 */
	public void installAPK(String sAPKPath) {
		Pub.LOG("installAPK" + sAPKPath);
		//
		File f = new File(sAPKPath);
		modifyFile(f);
		//
		Intent intent = new Intent(Intent.ACTION_VIEW);
		intent.setDataAndType(Uri.fromFile(f), "application/vnd.android.package-archive");
		TQLuaAndroidConsole.getGameSceneInstance().startActivity(intent);
	}

	public static void modifyFile(File file) {
		Process process = null;
		try {
			File tmpFile = file.getParentFile();
			process = Runtime.getRuntime().exec("chmod 777 " + tmpFile.getAbsolutePath());
			process.waitFor();
			String command = "chmod 777 " + file.getAbsolutePath();
			Runtime runtime = Runtime.getRuntime();
			process = runtime.exec(command);
			process.waitFor();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String updateNotificationTxt = null;// 下载完成后，通知栏文字

	/**
	 * 通知栏提示下载
	 *
	 * @param news
	 */
	public void showNotificationMessage(String updateFile) {
		// try {
		// if (updateNotificationTxt != null &&
		// !updateNotificationTxt.equals("")) {
		// Notification messageNotification = new Notification(R.drawable.icon,
		// "疯狂斗地主", System.currentTimeMillis());
		// NotificationManager messageNotificatioManager = (NotificationManager)
		// ActivityConsole.getCurrentActivity().getSystemService(Context.NOTIFICATION_SERVICE);
		// PendingIntent messagePendingIntent = null;
		// // 点击查看
		// messageNotification.flags |= messageNotification.FLAG_AUTO_CANCEL;
		// // 点击安装PendingIntent
		// File f = new File(updateFile);
		// modifyFile(f);
		// Uri uri = Uri.fromFile(f);
		// Intent installIntent = new Intent(Intent.ACTION_VIEW);
		// installIntent.setDataAndType(uri,
		// "application/vnd.android.package-archive");
		// messagePendingIntent =
		// PendingIntent.getActivity(ActivityConsole.getCurrentActivity(), 0,
		// installIntent, 0);
		// messageNotification.contentIntent = messagePendingIntent;
		//
		// RemoteViews contentView = new
		// RemoteViews(ActivityConsole.getCurrentActivity().getPackageName(),
		// R.layout.notification);
		// contentView.setImageViewResource(R.id.image, R.drawable.icon);
		// contentView.setTextViewText(R.id.title, "疯狂斗地主");
		// contentView.setTextViewText(R.id.text, updateNotificationTxt);
		// messageNotification.contentView = contentView;
		// messageNotificatioManager.notify(0, messageNotification);
		// }
		// } catch (Exception e) {
		// e.printStackTrace();
		// }
	}
}
