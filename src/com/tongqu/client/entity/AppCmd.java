package com.tongqu.client.entity;

public class AppCmd {

	// AIDL通信
	public static final int AIDL = 0x00010000;
	// 广播
	public static final int BROADCAST = 0x00020000;
	// 退出平台
	public static final int AIDL_QUIT_APP = AIDL + 1;
	// 2.1用户登录
	public static final int BROAD_USER_INFO = BROADCAST + 1;
	// 2.2通知其他同趣游戏退出
	public static final int BROAD_QUIT_TONGQU_GAMES = BROADCAST + 2;
	// 2.3询问其他同趣游戏牌桌是否退出并参加新比赛（开赛前30秒）
	public static final int BROAD_MATCH_ALARM = BROADCAST + 3;
	// 2.4启动游戏到指定的Activity，并传递Bundle参数
	public static final int BROAD_START_GAME = BROADCAST + 4;
	// 2.5询问用户名密码
	public static final int BROAD_REQ_LOGININFO = BROADCAST + 5;
	// 2.6得到用户名密码
	public static final int BROAD_RESP_LOGININFO = BROADCAST + 6;
}
