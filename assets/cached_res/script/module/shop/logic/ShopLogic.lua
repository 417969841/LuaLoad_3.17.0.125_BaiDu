module("ShopLogic", package.seeall)

view = nil

local scene = nil
local HongDian_Shop_Table_5_6 = {}
--滚动层
shopGiftScrollView = nil --礼包列表ScrollView
shopCoinScrollView = nil --金币礼包
Panel_101 = nil--礼包背景panl

--按钮+标签
label_shop_yuanbao = nil
label_shop_coin = nil
iv_shop_goods = nil
iv_shop_gift = nil
iv_shop_coin = nil
btn_shop_back = nil

--商城+礼包
ShopTable = {}
ShopImageGooodsTable = {}
ShopImageGooodsLabelTable = {}
ShopImageVipGiftTable = {}
ShopImageGiftTable = {}
AllGiftTable = {}--礼包list

--兑换列表
convertTable = {}
ConvertImageGooodsTable = {}

--屏幕尺寸，全局变量
local size = nil

--礼包分开，分成vip和非vip
panel_good = nil
panel_gift = nil
img_viplibao = nil
img_libao = nil
local temptab = nil --防止用户快速切换导致的空表nil
--顶部的tab
local TABCOIN = 1
local TABGOOD = 2
local TABGIFT = 3

local tab = TABCOIN

--左侧的tab
local GIFT_VIP = 1
local GIFT_COMMON = 2

zi_lb = nil
zi_jb = nil
zi_dj = nil
goods_ID = nil--物品ID
GoodDetailTable = nil;--存储对应物品相关信息的表
hongDianFlag = nil;
local TAG_TAN_HAO = 11;--叹号tag
local icon_new_label = nil
local shopGiftType = GIFT_VIP

txt_viplibao = nil;--
txt_superlibao = nil;--

--[[--
--站内信跳转过来的，得设置其默认的显示栏，并且得到具体显示的物体ID
--@param #number showtab 默认显示栏索引
--@param #type goodsID 具体某个物品ID
--]]
function setTabAndGoodsID(showtab, goodsID)
	temptab = tonumber(showtab)
	tab = tonumber(showtab)
	goods_ID = tonumber(goodsID)
end

--[[--
--是否有新礼包 有就显示红点
--]]
function setHongDian(flag)
	hongDianFlag = flag;
end

