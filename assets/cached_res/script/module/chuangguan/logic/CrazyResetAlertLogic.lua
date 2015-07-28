module("CrazyResetAlertLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
Label_Text = nil;--
Label_Title = nil;--
btn_cancel = nil;--
btn_reset = nil;--
Label_ButtonText = nil;--


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
	Label_Text = cocostudio.getUILabel(view, "Label_Text");
	Label_Title = cocostudio.getUILabel(view, "Label_Title");
	btn_cancel = cocostudio.getUIButton(view, "btn_cancel");
	btn_reset = cocostudio.getUIButton(view, "btn_reset");
	Label_ButtonText = cocostudio.getUILabel(view, "Label_ButtonText");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("CrazyResetAlert.json")
	local gui = GUI_CRAZY_RESET_ALERT
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
	GameStartConfig.addChildForScene(view)
	initView();
end

function requestMsg()

end

function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_CRAZY_RESET_ALERT)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_reset(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		sendOPERID_CRAZY_STAGE_RESET()
		mvcEngine.destroyModule(GUI_CRAZY_RESET_ALERT)
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
