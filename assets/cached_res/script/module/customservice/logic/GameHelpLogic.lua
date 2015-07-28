module("GameHelpLogic",package.seeall)

view = nil;

Panel_1 = nil;--
Image_Help = nil;--
Panel_Help = nil;--
btn_close = nil;--


function onKeypad(event)
	if event == "backClicked" then
	--返回键
		Common.hideWebView()
		mvcEngine.destroyModule(GUI_GAMEHELP);
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_1 = cocostudio.getUIPanel(view, "Panel_1");
	Image_Help = cocostudio.getUIImageView(view, "Image_Help");
	Panel_Help = cocostudio.getUIPanel(view, "Panel_Help");
	btn_close = cocostudio.getUIButton(view, "btn_close");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("GameHelp.json")
	local gui = GUI_GAMEHELP
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
	GameConfig.setTheCurrentBaseLayer(GUI_CUSTOMSERVICE)
	CCDirector:sharedDirector():getRunningScene():addChild(view)
	initView();
	initData();
end

function initData()
	local x = Panel_1:getPosition().x
	local y = Panel_1:getPosition().y
	local w = Panel_1:getSize().width
	local h = Panel_1:getSize().height
	Common.showWebView(GameConfig.URL_TABLE_CUSTOMSERVICE_HELP, "URL_TABLE_CUSTOMSERVICE_HELP", x+50, y+20, w-90, h-100)
end

function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		Common.hideWebView()
		mvcEngine.destroyModule(GUI_GAMEHELP);
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
