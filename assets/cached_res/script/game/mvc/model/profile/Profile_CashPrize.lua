module(..., package.seeall)

local CashPrizeTable = {} --现金奖品table
local CashPrizeListTable = {}
local CashPrizeExchangedListTable = {} --兑换过的现金奖列表
local hasCashPrize = false
local CashPrizeExchangeMobileFareTable = {} --兑换话费应答table
local CashPrizeExchangeGameCoin = {} --兑换金币应答table


----[[--
----加载本地現金奖品列表数据
--]]
--local function loadCashPrizeTable()
--	CashPrizeTable = Common.LoadTable("CashPrizeTable")
--	if CashPrizeTable == nil then
--		CashPrizeTable = {}
--		CashPrizeTable["Timestamp"] = 0
--		CashPrizeTable["AwardsList"] = {}
--	end
--end
--
--loadCashPrizeTable()

function getCashPrizeTable()

end

function setCashPrizeInfo(dataTable)
	Common.log("setCashPrizeInfo")
	CashPrizeTable = dataTable
	if dataTable["CashPrizeList"] ~= nil then
		CashPrizeListTable = dataTable["CashPrizeList"]
	end

	if dataTable["CashPrizeExchangedList"] ~= nil then
		CashPrizeExchangedListTable = dataTable["CashPrizeExchangedList"]
	end
	hasCashPrize = true
	framework.emit(OPERID_GET_CASH_PRIZE_LIST)
end

function getCashPrizeTimestamp()
	return CashPrizeTable["Timestamp"]
end

function getCashPrizeListTable()
	return CashPrizeListTable
end

function getCashPrizeExchangedListTable()
	return CashPrizeExchangedListTable
end

function setCashPrizeExchangeMobileFareTable(dataTable)
	CashPrizeExchangeMobileFareTable = dataTable
	framework.emit(OPERID_PRIZE_EXCHANGE_MOBILE_FARE)
end

function getCashPrizeExchangeMobileFareTable()
	return CashPrizeExchangeMobileFareTable
end

function setCashPrizeExchangeGameCoin(dataTable)
	CashPrizeExchangeGameCoin = dataTable
	framework.emit(OPERID_PRIZE_EXCHANGE_GAME_COIN)
end

function getCashPrizeExchangeGameCoin()
	return CashPrizeExchangeGameCoin
end

function getHasCashPrize()
	return hasCashPrize
end

registerMessage(OPERID_GET_CASH_PRIZE_LIST, setCashPrizeInfo)
registerMessage(OPERID_PRIZE_EXCHANGE_MOBILE_FARE, setCashPrizeExchangeMobileFareTable)
registerMessage(OPERID_PRIZE_EXCHANGE_GAME_COIN, setCashPrizeExchangeGameCoin)
