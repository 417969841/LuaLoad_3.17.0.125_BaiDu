module("FreeCoinLogic",package.seeall)

view = nil;

Panel_hall_freecoin = nil;--免费金币panel
ImageView_FreeCoin = nil;--免费金币imageView
sv_ranking = nil;--滚动层
Button_close = nil;--关闭按钮
rankingSize = nil;--滚动层的size
lookForwardButton = nil; --敬请期待button
lookForwardSprite = nil; --敬请期待精灵
lightSprite = nil; --发光图片
btnGanTanHao = nil;--感叹号(红点)
bindPhoneBtnGanTanHao = nil; --绑定手机感叹号
taskBtnGanTanHao = nil; --任务感叹号

freeCoinInfoTable = {};--免费金币详情table
freeCoinModuleUITable = {};--免费金币模块UI table
loadLocalDataIndexTable = {}; --需要加载本地数据的index
scrollSizeHeight = 0;--滚动层的高

--模块View 数据
local PANEL_WIDTH = 757;--模块panel的宽
local PANEL_HEIGHT = 120;--模块panel的高
local ICON_X = 80; --icon的X轴
local ICON_Y = 50; --icon的Y轴
local TITLE_X = 170;--标题的X轴
local TITLE_Y  = 85; --标题的Y轴
local INTRO_X = 170;--简介的X轴
local INTRO_Y = 36;--简介的Y轴
local BTN_X = 670;--按钮的X轴
local BTN_Y = 50;--按钮的Y轴
local BTN_WIDTH = 170;--按钮的宽
local BTN_HEIGHT = 70;--按钮的高
local TANHAO_X = 40;--按钮的X
local TANHAO_Y = 20;--按钮的Y
local PANEL_DISTANCE = 5;--panel的距离
local	LIGHT_SPRITE_Y = -160; --发光图的Y

--ZOrder
local ZOrderLow = 1
local ZOrderHigh = 2

local TITLE_SCALE = 1.5;--标题的放大的倍数

--[[--
--关闭弹出框
--]]
local function closeTheBox()
	mvcEngine.destroyModule(GUI_FREECOIN);
end

--[[--
--界面关闭动画
--]]
local function thisLayerCloseAmin()
	LordGamePub.closeDialogAmin(ImageView_FreeCoin,closeTheBox);
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		thisLayerCloseAmin();
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_hall_freecoin = cocostudio.getUIPanel(view, "Panel_hall_freecoin");
	ImageView_FreeCoin = cocostudio.getUIImageView(view, "ImageView_FreeCoin");
	sv_ranking = cocostudio.getUIScrollView(view, "sv_ranking");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	rankingSize = sv_ranking:getInnerContainerSize();
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("FreeCoin.json")
	local gui = GUI_FREECOIN
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);

	--初始化控件
	initView();
	--发送免费金币消息
	sendOPERID_FREE_COIN();
	Common.showProgressDialog("加载中，请稍后…");

	LordGamePub.showDialogAmin(ImageView_FreeCoin, true, nil)
end

function requestMsg()

end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		thisLayerCloseAmin();
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--下载服务器图片
--]]
local function downloadServerPic()
	for i = 1, #freeCoinInfoTable do
		--模块图标
		Common.getPicFile(freeCoinInfoTable[i]["ModuleIcon"], i, true, loadModuleIcon);
		--模块标题
		--Common.getPicFile(freeCoinInfoTable[i]["ModuleTitle"], i, true, loadModuleTitle);
		---模块按钮上要显示的文字
		Common.getPicFile(freeCoinInfoTable[i]["ModuleBtnTxt"], i, true, loadModuleBtnTxt);

	end
end

--[[--
--初始化免费金币简介label数据
--]]
local function initLabelInfroData()
	--控件为空,return
	if freeCoinModuleUITable == nil or #freeCoinModuleUITable == 0 then
		return;
	end

	for i = 1, #freeCoinInfoTable do
		if freeCoinModuleUITable[i] ~= nil then
			if freeCoinModuleUITable[i].labelInfro ~= nil then
				freeCoinModuleUITable[i].labelInfro:setText(freeCoinInfoTable[i].ModuleIntro);
			end
			if freeCoinModuleUITable[i].labelTitle ~= nil then
				freeCoinModuleUITable[i].labelTitle:setText(freeCoinInfoTable[i].ModuleTitle);
			end
		end
	end
