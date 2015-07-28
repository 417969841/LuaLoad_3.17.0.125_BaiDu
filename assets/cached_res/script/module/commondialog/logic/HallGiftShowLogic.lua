module("HallGiftShowLogic",package.seeall)

view = nil

iv_gift_title = nil;--礼包标题图片
iv_gift_data = nil;--礼包内容图片
label_gift_text = nil;--礼包介绍文字
Label_buy_num = nil;--礼包介绍文字
btn_close = nil
btn_buy = nil
btn_alipay = nil;--
ImageView_alipay = nil;--
btn_weixin = nil;--
ImageView_weixin = nil;--

local GiftDataTable = {}
local PaymentTable = nil--礼包的支付信息
panel = nil

isShow = false
canBeShow = false
nextView = nil
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
	view = cocostudio.createView("HallGiftShow.json")
	local gui = GUI_GIFT_SHOW_VIEW
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
	isShow = true
	canBeShow =	false
	panel = cocostudio.getUIPanel(view, "Panel_22")
	LordGamePub.showDialogAmin(panel)
	initView();
	--显示微信icon或新银联icon
	showWeChatOrNewUnionpayIcon();
end

--[[--
--显示微信icon或新银联icon
--]]
function showWeChatOrNewUnionpayIcon()
	if  Common.getCurrentNameOfAppPackageIsTQ() then
		--如果当前的包名为"com.tongqu.client.lord", 则使用微信Icon
		ImageView_weixin:loadTexture(Common.getResourcePath("ui_recharge_guide_btn_weixinzhifu.png"));
	else
		--如果当前的包名不是"com.tongqu.client.lord", 则使用新银联Icon
		ImageView_weixin:loadTexture(Common.getResourcePath("ui_recharge_guide_btn_yinlianzhifu.png"));
	end
end

function initView()
	iv_gift_title = cocostudio.getUIImageView(view, "iv_gift_title")--礼包标题图片
	iv_gift_data = cocostudio.getUIImageView(view, "iv_gift_data")--礼包内容图片
	label_gift_text = cocostudio.getUILabel(view, "label_gift_text")--礼包介绍文字
	Label_buy_num = cocostudio.getUILabel(view, "Label_buy_num")--礼包介绍文字
	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_buy = cocostudio.getUIButton(view, "btn_buy")
	btn_alipay = cocostudio.getUIButton(view, "btn_alipay");
	ImageView_alipay = cocostudio.getUIImageView(view, "ImageView_alipay");
	btn_weixin = cocostudio.getUIButton(view, "btn_weixin");
	ImageView_weixin = cocostudio.getUIImageView(view, "ImageView_weixin");
end

function closeGift()
	isShow = false
	canBeShow = false
	mvcEngine.destroyModule(GUI_GIFT_SHOW_VIEW)
end

function updataTitlePhoto(path)
	local photoPath = nil;
	local id = nil;
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and iv_gift_title ~= nil then
		iv_gift_title:loadTexture(photoPath)
	end
end

function updataGiftPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and iv_gift_data ~= nil then
		iv_gift_data:loadTexture(photoPath)
	end
end

