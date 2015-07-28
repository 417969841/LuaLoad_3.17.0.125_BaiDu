package com.tongqu.client.game;

import com.tongqu.client.lord.GameApplication;
import com.tongqu.client.lord.LoadActivity;
import com.tongqu.client.lord.TQGameMainScene;

public class TQLuaAndroidConsole {

	public static final String PackageName = "com.tongqu.client.lord";

	public static TQGameMainScene getGameSceneInstance() {
		return TQGameMainScene.getInstance();
	}

	public static GameApplication getApplicationInstance() {
		return GameApplication.getInstance();
	}

	public static Class<TQGameMainScene> getGameMainSceneClass() {
		return TQGameMainScene.class;
	}

	public static Class<LoadActivity> getLoadActivityClass() {
		return LoadActivity.class;
	}

}
