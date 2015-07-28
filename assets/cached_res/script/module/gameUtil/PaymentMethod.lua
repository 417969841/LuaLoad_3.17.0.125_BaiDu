module("PaymentMethod", package.seeall)

--[[--
--调用支付方法
--@param #table PaymentTable 要购买的商品信息
--@param #number PayTypeID 要使用的支付类型
--@param #number GiftID 礼包ID
--@param #boolean isExchange 是否兑换金币
--@param #number position 位置信息
]]
function callPayment(PaymentTable, PayTypeID, GiftID, isExchange, position)

	Common.log("PayTypeID = " .. PayTypeID)-- 支付类型

	Common.showProgressDialog("数据加载中,请稍后...")

	local SerialNumber = Common.getNativeTimeStamp()
	PaymentTable.SerialNumber = SerialNumber
	profile.PaymentResult.setPaymentTable(PaymentTable)

	if PayTypeID == profile.PayChannelData.RECHARGE_91 then
		--91
		local function callBaiduPayGetOrderInfo(parameters)
			PaymentInformation = {}
			PaymentInformation.giftID = GiftID
			PaymentInformation.orderID = parameters["orderID"]
			if isExchange then
				PaymentInformation.isChangeCoin = 1;
			else
				PaymentInformation.isChangeCoin = 0;
			end
			sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position);
		end

		--调用ios支付
		--ios平台
		local yuanbaoV = PaymentTable.price/10;
		local useridV =  profile.User.getSelfUserID();

		local args = {
			callback = callBaiduPayGetOrderInfo,
			userid = useridV,
			yuanbao = yuanbaoV,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "baiduorderID", args);

	elseif PayTypeID == profile.PayChannelData.IAP_PAY then
		--IAP
		local function callIAPPayGetOrderInfo(parameters)
			PaymentInformation = {};
			PaymentInformation.giftID = GiftID;
			if isExchange then
				PaymentInformation.isChangeCoin = 1;
			else
				PaymentInformation.isChangeCoin = 0;
			end
			sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position);
		end

		--调用ios支付
		--ios平台
		local yuanbaoV = PaymentTable.price/10;

		local args = {
			callback = callIAPPayGetOrderInfo,
			yuanbao = yuanbaoV,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "IAPorderID", args);
	elseif PayTypeID == profile.PayChannelData.HAIMA_PAY then
		--海马
		local function callHaiMaPayGetOrderInfo(parameters)
			PaymentInformation = {};
			PaymentInformation.giftID = GiftID;
			if isExchange then
				PaymentInformation.isChangeCoin = 1;
			else
				PaymentInformation.isChangeCoin = 0;
			end
			sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position);
		end

		--调用ios支付
		--ios平台

		local args = {
			callback = callHaiMaPayGetOrderInfo,
			payCode = PaymentTable.payCode,
			price = PaymentTable.price,
		}

		local ok, ret = luaoc.callStaticMethod("Helper", "HaiMaPaymentInfo", args);
	elseif PayTypeID == profile.PayChannelData.ALI_PAY then
		--支付宝
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)
		if Common.platform == Common.TargetIos then
			--ios平台
			PaymentInformation = {}
			PaymentInformation.giftID = GiftID
			PaymentInformation.orderID = ""
			if isExchange then
				PaymentInformation.isChangeCoin = 1
			else
				PaymentInformation.isChangeCoin = 0
			end
			sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)

		elseif Common.platform == Common.TargetAndroid then
			--Android平台
			PaymentInformation = {}
			PaymentInformation.giftID = GiftID
			PaymentInformation.orderID = ""
			if isExchange then
				PaymentInformation.isChangeCoin = 1
			else
				PaymentInformation.isChangeCoin = 0
			end
			sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
		end

	elseif PayTypeID == profile.PayChannelData.WEIXIN_PAY then
		--微信
		if not QuickPay.weiXinIsPaySupported() then
			Common.showToast("请您下载最新版微信！", 2);
		end
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)
		if Common.platform == Common.TargetIos then
			--ios平台
			PaymentInformation = {}
			PaymentInformation.giftID = GiftID
			if isExchange then
				PaymentInformation.isChangeCoin = 1
			else
				PaymentInformation.isChangeCoin = 0
			end
			sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
		elseif Common.platform == Common.TargetAndroid then
			--android平台
			PaymentInformation = {}
			PaymentInformation.giftID = GiftID
			if isExchange then
				PaymentInformation.isChangeCoin = 1
			else
				PaymentInformation.isChangeCoin = 0
			end
			sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
		end
	elseif PayTypeID == profile.PayChannelData.UNION_PAY then
	--银联
	elseif PayTypeID == profile.PayChannelData.RECHARGE_CARD_PAY then
		--充值卡
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)
		Common.log("PaymentTable.Pa8_cardNo = " .. PaymentTable.Pa8_cardNo) -- 充值卡卡号
		Common.log("PaymentTable.Pa9_cardPwd = " .. PaymentTable.Pa9_cardPwd) -- 充值卡密码
		Common.log("PaymentTable.Pd_frpId = " .. PaymentTable.Pd_frpId) -- 充值卡渠道编码

		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)

	elseif PayTypeID == profile.PayChannelData.MM_PAY_V2 then
		--MM
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)
		function callMMPayGetOrderInfo(parameters)
			PaymentInformation = {}
			PaymentInformation.giftID = GiftID
			if isExchange then
				PaymentInformation.isChangeCoin = 1
			else
				PaymentInformation.isChangeCoin = 0
			end
			sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
		end
		local javaClassName = "com.pay.PaymentConfig"
		local javaMethodName = "luaCallMMPayInit"
		local javaParams = {
			callMMPayGetOrderInfo,
			PaymentTable.payCode,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")

		--	elseif PayTypeID == profile.PayChannelData.CTESTORE_PAY then
		--		--电信
		--		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		--		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		--		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		--		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		--		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		--		Common.log("PaymentTable.serverMsg = " .. PaymentTable.serverMsg) -- 短信格式(华建特有)
		--		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)
		--		Common.log("PaymentTable.payCode = " .. PaymentTable.payCode) -- 价格(单位：分)
		--
		--		local javaClassName = "com.pay.PaymentConfig"
		--		local javaMethodName = "luaCallSetCestorePayData"
		--		local javaParams = {
		--			PaymentTable.payCode, PaymentTable.goodsName, PaymentTable.price
		--		}
		--
		--		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
		--
		--		PaymentInformation = {}
		--		PaymentInformation.giftID = GiftID
		--		if isExchange then
		--			PaymentInformation.isChangeCoin = 1
		--		else
		--			PaymentInformation.isChangeCoin = 0
		--		end
		--		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.RECHARGE_WOJIA then
		--同趣联通WO+
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)

		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		PaymentTableInfo = PaymentTable
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.NEW_UNION_PAY then
		--新银联
		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
		--	elseif PayTypeID == profile.PayChannelData.CM_PAY then
		--		--手机钱包
		--		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		--		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		--		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		--		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		--		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		--		Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		--		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)
		--		Common.log("PaymentTable.serverMsg = " .. PaymentTable.serverMsg) -- 短信格式
		--		local javaClassName = "com.pay.PaymentConfig"
		--		local javaMethodName = "luaCallSetPursePayData"
		--		local javaParams = {
		--			PaymentTable.payCode,PaymentTable.serverMsg
		--		}
		--		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
		--		PaymentInformation = {}
		--		PaymentInformation.giftID = GiftID
		--		if isExchange then
		--			PaymentInformation.isChangeCoin = 1
		--		else
		--			PaymentInformation.isChangeCoin = 0
		--		end
		--		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.SMS_ONLINE then
		--移动短代支付
		Common.log("移动短代支付")
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)

		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.SMS_UNICOM then
		--联通沃支付
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)

		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end

		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)

		--		if Common.platform == Common.TargetIos then
		--			--ios平台
		--			local args = {
		--				name = PaymentTable.goodsName,
		--				money = PaymentTable.price / 100,
		--				vacCode = PaymentTable.payCode,
		--			};
		--			luaoc.callStaticMethod("Helper", "UnicomPaymentInfo", args);
		--		elseif Common.platform == Common.TargetAndroid then
		--			--android平台
		--
		--		end
	elseif PayTypeID == profile.PayChannelData.HUAJIAN_DIANXIN_PAY then
		--电信短代支付
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		--Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)

		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.HUAJIAN_LIANTONG_PAY then
		--联通短代支付
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		--Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)

		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.EPAY then
		--宜支付
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		--Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)

		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.YINBEIKEPAY_CMCC then
		--银贝壳移动
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)
		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.YINBEIKEPAY_UNI then
		--银贝壳联通
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)

		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.YINBEIKEPAY_CT then
		--银贝壳电信
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		--Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)

		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.HONGRUAN_SDK_CMCC then
		--红软移动
		Common.log("HONGRUANPaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("HONGRUANPaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("HONGRUANPaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("HONGRUANPaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("HONGRUANPaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("HONGRUANPaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("HONGRUANPaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)
		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.HONGRUAN_SDK_UNICOM then
		--红软联通
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)
		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	elseif PayTypeID == profile.PayChannelData.HongRuanTableCT then
		--红软电信
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("PaymentTable.payCode = " .. PaymentTable.payCode)--支付代码
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)
		PaymentInformation = {}
		PaymentInformation.giftID = GiftID
		if isExchange then
			PaymentInformation.isChangeCoin = 1
		else
			PaymentInformation.isChangeCoin = 0
		end
		sendMANAGERID_V3_RECHARGE(PaymentTable, PaymentInformation, PayTypeID, position)
	end

end
