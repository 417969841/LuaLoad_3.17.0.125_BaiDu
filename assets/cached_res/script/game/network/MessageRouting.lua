local function messageExecute(nMBaseMessage)
	if nMBaseMessage == nil then
		return
	end

	local messageType = nMBaseMessage:getMessageType()

	if(messageType < 0) then
		messageType = 4294967296 + messageType
	end

	messageType = string.format("%x", messageType)
	Common.log("read message: Type === "..messageType.."   Length === "..nMBaseMessage:getLength())
	local readFunction  = "read" .. messageType

	local dataTable = {}
	if _G[readFunction] ~= nil then
		dataTable = _G[readFunction](nMBaseMessage)
	else
		Common.log("\nMessageRouting.lua: read function is nil: "..readFunction)
		return
	end

	--校验消息合法性
	--	local available = nMBaseMessage:isAvailable()
	--	available = true
	--	if available == false then
	--		Common.log("\nMessageRouting.lua: message data is unavailable, messageType="..messageType)
	--		return;
	--	end

	--调用消息对应的逻辑方法

	local tempMessageType = 0;
	if string.len(messageType) == string.len("80000000") then
		tempMessageType = string.sub(messageType, 2, -1);
	else
		tempMessageType = messageType;
	end

	local messageTable = getMessageTable()
	local messageTypeTo10 = tonumber(tempMessageType, 16)
	local functionArray = messageTable[messageTypeTo10]

	----------统一处理消息----------- “80 01 00 01”

	if functionArray == nil or (#functionArray) == 0 then
		Common.log("\nMessageRouting.lua: no logic function for type="..messageType..", name="..dataTable["messageName"])
		return
	end
	for i = 1, #functionArray do
		if functionArray[i] == nil then
			Common.log("\nMessageRouting.lua: function is nil: "..tostring(functionArray[i]))
		else
			functionArray[i](dataTable)
		end
	end
end

local b_receiveMsg = false

local receiveCount = 0
function setReceiveMsg()
	receiveCount = receiveCount+1
end

function observeServerMessage()
	Common.log("观察服务端消息");
	--观察服务端消息
	local notification = SevTCliNotification:sharedNotification()
	notification:addObserver(messageExecute, "ServerMessage")
end
