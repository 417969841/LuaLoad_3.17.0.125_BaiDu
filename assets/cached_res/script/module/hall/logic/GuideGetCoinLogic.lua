module("GuideGetCoinLogic",package.seeall)

view = nil
btn_close = nil
btn_go = nil
btn_cz = nil
btn_bm = nil

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
	view = cocostudio.createView("GuideGetCoin.json")
	local gui = GUI_GUIDEGETCOIN
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

	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)

	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_go = cocostudio.getUIButton(view, "btn_go")
	btn_cz = cocostudio.getUIButton(view, "btn_cz")
	btn_bm = cocostudio.getUIButton(view, "btn_bm")
end

function requestMsg()

end

--充值
function callback_btn_cz(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--关闭界面
		GameConfig.setTheLastBaseLayer(GUI_HALL)
		mvcEngine.createModule(GUI_RECHARGE_CENTER,LordGamePub.runSenceAction(view,nil,true))
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end
--前往
function callback_btn_go(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.showProgressDialog("数据加载中...")
		mvcEngine.createModule(GUI_RENWU)
	elseif component == CANCEL_UP then
	--取消
	end
end
--报名
function callback_btn_bm(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setHallRoomItem(0)
		GameConfig.setHallShowMode(2)
		mvcEngine.createModule(GUI_HALL)
	elseif component == CANCEL_UP then
	--取消
	end
end
--关闭
function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--关闭界面
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end
--关闭页面
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_GUIDEGETCOIN)
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
