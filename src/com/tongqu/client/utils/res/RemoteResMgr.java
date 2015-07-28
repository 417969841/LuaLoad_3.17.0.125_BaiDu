package com.tongqu.client.utils.res;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Rect;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.util.TypedValue;

import com.tongqu.client.entity.CallBackInfo;
import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.utils.Pub;

/**
 *
 * 图片缓存目录：/pic/cache
 */
public class RemoteResMgr implements Runnable {
	private static LinkedList<DownloadTask> allTask = new LinkedList<DownloadTask>();
	private static DownloadTask lastTask = null;
	public static int downnum;
	private Handler handler = new RemoteHandler();
	// 请求资源的map。 K：网址 V:资源Handler
	private static HashMap<String, List<CallBackInfo>> mRequestMap = new HashMap<String, List<CallBackInfo>>();
	private static HashMap<String, DownloadTask> mTaskMap = new HashMap<String, DownloadTask>();

	public synchronized static void requestRes(String sUrl, Handler handler, int nResID, boolean bHighPri) {
		// if (true) return;
		if (sUrl == null || sUrl.equals("")) {
			return;
		}
		// 先看看本地缓存是否存在
		if (exists(sUrl) && handler != null) {
			Message msg = new Message();
			msg.obj = new DownloadTask(nResID, sUrl);
			handler.sendMessage(msg);
			return;
		}
		// 从服务器下载
		List<CallBackInfo> ls = mRequestMap.get(sUrl);
		CallBackInfo mcallBackInfo = null;
		if (ls == null) {
			if (handler != null) {
				ls = new ArrayList<CallBackInfo>();
			}
			// 开始下载
			addTask(new DownloadTask(nResID, sUrl), bHighPri);
		}
		if (handler != null) {
			mcallBackInfo = new CallBackInfo();
			mcallBackInfo.mHandler = handler;
			mcallBackInfo.nResID = nResID;
			ls.add(mcallBackInfo);
			mRequestMap.put(sUrl, ls);
		}
	}

