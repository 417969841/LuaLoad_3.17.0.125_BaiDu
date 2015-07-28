--
-- 大厅按钮状态profile
--
module(..., package.seeall)

--button数据 table
local changeButtonDataTable = {};--改变的按钮数据
local serverButtonDataTable = {};--服务器按钮数据
local clientButtonDataTable = {};--客户端按钮数据
-- local buttonIDTable = {}; --按钮ID
local changeBtnIDTable = {};--改变的按钮ID


--[[--
--加载本地按钮状态数据
]]
local function loadButtonDataTable()
	if clientButtonDataTable == nil or #clientButtonDataTable == 0 then
		--clientButtonDataTable数据为空,读取本地数据(为了减少IO操作)
		clientButtonDataTable = {}
		clientButtonDataTable = Common.LoadTable("clientButtonDataTable_" .. profile.User.getSelfUserID());
		if clientButtonDataTable == nil then
			clientButtonDataTable = {}
		end
	end
end

--[[--
--加载客户端按钮数据
--]]
function loadClientButtonData()
	loadButtonDataTable();
end

--[[--
--获取更改的btn Id Table
--]]
function getChangeBtnIDTable()
	if #changeBtnIDTable >= #serverButtonDataTable then
		--如果改变按钮数等于所有的按钮数,则可能是新用户,不用播更改动画
		changeBtnIDTable = {};
	end
	return changeBtnIDTable;
end

--[[--
--获取大厅button改变状态 table
--]]
function getChangeButtonDataTable()
	if changeButtonDataTable == nil or #changeButtonDataTable == 0 then
		return clientButtonDataTable;
	end
	return changeButtonDataTable;
end

--[[--
--大厅按钮是否可用
--@param #number buttonID 按钮ID
--@return #boolean 是否可用
--]]
function isButtonAvailable(buttonID)
	local flag = false;
	for i = 1, #clientButtonDataTable do
		if buttonID == clientButtonDataTable[i].ButtonID then
			if clientButtonDataTable[i].ButtonStatus == HallButtonConfig.BUTTON_STATUS_OPEN then
				--如果按钮状态为开启,则表示按钮可用
				flag = true;
			end
			break;
		end
	end

	return flag;
end

--[[--
--获取大厅客户端button的Toast
--@param #number buttonID 按钮ID
--]]
function getButtonToast(buttonID)
	for i = 1, #clientButtonDataTable do
		if buttonID == clientButtonDataTable[i].ButtonID then
			return clientButtonDataTable[i].OpenConditionMsg;
		end
	end

	return "";
end

--[[--
--是否有按钮数据
--]]
function hasHallButtonData()
	local buttonData = getChangeButtonDataTable();
	if buttonData == nil or #buttonData == 0 then
		--buttonData为空,则说明该用户没有改变的按钮数据,也没有客户端的数据
		--属于刚注册的用户(或者本地没有该用户的数据)
		return false;
	end

	--如果有服务器相对于客户端改变的按钮数据,或有客户端本地的数据
	return true;
end

--[[--
--是否有大厅上部按钮被改变(相对于按钮的默认状态：即刚用户刚注册时按钮的状态)
--@return #boolean 大厅上部的按钮是否被改变
--]]
function hasTopButtonDataBeChange()
	local flag = false;
	local buttonID = 0;
	local buttonData = getChangeButtonDataTable();
	for i = 1, #buttonData do
		buttonID = buttonData[i].ButtonID;
		--如果改变的按钮数据有财神、活动、充值、免费金币,其中一个,则返回true
		if buttonID == HallButtonConfig.BTN_ID_CAI_SHEN or buttonID == HallButtonConfig.BTN_ID_ACTIVITY
			or buttonID == HallButtonConfig.BTN_ID_RECHARGE or buttonID == HallButtonConfig.BTN_ID_FREE_COIN then

			flag = true;
			break;
		end
	end

	return flag;
end

