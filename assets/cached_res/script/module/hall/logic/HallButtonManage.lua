--
--大厅按钮管理类
--
module("HallButtonManage", package.seeall)

local topButtonEntityTable = {};--上部按钮实体table
local midButtonEntityTable = {};--中部按钮实体table
--local changeButtonDataTable = {}

local FIVE_BTN_SHOW = 5;--可见的按钮数为5
local FOUR_BTN_SHOW = 4;--可见的按钮数为4
local THREE_BTN_SHOW = 3;--可见的按钮数为3

--中间的按钮ID(按所有的按钮都开启的顺序排序)
local midBtnIDTable = {
	HallButtonConfig.BTN_ID_CHAT .. "", --聊天
	HallButtonConfig.BTN_ID_LEISURE_GAME .. "", --休闲房间
	HallButtonConfig.BTN_ID_MATCH_GAME .. "", --比赛赢奖
	HallButtonConfig.BTN_ID_PK_GAME .. "", --疯狂闯关
	HallButtonConfig.BTN_ID_LUCKY_GAME .. "" --幸运游戏
};
--上部的按钮ID(按所有的按钮都开启的顺序排序)
local topBtnIDTable = {
	HallButtonConfig.BTN_ID_FREE_COIN .. "", --免费金币
	HallButtonConfig.BTN_ID_ACTIVITY .. "", --活动
	HallButtonConfig.BTN_ID_CAI_SHEN .. "", --财神
	HallButtonConfig.BTN_ID_RECHARGE .. "" --充值
};

--[[--
--根据ID获取对应按钮实体
--@param #number id 按钮ID
--@return #HallButton buttonEntity 按钮ID对应的按钮实例(找不到实体,返回nil)
--]]
function getButtonEntity(id)
	if topButtonEntityTable[id .. ""] == nil and midButtonEntityTable[id .. ""] == nil then
		--打印日志：为了查看buttonEntity是不是为空
		Common.log("HallButtonManage.lua function getButtonEntity(id) is nil value !!! id =" .. id);
		return nil;
	end

	if topButtonEntityTable[id .. ""] ~= nil then
		--如果根据ID找到的实体不为空,返回该实体
		return topButtonEntityTable[id .. ""];
	end
	if midButtonEntityTable[id .. ""] ~= nil then
		--如果根据ID找到的实体不为空,返回该实体
		return midButtonEntityTable[id .. ""];
	end
end

--[[--
--获取大厅按钮装饰动画状态
--@param #number id 按钮ID
--@return #boolean true:装饰动画正在show false:装饰动画不存在或未show
--]]
function getButtonDecorativeAnimStatus(id)
	local buttonEntity = getButtonEntity(id);
	if buttonEntity == nil then
		--如果按钮实体为nil
		return false;
	end

	if buttonEntity:hasDecorativeAnimation() then
		--有装饰动画
		return buttonEntity:getDecorativeAnimStatus();
	else
		--没有装饰动画
		return false;
	end
end

--[[--
--获取大厅按钮的Toast
--@param #number id 按钮ID
--@return #String toast
--]]
function getHallButtonToast(id)
	local buttonEntity = getButtonEntity(id);
	if buttonEntity == nil then
		--如果按钮实体为nil
		return false;
	end

	return buttonEntity:getButtonToast();
end

--[[--
--获取按钮的当前位置
--@param #number id 按钮ID
--]]
function getButtonCurrentPosition(id)
	local buttonEntity = getButtonEntity(id);
	if buttonEntity == nil then
		--如果按钮实体为nil
		return {x = 0, y = 0};
	end

	return buttonEntity:getCurrentPosition();
end

--[[--
--获取大厅中部显示的按钮
--@return #table 显示的按钮table
--]]
function getShowButtonUIOnMiddle()
	local location = 0;
	local showButtonTable = {};
	for key, value in pairs(midButtonEntityTable) do
		location = midButtonEntityTable[key]:getPanelLocation();
		if location ~= -1 then
			--如果当前的位置不等于-1,则说明,该按钮属于显示
			showButtonTable[location] = midButtonEntityTable[key]:getButtonUI();
		end
	end

	return showButtonTable;
end

--[[--
--根据UI获取大厅中部显示的按钮ID
--@param #CCButton ui 按钮UI
--@return #number 按钮ID
--]]
function getShowButtonIDWithUIOnMiddle(ui)
	for key, value in pairs(midButtonEntityTable) do
		if ui == midButtonEntityTable[key]:getButtonUI() then
			return midButtonEntityTable[key]:getButtonID();
		end
	end

	return 0;
