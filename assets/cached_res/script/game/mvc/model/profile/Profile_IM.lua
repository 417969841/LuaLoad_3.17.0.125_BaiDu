module(..., package.seeall)

local lastChatText -- 最新聊天信息
local userChatTable -- 用户发言信息
local IMID_OPERATE_CHAT_USER_TYPETable--取得屏蔽消息
local IMID_CHAT_ROOM_SEND_REWARD_V3Table = nil --小游戏领取打赏V3TableInfo
local IMID_MINI_GET_REWARDS_V3Table = nil --小游戏领取打赏提示

function getIMID_OPERATE_CHAT_USER_TYPETable()
	return IMID_OPERATE_CHAT_USER_TYPETable
end

function getLastChatText()
	return lastChatText
end

function getUserChatTable()
	return userChatTable
end

function getIMID_MINI_GET_REWARDS_V3Table()
	return IMID_MINI_GET_REWARDS_V3Table
end

function getIMID_CHAT_ROOM_SEND_REWARD_V3Table()
	if IMID_CHAT_ROOM_SEND_REWARD_V3Table ~= nil and IMID_CHAT_ROOM_SEND_REWARD_V3Table ~= "" then
		Common.log("readUserChatTable========"..IMID_CHAT_ROOM_SEND_REWARD_V3Table.SpeechText)
	end
	return IMID_CHAT_ROOM_SEND_REWARD_V3Table
end

--function readLastChatText(dataTable)
--	lastChatText = dataTable["SpeechText"]
--	framework.emit(IMID_GET_LAST_CHAT_ROOM_SPEAK)
--end

function readUserChatTable(dataTable)
	userChatTable = dataTable
	Common.log("readUserChatTable====================2")
	if userChatTable.CheckCode ~= nil and userChatTable.CheckCode ~= "" then
		Common.log("readUserChatTable====================1")
		IMID_CHAT_ROOM_SEND_REWARD_V3Table = dataTable
	end
	framework.emit(IMID_CHAT_ROOM_SPEAK)
end

function readIMID_OPERATE_CHAT_USER_TYPE(dataTable)
	IMID_OPERATE_CHAT_USER_TYPETable = dataTable
	framework.emit(IMID_OPERATE_CHAT_USER_TYPE)
end

function readIMID_CHAT_ROOM_SEND_REWARD_V3(dataTable)
	IMID_CHAT_ROOM_SEND_REWARD_V3Table = dataTable
	framework.emit(IMID_CHAT_ROOM_SEND_REWARD_V3)
end

function readIMID_MINI_GET_REWARDS_V3(dataTable)
	IMID_MINI_GET_REWARDS_V3Table = dataTable
	framework.emit(IMID_MINI_GET_REWARDS_V3)
end

function setIMID_CHAT_ROOM_SEND_REWARD_V3TableNull()
	IMID_CHAT_ROOM_SEND_REWARD_V3Table = nil
end

--registerMessage(IMID_GET_LAST_CHAT_ROOM_SPEAK, readLastChatText)
registerMessage(IMID_CHAT_ROOM_SPEAK, readUserChatTable)
registerMessage(IMID_OPERATE_CHAT_USER_TYPE, readIMID_OPERATE_CHAT_USER_TYPE)
registerMessage(IMID_CHAT_ROOM_SEND_REWARD_V3, readUserChatTable)
registerMessage(IMID_MINI_GET_REWARDS_V3, readIMID_MINI_GET_REWARDS_V3)