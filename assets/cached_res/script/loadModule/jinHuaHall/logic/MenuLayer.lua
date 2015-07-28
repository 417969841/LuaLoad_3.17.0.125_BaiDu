--
--金花大厅房间信息Layout
--Layout中元素 ：Layout, 按钮、背景图、进入进入条件、底注、消耗金币
--
module("MenuLayer",package.seeall);

--[[--
--创建一个房间信息
--@param #table roomInfo 房间信息
--@param #Function callBack 点击按钮的回调事件
--]]
function createOneRoomLayer(roomInfo, callBack)
	local layout = createLayout();
	local button = createButton(callBack, layout);
	local BgSprite = createBgSprite(roomInfo.roomPic);
	local ConditionSprite = createConditionSprite(roomInfo.roomCoinImg);
	local AntesLabel =createAntesLabel(roomInfo.betMinCoin .. "金币底注");
	local ConsumeLabel = createConsumeLabel("每局消耗" .. roomInfo.tableFee .. "金币");

	layout:setScale9Enabled(true);
	button:setScale9Enabled(true);
	button:setZOrder(3);
	SET_POS(button, 0, 0);
	SET_POS(BgSprite, 0, 0);
	SET_POS(ConditionSprite,  0, 93 - JinHuaHallLogic.getMenuCellHeight() / 2);
	SET_POS(AntesLabel,  0, 55 - JinHuaHallLogic.getMenuCellHeight() / 2);
	SET_POS(ConsumeLabel, 0,  3 - JinHuaHallLogic.getMenuCellHeight() / 2);

	layout:addChild(button);
	layout:addChild(BgSprite);
	layout:addChild(ConditionSprite);
	layout:addChild(AntesLabel);
	layout:addChild(ConsumeLabel);

	return layout;
end

--[[--
--创建一个Layout
--]]
function createLayout()
	local Layout = ccs.image({
		scale9 = true,
		image = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		size = CCSizeMake(JinHuaHallLogic.getMenuCellWidth(), JinHuaHallLogic.getMenuCellHeight()),
		capInsets = CCRectMake(0, 0, 0, 0),
	})

	return Layout;
end

--[[--
--创建一个Button
--@param #Function callBack 点击按钮的回调事件
--]]
function createButton(callBack, layout)
	local Button = ccs.button({
		scale9 = true,
		size = CCSizeMake(JinHuaHallLogic.getMenuCellWidth(), JinHuaHallLogic.getMenuCellHeight()),
		pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		text = "",
		capInsets = CCRectMake(0, 0, 0, 0),
		listener = {
			[ccs.TouchEventType.began] = function(uiwidget)
				layout:setScale(1.05)
			end,
			[ccs.TouchEventType.moved] = function(uiwidget)
			end,
			[ccs.TouchEventType.ended] = function(uiwidget)
				layout:setScale(1);
				callBack();
			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
				layout:setScale(1);
			end,
		}
	});
	return Button;
end

--[[--
--创建房间实体背景
--@param #String url 图片URL
--]]
function createBgSprite(url)
	local BgSprite = ccs.image({
		scale9 = true,
		image = Common.getResourcePath("px1.png"),
		size = CCSizeMake(JinHuaHallLogic.getMenuCellWidth(), JinHuaHallLogic.getMenuCellHeight()),
	})

	local function updataBgSprite(path)
		local photoPath = nil
		local id = nil
		if Common.platform == Common.TargetIos then
			photoPath = path["useravatorInApp"]
			id = path["id"]
		elseif Common.platform == Common.TargetAndroid then
			local i, j = string.find(path, "#")
			id = string.sub(path, 1, i-1)
			photoPath = string.sub(path, j+1, -1)
		end
		BgSprite:loadTexture(photoPath);
	end

	Common.getPicFile(url, 0, true, updataBgSprite);
	return BgSprite;
end

--[[--
--创建进入条件精灵
--@param #String url 图片URL
--]]
function createConditionSprite(url)
	local ConditionSprite = ccs.image({
		scale9 = false,
		image = Common.getResourcePath("px1.png"),
	})

	local function updataConditionSprit(path)
		local photoPath = nil
		local id = nil
		if Common.platform == Common.TargetIos then
			photoPath = path["useravatorInApp"]
			id = path["id"]
		elseif Common.platform == Common.TargetAndroid then
			local i, j = string.find(path, "#")
			id = string.sub(path, 1, i-1)
			photoPath = string.sub(path, j+1, -1)
		end
		ConditionSprite:loadTexture(photoPath);
	end

	Common.getPicFile(url, 1, true, updataConditionSprit);

	return ConditionSprite;
end

--[[--
--创建底注label
--@param #String txt label文字
--]]
function createAntesLabel(txt)
	local AntesLabel =  ccs.label({
		text = txt,
		color = ccc3(255, 230, 132),--色值黄色
		fontSize = 25,
	})
	return AntesLabel;
end

--[[--
--创建消耗金币label
--@param #String txt label文字
--]]
function createConsumeLabel(txt)
	local ConsumeLabel =  ccs.label({
		text = txt,
		fontSize = 25,
		color = ccc3(123, 164, 74),
	})
	return ConsumeLabel;
end
