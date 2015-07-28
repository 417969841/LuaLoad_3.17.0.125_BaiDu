module("SelectLaiziCardLogic",package.seeall)

view = nil

local CCTOUCHBEGAN = "began"
local CCTOUCHMOVED = "moved"
local CCTOUCHENDED = "ended"

Panel_SelectLaiziCard = nil

CardBatchNode = nil--存放展示的牌

laiziCardsTable = {}--存放展示牌型
CardsTableIndex = {}--存放展示牌型的真实下标
laiziCardsInterval = {}--存放牌型的显示区间
CardLayer = nil
local ViewBgW = 0;
local ViewBgH = 0;
local ViewBgX = 0;
local ViewBgY = 0;

local DW = 80;
local DH = 100;

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

local function OnTouchEvent(eventType, x, y)

	--点击选牌区域
	for i = 1, #laiziCardsInterval do
		if x > laiziCardsInterval[i][1] and x < laiziCardsInterval[i][1] + laiziCardsInterval[i][3]
			and y > laiziCardsInterval[i][2] - laiziCardsInterval[i][4] and y < laiziCardsInterval[i][2] then
			if eventType == CCTOUCHBEGAN then
				return true
			elseif eventType == CCTOUCHMOVED then
			elseif eventType == CCTOUCHENDED then
				TableConsole.sendTakeOutCard(TableCardLayer.getPopUpCardsVal(CardsTableIndex[i]));
				mvcEngine.destroyModule(GUI_TABLE_SELECT_LAIZI)
				break;
			end
		end
	end

	--点击周围区域
	if x < ViewBgX - DW / 2 or x > ViewBgX - DW / 2 + ViewBgW + DW
		or y > ViewBgY + DH - 10 or y < ViewBgY + DH - 10- (ViewBgH + DH) then
		mvcEngine.destroyModule(GUI_TABLE_SELECT_LAIZI)
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("SelectLaiziCard.json")
	local gui = GUI_TABLE_SELECT_LAIZI
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

	CardLayer = CCLayer:create()
	CardLayer:registerScriptTouchHandler(OnTouchEvent)
	CardLayer:setTouchEnabled(true)
	CardLayer:setZOrder(100)
	view:addChild(CardLayer)

	Panel_SelectLaiziCard = cocostudio.getUIPanel(view, "Panel_SelectLaiziCard")

	CardBatchNode = CCSpriteBatchNode:create(Common.getResourcePath("card.png"))
	CardBatchNode:setZOrder(3)
	view:addChild(CardBatchNode)
end

function requestMsg()

end

--[[--
--设置背景元素
--]]
local function setViewBg()
	local bgOutter = LordGamePub.createPointNineSprite(Common.getResourcePath("ui_item_bg.png"), 30, 35, ViewBgW + DW, ViewBgH + DH)
	bgOutter:setPosition(ViewBgX - DW / 2, ViewBgY + DH - 10)
	bgOutter:setAnchorPoint(ccp(0, 1));
	bgOutter:setZOrder(1)
	view:addChild(bgOutter)
	local bgInner = LordGamePub.createPointNineSprite(Common.getResourcePath("bg_gerenziliao_xinxi.png"), 20, 20, ViewBgW + DW - 30, ViewBgH)
	bgInner:setPosition(ViewBgX - 25, ViewBgY + 10)
	bgInner:setAnchorPoint(ccp(0, 1));
	bgInner:setZOrder(2)
	view:addChild(bgInner)
	local titleLabel = CCLabelTTF:create("选择牌型(30)", "", 30)
	titleLabel:setColor(ccc3(255, 255, 255))
	titleLabel:setAnchorPoint(ccp(0.5, 0.5));
	titleLabel:setPosition(TableConfig.TableDefaultWidth / 2, ViewBgY + DH / 2 - 5)
	titleLabel:setZOrder(3)
	view:addChild(titleLabel)
end

