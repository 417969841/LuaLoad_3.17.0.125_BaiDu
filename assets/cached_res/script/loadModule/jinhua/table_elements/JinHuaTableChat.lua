module("JinHuaTableChat", package.seeall)

--移除聊天气泡
local function showTextEnd(sender)
	JinHuaTableLogic.getParentLayer():removeChild(sender,true)
end

-- 隐藏移除动画
local function hideAnim(sender)
	JinHuaTableLogic.getParentLayer():removeChild(sender, true)
end

--显示聊天气泡
function showChatText(CSID, msg)
	local players = JinHuaTablePlayer.getPlayers()
	--此玩家不存在
	if not players[CSID] then
		return
	end

	if players[CSID] then
		local index = #(JinHuaChatPopLogic.chatLog)
		JinHuaChatPopLogic.chatLog[index+1] = {}
		JinHuaChatPopLogic.chatLog[index+1].nickName = players[CSID].nickName
		JinHuaChatPopLogic.chatLog[index+1].msg = msg
	end

	local parentAnchorPoint
	local locX,locY
	local arrowsDir
	local ARROWS_DOWN = 0
	local ARROWS_LEFT = 1
	local ARROWS_RIGHT = 2

	if CSID > 3 then
		parentAnchorPoint = ccp(1,0.5)
		locX = JinHuaTableConfig.spritePlayers[CSID].locX
		locY = JinHuaTableConfig.spritePlayers[CSID].locY + JinHuaTableConfig.playerBGHeight/2
		arrowsDir = ARROWS_RIGHT
	else
		parentAnchorPoint = ccp(0,0.5)
		locX = JinHuaTableConfig.spritePlayers[CSID].locX + JinHuaTableConfig.playerBGWidth
		locY = JinHuaTableConfig.spritePlayers[CSID].locY + JinHuaTableConfig.playerBGHeight/2
		arrowsDir = ARROWS_LEFT
	end
	if not parentAnchorPoint then
		return
	end

	--文字label
	local labelText = CCLabelTTF:create(msg, "Arial", 16)
	nameSize = labelText:getContentSize()
	if nameSize.width>100 * JinHuaTableConfig.TableScaleX then
		labelText = CCLabelTTF:create(msg, "Arial", 20,CCSizeMake(JinHuaTableConfig.TableDefaultWidth / 8 * JinHuaTableConfig.TableScaleX,0),kCCTextAlignmentLeft)
	end
	local width = JinHuaTableConfig.TableDefaultWidth * 39 / 800 * JinHuaTableConfig.TableScaleX
	local height = JinHuaTableConfig.TableDefaultHeight * 36 / 480 * JinHuaTableConfig.TableScaleY
	local fullRect = CCRectMake(0,0,width,height)
	local insetRect = CCRectMake(JinHuaTableConfig.TableDefaultWidth * 10 / 800 * JinHuaTableConfig.TableScaleX, JinHuaTableConfig.TableDefaultHeight * 10 / 480 * JinHuaTableConfig.TableScaleY,width-JinHuaTableConfig.TableDefaultWidth * 20 / 480 * JinHuaTableConfig.TableScaleX, height-JinHuaTableConfig.TableDefaultHeight *20 / 480 * JinHuaTableConfig.TableScaleY)
	local parent = CCScale9Sprite:create(getJinHuaResource("table_bubble_bg.png", pathTypeInApp), fullRect, insetRect )
	local size = CCSizeMake(labelText:getContentSize().width+20 * JinHuaTableConfig.TableScaleX,labelText:getContentSize().height+20 * JinHuaTableConfig.TableScaleY)
	labelText:setPosition(size.width/2,size.height/2)
	parent:setPreferredSize(size)
	parent:addChild(labelText)

	local arrows
	if arrowsDir == ARROWS_DOWN then
		local arrowsTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("table_bubble_arrows_down.png",pathTypeInApp))
		arrows = CCSprite:createWithTexture(arrowsTexture)
		arrows:setAnchorPoint(ccp(0.5,1))
		arrows:setPosition(size.width/2,3)

	elseif arrowsDir == ARROWS_LEFT then
		local arrowsTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("table_bubble_arrows_left.png",pathTypeInApp))
		arrows = CCSprite:createWithTexture(arrowsTexture)
		arrows:setAnchorPoint(ccp(1,0.5))
		arrows:setPosition(3,size.height/2)

	elseif  arrowsDir == ARROWS_RIGHT  then
		local arrowsTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("table_bubble_arrows_right.png",pathTypeInApp))
		arrows = CCSprite:createWithTexture(arrowsTexture)
		arrows:setAnchorPoint(ccp(0,0.5))
		arrows:setPosition(size.width-3,size.height/2)

	end
	parent:addChild(arrows)

	parent:setAnchorPoint(parentAnchorPoint)
	parent:setPosition(locX,locY)
	parent:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(4),CCCallFuncN:create(showTextEnd)))
	JinHuaTableLogic.getParentLayer():addChild(parent)
