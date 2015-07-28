module("TiaoJianBaoMingTanChuangLogic",package.seeall)

view = nil
local GoToNum = 0
panel = nil;
btn_go = nil;
btn_close = nil;

coinNum = 0

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

function setGoToNum(nNum)
	GoToNum = nNum
end

function getGoToNum()
	return GoToNum
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("TiaoJianBaoMingTanChuang.json")
	local gui = GUI_TIAOJIANBAOMINGTANCHUANG
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

	local imgGoBtnBg =  cocostudio.getUIImageView(view,"ImageView_65")
	local label = cocostudio.getUILabel(view,"lab_text")
	if(GoToNum == 1)then
		label:setText("您的金币不足，可以使用元宝兑换")
		imgGoBtnBg:loadTexture(Common.getResourcePath("ui_recharge_guide_btn_quianwang.png"))
	elseif(GoToNum == 2)then
		label:setText("您的元宝不足，请充值")
		imgGoBtnBg:loadTexture(Common.getResourcePath("ui_recharge_guide_btn_recharge.png"))
	elseif(GoToNum == 3)then
		label:setText("您的VIP等级未达到条件,是否了解【VIP】相关信息")
		imgGoBtnBg:loadTexture(Common.getResourcePath("ui_recharge_guide_btn_quianwang.png"))
	elseif(GoToNum == 4)then
		label:setText("您的天梯等级不足")
		imgGoBtnBg:loadTexture(Common.getResourcePath("ui_match_2level_btn_tiantixitong.png"))
	elseif(GoToNum == 5)then
		label:setText("您的碎片不足")
		imgGoBtnBg:loadTexture(Common.getResourcePath("ui_recharge_guide_btn_quianwang.png"))
	elseif(GoToNum == 6)then
		label:setText("您的兑奖券不足")
		imgGoBtnBg:loadTexture(Common.getResourcePath("ui_recharge_guide_btn_quianwang.png"))
	elseif(GoToNum == 7)then
		label:setText("您没有参加该比赛的门票")
		imgGoBtnBg:loadTexture(Common.getResourcePath("ui_recharge_guide_btn_querenguanbi.png"))
	end

	btn_go = cocostudio.getUIButton(view, "btn_go")
	btn_close = cocostudio.getUIButton(view, "btn_close")
end

function requestMsg()

end

function callback_btn_go(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local function actionOver()
			mvcEngine.destroyModule(GUI_TIAOJIANBAOMINGTANCHUANG)
			Common.log("GoToNum == "..GoToNum)
			if(GoToNum == 1)then
				--GameConfig.setTheLastBaseLayer(GUI_HALL)
				ExchangeLogic.setState(2)
				mvcEngine.createModule(GUI_CONVERTCOIN) -- 元宝换金币
			elseif(GoToNum == 2)then
				--UserInfoLogic.setTab(UserInfoLogic.TAB_TIANTI)
				--QuickPay.Pay_Guide_need_yuanbao_GuideTypeID = 100003;-- 游戏中元宝不足
				mvcEngine.createModule(GUI_PAYGUIDEPROMPT) -- 充值引导
				local yuanbaoNum = coinNum/100
				PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, yuanbaoNum, RechargeGuidePositionID.MatchListPositionG) -- 先创建再设置相关数据
			elseif(GoToNum == 3)then
				GameConfig.setTheLastBaseLayer(GUI_HALL)
				mvcEngine.createModule(GUI_VIP) -- VIP引导
			elseif(GoToNum == 4)then
				GameConfig.setTheLastBaseLayer(GUI_HALL)
				-- quick start no GUI
				Common.showProgressDialog("数据加载中,请稍后...")
				sendQuickEnterRoom(-1);
			elseif(GoToNum == 5)then
				GameConfig.setTheLastBaseLayer(GUI_HALL)
				-- quick start no GUI
				Common.showProgressDialog("数据加载中,请稍后...")
				sendQuickEnterRoom(-1);
			elseif(GoToNum == 6)then
				GameConfig.setTheLastBaseLayer(GUI_HALL)
				UserInfoLogic.setTab(UserInfoLogic.getPackTab());
				mvcEngine.createModule(GUI_USERINFO) -- 个人资料-背包
			elseif(GoToNum == 7)then
				GameConfig.setTheLastBaseLayer(GUI_HALL)
				-- just close alert
			end
		end

		LordGamePub.closeDialogAmin(panel, actionOver)

	elseif component == CANCEL_UP then
	--取消
	end

end


function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local function actionOver()
			mvcEngine.destroyModule(GUI_TIAOJIANBAOMINGTANCHUANG)
		end
		LordGamePub.closeDialogAmin(panel, actionOver)
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
