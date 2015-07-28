module(..., package.seeall)

local MinigametypeTable = {}
local Minigame_DuiJiang_Table = {}
Minigame_DuiJiang_Table["nMultipleDetail"] = {}
Minigame_DuiJiang_Table["nMultipleDetail"][1] = {}
Minigame_DuiJiang_Table["nMultipleDetail"][1]["content"] = ""
local Minigame_DuiJiang_Table_V3 = {}
local miniGameGuideInfoTable = {}
--[[--
--获取小游戏列表状态信息
--]]
function getGameTypeInfo()
	--去除不显示的模块
	local itemTable = {}
	for i = 1,#MinigametypeTable do
		if(MinigametypeTable[i].MiniGameState ~= 0) then
			table.insert(itemTable,MinigametypeTable[i])
		end
	end
	return itemTable
end

--[[--
--获取可更新的小游戏列表
--]]
function getCanUpdateMiniGameInfo()
	local itemTable = {}
	for i = 1,#MinigametypeTable do
		if(MinigametypeTable[i].isUpdate == 1) then
			table.insert(itemTable, MinigametypeTable[i])
		end
	end
	return itemTable
end

--[[--
--根据小游戏ID获取脚本升级Url地址
--]]
function getScriptUpdateUrl(MiniGameID)
	for i = 1, #MinigametypeTable do
		if MinigametypeTable[i].MiniGameID == MiniGameID then
			return MinigametypeTable[i].ScriptUpdateUrl;
		end
	end
	return "";
end

--[[--
--根据小游戏ID获取删除文件列表
--]]
function getFileDelListTxtUrlByGameID(MiniGameID)
	for i = 1, #MinigametypeTable do
		if MinigametypeTable[i].MiniGameID == MiniGameID then
			return MinigametypeTable[i].fileDelListTxtUrl;
		end
	end
	return "";
end

function readMANAGERID_MINIGAME_LIST_TYPE_V2(dataTable)
	MinigametypeTable = dataTable.typeList
	framework.emit(MANAGERID_MINIGAME_LIST_TYPE_V2)
end
function readMINI_COMMON_WINNING_RECORD(dataTable)
	Minigame_DuiJiang_Table	 = dataTable
	Common.setDataForSqlite("MINI_COMMON_WINNING_RECORD",Minigame_DuiJiang_Table.timestamp)
	framework.emit(MINI_COMMON_WINNING_RECORD)
end
function getMinigame_DuiJiang_Table()
	if Minigame_DuiJiang_Table~= nil and Minigame_DuiJiang_Table["nMultipleDetail"] ~= nil and Minigame_DuiJiang_Table["nMultipleDetail"][1]["content"] ~= "" then
		return Minigame_DuiJiang_Table["nMultipleDetail"][1].content
	end
end

function setMinigame_DuiJiang_TableNull()
	Minigame_DuiJiang_Table = nil
end

function getMinigame_DuiJiang_TableV2()
	if Minigame_DuiJiang_Table ~= nil and Minigame_DuiJiang_Table["nMultipleDetail"] ~= nil then
		return Minigame_DuiJiang_Table["nMultipleDetail"][1]
	end
end
function readMINI_COMMON_RECOMMEND(dataTable)
	Minigame_DuiJiang_Table_V3	 = dataTable
	framework.emit(MINI_COMMON_RECOMMEND)
end

function getMinigame_DuiJiang_TableV3()
	return Minigame_DuiJiang_Table_V3
end

function readMINI_COMMON_NEWGUIDE(dataTable)
	miniGameGuideInfoTable = dataTable
	framework.emit(MINI_COMMON_NEWGUIDE)
end

function getMiniGameGuideInfoTable()
	return miniGameGuideInfoTable
end

registerMessage(MINI_COMMON_NEWGUIDE, readMINI_COMMON_NEWGUIDE)
registerMessage(MINI_COMMON_RECOMMEND, readMINI_COMMON_RECOMMEND)
registerMessage(MINI_COMMON_WINNING_RECORD, readMINI_COMMON_WINNING_RECORD)
registerMessage(MANAGERID_MINIGAME_LIST_TYPE_V2, readMANAGERID_MINIGAME_LIST_TYPE_V2)
