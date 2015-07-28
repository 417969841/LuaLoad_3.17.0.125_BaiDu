module("ExchangeLogic",package.seeall)

view = nil
--兑换礼品
PrizeTable = {}
--碎片兑换礼品
SuipianPrizeTable = {}
MyPrizeTable = {}

PriceImageListTable = {}--兑换图片列表
SuipianImageListTable = {}--碎片商城图片列表
MyPriceImageListTable = {}--我的奖品图片列表
RemainderListTable = {}--抢购奖品剩余列表
--合成成功的信息
comtable = {}

local viewShowTag = 1
local tempviewShowTag = nil
--控件
PriceListScrollView = nil--奖品列表
btn_jiangquan = nil--奖券
btn_suipian = nil--碎片兑奖
btn_myprice = nil--我的奖品
self_yuanbao = nil--元宝
self_coin = nil--金币
btn_back = nil--返回按钮
lab_msg = nil --滚动消息

--宏定义栏
local TABDUIJIANGQUAN = 1;--兑奖券栏
local TABSUIPIAN = 2;--碎片栏
local TABJIANGPIN = 3;--奖品栏
--OZrder
local ZORDER_LOW = 5
local ZORDER_HIGH = 10
--全局变量
local size = nil

local viewX = 0--左右间隔
local viewY = 0 --上下间隔
local viewW = 0   --宽度
local viewH = 0--高度
local cellWidth = 0 --每个元素的宽
local cellHeight = 0 --每个元素的高
local spacingW = 0 --横向间隔
local spacingH = 0 --纵向间隔
--模块红点数据
local HongDian_Shop_Table_7_8_9 = {}
--字
zi_jp = nil
zi_sp = nil
zi_djq = nil

--走马灯公告
ExchangeZouMaDengLabel = nil
ExchangeZouMaDengTextTable = nil

--兑奖页面初始化标识
local exchangeHasInit = false

local lookTimer = nil

--兑奖状态
local STATUS_NOT_EXCHANGABLE = 0 --不可兑奖
local STATUS_EXCHANGABLE = 1 --可兑奖
local STATUS_COMPASS_AND_EXCHANGABLE = 2 --可合成兑奖
local STATUS_NEED_PAY_GUIDE = 3 --需要充值引导才可合成兑奖
--local isCashExchange = false
local isFirstGetExchangbleAwards = true
local picUrl = nil --实物图片url

goods_ID = nil
--用来临时存取从站内信跳转过来的物品的相关信息
ExchangeGoodTable = nil;
local isCashExchange = false

--android返回键
function onKeypad(event)
	if event == "backClicked" then
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then

	end
end

--[[--
--更新抢购奖品剩余数
]]
function updataRemainderList()
	if viewShowTag == 1 then
		--如果在兑奖卷专区则刷新限购物品数量
		local remainderTable = profile.CashAward.getCashAwardsRemainderInfo()
		if remainderTable["RemainderList"] ~= nil and #remainderTable["RemainderList"] > 0 then
			for i = 1,#remainderTable["RemainderList"] do
				local awardID = remainderTable["RemainderList"][i]["awardID"]
				local remainder = remainderTable["RemainderList"][i]["remainder"]
				if RemainderListTable[""..awardID] ~= nil then
					RemainderListTable[""..awardID]:setText("当前库存:" .. remainder)
				end
			end
		end
	end
end


--[[--
--更新兑换列表图片
]]
local function updataPriceImageList(path)
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
	if photoPath ~= nil and photoPath ~= "" and PriceImageListTable[""..id] ~= nil then
		PriceImageListTable[""..id]:loadTexture(photoPath);
		PriceImageListTable[""..id]:setScale(0.75);
	end
end


--[[--
--更新碎片商城列表图片
]]
local function updataSuipianImageList(path)
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
	if photoPath ~= nil and photoPath ~= "" and SuipianImageListTable[""..id] ~= nil then
		SuipianImageListTable[""..id]:loadTexture(photoPath);
		SuipianImageListTable[""..id]:setScale(0.75);
	end
end


--[[--
--更新我的奖品列表图片
]]
local function updataMyPriceImageList(path)
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
	if photoPath ~= nil and photoPath ~= "" and MyPriceImageListTable[""..id] ~= nil then
		MyPriceImageListTable[""..id]:loadTexture(photoPath);
		MyPriceImageListTable[""..id]:setScale(0.75);
	end
end

--[[--
--弹窗之后的发送信息
--]]
function sendMsgAfterOpenBox()
	setState(1)
--	sendOPERID_GET_CASH_AWARD_LIST()
--	sendOPERID_GET_CASH_PRIZE_LIST(profile.CashPrize.getCashPrizeTimestamp())
	--		isCashExchange = true
	local userID = profile.User.getSelfUserID()
	if userID ~= 0 then
		sendDBID_USER_INFO(profile.User.getSelfUserID())
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_EXCHANGE;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("Exchange.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("Exchange.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("Exchange_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameConfig.setTheCurrentBaseLayer(GUI_EXCHANGE)
	GameStartConfig.addChildForScene(view)
	--全局变量
	size = CCDirector:sharedDirector():getWinSize()

	initView()
	--添加红点
	if profile.HongDian.getProfile_HongDian_datatable() == 0 then
		HongDianLogic.showAllModule_HongDian(8,btn_suipian )
		HongDianLogic.showAllModule_HongDian(9,btn_myprice )

	end

	setTableState(viewShowTag)

	viewX = 0--左右间隔
	viewY = 53 --y位置
	viewW = 1136 - viewX*2;   --宽度
	viewH = 430;--高度
	cellWidth = 209; --每个元素的宽
	cellHeight = 224; --每个元素的高
	spacingW = 5; --横向间隔
	spacingH = 25; --纵向间隔
	local function delaySentMessage()
		--完成新手引导
		Common.showProgressDialog("数据加载中...")
		--奖品兑换
		sendMANAGERID_GET_PIECES_SHOP_LIST(profile.SuipianPrize.getPrizeSuipianListTimestamp());
		--现金奖品列表
		sendOPERID_GET_CASH_AWARD_LIST();
		--获取可兑换奖品列表
		sendMANAGERID_GET_EXCHANGBLE_AWARDS();
		--我的奖品  2信息
		sendNEW_GET_PRIZE_LIST(0,30); --充值卡
		sendMANAGERID_GET_EXCHANGE_AWARDS(); --兑换的奖品
		sendOPERID_GET_CASH_PRIZE_LIST(profile.CashPrize.getCashPrizeTimestamp()); --我的奖品中现金奖品
		profile.Marquee.resetMARQUEE_TABLE(2)
		setCompoundInfo(); --走马灯消息
	end

	if CommDialogConfig.getNewUserGiudeFinish() then
		LordGamePub.runSenceAction(view, delaySentMessage, false)
	else
		--未完成新手引导
		if profile.CashAward.getHasCashAward() and profile.Prize.getPrizeHasData() then
			showPriceList()
		else
			delaySentMessage()
		end
	end

end

function initView()
	btn_jiangquan = cocostudio.getUIImageView(view, "btn_jiangquan")
	btn_suipian = cocostudio.getUIImageView(view, "btn_suipian")
	btn_myprice = cocostudio.getUIImageView(view, "btn_myprice")
	PriceListScrollView = cocostudio.getUIScrollView(view, "scroll_list1")

	self_yuanbao = cocostudio.getUILabel(view,"lab_yuanbao")
	self_coin = cocostudio.getUILabel(view,"lab_coin")
	btn_back = cocostudio.getUIButton(view, "btn_back")
	lab_msg =  cocostudio.getUILabel(view,"lab_msg")

	zi_jp = cocostudio.getUIImageView(view, "zi_jp")
	zi_sp = cocostudio.getUIImageView(view, "zi_sp")
	zi_djq = cocostudio.getUIImageView(view, "zi_djq")

	--走马灯公告
	ExchangeZouMaDengLabel = cocostudio.getUILabel(view, "lab_msg")
	ExchangeZouMaDengLabel:setFontSize(25)
	ExchangeZouMaDengLabel:setTextHorizontalAlignment(kCCTextAlignmentCenter)
	ExchangeZouMaDengLabel:setColor(ccc3(255,255,255))

	--comsucessmsg()
	--lab_msg:setPosition(ccp(size.width/2+lab_msg:getContentSize().width/2, lab_msg:getPosition().y))

	--金币，元宝赋值
	self_yuanbao:setText(profile.User.getDuiJiangQuan())
	self_coin:setText(profile.User.getSelfdjqPieces())
end

function comsucessmsg()
	comtable = {"阿姨不可以已成功兑换小米1s","liuliu2已成功兑换iphone 5s"}
	--开始滚动
	if comtable ~= nil then
		local msgss = ""
		if #comtable >= 1 then
			if(comtable[1]) then
				msgss = comtable[1]
				table.remove(comtable,1)-----移除取出的信息
				headLabelTTFCallBack(msgss)
			end
		end
	end
end

local movetoTime =  0.005

function headLabelTTFCallBack(msgss)
	lab_msg:setText(msgss)
	lab_msg:stopAllActions()
	local moveto =  CCMoveBy:create(movetoTime*(size.width+lab_msg:getContentSize().width/2),ccp(- size.width-lab_msg:getContentSize().width/2,0))
	local moveto2 =  CCMoveTo:create(0.001,ccp(size.width/2+lab_msg:getContentSize().width/2,0))
	local headActioArray = CCArray:create()
	headActioArray:addObject(moveto)
	headActioArray:addObject(moveto2)
	headActioArray:addObject(CCCallFuncN:create(comsucessmsg))
	lab_msg:runAction(CCSequence:create(headActioArray))
end


--[[--
显示兑奖券专区   具体某个物品的详情
--]]
function show_DuiJiangQuanView(exchangeGoodTable)
	--及时置为nil很重要
	goods_ID = nil
	if tempviewShowTag ~= nil and tempviewShowTag == viewShowTag then
		--物品id
		local GoodID = exchangeGoodTable.GoodID
		--…ShortName  短名称
		local ShortName = exchangeGoodTable.ShortName
		--…Name  名称
		local Name = exchangeGoodTable.Name
		--…Prize  需要兑奖券价格
		local Prize = exchangeGoodTable.Prize
		--…Picture  列表界面大图
		local Picture = exchangeGoodTable.Picture
		--…Description  明细界面的说明
		local Description = exchangeGoodTable.Description
		local AwardStatus = exchangeGoodTable.AwardStatus
		local AwardMsg = exchangeGoodTable.AwardMsg
		local exchangbleTable = profile.Prize.getExchangbleAwardsInfo()

		if GoodID > 10000 then
			Common.log("AwardStatus is " .. AwardStatus)
			--现金奖品
			if AwardStatus == STATUS_COMPASS_AND_EXCHANGABLE then
				--可合成兑奖
				ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,true,AwardMsg)
			else
				ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,false)
			end
			mvcEngine.createModule(GUI_EXCHANGEDETAIL)
		else
			--实物奖励
			local isComposeAndExchange = false
			local composeAndExchangeItemInfo = nil
			if exchangbleTable["ExchangableAwardsList"] ~= nil and #exchangbleTable["ExchangableAwardsList"] ~= 0 then
				for j = 1,#exchangbleTable["ExchangableAwardsList"] do
					if exchangbleTable["ExchangableAwardsList"][j].awardID == GoodID then
						Common.log("ExchangableAwardsList awardStatus " .. exchangbleTable["ExchangableAwardsList"][j].awardStatus)
						if exchangbleTable["ExchangableAwardsList"][j].awardStatus == 2 then
							isComposeAndExchange = true
							composeAndExchangeItemInfo = exchangbleTable["ExchangableAwardsList"][j]
						end
					end
				end

				if isComposeAndExchange ==  true then
					--可合成兑奖
					Common.log("ExchangableAwardsList awardStatus " .. "可合成兑奖")
					ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,true,composeAndExchangeItemInfo.awardMsg)
					mvcEngine.createModule(GUI_EXCHANGEDETAIL)
				else
					--其他情况,包括可兑奖和不可兑奖
					ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,false)
					mvcEngine.createModule(GUI_EXCHANGEDETAIL)
				end
			else
				--没有可兑奖物品时
				ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,false)
				mvcEngine.createModule(GUI_EXCHANGEDETAIL)
			end
		end
	end