end

-- 检测并播放聊天语音
function checkAndPlayerChatSound(chatPlayerCSID,playerChatMsg)
	local commonChatIndex = -1
	for i=1,#JinHuaChatPopLogic.getTableChatCommonText() do
		if JinHuaChatPopLogic.getTableChatCommonText()[i] == playerChatMsg then
			commonChatIndex = i
		end
	end

	if commonChatIndex > 0 and JinHuaTablePlayer.getPlayers()[chatPlayerCSID] then
		JinHuaTableSound.playPlayerChatSound(commonChatIndex, JinHuaTablePlayer.getPlayers()[chatPlayerCSID].sex)
	end
end

--播放普通表情
function playChatCommonEmotion(CSID, emotionIndex)
	local players = JinHuaTablePlayer.getPlayers()
	if players[CSID] then
		--    然后创建armature类，并将进行初始化
		local armature = CCArmature:create("putongbiaoqing")
		--    然后选择播放动画0，并进行缩放和位置设置
		armature:getAnimation():playByIndex(emotionIndex)
		if (players[CSID] and players[CSID].isMe) then
			armature:setPosition(ccp(players[CSID]:getCenterX(), players[CSID]:getCenterY()))
		else
			local commonEmotionPosX = 0
			if CSID > 3 then
				commonEmotionPosX = players[CSID]:getPositionX() - armature:getContentSize().width/2
			else
				commonEmotionPosX = players[CSID]:getPositionX() + players[CSID]:getContentSize().width + armature:getContentSize().width/2
			end
			armature:setPosition(ccp(commonEmotionPosX, players[CSID]:getCenterY()))
		end
		armature:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(5.0),CCCallFuncN:create(hideAnim)))
		--    最后将armature添加到场景中
		JinHuaTableLogic.getParentLayer():addChild(armature)
	end
end

--播放高级表情
function playChatSuperiorEmotion(CSID, emotionIndex)
	local players = JinHuaTablePlayer.getPlayers()
	if players[CSID] then
		--    然后创建armature类，并将进行初始化
		local armature = CCArmature:create("gaojibiaoqing")
		--    然后选择播放动画0，并进行缩放和位置设置
		armature:getAnimation():playByIndex(emotionIndex)
		if (players[CSID] and players[CSID].isMe) then
			armature:setPosition(ccp(players[CSID]:getCenterX(), players[CSID]:getCenterY()))
		else
			local commonEmotionPosX = 0
			if CSID > 3 then
				commonEmotionPosX = players[CSID]:getPositionX() - armature:getContentSize().width/2
			else
				commonEmotionPosX = players[CSID]:getPositionX() + players[CSID]:getContentSize().width + armature:getContentSize().width/2
			end
			armature:setPosition(ccp(commonEmotionPosX, players[CSID]:getCenterY()))
		end
		armature:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(5.0),CCCallFuncN:create(hideAnim)))
		--    最后将armature添加到场景中
		JinHuaTableLogic.getParentLayer():addChild(armature)
	end
end