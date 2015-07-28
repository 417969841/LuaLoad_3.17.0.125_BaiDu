module(..., package.seeall)

--PayTypeID byte 支付渠道ID
RECHARGE_CARD_PAY = 1 --1:充值卡
ALI_PAY = 2 --2:支付宝
UNION_PAY = 3 --3:银联
COOLPAD_PAY = 4 --4:酷派
MM_PAY = 5 --5:MM
MIUI_PAY = 6 --6 小米
K_TOUCH_PAY = 7 --7天语
HUAJIAN_LIANTONG_PAY = 8 --8联通短信支付
HUAJIAN_DIANXIN_PAY = 9 --9电信短信支付
SMS_ONLINE = 10 --10移动短信支付
RECHARGE_91 = 11 --11 --- 91
SMS_UNICOM = 12 --12 联通--沃商店
--SHENGFENG_DIANXIN_PAY = 17 --17盛丰电信
MM_PAY_V2 = 21 --21MM带服务器回调
--CTESTORE_PAY = 25 -- 25天翼空间支付
IAP_PAY = 31    --iap支付
NEW_UNION_PAY = 29 --新银联支付
--CM_PAY = 39 --手机钱包支付
HAIMA_PAY = 49 --海马IOS支付
WEIXIN_PAY = 62;-- 62微信支付
EPAY = 69;-- 69宜支付
YINBEIKEPAY_CMCC = 76 --银贝壳移动
YINBEIKEPAY_UNI = 77 --银贝壳联通
YINBEIKEPAY_CT = 78 --银贝壳电信
HONGRUAN_SDK_CMCC = 83 --红软移动
HONGRUAN_SDK_UNICOM = 84 --红软联通
HONGRUAN_SDK_CT = 85 --红软电信
RECHARGE_WOJIA = 82 --同趣联通wo+
local PayChannelTable = {}
-- …PayTypeID byte 支付渠道ID 1:充值卡2:支付宝 3:银联4:酷派5:MM6 小米7天语8华建联通9华建电信10移动游戏基地
-- mnPayTypeID
-- …GoodsID byte 商品编号
-- mnGoodsID
-- …GoodsName Text 商品名称
-- msGoodsName
-- …GoodsDescription Text 商品描述
-- msGoodsDescription
-- …GoodsPrice Text 商品价格 例：价格:￥50.00
-- msGoodsPrice
-- …GoodsNum byte 一次购买商品数量
-- mnGoodsNum
-- …MMPayCode Text 短信支付代码 MM专用
-- msMMPayCode
-- …Messageformat Text 发送短信格式 华建专用
-- msMessageformat
-- …Status byte 是否可用 0：可用1：不可用
-- mnStatus
-- …Subtype Byte 支付子类型 默认为0
-- mnSubtype
-- …coinUrl Text 购买物品图标
-- msCoinUrl
-- …tagUrl Text 物品标签
-- msTagUrl
-- …addYuanbao Int 额外赠送的元宝数 0:无赠送
-- mnAddYuanbao
-- …Discount Int 优惠百分比(%) 例：10
-- mnDiscount