end

function clearAllListData()
	PriceListScrollView:removeAllChildren();
	PriceImageListTable = {}--兑换图片列表
	SuipianImageListTable = {}--碎片商城图片列表
	MyPriceImageListTable = {}--我的奖品图片列表
	RemainderListTable = {}--抢购奖品剩余列表
end

--[[--
--奖品列表
--]]
function initPriceListView()
	local showAnim = true

	clearAllListData();

	local cellSize = 0--总数

	if PrizeTable["List"]  == nil or PrizeTable["List"] == "" then
	else
		cellSize = #PrizeTable["List"]
	end

	PriceListScrollView:setSize(CCSizeMake(viewW, viewH))
	--	PriceListScrollView:setInnerContainerSize(CCSizeMake(cellWidth * 5 + spacingW * 6 ,cellSize / 5  * (spacingY + cellHeight) + viewH))
	PriceListScrollView:setInnerContainerSize(CCSizeMake(cellWidth * 5 + spacingW * (cellSize + 1),(math.ceil(cellSize / 5)) * (cellHeight + spacingH)))

	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		PriceListScrollView:setPosition(ccp(viewX + 27, viewY - 10))
	else
		PriceListScrollView:setPosition(ccp(viewX + 35, viewY - 10))
	end

	PriceListScrollView:setScaleX(GameConfig.ScaleAbscissa);
	PriceListScrollView:setScaleY(GameConfig.ScaleOrdinate);

	local exchangbleTable = profile.Prize.getExchangbleAwardsInfo()
	local PriceItemList = {};
	for i = 0, cellSize - 1 do
		--物品id
		local GoodID = PrizeTable["List"][i+1].GoodID

		--…ShortName  短名称
		local ShortName = PrizeTable["List"][i+1].ShortName
		--…Name  名称
		Common.log("exchange")
		local Name = PrizeTable["List"][i+1].Name
		Common.log("exchange"..Name)
		--…Prize  需要兑奖券价格
		local Prize = PrizeTable["List"][i+1].Prize
		--…Picture  列表界面大图
		local Picture = PrizeTable["List"][i+1].Picture
		--…Description  明细界面的说明
		local Description = PrizeTable["List"][i+1].Description
		--...AwardStatus
		local AwardStatus = PrizeTable["List"][i+1].AwardStatus
		--...AwardMsg
		local AwardMsg = PrizeTable["List"][i+1].AwardMsg
		--...AwardNeedYuanBao
		local AwardNeedYuanBao = PrizeTable["List"][i+1].AwardNeedYuanBao
		--底层layer
		local layout = ccs.image({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
			image = Common.getResourcePath("bg_bag_item.png"),
		})
		layout:setScale9Enabled(true);
		layout:setAnchorPoint(ccp(0.5, 0.5));

		--按钮
		if(NewUserGuideLogic.getNewUserFlag() == true and GoodID > 10000 and PrizeTable["List"][i+1].AwardStatus == STATUS_COMPASS_AND_EXCHANGABLE)then
			--如果是新手引导，现金奖品，可合成兑奖
			NewUserCreateLogic.setYiYuanHuaFeiData(PrizeTable["List"][i+1]);
		end
		local button = ccs.button({
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
					--删除new
					if profile.HongDian.getProfile_HongDian_datatable() == 0 then
						HongDianLogic.removeList_New_Label(7,uiwidget, GoodID)
					end
				end,
				[ccs.TouchEventType.ended] = function(uiwidget)
					layout:setScale(1)
					if GoodID > 10000 then
						--现金奖品
						Common.log("exchange现金奖品")
						if PrizeTable["List"][i+1].AwardStatus == STATUS_COMPASS_AND_EXCHANGABLE then
							--可合成兑奖
							ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,true,STATUS_COMPASS_AND_EXCHANGABLE,PrizeTable["List"][i+1].AwardMsg)
						elseif PrizeTable["List"][i+1].AwardStatus == STATUS_EXCHANGABLE then
							--可兑奖
							ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,false,STATUS_EXCHANGABLE,"")
						elseif PrizeTable["List"][i+1].AwardStatus == STATUS_NOT_EXCHANGABLE then
							--不可兑奖
							ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,false,STATUS_NOT_EXCHANGABLE,"兑奖券不足，去房间中开宝盒得碎片！")
						elseif PrizeTable["List"][i+1].AwardStatus == STATUS_NEED_PAY_GUIDE then
							--需要充值引导才可合成兑奖
							ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,false,STATUS_NEED_PAY_GUIDE,"您的合成符不足，可以使用元宝直接合成兑奖卷",AwardNeedYuanBao)
						end
						mvcEngine.createModule(GUI_EXCHANGEDETAIL)
					else
						--实物奖励
						Common.log("exchange实物奖励")
						local isComposeAndExchange = false
						local isExchangable = false
						local isNeedGuide = false
						local composeAndExchangeItemInfo = nil
						if exchangbleTable["ExchangableAwardsList"] ~= nil and #exchangbleTable["ExchangableAwardsList"] ~= 0 then
							for j = 1,#exchangbleTable["ExchangableAwardsList"] do
								if exchangbleTable["ExchangableAwardsList"][j].awardID == GoodID then
									if exchangbleTable["ExchangableAwardsList"][j].awardStatus == STATUS_COMPASS_AND_EXCHANGABLE then
										isComposeAndExchange = true
										composeAndExchangeItemInfo = exchangbleTable["ExchangableAwardsList"][j]
									elseif exchangbleTable["ExchangableAwardsList"][j].awardStatus == STATUS_EXCHANGABLE then
										isExchangable = true
									elseif exchangbleTable["ExchangableAwardsList"][j].awardStatus ==STATUS_NEED_PAY_GUIDE then
										isNeedGuide = true
										composeAndExchangeItemInfo = exchangbleTable["ExchangableAwardsList"][j]
									end
								end
							end

							if isComposeAndExchange ==  true then
								--可合成兑奖
								ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,true,STATUS_COMPASS_AND_EXCHANGABLE,composeAndExchangeItemInfo.awardMsg)
							elseif isExchangable == true then
								--可兑奖
								ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,false,STATUS_EXCHANGABLE,"")
							elseif isNeedGuide == true then
								--需要充值引导才可合成兑奖
								ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,false,STATUS_NEED_PAY_GUIDE,"您的合成符不足，可以使用元宝直接合成兑奖卷",composeAndExchangeItemInfo.awardNeedYuanBao)
							else
								--不可兑奖
								ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,false,STATUS_NOT_EXCHANGABLE,"兑奖券不足，去房间中开宝盒得碎片！")
							end
							mvcEngine.createModule(GUI_EXCHANGEDETAIL)
						else
							--没有可兑奖物品时
							ExchangeDetailLogic.setValue(1,GoodID,ShortName,Name,Prize,Picture,Description,false,STATUS_NOT_EXCHANGABLE,"兑奖券不足，去房间中开宝盒得碎片！")
							mvcEngine.createModule(GUI_EXCHANGEDETAIL)
						end
					end
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
					layout:setScale(1)
				end,
			}
		})

		--名称
		local labelName = ccs.label({
			text = ShortName,
			color = ccc3(65,41,25),
		})
		labelName:setFontSize(25)
		local labelName2 = ccs.label({
			text = ShortName,
			color = ccc3(65,41,25),
		})
		labelName2:setFontSize(20)
		--价格
		local labelPrice = ccs.label({
			text = Prize,
			color = ccc3(255,255,255),
		})
		labelPrice:setFontSize(25)
		--兑奖券图片  labelPrice   imageDjq
		local imageDjq = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_macth_chuangguanjiangli_duijiangjuan.png"),
		})
		imageDjq:setScale(0.4)
		--物品图片
		local imageGoods = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_jiazaimoren.png"),
		})

		PriceImageListTable[""..(i + 1)] = imageGoods
		PriceImageListTable[""..(i + 1)]:setVisible(false);
		if Picture ~= nil and  Picture ~= ""  then
			Common.getPicFile(Picture, (i + 1), true, updataPriceImageList)
		end
		local imageInfoBg = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth-65, 30),
			pressed = Common.getResourcePath("yuan.png"),
			normal = Common.getResourcePath("yuan.png"),
			text = "",
		})

		local imageExchangble = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("gift_tan_hao.png"),
		})

		--限量数量背景图
		local imageRemainder = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth-60, 40),
			pressed = Common.getResourcePath("bg_exchange_remainder.png"),
			normal = Common.getResourcePath("bg_exchange_remainder.png"),
			text = "",
		})

		--限量文字
		local labelRemainder = ccs.label({
			text = "超值奖品" ,
			color = ccc3(255,255,255),
		})
		labelRemainder:setFontSize(25)
		if GoodID > 10000 then
			RemainderListTable[""..GoodID] = labelRemainder
		end
		SET_POS(button, 0, 0);
		--设置名称位置
		local labelNameY = 70; -- 280
		SET_POS(labelName, 0,labelNameY);
		local labelName2Y =  70; --280
		SET_POS(labelName2, 0,labelName2Y)
		--设置描述背景
		local imageInfoBgY = -60; -- 60
		SET_POS(imageInfoBg, 0, imageInfoBgY)
		--设置图标位置
		local imageGoodsY = 10; --190
		SET_POS(imageGoods, 0,imageGoodsY);
		local labelPriceX = 8;--150
		local labelPriceY = -59; --60
		SET_POS(labelPrice, labelPriceX,labelPriceY);
		local imageDjqX = -52; --80
		local imageDjqY = -55; --60
		SET_POS(imageDjq, imageDjqX,imageDjqY);
		local imageExchangbleX = 1/2 * cellWidth - 15; -- 60;
		local imageExchangbleY = 1/2 * cellHeight - 10; --cellHeight - 55
		SET_POS(imageExchangble,imageExchangbleX,imageExchangbleY);
		local imageRemainderY = 0;-- -20
		SET_POS(imageRemainder,0,imageRemainderY);
		local labelRemainderY = 0;-- -20
		SET_POS(labelRemainder,0,labelRemainderY);
		if cellSize <= 5 then
			SET_POS(layout,spacingW+cellWidth/2+i % 5*(cellWidth+spacingW), viewH - 1/2 * (cellHeight + spacingH));
		else
			SET_POS(layout,spacingW+cellWidth/2+i % 5*(cellWidth+spacingW), (math.ceil(cellSize / 5)) * (cellHeight + spacingH) - (((math.ceil((i + 1) / 5)) * 2 - 1) / 2 * (cellHeight + spacingH)));
		end
		layout:addChild(imageInfoBg);
		layout:addChild(imageGoods);
		layout:addChild(labelName2);
		--		layout:addChild(labelName);
		layout:addChild(labelPrice);
		layout:addChild(imageDjq);
		layout:addChild(button);
		--添加红点NEWLABEL标签
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			----监测服务器数据
			if i == cellSize - 1 then
				HongDianLogic.getHongDian_Data_isTure(7, i+1, GoodID, 1)
			else
				HongDianLogic.getHongDian_Data_isTure(7, i+1, GoodID)
			end
			HongDianLogic.showAllChild_List_NewLabel(7,GoodID ,layout )
		end

		if exchangbleTable["ExchangableAwardsList"] ~= nil and #exchangbleTable["ExchangableAwardsList"] ~= 0 then
			for j = 1,#exchangbleTable["ExchangableAwardsList"] do
				if exchangbleTable["ExchangableAwardsList"][j].awardID == GoodID and exchangbleTable["ExchangableAwardsList"][j].awardNeedYuanBao == 0 then
					--如果可以合成兑奖
					layout:addChild(imageExchangble)
					break
				end
			end
		end
		if GoodID > 10000 then
			--如果是现金商品
			layout:addChild(imageRemainder)
			layout:addChild(labelRemainder)
			if PrizeTable["List"][i+1].AwardStatus == STATUS_COMPASS_AND_EXCHANGABLE or PrizeTable["List"][i+1].AwardStatus == STATUS_EXCHANGABLE then
				--如果可以合成兑奖
				layout:addChild(imageExchangble)
			end
		end
		table.insert(PriceItemList, layout);

		PriceListScrollView:addChild(layout)
		--获取我需要   从站内信跳转  过来的物品的 相关 信息
		setMessageExchangeData(GoodID,PrizeTable["List"][i+1])
	end

	local function callbackShowImage(index)
		if PriceImageListTable[""..index] ~= nil then
			PriceImageListTable[""..index]:setVisible(true);
		end
	end
	Common.closeProgressDialog()
	LordGamePub.showLandscapeList(PriceItemList, callbackShowImage);
	--显示从站内信跳转过来的具体物品信息
	showExchangeGoodsInfo()
