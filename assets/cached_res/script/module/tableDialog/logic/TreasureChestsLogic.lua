module("TreasureChestsLogic",package.seeall)

view = nil;

Panel_20 = nil;--
ImageView_bg = nil;--
Panel_box3 = nil;--
iv_box_prize3 = nil;--
Label_box_prize3 = nil;--
Panel_box2 = nil;--
iv_box_prize2 = nil;--
Label_box_prize2 = nil;--
Panel_box1 = nil;--
iv_box_prize1 = nil;--
Label_box_prize1 = nil;--
iv_box_num = nil;--
btn_close = nil;--
box3 = nil;--
box1 = nil;--
box2 = nil;--
--iv_light3 = nil;--
--iv_light2 = nil;--
--iv_light1 = nil;--
AtlasLabel_VIPLevel = nil;--VIP等级数
Label_NotVip2Tips = nil;--不是Vip2及以上的提示
Label_Vip2Tips = nil;--Vip2及以上的提示
ImageView_Title = nil;

BoxImageList = {};--宝箱图片
PanelBoxList = {};--宝箱奖励Panel
IvBoxPrizeList = {};--奖励图片
LabelBoxPrizeList = {};--奖励文字
TreasureChestsList = {};--宝箱列表数据
--iv_lightList = {};--奖品背景
preReadNewUserPrizeTable = {}; --新手预读奖励
TreasureChestPrize = {};--宝盒奖励
hasChooseBoxState = {}; --新手引导宝箱的状态
noChooseBoxPositon = {}; --新手引导没有选中的宝盒下标
local BOX_OPEN_STATE = 1;

isShowView = false;--当前界面是否显示

selectPosition = 0;--选择的位置
local FIRST_TIME_OPEN = 1;--新手第一次打开宝盒
local SECOND_TIME_OPEN = 2;--新手第二次打开宝盒
local NO_OPEN_BOX = 0;--没打开的宝盒
remainOpenBoxTime = 0;--新手引导剩余开宝盒数

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	ImageView_bg = cocostudio.getUIImageView(view, "ImageView_bg");
	Panel_box3 = cocostudio.getUIPanel(view, "Panel_box3");
	iv_box_prize3 = cocostudio.getUIImageView(view, "iv_box_prize3");
	Label_box_prize3 = cocostudio.getUILabel(view, "Label_box_prize3");
	Panel_box2 = cocostudio.getUIPanel(view, "Panel_box2");
	iv_box_prize2 = cocostudio.getUIImageView(view, "iv_box_prize2");
	Label_box_prize2 = cocostudio.getUILabel(view, "Label_box_prize2");
	Panel_box1 = cocostudio.getUIPanel(view, "Panel_box1");
	iv_box_prize1 = cocostudio.getUIImageView(view, "iv_box_prize1");
	Label_box_prize1 = cocostudio.getUILabel(view, "Label_box_prize1");
	iv_box_num = cocostudio.getUIImageView(view, "iv_box_num");
	btn_close = cocostudio.getUIButton(view, "btn_close");
	box3 = cocostudio.getUIImageView(view, "box3");
	box2 = cocostudio.getUIImageView(view, "box2");
	box1 = cocostudio.getUIImageView(view, "box1");
	--	iv_light3 = cocostudio.getUIImageView(view, "iv_light3");
	--	iv_light2 = cocostudio.getUIImageView(view, "iv_light2");
	--	iv_light1 = cocostudio.getUIImageView(view, "iv_light1");
	AtlasLabel_VIPLevel = cocostudio.getUILabelAtlas(view, "AtlasLabel_VIPLevel");
	Label_Vip2Tips = cocostudio.getUILabel(view, "Label_Vip2Tips");
	Label_NotVip2Tips = cocostudio.getUILabel(view, "Label_NotVip2Tips");
	ImageView_Title = cocostudio.getUIImageView(view, "ImageView_Title");
end

--[[--
--获取新手宝盒奖品预读信息
--]]
local function getPreReadNewUserPrize()
	--已经完成新手引导,则return
	if CommDialogConfig.getNewUserGiudeFinish() then
		return;
	end

	preReadNewUserPrizeTable  = profile.TreasureChests.getPreReadNewUserPrizeTable();
	if preReadNewUserPrizeTable == nil then
		sendOPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD();
		return;
	end

	remainOpenBoxTime = profile.TreasureChests.getPreReadNewUserOpenBoxTimes();
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("TreasureChests.json")
	local gui = GUI_TREASURE_CHESTS
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