end

--[[
--初始化免费金币滚动层数据
--]]
local function initFreeCoinScrollData()
	--下载服务器图片
	downloadServerPic();
	--初始化label数据
	initLabelInfroData();
end

--[[--
--创建模块的panel
--@param #number index 下标
--]]
local function createModulePanel(index)
	freeCoinModuleUITable[index].layout =  ccs.panel({
		scale9 = true,
		image = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		size = CCSizeMake(PANEL_WIDTH, PANEL_HEIGHT),
		capInsets = CCRectMake(0, 0, 0, 0),
	});
	freeCoinModuleUITable[index].layout:setTouchEnabled(false);
	local panelHeight = scrollSizeHeight - (PANEL_HEIGHT + PANEL_DISTANCE) * (index - 1)  - PANEL_HEIGHT / 2;
	freeCoinModuleUITable[index].layout:setPosition(ccp(PANEL_WIDTH / 2,  panelHeight));
	freeCoinModuleUITable[index].layout:setAnchorPoint(ccp(0.5,0.5));
	sv_ranking:addChild(freeCoinModuleUITable[index].layout);
end

--[[--
--创建模块的背景
--@param #number index 下标
--]]
local function createModuleBg(index)
	freeCoinModuleUITable[index].moduleBg = ccs.image({
		scale9 = false,
		image = Common.getResourcePath("bg_paihangbang_gonggao.png"),
	});
	freeCoinModuleUITable[index].moduleBg:setScaleX(PANEL_WIDTH / freeCoinModuleUITable[index].moduleBg:getContentSize().width)
	freeCoinModuleUITable[index].moduleBg:setScaleY(PANEL_HEIGHT / freeCoinModuleUITable[index].moduleBg:getContentSize().height)
	freeCoinModuleUITable[index].moduleBg:setAnchorPoint(ccp(0.5,0.5));
	freeCoinModuleUITable[index].moduleBg:setPosition(ccp(PANEL_WIDTH / 2,  PANEL_HEIGHT/ 2));
	freeCoinModuleUITable[index].moduleBg:setZOrder(ZOrderLow);

	if freeCoinModuleUITable[index].layout ~= nil then
		freeCoinModuleUITable[index].layout:addChild(freeCoinModuleUITable[index].moduleBg);
	end
end

--[[--
--点击分享按钮
--@param #number moduleBtnStatus 按钮状态
--]]
local function touchShareBtn(moduleBtnStatus)
	local hasShare = profile.ShareToWX.getShareComplete(os.time());--是否已经分享
	local HasReceived = profile.ShareToWX.getHasReceivedPrizes(os.time());--是否已经领奖
	if hasShare == true and HasReceived == false then
		--如果已经分享但是尚未领奖,点击发领奖消息
		Common.showProgressDialog("数据加载中,请稍后...")
		sendOPERID_REQUEST_GAME_SHARING_REWARD();
	else
		--如果尚未分享,点击进入分享画面
		mvcEngine.createModule(GUI_INITIATIVE_SHARE);
	end
end

--[[--
--点击开启宝盒按钮
--@param #String paramVal 参数值
--]]
local function touchOpenBaoHeBtn(paramVal)
	local roomdID = tonumber(paramVal);

	if paramVal == nil or roomdID == -1 then
		--快速开始
		sendQuickEnterRoom(-1);
	else
		--进入指定的房间
		sendEnterRoom(roomdID);
	end
end

