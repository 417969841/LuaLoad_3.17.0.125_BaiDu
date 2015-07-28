module("CardDuihuanWaysLogic",package.seeall)

view = nil

--控件
scroll_view = nil
--变量
local awardID = nil
local viewType = nil
local coinString = nil
PrizeChangeTable = {}
PriceChange = {}
CashPrizeWaysTable = {}
local userID = nil
btn_close = nil
panel = nil
local exchangeWay = nil
local exchangeType = nil
local checkBoxTable = {}

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
	view = cocostudio.createView("CardDuihuanWays.json")
	local gui = GUI_CARDDUIHUANWAYS
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

	--控件
	scroll_view = cocostudio.getUIScrollView(view, "scroll_view")
	btn_close = cocostudio.getUIButton(view, "btn_close")
	Common.log("viewType ==== "..viewType)
	if viewType == 1 then
		--实物奖
		sendNEW_GET_ALTERNATIVE_PRIZE_LIST(awardID)

	elseif viewType == 2 then
		--现金奖
		initCashList()
	end
	userID = profile.User.getSelfUserID()

end

function initList()
	local Cnt = #PrizeChangeTable["List"]

	local viewW = 500
	local viewHMax = 200
	local viewH = 0
	local viewX = -270
	local viewY = -114

	local cellWidth = 500 --每个元素的宽
	local cellHeight = 90 --每个元素的高

	local lieSize = 1 --列数
	local hangSize = math.floor((Cnt + (lieSize - 1)) / lieSize) --行数
	local spacingW = 0 --横向间隔
	local spacingH = -15 --纵向间隔


	if hangSize * cellHeight > viewHMax then
		viewH = viewHMax
		viewX = -350
		viewY = 75
	else
		viewH = viewHMax
		viewX = -350
		viewY = viewY + viewHMax - hangSize * cellHeight
	end

	scroll_view:setSize(CCSizeMake(viewW+150, viewH+25))
	scroll_view:setInnerContainerSize(CCSizeMake(viewW+150, cellHeight * hangSize + spacingH * (hangSize - 1)))
	scroll_view:setPosition(ccp(viewX, -114))

	for i = 0, Cnt-1 do
		local itemName = PrizeChangeTable["List"][i+1].itemName
		local itemType =  PrizeChangeTable["List"][i+1].itemType
		local layout = ccs.panel({
			scale9 = false,
			size = CCSizeMake(cellWidth, cellHeight),
			image = "",
			capInsets = CCRectMake(0, 0, 0, 0),

		})
		layout:setAnchorPoint(ccp(0.5,0.5))

		local function selected(uiwidget)
			for j = 0,#checkBoxTable do
				checkBoxTable[j]:setSelectedState(false)
			end
			uiwidget:setSelectedState(true)
			exchangeWay = i
			exchangeType = itemType
			Common.log("selected=========="..exchangeWay.." exchangeType "..exchangeType)
		end
		local function unSelected(uiwidget)
		end
		local checkBox = ccs.checkBox({
			normal      = Common.getResourcePath("btn_gerenziliao_select_press.png"),
			pressed     = Common.getResourcePath("btn_gerenziliao_select_press.png"),
			active      = Common.getResourcePath("btn_gerenziliao_select_nor.png"),
			n_disable   = Common.getResourcePath("btn_gerenziliao_select_press.png"),
			a_disable   = Common.getResourcePath("btn_gerenziliao_select_nor.png"),
			x   = 32,
			y   = 32,
			listener    = {[ccs.CheckBoxEventType.selected]     = selected,
				[ccs.CheckBoxEventType.unselected]   = unSelected,}
		})
		checkBoxTable[i] = checkBox

		local labelName = ccs.label({
			text = itemName,
			color = ccc3(193,150,108),
		})
		labelName:setFontSize(25)
		labelName:setTouchEnabled(false)
		labelName:setAnchorPoint(ccp(0,0.5))

		--		SET_POS(button, layout:getSize().width / 2, layout:getSize().height / 2)
		SET_POS(checkBox, layout:getSize().width / 3, layout:getSize().height / 2)
		SET_POS(labelName, layout:getSize().width / 3 + 40, layout:getSize().height / 2)
		--		SET_POS(layout,layout:getSize().width / 2  , cellHeight / 2 + (Cnt-1-i)*(cellHeight+spacingH))
		SET_POS(layout,layout:getSize().width / 2  , cellHeight / 2 + (Cnt-1-i)*(cellHeight+spacingH))

		--		layout:addChild(button)
		layout:addChild(checkBox)
		layout:addChild(labelName)
		scroll_view:addChild(layout)
	end
