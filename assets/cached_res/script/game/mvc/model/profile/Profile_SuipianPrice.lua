module(..., package.seeall)

local PrizeSuipianTable = {}
local suipianPrizeHasInit = false
--[[--
--加载碎片兑换奖品列表数据
]]
local function loadPrizeSuipianListTable()
	PrizeSuipianTable = Common.LoadTable("PrizeSuipianList")
	if PrizeSuipianTable == nil then
		PrizeSuipianTable = {}
		PrizeSuipianTable["Timestamp"] = 0
		PrizeSuipianTable["List"] = {}
	end
end

loadPrizeSuipianListTable()

--碎片相关
function setPrizeSuipianTable(dataTable)
	Common.log("碎片相关 === setPrizeSuipianTable ================== ")
	if PrizeSuipianTable["Timestamp"] ~= dataTable["TimeStamp"] then
		Common.log("碎片相关 === Timestamp ================== "..dataTable["TimeStamp"])
		PrizeSuipianTable["Timestamp"] = dataTable["TimeStamp"]
		PrizeSuipianTable["List"] = dataTable["AwardTable"]
		Common.SaveTable("PrizeSuipianList", PrizeSuipianTable)
	end
	suipianPrizeHasInit = true
	framework.emit(MANAGERID_GET_PIECES_SHOP_LIST)
end

function getPrizeSuipianTable()
	return PrizeSuipianTable["List"]

end

function setPrizeSuipianListTimestamp(time)
	PrizeSuipianTable["Timestamp"] = time;
end

function getPrizeSuipianListTimestamp()
	return PrizeSuipianTable["Timestamp"]
end

------------碎片商城
local PriceConvert = {}

PriceConvert["Result"] = 2 -- 2是初始值，0是成功 1是失败
PriceConvert["ResultMsg"] = ""

--[[--
--Result
]]
function getResult()
	local value = PriceConvert["Result"]
	if value == nil then
		return 2
	else
		return value
	end
end

function setResult(result)
	PriceConvert["Result"] = result
end

--[[--
--ResultText
]]
function getResultText()
	local value = PriceConvert["ResultMsg"]
	if value == nil then
		return ""
	else
		return value
	end
end

function getPriceGoodID()
	local value = PriceConvert["GoodID"]
	if value == nil then
		return -1
	else
		return value
	end
end

function setResultText(resultText)
	PriceConvert["ResultMsg"] = resultText
end

function setPriceConvertInfo(dataTable)

	PriceConvert["GoodID"] = dataTable["GoodID"]
	PriceConvert["Result"] = dataTable["Result"]
	PriceConvert["ResultMsg"] = dataTable["ResultMsg"]

	framework.emit(MANAGERID_PIECES_EXCHANGE)
end

function getSuipianPrizeHasData()
	return suipianPrizeHasInit
end

registerMessage(MANAGERID_GET_PIECES_SHOP_LIST, setPrizeSuipianTable)
registerMessage(MANAGERID_PIECES_EXCHANGE, setPriceConvertInfo)