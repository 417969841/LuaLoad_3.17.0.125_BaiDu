module("GameLoadingLogic",package.seeall)

local view = nil
local PanelGameLoading = nil
local isShow = false;
local touchLayer = nil

local function onKeypad(event)
	if event == "backClicked" then
		closeLoadingView()
	elseif event == "menuClicked" then
	end
end

--[[--
--设置当前界面返回键监听
]]
function setOnKeypadEventListener()
	if Common.platform == Common.TargetAndroid then
		view:addKeypadEventListener(onKeypad)
		view:setKeypadEnabled(true)
	end
end

--[[--
--关闭loading界面
--]]
function closeLoadingView()
	if view ~= nil then
		isShow = false;
		GameArmature.hideGameLoadingAnim(view)
		view:stopAllActions()
		view:removeFromParentAndCleanup(true)
		view = nil;
	end
end

function showLoadingView(x, y,isHightLight)
	if view == nil then
		view = cocostudio.createView("GameLoading.json")
		PanelGameLoading = cocostudio.getUIButton(view, "PanelGameLoading");
		--view:setTag(getDiffTag())
		view:setZOrder(20)
		if  isHightLight == false then
			PanelGameLoading:setVisible(false)
		end
		GameStartConfig.addChildForScene(view)
		touchLayer = CCLayer:create()
		view:addChild(touchLayer)
		setOnKeypadEventListener()
		touchLayer:setTouchPriority(-99999)
		touchLayer:registerScriptTouchHandler(closeLoadingView, false, -99999, true)
		touchLayer:setTouchEnabled(true)
		GameArmature.showGameLoadingAnim(view, x, y)
		isShow = true;
	end
end

--[[--
--是否显示loading界面
--]]
function isLoadingShow()
	return isShow;
end
