module("AaiXinNvShenGuiZeLogic",package.seeall)

view = nil

panel = nil
BackButton = nil

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
	view = cocostudio.createView("load_res/activity_res/AaiXinNvShenGuiZe.json")
	local gui = GUI_AIXINNVSHENGUIZE
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
	BackButton = cocostudio.getUIButton(view, "BackButton")

	LordGamePub.showDialogAmin(panel)
end

function requestMsg()

end

local function close()
	mvcEngine.destroyModule(GUI_AIXINNVSHENGUIZE)
end

function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(panel,close)
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
