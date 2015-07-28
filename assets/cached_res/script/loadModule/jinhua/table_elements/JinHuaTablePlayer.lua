module("JinHuaTablePlayer", package.seeall)

-- 玩家状态Icon类型
TYPE_ICON_FOLD = 1
TYPE_ICON_CHECK = 2
TYPE_ICON_FAILED = 3
TYPE_ICON_WIN = 4

-- 桌上玩家状态icon
local iconArray = {}
-- 玩家实体
local tablePlayerEntitys
--庄家icon
local dealer
--主视角倒计时框
local myTimer
--其他玩家押注倒计时框
local otherTimer
-- 看牌计时器
local lookCardTimer = nil
--请求个人信息UserId
local reqUserId
--当前出牌用户座位号
local currentCSID = -10
-- 看牌前换牌
changeCardWhenNotSee = false

--设置玩家状态icon
function addPlayerStateIcon(iconType, pos)
	local path
	if iconType == TYPE_ICON_FOLD then
		path = getJinHuaResource("desk_icon_fold.png", pathTypeInApp)
	elseif iconType == TYPE_ICON_CHECK then
		path = getJinHuaResource("desk_icon_check.png", pathTypeInApp)
	elseif iconType == TYPE_ICON_FAILED then
		path = getJinHuaResource("desk_icon_failed.png", pathTypeInApp)
	elseif iconType == TYPE_ICON_WIN then
		path = getJinHuaResource("desk_icon_win.png", pathTypeInApp)
	end
	local texture = CCTextureCache:sharedTextureCache():addImage(path)
	local iconSprite = CCSprite:createWithTexture(texture)
	iconSprite:setPosition(JinHuaTableConfig.spritePlayers[pos].iconX, JinHuaTableConfig.spritePlayers[pos].iconY)
	JinHuaTableLogic.getParentLayer():addChild(iconSprite)
	table.insert(iconArray, iconSprite)
end

-- 弃牌后更新玩家状态
local function updatePlayerStateAfterFoldCard(CSID)
	local tablePlayerEntity = tablePlayerEntitys[CSID]
	if tablePlayerEntity then
		tablePlayerEntity.status = STATUS_PLAYER_DISCARD
		addPlayerStateIcon(TYPE_ICON_FOLD, CSID)
		JinHuaTableBubble.showJinHuaTableBubble(CSID, JinHuaTableBubble.BUBBLE_TYPE_DISCARD)
		tablePlayerEntity:setPlayerDarkCoverVisible()
		--移除牌
		JinHuaTableCard.startFoldCardAnim(tablePlayerEntity)

		if tablePlayerEntity.isMe then
			JinHuaTableMyOperation.disableAllTableOperationButtons()
			JinHuaTableMyOperation.operateEndUpdateBtns()
		end
	end
end

-- 关闭下注倒计时
function closeBetTimer(cDeskID)
	if currentCSID == cDeskID then
		if tablePlayerEntitys[currentCSID].isMe then
			myTimer:cleanup()
			myTimer:setPercentage(0)
			JinHuaTableMyOperation.closeScheduleTimer()
		else
			otherTimer:cleanup()
			otherTimer:setPercentage(0)
		end
	end
end

-- 自己弃牌后更新
function updateTableAfterSelfFoldCard()
	local foldPlayerEntity = tablePlayerEntitys[1]
	updatePlayerStateAfterFoldCard(1)
	closeBetTimer(1)
	JinHuaTableSound.playPlayerOperationSound(JinHuaTableSound.FOLD_CARD_PLAYER_SOUND, tablePlayerEntitys[1].sex)
end

-- 关闭我的计时器
function closeMyTimer()
	myTimer:cleanup()
	myTimer:setPercentage(0)
end

-- 关闭他人的计时器
function closeOtherTimer()
	otherTimer:cleanup()
	otherTimer:setPercentage(0)
end

-- 清除所有计时器
function clearAllTimer()
	closeMyTimer()
	closeOtherTimer()
	currentCSID = -10
end

