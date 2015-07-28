module("NetErrExitDialogLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
android = nil;--
btn_logout = nil;--
btn_exit = nil;--
ios = nil;--
btn_logout_ios = nil;--
local isShow = false;--当前界面是否显示

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
	panel = cocostudio.getUIPanel(view, "panel");
	android = cocostudio.getUIPanel(view, "android");
	btn_logout = cocostudio.getUIButton(view, "btn_logout");
	btn_exit = cocostudio.getUIButton(view, "btn_exit");
	ios = cocostudio.getUIPanel(view, "ios");
	btn_logout_ios = cocostudio.getUIButton(view, "btn_logout_ios");

end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("NetErrExitDialog.json")
	local gui = GUI_NETERREXITDIALOG
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

	if Common.platform == Common.TargetIos then
		--ios平台
		Common.setButtonVisible(btn_exit, false);
		Common.setButtonVisible(btn_logout, false);
		Common.setButtonVisible(btn_logout_ios, true);
	elseif Common.platform == Common.TargetAndroid then
		--android
		Common.setButtonVisible(btn_exit, true);
		Common.setButtonVisible(btn_logout, true);
		Common.setButtonVisible(btn_logout_ios, false);
	end

	LordGamePub.showDialogAmin(panel);
	isShow = true;
end

function viewIsRunning()
	return isShow;
end

function requestMsg()

end

local function back()
	mvcEngine.destroyModule(GUI_NETERREXITDIALOG)
end

--Android设备中的退出按钮
function callback_btn_exit(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		back();
		Common.AndroidExitSendOnlineTime();
	elseif component == CANCEL_UP then
	--取消

	end
end

--Android设备中的重新连接按钮
function callback_btn_logout(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Services:getMessageService():closeSocket();
		Services:getMessageService():reConnect();
		LordGamePub.closeDialogAmin(panel, back);
	elseif component == CANCEL_UP then
	--取消

	end
end

--IOS中的重新连接按钮
function callback_btn_logout_ios(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Services:getMessageService():closeSocket();
		Services:getMessageService():reConnect();
		LordGamePub.closeDialogAmin(panel, back);
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
end

function removeSlot()
	isShow = false;
end