--[[--
--是否有大厅中部按钮被改变(相对于按钮的默认状态：即刚用户刚注册时按钮的状态)
--@return #boolean 大厅中部的按钮是否被改变
--]]
function hasMiddleButtonDataBeChange()
	local flag = false;
	local buttonID = 0;
	local buttonData = getChangeButtonDataTable();
	for i = 1, #buttonData do
		buttonID = buttonData[i].ButtonID;
		--如果改变的按钮数据有比赛赢奖、休闲房间、幸运游戏、疯狂闯关、聊天,其中一个,则返回true
		if buttonID == HallButtonConfig.BTN_ID_MATCH_GAME or buttonID == HallButtonConfig.BTN_ID_PK_GAME
			or buttonID == HallButtonConfig.BTN_ID_LEISURE_GAME or buttonID == HallButtonConfig.BTN_ID_LUCKY_GAME
			or buttonID == HallButtonConfig.BTN_ID_CHAT then

			flag = true;
			break;
		end
	end

	return flag;
end

--[[--
--改变按钮位置数据
--]]
local function changeButtonPositionData(buttonID, status)
	--更改的按钮为比赛赢奖、财神
	if buttonID == HallButtonConfig.BTN_ID_MATCH_GAME or buttonID == HallButtonConfig.BTN_ID_CAI_SHEN then
		--更改的状态为：开启
		if status ==  HallButtonConfig.BUTTON_STATUS_OPEN then
			table.insert(changeBtnIDTable, 1, buttonID);
		end
	end
end

--[[--
--读取大厅button状态
--@param #table dataTable 按钮数据
--]]
function readMANAGERID_GET_BUTTONS_STATUS(dataTable)
	changeButtonDataTable = {};
	serverButtonDataTable = dataTable["HallButton"];

	if #clientButtonDataTable == #serverButtonDataTable then
		--客户端与服务器控制的按钮数相同
		for i =1 ,  #serverButtonDataTable do
			if clientButtonDataTable[i] ~= nil then
				if clientButtonDataTable[i].ButtonID ~= serverButtonDataTable[i].ButtonID  then
					--相同的下标对应的ID不同（不同的按钮），则数据发生改变
					table.insert(changeButtonDataTable, serverButtonDataTable[i]);
				elseif clientButtonDataTable[i].ButtonStatus ~= serverButtonDataTable[i].ButtonStatus  then
					--相同的按钮，按钮状态不同，则数据已改变
					table.insert(changeButtonDataTable, serverButtonDataTable[i] );
					changeButtonPositionData(serverButtonDataTable[i].ButtonID, serverButtonDataTable[i].ButtonStatus);
				end
			end
		end
	else
		--客户端与服务器控制的按钮数不相同(按钮有增删),则全部是用服务器数据
		changeButtonDataTable = serverButtonDataTable;
	end

	--如果没有改变的数据,则抛弃消息,不分发
	--如果数据已经被改变了,则将server的数据保存在client
	if #changeButtonDataTable > 0 then
		clientButtonDataTable = serverButtonDataTable;
		--改变按钮位置数据
		Common.SaveTable("clientButtonDataTable_" .. profile.User.getSelfUserID(), clientButtonDataTable);
		framework.emit(MANAGERID_GET_BUTTONS_STATUS);
	else
		--如果客户端的按钮数据和服务器的按钮数据相同,则不会分发按钮状态消息, 分发礼包或者绑定手机号通知
		framework.emit(VIP_GIFT_AND_BIND_PHONE_NUMBER);
	end
end

--[[--
--清除数据
--]]
function clearData()
	clientButtonDataTable = {};
	changeButtonDataTable = {};
	serverButtonDataTable = {};
	changeBtnIDTable = {};
end

--[[--
--清除改变按钮的数据
--]]
function clearChangeButtonData()
	changeButtonDataTable = {};
end

--[[--
--清除数据改变的buttonID
--]]
function clearChangeBtnIDData()
	changeBtnIDTable = {};
end

registerMessage(MANAGERID_GET_BUTTONS_STATUS , readMANAGERID_GET_BUTTONS_STATUS);
