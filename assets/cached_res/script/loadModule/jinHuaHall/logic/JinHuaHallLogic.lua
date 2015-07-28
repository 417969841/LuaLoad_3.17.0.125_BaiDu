module("JinHuaHallLogic",package.seeall)

view = nil;

panel_bg = nil;--
img_bgleft = nil;--
Panel_16 = nil;--
Button_YuanBao = nil;--
Label_yuanbao = nil;--
--btn_VIPkaitong = nil;--
Label_CoinNum = nil;--
Button_Coin = nil;--
Label_NickName = nil;--
Label_VipLevel = nil;--
Image_Portrait = nil;--
Button_Return = nil;--
Image_logo = nil;--
panel_Hall = nil;--
Button_QuickStart = nil;--
Button_Classic = nil;--
Button_QianWang = nil;--
panel_Classic = nil;--
ScrollView_ClassicList = nil;--
panel_QianWang = nil;--
ScrollView_QianWangList = nil;--

logoPositionY = 0;-- logo的位置Y轴
JinHuaRoomTable = {};--金花房间列表

local MENUID_QUICKSTART = 1;--快速开始
local MENUID_JINGDIAN = 2;--经典场
local MENUID_QIANWANG = 3;--千王场
--房间模式
local MODE_HALL = 0; --大厅模式
local MODE_CLASSIC = 1; --经典模式
local MODE_QIANWANG = 2; --千王模式
--房间类型
local ROOM_TYPE_CLASSIC = 1;--1经典场
local ROOM_TYPE_QIANWANG = 2;--2千王场
--菜单cell的宽高
local MENU_CELL_WIDTH = 230;
local MENU_CELL_HEIGHT = 340;

--[[--
--获取菜单格子的宽
--]]--
function getMenuCellWidth()
	return MENU_CELL_WIDTH;
end

--[[--
--获取菜单格子的高
--]]--
function getMenuCellHeight()
	return MENU_CELL_HEIGHT;
end

--[[--
--返回按钮回调
--]]
local function returnCallBack()
	if GameConfig.getJinHuaHallShowMode() ~= MODE_HALL then
		changeHallView(MODE_HALL)
	else
		sendJHID_QUIT_JH_MINI();
		mvcEngine.createModule(GameConfig.getTheLastBaseLayer());
	end
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		returnCallBack();
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_JINHUAHALL;
	view = cocostudio.createView("load_res/JinHua/JinHuaHall.json");
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
	panel_bg = cocostudio.getUIPanel(view, "panel_bg");
	img_bgleft = cocostudio.getUIImageView(view, "img_bgleft");
	Panel_16 = cocostudio.getUIPanel(view, "Panel_16");
	Button_YuanBao = cocostudio.getUIButton(view, "Button_YuanBao");
	Label_yuanbao = cocostudio.getUILabel(view, "Label_yuanbao");
--	btn_VIPkaitong = cocostudio.getUIButton(view, "btn_VIPkaitong");
--	btn_VIPkaitong:setVisible(false);
	Label_CoinNum = cocostudio.getUILabel(view, "Label_Coin");
	Button_Coin = cocostudio.getUIButton(view, "Button_Coin");
	Label_NickName = cocostudio.getUILabel(view, "Label_NickName");
	Label_VipLevel = cocostudio.getUILabel(view, "Label_VipLevel");
	Image_Portrait = cocostudio.getUIImageView(view, "Image_Portrait");
	Button_Return = cocostudio.getUIButton(view, "Button_Return");
	panel_Hall = cocostudio.getUIPanel(view, "panel_Hall");
	Button_QuickStart = cocostudio.getUIButton(view, "Button_QuickStart");
	Button_Classic = cocostudio.getUIButton(view, "Button_Classic");
	Button_QianWang = cocostudio.getUIButton(view, "Button_QianWang");
	panel_Classic = cocostudio.getUIPanel(view, "panel_Classic");
	ScrollView_ClassicList = cocostudio.getUIScrollView(view, "ScrollView_ClassicList");
	panel_QianWang = cocostudio.getUIPanel(view, "panel_QianWang");
	ScrollView_QianWangList = cocostudio.getUIScrollView(view, "ScrollView_QianWangList");
	Image_logo = cocostudio.getUIImageView(view, "Image_logo");
	Image_Classic = cocostudio.getUIImageView(view, "Image_Classic");
	Image_QianWang = cocostudio.getUIImageView(view, "Image_QianWang");
	Image_logo:setVisible(false);
	Image_Classic:setVisible(false);
	Image_QianWang:setVisible(false);
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	GameConfig.setTheCurrentBaseLayer(GUI_JINHUAHALL)
	sendMANAGERID_JINHUA_USERINFO(profile.User.getSelfUserID());

	initView();
	showVipStatusIcon();
	--	updataJinHuaRoomData();
	changeHallView(GameConfig.getJinHuaHallShowMode());
	--更新用户信息
	updataUserInfo();
	if (profile.User.getSelfUserID() ~= 0) then
		sendDBID_USER_INFO(profile.User.getSelfUserID());
	end
