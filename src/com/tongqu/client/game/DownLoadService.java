package com.tongqu.client.game;

import java.util.ArrayList;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;

import com.tongqu.client.utils.Downloader;
import com.tongqu.client.utils.Pub;

public class DownLoadService extends Service {

	public static final int MSG_WHAT_DOWNLOAD_CHECK = 1000;

	private long startTime;

	@Override
	public IBinder onBind(Intent intent) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		super.onCreate();
		TQLuaAndroidConsole.getApplicationInstance().addService(this);
		startTime = System.currentTimeMillis();
		Pub.LOG("DownLoadService::onCreate");
		// // 牌桌动画下载无关网络
		// Downloader.getInst().getDownloadFile(Const.URL_TABLE_EMOTION,
		// Const.DIR_RELOAD, downloadHandler, 1, true, false);
		// // 下载礼包图片文件
		// Downloader.getInst().getDownloadFile(Const.URL_GIFT_LORD,
		// Const.DIR_RELOAD, downloadHandler, 2, true, false);
		// // 下载音乐文件
		// Downloader.getInst().getDownloadFile(Const.URL_LORD_MUSIC,
		// Const.DIR_RELOAD, downloadHandler, 3, true, false);
		// // 下载普通表情
		// Downloader.getInst().getDownloadFile(Const.URL_BIAOQING_COMMON,
		// Const.DIR_RELOAD, downloadHandler, 4, true, false);
		// // 下载高级表情
		// Downloader.getInst().getDownloadFile(Const.URL_BIAOQING_SUPERIOR,
		// Const.DIR_RELOAD, downloadHandler, 5, true, false);

		list.clear();
		list.add(1);
		list.add(2);
		list.add(3);
		list.add(4);
		list.add(5);
	}

	private ArrayList<Integer> list = new ArrayList<Integer>();

	Handler downloadHandler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			if (msg.what == MSG_WHAT_DOWNLOAD_CHECK) {
				if ((System.currentTimeMillis() - startTime > 10 * 60 * 1000)) {// 下载完或十分钟自动停止服务
					DownLoadService.this.stopSelf();
					Pub.LOG("DownLoadService stop " + (System.currentTimeMillis() - startTime));
				} else {
					if (Pub.getConnectionType() != Pub.NET_WIFI) {
						DownLoadService.this.stopSelf();
					} else {
						downloadHandler.sendEmptyMessageDelayed(MSG_WHAT_DOWNLOAD_CHECK, 10000);
					}
				}
			} else {
				list.remove((Integer) msg.what);
				Pub.LOG("DownLoadService list.size=" + list.size());
				if (list.size() == 0) {
					downloadHandler.sendEmptyMessage(MSG_WHAT_DOWNLOAD_CHECK);
				}

			}
		};
	};

	@Override
	public void onDestroy() {
		Pub.LOG("DownLoadService onDestroy ");
		TQLuaAndroidConsole.getApplicationInstance().removeService(this);
		if (TQLuaAndroidConsole.getApplicationInstance().getServiceCnt() == 0) {
			System.exit(0);
		} else {
			Downloader.getInst().stopDownload();
		}
	};

}