end

--[[--
显示碎片兑奖券
--]]
function showPicesView(data_temp)
	goods_ID = nil
	if tempviewShowTag ~= nil and tempviewShowTag == viewShowTag then
		--物品id
		local GoodID = data_temp.GoodID
		--…ShortName  短名称
		local ShortName = data_temp.ShortName
		--…Name  名称
		local Name = data_temp.Name
		--…Prize  需要兑奖券价格
		local Prize = data_temp.Prize
		--…Picture  列表界面大图
		local Picture = data_temp.Picture
		Common.log("Picture === "..Picture);
		--…Description  明细界面的说明
		local Description = data_temp.Description
		ExchangeDetailLogic.setValue(2,GoodID,ShortName,Name,Prize,Picture,Description)
		mvcEngine.createModule(GUI_EXCHANGEDETAIL)
	end
end

--[[--
--碎片商城
--]]
function initSuipianListView()
	local SUIPIAN_XIAOLIBAO_ID = 6;--碎片小礼包

	clearAllListData();

	local cellSize = 0--总数
	if SuipianPrizeTable["List"]  == nil or SuipianPrizeTable["List"] == "" then
	else
		cellSize = #SuipianPrizeTable["List"]
	end

	PriceListScrollView:setSize(CCSizeMake(viewW, viewH))
	if cellSize <= 5 then
		PriceListScrollView:setInnerContainerSize(CCSizeMake(cellWidth * 5 + spacingW * (cellSize + 1),viewH))
	else
		PriceListScrollView:setInnerContainerSize(CCSizeMake(cellWidth * 5 + spacingW * (cellSize + 1),(math.ceil(cellSize / 5)) * (cellHeight + spacingH)))
	end

	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		PriceListScrollView:setPosition(ccp(viewX + 27, viewY - 10))
	else
		PriceListScrollView:setPosition(ccp(viewX + 35, viewY - 10))
	end
	PriceListScrollView:setScaleX(GameConfig.ScaleAbscissa);
	PriceListScrollView:setScaleY(GameConfig.ScaleOrdinate);


	if cellSize == 0 then
		return
	end
	local SuipianItemList = {};
	for i = 0, cellSize - 1 do

		--物品id
		local GoodID = SuipianPrizeTable["List"][i+1].GoodID

		--…ShortName  短名称
		local ShortName = SuipianPrizeTable["List"][i+1].ShortName
		--…Name  名称
		local Name = SuipianPrizeTable["List"][i+1].Name
		--…Prize  需要兑奖券价格
		local Prize = SuipianPrizeTable["List"][i+1].Prize
		--…Picture  列表界面大图
		local Picture = SuipianPrizeTable["List"][i+1].Picture
		--…Description  明细界面的说明
		local Description = SuipianPrizeTable["List"][i+1].Description

		--底层layer
		local layout = ccs.image({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
			image = Common.getResourcePath("bg_bag_item.png"),
		})
		layout:setScale9Enabled(true);
		layout:setAnchorPoint(ccp(0.5, 0.5));

		if RenWuLogic.getModifyUserInfo() and GoodID == SUIPIAN_XIAOLIBAO_ID then
			--如果是在做新手任务，则自动弹出碎片小礼包界面
			RenWuLogic.setModifyUserInfo(false);
			ExchangeDetailLogic.setValue(2,GoodID,ShortName,Name,Prize,Picture,Description,nil,STATUS_EXCHANGABLE,"");
			mvcEngine.createModule(GUI_EXCHANGEDETAIL)
		end
		local button = ccs.button({
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
					if profile.HongDian.getProfile_HongDian_datatable() == 0 then
						HongDianLogic.removeList_New_Label(8,uiwidget, GoodID)
					end
				end,
				[ccs.TouchEventType.ended] = function(uiwidget)
					layout:setScale(1)
					if profile.User.getSelfdjqPieces() >= Prize then
						ExchangeDetailLogic.setValue(2,GoodID,ShortName,Name,Prize,Picture,Description,nil,STATUS_EXCHANGABLE,"")
					else
						ExchangeDetailLogic.setValue(2,GoodID,ShortName,Name,Prize,Picture,Description,nil,STATUS_NOT_EXCHANGABLE,"到休闲房间中开宝盒领碎片")
					end
					mvcEngine.createModule(GUI_EXCHANGEDETAIL)
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
					layout:setScale(1)
				end,
			}
		})

		--名称
		local labelName = ccs.label({
			text = ShortName,
			color = ccc3(65,41,25),

		})
		labelName:setFontSize(20)
		--labelName:setFontSize(18)
		--		local labelName2 = ccs.label({
		--			text = ShortName,
		--			color = ccc3(52,32,225),
		--		})
		--		labelName2:setFontSize(26)
		--价格
		local labelPrice = ccs.label({
			text = Prize,
			color = ccc3(255,255,255),
		})
		labelPrice:setFontSize(25)
		--兑奖券图片  labelPrice   imageDjq
		local imageDjq = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_sign_suipian.png"),
		})
		local imageGoods = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_jiazaimoren.png"),
		})
		SuipianImageListTable[""..(i + 1)] = imageGoods;
		SuipianImageListTable[""..(i + 1)]:setVisible(false);
		if Picture ~= nil and  Picture ~= ""  then
			Common.getPicFile(Picture, (i + 1), true, updataSuipianImageList)
		end
		local imageInfoBg = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth-65, 30),
			pressed = Common.getResourcePath("yuan.png"),
			normal = Common.getResourcePath("yuan.png"),
			text = "",
		})

		SET_POS(button, 0, 0);
		--设置名称位置
		local labelNameY = 70;--280
		SET_POS(labelName, 0,labelNameY);
		--SET_POS(labelName2, layout:getSize().width / 2,60)
		--设置描述背景
		local imageInfoBgY = -60;-- 60
		SET_POS(imageInfoBg, 0, imageInfoBgY);
		--设置图标位置
		local imageGoodsY = 10;--190
		SET_POS(imageGoods, 0, imageGoodsY);
		if cellSize <= 5 then
			SET_POS(layout,spacingW+cellWidth/2+i % 5*(cellWidth+spacingW), viewH - 1/2 * (cellHeight + spacingH));
		else
			SET_POS(layout,spacingW+cellWidth/2+i % 5*(cellWidth+spacingW), (math.ceil(cellSize / 5)) * (cellHeight + spacingH) - (((math.ceil((i + 1) / 5)) * 2 - 1) / 2 * (cellHeight + spacingH)));
		end
		local labelPriceX = 8; -- 150
		local labelPriceY = -59; --60
		SET_POS(labelPrice, labelPriceX,labelPriceY);
		local imageDjqX = -52; --80
		local imageDjqY = -60; --60
		SET_POS(imageDjq, imageDjqX,imageDjqY);

		layout:addChild(imageInfoBg)
		layout:addChild(imageGoods)
		--layout:addChild(labelName2)
		layout:addChild(labelName)
		layout:addChild(labelPrice)
		layout:addChild(imageDjq)
		layout:addChild(button)
		--红点添加NEWlabel标签
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			----监测服务器数据
			if i == cellSize - 1 then
				HongDianLogic.getHongDian_Data_isTure(8, i+1, GoodID, 1)
			else
				HongDianLogic.getHongDian_Data_isTure(8, i+1, GoodID)
			end
			HongDianLogic.showAllChild_List_NewLabel(8,GoodID, layout )
		end

		table.insert(SuipianItemList, layout);

		PriceListScrollView:addChild(layout)
		--设置要显示物品的相关信息
		setMessageExchangeData(GoodID, SuipianPrizeTable["List"][i+1])
	end
	local function callbackShowImage(index)
		if SuipianImageListTable[""..index] ~= nil then
			SuipianImageListTable[""..index]:setVisible(true);
		end
	end
	Common.closeProgressDialog()
	LordGamePub.showLandscapeList(SuipianItemList, callbackShowImage);
	--显示物品的具体信息view
	showExchangeGoodsInfo();
