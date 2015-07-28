module("JinHuaTableCoin", package.seeall)

-- 下注金币的闪烁动画
local chipFlashBgArray = {}
--桌上筹码
local coinArray = {}
-- 飞完一个金币需要加的金币数
local flyOneCoinEndAddCoinNum = 0
-- 当前玩家下注的数目
local currentPlayerBetChipCount = 0
-- 是否是自己下注
local isSelfBet = false

-- 隐藏移除动画
local function hideAnim(sender)
	JinHuaTableLogic.getParentLayer():removeChild(sender, true)
end

-- 清除上一局的金币动画
local function removeAllChipFlashBgSprites()
	for i=1,#chipFlashBgArray do
		JinHuaTableLogic.getParentLayer():removeChild(chipFlashBgArray[i], true)
	end
end

--押注回调
local function betCoinEnd(sender)
	local GameData = profile.JinHuaGameData.getGameData()
	if GameData.round ~= 0 then
		removeAllChipFlashBgSprites()
		-- 最后下注金币效果
		local textureChipFrontTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_coin_front.png", pathTypeInApp))
		for i=1,currentPlayerBetChipCount do
			local textureChipFrontSprite = CCSprite:createWithTexture(textureChipFrontTexture)
			local chipCount = #coinArray
			local chipSprite = coinArray[chipCount - i + 1]
			textureChipFrontSprite:setPosition(chipSprite:getPositionX(), chipSprite:getPositionY());
			JinHuaTableLogic.getParentLayer():addChild(textureChipFrontSprite)
			table.insert(chipFlashBgArray, textureChipFrontSprite)
		end
	end

	if isSelfBet then
		isSelfBet = false
	else
		ResumeSocket("betCoinEnd")
	end
end

--生产金币并扔到牌桌
-- pos 扔金币玩家位置
-- thisTimeBetCoins 下注金币数
function creatAllInBetCoins(pos, thisTimeBetCoins)
	local startX, startY, endX, endY
	local players = JinHuaTablePlayer.getPlayers()
	startX = players[pos]:getPositionX() + players[pos]:getContentSize().width / 2
	startY = players[pos]:getPositionY() + players[pos]:getContentSize().height / 2
	players[pos]:setCoin()

	local coinTable = JinHuaTableFunctions.getAllInChipArray(thisTimeBetCoins)
	--读取table 绘制金币
	for i=1, #coinTable do
		local spriteChip = JinHuaTableCoinEntity.createTableCoinEntity(coinTable[i])
		endX = math.random(JinHuaTableConfig.rangLeft, JinHuaTableConfig.rangRight)
		endY = math.random(JinHuaTableConfig.rangBottom, JinHuaTableConfig.rangTop)
		spriteChip:setPosition(startX, startY)
		local move = CCMoveTo:create(0.3, ccp(endX, endY))
		if i == #coinTable then
			spriteChip:runAction(CCSequence:createWithTwoActions(move, CCCallFuncN:create(betCoinEnd)))
		else
			spriteChip:runAction(move)
		end
		JinHuaTableLogic.getParentLayer():addChild(spriteChip)
		table.insert(coinArray, spriteChip)
	end

	currentPlayerBetChipCount = #coinTable
end

--[[--
--生产金币并扔到牌桌
--@param #type pos 扔金币玩家位置
--@param #type thisTimeBetCoins 下注金币数
--@param #type flyCoinCnt 飞几个金币
--]]
local function createNormalBetCoins(pos,thisTimeBetCoins,flyCoinCnt)
	local startX, startY, endX, endY
	local players = JinHuaTablePlayer.getPlayers()
	startX = players[pos]:getPositionX() + players[pos]:getContentSize().width / 2
	startY = players[pos]:getPositionY() + players[pos]:getContentSize().height / 2
	players[pos]:setCoin()
	thisTimeBetCoins = thisTimeBetCoins / flyCoinCnt
	for i=1, flyCoinCnt do
		local spriteChip = JinHuaTableCoinEntity.createTableCoinEntity(thisTimeBetCoins)
		endX = math.random(JinHuaTableConfig.rangLeft, JinHuaTableConfig.rangRight)
		endY = math.random(JinHuaTableConfig.rangBottom, JinHuaTableConfig.rangTop)
		spriteChip:setPosition(startX, startY)
		local move = CCMoveTo:create(0.3, ccp(endX, endY))
		if i == flyCoinCnt then
			spriteChip:runAction(CCSequence:createWithTwoActions(move,CCCallFuncN:create(betCoinEnd)))
		else
			spriteChip:runAction(move)
		end
		JinHuaTableLogic.getParentLayer():addChild(spriteChip)
		table.insert(coinArray, spriteChip)
	end

	currentPlayerBetChipCount = flyCoinCnt