--[[--
--刷新癞子牌
--]]
local function refreshLaiZiCards()
	local Scale = 0.7--牌的缩放比例
	local intervalW = TableConfig.cardWidth * Scale * 0.4 --每张牌的间距

	local allCardsW = 0
	local allCardsH = 0
	local CardsLeftX = 0
	local CardsTopY = 0

	allCardsW = (#laiziCardsTable[1] - 1) * intervalW +  TableConfig.cardWidth * Scale--本套牌的总宽度
	if (#laiziCardsTable > 4) then
		-- 大于四种的选择就要双列显示
		local hangSize = math.floor((#laiziCardsTable + 1) / 2)
		allCardsH = hangSize * TableConfig.cardHeight*(Scale + 0.1)--本套牌的总高度
		ViewBgW = allCardsW * 2 + TableConfig.cardHeight*(Scale/2)
	else
		allCardsH = #laiziCardsTable * TableConfig.cardHeight*(Scale + 0.1)
		ViewBgW = allCardsW
	end

	ViewBgH = allCardsH

	for i = 1, #laiziCardsTable do

		if laiziCardsTable[i] ~= nil then
			TableCardManage.SortCardVal(laiziCardsTable[i], TableCardManage.SORT_MODE_SAMECOUNT)

			local type =  TableCardManage.GetCardType(laiziCardsTable[i])
			local typeName = TableCardManage.CARD_TYPE[type + 1]

			if (#laiziCardsTable > 4) then
				if i % 2 == 0 then
					--右
					CardsLeftX = (TableConfig.TableDefaultWidth - (allCardsW * 2 + TableConfig.cardHeight*(Scale/2))) / 2 + allCardsW + TableConfig.cardHeight*(Scale/2)
				else
					--左
					CardsLeftX = (TableConfig.TableDefaultWidth - (allCardsW * 2 + TableConfig.cardHeight*(Scale/2))) / 2
				end

				CardsTopY = (TableConfig.TableDefaultHeight - (TableConfig.TableDefaultHeight - allCardsH) / 2) - TableConfig.cardHeight*(Scale + 0.1)*(math.floor((i + 1) / 2) - 1)
			else
				CardsLeftX = (TableConfig.TableDefaultWidth - allCardsW) / 2
				CardsTopY = (TableConfig.TableDefaultHeight - (TableConfig.TableDefaultHeight - allCardsH) / 2) - TableConfig.cardHeight*(Scale + 0.1)*(i - 1)
			end

			if i == 1 then
				ViewBgX = CardsLeftX
				ViewBgY = CardsTopY
			end

			for j = 1, #laiziCardsTable[i] do
				if laiziCardsTable[i][j] ~= nil then
					laiziCardsTable[i][j].m_CardSprite:setScale(Scale)
					laiziCardsTable[i][j].m_CardSprite:setPosition((j - 1) * intervalW + CardsLeftX, CardsTopY)
					laiziCardsTable[i][j].m_CardSprite:setZOrder(j)
					CardBatchNode:addChild(laiziCardsTable[i][j].m_CardSprite)
				end
			end

			local typeLabel = CCLabelTTF:create(typeName, "", 27)
			typeLabel:setColor(ccc3(255, 0, 0))
			typeLabel:setAnchorPoint(ccp(0.5, 0));
			typeLabel:setPosition(CardsLeftX + allCardsW / 2, CardsTopY - TableConfig.cardHeight*(Scale) + 5)
			typeLabel:setZOrder(#laiziCardsTable[i] + 1)
			view:addChild(typeLabel)
			laiziCardsInterval[i] = {CardsLeftX, CardsTopY, allCardsW, TableConfig.cardHeight*Scale}
		end
	end

	setViewBg()
end

--[[--
--设置癞子牌
--@param #table malTackOutVal 癞子牌值
--]]
function setLaiziCardsData(cardsSelect)
	laiziCardsTable = {}
	CardsTableIndex = {}
	laiziCardsInterval = {}
	if cardsSelect ~= nil then
		-- 把每一种牌放到一个数组里，之后所有的牌型放到一个table中
		for i = table.maxn(cardsSelect), 1, -1 do
			if cardsSelect[i] ~= nil then
				local tempData = {};
				for j = 1, #cardsSelect[i].cardData do
					local data = cardsSelect[i].cardData[j];
					local val = data.m_nValue;

					local card = TableCard:new(val, FACE_FRONT, false)
					card.mbLaiZi = data.mbIsLaiZi
					card.m_CardSprite.setValue(card.m_nColor, card.m_nWhat, data.mbIsLaiZi)
					table.insert(tempData, card)
				end
				table.insert(laiziCardsTable, tempData);--存数据
				table.insert(CardsTableIndex, cardsSelect[i].index);--存下标，确保顺序一致
			end
		end
	end

	refreshLaiZiCards()
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
	CardBatchNode:removeAllChildrenWithCleanup(true)
	--framework.removeSlotFromSignal(signal, slot)
end
