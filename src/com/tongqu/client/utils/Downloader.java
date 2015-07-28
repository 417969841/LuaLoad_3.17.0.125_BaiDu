package com.tongqu.client.utils;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.TypedValue;
import android.view.Gravity;

import com.tongqu.client.game.DownloadProgressPopWindow;
import com.tongqu.client.game.DownloadTableResourceProgressPopWindow;
import com.tongqu.client.game.TQLuaAndroidConsole;

/**
 * 1.任何由后台下载的线程都将要进行限速操作.
 *
 * 2.后台在开启一个下载任务时需要先判断该任务是否还存在.
 *
 * 3.若下载任务由前端交给后台时需要进行限速，并判断目前后台是否有下载任务。若有则需要排队.
 *
 * 4.若下载任务由后台交给前端时需要进行优先下载。当后台开始下载到该任务时需要判断该任务是否已然存在.
 *
 * 5.前端可执行线程数量依用户需求可以出现创建.
 *
 * 6.后台最大只能拥有1个下载线程.
 *
 */
public class Downloader {

	public static Downloader mInstance;

	private HashMap<String, DownloadInfo> mhDownTaskMap = new HashMap<String, DownloadInfo>();// 下载队列

	private HashMap<String, Integer> zipDataMap = new HashMap<String, Integer>();// 下载文件大小数据

	private Downloader(Context ctx) {

		loadZipData();
	}

	public static Downloader getInst() {
		if (mInstance == null) {
			mInstance = new Downloader(TQLuaAndroidConsole.getGameSceneInstance());
		}
		return mInstance;
	}

	/**
	 * 获取要下载的文件名
	 *
	 * @param url
	 * @return
	 */
	private String getFileNameFromUrl(String url) {
		int index = url.lastIndexOf('/');
		return url.substring(index + 1);
	}

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
	 * @param isShowDialog
	 *            是否显示现在进度界面
	 */
	public void getDownloadFile(String url, String dir, Handler handler, int engineId, boolean isRestriction, boolean isShowDialog) {
		getDownloadFile(url, dir, handler, engineId, isRestriction, isShowDialog, false);
	}

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
	 * @param isShowDialog
	 *            是否显示现在进度界面
	 * @param isTableRes
	 *            是否是牌桌资源
	 */
	public void getDownloadFile(String url, String dir, Handler handler, int engineId, boolean isRestriction, boolean isShowDialog, boolean isTableRes) {
		getDownloadFile(url, dir, handler, engineId, isRestriction, isShowDialog, isTableRes, false);
	}

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
	 * @param isShowDialog
	 *            是否显示现在进度界面
	 * @param isTableRes
	 *            是否是牌桌资源
	 * @param isPause
	 *            是否暂停
	 */
	public void getDownloadFile(String url, String dir, Handler handler, int engineId, boolean isRestriction, boolean isShowDialog, boolean isTableRes, boolean isPause) {
		DownloadInfo downInfo = new DownloadInfo(url, dir);
		downInfo.setUpdateHandler(handler);
		downInfo.setEngineId(engineId);
		downInfo.setRestriction(isRestriction);
		downInfo.setShowDialog(isShowDialog);
		downInfo.setTableRes(isTableRes);

		if (mhDownTaskMap.get(url) != null) {// 文件下载中

			// Toast.makeText(GameApplication.getCurrentActivity(),
			// "已加入下载队列，请稍后",
			// Toast.LENGTH_LONG).show();

			mhDownTaskMap.get(url).setUpdateHandler(handler);
			mhDownTaskMap.get(url).setEngineId(engineId);
			mhDownTaskMap.get(url).setRestriction(isRestriction);
			mhDownTaskMap.get(url).setShowDialog(isShowDialog);
			if (mDownloadThread != null && mDownloadThread.mDownloadInfo != null) {// 当前正有下载任务
				if (mDownloadThread.mDownloadInfo.getDownloadUrl().equals(url)) {// 新添加的任务正是当前下载任务
					mDownloadThread.mDownloadInfo.setUpdateHandler(handler);
					mDownloadThread.mDownloadInfo.setEngineId(engineId);
					mDownloadThread.mDownloadInfo.setRestriction(isRestriction);
					mDownloadThread.mDownloadInfo.setShowDialog(isShowDialog);
					mDownloadThread.mDownloadInfo.setTableRes(isTableRes);
					mDownloadThread.mDownloadInfo.setPause(isPause);
				}
			}
		} else {// 文件未下载
			mhDownTaskMap.put(url, downInfo);
			startDownload(url);
		}

		if (isTableRes && downInfo.isShowDialog() && isPause) {// 牌桌资源下载
																// 要尽快显示下载框
			mDownloadProgressHandler.sendEmptyMessage(Downloader.SHOW);
		}
	}

