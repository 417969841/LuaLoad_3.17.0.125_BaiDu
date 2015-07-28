module(..., package.seeall)

local PrizeTable = {}
local prizeHasInit = false
local ExchangbleAwardsTable = {} --可兑奖物品table
local hasNewExchangbleAwards = false --是否有新的可兑奖物品
local newExchangbleTableName = "NewExchangbleFile" --存储在本地的可兑奖物品的table名称
--[[--
--加载本地奖品列表数据
]]
local function loadPrizeListTable()
	PrizeTable = Common.LoadTable("PrizeList")
	if PrizeTable == nil then
		PrizeTable = {}
		PrizeTable["Timestamp"] = 0
		PrizeTable["List"] = {}
	end
end

loadPrizeListTable()

--奖品相关
function setPrizeTable(dataTable)
	if PrizeTable["Timestamp"] ~= dataTable["Timestamp"] then
		PrizeTable["Timestamp"] = dataTable["Timestamp"]
		PrizeTable["List"] = dataTable["PrizeData"]

		Common.SaveTable("PrizeList", PrizeTable)
	else

	end
	prizeHasInit = true
	framework.emit(MANAGERID_GET_PRESENTS)
end

function getPrizeTable()
	return PrizeTable["List"]

end

function setPrizeListTimestamp(time)
	PrizeTable["Timestamp"] = time;
end

function getPrizeListTimestamp()
	return PrizeTable["Timestamp"]
end
----------------------------------------兑奖券兑换
local PriceCompound = {}

PriceCompound["Result"] = 2 -- 2是初始值，0是成功 1是失败
PriceCompound["ResultMsg"] = ""

--[[--
--Result
]]
function getResult()
	local value = PriceCompound["Result"]
	if value == nil then
		return 2
	else
		return value
	end
end

function setResult(result)
	PriceCompound["Result"] = result
end

--[[--
--ResultText
]]
function getResultText()
	local value = PriceCompound["ResultMsg"]
	if value == nil then
		return ""
	else
		return value
	end
end

function setResultText(resultText)
	PriceCompound["ResultMsg"] = resultText
end

function setPriceConvertInfo(dataTable)
	local result = dataTable["Result"]
	local resultText = dataTable["Message"]

	PriceCompound["Result"] = result
	PriceCompound["ResultMsg"] = resultText

	framework.emit(MANAGERID_EXCHANGE_AWARD)
end

function getPrizeHasData()
	return prizeHasInit
end

function setExchangbleAwardsInfo(dataTable)
	ExchangbleAwardsTable = dataTable
	framework.emit(MANAGERID_GET_EXCHANGBLE_AWARDS)
end

function getExchangbleAwardsInfo()
	return ExchangbleAwardsTable
end

function getHaveExchangbleAwards()
	--检测是否有新的可兑奖物品,返回boolean
	Common.log("getHaveExchangbleAwards 1")
	Common.log("getHaveExchangbleAwards ppp " .. #ExchangbleAwardsTable["ExchangableAwardsList"])
	hasNewExchangbleAwards = false
	local newExchangbleTable = Common.LoadShareTable(newExchangbleTableName)
	if newExchangbleTable == nil then
		Common.log("getHaveExchangbleAwards newExchangbleTable == nil")
		 if ExchangbleAwardsTable["ExchangableAwardsList"] ~= nil and #ExchangbleAwardsTable["ExchangableAwardsList"] ~= 0 then
		 	hasNewExchangbleAwards = true;
			Common.log("getHaveExchangbleAwards ~= nil hasNewExchangbleAwards = true")
		 else
		 	Common.log("getHaveExchangbleAwards == nil hasNewExchangbleAwards = false")
		 	hasNewExchangbleAwards = false;
		 end
	else
		if ExchangbleAwardsTable["ExchangableAwardsList"] ~= nil and #ExchangbleAwardsTable["ExchangableAwardsList"] ~= 0 then
			Common.log("getHaveExchangbleAwards ExchangableAwardsList ~= nil for")
			for i = 1, #ExchangbleAwardsTable["ExchangableAwardsList"] do
				Common.log("getHaveExchangbleAwards #ExchangbleAwardsTable " .. i)
				for j = 1,#newExchangbleTable["ExchangableAwardsList"] do
					Common.log("getHaveExchangbleAwards #newExchangbleTable " .. j)
					if(newExchangbleTable["ExchangableAwardsList"][j].awardID == ExchangbleAwardsTable["ExchangableAwardsList"][i].awardID) then
						hasNewExchangbleAwards = false
						Common.log("getHaveExchangbleAwards hasNewExchangbleAwards = false ")
						break
					else
						hasNewExchangbleAwards = true
						Common.log("getHaveExchangbleAwards hasNewExchangbleAwards = true ")
					end
				end
				if hasNewExchangbleAwards == true then
					Common.log("getHaveExchangbleAwards hasNewExchangbleAwards = true break")
					break
				end
			end
		else
			Common.log("getHaveExchangbleAwards ExchangableAwardsList == nil false ")
			hasNewExchangbleAwards = false;
		end
	end
	Common.SaveShareTable(newExchangbleTableName,ExchangbleAwardsTable)
	return hasNewExchangbleAwards
end

registerMessage(MANAGERID_GET_PRESENTS, setPrizeTable)
registerMessage(MANAGERID_EXCHANGE_AWARD, setPriceConvertInfo)
registerMessage(MANAGERID_GET_EXCHANGBLE_AWARDS, setExchangbleAwardsInfo)