function onKeypad(event)
	if event == "backClicked" then
		--将默认显示栏置为 1（金币栏）
		tab = TABCOIN;
		hongDianFlag = nil;
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then

	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_SHOP;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("Shop.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("Shop.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("Shop_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameConfig.setTheCurrentBaseLayer(GUI_SHOP)

	--全局变量
	size = CCDirector:sharedDirector():getWinSize()

	scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(view)
	initShopView()
	--添加道具礼包红点
	if profile.HongDian.getProfile_HongDian_datatable() == 0 then
		HongDianLogic.showAllModule_HongDian(5,iv_shop_goods)
		HongDianLogic.showAllModule_HongDian(6,iv_shop_gift)
	end
	--loading
	local function delaySentMessage()
		if profile.ConvertList.getExchangeList() == true and profile.Shop.getGoodsListHasInit() == true and profile.Shop.getGiftListHasInit() == true then
			showGoodsList()
			setGiftListData()
			showConvertList()
		else
			Common.showProgressDialog("正在加载兑换列表信息，请稍后...")
			--商城
			sendDBID_MALL_GOODS_LIST(profile.Shop.getGoodsListTimestamp())
			--兑换
			sendDBID_EXCHANGE_LIST()
		end
		--礼包
		sendGIFTBAGID_GIFTBAG_LIST()
	end
	LordGamePub.runSenceAction(view,delaySentMessage,false)
end

function requestMsg()
end

--[[--
--初始化商城界面
]]
function initShopView()
	shopGiftScrollView = cocostudio.getUIScrollView(view, "scroll_gift")
	shopCoinScrollView = cocostudio.getUIScrollView(view, "scroll_coin")

	iv_shop_goods = cocostudio.getUIImageView(view, "iv_shop_goods")
	iv_shop_gift = cocostudio.getUIImageView(view, "iv_shop_gift")
	iv_shop_coin = cocostudio.getUIImageView(view, "iv_shop_coin")
	label_shop_yuanbao = cocostudio.getUILabel(view, "lab_yuanbao") --自己的元宝
	label_shop_coin = cocostudio.getUILabel(view, "lab_coin") --自己的金币
	btn_shop_back = cocostudio.getUIButton(view, "btn_shop_back")

	panel_good = cocostudio.getUIPanel(view, "panel_good")
	panel_gift = cocostudio.getUIPanel(view, "panel_gift")
	img_viplibao = cocostudio.getUIImageView(view, "img_viplibao")
	img_libao = cocostudio.getUIImageView(view, "img_libao")

	--字
	zi_lb = cocostudio.getUIImageView(view, "zi_lb")
	zi_jb = cocostudio.getUIImageView(view, "zi_jb")
	zi_dj = cocostudio.getUIImageView(view, "zi_dj")
	txt_viplibao = cocostudio.getUIImageView(view, "txt_viplibao");
	txt_superlibao = cocostudio.getUIImageView(view, "txt_superlibao");
	Panel_101= cocostudio.getUIPanel(view, "Panel_101")

	if hongDianFlag == 1 then
	--如果在大厅的商城栏上有礼包消息 则在  礼包按钮上显示红点
	--createTanHaoByTag(iv_shop_gift)
	end

	updataUserInfo()
	--设置显示
	if tab == nil or tab == "" then
		setTabView(TABCOIN)
	else
		setTabView(tab)
	end
end

function setTabView(tab)
	if tab == TABCOIN or tab == TABGOOD then
		--金币
		--商品
		panel_good:setVisible(true)
		panel_gift:setVisible(false)
		img_viplibao:setTouchEnabled(false)
		img_libao:setTouchEnabled(false)
		if tab == TABCOIN then
			zi_lb:loadTexture(Common.getResourcePath("ui_shop_btn_libao.png"))
			zi_jb:loadTexture(Common.getResourcePath("ui_shop_btn_jinbi2.png"))
			zi_dj:loadTexture(Common.getResourcePath("ui_shop_btn_daoju.png"))
		else
			zi_lb:loadTexture(Common.getResourcePath("ui_shop_btn_libao.png"))
			zi_jb:loadTexture(Common.getResourcePath("ui_shop_btn_jinbi.png"))
			zi_dj:loadTexture(Common.getResourcePath("ui_shop_btn_daoju2.png"))
		end
	else
		zi_lb:loadTexture(Common.getResourcePath("ui_shop_btn_libao2.png"))
		zi_jb:loadTexture(Common.getResourcePath("ui_shop_btn_jinbi.png"))
		zi_dj:loadTexture(Common.getResourcePath("ui_shop_btn_daoju.png"))
		--礼包
		panel_good:setVisible(false)
		panel_gift:setVisible(true)
		img_viplibao:setTouchEnabled(true)
		img_libao:setTouchEnabled(true)
		setGiftType(shopGiftType)
	end
end

function setGiftType(gifttype)
	shopGiftType = gifttype
	if shopGiftType == GIFT_VIP then
		img_viplibao:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		img_libao:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
	else
		img_libao:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		img_viplibao:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
	end
end

--[[--
--更新元宝数
]]
function updataUserInfo()
	label_shop_yuanbao:setText(profile.User.getSelfYuanBao())
	label_shop_coin:setText(profile.User.getSelfCoin())
end

local photoViwWidth = 219;
local photoViwHeight = 211;

--[[--
--更新商城图片
]]
local function updataImageGooods(path)
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
	if photoPath ~= nil and photoPath ~= "" and ShopImageGooodsTable[""..id] ~= nil then
		ShopImageGooodsTable[""..id]:loadTexture(photoPath);
		ShopImageGooodsTable[""..id]:setScale(0.8);
	end
end

--[[--
--更新商城标签图片
]]
local function updataImageGooodsLabel(path)
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
	if photoPath ~= nil and photoPath ~= "" and ShopImageGooodsLabelTable[""..id] ~= nil then
		ShopImageGooodsLabelTable[""..id]:loadTexture(photoPath)
		ShopImageGooodsLabelTable[""..id]:setScale(0.9)
	end
end

--[[--
--更新商城礼包图片
]]
local function updataImageGift(path)
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
	if photoPath ~= nil and photoPath ~= "" and ShopImageGiftTable[""..id] ~= nil then
		ShopImageGiftTable[""..id]:loadTexture(photoPath)
		ShopImageGiftTable[""..id]:setScale(0.8)
	end
end

--[[--
--更新商城VIP礼包图片
]]
local function updataImageVipGift(path)
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
	if photoPath ~= nil and photoPath ~= "" and ShopImageVipGiftTable[""..id] ~= nil then
		ShopImageVipGiftTable[""..id]:loadTexture(photoPath)
		ShopImageVipGiftTable[""..id]:setScale(0.8)
	end
end

--[[--
--更新兑换图片
]]
local function updataImageCoinGooods(path)
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
	if photoPath ~= nil and photoPath ~= "" and ConvertImageGooodsTable[""..id] ~= nil then
		ConvertImageGooodsTable[""..id]:loadTexture(photoPath)
		ConvertImageGooodsTable[""..id]:setScale(0.8)
	end
end

--[[--
--设置从站内信传过来物品的相关信息
--@param number mnGoodsID 物品ID
--@param table dataTable 表
--]]
function setMessageShowData(mnGoodsID, dataTable)
	--获取所要道具物品的所有相关信息
	if goods_ID ~= nil then
		if tonumber(goods_ID) == tonumber(mnGoodsID) then
			GoodDetailTable = dataTable
		end
	end
end

--[[--
--显示对应栏的具体物品信息
--]]
function showGoodsInfo()
	if goods_ID ~= nil and GoodDetailTable ~= nil then
		--如果是金币栏
		if tab == TABCOIN then
			showCoinDetail(GoodDetailTable)
			--如果是道具栏
		elseif tab == TABGOOD then
			showDaoJuDetail(GoodDetailTable)
			--如果是礼品栏
		elseif tab == TABGIFT then
			showGiftDetail(GoodDetailTable)
		end
	end
end

--[[--
由站内信  跳转的道具  具体详情页
--]]
function showDaoJuDetail(GoodDetailTable)
	goods_ID = nil;
	if temptab ~= nil and temptab == tab then
		local mnGoodsID = GoodDetailTable.ID
		--…Name  名称
		local msGoodsName = GoodDetailTable.Name
		--…IconURL  图标url
		local msPhotoUrl = GoodDetailTable.IconURL
		--…Description  描述
		local msGoodsText = GoodDetailTable.Description
		--…Consume  单价
		local mnPrice = GoodDetailTable.Consume
		--价格
		local newprice = mnPrice
		local zhekou = 100
		if zhekou == 100 or mnPrice == 1 then
		else
			--四舍五入
			if (mnPrice*(zhekou/100)%1)*10 >= 5 then
				newprice = math.ceil(mnPrice*(zhekou/100))
			else
				newprice = math.floor(mnPrice*(zhekou/100))
			end

		end
		mvcEngine.createModule(GUI_SHOP_BUY_GOODS)
		ShopBuyGoodsLogic.setGoodsData(mnGoodsID, msGoodsName, msGoodsText, newprice, msPhotoUrl)
	end
end


--[[--
-- 加载商城商品数据
]]
function loadShopGoodsView()
	shopCoinScrollView:setVisible(true)
	shopCoinScrollView:removeAllChildren()
	shopCoinScrollView:setTouchEnabled(true)

	shopGiftScrollView:setVisible(false)
	shopGiftScrollView:removeAllChildren()
	shopGiftScrollView:setTouchEnabled(false)

	ShopImageGiftTable = {};
	ShopImageVipGiftTable = {};
	ConvertImageGooodsTable = {};
	ShopImageGooodsTable = {};
	ShopImageGooodsLabelTable = {};

	iv_shop_goods:loadTexture(Common.getResourcePath("btn_macth_press.png"))
	iv_shop_gift:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
	iv_shop_coin:loadTexture(Common.getResourcePath("btn_macth_nor.png"))

	local cellSize = 0
	if ShopTable["GoodsListTable"] ~= nil  then
		cellSize = #ShopTable["GoodsListTable"]
	end
	Common.log("商场列表"..cellSize)

	local viewW = 0
	local viewH = 0
	local viewX = 28

	local viewY = 40
	local viewWmax = 1116;
	local viewHMax = 440;

	local cellWidth = 209; --每个元素的宽
	local cellHeight = 224; --每个元素的高

	local lieSize = 5 --列数
	local hangSize = math.floor((cellSize + (lieSize - 1)) / lieSize) --行数
	local yenum = math.floor((hangSize + 1) / 2)--多少页
	local spacingW = 6; --横向间隔
	local spacingH = 20 --纵向间隔
	local leftmargin  = 10;
	viewH = math.ceil((cellSize+1)/lieSize)*(cellHeight+spacingH) + leftmargin*2;

	shopCoinScrollView:setSize(CCSizeMake(viewWmax, viewHMax))
	shopCoinScrollView:setInnerContainerSize(CCSizeMake(viewWmax , viewH))
	shopCoinScrollView:setPosition(ccp(viewX, viewY))
	--适配需要：对列表进行缩放横坐标和纵坐标的缩放
	shopCoinScrollView:setScaleX(GameConfig.ScaleAbscissa);
	shopCoinScrollView:setScaleY(GameConfig.ScaleOrdinate);

	local shopItemList = {};
	for i = 0, cellSize - 1 do
		--ID
		local mnGoodsID = ShopTable["GoodsListTable"][i + 1].ID
		Common.log(mnGoodsID.."Shop mac   5")
		--…Name  名称
		local msGoodsName = ShopTable["GoodsListTable"][i + 1].Name
		--…gameType  所属游戏
		local mnGoodsGame = ShopTable["GoodsListTable"][i + 1].gameType
		--…goodsType  道具类型 :0钱袋入口1vip2道具3钱袋4互动道具5礼包6 Vip礼包
		local mnPropType = ShopTable["GoodsListTable"][i + 1].goodsType
		--…IconURL  图标url
		local msPhotoUrl = ShopTable["GoodsListTable"][i + 1].IconURL
		--…Title  标题
		local msGoodsTitle = ShopTable["GoodsListTable"][i + 1].Title
		--…Description  描述
		local msGoodsText = ShopTable["GoodsListTable"][i + 1].Description
		--…PurchaseLowerLimit  购买数量下限
		local mnCountDown = ShopTable["GoodsListTable"][i + 1].PurchaseLowerLimit
		--…PurchaseUpperLimit  购买数量上限
		local mnCountTop = ShopTable["GoodsListTable"][i + 1].PurchaseUpperLimit
		--…ConsumeType  购买类型 0金币，1元宝
		local mnBuyType = ShopTable["GoodsListTable"][i + 1].ConsumeType
		--…Consume  单价
		local mnPrice = ShopTable["GoodsListTable"][i + 1].Consume
		local VipConsume = ShopTable["GoodsListTable"][i + 1].VipConsume
		--…operationTagUrl  运营标签url
		local mnOperationLabel = ShopTable["GoodsListTable"][i + 1].operationTagUrl
		--exchangeCoin兑换金币数
		-- exchangeCoin = ShopTable["GoodsListTable"][i + 1].exchangeCoin
		--底层layer
		local layout = ccs.image({
			scale9 = false,
			size = CCSizeMake(photoViwWidth, photoViwHeight),
			image = "",
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		layout:setScale9Enabled(true);
		layout:setAnchorPoint(ccp(0.5, 0.5));

		--背景
		local bgurl = "bg_bag_item.png"

		local imgbg  = ccs.image({
			scale9 = true,
			image = Common.getResourcePath(bgurl),
			size = CCSizeMake(cellWidth, cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		imgbg:setScale9Enabled(true);
		--添加道具小红点
		icon_new_label = bgurl

		--名称
		local labelName = ccs.label({
			text = msGoodsName,
			color = ccc3(65, 41, 25),
		})
		labelName:setFontSize(22)
		local priceBg = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("yuan.png"),
			size = CCSizeMake(97, 33),
		})
		priceBg:setScale9Enabled(true);
		--labelName:setTouchEnabled(false)

		--labelPrice:setTouchEnabled(false)
		--vip折扣
		local VipLevel = profile.User.getSelfVipLevel()--vip级别
		local zhekou = 100
		if ShopTable["VipDiscountTable"] ~= nil then
			for k=1,#ShopTable["VipDiscountTable"] do
				if VipLevel == ShopTable["VipDiscountTable"][k].vipLevel then
					zhekou = ShopTable["VipDiscountTable"][k].vipDiscount
				end
			end
		end
		--价格
		local newprice = mnPrice
		if zhekou == 100 or mnPrice == 1 then
		else
			--四舍五入
			if (mnPrice*(zhekou/100)%1)*10 >= 5 then
				newprice = math.ceil(mnPrice*(zhekou/100))
			else
				newprice = math.floor(mnPrice*(zhekou/100))
			end

		end
		local button = ccs.button({
			scale9 = true,
			size = CCSizeMake(photoViwWidth, photoViwHeight),
			pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			text = "",
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = {
				[ccs.TouchEventType.began] = function(uiwidget)
					Common.log("Touch Down" .. msGoodsName)
					layout:setScale(1.1)
				end,
				[ccs.TouchEventType.moved] = function(uiwidget)
				--[[Common.log("Touch Move" .. i)]]
				end,
				[ccs.TouchEventType.ended] = function(uiwidget)
					layout:setScale(1)
					if mnPropType == profile.Shop.GOODS_TYPE_COIN_ENTRY then --是钱袋入口
					--						GameConfig.setTheLastBaseLayer(GUI_SHOP)
					--						mvcEngine.createModule(GUI_CONVERTLIST)
					else
						mvcEngine.createModule(GUI_SHOP_BUY_GOODS)
						ShopBuyGoodsLogic.setGoodsData(mnGoodsID, msGoodsName, msGoodsText, newprice, msPhotoUrl)
						----删除list中new
						Common.log(mnGoodsID.."删除list中new")
						if profile.HongDian.getProfile_HongDian_datatable() then
							HongDianLogic.removeList_New_Label(5, icon_new_label,mnGoodsID )
						end
					end
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
					layout:setScale(1)
					Common.log("Touch Cancel" .. msGoodsName)
				end,
			}
		})
		local labelPrice = ccs.label({
			text = newprice,
			color = ccc3(249, 235, 219),
		})
		labelPrice:setFontSize(20)

		local vipDiscount = ccs.label({
			text =  (zhekou/10).."折"  ,
			color = ccc3(255, 255, 255),
		})
		vipDiscount:setFontSize(25)
		--打折图片
		local imgDazhe = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_sale.png"),
		})
		--图片
		local imageGooods = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_jiazaimoren.png"),
		})
		--imageGooods:setTouchEnabled(false)

		ShopImageGooodsTable[""..(i + 1)] = imageGooods;
		ShopImageGooodsTable[""..(i + 1)]:setVisible(false);
		if msPhotoUrl ~= nil and msPhotoUrl ~= "" then
			Common.getPicFile(msPhotoUrl, i + 1, true, updataImageGooods)
		end
		--是否特价
		local imageLable = ccs.image({
			scale9 = false,
			image = "",
		})
		--imageLable:setTouchEnabled(false)
		ShopImageGooodsLabelTable[""..(i + 1)] = imageLable;
		ShopImageGooodsLabelTable[""..(i + 1)]:setVisible(false);
		if mnOperationLabel ~= nil and mnOperationLabel ~= "" then
			Common.getPicFile(mnOperationLabel, i + 1, true, updataImageGooodsLabel)
		end

		local labelInfo = nil
		if mnPropType == profile.Shop.GOODS_TYPE_COIN_ENTRY then --是钱袋入口
			labelInfo = ccs.label({
				text = "元宝兑换金币",
				size = CCSizeMake(cellWidth - 20, cellHeight / 3),
			})
		else
			labelInfo = ccs.label({
				text = msGoodsTitle,
				size = CCSizeMake(cellWidth - 20, cellHeight / 3),
			})
		end
		labelInfo:setFontSize(20)
		labelInfo:setAnchorPoint(ccp(0.5, 0.5))
		labelInfo:setTextAreaSize(CCSizeMake(cellWidth - 20, cellHeight / 4))
		--labelInfo:setTouchEnabled(false)
		--金币背景图
		local imgPrice = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_shop_recharge_yuanbao.png"),
		})
		imgPrice:setScale(0.7);
		SET_POS(imgbg, 0, 0);
		SET_POS(button, 0, 0);
		--设置商品名称位置
		local labelNameY = 73; --190
		SET_POS(labelName, 0, labelNameY);
		local vipDiscountX = 40;--170
		local vipDiscountY = -17;--90
		SET_POS(vipDiscount, vipDiscountX, vipDiscountY);
		local imgDazheX = 40;--170
		local imgDazheY = -17;--90
		SET_POS(imgDazhe, imgDazheX, imgDazheY);

		--设置商品价格
		local labelPriceX = 20; --140
		local labelPriceY = 0;--40
		SET_POS(labelPrice, labelPriceX, labelPriceY);
		local imgPriceX = -20; --70
		local imgPriceY = 0;--40
		SET_POS(imgPrice, imgPriceX, imgPriceY);
		local priceBgY = -67;--40
		SET_POS(priceBg, 0, priceBgY);

		--设置商品描述位置
		local labelInfoY = (labelInfo:getSize().height - cellHeight) /2-10;
		SET_POS(labelInfo, 0, labelInfoY);
		--设置商品图标位置
		local imageGooodsY = 5; --120
		SET_POS(imageGooods, 0, imageGooodsY);
		--设置商品标签位置
		local imageLableX = (imageLable:getSize().width -cellWidth) / 2;
		local imageLableY =  photoViwHeight - (imageLable:getSize().height + cellHeight) / 2+15;
		SET_POS(imageLable, imageLableX ,imageLableY);
		--所在的页
		local liesizenum = math.floor((cellSize+1)/2)--多少列
		local posX = (cellWidth + spacingW)* ((i)%lieSize + 1) - cellWidth / 2;
		local posY = viewH + cellHeight / 2 - (cellHeight + spacingH)* math.ceil((i+1)/lieSize);
		SET_POS(layout, posX, posY);

		layout:addChild(imgbg)
		layout:addChild(imageGooods)
		layout:addChild(labelName)
		priceBg:addChild(labelPrice)
		priceBg:addChild(imgPrice)
		layout:addChild(priceBg)
		---显示list中的new
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			if i == cellSize - 1 then
				HongDianLogic.getHongDian_Data_isTure(5, i+1, mnGoodsID, 1)
			else
				HongDianLogic.getHongDian_Data_isTure(5, i+1, mnGoodsID)
			end
			HongDianLogic.showAllChild_List_NewLabel(5,mnGoodsID,layout )
		end


		if zhekou == 100 or mnPrice == 1 then
		else
			layout:addChild(imgDazhe)
			layout:addChild(vipDiscount)
		end
		layout:addChild(imageLable)
		layout:addChild(button)

		table.insert(shopItemList, layout);

		shopCoinScrollView:addChild(layout);
		--获取从站内信跳转显示数据
		setMessageShowData(mnGoodsID, ShopTable["GoodsListTable"][i + 1]);
	end

	local function callbackShowImage(index)
		if ShopImageGooodsTable[""..index] ~= nil then
			ShopImageGooodsTable[""..index]:setVisible(true);
		end
		if ShopImageGooodsLabelTable[""..index] ~= nil then
			ShopImageGooodsLabelTable[""..index]:setVisible(true);
		end
	end
	LordGamePub.showLandscapeList(shopItemList, callbackShowImage);
	--从站内信跳转显示数据
	showGoodsInfo();
