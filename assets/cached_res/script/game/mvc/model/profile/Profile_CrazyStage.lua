module(..., package.seeall)

local CrazyBaseInfoTable = {} --闯关基本信息
local CrazyStageBeginTable = {} --开始闯关消息
local CrazyStageResultTable = {} --闯关结果
local CrazyStageReceiveAwardTable = {} --闯关领奖
local CrazyStageReliveTable = {} --闯关复活
local CrazyStageResetTable = {} --闯关重置消息
local CrazyStageRankTable = {} --闯关排行榜
local CrazyStageValidateTable = {} --闯关牌桌验证
local CrazyStageYesterdatAwardsTable = {} --闯关昨日奖励信息
local isFirstOpenCrazyStage = nil
local hasNewLuckyTurnChance = false
local CrazyNewLuckyTurnChanceTable = {}
local CrazyStageRankTodayInfoTable = {} --排行榜今日排行信息
isLoadCrazyStageTodayInfoByServer = false --是否是请求服务器获得的今日排行榜数据
DATAUPDATETIME = "DATAUPDATETIME" --存储间隔时间的key

----[[--
----闯关基本信息
--]]
local function loadCashBaseInfoTable()
	CrazyBaseInfoTable = Common.LoadTable("CrazyBaseInfoTable")
	if CrazyBaseInfoTable == nil then
		isFirstOpenCrazyStage = true
	else
		isFirstOpenCrazyStage = false
		if CrazyBaseInfoTable.hasNewLuckyTurnChance ~= nil then
			hasNewLuckyTurnChance = CrazyBaseInfoTable.hasNewLuckyTurnChance
		end
	end

	--判断是否显示闯关页面的幸运摇奖小红点
	CrazyNewLuckyTurnChanceTable = Common.LoadTable("CrazyNewLuckyTurnChanceTable")
	if CrazyNewLuckyTurnChanceTable == nil then
		--Common.log("CrazyNewLuckyTurnChanceTable is nil")
		hasNewLuckyTurnChance = false
	else
		Common.log("CrazyNewLuckyTurnChanceTable not nil")
		if CrazyNewLuckyTurnChanceTable.hasNewLuckyTurnChance ~= nil then
			Common.log("CrazyNewLuckyTurnChanceTable.hasNewLuckyTurnChance not nil")
			hasNewLuckyTurnChance = CrazyNewLuckyTurnChanceTable.hasNewLuckyTurnChance
		else
			Common.log("CrazyNewLuckyTurnChanceTable.hasNewLuckyTurnChance is nil")
			hasNewLuckyTurnChance = false
		end
	end
end

loadCashBaseInfoTable()

--[[--
--闯关排行信息
]]
local function loadCrazyStageRankTable()
	CrazyStageRankTable = Common.LoadTable("CrazyStageRankTable")
	if CrazyStageRankTable == nil then
		CrazyStageRankTable = {}
		CrazyStageRankTable["TimeStamp"] = 0
	end
end

loadCrazyStageRankTable()

function setCrazyBaseInfo(dataTable)
	CrazyBaseInfoTable = dataTable
	Common.SaveTable("CrazyBaseInfoTable", CrazyBaseInfoTable)
	--	if CrazyBaseInfoTable["TimeStamp"] == dataTable["TimeStamp"] then
	--		if dataTable["AwardList"] == nil and Common.LoadTable("CrazyBaseInfoTable") ~= nil then
	--			CrazyBaseInfoTable["AwardList"] = {}
	--			CrazyBaseInfoTable["AwardList"] = Common.LoadTable("CrazyBaseInfoTable")
	--		end
	--	else
	--		Common.SaveTable("CrazyBaseInfoTable", CrazyBaseInfoTable)
	--	end
	framework.emit(OPERID_CRAZY_STAGE_BASE_INFO)
end

--确定是否为失败状态
function getCrazyBaseInfostatus()
	return CrazyBaseInfoTable["status"]
end
--判断是否为
function getCrazyBaseInfofreeReliveCount()
	return CrazyBaseInfoTable["freeReliveCount"]
end
function getCrazyBaseInfo()
	return CrazyBaseInfoTable
end
function getCrazyTimeStamp()
	return CrazyBaseInfoTable["TimeStamp"]
end

function setCrazyStageBegin(dataTable)
	CrazyStageBeginTable = dataTable
	framework.emit(OPERID_CRAZY_STAGE_BEGIN)
end

function getCrazyStageBegin()
	return CrazyStageBeginTable
end

function setCrazyStageResult(dataTable)
	CrazyStageResultTable = dataTable
	framework.emit(OPERID_CRAZY_STAGE_RESULT)
end

function getCrazyStageResultfreeReliveCount()
	return CrazyStageResultTable["freeReliveCount"]
end
function getCrazyStageResult()
	return CrazyStageResultTable
end

