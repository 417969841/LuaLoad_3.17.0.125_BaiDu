module(..., package.seeall)

--服务器地址数据更新

local ServerListEnableTable = {}--可用的服务器地址
local ServerListDisableTable = {}--废弃的服务器地址

local ServerList = {
	"58.68.246.35",
	"58.68.246.36",
	"58.68.246.42"
}

function getServerList()

	ServerListEnableTable = Common.LoadTable("EnableServerList")
	ServerListDisableTable = Common.LoadTable("DisableServerList")

	Common.log("初始ServerList num === ".. #ServerList)

	if ServerListEnableTable ~= nil and #ServerListEnableTable > 0 then
		for i = 1, #ServerListEnableTable do
			local isHave = false
			for j = 1, #ServerList do
				--重复的IP不再添加
				if ServerListEnableTable[i].EnableServerIP == ServerList[j] then
					Common.log("添加Ip === break"..ServerListEnableTable[i].EnableServerIP)
					isHave = true
					break
				end
			end
			if isHave == false then
				Common.log("添加Ip === "..ServerListEnableTable[i].EnableServerIP)
				table.insert(ServerList, ServerListEnableTable[i].EnableServerIP)
			end
		end
	end

	if ServerListDisableTable ~= nil and #ServerListDisableTable > 0 then
		for i = 1, #ServerListDisableTable do
			for j = 1, #ServerList do
				if ServerListDisableTable[i].DisableServerIP == ServerList[j] then
					Common.log("删除Ip === "..ServerList[j])
					ServerList[j] = nil
					break
				end
			end
		end
	end

	return ServerList
end

--[[-- 解析服务器列表]]
function readDBID_SERVER_LIST(dataTable)
	--EnableServerCnt  可用的服务器数量
	local EnableTable = dataTable["EnableServerTable"]
	Common.SaveTable("EnableServerList", EnableTable)
	--DisableServerCnt  停用的服务器数量
	local DisableTable = dataTable["DisableServerTable"]
	Common.SaveTable("DisableServerList", DisableTable)
end