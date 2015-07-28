package com.tongqu.client.utils;

import java.io.File;

import android.os.Handler;

public class DownloadInfo {

	/**
	 * 初始化下载任务
	 *
	 * @param url
	 * @param dir
	 */
	public DownloadInfo(String url, String dir) {
		msOriginalDir = dir;
		mFileDir = Pub.getTrendsSaveFilePath(dir);
		downloadUrl = url;
	}
	private String msOriginalDir;//原始文件目录
	private String mFileDir;// 文件目录
	private boolean mbStop = false;// 是否停止下载
	private boolean mbPause = false;// 是否暂停下载
	private String downloadUrl;// 下载地址
	private Handler updateHandler;// 下载完成后用于通知的Handler
	private int engineId;// 下载后事件ID
	private boolean isRestriction;// 是否限速
	private long totalSize;// 大小
	private long downloadSize;// 已下载大小
	private boolean isShowDialog = false;// 是否显示下载进度界面
	private boolean isTableRes = false;// 是否是牌桌资源

	public String getMsOriginalDir() {
		return msOriginalDir;
	}

	public void setMsOriginalDir(String originalDir) {
		msOriginalDir = originalDir;
	}

	public boolean isTableRes() {
		return isTableRes;
	}

	public void setTableRes(boolean tableRes) {
		isTableRes = tableRes;
	}

	public boolean isShowDialog() {
		return isShowDialog;
	}

	public void setShowDialog(boolean showDialog) {
		isShowDialog = showDialog;
	}

	public String getFileDir() {
		return mFileDir;
	}

	public void setFileDir(String fileDir) {
		mFileDir = fileDir;
	}

	public boolean isStop() {
		return mbStop;
	}

	public void setStop(boolean Stop) {
		mbStop = Stop;
	}

	public boolean isPause() {
		return mbPause;
	}

	public void setPause(boolean Pause) {
		mbPause = Pause;
	}

	public String getDownloadUrl() {
		return downloadUrl;
	}

	public void setDownloadUrl(String Url) {
		downloadUrl = Url;
	}

	public Handler getUpdateHandler() {
		return updateHandler;
	}

	public void setUpdateHandler(Handler handler) {
		updateHandler = handler;
	}

	public int getEngineId() {
		return engineId;
	}

	public void setEngineId(int Id) {
		engineId = Id;
	}

	public boolean isRestriction() {
		return isRestriction;
	}

	public void setRestriction(boolean restriction) {
		isRestriction = restriction;
	}

	public long getTotalSize() {
		return totalSize;
	}

	public void setTotalSize(long allSize) {
		totalSize = allSize;
	}

	public long getDownloadSize() {
		return downloadSize;
	}

	public void setDownloadSize(long downSize) {
		downloadSize = downSize;
	}

	/**
	 * 文件是否存在
	 *
	 * @param url
	 * @return
	 */
	public boolean existsZip() {
		File file = new File(getFilePath());
		if (file.exists()) {
			return true;
		}
		return false;
	}

	/**
	 * 通过Url获取要下载的文件名
	 *
	 * @param url
	 * @return
	 */
	private String getFileNameFromUrl(String url) {
		int index = url.lastIndexOf('/');
		return url.substring(index + 1);
	}

	/**
	 * 获取下载后存放路径:dir+fileName
	 *
	 * @return
	 */
	public String getFilePath() {
		return mFileDir + getFileNameFromUrl(downloadUrl);
	}

	/**
	 * 获取临时路径:dir+fileName
	 *
	 * @return
	 */
	public String getTempPath() {
		return mFileDir + getFileNameFromUrl(downloadUrl) + "_tmp";
	}
}