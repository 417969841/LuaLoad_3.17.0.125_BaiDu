module("BuyCoinConfimLogic",package.seeall)

view = nil
panel = nil
btn_close = nil
btn_ok = nil
lab_msg = nil
local mnGoodsID = 1--自由兑换id==1
local msGoodsName = ""
local mnPrice = 0

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
	view = cocostudio.createView("RechargeConfirm.json")
	local gui = GUI_BUYCOINCONFIM
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

	lab_msg = cocostudio.getUILabel(view, "lab_msg")
	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_ok = cocostudio.getUIButton(view, "btn_ok")
	lab_msg:setText("您确定要花费"..mnPrice.."个元宝购买"..msGoodsName.."吗？")
end

function requestMsg()

end
function setData(mnGoodsIDV,msGoodsNameV,mnPriceV)
	mnGoodsID = mnGoodsIDV
	msGoodsName = msGoodsNameV
	mnPrice = mnPriceV
end
--确认
function callback_btn_ok(component)
	if component == PUSH_DOWN then
		--按下
	elseif component == RELEASE_UP then
		--抬起
		sendDBID_PAY_GOODS(mnGoodsID, 1)
		close()
	elseif component == CANCEL_UP then
		--取消
	end
end
--关闭
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
	mvcEngine.destroyModule(GUI_BUYCOINCONFIM)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
--注册监听信号
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--移除监听信号
--framework.removeSlotFromSignal(signal, slot)
end
