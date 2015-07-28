module("RechargePromptLogic",package.seeall)

view = nil

label_recharge_prompt = nil
btn_close = nil

local topText = nil --顶部提示语文字

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
	view = cocostudio.createView("RechargePrompt.json")
	local gui = GUI_RECHARGEPROMPT
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

	label_recharge_prompt = cocostudio.getUILabel(view, "label_recharge_prompt")
	label_recharge_prompt:setText(topText)
	btn_close = cocostudio.getUIButton(view, "btn_close")
end

function setValue(textV)
	topText = textV
end

function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_RECHARGEPROMPT)
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