end

--[[--
--改变大厅视图
--@param #number mode 大厅显示模式
--]]
function changeHallView(mode)
	if mode == nil then
		mode = MODE_HALL;
	end
	GameConfig.setJinHuaHallShowMode(mode)

	--切换界面有些按钮要隐藏
	if GameConfig.getJinHuaHallShowMode() == MODE_HALL then
		--进入大厅动画
		enterHallAnimation();
		panel_Hall:setVisible(true);
		panel_Hall:setTouchEnabled(true);
		panel_Classic:setVisible(false);
		panel_Classic:setTouchEnabled(false);
		ScrollView_ClassicList:setTouchEnabled(false);
		ScrollView_ClassicList:removeAllChildren();
		panel_QianWang:setVisible(false);
		panel_QianWang:setTouchEnabled(false);
		ScrollView_QianWangList:setTouchEnabled(false);
		ScrollView_QianWangList:removeAllChildren();
		Image_logo:setVisible(true);
		Image_Classic:setVisible(false);
		Image_QianWang:setVisible(false);
	elseif GameConfig.getJinHuaHallShowMode() == MODE_CLASSIC then
		panel_Hall:setVisible(false);
		panel_Hall:setTouchEnabled(false);
		panel_Classic:setVisible(true);
		panel_Classic:setTouchEnabled(true);
		ScrollView_ClassicList:setTouchEnabled(true);
		panel_QianWang:setVisible(false);
		panel_QianWang:setTouchEnabled(false);
		ScrollView_QianWangList:setTouchEnabled(false);
		Image_logo:setVisible(false);
		Image_Classic:setVisible(true);
		Image_QianWang:setVisible(false);
		updataJinHuaRoomData();
		showRoomList(MODE_CLASSIC, ScrollView_ClassicList);
	elseif GameConfig.getJinHuaHallShowMode() == MODE_QIANWANG then
		panel_Hall:setVisible(false);
		panel_Hall:setTouchEnabled(false);
		panel_Classic:setVisible(false);
		panel_Classic:setTouchEnabled(false);
		ScrollView_ClassicList:setTouchEnabled(false);
		panel_QianWang:setVisible(true);
		panel_QianWang:setTouchEnabled(true);
		ScrollView_QianWangList:setTouchEnabled(true);
		Image_logo:setVisible(false);
		Image_Classic:setVisible(false);
		Image_QianWang:setVisible(true);
		updataJinHuaRoomData();
		showRoomList(MODE_QIANWANG, ScrollView_QianWangList);
	end
end

