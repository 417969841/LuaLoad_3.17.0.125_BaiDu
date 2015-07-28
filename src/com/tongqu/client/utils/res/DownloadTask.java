package com.tongqu.client.utils.res;

public class DownloadTask {

	public int mResID;
	public String mUrl;
	public boolean done;
	
	public DownloadTask(int resID, String url) {
		mResID = resID;
		mUrl = url;
	}
	
	public String toString() {
		return "下载任务" + mResID + "(" + mUrl + ")";
	}
}
