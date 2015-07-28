module("SkipNewUserGuideLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_117 = nil;--
Button_SkipButton = nil;--
Panel_120 = nil;--
Label_SkipValue = nil;--
Button_JiXu = nil;--
local ClickSkipFlag = false;--如果是用户点击跳过，则为true，否则为false

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	--	 LordGamePub.showBaseLayerAction(view);
	elseif event == "menuClicked" then
	--菜单键
	end
end

--设置用户点击跳过
function setClickSkipNewUserGuideFlag(flag)
	ClickSkipFlag = flag;
end
--获取是否用户点击跳过，是则为true，否则为false
function getClickSkipNewUserGuideFlag()
	return ClickSkipFlag;
end

--新手跳过提示语
local function skipText()
	--新手引导方案，1是做过公共模块新手引导，0是没有做过公共模块新手引导
	local numberScheme = profile.NewUserGuide.getCommonNewUserGuideScheme();
	if(numberScheme == 0)then
		local skipValue = profile.profile.NewUserGuide.getNewUserGuideBaseInfo();
		if(NewUserGuideLogic.getTaskFinishState() == NewUserGuideLogic.getDataFinishState().oneFinish)then
			Label_SkipValue:setText(skipValue[2].ResultTxt);
		elseif(NewUserGuideLogic.getTaskFinishState() == NewUserGuideLogic.getDataFinishState().twoFinish)then
			Label_SkipValue:setText(skipValue[3].ResultTxt);
		elseif(NewUserGuideLogic.getTaskFinishState() == NewUserGuideLogic.getDataFinishState().threeFinish)then
			Label_SkipValue:setText(skipValue[4].ResultTxt);
		elseif(NewUserGuideLogic.getTaskFinishState() == NewUserGuideLogic.getDataFinishState().fourFinish)then
		end
	elseif(numberScheme == 1)then
		local skipValue = profile.profile.NewUserGuide.getNewUserGuideBaseInfo();
		Label_SkipValue:setText(skipValue[2].ResultTxt);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_117 = cocostudio.getUIPanel(view, "Panel_117");
	Button_SkipButton = cocostudio.getUIButton(view, "Button_SkipButton");
	Panel_120 = cocostudio.getUIPanel(view, "Panel_120");
	Label_SkipValue = cocostudio.getUILabel(view, "Label_SkipValue");
	Button_JiXu = cocostudio.getUIButton(view, "Button_JiXu");

	--跳过提示语
	skipText();
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("SkipNewUserGuide.json")
	local gui = GUI_SKIPNEWUSERGUIDE
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

	initView();
end

function requestMsg()

end

function callback_Button_SkipButton(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		ClickSkipFlag = true;
		sendCOMMONS_SKIP_NEWUSERGUIDE();
		mvcEngine.destroyModule(GUI_SKIPNEWUSERGUIDE);
		if NewUserGuideLogic.getNewUserGuideDisplayed() then
			--如果新手引导页面正在展示,销毁新手引导界面
			mvcEngine.destroyModule(GUI_NEWUSERGUIDE);
		elseif   NewUserCoverOtherLogic.getNewUserCoverDisplayed() then
			mvcEngine.destroyModule(GUI_NEWUSERCOVEROTHER);
		end

		if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
			--创建大厅箭头(完成新手引导,大厅出现提示指向"快速开始"的前提)
--			HallLogic.promptClickQuickStartBtn();
		end

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_JiXu(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_SKIPNEWUSERGUIDE);
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
