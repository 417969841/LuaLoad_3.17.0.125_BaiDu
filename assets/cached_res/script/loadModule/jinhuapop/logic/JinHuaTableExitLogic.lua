module("JinHuaTableExitLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_56 = nil;--
btn_close = nil;--
Button_Confirm = nil;--
Button_Download = nil;--

local JINHUA_DOWNLOAD_URL = "http://f.99sai.com/release/TqJinhua_latest.apk"

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		mvcEngine.destroyModule(GUI_JINHUA_TABLEEXIT)
	elseif event == "menuClicked" then
	--菜单键
	end
end

----[[--
----初始化当前界面
----]]
--local function initLayer()
--	local gui = GUI_JINHUATABLEEXIT;
--	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
--		--Android的适配方案没有 960x640
--		view = cocostudio.createView("load_res/JinHua/JinHuaTableExit_960_640.json");
--		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
--	else
--		view = cocostudio.createView("JinHuaTableExit.json");
--		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
--	end
--end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_56 = cocostudio.getUIPanel(view, "Panel_56");
	btn_close = cocostudio.getUIButton(view, "btn_close");
	Button_Confirm = cocostudio.getUIButton(view, "Button_Confirm");
	Button_Download = cocostudio.getUIButton(view, "Button_Download");
end

function createView()
	--初始化当前界面
	--	initLayer();
	view = cocostudio.createView("load_res/JinHua/JinHuaTableExit.json");
	view:setTag(getDiffTag());
	CCDirector:sharedDirector():getRunningScene():addChild(view)
	initView();
end

function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_JINHUA_TABLEEXIT)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Confirm(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		JinHuaTableMyOperation.quitGameRoom()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Download(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		download()
	elseif component == CANCEL_UP then
	--取消

	end
end

function download()
	local function callback()
		Common.showToast("游戏开始下载中...",2)
		JinHuaTableMyOperation.quitGameRoom()
	end
	local javaClassName = "com.tongqu.client.utils.MiniGameUtils"
	local javaMethodName = "luaCallDownloadMiniGame"
	local javaParams = {
		JINHUA_DOWNLOAD_URL,
		callback,
	}
	luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
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