--Android
local AliPayTable = {} --支付宝
local WeiXinTable = {} --微信
local UnionTable = {} --银联
local RechargeCardTable = {} --充值卡
local MMTable = {} --MM
local woJiaTable = {} --同趣联通wo+
local SMSOnlineTable = {} --游戏基地
local UnicomTable = {} --联通
local TelecomTable = {} --电信
local NewUnionTable = {} --新银联
local PurseTable = {} --手机钱包
--IOS
local BaiDu91RechargeTable = {} -- 百度91
local IAPRechargeTable = {}  --iap支付
local HaiMaRechargeTable = {} --海马IOS支付
local HuaJianTelecomTable = {} --华建电信
local HuaJianUnicomTable = {} --联通短代
local EPayTable = {} --宜支付短代
local YINBEIKETable = {} --银贝壳支付移动
local YINBEIKETable_UNI = {} --银贝壳支付联通
local YINBEIKETable_CT = {} --银贝壳支付电信
local HongRuanTableCMCC = {} --红软移动
local HongRuanTableUNI = {} --红软联通
local HongRuanTableCT = {} -- 红软电信
--goodsName  -- 商品名称
--goodsDetail  -- 商品的具体描述
--goodsPriceDetail  -- 本次支付的总费
--goodsCount = 1  -- 商品数量(默认为1)
--payCode  -- 支付代码
--serverMsg  -- 短信格式(华建特有)
--mnDiscount  -- 优惠百分比(%) 例：10
--mbIsShow  -- 是否可显示
--mnSubtype = 0  -- 支付子类型 默认为0
--msCoinUrl --tagUrl Text 物品标签
--msTagUrl   物品标签
--price  -- 价格(单位：分)

function releaseRechargeData()
	PayChannelTable = {}
	AliPayTable = {} --支付宝
	WeiXinTable = {} --微信
	UnionTable = {} --银联
	RechargeCardTable = {} --充值卡
	MMTable = {} --MM
	SMSOnlineTable = {} --游戏基地
	UnicomTable = {} --联通
	TelecomTable = {} --电信
	NewUnionTable = {} --新银联
	PurseTable = {} --手机钱包
	--IOS
	BaiDu91RechargeTable = {} -- 百度91
	IAPRechargeTable = {}  --iap支付
	HaiMaRechargeTable = {} --海马IOS支付
	HuaJianTelecomTable = {} --华建电信
	HuaJianUnicomTable = {} --联通短代
end

--[[--
--获取支付宝所有支付列表
]]
function getAliPayAllListData()
	return AliPayTable
end

--[[--
--获取支付宝可显示的支付列表
]]
function getAliPayShowListData()
	local AliPayShowTable = {}
	for key, var in ipairs(AliPayTable) do
		if var.mbIsShow == true then
			table.insert(AliPayShowTable, var)
		end
	end
	return AliPayShowTable
end

--[[--
--获取微信所有支付列表
]]
function getWeiXinAllListData()
	return WeiXinTable
end

--[[--
--获取微信可显示的支付列表
]]
function getWeiXinShowListData()
	local WeiXinShowTable = {}
	for key, var in ipairs(WeiXinTable) do
		if var.mbIsShow == true then
			table.insert(WeiXinShowTable, var)
		end
	end
	return WeiXinShowTable
end

--[[--
--获取新银联所有支付列表
]]
function getUnionAllListData()
	return NewUnionTable
end

--[[--
--获取新银联可显示支付列表
]]
function getUnionShowListData()
	local UnionShowTable = {}
	for key, var in ipairs(NewUnionTable) do
		if var.mbIsShow == true then
			table.insert(UnionShowTable, var)
		end
	end
	return UnionShowTable
end

--[[--
--获取充值卡支付列表
]]
function getRechargeCardAllListData()
	return RechargeCardTable
end

--[[--
--获取充值卡支付列表
]]
function getRechargeCardShowListData()
	local RechargeCardShowTable = {}
	for key, var in ipairs(RechargeCardTable) do
		if var.mbIsShow == true then
			table.insert(RechargeCardShowTable, var)
		end
	end
	return RechargeCardShowTable
end

--[[--
--获取MM支付列表
]]
function getMMAllListData()
	return MMTable
end

--[[--
--获取MM支付列表
]]
function getMMShowListData()
	local MMShowTable = {}
	for key, var in ipairs(MMTable) do
		if var.mbIsShow == true then
			table.insert(MMShowTable, var)
		end
	end
	return MMShowTable
end

--[[--
--获取同趣联通wo+支付列表
]]
function getWoJiaAllListData()
	return woJiaTable
end

