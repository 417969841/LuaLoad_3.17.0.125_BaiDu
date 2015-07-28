module("MassageConnect", package.seeall)

--[[
设置重要消息
0x8020000b 聊天
0x80060002 个人信息
0x80210004 站起
]]
local ImportMessageList = {
	--	0x8020000b,
	--	0x80060002,
	--	0x80210004
	}

local serverListTable = {}

--[[--
--获取ip（debug阶段函数）
--]]
function getServerIpList()
	local ipList = Common.LoadTable("TestServerList")
	if ipList ~= nil and #ipList > 0 then
		serverListTable = ipList;
	end
	return serverListTable;
end

local function setImportMessageList()
	--重要消息列表
	local messageService = Services:getMessageService()
	local importMessageListCount = #ImportMessageList
	for i = 1,importMessageListCount do
		local msgID = ImportMessageList[i]
		--4294967296 = 2的32次方
		--2147483648 = 2的16次方
		if(msgID >= 2147483648) then
			msgID = -4294967296 + msgID
		end
		messageService:setImportMessage(msgID)
	end
end

local function getImportMessageList()
	local importmessagelistnew = {}
	local messageService = Services:getMessageService()
	local importMessageListCount = #ImportMessageList
	for i = 0,importMessageListCount-1 do
		local msgid  = messageService:getImportMessage(i)
		importmessagelistnew[i+1] = msgid
	end
	return importmessagelistnew
end

function reConnect(ip)
	if ip == nil or ip == "" then
		return
	end
	local messageService = Services:getMessageService()
	Common.log("reConnect ServerList === ".. ip)
	serverListTable = {ip}
	Common.SaveTable("TestServerList", serverListTable);
	messageService:removeAllServerIp();
	messageService:init(ip, 65002);
	messageService:closeSocket();
	messageService:reConnect();
end

--[[--
--设置游戏网络连接
--]]
function startConnect()
	--socket
	serverListTable = profile.ServerList.getServerList()
	--	serverListTable = {
	--	--	"10.10.0.120",
	--	--	"10.10.0.119",
	--	--	"10.10.0.28",--懿流
	--	--	"10.10.0.99",--金虎
	--	--	"10.10.0.66",--刘哥
	--	--	"10.10.0.33",--步云
	--	}
--	}

	if not Common.isDebugState() then
		local messageService = Services:getMessageService()

		for i = 1, #serverListTable do
			Common.log("ServerList === ".. serverListTable[i])
			messageService:init(serverListTable[i], 65002)
		end

		messageService:reConnect();
	end

	observeServerMessage()

	--设置不暂停的消息
	--setImportMessageList();
	--getImportMessageList();
end