-- 更新玩家的按钮并启动计时
local function updateMyOperationBtnsAndStartTimer(currentPlayer)
	local pro = CCProgressTo:create(15, 100)
	if tablePlayerEntitys[currentPlayer.CSID].isMe then
		JinHuaTableMyOperation.updateMyOperationBtns(currentPlayer)
		local ifNeedMyTimer = JinHuaTableMyOperation.setMyTurnToOperate_ReturnIfNeedMyTimer(tablePlayerEntitys[currentPlayer.CSID])
		-- 启动我的计时器
		if ifNeedMyTimer then
			myTimer:runAction(CCSequence:createWithTwoActions(pro, CCCallFunc:create(JinHuaTableMyOperation.overTimeGiveUpCard)))
		end

		--		if UserGuideUtil.isUserGuide == true then
		--			if SimulateTableUtil.getCurrentRound() ~= 1 then
		--				SimulateTableUtil.setTablePromptPopText();
		--			end
		--			SimulateTableUtil.setMyOperateBtn();
		--		end
	else
		JinHuaTableMyOperation.updateMyBetBtnsOnOthersTurn()
		otherTimer:setPosition(tablePlayerEntitys[currentPlayer.CSID]:getPositionX() + tablePlayerEntitys[currentPlayer.CSID]:getContentSize().width / 2, tablePlayerEntitys[currentPlayer.CSID]:getPositionY() + tablePlayerEntitys[currentPlayer.CSID]:getContentSize().height / 2)
		otherTimer:runAction(pro)

		--		if UserGuideUtil.isUserGuide == true then
		--			SimulateTableUtil.disDisableAllBtn();
		--		end
	end
end

--更新当前要下注人
function refreshCurrentPlayer(currentPlayer)
	-- 说明已经结束 清除计时器
	if currentPlayer == nil then
		clearAllTimer()
		return
	end
	currentPlayer.CSID = profile.JinHuaGameData.getUserCSID(currentPlayer.SSID)
	Common.log("currentCSID="..currentCSID.." nextCSID="..currentPlayer.CSID)
	-- 还是当前用户，返回
	if currentCSID == currentPlayer.CSID then
		return
	end
	currentCSID = currentPlayer.CSID
	--	-- 可能乱牌桌，此处没人 保底方案
	if (tablePlayerEntitys[currentPlayer.CSID] == nil) then
		Common.uploadClientExceptionInfo(" SSID:"..currentPlayer.SSID.."下注下一个玩家处没人")
		return
	end
	--更新是否可以换牌提示
	JinHuaTableMyOperation.updateIsCanChangeCardState();
	--更新玩家的按钮并启动计时
	updateMyOperationBtnsAndStartTimer(currentPlayer)
end

-- 弃牌后更新下一个玩家
local function updateNextPlayerAfterFoldCard(foldCardData)
	if foldCardData.nextPlayer then
		refreshCurrentPlayer(foldCardData.nextPlayer)
		JinHuaTableTitle.updateTitle()
		JinHuaTableMyOperation.updateIsCanChangeCardState()
	end
end

-- 用户弃牌后收到服务器返回更新界面
function updateTableAfterFoldCardByServer(foldCardData)
	local foldPlayerEntity = tablePlayerEntitys[foldCardData.CSID]
	Common.log("弃牌座位号："..foldCardData.CSID)

	-- 别人弃牌的服务器返回
	if foldPlayerEntity and not (foldPlayerEntity.isMe and foldPlayerEntity.status == STATUS_PLAYER_DISCARD) then
		updatePlayerStateAfterFoldCard(foldCardData.CSID)
		closeBetTimer(foldCardData.CSID)
		JinHuaTableSound.playPlayerOperationSound(JinHuaTableSound.FOLD_CARD_PLAYER_SOUND, tablePlayerEntitys[foldCardData.CSID].sex)
	end
	updateNextPlayerAfterFoldCard(foldCardData)
end

-- 看牌后继续计时
local function continueMyTimer()
	if (lookCardTimer) then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookCardTimer)
	end
	if (tablePlayerEntitys[currentCSID] and tablePlayerEntitys[currentCSID].isMe and myTimer and myTimer:getPercentage() ~= 0) then
		local precent = myTimer:getPercentage()
		local remainTime = (1 - precent / 100) * 15

		local pro = CCProgressTo:create(remainTime, 100)

		myTimer:runAction(CCSequence:createWithTwoActions(pro, CCCallFunc:create(JinHuaTableMyOperation.overTimeGiveUpCard)))
	end
end

-- 看牌暂停倒计时
function lookCardStopTimer()
	-- 暂停计时
	if (myTimer and tablePlayerEntitys[currentCSID] and tablePlayerEntitys[currentCSID].isMe and myTimer:getPercentage() ~= 0) then
		myTimer:cleanup()
		lookCardTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(continueMyTimer, 3, false)
	end
end