end

--[[--
--获取大厅上部显示的按钮数
--@return #number 大厅上部显示的按钮数
--]]
function getShowButtonNumOnTop()
	local topButtonShowNum = 0;
	for key, value in pairs(topButtonEntityTable) do
		if topButtonEntityTable[key] ~= nil then
			if topButtonEntityTable[key]:isButtonShow() then
				--如果当前按钮是显示状态,则topButtonShowNum + 1
				topButtonShowNum = topButtonShowNum + 1;
			end
		end
	end
	return topButtonShowNum;
end

--[[--
--获取大厅中部显示的按钮数
--@return #number 大厅中部显示的按钮数
--]]
function getShowButtonNumOnMiddle()
	local midButtonShowNum = 0;
	for key, value in pairs(midButtonEntityTable) do
		if midButtonEntityTable[key] ~= nil then
			if midButtonEntityTable[key]:isButtonShow() then
				--如果当前按钮是显示状态,则topButtonShowNum + 1
				midButtonShowNum = midButtonShowNum + 1;
			end
		end
	end
	return midButtonShowNum;
end

--[[--
--根据ID将按钮实体存入ButtonEntityTable
--@param #number id 按钮ID
--@param #HallButton buttonEntity 按钮实例
--]]
function setButtonEntity(id, buttonEntity)
	if buttonEntity:getHallLocation() == HallButtonConfig.HALL_LOCATION_TOP then
		--大厅上部按钮
		topButtonEntityTable[id .. ""] = buttonEntity;
	elseif buttonEntity:getHallLocation() == HallButtonConfig.HALL_LOCATION_MID then
		--大厅中部按钮
		midButtonEntityTable[id .. ""] = buttonEntity;
	end
end

--[[--
--设置按钮的状态
--]]
function setButtonEntityStatus()
	local changeButtonDataTable = profile.ButtonsStatus.getChangeButtonDataTable();
	local buttonEntity = nil;--按钮实体
	for i = 1, #changeButtonDataTable do
		--根据ID获取按钮实体
		buttonEntity = getButtonEntity(changeButtonDataTable[i].ButtonID);
		if buttonEntity ~= nil then
			--按钮实体不为空
			buttonEntity:setStatus(changeButtonDataTable[i].ButtonStatus);
			buttonEntity:setButtonToast(changeButtonDataTable[i].OpenConditionMsg);
		end
	end
end

--[[--
--从左到右设置大厅中部(聊天、休闲房间、比赛赢奖、疯狂闯关、幸运游戏)五个按钮当前的位置
--@param #String key midButtonEntityTable的key
--]]
function setMiddleFiveButtonCurrentPosition(key)
	--按钮改变位置,y轴一直保持不变的
	local buttonPositionY = midButtonEntityTable[key]:getCurrentPosition().y;

	if midButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_LEFT then
		--第一位置
		midButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.MID_FOUR_BTN_LEFT_X, buttonPositionY);
	elseif midButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_CENTRE_LEFT then
		--第二位置
		midButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.MID_FOUR_BTN_CENTRE_LEFT_X, buttonPositionY);
	elseif midButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_CENTRE then
		--第三位置
		midButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.MID_FOUR_BTN_CENTRE_X, buttonPositionY);
	elseif midButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_CENTRE_RIGHT then
		--第四位置
		midButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.MID_FOUR_BTN_CENTRE_RIGHT_X, buttonPositionY);
	elseif midButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_RIGHT then
		--第五位置
		midButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.MID_FOUR_BTN_RIGHT_X, buttonPositionY);
	end
end

--[[--
--从左到右设置大厅上部(免费金币、活动、财神、充值)四个按钮当前的位置
--@param #String key topButtonEntityTable的key
--]]
function setTopFourButtonCurrentPosition(key)
	--按钮改变位置,y轴一直保持不变的
	local buttonPositionY = topButtonEntityTable[key]:getCurrentPosition().y;

	if topButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_LEFT then
		--第一位置
		topButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.TOP_FOUR_BTN_LEFT_X, buttonPositionY);
	elseif topButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_CENTRE_LEFT then
		--第二位置
		topButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.TOP_FOUR_BTN_CENTRE_LEFT_X, buttonPositionY);
	elseif topButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_CENTRE then
		--第三位置
		topButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.TOP_FOUR_BTN_CENTRE_X, buttonPositionY);
	elseif topButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_CENTRE_RIGHT then
		--第四位置
		topButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.TOP_FOUR_BTN_CENTRE_RIGHT_X, buttonPositionY);
	end