	/**
	 * 校验文件
	 *
	 * @param url
	 * @return true 文件完整，false 文件不完整
	 */
	public boolean verifyZipFile(String url, String dir) {
		DownloadInfo downInfo = new DownloadInfo(url, dir);
		boolean isfull = true;
		File file = new File(downInfo.getFilePath());
		if (file.exists()) {
			if (zipDataMap.size() > 0 && zipDataMap.get(downInfo.getDownloadUrl()) != null) {
				int size = zipDataMap.get(downInfo.getDownloadUrl());
				if (size != file.length()) {
					file.delete();
					isfull = false;
				}
			}
		}
		return isfull;
	}

	/**
	 * 根据url获取zip包路径
	 *
	 * @param url
	 * @return
	 */
	public String getZipFilePath(String url, String dir) {
		DownloadInfo downInfo = new DownloadInfo(url, dir);
		return downInfo.getFilePath();
	}

	/**
	 * 存储zip文件数据
	 */
	private void writeZipData() {
		if (FilesUtil.getInstance().fileSDOpen(FilesUtil.WRITE, FilesUtil.ReloadResDataName)) {
			DataOutputStream dos = FilesUtil.getInstance().dataOut;
			try {
				if (zipDataMap.size() > 0) {
					dos.writeInt(zipDataMap.size());
					Iterator iter = zipDataMap.entrySet().iterator();
					while (iter.hasNext()) {
						Map.Entry entry = (Map.Entry) iter.next();
						String key = (String) entry.getKey();
						int size = (Integer) entry.getValue();
						dos.writeUTF(key);
						dos.writeInt(size);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			FilesUtil.getInstance().fileClose();
		}
	}

	/**
	 * 读取zip文件数据
	 */
	private void loadZipData() {
		if (FilesUtil.getInstance().fileSDOpen(FilesUtil.READ, FilesUtil.ReloadResDataName)) {// 有存档
			DataInputStream dis = FilesUtil.getInstance().dataIn;
			try {
				int num = dis.readInt();
				for (int i = 0; i < num; i++) {
					String key = dis.readUTF();
					int size = dis.readInt();
					zipDataMap.put(key, size);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			FilesUtil.getInstance().fileClose();
		}
	}

	/**
	 * 文件是否存在
	 *
	 * @param url
	 * @return
	 */
	public boolean existsFile(String url, String dir) {
		DownloadInfo downInfo = new DownloadInfo(url, dir);
		File file = new File(downInfo.getFilePath());
		if (file.exists()) {
			return true;
		}
		return false;
	}

	/**
	 * zip文件是否正在下载
	 *
	 * @param url
	 * @return
	 */
	public boolean isZipDownloading(String url) {
		if (mhDownTaskMap.get(url) != null) {
			return true;
		}
		return false;
	}

	/**
	 * 获取文件的byte数组
	 *
	 * @param dir
	 * @param fileName
	 * @return
	 */
	public byte[] getFileData(String dir, String fileName) {
		byte[] fileData = null;
		if (Pub.isPics(fileName)) {
			fileName += "_data";
		}
		File dirFile = new File(dir);
		File file = new File(dirFile, fileName);
		if (file.exists()) {
			fileData = getBytesFromFile(file);
		}
		return fileData;
	}

	private byte[] getBytesFromFile(File file) {
		byte[] bytes = null;
		try {
			FileInputStream fis = new FileInputStream(file);
			long length = file.length();
			bytes = new byte[(int) length];
			fis.read(bytes);
			fis.close();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return bytes;
	}

	/**
	 * 获得文件夹下文件的名字
	 *
	 * @param fileName
	 * @return
	 */
	public String[] getFileName(String dir, String fileName) {
		String[] name = null;
		File file = new File(dir + File.separator + fileName);
		File[] files = file.listFiles();
		if (files != null && files.length > 0) {
			name = new String[files.length];
			for (int i = 0; i < files.length; i++) {
				name[i] = files[i].getName();
			}
		}
		return name;
	}

	/**
	 * 读取sd卡上的文件下所有图片资源
	 *
	 * @param name
	 * @return 返回 HashMap<String, Bitmap> -- <文件名,图片>
	 */
	public HashMap<String, Bitmap> readBitmapFile(String DirfileName) {
		HashMap<String, Bitmap> animationFrame = new HashMap<String, Bitmap>();
		File file = new File(DirfileName);
		File[] files = file.listFiles();
		if (files != null && files.length > 0) {
			for (int i = 0; i < files.length; i++) {
				FileInputStream fis = null;
				try {
					fis = new FileInputStream(files[i]);
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				}
				if (fis != null) {
					TypedValue value = new TypedValue();
					BitmapFactory.Options opts = new BitmapFactory.Options();
					opts.inTargetDensity = value.density;
					try {
						Bitmap tempImg = BitmapFactory.decodeStream(fis, null, opts);
						animationFrame.put(files[i].getName(), tempImg);
					} catch (OutOfMemoryError e) {
						e.printStackTrace();
					}
				}
			}
		}
		return animationFrame;
	}

	/**
	 * 获取二次加载文件中的图片
	 *
	 * @param url
	 * @param map
	 * @return
	 */
	public Bitmap getSDFileBitmap(String url, HashMap<String, Bitmap> map) {
		Bitmap temp = null;
		String fileName = getFileNameFromUrl(url) + "_data";
		temp = map.get(fileName);
		return temp;
	}

	/**
	 * 获取文件BufferedReader
	 *
	 * @param dir
	 * @param fileName
	 * @return
	 */
	public BufferedReader getBufferedReader(String dir, String fileName) {
		FileInputStream fis = getFileInputStream(dir, fileName);
		if (fis != null) {
			return new BufferedReader(new InputStreamReader(fis));
		}
		return null;
	}

	/**
	 * 获取文件输入流
	 *
	 * @param dir
	 * @param fileName
	 * @return
	 */
	public FileInputStream getFileInputStream(String dir, String fileName) {
		if (Pub.isPics(fileName)) {
			fileName += "_data";
		}
		File dirFile = new File(dir);
		File file = new File(dirFile, fileName);
		if (file.exists()) {
			try {
				return new FileInputStream(file);
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;
	}

	public int getMapSize() {
		return mhDownTaskMap.size();
	}

	public int getProgress(String url) {
		int progress = 0;
		DownloadInfo ri = mhDownTaskMap.get(url);
		if (ri == null) {

		} else if (ri.getTotalSize() != 0) {
			progress = (int) (ri.getDownloadSize() * 1.0 / ri.getTotalSize() * 100);
		}
		return progress;
	}

	public DownloadThread mDownloadThread;// 当前下载线程

	/**
	 * 开始前端下载
	 *
	 * @param downurl
	 */
	private void startDownload(final String downurl) {
		// TODO Auto-generated method stub
		DownloadInfo ri = mhDownTaskMap.get(downurl);
		if (ri == null) {
			return;
		}
		Pub.LOG("开始一个新二次下载==" + downurl);

		if (mDownloadThread == null) {// 当前无下载任务
			newDownloadThread(ri);
		} else {// 当前有下载任务
			if (ri.isShowDialog() && !mDownloadThread.mDownloadInfo.isShowDialog()) {// 如果是前端要显示的任务&&当前任务不显示下载进度

				stopDownloadThread(DownloadCallback.Pause);// 暂停上一个线程

				newDownloadThread(ri);// 开始新线程
			}
		}
	}

	/**
	 * 新建下载线程
	 *
	 * @param data
	 */
	public void newDownloadThread(final DownloadInfo data) {
		try {
			data.setPause(false);
			mDownloadThread = new DownloadThread(data, mDownloadCallback, mDownloadProgressHandler);

			File file = new File(data.getFilePath());
			if (file.exists()) {// 文件存在
				if (verifyZipFile(data.getDownloadUrl(), data.getMsOriginalDir())) {// 已经下载完成
					sendDownloadFollowUpMsg(data, Directly_Complete);
					stopDownloadThread(DownloadCallback.Success);
					logicNextTask();
				} else {// 本地文件有异常
					mDownloadCallback.noticeDownloadStatus(DownloadCallback.FileException);
				}
			} else {// 文件不存在
				// 添加zip数据
				URL url = new URL(data.getDownloadUrl());
				HttpURLConnection http = (HttpURLConnection) url.openConnection();
				int filesize = http.getContentLength();// 根据响应获取文件大小
				data.setTotalSize(filesize);
				http.disconnect();
				Pub.LOG("filesize ================ " + filesize);
				zipDataMap.put(data.getDownloadUrl(), filesize);
				writeZipData();
				if (mDownloadThread != null && !mDownloadThread.isStart()) {
					mDownloadThread.start();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 停止当前下载线程
	 */
	public void stopDownloadThread(int type) {
		if (mDownloadThread != null && mDownloadThread.mDownloadInfo != null) {
			try {
				switch (type) {
				case DownloadCallback.Success:
					// 下载成功，移除任务
					removeMapData();
					break;
				case DownloadCallback.Stop:
					// 下载取消，移除任务
					mDownloadThread.mDownloadInfo.setStop(true);
					removeMapData();
					break;
				case DownloadCallback.Pause:
					// 下载暂停
					mDownloadThread.mDownloadInfo.setPause(true);
					break;
				case DownloadCallback.FileException:
					// 文件异常

					break;
				default:
					break;
				}

				Thread tmpBlinker = mDownloadThread;
				mDownloadThread = null;
				if (tmpBlinker != null) {
					tmpBlinker.interrupt();
				}

				System.gc();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 删除本地文件
	 *
	 * @param data
	 */
	private void deleteFile(String filePath) {
		try {
			File file = new File(filePath);
			if (file.exists()) {
				file.delete();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 移除下载完成的任务
	 */
	private void removeMapData() {
		if (mDownloadThread != null && mDownloadThread.mDownloadInfo != null) {
			mhDownTaskMap.remove(mDownloadThread.mDownloadInfo.getDownloadUrl());
		}
	}

	private DownloadProgressPopWindow mDownloadProgressPopWindow;// 下载进度界面
	private DownloadTableResourceProgressPopWindow mDownloadTableResourceProgressPopWindow;// 牌桌资源下载进度界面

	public static final int SHOW = 100;// 显示下载进度界面
	public static final int CLOSE = 101;// 关闭下载进度界面

	/**
	 * 控制下载进度界面的显示/关闭
	 */
	Handler mDownloadProgressHandler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case SHOW:
				showDownloadProgress();
				break;
			case CLOSE:
				closeDownloadProgress();
				break;
			}
		}
	};

	/**
	 * 显示下载进度界面
	 */
	private void showDownloadProgress() {
		if (mDownloadThread != null && mDownloadThread.mDownloadInfo != null) {
			if (mDownloadThread.mDownloadInfo.isTableRes()) {
				if (!(mDownloadTableResourceProgressPopWindow != null && mDownloadTableResourceProgressPopWindow.isShowing())) {
					mDownloadTableResourceProgressPopWindow = new DownloadTableResourceProgressPopWindow(TQLuaAndroidConsole.getGameSceneInstance(), mDownloadThread.mDownloadInfo, mDownloadThread.getInitPosition());
					mDownloadTableResourceProgressPopWindow.showAtLocation(TQLuaAndroidConsole.getGameSceneInstance().getWindow().getDecorView(), Gravity.CENTER, 0, 0);
				}
			} else {
				if (!(mDownloadProgressPopWindow != null && mDownloadProgressPopWindow.isShowing())) {
					mDownloadProgressPopWindow = new DownloadProgressPopWindow(TQLuaAndroidConsole.getGameSceneInstance(), mDownloadThread.mDownloadInfo, mDownloadThread.getInitPosition());
					mDownloadProgressPopWindow.showAtLocation(TQLuaAndroidConsole.getGameSceneInstance().getWindow().getDecorView(), Gravity.CENTER, 0, 0);
				}
			}
		}
	}

	/**
	 * 牌桌资源下载框是否在下载中
	 */
	public boolean isDownloadTableResourceProgressPopWindowShowing() {
		return (mDownloadTableResourceProgressPopWindow != null && mDownloadTableResourceProgressPopWindow.isShowing());
	}

	/**
	 * 关闭下载进度界面
	 */
	private void closeDownloadProgress() {
		if (mDownloadProgressPopWindow != null && mDownloadProgressPopWindow.isShowing()) {
			mDownloadProgressPopWindow.dismiss();
		}
	}

	/**
	 * 下载成功或失败以后，开启下一个任务
	 */
	private void logicNextTask() {
		if (!mhDownTaskMap.isEmpty()) {
			Iterator iter = mhDownTaskMap.entrySet().iterator();
			while (iter.hasNext()) {
				Map.Entry entry = (Map.Entry) iter.next();
				String tempUrl = (String) entry.getKey();
				startDownload(tempUrl);
				break;
			}
		}
	}

	/**
	 * 下载回调接口
	 */
	DownloadCallback mDownloadCallback = new DownloadCallback() {

		@Override
		public void noticeDownloadStatus(int status) {
			// TODO Auto-generated method stub
			try {
				switch (status) {
				case DownloadCallback.Stop:
					// 下载中断(主动或被动停止下载)
					stopDownloadThread(status);
					logicNextTask();
					break;
				case DownloadCallback.Success:
					// 下载成功
					if (mDownloadThread != null && mDownloadThread.mDownloadInfo != null) {
						// 下载成功后的通知
						if (mDownloadThread.mDownloadInfo.getUpdateHandler() != null) {
							sendDownloadFollowUpMsg(mDownloadThread.mDownloadInfo, Download_Complete);
						}
					}
					stopDownloadThread(status);
					logicNextTask();
					break;
				case DownloadCallback.Pause:
					// 开启优先极高的任务，暂停下载

					break;
				case DownloadCallback.FileException:
					// 文件异常
					if (mDownloadThread != null && mDownloadThread.mDownloadInfo != null) {
						// 下载成功后的通知
						if (mDownloadThread.mDownloadInfo.getUpdateHandler() != null) {
							sendExceptionMsg(mDownloadThread.mDownloadInfo, Download_Complete);
						}
					}
					stopDownloadThread(status);
					deleteFile(mDownloadThread.mDownloadInfo.getFilePath());
					newDownloadThread(mDownloadThread.mDownloadInfo);
					break;
				default:
					break;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	};

	public static final int Download_Complete = 0;// 本地没有下载完成
	public static final int Directly_Complete = 1;// 本地已有直接完成

	/**
	 * 发送下载完成通知
	 *
	 * @param downloadInfo
	 * @param downloadType下载类型
	 *            0:本地没有下载完成；1:本地已有直接完成
	 */
	private void sendDownloadFollowUpMsg(DownloadInfo downloadInfo, int downloadType) {
		if (downloadInfo != null && downloadInfo.getUpdateHandler() != null) {
			Message msg = new Message();
			msg.what = downloadInfo.getEngineId();
			Bundle bundle = new Bundle();

			bundle.putInt("DownloadType", downloadType);
			bundle.putString("DownloadUrl", downloadInfo.getDownloadUrl());
			bundle.putString("FilePath", downloadInfo.getFilePath());
			bundle.putString("DirPath", downloadInfo.getFileDir());
			msg.setData(bundle);// mes利用Bundle传递数据

			downloadInfo.getUpdateHandler().sendMessage(msg);
		}
	}

	/**
	 * 发送异常数据
	 *
	 * @param downloadInfo
	 * @param downloadType
	 */
	private void sendExceptionMsg(DownloadInfo downloadInfo, int downloadType) {
		if (downloadInfo != null && downloadInfo.getUpdateHandler() != null) {
			Message msg = new Message();
			if (downloadInfo.getEngineId() == DownloadFollowUp.DOWNLOAD_ACTION_H) {
				// lua升级
				msg.what = DownloadFollowUp.DOWNLOAD_Lua_Exception;
			} else {
				msg.what = DownloadFollowUp.DOWNLOAD_Exception;
			}
			Bundle bundle = new Bundle();

			bundle.putInt("DownloadType", downloadType);
			bundle.putString("DownloadUrl", downloadInfo.getDownloadUrl());
			bundle.putString("FilePath", downloadInfo.getFilePath());
			bundle.putString("DirPath", downloadInfo.getFileDir());
			msg.setData(bundle);// mes利用Bundle传递数据

			downloadInfo.getUpdateHandler().sendMessage(msg);
		}
	}

	/**
	 * 停止所有下载
	 */
	public void stopDownload() {
		if (!mhDownTaskMap.isEmpty()) {
			Iterator iter = mhDownTaskMap.entrySet().iterator();
			while (iter.hasNext()) {
				Map.Entry entry = (Map.Entry) iter.next();
				String tempUrl = (String) entry.getKey();
				mhDownTaskMap.get(tempUrl).setStop(true);
			}
			mhDownTaskMap.clear();
		}
	}
}
