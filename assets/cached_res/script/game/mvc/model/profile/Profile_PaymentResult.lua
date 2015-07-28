module(..., package.seeall)

local PayResultTable = {}
--local PaySmsRechargeTable = {}
local cachePaymentTableList = {} --要购买的商品信息

local PayGuideDataTable = {}--充值引导信息

--[[--
--设置要购买的商品信息
--]]
function setPaymentTable(data)
	cachePaymentTableList["".. data.SerialNumber] = data
end

--[[--
--设置充值引导信息
--]]
function setGuideData(GuideType, needCurrencyNum, position)
	PayGuideDataTable = {}
	PayGuideDataTable.GuideType = GuideType
	PayGuideDataTable.needCurrencyNum = needCurrencyNum
	PayGuideDataTable.position = position
end

function readMANAGERID_V3_RECHARGE(dataTable)
	Common.closeProgressDialog()
	PayResultTable = {}
	-- result byte 兑换结果 0失败 1成功
	PayResultTable.result = dataTable["result"];
	-- msg text 信息/
	PayResultTable.payMsg = dataTable["payMsg"];
	-- OrderId订单号/银联签名
	PayResultTable.OrderId = dataTable["OrderId"];
	-- 支付渠道 0：支付宝微信双按钮
	PayResultTable.payChannel = dataTable["payChannel"];
	--KvLoop loop KeyValue循环 用于微信支付或其他扩展信息
	PayResultTable.KvLoop = {};
	PayResultTable.KvLoop = dataTable["KvLoop"];
	--SmsData loop 多条短信指令和目标号码循环
	PayResultTable.smsList = {};
	PayResultTable.smsList = dataTable["smsList"];
	--SmsHint text 短信发出后的弹框提示
	PayResultTable.SmsHint = dataTable["SmsHint"];
	--SerialNumber long 流水号
	PayResultTable.SerialNumber = dataTable["SerialNumber"];
	--Position Int 位置编码 默认为0
	PayResultTable.Position = dataTable["Position"];

	--获取支付信息
	local PaymentTable = cachePaymentTableList[""..PayResultTable.SerialNumber];

	if PaymentTable == nil then
		Common.showToast("支付订单信息错误", 2);
		return
	end

	if (PayResultTable["result"] == 0) then
		if PayResultTable.payChannel == 0 and PayResultTable.Position ~= 0 and PayGuideDataTable ~= nil then
			local tempTable = Common.copyTab(PayGuideDataTable);
			PayGuideDataTable = nil
			CommDialogConfig.showPayGuide(tempTable.GuideType, tempTable.needCurrencyNum, tempTable.position, 0, PayResultTable["payMsg"])
		else
			--支付失败
			Common.showDialog(PayResultTable["payMsg"]);
		end
	else
		--支付成功

		if PayResultTable.SmsHint ~= nil and PayResultTable.SmsHint~= "" then
			CommDialogConfig.showRechargePrompt(PayResultTable.SmsHint)
		end

		if PayResultTable["payChannel"] ==  profile.PayChannelData.RECHARGE_CARD_PAY then
		-- 充值卡子协议
		elseif PayResultTable["payChannel"]  ==  profile.PayChannelData.ALI_PAY then
			-- 支付宝子协议
			Common.setDataForSqlite(CommSqliteConfig.RECENT_RECHARGE_MEHTOD, "alipay");
			if Common.platform == Common.TargetIos then
				--ios平台
				function callAliPayGetOrderInfo(ret)
					local args = {
						orderID = PayResultTable["OrderId"],
						PartnerID = PayResultTable["KvLoop"].PARTNER,
						SellerID = PayResultTable["KvLoop"].SELLER,
						PartnerPrivKey = PayResultTable["KvLoop"].RSA_PRIVATE,
						AlipayPubKey = PayResultTable["KvLoop"].RSA_ALIPAY_PUBLIC,
						ServerUrl = PayResultTable["KvLoop"].SERVER_URL,
					}
					local ok, ret = luaoc.callStaticMethod("Helper", "alipayPayResult", args);
				end

				local useridV =  profile.User.getSelfUserID();
				local args = {
					pName = PaymentTable.goodsName,
					pDetail = PaymentTable.goodsDetail,
					pPrice = PaymentTable.price,
					userID = useridV,
					callback = callAliPayGetOrderInfo,
				}

				local ok, ret = luaoc.callStaticMethod("Helper", "alipayPaymentInfo", args);
			elseif Common.platform == Common.TargetAndroid then

				function callAliPayGetOrderInfo(parameters)
					local javaClassName = "com.pay.PaymentConfig"
					local javaMethodName = "luaCallAliPayResult"
					local javaParams = {
						PayResultTable["OrderId"],
						PayResultTable["KvLoop"].PARTNER,
						PayResultTable["KvLoop"].SELLER,
						PayResultTable["KvLoop"].RSA_PRIVATE,
						PayResultTable["KvLoop"].RSA_ALIPAY_PUBLIC,
						PayResultTable["KvLoop"].SERVER_URL,
						PayResultTable["KvLoop"].SERVICE,
						PayResultTable["KvLoop"].PAYMENT_TYPE,
						PayResultTable["KvLoop"].INPUT_CHARSET,
						CommDialogConfig.showRechargePrompt,
					}
					luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
				end

				local javaClassName = "com.pay.PaymentConfig"
				local javaMethodName = "luaCallAliPayGetOrderInfo"
				local javaParams = {
					PaymentTable.goodsName,
					PaymentTable.goodsDetail,
					PaymentTable.goodsPriceDetail,
					PaymentTable.mnDiscount,
					PaymentTable.mnSubtype,
					PaymentTable.price,
					callAliPayGetOrderInfo,
				}
				luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			end
		elseif PayResultTable["payChannel"] == profile.PayChannelData.WEIXIN_PAY then
			-- 微信子协议
			Common.setDataForSqlite(CommSqliteConfig.RECENT_RECHARGE_MEHTOD, "weixin");
			if Common.platform == Common.TargetIos then
				--ios平台
				local args = {
					appid = PayResultTable["KvLoop"].appid,
					partnerid = PayResultTable["KvLoop"].partnerid,
					prepayid = PayResultTable["KvLoop"].prepayid,
					noncestr = PayResultTable["KvLoop"].noncestr,
					timestamp = PayResultTable["KvLoop"].timestamp,
					package = PayResultTable["KvLoop"].package,
					sign = PayResultTable["KvLoop"].sign,
				}
				local ok, ret = luaoc.callStaticMethod("Helper", "weixinPayResult", args);
			elseif Common.platform == Common.TargetAndroid then
				--Android平台
				local javaClassName = "com.pay.PaymentConfig"
				local javaMethodName = "luaCallWeiXinPayResult"
				local javaParams = {
					PayResultTable["KvLoop"].appid,
					PayResultTable["KvLoop"].partnerid,
					PayResultTable["KvLoop"].prepayid,
					PayResultTable["KvLoop"].noncestr,
					PayResultTable["KvLoop"].timestamp,
					PayResultTable["KvLoop"].package,
					PayResultTable["KvLoop"].sign,
					CommDialogConfig.showRechargePrompt,
				}
				luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			end

		elseif PayResultTable["payChannel"]  ==  profile.PayChannelData.UNION_PAY then
			-- 银联子协议
			local javaClassName = "com.pay.PaymentConfig"
			local javaMethodName = "luaCallUnionPayResult"
			local javaParams = {
				PayResultTable["OrderId"],
			}
			luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")

		elseif PayResultTable["payChannel"]  ==  profile.PayChannelData.SMS_UNICOM then
			-- 联通沃商店子协议
			if Common.platform == Common.TargetIos then
			--ios平台
			--				local args = {
			--					orderID = PayResultTable["OrderId"],
			--					callback = CommDialogConfig.showRechargePrompt,
			--				};
			--				luaoc.callStaticMethod("Helper", "UnicomPayResult", args);
			elseif Common.platform == Common.TargetAndroid then
				--android平台

				PaymentTable.payCode = PayResultTable["KvLoop"].PayCode

				local javaClassName = "com.pay.PaymentConfig"
				local javaMethodName = "luaCallSetSMSUnicomData"
				local javaParams = {
					PaymentTable.goodsName,
					PaymentTable.price,
					PaymentTable.payCode,
				}
				luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")

				local javaClassName = "com.pay.PaymentConfig"
				local javaMethodName = "luaCallSMSUnicomPayResult"
				local javaParams = {
					PayResultTable["OrderId"],
					CommDialogConfig.showRechargePrompt,
				}
				luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			end

		elseif PayResultTable["payChannel"]  ==  profile.PayChannelData.MM_PAY_V2 then
			-- MM带回调
			local javaClassName = "com.pay.PaymentConfig"
			local javaMethodName = "luaCallMMPayResult"
			local javaParams = {
				PayResultTable["OrderId"],
				CommDialogConfig.showRechargePrompt,
			}
			luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			--		elseif PayResultTable["payChannel"]  ==  profile.PayChannelData.CTESTORE_PAY then
			--			-- 天翼空间
			--			local javaClassName = "com.pay.PaymentConfig"
			--			local javaMethodName = "luaCallCestorePayResult"
			--			local javaParams = {
			--				PayResultTable["OrderId"],
			--			}
			--			luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
		elseif PayResultTable["payChannel"]  ==  profile.PayChannelData.RECHARGE_WOJIA then
			-- 同趣联通wo+
			local payCode = PaymentTable.payCode
			local price = PaymentTable.price / 100
			local OrderId = PayResultTable.OrderId
			local javaClassName = "com.pay.PaymentConfig"
			local javaMethodName = "luaCallWoJiaPayResult"
			local javaParams = {
				payCode.."",
				price.."",
				OrderId.."",
			}
			luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")

		elseif PayResultTable["payChannel"] == profile.PayChannelData.NEW_UNION_PAY then
			Common.setDataForSqlite(CommSqliteConfig.RECENT_RECHARGE_MEHTOD, "union");
			-- 新银联
			local javaClassName = "com.pay.PaymentConfig"
			local javaMethodName = "luaCallNewUnionPayResult"
			local javaParams = {
				PayResultTable["OrderId"],
			}
			luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
		elseif PayResultTable["payChannel"]  ==  profile.PayChannelData.RECHARGE_91 then
			-- 91
			--调用ios支付

			local args = {
				orderID = PayResultTable["OrderId"],
			}
			local ok, ret = luaoc.callStaticMethod("Helper", "baiduzhifu", args)
		elseif PayResultTable["payChannel"]  ==  profile.PayChannelData.HAIMA_PAY then
			-- 海马
			--调用ios支付

			local args = {
				orderID = PayResultTable["OrderId"],
			}
			local ok, ret = luaoc.callStaticMethod("Helper", "HaiMaPayResult", args)
		elseif PayResultTable["payChannel"]  ==  profile.PayChannelData.IAP_PAY then
			-- IAP支付
			local userid =  profile.User.getSelfUserID()
			--iap
			function callIAPPayCheckInfo(parameters)
				sendMANAGERID_VALIDATE_IAP(parameters["receipt"],parameters["goodid"],userid)
			end
			--调用ios支付
			local args = {
				callback = callIAPPayCheckInfo,
				goodID = PayResultTable["OrderId"],
			}
			local ok,ret  = luaoc.callStaticMethod("Helper", "iapzhifu", args)
			--		elseif PayResultTable["payChannel"] == profile.PayChannelData.CM_PAY then
			--			-- 手机钱包
			--			local javaClassName = "com.pay.PaymentConfig"
			--			local javaMethodName = "luaCallPursePayResult"
			--			local javaParams = {
			--				PayResultTable["OrderId"],
			--			}
			--			luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
		elseif PayResultTable["payChannel"] == profile.PayChannelData.HUAJIAN_DIANXIN_PAY then
			--电信短代支付
			HuaJianTelecomPay()
		elseif PayResultTable["payChannel"] == profile.PayChannelData.SMS_ONLINE then
			--移动短代支付
			SmsOnlinePay()
		elseif PayResultTable["payChannel"] == profile.PayChannelData.HUAJIAN_LIANTONG_PAY then
			--联通短代支付
			HuaJianUnicomPay()
		elseif PayResultTable["payChannel"] == profile.PayChannelData.EPAY then
			-- 宜支付
			if Common.platform == Common.TargetIos then
			elseif Common.platform == Common.TargetAndroid then
				--android平台
				local javaClassName = "com.pay.PaymentConfig"
				local javaMethodName = "luaCallEPayResult"
				local javaParams = {
					PayResultTable["KvLoop"].partnerId,
					PayResultTable["KvLoop"].key,
					PayResultTable["KvLoop"].appFeeId,
					""..PaymentTable.price,
					PayResultTable["OrderId"],
					PayResultTable["KvLoop"].appId,
					PayResultTable["KvLoop"].qn,
					PaymentTable.goodsName,
				}
				luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			end
		elseif PayResultTable["payChannel"] == profile.PayChannelData.YINBEIKEPAY_CMCC then
			-- 银贝壳移动
			if Common.platform == Common.TargetIos then
			elseif Common.platform == Common.TargetAndroid then
				--android平台
				local javaClassName = "com.pay.PaymentConfig"
				local javaMethodName = "luaCallYINBEIKEPayResult"
				local javaParams = {
					PaymentTable.goodsName,
					PaymentTable.payCode.."",
					""..PaymentTable.price,
					PayResultTable["OrderId"].."",
				}
				luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			end
		elseif PayResultTable["payChannel"] == profile.PayChannelData.HONGRUAN_SDK_CMCC then
			-- 红软移动
			if Common.platform == Common.TargetIos then
			elseif Common.platform == Common.TargetAndroid then
				--android平台
				local javaClassName = "com.pay.PaymentConfig"
				local javaMethodName = "luaCallHongRPayResult"
				local javaParams = {
					PaymentTable.goodsName,
					PaymentTable.payCode.."",
					""..PaymentTable.price,
					PayResultTable["OrderId"].."",
				}
				luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			end
		elseif PayResultTable["payChannel"] == profile.PayChannelData.YINBEIKEPAY_UNI then
			-- 银贝壳联通
			if Common.platform == Common.TargetIos then
			elseif Common.platform == Common.TargetAndroid then
				--android平台
				local javaClassName = "com.pay.PaymentConfig"
				local javaMethodName = "luaCallYINBEIKEPayResult"
				local javaParams = {
					PaymentTable.goodsName,
					PaymentTable.payCode.."",
					""..PaymentTable.price,
					PayResultTable["OrderId"].."",
				}
				luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			end
		elseif PayResultTable["payChannel"] == profile.PayChannelData.HONGRUAN_SDK_UNICOM then
			-- 红软联通
			if Common.platform == Common.TargetIos then
			elseif Common.platform == Common.TargetAndroid then
				--android平台
				local javaClassName = "com.pay.PaymentConfig"
				local javaMethodName = "luaCallHongRPayResult"
				local javaParams = {
					PaymentTable.goodsName,
					PaymentTable.payCode.."",
					""..PaymentTable.price,
					PayResultTable["OrderId"].."",
				}
				luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			end
		elseif PayResultTable["payChannel"] == profile.PayChannelData.YINBEIKEPAY_CT then
			-- 银贝壳电信
			if Common.platform == Common.TargetIos then
			elseif Common.platform == Common.TargetAndroid then
				--android平台
				local javaClassName = "com.pay.PaymentConfig"
				local javaMethodName = "luaCallYINBEIKEPayResult"
				local javaParams = {
					PaymentTable.goodsName,
					PaymentTable.payCode.."",
					""..PaymentTable.price,
					PayResultTable["OrderId"].."",
				}
				luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			end
		elseif PayResultTable["payChannel"] == profile.PayChannelData.HONGRUAN_SDK_CT then
			-- 红软电信
			if Common.platform == Common.TargetIos then
			elseif Common.platform == Common.TargetAndroid then
				--android平台
				local javaClassName = "com.pay.PaymentConfig"
				local javaMethodName = "luaCallHongRPayResult"
				local javaParams = {
					PaymentTable.goodsName,
					PaymentTable.payCode.."",
					""..PaymentTable.price,
					PayResultTable["OrderId"].."",
				}
				luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			end
		else
			Common.log("支付失败!!!!!!!!!");
		end
	end

	cachePaymentTableList[""..PayResultTable.SerialNumber] = nil
	framework.emit(MANAGERID_V3_RECHARGE)