--[[--
--获取同趣联通wo+支付列表
]]
function getWoJiaShowListData()
	local woJiaTableInfo = {}
	for key, var in ipairs(woJiaTable) do
		if var.mbIsShow == true then
			table.insert(woJiaTableInfo, var)
		end
	end
	return woJiaTableInfo
end

--[[--
--获取游戏基地支付列表
]]
function getSMSOnlineAllListData()
	return SMSOnlineTable
end

--[[--
--获取游戏基地支付列表
]]
function getSMSOnlineShowListData()
	local SMSOnlineShowTable = {}
	for key, var in ipairs(SMSOnlineTable) do
		if var.mbIsShow == true then
			table.insert(SMSOnlineShowTable, var)
		end
	end
	return SMSOnlineShowTable
end

--[[--
--获取联通支付列表
]]
function getUnicomAllListData()
	return UnicomTable
end

--[[--
--获取联通支付列表
]]
function getUnicomShowListData()
	local UnicomShowTable = {}
	for key, var in ipairs(UnicomTable) do
		if var.mbIsShow == true then
			table.insert(UnicomShowTable, var)
		end
	end
	return UnicomShowTable
end

--[[--
--获取91支付列表
]]
function getBaidu91AllListData()
	return BaiDu91RechargeTable
end
--[[--
--获取91支付列表
]]
function getbaidu91ShowListData()
	local Baidu91ShowTable = {}
	for key, var in ipairs(BaiDu91RechargeTable) do
		if var.mbIsShow == true then
			table.insert(Baidu91ShowTable, var)
		end
	end
	return Baidu91ShowTable
end
--[[--
--获取iap支付列表
]]
function getIAPAllListData()
	return IAPRechargeTable
end
--[[--
--获取iap支付列表
]]
function getIAPShowListData()
	local IAPShowTable = {}
	for key, var in ipairs(IAPRechargeTable) do
		if var.mbIsShow == true then
			table.insert(IAPShowTable, var)
		end
	end
	return IAPShowTable
end

--[[--
--获取电信支付列表
]]
function getHuaJianTelecomAllListData()
	return HuaJianTelecomTable
end

--[[--
--获取电信支付列表
]]
function getHuaJianTelecomTableShowListData()
	local HuaJianTelecomTableShowTable = {}
	for key, var in ipairs(HuaJianTelecomTable) do
		if var.mbIsShow == true then
			table.insert(HuaJianTelecomTableShowTable, var)
		end
	end
	return HuaJianTelecomTableShowTable
end

--[[--
--获取电信支付列表
]]
function getHuaJianUnicomAllListData()
	return HuaJianUnicomTable
end

--[[--
--获取电信支付列表
]]
function getHuaJianUnicomTableShowListData()
	local HuaJianUnicomTableShowTable = {}
	for key, var in ipairs(HuaJianUnicomTable) do
		if var.mbIsShow == true then
			table.insert(HuaJianUnicomTableShowTable, var)
		end
	end
	return HuaJianUnicomTableShowTable
end

--[[--
--获取海马支付列表
]]
function getHaiMaAllListData()
	return HaiMaRechargeTable
end
--[[--
--获取海马支付列表
]]
function getHaiMaShowListData()
	local IAPShowTable = {}
	for key, var in ipairs(HaiMaRechargeTable) do
		if var.mbIsShow == true then
			table.insert(IAPShowTable, var)
		end
	end
	return IAPShowTable
end

--[[--
--获取电信支付列表
]]
function getTelecomAllListData()
	return TelecomTable
end

--[[--
--获取电信支付列表
]]
function getTelecomShowListData()
	local TelecomShowTable = {}
	for key, var in ipairs(TelecomTable) do
		if var.mbIsShow == true then
			table.insert(TelecomShowTable, var)
		end
	end
	return TelecomShowTable
end

--[[--
--获取手机钱包支付列表
]]
function getPurseAllListData()
	return PurseTable
end

--[[--
--获取手机钱包支付列表
]]
function getPurseShowListData()
	local PurseShowTable = {}
	for key, var in ipairs(PurseTable) do
		if var.mbIsShow == true then
			table.insert(PurseShowTable, var)
		end
	end
	return PurseShowTable