	private final class RemoteHandler extends Handler {
		public void handleMessage(Message msg) {
			String url = msg.getData().getString("URL");
			DownloadTask task = mTaskMap.get(url);
			if (msg.getData().getBoolean("done") == true) {
				downnum--;
				// if(type.equals("image/jpeg"))
				{
					InputStream is = new ByteArrayInputStream((byte[]) ((Object[]) msg.obj)[1]);
					try {
						RemoteResMgr.store(url, is);
						is.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
				if (task != null) {
					task.done = true;
				}
			} else if (msg.getData().getBoolean("wrongurl") == true) {
				// Toast.makeText(ActivityBase.getCurrent(), msg.obj.toString(),
				// Toast.LENGTH_LONG).show();
				downnum--;
				if (task != null) {
					task.done = false;
				}
			}
			// 反馈给监听者
			// 查找所有的监听者
			List<CallBackInfo> lsHandler = mRequestMap.get(url);
			if (lsHandler != null) {
				if (task.done) {
					for (int i = 0; i < lsHandler.size(); i++) {
						if (lsHandler.get(i) != null) {
							Message msg1 = new Message();
							DownloadTask callbackTask = new DownloadTask(lsHandler.get(i).nResID, url);
							msg1.obj = callbackTask;
							lsHandler.get(i).mHandler.sendMessage(msg1);
						}
					}
				}
				lsHandler.clear();
				lsHandler = null;
				mRequestMap.remove(url);
			}
			mTaskMap.remove(url);
		}
	}

	// http://photo.99sai.com/upload/头像地址根目录
	public static final String PHOTO_URL = "http://photo.99sai.com/upload/";

	private static DiskCache mDiskCache;
	// http://photo.99sai.com/upload/头像地址根目录
	private static DiskCache mPhotoDiskCache;

	public RemoteResMgr(Context context) {
		if (Environment.getExternalStorageDirectory().canWrite()) {
			mDiskCache = new HasDiskCache(context, "TqPic", context.getPackageName());
			mPhotoDiskCache = new HasDiskCache(context, "TqPic", "Photo");
		} else {
			mDiskCache = new NullDiskCache(context, "pic", context.getPackageName());
			mPhotoDiskCache = new NullDiskCache(context, "pic", "Photo");
		}
	}

	public static boolean exists(String url) {
		if (url != null && !url.equals("")) {
			String md5 = MD5.toMd5(url.getBytes());
			if (url.contains(PHOTO_URL)) {
				return mPhotoDiskCache.exists(md5);
			} else {
				return mDiskCache.exists(md5);
			}
		} else {
			return false;
		}
	}

	public static File getFile(String url) {
		String md5 = MD5.toMd5(url.getBytes());
		if (url.contains(PHOTO_URL)) {
			return mPhotoDiskCache.getFile(md5);
		} else {
			return mDiskCache.getFile(md5);
		}
	}

	public static InputStream getInputStream(String url) {
		try {
			if (url != null) {
				String md5 = MD5.toMd5(url.getBytes());
				if (url.contains(PHOTO_URL)) {
					return mPhotoDiskCache.getInputStream(md5);
				} else {
					return mDiskCache.getInputStream(md5);
				}
			} else {
				return null;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public static String getPicPath(String url) {
		if (url == null || url.equals("")) {
			return null;
		}
		String md5 = MD5.toMd5(url.getBytes());
		if (url.contains(PHOTO_URL)) {
			return mPhotoDiskCache.getFile(md5).getPath();
		} else {
			return mDiskCache.getFile(md5).getPath();
		}
	}

	public static Bitmap getpic(String url) throws IOException {
		if (url == null || url.equals("")) {
			return null;
		}
		BitmapFactory.Options opt = new BitmapFactory.Options();
		opt.inPreferredConfig = Bitmap.Config.RGB_565;
		opt.inJustDecodeBounds = false;
		opt.inDither = false;
		opt.inPurgeable = true;
		opt.inInputShareable = true;
		TypedValue value = new TypedValue();
		opt.inTargetDensity = value.density;

		FileInputStream fis = (FileInputStream) getInputStream(url);
		if (fis == null)
			return null;
		Bitmap bm = null;
		try {
			bm = BitmapFactory.decodeStream(fis, null, opt);
		} catch (OutOfMemoryError e) {
			e.printStackTrace();
		} finally {
			try {
				fis.close();
				fis = null;
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return bm;
	}

	public static Bitmap getSmallpic(String url) throws IOException {

		FileInputStream fis = (FileInputStream) getInputStream(url);
		if (fis == null)
			return null;
		Bitmap bm = null;

		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		// // 获取这个图片的宽和高
		bm = BitmapFactory.decodeStream(fis, new Rect(5, 5, 5, 5), options); // 此时返回bm为空
		options.inJustDecodeBounds = false;

		// 计算缩放比
		int be = (int) (options.outHeight / (float) 50);

		if (be <= 0)
			be = 1;
		options.inSampleSize = be;
		FileInputStream fis1 = (FileInputStream) getInputStream(url);
		bm = BitmapFactory.decodeStream(fis1, new Rect(5, 5, 5, 5), options);
		fis.close();
		fis1.close();
		return bm;
	}

	private static void store(String url, InputStream is) throws IOException {
		if (url.contains(PHOTO_URL)) {
			String mUrl = MD5.toMd5(url.getBytes());
			mPhotoDiskCache.store(mUrl, is);
		} else {
			String mUrl = MD5.toMd5(url.getBytes());
			mDiskCache.store(mUrl, is);
		}
	}

	/** 向工作队列中加入一个新任务 */
	private static synchronized void addTask(DownloadTask task, boolean isHigh) {
		if (task != null) {
			if (isHigh) {
				allTask.addFirst(task);// 插入一个任务
			} else {
				allTask.offer(task);// 向队列中加入一个任务
			}
		}
	}

	@Override
	public void run() {
		while (true) {
			lastTask = null;
			synchronized (allTask) {
				// Log.i("num10",String.valueOf(downnum));
				if (allTask.size() > 0 && downnum < 1) {// 取任务
					lastTask = allTask.poll();
					// 执行任务
					doTask(lastTask);
					downnum++;
				}
			}
			try {
				int netType = Pub.getConnectionType();
				if (netType == Pub.NET_WIFI || netType == Pub.NET_3G) {
					Thread.sleep(250);
				} else {
					Thread.sleep(500);
				}
			} catch (Exception e) {
			}
		}
	}

	private void doTask(DownloadTask task) {
		mTaskMap.put(task.mUrl, task);
		HttpEngine.getHttpEngine().begineGet(task.mUrl, handler, TQLuaAndroidConsole.getGameSceneInstance());
	}
}
