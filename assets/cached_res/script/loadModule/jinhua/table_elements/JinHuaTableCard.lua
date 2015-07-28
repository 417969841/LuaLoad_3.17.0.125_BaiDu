module("JinHuaTableCard", package.seeall)

--叠加牌
local sendCardSprite
-- 换牌成功动画
local changeCardAnimTexture
local CardTypeName = {"235", "散牌", "对子", "顺子", "金花", "同花顺", "豹子"}

-- 翻牌时间
OpenCardAnimTime = 0.6;

--发牌音效
local function playSendCardEffect()
    JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_SENDCARD)
end

--发牌动画结束
local function sendCardAnimEnd()
    JinHuaTableLogic.resumeSocket()
    local parentLayer = JinHuaTableLogic.getParentLayer()
    local players = JinHuaTablePlayer.getPlayers()

    sendCardSprite:setVisible(false)
    local initCardData = profile.JinHuaGameData.getInitCardData()
--    if players[1] and players[1].isMe and players[1].status == STATUS_PLAYER_PLAYING and UserGuideUtil.isUserGuide == false then
    if players[1] and players[1].isMe and players[1].status == STATUS_PLAYER_PLAYING then
        JinHuaTableButtonGroup.setEnable(BTN_ID_FOLD)
        JinHuaTableButtonGroup.setEnable(BTN_ID_CHECK)
        JinHuaTableButtonGroup.setEnable(BTN_ALWAYS_BET_COIN)
    end
    Common.log("发牌结束，更新出牌人。。。。。")
    JinHuaTablePlayer.refreshCurrentPlayer(initCardData.currentPlayer)
    JinHuaTableCoin.setCoinsAboveCards()

    -- 新手引导
--    if UserGuideUtil.isUserGuide == true then
--        SimulateTableUtil.showTablePromptPop();
--        SimulateTableUtil.setTablePromptPopText();
----        SimulateTableUtil.setMyOperateBtn();
--    end
end

-- 发牌的时候初始化牌 的缩放，旋转角度，位置
local function sendCardInitCardState(player)
    for i=1, #player.cardSprites do
        player.cardSprites[i]:setPosition(JinHuaTableConfig.cardsSpriteStartPositionX, JinHuaTableConfig.cardsSpriteStartPositionY)
        player.cardSprites[i]:setScale(JinHuaTableConfig.cardScale)
        player.cardSprites[i]:setRotation(0)
    end
end

--发1张牌结束回调
local function sendMyCard1End(sender)
    sender:setScale(1)
    sender:setRotation(JinHuaTableConfig.myCard1Rotation)
end

--发1张牌结束回调
local function sendMyCard2End(sender)
    sender:setScale(1)
    sender:setRotation(JinHuaTableConfig.myCard2Rotation)
end

--发1张牌结束回调
local function sendMyCard3End(sender)
    sender:setScale(1)
    sender:setRotation(JinHuaTableConfig.myCard3Rotation)
end