end


--[[--
显示  从站内信传 过来的   我的奖品
--]]
function showMyPrizeView(data_temp)
	goods_ID = nil
	if tempviewShowTag ~= nil and tempviewShowTag == viewShowTag then
		--AwardData---奖品ID =
		local AwardID = data_temp.id
		--AwardData---名称 =
		local Name = data_temp.name
		--AwardData---状态 =
		local Status = data_temp.status
		--AwardData---购买日期 =
		local Date = data_temp.date
		--AwardData---图片路径 =
		local PictureUrl = data_temp.url
		--Description
		local Description =  data_temp.Description
		--type 1充值卡  2兑换的奖品、3现金奖品
		local type = data_temp.type
		--Category  1.卡密类 2.实物类
		local Category = data_temp.Category
		--isExpired
		local isExpired = data_temp.isExpired
		--TotalityAmount
		local TotalityAmount = data_temp.TotalityAmount
		--ExchangbleAmount
		local ExchangbleAmount = data_temp.ExchangbleAmount
		--HistoryAmount
		local HistoryAmount = data_temp.HistoryAmount
		--name
		local c = "奖品已领"
		local param1, param2 = string.find(Name, c)
		local disName = Name
		if param1 and param2 then
			disName = string.gsub(disName, "奖品已领：", "")
		end
		if type == 1  then
			if isExpired == 1 then
				MyPrizeDetailLogic.setValue(AwardID,disName,Status,Date,PictureUrl,Description)
				mvcEngine.createModule(GUI_MYPRIZEDETAIL)
			else
				if Status == 0 then
					--1卡密  2实物
					if Category == 2 then
						ExchangeDetailLogic.setValue2(4,AwardID,disName,Status,Date,PictureUrl,Description)
						mvcEngine.createModule(GUI_EXCHANGEDETAIL)
					else
						CardDuihuanWaysLogic.setValue(AwardID,1)
						mvcEngine.createModule(GUI_CARDDUIHUANWAYS)
					end
				else
					--1卡密  2实物
					if Category == 2 then
						MyPrizeDetailLogic.setValue(AwardID,disName,Status,Date,PictureUrl,Description)
						mvcEngine.createModule(GUI_MYPRIZEDETAIL)
					else
						local b = "成功兑换"
						local param1, param2 = string.find(Name, b)
						if param1 and param2 then
							MyPrizeDetailLogic.setValue(AwardID,disName,Status,Date,PictureUrl,Description)
							mvcEngine.createModule(GUI_MYPRIZEDETAIL)
						else
							CardKhAndPassLogic.setAwardID(2,AwardID,Description,Status,Date,PictureUrl,Description)
							mvcEngine.createModule(GUI_CARDKHANDPASS)
						end
					end
				end
			end
		elseif type == 2 then
			ExchangeDetailLogic.setValue2(3,AwardID,disName,Status,Date,PictureUrl,Description)
			mvcEngine.createModule(GUI_EXCHANGEDETAIL)
		elseif type == 3 then
			if ExchangbleAmount ~= nil then
				mvcEngine.createModule(GUI_HUAFEIZHANGHU)
				HuaFeiZhangHuLogic.setData(TotalityAmount,ExchangbleAmount,HistoryAmount,AwardID - 10000,Description)
				Common.log("一元话费  MyPrizeTableList.[i + 1].TotalityAmount==="..TotalityAmount);
				Common.log("一元话费  MyPrizeTableList.[i + 1].ExchangbleAmount==="..ExchangbleAmount);
				Common.log("一元话费  MyPrizeTableList.[i + 1].HistoryAmount==="..HistoryAmount);
				Common.log("一元话费  AwardID - 10000==="..AwardID - 10000);
				Common.log("一元话费  Description==="..Description);
			else
				ExchangeDetailLogic.setValue2(3,AwardID,disName,Status,Date,PictureUrl,Description)
				mvcEngine.createModule(GUI_EXCHANGEDETAIL)
			end
		end
	end
end