end

--[[--
--从左到右设置大厅上部(免费金币、活动、充值)三个按钮当前的位置
--@param #String key topButtonEntityTable的key
--]]
function setTopThreeButtonCurrentPosition(key)
	--按钮改变位置,y轴一直保持不变的
	local buttonPositionY = topButtonEntityTable[key]:getCurrentPosition().y;

	if topButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_LEFT then
		--第一位置
		topButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.FREE_COIN_X, buttonPositionY);
	elseif topButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_CENTRE_LEFT then
		--第二位置
		topButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.ACTIVITY_X, buttonPositionY);
	elseif topButtonEntityTable[key]:getPanelLocation() == HallButtonConfig.PANEL_LOCATION_CENTRE then
		--第三位置
		topButtonEntityTable[key]:setCurrentPosition(HallButtonConfig.RECHARGE_X, buttonPositionY);
	end
end

--[[--
--设置上部按钮的当前位置
--]]
function setTopButtonCurrentPosition()
	do return end
	local topButtonShowNum = getShowButtonNumOnTop();
	for key, value in pairs(topButtonEntityTable) do
		if topButtonShowNum == FOUR_BTN_SHOW then
			--大厅上部有可见的按钮数为4
			setTopFourButtonCurrentPosition(key);
		elseif topButtonShowNum == THREE_BTN_SHOW then
			--大厅上部有可见的按钮数为3
			setTopThreeButtonCurrentPosition(key);
		end
	end
end

--[[--
--设置大厅中部按钮的当前位置
--]]
function setMiddleButtonCurrentPosition()
	local midButtonShowNum = getShowButtonNumOnMiddle();
	for key, value in pairs(midButtonEntityTable) do
		setMiddleFiveButtonCurrentPosition(key);
	end
end

--[[--
--大厅按钮是否可用(开启)
--@param #number id 按钮ID
--@return #boolean true:按钮可用(可点击按钮进入) false:按钮实体不存在或不可用
--]]
function isHallButtonAvailable(id)
	local buttonEntity = getButtonEntity(id);
	if buttonEntity == nil then
		--如果按钮实体为nil
		return false;
	end

	return buttonEntity:isButtonAvailable();
end

--[[--
--大厅按钮是否可见
--@param #number id 按钮ID
--@return #boolean true:按钮可见 false:按钮实体不存在或不可见
--]]
function isHallButtonShow(id)
	local buttonEntity = getButtonEntity(id);
	if buttonEntity == nil then
		--如果按钮实体为nil
		return false;
	end

	return buttonEntity:isButtonShow();
end

--[[--
--根据按钮的UI,判断该按钮的是否为半透明
--@param #number buttonID 按钮ID
--@return #boolean 按钮是否为半透明
--]]
function isHallButtonTranslucent(buttonID)
	local buttonEntity = getButtonEntity(buttonID);
	if buttonEntity == nil then
		--如果按钮实体为nil
		return false;
	end

	return buttonEntity:isButtonTranslucent();
end

--[[--
--显示一个按钮骨骼动画
--@param #CCLayer view 大厅的view
--@param #HallButton buttonEntity 按钮实体
--]]
function showOneButttonArmature(view, buttonEntity)
	local button = nil; --ui
	local btnPosition = nil; --按钮位置(相对于view)
	button = buttonEntity:getButtonUI();
	btnPosition = button:getParent():convertToWorldSpace(button:getPosition());

	if buttonEntity ~= nil and buttonEntity:hasDecorativeAnimation() then
		--按钮有装饰动画
		if buttonEntity:isButtonAvailable() then
			--按钮开启,显示装饰动画
			buttonEntity:setDecorativeAnimStatus(true);
			buttonEntity:showDecorativeAnimation(view, btnPosition.x, btnPosition.y);
		else
			--按钮不开启,移除装饰动画
			buttonEntity:setDecorativeAnimStatus(false);
			buttonEntity:removeDecorativeAnimation(view);
		end
	end
end

