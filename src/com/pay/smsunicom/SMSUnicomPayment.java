package com.pay.smsunicom;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.widget.Toast;

import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.utils.Pub;
import com.unicom.dcLoader.Utils;
import com.unicom.dcLoader.Utils.UnipayPayResultListener;
import com.unicom.dcLoader.Utils.VacMode;


public class SMSUnicomPayment {

	public static SMSUnicomPayment mSMSUnicomPayment;

	public static SMSUnicomPayment getInstance() {
		if (mSMSUnicomPayment == null) {
			mSMSUnicomPayment = new SMSUnicomPayment();
		}
		return mSMSUnicomPayment;
	}

	public static final String company = "北京同趣同趣科技有限公司";
	public static final String gamename = "疯狂斗地主(赢奖)";
	public static final String cpCode = "9025957255";
	public static final String cpid = "86005299";
	public static final String appid = "902595725520130301155352743500";
	public String daoju;// 名称
	public String money;// 价格
	public int price_unicom;// 价格
	public String consumeCode_unicom;// 代码
	public String orderID;// 订单号
	public int isExchange;// 是否兑换金币
	public int mnSMSPayGiftID;// 礼包ID
	public int mnSubtype;// 支付渠道子类型

	public SMSUnicomPayment() {
		// Context mContext, String appid, String cpCode, String cpid, String
		// company, String phone, String game, UnipayPayResultListener mCallBack
		// @params mContext Context对象
		// @params appid 应用编号
		// @params cpCode 开发商编号
		// @params cpId 开发商VAC资质编号
		// @param company 开发者公司名字
		// @param phone 开发者客服电话号码
		// @param game 应用名称
		// @params mCallBack 初始化函数回调结果
		if (Pub.getOperater() == Pub.CHINA_UNICOM) {
			Utils.getInstances().init(TQLuaAndroidConsole.getGameSceneInstance(), appid, cpCode, cpid, company, Pub.getServerPhone(), gamename, new PayResultListener());
		}
	}

	/**
	 * 设置联通支付数据
	 *
	 * @param name
	 * @param price
	 * @param payCode
	 */
	public void setSMSUnicomData(String name, int price, String payCode) {
		daoju = name;
		money = "" + (float) price / (float) 100;
		consumeCode_unicom = payCode;
	}

	public static int mnCallBackLua;

	/**
	 * 接收联通订单回调
	 */
	public void readDBID_EXCHANGE_SMSUnicom(String OrderID, int callBackLua) {
		if (OrderID == null || (OrderID != null && OrderID.equals(""))) {
			Pub.LOG("msg ===================== 数据出错");
			consumeCode_unicom = null;
			return;
		}
		if (consumeCode_unicom != null) {
			orderID = OrderID;
			mnCallBackLua = callBackLua;
			if (daoju != null && money != null) {
				// @params mContext Context对象
				// @params vac 是否使用VAC话费支付
				// @params otherpay 是否使用第三方
				// @params url
				// 第三方支付结果推送地址（话费支付结果接收地址在开发者社区配置，地址可以相同，但是客户端和开发者社区都必须配置）

				// Context mContext, boolean vac,Boolean otherpay,
				// String url
				Utils.getInstances().setBaseInfo(TQLuaAndroidConsole.getGameSceneInstance(), true, false, "http://58.68.246.34/tqAdmin/W3gSmsRechargeAction.do");

				// @params vacCode VAC话费计费代码
				// @params customCode 第三方支付计费代码
				// @params props 道具名
				// @params money 金额（单位：元）
				// @params orderid 订单号（24位字母+数字），不足24位要补全
				// @param uid 应用内的使用计费的用户ID（唯一标识）
				// @param vac_mode VAC支付方式（单次：single，包月：sub，退订：unsub）
				// @param mCallBack 支付接口回调接口

				// Context mContext, String vacCode,String customCode,
				// String props, String money,String orderid, String
				// uid, VacMode vac_mode, UnipayPayResultListener
				// mCallBack
				Utils.getInstances().pay(TQLuaAndroidConsole.getGameSceneInstance(), consumeCode_unicom, "", daoju, money, orderID, "uid", VacMode.single, new PayResultListener());
			}
			consumeCode_unicom = null;
		}
	}

	// 回调结果
	public static final int SUCCESS = 1; // 成功
	public static final int FAILED = 2; // 失败 回调参数为空
	public static final int CANCEL = 3; // 取消

	// 回调类型
	public static final int SUBCOMMIT_VAC = 20; // VAC支付提交（适用于联网支付）
	public static final int SUCCESS_SMS = 21; // 短代支付成功（适用于单机短代支付）
	public static final int SUBCOMMIT_WEBALIPAY = 22; // WEB支付宝提交
	public static final int SUCCESS_KALIPAY = 23; // 支付宝快捷支付成功
	public static final int SUBCOMMIT_SZF = 24; // 神州付提交
	public static final int CANCEL_FIRSTPAGE = 26; // 第一次确认支付取消
	public static final int CANCEL_VACPAYPAGE = 27; // VAC支付页面取消
	public static final int CANCEL_OTHERPAYPAGE = 28; // 其他支付页面取消
	public static final int CANCEL_CHANGECODE = 29; // 兑换码页面取消
	public static final int CANCEL_VACYZM = 30; // 话费验证码页面取消

	public class PayResultListener implements UnipayPayResultListener {
		/**
		 * flag为支付回调结果，flag2为回调类型，error为当前结果描述
		 */
		public void PayResult(String paycode, int flag, int flag2, String error) {

			Pub.LOG("flag=" + flag + ";code=" + paycode + ";error=" + error);

			switch (flag) {
			case Utils.SUCCESS:
				// 此处放置支付请求已提交的相关处理代码
				TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
					@Override
					public void run() {
						Cocos2dxLuaJavaBridge.callLuaFunctionWithString(mnCallBackLua, "SUCCESS");
						Cocos2dxLuaJavaBridge.releaseLuaFunction(mnCallBackLua);
					}
				});

				daoju = null;
				money = null;
				consumeCode_unicom = null;
				orderID = null;
				mnSMSPayGiftID = 0;
				price_unicom = 0;
				break;
			case Utils.FAILED:
				// 此处放置支付请求失败的相关处理代码
				Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), error, Toast.LENGTH_LONG).show();
				break;
			case Utils.CANCEL:
				// 此处放置支付请求被取消的相关处理代码
				Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), error, Toast.LENGTH_LONG).show();
				break;
			default:
				break;
			}
		}
	}
}
