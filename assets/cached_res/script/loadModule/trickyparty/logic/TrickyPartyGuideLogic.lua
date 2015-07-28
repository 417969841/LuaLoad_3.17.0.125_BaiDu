module("TrickyPartyGuideLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
BackButton = nil;--


function onKeypad(event)
	if event == "backClicked" then
	--返回键
		local function actionOver()
			mvcEngine.destroyModule(GUI_TRICKYPARTYGUIDE)
		end
		LordGamePub.closeDialogAmin(panel, actionOver)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_TRICKYPARTYGUIDE;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("load_res/TrickyParty/TrickyPartyGuide.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("load_res/TrickyParty/TrickyPartyGuide.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	panel = cocostudio.getUIPanel(view, "panel");
	BackButton = cocostudio.getUIButton(view, "BackButton");
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

function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		local function actionOver()
			mvcEngine.destroyModule(GUI_TRICKYPARTYGUIDE)
		end
		LordGamePub.closeDialogAmin(panel, actionOver)
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
