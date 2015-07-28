module(..., package.seeall)

local TTGameOver = {}--天梯游戏结束
local TTListTable = {}--天梯排名
local TTLgz = {} --天梯领工资
local TTJieduanInfo = {}--天体阶段信息
local TianTiHelpTable = {}

local LADDER_DUAN_NAMES = {"青铜","白银","黄金","白金","钻石"};
local LADDER_DUAN_IMAGE = {"ic_gerenziliao_tianti_level_bronze.png",
	"ic_gerenziliao_tianti_level_silver.png",
	"ic_gerenziliao_tianti_level_gold.png",
	"ic_gerenziliao_tianti_level_platinum.png",
	"ic_gerenziliao_tianti_level_jewel.png"};
local LADDER_DUAN_TYPE = {"ui_gerenziliao_tianti_level_qingtong.png",
	"ui_gerenziliao_tianti_level_baiyin.png",
	"ui_gerenziliao_tianti_level_huangjin.png",
	"ui_gerenziliao_tianti_level_baijin.png",
	"ui_gerenziliao_tianti_level_zuanshi.png"};

--[[--
--获得段位名称
--]]
function getDuanWeiName(index)
	return LADDER_DUAN_NAMES[index]
end

--[[--
--获取段位示意图
--]]
function getDuanWeiImage(index)
	if index<1 or index >5 or index == nil then
		index = 1
	end
	return LADDER_DUAN_IMAGE[index]
end

--[[--
--获取段位名称图片
--]]
function getDuanWeiType(index)
	if index<1 or index >5 or index == nil then
		index = 1
	end
	return LADDER_DUAN_TYPE[index]
end

--[[--
--加载天梯排名数据
--]]
function setTTRankTable(dataTable)
	TTListTable = dataTable
	framework.emit(LADDER_TOP)
end

function getTTTable()
	return TTListTable
end

--[[--
--天梯领工资
--]]
function setTTLgz(dataTable)
	TTLgz = dataTable
	framework.emit(LADDER_SALARY)
end
--[[--
--获取天梯领工资数据
--]]
function getTTLgz()
	return TTLgz
end

--[[--
--天梯游戏结束消息（在gameResult消息之后）
--]]
function readLADDER_GAME_OVER(dataTable)
	TTGameOver = dataTable
	framework.emit(LADDER_GAME_OVER)
end

--[[--
--获取天梯游戏结束数据
--]]
function getTTGameOverData()
	return TTGameOver
end

function  readTianTiHelp(dataTable)
	TianTiHelpTable = dataTable
	framework.emit(Ladder_MSG_HELP)
end

function  getTianTiHelp()
	return TianTiHelpTable
end





--天梯阶段信息
function readLADDERID2_LADDER_LEVEL_UP_NOTICE(dataTable)
	TTJieduanInfo = dataTable
	framework.emit(LADDERID2_LADDER_LEVEL_UP_NOTICE)
end

function getLADDERID2_LADDER_LEVEL_UP_NOTICE()
	return TTJieduanInfo
end

registerMessage(LADDER_TOP, setTTRankTable)
registerMessage(LADDER_SALARY, setTTLgz)
registerMessage(LADDER_GAME_OVER, readLADDER_GAME_OVER)
registerMessage(LADDERID2_LADDER_LEVEL_UP_NOTICE, readLADDERID2_LADDER_LEVEL_UP_NOTICE)
registerMessage(Ladder_MSG_HELP, readTianTiHelp)