TableCard = {
	-- 牌值
	m_nValue = 0,
	-- 标示相同大小牌的数量
	m_nSameCardCnt = -1,
	-- 花色 0--3
	m_nColor = 0,
	-- 牌面大小。2最大
	m_nWhat = 0,
	-- 是否被选中
	m_bSelected = false,
	-- 是否触摸按下
	m_bTouchMarked = false,
	-- 标记，用于对牌的检索
	m_bMarked = false,
	-- 标记，此牌是否有牌值相同的其它牌，用于避免3带1时破坏对或三或四张。
	m_bSame = 0,
	-- 是否为自己手里牌
	m_bMyHand = false,
	-- 是否为底牌
	m_bReserved = false,
	-- 是否是癞子牌
	mbLaiZi = false,
	-- 癞子变化后的牌值
	m_LaiziValues = {},
	--牌的精灵
	m_CardSprite = nil,
	--牌的正反面
	m_nFaceState = 0x01,
	--是否隐藏
	m_bHide = false,
	m_anScreenXYLT = {x = 0,y = 0},--左上点屏幕坐标
	m_anScreenXYRB = {x = 0,y = 0}--右下点屏幕坐标
}

TableCard_COLOR = { "方块", "梅花", "红桃", "黑桃" };
TableCard_NUM = { "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A", "2", "xiao", "da" };

-- 0x01正面 0x001反面
FACE_FRONT = 0x01;
FACE_BACK = 0x010;

TableCard.__index = TableCard

--[[--
--创建一张新牌
--]]
function TableCard:new(nVal, nFace, myhand)
	local self = {}

	setmetatable(self, TableCard)

	self.m_nFaceState = nFace
	self.m_bMyHand = myhand
	self.m_CardSprite = self:createCardSprite()

	self:setValue(nVal)

	if self.m_nFaceState == FACE_FRONT then
		--显示正面
		self.m_CardSprite.showFront()
	elseif self.m_nFaceState == FACE_BACK then
		--显示背面
		self.m_CardSprite.showBack()
	end
	self.m_bHide = false
	return self  --返回自身
end

function TableCard:setValue(nVal)
	self.m_nValue = nVal;
	if (TableConsole.isLaizi(self.m_nValue)) then
		self.mbLaiZi = true;
	else
		self.mbLaiZi = false;
	end
	self.m_bSetupTexture = false;
	if (nVal < 52) then
		self.m_nColor = math.modf(nVal / 13);
		self.m_nWhat = nVal % 13;
	elseif (nVal == 52) then
		-- 小王
		self.m_nColor = 0;
		self.m_nWhat = 13;
	elseif (nVal == 53) then
		-- 大王
		self.m_nColor = 1;
		self.m_nWhat = 14;
	end
	if self.m_CardSprite ~= nil then
		self.m_CardSprite.setValue(self.m_nColor, self.m_nWhat, self.mbLaiZi)
	end

	--	local msg = TableCard_COLOR[self.m_nColor + 1] .. TableCard_NUM[self.m_nWhat + 1] .. "(" ..self.m_nValue .. ")";
	--	Common.log(msg)
end

function TableCard:setScreenXYLT(xLT, yLT)
	self.m_anScreenXYLT = {x = 0,y = 0}
	self.m_anScreenXYLT.x = xLT
	self.m_anScreenXYLT.y = yLT
end

function TableCard:setScreenXYRB(xRB, yRB)
	self.m_anScreenXYRB = {x = 0,y = 0}
	self.m_anScreenXYRB.x = xRB
	self.m_anScreenXYRB.y = yRB
end

--[[--
--获得牌值
--]]
function TableCard:getValue()
	return self.m_nValue;
end

--[[--
--判断是否选中
--]]
function TableCard:click(x, y)
	if not self.m_CardSprite:isVisible() then
		--当前不显示
		return false
	end
	if x > self.m_anScreenXYLT.x and x < self.m_anScreenXYRB.x and y < self.m_anScreenXYLT.y and y > self.m_anScreenXYRB.y then
		return true
	else
		return false
	end
