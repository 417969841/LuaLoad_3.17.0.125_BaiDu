module(..., package.seeall)

local JinHuangGuanReadyInfoTable = {}
local JinHuangGuanMESSAGEInfoTable = {}
local JinHuangGuanJHG_START_GAMEInfoTable = {}
local JHG_CHANGE_PAIInfoTable = {}
local JinHuangGuanJHG_RICK_COLLECT_MONEYInfoTable = {}
local JHG_RICK_WINNING_RECORDInfoTable = {}

--获取金皇冠准备信息
function getReadyInfo()
	return JinHuangGuanReadyInfoTable
end

function readJHG_READY_INFO(dataTable)
	JinHuangGuanReadyInfoTable = dataTable
	framework.emit(JHG_READY_INFO)
end

--获取金皇冠滚动信息
function getTableOfMESSAGEInfo()
	return JinHuangGuanMESSAGEInfoTable
end

function readJHG_ROLL_MESSAGE(dataTable)
	JinHuangGuanMESSAGEInfoTable = dataTable
	framework.emit(JHG_ROLL_MESSAGE)
end

--获取金皇冠开始信息
function getTableOfStartInfo()
	return JinHuangGuanJHG_START_GAMEInfoTable
end

function readJHG_START_GAME(dataTable)
	JinHuangGuanJHG_START_GAMEInfoTable = dataTable
	framework.emit(JHG_START_GAME)
end

--金皇冠换牌消息
function getTableOfJHG_CHANGE_PAIInfo()
	return JHG_CHANGE_PAIInfoTable
end

function readJHG_CHANGE_PAI(dataTable)
	JHG_CHANGE_PAIInfoTable = Common.copyTab(dataTable)
	JHG_CHANGE_PAIInfoTable["handselPool"] = {}
	for i = 1, 8 do
		JHG_CHANGE_PAIInfoTable["handselPool"][i] = 0
	end
	for i = 1, #JHG_CHANGE_PAIInfoTable.RiskWinCoinList do
		JHG_CHANGE_PAIInfoTable["handselPool"][JHG_CHANGE_PAIInfoTable["RiskWinCoinList"][i].RiskNum] = JHG_CHANGE_PAIInfoTable["RiskWinCoinList"][i].RiskWinCoinNum
	end
	local num = tonumber(string.sub(JHG_CHANGE_PAIInfoTable["WinTime"], 1, 1))
	JHG_CHANGE_PAIInfoTable["WinTime"] = {}
	JHG_CHANGE_PAIInfoTable["WinTime"][1] = math.random(0, 100)
	JHG_CHANGE_PAIInfoTable["WinTime"][2] = num - JHG_CHANGE_PAIInfoTable["WinTime"][1]
	framework.emit(JHG_CHANGE_PAI)
end

--获取金皇冠比倍收钱信息
function getTableOfJHG_RICK_COLLECT_MONEYInfo()
	return JinHuangGuanJHG_RICK_COLLECT_MONEYInfoTable
end

function readJHG_RICK_COLLECT_MONEY(dataTable)
	JinHuangGuanJHG_RICK_COLLECT_MONEYInfoTable = dataTable
	framework.emit(JHG_RICK_COLLECT_MONEY)
end

--[[--
--获取金皇冠中奖记录信息
--]]
function getTableOfJHG_RICK_WINNING_RECORD()
	return JHG_RICK_WINNING_RECORDInfoTable
end

function readJHG_WINNING_RECORD(dataTable)
	JHG_RICK_WINNING_RECORDInfoTable = dataTable
	framework.emit(JHG_WINNING_RECORD)
end

registerMessage(JHG_READY_INFO, readJHG_READY_INFO)
registerMessage(JHG_ROLL_MESSAGE, readJHG_ROLL_MESSAGE)
registerMessage(JHG_START_GAME, readJHG_START_GAME)
registerMessage(JHG_CHANGE_PAI, readJHG_CHANGE_PAI)
registerMessage(JHG_RICK_COLLECT_MONEY, readJHG_RICK_COLLECT_MONEY)
registerMessage(JHG_WINNING_RECORD, readJHG_WINNING_RECORD)