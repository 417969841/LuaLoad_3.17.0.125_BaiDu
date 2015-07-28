--存放牌桌上所有显示的牌以及结算金币，位于牌桌第二层
module("TableCardLayer", package.seeall)

local CardLayer = nil--存放牌桌上展示的牌

local CardBatchNode = nil--存放牌桌上展示的牌

local SelfCards = {}--自己的手牌

local OutSelfCards = {}--自己本回合出的牌

local ReservedCards = {} --底牌
local mLaiZiCard = nil--癞子底牌

local m_aPlayerTableCards = {} --牌桌上的牌( 下标是牌桌的位置+1 ====== pos+1)

local playerCardVal_1 = {}--玩家位置1的明牌
local playerCardVal_2 = {}--玩家位置2的明牌

local RemainCards = {} --牌桌上剩余的牌( 下标是牌桌的位置+1 ====== pos+1)

local ShuffleList = {} --洗牌

--local noBigCards = nil--没有更大的牌

local ReserveCardIndex = 0;--底牌翻开下标

local ReserveCardMultiple = nil; -- 底牌翻倍图片

local DealTime = 0.03 --发牌间隔
local lookTimer = nil --定时器

dipaiBgLayer = nil
local originY = 0 -- 底牌的初始纵坐标
mingpaiFlag = nil -- 明牌标志图片

isShowReservedCards = false --是否正在显示地主三张底牌动画

isYaobuqi = false

function updateDipaiOriginY()

end

--[[
上移底牌背景layer
]]
function moveUpDipaiBgLayer()
	local up = CCMoveTo:create(0.2, ccp(0, 80))
	local arr = CCArray:create()
	arr:addObject(up)
	dipaiBgLayer:runAction(CCSequence:create(arr))
end

--[[
下移底牌背景layer
]]
function moveDownDipaiBgLayer()
	local down = CCMoveTo:create(0.2, ccp(0, 0))
	local arr = CCArray:create()
	arr:addObject(down)
	dipaiBgLayer:runAction(CCSequence:create(arr))
end

--[[--
--创建纸牌层
]]
local function creatCardLayer()
	CardLayer = CCLayer:create()
	CardLayer:registerScriptTouchHandler(TableOnTouch.OnTouchEvent)
	setCardLayerTouchEnabled(true)
	CardLayer:setZOrder(1)
	CardBatchNode = CCSpriteBatchNode:create(Common.getResourcePath("card.png"))
	CardLayer:addChild(CardBatchNode)

--	noBigCards = CCSprite:create(Common.getResourcePath("ui_desk_hint1.png"))
--	noBigCards:setScale(0.9)
	--iv_photo:setAnchorPoint(ccp(0.5, 0.5));
--	noBigCards:setPosition(TableConfig.TableDefaultWidth / 2, 100);
--	noBigCards:setVisible(false)
--	noBigCards:setZOrder(10)
--	CardLayer:addChild(noBigCards)

	-- 底牌背景layer
	dipaiBgLayer = CCLayer:create()
	dipaiBgLayer:setAnchorPoint(ccp(0, 0))
	dipaiBgLayer:setPosition(ccp(0, 0))
	CardLayer:addChild(dipaiBgLayer)
end

--[[--
--隐藏没有最大牌提示
--]]
function hideNoBigCard()
--	noBigCards:setVisible(false);
	setAllHandCardsMarked(false);
	setCardLayerTouchEnabled(true);

	-- 恢复图片至默认大小和位置
--	noBigCards:setScale(1)
--	noBigCards:setPosition(TableConfig.TableDefaultWidth / 2, 100)

	TableLogic.setYaobuqiState(false)
	isYaobuqi = false
end

--[[--
--显示没有最大牌提示
--]]
function showNoBigCard()
	setAllHandCardsMarked(true);
	setCardLayerTouchEnabled(false);
--	noBigCards:stopAllActions();
--	noBigCards:setVisible(true);

--	TableLogic.setYaobuqiState(true)
	isYaobuqi = true
	if jipaiqiLogic.bJipaiqiViewDidShow == true then
		-- 记牌器已经显示时，需要缩小和上移图片
--		noBigCards:setScale(0.8)
--		noBigCards:setPosition(TableConfig.TableDefaultWidth / 2, 100 + 50)
	end
end

--[[--
--设置出牌触摸监听
--]]
function setCardLayerTouchEnabled(isTouchEnabled)
	if (TableConsole.getPlayer(TableConsole.getSelfSeat()) ~= nil and TableConsole.getPlayer(TableConsole.getSelfSeat()).m_bTrustPlay)
		or not getAllHandCardsIsMarked() then
		CardLayer:setTouchEnabled(false)
	else
		CardLayer:setTouchEnabled(isTouchEnabled)
	end
end

--[[--
--获取纸牌层
--]]
function getCardLayer()
	if CardLayer == nil then
		creatCardLayer()
	end
	return CardLayer
end

local mnNumCoin = 0;--飞金币的个数

--[[--
--隐藏金币
--]]
local function hideFlyCoin(sender)
	sender:setVisible(false)
	CardBatchNode:removeChild(sender, true)
	if mnNumCoin == 0 then
		mnNumCoin = -1;
		local delay = CCDelayTime:create(1.5)
		local arr = CCArray:create()
		arr:addObject(delay)
		arr:addObject(CCCallFuncN:create(TableConsole.GameResultAfterMsg))
		local seq = CCSequence:create(arr)
		CardLayer:runAction(seq)
	end
end

--[[--
--飞金币动画
--]]
local function FlyingCoinAmin(lossPos, WinPos)
	local coin = CCSprite:createWithSpriteFrameName("fly_coin.png")
	coin:setAnchorPoint(ccp(0.5, 0.5));
	coin:setScale(2.0)
	coin:setZOrder(100)
	coin:setPosition(TableConfig.FlyCoinPos[lossPos + 1][1],TableConfig.FlyCoinPos[lossPos + 1][2]);
	CardBatchNode:addChild(coin)
	local flyTime = 0.3
	local move = CCMoveTo:create(flyTime, ccp(TableConfig.FlyCoinPos[WinPos + 1][1],TableConfig.FlyCoinPos[WinPos + 1][2]))
	local arr = CCArray:create()
	arr:addObject(move)
	arr:addObject(CCCallFuncN:create(hideFlyCoin))
	local seq = CCSequence:create(arr)
	coin:runAction(seq)
end

--[[--
--开始飞金币
--]]
local function startFlyCoin()
	for i = 1, #TableConsole.mnWin_Pos do
		for j = 1, #TableConsole.mnLoss_Pos do
			FlyingCoinAmin(TableConsole.mnLoss_Pos[j].pos, TableConsole.mnWin_Pos[i].pos);
		end
	end
	mnNumCoin = mnNumCoin - 1
	if mnNumCoin > 0 then
		local delay = CCDelayTime:create(0.1)
		local arr = CCArray:create()
		arr:addObject(delay)
		arr:addObject(CCCallFuncN:create(startFlyCoin))
		local seq = CCSequence:create(arr)
		CardLayer:runAction(seq)
	end
end

--[[--
--飞金币
--]]
function flyCoin()
	mnNumCoin = 0
	if (TableConsole.mnWin_Pos ~= nil and TableConsole.mnLoss_Pos ~= nil) then
