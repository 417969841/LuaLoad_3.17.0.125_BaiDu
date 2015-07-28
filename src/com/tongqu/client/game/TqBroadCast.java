package com.tongqu.client.game;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.telephony.SmsMessage;
import android.util.Log;

import com.pay.purse.SMSPursePayment;
import com.tongqu.client.config.GameConfig;
import com.tongqu.client.entity.AppCmd;
import com.tongqu.client.entity.User;
import com.tongqu.client.utils.Pub;

public class TqBroadCast extends BroadcastReceiver {

	public static final String CAN_NOT_AUTO_SEND = "如您的金币、元宝未到账，请您在手机短信中查看10658008的信息，回复信息中的3位数字验证码返回游戏即可获取！";
	public static final String PREFS_NAME = "SMS_MATCHES";
	public static final String TAG = "MsmRecevicer";
	public Context mContext;
	public static ArrayList<String> mContent = new ArrayList<String>();

	@Override
	public void onReceive(Context context, Intent intent) {
		if (!"android.provider.Telephony.SMS_RECEIVED".equals(intent.getAction())) {
			return;
		} else {
			Log.i(TAG, TAG + "-->onReceive");
			// 当系统收到短信时，会发出一个action名称为Android.provier.Telephony.SMS_RECEIVED的广播Intent，
			// 该Intent存放了接收到的短信内容，使用名称 "pdus"即可从Intent中获取短信内容。
			// pdus是一个object类型的数组，每一个object都是一个byte[]字节数组，每一项为一条短信。
			try {
				mContext = context;
				if (SMSPursePayment.SMS_MATCHES == null) {
					// 从本地ShardPreferences中取
					SharedPreferences settings = context.getSharedPreferences(PREFS_NAME, 0);
					String regex = settings.getString("matches", "");
					if (regex.equals("")) {
						return;
					}
					String[] result = regex.split("_");
					SMSPursePayment.SMS_MATCHES = result;
					for (int i = 0; i < SMSPursePayment.SMS_MATCHES.length; i++) {
						Pub.LOG("SMS_MATCHES in BroadCast " + SMSPursePayment.SMS_MATCHES[i]);
					}
					// SMSPursePayment.BEGIN_INT = Integer.parseInt(result[1]);
					// SMSPursePayment.END_INT = Integer.parseInt(result[2]);
				}
				Bundle bundle = intent.getExtras();
				// 判断是否有数据
				if (bundle != null) {
					Object[] pduses = (Object[]) intent.getExtras().get("pdus");
					for (Object pdus : pduses) {
						byte[] pdusmessage = (byte[]) pdus;
						SmsMessage sms = SmsMessage.createFromPdu(pdusmessage);
						String mobile = sms.getOriginatingAddress();// 发送短信的手机号码
						String content = sms.getDisplayMessageBody(); // 短信内容
						for (int i = 0; i < SMSPursePayment.SMS_MATCHES.length; i++) {
							Pattern p = Pattern.compile(SMSPursePayment.SMS_MATCHES[i]);
							Matcher m = p.matcher(content);
							if (m.matches()) {
								Pub.LOG("MsmRecevicer is matches");
								// String smsText =
								// content.substring(SMSPurseUtil.BEGIN_INT,
								// SMSPurseUtil.END_INT);
								// SmsManager smsMgr = SmsManager.getDefault();
								// smsMgr.sendTextMessage(mobile, null, smsText,
								// null, null);
								// SMSPurseUtil.getInstance().OVER_TIME_TEXT =
								// "支付信息获取失败,未能成功充值.";
								// SMSPurseUtil.getInstance().removeHandler();
								mContent.add(content);
								if (mContent.size() == 1) {
									mHandler.sendEmptyMessageDelayed(DELAY, 3000);
								}
							}
						}

						// Date date = new Date(sms.getTimestampMillis());
						// SimpleDateFormat format = new
						// SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						// String time = format.format(date); // 得到发送时间
						Log.i(TAG, TAG + "-------msm---------");
						Log.i(TAG, TAG + "-->mobile:" + mobile);
						Log.i(TAG, TAG + "-->content:" + content);
						// Log.i(TAG, TAG + "-->time:" + time);
						// if (BEGIN_TEXT.equals(content.substring(0, 3))) {
						// String[] message = setValue(content);
						// getIdentify(message);
						// Log.i(TAG, TAG + "-->result " +
						// getIdentify(message));
						// } else {
						// Log.i(TAG, TAG + "-->in else:");
						// }
					}
				}
			} catch (Exception e) {
				// SMSPurseUtil.getInstance().removeHandler();
				e.printStackTrace();
				AlertDialog dialog;
				AlertDialog.Builder builder = new AlertDialog.Builder(TQLuaAndroidConsole.getGameSceneInstance().getContext());
				builder.setTitle("提示").setIcon(android.R.drawable.stat_notify_error);
				builder.setMessage(CAN_NOT_AUTO_SEND);
				builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						//
					}
				});
				dialog = builder.create();
				dialog.show();
			}
		}

		if ("android.intent.action.BOOT_COMPLETED".equals(intent.getAction())) {
			Pub.LOG("系统启动广播，恢复闹钟");
			restorAlarm(context);
			return;
		}

		int nMsgID = intent.getIntExtra("MsgID", 0);
		switch (nMsgID) {
		case AppCmd.BROAD_USER_INFO:
			Pub.LOG("收到BROAD_USER_INFO");
			processUserLogin(context, intent);
			break;
		case AppCmd.BROAD_QUIT_TONGQU_GAMES:
			Pub.LOG("收到BROAD_QUIT_TONGQU_GAMES");
			processQuitTongquGames(context, intent);
			break;
		case AppCmd.BROAD_MATCH_ALARM:
			Pub.LOG("收到BROAD_MATCH_ALARM_ON_TABLE");
			processMatchAlarm(context, intent);
			break;
		case AppCmd.BROAD_START_GAME:
			Pub.LOG("收到BROAD_START_GAME");
			processStartGame(context, intent);
			break;
		case AppCmd.BROAD_REQ_LOGININFO:
			Pub.LOG("收到BROAD_REQ_LOGININFO");
			processLoginInfoReq(context, intent);
			break;
		case AppCmd.BROAD_RESP_LOGININFO:
			Pub.LOG("收到BROAD_RESP_LOGININFO");
			processLoginInfoResp(context, intent);
			break;
		default:
			Pub.LOG("收到未知广播 " + nMsgID);
			break;
		}

	}

	/**
	 * 手机重启后，从数据库恢复闹钟
	 *
	 * @param context
	 */
	private void restorAlarm(Context context) {
		// AlarmRecord[] aar = TqLordConfig.getInst().getAlarmList();
		// if (aar == null) {
		// return;
		// }
		// for (int i = 0; i < aar.length; i++) {
		// Pub.LOG("恢复闹钟 " + aar[i]);
		// if (System.currentTimeMillis() > aar[i].mnAlertTime) {
		// Pub.LOG("闹钟过期，从数据库删除");
		// TqLordConfig.getInst().deleteAlarm(aar[i].mnMatchID);
		// } else {
		// long nDelay = 2 * 60 * 1000;
		// long nMsBeforeMatchStart = aar[i].mnAlertTime -
		// System.currentTimeMillis();
		// if (nMsBeforeMatchStart > nDelay) {
		// MatchAlarmBroadCast.addAlarm(context, aar[i].mnGameID,
		// aar[i].mnMatchID, SystemClock.elapsedRealtime() +
		// nMsBeforeMatchStart, aar[i].msTitle, aar[i].msMatchInstanceID);
		// }
		// }
		// }
		// System.exit(0);
	}

	private void processQuitTongquGames(Context context, Intent intent) {
		// FromApp text 发起进程名
		// String sFromApp = intent.getStringExtra("FromApp");
		// if (!Const.APP_NAME.equals(sFromApp)) {
		// ActivityBase.KICK_OFF_LINE = true;
		// if (GameApplication.getCurrentActivity() != null) {
		// ActivityUtils.getInstance().finishAll();
		// }
		// System.exit(0);
		// }
	}

	private void processLoginInfoReq(Context context, Intent intent) {
		// String sFromApp = intent.getStringExtra("FromApp");
		// if (Const.APP_NAME.equals(sFromApp)) {
		// return;
		// }
		// //
		// User user = TqLordConfig.getInst().getLastLoginUser();
		// if (user != null) {
		// sendLoginInfoRespBroadcast(context, user, sFromApp);
		// }
		// //
		// System.exit(0);
	}

	private void processLoginInfoResp(Context context, Intent intent) {
		String sFromApp = intent.getStringExtra("FromApp");
		if (!GameConfig.APP_NAME.equals(sFromApp)) {
			System.exit(0);
			return;
		}
		//
		String sNickName = intent.getStringExtra("NickName");
		String sPassword = intent.getStringExtra("Password");
		Pub.LOG("LoginInfoResp 用户名=" + sNickName + "  密码=" + sPassword);
		if (sNickName == null || sNickName.equals("") || sPassword == null || sPassword.equals("")) {
			return;
		}
	}

	private void processUserLogin(Context context, Intent intent) {
		// String sFromApp = intent.getStringExtra("FromApp");
		// int nUserID = intent.getIntExtra("UserID", 0);
		// String sNickName = intent.getStringExtra("NickName");
		// Pub.LOG("sNickName =============== " + sNickName);
		// String sPassword = intent.getStringExtra("Password");
		// Pub.LOG("sPassword =============== " + sPassword);
		// int isPackage = intent.getIntExtra("Package", 0);
		// if (Const.APP_NAME.equals(sFromApp)) {
		// if (isPackage == 1) {
		// if (GameApplication.getCurrentActivity() == null) {
		// Pub.LOG("收到同趣产品安装成功后的缺省用户信息，此时退出。");
		// System.exit(0);
		// }
		// }
		// return;
		// }
		// //
		// User user = new User();
		// user.userid = nUserID;
		// user.nickname = sNickName;
		// user.password = sPassword;
		// Pub.LOG("processUserLogin() FromApp: " + sFromApp);
		// TqLordConfig.getInst().setLastLoginUser(user);
		// //
		// if (GameApplication.getCurrentActivity() == null &&
		// !Const.APP_NAME.equals(sFromApp)) {
		// Pub.LOG("处理完广播，退出应用" + sNickName + ":" + sPassword);
		// System.exit(0);
		// }
	}

	/**
	 * 发送登录信息请求广播
	 *
	 * @param context
	 */
	public static void sendLoginInfoReqBroadcast(Context context) {
		Intent intent = new Intent(BROADCAST_ACTION);
		Bundle bundle = new Bundle();
		bundle.putInt("MsgID", AppCmd.BROAD_REQ_LOGININFO);
		// FromApp text 发起进程名
		bundle.putString("FromApp", GameConfig.APP_NAME);
		intent.putExtras(bundle);
		context.sendBroadcast(intent);
	}

	/**
	 * 发送用户登录信息
	 *
	 * @param context
	 * @param user
	 * @param fromApp
	 */
	public static void sendLoginInfoRespBroadcast(Context context, User user, String fromApp) {
		Pub.LOG("斗地主===================发送广播sendLoginInfoResp");
		Intent intent = new Intent(BROADCAST_ACTION);
		Bundle bundle = new Bundle();
		bundle.putInt("MsgID", AppCmd.BROAD_RESP_LOGININFO);
		bundle.putString("FromApp", fromApp);
		// NickName text 昵称
		bundle.putString("NickName", user.nickname);
		// Password text 密码
		bundle.putString("Password", user.password);
		// bundle.putString("game", Const.APP_NAME);
		intent.putExtras(bundle);
		context.sendBroadcast(intent);
	}

	/**
	 * 发送用户信息变更广播
	 *
	 * @param nUserID
	 * @param sNickName
	 * @param sPassword
	 */
	public static void sendUserInfoBroadcast(Context context, int nUserID, String sNickName, String sPassword, int isPackage) {

		Intent intent = new Intent(BROADCAST_ACTION);
		Bundle bundle = new Bundle();
		bundle.putInt("MsgID", AppCmd.BROAD_USER_INFO);
		// FromApp text 发起进程名
		bundle.putString("FromApp", GameConfig.APP_NAME);
		// UserID int 用户ID
		bundle.putInt("UserID", nUserID);
		// NickName text 昵称
		bundle.putString("NickName", sNickName);
		// Password text 密码
		bundle.putString("Password", sPassword);
		bundle.putInt("Package", isPackage);
		intent.putExtras(bundle);
		context.sendBroadcast(intent);
	}

	/**
	 * 发送退出其他同趣游戏的广播
	 */
	public static void sendQuitTongquGamesBroadcast() {
		Pub.LOG("发送BROAD_QUIT_TONGQU_GAMES");
		Intent intent = new Intent(BROADCAST_ACTION);
		Bundle bundle = new Bundle();
		bundle.putInt("MsgID", AppCmd.BROAD_QUIT_TONGQU_GAMES);
		// FromApp text 发起进程名
		bundle.putString("FromApp", GameConfig.APP_NAME);

		intent.putExtras(bundle);
		TQLuaAndroidConsole.getGameSceneInstance().sendBroadcast(intent);
	}

	/**
	 * 发送启动游戏广播
	 *
	 * @param sDstApp
	 * @param sStartMode
	 * @param bNeedReturnBack
	 */
	public static void sendStartGameBroadcast(String sDstApp, String sStartMode, int nStartParam, boolean bNeedReturnBack) {
		// Pub.LOG("发送BROAD_START_APP (" + sDstApp + ", " + sStartMode + ", " +
		// bNeedReturnBack + ")");
		// Bundle bundle = new Bundle();
		// bundle.putInt("MsgID", AppCmd.BROAD_START_GAME);
		// // FromApp text 发起进程名
		// bundle.putString("FromApp", Const.APP_NAME);
		// // FromApp text 目标进程名
		// bundle.putString("DstApp", sDstApp);
		// // StartMode text 启动类型[HomeActivity, EnterRoom, RegMatch,
		// MatchDetail]
		// bundle.putString("StartMode", sStartMode);
		// // StartParam int 启动参数
		// bundle.putInt("StartParam", nStartParam);
		// //
		// // NeedReturnBack boolean 是否返回原界面
		// bundle.putBoolean("NeedReturnBack", bNeedReturnBack);
		// bundle.putLong("OldSessionID", ActivityBase.SELF_SESSION_ID);
		// bundle.putInt("UserID", ActivityBase.USER_ID);
		// bundle.putByteArray("LoginMsg", ActivityBase.LOGIN_MSG);
		// bundle.putString("IP",
		// Const.getServerIpList().get(SocketMgr.mServerIdx));
		//
		// if (getIsHighVersion(sDstApp)) {
		// Intent intentA = new Intent();
		// intentA.setComponent(new ComponentName("com.tongqu.client." +
		// sDstApp, "com.tongqu.client." + sDstApp + ".StartAppActivity"));
		// intentA.putExtras(bundle);
		// GameApplication.getCurrentActivity().startActivity(intentA);
		// } else {
		// Intent intent = new Intent(BROADCAST_ACTION);
		// intent.putExtras(bundle);
		// GameApplication.getCurrentActivity().sendBroadcast(intent);
		// }
	}

	/**
	 * 获取版本是不是支持直接启Activity
	 *
	 * @return
	 */
	public static boolean getIsHighVersion(String appName) {
		boolean isHighVersion = true;
		String packageName = "com.tongqu.client." + appName;

		if ("platform".equals(appName)) {
			int verCode = getVersionCode(packageName);
			if (verCode < 33751040) {
				isHighVersion = false;
			}
		} else if ("lord".equals(appName)) {
			int verCode = getVersionCode(packageName);
			if (verCode < 33947648) {
				isHighVersion = false;
			}
		} else if ("poker".equals(appName)) {
			int verCode = getVersionCode(packageName);
			if (verCode < 16908288) {
				isHighVersion = false;
			}
		} else if ("mahjong".equals(appName)) {
			int verCode = getVersionCode(packageName);
			if (verCode < 17170432) {
				isHighVersion = false;
			}
		}

		return isHighVersion;

	}

	/**
	 * 得到版本编号
	 *
	 * @return
	 */
	public static int getVersionCode(String packageName) {
		try {
			int nVer = TQLuaAndroidConsole.getGameSceneInstance().getPackageManager().getPackageInfo(packageName, 0).versionCode;
			return nVer;
		} catch (Exception e) {
			Pub.LOG("getVersionCode " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 处理启动应用的广播 [HomeActivity, EnterRoom, RegMatch, MatchDetail]
	 *
	 * @param context
	 * @param i
	 */
	private void processStartGame(Context context, Intent i) {
		// String sDstApp = i.getStringExtra("DstApp");
		// if (!Const.APP_NAME.equals(sDstApp)) {
		// Pub.LOG("收到了与自己无关的启动游戏广播，退出进程");
		// // Pub.LOG("GameApplication.getCurrentActivity()=" +
		// // GameApplication.getCurrentActivity().getClass().getName());
		// if (GameApplication.getCurrentActivity() == null) {
		// System.exit(0);
		// }
		// return;
		// }
		// String sStartMode = i.getStringExtra("StartMode");
		// int nStartParam = i.getIntExtra("StartParam", 0);
		// String sStartParamStr = i.getStringExtra("StartParamStr");
		// String sFromApp = i.getStringExtra("FromApp");
		// boolean bNeedReturnBack = i.getBooleanExtra("NeedReturnBack", false);
		// ActivityBase.OLD_SESSION_ID = i.getLongExtra("OldSessionID", 0);
		// ActivityBase.USER_ID = i.getIntExtra("UserID", 0);
		// ActivityBase.LOGIN_MSG = i.getByteArrayExtra("LoginMsg");
		// String IP = i.getStringExtra("IP");
		//
		// // 准备启动游戏
		// Intent intent = new Intent();
		// intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		// String sDstActivityName = "";
		// if ("HomeActivity".equals(sStartMode)) {
		// // 进入主页
		// sDstActivityName = "NewPatternSelectActivity";
		// } else if ("EnterRoom".equals(sStartMode)) {
		// // 进入房间，RoomID为nStartParam
		// sDstActivityName = "RoomListActivity";
		// } else if ("RegMatch".equals(sStartMode)) {
		// // 报名比赛，MatchID为nStartParam
		// sDstActivityName = "MatchListActivity";
		// } else if ("MatchDetail".equals(sStartMode)) {
		// // 显示比赛详情，MatchID为nStartParam
		// sDstActivityName = "MatchListActivity";
		// }
		//
		// intent.setComponent(new ComponentName("com.tongqu.client." + sDstApp,
		// "com.tongqu.client." + sDstApp + "." + sDstActivityName));
		//
		// // 调用者
		// intent.putExtra("FromApp", sFromApp);
		// // 启动模式
		// intent.putExtra("StartMode", sStartMode);
		// // 启动参数
		// intent.putExtra("StartParam", nStartParam);
		// intent.putExtra("StartParamStr", sStartParamStr);
		// // 是否需要返回到调用者
		// intent.putExtra("NeedReturnBack", bNeedReturnBack);
		// intent.putExtra("OldSessionID", ActivityBase.OLD_SESSION_ID);
		// intent.putExtra("UserID", ActivityBase.USER_ID);
		// intent.putExtra("LoginMsg", ActivityBase.LOGIN_MSG);
		// intent.putExtra("IP", IP);
		//
		// context.startActivity(intent);
		// Pub.LOG("启动进程 " + "com.tongqu.client." + sDstApp + "." +
		// sDstActivityName);

	}

	/**
	 * 发送比赛闹钟广播
	 *
	 * @param nMatchID
	 * @param sMatchInstanceID
	 * @param sMatchTitle
	 * @param nAlarmID
	 */
	public static void sendMatchAlarmBroadcast(Context context, int nMatchID, String sMatchInstanceID, String sMatchTitle, int nAlarmID) {
		// Pub.LOG("发送BROAD_MATCH_ALARM");
		// Intent intent = new Intent(BROADCAST_ACTION);
		// Bundle bundle = new Bundle();
		// bundle.putInt("MsgID", AppCmd.BROAD_MATCH_ALARM);
		// // FromApp text 发起进程名
		// bundle.putString("FromApp", Const.APP_NAME);
		// // FromGameID int 发起游戏ID
		// bundle.putInt("FromGameID", Const.GAME_ID);
		// // MatchID int 比赛ID
		// bundle.putInt("MatchID", nMatchID);
		// // MatchInstanceID text 比赛实例ID
		// bundle.putString("MatchInstanceID", sMatchInstanceID);
		// // MatchTitle text 比赛标题
		// bundle.putString("MatchTitle", sMatchTitle);
		// // AlarmID int 闹钟ID
		// bundle.putInt("AlarmID", nAlarmID);
		//
		// intent.putExtras(bundle);
		// context.sendBroadcast(intent);
	}

	/**
	 * 处理比赛闹钟广播
	 *
	 * @param context
	 * @param intent
	 */
	private void processMatchAlarm(Context context, Intent intent) {
		// if (GameApplication.getCurrentActivity() == null) {
		// Pub.LOG("收到闹钟广播本应用不在运行，退出应用");
		// System.exit(0);
		// return;
		// }
		// // FromApp text 发起进程名
		// String sFromApp = intent.getStringExtra("FromApp");
		// // FromGameID int 发起GameID
		// int nFromGameID = intent.getIntExtra("FromGameID", 0);
		// // MatchID int 比赛ID
		// int nMatchID = intent.getIntExtra("MatchID", 0);
		// // MatchInstanceID text 比赛实例ID
		// String sMatchInstanceID = intent.getStringExtra("MatchInstanceID");
		// // MatchTitle text 比赛标题
		// String sMatchTitle = intent.getStringExtra("MatchTitle");
		// // AlarmID int 闹钟ID
		// int nAlarmID = intent.getIntExtra("AlarmID", 0);
		// //
		// if (nAlarmID == 2) {
		// Toast.makeText(context, "您报名的“" + sMatchTitle + "”将在20秒后开始。",
		// Toast.LENGTH_LONG).show();
		// }
	}

	public static final int DELAY = 1;
	public Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case DELAY:
				Pub.LOG("deleteSMS mHandler");
				if (mContent.size() > 0) {
					deleteSMS();
					mHandler.sendEmptyMessageDelayed(DELAY, 3000);
				}
				break;
			}
		}
	};

	private static final String BROADCAST_ACTION = "com.tongqu.intent.action.BROADCAST";

	public void deleteSMS() {
		Pub.LOG("deleteSMS 1");
		try {

			String[] projection = new String[] { "_id", "address", "person", "body", "date", "type" };
			// 准备系统短信收信箱的uri地址
			Uri uri = Uri.parse("content://sms/inbox");// 收信箱
			// 查询收信箱里所有的短信
			Cursor isRead = mContext.getContentResolver().query(uri, projection, null, null, null);
			while (isRead.moveToNext()) {
				Pub.LOG("deleteSMS 2");
				// String phone =
				// isRead.getString(isRead.getColumnIndex("address")).trim();//获取发信人
				String body = isRead.getString(isRead.getColumnIndex("body")).trim();// 获取信息内容
				for (int i = 0; i < SMSPursePayment.SMS_MATCHES.length; i++) {
					Pattern p = Pattern.compile(SMSPursePayment.SMS_MATCHES[i]);
					Matcher m = p.matcher(body);
					Pub.LOG("deleteSMS body " + body);
					if (m.matches()) {
						int id = isRead.getInt(isRead.getColumnIndex("_id"));
						Pub.LOG("deleteSMS id " + id);
						mContext.getContentResolver().delete(Uri.parse("content://sms"), "_id=?", new String[] { "" + id });
						Pub.LOG("deleteSMS end " + id);
						if (mContent.size() > 0) {
							mContent.remove(0);
						}
					}
				}
				// while (mContent.size() > 0) {
				// String smscontent = mContent.get(0);
				// if (body.equals(smscontent)) {
				// Pub.LOG("deleteSMS 3");
				// int id = isRead.getInt(isRead.getColumnIndex("_id"));
				// Pub.LOG("deleteSMS id " + id);
				// mContext.getContentResolver().delete(Uri.parse("content://sms"),
				// "_id=?", new String[] { "" + id });
				// Pub.LOG("deleteSMS end " + id);
				// mContent.remove(0);
				// }
				// }
			}
		} catch (Exception e) {
			Pub.LOG("deleteSMS 4");
			e.printStackTrace();
			if (mContent.size() > 0) {
				mContent.remove(0);
			}
		}
	}

}