--[[--
--点击模块按钮
--]]
local function touchMoudleButton(index)
	local ModuleID = freeCoinInfoTable[index].ModuleID
	if ModuleID == profile.FreeCoin.getModuleConstantDataTable().MonthSign.ID then
		--月签
		if profile.MonthSign.getUserIsSignDate() == nil or  #profile.MonthSign.getUserIsSignDate() == 0 then
			--数据为空,重新发送消息
			sendUSERS_MONTH_SIGN_BASIC_INFO(profile.User.getSelfUserID());
		else
			mvcEngine.createModule(GUI_MONTHSIGN);
		end
	elseif ModuleID == profile.FreeCoin.getModuleConstantDataTable().DailyTask.ID then
		--每日任务
		mvcEngine.createModule(GUI_RENWU);

	elseif ModuleID == profile.FreeCoin.getModuleConstantDataTable().Share.ID then
		--分享
		touchShareBtn(freeCoinInfoTable[index].ModuleBtnStatus);
	elseif ModuleID == profile.FreeCoin.getModuleConstantDataTable().OpenBaoHe.ID then
		--开启房间宝盒
		touchOpenBaoHeBtn(freeCoinInfoTable[index].ParamVal);
	--进入相对于的房间
	elseif ModuleID == profile.FreeCoin.getModuleConstantDataTable().RedGift.ID then
		--红包分享
		CommShareConfig.selectRedGiftShareType()
		HongDian_datatable[12]["ID"][ModuleID] = nil
		sendMANAGERID_REMOVE_REDP(12, ModuleID)
	elseif ModuleID == profile.FreeCoin.getModuleConstantDataTable().InvitationCode.ID then
		--邀请码兑换
		--		if profile.ShareAwardRecipients.isButtonAvailable() then
		RedeemLogic.setCurViewType(RedeemLogic.getViewTypeTable().TAG_INVITE_PRIZE);
		mvcEngine.createModule(GUI_REDEEM);
	--		else
	--			Common.showToast(profile.ShareAwardRecipients.getTouchButtonTips(), 2);
	--		end
	elseif ModuleID == profile.FreeCoin.getModuleConstantDataTable().BindPhone.ID then
		--绑定手机
		BindPhoneConfig.showBindPhoneLayer()
		HongDian_datatable = {}
		HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
		HongDian_datatable[12]["ID"][ModuleID] = nil
		sendMANAGERID_REMOVE_REDP(12, ModuleID)
		if bindPhoneBtnGanTanHao ~= nil then
			bindPhoneBtnGanTanHao:setVisible(false)
		end
	end

end

--[[--
--创建叹号(红点)
--]]
function createGanTanHao()
	if btnGanTanHao ~= nil then
		return;
	end

	btnGanTanHao = UIImageView:create();
	btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"));
	btnGanTanHao:setPosition(ccp(TANHAO_X,TANHAO_Y));
end

--[[--
--创建绑定手机叹号(红点)
--]]
function createBindPhoneGanTanHao()
	if bindPhoneBtnGanTanHao ~= nil then
		bindPhoneBtnGanTanHao:setVisible(true)
		return;
	end
	bindPhoneBtnGanTanHao = UIImageView:create();
	bindPhoneBtnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"));
	bindPhoneBtnGanTanHao:setPosition(ccp(TANHAO_X,TANHAO_Y));
	bindPhoneBtnGanTanHao:setVisible(true)
end

--[[--
--创建绑定手机叹号(红点)
--]]
function createTaskGanTanHao()
	if taskBtnGanTanHao ~= nil then
		taskBtnGanTanHao:setVisible(true)
		return;
	end
	taskBtnGanTanHao = UIImageView:create();
	taskBtnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"));
	taskBtnGanTanHao:setPosition(ccp(TANHAO_X,TANHAO_Y));
	taskBtnGanTanHao:setVisible(true)
end

--[[--
--显示按钮的状态
--@param #number index freeCoinInfoTable下标
--]]
local function showButtonStatus(index)
	if freeCoinInfoTable[index].ModuleID == profile.FreeCoin.getModuleConstantDataTable().MonthSign.ID then
		--月签
		if freeCoinInfoTable[index].ModuleBtnStatus == profile.FreeCoin.getModuleConstantDataTable().MonthSign.HasSign then
			--未签,按钮变灰
			freeCoinModuleUITable[index].button:loadTextures(Common.getResourcePath("btn_dark.png"),Common.getResourcePath("btn_dark.png"), "");
		end
	elseif freeCoinInfoTable[index].ModuleID == profile.FreeCoin.getModuleConstantDataTable().DailyTask.ID then
		--每日任务
		local ModuleID = freeCoinInfoTable[index].ModuleID

