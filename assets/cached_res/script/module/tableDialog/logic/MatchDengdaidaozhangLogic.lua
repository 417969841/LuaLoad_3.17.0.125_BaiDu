module("MatchDengdaidaozhangLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
Label_text = nil;--
btn_backtorecharge = nil;--


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
	btn_backtorecharge = cocostudio.getUIButton(view, "btn_backtorecharge");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("MatchDengdaidaozhang.json")
	local gui = GUI_MATCH_TABLE_DENGDAIDAOZHANG
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

function callback_btn_backtorecharge(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
	
	--充值引导框
  	local userCurCoin = profile.User.getSelfCoin()
	local needConCnt = MatchRechargeCoin.tRecharge.MinCoin - userCurCoin
	Common.log("needConCnt = "..needConCnt)

  	CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, needConCnt, RechargeGuidePositionID.MatchListPositionI)
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
