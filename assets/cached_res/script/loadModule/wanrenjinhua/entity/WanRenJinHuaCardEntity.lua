function WanRenJinHuaCardEntity()
	local self = CCSprite:create()
	local front, back

	local function init()
		self:setContentSize(CCSizeMake(TableConfig.cardWidth, TableConfig.cardHeight))
		local backTexture = CCTextureCache:sharedTextureCache():addImage(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_pokerback.png", pathTypeInApp))
		back = CCSprite:createWithTexture(backTexture)
		local frontTexture = CCTextureCache:sharedTextureCache():addImage(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_cardbg.png", pathTypeInApp))
		front = CCSprite:createWithTexture(frontTexture)
		back:setPosition(back:getContentSize().width / 2, back:getContentSize().height / 2)
		front:setPosition(front:getContentSize().width / 2, front:getContentSize().height / 2)
		self:addChild(front)
		self:addChild(back)
		self:setScale(WanRenJinHuaConfig.CardScale)
	end

	function self.setValue(value)
		front:removeAllChildrenWithCleanup(true)
		self.value = value
		local typeIndex = math.modf(value / 13) + 1;
		local valueIndex = value % 13;

		--绘制牌值
		local valueWidth = 314 / 13
		local valueHeight = 26
		local cardValueTexture
		if typeIndex == 1 or typeIndex == 3 then
			cardValueTexture = CCTextureCache:sharedTextureCache():addImage(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_card_redvalue.png"))
		else
			cardValueTexture = CCTextureCache:sharedTextureCache():addImage(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_card_blackvalue.png"))
		end
		local rect = CCRectMake(valueWidth * valueIndex, 0, valueWidth, valueWidth)
		local frameValue = CCSpriteFrame:createWithTexture(cardValueTexture, rect)
		local valueSprite = CCSprite:createWithSpriteFrame(frameValue)
		valueSprite:setAnchorPoint(ccp(0, 1))
		valueSprite:setPosition(7, front:getContentSize().height - 3)

		--绘制花色
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_card_type.plist"))
		-- 大花色
		local cardTypeBigSprite = CCSprite:createWithSpriteFrameName(string.format("desk_card_type%d.png",typeIndex))
		cardTypeBigSprite:setAnchorPoint(ccp(1, 0))
		cardTypeBigSprite:setPosition(front:getContentSize().width - 5, 7)
		-- 小花色
		local cardTypeSmallSprite = CCSprite:createWithSpriteFrameName(string.format("desk_card_type%d.png",typeIndex))
		cardTypeSmallSprite:setAnchorPoint(ccp(0, 1))
		cardTypeSmallSprite:setScale(0.4)
		cardTypeSmallSprite:setPosition(valueSprite:getPositionX(), valueSprite:getPositionY() - valueSprite:getContentSize().height - 3)

		front:addChild(valueSprite)
		front:addChild(cardTypeBigSprite)
		front:addChild(cardTypeSmallSprite)
	end

	function self.getValue()
		return self.value
	end

	function self.showBack()
		back:setVisible(true)
		if front ~= nil then
			front:setVisible(false)
		end
	end

	function self.showFront()
		if front ~= nil then
			front:setVisible(true)
			back:setVisible(false)
		end
	end

	init()
	return self
end