--		if showFreeCoinListRedPoint(freeCoinInfoTable[index].ModuleID) then
--			createTaskBtnGanTanHao();
--			freeCoinModuleUITable[index].button:addChild(taskBtnGanTanHao);
--			Common.log("showFreeCoinListRedPoint====="..freeCoinInfoTable[index].ModuleID)
--		end
		if freeCoinInfoTable[index].ModuleBtnStatus == profile.FreeCoin.getModuleConstantDataTable().DailyTask.HasTanHao then
			--有可领取奖励,有叹号(红点)
			createTaskGanTanHao();
			freeCoinModuleUITable[index].button:addChild(taskBtnGanTanHao);
		elseif profile.HongDian.getProfile_HongDian_datatable() == 0 then
			if #profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()[12]["ID"] >= 1 then
				HongDian_datatable = {}
				HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
				HongDian_datatable[12]["ID"][ModuleID] = nil
				sendMANAGERID_REMOVE_REDP(12, ModuleID)
			end
		end

	elseif freeCoinInfoTable[index].ModuleID == profile.FreeCoin.getModuleConstantDataTable().Share.ID then
		--分享
		if profile.ShareToWX.getShareComplete(os.time()) == true then
			--已分享
			if profile.ShareToWX.getHasReceivedPrizes(os.time()) then
				--已领取
				--TODO
				freeCoinModuleUITable[index].btnTextSprite:loadTexture(Common.getResourcePath("yilingqu.png"));
				freeCoinModuleUITable[index].labelInfro:setText("记得明天再来‘分享’领奖励吧");
				freeCoinModuleUITable[index].button:loadTextures(Common.getResourcePath("btn_dark.png"),Common.getResourcePath("btn_dark.png"), "")
			else
				--未领取
				freeCoinModuleUITable[index].btnTextSprite:loadTexture(Common.getResourcePath("lingqu.png"));
				freeCoinModuleUITable[index].labelInfro:setText("恭喜您完成今日分享，快点击‘领奖’吧");
			end
		end
	elseif freeCoinInfoTable[index].ModuleID == profile.FreeCoin.getModuleConstantDataTable().OpenBaoHe.ID then
	--开启房间宝盒
	-- 没变化
	elseif freeCoinInfoTable[index].ModuleID == profile.FreeCoin.getModuleConstantDataTable().BindPhone.ID then
		--绑定手机

		if showFreeCoinListRedPoint(freeCoinInfoTable[index].ModuleID) then
			if bindPhoneBtnGanTanHao ~= nil then
				bindPhoneBtnGanTanHao:setVisible(true)
			else
				createBindPhoneGanTanHao();
				freeCoinModuleUITable[index].button:addChild(bindPhoneBtnGanTanHao);
			end
		end
	end
end

--[[-
--显示列表小红点
--@param #number ModuleID 下标
--]]
function showFreeCoinListRedPoint(ModuleID)
	local dataTable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()[12]["ID"]

	if #dataTable >= 1 then
		for i = 1, #dataTable do
			Common.log("dataTable==="..tonumber(dataTable[i]).."+"..tonumber(ModuleID))
			if tonumber(dataTable[i]) == tonumber(ModuleID) then
				return true
			end
		end
	end
	return false
end

--[[-
--创建模块标题
--@param #number index 下标
--]]
local function createModuleBtnText(index)
	freeCoinModuleUITable[index].btnTextSprite = UIImageView:create();
	freeCoinModuleUITable[index].btnTextSprite:loadTexture(Common.getResourcePath("menghei2_hall_gengduo_ic.png"));
	--按钮拉伸字变形了,往回缩放
	freeCoinModuleUITable[index].btnTextSprite:setScaleY(59 / BTN_HEIGHT);

	if freeCoinModuleUITable[index].button ~= nil then
		freeCoinModuleUITable[index].button:addChild(freeCoinModuleUITable[index].btnTextSprite);
	end
end

--[[--
--创建模块的按钮
--@param #number index 下标
--]]
local function createModuleButton(index)
	freeCoinModuleUITable[index].button = ccs.button({
		scale9 = true,
		size = CCSizeMake(BTN_WIDTH,59),
		pressed = Common.getResourcePath("btn_gerenziliao0.png"),
		normal = Common.getResourcePath("btn_gerenziliao0.png"),
		text = "",
		capInsets = CCRectMake(0, 0, 0, 0),
		listener = {
			[ccs.TouchEventType.began] = function(uiwidget)

			end,
			[ccs.TouchEventType.moved] = function(uiwidget)

			end,
			[ccs.TouchEventType.ended] = function(uiwidget)
				--点击按钮
				touchMoudleButton(index);
			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
			end,
		}
	})

	freeCoinModuleUITable[index].button:setPosition(ccp(BTN_X, BTN_Y));
	freeCoinModuleUITable[index].button:setZOrder(ZOrderHigh);
	--按钮宽九宫格拉伸, 高等比拉伸
	freeCoinModuleUITable[index].button:setScaleY(BTN_HEIGHT/ 59);

	if freeCoinModuleUITable[index].layout ~= nil then
		freeCoinModuleUITable[index].layout:addChild(freeCoinModuleUITable[index].button);
	end
