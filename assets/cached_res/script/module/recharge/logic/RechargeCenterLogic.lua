module("RechargeCenterLogic", package.seeall)

view = nil

local scene = nil
--panel
panel_recharge_list = nil --支付列表(支付宝、银联、短代)
panel_recharge_history = nil --支付历史
panel_recharge_card = nil --支付卡列表
--控件
text_self_coin = nil --自己的金币数
text_self_yuanbao = nil --自己的元宝数
btn_back = nil--返回键
btn_vip = nil--vip
maskImageView = nil;--VIP遮罩
lab_vipbili = nil
Button_chongzhi = nil;--
ImageView_35 = nil --vip标签
Image_VipIcon = nil;--vip icon
Button_AddYuanBao = nil
--img控件
img_czhistory = nil --充值历史tab
img_duanxin = nil--短息tab
img_alipay = nil--支付宝
img_wechat = nil --微信
img_yinlian = nil --银联
img_czk = nil--充值卡
img_iap = nil --iap
img_czhistorytitle = nil --充值历史tab
img_duanxintitle = nil--短息tab
img_alipaytitle = nil--支付宝
img_weixintitle = nil--微信文字
img_yinliantitle = nil --银联
img_czktitle = nil--充值卡
img_iaptitle = nil --iap
lab_vipnum = nil
img_vipload = nil
lab_vip = nil
Image_Operators = nil;
Image_OperatorsTitle = nil;
Panel_YuanBao = nil;--元宝
Image_YuanBao = nil;
Image_YuanBaoTitle = nil;
AtlasLabel_NextVipLevel = nil;
Image_CheckBox1 = nil;--
Label_CardValue1 = nil;--
Image_CheckBox2 = nil;--
Label_CardValue2 = nil;--
Image_CheckBox3 = nil;--
Label_CardValue3 = nil;--
Image_CheckBox4 = nil;--
Label_CardValue4 = nil;--
Image_CheckBox5 = nil;--
Label_CardValue5 = nil;--

CardCheckBoxUITable = {};--充值卡选择框UItable
CardValueUITable = {};--充值卡面值UItable
local CurrentSelectIndex = 1;--当前选中的下标

--变量
local RECHARGE_LIST_ALIPAY = 1 --支付宝充值列表状态
local RECHARGE_LIST_UNION = 2 --银联充值列表状态
local RECHARGE_LIST_SMS = 3 --短信充值列表状态
local RECHARGE_CARD = 4 --充值卡支付列表状态
local RECHARGE_WEIXIN = 5 --微信支付列表状态
local RECHARGE_91 = 11 --91支付
local RECHARGE_LIST_NEW_UNION = 29 --新银联
local RECHARGE_IAP = 31 --iap支付
local RECHARGE_HAIMA = 49 --海马ios支付
local RECHARGE_WOJIA = 82 --同趣联通wo+

local MODE_YUANBAO = 1 --元宝充值选择
local MODE_HISTORY = 2 --支付历史模式选择
--滑动层
payDataScrollView = nil --支付列表ScrollView
scroll_list = nil--支付历史滑动层
--
local RechargeCardPrice = 0--充值卡价格
RechargeCardInfoTable = {}--充值卡信息
local Pd_frpId = nil --充值卡渠道编码
RechargeRecordTable = {}--充值历史
local PageSize = 20--充值历史
local PageStartID = 0--充值历史

--充值卡界面控件
img_yidong = nil
img_liantong = nil
img_dianxin = nil
btn_czkok = nil
img_yidong1 = nil
img_dianxin1 = nil
img_liantong1 = nil
--label_recharge_card_info = nil
panel_czlist = nil
local RechargeCard_YIDONG = 0--移动
local RechargeCard_LIANDONG = 1--联通
local RechargeCard_DIANXIN = 2--电信
local CurrentCardType = 0;--当前充值卡类型
local yidong = {10,30,50,100,300}
local liantong = {20,30,50,100,300}
local dianxin = {50,100}
--imgCxkBtnList = {} --充值卡按钮list
-- 支付渠道编码
local YIDONG_FRPID = "SZX";
local LIANTONG_FRPID = "UNICOM";
local DIANXIN_FRPID = "TELECOM";

currentTxtInput = nil; --当前文本输入框
currentTxtShow = nil; --当前文本显示
defaultValueLabelsTable ={}; --label的默认值table
defaultValueLabel = "";--label默认值

currentTab = 0;--当前tab

