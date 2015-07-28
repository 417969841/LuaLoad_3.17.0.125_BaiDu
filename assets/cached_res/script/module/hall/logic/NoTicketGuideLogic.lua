module("NoTicketGuideLogic",package.seeall)

view = nil
panel = nil
btn_close = nil
btn_go = nil
lab_text = nil

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
	view = cocostudio.createView("NoTicketGuide.json")
	local gui = GUI_NOTICKETGUIDE
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
	btn_go =  cocostudio.getUIButton(view, "btn_go")
	lab_text = cocostudio.getUILabel(view, "lab_text")
	lab_text:setText("您没有该比赛的门票，可以去【碎片商城】看看，部分门票可以直接兑换！")
end

function requestMsg()

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
	mvcEngine.destroyModule(GUI_NOTICKETGUIDE)
end
function callback_btn_go(component)
	if component == PUSH_DOWN then
		--按下
	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_HALL)
		--GameConfig.setHallShowMode()
		--GameConfig.setHallRoomItem()
		ExchangeLogic.setState(2)
		mvcEngine.createModule(GUI_EXCHANGE,LordGamePub.runSenceAction(view,nil,true))

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
end
