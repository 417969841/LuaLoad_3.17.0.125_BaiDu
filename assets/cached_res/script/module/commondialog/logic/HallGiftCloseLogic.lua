module("HallGiftCloseLogic", package.seeall)

view = nil
Button_close = nil
Button_back = nil
panel = nil

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
	view = cocostudio.createView("HallGiftClose.json")
	local gui = GUI_GIFT_CLOSE_VIEW
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

	panel = cocostudio.getUIPanel(view, "Panel_22")
	LordGamePub.showDialogAmin(panel)

	Button_close = cocostudio.getUIButton(view, "Button_close")
	Button_back = cocostudio.getUIButton(view, "Button_back")
	Common.setDataForSqlite(CommSqliteConfig.ShowGiftCloseTimeStamp, Common.getServerTime());
end

function requestMsg()

end

local function close()
	mvcEngine.destroyModule(GUI_GIFT_CLOSE_VIEW)
	if HallGiftShowLogic.view ~= nil then
		HallGiftShowLogic.closeGift()
	end
end

local function back()
	mvcEngine.destroyModule(GUI_GIFT_CLOSE_VIEW)
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(panel, close)
		--MatchRechargeCoin.showChongzhiyindao()
		if MatchRechargeCoin.bIsRechargeWaiting == true then
			if LordGamePub.logicGiveCoin() then
				MatchRechargeCoin.sendPochansongjin()
			else
				MatchRechargeCoin.showChongzhiyindao()
			end
		else
			if LordGamePub.logicGiveCoin()then
				--可以破产送金
				--能破产送金，就发消息
				sendMANAGERID_GIVE_AWAY_GOLD(-1)
			end
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(panel, back)
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