-- 自己站起后，更新当前人
local function updateCurrentPlayerAfterStandUpMe()
	local timerCSID
	if currentCSID ~= -10 and tablePlayerEntitys[currentCSID] then
		if tablePlayerEntitys[currentCSID].isMe then
			myTimer:cleanup()
			myTimer:setPercentage(0)
			currentCSID = -10
			-- 关闭操作计时器
			JinHuaTableMyOperation.closeScheduleTimer()
		else
			-- 自己站起之后，其他玩家位置变化，原来的currentCSID 变成了SSID + 1
			timerCSID = tablePlayerEntitys[currentCSID].SSID + 1
		end
	end

	return timerCSID
end

-- 清理玩家状态图标
function clearPlayerStateIcons()
	for i=1,#iconArray do
		JinHuaTableLogic.getParentLayer():removeChild(iconArray[i],true)
	end
end

-- 坐下站起时清空牌桌
local function clearTableAfterSitAndStand()
	clearPlayerStateIcons()
	for i=1, table.maxn(tablePlayerEntitys) do
		if tablePlayerEntitys[i] then
			Common.log("清除牌位置:"..i.." name="..tablePlayerEntitys[i].nickName)
			tablePlayerEntitys[i]:removeCard(JinHuaTableLogic.getParentLayer())
		end
	end

	for i=1, table.maxn(tablePlayerEntitys) do
		if tablePlayerEntitys[i] then
			Common.log("清除player SSID="..tablePlayerEntitys[i].SSID..tablePlayerEntitys[i].nickName)
			tablePlayerEntitys[i]:removePlayerElementFromLayer(JinHuaTableLogic.getParentLayer())
		end
	end
	dealer:setVisible(false)
	iconArray = {}
end

--设置庄家图标
function setDealer(parentLayer)
	local GameData = profile.JinHuaGameData.getGameData()
	local pos = GameData.dealerCSID
	Common.log("庄家座位："..pos)
	if dealer == nil then
		dealer = CCSprite:create(getJinHuaResource("desk_icon_dealer.png", pathTypeInApp))
		parentLayer:addChild(dealer)
	end
	dealer:setVisible(true)
	dealer:setPosition(JinHuaTableConfig.spritePlayers[pos].iconX,JinHuaTableConfig.spritePlayers[pos].iconY)
end

--绘制玩家状态
local function showPlayerStatus(tablePlayerEntity)
	if tablePlayerEntity and tablePlayerEntity.status then
		Common.log("玩家名字======="..tablePlayerEntity.nickName.."玩家状态======="..tablePlayerEntity.status)
		if tablePlayerEntity.status == STATUS_PLAYER_READY then
			tablePlayerEntity:showReadyIcon()
		elseif tablePlayerEntity.status == STATUS_PLAYER_PK_FAILURE then
			addPlayerStateIcon(TYPE_ICON_FAILED, tablePlayerEntity.CSID)
			tablePlayerEntity:setPlayerDarkCoverVisible()
		elseif tablePlayerEntity.status == STATUS_PLAYER_DISCARD then
			addPlayerStateIcon(TYPE_ICON_FOLD, tablePlayerEntity.CSID)
			tablePlayerEntity:setPlayerDarkCoverVisible()
		elseif tablePlayerEntity.status == STATUS_PLAYER_PLAYING then
		elseif tablePlayerEntity.status == STATUS_PLAYER_LOOKCARD then
			addPlayerStateIcon(TYPE_ICON_CHECK, tablePlayerEntity.CSID)
		else
			tablePlayerEntity:setPlayerDarkCoverVisible()
		end
	end
end

--根据用户id获取用户
local function getPlayerByUserId(userId)
	for var=1, table.maxn(tablePlayerEntitys) do
		local tmp = tablePlayerEntitys[var]
		if tmp and (tmp.userId.."") == userId then
			return tmp
		end
	end
	return nil
end

--更新用户头像
local function updatePlayerPortrait(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]

		Common.log("update"..photoPath)
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		Common.log(i, j)
		--  string.sub(s,i,j) 提取字符串s的第i个到第j个字符。Lua中，第一个字符的索引值为1，最后一个为-1，以此类推，如：
		--  Common.log(string.sub("[hello world]",2,-2))      --输出hello world
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath and id then
		local player = getPlayerByUserId(id)
		if player then
			player.portraitPath = photoPath
			player:setPortrait(photoPath)
		end
	end
end

-- 设置玩家头像
local function setPlayerPhoto(tablePlayerEntity)
	if tablePlayerEntity.portraitPath then -- 已经显示过头像了
		tablePlayerEntity:setPortrait(tablePlayerEntity.portraitPath)
	else
		if tablePlayerEntity.photoUrl and tablePlayerEntity.photoUrl ~="" then
			Common.getPicFile(tablePlayerEntity.photoUrl, tablePlayerEntity.userId,true,updatePlayerPortrait)
		else
			tablePlayerEntity:setPortrait(nil)
		end
	end
