module(..., package.seeall)

local MessageTable = {}--用户的信息
local MessageServerTable = {}--系统的信息
local deleteMessage = {}--删除信息
local MessageContentUser = {}--user
local MessageContentServer = {}--server
local emptyMessage = {}--清空信息
local sendMessage = {}--发送信息
local sendToAnyone = {}--发给任何一个人，有昵称
local sayHello = {} --打招呼消息
local systemMessageLisTable = {} --系统站内信消息列表
local SystemReceiveAwardsTable = {} -- 站内信消息领奖
local systemMessageReadTable = {} --站内信已读列表
local CloseMessageTable = {} --屏蔽玩家站内信列表
local SystemMessage_no_ReadCount = 0
local UserMessage_no_ReadCount = 0
local isHallMessage_isRed = false
function readisHallMessage_isRed(dataTable)
	--系统
	isHallMessage_isRed = true
end

function setisHallMessage_isRed()
	isHallMessage_isRed = false
end
function getisHallMessage_isRed()
	--系统
	return isHallMessage_isRed
end

function setUserMessage_no_ReadCount()
	UserMessage_no_ReadCount =  UserMessage_no_ReadCount - 1
end

function setSystemMessage_no_ReadCount()
	SystemMessage_no_ReadCount =  SystemMessage_no_ReadCount - 1
end

function getUserMessage_no_ReadCount()
	return UserMessage_no_ReadCount
end

function getSystemMessage_no_ReadCount()
	return SystemMessage_no_ReadCount
