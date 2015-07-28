module(..., package.seeall)

--------------------------- 礼包 ---------------------------

local GiftData = {}--礼包模块数据
local GiftResultForYuanbao = {}--元宝购买礼包数据

--存放礼包状态,是否已经购买过礼包 0：已经购买（不可购买） 1：可以购买 2:不够触发条件，3---礼包看过后，24小时不可见
local GiftBagType = {}
--[[--
--获取礼包数据
]]
function getGiftDataTable()
	return GiftData
end

--[[--
--获取元宝购买礼包数据
]]
function getGiftResultForYuanbao()
	return GiftResultForYuanbao
end

--[[--
--存储各个礼包状态
--@param #number GiftBagType 礼包类型
--@param #number IsPayGift 礼包状态,存放礼包状态,是否已经购买过礼包 0：已经购买（不可购买） 1：可以购买 2:不够触发条件，3---礼包看过后，24小时不可见
]]
function saveGiftBagType(GiftBagType, IsPayGift)
	Common.setDataForSqlite(CommSqliteConfig.GiftBagType..GiftBagType.."_"..profile.User.getSelfUserID(), IsPayGift)
end

--[[--
--获取对应礼包的状态
--@param #number GiftBagType 礼包类型
]]
function getGiftBagType(GiftBagType)
	return Common.getDataForSqlite(CommSqliteConfig.GiftBagType..GiftBagType.."_"..profile.User.getSelfUserID())
end

--[[--
--获取当前礼包是否可以购买
--@param #number GiftBagType 礼包类型
]]
function getIsPayGift(GiftBagType)
	if not ServerConfig.getGiftIsShow() then
		return false
	end
	if QuickPay.LaoHuJi_GiftTypeID == GiftBagType --[[--or (GameConfig.getTheCurrentBaseLayer() == GUI_TABLE and QuickPay.First_Pay_GiftTypeID == GiftBagType)--]] then
		if getGiftBagType(GiftBagType) == 0 then
			-- 0：已经购买（不可购买）
			return false
		elseif getGiftBagType(GiftBagType) == 1 or getGiftBagType(GiftBagType) == 3 then
			-- 1：可以购买
			return true
		elseif getGiftBagType(GiftBagType) == 2 then
			-- 2:不够触发条件
			return false
		else
			return false
		end
		--	elseif (GameConfig.getTheCurrentBaseLayer() == GUI_HALL and QuickPay.First_Pay_GiftTypeID == GiftBagType) then
		--		if getGiftBagType(GiftBagType) == 0 then
		--			-- 0：已经购买（不可购买）
		--			return false
		--		elseif getGiftBagType(GiftBagType) == 1 or getGiftBagType(GiftBagType) == 3 or getGiftBagType(GiftBagType) == 2 then
		--			-- 1：可以购买
		--			return true
		--		else
		--			return false
		--		end
	else
		if getGiftBagType(GiftBagType) == 0 then
			-- 0：已经购买（不可购买）
			return false
		elseif getGiftBagType(GiftBagType) == 1 then
			-- 1：可以购买
			return true
		elseif getGiftBagType(GiftBagType) == 2 then
			-- 2:不够触发条件
			return false
		elseif getGiftBagType(GiftBagType) == 3 then
			-- 3---礼包看过后，24小时不可见
			return false
		else
			return false
		end
	end
end


--3.8.3 通用礼包请求消息(GIFTBAGID_REQUIRE_GIFTBAG)
function readGIFTBAGID_REQUIRE_GIFTBAG(dataTable)
	Common.closeProgressDialog()
	saveGiftBagType(dataTable["giftBagType"], 0)
	framework.emit(GIFTBAGID_REQUIRE_GIFTBAG)
end

--3.8.5 推送双核礼包(GIFTBAGID_PUSH_DUAL_GIFTBAG)
function readGIFTBAGID_PUSH_DUAL_GIFTBAG(dataTable)
	Common.closeProgressDialog()
	GiftData = {}
	GiftData = dataTable
	framework.emit(GIFTBAGID_PUSH_DUAL_GIFTBAG)
end

--3.8.6 使用元宝购买礼包(GIFTBAGID_BUY_GIFTBAG)
function readGIFTBAGID_BUY_GIFTBAG(dataTable)
	GiftResultForYuanbao = dataTable;
	framework.emit(GIFTBAGID_BUY_GIFTBAG)
end

--3.8.7 客户端展示礼包(GIFTBAGID_SHOW_GIFTBAG)
function readGIFTBAGID_SHOW_GIFTBAG(dataTable)
	framework.emit(GIFTBAGID_SHOW_GIFTBAG)