--[[--
--设置礼包数据
]]
function setGiftData(giftData)

	GiftDataTable = giftData

	Common.log("礼包数据 GiftDataTable.mGiftBagType == "..GiftDataTable.mGiftBagType)
	sendGIFTBAGID_SHOW_GIFTBAG(GiftDataTable.mGiftBagType)

	Common.log("礼包数据-------------正式数据------------")

	if #GiftDataTable["GiftBagData"] == 1 or #GiftDataTable["GiftBagData"] == 2 then
		--单核礼包
		Common.getPicFile(GiftDataTable.BannerUrl, 0, true, updataTitlePhoto)
		Common.getPicFile(GiftDataTable["GiftBagData"][1].msGiftImageUrl, 0, true, updataGiftPhoto)
		label_gift_text:setText(GiftDataTable.TitleText)
		Label_buy_num:setText("已有" .. GiftDataTable["GiftBagData"][1].mnBuyCount .. "人购买")

		if GiftDataTable.mnPaymentType == 1 then
			--RMB购买
			local isSearchSMS = true;
			if GiftDataTable.RechargeMode == 0 then
				--第三方支付
				isSearchSMS = false;
			else
				--短代
				isSearchSMS = true;
			end
			PaymentTable = QuickPay.getPaymentTableForGift(GiftDataTable["GiftBagData"][1].mnGiftPriceRMB, GiftDataTable["GiftBagData"][1].mnGiftID, isSearchSMS)
			if PaymentTable == nil then
				Common.setButtonVisible(btn_buy, false)
				Common.setButtonVisible(btn_alipay, false)
				Common.setButtonVisible(btn_weixin, false)
			else
				if PaymentTable.PayTypeID == profile.PayChannelData.WEIXIN_PAY or PaymentTable.PayTypeID == profile.PayChannelData.NEW_UNION_PAY or PaymentTable.PayTypeID == profile.PayChannelData.ALI_PAY then
					--支付宝、银联、微信
					Common.setButtonVisible(btn_buy, false)
					Common.setButtonVisible(btn_alipay, true)
					Common.setButtonVisible(btn_weixin, true)
				else
					Common.setButtonVisible(btn_buy, true)
					Common.setButtonVisible(btn_alipay, false)
					Common.setButtonVisible(btn_weixin, false)
				end
			end
		else
			--元宝购买
			PaymentTable = nil
			Common.setButtonVisible(btn_buy, true)
			Common.setButtonVisible(btn_alipay, false)
			Common.setButtonVisible(btn_weixin, false)
		end
	else
	--双核礼包

	end
end

function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--如果闯关结束的购买复活石窗口可以显示,则显示
		if CrazyBuyStoneLogic.canBeShow == true then
			mvcEngine.createModule(GUI_CRAZY_BUY_STONE)
			return
		end
		--如果闯关结束的闯关结果窗口可以显示,则显示
		if CrazyResultLogic.canBeShow == true then
			mvcEngine.createModule(GUI_CRAZY_RESULT)
			return
		end
		--如果在闯关中且礼包页面在闯关结果弹框后显示,则关闭时回到闯关主页
		if nextView ~= nil and nextView == GUI_CHUANGGUAN then
			nextView = nil
			CrazyResultLogic.isShow = false
			CrazyBuyStoneLogic.isShow = false
			TableConsole.resetCrazy()
			mvcEngine.createModule(GUI_CHUANGGUAN)
			return
		end
		--抬起
		local timeStamp = Common.getDataForSqlite(CommSqliteConfig.ShowGiftCloseTimeStamp);
		if timeStamp == nil or timeStamp == "" then
			timeStamp = 0;
		else
			timeStamp = tonumber(timeStamp);
		end
		local nowStamp = Common.getServerTime();