--		Common.log("zbl...#win = " .. #TableConsole.mnWin_Pos .. "           #loss = " .. #TableConsole.mnLoss_Pos)
		local nAllCoin = 0;
		if (#TableConsole.mnWin_Pos > #TableConsole.mnLoss_Pos) then
			--农民赢
--			Common.log("zbl1")
			nAllCoin = TableConsole.mnLoss_Pos[1].WinChip / 2;
		elseif (#TableConsole.mnWin_Pos == #TableConsole.mnLoss_Pos) then
			--农民托管，地主赢
--			Common.log("zbl2")
			nAllCoin = TableConsole.mnLoss_Pos[1].WinChip;
		else
			--地主赢
--			Common.log("zbl3")
			nAllCoin = TableConsole.mnWin_Pos[1].WinChip / 2;
		end

		mnNumCoin = math.floor((math.abs(nAllCoin) + 99) / 100);
		if (mnNumCoin > 0) then
			if (mnNumCoin > 20) then
				mnNumCoin = 20;
			end
			AudioManager.playLordSound(AudioManager.TableSound.COINFLY, false, AudioManager.SOUND);
		end
	end
	startFlyCoin()
end


--[[--
--按帧显示手牌
--]]
local function showHandCardsByIndex(index)
	if SelfCards[index] ~= nil then
		local cardBasePositionX = SelfCards[index].m_CardSprite:getPositionX()
		local cardBasePositionY = SelfCards[index].m_CardSprite:getPositionY()

		local cardBeginPosition = ccp(cardBasePositionX + 500,cardBasePositionY)

		SelfCards[index].m_CardSprite:setVisible(true)

		if index == 17 then
			-- 这张牌是最后一张，设置明牌标志
			setMingpaiFlagSprite(SelfCards[index].m_CardSprite)
		end

		SelfCards[index].m_CardSprite:setPosition(cardBeginPosition)
		local move = CCMoveTo:create(DealTime, ccp(cardBasePositionX,cardBasePositionY))
		local arr = CCArray:create()
		arr:addObject(move)
		--		arr:addObject(CCCallFuncN:create(hideDeal))
		--		arr:addObject(CCCallFuncN:create(setoutDeal))
		local seq = CCSequence:create(arr)
		SelfCards[index].m_CardSprite:runAction(seq)
	end
end

--[[--
-- 发牌结束后,手牌放大动画
--]]--
local function playDealEndAnimation()
	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
	if SelfCards == nil or #SelfCards == 0 then
		return
	end

	for i = 1,#SelfCards do
		local AnchorPosition = SelfCards[i].m_CardSprite:getAnchorPoint()
		local PositionX = SelfCards[i].m_CardSprite:getPositionX()
		local PositionY = SelfCards[i].m_CardSprite:getPositionY()
		local scaleBig = CCScaleTo:create(0.25, 1.1)
		local scaleSmall = CCScaleTo:create(0.25, 1)
		local function callback()
			SelfCards[i].m_CardSprite:setAnchorPoint(AnchorPosition)
			SelfCards[i].m_CardSprite:setPosition(PositionX, PositionY)
			--			SelfCards[i].m_CardSprite:setAnchorPoint(ccp(0,1))
			--			if i == #SelfCards and TableConsole.getPlayer(TableConsole.getSelfSeat()).m_bIsLord then
			--				for i = 1,#ReservedCards do
			--					Common.log("playDealEndAnimation " .. i)
			--				end
			--			end
		end
		local arr = CCArray:create()
		arr:addObject(scaleBig)
		arr:addObject(scaleSmall)
		arr:addObject(CCCallFuncN:create(callback))
		--		arr:addObject(CCCallFuncN:create(hideDeal))
		--		arr:addObject(CCCallFuncN:create(setoutDeal))
		local seq = CCSequence:create(arr)
		SelfCards[i].m_CardSprite:setAnchorPoint(ccp(0.5,0.5))
		SelfCards[i].m_CardSprite:setPosition(PositionX + TableConfig.cardWidth / 2, PositionY - TableConfig.cardHeight / 2)
		SelfCards[i].m_CardSprite:runAction(seq)
	end

	--明牌标志放大动画
	if mingpaiFlag ~= nil then
		local scaleBig = CCScaleTo:create(0.25, 1.1)
		local scaleSmall = CCScaleTo:create(0.25, 1)
		local arr = CCArray:create()
		arr:addObject(scaleBig)
		arr:addObject(scaleSmall)
		local seq = CCSequence:create(arr)
		mingpaiFlag:runAction(seq)
	end
end

local DealIndex = 0--发牌帧

--[[--
--删除发牌
--]]
local function removeShuffleList()
	if ShuffleList ~= nil then
		for i = 1, table.maxn(ShuffleList) do
			if ShuffleList[i] ~= nil then
				CardBatchNode:removeChild(ShuffleList[i].m_CardSprite, true)
			end
		end
		ShuffleList = {}
	end
	DealIndex = 0;
end

OpenInitCard = 1--发牌时明牌可选倍数
isDealEnd = false--是否发牌结束

--[[--
--隐藏已经发出的牌
--]]
local function hideDeal(sender)
	sender:setVisible(false)
	if DealIndex % 3 == 0 then
		--自己的牌
		showHandCardsByIndex(math.floor(DealIndex / 3))
		if TableConsole.getPlayer(TableConsole.getSelfSeat()).mnOpenCardsTimes == 1 then
			if math.floor(DealIndex / 3 / 6) == 0 then
				--四倍明
				if OpenInitCard ~= 4 then
					OpenInitCard = 4
					TableLogic.setOpenInitCardsButton()
				end
			elseif math.floor(DealIndex / 3 / 6) == 1 then
				--三倍明牌
				if OpenInitCard ~= 3 then
					OpenInitCard = 3
					TableLogic.setOpenInitCardsButton()
				end
			elseif math.floor(DealIndex / 3 / 6) == 2 then
				--二倍明牌
				if OpenInitCard ~= 2 then
					OpenInitCard = 2
					TableLogic.setOpenInitCardsButton()
				end
			end
		end
	end
	if DealIndex / 3 == 17 then
		--发牌结束
		AudioManager.stopAllSound()
		isDealEnd = true
		OpenInitCard = 1
		removeShuffleList()
		if TableConsole.mnTableType == TableConsole.TABLE_TYPE_HAPPY or TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT then
			--明牌
			if TableConsole.getPlayer(TableConsole.getSelfSeat()).mnOpenCardsTimes == 1 and TableConsole.IsOpenCardsEnd == 0 then
				TableConsole.setCurrPlayer(-1);
				TableConsole.sendTableOpenCards(1);
			end
			if not TableConsole.getPlayer(TableConsole.getSelfSeat()).m_bTrustPlay then
				TableLogic.hideGameBtn();
			end
			TableConsole.setStatus(TableConsole.STAT_CALLSCORE);
			--TableConsole.setCurrPlayer(TableConsole.m_nCallScorePlayerSeat);
			showOpenCards(1);
			showOpenCards(2);
		else
			--普通房间
			TableConsole.setStatus(TableConsole.STAT_CALLSCORE);
		--TableConsole.setCurrPlayer(TableConsole.m_nCallScorePlayerSeat);
		end
		if lookTimer ~= nil then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
		end
		lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(playDealEndAnimation,0.2,false)
	end
end

--[[--
--发牌动画
--]]
local function setoutDeal()
	DealIndex = DealIndex + 1
	DealTime = 0.03
	if TableConsole.mnTableType == TableConsole.TABLE_TYPE_HAPPY or TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT then
	--		DealTime = 0.06
	elseif TableConsole.mnTableType == TableConsole.TABLE_TYPE_NORMAL then
	--		DealTime = 0.03
	end
	if DealIndex <= #ShuffleList - 3 then
		if DealIndex % 3 == 0 then
			--发给自己
			local intervalW = 52 + 20 - 17  --每张牌的间距
			local allCardsW = 16 * intervalW +  TableConfig.cardWidth
			local CardsLeftX = (TableConfig.TableDefaultWidth - allCardsW) / 2

			--			local move = CCMoveTo:create(DealTime, ccp((math.floor(DealIndex / 3) - 1) * intervalW + CardsLeftX , TableConfig.BottomH + TableConfig.cardHeight))
			local delay = CCDelayTime:create(DealTime)
			local arr = CCArray:create()
			arr:addObject(delay)
			arr:addObject(CCCallFuncN:create(hideDeal))
			arr:addObject(CCCallFuncN:create(setoutDeal))
			local seq = CCSequence:create(arr)
			ShuffleList[DealIndex].m_CardSprite:runAction(seq)
		elseif  DealIndex % 3 == 1 then
			--发给下家
			--			local move = CCMoveTo:create(DealTime, ccp(TableConfig.TableCardsPos[2][1], TableConfig.TableCardsPos[2][2] - 50))
			local delay = CCDelayTime:create(DealTime)
			local arr = CCArray:create()
			arr:addObject(delay)
			arr:addObject(CCCallFuncN:create(hideDeal))
			arr:addObject(CCCallFuncN:create(setoutDeal))
			local seq = CCSequence:create(arr)
			ShuffleList[DealIndex].m_CardSprite:runAction(seq)

			if (TableConsole.mnTableType == TableConsole.TABLE_TYPE_HAPPY or TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT) then
				showOpenCards(1)
			end
		elseif  DealIndex % 3 == 2 then
			--发给上家
			--			local move = CCMoveTo:create(DealTime, ccp(TableConfig.TableCardsPos[3][1], TableConfig.TableCardsPos[3][2] - 50))
			local delay = CCDelayTime:create(DealTime)
			local arr = CCArray:create()
			arr:addObject(delay)
			arr:addObject(CCCallFuncN:create(hideDeal))
			arr:addObject(CCCallFuncN:create(setoutDeal))
			local seq = CCSequence:create(arr)
			ShuffleList[DealIndex].m_CardSprite:runAction(seq)
			if (TableConsole.mnTableType == TableConsole.TABLE_TYPE_HAPPY or TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT) then
				showOpenCards(2)
			end
		end
	end
end

function TableDealCards()
	--初始化牌堆
	isDealEnd = false
	for i = 1, 54 do
		local card = TableCard:new(0, FACE_BACK, false)
		card.m_CardSprite:setScale(0.5)
		local nextX = math.random(-5, 5);
		local nextY = math.random(-5, 5);
		local nextAngle = math.random(-20, 20)
		local cardX = TableConfig.TableDefaultWidth / 2 + nextX
		local cardY = TableConfig.TableDefaultHeight / 2 + 70 + nextY
		card.m_CardSprite:setAnchorPoint(ccp(0.5, 0.5));
		card.m_CardSprite:setRotation(nextAngle)
		card.m_CardSprite:setPosition(cardX, cardY)
		card.m_CardSprite:setZOrder(55 - i)
		table.insert(ShuffleList, card)
		CardBatchNode:addChild(card.m_CardSprite)
		ShuffleList[i].m_CardSprite:setVisible(false)
	end
	DealIndex = 0;
	OpenInitCard = 1
	setoutDeal()
	AudioManager.playLordSound(AudioManager.TableSound.FAPAI, true, -1)
	--	for i = 1, #ShuffleList do
	--		local moveX = math.random(-20, 20)
	--		local moveY = math.random(-5, 5)
	--		local move1 = CCMoveBy:create(0.2,ccp(moveX,moveY))
	--		local move2 = CCMoveBy:create(0.2,ccp(-moveX*2,-moveY*2))
	--		local move3 = CCMoveBy:create(0.2,ccp(moveX*2,moveY*2))
	--		local move4 = CCMoveBy:create(0.2,ccp(-moveX,-moveY))
	--		local arr = CCArray:create()
	--		arr:addObject(move1)
	--		arr:addObject(move2)
	--		arr:addObject(move3)
	--		arr:addObject(move4)
	--		if i == #ShuffleList then
	--			arr:addObject(CCCallFuncN:create(setoutDeal))
	--		end
	--		local seq = CCSequence:create(arr)
	--		ShuffleList[i].m_CardSprite:runAction(seq)
	--	end
end

--[[--
--显示正面
--]]
function showCardFront(sender)
	sender:showFront()
end

--[[--
--特殊底牌回调
--]]
local function ReserveCardCallback()
	if TableConsole.msReservedCardName ~= nil then
		Common.showToast("底牌特殊牌型," .. TableConsole.msReservedCardName .. "x" .. TableConsole.mnReservedCardTimes .. "倍", 2);
	end
end

--[[--
--翻开牌(逐张翻开)
--@param #number Index 从第几张牌开始翻开
--]]
function turnReserveCard(Index)
	if Index ~= nil and type(Index) == "number" then
		ReserveCardIndex = Index;
	end
	if ReservedCards ~= nil then
		if ReserveCardIndex <= #ReservedCards then
			--翻牌动画
			local cardSprite = ReservedCards[#ReservedCards - ReserveCardIndex + 1].m_CardSprite
			local array = CCArray:create()
			array:addObject(CCScaleTo:create(0.3,0,cardSprite:getScaleY()))
			array:addObject(CCCallFuncN:create(showCardFront))
			array:addObject(CCScaleTo:create(0.3,cardSprite:getScaleX(),cardSprite:getScaleY()))
			array:addObject(CCCallFuncN:create(turnReserveCard))
			cardSprite:runAction(CCSequence:create(array))
			ReserveCardIndex = ReserveCardIndex + 1;
		else
			--翻牌后的加倍动画
			if TableConsole.mnReservedCardTimes ~= nil and TableConsole.msReservedCardName ~= nil then
				if TableConsole.mnReservedCardTimes > 1 then
					ReserveCardMultiple = CCMenuItemImage:create(Common.getResourcePath("reservedcard_".. TableConsole.mnReservedCardTimes ..".png"), Common.getResourcePath("reservedcard_".. TableConsole.mnReservedCardTimes ..".png"));
					ReserveCardMultiple:setScale(10);
					--TODO
					ReserveCardMultiple:registerScriptTapHandler(ReserveCardCallback)
					local scaleAction =  CCScaleTo:create(0.25, 1);
					local ease = CCEaseOut:create(scaleAction, 0.8);
					local array = CCArray:create();
					array:addObject(ease);
					local seq = CCSequence:create(array);
					ReserveCardMultiple:runAction(seq);
					local menu = CCMenu:createWithItem(ReserveCardMultiple)

					--menu:setPosition(3 * 25, TableConfig.TableDefaultHeight - 60)
					local positionX = TableLogic.Panel_Top_Button:getPosition().x+TableLogic.Panel_Top_Button:getContentSize().width/2+14
					Common.log("底牌加倍图片PositionX:"..positionX)
					if TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT then
						menu:setPosition(positionX - 50, TableConfig.TableDefaultHeight - 45)
					else
						menu:setPosition(positionX, TableConfig.TableDefaultHeight - 45)
					end
					--CardLayer:addChild(menu);
					menu:setZOrder(10)
					dipaiBgLayer:addChild(menu);
				end
			end
		end
	end
end

--[[--
--隐藏老虎机动画后的癞子牌
--]]
local function removeLaiZiCard(sender)
	CardBatchNode:removeChild(sender,true)
	TableConsole.setGameBeginBtn(TableConsole.isShowLaiZiAnim_LordSeat)
	--牌桌软引导动画 癞子提示
	--	TableConsole.softGuideTable = Common.LoadTable(TableConsole.softGuideTableText)
	if TableConsole.softGuideTable == nil then
		TableElementLayer.showSoftGuideOmniPotentTips()
		TableConsole.softGuideTable = {}
		TableConsole.softGuideTable[profile.User.getSelfUserID() .. ""] = {}
		TableConsole.softGuideTable[profile.User.getSelfUserID() .. ""].omni = true
		Common.SaveTable(TableConsole.softGuideTableText,TableConsole.softGuideTable)
	elseif TableConsole.softGuideTable[profile.User.getSelfUserID() .. ""] == nil then
		TableElementLayer.showSoftGuideOmniPotentTips()
		TableConsole.softGuideTable[profile.User.getSelfUserID() .. ""] = {}
		TableConsole.softGuideTable[profile.User.getSelfUserID() .. ""].omni = true
		Common.SaveTable(TableConsole.softGuideTableText,TableConsole.softGuideTable)
	elseif TableConsole.softGuideTable[profile.User.getSelfUserID() .. ""].omni == nil then
		TableElementLayer.showSoftGuideOmniPotentTips()
		TableConsole.softGuideTable[profile.User.getSelfUserID() .. ""].omni = true
		Common.SaveTable(TableConsole.softGuideTableText,TableConsole.softGuideTable)
	end
end

--[[--
--显示老虎机动画后的癞子牌
--]]
function showLaiZiCard(LaiziCardVal)
	local card = TableCard:new(LaiziCardVal, FACE_FRONT, false)
	--	card.m_CardSprite:setScale(0.5)
	card.m_CardSprite:setAnchorPoint(ccp(0.5, 0.5));
	card.m_CardSprite:setPosition(TableConfig.TableDefaultWidth/2, TableConfig.TableDefaultHeight/2)
	CardBatchNode:addChild(card.m_CardSprite)

	local delay = CCDelayTime:create(1)
	local scale = CCScaleTo:create(0.4,0.4)
	local moveTo = CCMoveTo:create(0.4,ccp(3 *35 + TableLogic.Panel_Top_Button:getPosition().x+TableLogic.Panel_Top_Button:getContentSize().width/2.4 + 50, TableConfig.TableDefaultHeight - 50))
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCSpawn:createWithTwoActions(moveTo,scale))
	array:addObject(CCCallFuncN:create(removeLaiZiCard))
	local seq = CCSequence:create(array)
	card.m_CardSprite:runAction(seq)

	for i = 1,#ReservedCards do
		local positionX = ReservedCards[i].m_CardSprite:getPositionX()
		local positionY = ReservedCards[i].m_CardSprite:getPositionY()
		local delay = CCDelayTime:create(1.2)
		local moveTo = CCMoveTo:create(0.2,ccp((i - 1) * ReservedCards[i].m_CardSprite:getContentSize().width/2.2 + TableLogic.Panel_Top_Button:getPosition().x+TableLogic.Panel_Top_Button:getContentSize().width/2.8, TableConfig.TableDefaultHeight - 37))
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(moveTo)
		local seq = CCSequence:create(array)
		ReservedCards[i].m_CardSprite:runAction(seq)
	end
end


--[[--
--添加剩余的牌(直接加入layer中)
--@param #table cards 明牌牌值table
--@param #number SeatID 玩家座位号
--]]
function addRemainCards(cardsVal, SeatID)
	local pos = TableConsole.getPlayerPosBySeat(SeatID)
	RemainCards[pos + 1] = {}
	local cardNum = 0;
	local lineIndex = 0;
	local OffX = 0
	if pos == 1 then
		OffX = -320
	else
		OffX = 70
	end
	for i = 1, #cardsVal do
		local card = TableCard:new(cardsVal[i], FACE_FRONT, false)
		table.insert(RemainCards[pos + 1], card)
	end
	TableCardManage.SortCardVal(RemainCards[pos + 1], TableCardManage.SORT_MODE_WHAT)
	for i = 1 , #RemainCards[pos + 1] do
		cardNum = cardNum + 1;
		RemainCards[pos + 1][i].m_CardSprite:setScale(0.5)
		local cardX = TableConfig.TableCardsPos[pos + 1][1] + OffX + (i - 1) * 25
		local cardY = TableConfig.TableCardsPos[pos + 1][2]
		if cardNum > 10 then
			if cardNum == 11 then
				lineIndex = i
			end
			cardX = TableConfig.TableCardsPos[pos + 1][1] + OffX + (i - lineIndex) * 25
			cardY = TableConfig.TableCardsPos[pos + 1][2] - 50
		end
		RemainCards[pos + 1][i].m_CardSprite:setPosition(cardX, cardY)
		CardBatchNode:addChild(RemainCards[pos + 1][i].m_CardSprite)
	end
end

--[[--
--删除所有的剩余牌
--]]
function removeAllRemainCards()
	if RemainCards ~= nil then
		for i = 1, table.maxn(RemainCards) do
			if RemainCards[i] ~= nil then
				for j = 1, #RemainCards[i] do
					CardBatchNode:removeChild(RemainCards[i][j].m_CardSprite,true)
				end
			end
		end
		RemainCards = {}
	end
end


--[[--
--添加明牌(需要多次刷新，所以先加入layer中)
--@param #table cards 明牌牌值table
--@param #number SeatID 玩家座位号
--]]
function addOpenCards(cardsVal, SeatID)
	Common.log("addOpenCards SeatID = "..SeatID)
	local pos = TableConsole.getPlayerPosBySeat(SeatID)
	if cardsVal ~= nil then
		if pos == 1 then
			--位置1
			for i = 1, #cardsVal do
				local card = TableCard:new(cardsVal[i], FACE_FRONT, false)
				table.insert(playerCardVal_1, card)
				playerCardVal_1[i].m_CardSprite:setVisible(false);
				CardBatchNode:addChild(card.m_CardSprite)
			end
		elseif pos == 2 then
			--位置2
			for i = 1, #cardsVal do
				local card = TableCard:new(cardsVal[i], FACE_FRONT, false)
				table.insert(playerCardVal_2, card)
				playerCardVal_2[i].m_CardSprite:setVisible(false);
				CardBatchNode:addChild(card.m_CardSprite)
			end
		end
	end
end

--[[--
--显示明牌
--]]
function showOpenCards(pos)
	Common.log("showOpenCards pos = "..pos)

	if pos == 1 then
		--位置1
		if playerCardVal_1 ~= nil then
			for i = 1,  table.maxn(playerCardVal_1) do
				if (DealIndex > 0 and i <= DealIndex / 3) or TableConsole.m_nGameStatus > TableConsole.STAT_SETOUT then
					if playerCardVal_1[i] ~= nil then
						playerCardVal_1[i].m_CardSprite:setVisible(true);
					end
				end
			end
		end
	elseif pos == 2 then
		--位置2
		if playerCardVal_2 ~= nil then
			for i = 1,  table.maxn(playerCardVal_2) do
				if (DealIndex > 0 and i <= DealIndex / 3) or TableConsole.m_nGameStatus > TableConsole.STAT_SETOUT then
					if playerCardVal_2[i] ~= nil then
						playerCardVal_2[i].m_CardSprite:setVisible(true);
					end
				end
			end
		end
	end
end

--[[--
--癞子场中，刷新明牌牌值，并重新排序
--]]
function refreshOpenCardsValForLaizi(SeatID)
	local pos = TableConsole.getPlayerPosBySeat(SeatID)
	if pos == 1 then
		if playerCardVal_1 ~= nil then
			for i = 1, table.maxn(playerCardVal_1) do
				if playerCardVal_1[i] ~= nil then
					playerCardVal_1[i]:setValue(playerCardVal_1[i].m_nValue)
				end
			end
		end
	elseif pos == 2 then
		if playerCardVal_2 ~= nil then
			for i = 1, table.maxn(playerCardVal_2) do
				if playerCardVal_2[i] ~= nil then
					playerCardVal_2[i]:setValue(playerCardVal_2[i].m_nValue)
				end
			end
		end
	end
	refreshOpenCardsBySeat(SeatID)
end


--[[--
--刷新明牌
--]]
function refreshOpenCardsBySeat(SeatID)
	local pos = TableConsole.getPlayerPosBySeat(SeatID)
	if pos == 1 then
		--位置1
		if playerCardVal_1 ~= nil then
			TableCardManage.SortCardVal(playerCardVal_1, TableCardManage.SORT_MODE_WHAT)
			local cardNum = 0;
			local lineIndex = 0;
			for i = 1,  table.maxn(playerCardVal_1) do
				if playerCardVal_1[i] ~= nil then
					cardNum = cardNum + 1
					playerCardVal_1[i].m_CardSprite:setScale(0.3)
					local cardX = TableConfig.TableCardsPos[pos + 1][1] - 300 + (i - 1) * 25
					local cardY = TableConfig.TableCardsPos[pos + 1][2] + 90
					if cardNum > 10 then
						if cardNum == 11 then
							lineIndex = i
						end
						cardX = TableConfig.TableCardsPos[pos + 1][1] - 300 + (i - lineIndex) * 25
						cardY = TableConfig.TableCardsPos[pos + 1][2] + 90 - 50
					end
					playerCardVal_1[i].m_CardSprite:setPosition(cardX, cardY)
					playerCardVal_1[i].m_CardSprite:setZOrder(i)
				end
			end
		end
	elseif pos == 2 then
		--位置2
		if playerCardVal_2 ~= nil then
			TableCardManage.SortCardVal(playerCardVal_2, TableCardManage.SORT_MODE_WHAT)
			local cardNum = 0;
			local lineIndex = 0;
			for i = 1,  table.maxn(playerCardVal_2) do
				if playerCardVal_2[i] ~= nil then
					cardNum = cardNum + 1
					playerCardVal_2[i].m_CardSprite:setScale(0.3)
					local cardX = TableConfig.TableCardsPos[pos + 1][1] + 50 + (i - 1) * 25
					local cardY = TableConfig.TableCardsPos[pos + 1][2] + 90
					if cardNum > 10 then
						if cardNum == 11 then
							lineIndex = i
						end
						cardX = TableConfig.TableCardsPos[pos + 1][1] + 50 + (i - lineIndex) * 25
						cardY = TableConfig.TableCardsPos[pos + 1][2] + 90 - 50
					end
					playerCardVal_2[i].m_CardSprite:setPosition(cardX, cardY)
					playerCardVal_2[i].m_CardSprite:setZOrder(i)
				end
			end
		end
	end
	showOpenCards(pos);
end

--[[--
--删除明牌
--@param #table TakeOutCards 出的牌值
--@param #number SeatID 自己的座位号
--]]
function removeOpenCardsBySeat(TakeOutCardsData, SeatID)
	if TakeOutCardsData ~= nil then

		local pos = TableConsole.getPlayerPosBySeat(SeatID)
		if pos == 1 then
			--位置1
			if playerCardVal_1 ~= nil then
				local Index = 1
				while Index <= table.maxn(playerCardVal_1) do
					if playerCardVal_1[Index] ~= nil then
						local isHave = false
						for j = 1 , #TakeOutCardsData do
							if playerCardVal_1[Index].m_nValue == TakeOutCardsData[j].mnTheOriginalValue then
								CardBatchNode:removeChild(playerCardVal_1[Index].m_CardSprite,true)
								table.remove(playerCardVal_1, Index)
								isHave = true
								break;
							end
						end
						if not isHave then
							Index = Index + 1
						end
					end
				end
			end
		elseif pos == 2 then
			--位置2
			if playerCardVal_2 ~= nil then
				local Index = 1
				while Index <= table.maxn(playerCardVal_2) do
					if playerCardVal_2[Index] ~= nil then
						local isHave = false
						for j = 1 , #TakeOutCardsData do
							if playerCardVal_2[Index].m_nValue == TakeOutCardsData[j].mnTheOriginalValue then
								CardBatchNode:removeChild(playerCardVal_2[Index].m_CardSprite,true)
								table.remove(playerCardVal_2, Index)
								isHave = true
								break;
							end
						end
						if not isHave then
							Index = Index + 1
						end
					end
				end
			end
		end
	end
end

--[[--
--删除所有明牌
--]]
function removeAllOpenCards()
	if playerCardVal_1 ~= nil then
		for i = 1,  table.maxn(playerCardVal_1) do
			if playerCardVal_1[i] ~= nil then
				CardBatchNode:removeChild(playerCardVal_1[i].m_CardSprite,true)
			end
		end
		playerCardVal_1 = {}
	end
	if playerCardVal_2 ~= nil then
		for i = 1,  table.maxn(playerCardVal_2) do
			if playerCardVal_2[i] ~= nil then
				CardBatchNode:removeChild(playerCardVal_2[i].m_CardSprite,true)
			end
		end
		playerCardVal_2 = {}
	end
end

--[[--
--获取自己的手牌
--]]
function getSelfCards()
	return SelfCards
end

--[[--
--得到手牌数量
--]]
function getHandCardsCnt()
	local CardsCnt = 0
	if SelfCards ~= nil then
		CardsCnt = #SelfCards
	end
	return CardsCnt
end


--[[--
--添加自己的手牌(需要多次刷新，所以先加入layer中)
--@table cards card 纸牌牌值
--@param #boolean isVisible 是否隐藏
--]]
function addHandCard(cardsVal, isVisible)
	if cardsVal ~= nil then
		for i = 1, #cardsVal do
			local card = TableCard:new(cardsVal[i], FACE_FRONT, true)
			--发牌消息添加手牌,设置成不显示，发牌动画后显示
			card.m_CardSprite:setVisible(isVisible)
			table.insert(SelfCards, card)
			CardBatchNode:addChild(card.m_CardSprite)
		end
	end
end

local allCardsW = 0 --所有牌的总宽度
local CardsLeftX = 0 --绘制牌的左侧起点位置

--[[--
--获取所有牌的总宽度
--]]
function getAllCardsW()
	return allCardsW
end
--[[--
--获取绘制牌的左侧起点位置
--]]
function getCardsLeftX()
	return CardsLeftX
end

--[[--
--癞子场中，刷新手牌牌值，并重新排序
--]]
function refreshHandCardsValForLaizi()
	for i = 1, table.maxn(SelfCards) do
		if SelfCards[i] ~= nil then
			SelfCards[i]:setValue(SelfCards[i].m_nValue);
		end
	end
	refreshHandCards();
	if TableConsole.getPlayer(TableConsole.getSelfSeat()).m_bTrustPlay then
		setAllHandCardsMarked(true);
	end
end

--[[--
--刷新手牌
--]]
function refreshHandCards()
	if SelfCards ~= nil then

		TableCardManage.SortCardVal(SelfCards, TableCardManage.SORT_MODE_WHAT)

		local intervalW = 52 + 20 - getHandCardsCnt()  --每张牌的间距
		allCardsW = (getHandCardsCnt() - 1) * intervalW +  TableConfig.cardWidth
		CardsLeftX = (TableConfig.TableDefaultWidth - allCardsW) / 2
		Common.log("refreshHandCards+1")

		for i = 1, table.maxn(SelfCards) do
			if SelfCards[i] ~= nil then
				SelfCards[i].m_CardSprite:setPosition((i - 1) * intervalW + CardsLeftX, TableConfig.BottomH + TableConfig.cardHeight)
				--计算每张牌的显示区域
				if i ==  table.maxn(SelfCards) then
					--最后一张牌的显示区域为整张牌
					SelfCards[i]:setScreenXYLT((i - 1) * intervalW + CardsLeftX, TableConfig.BottomH + TableConfig.cardHeight)
					SelfCards[i]:setScreenXYRB((i - 1) * intervalW + CardsLeftX + TableConfig.cardWidth, TableConfig.BottomH + TableConfig.cardHeight - TableConfig.cardHeight)
					--设置明牌标志
					setMingpaiFlagSprite(SelfCards[i].m_CardSprite)
				else
					SelfCards[i]:setScreenXYLT((i - 1) * intervalW + CardsLeftX, TableConfig.BottomH + TableConfig.cardHeight)
					SelfCards[i]:setScreenXYRB((i - 1) * intervalW + CardsLeftX + intervalW, TableConfig.BottomH + TableConfig.cardHeight - TableConfig.cardHeight)
				end
				SelfCards[i].m_CardSprite:setZOrder(i)
			end
		end

		TableCardManage.initData(SelfCards);
	end
end

--[[
根据最后一张手牌，设置明牌标志
cardSprite:最后一张手牌的sprite
]]
function setMingpaiFlagSprite(cardSprite)
	local cardVisible = cardSprite:isVisible()
	if TableConsole.m_bSelfDidMingpai == true and cardVisible == true then
		Common.log("添加明牌标志")
		if mingpaiFlag == nil then
			mingpaiFlag = CCSprite:create(Common.getResourcePath("ui_desk_mingpai.png"))
			mingpaiFlag:setPosition(cardSprite:getPositionX()+80, cardSprite:getPositionY()-50);
			CardLayer:addChild(mingpaiFlag)
		else
			mingpaiFlag:setPosition(cardSprite:getPositionX()+80, cardSprite:getPositionY()-50);
		end
	end
end

--[[
移除明牌标志
]]
function removeMingpaiFlagSprite()
	if mingpaiFlag ~= nil then
		mingpaiFlag:removeFromParentAndCleanup(true)
		mingpaiFlag = nil
		TableConsole.m_bSelfDidMingpai = false
	end
end

--[[--
--删除自己的手牌
--@param table TakeOutCards 牌值
--]]
function removeHandCard(TakeOutCards)
	if SelfCards ~= nil then
		local Index = 1
		while Index <= table.maxn(SelfCards) do
			if SelfCards[Index] ~= nil then
				local isHave = false
				for j = 1 , #TakeOutCards do
					if SelfCards[Index].m_nValue == TakeOutCards[j] then
						CardBatchNode:removeChild(SelfCards[Index].m_CardSprite,true)
						table.remove(SelfCards, Index)
						isHave = true
						break;
					end
				end
				if not isHave then
					Index = Index + 1
				end
			end
		end
	end

	--有key值元素时使用这种方法删除
	--	local data = {10,20,30,50,60,70,one="one"}
	--	local test = {20,30,40}
	--	local temp = {}
	--	for key, var in pairs(data) do
	--		local isHave = false
	--		for key1, var1 in pairs(test) do
	--			if var == var1 then
	--				isHave = true
	--				break
	--			end
	--		end
	--		if not isHave then
	--			if type(key)== "number" then
	--				table.insert(temp, var)
	--			else
	--				temp[key] = var
	--			end
	--		end
	--	end
	--	data = temp

end

--[[--
--删除自己所有的手牌
--]]
function removeAllHandCards()
	if SelfCards ~= nil then
		for i = 1, table.maxn(SelfCards) do
			if SelfCards[i] ~= nil then
				CardBatchNode:removeChild(SelfCards[i].m_CardSprite, true)
			end
		end
		SelfCards = {}
	end
end

--[[--
--取消选中的手牌
--]]
function unSelectAllHandCards()
	Common.log("unSelectAllHandCards")
	Common.log("SelfCards cnt = "..#SelfCards)
	for i = 1 ,table.maxn(SelfCards) do
		if SelfCards[i] ~= nil and SelfCards[i].m_bSelected then
			SelfCards[i]:setSelected(false);
			SelfCards[i]:setTouchMarked(false);

			--[[设置明牌标志的位置
			if i == table.maxn(SelfCards) then
				Common.log("setMingpaiFlagSprite")
				setMingpaiFlagSprite(SelfCards[i].m_CardSprite)
			end
			]]
		end

		--设置明牌标志的位置
		if i == table.maxn(SelfCards) then
			Common.log("setMingpaiFlagSprite")
			setMingpaiFlagSprite(SelfCards[i].m_CardSprite)
		end
	end
end

--[[--
--设置所有手牌是否不可选
--]]
function setAllHandCardsMarked(isMarked)
	for i = 1 ,table.maxn(SelfCards) do
		if SelfCards[i] ~= nil then
			SelfCards[i]:setSelected(false);
			SelfCards[i]:setTouchMarked(isMarked);
		end
	end
end

--[[--
--获取所有手牌是否可选
--]]
function getAllHandCardsIsMarked()
	local isSelected = false;
	for i = 1 ,table.maxn(SelfCards) do
		if SelfCards[i] ~= nil and not SelfCards[i]:IsTouchMarked() then
			--如有一张牌没有被标记不可选，则返回可选
			isSelected = true;
			break;
		end
	end
	return isSelected;
end

--[[--
--获取癞子底牌
--]]
function getLaiZiReservedCards()
	return mLaiZiCard
end

--[[--
--添加癞子底牌
--]]
function setLaiZiReservedCard(CardVal)
	if CardVal >= 0  then
		mLaiZiCard = TableCard:new(CardVal, FACE_FRONT, false)
		mLaiZiCard.m_CardSprite:setAnchorPoint(ccp(0.5, 0.5));
	else
		mLaiZiCard = nil
	end
end

--[[--
--获取底牌
--]]
function getReservedCards()
	return ReservedCards
end

--[[--
--添加底牌
--@param TableCard card 纸牌
--]]
function addReservedCard(card)
	if card ~= nil then
		card.m_CardSprite:setAnchorPoint(ccp(0.5, 0.5));
		table.insert(ReservedCards, card)
		--CardBatchNode:addChild(card.m_CardSprite)
		--TableLogic.iv_beishu:addChild(card.m_CardSprite)
		dipaiBgLayer:addChild(card.m_CardSprite)
		Common.log("addReservedCard")
	end
end

--[[--
--癞子场中，刷新底牌牌值，并重新排序
--]]
function refreshReservedCardsValForLaizi()
	for i = 1, #ReservedCards do
		if ReservedCards[i] ~= nil then
			ReservedCards[i]:setValue(ReservedCards[i].m_nValue)
		end
	end
	refreshReservedCards(false)
end

--[[--
--刷新底牌
--]]
function refreshReservedCards(value)
	Common.log("refreshReservedCards")

	if ReservedCards ~= nil then
		TableCardManage.SortCardVal(ReservedCards, TableCardManage.SORT_MODE_WHAT)
		for i = 1, #ReservedCards do
			if ReservedCards[i] ~= nil then
				ReservedCards[i].m_CardSprite:setScale(0.4)
				--ReservedCards[i].m_CardSprite:setPosition((i - 1) * 25 + TableLogic.Panel_Top_Button:getPosition().x+TableLogic.Panel_Top_Button:getContentSize().width/2.4, TableConfig.TableDefaultHeight - 50)

				--				ReservedCards[i].m_CardSprite:setPosition((i - 1) * ReservedCards[i].m_CardSprite:getContentSize().width/2 + TableLogic.Panel_Top_Button:getPosition().x+TableLogic.Panel_Top_Button:getContentSize().width/2.4, TableConfig.TableDefaultHeight - 50)
				if (TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT) and value ~= nil then
					-- 有癞子底牌时，3张底牌的布局
					ReservedCards[i].m_CardSprite:setPosition((i - 1) * ReservedCards[i].m_CardSprite:getContentSize().width/2.2 + TableLogic.Panel_Top_Button:getPosition().x+TableLogic.Panel_Top_Button:getContentSize().width/2.8, TableConfig.TableDefaultHeight - 37)
				else
					-- 没有癞子底牌时，3张底牌的布局
					ReservedCards[i].m_CardSprite:setPosition((i - 1) * ReservedCards[i].m_CardSprite:getContentSize().width/2 + TableLogic.Panel_Top_Button:getPosition().x+TableLogic.Panel_Top_Button:getContentSize().width/2.4, TableConfig.TableDefaultHeight - 37)
				end

				ReservedCards[i].m_CardSprite:setZOrder(i)
			end
		end
	end
	if (TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT) then
		--添加
		if mLaiZiCard ~= nil then
			mLaiZiCard.m_CardSprite:setScale(0.4)
			mLaiZiCard.m_CardSprite:setPosition(3 *35 + TableLogic.Panel_Top_Button:getPosition().x+TableLogic.Panel_Top_Button:getContentSize().width/2.4 + 50, TableConfig.TableDefaultHeight - 37)
			--CardBatchNode:addChild(mLaiZiCard.m_CardSprite)
			dipaiBgLayer:addChild(mLaiZiCard.m_CardSprite)
		end
	end
end

--[[
显示底牌
]]
function showReservedCards()
	if ReservedCards ~= nil then
		TableCardManage.SortCardVal(ReservedCards, TableCardManage.SORT_MODE_WHAT)
		for i = 1, #ReservedCards do
			if ReservedCards[i] ~= nil then
				ReservedCards[i].m_CardSprite:setVisible(true)
			end
		end
	end
	if (TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT) then
		--添加
		if mLaiZiCard ~= nil then
			mLaiZiCard.m_CardSprite:setVisible(true)
		end
	end
end

--[[
隐藏底牌
]]
function hideReservedCards()
	if ReservedCards ~= nil then
		TableCardManage.SortCardVal(ReservedCards, TableCardManage.SORT_MODE_WHAT)
		for i = 1, #ReservedCards do
			if ReservedCards[i] ~= nil then
				ReservedCards[i].m_CardSprite:setVisible(false)
			end
		end
	end

	if ReserveCardMultiple ~= nil then
		ReserveCardMultiple:setVisible(false);
	end

	if (TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT) then
		--添加
		if mLaiZiCard ~= nil then
			mLaiZiCard.m_CardSprite:setVisible(false)
		end
	end
end

--[[--
--删除底牌
--]]
function removeAllReservedCards()
	if ReservedCards ~= nil then
		for i = 1, table.maxn(ReservedCards) do
			if ReservedCards[i] ~= nil then
				dipaiBgLayer:removeChild(ReservedCards[i].m_CardSprite,true)
			end
		end
		ReservedCards = {}
	end
end

--[[--
--判断是否有用户出完牌
--]]
function getPlayerCardsIsGone()
	local isGone = false;
	for i = 1 , TableConsole.getPlayerCnt() do
		local SeatID = TableConsole.getPlayerSeatByPos(i - 1)
		if TableConsole.getPlayer(SeatID).m_nCardCnt == 0  then
			isGone = true;
			break;
		end
	end
	return isGone;
end

--[[--
--获取牌桌上的牌
--]]
function getPlayerTableCards()
	return m_aPlayerTableCards
end

--[[--
--是否是新回合
--]]
function getIsNewBout(nowSeat)
	local isNewBout = true;
	local nSeat = nowSeat;
	for i = 1, 2 do
		nSeat = (nSeat - 1 + 3) % 3;-- 找到nPlayer的上家
		local nPos = TableConsole.getPlayerPosBySeat(nSeat)
		if (m_aPlayerTableCards[nPos + 1] ~= nil and
			#m_aPlayerTableCards[nPos + 1] > 0) then
			isNewBout = false;
			break;
		end
	end
	return isNewBout;
end

--[[--
--删除所有牌桌上出的牌
--]]
function removeAllTableCards()
	if m_aPlayerTableCards ~= nil  then
		for i = 1, #m_aPlayerTableCards do
			if m_aPlayerTableCards[i] ~= nil then
				for j = 1, #m_aPlayerTableCards[i] do
					if m_aPlayerTableCards[i][j] ~= nil then
						CardBatchNode:removeChild(m_aPlayerTableCards[i][j].m_CardSprite,true)
					end
				end
			end
		end
		m_aPlayerTableCards = {}
	end

	--移除明牌标志
	TableCardLayer.removeMingpaiFlagSprite()
end

--[[--
--根据座位号清空牌桌上出的牌
--]]
function clearTableCardsBySeat(Seat)
	local pos = TableConsole.getPlayerPosBySeat(Seat)
	--删除当前出牌人桌上的牌
	if m_aPlayerTableCards[pos + 1] ~= nil then
		for i = 1, #m_aPlayerTableCards[pos + 1] do
			if m_aPlayerTableCards[pos + 1][i] ~= nil then
				CardBatchNode:removeChild(m_aPlayerTableCards[pos + 1][i].m_CardSprite,true)
			end
		end
	end

	m_aPlayerTableCards[pos + 1] = {}
end

--[[--
--添加牌桌上的牌
--@param table TakeOutCards 牌值value
--@param number SeatID 座位号
--]]
function addTableCard(TakeOutCards, SeatID, notUpdataCardCnt)
	if TakeOutCards ~= nil then

		local pos = TableConsole.getPlayerPosBySeat(SeatID)
		--删除当前出牌人桌上的牌
		if m_aPlayerTableCards[pos + 1] ~= nil then
			for i = 1, #m_aPlayerTableCards[pos + 1] do
				if m_aPlayerTableCards[pos + 1][i] ~= nil then
					CardBatchNode:removeChild(m_aPlayerTableCards[pos + 1][i].m_CardSprite,true)
				end
			end
		end

		if notUpdataCardCnt == nil then
			TableConsole.getPlayer(SeatID).m_nCardCnt = TableConsole.getPlayer(SeatID).m_nCardCnt - #TakeOutCards
			--通过手牌数是否为0来判断牌局是否结束
			BindPhoneLogic.stopShowHallGift()
			TableElementLayer.updataUserCardCnt()
		end

		m_aPlayerTableCards[pos + 1] = {}
		for i = 1, #TakeOutCards do
			local card = TableCard:new(TakeOutCards[i].mnTheEndValue, FACE_FRONT, false)
			card.mbLaiZi = TakeOutCards[i].mbIsLaiZi
			card.m_CardSprite.setValue(card.m_nColor, card.m_nWhat, TakeOutCards[i].mbIsLaiZi)
			card.m_CardSprite:setAnchorPoint(ccp(0.5, 0.5));
			table.insert(m_aPlayerTableCards[pos + 1], card)
		end
		--		if #TakeOutCards > 0 then
		--			local cardType = TableCardManage.GetCardType(m_aPlayerTableCards[pos + 1])
		--
		--			Common.log("牌型 ==== "..TableCardManage.CARD_TYPE[cardType + 1])
		--		end

	end
end

local CardAngle = 14;--旋转间隔角度
local CardRadius = 90;--扇形半径
--[[--
--获取每张牌的旋转角度
--@param #number pos 显示位置
--@param #number index 第几张牌
--@param #number cardsNum 总牌数
--]]
local function getCardsAngle(pos, index, cardsNum)
	local angle = 0;
	if cardsNum % 2 == 0 then
		--偶数
		local middleLeft = cardsNum / 2
		local middleRight = cardsNum / 2 + 1
		if index == middleLeft then
			angle = - CardAngle / 2
		elseif index == middleRight then
			angle = CardAngle / 2
		elseif index < middleLeft then
			angle = - CardAngle / 2 - CardAngle * (middleLeft - index)
		elseif index > middleRight then
			angle = CardAngle / 2 + CardAngle * (index - middleRight)
		end
	else
		--奇数
		local middle = math.modf(cardsNum / 2) + 1
		if index == middle then
			angle = 0
		elseif index > middle then
			angle = CardAngle * (index - middle)
		elseif index < middle then
			angle = - CardAngle * (middle - index)
		end
	end
	if pos == 1 then
	--自己
	elseif pos == 2 then
		--下家
		angle = angle - 90
	elseif pos == 3 then
		--上家
		angle = angle + 90
	end
	return angle;
end

--[[--
--刷新牌桌上指定位置的牌
--]]
function refreshTableCardsBySeat(SeatID)
	if m_aPlayerTableCards ~= nil  then
		local pos = TableConsole.getPlayerPosBySeat(SeatID)
		if m_aPlayerTableCards[pos + 1] ~= nil then
			TableCardManage.SortCardVal(m_aPlayerTableCards[pos + 1], TableCardManage.SORT_MODE_SAMECOUNT)
			for j = 1, #m_aPlayerTableCards[pos + 1] do
				if m_aPlayerTableCards[pos + 1][j] ~= nil then
					m_aPlayerTableCards[pos + 1][j].m_CardSprite:setScale(0.6)
					local angle = getCardsAngle(pos + 1, j, #m_aPlayerTableCards[pos + 1])
					local cardX = TableConfig.TableCardsPos[pos + 1][1] + CardRadius * math.sin(math.rad(angle))
					local cardY = TableConfig.TableCardsPos[pos + 1][2] - (CardRadius - CardRadius * math.cos(math.rad(angle)))
					m_aPlayerTableCards[pos + 1][j].m_CardSprite:setRotation(angle)
					m_aPlayerTableCards[pos + 1][j].m_CardSprite:setPosition(cardX, cardY)
					m_aPlayerTableCards[pos + 1][j].m_CardSprite:setZOrder(j + 50)
					CardBatchNode:addChild(m_aPlayerTableCards[pos + 1][j].m_CardSprite)
				end
			end
		end
	end
end


--[[--
--刷新牌桌上所有的牌
--]]
function refreshAllTableCards()
	if m_aPlayerTableCards ~= nil  then
		for i = 1, #m_aPlayerTableCards do
			if m_aPlayerTableCards[i] ~= nil then
				TableCardManage.SortCardVal(m_aPlayerTableCards[i], TableCardManage.SORT_MODE_SAMECOUNT)
				for j = 1, #m_aPlayerTableCards[i] do
					if m_aPlayerTableCards[i][j] ~= nil then
						m_aPlayerTableCards[i][j].m_CardSprite:setScale(0.6)
						local angle = getCardsAngle(i, j, #m_aPlayerTableCards[i])
						local cardX = TableConfig.TableCardsPos[i][1] + CardRadius * math.sin(math.rad(angle))
						local cardY = TableConfig.TableCardsPos[i][2] - (CardRadius - CardRadius * math.cos(math.rad(angle)))
						m_aPlayerTableCards[i][j].m_CardSprite:setRotation(angle)
						m_aPlayerTableCards[i][j].m_CardSprite:setPosition(cardX, cardY)
						CardBatchNode:addChild(m_aPlayerTableCards[i][j].m_CardSprite)
					end
				end
			end
		end
	end
end

local cardsSelect = {}

function getCardsSelectTable()
	return cardsSelect;
end

function getThenOneCardsSelect()
	local index = 0
	if cardsSelect ~= nil then
		for i = 1, table.maxn(cardsSelect) do
			if cardsSelect[i] ~= nil then
				index = cardsSelect[i].index
				break;
			end
		end
	end
	return index;
end

--[[--
--是否有选中的牌
--]]
function isNotSelectCard()
	local notSelectCard = true;
	for i = 1, table.maxn(SelfCards) do
		if SelfCards[i] ~= nil then
			if (SelfCards[i].m_bSelected) then
				notSelectCard = false;
				break;
			end
		end
	end
	return notSelectCard;
end

--[[--
--取出已经选中的牌
--]]
local function getPopUpCards()
	local anTmp = {};
	for i = 1, table.maxn(SelfCards) do
		if SelfCards[i] ~= nil then
			if (SelfCards[i].m_bSelected) then
				table.insert(anTmp, SelfCards[i]);
			end
		end
	end
	return anTmp;
end

--[[--
--弹出智能选择的牌
--]]
function popupTouchCards(an)
	local nPos = getHandCardsCnt();
	for i = #an,1,-1 do
		for j = nPos,1,-1 do
			if j <= nPos then
				if (an[i] == SelfCards[j].m_nWhat) then
					SelfCards[j]:setSelected(true);
					nPos = j - 1;
					break;
				end
			end
		end
	end
end

--[[--
-- 是否合法出牌
--
-- @return boolean
--]]
function isValidOutCards()
	--	--[[--测试多种癞子牌--]]
	--	TableConsole.mnTableType = TableConsole.TABLE_TYPE_OMNIPOTENT;
	--	TableConsole.mnLaiziCardVal = 1;
	--	--	local handCards = {36,23,10,48,35,22,40,27,14,1}--KKKQQQ4444
	--	local handCards = {48,35,22,1}--QQQ4
	--	--	local handCards = {36,35,40,27,14,1}--KQ4444
	--	TableCardLayer.addHandCard(handCards, true);
	--	for i = 1, table.maxn(SelfCards) do
	--		SelfCards[i].m_bSelected = true;
	--	end

	cardsSelect = {}

	local acSelf = getPopUpCards();
	Common.log("出牌 acSelf ==== "..#acSelf)
	if #acSelf == 0 then
		return false, #acSelf;
	end

	for i = 2, 1, -1 do
		if (m_aPlayerTableCards[i + 1] ~= nil and #m_aPlayerTableCards[i + 1] > 0) then
			--local n = TableCardManage.CompareCard(acSelf, #acSelf, m_aPlayerTableCards[i + 1], #m_aPlayerTableCards[i + 1]);
			local n = TableCardManage.compareCardWithX(acSelf, #acSelf, m_aPlayerTableCards[i + 1], #m_aPlayerTableCards[i + 1]);
			if n > 0 then
				cardsSelect = TableCardManage.rejectRepeatType(acSelf);
			end
			return n > 0, #acSelf;
		end
	end
	-- 如果自己为先手出牌
	--	local cardType = TableCardManage.GetCardType(acSelf);
	local cardType = TableCardManage.getCardTypeWithX(acSelf);
	Common.log("出牌牌型 ==== "..TableCardManage.CARD_TYPE[cardType + 1])
	if (cardType == TableCardManage.TYPE_INVALIDATE) then
		return false, #acSelf;
	else
		cardsSelect = TableCardManage.rejectRepeatType(acSelf);
		return true, #acSelf;
	end
end

--[[--
--判断癞子牌是否有多种变化
--@return
--]]
function isHaveMoreLaiZiVal()
	local num = 0
	if cardsSelect ~= nil then
		for i = 1, table.maxn(cardsSelect) do
			if cardsSelect[i] ~= nil then
				num = num + 1
			end
		end
	end
	if num > 1  then
		return true;
	else
		return false
	end

	--	local isHaveMore = false;
	--	if (TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT) then
	--		for i = 1, table.maxn(SelfCards) do
	--			if (SelfCards[i].m_bSelected) then
	--				if (SelfCards[i].mbLaiZi) then
	--					if (#SelfCards[i].m_LaiziValues > 1) then
	--						isHaveMore = true;
	--						break;
	--					end
	--				end
	--			end
	--		end
	--	end
	--	return isHaveMore;
end

--[[--
* 得到弹出的牌值
*
* @param index
* @return
--]]
function getPopUpCardsVal(index)
	local tackOutVal = {};
	for i = 1, table.maxn(SelfCards) do
		if (SelfCards[i].m_bSelected) then
			local takeoutData = TableTakeOutCard:new()
			if (SelfCards[i].mbLaiZi) then
				takeoutData.mbIsLaiZi = true;
				takeoutData.mnTheOriginalValue = SelfCards[i].m_nValue;
				takeoutData.malLaiZiChangeVal = SelfCards[i].m_LaiziValues;
				if (#takeoutData.malLaiZiChangeVal > 1) then
					if (index >= 1 and index <= #takeoutData.malLaiZiChangeVal) then
						takeoutData.mnTheEndValue = SelfCards[i].m_LaiziValues[index];
					else
						takeoutData.mnTheEndValue = -1;
					end
				else
					takeoutData.mnTheEndValue = SelfCards[i].m_LaiziValues[1];
				end
			else
				takeoutData.mbIsLaiZi = false;
				takeoutData.mnTheOriginalValue = SelfCards[i].m_nValue;
				takeoutData.mnTheEndValue = SelfCards[i].m_nValue;
			end
			table.insert(tackOutVal, takeoutData);
		end
	end
	--	Common.log("tackOutVal ======== "..#tackOutVal);
	--	for i = 1, #tackOutVal do
	--		Common.log("tackOutVal[i].mnTheOriginalValue ======== "..tackOutVal[i].mnTheOriginalValue);
	--		Common.log("tackOutVal[i].mnTheEndValue ======== "..tackOutVal[i].mnTheEndValue);
	--	end
	return tackOutVal;
end

function CardsPrompt()
	-- 提示
	local nSeat = TableConsole.getSelfSeat();
	for i = 1, 2 do
		nSeat = (nSeat - 1 + 3) % 3;-- 找到自己的上家
		local pos = TableConsole.getPlayerPosBySeat(nSeat)
		if (m_aPlayerTableCards[pos + 1] ~= nil and #m_aPlayerTableCards[pos + 1] > 0) then
			unSelectAllHandCards();
			local b = TableCardManage.Search(m_aPlayerTableCards[pos + 1], true);
			if (b) then
				TableLogic.logicTakeoutButtonEnabled();

				--设置明牌标志的位置
				local selfCards = TableCardLayer.getSelfCards()
				for i = 1, table.maxn(selfCards) do
					if selfCards[i] ~= nil then
						if i ==  table.maxn(selfCards) then
							TableCardLayer.setMingpaiFlagSprite(selfCards[i].m_CardSprite)
						end
					end
				end
			else
				-- 直接不出
				TableConsole.pass()
			end
			return;
		end
	end
end

--[[--
--清空牌桌上的牌
--]]
function removeAllCards()
	CardBatchNode:removeAllChildrenWithCleanup(true)
	mLaiZiCard  = nil
	SelfCards = {}--自己的手牌
	OutSelfCards = {}--自己本回合出的牌
	ReservedCards = {} --底牌
	m_aPlayerTableCards = {} --牌桌上的牌
	playerCardVal_1 = {}--玩家位置1的明牌
	playerCardVal_2 = {}--玩家位置2的明牌
	RemainCards = {} --牌桌上剩余的牌
	ShuffleList = {} --洗牌
	cardsSelect = {}
	DealIndex = 0;
	ReserveCardIndex = 0;
	isDealEnd = false;
	mingpaiFlag = nil
end

--[[--
--删除纸牌层
--]]
function reomveAllCardLayer()
	CardBatchNode:removeAllChildrenWithCleanup(true)
	mLaiZiCard  = nil
	SelfCards = {}--自己的手牌
	OutSelfCards = {}--自己本回合出的牌
	ReservedCards = {} --底牌
	m_aPlayerTableCards = {} --牌桌上的牌
	playerCardVal_1 = {}--玩家位置1的明牌
	playerCardVal_2 = {}--玩家位置2的明牌
	RemainCards = {} --牌桌上剩余的牌
	ShuffleList = {} --洗牌
	cardsSelect = {}
	DealIndex = 0;
	ReserveCardIndex = 0;
	if ReserveCardMultiple ~= nil then
		CardLayer:removeChild(ReserveCardMultiple, true);
		ReserveCardMultiple = nil;
	end
	if dipaiBgLayer ~= nil then
		CardLayer:removeChild(dipaiBgLayer, true);
		dipaiBgLayer = nil;
	end

	isDealEnd = false;
	mingpaiFlag = nil;
	CardBatchNode = nil;

	CardLayer:stopAllActions();
	CardLayer:removeFromParentAndCleanup(true);
	CardLayer = nil
end

--地主三张底牌站立2秒提示
function lordReservedCardsTips()
	isShowReservedCards = true
	Common.log("lordReservedCardsTips #SelfCards is " .. #SelfCards)
	for i = 1, #ReservedCards do
		for j = 1, #SelfCards do
			if ReservedCards[i].m_nValue == SelfCards[j].m_nValue then
				Common.log("lordReservedCardsTips #SelfCards j is " .. j)
				local positionX = SelfCards[j].m_CardSprite:getPositionX()
				local positionY = SelfCards[j].m_CardSprite:getPositionY()

				local delay1 = CCDelayTime:create(0.3)
				local moveUp = CCMoveTo:create(0.01,ccp(positionX,positionY + 25))
				local delay = CCDelayTime:create(2)
				local moveDown= CCMoveTo:create(0.2,ccp(positionX,positionY))
				local array = CCArray:create();
				array:addObject(delay1);
				array:addObject(moveUp);
				array:addObject(delay);
				array:addObject(moveDown);
				if j == 3 then
					array:addObject(CCCallFuncN:create(refreshHandCards))
				end

				local seq = CCSequence:create(array);

				SelfCards[j].m_CardSprite:runAction(seq);
			end
		end
		Common.log("playDealEndAnimation " .. i)
	end
end

--停止三张底牌站立2秒提示动画
function stopReservedCardsTips()
	for i = 1, #SelfCards do
		SelfCards[i].m_CardSprite:stopAllActions()
	end
end