end

--[[--
--由站内信  跳转的礼包  具体详情页
--@param table
--]]
function showGiftDetail(GoodDetailTable)
	goods_ID = nil;
	if GoodDetailTable.goodsType == profile.Shop.GOODS_TYPE_VIP_GIFT then
		--vip礼包
		local VipGiftID = GoodDetailTable.VipGiftData
		--…Name  名称
		local Name = GoodDetailTable.Name
		--…IconURL  图标url
		local IconURL = GoodDetailTable.IconURL
		--…Description  描述
		local Description = GoodDetailTable.Title
		local Consume = GoodDetailTable.Consume
		local needVipMinLevel = GoodDetailTable.needVipMinLevel

		local VipLevel = profile.User.getSelfVipLevel()--vip级别
		if tonumber(needVipMinLevel) <= tonumber(VipLevel) then
			--自己的vip大于。可以购买    Name  IconURL  Description  Consume  needVipMinLevel
			BuyVipGiftLogic.setValue(VipGiftID,Name,IconURL,Description,Consume,needVipMinLevel,BuyVipGiftLogic.getFromType().ISFROMZHANNEIXING)
			mvcEngine.createModule(GUI_BUYVIPGIFT)
		else
			--不能购买
			BuyGiftVipNotFitLogic.setNotFitValue(needVipMinLevel,VipGiftID,Name,IconURL,Description,Consume,BuyVipGiftLogic.getFromType().ISFROMZHANNEIXING)
			mvcEngine.createModule(GUI_BUYGIFTVIPNOTFIT)
		end
	elseif GoodDetailTable.goodsType == profile.Shop.GOODS_TYPE_GIFT then
		local GiftBagType = GoodDetailTable.GiftBagType
		Common.showProgressDialog("数据加载中...")
		sendGIFTBAGID_REQUIRE_GIFTBAG(GiftBagType, 1)
	end
