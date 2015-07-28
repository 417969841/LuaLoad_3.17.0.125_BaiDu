module("JinHuaTableTips", package.seeall)

--显示pkTip
local isShowTipPK = true
--显示开牌tip
local isShowTipOpenCard = true
--坐下提示tip
local sitTipSprites = {}

--隐藏回调
local function hideSprite(sender)
	sender:setVisible(false)
	JinHuaTableLogic.getParentLayer():removeChild(sender,true)
end

--显示pkTip
function showTipPK()
	if isShowTipPK then
		isShowTipPK = false
		local pkTip = CCSprite:create(getJinHuaResource("desk_tip_pk.png",pathTypeInApp))
		local x,y=JinHuaTableButtonGroup.getPKTipLoc()
		pkTip:setPosition(x,y+pkTip:getContentSize().height/2)
		JinHuaTableLogic.getParentLayer():addChild(pkTip)
		pkTip:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(3),CCCallFuncN:create(hideSprite)))
	end
end

--显示开牌tip
function showTipOpenCard()
	if isShowTipOpenCard then
		isShowTipOpenCard = false
		local openCardTip = CCSprite:create(getJinHuaResource("desk_tip_opencard.png",pathTypeInApp))
		local x,y=JinHuaTableButtonGroup.getPKTipLoc()
		openCardTip:setPosition(x,y+openCardTip:getContentSize().height/2)
		JinHuaTableLogic.getParentLayer():addChild(openCardTip)
		openCardTip:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(3),CCCallFuncN:create(hideSprite)))
	end
end

--坐下tip
function createSitTips(CSID)
	if sitTipSprites[CSID] then
		sitTipSprites[CSID]:setVisible(true)
	else
		local tipSprite
		if CSID>3 then
			local sitTipTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_sit_tip_left.png",pathTypeInApp))
			tipSprite = CCSprite:createWithTexture(sitTipTexture)
			tipSprite:setAnchorPoint(ccp(1,0))
			tipSprite:setPosition(JinHuaTableConfig.spritePlayers[CSID].locX,JinHuaTableConfig.spritePlayers[CSID].locY+JinHuaTableConfig.playerBGHeight-tipSprite:getContentSize().height)
		else
			local sitTipTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_sit_tip_right.png",pathTypeInApp))
			tipSprite = CCSprite:createWithTexture(sitTipTexture)
			tipSprite:setAnchorPoint(ccp(0,0))
			tipSprite:setPosition(JinHuaTableConfig.spritePlayers[CSID].locX+JinHuaTableConfig.playerBGWidth,JinHuaTableConfig.spritePlayers[CSID].locY+JinHuaTableConfig.playerBGHeight-tipSprite:getContentSize().height)
		end
		if tipSprite then
			local array = CCArray:create()
			array:addObject(CCDelayTime:create(2.0))
			array:addObject(CCScaleTo:create(0.3,0))
			array:addObject(CCScaleTo:create(0.3,1.2))
			array:addObject(CCScaleTo:create(0.05,1))
			tipSprite:runAction(CCRepeatForever:create(CCSequence:create(array)))
			sitTipSprites[CSID] = tipSprite
			JinHuaTableLogic.getParentLayer():addChild(tipSprite)
		end
	end
end

-- 隐藏进入牌桌提示
local function dismissEnterTablePrompt(sender)
	JinHuaTableLogic.getForthLayer():removeChild(sender, true)
end

-- 进入牌桌提示
function showEnterTableTips()
	-- 永远在最上层
	local enterTablePrompt = CCSprite:create(getJinHuaResource("ui_desk_qipao.png", pathTypeInApp))
	enterTablePrompt:setAnchorPoint(ccp(0, 0.5))
	enterTablePrompt:setPosition(JinHuaTableConfig.enterTablePromptX, JinHuaTableConfig.enterTablePromptY)
	JinHuaTableLogic.getForthLayer():addChild(enterTablePrompt)
	--延时取消
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(3))
	array:addObject(CCCallFuncN:create(dismissEnterTablePrompt))
	enterTablePrompt:runAction(CCSequence:create(array))
end

--清除坐下tip
function clearAllSitTips()
	for i=1,table.maxn(sitTipSprites) do
		if sitTipSprites[i] then
			sitTipSprites[i]:setVisible(false)
		end
	end
end

-- 移除坐下tip
function removeSitTip(CSID)
	if sitTipSprites[CSID] then
		sitTipSprites[CSID]:setVisible(false)
	end
end

function initTipsData()
	isShowTipPK = true
	isShowTipOpenCard = true
end

function clear()
	sitTipSprites = {}
end