--[[--
--初始化界面数据
--]]
function initViewData()
	local vipLevel = VIPPub.getUserVipType(profile.User.getSelfVipLevel());
	if vipLevel < 2 then
		--	上面文字： 请您选择1个宝箱
		--下面文字： VIP2及以上可以领取2个宝箱
		Label_Vip2Tips:setVisible(false);
		Label_NotVip2Tips:setVisible(true);
		AtlasLabel_VIPLevel:setStringValue(2);
		iv_box_num:loadTexture(Common.getResourcePath("ui_1bx.png"));
		ImageView_Title:loadTexture(Common.getResourcePath("ui_choosebx.png"));
	else
		--VIP2及以上玩家：
		--上面文字： 请您选择第1个宝箱，请您选择第2个宝箱(切换是数字2图要放大缩小一下)
		--下面文字： 您是VIPX，每次可以领取2个宝箱！
		Label_Vip2Tips:setVisible(true);
		Label_NotVip2Tips:setVisible(false);
		AtlasLabel_VIPLevel:setStringValue(vipLevel);
		if profile.TreasureChests.IsSecondOpenTime() then
			--第二次打开宝盒
			iv_box_num:loadTexture(Common.getResourcePath("ui_1bx.png"));
			ImageView_Title:loadTexture(Common.getResourcePath("ui_choosebx_vip.png"));
		else
			iv_box_num:loadTexture(Common.getResourcePath("ui_2bx.png"));
			ImageView_Title:loadTexture(Common.getResourcePath("ui_choosebx.png"));
		end
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);

	initView();
	--初始化界面数据
	initViewData();
	--获取新手宝盒奖品预读信息
	getPreReadNewUserPrize();

	Panel_box1:setVisible(false)
	Panel_box2:setVisible(false)
	Panel_box3:setVisible(false)
	LordGamePub.showDialogAmin(Panel_20);

	table.insert(BoxImageList, box1);
	table.insert(BoxImageList, box2);
	table.insert(BoxImageList, box3);
	table.insert(PanelBoxList, Panel_box1);
	table.insert(PanelBoxList, Panel_box2);
	table.insert(PanelBoxList, Panel_box3);
	table.insert(IvBoxPrizeList, iv_box_prize1);
	table.insert(IvBoxPrizeList, iv_box_prize2);
	table.insert(IvBoxPrizeList, iv_box_prize3);
	table.insert(LabelBoxPrizeList, Label_box_prize1);
	table.insert(LabelBoxPrizeList, Label_box_prize2);
	table.insert(LabelBoxPrizeList, Label_box_prize3);
	--	table.insert(iv_lightList, iv_light1);
	--	table.insert(iv_lightList, iv_light2);
	--	table.insert(iv_lightList, iv_light3);

	--设置
	if TableConsole.RoomLevel == 0 then
		box1:loadTexture(Common.getResourcePath("ic_activity_baoxiang_mu.png"))
		box2:loadTexture(Common.getResourcePath("ic_activity_baoxiang_mu.png"))
		box3:loadTexture(Common.getResourcePath("ic_activity_baoxiang_mu.png"))
	elseif TableConsole.RoomLevel == 1 then
		box1:loadTexture(Common.getResourcePath("ic_activity_baoxiang_tie.png"))
		box2:loadTexture(Common.getResourcePath("ic_activity_baoxiang_tie.png"))
		box3:loadTexture(Common.getResourcePath("ic_activity_baoxiang_tie.png"))
	elseif TableConsole.RoomLevel == 2 then
		box1:loadTexture(Common.getResourcePath("ic_activity_baoxiang_jin.png"))
		box2:loadTexture(Common.getResourcePath("ic_activity_baoxiang_jin.png"))
		box3:loadTexture(Common.getResourcePath("ic_activity_baoxiang_jin.png"))
	elseif TableConsole.RoomLevel == 3 then
		box1:loadTexture(Common.getResourcePath("ic_activity_baoxiang_zuanshi.png"))
		box2:loadTexture(Common.getResourcePath("ic_activity_baoxiang_zuanshi.png"))
		box3:loadTexture(Common.getResourcePath("ic_activity_baoxiang_zuanshi.png"))
	else
		box1:loadTexture(Common.getResourcePath("ic_activity_baoxiang_zuanshi.png"))
		box2:loadTexture(Common.getResourcePath("ic_activity_baoxiang_zuanshi.png"))
		box3:loadTexture(Common.getResourcePath("ic_activity_baoxiang_zuanshi.png"))
	end

	LordGamePub.showShakeAnimate(box1)
	LordGamePub.showShakeAnimate(box2)
	LordGamePub.showShakeAnimate(box3)

	--	--自己的VIP等级
	--	local myVipNumber = VIPPub.getUserVipType(profile.User.getSelfVipLevel())
	--	if myVipNumber >= 2 then
	--		iv_box_num:loadTexture(Common.getResourcePath("ui_2bx.png"))
	--	else
	--		iv_box_num:loadTexture(Common.getResourcePath("ui_1bx.png"))
	--	end

	isShowView = true;