end

--[[--
--创建模块label
--@param #number index 下标
--]]
local function createModuleLabel(index)
	freeCoinModuleUITable[index].labelInfro = ccs.label({
		text = "",
		fontSize = 22
	})
	freeCoinModuleUITable[index].labelInfro:setTextAreaSize(CCSizeMake(400, 0))
	freeCoinModuleUITable[index].labelInfro:setColor(ccc3(193, 150, 108))
	freeCoinModuleUITable[index].labelInfro:setTouchEnabled(false)
	freeCoinModuleUITable[index].labelInfro:setZOrder(ZOrderHigh);
	freeCoinModuleUITable[index].labelInfro:setAnchorPoint(ccp(0,0.5));
	freeCoinModuleUITable[index].labelInfro:setPosition(ccp(INTRO_X, INTRO_Y));

	if freeCoinModuleUITable[index].layout ~= nil then
		freeCoinModuleUITable[index].layout:addChild(freeCoinModuleUITable[index].labelInfro);
	end
end

--[[--
--创建模块icon
--@param #number index 下标
--]]
local function createModuleIcon(index)
	freeCoinModuleUITable[index].iconSprite = UIImageView:create();
	freeCoinModuleUITable[index].iconSprite:setPosition(ccp(ICON_X, ICON_Y));
	freeCoinModuleUITable[index].iconSprite:setZOrder(ZOrderHigh);
	freeCoinModuleUITable[index].iconSprite:loadTexture(Common.getResourcePath("ic_jiazaimoren.png", pathTypeInApp));

	if freeCoinModuleUITable[index].layout ~= nil then
		freeCoinModuleUITable[index].layout:addChild(freeCoinModuleUITable[index].iconSprite);
	end
end

--[[-
--创建模块标题
--@param #number index 下标
--]]
local function createModuleTitle(index)
	freeCoinModuleUITable[index].labelTitle = ccs.label({
		text = "",
		color = ccc3(249, 235, 219),
	});
	freeCoinModuleUITable[index].labelTitle:setAnchorPoint(ccp(0,0.5));
	freeCoinModuleUITable[index].labelTitle:setFontSize(25);
	freeCoinModuleUITable[index].labelTitle:setZOrder(ZOrderHigh);
	freeCoinModuleUITable[index].labelTitle:setPosition(ccp(TITLE_X, TITLE_Y));

	if freeCoinModuleUITable[index].layout ~= nil then
		freeCoinModuleUITable[index].layout:addChild(freeCoinModuleUITable[index].labelTitle);
	end
end

--[[--
--创建一个模块的view
--@param #number index 下标
--]]
local function createOneModuleView(index)
	freeCoinModuleUITable[index] = {};
	--模块panel
	createModulePanel(index);
	--背景image
	createModuleBg(index);
	--模块图标
	createModuleIcon(index);
	--模块标题
	createModuleTitle(index);
	--模块简介
	createModuleLabel(index);
	--按钮
	createModuleButton(index);
	--模块按钮上要显示的文字
	createModuleBtnText(index);
	--改变按钮状态
	showButtonStatus(index);
end

--[[--
--点击敬请期待事件
--]]
local function onClickLookForwardLayout()
	Common.showToast("更多领奖活动敬请期待！",2)
end

--[[--
--创建敬请期待按钮
--]]
local function createLookForwardBtn(index)
	lookForwardButton = ccs.button({
		scale9 = false,
		normal = Common.getResourcePath("bg_paihangbang_gonggao.png"),
		pressed = Common.getResourcePath("bg_paihangbang_gonggao.png"),
		text = "",
		capInsets = CCRectMake(0,  0, 0, 0),
		listener = {
			[ccs.TouchEventType.began] = function(uiwidget)
			end,
			[ccs.TouchEventType.moved] = function(uiwidget)
			end,
			[ccs.TouchEventType.ended] = function(uiwidget)
				onClickLookForwardLayout();
			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
			end,
		}
	})
	lookForwardButton:setPosition(ccp(PANEL_WIDTH / 2, PANEL_HEIGHT / 2));
	lookForwardButton:setZOrder(ZOrderLow);
	lookForwardButton:setScaleX(PANEL_WIDTH / lookForwardButton:getContentSize().width)
	lookForwardButton:setScaleY(PANEL_HEIGHT / lookForwardButton:getContentSize().height)

	if freeCoinModuleUITable[index].layout ~= nil then
		freeCoinModuleUITable[index].layout:addChild(lookForwardButton);
	end
