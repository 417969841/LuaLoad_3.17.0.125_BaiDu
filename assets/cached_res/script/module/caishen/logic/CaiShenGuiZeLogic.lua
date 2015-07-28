module("CaiShenGuiZeLogic",package.seeall)

view = nil

LabelText = nil
panel = nil
BackButton = nil;

function onKeypad(event)
	if event == "backClicked" then
		local function actionOver()
			mvcEngine.destroyModule(GUI_CAISHENGUIZE)
		end
		LordGamePub.closeDialogAmin(panel,actionOver)
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("CaiShenGuiZe.json")
	local gui = GUI_CAISHENGUIZE
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
	panel = cocostudio.getUIImageView(view, "ImageView_23")
	BackButton = cocostudio.getUIButton(view, "BackButton")

	LordGamePub.showDialogAmin(panel, true)
end

function requestMsg()

end

function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local function actionOver()
			mvcEngine.destroyModule(GUI_CAISHENGUIZE)
		end
		LordGamePub.closeDialogAmin(panel,actionOver)
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