end

--[[--
-- 收到服务器押注后，下注动画
-- @param #table betChipData 下注回应数据
--@param #boolean isSelfClickToBet 自己跟注、加注、全压为true, Pk、下底注为false、别人下注等为false
--]]
function betCoinAnim(betChipData, isSelfClickToBet)
	local players = JinHuaTablePlayer.getPlayers()

	--飞金币数
	local flyCoinCnt = 1
	if players[betChipData.CSID] and players[betChipData.CSID].status == STATUS_PLAYER_LOOKCARD then
		flyCoinCnt = flyCoinCnt*2
	end

	-- 底注
	if betChipData.type==TYPE_BET_ANTE then
		JinHuaTableButtonGroup.hideBtn(BTN_ID_READY)
		JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_BET)
		JinHuaTablePlayer.setDealer(JinHuaTableLogic.getParentLayer())
	elseif betChipData.type==TYPE_BET_CALL then
		JinHuaTableBubble.showJinHuaTableBubble(betChipData.CSID, JinHuaTableBubble.BUBBLE_TYPE_CALL)
		JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_BET)
	elseif betChipData.type==TYPE_BET_RAISE then
		JinHuaTableBubble.showJinHuaTableBubble(betChipData.CSID, JinHuaTableBubble.BUBBLE_TYPE_RAISE)
		JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_BET)
	elseif betChipData.type==TYPE_BET_ALLIN then
		JinHuaTableMyOperation.setAllInValue(betChipData.thisTimeBetCoins)
		local allInArmature = CCArmature:create("yaman")
		--    该模板中共制作了三个动画，你可以将索引修改为0/1/2中的任意值来查看不同效果
		allInArmature:setPosition(JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX/2,(JinHuaTableConfig.rangBottom+JinHuaTableConfig.rangTop)/2)
		--    然后选择播放动画0，并进行缩放和位置设置
		allInArmature:getAnimation():playByIndex(0)
		allInArmature:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.5),CCCallFuncN:create(hideAnim)))
		JinHuaTableLogic.getParentLayer():addChild(allInArmature)
		JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_ALLIN)
	elseif betChipData.type==TYPE_BET_PK then
		flyCoinCnt = flyCoinCnt*2
	end

	if betChipData.type==TYPE_BET_ALLIN then
		creatAllInBetCoins(betChipData.CSID,betChipData.thisTimeBetCoins)
	else
		createNormalBetCoins(betChipData.CSID,betChipData.thisTimeBetCoins,flyCoinCnt)
	end

	if not isSelfClickToBet then
		JinHuaTablePlayer.refreshCurrentPlayer(betChipData["currentPlayer"])
		JinHuaTableTitle.updateTitle()
	else
		isSelfBet = true
	end

	-- 播放声音
	if betChipData.type==TYPE_BET_ALLIN or betChipData.type==TYPE_BET_RAISE then
		JinHuaTableSound.playPlayerOperationSound(JinHuaTableSound.RAISE_BET_PLAYER_SOUND, players[betChipData.CSID].sex)
	elseif betChipData.type==TYPE_BET_CALL then
		-- 跟注
		JinHuaTableSound.playPlayerOperationSound(JinHuaTableSound.BET_PLAYER_SOUND, players[betChipData.CSID].sex)
	end
end

-- 设置金币在牌的上层
function setCoinsAboveCards()
	for i=1,#coinArray do
		local chip = coinArray[i]
		if chip then
			chip:retain()
			JinHuaTableLogic.getParentLayer():removeChild(chip,false)
			JinHuaTableLogic.getParentLayer():addChild(chip)
			chip:autorelease()
		end
	end
end

-- 通过飞金币增加赢家的金币数
local function addWinPlayerCoinNumByFlyCoin()
	local playerPos = JinHuaTablePlayer.getWinPlayerPos()
	if JinHuaTablePlayer.getPlayers()[playerPos] then
		JinHuaTablePlayer.getPlayers()[playerPos]:addPlayerCoin(flyOneCoinEndAddCoinNum)
	end
end

