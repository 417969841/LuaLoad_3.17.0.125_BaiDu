function CardSprite()
	local self = CCSprite:create()
	local front, back

	local function init()
		self:setContentSize(CCSizeMake(JinHuaTableConfig.cardWidth, JinHuaTableConfig.cardHeight))
		local backTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_pokerback.png", pathTypeInApp))
		back = CCSprite:createWithTexture(backTexture)
		local frontTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_cardbg.png", pathTypeInApp))
		front = CCSprite:createWithTexture(frontTexture)
		back:setPosition(back:getContentSize().width / 2, back:getContentSize().height / 2)
		front:setPosition(front:getContentSize().width / 2, front:getContentSize().height / 2)
		self:addChild(front)
		self:addChild(back)
	end

	function self.setValue(value)
		front:removeAllChildrenWithCleanup(true)
		self.value = value
		--typeIndex == 1(方块)\2(梅花)\3(红桃)\4(黑桃)
		local typeIndex = math.modf(value / 13) + 1;
		--valueIndex == 在数组{2,3,4,5,6,7,8,9,10,J,Q,K,A}中取
		local valueIndex = value % 13;

		--绘制牌值
		local valueWidth = 416 / 13 --一个数字的宽
		local valueHeight = 32--一个数字的高
		local cardValueTexture
		if typeIndex == 1 or typeIndex == 3 then
			cardValueTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_card_redvalue.png", pathTypeInApp))
		else
			cardValueTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_card_blackvalue.png", pathTypeInApp))
		end
		local rect = CCRectMake(valueWidth * valueIndex, 0, valueWidth, valueHeight - 1)
		local frameValue = CCSpriteFrame:createWithTexture(cardValueTexture, rect)
		local valueSprite = CCSprite:createWithSpriteFrame(frameValue)
		valueSprite:setAnchorPoint(ccp(0, 1))
		valueSprite:setPosition(7, front:getContentSize().height - 3)

		--绘制花色
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(getJinHuaResource("desk_card_type.plist", pathTypeInApp))
		-- 大花色
		local cardTypeBigSprite = CCSprite:createWithSpriteFrameName(string.format("desk_card_type%d.png",typeIndex))
		cardTypeBigSprite:setAnchorPoint(ccp(1, 0))
		cardTypeBigSprite:setPosition(front:getContentSize().width - 5, 7)
		-- 小花色
		local cardTypeSmallSprite = CCSprite:createWithSpriteFrameName(string.format("desk_card_type%d.png",typeIndex))
		cardTypeSmallSprite:setAnchorPoint(ccp(0, 1))
		cardTypeSmallSprite:setScale(0.4)
		cardTypeSmallSprite:setPosition(valueSprite:getPositionX() + 7, valueSprite:getPositionY() - valueSprite:getContentSize().height)

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