end

--3.8.8 用户礼包状态(GIFTBAGID_GET_GIFTBAG_MSG)
function readGIFTBAGID_GET_GIFTBAG_MSG(dataTable)
	GiftBagType = dataTable["GiftBagData"]

	for i = 1, #GiftBagType do
		--…GiftBagType  礼包类别ID
		--Common.log("GiftBagData---礼包类别ID = " .. GiftBagType[i].GiftBagType)
		--…IsPayGift  是否可以购买此类礼包
		--Common.log("GiftBagData---是否可以购买此类礼包 = " .. GiftBagType[i].IsPayGift)
		saveGiftBagType(GiftBagType[i].GiftBagType, GiftBagType[i].IsPayGift)
	end
	--RemainCount  当天剩余破产送金次数
	profile.User.mnRemainCount = dataTable["RemainCount"]
	framework.emit(GIFTBAGID_GET_GIFTBAG_MSG)
end

--3.8.10 用户删除背包礼包列表(GIFTBAGID_PUSH_DELBACKLIST)
function readGIFTBAGID_PUSH_DELBACKLIST(dataTable)
	framework.emit(GIFTBAGID_PUSH_DELBACKLIST)
end

local GIFTBAGID_NEWGIFT_TYPETable = {}
function getGIFTBAGID_NEWGIFT_TYPETable()
	return GIFTBAGID_NEWGIFT_TYPETable
end

--3.8.11 用户背包中新礼包状态(GIFTBAGID_NEWGIFT_TYPE)
function readGIFTBAGID_NEWGIFT_TYPE(dataTable)
	GIFTBAGID_NEWGIFT_TYPETable = dataTable
	framework.emit(GIFTBAGID_NEWGIFT_TYPE)
end

local GIFTBAGID_SHOW_FIRSTPAY_ICONTable = {}
--3.8.13 首充礼包图标是否显示(GIFTBAGID_SHOW_FIRSTPAY_ICON)
function readGIFTBAGID_SHOW_FIRSTPAY_ICON(dataTable)
	GIFTBAGID_SHOW_FIRSTPAY_ICONTable = dataTable
	framework.emit(GIFTBAGID_SHOW_FIRSTPAY_ICON)
end

--[[--
--首充礼包图标是否显示
--]]
function isShowFirstGiftIcon()
	if GameConfig.getTheCurrentBaseLayer() ~= GUI_TABLE then
		if ServerConfig.getGiftIsShow() then
			return true;
		else
			return false;
		end
	else
		if not ServerConfig.getGiftIsShow() then
			return false;
		end
		if getGiftBagType(QuickPay.First_Pay_GiftTypeID) == 0 then
			return false
		end
		if GIFTBAGID_SHOW_FIRSTPAY_ICONTable ~= nil and GIFTBAGID_SHOW_FIRSTPAY_ICONTable["Visible"] ~= nil then
			--是否可见	1是 0否
			if GIFTBAGID_SHOW_FIRSTPAY_ICONTable["Visible"] == 0 then
				return false;
			else
				return true;
			end
		else
			return false;
		end
	end
end

--[[--
--发送首充礼包图标是否显示消息
--]]
function sendFirstGiftIconMsg(Position)
	if getGiftBagType(QuickPay.First_Pay_GiftTypeID) ~= 0 then
		sendGIFTBAGID_SHOW_FIRSTPAY_ICON(Position);
	end
end

registerMessage(GIFTBAGID_REQUIRE_GIFTBAG, readGIFTBAGID_REQUIRE_GIFTBAG)
registerMessage(GIFTBAGID_PUSH_DUAL_GIFTBAG, readGIFTBAGID_PUSH_DUAL_GIFTBAG)
registerMessage(GIFTBAGID_BUY_GIFTBAG, readGIFTBAGID_BUY_GIFTBAG)
registerMessage(GIFTBAGID_SHOW_GIFTBAG, readGIFTBAGID_SHOW_GIFTBAG)
registerMessage(GIFTBAGID_GET_GIFTBAG_MSG, readGIFTBAGID_GET_GIFTBAG_MSG)
registerMessage(GIFTBAGID_PUSH_DELBACKLIST, readGIFTBAGID_PUSH_DELBACKLIST)
registerMessage(GIFTBAGID_NEWGIFT_TYPE, readGIFTBAGID_NEWGIFT_TYPE)
registerMessage(GIFTBAGID_SHOW_FIRSTPAY_ICON, readGIFTBAGID_SHOW_FIRSTPAY_ICON)