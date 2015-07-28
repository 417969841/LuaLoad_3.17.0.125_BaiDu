WanRenJinHuaTableCard = {}

local tableCards = {} -- 桌上的牌
local cardTypeSprite = {} -- 牌型
local cardWinMultipleSprite = {} -- 倍数
local cardsSprite = nil -- 发牌精灵
local cardTypeNameTable = {
		dilong="ui_wanrenjinhua_325.png",
		baozi="ui_wanrenjinhua_baozi.png",
		duizi="ui_wanrenjinhua_duizi.png",
		tonghua="ui_wanrenjinhua_jinhua.png",
		gaopai="ui_wanrenjinhua_sanpai.png",
		tonghuashun="ui_wanrenjinhua_shunjin.png",
		shunzi="ui_wanrenjinhua_shunzi.png"
	} -- 牌型名字
local caidengSprite = {} -- 彩灯精灵
local cardTypeTime = 0.3 -- 牌型动画时间
local showCardTime = 0.3 -- 翻牌动画时间
local wholeTimeOneCards = 0 -- 一整牌一整套动画的时间

-- 播放请下注音效
local function playPleaseBetSound()
	WanRenJinHuaSound.playEffectMusic(WanRenJinHuaSound.SOUND_BET_PLEASE)
end

-- 回调处理
local function sendCardCallBack(sender, index)
	sender:setRotation(WanRenJinHuaConfig.CardRotation[index])
	if index == 3 then
		cardsSprite:setVisible(false)
		-- 播放音效
		WanRenJinHuaSound.playEffectMusic(WanRenJinHuaSound.SOUND_BEFORE_BET)
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(1.5))
		array:addObject(CCCallFuncN:create(playPleaseBetSound))
		tableCards[1][1]:runAction(CCSequence:create(array))
	end
end

local function sendCard1CallBack(sender)
	sendCardCallBack(sender, 1)
end

local function sendCard2CallBack(sender)
	sendCardCallBack(sender, 2)
end

local function sendCard3CallBack(sender)
	sendCardCallBack(sender, 3)
end

-- 发牌回调
local sendCardCallBackTable = {sendCard1CallBack, sendCard2CallBack, sendCard3CallBack}

-- 显示输赢结果
local function showCardResult(index, cardType, multiple, isWin)
	if cardType and cardType ~= "" then
		if isWin == 1 then -- 赢了
			caidengSprite[index]:setVisible(true)
			cardWinMultipleSprite[index]:setString(":"..tostring(multiple)) -- ":"是"9"的asc码的后一位  所以在此可以取到x
			cardWinMultipleSprite[index]:setVisible(true)
		end
		Common.log("cardType ======= "..cardType)
		cardTypeSprite[index]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(cardTypeNameTable[cardType]))
		cardTypeSprite[index]:setVisible(true)
		if index > 1 then
			-- 隐藏自己下注数
			WanRenJinHuaSelfBetNum.delayDismissSelfBetNumByIndex(index-1, 0)
			-- 显示自己赢金币数
			WanRenJinHuaSelfWinCoinNum.delayToShowSelfWinNum(index-1, 0)
		end
	end
end

-- 缩放精灵
local function scaleSprite(sender)
	sender:setScale(2)
	sender:setVisible(true)
end

-- 显示精灵
local function showSprite(sender)
	sender:setVisible(true)
end

-- 开始缩放动画
-- delayTime 延时
local function startScaleAnim(sender, delayTime)
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(delayTime))
	array:addObject(CCCallFuncN:create(scaleSprite))
	array:addObject(CCScaleTo:create(cardTypeTime,1))
	sender:runAction(CCSequence:create(array))
end

-- 由游戏结果消息显示结果框
local function showResultPop()
	local data = profile.WanRenJinHua.getWanRenJinHuaResultDataTable()
	mvcEngine.createModule(GUI_WANRENJINHUA_RESULT)
	WanRenResultPopLogic.setResultData(data["dealerWinCoin"], data["bigWinner"], data["winCoin"])
	WanRenJinHuaBetArea.isSelfBet = false
	-- 播放音效
	if WanRenJinHuaSelfWinCoinNum.getAllSelfWinCoinNum() > 0 then
		WanRenJinHuaSound.playEffectMusic(WanRenJinHuaSound.SOUND_FLYWINCOINS)
	end
	-- 增减金币
	if WanRenJinHuaSelfWinCoinNum.getAllSelfWinCoinNum() ~= 0 then
		WanRenJinHuaUserInfo.dynamicAddCoin(WanRenJinHuaSelfWinCoinNum.getAllSelfWinCoinNum())
	end
end

