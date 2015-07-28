module(..., package.seeall)

local ShopGoodsTable = {}
local ShopGiftTable = {}

GOODS_TYPE_COIN_ENTRY = 0; -- 钱袋入口
GOODS_TYPE_VIP = 1; -- vip
GOODS_TYPE_PROP = 2; -- 道具
GOODS_TYPE_COIN = 3; -- 钱袋
GOODS_TYPE_HUDONG = 4; -- 互动道具
GOODS_TYPE_GIFT = 5; -- 礼包
GOODS_TYPE_VIP_GIFT = 6; -- VIP礼包
GOODS_TYPE_DUIJIANG_PIECES = 7; -- 兑奖券碎片

local GoodsListHasInit = false
local GiftListHasInit = false


--…ID
--…Name  名称
--…gameType  所属游戏
--…goodsType  商品类型 0钱袋入口1vip2道具3钱袋4互动道具5礼包6 Vip礼包 7 兑奖券碎片
--…IconURL  图标url
--…Title  标题
--…Description  描述
--…PurchaseLowerLimit  购买数量下限
--…PurchaseUpperLimit  购买数量上限
--…ConsumeType  消耗类型
--…Consume  单价
--…operationTagUrl  运营标签url

--[[--
--加载本地商城列表数据
]]
local function loadGoodsListTable()

	ShopGoodsTable = Common.LoadTable("ShopGoodsList")
	--Common.log("服务器时间戳" .. RoomTable["timestamp"])
	--Common.log("客户端时间戳" .. RoomTableJson["timestamp"])
	if ShopGoodsTable == nil then
		ShopGoodsTable = {}
		ShopGoodsTable["Timestamp"] = 0
		ShopGoodsTable["GoodsListTable"] = {}
		ShopGoodsTable["VipDiscountTable"] = {} --vip打折信息
	end
end

loadGoodsListTable()

--[[--
--获取商品列表时间戳
]]
function getGoodsListTimestamp()
	return ShopGoodsTable["Timestamp"]
end

--[[--
--获取商品列表
]]
function getGoodsListTable()
	return ShopGoodsTable["GoodsListTable"]
end
--[[--
--获取VIP打折信息
]]
function getGoodsVipDiscountTable()
	return ShopGoodsTable["VipDiscountTable"]
end

--[[--
--获取礼包列表
]]
function getGiftsListTable()
	return ShopGiftTable["GiftListTable"]
end

function getVipGiftListTable()
	return ShopGiftTable["VipGiftData"]
end

--[[-- 解析商城商品列表]]
function readDBID_MALL_GOODS_LIST(dataTable)
	Common.log("xwh Shop goods has come")
	if ShopGoodsTable["Timestamp"] ~= dataTable["Timestamp"] then
		Common.log("重新加载商城列表")
		ShopGoodsTable["Timestamp"] = dataTable["Timestamp"]
		ShopGoodsTable["VipDiscountTable"] = dataTable["VipDiscountTable"]
		--ShopGoodsTable["GoodsListTable"] = dataTable["GoodsTable"]
		--干掉兑换金币
		local j = 1
		for i = 1, #dataTable["GoodsTable"] do
			if dataTable["GoodsTable"][i].goodsType == profile.Shop.GOODS_TYPE_COIN_ENTRY then
			else
				ShopGoodsTable["GoodsListTable"][j] = {}
				ShopGoodsTable["GoodsListTable"][j] =  dataTable["GoodsTable"][i]
				j = j+1
			end
		end
		Common.SaveTable("ShopGoodsList", ShopGoodsTable)
	else
		Common.log("使用本地商城列表")
	end
	GoodsListHasInit = true
	framework.emit(DBID_MALL_GOODS_LIST)
end

--3.8.9 用户可购买礼包列表(GIFTBAGID_GIFTBAG_LIST)
function readGIFTBAGID_GIFTBAG_LIST(dataTable)
	Common.log("xwh Shop gift has come")
	ShopGiftTable["GiftListTable"] = dataTable["GiftBagData"]
	ShopGiftTable["VipGiftData"] =  dataTable["VipGiftData"]--vip礼包
	GiftListHasInit = true
	framework.emit(GIFTBAGID_GIFTBAG_LIST)
end

function getGoodsListHasInit()
	return GoodsListHasInit
end

function getGiftListHasInit()
	return GiftListHasInit
end

registerMessage(DBID_MALL_GOODS_LIST, readDBID_MALL_GOODS_LIST)
registerMessage(GIFTBAGID_GIFTBAG_LIST, readGIFTBAGID_GIFTBAG_LIST)