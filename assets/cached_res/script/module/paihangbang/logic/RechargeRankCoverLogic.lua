module("RechargeRankCoverLogic",package.seeall)

view = nil;

Panel_bgPrompt = nil;--
Panel_Help = nil;--
ImageView_Help = nil;--
ImageView_help_people = nil;--
Label_help_prompt = nil;--
Panel_Button = nil;--
ImageView_arrowhead = nil;--
Panel_Reduce = nil;--
ImageView_Reduce = nil;--
ImageView_reduce_people = nil;--
Label_reduce_prompt = nil;--

--自定义变量
local RECHARGERANKHELP = 1 -- 首次进入充值排行榜
local RECHARGERANKREDUCE = 2 -- 充值排行榜名次掉落

local guideShowType = 1; --显示类型
local isTouchEnabled = false; --是否可以进行触摸

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("RechargeRankCover.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("RechargeRankCover.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("RechargeRankCover_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_bgPrompt = cocostudio.getUIPanel(view, "Panel_bgPrompt");
	Panel_Help = cocostudio.getUIPanel(view, "Panel_Help");
	ImageView_Help = cocostudio.getUIImageView(view, "ImageView_Help");
	ImageView_help_people = cocostudio.getUIImageView(view, "ImageView_help_people");
	Label_help_prompt = cocostudio.getUILabel(view, "Label_help_prompt");
	Panel_Button = cocostudio.getUIPanel(view, "Panel_Button");
	ImageView_arrowhead = cocostudio.getUIImageView(view, "ImageView_arrowhead");
	Panel_Reduce = cocostudio.getUIPanel(view, "Panel_Reduce");
	ImageView_Reduce = cocostudio.getUIImageView(view, "ImageView_Reduce");
	ImageView_reduce_people = cocostudio.getUIImageView(view, "ImageView_reduce_people");
	Label_reduce_prompt = cocostudio.getUILabel(view, "Label_reduce_prompt");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	initView();
	iniViewData()
end

--[[--
--初始化界面
--]]
function iniViewData()
	--定时解开触摸
	openViewTouchEnabled()
	view:setTouchEnabled(false)
	Panel_Reduce:setVisible(false)
	Label_reduce_prompt:setText("")
	Panel_Help:setVisible(false)
	Label_help_prompt:setText("")
	local labelSize = ImageView_Help:getContentSize()
	local labelPosition = ImageView_Help:getPosition()
	if guideShowType == RECHARGERANKHELP then
		Panel_Help:setVisible(true)
		sendCOMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG(1)
		runHeadAction()
	elseif guideShowType == RECHARGERANKREDUCE then
		Panel_Reduce:setVisible(true)
		sendCOMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG(2)
	end

end

--[[--
--设置显示类型
--]]
function setShowType(type)
	guideShowType = type
end

--[[--
--箭头动画
--]]
function runHeadAction()
	local array = CCArray:create();
	local moveUp = CCMoveBy:create(0.3, ccp(0, 50))
	local moveDown = CCMoveBy:create(0.3, ccp(0, -50))
	array:addObject(moveUp)
	array:addObject(moveDown)
	array:addObject(CCCallFunc:create(
		function ()
			runHeadAction()
		end
	))
	local seq = CCSequence:create(array)
	ImageView_arrowhead:runAction(seq)
end

--[[--
--提示动画
--]]
function runPromptMoveAction()
	local function runLocalAction(UILable)
		local array = CCArray:create();
		local moveLeft = CCMoveTo:create(0.5, ccp(575, 464))
		array:addObject(moveLeft)
		array:addObject(CCCallFunc:create(
			function ()
				isTouchEnabled = true
				view:setTouchEnabled(true)
			end
		))
		local seq = CCSequence:create(array)
		UILable:runAction(seq)
	end

	if guideShowType == RECHARGERANKHELP then
		runLocalAction(ImageView_Help)
	elseif guideShowType == RECHARGERANKREDUCE then
		runLocalAction(ImageView_Reduce)
	end
end


--[[--
--设置引导提示
--]]
function setGuidePrompt()
	local promptText = profile.PaiHangBangNotice.getPaiHangBangGuidePromptTable()
	if promptText.Msg == nil or promptText == "" then
		return
	end
	local labelSize = Label_help_prompt:getContentSize()
	local labelPosition = ImageView_Help:getPosition()
	local ImageViewSize = ImageView_Help:getContentSize()--(labelPosition.x - ImageViewSize.width*1.2 )/2
	if guideShowType == RECHARGERANKHELP then
		Common.showWebView("", promptText.Msg, labelPosition.x * 0.15, labelPosition.y - labelSize.height/0.9, labelSize.width*1.5, labelSize.height*1.7)
	elseif guideShowType == RECHARGERANKREDUCE then
		Common.showWebView("", promptText.Msg, labelPosition.x *0.15, labelPosition.y - labelSize.height/0.9, labelSize.width*1.5, labelSize.height*1.7)
	end
--	runPromptMoveAction()
end

--[[--
--界面定时解开触摸屏蔽
--]]
function openViewTouchEnabled()
	local array = CCArray:create();
	array:addObject(CCDelayTime:create(2))
	array:addObject(CCCallFunc:create(
		function ()
			isTouchEnabled = true
			view:setTouchEnabled(true)
		end
	))
	local seq = CCSequence:create(array)
	view:runAction(seq)
end

function requestMsg()

end

function callback_Panel_bgPrompt(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		if guideShowType == RECHARGERANKREDUCE then
			PaiHangBangLogic.removeShadowLayer()
			mvcEngine.destroyModule(GUI_RECHARGERANKCOVER);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_Button(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		if guideShowType == RECHARGERANKHELP then
			ImageView_arrowhead:stopAllActions()
			PaiHangBangLogic.showRechargeRankHelp()
			PaiHangBangLogic.removeShadowLayer()

		end
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()
	Common.hideWebView()
	view:stopAllActions()
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(COMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG, setGuidePrompt)
	framework.addSlot2Signal(COMMONS_GET_RECHARGE_ENCOURAGE_MSG, slot)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(COMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG, setGuidePrompt)
	framework.removeSlotFromSignal(COMMONS_GET_RECHARGE_ENCOURAGE_MSG, slot)
end