function onKeypad(event)
	if event == "backClicked" then
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then

	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_RECHARGECENTER;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("RechargeCenter.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("RechargeCenter.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("RechargeCenter_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameConfig.setTheCurrentBaseLayer(GUI_RECHARGE_CENTER)
	scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(view)

	initRechargeCenterView();
	--保存用于显示的label默认值
	CurrentSelectIndex = 1;
	CurrentCardType = 0;

	local ShowFirstGiftTime = Common.getDataForSqlite(CommSqliteConfig.RechargeCenterShowFirstGiftTime.."_"..profile.User.getSelfUserID())
	local datecha, now = Common.getTimeDifference(ShowFirstGiftTime)

	if datecha > 24 then
		Common.showProgressDialog("数据加载中...")
		sendGIFTBAGID_REQUIRE_GIFTBAG(QuickPay.First_Pay_GiftTypeID, 1)
		Common.setDataForSqlite(CommSqliteConfig.RechargeCenterShowFirstGiftTime.."_"..profile.User.getSelfUserID(),now)
	end


	local function delaySentMessage()
		--请求充值历史
		sendGET_RECHARGE_RECORD(PageStartID,PageSize)
		sendMANAGERID_GET_VIP_MSG()
	end
	LordGamePub.runSenceAction(view,delaySentMessage,false)
	--预加载动画
	GameArmature.loadRechargeArmature()
	giftAnimation(Button_chongzhi)
end

function requestMsg()
end

--[[--
--初始化登陆界面
]]
function initRechargeCenterView()
	panel_recharge_list = cocostudio.getUIPanel(view, "panel_recharge_list") --支付列表(支付宝、银联、短代)
	panel_recharge_history = cocostudio.getUIPanel(view, "panel_recharge_history") --支付模式选择
	Panel_YuanBao = cocostudio.getUIPanel(view, "Panel_YuanBao") --元宝界面
	panel_recharge_card = cocostudio.getUIPanel(view, "panel_recharge_card") --支付卡列表

	text_self_coin = cocostudio.getUILabel(view, "text_self_coin")
	text_self_yuanbao = cocostudio.getUILabel(view, "text_self_yuanbao")
	payDataScrollView = cocostudio.getUIScrollView(view, "recharge_list_sv") --支付列表
	scroll_list = cocostudio.getUIScrollView(view, "scroll_list") --充值历史
	btn_back = cocostudio.getUIButton(view, "btn_back")
	btn_vip = cocostudio.getUIButton(view, "btn_vip")
	maskImageView = cocostudio.getUIImageView(view, "maskImageView");
	lab_vipbili = cocostudio.getUILabel(view, "lab_vipbili")
	ImageView_35 = cocostudio.getUIImageView(view, "ImageView_35")
	Image_VipIcon = cocostudio.getUIImageView(view, "Image_VipIcon")
	Button_chongzhi = cocostudio.getUIButton(view, "Button_chongzhi");--充值按钮
	Button_AddYuanBao = cocostudio.getUIImageView(view, "Button_AddYuanBao")
	Button_AddYuanBao:setVisible(false)

	label_card_number = cocostudio.getUILabel(view, "Label_card_number")--充值卡卡号label

	--img tab
	Image_YuanBao = cocostudio.getUIImageView(view, "Image_YuanBao")
	Image_YuanBaoTitle = cocostudio.getUIImageView(view, "Image_YuanBaoTitle")
	img_czhistory = cocostudio.getUIImageView(view, "img_czhistory")
	img_duanxin = cocostudio.getUIImageView(view, "img_duanxin")
	img_alipay = cocostudio.getUIImageView(view, "img_alipay")
	img_wechat = cocostudio.getUIImageView(view, "img_wechat")
	img_yinlian = cocostudio.getUIImageView(view, "img_yinlian")
	img_czk = cocostudio.getUIImageView(view, "img_czk")
	img_iap = cocostudio.getUIImageView(view, "img_iap")

	img_czhistorytitle = cocostudio.getUIImageView(view, "img_czhistorytitle")
	img_duanxintitle = cocostudio.getUIImageView(view, "img_duanxintitle")
	img_alipaytitle = cocostudio.getUIImageView(view, "img_alipaytitle")
	img_weixintitle = cocostudio.getUIImageView(view, "img_weixintitle")
	img_yinliantitle = cocostudio.getUIImageView(view, "img_yinliantitle")
	img_czktitle = cocostudio.getUIImageView(view, "img_czktitle")
	img_iaptitle = cocostudio.getUIImageView(view, "img_iaptitle")
	--充值卡充值界面
	img_yidong = cocostudio.getUIImageView(view, "img_yidong")
	img_liantong = cocostudio.getUIImageView(view, "img_liantong")
	img_dianxin = cocostudio.getUIImageView(view, "img_dianxin")
	img_yidong1 = cocostudio.getUIImageView(view, "img_yidong1")
	img_dianxin1 = cocostudio.getUIImageView(view, "img_dianxin1")
	img_liantong1 = cocostudio.getUIImageView(view, "img_liantong1")
	btn_czkok = cocostudio.getUIButton(view, "btn_czkok")
	panel_czlist = cocostudio.getUIPanel(view, "Panel_czlist")
	lab_vipnum = cocostudio.getUILabelAtlas(view, "lab_vipnum")
	img_vipload =  cocostudio.getUILoadingBar(view, "img_vipload")
	Image_Operators = cocostudio.getUIImageView(view, "Image_Operators");
	Image_OperatorsTitle = cocostudio.getUIImageView(view, "Image_OperatorsTitle");
	lab_vip = cocostudio.getUILabel(view, "lab_vip")
	AtlasLabel_NextVipLevel = cocostudio.getUILabelAtlas(view, "AtlasLabel_NextVipLevel")
	Image_CheckBox1 = cocostudio.getUIImageView(view, "Image_CheckBox1");
	Label_CardValue1 = cocostudio.getUILabel(view, "Label_CardValue1");
	Image_CheckBox2 = cocostudio.getUIImageView(view, "Image_CheckBox2");
	Label_CardValue2 = cocostudio.getUILabel(view, "Label_CardValue2");
	Image_CheckBox3 = cocostudio.getUIImageView(view, "Image_CheckBox3");
	Label_CardValue3 = cocostudio.getUILabel(view, "Label_CardValue3");
	Image_CheckBox4 = cocostudio.getUIImageView(view, "Image_CheckBox4");
	Label_CardValue4 = cocostudio.getUILabel(view, "Label_CardValue4");
	Image_CheckBox5 = cocostudio.getUIImageView(view, "Image_CheckBox5");
	Label_CardValue5 = cocostudio.getUILabel(view, "Label_CardValue5");
	table.insert(CardCheckBoxUITable, Image_CheckBox1);
	table.insert(CardCheckBoxUITable, Image_CheckBox2);
	table.insert(CardCheckBoxUITable, Image_CheckBox3);
	table.insert(CardCheckBoxUITable, Image_CheckBox4);
	table.insert(CardCheckBoxUITable, Image_CheckBox5);
	table.insert(CardValueUITable, Label_CardValue1);
	table.insert(CardValueUITable, Label_CardValue2);
	table.insert(CardValueUITable, Label_CardValue3);
	table.insert(CardValueUITable, Label_CardValue4);
	table.insert(CardValueUITable, Label_CardValue5);
	img_iap:setVisible(false)

	updataUserInfo()
	setTabView(MODE_YUANBAO);
end

--[[--
--选择显示的模式
--]]
function chooseRechargeShow()
	GameConfig.setRechargeShowState(0);
	--ios平台的话直接显示列表,andorid的话，显示支付宝 Common.platform == Common.TargetIos
	if Common.platform == Common.TargetIos then
		--ios 支付tab
		img_yinlian:setVisible(false)
		img_yinlian:setTouchEnabled(false)

		img_czk:setVisible(false)
		img_czk:setTouchEnabled(false)

		img_duanxin:setVisible(false)
		img_duanxin:setTouchEnabled(false)

		if GameConfig.PaymentForIphone == GameConfig.PAYMENT_SMS then
			--短代
			img_alipay:setVisible(true)
			img_alipay:setTouchEnabled(true)
			img_wechat:setVisible(true)
			img_wechat:setTouchEnabled(true)
			local operator = Common.getOperater()
			if operator ~= 0 then
				local CurrentList, payChannel = getSMSPayListAndPayChannel()
				if CurrentList == nil or #CurrentList == 0 or payChannel == nil then
					img_duanxin:setVisible(false)
					img_duanxin:setTouchEnabled(false)
					changeRechargeShow(RECHARGE_LIST_ALIPAY)
				else
					img_duanxin:setVisible(true)
					img_duanxin:setTouchEnabled(true)
					changeRechargeShow(RECHARGE_LIST_SMS)
				end
			else
				img_iap:setVisible(false)
				img_iap:setTouchEnabled(false)
				panel_recharge_card:setVisible(false)
				changeRechargeShow(RECHARGE_LIST_ALIPAY)
			end
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_IAP then
			img_alipay:setVisible(false)
			img_alipay:setTouchEnabled(false)
			img_wechat:setVisible(false)
			img_wechat:setTouchEnabled(false)
			changeRechargeShow(RECHARGE_IAP)
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_91 then
			img_alipay:setVisible(false)
			img_alipay:setTouchEnabled(false)
			img_wechat:setVisible(false)
			img_wechat:setTouchEnabled(false)
			changeRechargeShow(RECHARGE_91)
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_HAIMA then
			img_alipay:setVisible(false)
			img_alipay:setTouchEnabled(false)
			img_wechat:setVisible(false)
			img_wechat:setTouchEnabled(false)
			changeRechargeShow(RECHARGE_HAIMA)


		end
	else
		--android 支付
		img_iap:setVisible(false)
		img_iap:setTouchEnabled(false)
		--如果有手机卡，显示短信充值
		--运营商
		local operator = Common.getOperater()
		if operator ~= 0 then
			local CurrentList, payChannel = getSMSPayListAndPayChannel()
			if CurrentList == nil or #CurrentList == 0 or payChannel == nil then
				img_duanxin:setVisible(false)
				img_duanxin:setTouchEnabled(false)
				changeRechargeShow(RECHARGE_LIST_ALIPAY)
			else
				img_duanxin:setVisible(true)
				img_duanxin:setTouchEnabled(true)
				changeRechargeShow(RECHARGE_LIST_SMS)
			end
		else
			changeRechargeShow(RECHARGE_LIST_ALIPAY)
		end
	end
end


--[[--
--礼包动画
--]]--
function giftAnimation(panel)
	panel:setVisible(false) --隐藏之前的聊天按钮，显示小喇叭
	local trumpetArmature = nil
	trumpetArmature = CCArmature:create("libaodonghua"); --创建动画
	trumpetArmature:getAnimation():playByIndex(0); --播放动画组的第一个动画,非循环
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(2))
	array:addObject(CCCallFunc:create(
		function ()
			trumpetArmature:getAnimation():playByIndex(0); --播放动画组的第一个动画，并设置每2秒播放一次
		end
	))
	local seq = CCSequence:create(array)
	trumpetArmature:setPosition(ccp(panel:getPosition().x, panel:getPosition().y)) --设置动画的位置
	trumpetArmature:setScale(0.8);
	view:addChild(trumpetArmature)
	view:runAction(CCRepeatForever:create(seq))
end

function updataUserInfo()
	Common.log("Signal_BASEID_GET_BASEINFO updataUserInfo")
	if text_self_coin ~= nil and text_self_yuanbao ~= nil then
		text_self_coin:setText(profile.User.getSelfCoin())
		text_self_yuanbao:setText(profile.User.getSelfYuanBao())
	end
end

--[[--设置充值卡金额]]
function setRechargeCardPrice(index, type)
	if type == RechargeCard_YIDONG then

		Pd_frpId = YIDONG_FRPID
	elseif type == RechargeCard_LIANDONG then
		Pd_frpId = LIANTONG_FRPID
	else
		Pd_frpId = DIANXIN_FRPID
	end
	RechargeCardPrice = price
	local CurrentList = profile.PayChannelData.getRechargeCardShowListData()

	for key, var in ipairs(CurrentList) do
		if var.price == RechargeCardPrice * 100 then
			RechargeCardInfoTable = var
			break
		end
	end
end

--[[--获取充值卡金额]]
function getRechargeCardPrice()
	return RechargeCardPrice
end


local photoViwWidth = 223;
local photoViwHeight = 214;

--[[--
--显示支付列表数据(支付宝、微信、银联、短信计费)
]]
function showPayScrollView(CurrentList, PayTypeID)

	payDataScrollView:removeAllChildren();

	local cellSize = #CurrentList
	local viewW = 0
	local viewWmax = 880;
	local viewHMax = 330;
	local viewH = 0
	local viewX = 10 * GameConfig.ScaleAbscissa;
	local viewY = 38 * GameConfig.ScaleOrdinate

	local cellWidth = 145; --每个元素的宽
	local cellHeight = 277; --每个元素的高

	local hangSize = 1; --行数
	local lieSize = math.ceil(cellSize / hangSize); --列数 (向上取整)
	local spacingW = 0; --横向间隔
	local spacingH = 20; --纵向间隔
	local leftSpacing = 6;--左侧间隔

	--为了适配凑数
	--if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
	--如果手机当前的分比率小于1.6大于1.4
	--viewW = lieSize * cellWidth + spacingW * (lieSize + 4);
	--else
	--大于1.6, 小于1.4(目前ipad留黑边)
	viewW = lieSize * (cellWidth + spacingW) + spacingW * 2;
	--end

	if viewW > viewWmax then
		viewWmax = viewWmax--设置的显示区域必须比真实区域小
		viewW = viewW
	else
		viewWmax = viewW
		viewW = viewWmax + 1
	end

	payDataScrollView:setSize(CCSizeMake(viewWmax, viewHMax));
	payDataScrollView:setInnerContainerSize(CCSizeMake(viewW, viewHMax));
	payDataScrollView:setPosition(ccp(viewX, viewY));
	--适配需要：对列表进行缩放横坐标和纵坐标的缩放
	payDataScrollView:setScaleX(GameConfig.ScaleAbscissa);
	payDataScrollView:setScaleY(GameConfig.ScaleOrdinate);

	local PayScrollList = {};

	for i = 1, cellSize do
		-- 商品名称
		local goodsName = CurrentList[i].goodsName
		-- 商品的具体描述
		local goodsDetail = CurrentList[i].goodsDetail
		-- 本次支付的总费
		local goodsPriceDetail = CurrentList[i].goodsPriceDetail
		-- 优惠百分比(%) 例：10
		local mnDiscount = CurrentList[i].mnDiscount
		-- 是否可显示
		local mbIsShow = CurrentList[i].mbIsShow
		-- 支付子类型 默认为0
		local Subtype = CurrentList[i].mnSubtype
		-- 价格(单位：分)
		local price = CurrentList[i].price

		--背景图片
		local bgurl = "bg_bag_item.png"

		--底层layer
		local layout = ccs.image({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			image = Common.getResourcePath(bgurl),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		layout:setScale9Enabled(true);
		layout:setAnchorPoint(ccp(0.5, 0.5));
		--按钮
		local button = ccs.button({
			--默认居中对齐
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			text = "",
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = {
				[ccs.TouchEventType.began] = function(uiwidget)
					layout:setScale(1.1)
				end,
				[ccs.TouchEventType.moved] = function(uiwidget)

				end,
				[ccs.TouchEventType.ended] = function(uiwidget)
					layout:setScale(1)
					local isExchange = false
					local function callPaymentFunc()
						PaymentMethod.callPayment(CurrentList[i],PayTypeID,0,isExchange,0)
					end
					if PayTypeID == profile.PayChannelData.HUAJIAN_DIANXIN_PAY or PayTypeID == profile.PayChannelData.SMS_ONLINE or PayTypeID == profile.PayChannelData.HUAJIAN_LIANTONG_PAY then
						RechargeConfirmLogic.setData(CurrentList[i],PayTypeID,isExchange)
						mvcEngine.createModule(GUI_RECHARGE_CONFIRM)
					else
						callPaymentFunc()
					end
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
					layout:setScale(1)
				end,
			}
		})
		--标题
		local labelName = ccs.label({
			text = goodsName,
			color = ccc3(65, 41, 25),
		})
		labelName:setFontSize(22)
		labelName:setTouchEnabled(false)

		--价格
		local labelPrice = ccs.label({
			text = "￥" ..  math.floor(price / 100),
		})
		local priceBg = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("yuan.png"),
			size = CCSizeMake(87, 30),
		})
		priceBg:setScale9Enabled(true);
		--元宝标题
		local yuanbaoimg = ""
		if price <= 600 then
			yuanbaoimg = "ic_charge_yuanbao1.png"
		elseif price <= 2000 then
			yuanbaoimg = "ic_charge_yuanbao2.png"
		elseif price <= 5000 then
			yuanbaoimg = "ic_charge_yuanbao3.png"
		elseif price <= 10000 then
			yuanbaoimg = "ic_charge_yuanbao4.png"
		else
			yuanbaoimg = "ic_charge_yuanbao5.png"
		end
		local yuanbaoBg = ccs.image({
			scale9 = false,
			image = Common.getResourcePath(yuanbaoimg),
			size = CCSizeMake(182, 145),
		})
		yuanbaoBg:setScale(0.6)
		--最超值标题 此处目前省略了短信支付不作为显示
		local chaozhiimg = ""
		if GameConfig.getRechargeShowState() ~= RECHARGE_LIST_SMS then
			if i == 0 then
				chaozhiimg = "ui_charge_label_zuihuasuan.png"
			elseif i == 2 then
				chaozhiimg = "ui_charge_label_zuiremen.png"
			end
		end

		local chaozhiBg = ccs.image({
			scale9 = false,
			image = Common.getResourcePath(chaozhiimg),
			size = CCSizeMake(123, 110),
		})

		labelPrice:setTouchEnabled(false)
		--赠送
		local labelDiscount = ccs.label({
			text = "(赠送" .. mnDiscount .. "%)",
			color = ccc3(65,41,25),
		})
		labelDiscount:setTouchEnabled(false)

		local posX = i * spacingW + (i - 1/2) * cellWidth + leftSpacing;
		local posY = cellHeight /2
		--设置商品名称
		local labelNameY = 90; -- 80
		SET_POS(labelName,0 , labelNameY);
		--设置商品价格背景
		local priceBgY = -85; -- 30
		SET_POS(priceBg, 0,priceBgY)
		SET_POS(labelPrice, 0,0)
		--设置商品优惠百分比
		local labelDiscountY = -50; --50
		SET_POS(labelDiscount, 0, labelDiscountY)
		local yuanbaoBgY = 20; --150
		SET_POS(yuanbaoBg, 0, yuanbaoBgY)
		--设置每个Item的位置 layout:getSize().width / 2 layout:getSize().height / 2
		SET_POS(button, 0, 0)
		SET_POS(chaozhiBg, (chaozhiBg:getSize().width - layout:getSize().width) / 2, (layout:getSize().height - chaozhiBg:getSize().height) / 2 - 3)
		SET_POS(layout,posX, posY);
		layout:addChild(labelName)
		layout:addChild(priceBg)
		priceBg:addChild(labelPrice)
		layout:addChild(yuanbaoBg)
		layout:addChild(chaozhiBg)
		if mnDiscount > 0 then
			layout:addChild(labelDiscount)
		end
		layout:addChild(button);

		table.insert(PayScrollList, layout);

		payDataScrollView:addChild(layout);
	end

	local function callbackShowImage(index)
	end

	LordGamePub.showLandscapeList(PayScrollList, callbackShowImage);
end

--[[--
--获取短代支付的支付列表和渠道
--@return #table CurrentList 支付列表
--@return number PayChannel 支付渠道
--]]
function getSMSPayListAndPayChannel()
	local CurrentList = {}
	local PayChannel = nil
	if Common.getOperater() == Common.CHINA_MOBILE then
		--移动
		if GameConfig.PAYMENT_METHOD_STATUS == GameConfig.PAYMENT_SHOW_MM_OTHERS then
			--MM
			CurrentList = profile.PayChannelData.getMMShowListData();
			PayChannel = profile.PayChannelData.MM_PAY_V2;
		elseif GameConfig.PAYMENT_METHOD_STATUS == GameConfig.PAYMENT_SHOW_SMSONLINE_OTHERS then
			--移动短代
			CurrentList = profile.PayChannelData.getSMSOnlineShowListData()
			PayChannel = profile.PayChannelData.SMS_ONLINE
		elseif GameConfig.PAYMENT_METHOD_STATUS == GameConfig.PAYMENT_SHOW_EPAY then
			--宜支付
			CurrentList = profile.PayChannelData.getEPayShowListData()
			PayChannel = profile.PayChannelData.EPAY
		elseif GameConfig.PAYMENT_METHOD_STATUS == GameConfig.PAYMENT_SHOW_YINBEIKE_CMCC then
			--银贝壳移动
			CurrentList = profile.PayChannelData.getYINBEIKEPayShowListData()
			PayChannel = profile.PayChannelData.YINBEIKEPAY_CMCC
		elseif GameConfig.PAYMENT_METHOD_STATUS == GameConfig.PAYMENT_SHOW_HONGRUAN_SDK_CMCC then
			--红软移动
			CurrentList = profile.PayChannelData.getHongRuanPayShowListData_CMCC()
			PayChannel = profile.PayChannelData.HONGRUAN_SDK_CMCC
		end

	elseif Common.getOperater() == Common.CHINA_UNICOM then
		--联通
		if GameConfig.PAYMENT_METHOD_STATUS_LIANTONG == GameConfig.PAYMENT_SHOW_WOSTORE_OTHERS then
			--沃商店
			CurrentList = profile.PayChannelData.getUnicomShowListData()
			PayChannel = profile.PayChannelData.SMS_UNICOM
		elseif GameConfig.PAYMENT_METHOD_STATUS_LIANTONG == GameConfig.PAYMENT_SHOW_HUAJIAN_UNICOM_OTHERS then
			--联通短代
			CurrentList = profile.PayChannelData.getHuaJianUnicomTableShowListData()
			PayChannel = profile.PayChannelData.HUAJIAN_LIANTONG_PAY
		elseif GameConfig.PAYMENT_METHOD_STATUS_LIANTONG == GameConfig.PAYMENT_SHOW_EPAY then
			--宜支付
			CurrentList = profile.PayChannelData.getEPayShowListData()
			PayChannel = profile.PayChannelData.EPAY
		elseif GameConfig.PAYMENT_METHOD_STATUS_LIANTONG == GameConfig.PAYMENT_SHOW_YINBEIKE_UNI then
			--银贝壳联通
			CurrentList = profile.PayChannelData.getYINBEIKEPayShowListData_UNI()
			PayChannel = profile.PayChannelData.YINBEIKEPAY_UNI
		elseif GameConfig.PAYMENT_METHOD_STATUS_LIANTONG == GameConfig.PAYMENT_SHOW_HONGRUAN_SDK_UNICOM then
			--红软联通
			CurrentList = profile.PayChannelData.getHongRuanPayShowListData_UNI()
			PayChannel = profile.PayChannelData.HONGRUAN_SDK_UNICOM
		elseif GameConfig.PAYMENT_METHOD_STATUS_LIANTONG == GameConfig.PAYMENT_SHOW_WOJIA then
			--同趣联通wo+
			CurrentList = profile.PayChannelData.getWoJiaAllListData()
			PayChannel = profile.PayChannelData.RECHARGE_WOJIA
		end
	elseif Common.getOperater() == Common.CHINA_TELECOM then
		if GameConfig.PAYMENT_METHOD_STATUS_DIANXIN == GameConfig.PAYMENT_SHOW_HUAJIAN_OTHERS then
			--电信短代
			CurrentList = profile.PayChannelData.getHuaJianTelecomTableShowListData()
			PayChannel = profile.PayChannelData.HUAJIAN_DIANXIN_PAY
		elseif GameConfig.PAYMENT_METHOD_STATUS_DIANXIN == GameConfig.PAYMENT_SHOW_EPAY then
			--宜支付
			CurrentList = profile.PayChannelData.getEPayShowListData()
			PayChannel = profile.PayChannelData.EPAY
		elseif GameConfig.PAYMENT_METHOD_STATUS_DIANXIN == GameConfig.PAYMENT_SHOW_YINBEIKE_CT then
			--银贝壳电信
			CurrentList = profile.PayChannelData.getYINBEIKEPayShowListData_CT()
			PayChannel = profile.PayChannelData.YINBEIKEPAY_CT
		elseif GameConfig.PAYMENT_METHOD_STATUS_DIANXIN == GameConfig.PAYMENT_SHOW_HONGRUAN_SDK_CT then
			--红软电信
			CurrentList = profile.PayChannelData.getHongRuanPayShowListDataCMCC_CT()
			PayChannel = profile.PayChannelData.HONGRUAN_SDK_CT
		end
	end

	return CurrentList, PayChannel;
end


--[[--
-- 改变支付中心显示状态
--#number state 要显示的状态
]]
function changeRechargeShow(state)
	if GameConfig.getRechargeShowState() == state then
		return;
	end
	GameConfig.setRechargeShowState(state)

	if GameConfig.getRechargeShowState() == RECHARGE_LIST_ALIPAY then
		--支付宝支付
		panel_recharge_history:setVisible(false)
		panel_recharge_list:setVisible(true)
		panel_recharge_card:setVisible(false)

		panel_recharge_history:setTouchEnabled(false)
		panel_recharge_list:setTouchEnabled(true)
		panel_recharge_card:setTouchEnabled(false)
		payDataScrollView:setTouchEnabled(true)

		panel_recharge_history:setZOrder(5)
		panel_recharge_list:setZOrder(6)
		panel_recharge_card:setZOrder(5)

		--tab
		img_duanxin:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_alipay:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		img_wechat:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_yinlian:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_czk:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		--tabtitle
		--		img_czhistorytitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_record.png"))
		img_duanxintitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_note.png"))
		img_alipaytitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_zhifubao2.png"))
		img_weixintitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_weixin.png"))
		img_yinliantitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_unionpay.png"))
		img_czktitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_card.png"))
		img_iaptitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_official.png"))

		local CurrentList = profile.PayChannelData.getAliPayShowListData()
		showPayScrollView(CurrentList, profile.PayChannelData.ALI_PAY)

	elseif GameConfig.getRechargeShowState() == RECHARGE_WEIXIN then
		--微信支付
		panel_recharge_history:setVisible(false)
		panel_recharge_list:setVisible(true)
		panel_recharge_card:setVisible(false)

		panel_recharge_history:setTouchEnabled(false)
		panel_recharge_list:setTouchEnabled(true)
		panel_recharge_card:setTouchEnabled(false)
		payDataScrollView:setTouchEnabled(true)

		panel_recharge_history:setZOrder(5)
		panel_recharge_list:setZOrder(6)
		panel_recharge_card:setZOrder(5)

		--tab
		img_duanxin:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_alipay:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_wechat:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		img_yinlian:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_czk:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		--tabtitle
		--		img_czhistorytitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_record.png"))
		img_duanxintitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_note.png"))
		img_alipaytitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_zhifubao.png"))
		img_weixintitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_weixin2.png"))
		img_yinliantitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_unionpay.png"))
		img_czktitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_card.png"))
		img_iaptitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_official.png"))

		local CurrentList = profile.PayChannelData.getWeiXinShowListData()
		showPayScrollView(CurrentList, profile.PayChannelData.WEIXIN_PAY)

	elseif GameConfig.getRechargeShowState() == RECHARGE_LIST_NEW_UNION then
		--新银联支付
		panel_recharge_history:setVisible(false)
		panel_recharge_list:setVisible(true)
		panel_recharge_card:setVisible(false)

		panel_recharge_history:setTouchEnabled(false)
		panel_recharge_list:setTouchEnabled(true)
		panel_recharge_card:setTouchEnabled(false)
		payDataScrollView:setTouchEnabled(true)

		panel_recharge_history:setZOrder(5)
		panel_recharge_list:setZOrder(6)
		panel_recharge_card:setZOrder(5)
		--tab
		img_duanxin:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_alipay:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_wechat:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_yinlian:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		img_czk:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		--tabtitle
		--		img_czhistorytitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_record.png"))
		img_duanxintitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_note.png"))
		img_alipaytitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_zhifubao.png"))
		img_weixintitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_weixin.png"))
		img_yinliantitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_unionpay2.png"))
		img_czktitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_card.png"))
		img_iaptitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_official.png"))
		local CurrentList = profile.PayChannelData.getUnionShowListData()
		showPayScrollView(CurrentList, profile.PayChannelData.NEW_UNION_PAY)

	elseif GameConfig.getRechargeShowState() == RECHARGE_LIST_SMS then
		--短信支付
		panel_recharge_history:setVisible(false)
		panel_recharge_list:setVisible(true)
		panel_recharge_card:setVisible(false)

		panel_recharge_history:setTouchEnabled(false)
		panel_recharge_list:setTouchEnabled(true)
		panel_recharge_card:setTouchEnabled(false)
		payDataScrollView:setTouchEnabled(true)

		panel_recharge_history:setZOrder(5)
		panel_recharge_list:setZOrder(6)
		panel_recharge_card:setZOrder(5)
		--tab
		img_duanxin:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		img_alipay:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_wechat:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_yinlian:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_czk:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		--tabtitle
		img_duanxintitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_note2.png"))
		img_alipaytitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_zhifubao.png"))
		img_weixintitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_weixin.png"))
		img_yinliantitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_unionpay.png"))
		img_czktitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_card.png"))
		img_iaptitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_official.png"))

		local CurrentList, payChannel = getSMSPayListAndPayChannel()
		if CurrentList~= nil and #CurrentList > 0 and payChannel~= nil then
			showPayScrollView(CurrentList, payChannel)
		else
			--未知运营商
			Common.showToast("设备无法使用短信支付！", 2)
		end

	elseif GameConfig.getRechargeShowState() == RECHARGE_CARD then
		--充值卡支付
		panel_recharge_history:setVisible(false)
		panel_recharge_list:setVisible(false)
		panel_recharge_card:setVisible(true)

		panel_recharge_history:setTouchEnabled(false)
		panel_recharge_list:setTouchEnabled(false)
		panel_recharge_card:setTouchEnabled(true)

		panel_recharge_history:setZOrder(5)
		panel_recharge_list:setZOrder(5)
		panel_recharge_card:setZOrder(6)
		--tab
		img_duanxin:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_alipay:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_wechat:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_yinlian:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_czk:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		--tabtitle
		img_duanxintitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_note.png"))
		img_alipaytitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_zhifubao.png"))
		img_weixintitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_weixin.png"))
		img_yinliantitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_unionpay.png"))
		img_czktitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_card2.png"))
		img_iaptitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_official.png"))
	elseif GameConfig.getRechargeShowState() == RECHARGE_91 then
		--91
		panel_recharge_history:setVisible(false)
		panel_recharge_list:setVisible(true)
		panel_recharge_card:setVisible(false)

		panel_recharge_history:setTouchEnabled(false)
		panel_recharge_list:setTouchEnabled(true)
		panel_recharge_card:setTouchEnabled(false)
		payDataScrollView:setTouchEnabled(true)

		panel_recharge_history:setZOrder(5)
		panel_recharge_list:setZOrder(6)
		panel_recharge_card:setZOrder(5)

		local CurrentList = profile.PayChannelData.getbaidu91ShowListData()
		showPayScrollView(CurrentList, profile.PayChannelData.RECHARGE_91)
		img_iap:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		img_iaptitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_official2.png"))
		--tabtitle
	elseif GameConfig.getRechargeShowState() == RECHARGE_IAP then
		--iap
		panel_recharge_history:setVisible(false)
		panel_recharge_list:setVisible(true)
		panel_recharge_card:setVisible(false)

		panel_recharge_history:setTouchEnabled(false)
		panel_recharge_list:setTouchEnabled(true)
		panel_recharge_card:setTouchEnabled(false)
		payDataScrollView:setTouchEnabled(true)

		panel_recharge_history:setZOrder(5)
		panel_recharge_list:setZOrder(6)
		panel_recharge_card:setZOrder(5)

		local CurrentList = profile.PayChannelData.getIAPShowListData()
		showPayScrollView(CurrentList, profile.PayChannelData.IAP_PAY)
		img_iap:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		img_iaptitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_official2.png"))
		--tableTitle
	elseif GameConfig.getRechargeShowState() == RECHARGE_HAIMA then
		--海马
		panel_recharge_history:setVisible(false)
		panel_recharge_list:setVisible(true)
		panel_recharge_card:setVisible(false)

		panel_recharge_history:setTouchEnabled(false)
		panel_recharge_list:setTouchEnabled(true)
		panel_recharge_card:setTouchEnabled(false)
		payDataScrollView:setTouchEnabled(true)

		panel_recharge_history:setZOrder(5)
		panel_recharge_list:setZOrder(6)
		panel_recharge_card:setZOrder(5)

		local CurrentList = profile.PayChannelData.getHaiMaShowListData()
		showPayScrollView(CurrentList, profile.PayChannelData.HAIMA_PAY)
		img_iap:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		img_iaptitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_official2.png"))

	end
end

--[[--
--设置选择的充值卡面值
--@param #number index 选中的下标
--]]
function selectCardValue(index)
	--如果控件不存在,或者点击选择的和当前选中的一致,return
	if CardCheckBoxUITable == nil and CurrentSelectIndex == index then
		return;
	end
	
	--如果是电信充值
	if CurrentCardType == RechargeCard_DIANXIN then
		if index >= 3 then
			return;
		end
	end

	--将当前的选中的选中框变成不选中状态
	if CardCheckBoxUITable[CurrentSelectIndex] ~= nil then
		CardCheckBoxUITable[CurrentSelectIndex]:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
	end

	--将点击的选中的选中框变成选中状态
	if CardCheckBoxUITable[index] ~= nil then
		CurrentSelectIndex = index;
		CardCheckBoxUITable[index]:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
	end

	if CurrentCardType == RechargeCard_YIDONG then
		RechargeCardPrice = yidong[index];
	elseif CurrentCardType == RechargeCard_LIANDONG then
		RechargeCardPrice = liantong[index];
	else
		RechargeCardPrice = dianxin[index];
	end

end

--充值卡list
function initCzkList(type)
	local data = nil
	CurrentCardType = type;
	if CurrentCardType == RechargeCard_YIDONG then
		data = yidong
		Image_OperatorsTitle:loadTexture(Common.getResourcePath("yidong.png"))
		Pd_frpId = YIDONG_FRPID
	elseif CurrentCardType == RechargeCard_LIANDONG then
		data = liantong
		Image_OperatorsTitle:loadTexture(Common.getResourcePath("liantong.png"))
		Pd_frpId = LIANTONG_FRPID
	else
		data = dianxin
		Image_OperatorsTitle:loadTexture(Common.getResourcePath("dianxin.png"))
		Pd_frpId = DIANXIN_FRPID
	end
	local CurrentList = profile.PayChannelData.getRechargeCardShowListData()
	for i = 1, #data do
		for key, var in ipairs(CurrentList) do
			if var.price == data[i] * 100 and CardValueUITable[i] ~= nil then
				if var.mnDiscount > 0 then
					CardValueUITable[i]:setText(data[i].."元(".. var.goodsName ..",赠送"..var.mnDiscount.."%)")--充值卡描述
				else
					CardValueUITable[i]:setText(data[i].."元(".. var.goodsName ..")")--充值卡描述
				end
				break
			end
		end
	end
	selectCardValue(1);

	--隐藏和显示的单选框
	for i = 1, #CardCheckBoxUITable do
		if i > #data then
			CardCheckBoxUITable[i]:setVisible(false);
		else
			CardCheckBoxUITable[i]:setVisible(true);
		end
	end
end

--[[--
--返回
]]
function callback_btn_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.showBaseLayerAction(view)
	elseif component == CANCEL_UP then
	--取消
	end
end

--iap
function callback_btn_iap(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if GameConfig.PaymentForIphone == GameConfig.PAYMENT_IAP then
			--iap
			changeRechargeShow(RECHARGE_IAP)
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_91 then
			--91
			changeRechargeShow(RECHARGE_91)
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_HAIMA then
			--海马IOS支付
			changeRechargeShow(RECHARGE_HAIMA)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end
--[[--
--充值记录
]]
function callback_btn_recharge_history(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		setTabView(MODE_HISTORY);
	elseif component == CANCEL_UP then
	--取消
	end
end


--[[--
--充值卡
]]
function callback_btn_recharge_card(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		changeRechargeShow(RECHARGE_CARD);
		Image_OperatorsTitle:loadTexture(Common.getResourcePath("yidong.png"))
		initCzkList(RechargeCard_YIDONG)
		Pd_frpId = YIDONG_FRPID
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--短信支付
]]
function callback_btn_sms(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--Common.showToast("暂未开通！", 2)
		if Common.getOperater() == Common.CHINA_MOBILE or Common.getOperater() == Common.CHINA_UNICOM
			or Common.getOperater() == Common.CHINA_TELECOM then
			changeRechargeShow(RECHARGE_LIST_SMS)
		else
			--未知运营商
			Common.showToast("设备无法使用短信支付！", 2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--银联支付
]]
function callback_btn_union(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		changeRechargeShow(RECHARGE_LIST_NEW_UNION)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--支付宝
]]
function callback_btn_alipay(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		changeRechargeShow(RECHARGE_LIST_ALIPAY)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--微信
]]
function callback_img_wechat(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if Common.getCurrentNameOfAppPackageIsTQ() then
			--如果当前的包名为"com.tongqu.client.lord", 则使用微信支付
			changeRechargeShow(RECHARGE_WEIXIN);
		else
			Common.showToast("您当前的微信支付无法使用", 2);
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--vip
function callback_btn_vip(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_RECHARGE_CENTER)
		VIPLogic.isInitFromChonZhiView(true)
		mvcEngine.createModule(GUI_VIP)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_chongzhi(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		sendGIFTBAGID_GET_LOOP_GIFT(3)

	elseif component == CANCEL_UP then
	--取消

	end
end

--兑换金币
function callback_btn_addcoin(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local myyuanbao = profile.User.getSelfYuanBao()
		if myyuanbao >= 50 then
			Common.openConvertCoin()
		else
			--充值引导
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
			PayGuidePromptLogic.setEnterType(true)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

-------------------------------------------------充值卡界面-----------------------

--确定购买
function callback_btn_czkok(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		GameConfig.setTheLastBaseLayer(GUI_RECHARGE_CENTER);
		local CurrentList = profile.PayChannelData.getRechargeCardShowListData()
		for key, var in ipairs(CurrentList) do
			if var.price == RechargeCardPrice * 100 then
				RechargeCardInfoTable = var
				break;
			end
		end
		RechargeCardInfoTable.Pd_frpId = Pd_frpId
		InputPrepaidCardLogic.setValue(RechargeCardInfoTable);
		mvcEngine.createModule(GUI_INPUTPREPAIDCARD)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--元宝充值
--]]
function callback_Image_YuanBao(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setTabView(MODE_YUANBAO);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--运营商按钮
--]]
function callback_Image_Operators(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_RECHARGE_CENTER);
		mvcEngine.createModule(GUI_SELECTCARRIERS)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第1个选择框
--]]
function callback_CheckBox1(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		selectCardValue(1)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第2个选择框
--]]
function callback_CheckBox2(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		selectCardValue(2)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第3个选择框
--]]
function callback_CheckBox3(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		selectCardValue(3)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第4个选择框
--]]
function callback_CheckBox4(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		selectCardValue(4)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第五个选择框
--]]
function callback_CheckBox5(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		selectCardValue(5)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--切换页
--]]
function setTabView(tab)
	if tab == currentTab then
		return;
	end
	currentTab = tab;
	if tab == MODE_HISTORY then
		--充值记录界面
		Panel_YuanBao:setVisible(false);
		Panel_YuanBao:setTouchEnabled(false);
		Panel_YuanBao:setZOrder(3);
		panel_recharge_card:setVisible(false);
		panel_recharge_card:setTouchEnabled(false);
		panel_recharge_card:setZOrder(3);
		panel_recharge_list:setVisible(false);
		panel_recharge_list:setTouchEnabled(false);
		panel_recharge_list:setZOrder(3);
		panel_recharge_history:setVisible(true);
		panel_recharge_history:setTouchEnabled(true);
		panel_recharge_history:setZOrder(3);
		Image_YuanBao:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		Image_YuanBaoTitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_yuanbaochongzhi.png"))
		img_czhistory:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		img_czhistorytitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_record2.png"))
		payDataScrollView:removeAllChildren()
		payDataScrollView:setTouchEnabled(false)
		showRechargeRecord();
	else
		--不是充值记录界面
		scroll_list:removeAllChildren();
		Panel_YuanBao:setVisible(true);
		Panel_YuanBao:setTouchEnabled(true);
		Panel_YuanBao:setZOrder(6);
		panel_recharge_card:setVisible(true);
		panel_recharge_card:setTouchEnabled(true);
		panel_recharge_card:setZOrder(4);
		panel_recharge_list:setVisible(true);
		panel_recharge_list:setZOrder(4);
		panel_recharge_list:setTouchEnabled(true)
		panel_recharge_history:setVisible(false);
		payDataScrollView:setTouchEnabled(true)
		Panel_YuanBao:setTouchEnabled(true)
		Image_YuanBao:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		Image_YuanBaoTitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_yuanbaochongzhi2.png"))
		img_czhistory:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		img_czhistorytitle:loadTexture(Common.getResourcePath("ui_charge_way_btn_record.png"))
		chooseRechargeShow();
	end