end

--[[--
-- 加载商城礼包数据
]]
function loadShopGiftView()
	shopGiftScrollView:setVisible(true)
	shopGiftScrollView:removeAllChildren()
	shopGiftScrollView:setTouchEnabled(true)

	shopCoinScrollView:setVisible(false)
	shopCoinScrollView:removeAllChildren()
	shopCoinScrollView:setTouchEnabled(false)

	ShopImageGiftTable = {};
	ShopImageVipGiftTable = {};
	ConvertImageGooodsTable = {};
	ShopImageGooodsTable = {};
	ShopImageGooodsLabelTable = {};


	iv_shop_goods:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
	iv_shop_gift:loadTexture(Common.getResourcePath("btn_macth_press.png"))
	iv_shop_coin:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
	local cellSize = 0
	if shopGiftType == GIFT_VIP then
		--vip礼包
		txt_viplibao:loadTexture(Common.getResourcePath("ui_shop_btn_viplibao2.png"))
		txt_superlibao:loadTexture(Common.getResourcePath("ui_shop_btn_chaozhilibao.png"))
		if AllGiftTable["VipGiftData"] ~= nil  then
			cellSize = #AllGiftTable["VipGiftData"]
		end
	else
		txt_viplibao:loadTexture(Common.getResourcePath("ui_shop_btn_viplibao.png"))
		txt_superlibao:loadTexture(Common.getResourcePath("ui_shop_btn_chaozhilibao2.png"))
		if ServerConfig.getGiftIsShow() then
			if AllGiftTable["GiftListTable"] ~= nil then
				cellSize = #AllGiftTable["GiftListTable"]
				if cellSize <= 0 then
					local labelTip = ccs.label({
					text = "当前没有礼包",
					color = ccc3(249, 235, 219),
					fontSize = 25,
					})
					Panel_101:addChild(labelTip)
					SET_POS(labelTip,Panel_101:getContentSize().width/2, Panel_101:getSize().height/2)
				end

			end
		end
	end

	local viewW = 0
	local viewH = 0
	local viewX = 5

	local viewY = 0
	local viewWmax = 880;
	local viewHMax = 420;

	local cellWidth = 209; --每个元素的宽
	local cellHeight = 224; --每个元素的高

	local lieSize = 4 --列数
	local hangSize = math.floor((cellSize + (lieSize - 1)) / lieSize) --行数
	local yenum = math.floor((hangSize + 1) / 2)--多少页
	local spacingW = 10; --横向间隔
	local spacingH = 20 --纵向间隔
	local leftmargin  = 10;
	viewH = math.ceil((cellSize+1)/lieSize)*(cellHeight+spacingH);
	if viewH < viewHMax then
		viewH = viewHMax;
	end

	shopGiftScrollView:setSize(CCSizeMake(viewWmax, viewHMax))
	shopGiftScrollView:setInnerContainerSize(CCSizeMake(viewWmax , viewH))
	shopGiftScrollView:setPosition(ccp(viewX, viewY))
	--适配需要：对列表进行缩放横坐标和纵坐标的缩放
	shopGiftScrollView:setScaleX(GameConfig.ScaleAbscissa);
	shopGiftScrollView:setScaleY(GameConfig.ScaleOrdinate);

	local shopGiftList = {};

	for i = 0, cellSize - 1 do
		local VipGiftID = nil
		local GiftBagType = nil
		local Name = ""
		local IconURL = ""
		local Description = ""
		local Consume = ""
		local needVipMinLevel = ""--最小vip等级
		if shopGiftType == GIFT_VIP then
			--vip礼包
			VipGiftID = AllGiftTable["VipGiftData"][i + 1].VipGiftID
			--…GiftBagType  礼包类别ID
			GiftBagType = AllGiftTable["VipGiftData"][i + 1].GiftBagType

			--…Name  名称
			Name = AllGiftTable["VipGiftData"][i + 1].Name
			--…IconURL  图标url
			IconURL = AllGiftTable["VipGiftData"][i + 1].IconURL
			--…Description  描述
			Description = AllGiftTable["VipGiftData"][i + 1].Title
			Consume = AllGiftTable["VipGiftData"][i + 1].Consume
			needVipMinLevel = AllGiftTable["VipGiftData"][i + 1].needVipMinLevel
		else
			--…GiftBagType  礼包类别ID
			GiftBagType = AllGiftTable["GiftListTable"][i + 1].GiftBagType
			--…Name  名称
			Name = AllGiftTable["GiftListTable"][i + 1].Name
			--…IconURL  图标url
			IconURL = AllGiftTable["GiftListTable"][i + 1].IconURL
			--…Description  描述
			Description = AllGiftTable["GiftListTable"][i + 1].Description
		end		--底层layer
		local layout = ccs.image({
			scale9 = false,
			size = CCSizeMake(photoViwWidth, photoViwHeight),
			image = "",
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		layout:setScale9Enabled(true);
		layout:setAnchorPoint(ccp(0.5, 0.5));


		--often
		local button = ccs.button({
			scale9 = true,
			size = CCSizeMake(photoViwWidth, photoViwHeight),
			pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			text = "",
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = {
				[ccs.TouchEventType.began] = function(uiwidget)
					layout:setScale(1.1)
				end,
				[ccs.TouchEventType.moved] = function(uiwidget)
				--[[Common.log("Touch Move" .. i)]]
				end,
				[ccs.TouchEventType.ended] = function(uiwidget)
					layout:setScale(1)
					if shopGiftType == GIFT_VIP then
						if VipGiftID == nil then
							return
						end
						local VipLevel = profile.User.getSelfVipLevel()--vip级别 often
						if AllGiftTable["VipGiftData"][i + 1].needVipMinLevel <= VipLevel then
							--自己的vip大于。可以购买    Name  IconURL  Description  Consume  needVipMinLevel
							BuyVipGiftLogic.setValue(tonumber(VipGiftID),Name,IconURL,Description,Consume,needVipMinLevel,BuyVipGiftLogic.getFromType().ISFROMSHOPVIEW)
							mvcEngine.createModule(GUI_BUYVIPGIFT)
						else
							--不能购买
							BuyGiftVipNotFitLogic.setNotFitValue(needVipMinLevel,tonumber(VipGiftID),Name,IconURL,Description,Consume,BuyVipGiftLogic.getFromType().ISFROMSHOPVIEW)
							mvcEngine.createModule(GUI_BUYGIFTVIPNOTFIT)
						end
					else
						if GiftBagType == nil then
							return
						end
						Common.showProgressDialog("数据加载中...")
						sendGIFTBAGID_REQUIRE_GIFTBAG(tonumber(GiftBagType), 1)
						--删除超值礼包new标签
						if profile.HongDian.getProfile_HongDian_datatable() == 0 then
							HongDianLogic.removeList_New_Label(6, icon_new_label, GiftBagType)
						end
					end
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
					layout:setScale(1)
				end,
			}
		})
		--背景
		local bgurl = "bg_bag_item.png"

		local imgbg  = ccs.image({
			scale9 = true,
			image = Common.getResourcePath(bgurl),
			size = CCSizeMake(cellWidth, cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		imgbg:setScale9Enabled(true);
		--价格
		local labelPrice = ccs.label({
			text = Consume,
			color = ccc3(249, 235, 219),
		})
		labelPrice:setFontSize(20)
		local priceBg = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("yuan.png"),
			size = CCSizeMake(97, 33),
		})
		priceBg:setScale9Enabled(true);
		--名称
		local labelName = ccs.label({
			text = Name,
			color = ccc3(65, 41, 25),
		})
		labelName:setFontSize(22)
		--图片
		local imageGooods = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_jiazaimoren.png"),
		})
		if shopGiftType == GIFT_VIP then
			ShopImageVipGiftTable[""..(i+1)] = imageGooods
			ShopImageVipGiftTable[""..(i+1)]:setVisible(false);

			if IconURL ~= nil and IconURL ~= "" then
				Common.getPicFile(IconURL, (i+1), true, updataImageVipGift)
			end
		else
			ShopImageGiftTable[""..(i+1)] = imageGooods
			ShopImageGiftTable[""..(i+1)]:setVisible(false);

			if IconURL ~= nil and IconURL ~= "" then
				Common.getPicFile(IconURL, (i+1), true, updataImageGift)
			end
		end
		--金币背景图
		local imgPrice = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_shop_recharge_yuanbao.png"),
		})
		imgPrice:setScale(0.7);

		--说明
		local textAreaInfo = ccs.TextArea({
			text = Description,
			size = CCSizeMake(193, 30),
		})
		textAreaInfo:setTextAreaSize(CCSizeMake(193, 30))
		textAreaInfo:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		textAreaInfo:setZOrder(5);
		textAreaInfo:setColor(ccc3(249,235,219))
		textAreaInfo:setFontSize(20)
		local timeBg =  ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_exchange_remainder.png"),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		timeBg:setScaleX(193 / timeBg:getContentSize().width);
		timeBg:setScaleY(30 / timeBg:getContentSize().height);
		timeBg:setZOrder(4);

		SET_POS(imgbg, 0, 0);
		SET_POS(button, 0, 0);
		--设置商品名称位置
		local labelNameY = 75;--190
		SET_POS(labelName, 0, labelNameY);
		--设置商品描述位置
		local textAreaInfoY = -65;--40
		SET_POS(textAreaInfo, 0, textAreaInfoY);
		SET_POS(timeBg, 0, textAreaInfoY);
		--设置商品图标位置
		local imageGooodsY = 5;--120
		SET_POS(imageGooods, 0, imageGooodsY);
		--设置商品价格
		local labelPriceX = 20; --140
		local labelPriceY = 0; -- 40
		SET_POS(labelPrice, labelPriceX, labelPriceY);
		local imgPriceX = -20; --70
		local imgPriceY = 0; --40
		SET_POS(imgPrice, imgPriceX, imgPriceY);
		local priceBgY = -65; --40
		SET_POS(priceBg, 0, priceBgY);
		local posX = (cellWidth + spacingW)* ((i)%lieSize + 1) - cellWidth / 2;
		local posY = viewH + cellHeight / 2 - (cellHeight + spacingH)* math.ceil((i+1)/lieSize);
		SET_POS(layout, posX, posY);
		layout:addChild(imgbg)
		layout:addChild(imageGooods)
		layout:addChild(labelName)

		--添加红点新的标签
		if shopGiftType ~= GIFT_VIP then
			if profile.HongDian.getProfile_HongDian_datatable() == 0 then
				----监测服务器数据
				if i == cellSize - 1 then
					HongDianLogic.getHongDian_Data_isTure(6, i+1, AllGiftTable["GiftListTable"][i + 1].GiftBagType, 1)
				else
					HongDianLogic.getHongDian_Data_isTure(6, i+1, AllGiftTable["GiftListTable"][i + 1].GiftBagType)
				end
				HongDianLogic.showAllChild_List_NewLabel(6, AllGiftTable["GiftListTable"][i + 1].GiftBagType, layout)
			end
		end
		if shopGiftType == GIFT_VIP then
			priceBg:addChild(labelPrice)
			priceBg:addChild(imgPrice)
			layout:addChild(priceBg)
		else
			layout:addChild(textAreaInfo)
			layout:addChild(timeBg)
		end
		layout:addChild(button)

		table.insert(shopGiftList, layout);

		shopGiftScrollView:addChild(layout)

		--获取所要物品的所有相关信息
		if shopGiftType == GIFT_VIP then
			setMessageShowData(VipGiftID, AllGiftTable["VipGiftData"][i + 1]);
		elseif shopGiftType == GIFT_COMMON then
			setMessageShowData(GiftBagType, AllGiftTable["GiftListTable"][i + 1]);
		end
	end
	local function callbackShowImage(index)
		if shopGiftType == GIFT_VIP then
			if ShopImageVipGiftTable[""..index] ~= nil then
				ShopImageVipGiftTable[""..index]:setVisible(true);
			end
		else
			if ShopImageGiftTable[""..index] ~= nil then
				ShopImageGiftTable[""..index]:setVisible(true);
			end
		end
	end
	LordGamePub.showLandscapeList(shopGiftList, callbackShowImage);
	--如果站内信跳转过来   则显示具体物品信息
	showGoodsInfo()
