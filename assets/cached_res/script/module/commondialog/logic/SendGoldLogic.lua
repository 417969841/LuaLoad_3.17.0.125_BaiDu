module("SendGoldLogic",package.seeall)

view = nil
panel = nil
lab_msg = nil
btn_close = nil
ResultMsg = nil

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
	view = cocostudio.createView("SendGold.json")
	local gui = GUI_SENDGOLD
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

	btn_close = cocostudio.getUIButton(view, "btn_close")
	lab_msg = cocostudio.getUILabel(view, "lab_msg")
	lab_msg:setText(ResultMsg)

end
function setValue(ResultMsgV)
	ResultMsg = ResultMsgV
end
function requestMsg()

end

--关闭
function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--关闭界面
		close()
		if MatchRechargeCoin.bIsRechargeWaiting == true then
			-- 如果是在比赛充值等待区里，则进行充值引导
			MatchRechargeCoin.showChongzhiyindao()
		end

	elseif component == CANCEL_UP then
	--取消
	end
end
--关闭页面
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_SENDGOLD)
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
