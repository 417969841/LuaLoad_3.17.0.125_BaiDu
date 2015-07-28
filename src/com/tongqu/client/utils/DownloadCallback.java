package com.tongqu.client.utils;

public interface DownloadCallback {

	public static final int Stop = 0;// 未下载完成
	public static final int Success = 1;// 下载完成
	public static final int Pause = 2;// 暂停下载
	public static final int FileException = 3;// 文件异常

	/**
	 * 通知下载任务状态
	 *
	 * @param status
	 *            0未下载完成；1下载完成；2 暂停下载；3文件异常
	 */
	public void noticeDownloadStatus(int status);
}