end

--[[--
--创建敬请期待精灵
--]]
local function createLookForwardSprite(index)
	--敬请期待Sprite
	lookForwardSprite =  UIImageView:create();
	lookForwardSprite:setPosition(ccp(PANEL_WIDTH /2, PANEL_HEIGHT / 2));
	lookForwardSprite:setZOrder(ZOrderHigh);
	lookForwardSprite:setAnchorPoint(ccp(0.5,0.5));
	lookForwardSprite:loadTexture(Common.getResourcePath("qidai.png"));

	if freeCoinModuleUITable[index].layout ~= nil then
		freeCoinModuleUITable[index].layout:addChild(lookForwardSprite);
	end
end

--[[--
--敬请期待view
--]]
local function createLookForwardView()
	local index = #freeCoinInfoTable + 1;
	freeCoinModuleUITable[index] = {};
	--敬请期待panel
	createModulePanel(index);
	--敬请期待button
	createLookForwardBtn(index);
	--敬请期待Sprite
	createLookForwardSprite(index);
end

--[[--
--发光View
--]]
local function createLightView()
	lightSprite = ccs.image({
		scale9 = false,
		image = Common.getResourcePath("ui_bianyuanfaguang.png"),
	});
	lightSprite:setScale(rankingSize.width / lightSprite:getContentSize().width);
	lightSprite:setTouchEnabled(false);
	lightSprite:setPosition(ccp(rankingSize.width / 2, LIGHT_SPRITE_Y));
	lightSprite:setAnchorPoint(ccp(0.5,0));
	sv_ranking:addChild(lightSprite)
end

--[[--
--设置滚动层的size
--]]
local function setScrollViewSize()
	scrollSizeHeight = #freeCoinInfoTable* (PANEL_HEIGHT + PANEL_DISTANCE);

	if scrollSizeHeight < rankingSize.height then
		--如果所有免费金币的内容的高小于UI工程滚动层的高,则滚动层的高不变
		scrollSizeHeight = rankingSize.height;
	end

	sv_ranking:setInnerContainerSize(CCSize(rankingSize.width,scrollSizeHeight));
end

