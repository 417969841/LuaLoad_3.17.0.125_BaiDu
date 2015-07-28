package com.tongqu.client.utils;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.net.HttpURLConnection;
import java.net.URL;

import android.os.Handler;

public class DownloadThread extends Thread {

	private static final int BUFFER_SIZE = 4096;
	private boolean finished = false, start = false;
	private long startPosition = 0;// 初始进度（用于多线程下载）
	private long initPosition = 0;// 本地进度

	public DownloadInfo mDownloadInfo;
	private DownloadCallback mCallBack;
	private Handler mHandler;

	// 分块构造函数
	public DownloadThread(DownloadInfo data, DownloadCallback callBack, Handler handler) {
		mDownloadInfo = data;
		mCallBack = callBack;
		mHandler = handler;
	}

	public void run() {
		URL url = null;
		HttpURLConnection http = null;
		try {
			url = new URL(mDownloadInfo.getDownloadUrl());
			http = (HttpURLConnection) url.openConnection();
			http.setConnectTimeout(5000);
			http.setRequestMethod("GET");
			http.setRequestProperty("Accept", "image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*");
			http.setRequestProperty("Referer", url.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (http == null) {
			return;
		}

		File file = new File(mDownloadInfo.getTempPath());
		if (file.exists()) {
			initPosition = file.length();
			mDownloadInfo.setDownloadSize(initPosition + startPosition);
		} else {
			mDownloadInfo.setDownloadSize(startPosition);
		}

		//
		InputStream is = null;
		RandomAccessFile fos = null;
		try {
			Pub.LOG("mDownloadInfo.getDownloadSize() ===== " + mDownloadInfo.getDownloadSize());
			Pub.LOG("mDownloadInfo.getTotalSize() ===== " + mDownloadInfo.getTotalSize());
			if (mDownloadInfo.getDownloadSize() < mDownloadInfo.getTotalSize()) {

				// 文件未下载完成，获取到当前指针位置，继续下载。
				byte[] buffer = new byte[BUFFER_SIZE];
				int offset = 0;
				fos = new RandomAccessFile(file, "rwd");

				try {
					http.setRequestProperty("Range", "bytes=" + mDownloadInfo.getDownloadSize() + "-" + mDownloadInfo.getTotalSize());// 设置获取实体数据的范围
					http.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.2; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)");
					http.setRequestProperty("Connection", "Keep-Alive");

					fos.seek(mDownloadInfo.getDownloadSize());
				} catch (Exception e) {
					e.printStackTrace();
					// 续传异常时，重新下载
					fos.seek(0);
				}

				is = http.getInputStream();
				while (!mDownloadInfo.isStop()) {// 若没有停止
					if (!mDownloadInfo.isPause()) {// 没有暂停（暂停时线程空转）
						if ((offset = is.read(buffer, 0, BUFFER_SIZE)) != -1) {
							fos.write(buffer, 0, offset);
							mDownloadInfo.setDownloadSize(mDownloadInfo.getDownloadSize() + offset);

							if (mDownloadInfo.isRestriction()) {
								try {
									try {
										int netType = Pub.getConnectionType();
										if (netType == Pub.NET_WIFI || netType == Pub.NET_3G) {
											Thread.sleep(250);
										} else {
											Thread.sleep(500);
										}
									} catch (Exception e) {
									}
								} catch (Exception e) {
								}
							}

							if (mDownloadInfo.isShowDialog()) {// 是否显示下载进度
								mHandler.sendEmptyMessage(Downloader.SHOW);
							} else {
								mHandler.sendEmptyMessage(Downloader.CLOSE);
							}
						} else {
							// 下载结束，跳出
							break;
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			Pub.LOG("finally ------------------");
			if (mDownloadInfo.getDownloadSize() == mDownloadInfo.getTotalSize() && mDownloadInfo.getTotalSize() > 0) {// 下载完成
				file.renameTo(new File(mDownloadInfo.getFilePath()));
				mCallBack.noticeDownloadStatus(DownloadCallback.Success);
			} else if (mDownloadInfo.getDownloadSize() < mDownloadInfo.getTotalSize()) {// 中断
				if (mDownloadInfo.isStop()) {// 取消下载
					mCallBack.noticeDownloadStatus(DownloadCallback.Stop);
				} else if (mDownloadInfo.isPause()) {// 暂停下载
					mCallBack.noticeDownloadStatus(DownloadCallback.Pause);
				}
			} else {// 下载异常
				mCallBack.noticeDownloadStatus(DownloadCallback.FileException);
			}
			mHandler.sendEmptyMessage(Downloader.CLOSE);
			try {
				if (is != null) {
					is.close();
					is = null;
				}
				if (fos != null) {
					fos.close();
					fos = null;
				}
				http.disconnect();
				finished = true;
				start = false;
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public synchronized void start() {
		// TODO Auto-generated method stub
		super.start();
		start = true;
		finished = false;
	}

	/**
	 * 是否已经开始下载
	 *
	 * @return
	 */
	public boolean isStart() {
		return start;
	}

	/**
	 * 是否已经结束下载
	 *
	 * @return
	 */
	public boolean isFinished() {
		return finished;
	}

	/**
	 * 获取本地已下载进度
	 *
	 * @return
	 */
	public long getInitPosition() {
		return initPosition;
	}
}