end


--[[--
由站内信  跳转的 金币兑换 具体详情页
--]]
function showCoinDetail(GoodDetailTable)
	goods_ID = nil;
	if temptab ~= nil and temptab == tab then
		--ID
		local mnGoodsID = GoodDetailTable.ID
		--…Name  名称
		local msGoodsName = GoodDetailTable.Name
		--…IconURL  图标url
		local msPhotoUrl = GoodDetailTable.IconURL
		--…Description  描述
		local msGoodsText = GoodDetailTable.Description
		--…Consume  单价
		local mnPrice = GoodDetailTable.Consume
		--exchangeCoin兑换金币数
		local exchangeCoin = GoodDetailTable.exchangeCoin
		mvcEngine.createModule(GUI_SHOP_BUY_COIN)
		ShopBuyCoinLogic.setGoodsData(mnGoodsID, msGoodsName, msGoodsText, exchangeCoin,msPhotoUrl,mnPrice)
	end
end


--[[--
--金币兑换view
--]]
function loadShopCoinView()

	shopCoinScrollView:setVisible(true)
	shopCoinScrollView:setTouchEnabled(true)
	shopCoinScrollView:removeAllChildren()

	shopGiftScrollView:setVisible(false)
	shopGiftScrollView:removeAllChildren()
	shopGiftScrollView:setTouchEnabled(false)

	ShopImageGiftTable = {};
	ShopImageVipGiftTable = {};
	ConvertImageGooodsTable = {};
	ShopImageGooodsTable = {};
	ShopImageGooodsLabelTable = {};

	iv_shop_goods:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
	iv_shop_gift:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
	iv_shop_coin:loadTexture(Common.getResourcePath("btn_macth_press.png"))
	local cellSize = 0
	if convertTable["GoodsListTable"] ~= nil  then
		cellSize = #convertTable["GoodsListTable"]
	end

	local viewW = 0
	local viewH = 0
	local viewX = 28

	local viewY = 40
	local viewWmax = 1116;
	local viewHMax = 440;

	local cellWidth = 209; --每个元素的宽
	local cellHeight = 224; --每个元素的高

	local lieSize = 5 --列数
	local hangSize = math.floor((cellSize + (lieSize - 1)) / lieSize) --行数
	local yenum = math.floor((hangSize + 1) / 2)--多少页
	local spacingW = 6; --横向间隔
	local spacingH = 20 --纵向间隔
	local leftmargin  = 10;
	viewH = math.ceil((cellSize+1)/lieSize)*(cellHeight+spacingH) + leftmargin*2;

	shopCoinScrollView:setSize(CCSizeMake(viewWmax, viewHMax))
	shopCoinScrollView:setInnerContainerSize(CCSizeMake(viewWmax, viewH))
	shopCoinScrollView:setPosition(ccp(viewX, viewY))

	shopCoinScrollView:setScaleX(GameConfig.ScaleAbscissa);
	shopCoinScrollView:setScaleY(GameConfig.ScaleOrdinate);


	local ShopCoinList = {};


	for i = 0, cellSize - 1 do
		--ID
		local mnGoodsID = convertTable["GoodsListTable"][i + 1].ID
		--…Name  名称
		local msGoodsName = convertTable["GoodsListTable"][i + 1].Name
		--…goodsType  道具类型 :0钱袋入口1vip2道具3钱袋4互动道具5礼包6 Vip礼包
		local mnPropType = convertTable["GoodsListTable"][i + 1].goodsType
		--…IconURL  图标url
		local msPhotoUrl = convertTable["GoodsListTable"][i + 1].IconURL
		--…Title  标题
		local msGoodsTitle = convertTable["GoodsListTable"][i + 1].Title
		--…Description  描述
		local msGoodsText = convertTable["GoodsListTable"][i + 1].Description
		--…PurchaseLowerLimit  购买数量下限
		local mnCountDown = convertTable["GoodsListTable"][i + 1].PurchaseLowerLimit
		--…PurchaseUpperLimit  购买数量上限
		local mnCountTop = convertTable["GoodsListTable"][i + 1].PurchaseUpperLimit
		--…ConsumeType  购买类型 0金币，1元宝
		local mnBuyType = convertTable["GoodsListTable"][i + 1].ConsumeType
		--…Consume  单价
		local mnPrice = convertTable["GoodsListTable"][i + 1].Consume
		--…operationTagUrl  运营标签url
		local mnOperationLabel = convertTable["GoodsListTable"][i + 1].operationTagUrl
		--exchangeCoin兑换金币数
		local exchangeCoin = convertTable["GoodsListTable"][i + 1].exchangeCoin
		--VipConsume
		local VipConsume = convertTable["GoodsListTable"][i + 1].VipConsume

		local layout = ccs.image({
			scale9 = false,
			size = CCSizeMake(cellWidth, cellHeight),
			image = "",
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		layout:setScale9Enabled(true);
		layout:setAnchorPoint(ccp(0.5, 0.5));

		local button = ccs.button({
			scale9 = true,
			size = CCSizeMake(photoViwWidth, photoViwHeight),
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
					mvcEngine.createModule(GUI_SHOP_BUY_COIN)
					ShopBuyCoinLogic.setGoodsData(mnGoodsID, msGoodsName, msGoodsText, exchangeCoin,msPhotoUrl,mnPrice)
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
					layout:setScale(1)
				end,
			}
		})
		--背景
		local bgurl = "bg_bag_item.png"

		local imgbg  = ccs.image({
			scale9 = true,
			image = Common.getResourcePath(bgurl),
			size = CCSizeMake(cellWidth, cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		imgbg:setScale9Enabled(true);
		--名称
		local labelName = ccs.label({
			text = msGoodsName,
			color = ccc3(65, 41, 25),
		})
		labelName:setFontSize(22)
		--labelName:setTouchEnabled(false)
		local priceBg = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("yuan.png"),
			size = CCSizeMake(97, 33),
		})
		priceBg:setScale9Enabled(true);

		--价格
		local labelPrice = ccs.label({
			text = mnPrice,
		})
		--labelPrice:setTouchEnabled(false)
		labelPrice:setFontSize(20)

		--图片
		local imageGooods = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_jiazaimoren.png"),
		})
		ConvertImageGooodsTable[""..(i + 1)] = imageGooods
		ConvertImageGooodsTable[""..(i + 1)]:setVisible(false);
		if msPhotoUrl ~= nil and  msPhotoUrl ~= ""  then
			Common.getPicFile(msPhotoUrl, (i + 1), true, updataImageCoinGooods)
		end
		--imageGooods:setTouchEnabled(false)

		--说明
		local textAreaInfo = nil
		if mnPropType == profile.Shop.GOODS_TYPE_COIN_ENTRY then --是钱袋入口
			textAreaInfo = ccs.TextArea({
				text = "元宝兑换金币",
				size = CCSizeMake(cellWidth - 20, cellHeight / 3),
			})
		else
			textAreaInfo = ccs.TextArea({
				text = msGoodsTitle,
				size = CCSizeMake(cellWidth - 20, cellHeight / 3),
			})
		end
		--textAreaInfo:setTouchEnabled(false)
		--金币背景图
		local imgPrice = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_shop_recharge_yuanbao.png"),
		})
		imgPrice:setScale(0.7);
		SET_POS(imgbg, 0, 0);
		SET_POS(button, 0, 0);
		--设置商品名称位置
		local labelNameY = 73;--190
		SET_POS(labelName,  0, labelNameY);
		--设置商品描述位置
		local textAreaInfoY = -67;
		SET_POS(textAreaInfo, cellWidth / 2, textAreaInfoY);
		--设置商品价格
		local labelPriceX = 20; --140
		local labelPriceY = 0; -- 40
		SET_POS(labelPrice, labelPriceX, labelPriceY);
		local imgPriceX = -20; --70
		local imgPriceY = 0; --40
		SET_POS(imgPrice, imgPriceX, imgPriceY);
		local priceBgY = -67; --40
		SET_POS(priceBg, 0, priceBgY);
		--设置商品图标位置
		local imageGooodsY = 3; --120
		SET_POS(imageGooods,  0, imageGooodsY);

		--所在的页
		local liesizenum = math.floor((cellSize+1)/2)--多少列
		local posX = (cellWidth + spacingW)* ((i)%lieSize + 1) - cellWidth / 2;
		local posY = viewH + cellHeight / 2 - (cellHeight + spacingH)* math.ceil((i+1)/lieSize);
		SET_POS(layout, posX, posY);
		layout:addChild(imgbg)
		if mnPropType ~= profile.Shop.GOODS_TYPE_COIN_ENTRY then --不是钱袋入口
		--layout:addChild(labelPrice)
		end

		priceBg:addChild(labelPrice)
		priceBg:addChild(imgPrice)
		layout:addChild(priceBg)
		layout:addChild(imageGooods)
		layout:addChild(labelName)
		layout:addChild(button)

		table.insert(ShopCoinList, layout);

		shopCoinScrollView:addChild(layout)

		--获取所要物品的所有相关信息
		setMessageShowData(mnGoodsID, convertTable["GoodsListTable"][i + 1]);
	end
	local function callbackShowImage(index)
		if ConvertImageGooodsTable[""..index] ~= nil then
			ConvertImageGooodsTable[""..index]:setVisible(true);
		end
	end
	LordGamePub.showLandscapeList(ShopCoinList, callbackShowImage);
	--显示具体物品信息
	showGoodsInfo();
