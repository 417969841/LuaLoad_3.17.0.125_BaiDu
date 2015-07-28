module(..., package.seeall)

local CashAwardTable = {} --现金奖品table
local CashAwardRemainderTable = {} --现金奖品剩余数table
local CashAwardExchangeTable = {} --兑换限量奖品结果table

local hasCashAward = false --是否获取过现金奖品table

--[[--
--加载本地現金奖品列表数据
]]
--local function loadCashAwardTable()
--	CashAwardTable = Common.LoadTable("CashAwardTable")
--	if CashAwardTable == nil then
--		CashAwardTable = {}
--		CashAwardTable["Timestamp"] = 0
--		CashAwardTable["AwardsList"] = {}
--	end
--end
--
--loadCashAwardTable()

function setCashAwardsInfo(dataTable)
	CashAwardTable = dataTable
	Common.SaveTable("CashAwardTable", CashAwardTable)
	hasCashAward = true
	framework.emit(OPERID_GET_CASH_AWARD_LIST)
end


function getCashAwardsInfo()
	return CashAwardTable
end

function getHasCashAward()
	return hasCashAward
end

function setCashAwardsRemainderInfo(dataTable)
	CashAwardRemainderTable = dataTable
	framework.emit(OPERID_GET_CASH_AWARD_REMAINDER)
end


function getCashAwardsRemainderInfo()
	return CashAwardRemainderTable
end

function setCashAwardsExchangeInfo(dataTable)
	CashAwardExchangeTable = dataTable
	framework.emit(OPERID_EXCHANGE_LIMITED_AWARD)
end


function getCashAwardsExchangeInfo()
	return CashAwardExchangeTable
end

--function getCashAwardTimestamp()
--	return CashAwardTable["Timestamp"]
--end


registerMessage(OPERID_GET_CASH_AWARD_LIST, setCashAwardsInfo)
registerMessage(OPERID_GET_CASH_AWARD_REMAINDER, setCashAwardsRemainderInfo)
registerMessage(OPERID_EXCHANGE_LIMITED_AWARD, setCashAwardsExchangeInfo)