end

function initCashList()
	local Cnt = 2

	local viewW = 500
	local viewHMax = 300
	local viewH = 0
	local viewX = 50
	local viewY = 50

	local cellWidth = 500 --每个元素的宽
	local cellHeight = 100 --每个元素的高

	local lieSize = 1 --列数
	local hangSize = math.floor((Cnt + (lieSize - 1)) / lieSize) --行数
	local spacingW = 0 --横向间隔
	local spacingH = 0 --纵向间隔


	if hangSize * cellHeight > viewHMax then
		viewH = viewHMax
		viewX = 50
		viewY = 50
	else
		viewH = hangSize * cellHeight
		viewX = 50
		viewY = viewY + viewHMax - hangSize * cellHeight
	end

	--	scroll_view:setSize(CCSizeMake(viewW, viewH))
	--	scroll_view:setInnerContainerSize(CCSizeMake(viewW, cellHeight * hangSize + spacingH * (hangSize - 1)))
	--	scroll_view:setPosition(ccp(viewX, viewY))

	for i = 0, Cnt-1 do
		local itemName = nil
		local itemType =  nil
		if i == 0 then
			itemName = coinString
			itemType =  ""
		else
			itemName = "兑换话费"
			itemType =  "兑换话费"
		end

		local layout = ccs.panel({
			scale9 = false,
			size = CCSizeMake(cellWidth, cellHeight),
			image = "",
			capInsets = CCRectMake(0, 0, 0, 0),

		})
		layout:setAnchorPoint(ccp(0.5,0.5))

		local function selected(uiwidget)
			for j = 0,#checkBoxTable do
				checkBoxTable[j]:setSelectedState(false)
			end
			uiwidget:setSelectedState(true)
			exchangeWay = i
		end
		local function unSelected(uiwidget)
		end
		local checkBox = ccs.checkBox({
			normal      = Common.getResourcePath("btn_gerenziliao_select_press.png"),
			pressed     = Common.getResourcePath("btn_gerenziliao_select_press.png"),
			active      = Common.getResourcePath("btn_gerenziliao_select_nor.png"),
			n_disable   = Common.getResourcePath("btn_gerenziliao_select_press.png"),
			a_disable   = Common.getResourcePath("btn_gerenziliao_select_nor.png"),
			x   = 32,
			y   = 32,
			listener    = {[ccs.CheckBoxEventType.selected]     = selected,
				[ccs.CheckBoxEventType.unselected]   = unSelected,}
		})
		checkBoxTable[i] = checkBox

		local labelName = ccs.label({
			text = itemName,
			color = ccc3(193,150,108),
		})
		labelName:setFontSize(25)
		labelName:setTouchEnabled(false)
		labelName:setAnchorPoint(ccp(0,0.5))
		--		SET_POS(button, layout:getSize().width / 2, layout:getSize().height / 2)
		SET_POS(checkBox, layout:getSize().width / 3, layout:getSize().height / 2)
		SET_POS(labelName, layout:getSize().width / 3 + 40, layout:getSize().height / 2)
		SET_POS(layout,layout:getSize().width / 2 , cellHeight / 2 + i * (cellHeight + spacingH))

		--		layout:addChild(button)
		layout:addChild(checkBox)
		layout:addChild(labelName)
		scroll_view:addChild(layout)
	end
end

