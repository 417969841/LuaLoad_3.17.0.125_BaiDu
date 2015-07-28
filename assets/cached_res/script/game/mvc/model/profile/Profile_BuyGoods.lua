module(..., package.seeall)

local BuyGoodsTable = {}

BuyCoinGoodsID = 10--购买金币
--[[--
--获取购买结果数据
]]
function getBuyGoodsData()
	return BuyGoodsTable
end

--[[-- 解析解析购买商品]]
function readDBID_PAY_GOODS(dataTable)
	--isVIp  1是0否
	BuyGoodsTable["isVIp"] = dataTable["isVIp"]
	--result  是否成功1是0否
	BuyGoodsTable["result"] = dataTable["result"]
	--resultMsg
	BuyGoodsTable["resultMsg"] = dataTable["resultMsg"]
	--ItemID
	BuyGoodsTable["ItemID"] = dataTable["ItemID"]

	if BuyCoinGoodsID == BuyGoodsTable["ItemID"] then

	end

	framework.emit(DBID_PAY_GOODS)
end

registerMessage(DBID_PAY_GOODS, readDBID_PAY_GOODS)