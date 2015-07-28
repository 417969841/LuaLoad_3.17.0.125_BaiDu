module("RechargeResultLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_48 = nil;--
Panel_exchange_box = nil;--
label_exchange_coin = nil;--
Label_exchange_info = nil;--
CheckBox_exchange = nil;--
Button_close = nil;--
Button_ok = nil;--
Label_text = nil;--

mYuanBaoNum = nil

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
	Panel_48 = cocostudio.getUIPanel(view, "Panel_48");
	Panel_exchange_box = cocostudio.getUIPanel(view, "Panel_exchange_box");
	label_exchange_coin = cocostudio.getUILabel(view, "label_exchange_coin");
	Label_exchange_info = cocostudio.getUILabel(view, "Label_exchange_info");
	CheckBox_exchange = cocostudio.getUICheckBox(view, "CheckBox_exchange");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Button_ok = cocostudio.getUIButton(view, "Button_ok");
	Label_text = cocostudio.getUILabel(view, "Label_text");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("RechargeResult.json")
	local gui = GUI_RECHARGE_RESULT
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

	LordGamePub.showDialogAmin(Panel_48)
end

function requestMsg()

end

function setDialogData(text, yuanbaoNum)
	CheckBox_exchange:setSelectedState(true)
	if text ~= nil and text ~= "" then
		Label_text:setText(text);
	end
	mYuanBaoNum = yuanbaoNum
	if mYuanBaoNum ~= nil and mYuanBaoNum > 0 then
		label_exchange_coin:setText("" .. (mYuanBaoNum * 100));
	end
end

local function close()
	mvcEngine.destroyModule(GUI_RECHARGE_RESULT)
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(Panel_48, close)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_ok(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local isExchange = CheckBox_exchange:getSelectedState()
		if isExchange then
			sendDBID_PAY_GOODS(10, mYuanBaoNum)
		end
		LordGamePub.closeDialogAmin(Panel_48, close)
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
