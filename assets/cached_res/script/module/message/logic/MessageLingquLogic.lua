module("MessageLingquLogic",package.seeall)

view = nil
local scene = nil
--控件
btn_close = nil--关闭按钮
btn_lq = nil--领取奖励
lab_title = nil
lab_text = nil
img_good = nil

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
	view = cocostudio.createView("MessageLingqu.json")
	local gui = GUI_MESSAGELINGQU
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

	scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(view)
	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)

	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_lq = cocostudio.getUIButton(view, "btn_lq")
	lab_title = cocostudio.getUILabel(view, "lab_title")
	lab_text = cocostudio.getUILabel(view, "lab_text")
	img_good =  cocostudio.getUIImageView(view, "img_good")
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
	mvcEngine.destroyModule(GUI_MESSAGELINGQU)
end

--领取
function callback_btn_lq(component)
	if component == PUSH_DOWN then
		--按下
	elseif component == RELEASE_UP then
		--抬起
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