--发牌操作
-- parentLayer 层
-- players 玩家
local function sendCardAnim(parentLayer, players)
    JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_SENDCARDRING)
    if sendCardSprite == nil then
        sendCardSprite = CCSprite:create(getJinHuaResource("desk_cards.png",pathTypeInApp))
        sendCardSprite:setAnchorPoint(ccp(0.5,1))
        sendCardSprite:setPosition(JinHuaTableConfig.sendCardsSpritePositionX, JinHuaTableConfig.sendCardsSpritePositionY)
       	sendCardSprite:setScale(JinHuaTableConfig.cardScale)
        parentLayer:addChild(sendCardSprite)
    end
    sendCardSprite:setVisible(true)

    local setEndFunc = true
    Common.log("发牌..桌上人数："..table.maxn(players))
    for i = 1, table.maxn(players) do
        local spritePlayer = players[i]
        if spritePlayer and spritePlayer.cardSprites[1] then
            Common.log("发牌..座号："..i)
            local spriteCard1 = spritePlayer.cardSprites[1]
            local endX1 = spriteCard1:getPositionX()
            local endY1 = spriteCard1:getPositionY()
            local spriteCard2 = spritePlayer.cardSprites[2]
            local endX2 = spriteCard2:getPositionX()
            local endY2 = spriteCard2:getPositionY()
            local spriteCard3 = spritePlayer.cardSprites[3]
            local endX3 = spriteCard3:getPositionX()
            local endY3 = spriteCard3:getPositionY()
            sendCardInitCardState(spritePlayer)

            if spritePlayer.isMe then
                local move1 = CCMoveTo:create(0.5, ccp(endX1, endY1))
                spriteCard1:runAction(CCSequence:createWithTwoActions(move1, CCCallFuncN:create(sendMyCard1End)))
                local move2 = CCMoveTo:create(0.5, ccp(endX2, endY2))
                local array2 = CCArray:create()
                array2:addObject(CCDelayTime:create(0.5))
                array2:addObject(move2)
                array2:addObject(CCCallFuncN:create(sendMyCard2End))
                spriteCard2:runAction(CCSequence:create(array2))
                local move3 = CCMoveTo:create(0.5, ccp(endX3, endY3))
                local array3 = CCArray:create()
                array3:addObject(CCDelayTime:create(1.0))
                array3:addObject(move3)
                array3:addObject(CCCallFuncN:create(sendMyCard3End))
                spriteCard3:runAction(CCSequence:create(array3))
            else
                local move1 = CCMoveTo:create(0.5, ccp(endX1, endY1))
                spriteCard1:runAction(move1)
                local move2 = CCMoveTo:create(0.5, ccp(endX2, endY2))
                spriteCard2:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), move2))
                local move3 = CCMoveTo:create(0.5, ccp(endX3, endY3))
                local array = CCArray:create()
                array:addObject(CCDelayTime:create(1.0))
                array:addObject(move3)
                --设置发完牌回调 播放音效
                if setEndFunc then
                    setEndFunc = false
                    playSendCardEffect()
                    array = CCArray:create()
                    array:addObject(CCDelayTime:create(0.5))
                    array:addObject(CCCallFunc:create(playSendCardEffect))
                    array:addObject(CCDelayTime:create(0.5))
                    array:addObject(CCCallFunc:create(playSendCardEffect))
                    array:addObject(move3)

                    local aniArr = CCArray:create()
                    aniArr:addObject(CCDelayTime:create(1.8))
                    aniArr:addObject(CCCallFunc:create(sendCardAnimEnd))
                    parentLayer:runAction(CCSequence:create(aniArr))
                    Common.log("发牌定时。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。")
                end
                spriteCard3:runAction(CCSequence:create(array))
            end
        end
    end
end

-- 服务器发牌消息后更新界面
function updateTableAfterSendCardByServer()
    local GameData = profile.JinHuaGameData.getGameData()
    local parentLayer = JinHuaTableLogic.getParentLayer()
    local players = JinHuaTablePlayer.getPlayers()

    JinHuaTableMyOperation.updateDataSendCard()
    GameData.status = STATUS_TABLE_PLAYING
    for i=1,table.maxn(players) do
        local player = players[i]
        if player and player.status == STATUS_PLAYER_READY then
            player.status = STATUS_PLAYER_PLAYING
            player.cardValues = {}
            player:hideReadyIcon()
            player:createCard()
        end
    end
    sendCardAnim(parentLayer, players)
    JinHuaTableTitle.updateTitle()
    JinHuaTableMyOperation.updateIsCanChangeCardState()
    JinHuaTablePlayer.setDealer(parentLayer)
end

--显示正面
local function showCardFront(sender)
    sender:showFront()
end

--翻开牌
local function openCard(cardSprite)
    local array = CCArray:create()
    array:addObject(CCScaleTo:create(OpenCardAnimTime/2,0,cardSprite:getScaleY()))
    array:addObject(CCCallFuncN:create(showCardFront))
    array:addObject(CCScaleTo:create(OpenCardAnimTime/2,cardSprite:getScaleX(),cardSprite:getScaleY()))
    cardSprite:runAction(CCSequence:create(array))
end

--[[--
-- 显示牌型
--@param #table player 玩家
--@param #number cardType 牌型
--]]
function showCardType(player, cardType)
    Common.log("牌型======player.cardType================="..player.cardType.."  cardType===="..cardType)
    if cardType and tonumber(cardType) ~= 0 then
        player.cardTypeSprite:setVisible(true)
        player.cardTypeLabel:setString(CardTypeName[tonumber(cardType)])
    end
end

--看牌旋转牌
local function rotateCard(endX,endY,cardSprite,angle)
    cardSprite:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(endX,endY)),CCRotateTo:create(0.5,angle)))
end

-- 看牌动画
function lookCardAnim(players, checkCardData)
    -- 要看牌的人手上没有牌...
    if not players[checkCardData.CSID].cardSprites[1] then
        return
    end
    -- 自己看牌
    if players[checkCardData.CSID].isMe then
        JinHuaTableButtonGroup.setDisable(BTN_ID_CHECK)
        for i=1, #players[checkCardData.CSID].cardSprites do
            players[checkCardData.CSID].cardSprites[i].setValue(checkCardData["cardValues"][i])
            openCard(players[checkCardData.CSID].cardSprites[i])
        end
        showCardType(players[checkCardData.CSID], checkCardData["cardType"])
