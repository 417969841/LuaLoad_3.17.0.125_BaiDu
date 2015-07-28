package com.pay.alipay;

import java.net.URLEncoder;
import java.util.HashMap;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.pm.PackageInfo;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Toast;

import com.tongqu.client.entity.ProductDetail;
import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.lord.R;
import com.tongqu.client.utils.DownloadFollowUp;
import com.tongqu.client.utils.Downloader;
import com.tongqu.client.utils.Pub;

public class AliPayment {

	public static AliPayment mAliPayment;

	public static AliPayment getInstance() {
		if (mAliPayment == null) {
			mAliPayment = new AliPayment();
		}
		return mAliPayment;
	}

	private ProgressDialog mProgress = null;

	public int mnCallLuaFunction;

	private ProductDetail mProduct = null;

	/**
	 * lua调用获取支付宝订单信息
	 *
	 * @param goodsName
	 * @param goodsDetail
	 * @param goodsPriceDetail
	 * @param mnDiscount
	 * @param mnSubtype
	 * @param price
	 * @param isExchange
	 * @param goodsID
	 */
	public void luaCallAliPayGetOrderID(String goodsName, String goodsDetail, String goodsPriceDetail, int mnDiscount, int mnSubtype, int price, int callLuaFunction) {
		ProductDetail product = new ProductDetail();
		product.goodsName = goodsName;
		product.goodsDetail = goodsDetail;
		product.goodsPriceDetail = goodsPriceDetail;
		product.mnDiscount = mnDiscount;
		product.mnSubtype = mnSubtype;
		product.price = price;
		mnCallLuaFunction = callLuaFunction;
		mProduct = product;
		getAliPayOrderInfo();
	}

