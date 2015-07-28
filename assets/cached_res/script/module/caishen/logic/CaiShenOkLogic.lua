module("CaiShenOkLogic",package.seeall)

view = nil
TitleString = nil
NotificationString = nil
panel = nil;
BackButton = nil;

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
	view = cocostudio.createView("CaiShenOk.json")
	local gui = GUI_CAISHENOK
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
	local Label = cocostudio.getUILabel(view, "Label_DuoCiXiaJiang")
	Label:setTextVerticalAlignment(kCCVerticalTextAlignmentTop);
	Label:setText(TitleString)
	Label = cocostudio.getUILabel(view, "Label_JiXuXiaJiang")
	Label:setTextVerticalAlignment(kCCVerticalTextAlignmentTop);
	Label:setText(NotificationString)

	panel = cocostudio.getUIImageView(view, "ImageView_22")
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
			mvcEngine.destroyModule(GUI_CAISHENOK)
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
