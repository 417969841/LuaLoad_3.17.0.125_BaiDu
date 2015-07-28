module("RechargeConfirmLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
lab_msg = nil;--
btn_ok = nil;--
btn_close = nil;--

callbackBtnOK = nil -- 点击确定的回调函数

local GoodsItem = nil
local PayTypeID = nil
local isExchange = nil

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
	lab_msg = cocostudio.getUILabel(view, "lab_msg");
	btn_ok = cocostudio.getUIButton(view, "btn_ok");
	btn_close = cocostudio.getUIButton(view, "btn_close");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("RechargeConfirm.json")
	local gui = GUI_RECHARGE_CONFIRM
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
	GameStartConfig.addChildForScene(view)
	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)
	initView();
end

function setData(GoodsItemV,PayTypeIDV,isExchangeV)
	GoodsItem = GoodsItemV
	PayTypeID = PayTypeIDV
	isExchange = isExchangeV
end

function requestMsg()

end

function callback_btn_ok(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if callbackBtnOK ~= nil then
			callbackBtnOK()
			callbackBtnOK = nil
			return
		end

		PaymentMethod.callPayment(GoodsItem,PayTypeID,0,isExchange,0)
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

--关闭
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_RECHARGE_CONFIRM)
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