function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_ok(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.log("callback_Button_ok exchangeWay is nil")
		if viewType == 1 then
			--实物奖
			if exchangeType ~= nil then
				--直接兑换金币和元宝
				--1 金币 2 元宝 >2 兑换充值卡的需要提交表单
				if exchangeType == 1 or exchangeType == 2 then
					Common.showToast("请求已发出，请稍后", 2)
					sendNEW_GET_ALTERNATIVE_PRIZE(awardID,exchangeType)
				else
					GetCardAwardInfoLogic.setValue(awardID)
					mvcEngine.createModule(GUI_GETCARDAWARDINFO)
				end
				return
			end
		elseif viewType == 2 then
			--现金奖
			if exchangeWay == nil then
				Common.showToast("请选择想要的兑换方式",2)
			elseif exchangeWay == 0 then
				Common.log("callback_Button_ok exchangeWay is 0")
				sendOPERID_PRIZE_EXCHANGE_GAME_COIN(awardID)
				close()
			elseif exchangeWay == 1 then
				Common.log("callback_Button_ok exchangeWay is 1")
				if awardID ~= nil then
					GetCardAwardInfoLogic.setValue(awardID)
					mvcEngine.destroyModule(GUI_CARDDUIHUANWAYS)
					mvcEngine.createModule(GUI_GETCARDAWARDINFO)
				end
			end
		end

	elseif component == CANCEL_UP then
	--取消

	end
end

--关闭
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_CARDDUIHUANWAYS)
end
function setValue(AwardIDV,typeV,coinStringV)
	awardID = AwardIDV
	viewType = typeV
	coinString = coinStringV
end

function slot_list()

	PrizeChangeTable["List"] = {}
	PrizeChangeTable["List"] = profile.MyPrize.getPrizeChange()
	initList()
end

function slot_result()
	PriceChange = profile.MyPrize.getPriceChangeInfo()
	local Result = PriceChange["Result"]
	local exchargeFlag = PriceChange["exchargeFlag"]
	local PrizeTip = PriceChange["PrizeTip"]
	local CardNO = PriceChange["CardNO"]
	local Password = PriceChange["Password"]
	local PrizeID = PriceChange["PrizeID"]
	local PrizeName = PriceChange["PrizeName"]

	--赋值
	if exchargeFlag == 0 then
		Common.log("setsql"..PrizeID.."="..userID.."="..PrizeName.."="..CardNO.."="..Password)
		Common.setDataForSqlite(CommSqliteConfig.GetCardKhInGameName..PrizeID..userID,PrizeName)
		Common.setDataForSqlite(CommSqliteConfig.GetCardKh..PrizeID..userID,CardNO)
		Common.setDataForSqlite(CommSqliteConfig.GetCardPass..PrizeID..userID,Password)
		CardKhAndPassLogic.setValue(1,PrizeID,PrizeName,CardNO,Password)
		mvcEngine.createModule(GUI_CARDKHANDPASS)
	else
		--mvcEngine.destroyModule(GUI_CARDDUIHUANWAYS)
		mvcEngine.createModule(GUI_EXCHANGE)
		--mvcEngine.createModule(GUI_EXCHANGE,LordGamePub.runSenceAction(view,nil,true))
	end
	Common.showToast(PrizeTip, 2)

end

--[[--
--备用奖品获取
--]]
function get_prizev2()
	PRIZE_V2_Table = {}
	PRIZE_V2_Table = profile.MyPrize.getGET_ALTERNATIVE_PRIZE_V2_Table()
	Common.log("get_prizev2")
	if PRIZE_V2_Table["Result"] == 1 then
		--创建实物奖
		GetCardAwardInfoLogic.setValue(awardID)
		GetCardAwardInfoLogic.setisEnable_moibleByperson()
		mvcEngine.destroyModule(GUI_CARDDUIHUANWAYS)
		mvcEngine.createModule(GUI_GETCARDAWARDINFO)
	elseif PRIZE_V2_Table["Result"] == 0 then
		Common.showToast(PRIZE_V2_Table["Msg"], 2)
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	prizeID = nil
	exchangeWay = nil
	exchangeType = nil
end

function addSlot()
	framework.addSlot2Signal(GET_ALTERNATIVE_PRIZE_V2, get_prizev2)
	framework.addSlot2Signal(NEW_GET_ALTERNATIVE_PRIZE_LIST, slot_list)
	framework.addSlot2Signal(NEW_GET_ALTERNATIVE_PRIZE, slot_result)

end

function removeSlot()
	framework.removeSlotFromSignal(GET_ALTERNATIVE_PRIZE_V2, get_prizev2)
	framework.removeSlotFromSignal(NEW_GET_ALTERNATIVE_PRIZE_LIST, slot_list)
	framework.removeSlotFromSignal(NEW_GET_ALTERNATIVE_PRIZE, slot_result)

end
--GUI_CARDKHANDPASS