--[[--
--显示大厅上部按钮骨骼动画(财神)
--@param #CCLayer view 大厅的view
--]]
function showButttonArmatureOnTop(view)
	--当前界面不是大厅,解锁动画正在进行, 抛弃回调消息
	if GameConfig.getHallShowMode() ~= HallLogic.getHallModeValue() or GameConfig.getTheCurrentBaseLayer() ~= GUI_HALL or HallLogic.isUnlockAnimationPlay then
		return;
	end

	for key, value in pairs(topButtonEntityTable) do
		showOneButttonArmature(view, topButtonEntityTable[key])
	end
end

--[[--
--显示大厅中按钮骨骼动画(比赛赢奖、休闲房间、幸运游戏、疯狂闯关)
--@param #CCLayer view 大厅的view
--]]
function showButttonArmatureOnMiddle(view)
	--当前界面不是大厅,解锁动画正在进行, 抛弃回调消息
	if GameConfig.getHallShowMode() ~= HallLogic.getHallModeValue() or GameConfig.getTheCurrentBaseLayer() ~= GUI_HALL or HallLogic.isUnlockAnimationPlay then
		return;
	end

	for key, value in pairs(midButtonEntityTable) do
		showOneButttonArmature(view, midButtonEntityTable[key])
	end
end

--[[--
--从左到右对按钮进行排序
--@param #table btnIDTable 按钮ID table
--@param #table buttonEntityTable 按钮实体table
--]]
function sortButtonFromLeftToRight(btnIDTable, buttonEntityTable)
	local panelLocation = 0;
	local entityKey = "";

	for i = 1, #btnIDTable do
		entityKey = btnIDTable[i];
		if buttonEntityTable[entityKey] ~= nil then
			if buttonEntityTable[entityKey]:isButtonAvailable() then
				panelLocation = panelLocation + 1;
				buttonEntityTable[entityKey]:setPanelLocation(panelLocation);
			end
		end
	end

	for i = 1, #btnIDTable do
		entityKey = btnIDTable[i];
		if buttonEntityTable[entityKey] ~= nil then
			if buttonEntityTable[entityKey]:isButtonTranslucent() then
				panelLocation = panelLocation + 1;
				buttonEntityTable[entityKey]:setPanelLocation(panelLocation);
			end
		end
	end
end


--[[--
--更新上部按钮的状态
--]]
function updateTopButtonStatus()
	for key, value in pairs(topButtonEntityTable) do
		topButtonEntityTable[key]:updateStatus();
	end
end

--[[--
--更新中部按钮的状态
--]]
function updateMiddleButtonStatus()
	for key, value in pairs(midButtonEntityTable) do
		midButtonEntityTable[key]:updateStatus();
	end
end

--[[--
--更新按钮的状态
--]]
function updateButtonStatus()
	local changeButtonDataTable = profile.ButtonsStatus.getChangeButtonDataTable();
	local buttonEntity = nil;--按钮实体
	for i = 1, #changeButtonDataTable do
		--根据ID获取按钮实体
		buttonEntity = getButtonEntity(changeButtonDataTable[i].ButtonID);
		if buttonEntity ~= nil then
			buttonEntity:updateStatus();
		end
	end
end

--[[--
--没有登录过的用户更新大厅按钮数据
--]]
function updateButtonEntityDataWithNoChangeData()
	--更新大厅上部按钮数据
	updateTopButtonStatus();
	--更新大厅中部按钮数据
	updateMiddleButtonStatus();
end

--[[--
--更新大厅Btn数据(修改数据，不修改UI)
--]]
function updateButtonEntityData()
	if profile.ButtonsStatus.hasHallButtonData() then
		--如果有大厅按钮数据(客户端相对于服务器改变的数据、或客户端的本地数据)

		--设置按钮状态
		setButtonEntityStatus();
		--如果大厅上部的按钮数据被改变,则重新排序、设置当前位置
		if profile.ButtonsStatus.hasTopButtonDataBeChange() then
			--从左到右对大厅上部按钮进行排序
			sortButtonFromLeftToRight(topBtnIDTable, topButtonEntityTable);
			--设置大厅上部按钮的当前位置
			setTopButtonCurrentPosition();
		end

		--如果大厅中部的按钮数据被改变,则重新排序、设置当前位置
		if profile.ButtonsStatus.hasMiddleButtonDataBeChange() then
			--从左到右对大厅中部按钮进行排序
			sortButtonFromLeftToRight(midBtnIDTable, midButtonEntityTable);
			--设置大厅中部按钮的当前位置
			setMiddleButtonCurrentPosition();
		end
	end