--[[--
--我的奖品列表
--]]
function initMyPriceListView()
	clearAllListData();

	local cellSize = 0--总数
	if MyPrizeTable["List"]  == nil or MyPrizeTable["List"] == "" then
	else
		cellSize = #MyPrizeTable["List"]
	end
	--如果我的奖品为空的话，显示3个黑色的框
	if cellSize == 0 then
		cellSize = 1
		PriceListScrollView:setSize(CCSizeMake(viewW, viewH))
		if cellSize <= 5 then
			PriceListScrollView:setInnerContainerSize(CCSizeMake(cellWidth * 5 + spacingW * (cellSize + 1),viewH))
		else
			PriceListScrollView:setInnerContainerSize(CCSizeMake(cellWidth * 5 + spacingW * (cellSize + 1),(math.ceil(cellSize / 5)) * (cellHeight + spacingH)))
		end

		if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
			PriceListScrollView:setPosition(ccp(viewX + 27, viewY - 10))
		else
			PriceListScrollView:setPosition(ccp(viewX + 35, viewY - 10))
		end
		PriceListScrollView:setScaleX(GameConfig.ScaleAbscissa);
		PriceListScrollView:setScaleY(GameConfig.ScaleOrdinate);

		for i = 0, cellSize-1 do
			--底层layer
			local layout = ccs.panel({
				scale9 = true,
				size = CCSizeMake(cellWidth, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
				image = Common.getResourcePath("ui_item_bg.png"),
			})
			layout:setAnchorPoint(ccp(0.5, 0.5))
			--按钮
			local button = ccs.button({
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
					end,
					[ccs.TouchEventType.canceled] = function(uiwidget)
						layout:setScale(1)
					end,
				}
			})
			local labelName = ccs.label({
				text = "您还没有奖品",
				color = ccc3(156,156,156),
			})
			labelName:setFontSize(25)
			local labelName2 = ccs.label({
				text = "您还没有奖品",
				color = ccc3(19,19,19),
			})
			labelName2:setFontSize(26)

			SET_POS(button, 0, 0)
			--设置名称位置
			SET_POS(labelName, layout:getSize().width / 2,60)
			SET_POS(labelName2, layout:getSize().width / 2,60)
			if cellSize <= 5 then
				SET_POS(layout,spacingW+cellWidth/2+i % 5*(cellWidth+spacingW), viewH - 1/2 * (cellHeight + spacingH));
			else
				SET_POS(layout,spacingW+cellWidth/2+i % 5*(cellWidth+spacingW), (math.ceil(cellSize / 5)) * (cellHeight + spacingH) - (((math.ceil((i + 1) / 5)) * 2 - 1) / 2 * (cellHeight + spacingH)));
			end
			layout:addChild(labelName2)
			layout:addChild(labelName)
			layout:addChild(button)
			PriceListScrollView:addChild(layout)
		end
	else
		local showWidth = 0
		if viewW >= cellWidth * cellSize + spacingW * (cellSize + 1) then
			showWidth = viewW+1
		else
			showWidth = cellWidth * cellSize + spacingW * (cellSize + 1)
		end
		PriceListScrollView:setSize(CCSizeMake(viewW, viewH))
		if cellSize <= 5 then
			PriceListScrollView:setInnerContainerSize(CCSizeMake(cellWidth * 5 + spacingW * (cellSize + 1),viewH))
		else
			PriceListScrollView:setInnerContainerSize(CCSizeMake(cellWidth * 5 + spacingW * (cellSize + 1),(math.ceil(cellSize / 5)) * (cellHeight + spacingH)))
		end

		if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
			PriceListScrollView:setPosition(ccp(viewX + 27, viewY - 10))
		else
			PriceListScrollView:setPosition(ccp(viewX + 35, viewY - 10))
		end
		PriceListScrollView:setScaleX(GameConfig.ScaleAbscissa);
		PriceListScrollView:setScaleY(GameConfig.ScaleOrdinate);

		local PriceItemList = {};
		for i = 0, cellSize - 1 do
			--AwardData---奖品ID =
			local AwardID = MyPrizeTable["List"][i+1].id
			Common.log("AwardDatamc"..AwardID)
			--AwardData---名称 =
			local Name = MyPrizeTable["List"][i+1].name
			--AwardData---状态 =
			local Status = MyPrizeTable["List"][i+1].status
			--AwardData---购买日期 =
			local Date = MyPrizeTable["List"][i+1].date
			--AwardData---图片路径 =
			local PictureUrl = MyPrizeTable["List"][i+1].url
			--Description
			local Description =  MyPrizeTable["List"][i+1].Description
			--type 1充值卡  2兑换的奖品、3现金奖品
			local type = MyPrizeTable["List"][i+1].type
			--Category  1.卡密类 2.实物类
			local Category = MyPrizeTable["List"][i+1].Category
			--isExpired
			local isExpired = MyPrizeTable["List"][i+1].isExpired
			--TotalityAmount
			local TotalityAmount = MyPrizeTable["List"][i + 1].TotalityAmount
			--ExchangbleAmount
			local ExchangbleAmount = MyPrizeTable["List"][i + 1].ExchangbleAmount
			--HistoryAmount
			local HistoryAmount = MyPrizeTable["List"][i + 1].HistoryAmount
			Common.log("奖品ID ======= "..AwardID)
			Common.log("奖品名称 ======= "..Name .. "type is " .. type .. " Status is " .. Status .. " isExpired is " .. isExpired)
			--三种状态的背景图  bg_macth_label  ic_prize_yiguoqi  ic_prize_yilingqu
			local img_ding = ""
			--name
			local c = "奖品已领"
			local param1, param2 = string.find(Name, c)
			local disName = Name
			if param1 and param2 then
				disName = string.gsub(disName, "奖品已领：", "")
			end
			if(type == 3 and MyPrizeTable["List"][i + 1].ExchangbleAmount ~= nil)then
				NewUserCreateLogic.setYiYuanHuaFeiAward(MyPrizeTable["List"][i + 1]);
			end
			local StatusText = nil
			if type == 1 then
				Common.log("充值卡状态"..isExpired.."=="..Status)
				--type==1 充值卡  isExpired ==1已过期  Status==0领奖   已领奖
				--type==2 奖品       Status==0处理中    1已发货  2已领奖  已过期
				if isExpired == 1 then
					StatusText = "已过期"
					img_ding = "ic_prize_yiguoqi.png"
				else
					if Status == 1 then
						StatusText = "处理中"
						img_ding = ""
					elseif Status == 2 then
						StatusText = "已领奖"
						img_ding = "ic_prize_yilingqu.png"
					elseif Status == 0 then
						StatusText = "可领取"
						img_ding = "gift_tan_hao.png"
					end
				end
			elseif type == 3 then
				if MyPrizeTable["List"][i+1].ExchangbleAmount ~= nil and MyPrizeTable["List"][i+1].TotalityAmount ~= nil then
					--现金奖
					if MyPrizeTable["List"][i+1].ExchangbleAmount > MyPrizeTable["List"][i+1].TotalityAmount then
						StatusText = ""
						img_ding = ""
					else
						StatusText = "可领奖"
						img_ding = "gift_tan_hao.png"
					end
				else
					if Status == 1 then
						StatusText = "处理中"
						img_ding = ""
					elseif Status == 2 then
						StatusText = "已领奖"
						img_ding = "ic_prize_yilingqu.png"
					elseif Status == 0 then
						StatusText = "可领取"
						img_ding = "gift_tan_hao.png"
					end
				end
			else
				--实物奖
				if Status == 0 then
					StatusText = "处理中"
					img_ding = ""
				elseif Status == 1 then
					StatusText = "已发货"
					img_ding = ""
				elseif Status == 2 then
					StatusText = "已领奖"
					img_ding = "ic_prize_yilingqu.png"
				else
					StatusText = "已过期"
					img_ding = "ic_prize_yiguoqi.png"
				end
			end
			local img_dingBg = ccs.image({
				scale9 = false,
				image = Common.getResourcePath(img_ding),
			})
			img_dingBg:setZOrder(ZORDER_LOW);
			local bgMenghei = ccs.button({
				scale9 = true,
				size = CCSizeMake(cellWidth, cellHeight-10),
				pressed = Common.getResourcePath("bg_macth_zhezhao.png"),
				normal = Common.getResourcePath("bg_macth_zhezhao.png"),
				text = "",
			})
			bgMenghei:setTouchEnabled(false)

			--底层layer
			local layout = ccs.image({
				scale9 = true,
				size = CCSizeMake(cellWidth, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
				image = Common.getResourcePath("bg_bag_item.png"),
			})
			layout:setScale9Enabled(true);
			layout:setAnchorPoint(ccp(0.5, 0.5));

			--按钮
			local button = ccs.button({
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
						if profile.HongDian.getProfile_HongDian_datatable() == 0 then
							HongDianLogic.removeList_New_Label(9,uiwidget, AwardID)
							Common.log("removeList_New_Label9")
						end
						--type==1 充值卡  isExpired ==1已过期  Status==0领奖   已领奖
						--type==2 奖品       Status==0处理中    1已发货  2已领奖  已过期
						Common.log("duijiang1"..type..Status)
						if type == 1  then
							if isExpired == 1 then
								MyPrizeDetailLogic.setValue(AwardID,disName,Status,Date,PictureUrl,Description)
								mvcEngine.createModule(GUI_MYPRIZEDETAIL)
							else
								if Status == 0 then
									--1卡密  2实物
									if Category == 2 then
										ExchangeDetailLogic.setValue2(4,AwardID,disName,Status,Date,PictureUrl,Description)
										mvcEngine.createModule(GUI_EXCHANGEDETAIL)
									else
										Common.log("MyPrizeDetailLogic=="..AwardID)
										CardDuihuanWaysLogic.setValue(AwardID,1)
										mvcEngine.createModule(GUI_CARDDUIHUANWAYS)
									end
								elseif Status == 1 then
									Common.showToast("您的兑奖请求已收到，客服正在抓紧处理中！", 2)
								else
									--1卡密  2实物
									if Category == 2 then
										MyPrizeDetailLogic.setValue(AwardID,disName,Status,Date,PictureUrl,Description)
										mvcEngine.createModule(GUI_MYPRIZEDETAIL)
									else
--										local b = "成功兑换"
--										local param1, param2 = string.find(Name, b)
--										if param1 and param2 then
											MyPrizeDetailLogic.setValue(AwardID,disName,Status,Date,PictureUrl,Description)
											mvcEngine.createModule(GUI_MYPRIZEDETAIL)
--										else
--											CardKhAndPassLogic.setAwardID(2,AwardID,Description,Status,Date,PictureUrl,Description)
--											mvcEngine.createModule(GUI_CARDKHANDPASS)
--										end
									end
								end
							end
						elseif type == 2 then
							ExchangeDetailLogic.setValue2(3,AwardID,disName,Status,Date,PictureUrl,Description)
							mvcEngine.createModule(GUI_EXCHANGEDETAIL)
						elseif type == 3 then
							if MyPrizeTable["List"][i + 1].ExchangbleAmount ~= nil then
								mvcEngine.createModule(GUI_HUAFEIZHANGHU)
								HuaFeiZhangHuLogic.setData(MyPrizeTable["List"][i + 1].TotalityAmount,MyPrizeTable["List"][i + 1].ExchangbleAmount,MyPrizeTable["List"][i + 1].HistoryAmount,AwardID - 10000,Description)
							else
								ExchangeDetailLogic.setValue2(3,AwardID,disName,Status,Date,PictureUrl,Description)
								mvcEngine.createModule(GUI_EXCHANGEDETAIL)
							end
						end
					end,
					[ccs.TouchEventType.canceled] = function(uiwidget)
						layout:setScale(1)
					end,
				}
			})

			button:setZOrder(ZORDER_HIGH);
			local labelStatus = nil
			if MyPrizeTable["List"][i+1].ExchangbleAmount ~= nil and MyPrizeTable["List"][i+1].TotalityAmount ~= nil then
				--现金奖
				if MyPrizeTable["List"][i+1].ExchangbleAmount > MyPrizeTable["List"][i+1].TotalityAmount then
					labelStatus= ccs.label({
					text = MyPrizeTable["List"][i + 1].TotalityAmount .. "/" .. MyPrizeTable["List"][i + 1].ExchangbleAmount .. "元",
					color = ccc3(255,255,255),
					})
				else
					labelStatus= ccs.label({
					text = MyPrizeTable["List"][i + 1].TotalityAmount .. "/" .. MyPrizeTable["List"][i + 1].ExchangbleAmount .. "元",
					color = ccc3(177,219,75),
					})
				end
			else
				labelStatus= ccs.label({
				text = StatusText,
				color = ccc3(255,255,255),
				})
			end

			labelStatus:setFontSize(25)
			labelStatus:setZOrder(ZORDER_HIGH)
			--下部的名称
			local labelName = ccs.label({
					text = disName,
					color = ccc3(65,41,25),
				})
			labelName:setFontSize(20)