--        if JinHuaTablePlayer.getCurrentCSID() == 1 and UserGuideUtil.isUserGuide == false then
        if JinHuaTablePlayer.getCurrentCSID() == 1 then
            JinHuaTableMyOperation.updateMyOperationBtns(checkCardData.currentPlayer)
        end
    else
        -- 别人看牌
        if checkCardData.CSID>3 then
            rotateCard(JinHuaTableConfig.spritePlayers[checkCardData.CSID].cards[3].locX,JinHuaTableConfig.spritePlayers[checkCardData.CSID].cards[3].locY,players[checkCardData.CSID].cardSprites[1],-86)
            rotateCard(JinHuaTableConfig.spritePlayers[checkCardData.CSID].cards[3].locX,JinHuaTableConfig.spritePlayers[checkCardData.CSID].cards[3].locY,players[checkCardData.CSID].cardSprites[2],-43)
        else
            rotateCard(JinHuaTableConfig.spritePlayers[checkCardData.CSID].cards[1].locX,JinHuaTableConfig.spritePlayers[checkCardData.CSID].cards[1].locY,players[checkCardData.CSID].cardSprites[3],86)
            rotateCard(JinHuaTableConfig.spritePlayers[checkCardData.CSID].cards[1].locX,JinHuaTableConfig.spritePlayers[checkCardData.CSID].cards[1].locY,players[checkCardData.CSID].cardSprites[2],43)
        end
    end
end

-- 是否需要显示手牌
local function isNeedShowHandCard(index)
    local players = JinHuaTablePlayer.getPlayers()
    -- 座位上有人，并且服务器传了牌值
    if players[index] ~= nil and players[index].cardValues ~= nil then
    	if #players[index].cardValues == 3 then
    		if players[index].cardSprites[1] ~= nil then
		        -- 牌值是空
		        if players[index].cardSprites[1].value == nil then
		            return true
		        end
	       end
        end
    end
    return false
end

-- 设置我的牌的大小和位置
function setMyCardScaleAndRotation(card1, card2, card3)
    sendMyCard1End(card1)
    sendMyCard2End(card2)
    sendMyCard3End(card3)
end

-- 设置牌的大小和翻转角度
local function setCardScaleAndRotation(index)
    local players = JinHuaTablePlayer.getPlayers()
    for j=1, #players[index].cardSprites do
        players[index].cardSprites[j].setValue(players[index].cardValues[j])
        if not players[index].isMe then
            players[index].cardSprites[j]:setRotation(0)
            players[index].cardSprites[j]:setScale(0.8)
        end
    end

    if players[index].isMe then
        setMyCardScaleAndRotation(players[index].cardSprites[1], players[index].cardSprites[2], players[index].cardSprites[3])
    end
end

-- 设置牌的位置，并翻开牌
local function setCardPositionAndOpenCard(i)
    local players = JinHuaTablePlayer.getPlayers()
    for j=1, #players[i].cardSprites do
        if i>3 then
            players[i].cardSprites[j]:setPosition(JinHuaTableConfig.spritePlayers[players[i].CSID].cards[3].locX-JinHuaTableConfig.cardWidth+(j-1)*JinHuaTableConfig.cardWidth/2,
                JinHuaTableConfig.spritePlayers[players[i].CSID].cards[j].locY - 17 * JinHuaTableConfig.TableScaleY)
        elseif i>1 then
            players[i].cardSprites[j]:setPosition(JinHuaTableConfig.spritePlayers[players[i].CSID].cards[1].locX+(j-1)*JinHuaTableConfig.cardWidth/2,
                JinHuaTableConfig.spritePlayers[players[i].CSID].cards[j].locY - 17 * JinHuaTableConfig.TableScaleY)
        end
        openCard(players[i].cardSprites[j])
    end
end

-- 胜利动画
local function startWinAnim()
    local gameResultData = profile.JinHuaGameData.getGameResultData()
    if JinHuaTablePlayer.getPlayers()[gameResultData.CSID] then
        if gameResultData.CSID == 1 and profile.JinHuaGameData.getGameData().mySSID then
            JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_WIN)
        end
        JinHuaPKAnim.startScatterFlower(ccp(JinHuaTablePlayer.getPlayers()[gameResultData.CSID]:getCenterX(),JinHuaTablePlayer.getPlayers()[gameResultData.CSID]:getCenterY()))
        JinHuaTableLogic.getParentLayer():runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2.0),CCCallFunc:create(JinHuaTableCoin.flyCoinsAnim)))
    else
        JinHuaTableCoin.flyCoinsAnim()
    end

    -- 新手引导
