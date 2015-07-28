package com.tongqu.client.game;

import java.io.File;
import java.util.ArrayList;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import com.tongqu.client.entity.LuaUpdateInfo;
import com.tongqu.client.unzip.UnzipAsyncTaskForLua;
import com.tongqu.client.utils.Pub;

public class LuaUpdateConsole {

	public static int unZipProgressCallback = -1;
	public static UnzipAsyncTaskForLua mUnzipAsyncTask = null;

	/**
	 * 解压下载的zip包&&删除多余文件
	 */
	public static void unZipScriptAndDeleteFile(String ScriptZipName, String delFileList) {
		Pub.LOG("解压下载的zip包 === " + ScriptZipName);
		Pub.LOG("删除多余文件 === " + delFileList);
		// 解压
		String ScriptZipPath = TQGameAndroidBridge.getZipFilePath() + ScriptZipName;
		final String delFileListPath = TQGameAndroidBridge.getZipFilePath() + delFileList;
		File zipFile = new File(ScriptZipPath);
		if (zipFile.exists()) {
			// 如果有zip包，则解压
			if (mUnzipAsyncTask == null) {
				mUnzipAsyncTask = new UnzipAsyncTaskForLua(ScriptZipPath, TQGameAndroidBridge.getScriptFilePath(), TQLuaAndroidConsole.getGameSceneInstance().mLoadhandler);
				mUnzipAsyncTask.execute();
			}
		}
		// 删除冗余文件
		new Thread(new Runnable() {
			public void run() {
				// 删除多余文件
				ArrayList<String> delList = Pub.readFileOnLine(delFileListPath);
				if (delList.size() > 0) {
					for (int i = 1; i < delList.size(); i++) {
						File delFile = new File(TQGameAndroidBridge.getScriptFilePath() + delList.get(i));
						if (delFile.exists()) {
							delFile.delete();
						}
					}
				}
				setDeleteDone(true);
			}
		}).start();
	}

	private static LuaUpdateInfo mLuaUpdateInfo = null;// lua升级信息
	private static int unZipScriptAndDeleteFileDoneCallback = 0;// 解压删除文件完成后，回调lua
	private static boolean isUnZipDone = false;// 是否解压完
	private static boolean isDeleteDone = false;// 是否删除完

	/**
	 * 设置是否解压完成
	 *
	 * @param done
	 */
	public static void setUnZipDone(boolean done) {
		isUnZipDone = done;
		logicUnZipAndDeleteFileDone();
	}

	/**
	 * 设置是否删除完成
	 *
	 * @param done
	 */
	public static void setDeleteDone(boolean done) {
		isDeleteDone = done;
		logicUnZipAndDeleteFileDone();
	}

	public static final int NO_RESTART = 0;// 不用重启
	public static final int RESTART = 1;// 需要重启

	/**
	 * 结束当前更新lua任务
	 */
	public static void closeCurrentTask() {
		if (mUnzipAsyncTask != null) {
			mUnzipAsyncTask.cancel(true);
			mUnzipAsyncTask = null;
		}
		mLuaUpdateInfo = null;
		isUnZipDone = false;
		isDeleteDone = false;
	}