end

--[[--
--点击显示商品
]]
function callback_iv_shop_goods(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if tab ~= TABGOOD then
			tab = TABGOOD
			loadShopGoodsView()
			if profile.HongDian.getProfile_HongDian_datatable() == 0 then
				removeAllChildAndCleanUp()
				HongDianLogic.showAllModule_HongDian(6,iv_shop_gift)
			end
			setTabView(TABGOOD)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end


--[[--
--点击显示礼包
]]
function callback_iv_shop_gift(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			removeAllChildAndCleanUp()
			HongDianLogic.showAllModule_HongDian(5,iv_shop_goods)
		end
		if tab ~= TABGIFT then
			--礼包
			tab = TABGIFT
			setTabView(TABGIFT)
			loadShopGiftView()
		end
	elseif component == CANCEL_UP then
	--取消
	end
end


--[[--
--点击显示金币兑换
--]]
function callback_iv_shop_coin(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if tab ~= TABCOIN then
			tab = TABCOIN
			loadShopCoinView()
			setTabView(TABCOIN)
			--显示道具和礼包的红点
			if profile.HongDian.getProfile_HongDian_datatable() ==0 then
				removeAllChildAndCleanUp()
				HongDianLogic.showAllModule_HongDian(5,iv_shop_goods)
				HongDianLogic.showAllModule_HongDian(6,iv_shop_gift)
			end
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--返回
--]]
function callback_btn_shop_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--将默认显示栏置为 1（金币栏）
		tab = TABCOIN;
		hongDianFlag = nil;
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			HongDianLogic.setHongDian_Shop_table_null()
		end
		LordGamePub.showBaseLayerAction(view)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--vip礼包
--]]
function callback_img_viplibao(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if shopGiftType ~= GIFT_VIP then
			setGiftType(GIFT_VIP)
			loadShopGiftView()
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--超值礼包
--]]
function callback_img_libao(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if shopGiftType ~= GIFT_COMMON then
			setGiftType(GIFT_COMMON)
			loadShopGiftView()
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_shop_recharge(component)
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

function callback_btn_shop_rechargeyuanbao(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_SHOP)
		mvcEngine.createModule(GUI_RECHARGE_CENTER,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--移除btn上的叹号
--@param #CCButton btn 菜单按钮
--]]
function removeTanHaoByTag(btn)
	if btn:getChildByTag(TAG_TAN_HAO) ~= nil then
		btn:getChildByTag(TAG_TAN_HAO):setVisible(false)
	end