-- 延时显示结果框
local function delayToShowResultPop()
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(wholeTimeOneCards*5))
	array:addObject(CCCallFuncN:create(showResultPop))
	if tableCards[1][1] then
		tableCards[1][1]:runAction(CCSequence:create(array))
	end
end

-- 开始赢动画
-- 位置
-- 延迟时间
local function startWinAnim(index, delayTime)
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(delayTime))
	array:addObject(CCCallFuncN:create(showSprite))
	caidengSprite[index]:runAction(CCSequence:create(array))
	-- 下注区动画
	if index > 1 and WanRenJinHuaSelfWinCoinNum.winCountValueTable[index-1] > 0 then
		WanRenJinHuaBetArea.startWinAnim(index-1, delayTime)
	end
	if index > 1 then
		Common.log("赢金币"..WanRenJinHuaSelfWinCoinNum.winCountValueTable[index-1])
	end
end

-- 显示倍数
local function showWinMultipleSprite(index, delayTime)
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(delayTime))
	array:addObject(CCCallFuncN:create(showSprite))
	cardWinMultipleSprite[index]:runAction(CCSequence:create(array))
end

-- 开始结果动画
-- delayTime 延时时间
local function startCardResultAnim(index, cardType, multiple, isWin, delayTime)
	if cardType and cardType ~= "" then
		cardTypeSprite[index]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(cardTypeNameTable[cardType]))
		startScaleAnim(cardTypeSprite[index], delayTime)
		if index > 1 then
			-- 隐藏自己下注数
			WanRenJinHuaSelfBetNum.delayDismissSelfBetNumByIndex(index-1, delayTime+cardTypeTime)
			-- 显示自己赢金币数
			WanRenJinHuaSelfWinCoinNum.delayToShowSelfWinNum(index-1, delayTime+cardTypeTime)
		end

		if isWin == 1 then -- 赢了
			cardWinMultipleSprite[index]:setString(":"..tostring(multiple)) -- ":"是"9"的asc码的后一位  所以在此可以取到x
			showWinMultipleSprite(index, delayTime+cardTypeTime)
			startWinAnim(index, delayTime+cardTypeTime)
		end
	end
end

-- 创建发牌精灵
local function createSendCardsSprite(layer)
	if cardsSprite == nil then
		cardsSprite = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_cards.png",pathTypeInApp))
		cardsSprite:setPosition(WanRenJinHuaConfig.SendCardPositionX, WanRenJinHuaConfig.SendCardPositionY)
		layer:addChild(cardsSprite)
	end
	cardsSprite:setVisible(true)
end

