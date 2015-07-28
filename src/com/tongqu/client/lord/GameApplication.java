package com.tongqu.client.lord;

import java.util.ArrayList;

import android.app.Application;
import android.app.Service;

import com.baidu.frontia.FrontiaApplication;
import com.tongqu.client.utils.Pub;
import com.tongqu.client.utils.res.RemoteResMgr;

public class GameApplication extends Application {

	private RemoteResMgr mRemoteResourceMgr;

	private static GameApplication instance;

	public static GameApplication getInstance() {
		return instance;
	}

	@Override
	public void onCreate() {
		super.onCreate();

		instance = this;
		mRemoteResourceMgr = new RemoteResMgr(this);
		Thread th = new Thread(mRemoteResourceMgr);
		th.start();
		Pub.getSaveFilePath();
		FrontiaApplication.initFrontiaApplication(this.getApplicationContext());
	}

	// 服务列表
	private ArrayList<Service> serviceList = new ArrayList<Service>();

	public void addService(Service service) {
		serviceList.add(service);
	}

	public void removeService(Service service) {
		serviceList.remove(service);
	}

	public int getServiceCnt() {
		return serviceList.size();
	}
}
