JinHuaPKAnim = {}

local PKLayer
--大背景，小背景，vs字，左边头像，右边头像，左边昵称，右边昵称，左边胜利ICON，右边胜利ICON
local bgSprite,bg1Sprite,vsTextSprite,photoLeft,photoRight,nameLeft,nameRight,iconLeftWin,iconRightWin,iconLeftLoss,iconRightLoss,lightingSprite
--左边头像X坐标，右边X坐标，头像Y坐标，名字Y坐标
local photoLeftX,photoRightX,photoY,nameY
--闪电动画
--  local frame1,frame2
--左右各三张牌
local cardLeft1,cardLeft2,cardLeft3,cardRight1,cardRight2,cardRight3
--pk信息
local pkData
--左边位置上人的客户端座位号，右边位置上人的客户端座位号
local leftCSID,rightCSID
--撒星动画
local armature

local mLeftSprite, mRightSprite

local function init()
	PKLayer = CCLayer:create()
	bgSprite = CCSprite:create(getJinHuaResource("desk_pk_bg.png"))
	bgSprite:setPosition(JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX / 2 ,JinHuaTableConfig.TableDefaultHeight * JinHuaTableConfig.TableScaleY / 2)
	photoLeftX = JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX / 4
	photoRightX = JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX * 0.75
	local bgSize = bgSprite:getContentSize()
	bg1Sprite = CCSprite:create(getJinHuaResource("desk_pk_bg1.png"))
	local bg1Size = bg1Sprite:getContentSize()
	bg1Sprite:setPosition(JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX/ 2,bgSprite:getPositionY()-bgSize.height/2+JinHuaTableConfig.TableDefaultHeight*JinHuaTableConfig.TableScaleY / 17+bg1Size.height/2)
	vsTextSprite = CCSprite:create(getJinHuaResource("desk_pk_text.png"))
	vsTextSprite:setPosition(JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX / 2,bg1Sprite:getPositionY())

	local phototexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_playerhead1.png"))
	photoLeft = CCSprite:createWithTexture(phototexture)
	photoRight = CCSprite:createWithTexture(phototexture)
	photoY = bg1Sprite:getPositionY()
	photoLeft:setPosition(photoLeftX,photoY)
	photoRight:setPosition(photoRightX,photoY)

	nameLeft = CCLabelTTF:create("playerLeft", "Arial", 24)
	nameRight = CCLabelTTF:create("playerRight", "Arial", 24)
	nameY = photoLeft:getPositionY()+photoLeft:getContentSize().height/2+5 * JinHuaTableConfig.TableScaleY+nameLeft:getContentSize().height/2
	nameLeft:setPosition(photoLeftX,nameY)
	nameRight:setPosition(photoRightX,nameY)

	local textureWin = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_icon_win_big.png",pathTypeInApp))
	iconLeftWin = CCSprite:createWithTexture(textureWin)
	iconRightWin = CCSprite:createWithTexture(textureWin)
	local textureLoss = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_icon_failed_big.png",pathTypeInApp))
	iconLeftLoss = CCSprite:createWithTexture(textureLoss)
	iconRightLoss = CCSprite:createWithTexture(textureLoss)
	iconLeftWin:setPosition(JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX / 3, photoY)
	iconLeftLoss:setPosition(JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX / 3, photoY)
	iconRightWin:setPosition(JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX / 1.5,photoY)
	iconRightLoss:setPosition(JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX / 1.5,photoY)

	local frameWidth = 519
	local frameHeight = 281
	local lightFrameTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_result_lighting_frame.png", pathTypeInApp))
	local rect = CCRectMake(0,0,frameWidth,frameHeight)
	local frame1 = CCSpriteFrame:createWithTexture(lightFrameTexture,rect)

	lightingSprite = CCSprite:createWithSpriteFrame(frame1)
	lightingSprite:setPosition(JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX / 2,photoY)
	lightingSprite:setVisible(false)

	--左右各三张牌
	local texture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_pokerback.png", pathTypeInApp))
	cardLeft1 = CCSprite:createWithTexture(texture)
	local size = cardLeft1:getContentSize()
	local cardY = JinHuaTableConfig.TableDefaultHeight * JinHuaTableConfig.TableScaleY / 2+bgSize.height/2-10 * JinHuaTableConfig.TableScaleY-size.height/2
	cardLeft1:setPosition(JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX / 2 - bgSize.width/2+10 * JinHuaTableConfig.TableScaleX+size.width/2,cardY)
	cardLeft2 = CCSprite:createWithTexture(texture)
	cardLeft2:setPosition(cardLeft1:getPositionX()+size.width+5*JinHuaTableConfig.TableScaleX,cardY)
	cardLeft3 = CCSprite:createWithTexture(texture)
	cardLeft3:setPosition(cardLeft2:getPositionX()+size.width+5*JinHuaTableConfig.TableScaleX,cardY)
	cardRight1 = CCSprite:createWithTexture(texture)
	cardRight1:setPosition(JinHuaTableConfig.TableDefaultWidth*JinHuaTableConfig.TableScaleX/2+bgSize.width/2-10*JinHuaTableConfig.TableScaleX-size.width/2,cardY)
	cardRight2 = CCSprite:createWithTexture(texture)
	cardRight2:setPosition(cardRight1:getPositionX()-size.width-5*JinHuaTableConfig.TableScaleX,cardY)
	cardRight3 = CCSprite:createWithTexture(texture)
	cardRight3:setPosition(cardRight2:getPositionX()-size.width-5*JinHuaTableConfig.TableScaleX,cardY)
	cardLeft1:setVisible(false)
	cardLeft2:setVisible(false)
	cardLeft3:setVisible(false)
	cardRight1:setVisible(false)
	cardRight2:setVisible(false)
	cardRight3:setVisible(false)

	PKLayer:addChild(bgSprite)
	PKLayer:addChild(bg1Sprite)
	PKLayer:addChild(vsTextSprite)
	PKLayer:addChild(photoLeft)
	PKLayer:addChild(photoRight)
	PKLayer:addChild(nameLeft)
	PKLayer:addChild(nameRight)
	PKLayer:addChild(iconLeftWin)
	PKLayer:addChild(iconLeftLoss)
	PKLayer:addChild(iconRightWin)
	PKLayer:addChild(iconRightLoss)

	PKLayer:addChild(cardLeft1)
	PKLayer:addChild(cardLeft2)
	PKLayer:addChild(cardLeft3)
	PKLayer:addChild(cardRight1)
	PKLayer:addChild(cardRight2)
	PKLayer:addChild(cardRight3)

	PKLayer:addChild(lightingSprite)
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(getJinHuaResource("bipaiwin0.png", pathTypeInApp),getJinHuaResource("bipaiwin0.plist", pathTypeInApp),getJinHuaResource("bipaiwin.ExportJson", pathTypeInApp));
	armature = CCArmature:create("bipaiwin")
	armature:setVisible(false)
	PKLayer:addChild(armature)
	PKLayer:setVisible(false)