end

--[[--
--创建btn上的叹号
--@param #CCButton btn 菜单按钮
--]]
function createTanHaoByTag(btn)
	if btn:getChildByTag(TAG_TAN_HAO)  == nil then
		local btnGanTanHao = UIImageView:create()
		btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
		btnGanTanHao:setAnchorPoint(ccp(-0.8,0.1))
		btnGanTanHao:setZOrder(4);
		btn:addChild(btnGanTanHao)
		btnGanTanHao:setTag(TAG_TAN_HAO)
	end
end

--[[--
--显示商品界面
]]
function showGoodsList()
	ShopTable["GoodsListTable"] = profile.Shop.getGoodsListTable()
	ShopTable["VipDiscountTable"] = profile.Shop.getGoodsVipDiscountTable()
	if ShopTable["GoodsListTable"] ~=nil and tab == TABGOOD then
		Common.closeProgressDialog()
		loadShopGoodsView()
	end
end


--[[--
--显示金币兑换
--]]
function showConvertList()
	convertTable["GoodsListTable"] = profile.ConvertList.getConvertTable()
	if convertTable["GoodsListTable"] ~=nil and tab == TABCOIN then
		Common.closeProgressDialog()
		loadShopCoinView()
	end
end

--[[--
--设置礼包数据
]]
function setGiftListData()
	AllGiftTable["GiftListTable"] = profile.Shop.getGiftsListTable()
	AllGiftTable["VipGiftData"] = profile.Shop.getVipGiftListTable()
	if AllGiftTable ~= nil and tab == TABGIFT then
		Common.closeProgressDialog()
		loadShopGiftView();
	end
