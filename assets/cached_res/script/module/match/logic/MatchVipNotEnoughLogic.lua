module("MatchVipNotEnoughLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
duijiangquan_not_enough = nil;--
ticket_not_enough = nil;--
tianti_not_enough = nil;--
btn_cz = nil;--
ImageView_button = nil;--
vip_not_enough = nil;--
lab_jine = nil;--
lab_vip2 = nil;--
lab_vip = nil;--
btn_close = nil;--
suipian_not_enough = nil;--
coinNum = 0
duijiangjuanNum = 0
suipianNum = 0
tiantidengjiDescription = ""
vipLvlNum = 0 -- 需要达到的VIP等级
matchInstance = {} --比赛实例

local GoToNum = 0
local vipneedyuanbao = 0 -- 达到VIP等级需要的元宝数

function setGoToNum(nNum)
  GoToNum = nNum
end

function getGoToNum()
  return GoToNum
end

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

	duijiangquan_not_enough = cocostudio.getUIPanel(view, "duijiangquan_not_enough");
	ticket_not_enough = cocostudio.getUIPanel(view, "ticket_not_enough");
	tianti_not_enough = cocostudio.getUIPanel(view, "tianti_not_enough");
  	vip_not_enough = cocostudio.getUIPanel(view, "vip_not_enough");
  	suipian_not_enough = cocostudio.getUIPanel(view, "suipian_not_enough");

  	duijiangquan_not_enough:setVisible(false)
  	ticket_not_enough:setVisible(false)
  	tianti_not_enough:setVisible(false)
  	vip_not_enough:setVisible(false)
  	suipian_not_enough:setVisible(false)

	btn_cz = cocostudio.getUIButton(view, "btn_cz");
	ImageView_button = cocostudio.getUIImageView(view, "ImageView_button");

	lab_jine = cocostudio.getUILabel(view, "lab_jine");
	lab_vip2 = cocostudio.getUILabelAtlas(view, "lab_vip2");
	lab_vip = cocostudio.getUILabelAtlas(view, "lab_vip");
	btn_close = cocostudio.getUIButton(view, "btn_close");

  	--local imgGoBtnBg =  cocostudio.getUIImageView(view,"ImageView_65")
	--local label = cocostudio.getUILabel(view,"lab_text")
	if(GoToNum == 1)then
    	-- 直接充值引导
		--label:setText("您的金币不足，可以使用元宝兑换")
    	--imgGoBtnBg:loadTexture(Common.getResourcePath("ui_recharge_guide_btn_quianwang.png"))
	elseif(GoToNum == 2)then
    	-- 直接充值引导
		--label:setText("您的元宝不足，请充值")
		--imgGoBtnBg:loadTexture(Common.getResourcePath("ui_recharge_guide_btn_recharge.png"))
	elseif(GoToNum == 3)then

    	vip_not_enough:setVisible(true)
    	Common.log("vipLvlNum = "..vipLvlNum)
		lab_vip:setStringValue(""..vipLvlNum)
    	lab_vip2:setStringValue(""..vipLvlNum)
    	-- 1元<->10元宝
    	--vipneedyuanbao =  VIPPub.getUserVipChaNeedMoney(tonumber(vipLvlNum))
    	local needMoney = VIPPub.getUserVipChaNeedMoneyRMB(tonumber(vipLvlNum))
    	lab_jine:setText(""..needMoney.."元")
    	ImageView_button:loadTexture(Common.getResourcePath("ui_match_2level_btn_lijichongzhi.png"))
  	elseif(GoToNum == 4)then
    	tianti_not_enough:setVisible(true)

    	local lblNum = cocostudio.getUILabel(view,"Label_32_0_0_0_1_1")
    	lblNum:setText(tiantidengjiDescription)
    	ImageView_button:loadTexture(Common.getResourcePath("ui_item_btn_qianwang.png"))
  	elseif(GoToNum == 5)then
    	suipian_not_enough:setVisible(true)

		local lblNum = cocostudio.getUILabel(view,"Label_32_0_0_0_1")
    	lblNum:setText(""..suipianNum)
    	ImageView_button:loadTexture(Common.getResourcePath("ui_item_btn_qianwang.png"))
  	elseif(GoToNum == 6)then
    	duijiangquan_not_enough:setVisible(true)

    	local lblNum = cocostudio.getUILabel(view,"Label_32_0_0_0_1_1_0_0")
    	lblNum:setText(""..duijiangjuanNum)
    	ImageView_button:loadTexture(Common.getResourcePath("ui_item_btn_qianwang.png"))
  	elseif(GoToNum == 7)then
		ticket_not_enough:setVisible(true)

		local lblNum = cocostudio.getUILabel(view,"Label_32_0_0_0_1_1_0")
    	lblNum:setText(matchInstance["TicketName"])
    	ImageView_button:loadTexture(Common.getResourcePath("ui_item_btn_ensure.png"))
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("MatchVipNotEnough.json")
	local gui = GUI_MATCHVIPNOTENOUGH
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

	initView();
end

function requestMsg()

end

function callback_btn_cz(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
  		mvcEngine.destroyModule(GUI_MATCHVIPNOTENOUGH)

      	Common.log("GoToNum == "..GoToNum)
		if(GoToNum == 1)then
			ExchangeLogic.setState(2)
        	mvcEngine.createModule(GUI_CONVERTCOIN) -- 元宝换金币
		elseif(GoToNum == 2)then
        	mvcEngine.createModule(GUI_PAYGUIDEPROMPT) -- 充值引导
        	local yuanbaoNum = coinNum/100
        	PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, yuanbaoNum, RechargeGuidePositionID.MatchListPositionG) -- 先创建再设置相关数据
		elseif(GoToNum == 3)then
			--GameConfig.setTheLastBaseLayer(GUI_HALL)
        	--mvcEngine.createModule(GUI_VIP) -- VIP引导
        	CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, vipneedyuanbao ,RechargeGuidePositionID.MatchListPositionC)
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
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
  mvcEngine.destroyModule(GUI_MATCHVIPNOTENOUGH)

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
