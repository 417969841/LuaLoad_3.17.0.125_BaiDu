module("matchjijiangkaisaiLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
Label_text = nil;--
btn_xiaoyouxi = nil;--
btn_tuisai = nil;--
BackButton = nil;--
Image_bg = nil;--

Label_text_0 = nil
Label_9 = nil
Label_10 = nil
Label_text = nil
Label_text_1 = nil

tableMode = -1 -- 1:当前在比赛中, 2:当前在房间中, 3:新比赛快开始，不让进房间
leftCallbackFunction = nil
rightCallbackFunction = nil

strTitleTips = ""

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	panel = cocostudio.getUIPanel(view, "panel");
	Label_text = cocostudio.getUILabel(view, "Label_text");
	btn_xiaoyouxi = cocostudio.getUIButton(view, "btn_xiaoyouxi");
	btn_tuisai = cocostudio.getUIButton(view, "btn_tuisai");
	BackButton = cocostudio.getUIButton(view, "BackButton");
	Image_bg = cocostudio.getUIImageView(view, "Image_bg");

	Label_text_0 = cocostudio.getUILabel(view, "Label_text_0")
	Label_9 = cocostudio.getUILabel(view, "Label_9")
	Label_10 = cocostudio.getUILabel(view, "Label_10")
	Label_text = cocostudio.getUILabel(view, "Label_text")
	Label_text_1 = cocostudio.getUILabel(view, "Label_text_1")

	Label_text_0:setText(strTitleTips)
	if tableMode == 1 then
		Label_9:setText("参加新比赛")
		Label_10:setText("继续当前比赛")

	elseif tableMode == 2 then
		if GameLoadModuleConfig.getFruitIsExists() then
			Label_9:setText("小游戏")
			Label_text_1:setText("先玩会儿小游戏")
		else
			Label_9:setText("确定")
			Label_text_1:setText("等待比赛开始")
		end
		Label_10:setText("退赛进入房间")
		Label_text:setText("放弃将开始的比赛")
	elseif tableMode == 3 then
		if GameLoadModuleConfig.getFruitIsExists() then
			Label_9:setText("小游戏")
			Label_text_1:setText("先玩会儿小游戏")
		else
			Label_9:setText("确定")
			Label_text_1:setText("等待比赛开始")
		end
		Label_10:setText("退赛进入房间")
		Label_text:setText("放弃将开始的比赛")
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("matchjijiangkaisai.json")
	local gui = GUI_MATCH_JIJIANGKAISHI
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

function callback_btn_xiaoyouxi(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if GameLoadModuleConfig.getFruitIsExists() then
			if leftCallbackFunction then
				leftCallbackFunction()
				leftCallbackFunction = nil
			end
		else
			close()
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_tuisai(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if rightCallbackFunction then
			rightCallbackFunction()
			rightCallbackFunction = nil
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

function close()
	mvcEngine.destroyModule(GUI_MATCH_JIJIANGKAISHI)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	tableMode = 0
	leftCallbackFunction = nil
	rightCallbackFunction = nil
end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