--		if (nowStamp - timeStamp) / (3600 * 18) > 1 then
		if isShowAgainClose() then
			if GameConfig.getTheCurrentBaseLayer() ~= GUI_SHOP then
				mvcEngine.createModule(GUI_GIFT_CLOSE_VIEW)
			else
				mvcEngine.destroyModule(GUI_GIFT_SHOW_VIEW)
			end
		else
			mvcEngine.destroyModule(GUI_GIFT_SHOW_VIEW)
			-- 礼包是2级，充值引导是3级（关掉2级页面时，会把3级页面一起关掉）
			if MatchRechargeCoin.bIsRechargeWaiting == true then
				if LordGamePub.logicGiveCoin() then
					MatchRechargeCoin.sendPochansongjin()
				else
					MatchRechargeCoin.showChongzhiyindao()
				end
			else
				if LordGamePub.logicGiveCoin() then
					--可以破产送金
					--能破产送金，就发消息
					sendMANAGERID_GIVE_AWAY_GOLD(-1)
				end
			end
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_buy(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_GIFT_SHOW_VIEW)

		if MatchRechargeCoin.bIsRechargeWaiting == true then
			mvcEngine.createModule(GUI_MATCH_TABLE_DENGDAIDAOZHANG);
		end

		if GiftDataTable.mnPaymentType == 1 then
			--RMB购买
			QuickPay.PayGuide(PaymentTable, PaymentTable.PayTypeID, 0, false)
		else
			--元宝购买
			if profile.User.getSelfYuanBao() >= GiftDataTable["GiftBagData"][1].mnGiftPriceYuanBao then
				sendGIFTBAGID_BUY_GIFTBAG(GiftDataTable["GiftBagData"][1].mnGiftID)
			else
				local num =  GiftDataTable["GiftBagData"][1].mnGiftPriceYuanBao - profile.User.getSelfYuanBao()
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, num, RechargeGuidePositionID.PayGiftPositionA)
			end
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_alipay(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_GIFT_SHOW_VIEW)
		if GiftDataTable.mnPaymentType == 1 then
			--RMB购买
			QuickPay.PayGuide(PaymentTable, profile.PayChannelData.ALI_PAY, 0, false)
		else
			--元宝购买
			if profile.User.getSelfYuanBao() >= GiftDataTable["GiftBagData"][1].mnGiftPriceYuanBao then
				sendGIFTBAGID_BUY_GIFTBAG(GiftDataTable["GiftBagData"][1].mnGiftID)
			else
				local num =  GiftDataTable["GiftBagData"][1].mnGiftPriceYuanBao - profile.User.getSelfYuanBao()
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, num, RechargeGuidePositionID.PayGiftPositionA)
			end
		end
		if TableConsole.mode == TableConsole.MATCH and GameConfig.getTheCurrentBaseLayer() == GUI_TABLE and MatchRechargeCoin.bIsRechargeWaiting == true then
			Common.log("如果是在比赛中的牌局里面，则弹出等待到账")
			mvcEngine.createModule(GUI_MATCH_TABLE_DENGDAIDAOZHANG)
			return
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_weixin(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_GIFT_SHOW_VIEW)
		if GiftDataTable.mnPaymentType == 1 then
			--RMB购买
			if  Common.getCurrentNameOfAppPackageIsTQ() then
				--如果当前的包名为"com.tongqu.client.lord", 则使用微信支付
				QuickPay.PayGuide(PaymentTable, profile.PayChannelData.WEIXIN_PAY, 0, false);
			else
				--如果当前的包名不是"com.tongqu.client.lord", 则使用银联支付
				QuickPay.PayGuide(PaymentTable, profile.PayChannelData.NEW_UNION_PAY, 0, false);
			end
		else
			--元宝购买
			if profile.User.getSelfYuanBao() >= GiftDataTable["GiftBagData"][1].mnGiftPriceYuanBao then
				sendGIFTBAGID_BUY_GIFTBAG(GiftDataTable["GiftBagData"][1].mnGiftID)
			else
				local num =  GiftDataTable["GiftBagData"][1].mnGiftPriceYuanBao - profile.User.getSelfYuanBao()
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, num, RechargeGuidePositionID.PayGiftPositionA)
			end
		end
		if TableConsole.mode == TableConsole.MATCH and GameConfig.getTheCurrentBaseLayer() == GUI_TABLE and MatchRechargeCoin.bIsRechargeWaiting == true then
			Common.log("如果是在比赛中的牌局里面，则弹出等待到账")
			mvcEngine.createModule(GUI_MATCH_TABLE_DENGDAIDAOZHANG)
			return
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--判断是否应该弹出礼包确认关闭框
--]]--
function isShowAgainClose()
	local ShowAgainCloseTable = Common.LoadTable("ShowAgainCloseTable");
	if  ShowAgainCloseTable == nil or ShowAgainCloseTable == "" then
		--可以弹出（第一次调用）
		ShowAgainCloseTable = true
		Common.SaveTable("ShowAgainCloseTable", ShowAgainCloseTable)
	else
		--不能弹出
		ShowAgainCloseTable = false
	end
	return ShowAgainCloseTable
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
