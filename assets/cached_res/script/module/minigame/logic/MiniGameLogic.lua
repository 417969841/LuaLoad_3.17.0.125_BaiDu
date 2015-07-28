module("MiniGameLogic",package.seeall)

view = nil;

Panel_20 = nil;--
BackButton = nil;--返回按钮
ImageView_Bg = nil;--背景
Image_GameList = nil;--小游戏列表
MiniGameTable = {};--小游戏信息
MiniGameLayoutList = {};--小游戏layout列表
local CELL_WIDTH = 175;--一个元素的框
local CELL_HEIGHT = 165;--一个元素的高
local cellDistanceWidth = 0;--每个格子宽的距离
local cellDistanceHeight = 0;--每个格子高的距离
local NUM_ROWS = 2;--行数
local NUM_COLUMNS = 4;--列数

local ID_FRUIT_MACHINE = 102;--老虎机GameID
local ID_JIN_HUANG_GUAN = 103;--金皇冠GameID
local ID_WAN_REN_JIN_HUA = 104;--万人金花GameID
local ID_WAN_REN_FRUIT_MACHINE = 105;--万人水果派
local ID_JIN_HUA = 106;--扎金花
local ID_POKER = 107;--德州扑克

local NO_LOCK = 1;--icon是无锁
local HAS_LOCK = 2;--icon上有锁

local function close()
	mvcEngine.destroyModule(GUI_MINIGAME);
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		LordGamePub.closeDialogAmin(ImageView_Bg, close);
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_MINIGAME;
	view = cocostudio.createView("MiniGame.json");
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	BackButton = cocostudio.getUIButton(view, "BackButton");
	ImageView_Bg = cocostudio.getUIImageView(view, "ImageView_Bg");
	Image_GameList = cocostudio.getUIImageView(view, "Image_GameList");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();

	local array = CCArray:create()
	array:addObject(CCCallFuncN:create(function()
		LordGamePub.showDialogAmin(Panel_20, false, nil)
		Common.showProgressDialog("正在加载游戏，请稍后...",nil,nil,false)
		end));
	array:addObject(CCDelayTime:create(0.3))
	array:addObject(CCCallFuncN:create(function()
		sendMANAGERID_MINIGAME_LIST_TYPE_V2(GameLoadModuleConfig.getMiniGameConfigList())
		end));
    local seq = CCSequence:create(array);
    view:runAction(seq);




end

function requestMsg()

end