end


local index = 1 -- 移动发短信标示
local lookTimer = nil

function HuaJianTelecomPay()
	if PayResultTable["smsList"][1] ~= nil then
		if PayResultTable["smsList"][1].IsDataSms == 0 then
			--0文本短信
			Common.sendSMSMessage(PayResultTable["smsList"][1].number, PayResultTable["smsList"][1].smsContent)
		elseif PayResultTable["smsList"][1].IsDataSms == 1 then
			-- 1二进制短信
			Common.sendSMSDataMessage(PayResultTable["smsList"][1].number, PayResultTable["smsList"][1].DestinationPort, PayResultTable["smsList"][1].smsContent)
		end
	end
end

function HuaJianUnicomPay()
	if PayResultTable["smsList"][1] ~= nil then
		if PayResultTable["smsList"][1].IsDataSms == 0 then
			--0文本短信
			Common.sendSMSMessage(PayResultTable["smsList"][1].number, PayResultTable["smsList"][1].smsContent)
		elseif PayResultTable["smsList"][1].IsDataSms == 1 then
			-- 1二进制短信
			Common.sendSMSDataMessage(PayResultTable["smsList"][1].number, PayResultTable["smsList"][1].DestinationPort, PayResultTable["smsList"][1].smsContent)
		end
	end
end

function callMethod()
	if PayResultTable["smsList"][index] ~= nil then
		if PayResultTable["smsList"][index].IsDataSms == 0 then
			--0文本短信
			Common.sendSMSMessage(PayResultTable["smsList"][index].number, PayResultTable["smsList"][index].smsContent)
		elseif PayResultTable["smsList"][index].IsDataSms == 1 then
			-- 1二进制短信
			Common.sendSMSDataMessage(PayResultTable["smsList"][index].number, PayResultTable["smsList"][index].DestinationPort, PayResultTable["smsList"][index].smsContent)
		end
		index = index + 1
	else
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
		lookTimer = nil
		index = 1;
	end
end

function SmsOnlinePay()
	if lookTimer == nil then
		lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(callMethod, 2, false)
	end
end

registerMessage(MANAGERID_V3_RECHARGE, readMANAGERID_V3_RECHARGE)