-- 绘制桌面上的牌
-- layer 要加的层
-- 数据
function createWanRenJinHuaTableCard(layer, data)
	-- 图片加入缓存
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_wangrenjinhua_paixing0.plist"))

	if not data then
		return
	end

	-- 一整套动作的时间，每套动作延时1秒
	wholeTimeOneCards = showCardTime*2+cardTypeTime+1

	tableCards = {}
	for i = 1, #data do
		local cardNum = #data[i]["card"]
		tableCards[i] = {}

		-- 牌型的位置
		local cardTypePosX = WanRenJinHuaConfig.TableCardPositionX[i]
		local cardTypePosY = WanRenJinHuaConfig.TableCardPositionY[i]

		-- 输赢动画
		caidengSprite[i] = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_wangrenjinhua_caideng1.png"))
		caidengSprite[i]:setPosition(cardTypePosX, cardTypePosY)
		local animation = CCAnimation:create()
		animation:addSpriteFrameWithFileName(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_wangrenjinhua_caideng1.png"))
		animation:addSpriteFrameWithFileName(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_wangrenjinhua_caideng2.png"))
		animation:setDelayPerUnit(0.3)
		caidengSprite[i]:runAction( CCRepeatForever:create( CCAnimate:create(animation) ) )
		caidengSprite[i]:setVisible(false)
		layer:addChild(caidengSprite[i], 1)

		-- 创建牌
		for j = 1, cardNum do
			local cardValue = data[i]["card"][j].cardValue
			tableCards[i][j] = WanRenJinHuaCardEntity()
			tableCards[i][j]:setPosition(cardTypePosX + WanRenJinHuaConfig.EachCardDistanceX[j] +20* TableConfig.TableScaleX, cardTypePosY + ((4 - j) * 5  + 18 ) * TableConfig.TableScaleX  )
			tableCards[i][j]:setAnchorPoint(ccp(0.5, 0.5))
			if cardValue and cardValue >= 0 then
				tableCards[i][j].setValue(cardValue)
				tableCards[i][j].showFront()
			else
				tableCards[i][j].showBack()
			end
			tableCards[i][j]:setRotation(WanRenJinHuaConfig.CardRotation[j])
			layer:addChild(tableCards[i][j], 2)
		end

		-- 创建牌型
		cardTypeSprite[i] = CCSprite:createWithSpriteFrameName(cardTypeNameTable["dilong"])
		cardTypeSprite[i]:setAnchorPoint(ccp(0, 0.5))
		cardTypeSprite[i]:setPosition(cardTypePosX - 30 *TableConfig.TableScaleX, cardTypePosY)
		layer:addChild(cardTypeSprite[i], 2)
		cardTypeSprite[i]:setVisible(false)

		-- 创建倍数
		cardWinMultipleSprite[i] = CCLabelAtlas:create("1", WanRenJinHuaConfig.getWanRenJinHuaResource("num_wangrenjinhua_beishu.png"), 286 / 11, 30, 48)
		cardWinMultipleSprite[i]:setAnchorPoint(ccp(0.5, 0.5))
		cardWinMultipleSprite[i]:setPosition(cardTypePosX+cardTypeSprite[i]:getContentSize().width/2+cardWinMultipleSprite[i]:getContentSize().width/2+10,cardTypePosY)
		layer:addChild(cardWinMultipleSprite[i], 2)
		cardWinMultipleSprite[i]:setVisible(false)

		-- 如果是结果阶段显示结果
		if WanRenJinHuaConfig.TableStatus == WanRenJinHuaConfig.WanRenJinHuaResultState then
			showCardResult(i, data[i].cardType, data[i].multiple, data[i].isWin)
		end
	end
end

-- 发牌音效
local function playSendCardSound()
	WanRenJinHuaSound.playEffectMusic(WanRenJinHuaSound.SOUND_SENDCARD)
end

-- 发牌
function WanRenJinHuaTableCard.sendCard(layer, data)
	if not data then
		return
	end

	createSendCardsSprite(layer)
	for i = 1, #tableCards do
		for j = 1, #tableCards[i] do
			local cardValue = data[i]["card"][j].cardValue
			if cardValue and cardValue >= 0 then
				tableCards[i][j].setValue(cardValue)
				tableCards[i][j].showFront()
			else
				tableCards[i][j].showBack()
			end

			local endX = tableCards[i][j]:getPositionX()
			local endY = tableCards[i][j]:getPositionY()
			tableCards[i][j]:setPosition(WanRenJinHuaConfig.SendCardPositionX, WanRenJinHuaConfig.SendCardPositionY)
			tableCards[i][j]:setVisible(true)
			local moveAnim = CCMoveTo:create(0.5, ccp(endX, endY))
			local arrayAnim = CCArray:create()
			arrayAnim:addObject(CCDelayTime:create(0.5*(j-1)))
			if i == #tableCards then
				arrayAnim:addObject(CCCallFunc:create(playSendCardSound))
			end
			arrayAnim:addObject(moveAnim)
			arrayAnim:addObject(CCCallFuncN:create(sendCardCallBackTable[j]))
			tableCards[i][j]:runAction(CCSequence:create(arrayAnim))
		end
	end
end

-- 显示牌正面
local function showCardFront(sender)
	sender.showFront()
end

-- 开牌
function WanRenJinHuaTableCard.showCard(data)
	if not data then
		return
	end

	for i = 1, #tableCards do
		for j = 2, #tableCards[i] do -- 第一张牌开着，所以从2开始
			local cardValue = data[i]["cards"][j].cardValue
			tableCards[i][j].setValue(cardValue)

			local arrayAnim = CCArray:create()
			arrayAnim:addObject(CCDelayTime:create(wholeTimeOneCards*(i-1)))
			arrayAnim:addObject(CCScaleTo:create(showCardTime,0,tableCards[i][j]:getScaleY()))
			arrayAnim:addObject(CCCallFuncN:create(showCardFront))
			arrayAnim:addObject(CCScaleTo:create(showCardTime,tableCards[i][j]:getScaleX(),tableCards[i][j]:getScaleY()))
			tableCards[i][j]:runAction(CCSequence:create(arrayAnim))
		end

		-- 执行结果动画   翻牌动画之后，showCardTime*2+wholeTimeOneCards*(i-1)
		startCardResultAnim(i, data[i].cardType, data[i].multiple, data[i].isWin, showCardTime*2+wholeTimeOneCards*(i-1))
	end

	delayToShowResultPop()
end

-- 清除桌上的牌
function WanRenJinHuaTableCard.clearCards()
	for i = 1, #tableCards do
		for j = 1, #tableCards[i] do
			tableCards[i][j]:setVisible(false)
			tableCards[i][j]:setRotation(0)
		end
		cardTypeSprite[i]:setVisible(false)
		cardWinMultipleSprite[i]:setVisible(false)
		caidengSprite[i]:setVisible(false)
	end
end

-- 清除数据
function WanRenJinHuaTableCard.clearData()
	cardsSprite = nil
end