end

--初始化用户信息显示界面
local function initPlayerSptites(parentLayer)
	local GameData = profile.JinHuaGameData.getGameData()
	local playerTable = profile.JinHuaGameData.getPlayers()
	tablePlayerEntitys = playerTable
	--绘制人物
	for i = 1, JinHuaTableConfig.playerCnt do
		Common.log("绘制玩家:"..i)
		if playerTable[i] then
			Common.log("此处有玩家，玩家名字:"..playerTable[i].nickName)
			local tablePlayerEntity = JinHuaTablePlayerEntity:create(playerTable[i])
			tablePlayerEntity:addPlayerElementToLayer(parentLayer)
			showPlayerStatus(tablePlayerEntity)
			tablePlayerEntity:createCard()
			tablePlayerEntity:showJinbiAnim()
			setPlayerPhoto(tablePlayerEntitys[i])
		elseif GameData.mySSID == nil then -- 没有玩家，并且自己并没有坐下
			JinHuaTableButtonGroup.showBtn(BTN_SIT_ID_1 + i - 1)
			JinHuaTableTips.createSitTips(i)
		end
	end
end

-- 站起后检测是否需要弹出充值引导，需要则弹出
local function checkAndShowPayGuideAfterStand()
	Common.log("checkAndShowPayGuideAfterStand ")
	local GameData = profile.JinHuaGameData.getGameData()
	local roomInfo = profile.JinHuaRoomData.getRoomById(GameData.roomId)
	local self_coinnum = tonumber(profile.JinHuaGameData.getMySelf().remainCoins)
	if roomInfo and roomInfo.minCoin > self_coinnum then
		local num =  roomInfo.minCoin - self_coinnum
		if not  HallGiftShowLogic.isShow then
			--如果有礼包显示，则不充值引导
			Common.log("checkAndShowPayGuideAfterStand showPayGuide ")
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, num, RechargeGuidePositionID.JinHuaPositionA)
		end
	end
end

-- 重新加入层中，以便于能显示在上面
local function reAddToLayer(sprite)
	sprite:retain()
	JinHuaTableLogic.getParentLayer():removeChild(sprite,false)
	JinHuaTableLogic.getParentLayer():addChild(sprite)
	sprite:autorelease()
end

--自己站起界面更新
local function updateTableAfterStandUpMe()
	-- 清空发牌
	JinHuaTableCard.dismissSendCardSprite()
	clearTableAfterSitAndStand()
	local timerCSID = updateCurrentPlayerAfterStandUpMe()
	JinHuaTableMyOperation.clearAllTableBtns()

	profile.JinHuaGameData.updatePlayerInfo_SelfStand()
	setDealer(JinHuaTableLogic.getParentLayer())
	-- 重新初始化玩家
	initPlayerSptites(JinHuaTableLogic.getParentLayer())

	if timerCSID and tablePlayerEntitys[timerCSID] then
		otherTimer:setPosition(tablePlayerEntitys[timerCSID]:getCenterX(), tablePlayerEntitys[timerCSID]:getCenterY())
		currentCSID = timerCSID
	end
	reAddToLayer(myTimer)
	reAddToLayer(otherTimer)

	--站起时金币不足，弹出充值引导
	checkAndShowPayGuideAfterStand()
end

--自己站起
function selfStandUp()
	local GameData = profile.JinHuaGameData.getGameData()
	if not GameData.mySSID then
		return
	end
	sendJHID_STAND_UP()
	updateTableAfterStandUpMe()
end

--别人站起
local function updateTableAfterStandUpOther(CSID)
	local GameData = profile.JinHuaGameData.getGameData()
	--清除牌桌站起玩家
	Common.log("清除牌桌玩家..站起客户端座位号:"..CSID)
	if tablePlayerEntitys[CSID] then
		tablePlayerEntitys[CSID]:removePlayerElementFromLayer(JinHuaTableLogic.getParentLayer())
		--清除手牌
		if tablePlayerEntitys[CSID].cardSprites[1] then
			tablePlayerEntitys[CSID]:removeCard(JinHuaTableLogic.getParentLayer())
		end
		tablePlayerEntitys[CSID] = nil
	end

	-- 显示坐下按钮
	if not GameData.mySSID then
		JinHuaTableButtonGroup.showBtn(BTN_SIT_ID_1+CSID-1)
		JinHuaTableTips.createSitTips(CSID)
	end
end

