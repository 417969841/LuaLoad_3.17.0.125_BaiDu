package com.tongqu.client.game;

import java.util.ArrayList;
import java.util.Iterator;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import com.tongqu.client.entity.LuaUpdateInfo;
import com.tongqu.client.utils.DownloadFollowUp;
import com.tongqu.client.utils.Downloader;
import com.tongqu.client.utils.Pub;
import com.tongqu.client.utils.ZipFileUtil;

/**
 * 方便lua来调用2次加载的相关方法
 *
 */
public class LuaCallDownloadControler {

	/**
	 * 校验文件
	 *
	 * @param url
	 * @return true 文件完整，false 文件不完整
	 */
	public static boolean LuaCallVerifyZipFile(final String url, final String dir) {
		boolean verifyZipFile = Downloader.getInst().verifyZipFile(url, dir);
		Pub.LOG("verifyZipFile===========" + verifyZipFile);
		return verifyZipFile;
	}

	public static int mnCallBackLua = -1;
	public static String DownloadTips = "";

	/**
	 * 下载文件
	 *
	 * @param url
	 *            下载地址
	 * @param dir
	 *            存放路径
	 * @param handler
	 *            下载后通知
	 * @param engineId
	 *            通知ID
	 * @param isRestriction
	 *            是否限速
	 * @param boolean 是否显示现在进度界面
	 * @param sDownloadTips
	 *            下载时的提示语
	 *
	 */
	public static void LuaCallGetDownloadFile(final String url, final String dir, final float engineId, final boolean isRestriction, final boolean isShowDialog, final String sDownloadTips) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				DownloadTips = sDownloadTips;
				Downloader.getInst().getDownloadFile(url, dir, DownloadFollowUp.getInst().mDownloadActionHandler, (int) engineId, isRestriction, isShowDialog);
			}
		});
	}

	public static ArrayList<LuaUpdateInfo> LuaUpdateInfoList = new ArrayList<LuaUpdateInfo>();

	/**
	 * 添加lua脚本的下载信息
	 *
	 * @param zipUrl
	 *            zip下载地址
	 * @param delUrl
	 *            删除目录下载地址
	 * @param callback
	 *            下载完成后回调
	 */
	public static void addLuaUpdateInfo(String zipUrl, String delUrl, int callback, boolean restart) {
		LuaUpdateInfo info = new LuaUpdateInfo();

		info.zipUrl = zipUrl;
		info.delUrl = delUrl;
		info.callback = callback;
		info.restart = restart;

		LuaUpdateInfoList.add(info);
	}

	/**
	 * 获取已经下载完成一个lua升级任务
	 *
	 * @param isRemove
	 *            是否删除升级信息（开始解压时传true）
	 * @return
	 */
	public static LuaUpdateInfo getLuaUpdateDoneInfo(boolean isRemove) {
		Iterator iter = LuaUpdateInfoList.iterator();
		LuaUpdateInfo info = null;
		while (iter.hasNext()) {
			LuaUpdateInfo entry = (LuaUpdateInfo) iter.next();
			boolean isDownloadZip = (boolean) entry.isDownloadZip();
			boolean isDownloadDel = (boolean) entry.isDownloadDel();
			if (isDownloadZip && isDownloadDel) {
				info = entry;
				if (isRemove) {
					iter.remove();
				}
				break;
			}
		}
		return info;
	}

	/**
	 * lua升级文件下载完成后回调lua
	 */
	public static void callBackLuaUpdateDone() {
		final LuaUpdateInfo info = getLuaUpdateDoneInfo(false);
		if (info != null) {
			TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
				@Override
				public void run() {
					Pub.LOG("entry.getZipFileName() ====== " + info.getZipFileName());
					Pub.LOG("entry.getDelFileName() ====== " + info.getDelFileName());
					Cocos2dxLuaJavaBridge.callLuaFunctionWithString(info.callback, "" + (info.restart ? 1 : 0));
					// Cocos2dxLuaJavaBridge.releaseLuaFunction(info.callback);
				}
			});
		}
	}

	/**
	 * lua升级文件下载异常
	 */
	public static void callBackLuaUpdateException(String url) {
		Iterator iter = LuaUpdateInfoList.iterator();
		while (iter.hasNext()) {
			LuaUpdateInfo entry = (LuaUpdateInfo) iter.next();
			String zipUrl = (String) entry.zipUrl;
			String delUrl = (String) entry.delUrl;
			if (zipUrl.equals(url) || delUrl.equals(url)) {
				iter.remove();
				break;
			}
		}
	}

	/**
	 * 是否存在下载任务
	 *
	 * @param zipUrl
	 */
	public static boolean isExistDownloadTask(String zipUrl) {
		for (int i = 0; i < LuaUpdateInfoList.size(); i++) {
			if (LuaUpdateInfoList.get(i).restart) {
				// 有主版本的更新
				Pub.LOG("有主版本正在更新");
				return true;
			}
			if (LuaUpdateInfoList.get(i).zipUrl.equals(zipUrl)) {
				Pub.LOG("已经在下载队列中");
				return true;
			}
		}
		return false;
	}

	/**
	 * 下载lua脚本升级文件
	 *
	 * @param zipUrl
	 *            zip下载地址
	 * @param delUrl
	 *            删除目录下载地址
	 * @param dir
	 *            存放路径
	 * @param handler
	 *            下载后通知
	 * @param engineId
	 *            通知ID
	 * @param isRestriction
	 *            是否限速
	 * @param boolean 是否显示现在进度界面
	 * @param sDownloadTips
	 *            下载时的提示语
	 * @param callback
	 *            下载完成后回调
	 * @param restart
	 *            是否需要重启更新
	 */
	public static void getDownloadLuaUpdateFile(final String zipUrl, final String delUrl, final String dir, final float engineId, final boolean isRestriction, final boolean isShowDialog, String sDownloadTips, int callback, boolean restart) {
		if (!isExistDownloadTask(zipUrl)) {
			addLuaUpdateInfo(zipUrl, delUrl, callback, restart);
			DownloadTips = sDownloadTips;
			TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					// 下载zip
					Downloader.getInst().getDownloadFile(zipUrl, dir, DownloadFollowUp.getInst().mDownloadActionHandler, (int) engineId, isRestriction, isShowDialog);
					// 下载删除列表
					Downloader.getInst().getDownloadFile(delUrl, dir, DownloadFollowUp.getInst().mDownloadActionHandler, (int) engineId, isRestriction, isShowDialog);
				}
			});
		}
	}

	/**
	 * 下载牌桌文件
	 *
	 * @param url
	 *            下载地址
	 * @param dir
	 *            存放路径
	 * @param handler
	 *            下载后通知
	 * @param engineId
	 *            通知ID
	 * @param isRestriction
	 *            是否限速
	 * @param isShowDialog
	 *            是否显示现在进度界面
	 * @param isTableRes
	 *            是否是牌桌资源
	 * @param isPause
	 *            是否暂停
	 *
	 * @param 下载完的lua回调方法
	 */
	public static void LuaCallGetTableDownloadFile(final String url, final String dir, final float engineId, final boolean isRestriction, final boolean isShowDialog, final boolean isTableRes, final boolean isPause, int CallBackLua) {
		mnCallBackLua = CallBackLua;
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Downloader.getInst().getDownloadFile(url, dir, DownloadFollowUp.getInst().mDownloadActionHandler, (int) engineId, isRestriction, isShowDialog, isTableRes, isPause);
			}
		});
	}

	/**
	 * 根据url获取zip包路径
	 *
	 * @param url
	 * @return
	 */
	public static String LuaCallGetZipFilePath(final String url, final String dir) {
		return Downloader.getInst().getZipFilePath(url, dir);
	}

	/**
	 * 校验解压后文件完整性（是都解压完全，解压后的文件大小是否一致）
	 *
	 * @param dir
	 *            解压到的详细路径
	 * @param zipFilePath
	 *            zip文件详细路径
	 * @return
	 */
	public static void LuaCallVerifyUnZipedFiles(final String dir, final String zipFilePath) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				ZipFileUtil.verifyUnZipedFiles(dir, zipFilePath);
			}
		});
	}

	/**
	 * zip解压后的文件是否可以使用
	 *
	 * @param zipFilePath
	 *            zip路径
	 * @return
	 */
	public static boolean LuaCallIsCanAccessZip(final String zipFilePath) {
		return ZipFileUtil.isCanAccessZip(zipFilePath);
	}

	/**
	 * 文件是否存在
	 *
	 * @param url
	 * @return
	 */
	public static boolean LuaCallExistsFile(String url, String dir) {
		return Downloader.getInst().existsFile(url, dir);
	}

}
