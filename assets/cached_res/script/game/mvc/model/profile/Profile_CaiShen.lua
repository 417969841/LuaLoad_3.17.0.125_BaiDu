module(..., package.seeall)

local FORTUNE_GET_INFORMATIONTable = {}--财神界面基本信息
local FORTUNE_TIME_SYNCTable = {}
local FORTUNE_GET_AWARDTable = {}
local FORTUNE_OFFER_SACRIFICETable = {}
local FORTUNE_RELEASE_NOTIFICATIONTable = {}

--[[--
--财神界面基本信息
]]
function getFORTUNE_GET_INFORMATIONTable()
	return FORTUNE_GET_INFORMATIONTable
end

-- 财神界面基本信息(FORTUNE_GET_INFORMATION)
function readFORTUNE_GET_INFORMATION(dataTable)
	FORTUNE_GET_INFORMATIONTable = dataTable
	framework.emit(FORTUNE_GET_INFORMATION)
end

--[[--
-- 财神领奖时间同步
]]
function getFORTUNE_TIME_SYNCTable()
	return FORTUNE_TIME_SYNCTable
end

--  财神领奖时间同步(FORTUNE_TIME_SYNC)
function readFORTUNE_TIME_SYNC(dataTable)
	FORTUNE_TIME_SYNCTable = dataTable
	framework.emit(FORTUNE_TIME_SYNC)
end

--[[--
--财神领奖
]]
function getFORTUNE_GET_AWARDTable()
	return FORTUNE_GET_AWARDTable
end

-- 财神领奖(FORTUNE_GET_AWARD)
function readFORTUNE_GET_AWARD(dataTable)
	FORTUNE_GET_AWARDTable = dataTable
	framework.emit(FORTUNE_GET_AWARD)
end

--[[--
--财神上香
]]
function getFORTUNE_OFFER_SACRIFICETable()
	return FORTUNE_OFFER_SACRIFICETable
end

-- 财神上香(FORTUNE_OFFER_SACRIFICE)
function readFORTUNE_OFFER_SACRIFICE(dataTable)
	FORTUNE_OFFER_SACRIFICETable = dataTable
	framework.emit(FORTUNE_OFFER_SACRIFICE)
end

--[[--
--财神通知
]]
function getFORTUNE_RELEASE_NOTIFICATIONTable()
	return FORTUNE_RELEASE_NOTIFICATIONTable
end

-- 财神通知(FORTUNE_RELEASE_NOTIFICATION)
function readFORTUNE_RELEASE_NOTIFICATION(dataTable)
	FORTUNE_RELEASE_NOTIFICATIONTable = dataTable
	framework.emit(FORTUNE_RELEASE_NOTIFICATION)
end

registerMessage(FORTUNE_GET_INFORMATION, readFORTUNE_GET_INFORMATION)
registerMessage(FORTUNE_TIME_SYNC, readFORTUNE_TIME_SYNC)
registerMessage(FORTUNE_GET_AWARD, readFORTUNE_GET_AWARD)
registerMessage(FORTUNE_OFFER_SACRIFICE, readFORTUNE_OFFER_SACRIFICE)
registerMessage(FORTUNE_RELEASE_NOTIFICATION, readFORTUNE_RELEASE_NOTIFICATION)