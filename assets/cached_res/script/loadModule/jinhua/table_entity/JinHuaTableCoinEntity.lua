module("JinHuaTableCoinEntity", package.seeall)

-- 创建普通筹码
function createTableCoinEntity(coinValue)
	local textureChip = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_coin_bg.png", pathTypeInApp))
	local spriteChip = CCSprite:createWithTexture(textureChip)
	local X = math.random(JinHuaTableConfig.rangLeft, JinHuaTableConfig.rangRight)
	local Y = math.random(JinHuaTableConfig.rangBottom, JinHuaTableConfig.rangTop)
	local text = ""
	if tonumber(coinValue) > 9999  then
		text = math.modf(tonumber(coinValue) / 1000).."K"
	else
		text = ""..coinValue
	end
	local label = CCLabelTTF:create(text, "Arial", 24)
	--金币的宽
	local spriteChipWidth = spriteChip:getContentSize().width;
	--金币的高
	local spriteChipHeight = spriteChip:getContentSize().height;
	label:setColor(ccc3(63, 25, 6))
	label:setPosition(spriteChipWidth/2,spriteChipHeight/2)
	spriteChip:addChild(label)
	spriteChip:setPosition(X, Y)
	return spriteChip
end