end

--重置状态
local function resetPos()
	PKLayer:removeChild(photoLeft,true)
	PKLayer:removeChild(photoRight,true)
	bgSprite:setScale(0)
	bg1Sprite:setScale(0)
	vsTextSprite:setScale(0)
	nameLeft:setVisible(false)
	nameRight:setVisible(false)
	iconLeftWin:setVisible(false)
	iconLeftLoss:setVisible(false)
	iconRightWin:setVisible(false)
	iconRightLoss:setVisible(false)
	lightingSprite:setVisible(false)
	cardLeft1:setVisible(false)
	cardLeft2:setVisible(false)
	cardLeft3:setVisible(false)
	cardRight1:setVisible(false)
	cardRight2:setVisible(false)
	cardRight3:setVisible(false)
	PKLayer:setVisible(true)
end

local function photoLeftMoveEnd()
	nameLeft:setVisible(true)
end

--PK结束
local function pkOver()
	armature:setVisible(false)
	PKLayer:setVisible(false)
	JinHuaTablePlayer.addPlayerStateIcon(JinHuaTablePlayer.TYPE_ICON_WIN, pkData.winCSID)
	JinHuaTablePlayer.addPlayerStateIcon(JinHuaTablePlayer.TYPE_ICON_FAILED, pkData.lossCSID)
	--设置下一个玩家

	JinHuaTablePlayer.refreshCurrentPlayer(pkData.nextPlayer)
	ResumeSocket("callBack_PK")

    -- 新手引导
--	if UserGuideUtil.isUserGuide == true then
--	   SimulateTableUtil.simulateTableResult();
--	end
end