--[[
--初始化免费金币滚动层view
--]]
local function initFreeCoinScrollView()
	--数据不存在, return
	if freeCoinInfoTable == nil or freeCoinInfoTable == "" then
		return;
	end

	--设置滚动层的size
	setScrollViewSize();
	--模块View
	Common.log("zbl  #freeCoinInfoTable  = " .. #freeCoinInfoTable )
	for i =  1, #freeCoinInfoTable do
		--创建一个模块的view
		createOneModuleView(i);
	end
	--敬请期待view
	--createLookForwardView();
	--发光View
	createLightView();
end

--[[--
--加载本地数据(目前只有分享有本地数据)
--]]
local function loadFreeCoinLocalData()
	local index = 0;
	for i = 1, #loadLocalDataIndexTable do
		index = loadLocalDataIndexTable[i];
		if freeCoinInfoTable[index].ModuleID == profile.FreeCoin.getModuleConstantDataTable().Share.ID then
			freeCoinModuleUITable[index].btnTextSprite:loadTexture(Common.getResourcePath("lingqu.png"));
			freeCoinModuleUITable[index].labelInfro:setText("恭喜您完成今日分享，快点击‘领奖’吧");
			break;
		end
	end
end

--[[--
--应答免费金币消息
--]]
function processOPERID_FREE_COIN()
	Common.closeProgressDialog();
	freeCoinInfoTable = profile.FreeCoin.getFreeCoinInfoTable();
	--初始化免费金币滚动层view
	initFreeCoinScrollView();
	--初始化免费金币滚动层数据
	initFreeCoinScrollData();
end

--[[--
--领取奖励结果
--]]
function getSharingReward()
	Common.closeProgressDialog();
	local SharingRewardTable = profile.ShareToWX.getSharingRewardTable()
	if SharingRewardTable == nil then
		return
	end
	local result = SharingRewardTable.result
	if result == 0 then
		Common.showToast("领奖失败!您今天已经领取过一次奖励了哟~", 2)
	else
		for i = 1,#freeCoinInfoTable do
			if freeCoinInfoTable[i].ModuleID == profile.FreeCoin.getModuleConstantDataTable().Share.ID then
				freeCoinModuleUITable[i].btnTextSprite:loadTexture(Common.getResourcePath("yilingqu.png"));
				freeCoinModuleUITable[i].button:loadTextures(Common.getResourcePath("btn_dark.png"),Common.getResourcePath("btn_dark.png"), "")
				freeCoinModuleUITable[i].labelInfro:setText("记得明天再来‘分享’领奖励吧");
				hasAward = true;
				break;
			end
		end
		--ImageToast.createView(nil,Common.getResourcePath("ic_recharge_guide_jinbi.png"),"x" .. result,"领取奖励成功",2)
		--注销掉弹窗是因为大厅有相同的消息弹窗 (会造成弹窗两次)
	end
end

--[[--
--加载免费金币模块icon
--]]
function loadModuleIcon(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		--  string.sub(s,i,j) 提取字符串s的第i个到第j个字符。Lua中，第一个字符的索引值为1，最后一个为-1，以此类推，如：
		--  Common.log(string.sub("[hello world]",2,-2))      --输出hello world
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end

	if photoPath == nil or  photoPath == ""then
		return
	end
	if freeCoinModuleUITable == nil or #freeCoinModuleUITable == 0 then
		return;
	end

	if freeCoinModuleUITable[tonumber(id)] ~= nil and freeCoinModuleUITable[tonumber(id)].iconSprite ~= nil then
		freeCoinModuleUITable[tonumber(id)].iconSprite:loadTexture(photoPath);
	end
end

--[[--
--加载免费金币模块标题
--]]
function loadModuleTitle(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		--  string.sub(s,i,j) 提取字符串s的第i个到第j个字符。Lua中，第一个字符的索引值为1，最后一个为-1，以此类推，如：
		--  Common.log(string.sub("[hello world]",2,-2))      --输出hello world
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end

	if photoPath == nil or  photoPath == ""then
		return
	end
	if freeCoinModuleUITable == nil or #freeCoinModuleUITable == 0 then
		return;
	end

	if freeCoinModuleUITable[tonumber(id)] ~= nil and freeCoinModuleUITable[tonumber(id)].titleSprite ~= nil then
		freeCoinModuleUITable[tonumber(id)].titleSprite:loadTexture(photoPath);
	end
end

--[[--
--加载免费金币按钮文字
--]]
function loadModuleBtnTxt(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		--  string.sub(s,i,j) 提取字符串s的第i个到第j个字符。Lua中，第一个字符的索引值为1，最后一个为-1，以此类推，如：
		--  Common.log(string.sub("[hello world]",2,-2))      --输出hello world
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end

	if photoPath == nil or  photoPath == ""then
		return
	end
	if freeCoinModuleUITable == nil or #freeCoinModuleUITable == 0 then
		return;
	end

	if freeCoinInfoTable[tonumber(id)].ModuleID == profile.FreeCoin.getModuleConstantDataTable().Share.ID and profile.ShareToWX.getShareComplete(os.time()) then
		return;
	end

	if freeCoinModuleUITable[tonumber(id)] ~= nil and freeCoinModuleUITable[tonumber(id)].btnTextSprite ~= nil then
		freeCoinModuleUITable[tonumber(id)].btnTextSprite:loadTexture(photoPath);
	end

	--	--更新完所有的服务器下载图片后, 加载本地数据
	--	if id == #freeCoinInfoTable then
	--		--加载本地数据(目前只有分享有本地数据)
	--		loadFreeCoinLocalData();
	--	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(OPERID_FREE_COIN, processOPERID_FREE_COIN)
	framework.addSlot2Signal(OPERID_REQUEST_GAME_SHARING_REWARD, getSharingReward)
end

function removeSlot()
	framework.removeSlotFromSignal(OPERID_FREE_COIN, processOPERID_FREE_COIN)
	framework.removeSlotFromSignal(OPERID_REQUEST_GAME_SHARING_REWARD, getSharingReward)
end
