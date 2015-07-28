local messageTable = {}

--注册消息
function registerMessage(messageType, logicFunction)
	local functionArray = messageTable[messageType]
	if functionArray == nil then
		functionArray = {logicFunction}
		messageTable[messageType] = functionArray
		if functionArray[1] == nil then
			Common.log("function is nil")
		end
	else
		for i=1,#functionArray do
			if(logicFunction == functionArray[i]) then
				return
			end
		end
		table.insert(functionArray, logicFunction)
	end
end

--移除消息
function removeMessage(messageType, logicFunction)
	local functionArray = messageTable[messageType]
	if functionArray == nil then
		return
	end
	local index = 0
	for i=1, #functionArray do
		if functionArray[i]==logicFunction then
			index = i
			break
		end
	end
	if index>0 then
		table.remove(functionArray, index)
	end
end

function removeMessageByType(messageType)
	local functionArray = messageTable[messageType]
	if functionArray == nil then
		return
	end

	for i = 1, #functionArray do
		table.remove(functionArray, index)
	end

end

--移除所有的注册消息
function removeAllMessage()
	messageTable = {}
end

--得到消息table
function getMessageTable()
	return messageTable
end

------------------------------------------------------------------
--以下为缓存消息相关

--缓存消息
function addBaseMessage(baseMessage, logicKey)
	local messageDictionary = FrameWorkDataPool:getInstance()
	local messageType = baseMessage:getMessageType()
	local messageMap = messageDictionary:objectForKey(logicKey)
	if messageMap == nil then
		messageMap = CCDictionary:create()
		messageMap:setObject(baseMessage, messageType)
		messageDictionary:setObject(messageMap, logicKey)
		return
	else
		messageMap=tolua.cast(messageMap,"CCDictionary")
	end

	messageMap:setObject(baseMessage, messageType)
end

--取出缓存消息
function getBaseMessage(messageType, logicKey)

	local messageDictionary = FrameWorkDataPool:getInstance()
	local messageMap = messageDictionary:objectForKey(logicKey)
	if messageMap == nil then
		return nil
	end

	local dictionary = tolua.cast (messageMap, "CCDictionary")
	local message = dictionary:objectForKey(messageType)

	if message==nil then
		return nil
	else
		local nmBaseMessage = tolua.cast (message, "NMBaseMessage")
		local readFunction  = "read" .. messageType
		local dataTable     = {}
		if _G[readFunction] ~= nil then
			nmBaseMessage:readStart()
			dataTable     = _G[readFunction](nmBaseMessage)
			return dataTable
		else
			Common.log("\nMessageCenter.lua: read function is nil: "..readFunction)
			return nil
		end
	end
end

--移除消息缓存
function removeBaseMessage(logicKey)
	local messageDictionary = FrameWorkDataPool:getInstance()
	local messageMap = messageDictionary:objectForKey(logicKey)
	if messageMap ~= nil then
		messageDictionary:removeObjectForKey(logicKey)
	end
end

--移除所有消息缓存

function removeAllBaseMessage()
	local messageDictionary = FrameWorkDataPool:getInstance()
	--    messageDictionary:removeAllObjects()
end

--消息暂停
function PauseSocket(log)
	if log ~= nil then
		Common.log("PauseSocket....."..log)
	end
	local messageService=Services:getMessageService()
	messageService:pauseSocket();
end
--消息继续
function ResumeSocket(log)
	if log ~= nil then
		Common.log("ResumeSocket....."..log)
	end
	local messageService=Services:getMessageService()
	messageService:resumeSocket();
end
--清空C++层的所有消息
function removeAllSocketMessage()
	Services:getMessageService():removeAllMessage();
end