end

--[[--
--获取宜支付支付列表
]]
function getEPayAllListData()
	return EPayTable
end

--[[--
--获取显示的宜支付支付列表
]]
function getEPayShowListData()
	local EPayShowTable = {}
	for key, var in ipairs(EPayTable) do
		if var.mbIsShow == true then
			table.insert(EPayShowTable, var)
		end
	end
	return EPayShowTable
end


--[[--
--银贝壳
]]
function getYINBEIKEPayAllListData()
	return YINBEIKETable
end

function getYINBEIKEPayAllListData_UNI()
	return YINBEIKETable_UNI
end

function getYINBEIKEPayAllListData_CT()
	return YINBEIKETable_CT
end
--[[--
--红软短代
]]
function getAllListDataHongRuanTableCMCC()
	return HongRuanTableCMCC
end

function getAllListDataHongRuanTableUNI()
	return HongRuanTableUNI
end

function getAllListDataHongRuanTableCT()
	return HongRuanTableCT
end

--[[--
--获取显示的银贝壳支付列表
]]
function getYINBEIKEPayShowListData()
	local YINBEIKEPayShowTable = {}
	for key, var in ipairs(YINBEIKETable) do
		if var.mbIsShow == true then
			table.insert(YINBEIKEPayShowTable, var)
		end
	end
	return YINBEIKEPayShowTable
end

function getYINBEIKEPayShowListData_UNI()
	local YINBEIKEPayShowTable = {}
	for key, var in ipairs(YINBEIKETable_UNI) do
		if var.mbIsShow == true then
			table.insert(YINBEIKEPayShowTable, var)
		end
	end
	return YINBEIKEPayShowTable
end
function getYINBEIKEPayShowListData_CT()
	local YINBEIKEPayShowTable = {}
	for key, var in ipairs(YINBEIKETable_CT) do
		if var.mbIsShow == true then
			table.insert(YINBEIKEPayShowTable, var)
		end
	end
	return YINBEIKEPayShowTable
end


--[[--
--获取显示的红软支付列表
]]
function getHongRuanPayShowListData_CMCC()
	local HongRuanPayShowTable = {}
	for key, var in ipairs(HongRuanTableCMCC) do
		if var.mbIsShow == true then
			table.insert(HongRuanPayShowTable, var)
		end
	end
	return HongRuanPayShowTable
end

function getHongRuanPayShowListData_UNI()
	local HongRuanPayShowTable = {}
	for key, var in ipairs(HongRuanTableUNI) do
		if var.mbIsShow == true then
			table.insert(HongRuanPayShowTable, var)
		end
	end
	return HongRuanPayShowTable
end
function getHongRuanPayShowListDataCMCC_CT()
	local HongRuanPayShowTable = {}
	for key, var in ipairs(HongRuanTableCT) do
		if var.mbIsShow == true then
			table.insert(HongRuanPayShowTable, var)
		end
	end
	return HongRuanPayShowTable