end

--[[--
--更新按钮状态、位置(修改UI，不修改数据)
--]]
function updateButtonProperty()
	if profile.ButtonsStatus.hasHallButtonData() then
		--如果有大厅按钮数据(客户端相对于服务器改变的数据、或客户端的本地数据)
		--更新按钮状态
		updateButtonStatus();
	else
		--没有改变的按钮数据或本地的数据
		updateButtonEntityDataWithNoChangeData();
	end

	--如果没有改变的数据(该用户刚注册或本地没有该用户的数据)、或有大厅按钮中部的数据更新,都有update位置
	if not profile.ButtonsStatus.hasHallButtonData() or profile.ButtonsStatus.hasMiddleButtonDataBeChange() then
		--更新大厅中部按钮的位置
		for key, value in pairs(midButtonEntityTable) do
			midButtonEntityTable[key]:updatePosition();
		end
	end

	--如果没有改变的数据(该用户刚注册或本地没有该用户的数据)、或有大厅按钮上部的数据更新,都有update位置
	if not profile.ButtonsStatus.hasHallButtonData() or profile.ButtonsStatus.hasTopButtonDataBeChange() then
		--更新大厅上部按钮的位置
		for key, value in pairs(topButtonEntityTable) do
			topButtonEntityTable[key]:updatePosition();
		end
	end
end

--[[--
--交换三个按钮的位置(将比赛赢奖移动到休闲房间后,疯狂闯关和幸运游戏右移)
--@param #number nTime 移动的时间
--]]
function exchangePositionsOfMidThreeBtns(nTime)
	local matchGamePosition = midButtonEntityTable[HallButtonConfig.BTN_ID_MATCH_GAME .. ""]:getCurrentPosition();
	local pkGamePosition = midButtonEntityTable[HallButtonConfig.BTN_ID_PK_GAME .. ""]:getCurrentPosition();
	local luckyGamePosition = midButtonEntityTable[HallButtonConfig.BTN_ID_LUCKY_GAME .. ""]:getCurrentPosition();

	midButtonEntityTable[HallButtonConfig.BTN_ID_MATCH_GAME .. ""]:showButtonMoveAnimation(matchGamePosition.x, matchGamePosition.y, nTime, HallLogic.callBackToShowButton);
	midButtonEntityTable[HallButtonConfig.BTN_ID_PK_GAME .. ""]:showButtonMoveAnimation(pkGamePosition.x, pkGamePosition.y, nTime, nil);
	midButtonEntityTable[HallButtonConfig.BTN_ID_LUCKY_GAME .. ""]:showButtonMoveAnimation(luckyGamePosition.x, luckyGamePosition.y, nTime, nil);
end

--[[--
--移动上部的其他按钮(财神出现,免费金币、活动左移)
--@param #number nTime 移动的时间
--]]
function moveOtherUpperButtons(nTime)
	local caiShenPosition = topButtonEntityTable[HallButtonConfig.BTN_ID_CAI_SHEN .. ""]:getCurrentPosition();
	topButtonEntityTable[HallButtonConfig.BTN_ID_CAI_SHEN .. ""]:showButtonMoveAnimation(caiShenPosition.x, caiShenPosition.y, nTime, HallLogic.callBackToShowButton);

	do return end
	local freeCoinPosition = topButtonEntityTable[HallButtonConfig.BTN_ID_FREE_COIN .. ""]:getCurrentPosition();
	local activityPosition = topButtonEntityTable[HallButtonConfig.BTN_ID_ACTIVITY .. ""]:getCurrentPosition();
	local rechargePosition = topButtonEntityTable[HallButtonConfig.BTN_ID_RECHARGE .. ""]:getCurrentPosition();

	topButtonEntityTable[HallButtonConfig.BTN_ID_FREE_COIN .. ""]:showButtonMoveAnimation(freeCoinPosition.x, freeCoinPosition.y, nTime, nil);
	topButtonEntityTable[HallButtonConfig.BTN_ID_ACTIVITY .. ""]:showButtonMoveAnimation(activityPosition.x, activityPosition.y, nTime, nil);
	topButtonEntityTable[HallButtonConfig.BTN_ID_RECHARGE .. ""]:showButtonMoveAnimation(rechargePosition.x, rechargePosition.y, nTime, nil);
end

--[[--
--清除数据
--]]
function clearData()
	topButtonEntityTable = {};
	midButtonEntityTable = {};
end