--[[--
--展示房间列表
--@param #number mode 大厅显示模式
--@param #UIScrollView RoomlistScrollView 滚动控件
--]]
function showRoomList(mode, RoomlistScrollView)
	local roomlength = 0;
	local showrooms = {};
	for i = 1, #JinHuaRoomTable do
		--千王
		if mode == MODE_QIANWANG and JinHuaRoomTable[i].roomType == ROOM_TYPE_QIANWANG then
			roomlength = roomlength + 1;
			showrooms[roomlength] = {};
			showrooms[roomlength] = JinHuaRoomTable[i];
		elseif mode == MODE_CLASSIC and JinHuaRoomTable[i].roomType == ROOM_TYPE_CLASSIC then
			roomlength = roomlength + 1;
			showrooms[roomlength] = {};
			showrooms[roomlength] = JinHuaRoomTable[i];
		end
	end

	local cellSize = 0;
	cellSize = #showrooms;
	local viewW = 0;
	local viewH = 380;
	local viewWMax = 1136;
	local viewX = 0;
	local viewY = 0;

	local cellImageHeight = 206 -- 图片高度
	local spacingW = 52 --横向间隔
	local spacingH = 30 --纵向高度

	local firstElementWidthLeft = 0;--第一个元素距离左侧的距离

	if (cellSize * (MENU_CELL_WIDTH + spacingW) + spacingW) < viewWMax then
		firstElementWidthLeft = (viewWMax - cellSize * (MENU_CELL_WIDTH + spacingW) + spacingW) / 2 ;
		viewW = viewWMax
	else
		firstElementWidthLeft = spacingW;
		viewW = cellSize * (MENU_CELL_WIDTH + spacingW) + spacingW;
	end

	RoomlistScrollView:setSize(CCSizeMake(viewW, viewH))
	RoomlistScrollView:setInnerContainerSize(CCSizeMake(viewW, viewH))
	RoomlistScrollView:setPosition(ccp(0, 0))

	local layoutArray = {}
	for i = 1, cellSize do
		local roomID = showrooms[i].roomID
		local minCoin = showrooms[i].minCoin;--进入房间最小金币
		local maxCoin = showrooms[i].maxCoin;--进入房间最大金币

		--点击回调
		local function clickCallBack()
			--如果本身金币数 大于 房间最大 弹toast
			--如果本身金币数 小于 房间最小 弹充值引导
			local self_coinnum = tonumber(profile.User.getSelfCoin())

			local num =  minCoin -self_coinnum
			if  (tonumber(maxCoin) >= self_coinnum) and  (tonumber(minCoin) <= self_coinnum) then
				--TODO 进入房间逻辑
				sendJHID_ENTER_ROOM(roomID)
			elseif tonumber(maxCoin) < self_coinnum then
				--大于最大，进入高倍房间
				Common.showToast("您的金币数已经大于房间最大金币数，建议您去高倍房间", 2)
			elseif tonumber(minCoin) > self_coinnum then
				--小于最小，弹充值引导
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, num, RechargeGuidePositionID.JinHuaPositionA)
			end
		end

		local layout = MenuLayer.createOneRoomLayer(showrooms[i], clickCallBack);
		layout:setPosition(ccp(firstElementWidthLeft+ MENU_CELL_WIDTH / 2 + (i - 1) * (MENU_CELL_WIDTH + spacingW), spacingH + MENU_CELL_HEIGHT / 2));
		layout:setVisible(false);
		table.insert(layoutArray, layout);
		RoomlistScrollView:addChild(layout)
	end

	local function callbackShowList(index)
		if layoutArray[index] ~= nil then
			layoutArray[index]:setVisible(true);
		end
	end
	LordGamePub.showLandscapeList(layoutArray, callbackShowList);
end

--[[--
--进入大厅动画
--]]
function enterHallAnimation()
	--panel_Hall动画
	local panelHallView = {};

	local function callbackShowBtn(index)
		if panelHallView[index] ~= nil then
			panelHallView[index]:setVisible(true);
		end
	end

	if Button_QuickStart ~= nil then
		Button_QuickStart:setVisible(false);
		table.insert(panelHallView, Button_QuickStart);
	end
	if Button_Classic ~= nil then
		Button_Classic:setVisible(false);
		table.insert(panelHallView, Button_Classic);
	end
	if Button_QianWang ~= nil then
		Button_QianWang:setVisible(false);
		table.insert(panelHallView, Button_QianWang);
	end
	LordGamePub.showLandscapeList(panelHallView, callbackShowBtn);
end

function requestMsg()

end

--更新个人头像
local function updataUserPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		local id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
	if (photoPath ~= nil and photoPath ~= "" and Image_Portrait ~= nil) then
		Image_Portrait:loadTexture(photoPath);
	else
	end
end

--function showVipStatusIcon()
--	if profile.VIPState.getVipStatus() == 4 then
--		--空白
--		btn_VIPkaitong:setVisible(false)
--	elseif profile.VIPState.getVipStatus() == 2 then
--		--优惠
--		if GameConfig.getHallShowMode() == MODE_HALL then
--			btn_VIPkaitong:setVisible(false)
--			GameArmature.showVipSaleArmature(view, 136, -101)
--		end
--	else
--		--1：开通3：续费
--		btn_VIPkaitong:setVisible(true)
--	end
--end

--[[--
--更新用户数据
]]
function updataUserInfo()
	local useravatorIdSD = Common.getDataForSqlite(CommSqliteConfig.SelfAvatorInSD..profile.User.getSelfUserID());
	if useravatorIdSD == nil or useravatorIdSD == "" then
		local photoUrl = profile.User.getSelfPhotoUrl();
		if photoUrl ~= nil then
			Common.getPicFile(photoUrl, 0, true, updataUserPhoto);
		end
	else
		Image_Portrait:loadTexture(useravatorIdSD);
	end
	Label_NickName:setText(profile.User.getSelfNickName());
	Label_CoinNum:setText(profile.User.getSelfCoin());
	Label_yuanbao:setText(profile.User.getSelfYuanBao());
	Label_VipLevel:setText(VIPPub.getUserVipType(math.abs(profile.VIPState.getVipLevel())));
