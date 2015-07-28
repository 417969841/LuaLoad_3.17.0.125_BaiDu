module(..., package.seeall)

local VIPListTable = {}

VIPListTable["TimeStamp"] = 0
VIPListTable["VIPList"] = {}
local VIPListLevelTable = {}

--[[--
--加载本地vip数据
]]
local function loadVipListTable()
	VIPListTable = Common.LoadTable("VIPListTable")
	if VIPListTable == nil then
		VIPListTable = {}
		VIPListTable["TimeStamp"] = 0
		VIPListTable["VIPList"] = {}
	end
end

loadVipListTable()

--[[时间戳]]
function getTimestamp()
	local value = VIPListTable["TimeStamp"]
	if value == nil then
		return 0
	else
		return value
	end
end
function setTimestamp(value)
	VIPListTable["TimeStamp"] = value
end

--加载vip数据
function setVipTable(dataTable)
	if VIPListTable["TimeStamp"] ~= dataTable["timestamp"] then
		VIPListTable["TimeStamp"] = dataTable["timestamp"]
		VIPListTable["VIPList"]  = dataTable["vipTable"]
		Common.SaveTable("VIPListTable", VIPListTable)
		Common.log("VIPppp加载网络")
	else
		Common.log("VIPppp加载本地")
	end
	framework.emit(MANAGERID_VIP_LIST_V3)
end

--加载vip等级数据
function setVipLevelTable(dataTable)
	VIPListLevelTable["VipLevelListTable"] = dataTable["VipLevelListTable"];
	VIPListLevelTable["VipMaxLevel"] = dataTable["VipMaxLevel"];
	framework.emit(MANAGERID_VIP_LEVEL_LIST);
end

--获取vip等级数据
function getVipLevelTable()
	return VIPListLevelTable;
end

function getVipTable()
	return VIPListTable["VIPList"]
end

registerMessage(MANAGERID_VIP_LIST_V3, setVipTable)
registerMessage(MANAGERID_VIP_LEVEL_LIST, setVipLevelTable); --注册vip等级信号