	/**
	 * 是否支持支付
	 *
	 * @return
	 */
	public boolean isPaySupported() {
		// check to see if the MobileSecurePay is already installed.
		// 检测安全支付服务是否安装
		PackageInfo pkg = Pub.getPkgInfoByName("com.alipay.android.app");
		PackageInfo pkgGphone = Pub.getPkgInfoByName("com.eg.android.AlipayGphone");
		if (pkg == null && pkgGphone == null) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * ailipay支付
	 *
	 */
	public void getAliPayOrderInfo() {
		if (isPaySupported()) {
			// prepare the order info.
			TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
				@Override
				public void run() {
					Cocos2dxLuaJavaBridge.callLuaFunctionWithString(mnCallLuaFunction, "");
					Cocos2dxLuaJavaBridge.releaseLuaFunction(mnCallLuaFunction);
				}
			});
		} else {
			Pub.closeProgressDialog();
			Downloader.getInst().getDownloadFile(PartnerConfig.ALIPAY_PLUGIN_NAME_URL, "download", DownloadFollowUp.getInst().mDownloadActionHandler, DownloadFollowUp.DOWNLOAD_ACTION_A, false, true);
		}
	}

	/**
	 * get the selected order info for pay. 获取商品订单信息 trade_status 用于判断交易状态，值有：
	 * TRADE_FINISHED：表示交易成功完成 WAIT_BUYER_PAY：表示等待付款
	 * TRADE_SUCCESS：表示交易成功（高级即时到帐） 表示交易成功（高级即时到帐） total_fee 交易金额 subject 商品名称
	 * out_trade_no 外部交易号（商户交易号） trade_no 支付宝交易号 gmt_create 交易创建时间 gmt_payment
	 * 交易付款时间若交易状态是“WAIT_BUYER_PAY”则无此参数
	 *
	 *
	 * @param position
	 *            商品在列表中的位置
	 * @return
	 */
	String getOrderInfo(ProductDetail product, String orderID) {
		Pub.LOG("orderID ======== " + orderID);
		String
		// 合作商户ID
		strOrderInfo = "partner=" + "\"" + mAliPayMap.get("PARTNER") + "\"";
		strOrderInfo += "&";
		// 商户收款的支付宝账号
		strOrderInfo += "seller_id=" + "\"" + mAliPayMap.get("SELLER") + "\"";

		strOrderInfo += "&";
		// 获取外部订单号
		strOrderInfo += "out_trade_no=" + "\"" + orderID + "\"";
		strOrderInfo += "&";
		// 商品名称
		strOrderInfo += "subject=" + "\"" + product.goodsName + "\"";
		strOrderInfo += "&";
		// 商品的具体描述
		strOrderInfo += "body=" + "\"" + product.goodsDetail + "\"";
		strOrderInfo += "&";
		// 本次支付的总费
		strOrderInfo += "total_fee=" + "\"" + product.goodsPriceDetail.replace("价格:￥", "") + "\"";
		strOrderInfo += "&";
		// 商家提供的url
		strOrderInfo += "notify_url=" + "\"" + mAliPayMap.get("SERVER_URL") + "\"";
		strOrderInfo += "&";
		// service not null 固定值mobile.securitypay.pay
		strOrderInfo += "service=" + "\"" + mAliPayMap.get("SERVICE") + "\"";
		strOrderInfo += "&";
		// payment_type not null 支付类型 默认值为1（商品购买）
		strOrderInfo += "payment_type=" + "\"" + mAliPayMap.get("PAYMENT_TYPE") + "\"";
		strOrderInfo += "&";
		// _input_charset not null 商户网站使用的编码格式，默认为UTF-8
		strOrderInfo += "_input_charset=" + "\"" + mAliPayMap.get("INPUT_CHARSET") + "\"";

		return strOrderInfo;
	}

	/**
	 * sign the order info. 对订单信息进行签名
	 *
	 * @param signType
	 *            签名方式
	 * @param content
	 *            待签名订单信息
	 * @return
	 */
	String sign(String signType, String content) {
		return Rsa.sign(content, mAliPayMap.get("RSA_PRIVATE"));
	}

	/**
	 * get the sign type we use. 获取签名方式
	 *
	 * @return
	 */
	String getSignType() {
		String getSignType = "sign_type=" + "\"" + "RSA" + "\"";
		return getSignType;
	}

	/**
	 * get the char set we use. 获取字符集
	 *
	 * @return
	 */
	String getCharset() {
		String charset = "charset=" + "\"" + "utf-8" + "\"";
		return charset;
	}

	public int mnCallBackLua;

	public HashMap<String, String> mAliPayMap;

	public void readDBID_EXCHANGE_AliPay(String orderID, HashMap<String, String> aliPayMap, int callBackLua) {
		mAliPayMap = aliPayMap;
		mnCallBackLua = callBackLua;
		// 给服务器发送订单信息
		String orderInfo = getOrderInfo(mProduct, orderID);
		// prepare the order info.
		// 准备订单信息
		startAliPay(orderInfo);
		mProduct = null;
	}

	/**
	 * 调用alipay的支付插件
	 */
	private void startAliPay(String orderInfo) {
		// check some info.
		// 检测配置信息
		if (!checkInfo()) {
			BaseHelper.showDialog(TQLuaAndroidConsole.getGameSceneInstance(), "提示", "缺少partner或者seller，请在PartnerConfig.java中增加。", R.drawable.infoicon);
			return;
		}

		// start pay for this order.
		// 根据订单信息开始进行支付
		try {
			// 这里根据签名方式对订单信息进行签名
			String signType = getSignType();
			String strsign = sign(signType, orderInfo);
			// 对签名进行编码
			strsign = URLEncoder.encode(strsign);
			// 组装好参数
			String info = orderInfo + "&sign=" + "\"" + strsign + "\"" + "&" + getSignType();
			// start the pay.
			// 调用pay方法进行支付
			MobileSecurePayer msp = new MobileSecurePayer();
			boolean bRet = msp.pay(info, mHandler, AlixId.RQF_PAY, TQLuaAndroidConsole.getGameSceneInstance());

			if (bRet) {
				// show the progress bar to indicate that we have started
				// paying.
				// 显示“正在支付”进度条
				closeProgress();
				mProgress = BaseHelper.showProgress(TQLuaAndroidConsole.getGameSceneInstance(), null, "正在支付", false, true);
			}
		} catch (Exception ex) {
			Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), R.string.remote_call_failed, Toast.LENGTH_LONG).show();
		}
	}

	public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
		return false;
	}

	/**
	 * check some info.the partner,seller etc. 检测配置信息
	 * partnerid商户id，seller收款帐号不能为空
	 *
	 * @return
	 */
	private boolean checkInfo() {
		String partner = mAliPayMap.get("PARTNER");
		String seller = mAliPayMap.get("SELLER");
		if (partner == null || partner.length() <= 0 || seller == null || seller.length() <= 0)
			return false;

		return true;
	}

	//
	// the handler use to receive the pay result.
	// 这里接收支付结果，支付宝手机端同步通知
	private Handler mHandler = new Handler() {
		public void handleMessage(Message msg) {
			try {
				String strRet = (String) msg.obj;

				// 测试中打印同步通知log，上线建议注释掉，或者自行设置开关
				// Pub.LOGAliPay(strRet);

				switch (msg.what) {
				case AlixId.RQF_PAY: {
					//
					closeProgress();

					// Pub.LOGAliPay(strRet);

					// 此处将提示给开发人员具体的交易状态码，
					// 由于安全支付服务付款成功以后会有提示展示给用户，所以建议在上线版本中不进行额外提示
					// 以免造成用户提示的混乱。
					// 从通知中获取参数
					try {
						// 获取交易状态，具体状态代码请参看文档
						String tradeStatus = "resultStatus=";
						int imemoStart = strRet.indexOf("resultStatus=");
						imemoStart += tradeStatus.length();
						int imemoEnd = strRet.indexOf(";memo=");
						tradeStatus = strRet.substring(imemoStart, imemoEnd);

						// 对通知进行验签
						ResultChecker resultChecker = new ResultChecker(strRet);

						int retVal = resultChecker.checkSign();
						// 返回验签结果以及交易状态
						// 验签失败
						if (retVal == ResultChecker.RESULT_CHECK_SIGN_FAILED) {
							// BaseHelper.showDialog(TQLuaAndroidConsole.getGameSceneInstance(),
							// "提示",
							// TQLuaAndroidConsole.getGameSceneInstance().getResources().getString(R.string.check_sign_failed),
							// android.R.drawable.ic_dialog_alert);
						} else {
							String trade = null;
							for (int i = 0; i < maTradeStatus.length; i++) {
								if (tradeStatus.contains(maTradeStatus[i][0])) {
									trade = maTradeStatus[i][1];
									break;
								}
							}
							if (tradeStatus.contains("9000")) {
								TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
									@Override
									public void run() {
										Cocos2dxLuaJavaBridge.callLuaFunctionWithString(mnCallBackLua, "");
										Cocos2dxLuaJavaBridge.releaseLuaFunction(mnCallBackLua);
									}
								});
							} else {
								if (trade != null) {
									BaseHelper.showDialog(TQLuaAndroidConsole.getGameSceneInstance(), "提示", trade, R.drawable.infoicon);
								}
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
						BaseHelper.showDialog(TQLuaAndroidConsole.getGameSceneInstance(), "提示", strRet, R.drawable.infoicon);
					}
				}
					break;
				}

				super.handleMessage(msg);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	};

	String maTradeStatus[][] = { { "9000", "充值成功,购买的物品会在5分钟内到账" }, { "4000", "订单支付失败" }, { "4001", "数据格式不正确" }, { "4003", "该用户绑定的支付宝账被冻结或不允许支付" }, { "4004", "该用户已解除绑定" }, { "4005", "绑定失败或没有绑定" }, { "4006", "订单支付失败" }, { "4010", "重新绑定账户" }, { "6000", "支付服务正在进行升级操作" }, { "6001", "用户中途取消支付操作" }, { "6002", "网络连接异常" } };

	/**
	 * the OnCancelListener for lephone platform. lephone系统使用到的取消dialog监听
	 */
	static class AlixOnCancelListener implements DialogInterface.OnCancelListener {
		Activity mcontext;

		AlixOnCancelListener(Activity context) {
			mcontext = context;
		}

		public void onCancel(DialogInterface dialog) {
			mcontext.onKeyDown(KeyEvent.KEYCODE_BACK, null);
		}
	}

	/**
	 * 关闭进度框
	 */
	public void closeProgress() {
		try {
			if (mProgress != null) {
				mProgress.dismiss();
				mProgress = null;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