end

--[[--
-- 标记此牌
--]]
function TableCard:Mark()
	self.m_bMarked = true;
end

--[[--
-- 取消标记
--]]
function TableCard:Unmark()
	self.m_bMarked = false;
end

--[[--
-- 是否被标记
--]]
function TableCard:IsMarked()
	return self.m_bMarked;
end

--[[--
-- 是否被标记不可选中
--]]
function TableCard:IsTouchMarked()
	return self.m_bTouchMarked;
end

--[[--
--设置是否触摸到
--]]
function TableCard:setTouchMarked(isTouchMarked)
	self.m_bTouchMarked = isTouchMarked
	if self.m_bTouchMarked then
		self.m_CardSprite.setFrontColor(125, 125, 125)
	else
		self.m_CardSprite.setFrontColor(255, 255, 255)
	end
end

--[[--
--处理牌的选中逻辑
--]]
function TableCard:OnSelected()
	if self.m_bSelected then
		self:setSelected(false)
	else
		self:setSelected(true)
	end
end

--[[--
--设置选中状态
--]]
function TableCard:setSelected(isSelected)
	self.m_bSelected = isSelected
	if self.m_bSelected then
		self.m_CardSprite:setPosition(self.m_CardSprite:getPositionX(), TableConfig.BottomH + TableConfig.cardHeight + 35)
	else
		self.m_CardSprite:setPosition(self.m_CardSprite:getPositionX(), TableConfig.BottomH + TableConfig.cardHeight)
	end
end

--[[--
--添加癞子变化后的牌值
--]]
function TableCard:addLaiziValues(what)
	--	Common.log("添加癞子变化后的牌值  what ===== "..what)
	table.insert(self.m_LaiziValues, what)
end