-- 收到服务器站起
function updateTableAfterStandUpByServer(standUpData)
	local mySelf = profile.JinHuaGameData.getMySelf()
	Common.log("processJHID_STAND_UP result="..standUpData.result)
	if standUpData.result == 1 then
		-- 自己站起
		if mySelf.SSID and mySelf.SSID == standUpData.SSID then
			sendDBID_USER_INFO(mySelf.userId)
			updateTableAfterStandUpMe()
			mySelf.SSID = nil
		else
			-- 别人站起
			updateTableAfterStandUpOther(standUpData.CSID)
		end
	end
end

-- 其他人坐下
local function sitDownOther(sitDownData)
	local i = sitDownData.playerInfo.CSID
	tablePlayerEntitys[i] = JinHuaTablePlayerEntity:create(sitDownData.playerInfo)
	showPlayerStatus(tablePlayerEntitys[i])
	setPlayerPhoto(tablePlayerEntitys[i])
	tablePlayerEntitys[i]:createCard()
	tablePlayerEntitys[i]:addPlayerElementToLayer(JinHuaTableLogic.getParentLayer())

	reAddToLayer(myTimer)
	reAddToLayer(otherTimer)

	JinHuaTableMyOperation.hideSit(i)
end

-- 自己坐下服务器应答处理
--  更新金币数
local function selfSitDownByServer()
	if tablePlayerEntitys[1] then -- 一号位有人
		tablePlayerEntitys[1]:setCoin()
		JinHuaTableTips.showEnterTableTips()
	end
end

-- 坐下失败
local function sitDownFail(data)
	local GameData = profile.JinHuaGameData.getGameData()
	if GameData.mySSID then
		updateTableAfterStandUpMe()
		local mySelf = profile.JinHuaGameData.getMySelf()
		mySelf.SSID = nil
	end
	Common.showToast(data.message, 2)
	ResumeSocket("sit failed")
end

--服务器推送坐下
-- sitDownData 坐下数据
function updateTableSitDownByServer(sitDownData)
	PauseSocket("updateTableSitDownByServer")
	-- 失败
	if sitDownData.result == 0 then
		sitDownFail(sitDownData)
		return
	end

	--成功
	if sitDownData.playerInfo and sitDownData.playerInfo.userId then
		if sitDownData.playerInfo.userId == profile.User.getSelfUserID() then
			selfSitDownByServer()
		else
			sitDownOther(sitDownData)
		end
	end

	ResumeSocket("updateTableSitDownByServer")
end

--我坐下更新显示
local function sitDownMeUpdate(seatId)
	local GameData = profile.JinHuaGameData.getGameData()
	--  PauseSocket("sitDown")
	JinHuaTableCard.dismissSendCardSprite()
	--倒计时检测
	local timerSSID
	if currentCSID~=-10 and tablePlayerEntitys[currentCSID] then
		timerSSID = tablePlayerEntitys[currentCSID].SSID
	end

	clearTableAfterSitAndStand()
	profile.JinHuaGameData.updatePlayerInfo_SelfSit(seatId)
	setDealer(JinHuaTableLogic.getParentLayer())
	initPlayerSptites(JinHuaTableLogic.getParentLayer())
	JinHuaTableMyOperation.showFunctionBtns()
	if timerSSID then
		local timerCSID = profile.JinHuaGameData.getUserCSID(timerSSID)
		currentCSID = timerCSID
		otherTimer:setPosition(tablePlayerEntitys[timerCSID]:getCenterX(), tablePlayerEntitys[timerCSID]:getCenterY())
		Common.log("坐下========坐下后   倒计时更新位置==============currentCSID==="..currentCSID)
	end
	reAddToLayer(myTimer)
	reAddToLayer(otherTimer)

	--显示准备按钮
	if GameData.status == STATUS_TABLE_READY then
	--		JinHuaTableButtonGroup.showBtn(BTN_ID_READY)
	end
	--  ResumeSocket("sitDown")
end

--坐下
function sitDownMe(seatId)
	local GameData = profile.JinHuaGameData.getGameData()
	local roomInfo = profile.JinHuaRoomData.getRoomById(GameData.roomId)
	local self_coinnum = tonumber(profile.JinHuaGameData.getMySelf().remainCoins)
	Common.log("坐下座位号："..seatId)
	--	Common.log(self_coinnum)
	if roomInfo and roomInfo.minCoin>self_coinnum then
		--		Common.log(roomInfo.minCoin)
		local num =  roomInfo.minCoin -self_coinnum
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, num, RechargeGuidePositionID.JinHuaPositionA)
		return
	end
	JinHuaTableMyOperation.hideSitBtns()
	sendJHID_SIT_DOWN(GameData.roomId,GameData.tableId,seatId)
	sitDownMeUpdate(seatId)