end
--[[--
--处理支付列表数据
]]
function readPAYMENT_DATA_LIST(dataTable)
	releaseRechargeData()

	PayChannelTable["PayChannelData"] = dataTable["PayChannelData"]

	for key, var in ipairs(PayChannelTable["PayChannelData"]) do
		local tempTable = {}

		if var.PayTypeID == ALI_PAY then
			--支付宝
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(AliPayTable, tempTable)
		elseif var.PayTypeID == WEIXIN_PAY then
			--微信
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(WeiXinTable, tempTable)

		elseif var.PayTypeID == UNION_PAY then

		elseif var.PayTypeID == NEW_UNION_PAY then
			--新银联
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(NewUnionTable, tempTable)

		elseif var.PayTypeID == RECHARGE_CARD_PAY then
			--充值卡
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(RechargeCardTable, tempTable)

		elseif var.PayTypeID == MM_PAY_V2 then
			--MM
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0
			tempTable.payCode = var.MMPayCode --支付代码

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(MMTable, tempTable)
		elseif var.PayTypeID == RECHARGE_WOJIA then
			--同趣联通wo+
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0
			tempTable.payCode = var.MMPayCode --支付代码

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(woJiaTable, tempTable)
		elseif var.PayTypeID == SMS_ONLINE then
			--移动短信支付
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0
			tempTable.payCode = var.MMPayCode --支付代码

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(SMSOnlineTable, tempTable)
		elseif var.PayTypeID == SMS_UNICOM then
			--联通沃商店
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0
			tempTable.payCode = var.MMPayCode --支付代码

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(UnicomTable, tempTable)
		elseif var.PayTypeID == RECHARGE_91 then
			--91  Baidu91ShowTable
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(BaiDu91RechargeTable, tempTable)
		elseif var.PayTypeID == IAP_PAY then
			--iap   IAPRechargeTable
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(IAPRechargeTable, tempTable)
		elseif var.PayTypeID == HAIMA_PAY then
			-- 海马IOS
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			tempTable.payCode = var.MMPayCode --支付代码
			tempTable.serverMsg = var.Messageformat
			table.insert(HaiMaRechargeTable, tempTable)
		elseif var.PayTypeID == HUAJIAN_DIANXIN_PAY then
			--电信短代
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(HuaJianTelecomTable, tempTable)
		elseif var.PayTypeID == HUAJIAN_LIANTONG_PAY then
			--联通短代
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(HuaJianUnicomTable, tempTable)
		elseif var.PayTypeID == EPAY then
			--宜支付短代
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(EPayTable, tempTable)
		elseif var.PayTypeID == YINBEIKEPAY_CMCC then
			--银贝壳支付短代
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			tempTable.payCode = var.MMPayCode
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID

			table.insert(YINBEIKETable, tempTable)
		elseif var.PayTypeID == HONGRUAN_SDK_CMCC then
			--红软支付短代
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			tempTable.payCode = var.MMPayCode
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID

			table.insert(HongRuanTableCMCC, tempTable)
		elseif var.PayTypeID == YINBEIKEPAY_UNI then
			--银贝壳支付短代

			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			tempTable.payCode = var.MMPayCode
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(YINBEIKETable_UNI, tempTable)
		elseif var.PayTypeID == HONGRUAN_SDK_UNICOM then
			--红软支付短代

			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			tempTable.payCode = var.MMPayCode
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(HongRuanTableUNI, tempTable)
		elseif var.PayTypeID == YINBEIKEPAY_CT then

			--银贝壳支付短代
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			tempTable.payCode = var.MMPayCode
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(YINBEIKETable_CT, tempTable)
		elseif var.PayTypeID == HONGRUAN_SDK_CT then

			--银贝壳支付短代
			tempTable.goodsName = var.NewName -- 商品名称
			tempTable.goodsDetail = var.GoodsDescription -- 商品的具体描述
			tempTable.goodsPriceDetail = var.GoodsPrice -- 本次支付的总费
			tempTable.mnDiscount = var.Discount -- 优惠百分比(%) 例：10
			tempTable.payCode = var.MMPayCode
			if var.Status == 0 then
				tempTable.mbIsShow = true -- 是否可显示
			else
				tempTable.mbIsShow = false
			end
			tempTable.mnSubtype = var.Subtype -- 支付子类型 默认为0

			local strResult, cnt = string.gsub(var.GoodsPrice, "价格:￥", "")
			tempTable.price = tonumber(strResult)*100 -- 价格(单位：分)

			tempTable.PayTypeID = var.PayTypeID
			table.insert(HongRuanTableCT, tempTable)
		end
	end

	framework.emit(PAYMENT_DATA_LIST)
end

registerMessage(PAYMENT_DATA_LIST,readPAYMENT_DATA_LIST)