--			if type == 3 and MyPrizeTable["List"][i + 1].ExchangbleAmount ~= nil then
--				labelName = ccs.label({
--					text =  MyPrizeTable["List"][i + 1].TotalityAmount .. "/" .. MyPrizeTable["List"][i + 1].ExchangbleAmount .. "元",
--					color = ccc3(255,255,255),
--				})
--			else
--				labelName = ccs.label({
--					text = disName,
--					color = ccc3(255,255,255),
--				})
--			end

			--labelName:setFontSize(25)
			--上部的名称
			local labelName2 = ccs.label({
				text = disName,
				color = ccc3(65,41,25),
			})
			labelName2:setFontSize(20)

			--物品图片
			local imageGoods = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("ic_jiazaimoren.png"),
			})
			MyPriceImageListTable[""..(i + 1)] = imageGoods;
			MyPriceImageListTable[""..(i + 1)]:setVisible(false);
			if PictureUrl ~= nil and  PictureUrl ~= ""  then
				Common.getPicFile(PictureUrl, (i + 1), true, updataMyPriceImageList)
			end
			local imageInfoBg = ccs.button({
				scale9 = true,
				size = CCSizeMake(cellWidth-65, 30),
				pressed = Common.getResourcePath("yuan.png"),
				normal = Common.getResourcePath("yuan.png"),
				text = "",
			})


			SET_POS(button, 0, 0);
			--设置名称位置
			local labelNameY = 70; -- 280
			SET_POS(labelName, 0,labelNameY);
			local labelName2Y = 70;--280
			SET_POS(labelName2, 0,labelName2Y);
			--设置描述背景
			local imageInfoBgY = -60;--60
			SET_POS(imageInfoBg, 0, imageInfoBgY);
			--设置图标位置
			local imageGoodsY = 10;--20
			SET_POS(imageGoods, 0,imageGoodsY);
			SET_POS(bgMenghei, 0,0);
			local labelStatusX = 3;--150
			local labelStatusY = -59; --60
			SET_POS(labelStatus, labelStatusX,labelStatusY);
			if type == 1 then
				--type==1 充值卡  isExpired ==1已过期  Status==0领奖   已领奖
				--type==2 奖品       Status==0处理中    1已发货  2已领奖  已过期
				if isExpired == 1 then
					local img_dingBgY = 20; --layout:getSize().height/2+20
					SET_POS(img_dingBg, 0, img_dingBgY);
				else
					if Status == 0 then
						Common.log("xwh awardNAME is " .. Name)
						--						SET_POS(img_dingBg, 0+img_dingBg:getSize().width / 2,layout:getSize().height - img_dingBg:getSize().height / 2 )
						--SET_POS(img_dingBg, (img_dingBg:getSize().width - layout:getSize().width) / 2, (layout:getSize().height - img_dingBg:getSize().height) / 2 );
						SET_POS(img_dingBg, 1/2 * cellWidth - 15,1/2 * cellHeight - 10);
					--						SET_POS(labelStatus, img_dingBg:getSize().width/2-10, layout:getSize().height - img_dingBg:getSize().height / 2 + 10)--状态
					--						SET_POS(labelStatus, (img_dingBg:getSize().width- layout:getSize().width)/2-10, (layout:getSize().height - img_dingBg:getSize().height / 2) + 10);--状态
					--						SET_POS(labelStatus,img_dingBg:getPosition().x - 10,img_dingBg:getPosition().y + 10);--状态
					else
						SET_POS(img_dingBg, 0,0);
					end
				end
			elseif type == 3 then
				if MyPrizeTable["List"][i+1].ExchangbleAmount ~= nil and MyPrizeTable["List"][i+1].TotalityAmount ~= nil then
					--现金奖
					if MyPrizeTable["List"][i+1].ExchangbleAmount > MyPrizeTable["List"][i+1].TotalityAmount then

					else
						SET_POS(img_dingBg, 1/2 * cellWidth - 15,1/2 * cellHeight - 10);
					end
				else
					if Status == 0 then
						SET_POS(img_dingBg, 1/2 * cellWidth - 15,1/2 * cellHeight - 10);
					--						SET_POS(img_dingBg, (img_dingBg:getSize().width - layout:getSize().width)  / 2, (layout:getSize().height - img_dingBg:getSize().height) / 2 )
					--					SET_POS(labelStatus,(img_dingBg:getSize().width- layout:getSize().width)/2-10, (layout:getSize().height - img_dingBg:getSize().height) / 2 + 10)--状态
					--						SET_POS(labelStatus,img_dingBg:getPosition().x - 10,img_dingBg:getPosition().y + 10);--状态
					elseif Status == 1 then
					--						SET_POS(img_dingBg, (img_dingBg:getSize().width- layout:getSize().width) / 2,(layout:getSize().height - img_dingBg:getSize().height) / 2 )
					--					SET_POS(labelStatus,(img_dingBg:getSize().width- layout:getSize().width)/2-10, (layout:getSize().height - img_dingBg:getSize().height) / 2 + 10)--状态
					--						SET_POS(labelStatus,img_dingBg:getPosition().x - 10,img_dingBg:getPosition().y + 10);--状态
					elseif Status == 2 then
						SET_POS(img_dingBg, 0, 0);
					end
				end

			else
				--实物奖
				if Status == 0 then
				--					SET_POS(img_dingBg, (img_dingBg:getSize().width - layout:getSize().width) / 2,(layout:getSize().height - img_dingBg:getSize().height) / 2 )
				--					SET_POS(labelStatus, (img_dingBg:getSize().width - layout:getSize().width)/2-10, (layout:getSize().height - img_dingBg:getSize().height) / 2 + 10)--状态
				--					SET_POS(labelStatus,img_dingBg:getPosition().x - 10,img_dingBg:getPosition().y + 10);--状态

				elseif Status == 1 then
				--					SET_POS(img_dingBg,60,0);
				--					SET_POS(labelStatus, 50, 10)--状态
				elseif Status == 2 then
					SET_POS(img_dingBg, 0,0);
				--					SET_POS(labelStatus, -10, 10)--状态
				else
					SET_POS(img_dingBg, 0,20);
				--					SET_POS(labelStatus, 50, 10)--状态
				end
			end

			if cellSize <= 5 then
				SET_POS(layout,spacingW+cellWidth/2+i % 5*(cellWidth+spacingW), viewH - 1/2 * (cellHeight + spacingH));
			else
				SET_POS(layout,spacingW+cellWidth/2+i % 5*(cellWidth+spacingW), (math.ceil(cellSize / 5)) * (cellHeight + spacingH) - (((math.ceil((i + 1) / 5)) * 2 - 1) / 2 * (cellHeight + spacingH)));
			end

			layout:addChild(imageInfoBg)
			layout:addChild(imageGoods)
			layout:addChild(labelName)
			layout:addChild(button)
			layout:addChild(labelStatus)
			--添加红点
			Common.log("监测服务器数据profile.HongDian")
			if profile.HongDian.getProfile_HongDian_datatable() == 0 then
				----监测服务器数据
				Common.log("监测服务器数据profile.HongDian"..AwardID)
				if i == cellSize - 1 then
					HongDianLogic.getHongDian_Data_isTure(9, i+1, AwardID, 1)
				else
					Common.log("监测服务器数据profile.HongDian"..AwardID)
					HongDianLogic.getHongDian_Data_isTure(9, i+1, AwardID)
				end
				HongDianLogic.showAllChild_List_NewLabel(9,AwardID,layout )
			end

			if type == 1 then
				--充值卡  已过期  领奖   已领奖   处理中    已发货  已领奖  已过期
					if Status ~= 0 then
						--不是可领取就蒙黑
						layout:addChild(bgMenghei)
					end
					layout:addChild(img_dingBg)
			elseif type == 3 then
				if MyPrizeTable["List"][i+1].ExchangbleAmount ~= nil and MyPrizeTable["List"][i+1].TotalityAmount ~= nil then
					Common.log("ExchangbleAmount TotalityAmount not nil")
					--现金奖
					if MyPrizeTable["List"][i+1].ExchangbleAmount > MyPrizeTable["List"][i+1].TotalityAmount then
					else
						layout:addChild(img_dingBg)
					end
				else
					if Status ~= 0 then
						--不是可领取就蒙黑
						layout:addChild(bgMenghei)
					end

					if Status == 2 then
						--已领取
						layout:addChild(img_dingBg)
					end
				end
			else
				--实物奖
				if Status == 0 or Status == 1 then
				else
					layout:addChild(img_dingBg)
				end
				if Status ~= 0 then
					layout:addChild(bgMenghei)
				end
				if Status ~= 0 and Status ~= 1 then
					layout:addChild(img_dingBg)
				end
			end

			table.insert(PriceItemList, layout);

			PriceListScrollView:addChild(layout);

			--设置交换物品的相关信息
			setMessageExchangeData(AwardID, MyPrizeTable["List"][i+1])
		end
		local function callbackShowImage(index)
			if MyPriceImageListTable[""..index] ~= nil then
				MyPriceImageListTable[""..index]:setVisible(true);
			end
		end
		Common.closeProgressDialog()
		LordGamePub.showLandscapeList(PriceItemList, callbackShowImage);
		--显示物品的具体信息
		showExchangeGoodsInfo();
	end