end

-- 玩家准备消息回来后更新界面
function updateTableAfterPlayerReadyServerBack(readyData)
	Common.log("准备玩家数 ==="..table.maxn(tablePlayerEntitys))
	local GameData = profile.JinHuaGameData.getGameData()
	-- 本人准备失败之后再发一次准备
	if readyData.CSID == 1 and GameData.mySSID and tablePlayerEntitys[1] and tablePlayerEntitys[1].status ~= STATUS_PLAYER_READY and readyData.result == 0 then
		JinHuaTableLogic.getParentLayer():runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2.0),CCCallFunc:create(JinHuaTableMyOperation.onClick_btnReady)))
	end

	for i=1,table.maxn(tablePlayerEntitys) do
		if tablePlayerEntitys[i] and tablePlayerEntitys[i].status and tablePlayerEntitys[i].status == STATUS_PLAYER_READY then
			Common.log("processJHID_READY "..i.."号位准备")
			if not tablePlayerEntitys[i] then
				Common.uploadClientExceptionInfo(" i:"..tablePlayerEntitys[i].CSID.." readyData.CSID:"..readyData.CSID.."准备没人")
				return
			end
			tablePlayerEntitys[i]:showReadyIcon()
			tablePlayerEntitys[i]:setPlayerDarkCoverdGone()
		end
	end
end

-- 玩家换牌消息回来后更新界面
function updateTableAfterPlayerChangeCardServerBack(changeCardData)
	local GameData = profile.JinHuaGameData.getGameData()
	-- 失败
	if changeCardData.result ~= 1  then
		Common.showToast(changeCardData.message, 2)
		-- 换牌卡不够而失败
		if changeCardData.result == 2 then
			mvcEngine.createModule(GUI_JINHUA_TABLEGOODSBUYPOP)
			JinHuaTableGoodsBuyPopLogic.setGoodsInfo(QuickPay.Pay_Guide_changecard_GuideTypeID,RechargeGuidePositionID.TablePositionG)
		end
		return
	end

	local parentLayer = JinHuaTableLogic.getParentLayer()
	JinHuaTableBubble.showJinHuaTableBubble(changeCardData.CSID, JinHuaTableBubble.BUBBLE_TYPE_CHANGECARD)
	-- 换牌动画
	if (tablePlayerEntitys[changeCardData.CSID] and not tablePlayerEntitys[changeCardData.CSID].isMe) then
		JinHuaTableCard.changeCardAnim(parentLayer, changeCardData.CSID)
	end

	-- 自己换牌
	if GameData.mySSID and GameData.mySSID == changeCardData.SSID and tablePlayerEntitys[1].cardSprites[1] then
		-- 翻转牌
		for i=1, #tablePlayerEntitys[1].cardSprites do
			if tablePlayerEntitys[1].cardSprites[i].getValue() and tablePlayerEntitys[1].cardSprites[i].getValue()==JinHuaTableChangeCardPopLogic.getChangeCardValue() then
				JinHuaTableCard.selfChangeCardTurn(tablePlayerEntitys[1].cardSprites[i])
			end
		end

		JinHuaTableMyOperation.updateDataAfterChangeCardSucc(changeCardData.propCnt, changeCardData.remainTime)
		JinHuaTableCard.showCardType(tablePlayerEntitys[changeCardData.CSID], changeCardData["cardType"])
		JinHuaTableSound.playPlayerOperationSound(JinHuaTableSound.CHANGE_CARD_PLAYER_SOUND, tablePlayerEntitys[changeCardData.CSID].sex)
	end
end

-- 玩家聊天消息返回后更新界面
function updateTableAfterPlayerChatServerBack(chatMsg)
	if chatMsg.result == 0 then
		Common.showToast(chatMsg.message, 2)
		return
	end

	if tablePlayerEntitys[chatMsg.CSID] then
		tablePlayerEntitys[chatMsg.CSID].remainCoins = chatMsg.remainCoins
		tablePlayerEntitys[chatMsg.CSID]:setCoin()
	end
	if chatMsg.type == TYPE_CHAT_COMMON then
		JinHuaTableChat.playChatCommonEmotion(chatMsg.CSID, chatMsg.msg)
	elseif chatMsg.type == TYPE_CHAT_SUPERIOR then
		JinHuaTableChat.playChatSuperiorEmotion(chatMsg.CSID, chatMsg.msg)
	elseif chatMsg.type == TYPE_CHAT_TEXT then
		JinHuaTableChat.checkAndPlayerChatSound(chatMsg.CSID, chatMsg.msg)
		JinHuaTableChat.showChatText(chatMsg.CSID, chatMsg.msg)
	end