end

--清空红点
function removeAllChildAndCleanUp()

	HongDian_Shop_Table_5_6 = HongDianLogic.getHongDian_Shop_table()
	if HongDian_Shop_Table_5_6[5] ~= nil then
		HongDian_Shop_Table_5_6[5]:setVisible(false)
	end
	if HongDian_Shop_Table_5_6[6] ~= nil then
		HongDian_Shop_Table_5_6[6]:setVisible(false)
	end
end


--[[--
--设置tab
--]]
function setTab(tabV)
	tab = tabV
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(DBID_MALL_GOODS_LIST, showGoodsList)--道具
	framework.addSlot2Signal(GIFTBAGID_GIFTBAG_LIST, setGiftListData)--礼包
	framework.addSlot2Signal(BASEID_GET_BASEINFO, updataUserInfo)
	framework.addSlot2Signal(DBID_EXCHANGE_LIST, showConvertList)--金币
end

function removeSlot()
	framework.removeSlotFromSignal(DBID_MALL_GOODS_LIST, showGoodsList)
	framework.removeSlotFromSignal(GIFTBAGID_GIFTBAG_LIST, setGiftListData)
	framework.removeSlotFromSignal(BASEID_GET_BASEINFO, updataUserInfo)
	framework.removeSlotFromSignal(DBID_EXCHANGE_LIST, showConvertList)
end