end

--[[--
--显示充值记录
--]]
function showRechargeRecord()
	if RechargeRecordTable["RechargeRecordData"] == nil then
		return
	end

	local cellSize = #RechargeRecordTable["RechargeRecordData"] --总数
	Common.log("充值历史"..cellSize)
	local viewW = 1053;
	local viewHMax = 400;
	local viewH = 0
	local viewX = 0
	local viewY = 0

	local cellWidth = 1024; --每个元素的宽
	local cellHeight = 53; --每个元素的高

	local lieSize = 1 --列数
	local hangSize = math.floor((cellSize + (lieSize - 1)) / lieSize) --行数
	local spacingW = 0 --横向间隔
	local spacingH = 0 --纵向间隔

	viewH = math.ceil((cellSize)/lieSize)*(cellHeight+spacingH);
	if viewH < viewHMax then
		viewH = viewHMax;
	end

	scroll_list:setSize(CCSizeMake(viewW, viewHMax))
	scroll_list:setInnerContainerSize(CCSizeMake(viewW, viewH))
	scroll_list:setPosition(ccp(viewX, viewY))
	--适配需要：对列表进行缩放横坐标和纵坐标的缩放
	scroll_list:setScaleX(GameConfig.ScaleAbscissa);
	scroll_list:setScaleY(GameConfig.ScaleOrdinate);

	for i = 0, cellSize - 1 do
		--金额
		local rechargeValue = RechargeRecordTable["RechargeRecordData"][cellSize - 1 - i + 1].rechargeValue
		--渠道
		local rechargeChannel = RechargeRecordTable["RechargeRecordData"][cellSize - 1 - i+1].rechargeChannel
		--时间
		local rechargeTime = RechargeRecordTable["RechargeRecordData"][cellSize - 1 - i+1].rechargeTime

		--		--充值记录
		--		local labelJilu = ccs.label({
		--			text = "充值记录:",
		--			color = ccc3(255,255,255),
		--		})
		--		labelJilu:setFontSize(35)
		--金额
		local labelName = ccs.label({
			text = "充值人民币",
			color =  ccc3(194,151,109),
		})
		labelName:setFontSize(25)
		local labelPrice = ccs.label({
			text = rechargeValue.."元",
			color =  ccc3(240,211,73),
		})
		labelPrice:setFontSize(25)
		--时间
		local labelTime = ccs.label({
			text = "在"..rechargeTime,
			color =  ccc3(194,151,109),
		})
		labelTime:setFontSize(25)
		--渠道
		local labelChannel = ccs.label({
			text = "通过"..rechargeChannel.."购入",
			color =  ccc3(194,151,109),
		})
		labelChannel:setFontSize(25)

		--底层layer
		local layout = ccs.panel({
			scale9 = false,
			size = CCSizeMake(cellWidth , cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
		})

		local bg = "";
		if i % 2 == 0 then
			bg = "bg_paihangbang_di2.png"
		else
			bg = "bg_paihangbang_di1.png"
		end
		local imageInfoBg = ccs.image({
			scale9 = false,
			image = Common.getResourcePath(bg),
			size = CCSizeMake(1024 , 53),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		imageInfoBg:setScale9Enabled(true);
		imageInfoBg:setAnchorPoint(ccp(0, 0));
		imageInfoBg:setZOrder(0);

		--设置
		--		SET_POS(labelJilu,  labelJilu:getSize().width/2 + 10, 75)
		SET_POS(labelTime, 40+labelTime:getSize().width/2, 25)
		SET_POS(labelChannel, 60+ labelTime:getSize().width+ labelChannel:getSize().width/2, 25)
		SET_POS(labelName,  80+ labelTime:getSize().width+ labelChannel:getSize().width+labelName:getSize().width/2 , 25)
		SET_POS(labelPrice,  80+ labelName:getSize().width+ labelTime:getSize().width+ labelChannel:getSize().width+labelPrice:getSize().width/2 , 25)
		SET_POS(layout,15,viewH - cellHeight*(cellSize - i) + 15)
		SET_POS(imageInfoBg,0,0)

		--		layout:addChild(labelJilu)
		labelTime:setZOrder(1);
		labelChannel:setZOrder(1);
		labelName:setZOrder(1);
		labelPrice:setZOrder(1);
		layout:addChild(labelTime)
		layout:addChild(labelChannel)
		layout:addChild(labelName)
		layout:addChild(labelPrice)
		layout:addChild(imageInfoBg)

		scroll_list:addChild(layout)
	end
end

-------------------------------------------------充值卡界面结束-----------------------

--[[--
--收到支付列表数据
]]
function upDataListData()
	Common.log("收到支付列表数据")
end

function updataIAPPay()
	local result = profile.IAPPayResult.getResult()
	local msg = profile.IAPPayResult.getResultText()
	--0 成功  1 失败
	Common.showToast(msg, 2)
end

--充值历史
function slot_RechargeRecord()
	RechargeRecordTable["RechargeRecordData"] = profile.RechargeRecord.getRechargeRecordTable()
end

function updataUserVip()
	local VipLevel = profile.User.getSelfVipLevel()--vip级别
	local VipExpirationDate = profile.User.getVipExpirationDate()--到期日期
	local Amount = profile.User.getSelfAmount()--当月累计
	local Balance = profile.User.getSelfBalance()--到达下一级需要

	local vipjb = VIPPub.getUserVipType(VipLevel)
	local nextjb = VIPPub.getUserVipName(vipjb+ 1)
	local datetab = os.date("*t",VipExpirationDate/1000)
	local datenyr = datetab.year.."/"..datetab.month
	local Ycz = Amount+Balance  --当月累计+到达下一级需要
	local bl = 0--图片显示比例
	if Ycz <= 0 then
		bl = 0--已充值/（已充值+需充值）
	else
		bl = Amount/(Amount+Balance)--已充值/（已充值+需充值）
	end

	local vipType = VIPPub.getUserVipType(VipLevel)
	if vipType >= VIPPub.VIP_1 then
		--vip
		--100万
		if Balance >= 100000000 then
			lab_vip:setText("您已经达到VIP7，享受最高级特权")
			img_vipload:setPercent(100)
			lab_vipbili:setText(VIPPub.VipCzje[vipjb].."/"..VIPPub.VipCzje[vipjb])
			Image_VipIcon:setVisible(false);
			AtlasLabel_NextVipLevel:setVisible(false);
		else
			lab_vip:setText("再充值" .. (Balance / 100) .. "元即可成为")
			img_vipload:setPercent(bl*100)
			lab_vipbili:setText((Amount/100).."/".. (Amount+Balance)/100)
		end
		lab_vipnum:setStringValue(vipjb)
		AtlasLabel_NextVipLevel:setStringValue(vipjb + 1)
		ImageView_35:loadTexture(Common.getResourcePath("hall_vip_icon.png"));
	else
--		lab_vipnum:setVisible(false)
    lab_vipnum:setStringValue(0)
		AtlasLabel_NextVipLevel:setStringValue(1)
		lab_vip:setText("仅需充值".. (Balance / 100) .. "元，马上成为")
		lab_vipbili:setText((Amount/100).."/".. (Amount+Balance)/100)
		lab_vip:setFontSize(20)
		ImageView_35:loadTexture(Common.getResourcePath("hall_vip_icon_no.png"));
		maskImageView:setVisible(true)
		img_vipload:setPercent(bl*100)
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	GameArmature.removeRechargeArmature(view)
	CurrentSelectIndex = 1;
	CurrentCardType = 0;
end

function addSlot()
	framework.addSlot2Signal(PAYMENT_DATA_LIST, upDataListData)
	framework.addSlot2Signal(BASEID_GET_BASEINFO, updataUserInfo)
	framework.addSlot2Signal(MANAGERID_VALIDATE_IAP, updataIAPPay)
	framework.addSlot2Signal(GET_RECHARGE_RECORD, slot_RechargeRecord)
	framework.addSlot2Signal(MANAGERID_GET_VIP_MSG, updataUserVip)
end

function removeSlot()
	framework.removeSlotFromSignal(PAYMENT_DATA_LIST, upDataListData)
	framework.removeSlotFromSignal(BASEID_GET_BASEINFO, updataUserInfo)
	framework.removeSlotFromSignal(MANAGERID_VALIDATE_IAP, updataIAPPay)
	framework.removeSlotFromSignal(GET_RECHARGE_RECORD, slot_RechargeRecord)
	framework.removeSlotFromSignal(MANAGERID_GET_VIP_MSG, updataUserVip)
end