end

-- 收到服务器看牌消息更新
function updateTableAfterLookCardByServer(checkCardData)
	local GameData = profile.JinHuaGameData.getGameData()
	if (tablePlayerEntitys[checkCardData.CSID] == nil) then
		Common.uploadClientExceptionInfo(" SSID:"..checkCardData.seatID.."看牌位置没人")
		return
	end
	tablePlayerEntitys[checkCardData.CSID].status = STATUS_PLAYER_LOOKCARD
	-- 看牌图标
	addPlayerStateIcon(TYPE_ICON_CHECK, checkCardData.CSID)
	JinHuaTableBubble.showJinHuaTableBubble(checkCardData.CSID, JinHuaTableBubble.BUBBLE_TYPE_LOOKCARD)
	JinHuaTableCard.lookCardAnim(tablePlayerEntitys, checkCardData)

	if (changeCardWhenNotSee) then
		local mySelf = profile.JinHuaGameData.getMySelf()
		if GameData.mySSID and mySelf.cardSprites[1] and mySelf.cardSprites[1].getValue() then
			JinHuaTableChangeCardPopLogic.setCardValues(mySelf.cardSprites[1].getValue(),mySelf.cardSprites[2].getValue(),mySelf.cardSprites[3].getValue())
			mvcEngine.createModule(GUI_JINHUA_TABLECHANGECARDPOP)
		end
		changeCardWhenNotSee = false
	end

	continueMyTimer()
	JinHuaTableSound.playPlayerOperationSound(JinHuaTableSound.CHECK_CARD_PLAYER_SOUND, tablePlayerEntitys[checkCardData.CSID].sex)
end

-- 收到禁比消息处理界面
function updateTableAfterJinbiByServer(jinbiTable)
	local GameData = profile.JinHuaGameData.getGameData()
	if jinbiTable["result"] == 0 then
		Common.showToast(jinbiTable["message"], 2)
	else
		local jinbiPlayerSeatID = profile.JinHuaGameData.getUserCSID(jinbiTable["SSID"])
		tablePlayerEntitys[jinbiPlayerSeatID]:showJinbiAnim()
		JinHuaTableBubble.showJinHuaTableBubble(jinbiPlayerSeatID, JinHuaTableBubble.BUBBLE_TYPE_NO_PK)
		if jinbiPlayerSeatID == 1 and GameData.mySSID then -- 是自己
			GameConfig.remainNoPKCnt = jinbiTable.propCnt
			JinHuaTableButtonGroup.updateNoPkCountText()
		end
	end
end

-- 自己点击下注
function selfClickToBetCoin(bet_type, bet_coin)
	closeMyTimer()
	JinHuaTableMyOperation.pauseVibrateSchedule()
	local betChipData = {}
	betChipData.CSID = 1
	betChipData.type = bet_type
	betChipData.thisTimeBetCoins = bet_coin
	JinHuaTableCoin.betCoinAnim(betChipData, true)
end

-- 服务器返回的下注应答
function updateTableAfterBetCoinByServer()
	local betChipData = profile.JinHuaGameData.getBetChipData()
	if betChipData.result == 0 then
		ResumeSocket("下注失败！！！")
		return
	end

	-- 我的下注返回且不是下底注且不是比牌
	if tablePlayerEntitys[betChipData.CSID] and tablePlayerEntitys[betChipData.CSID].isMe and betChipData.type~=TYPE_BET_ANTE and betChipData.type~=TYPE_BET_PK then
		refreshCurrentPlayer(betChipData["currentPlayer"])
		tablePlayerEntitys[betChipData.CSID]:setCoin()
		JinHuaTableTitle.updateTitle()
		ResumeSocket("processJHID_BET  me")
	else
		if tablePlayerEntitys[betChipData.CSID] ~= nil and tablePlayerEntitys[betChipData.CSID].mPlayerSprite ~= nil then
			-- 别人下注或下底注或比牌操作
			closeOtherTimer()
			JinHuaTableCoin.betCoinAnim(betChipData, false)
		else
			Common.uploadClientExceptionInfo("下注处，mPlayerSprite为空");
		end
	end
end

