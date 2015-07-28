module("CrazyBuyStoneLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
ImageView_Win = nil;--
Label_Number = nil;--
Label_Text = nil;--
Label_Money = nil;--
ImageView_Fail = nil;--
btn_cancel = nil;--
btn_logout = nil;--
Image_fuhuo = nil;--
Label_StoneNum = nil;
Label_Title = nil;--
Label_BuyNum = nil--购买复活石个数
Label_BuyNum_Cover = nil--购买复活石个数

local isInTable = nil; --是否闯关成功
local isDizhu = nil; --是否是地主
local reliveStoneNumber = nil; --拥有复活石数量
local needReliveStone = nil; --复活所需复活石数量
local goodsCode = nil; --购买复活石的物品Code
local goodsPrice = nil; --购买复活石的金额
local goodsNumber = nil; --可以购买的复活石数量
local PaymentTable = nil; --支付信息
local GuideID = nil; --支付引导ID
isShow = false;--弹窗是否正在显示
canBeShow = false;--弹窗是否可以显示

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		close()
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
	Label_Text = cocostudio.getUILabel(view, "Label_Text");
	Label_Money = cocostudio.getUILabel(view, "Label_Money");
	btn_cancel = cocostudio.getUIButton(view, "btn_cancel");
	btn_logout = cocostudio.getUIButton(view, "btn_logout");
	Image_fuhuo = cocostudio.getUIImageView(view, "Image_fuhuo");
	Label_StoneNum = cocostudio.getUILabel(view, "Label_StoneNum");
	Label_Title = cocostudio.getUILabel(view, "Label_Title");
	Label_BuyNum = cocostudio.getUILabel(view, "Label_19");
	Label_BuyNum_Cover = cocostudio.getUILabel(view, "Label_191");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("CrazyBuyStone.json")
	local gui = GUI_CRAZY_BUY_STONE
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
	isShow = true
	canBeShow = false
	initView();
	showView();
end

function showView()
	GuideID = switchGuideID(needReliveStone - reliveStoneNumber)
	Common.log("crazy GuideID is " .. GuideID)
	PaymentTable = QuickPay.getPaymentTable(GuideID, 0, 0, true)
	if PaymentTable.GiftID ~= nil then
		TableConsole.stoneRechargeId = PaymentTable.GiftID
	end
	if isInTable == true then
		Label_Text:setText("使用" .. needReliveStone .."个复活石可立刻复活，您的复活石不够，是否购买？")
		Image_fuhuo:loadTexture(Common.getResourcePath("fuhuo.png"))
		Label_Money:setText(PaymentTable.price / 100 .. "元")
		if isDizhu == true then
		elseif isDizhu == false then
		else
		end
	else
		Label_Title:setVisible(false)
		Label_Text:setText("闯关失败时使用复活石进行复活并继续闯关")
		Image_fuhuo:loadTexture(Common.getResourcePath("ui_item_btn_goumai.png"))
		Label_Money:setText(PaymentTable.price / 100 .. "元")

	end
	Label_BuyNum:setText("X" .. PaymentTable.price / 100)
	Label_BuyNum_Cover:setText("X" .. PaymentTable.price / 100)
	Label_StoneNum:setText(reliveStoneNumber .. "个")
end

function setValue(isInTableV,isDizhuV,reliveStoneNumberV,needReliveStoneV,goodsCodeV,goodsPriceV,goodsNumberV)
	isInTable = isInTableV
	isDizhu = isDizhuV
	reliveStoneNumber = reliveStoneNumberV
	needReliveStone = needReliveStoneV
	goodsCode = goodsCodeV
	goodsPrice = goodsPriceV
	goodsNumber = goodsNumberV
end

function requestMsg()

end

function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--通过购买的数量来判断GuideID
--]]--
function switchGuideID(number)
	Common.log("switchGuideID number is " .. number)
	local id = 0;
	if Common.getOperater() == Common.UNKNOWN then
		if number <= 5 then
			id = QuickPay.Pay_Guide_stone_small_GuideTypeID
		elseif number > 10 then
			id = QuickPay.Pay_Guide_stone_large_GuideTypeID
		else
			id = QuickPay.Pay_Guide_stone_middle_GuideTypeID
		end
	else
		if number <= 5 then
			id = QuickPay.Pay_Guide_stone_small_GuideTypeID
		elseif number > 8 then
			id = QuickPay.Pay_Guide_stone_large_GuideTypeID
		else
			id = QuickPay.Pay_Guide_stone_middle_GuideTypeID
		end
	end

	return id
end

function callback_btn_logout(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--		Common.log("callback_btn_logout " .. goodsPrice)
		--		local PaymentTable = QuickPay.getPaymentTableForGift(goodsPrice, goodsCode)
		--		PaymentTable.goodsName = "复活石" .. goodsNumber .. "个";
		--		QuickPay.PayGuide(PaymentTable, PaymentTable.PayTypeID, 0, false)
		--		local operator = Common.getOperater()
		--		if operator ~= 0 then
		--		--有手机卡的时候弹出Toast提示
		--
		--		end
		mvcEngine.destroyModule(GUI_CRAZY_BUY_STONE)
		if ServerConfig.getQuickPayIsShow() then
			if Common.getOperater() == Common.UNKNOWN then
				--非短代支付
				CommDialogConfig.showPayGuide(GuideID, 0, RechargeGuidePositionID.ReliveStoneA)
			else
				--短代支付，直接调用SDK
				QuickPay.PayGuide(PaymentTable, PaymentTable.PayTypeID, RechargeGuidePositionID.ReliveStoneA, 0)
			end
		else
			Common.showToast("您的道具已耗尽，请前往‘商城’购买!", 2);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function close()
	if HallGiftShowLogic.canBeShow then
		local giftData = profile.Gift.getGiftDataTable()
		mvcEngine.createModule(GUI_GIFT_SHOW_VIEW)
		HallGiftShowLogic.setGiftData(giftData)
	else
		HallGiftShowLogic.nextView = nil
		if GameConfig.getTheCurrentBaseLayer() == GUI_CHUANGGUAN then
			mvcEngine.destroyModule(GUI_CRAZY_BUY_STONE)
		else
			TableConsole.resetCrazy()
			mvcEngine.createModule(GUI_CHUANGGUAN)
		end
	end
	isShow = false
	canBeShow = false
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	isShow = false
	canBeShow = false
end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
