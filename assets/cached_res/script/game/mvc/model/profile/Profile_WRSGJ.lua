--
--	万人水果机profile
--

module(..., package.seeall)


local WRSGJInfoTable={}
local WRSGJ_SYNC_MESSAGETable={}
local WRSGJ_NOTICETable={}
local WRSGJ_BETTable={}
local WRSGJ_RADIOTable={}
local WRSGJ_RESULTTable={}
local WRSGJ_POSITIONTable={}
--local WRSGJ_SYNC_MESSAGE_RADIOTable = {}
WRSGJ_SYNC_MESSAGE_RADIOTable = {};







--[[--
----加载本地基本信息
--]]--
local function loadWRSGJ_INFO()

	WRSGJInfoTable = Common.LoadTable("WRSGJInfoTable")
	if WRSGJInfoTable == nil then
		WRSGJInfoTable = {}
		WRSGJInfoTable["Timestamp"] = 0
		WRSGJInfoTable["GameState"] = 0
		WRSGJInfoTable["GoodsList"] = {}
		WRSGJInfoTable["HistoryList"] = {}
		WRSGJInfoTable["Raise"] = {}
		WRSGJInfoTable["BetCoin"] = {}
	end
end

loadWRSGJ_INFO()

--读取万人水果机基本信息(WRSGJ_INFO)
function readWRSGJ_INFO(dataTable)
	if WRSGJInfoTable["Timestamp"] ~= dataTable["Timestamp"] then
		Common.log("zz...重新加载水果派基本信息")
		WRSGJInfoTable=dataTable
		Common.SaveTable("WRSGJInfoTable", WRSGJInfoTable)
	else
		Common.log("zz...使用本地基本信息")
		 WRSGJInfoTable["GameState"] = dataTable["GameState"]
		 WRSGJInfoTable["HistoryList"] = dataTable["HistoryList"]
		 WRSGJInfoTable["Raise"] = dataTable["Raise"]
		 WRSGJInfoTable["BetCoin"] = dataTable["BetCoin"]
	end


	framework.emit(WRSGJ_INFO)
end



local FruitTabel={}
FruitTabel[1]="【苹果】"
FruitTabel[2]="【橙子】"
FruitTabel[3]="【木瓜】"
FruitTabel[4]="【铃铛】"
FruitTabel[5]="【西瓜】"
FruitTabel[6]="【双星】"
FruitTabel[7]="【 7 7 】"
FruitTabel[8]="【 BAR 】"

local isinsert  = false;
--读取水果机同步消息(WRSGJ_SYNC_MESSAGE)
function readWRSGJ_SYNC_MESSAGE(dataTable)
	WRSGJ_SYNC_MESSAGETable=dataTable
	for i=1,#dataTable["XiazhuMSg"] do
	 	table.insert(WRSGJ_SYNC_MESSAGE_RADIOTable, dataTable["XiazhuMSg"][i])
	 end

	framework.emit(WRSGJ_SYNC_MESSAGE)
end

--读取万人水果机公告(WRSGJ_NOTICE）
function readWRSGJ_NOTICE(dataTable)
	WRSGJ_NOTICETable=dataTable
	framework.emit(WRSGJ_NOTICE)
end


--读取万人水果机押注( WRSGJ_BET ）
function readWRSGJ_BET(dataTable)
	WRSGJ_BETTable = dataTable
	framework.emit(WRSGJ_BET)
end


--读取万人水果机下注广播(WRSGJ_RADIO)
function readWRSGJ_RADIO(dataTable)
	dataTable = {}
	--  用户名
	dataTable["username"] = " "
	--  金币数
	dataTable["Coin"] = 10000
	--  押注类型
	dataTable["BetType"] = 1
	WRSGJ_RADIOTable=dataTable
	framework.emit(WRSGJ_RADIO)
end


--读取万人水果机游戏结果(WRSGJ_RESULT)
function readWRSGJ_RESULT(dataTable)
	WRSGJ_RESULTTable=dataTable
	framework.emit(WRSGJ_RESULT)
end


--读取万人水果机转盘起止位置 (WRSGJ_POSITION)
function readWRSGJ_POSITION(dataTable)
	WRSGJ_POSITIONTable=dataTable
	framework.emit(WRSGJ_POSITION)
end




--万人水果机基本信息(WRSGJ_INFO)
function getTableWithWRSGJ_INFO()
	return WRSGJInfoTable
end

--读取水果机同步消息(WRSGJ_SYNC_MESSAGE)
function getTableWithWRSGJ_SYNC_MESSAGE()
	return WRSGJ_SYNC_MESSAGETable
end

function getTableWithWRSGJ_SYNC_MESSAGE_RADIO()
	local MSG = {}
	if #WRSGJ_SYNC_MESSAGE_RADIOTable > 0 then
	 	MSG["name"] =  WRSGJ_SYNC_MESSAGE_RADIOTable[1].username
	 	MSG["type"] = FruitTabel[WRSGJ_SYNC_MESSAGE_RADIOTable[1].betType+1]
	 	MSG["coin"] =WRSGJ_SYNC_MESSAGE_RADIOTable[1].coin .. "金币"
	 	table.remove(WRSGJ_SYNC_MESSAGE_RADIOTable,1)
	end
	return MSG
end

--万人水果机公告(WRSGJ_NOTICE）
function getTableWithWRSGJ_NOTICE()
	return WRSGJ_NOTICETable
end

--万人水果机押注( WRSGJ_BET ）
function getTableWithWRSGJ_BET()
	return WRSGJ_BETTable
end

--万人水果机下注广播(WRSGJ_RADIO)
function getTableWithWRSGJ_RADIO()
	return WRSGJ_RADIOTable
end


--万人水果机游戏结果(WRSGJ_RESULT)
function getTableWithWRSGJ_RESULT()
	return WRSGJ_RESULTTable
end

--万人水果机转盘起止位置 (WRSGJ_POSITION)
function getTableWithWRSGJ_POSITION()
	return WRSGJ_POSITIONTable
end



registerMessage(WRSGJ_INFO , readWRSGJ_INFO);
registerMessage(WRSGJ_SYNC_MESSAGE , readWRSGJ_SYNC_MESSAGE);
registerMessage(WRSGJ_NOTICE , readWRSGJ_NOTICE);
registerMessage(WRSGJ_BET , readWRSGJ_BET);
registerMessage(WRSGJ_RADIO , readWRSGJ_RADIO);
registerMessage(WRSGJ_RESULT , readWRSGJ_RESULT);
registerMessage(WRSGJ_POSITION , readWRSGJ_POSITION);