end

function requestMsg()

end

local function updataPrizeUrl(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and IvBoxPrizeList[tonumber(id)] ~= nil then
		IvBoxPrizeList[tonumber(id)]:loadTexture(photoPath)
	end
end

--[[--
--更新奖励列表信息
--]]
function updataPrizeListData()
	TreasureChestsList = profile.TreasureChests.getTreasureChestsList()
	for i = 1, #TreasureChestsList["TreasureBoxList"] do
		--…Position	byte	宝盒编号（从左至右0，1，2）
		local pos = TreasureChestsList["TreasureBoxList"][i].Position;
		--…state	byte		0：未打开 1：已打开
		local state = TreasureChestsList["TreasureBoxList"][i].state;
		--…description	Text	宝盒奖品描述	未打开的宝盒数据传空字符串
		local description = TreasureChestsList["TreasureBoxList"][i].description;
		--…PrizeUrl	Text	宝盒奖品图片	未打开的宝盒数据传空字符串
		local PrizeUrl = TreasureChestsList["TreasureBoxList"][i].PrizeUrl;
		if state == 0 then
			--0：未打开
			BoxImageList[pos + 1]:setVisible(true);
			PanelBoxList[pos + 1]:setVisible(false);
		else
			-- 1：已打开
			BoxImageList[pos + 1]:setVisible(false);
			PanelBoxList[pos + 1]:setVisible(true);
			LabelBoxPrizeList[pos + 1]:setText(description);
			--			iv_lightList[pos + 1]:runAction(CCRepeatForever:create(CCRotateBy:create(5,360)));
			if PrizeUrl ~= nil and  PrizeUrl ~= ""  then
				LordGamePub.downloadImageForNative(PrizeUrl, (pos + 1), true, updataPrizeUrl)
			end
		end
	end
end

local function exit_CallBack()
	mvcEngine.destroyModule(GUI_TREASURE_CHESTS)
end

function callback_box3(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--box3:stopAllActions();
		selectPosition = 2
		sendBAOHE_V4_GET_PRIZE(TableConsole.m_nRoomID, selectPosition);
		--显示新手引导的宝盒奖励
		showNewUserGuidePrize(selectPosition);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_box2(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--box2:stopAllActions();
		selectPosition = 1
		sendBAOHE_V4_GET_PRIZE(TableConsole.m_nRoomID, selectPosition);
		--显示新手引导的宝盒奖励
		showNewUserGuidePrize(selectPosition);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_box1(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--box1:stopAllActions();
		selectPosition = 0
		sendBAOHE_V4_GET_PRIZE(TableConsole.m_nRoomID, selectPosition);
		--显示新手引导的宝盒奖励
		showNewUserGuidePrize(selectPosition);
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Panel_20(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起er
		if(NewUserGuideLogic.getNewUserFlag())then
		else
			LordGamePub.closeDialogAmin(Panel_20, exit_CallBack);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--@param #type NewUserShow 关闭当前界面
--@param #type TableConsole.showNewUserGuide 发送领奖消息
--]]
local function NewUserShow()
	exit_CallBack();
	TableConsole.showNewUserGuide();
end

--[[--
--显示不选中宝盒奖品
--@param #number pos 宝盒的位置
--@param #String PrizeUrl 物品图片url
--@param #String description 物品描述
--]]
local function showOtherBoxPrize(pos, PrizeUrl, description)
	--保底方案：控件不存在, return
	if PanelBoxList[pos] == nil or LabelBoxPrizeList[pos] == nil or BoxImageList[pos] == nil then
		return;
	end

	local isTransmit = false;
	if description ~= nil and description ~= "" and  PrizeUrl ~= nil and  PrizeUrl ~= ""  then
		PanelBoxList[pos]:setVisible(true);
		--		iv_lightList[pos]:setVisible(false);
		BoxImageList[pos]:setTouchEnabled(false);
		LabelBoxPrizeList[pos]:setText(description);
		LordGamePub.downloadImageForNative(PrizeUrl, (pos), true, updataPrizeUrl)
		if not isTransmit then
			isTransmit = true;
			if (NewUserGuideLogic.getNewUserFlag() == true and NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_TWO_TABLE_2_BAOXIANG) then
				--新手引导
				LordGamePub.showOtherBoxPrizeAnimate(BoxImageList[pos], PanelBoxList[pos], NewUserShow, 0.5);
			else
				LordGamePub.showOtherBoxPrizeAnimate(BoxImageList[pos], PanelBoxList[pos], exit_CallBack, 1);
			end
		else
			LordGamePub.showOtherBoxPrizeAnimate(BoxImageList[pos], PanelBoxList[pos], nil, 0);
		end
	end
end

--[[--
--没有选中的宝盒position
--]]
local function setNoChooseBoxPosition()
	for i = 1, #IvBoxPrizeList do
		if hasChooseBoxState[i] == nil or hasChooseBoxState[i] ~= BOX_OPEN_STATE then
			table.insert(noChooseBoxPositon, i);
		end
	end
end

--[[--
--新手引导显示其他的宝盒
--]]
local function showOtherBoxForNewUser()
	--没有选中的宝盒position
	setNoChooseBoxPosition();
	for i = 1, #preReadNewUserPrizeTable do

		--…description	Text	宝盒奖品描述	未打开的宝盒数据传空字符串
		local description = preReadNewUserPrizeTable[i].TreasureDiscription;
		--…PrizeUrl	Text	宝盒奖品图片	未打开的宝盒数据传空字符串
		local PrizeUrl = preReadNewUserPrizeTable[i].TreasurePicUrl;
		--显示未打开的宝盒奖品
		showOtherBoxPrize(noChooseBoxPositon[i], PrizeUrl, description);
	end
end

--[[--
--不是新手引导显示其他的宝盒
--]]
local function showOtherBoxForOldUser()
	for i = 1, #TreasureChestPrize["TreasureBoxList"] do
		--…Position	byte	宝盒编号（从左至右0，1，2）
		local pos = TreasureChestPrize["TreasureBoxList"][i].Position;
		local state = TreasureChestPrize["TreasureBoxList"][i].state;
		--…description	Text	宝盒奖品描述	未打开的宝盒数据传空字符串
		local description = TreasureChestPrize["TreasureBoxList"][i].description;
		--…PrizeUrl	Text	宝盒奖品图片	未打开的宝盒数据传空字符串
		local PrizeUrl = TreasureChestPrize["TreasureBoxList"][i].PrizeUrl;

		if state == 1 then
		-- 1：已打开
		elseif state == 0 then
			-- 1：未打开
			--显示不选择的宝盒
			showOtherBoxPrize(pos + 1 , PrizeUrl, description)
		end
	end
end

--[[--
--显示其他宝盒(不中奖的宝盒)
--]]
local function showOthersBox()
	local function callBack()
		if CommDialogConfig.getNewUserGiudeFinish() then
			showOtherBoxForOldUser();
		else
			--新手引导
			showOtherBoxForNewUser();
		end
	end

	local array = CCArray:create();
	array:addObject(CCDelayTime:create(0.5));
	array:addObject(CCCallFunc:create(callBack));
	if view ~= nil then
		view:runAction(CCSequence:create(array));
	end
end

--第二次开宝盒提示
local function theSecondTipOpenTreasureChests()
	iv_box_num:loadTexture(Common.getResourcePath("ui_1bx.png"));
	ImageView_Title:loadTexture(Common.getResourcePath("ui_choosebx_vip.png"));
	local fadeIn = CCFadeIn:create(0.2);
	local scaleBig = CCScaleTo:create(0.5, 1.3);
	local scaleSmall = CCScaleTo:create(0.5, 1);
	local arr = CCArray:create();
	arr:addObject(fadeIn);
	arr:addObject(scaleBig);
	arr:addObject(scaleSmall);
	local seq = CCSequence:create(arr);
	iv_box_num:runAction(seq);
end

--[[--
--显示选中宝盒奖品
--@param #number index 宝盒的位置
--@param #String PicUrl 物品图片url
--@param #String Discription 物品描述
--@param #number Multiple 奖品倍数
--@param #number Count 最终奖品数目
--]]
local function showChooseBoxPrize(index, PicUrl, Discription, Multiple,Count)
	--保底方案：控件不存在, return
	if PanelBoxList[index] == nil or LabelBoxPrizeList[index] == nil or BoxImageList[index] == nil then
		return;
	end
	PanelBoxList[index]:setVisible(true);
	LabelBoxPrizeList[index]:setText(Discription);
	BoxImageList[index]:setTouchEnabled(false);
	--iv_lightList[index]:runAction(CCRepeatForever:create(CCRotateBy:create(5,360)));

	if PicUrl ~= nil and PicUrl ~= "" then
		LordGamePub.downloadImageForNative(PicUrl, (index), true, updataPrizeUrl)
	end

	local function showToast()
		if Multiple > 0 then
			ImageToast.createView(PicUrl, nil, Discription, "恭喜您获取" .. Multiple .. "倍宝盒奖励", 2);
		else
			ImageToast.createView(PicUrl, nil, Discription, "恭喜您获取宝盒奖励", 2);
		end

		if CommDialogConfig.getNewUserGiudeFinish()  then
			--已完成新手引导
			if profile.TreasureChests.IsSecondOpenTime() or profile.TreasureChests.getOpenCountMax() == 1 then
				--如果不是第二次打开宝盒或者最多能打开一次宝盒
				ImageToast.OverFunction = showOthersBox;
			else
				profile.TreasureChests.setTreasureChestsState(index);
				--可以打开第一个宝盒
				theSecondTipOpenTreasureChests();
			end
		else
			--未完成新手引导
			if  remainOpenBoxTime == 0 then
				--开宝盒次数为0
				ImageToast.OverFunction = showOthersBox;
			else
				--如果剩余宝盒数不为0,则显示打开第二个
				theSecondTipOpenTreasureChests();
			end
		end

	end

	LordGamePub.showBoxPrizeAnimate(BoxImageList[index], PanelBoxList[index], showToast);
end

--[[--
--显示新手引导的宝盒奖励
--@param #number selectPos 宝盒下标
--]]
function showNewUserGuidePrize(selectPos)
	if NewUserGuideLogic.getNewUserFlag() == false or NewUserCoverOtherLogic.getTaskState() ~= NewUserCoverOtherLogic.getDataTable().TASK_TWO_TABLE_2_BAOXIANG  then
		return;
	end
	if remainOpenBoxTime == 0 then
		return;
	end

	--预读消息：服务器发的数据,中奖的在前面,不中奖的在后面
	--…TreasurePicUrl  物品图片url
	local PicUrl = preReadNewUserPrizeTable[1].TreasurePicUrl;
	--…TreasureDiscription  物品描述
	local Discription = preReadNewUserPrizeTable[1].TreasureDiscription;
	--…Multiple  奖品倍数
	local Multiple = preReadNewUserPrizeTable[1].Multiple;
	--…lastTreasureCount  最终奖品数目
	local Count = preReadNewUserPrizeTable[1].LastTreasureCount;

	remainOpenBoxTime = remainOpenBoxTime - 1;

	--显示选中宝盒奖品
	showChooseBoxPrize(selectPos + 1, PicUrl, Discription, Multiple,Count)
	table.remove(preReadNewUserPrizeTable, 1);
	table.insert(hasChooseBoxState, selectPos + 1, BOX_OPEN_STATE);
end

--[[--
--获取宝盒奖励
--]]
local function TableBaoHeGetTreasure()
	--如果是新手引导,则已经使用了预读数据,抛弃服务端数据
	if CommDialogConfig.getNewUserGiudeFinish() == false then
		return;
	end

	TreasureChestPrize = profile.TreasureChests.getTreasureChestsPrize()
	--Result  1 成功 0 失败
	if (TreasureChestPrize["Result"] == 0) then
		TableElementLayer.UpdataBaoXiangData()
		Common.showToast(TreasureChestPrize["ResultMsg"], 2)
		return;
	end

	local index = TreasureChestPrize["Position"];
	if index == nil then
		index = selectPosition;
	end

	for i = 1, #TreasureChestPrize["TreasurePrizeList"] do--
		--…TreasurePicUrl  物品图片url
		local PicUrl = TreasureChestPrize["TreasurePrizeList"][i].TreasurePicUrl;
		--…TreasureDiscription  物品描述
		local Discription = TreasureChestPrize["TreasurePrizeList"][i].TreasureDiscription;
		--…Multiple  奖品倍数
		local Multiple = TreasureChestPrize["TreasurePrizeList"][i].Multiple;
		--…lastTreasureCount  最终奖品数目
		local Count = TreasureChestPrize["TreasurePrizeList"][i].lastTreasureCount;

		--显示选中宝盒奖品(index + 1, 客户端下标从1开始,服务端从0开始)
		showChooseBoxPrize(index + 1, PicUrl, Discription, Multiple, Count);
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	TableElementLayer.UpdataBaoXiangData()
end

function addSlot()
	framework.addSlot2Signal(BAOHE_V4_GET_PRIZE, TableBaoHeGetTreasure)
	framework.addSlot2Signal(OPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD, getPreReadNewUserPrize)
end

function removeSlot()
	framework.removeSlotFromSignal(BAOHE_V4_GET_PRIZE, TableBaoHeGetTreasure)
	framework.removeSlotFromSignal(OPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD, getPreReadNewUserPrize)
end