--胜负icon动画
local function startWinIconScale()
	lightingSprite:setVisible(false)
	if leftCSID==pkData.winCSID then
		armature:setPosition(ccp(photoLeftX,photoY));
		iconLeftWin:setScale(0)
		iconLeftWin:setVisible(true)
		iconLeftWin:runAction(CCScaleTo:create(0.3,1.0))
		iconRightLoss:setScale(0)
		iconRightLoss:setVisible(true)
		iconRightLoss:runAction(CCScaleTo:create(0.3,1.0))
	else
		armature:setPosition(ccp(photoRightX,photoY))
		iconLeftLoss:setScale(0)
		iconLeftLoss:setVisible(true)
		iconLeftLoss:runAction(CCScaleTo:create(0.3,1.0))
		iconRightWin:setScale(0)
		iconRightWin:setVisible(true)
		iconRightWin:runAction(CCScaleTo:create(0.3,1.0))
	end

	-- 自己输赢分别播放输赢音效，别人pk按照发起人输赢来算
	if (profile.JinHuaGameData.getGameData().mySSID and pkData.lossCSID == 1) or (pkData.winnerSeatID==pkData.aimSeatID and profile.JinHuaGameData.getGameData().mySSID ~= pkData.winnerSeatID) then
		JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_PKLOSS)
	else
		JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_PKWIN)
	end

	-- 防止自己站起后位置改变
	if JinHuaTablePlayer.getPlayers()[pkData.lossCSID] then
		JinHuaTablePlayer.getPlayers()[pkData.lossCSID]:setPlayerDarkCoverVisible()
	end

	--撒花动画
	armature:setVisible(true)
	armature:getAnimation():playByIndex(0)
	PKLayer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2.0),CCCallFunc:create(pkOver)))
end

--闪电
local function startLighting()
	local frameWidth = 519
	local frameHeight = 281
	local lightFrameTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_result_lighting_frame.png", pathTypeInApp))
	local rect = CCRectMake(0,0,frameWidth,frameHeight)
	local frame1 = CCSpriteFrame:createWithTexture(lightFrameTexture,rect)
	rect = CCRectMake(0,frameHeight,frameWidth,frameHeight)
	local frame2 = CCSpriteFrame:createWithTexture(lightFrameTexture,rect)
	local animFrames = CCArray:create()
	animFrames:addObject(frame1)
	animFrames:addObject(frame2)
	local anim = CCAnimation:createWithSpriteFrames(animFrames,0.1)
	local animate = CCAnimate:create(anim)
	local lightingAnim = CCRepeat:create(animate,12)
	lightingSprite:setVisible(true)
	lightingSprite:runAction(CCSequence:createWithTwoActions(lightingAnim,CCCallFunc:create(startWinIconScale)))
	JinHuaTableSound.playEffectMusic(JinHuaTableSound.SOUND_PK)
end

local function photoRightMoveEnd()
	nameRight:setVisible(true)
	--背景放大
	bgSprite:runAction(CCScaleTo:create(0.3,1.0))
	bg1Sprite:runAction(CCScaleTo:create(0.3,1.0))
	--显示牌
	cardLeft1:setVisible(true)
	cardLeft2:setVisible(true)
	cardLeft3:setVisible(true)
	cardRight1:setVisible(true)
	cardRight2:setVisible(true)
	cardRight3:setVisible(true)
	--vs放大
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.3))
	array:addObject(CCScaleTo:create(0.3,1.0))
	array:addObject(CCCallFunc:create(startLighting))
	vsTextSprite:runAction(CCSequence:create(array))
end

-- 开始飞头像动画
local function startFlyPhotoAnim(sender)
	PKLayer:removeChild(sender, true)

	local picMaleSpriteTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_playerhead1.png", pathTypeInApp))
	local picFemaleSpriteTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_playerhead0.png", pathTypeInApp))
	if mLeftSprite.sex == profile.JinHuaGameData.MALE then
		photoLeft = CCSprite:createWithTexture(picMaleSpriteTexture)
	else
		photoLeft = CCSprite:createWithTexture(picFemaleSpriteTexture)
	end
	photoLeft:setPosition(mLeftSprite:getCenterX(),mLeftSprite:getCenterY())
	if mRightSprite.sex == profile.JinHuaGameData.MALE then
		photoRight = CCSprite:createWithTexture(picMaleSpriteTexture)
	else
		photoRight = CCSprite:createWithTexture(picFemaleSpriteTexture)
	end
	photoRight:setPosition(mRightSprite:getCenterX(),mRightSprite:getCenterY())
	--设置头像图片
	if mLeftSprite.portraitPath then
		local texture = CCTextureCache:sharedTextureCache():addImage(mLeftSprite.portraitPath)
		if texture then
			photoLeft:setTexture(texture)
		end
	end
	if mRightSprite.portraitPath then
		local texture = CCTextureCache:sharedTextureCache():addImage(mRightSprite.portraitPath)
		if texture then
			photoRight:setTexture(texture)
		end
	end
	nameLeft:setString(mLeftSprite.nickName)
	nameRight:setString(mRightSprite.nickName)
	leftCSID = mLeftSprite.CSID
	rightCSID = mRightSprite.CSID
	photoLeft:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(photoLeftX,photoY)),CCCallFunc:create(photoLeftMoveEnd)))
	photoRight:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.3,ccp(photoRightX,photoY)),CCCallFunc:create(photoRightMoveEnd)))
	PKLayer:addChild(photoLeft)
	PKLayer:addChild(photoRight)
	--amarture放上面
	armature:retain()
	PKLayer:removeChild(armature,false)
	PKLayer:addChild(armature)
	armature:autorelease()
	--闪电动画放上面
	lightingSprite:retain()
	PKLayer:removeChild(lightingSprite,false)
	PKLayer:addChild(lightingSprite)
	lightingSprite:autorelease()