	/**
	 * 通知lua层，脚本更新完毕
	 *
	 * @param type
	 */
	public static void callBackLuaUpdateDone(final int type) {
		if (unZipScriptAndDeleteFileDoneCallback > 0) {
			TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
				@Override
				public void run() {
					Cocos2dxLuaJavaBridge.callLuaFunctionWithString(unZipScriptAndDeleteFileDoneCallback, "" + type);
					Cocos2dxLuaJavaBridge.releaseLuaFunction(unZipScriptAndDeleteFileDoneCallback);
				}
			});
		}
	}

	/**
	 * 判断是否完成解压删除文件
	 */
	public static void logicUnZipAndDeleteFileDone() {
		if (isUnZipDone && isDeleteDone) {
			// 完成解压删除文件
			if (mLuaUpdateInfo == null) {
				Pub.LOG("mLuaUpdateInfo ======== 信息错误");
				return;
			}
			// 删除zip包
			File zipFile = new File(TQGameAndroidBridge.getZipFilePath() + mLuaUpdateInfo.getZipFileName());
			if (zipFile.isFile() && zipFile.exists()) {
				zipFile.delete();
			}
			if (mLuaUpdateInfo.restart) {
				// 主版本更新
				// 修改SD卡中的版本号
				ArrayList<String> delList = Pub.readFileOnLine(TQGameAndroidBridge.getZipFilePath() + mLuaUpdateInfo.getDelFileName());
				if (delList.size() > 0) {
					String ver = delList.get(0);
					int nPos = ver.lastIndexOf('.');
					String value = ver.substring(0, nPos);
					Pub.LOG("value ======== " + value);
					Pub.setJSONObject(TQGameAndroidBridge.getScriptFilePath(), "scriptVersion.json", "scriptVerName", value);
				}
			}

			// 删除文件列表
			File delFile = new File(TQGameAndroidBridge.getZipFilePath() + mLuaUpdateInfo.getDelFileName());
			if (delFile.isFile() && delFile.exists()) {
				delFile.delete();
			}
			if (mLuaUpdateInfo.restart) {
				// 需要重载(主版本更新)
				closeCurrentTask();
				// 通知lua升级完成
				callBackLuaUpdateDone(RESTART);
			} else {
				// 不用重载

				if (!TQGameAndroidBridge.isLoadSDScript) {
					// 使用的是包内的代码，需要重载一下（用户首次复制完脚本，就要更新代码,需要重载）
					closeCurrentTask();
					// 通知lua升级完成
					callBackLuaUpdateDone(RESTART);
				} else {
					closeCurrentTask();
					LuaUpdateInfo info = LuaCallDownloadControler.getLuaUpdateDoneInfo(true);
					if (info != null) {
						// 还有下载完成的lua升级文件,继续解压
						mLuaUpdateInfo = info;
						unZipScriptAndDeleteFile(mLuaUpdateInfo.getZipFileName(), mLuaUpdateInfo.getDelFileName());
					} else {
						// 已经没有下载完成的lua升级文件,通知lua升级完成
						callBackLuaUpdateDone(NO_RESTART);
					}
				}
			}

		}
	}

	/**
	 * 判断lua升级文件
	 *
	 * @param callback
	 */
	public static void logicLuaUpdateFile(int unZipCallback, int UpdateDoneCallback) {
		if (mLuaUpdateInfo != null) {
			Pub.LOG("有解压任务正在进行...........");
			return;
		}
		unZipProgressCallback = unZipCallback;
		unZipScriptAndDeleteFileDoneCallback = UpdateDoneCallback;
		mLuaUpdateInfo = LuaCallDownloadControler.getLuaUpdateDoneInfo(true);
		if (mLuaUpdateInfo != null) {
			unZipScriptAndDeleteFile(mLuaUpdateInfo.getZipFileName(), mLuaUpdateInfo.getDelFileName());
		}
	}

	/**
	 * 判断脚本加载目录
	 */
	public static void logicScriptLoadDir() {
		Pub.LOG("判断脚本加载 ======== ");
		if (!Pub.logicScriptInSD()) {
			// SD卡中没有脚本,复制脚本,使用游戏包中的脚本
			TQGameAndroidBridge.isLoadSDScript = false;
			TQGameAndroidBridge.isCopySDScript = true;
		} else {
			// SD卡中有脚本
			int scriptVersionFromAssets = Pub.getScriptVerCode(Pub.getScriptDataFromAssets("scriptVerName"));
			Pub.LOG("包内：getScriptVerCodeFromAssets === " + scriptVersionFromAssets);
			int scriptVersionFromSD = Pub.getScriptVerCode(Pub.getScriptDataFromSD("scriptVerName"));
			Pub.LOG("SD卡：getScriptVerCodeFromSD === " + scriptVersionFromSD);

			if (Pub.mbIsDeBug /* scriptVersionFromAssets == scriptVersionFromSD */) {
				// DeBug或者脚本版本号相同--使用游戏包中的脚本
				TQGameAndroidBridge.isLoadSDScript = false;
				TQGameAndroidBridge.isCopySDScript = false;
				TQGameAndroidBridge.isScriptVerSame = true;
			} else {
				if (scriptVersionFromAssets > scriptVersionFromSD) {
					// 游戏包内脚本号高,使用游戏包中的脚本,复制脚本要SD卡中
					TQGameAndroidBridge.isLoadSDScript = false;
					TQGameAndroidBridge.isCopySDScript = true;
				} else if (scriptVersionFromAssets <= scriptVersionFromSD) {
					// SD卡中脚本版本号高,脚本版本号相同,使用SD卡中的脚本
					TQGameAndroidBridge.isLoadSDScript = true;
					TQGameAndroidBridge.isCopySDScript = false;
				}
			}
		}
	}
}
