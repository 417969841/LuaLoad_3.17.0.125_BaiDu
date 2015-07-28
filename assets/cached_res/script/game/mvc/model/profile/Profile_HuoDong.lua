module(..., package.seeall)

local OPERID_GET_OPER_TASK_LIST_V2Table = {}
local OPERID_GET_OPER_TASK_LISTTable = {}
local OPERID_GODDESS_GET_INFOTable = {}
local OPERID_GODDESS_RESETTable = {}
local OPERID_GODDESS_GET_GIFTTable = {}
local OPERID_FXGZ_GET_INFOTable = {}
local OPERID_FXGZ_PLAYTable = {}
local MonthlyHasData = false
local OperTaskHasData = false


--[[--
--获取活动信息
]]
function getOPERID_GET_OPER_TASK_LIST_V2Table()
	return OPERID_GET_OPER_TASK_LIST_V2Table
end

--[[--
--获取可更新的小游戏列表
--]]
function getCanUpdateOperTaskInfo()
	local itemTable = {}
	for i = 1,#OPERID_GET_OPER_TASK_LIST_V2Table do
		if(OPERID_GET_OPER_TASK_LIST_V2Table[i].isUpdate == 1) then
			table.insert(itemTable, OPERID_GET_OPER_TASK_LIST_V2Table[i])
		end
	end
	return itemTable
end

function getOPERID_GET_OPER_TASK_LISTTable()
	return OPERID_GET_OPER_TASK_LISTTable
end

function getOPERID_GODDESS_GET_INFOTable()
	return OPERID_GODDESS_GET_INFOTable
end

function getOPERID_GODDESS_RESETTable()
	return OPERID_GODDESS_RESETTable
end

function getOPERID_GODDESS_GET_GIFTTable()
	return OPERID_GODDESS_GET_GIFTTable
end

function getOPERID_FXGZ_GET_INFOTable()
	return OPERID_FXGZ_GET_INFOTable
end

function getOPERID_FXGZ_PLAYTable()
	return OPERID_FXGZ_PLAYTable
end

--活动
function readOPERID_GET_OPER_TASK_LIST_V2Table(dataTable)
	OperTaskHasData = true
	OPERID_GET_OPER_TASK_LIST_V2Table = dataTable
	framework.emit(OPERID_GET_OPER_TASK_LIST_V2)
end

--function readOPERID_GET_OPER_TASK_LIST(dataTable)
--	OperTaskHasData = true
--	OPERID_GET_OPER_TASK_LISTTable = dataTable
--	framework.emit(OPERID_GET_OPER_TASK_LIST)
--end

function readOPERID_GODDESS_GET_INFO(dataTable)
	OPERID_GODDESS_GET_INFOTable = dataTable
	framework.emit(OPERID_GODDESS_GET_INFO)
end

function readOPERID_GODDESS_RESET(dataTable)
	OPERID_GODDESS_RESETTable = dataTable
	framework.emit(OPERID_GODDESS_RESET)
end

function readOPERID_GODDESS_GET_GIFT(dataTable)
	OPERID_GODDESS_GET_GIFTTable = dataTable
	framework.emit(OPERID_GODDESS_GET_GIFT)
end

function readOPERID_FXGZ_GET_INFO(dataTable)
	OPERID_FXGZ_GET_INFOTable = dataTable
	framework.emit(OPERID_FXGZ_GET_INFO)
end

function readOPERID_FXGZ_PLAY(dataTable)
	OPERID_FXGZ_PLAYTable = dataTable
	framework.emit(OPERID_FXGZ_PLAY)
end

function getOperTaskHasData()
	return OperTaskHasData
end

function getMonthlyHasData()
	return MonthlyHasData
end

registerMessage(OPERID_GET_OPER_TASK_LIST_V2, readOPERID_GET_OPER_TASK_LIST_V2Table)
--registerMessage(OPERID_GET_OPER_TASK_LIST, readOPERID_GET_OPER_TASK_LIST)
registerMessage(OPERID_GODDESS_GET_INFO, readOPERID_GODDESS_GET_INFO)
registerMessage(OPERID_GODDESS_RESET, readOPERID_GODDESS_RESET)
registerMessage(OPERID_GODDESS_GET_GIFT, readOPERID_GODDESS_GET_GIFT)
registerMessage(OPERID_FXGZ_GET_INFO, readOPERID_FXGZ_GET_INFO)
registerMessage(OPERID_FXGZ_PLAY, readOPERID_FXGZ_PLAY)