end

--[[--
--返回
--]]
function callback_Button_Return(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		returnCallBack();
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--个人头像
--]]
function callback_Image_Portrait(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_JINHUAUSERINFO);
		JinHuaUserInfoLogic.setSelfUserInfo();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Coin(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local myyuanbao = profile.User.getSelfYuanBao()
		if myyuanbao >= 50 then
			Common.openConvertCoin()
		else
			--充值引导
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
			PayGuidePromptLogic.setEnterType(true)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--function callback_btn_VIPkaitong(component)
--	if component == PUSH_DOWN then
--	--按下
--
--	elseif component == RELEASE_UP then
--		--抬起
--		if profile.VIPState.getVipStatus() == 1 or profile.VIPState.getVipStatus() == 2 then  --开通和优惠状态
--			sendMANAGERID_VIPV2_GET_GIFTBAG(profile.VIPState.getVipStatus(), profile.VIPState.getVipPrice())
--		elseif profile.VIPState.getVipStatus() == 3 then  --续费状态
--			mvcEngine.createModule(GUI_PAYGUIDEPROMPT)
--			PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, profile.VIPState.getVipPrice()*1000 * 0.7, 0)
--		end
--	elseif component == CANCEL_UP then
--	--取消
--
--	end
--end

function callback_Button_YuanBao(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_JINHUAHALL)
		mvcEngine.createModule(GUI_RECHARGE_CENTER,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--快速开始
--]]
function callback_Button_QuickStart(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--TODO 快速开始逻辑
		sendJHID_QUICK_START_REQ() --扎金花快速开始
	elseif component == CANCEL_UP then
	--取消

	end
end


--[[--
--经典场
--]]
function callback_Button_Classic(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if GameConfig.getJinHuaHallShowMode() ~= MODE_CLASSIC then
			changeHallView(MODE_CLASSIC);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--千王场
--]]
function callback_Button_QianWang(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if GameConfig.getJinHuaHallShowMode() ~= MODE_QIANWANG then
			changeHallView(MODE_QIANWANG);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--更新金花房间数据
--]]
function updataJinHuaRoomData()
	JinHuaRoomTable = profile.JinHuaRoomData.getJinHuaRoomTable();
end

--[[--
--获取金花图片path
--@param #String imgName 图片名字
--]]
function getJinHuaImgPath(imgName)
	local sName = "load_res/JinHua/" .. imgName;
	return Common.getResourcePath("load_res/JinHua/" .. imgName);
end

--快速开始应答
function processJHID_QUICK_START()
	Common.closeProgressDialog()
	--	if profile.TableQuickStart.getResultCode() ~= 1 then
	--		Common.showToast(profile.TableQuickStart.getResultText(), 2)
	--		mvcEngine.createModule(GUI_PAYGUIDEPROMPT)
	--		PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, 2000, RechargeGuidePositionID.PatternSelectPosition)
	--	end
end

--牌桌同步
function processJHID_TABLE_SYNC()
	PauseSocket("processJHID_TABLE_SYNC")
	GameConfig.setTheLastBaseLayer(GUI_HALL)
	mvcEngine.createModule(GUI_JINHUA_TABLE)
	--	mvcEngine.createModule(GUI_JINHUA_TABLE,LordGamePub.runSenceAction(JinHuaTableLogic.view,nil,true))
end

function processJHID_ENTER_ROOM()
	local enterRoomACK = profile.JinHuaRoomData.getEnterRoomACK()
	if enterRoomACK then
		if enterRoomACK.result == 0 then
			Common.closeProgressDialog()
			Common.showToast("" .. enterRoomACK.message, 2)
		end
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(DBID_USER_INFO, updataUserInfo)
	framework.addSlot2Signal(JHID_QUICK_START, processJHID_QUICK_START)
	framework.addSlot2Signal(JHID_TABLE_SYNC, processJHID_TABLE_SYNC)
	framework.addSlot2Signal(JHID_ENTER_ROOM, processJHID_ENTER_ROOM)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(DBID_USER_INFO, updataUserInfo)
	framework.removeSlotFromSignal(JHID_QUICK_START, processJHID_QUICK_START)
	framework.removeSlotFromSignal(JHID_TABLE_SYNC, processJHID_TABLE_SYNC)
	framework.removeSlotFromSignal(JHID_ENTER_ROOM, processJHID_ENTER_ROOM)
end
