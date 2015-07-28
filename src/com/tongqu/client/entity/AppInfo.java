package com.tongqu.client.entity;

import com.tongqu.client.utils.Pub;

public class AppInfo {

	public String appName = "";
	public String packageName = "";
	public String versionName = "";
	public int versionCode = 0;

	public void print() {
		Pub.LOG("Name:" + appName + " Package:" + packageName);
		Pub.LOG("Name:" + appName + " versionName:" + versionName);
		Pub.LOG("Name:" + appName + " versionCode:" + versionCode);
	}

}