end

-- 开始瞄准动画
local function startAimAnim()
	local aimSprite = CCSprite:create(getJinHuaResource("table_pk_collimation.png", pathTypeInApp))
	aimSprite:setPosition(JinHuaTableConfig.spritePlayers[pkData.launchCSID].locX, JinHuaTableConfig.spritePlayers[pkData.launchCSID].locY+mLeftSprite:getContentSize().height)
	local array = CCArray:create()
	array:addObject(CCMoveTo:create(0.5,ccp(JinHuaTableConfig.spritePlayers[pkData.aimCSID].locX+mLeftSprite:getContentSize().width/2, JinHuaTableConfig.spritePlayers[pkData.aimCSID].locY+mLeftSprite:getContentSize().height/2)))
	array:addObject(CCScaleTo:create(0.5,1.5))
	array:addObject(CCScaleTo:create(0.5,1))
	array:addObject(CCCallFuncN:create(startFlyPhotoAnim))
	array:addObject(CCDelayTime:create(0.5))
	aimSprite:runAction(CCSequence:create(array))
	PKLayer:addChild(aimSprite)
end

--开始PK动画(左边playerSprite,右边playerSprite,PK信息)
local function showJinHuaPKAnim(leftSprite,rightSprite,data)
	mLeftSprite = leftSprite
	mRightSprite = rightSprite
	resetPos()
	pkData = data

	startAimAnim()
end

function JinHuaPKAnim.startPK(PKData)
	local players = JinHuaTablePlayer.getPlayers()
	-- 人已经走了
	if not players[PKData.lossCSID] or not players[PKData.winCSID] or
		not players[PKData.lossCSID].mPlayerSprite or not players[PKData.winCSID].mPlayerSprite then
		return
	end
	players[PKData.lossCSID].status = STATUS_PLAYER_PK_FAILURE
	if PKData.winCSID < PKData.lossCSID then
		showJinHuaPKAnim(players[PKData.winCSID],players[PKData.lossCSID],PKData)
	else
		showJinHuaPKAnim(players[PKData.lossCSID],players[PKData.winCSID],PKData)
	end
	if players[PKData.lossCSID] and players[PKData.lossCSID].isMe then
		JinHuaTableButtonGroup.setDisable(BTN_ID_FOLD)
		JinHuaTableButtonGroup.setDisable(BTN_ID_CHECK)
	end
	if players[PKData.launchCSID] then
		players[PKData.launchCSID]:setCoin()
	end

	-- 如果换牌界面在显示中
	if (players[1] and (players[1].CSID == PKData.launchCSID or players[1].CSID == PKData.aimSeatID) and JinHuaTableGoodsBuyPopLogic.isTableGoodsBuyPopShowing == true) then
		mvcEngine.destroyModule(GUI_JINHUA_TABLEGOODSBUYPOP)
	end
	JinHuaTableSound.playPlayerOperationSound(JinHuaTableSound.PK_CARD_PLAYER_SOUND, players[PKData.launchCSID].sex)
end

--PK结束
local function scatterFlowerOver()
	armature:setVisible(false)
	PKLayer:setVisible(false)
end

--开始获胜动画：撒花
function JinHuaPKAnim.startScatterFlower(position)
	resetPos()
	armature:setPosition(position)
	--撒花动画
	armature:setVisible(true)
	armature:getAnimation():playByIndex(0)
	PKLayer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2.0),CCCallFunc:create(scatterFlowerOver)))
end

-- 是否在显示中
function JinHuaPKAnim.isPKLayerShowing()
	return PKLayer:isVisible()
end

function JinHuaPKAnim.createPKLayer()
	init()
	return PKLayer
end