--    if UserGuideUtil.isUserGuide == true then
--        SimulateTableUtil.setTablePromptPopText();
--    end
end

--亮牌
local function showHandCard()
    local players = JinHuaTablePlayer.getPlayers()

    --是否需要翻牌
    local turnCard = false
    for i=1, table.maxn(players) do
        if isNeedShowHandCard(i) then
            Common.log("亮牌玩家位置："..i)
            turnCard = true

            setCardScaleAndRotation(i)
            setCardPositionAndOpenCard(i)
            showCardType(players[i], players[i].cardType)
        end
    end

    --  如果要翻牌，则延时0.3秒播胜利动画
    if turnCard then
        JinHuaTableLogic.getParentLayer():runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3),CCCallFunc:create(startWinAnim)))
    else
        startWinAnim()
    end
end

--延时开始结果绘制
function startResultShow()
    JinHuaTableLogic.getParentLayer():runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(showHandCard)))
end

-- 隐藏移除动画
local function hideAnim(sender)
    JinHuaTableLogic.getParentLayer():removeChild(sender, true)
end

-- 换牌动画
function changeCardAnim(parentLayer, changeCardPlayerCSID)
    if (not changeCardAnimTexture) then
        changeCardAnimTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("change_card_anim.png", pathTypeInApp))
    end
    local changeCardAnimSprite = CCSprite:createWithTexture(changeCardAnimTexture)
    parentLayer:addChild(changeCardAnimSprite)
    if (JinHuaTableConfig.spritePlayers[changeCardPlayerCSID]) then
        changeCardAnimSprite:setPosition(ccp(JinHuaTableConfig.spritePlayers[changeCardPlayerCSID].pkX,JinHuaTableConfig.spritePlayers[changeCardPlayerCSID].pkY))
    end
    local changeCardRoteTo = CCRotateBy:create(2, 480)

    changeCardAnimSprite:runAction(CCSequence:createWithTwoActions(changeCardRoteTo,CCCallFuncN:create(hideAnim)))
end

--[[--
-- 翻转过程中设置牌值
--@param #table sender 牌精灵
--]]
local function selfChangeCardTurnSetValue(sender)
    local changeCardData = profile.JinHuaGameData.getChangeCardData()
    sender.setValue(changeCardData.changeValue)
end

-- 自己换牌翻转
function selfChangeCardTurn(cardSprite)
    local array = CCArray:create()
    array:addObject(CCScaleTo:create(0.3,0,cardSprite:getScaleY()))
    array:addObject(CCCallFuncN:create(selfChangeCardTurnSetValue))
    array:addObject(CCScaleTo:create(0.3,cardSprite:getScaleX(),cardSprite:getScaleY()))
    cardSprite:runAction(CCSequence:create(array))
end

-- 弃牌动画结束后操作
local function foldCardAnimEnd(sender)
    JinHuaTableLogic.getParentLayer():removeChild(sender, true)
end

--开始弃牌动画
function startFoldCardAnim(player)
    if player and player.cardSprites[1] then
        JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_FOLD)
        local moveByX = JinHuaTableConfig.TableDefaultWidth / 2 * JinHuaTableConfig.TableScaleX - player.cardSprites[2]:getPositionX()
        local moveByY = (JinHuaTableConfig.rangTop+JinHuaTableConfig.rangBottom)/2 - player.cardSprites[2]:getPositionY()
        local byPoint = ccp(moveByX, moveByY)
        for i=1, #player.cardSprites do
            player.cardSprites[i]:runAction(CCSequence:createWithTwoActions(CCMoveBy:create(0.5, byPoint), CCCallFuncN:create(foldCardAnimEnd)))
            player.cardSprites[i] = nil
        end
        -- 牌型
        player.cardTypeSprite:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFuncN:create(foldCardAnimEnd)))
        player.cardTypeSprite = nil
    end
end

--清理手牌
function clearCards()
    for i = 1, table.maxn(JinHuaTablePlayer.getPlayers()) do
        local spritePlayer = JinHuaTablePlayer.getPlayers()[i]
        if spritePlayer and spritePlayer.cardSprites[1] then
            spritePlayer:removeCard(JinHuaTableLogic.getParentLayer())
        end
    end
end

-- 隐藏发牌精灵
function dismissSendCardSprite()
    --隐藏牌
    if sendCardSprite then
        sendCardSprite:setVisible(false)
    end
end

-- 清理本模块数据
function clear()
    sendCardSprite = nil
end