end

--[[--
--设置从站内信传过来物品的相关信息
--@param number mnGoodsID 物品ID
--@param table dataTable 表
--]]
function setMessageExchangeData(mnGoodsID, dataTable)
	--获取所要道具物品的所有相关信息
	if tonumber(goods_ID) == tonumber(mnGoodsID) then
		ExchangeGoodTable = dataTable
	end
end

--[[--
--显示交换物品信息
--]]
function showExchangeGoodsInfo()
	if goods_ID ~= nil and ExchangeGoodTable ~= nil then
		--如果是兑奖栏
		if viewShowTag == TABDUIJIANGQUAN then
			show_DuiJiangQuanView(ExchangeGoodTable)
			--如果是碎片栏
		elseif viewShowTag == TABSUIPIAN then
			showPicesView(ExchangeGoodTable)
			--如果是礼品栏
		elseif viewShowTag == TABJIANGPIN then
			showMyPrizeView(ExchangeGoodTable)
		end
	end
end


function requestMsg()
	--新手引导
	NewUserCreateLogic.JumpInterface(ExchangeLogic.view,NewUserCoverOtherLogic.getTaskState());
end


--[[--
--我的奖卷兑换按钮
--]]
function callback_btn_jiangquan(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		setTableState(1)
		Common.showProgressDialog("数据加载中...")
		initPriceListView()
		--删除所有红点
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			removeAllChildAndCleanUp()
			HongDianLogic.showAllModule_HongDian(8,btn_suipian  )
			HongDianLogic.showAllModule_HongDian(9,btn_myprice  )
		end

	elseif component == CANCEL_UP then
	--取消
	end
end
--碎片对黄按钮
function callback_btn_suipian(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		setTableState(2)
		Common.showProgressDialog("数据加载中...")
		initSuipianListView()
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			removeAllChildAndCleanUp()
			HongDianLogic.showAllModule_HongDian(7,btn_jiangquan   )
			HongDianLogic.showAllModule_HongDian(9,btn_myprice  )
		end

	elseif component == CANCEL_UP then
	--取消
	end
end


--我的奖品按钮
function callback_btn_myprice(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		setTableState(3)
		Common.showProgressDialog("数据加载中...")
		initMyPriceListView()
		--删除所有红点
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			removeAllChildAndCleanUp()
			HongDianLogic.showAllModule_HongDian(7,btn_jiangquan)
			HongDianLogic.showAllModule_HongDian(8,btn_suipian)
		end

	elseif component == CANCEL_UP then
	--取消
	end
end


--兑换金币
function callback_btn_pack_coinrecharge(component)
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


--购买元宝
function callback_btn_pack_yuanbaorecharge(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_EXCHANGE)
		mvcEngine.createModule(GUI_SHOP,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消
	end
end


--[[--
--设置   默认显示栏   和   物品ID
--]]
function setGoodsID(good_id)
	goods_ID = tonumber(good_id);
end


--[[--
--设置当前的选择状态
]]
function setTableState(state)
	viewShowTag = tonumber(state)
	if  viewShowTag == 1 then
		btn_jiangquan:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		btn_suipian:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		btn_myprice:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		zi_jp:loadTexture(Common.getResourcePath("ui_prize_btn_my.png"))
		zi_sp:loadTexture(Common.getResourcePath("ui_prize_btn_chip.png"))
		zi_djq:loadTexture(Common.getResourcePath("ui_prize_btn_thezone2.png"))
	elseif viewShowTag == 2 then
		btn_jiangquan:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		btn_suipian:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		btn_myprice:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		zi_jp:loadTexture(Common.getResourcePath("ui_prize_btn_my.png"))
		zi_sp:loadTexture(Common.getResourcePath("ui_prize_btn_chip2.png"))
		zi_djq:loadTexture(Common.getResourcePath("ui_prize_btn_thezone.png"))
	elseif viewShowTag == 3 then
		btn_jiangquan:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		btn_suipian:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		btn_myprice:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		zi_jp:loadTexture(Common.getResourcePath("ui_prize_btn_my2.png"))
		zi_sp:loadTexture(Common.getResourcePath("ui_prize_btn_chip.png"))
		zi_djq:loadTexture(Common.getResourcePath("ui_prize_btn_thezone.png"))
	end
end

function setState(state)
	tempviewShowTag = tonumber(state)
	viewShowTag = tonumber(state)
end

function callback_btn_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			HongDianLogic.setHongDian_Shop_table_null()
		end

		LordGamePub.showBaseLayerAction(view)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
现金奖列表获取后发送请求实物奖品列表
--]]
function toSendMANAGERID_GET_PRESENTS()
	--碎片兑换
	sendMANAGERID_GET_PRESENTS(profile.Prize.getPrizeListTimestamp());
end

--[[--
奖品兑换
--]]
function showPriceList()
	PrizeTable["List"] = {}
	PrizeTable["List"] = Common.copyTab(profile.Prize.getPrizeTable())
	local cashAwardTable = Common.copyTab(profile.CashAward.getCashAwardsInfo())
	if cashAwardTable["AwardsList"] ~= nil and #cashAwardTable["AwardsList"] > 0 then
		if PrizeTable["List"] ~= nil and #PrizeTable["List"] > 0 then
			for p = 1,#PrizeTable["List"] do
				table.insert(cashAwardTable["AwardsList"],PrizeTable["List"][p])
			end
			PrizeTable["List"] = cashAwardTable["AwardsList"]
		end
	end

	if viewShowTag == 1 then
--		Common.closeProgressDialog()
		initPriceListView()
	end
	--定时发送刷新剩余数请求,然后刷新数量
	refreshCashAwardReminder()
end

function refreshCashAwardReminder()
	local CashAwardTable = Common.copyTab(profile.CashAward.getCashAwardsInfo())
	local dataTable = {}
	if CashAwardTable["AwardsList"] ~= nil and #CashAwardTable["AwardsList"] > 0 then
		for i = 1,#CashAwardTable["AwardsList"] do
			table.insert(dataTable,CashAwardTable["AwardsList"][i].GoodID - 10000)
		end
	end
	local function callback()
		sendOPERID_GET_CASH_AWARD_REMAINDER(dataTable)
	end
	callback()
	if lookTimer ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
	end
	lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(callback,5,false)
end

--[[--
碎片兑换
--]]
function showSuipianPriceListSp()
	SuipianPrizeTable["List"] = profile.SuipianPrize.getPrizeSuipianTable()
	if viewShowTag == 2 then
--		Common.closeProgressDialog()
		initSuipianListView()
	end
end

--[[--
我的奖品
--]]
function showMyPriceList()
	MyPrizeTable["List"] = Common.copyTab(profile.MyPrize.getPrizeTable())
	MyCashPrizeTable = Common.copyTab(profile.CashPrize.getCashPrizeListTable())
	MyCashExchangedPrizeTable = Common.copyTab(profile.CashPrize.getCashPrizeExchangedListTable())
	for p = 1,#MyCashExchangedPrizeTable do
		table.insert(MyCashPrizeTable,MyCashExchangedPrizeTable[p])
	end
	for p = 1,#MyPrizeTable["List"] do
		table.insert(MyCashPrizeTable, MyPrizeTable["List"][p])
	end
	MyPrizeTable["List"] = MyCashPrizeTable
	if viewShowTag == 3 then
--		Common.closeProgressDialog()
		initMyPriceListView()
	end
end

--[[--
刷新界面
--]]
function readRechargeResult()
	sendOPERID_GET_CASH_AWARD_LIST();
end

--[[--
奖品兑换功能
--]]
function slot_couvert()
	local result = profile.Prize.getResult()
	local resultmsg = profile.Prize.getResultText()
	Common.showToast(resultmsg, 2)
	if result == 0 then
		--mvcEngine.createModule(GUI_EXCHANGE,LordGamePub.runSenceAction(view,nil,true))
		--		isCashExchange = false
		local userID = profile.User.getSelfUserID()
		if userID ~= 0 then
			Common.showProgressDialog("数据加载中...")
			sendDBID_USER_INFO(profile.User.getSelfUserID())
		end
		CommShareConfig.showExchangeSharePanel()
	end
end

--[[--
发送获取可兑奖列表请求
--]]
function toSendMANAGERID_GET_EXCHANGBLE_AWARDS()
	sendMANAGERID_GET_EXCHANGBLE_AWARDS()
end

--[[--
发送获取现金可兑奖列表请求
--]]
function refreshList()
	local dataTable = profile.CashAward.getCashAwardsExchangeInfo()
	if dataTable ~= nil and dataTable["result"] == 0 then
		isCashExchange = true
		--新手引导,不弹窗,已经预先弹出了
		if CommDialogConfig.getNewUserGiudeFinish() then
			ImageToast.createView(dataTable.picUrl, nil, "x1", dataTable.message, 2)
			sendMsgAfterOpenBox();
		end
		--		setState(1)
		--		sendOPERID_GET_CASH_AWARD_LIST()
		--		sendOPERID_GET_CASH_PRIZE_LIST(profile.CashPrize.getCashPrizeTimestamp())
		--		--		isCashExchange = true
		--		local userID = profile.User.getSelfUserID()
		--		if userID ~= 0 then
		--			sendDBID_USER_INFO(profile.User.getSelfUserID())
		--		end
		CommShareConfig.showExchangeSharePanel(dataTable.picUrl)
	else
		Common.showToast(dataTable["message"], 2)
	end
end


--[[--
发送获取我的奖品列表请求
--]]
function toSendMANAGERID_GET_EXCHANGE_AWARDS()
	sendNEW_GET_PRIZE_LIST(0,30)
	sendMANAGERID_GET_EXCHANGE_AWARDS(); --兑换的奖品
end

--[[--
现金奖品兑换话费后发送获取现金我的奖品列表请求
--]]
function refreshPrizeListFromFare()
	local dataTable = profile.CashPrize.getCashPrizeExchangeMobileFareTable()
	if dataTable ~= nil and dataTable["result"] == 0 then
		setState(3)
		sendOPERID_GET_CASH_PRIZE_LIST(profile.CashPrize.getCashPrizeTimestamp())
		local userID = profile.User.getSelfUserID()
		if userID ~= 0 then
			Common.showProgressDialog("数据加载中...")
			sendDBID_USER_INFO(profile.User.getSelfUserID())
		end
		Common.showToast(dataTable["message"], 2)
	else
		Common.showToast(dataTable["message"], 2)
	end
end

--[[--
现金奖品兑换金币后发送获取现金我的奖品列表请求
--]]
function refreshPrizeListFromCoin()
	local dataTable = profile.CashPrize.getCashPrizeExchangeGameCoin()
	if dataTable ~= nil and dataTable["result"] == 0 then
		setState(3)
		sendOPERID_GET_CASH_PRIZE_LIST(profile.CashPrize.getCashPrizeTimestamp())
		local userID = profile.User.getSelfUserID()
		if userID ~= 0 then
			Common.showProgressDialog("数据加载中...")
			sendDBID_USER_INFO(profile.User.getSelfUserID())
		end
		Common.showToast(dataTable["message"], 2)
	else
		Common.showToast(dataTable["message"], 2)
	end
end


--[[--
刷新兑奖页面
--]]
function toRefreshView()
--	Common.closeProgressDialog()
	--	mvcEngine.createModule(GUI_EXCHANGE)
	if isFirstGetExchangbleAwards == true or isCashExchange == true then
		isFirstGetExchangbleAwards = false
		isCashExchange = false
	else
		showPriceList()
		showSuipianPriceListSp()
		showMyPriceList()
		profile.Marquee.resetMARQUEE_TABLE(2)
		setCompoundInfo(); --走马灯消息
	end
	--	if isCashExchange == true then
	--
	--	else
	--		showPriceList()
	--		showSuipianPriceListSp()
	--		showMyPriceList()
	--		profile.Marquee.resetMARQUEE_TABLE(2)
	--		setCompoundInfo(); --走马灯消息
	--		isCashExchange = false
	--	end
end

function updataUserInfo()
	Common.log("exchange updataUserInfo")

	--兑奖券贺岁片赋值
	self_yuanbao:setText(profile.User.getDuiJiangQuan())
	self_coin:setText(profile.User.getSelfdjqPieces())
end

--[[--
兑奖页面走马灯
--]]

function setCompoundInfo()
	local Text = profile.Marquee.getOPERID_ACTIVITY_MARQUEE()
	if Text == nil then
		return
	end
	local movetoTime =  0.01
	local winSize = CCDirector:sharedDirector():getWinSize()
	ExchangeZouMaDengLabel:stopAllActions()
	ExchangeZouMaDengLabel:setText(Text)
	ExchangeZouMaDengLabel:setAnchorPoint(ccp(0.5,0.5))
	ExchangeZouMaDengLabel:setPosition(ccp(winSize.width*1.2,ExchangeZouMaDengLabel:getPosition().y))
	local moveby =  CCMoveBy:create(movetoTime*(ExchangeZouMaDengLabel:getContentSize().width +winSize.width*1.2),ccp(-ExchangeZouMaDengLabel:getContentSize().width - winSize.width*1.2,0))
	local headActioArray = CCArray:create()
	headActioArray:addObject(moveby)
	headActioArray:addObject(CCCallFuncN:create(setCompoundInfo))
	ExchangeZouMaDengLabel:runAction(CCRepeatForever:create(CCSequence:create(headActioArray)))
	--	ExchangeZouMaDengTextTable = profile.PriceCompound.getCompoundSucessMsg()
	--	InfoLabelScroll(OPERID_ACTIVITY_MARQUEE_TEXT_TABLE["allStr"])
end

--消除所有红点
function removeAllChildAndCleanUp()
	--if viewShowTag == 1 then

	HongDian_Shop_Table_7_8_9 = HongDianLogic.getHongDian_Shop_table()
	if HongDian_Shop_Table_7_8_9[7] ~= nil then
		HongDian_Shop_Table_7_8_9[7]:setVisible(false)
	end
	if HongDian_Shop_Table_7_8_9[8] ~= nil then
		HongDian_Shop_Table_7_8_9[8]:setVisible(false)
	end
	if HongDian_Shop_Table_7_8_9[9] ~= nil then
		HongDian_Shop_Table_7_8_9[9]:setVisible(false)
	end

end

--[[--
--将初始化标识恢复false,在切换账号时调用
--]]
function releaseHuoDongHasInit()
	huodongHasInit = false
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	viewShowTag = 1;
	--	isCashExchange = false
	if lookTimer ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
	end
	isFirstGetExchangbleAwards = true
end

function addSlot()
	framework.addSlot2Signal(MANAGERID_GET_PRESENTS, showPriceList)--奖品兑换
	framework.addSlot2Signal(MANAGERID_GET_PIECES_SHOP_LIST, showSuipianPriceListSp)--碎片兑换
	framework.addSlot2Signal(NEW_GET_PRIZE_LIST, showMyPriceList)--我的奖品
	framework.addSlot2Signal(MANAGERID_EXCHANGE_AWARD, slot_couvert)
	framework.addSlot2Signal(BASEID_GET_BASEINFO, updataUserInfo)
	framework.addSlot2Signal(OPERID_ACTIVITY_MARQUEE,setCompoundInfo)
	framework.addSlot2Signal(DBID_USER_INFO,toSendMANAGERID_GET_EXCHANGBLE_AWARDS)
	framework.addSlot2Signal(MANAGERID_GET_EXCHANGBLE_AWARDS,toRefreshView)
	framework.addSlot2Signal(OPERID_GET_CASH_AWARD_LIST,toSendMANAGERID_GET_PRESENTS)
	framework.addSlot2Signal(OPERID_GET_CASH_AWARD_REMAINDER,updataRemainderList)
	framework.addSlot2Signal(OPERID_PRIZE_EXCHANGE_MOBILE_FARE,refreshPrizeListFromFare)
	framework.addSlot2Signal(OPERID_PRIZE_EXCHANGE_GAME_COIN,refreshPrizeListFromCoin)
	framework.addSlot2Signal(OPERID_GET_CASH_PRIZE_LIST,toSendMANAGERID_GET_EXCHANGE_AWARDS)
	framework.addSlot2Signal(OPERID_EXCHANGE_LIMITED_AWARD,refreshList)
	framework.addSlot2Signal(MANAGERID_GET_EXCHANGE_AWARDS,showMyPriceList)
	framework.addSlot2Signal(DBID_RECHARGE_RESULT_NOTIFICATION, readRechargeResult)
end

function removeSlot()
	framework.removeSlotFromSignal(MANAGERID_GET_PRESENTS, showPriceList)
	framework.removeSlotFromSignal(MANAGERID_GET_PIECES_SHOP_LIST, showSuipianPriceListSp)
	framework.removeSlotFromSignal(NEW_GET_PRIZE_LIST, showMyPriceList)
	framework.removeSlotFromSignal(MANAGERID_EXCHANGE_AWARD, slot_couvert)
	framework.removeSlotFromSignal(BASEID_GET_BASEINFO, updataUserInfo)
	framework.removeSlotFromSignal(OPERID_ACTIVITY_MARQUEE,setCompoundInfo)
	framework.removeSlotFromSignal(DBID_USER_INFO,toSendMANAGERID_GET_EXCHANGBLE_AWARDS)
	framework.removeSlotFromSignal(MANAGERID_GET_EXCHANGBLE_AWARDS,toRefreshView)
	framework.removeSlotFromSignal(OPERID_GET_CASH_AWARD_LIST,toSendMANAGERID_GET_PRESENTS)
	framework.removeSlotFromSignal(OPERID_GET_CASH_AWARD_REMAINDER,updataRemainderList)
	framework.removeSlotFromSignal(OPERID_PRIZE_EXCHANGE_MOBILE_FARE,refreshPrizeListFromFare)
	framework.removeSlotFromSignal(OPERID_PRIZE_EXCHANGE_GAME_COIN,refreshPrizeListFromCoin)
	framework.removeSlotFromSignal(OPERID_GET_CASH_PRIZE_LIST,toSendMANAGERID_GET_EXCHANGE_AWARDS)
	framework.removeSlotFromSignal(OPERID_EXCHANGE_LIMITED_AWARD,refreshList)
	framework.removeSlotFromSignal(MANAGERID_GET_EXCHANGE_AWARDS,showMyPriceList)
	framework.removeSlotFromSignal(DBID_RECHARGE_RESULT_NOTIFICATION, readRechargeResult)
end