--获取游戏中玩家最少钱数
function getMinCoin()
	local minCoin = -1
	for i=1, table.maxn(tablePlayerEntitys) do
		if tablePlayerEntitys[i] and (tablePlayerEntitys[i].status == STATUS_PLAYER_PLAYING or tablePlayerEntitys[i].status == STATUS_PLAYER_LOOKCARD) then
			if minCoin == -1 then
				minCoin = tablePlayerEntitys[i].remainCoins
			else
				if minCoin>tablePlayerEntitys[i].remainCoins then
					minCoin = tablePlayerEntitys[i].remainCoins
				end
			end
		end
	end
	return minCoin
end

-- 重置用户下金币
function resetPlayerBetCoin()
	for i=1, table.maxn(tablePlayerEntitys) do
		if tablePlayerEntitys[i] then
			tablePlayerEntitys[i].betCoins = 0
		end
	end
end

--初始化禁比状态
function initPlayerNoPKState()
	for i = 1, table.maxn(tablePlayerEntitys) do
		if tablePlayerEntitys[i] then
			tablePlayerEntitys[i].noPK = false
			tablePlayerEntitys[i]:dismissJinbiIcon()
		end
	end
end

-- 点击玩家检测并执行相关碰撞
-- 碰撞返回true 否则返回false
function checkAndDoTablePlayerCollide(x, y)
	for i=1, table.maxn(tablePlayerEntitys) do
		if tablePlayerEntitys[i] ~= nil and tablePlayerEntitys[i].mPlayerSprite ~= nil and tablePlayerEntitys[i]:boundingBox():containsPoint(ccp(x,y)) and tablePlayerEntitys[i].userId then
			Common.setUmengUserDefinedInfo("table_inner_btn_click", "房间：点击用户")

			reqUserId = tablePlayerEntitys[i].userId
			-- 新手引导
			--			if UserGuideUtil.isUserGuide == true and reqUserId ~= profile.User.getSelfUserID() then
			--				SimulateTableUtil.clickPlayer(reqUserId);
			--			else
			--				mvcEngine.createModule(GUI_USERINFO);
			--				UserInfoLogic.setUserInfo(tablePlayerEntitys[i].userId);
			--			end
			if tablePlayerEntitys[i].userId == profile.User.getSelfUserID() then
				mvcEngine.createModule(GUI_JINHUAUSERINFO);
				JinHuaUserInfoLogic.setSelfUserInfo()
			else
				mvcEngine.createModule(GUI_JINHUAUSERINFO);
				JinHuaUserInfoLogic.setOtherUserInfo(tablePlayerEntitys[i].userId);
			end

			return true
		end
	end

	return false
end

-- 获取赢家的位置
function getWinPlayerPos()
	local pos = 0
	local gameResultData = profile.JinHuaGameData.getGameResultData()
	if (gameResultData) then
		gameResultData.CSID = profile.JinHuaGameData.getUserCSID(gameResultData.winnerSeat)
		pos = gameResultData.CSID
	end
	return pos
end

-- 添加计时器
local function addTimerSprite(parentLayer)
	local timerTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_bg_time.png", pathTypeInApp))
	local spriteTimer = CCSprite:createWithTexture(timerTexture)
	myTimer = CCProgressTimer:create(spriteTimer)
	myTimer:setType(kCCProgressTimerTypeRadial)
	myTimer:setPosition(tablePlayerEntitys[1]:getPositionX() + tablePlayerEntitys[1]:getContentSize().width / 2, tablePlayerEntitys[1]:getPositionY() + tablePlayerEntitys[1]:getContentSize().height / 2)
	parentLayer:addChild(myTimer)

	otherTimer = CCProgressTimer:create(spriteTimer)
	otherTimer:setType(kCCProgressTimerTypeRadial)
	parentLayer:addChild(otherTimer)
end

function create(layer)
	local GameData = profile.JinHuaGameData.getGameData()
	initPlayerSptites(layer)
	-- 如果我在牌桌上并且有牌，更新我的操作按钮
	if profile.JinHuaGameData.isMePlayingThisRound() then
		JinHuaTableMyOperation.updateMyOperationBtns(tablePlayerEntitys[1])
	end
	addTimerSprite(layer)
	setDealer(layer)
	if GameData.status == STATUS_TABLE_PLAYING and GameData.currentPlayer then
		refreshCurrentPlayer(GameData.currentPlayer)
	end
end

function getCurrentCSID()
	return currentCSID
end

function resetCurrentCSID()
	currentCSID = -10
end

-- 清理本模块数据
function clear()
	dealer = nil
	iconArray = {}
	currentCSID = -10
	myTimer = nil
	otherTimer= nil
	tablePlayerEntitys = {}
end

function getPlayers()
	return tablePlayerEntitys
end