function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(ImageView_Bg, close);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--点击按钮事件
--]]
function clickButtonEvent(index)
	if(index <= #MiniGameTable and MiniGameTable[index].MiniGameState == NO_LOCK) then
		if(MiniGameTable[index].MiniGameID == ID_FRUIT_MACHINE)then
			--水果机
			if GameLoadModuleConfig.getFruitIsExists() then
				GameConfig.setTheLastBaseLayer(GUI_HALL)
				mvcEngine.createModule(GUI_MINIGAME_FRUIT_MACHINE, LordGamePub.runSenceAction(HallLogic.view,nil,true))
			else
				Common.showToast("资源加载中，请稍候…",2)
			end
		elseif(MiniGameTable[index].MiniGameID == ID_JIN_HUANG_GUAN) then
			--金皇冠
			if GameLoadModuleConfig.getJinHuangGuanIsExists() then
				Common.showProgressDialog("进入房间中,请稍后...");
				GameConfig.setTheLastBaseLayer(GUI_HALL)
				mvcEngine.createModule(GUI_JINHUANGUAN, LordGamePub.runSenceAction(HallLogic.view,nil,true))
			else
				Common.showToast("资源加载中，请稍候…",2)
			end
		elseif(MiniGameTable[index].MiniGameID == ID_WAN_REN_JIN_HUA) then
			--万人金花
			if GameLoadModuleConfig.getWanRenJinHuaIsExists() then
				sendJHROOMID_MINI_JINHUA_ENTER_GAME()
				sendJHGAMEID_MINI_JINHUA_HELP() -- 预先获取万人金花帮助信息
				sendJHGAMEID_MINI_JINHUA_HISTORY() -- 预先获取万人金花历史信息
			else
				Common.showToast("资源加载中，请稍候…",2)
			end
		elseif(MiniGameTable[index].MiniGameID == ID_WAN_REN_FRUIT_MACHINE) then
			--万人水果机
			if GameLoadModuleConfig.getWanRenFruitIsExists() then
				sendWRSGJ_INFO(0) --发送基本信息 INFO
				GameConfig.setTheLastBaseLayer(GUI_HALL)
				mvcEngine.createModule(GUI_WRSGJ, LordGamePub.runSenceAction(HallLogic.view,nil,true))
			else
				Common.showToast("资源加载中，请稍候…",2)
			end
		elseif(MiniGameTable[index].MiniGameID == ID_JIN_HUA) then
			--炸金花
			if GameLoadModuleConfig.getJinHuaIsExists() then
--				sendJHID_ENTER_JH_MINI();--发送进入扎金花大厅消息(服务器不回)
--				sendJINHUA_ROOMID_ROOM_LIST(profile.JinHuaRoomData.getTimeStamp());--发送扎金花房间列表消息
--				GameConfig.setTheLastBaseLayer(GUI_HALL);
--				mvcEngine.createModule(GUI_JINHUAHALL);
				sendJHID_QUICK_START_REQ() --扎金花快速开始
			else
				Common.showToast("资源加载中，请稍候…",2)
			end
		elseif(MiniGameTable[index].MiniGameID == ID_POKER) then
			--德州
			if GameLoadModuleConfig.getPokerIsExists() then
--				GameConfig.setTheLastBaseLayer(GUI_HALL)
--				mvcEngine.createModule(GUI_POKERTABLE)
				sendPOKPLATID_ROOM_QUICKSTART(-1, profile.User.getSelfCoin())
			else
				Common.showToast("资源加载中，请稍候…",2)
			end
		end
	elseif(index <= #MiniGameTable)then
		Common.showToast(MiniGameTable[index].StateMsgTxt, 1)
	elseif(index > #MiniGameTable)then
		Common.showToast("更多精彩，敬请期待", 1);
	end
end

--[[--
--创建layout
--]]
function createMiniGameLayout()
	local miniGameLayout = ccs.image({
		scale9 = false,
		image = Common.getResourcePath("gengduoyouxiIcon.png"),
		size = CCSizeMake(CELL_WIDTH, CELL_HEIGHT),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	miniGameLayout:setScale9Enabled(true);

	return miniGameLayout;
end

--[[--
--创建Button
--]]
function createButton(miniGameLayout, index)
	local button  =  ccs.button({
		scale9 = true,
		size = CCSizeMake(CELL_WIDTH, CELL_HEIGHT),
		pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		text = "",
		capInsets = CCRectMake(0, 0, 0, 0),
		listener = {
			[ccs.TouchEventType.began] = function(uiwidget)
				miniGameLayout:setScale(1.05)
			end,
			[ccs.TouchEventType.moved] = function(uiwidget)
			end,
			[ccs.TouchEventType.ended] = function(uiwidget)
				miniGameLayout:setScale(1);
				clickButtonEvent(index);
			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
				miniGameLayout:setScale(1);
			end,
		}
	});

	return button;
end

--[[--
--初始化小游戏列表
--]]
function initMiniGameList()
	local ViewWidth = 762;--列表的宽
	local ViewHeight = 421;--列表的高
	local distanceLeft = 12; --第一个格子距离左边的宽
	local distanceTop = 30;--第一个格子距离上部的高
	--Image_GameList:setSize(CCSizeMake(ViewWidth, ViewHeight));
	cellDistanceWidth = (ViewWidth - CELL_WIDTH * NUM_COLUMNS) / (NUM_COLUMNS + 1);
	cellDistanceHeight = (ViewHeight - CELL_HEIGHT * NUM_ROWS) / (NUM_ROWS + 1);
	for i =1, 8 do
		--背景
		local miniGameLayout = createMiniGameLayout();
		MiniGameLayoutList[i] = miniGameLayout;
		--按钮
		local button = createButton(miniGameLayout, i);

		local function loadMiniGameIcon(path)
			local photoPath = nil;
			local id = nil;
			if Common.platform == Common.TargetIos then
				photoPath = path["useravatorInApp"]
				id = path["id"]
			elseif Common.platform == Common.TargetAndroid then
				--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
				local i, j = string.find(path, "#")
				id = string.sub(path, 1, i - 1)
				photoPath = string.sub(path, j + 1, -1)
			end
			miniGameLayout:loadTexture(photoPath);
		end

		if i <= #MiniGameTable then
			Common.getPicFile(MiniGameTable[i].MiniGameIconUrl, i, true, loadMiniGameIcon);
			if MiniGameTable[i].MiniGameState == HAS_LOCK then
				--如果有锁,则创建锁精灵
				local lock = ccs.image({
					image = Common.getResourcePath("suo_xiaoyouxi_nor.png"),
				})

				SET_POS(lock, 0,0);
				miniGameLayout:addChild(lock);
			end
		end

		SET_POS(button, 0, 0);
		local layoutX = (cellDistanceWidth + CELL_WIDTH) *( (i -1) % NUM_COLUMNS) + CELL_WIDTH / 2 + distanceLeft;
		local layoutY = ViewHeight - (cellDistanceHeight+CELL_HEIGHT) * math.floor((i -1) / NUM_COLUMNS) - CELL_HEIGHT / 2 - distanceTop;
		SET_POS(miniGameLayout, layoutX, layoutY);
		miniGameLayout:addChild(button);
		Image_GameList:addChild(miniGameLayout);
	end
end

--[[--
--获取小游戏数据
--]]
function getMiniGameData()
	MiniGameTable = profile.MiniGame.getGameTypeInfo();
	Common.closeProgressDialog();
	--初始化小游戏列表
	initMiniGameList();
end

-- 进入万人金花
function enterWanRenJinHuaTable()
	GameConfig.setTheLastBaseLayer(GUI_HALL)
	mvcEngine.createModule(GUI_WANRENJINHUA,LordGamePub.runSenceAction(WanRenJinHuaLogic.view,nil,true))
end

--牌桌同步
function processJHID_TABLE_SYNC()
	PauseSocket("processJHID_TABLE_SYNC")
	GameConfig.setTheLastBaseLayer(GUI_HALL)
	mvcEngine.createModule(GUI_JINHUA_TABLE)
	--	mvcEngine.createModule(GUI_JINHUA_TABLE,LordGamePub.runSenceAction(JinHuaTableLogic.view,nil,true))
end


--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(MANAGERID_MINIGAME_LIST_TYPE_V2, getMiniGameData)--小游戏列表状态消息
	framework.addSlot2Signal(JHGAMEID_MINI_JINHUA_TABLE_SYNC, enterWanRenJinHuaTable)--万人金花牌桌同步
	framework.addSlot2Signal(JHID_TABLE_SYNC, processJHID_TABLE_SYNC)--扎金花牌桌同步
end

function removeSlot()
	framework.removeSlotFromSignal(MANAGERID_MINIGAME_LIST_TYPE_V2, getMiniGameData)
	framework.removeSlotFromSignal(JHGAMEID_MINI_JINHUA_TABLE_SYNC, enterWanRenJinHuaTable)--万人金花牌桌同步
	framework.removeSlotFromSignal(JHID_TABLE_SYNC, processJHID_TABLE_SYNC)--扎金花牌桌同步
end
