module("UserAgreementLogic",package.seeall)

view = nil
panel = nil
Panel_webview = nil
btn_close = nil
local url = "http://f.99sai.com/lord/ServiceTerm.html"

function onKeypad(event)
	if event == "backClicked" then
		Common.hideWebView()
		mvcEngine.destroyModule(GUI_USERAGREEMENT)
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("UserAgreement.json")
	local gui = GUI_USERAGREEMENT
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
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)

	panel = cocostudio.getUIPanel(view, "Panel")
	Panel_webview = cocostudio.getUIPanel(view, "Panel_webview")
	LordGamePub.showDialogAmin(panel)
	btn_close = cocostudio.getUIButton(view, "btn_close")
	local x = Panel_webview:getPosition().x;
	local y = Panel_webview:getPosition().y;
	local w = Panel_webview:getSize().width;
	local h = Panel_webview:getSize().height;
--	Common.showWebView(url, "", x, y, w, h);
	--插个旗
--	GameConfig.URL_TABLE_LOGIN
	CommDialogConfig.commonLoadWebView(GameConfig.URL_TABLE_LOGIN, "URL_TABLE_LOGIN", x, y, w, h)
end

function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.hideWebView()
		LordGamePub.closeDialogAmin(panel,close)
	elseif component == CANCEL_UP then
	--取消
	end
end

function close()
	mvcEngine.destroyModule(GUI_USERAGREEMENT)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
end

function removeSlot()
end
