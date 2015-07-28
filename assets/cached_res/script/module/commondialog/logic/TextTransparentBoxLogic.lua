module("TextTransparentBoxLogic",package.seeall)

view = nil;

Panel_Box = nil;--
ImageView_TransparentBox = nil;
Button_close = nil;--
Button_goto_guan = nil--
Panel_webview = nil;--webView提示信息
Label_tips = nil;--文本提示信息

local function closeTheBox()
	mvcEngine.destroyModule(GUI_TEXT_TRANSPARENT_BOX);
end

--[[--
--界面关闭动画
--]]
local function thisLayerCloseAmin()
	Common.hideWebView();
	LordGamePub.closeDialogAmin(ImageView_TransparentBox,closeTheBox);
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
	Panel_Box = cocostudio.getUIPanel(view, "Panel_Box");
	ImageView_TransparentBox = cocostudio.getUIImageView(view, "ImageView_TransparentBox");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Button_goto_guan = cocostudio.getUIButton(view, "Button_goto_guan_0");
	Panel_webview = cocostudio.getUIPanel(view, "Panel_webview");
	Label_tips = cocostudio.getUILabel(view, "Label_tips");

	Button_goto_guan:setVisible(false)
	Button_goto_guan:setEnabled(false)
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("TextTransparentBox.json")
	local gui = GUI_TEXT_TRANSPARENT_BOX
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

function btn_goto_guan(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		print("btn_goto_guan")
		GameConfig.setTheLastBaseLayer(GUI_HALL)
		mvcEngine.createModule(GUI_CHUANGGUAN)
	elseif component == CANCEL_UP then
	--取消

	end
end


--[[--
--设置弹出框label提示文字
--@param #String msg 提示文字
--]]
function setTransparentBoxTipsText(msg)
	Panel_webview:setVisible(false);
	Label_tips:setVisible(true);
	Label_tips:setText(msg);
end

--[[--
--设置弹出框是否显示前往闯关按钮
--]]
function setShowGoToGuanBtn()
	Button_goto_guan:setVisible(true)
	Button_goto_guan:setEnabled(true)
end

--[[--
--设置弹出框WebView提示文字
--@param #String url 提示语网址
--]]
function setTransparentBoxTipsUrl(url, key)
	Panel_webview:setVisible(true);
	Label_tips:setVisible(false);
	local x = Panel_webview:getPosition().x;
	local y = Panel_webview:getPosition().y;
	local w = Panel_webview:getSize().width;
	local h = Panel_webview:getSize().height;
	--	Common.showWebView(url, "", x, y, w,h);
	CommDialogConfig.commonLoadWebView(url, key, x, y, w, h)
end

--[[--
--触控面板
--]]
function callback_Panel_Box(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--thisLayerCloseAmin();
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