function setCrazyStageReceiveAward(dataTable)
	CrazyStageReceiveAwardTable = dataTable
	framework.emit(OPERID_CRAZY_STAGE_RECEIVE_AWARD)
end

function getCrazyStageReceiveAward()
	return CrazyStageReceiveAwardTable
end

function setCrazyStageRelive(dataTable)
	CrazyStageReliveTable = dataTable
	framework.emit(OPERID_CRAZY_STAGE_RELIVE)
end

function getCrazyStageRelive()
	return CrazyStageReliveTable
end

function setCrazyStageReset(dataTable)
	CrazyStageResetTable = dataTable
	framework.emit(OPERID_CRAZY_STAGE_RESET)
end

function getCrazyStageReset()
	return CrazyStageResetTable
end

function setCrazyStageRank(dataTable)
	if CrazyStageRankTable["TimeStamp"] == dataTable["TimeStamp"] then

	else
		CrazyStageRankTable = dataTable
		Common.SaveTable("CrazyStageRankTable", CrazyStageRankTable)
	end
	--	CrazyStageRankTable = dataTable
	framework.emit(OPERID_CRAZY_STAGE_RANK)
end

function getCrazyStageRank()
	return CrazyStageRankTable
end

function getCrazyRankTimeStamp()
	return CrazyStageRankTable["TimeStamp"]
end

function getIsFirstOpenCrazyStage()
	return isFirstOpenCrazyStage
end

function setIsFirstOpenCrazyStage(value)
	isFirstOpenCrazyStage = value
end

function setCrazyStageValidateTable(dataTable)
	CrazyStageValidateTable = dataTable
	framework.emit(OPERID_CRAZY_STAGE_VALIDATE)
end

function getCrazyStageValidateTable()
	return CrazyStageValidateTable
end

function setCrazyStageYesterdatAwardsTable(dataTable)
	CrazyStageYesterdatAwardsTable = dataTable
	framework.emit(OPERID_CRAZY_STAGE_YESTERDAY_AWARDS)
end

function getCrazyStageYesterdatAwardsTable()
	return CrazyStageYesterdatAwardsTable
end

function setHasNewLuckyTurnChance(value)
	hasNewLuckyTurnChance = value
	CrazyNewLuckyTurnChanceTable = Common.LoadTable("CrazyNewLuckyTurnChanceTable")
	if CrazyNewLuckyTurnChanceTable == nil then
		CrazyNewLuckyTurnChanceTable = {}
	end
	CrazyNewLuckyTurnChanceTable.hasNewLuckyTurnChance = value
	Common.SaveTable("CrazyNewLuckyTurnChanceTable", CrazyNewLuckyTurnChanceTable)
end

function getHasNewLuckyTurnChance()
	return hasNewLuckyTurnChance
end

--[[--
--设置排行榜今日排行榜数据
--]]
function setCrazyTodayInfo(dataTable)
	CrazyStageRankTodayInfoTable = dataTable
--	if CrazyStageRankTodayInfoTable ~= nil then
--		Common.log("setCrazyTodayInfo======")
--		Common.SaveTable("CrazyStageRankTodayInfoTable", CrazyStageRankTodayInfoTable)
--	end
	local nowStamp = Common.getServerTime()
	Common.setDataForSqlite(DATAUPDATETIME, nowStamp);
	isLoadCrazyStageTodayInfoByServer = false
	framework.emit(OPERID_CRAZY_STAGE_TODAY_RANK)
end

--[[--
--获得今日排行榜数据
--]]
function getCrazyStageRankTodayInfo()
--	if not isLoadCrazyStageTodayInfoByServer then
--		CrazyStageRankTodayInfoTable = Common.LoadTable("CrazyStageRankTodayInfoTable")
--	end
	return CrazyStageRankTodayInfoTable
end


registerMessage(OPERID_CRAZY_STAGE_TODAY_RANK, setCrazyTodayInfo)
registerMessage(OPERID_CRAZY_STAGE_BASE_INFO, setCrazyBaseInfo)
registerMessage(OPERID_CRAZY_STAGE_BEGIN, setCrazyStageBegin)
registerMessage(OPERID_CRAZY_STAGE_RESULT, setCrazyStageResult)
registerMessage(OPERID_CRAZY_STAGE_RECEIVE_AWARD, setCrazyStageReceiveAward)
registerMessage(OPERID_CRAZY_STAGE_RELIVE, setCrazyStageRelive)
registerMessage(OPERID_CRAZY_STAGE_RESET, setCrazyStageReset)
registerMessage(OPERID_CRAZY_STAGE_RANK, setCrazyStageRank)
registerMessage(OPERID_CRAZY_STAGE_VALIDATE, setCrazyStageValidateTable)
registerMessage(OPERID_CRAZY_STAGE_YESTERDAY_AWARDS, setCrazyStageYesterdatAwardsTable)