--[[--
--@param #number Color 颜色
--@param #number What 数字
--@param #boolean LaiZi 是否是癞子
--]]
function TableCard:createCardSprite()
	local CardSprite = CCSprite:createWithSpriteFrameName("Pai_font.png")
	local front, back
	-- 上牌值
	local valueTopSprite = nil
	-- 下牌值
	local valueDownSprite = nil
	-- 上花色
	local cardTypeTopSprite = nil
	-- 下花色
	local cardTypeDownSprite = nil

	CardSprite:setContentSize(CCSizeMake(TableConfig.cardWidth, TableConfig.cardHeight))
	back = CCSprite:createWithSpriteFrameName("Pai_back.png")
	front = CCSprite:createWithSpriteFrameName("Pai_font.png")
	back:setPosition(back:getContentSize().width / 2, back:getContentSize().height / 2)
	front:setPosition(front:getContentSize().width / 2, front:getContentSize().height / 2)
	CardSprite:addChild(front)
	CardSprite:addChild(back)

	function CardSprite.setValue(Color, What, LaiZi)
		front:removeAllChildrenWithCleanup(true)
		valueTopSprite = nil
		valueDownSprite = nil
		cardTypeDownSprite = nil
		cardTypeTopSprite = nil

		-- 绘制数字
		if LaiZi then
			--癞子牌
			valueTopSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_green_%d.png", What))
			valueDownSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_green_%d.png", What))
		else
			if What < 13 then
				--普通牌
				if Color % 2 == 0 then
					valueTopSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_red_%d.png", What))
					valueDownSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_red_%d.png", What))
				else
					valueTopSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_black_%d.png", What))
					valueDownSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_black_%d.png", What))
				end
			else
				--大小王
				valueTopSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_cat_%d.png", What - 13))
				valueDownSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_cat_%d.png", What - 13))
			end
		end

		-- 绘制花色
		if LaiZi then
			--癞子牌
			if What == 8 or What == 9 or What == 10 then
				cardTypeDownSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_coler_%d.png",What))
			else
				cardTypeDownSprite = CCSprite:createWithSpriteFrameName("Pai_coler_xing.png")
			end
			cardTypeTopSprite = CCSprite:createWithSpriteFrameName("Pai_coler_xing.png")
		else
			if What < 13 then
				if What == 8 or What == 9 or What == 10 then
					cardTypeDownSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_coler_%d.png",What))
					cardTypeTopSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_coler_%d.png",Color))
				else
					cardTypeDownSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_coler_%d.png",Color))
					cardTypeTopSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_coler_%d.png",Color))
				end
			else
				cardTypeDownSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_coler_cat_%d.png",Color))
				cardTypeTopSprite = CCSprite:createWithSpriteFrameName(string.format("Pai_coler_cat_%d.png",Color))
			end
		end

		front:addChild(valueTopSprite)
		front:addChild(cardTypeTopSprite)
		front:addChild(valueDownSprite)
		front:addChild(cardTypeDownSprite)

		if valueTopSprite ~= nil then
			valueTopSprite:setAnchorPoint(ccp(0, 1))
			if What < 13 then
				valueTopSprite:setPosition(-8, front:getContentSize().height)
			else
				valueTopSprite:setPosition(3, front:getContentSize().height - 5)
			end
		end

		if valueDownSprite ~= nil then
			valueDownSprite:setAnchorPoint(ccp(0, 1))
			valueDownSprite:setPosition(front:getContentSize().width + 8, 0)
			valueDownSprite:setRotation(180)
		end

		if cardTypeTopSprite ~= nil then
			cardTypeTopSprite:setAnchorPoint(ccp(0, 1))
			cardTypeTopSprite:setPosition(valueTopSprite:getPositionX() + 15, valueTopSprite:getPositionY() - valueTopSprite:getContentSize().height + 10)
		end

		if cardTypeDownSprite ~= nil then
			cardTypeDownSprite:setAnchorPoint(ccp(1, 0))
			if What < 13 then
				if What == 8 or What == 9 or What == 10 then
					cardTypeDownSprite:setPosition(valueDownSprite:getPositionX() - 12, valueDownSprite:getPositionY() + 4)
				else
					cardTypeDownSprite:setPosition(valueDownSprite:getPositionX() - 48, valueDownSprite:getPositionY() + valueDownSprite:getContentSize().height + 22)
					cardTypeDownSprite:setRotation(180)
				end
			else
				cardTypeDownSprite:setPosition(valueDownSprite:getPositionX(), valueDownSprite:getPositionY() + 16)
			end
		end

		if What < 13 then
			if What == 8 or What == 9 or What == 10 then
				valueDownSprite:setVisible(false)
				cardTypeTopSprite:setVisible(true)
			else
				valueDownSprite:setVisible(true)
				cardTypeTopSprite:setVisible(true)
			end
		else
			valueDownSprite:setVisible(false)
			cardTypeTopSprite:setVisible(false)
		end
	end

	function CardSprite.showBack()
		back:setVisible(true)
		if front ~= nil then
			front:setVisible(false)
		end
	end

	function CardSprite.showFront()
		if front ~= nil then
			front:setVisible(true)
			back:setVisible(false)
		end
	end

	function CardSprite.setFrontColor(R,G,B)
		if front ~= nil then
			front:setColor(ccc3(R,G,B))
		end
		if cardTypeDownSprite ~= nil then
			cardTypeDownSprite:setColor(ccc3(R,G,B))
		end
		if cardTypeTopSprite ~= nil then
			cardTypeTopSprite:setColor(ccc3(R,G,B))
		end
		if valueTopSprite ~= nil then
			valueTopSprite:setColor(ccc3(R,G,B))
		end
		if valueDownSprite ~= nil then
			valueDownSprite:setColor(ccc3(R,G,B))
		end
	end

	CardSprite:setAnchorPoint(ccp(0, 1));

	return CardSprite
end

