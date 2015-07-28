module(..., package.seeall)

local ShuiGuoJiReadyInfoTable = {}
local ShuiGuoJiTableOfWinInfoTable = {}
local ShuiGuoJiMESSAGEInfoTable = {}
local ShuiGuoJiPRIZEInfoTable = {}
local ShuiGuoJiCOLLECT_MONEYInfoTable = {}
local ShuiGuoJiSLOT_RICK_WINNING_RECORD = {}
--[[
--获取老虎机准备信息
--]]
function getReadyInfo()
	return ShuiGuoJiReadyInfoTable
end

function readSLOT_READY_INFO(dataTable)
	ShuiGuoJiReadyInfoTable = dataTable

	framework.emit(SLOT_READY_INFO)
end

--[[
--获取老虎机奖金表信息
--]]
function getTableOfWinInfo()
	return ShuiGuoJiTableOfWinInfoTable
end

function readSLOT_PRIZE_LIST(dataTable)
	ShuiGuoJiTableOfWinInfoTable = dataTable
	framework.emit(SLOT_PRIZE_LIST)
end

--[[
--获取老虎机滚动信息
--]]
function getTableOfMESSAGEInfo()
	return ShuiGuoJiMESSAGEInfoTable
end

function readSLOT_ROLL_MESSAGE(dataTable)
	ShuiGuoJiMESSAGEInfoTable = dataTable
	framework.emit(SLOT_ROLL_MESSAGE)
end

--[[
--获取老虎机领奖信息
--]]
function getTableOfPRIZEInfo()
	return ShuiGuoJiPRIZEInfoTable
end
--[[--
	此处将老虎机领奖信息copy
--]]
function readSLOT_ACCEPT_THE_PRIZE(dataTable)

	ShuiGuoJiPRIZEInfoTable = Common.copyTab(dataTable)
	ShuiGuoJiPRIZEInfoTable["handselPool"] = {}
	for i = 1, 8 do
		ShuiGuoJiPRIZEInfoTable["handselPool"][i] = 0
	end
	for i = 1, #ShuiGuoJiPRIZEInfoTable["RiskWinCoinList"]do
		ShuiGuoJiPRIZEInfoTable["handselPool"][ShuiGuoJiPRIZEInfoTable["RiskWinCoinList"][i].RiskNum] = ShuiGuoJiPRIZEInfoTable["RiskWinCoinList"][i].RiskWinCoinNum
	end
	local num = tonumber(string.sub(ShuiGuoJiPRIZEInfoTable["WinTime"], 1, 1))
	ShuiGuoJiPRIZEInfoTable["WinTime"] = {}
	ShuiGuoJiPRIZEInfoTable["WinTime"][1] = math.random(0, 100)
	ShuiGuoJiPRIZEInfoTable["WinTime"][2] = num - ShuiGuoJiPRIZEInfoTable["WinTime"][1]
	framework.emit(SLOT_ACCEPT_THE_PRIZE)
end

--[[
--获取老虎机比倍收钱信息
--]]
function getTableOfCOLLECT_MONEYInfo()
	return ShuiGuoJiCOLLECT_MONEYInfoTable
end

function readSLOT_RICK_COLLECT_MONEY(dataTable)
	ShuiGuoJiCOLLECT_MONEYInfoTable = dataTable
	framework.emit(SLOT_RICK_COLLECT_MONEY)
end


--[[--
--]]
function getTableOfSLOT_RICK_WINNING_RECORD()
	return ShuiGuoJiSLOT_RICK_WINNING_RECORD
end

function readSLOT_RICK_WINNING_RECORD(dataTable)
	ShuiGuoJiSLOT_RICK_WINNING_RECORD = dataTable
	framework.emit(SLOT_RICK_WINNING_RECORD)
end

registerMessage(SLOT_READY_INFO, readSLOT_READY_INFO)
registerMessage(SLOT_PRIZE_LIST, readSLOT_PRIZE_LIST)
registerMessage(SLOT_ROLL_MESSAGE, readSLOT_ROLL_MESSAGE)
registerMessage(SLOT_ACCEPT_THE_PRIZE, readSLOT_ACCEPT_THE_PRIZE)
registerMessage(SLOT_RICK_COLLECT_MONEY, readSLOT_RICK_COLLECT_MONEY)
registerMessage(SLOT_RICK_WINNING_RECORD, readSLOT_RICK_WINNING_RECORD)