end
--全部的消息，包括系统和个人，现在只要个人的
function setMessageTable(dataTable)
	UserMessage_no_ReadCount = 0
	for z = 1,#dataTable["MessageData"] do
		if 	dataTable["MessageData"][z].UnreadMessageCnt > 0 then
			UserMessage_no_ReadCount = UserMessage_no_ReadCount + 1
		end
	end
	Common.log("messagemodel"..#dataTable["MessageData"])
	MessageTable["MessageList"] = {}
	local hasReadMsgTable ={};--已读消息
	--干掉系统消息
	local j = 1--用户的信息
	for i = 1,  #dataTable["MessageData"] do
		--server消息
		if dataTable["MessageData"][i].IsSysMsg == 1 then
			MessageServerTable = dataTable["MessageData"][i];
		else
			if dataTable["MessageData"][i].UnreadMessageCnt == 0 then
				table.insert(hasReadMsgTable, dataTable["MessageData"][i]);
			else
				--未读消息放在前面，已读消息放在后面
				MessageTable["MessageList"][j] = {};
				MessageTable["MessageList"][j] =  dataTable["MessageData"][i];
				j = j+1
			end
		end
	end

	for i = 1, #hasReadMsgTable do
		--未读消息放在前面，已读消息放在后面
		MessageTable["MessageList"][j] = {};
		MessageTable["MessageList"][j] =  hasReadMsgTable[i];
		j = j+1
	end

	framework.emit(DBID_V2_GET_CONVERSATION_LIST)
end
--获取系统消息列表
function getSystemMessageTable()
	return systemMessageLisTable["SystemMessageList"]
end
--获取系统消息领奖列表
function getMessageReceiveAwardTable()
	return SystemReceiveAwardsTable
end
--获取站内消息阅读列表
function getSystemMessageReadTable()
	return systemMessageReadTable
end

--获取站内信消息
function setSystemMessageTable(dataTable)
	--获取未读消息数量
	SystemMessage_no_ReadCount = 0
	for z = 1,dataTable["messageList_Count"]do
		if 	dataTable["MessageListTable"][z].MessageFlag == 0 then
			SystemMessage_no_ReadCount = SystemMessage_no_ReadCount + 1
		end
	end
	systemMessageLisTable["SystemMessageList"] = {}
	--3.07的系统站内信的时间从早到晚的，为了兼容服务器不改，所以现在的客户端需要把table倒着存
	local j = 1;
	local hasReadMsgTable = {};--已读的消息
	for i = #dataTable["MessageListTable"], 1, -1 do
		if dataTable["MessageListTable"][i].MessageFlag == 0 then
			--未读放在前面，已读放在后面
			systemMessageLisTable["SystemMessageList"][j] = {};
			systemMessageLisTable["SystemMessageList"][j] = dataTable["MessageListTable"][i];
			j = j + 1;
		else
			table.insert(hasReadMsgTable, dataTable["MessageListTable"][i]);
		end
	end

	for i = 1, #hasReadMsgTable do
		--未读消息放在前面，已读消息放在后面
		systemMessageLisTable["SystemMessageList"][j] = {};
		systemMessageLisTable["SystemMessageList"][j] =  hasReadMsgTable[i];
		j = j+1;
	end
	framework.emit(MAIL_SYSTEM_MESSGE_LIST)
end
--获取站内信领奖列表
function setMessageReceiveAwardTable(dataTable)
	SystemReceiveAwardsTable = {}
	SystemReceiveAwardsTable["MessageId"] = dataTable["MessageId"]
	SystemReceiveAwardsTable["Success"] = dataTable["Success"]
	SystemReceiveAwardsTable["Message"] = dataTable["Message"]
	SystemReceiveAwardsTable["MessageReceiveListTable"] = dataTable["MessageReceiveListTable"]
	framework.emit(MAIL_SYSTEM_MESSAGE_RECEIVE_AWARD)
end
function setSystemMessageReadTable(dataTable)
	systemMessageReadTable["MessageId"] = dataTable["MessageId"]
	systemMessageReadTable["Success"] = dataTable["Success"]
	framework.emit(MAIL_SYSTEM_MESSAGE_READ)
end

--获取服务器信息未读的，
function getServernotReadNum()
	return MessageServerTable.UnreadMessageCnt
end

function getMessageTable()
	return MessageTable["MessageList"]
end

--刪除回話
function setDeleteMessage(dataTable)
	deleteMessage["Result"] = dataTable["Result"]
	deleteMessage["ResultTxt"] = dataTable["ResultTxt"]
	framework.emit(DBID_V2_DELETE_CONVERSATION)
end

function getDeleteMessage()
	return deleteMessage
end

--清空回話
function setEmptyMessage(dataTable)
	Common.log("清空回話")
	emptyMessage["Result"] = dataTable["Result"]
	emptyMessage["ResultTxt"] = dataTable["ResultTxt"]
	framework.emit(DBID_V2_EMPTY_CONVERSITION)
end

function getEmptyMessage()
	return emptyMessage
end

--回話內容,现在要分开，server和user分开
function setMessageContent(dataTable)
	if dataTable["ConversationID"] == 0 then
		MessageContentServer["ConversationID"] = dataTable["ConversationID"]
		MessageContentServer["UserInfo"] = dataTable["UserInfo"]
		MessageContentServer["MsessageTable"] = {}

		--倒叙排列对话内容54321 ->  12345
		local NewTable = {}
		NewTable["MsessageTable"] = {}
		local count = #dataTable["MessageTable"]
		for i = 1 ,count  do
			NewTable["MsessageTable"][count+1-i] = dataTable["MessageTable"][i]
		end
		MessageContentServer["MessageTable"] = NewTable["MsessageTable"]
	else
		MessageContentUser["ConversationID"] = dataTable["ConversationID"]
		MessageContentUser["UserInfo"] = dataTable["UserInfo"]
		MessageContentUser["MsessageTable"] = {}

		--倒叙排列对话内容54321 ->  12345
		local NewTable = {}
		NewTable["MsessageTable"] = {}
		local count = #dataTable["MessageTable"]
		for i = 1 ,count  do
			NewTable["MsessageTable"][count+1-i] = dataTable["MessageTable"][i]
		end
		MessageContentUser["MessageTable"] = NewTable["MsessageTable"]
	end
	MessageContentUser["IsShield"] = dataTable["IsShield"]
	framework.emit(DBID_V2_GET_CONVERSATION)
end

--user回话
function getMessageContent()
	return MessageContentUser
end

--server回话
function getMessageContentServer()
	return MessageContentServer
end

--發送會話
function setSendMessage(dataTable)
	sendMessage["Result"] = dataTable["Result"]
	sendMessage["ResultTxt"] = dataTable["ResultTxt"]
	framework.emit(DBID_V2_SEND_MESSAGE)
end

function getSendMessage()
	return sendMessage
end

--发送会话给指定人
function setToAnyone(dataTable)
	sendToAnyone["Result"] = dataTable["Result"]
	sendToAnyone["ResultTxt"] = dataTable["ResultTxt"]
	framework.emit(DBID_V2_SEND_MSG_NICKNAME)
end

function getToAnyone()
	return sendToAnyone
end

--打招呼消息
function setSayhello(dataTable)
	sayHello["Result"] = dataTable["Result"]
	sayHello["Msg"] = dataTable["Msg"]
	framework.emit(DBID_V2_SAY_HELLO)
end

function getSayHello()
	return sayHello
end


function setCloseMsg(dataTable)
	CloseMessageTable = dataTable
	framework.emit(DBID_SHIELD_MAIL_USERID)
end

function getCloseMsg()
	Common.log("aa是否调用得到")
	return CloseMessageTable
end




--站内信消息信号注册
registerMessage(MAIL_UNREAD_SEND, readisHallMessage_isRed)
registerMessage(MAIL_SYSTEM_MESSGE_LIST, setSystemMessageTable)
registerMessage(MAIL_SYSTEM_MESSAGE_RECEIVE_AWARD, setMessageReceiveAwardTable)
registerMessage(MAIL_SYSTEM_MESSAGE_READ, setSystemMessageReadTable)
--
registerMessage(DBID_V2_GET_CONVERSATION_LIST, setMessageTable)
registerMessage(DBID_V2_DELETE_CONVERSATION,setDeleteMessage)
registerMessage(DBID_V2_EMPTY_CONVERSITION, setEmptyMessage)
--
registerMessage(DBID_V2_GET_CONVERSATION, setMessageContent)
registerMessage(DBID_V2_SEND_MESSAGE, setSendMessage)
registerMessage(DBID_V2_SEND_MSG_NICKNAME, setToAnyone)
registerMessage(DBID_V2_SAY_HELLO, setSayhello)
registerMessage(DBID_SHIELD_MAIL_USERID, setCloseMsg) --屏蔽玩家站内信