--赢家飞金币结束回调
local function coinsMoveEnd(sender)
	JinHuaTableLogic.getParentLayer():removeChild(sender, true)
	addWinPlayerCoinNumByFlyCoin()
	JinHuaTableLogic.resetData()
end

--清除桌上金币
local function clearCoins()
	for i=1,#coinArray do
		table.remove(coinArray)
	end
end

-- 飞完金币后清理牌桌
local function clearTableAfterFlyCoin()
	local GameData = profile.JinHuaGameData.getGameData()
	clearCoins()
	JinHuaTableCard.clearCards()
	JinHuaTablePlayer.clearPlayerStateIcons()

	if GameData.mySSID and JinHuaTablePlayer.getPlayers()[1].status ~= STATUS_PLAYER_READY then
		if JinHuaTableTextPopLogic and JinHuaTableTextPopLogic.isShow then
			mvcEngine.destroyModule(GUI_JINHUA_TABLETEXTPOP)
		end
	end
	if JinHuaTablePlayer.getPlayers()[JinHuaTablePlayer.getWinPlayerPos()] then
		JinHuaTablePlayer.getPlayers()[JinHuaTablePlayer.getWinPlayerPos()]:setCoin()
	end

	JinHuaTableMyOperation.gameResultOperation()
	ResumeSocket("gameResult")
end

--赢家飞金币
function flyCoinsAnim()
	removeAllChipFlashBgSprites()
	local pos = JinHuaTablePlayer.getWinPlayerPos()
	JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_FLYWINCOINS)
	local playerSpritesX = 0
	local playerSpritesY = 0
	if not JinHuaTablePlayer.getPlayers()[pos] then
		playerSpritesX = JinHuaTableConfig.spritePlayers[pos].locX + JinHuaTableConfig.playerWidth / 2
		playerSpritesY = JinHuaTableConfig.spritePlayers[pos].locY + JinHuaTableConfig.playerHeight / 2
	else
		playerSpritesX = JinHuaTablePlayer.getPlayers()[pos]:getPositionX() + JinHuaTablePlayer.getPlayers()[pos]:getContentSize().width / 2
		playerSpritesY = JinHuaTablePlayer.getPlayers()[pos]:getPositionY() + JinHuaTablePlayer.getPlayers()[pos]:getContentSize().height / 2
	end

	local chipSpriteSpeed = 800 * JinHuaTableConfig.TableScaleX --速度像素/秒

	local chipCount = #coinArray
	if JinHuaTablePlayer.getPlayers()[pos] then
		flyOneCoinEndAddCoinNum = math.floor((JinHuaTablePlayer.getPlayers()[pos].remainCoins - JinHuaTablePlayer.getPlayers()[pos]:getCurrentShowingCoinNum())/chipCount)
	end

	for i =1, chipCount do
		local chipSpritesX = coinArray[i]:getPositionX() + coinArray[i]:getContentSize().width / 2
		local chipSpritesY = coinArray[i]:getPositionY() + coinArray[i]:getContentSize().height / 2

		-- 距离
		local distance = math.sqrt(math.pow(chipSpritesX - playerSpritesX, 2) + math.pow(chipSpritesY - playerSpritesY, 2))

		local move = CCMoveTo:create(distance / chipSpriteSpeed, ccp(playerSpritesX, playerSpritesY))
		local array = CCArray:create()
		array:addObject(move)
		array:addObject(CCCallFuncN:create(coinsMoveEnd))
		coinArray[i]:runAction(CCSequence:create(array))
	end
	JinHuaTableLogic.getParentLayer():runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(clearTableAfterFlyCoin)))
end

--牌桌筹码显示
function createTableCoins(layer, coinData)
	if coinData then
		local coins = {}
		for i = 1, #coinData do
			if coinData[i].allIn == 1 then
				local tmp = JinHuaTableFunctions.getAllInChipArray(coinData[i].coins)
				for var=1, #tmp do
					coins[#coins+1] = tmp[var]
				end
			elseif coinData[i].lookCard == 1 then
				coins[#coins+1] = coinData[i].coins/2
				coins[#coins+1] = coinData[i].coins/2
			else
				coins[#coins+1] = coinData[i].coins
			end
		end
		--创建筹码
		for i=1, #coins do
			local spriteChip = JinHuaTableCoinEntity.createTableCoinEntity(coins[i])
			layer:addChild(spriteChip)
			table.insert(coinArray, spriteChip)
		end
	end
end

-- 清理本模块数据
function clear()
	coinArray = {}
	isSelfBet = false
end