-- 创建普通筹码
function WanRenJinHuaTableCoinEntity(coinValue, rangLeft, rangRight, rangBottom, rangTop)
	local textureChip = CCTextureCache:sharedTextureCache():addImage(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_coin_bg.png"))
	local spriteChip = CCSprite:createWithTexture(textureChip)
	--金币的宽的一半
	local spriteChipWidthHalf = spriteChip:getContentSize().width / 2;
	--金币的高的一半
	local spriteChipHeightHalf = spriteChip:getContentSize().height / 2;
	local X = math.random(rangLeft + spriteChipHeightHalf, rangRight - spriteChipHeightHalf)
	local Y = math.random(rangBottom + spriteChipHeightHalf, rangTop - spriteChipHeightHalf)
	local text = ""
	if tonumber(coinValue) > 9999  then
		text = math.modf(tonumber(coinValue) / 1000).."K"
	else
		text = ""..coinValue
	end
	local label = CCLabelTTF:create(text, "Arial", 24)

	label:setColor(ccc3(63, 25, 6))
	label:setPosition(spriteChipWidthHalf,spriteChipHeightHalf)
	spriteChip:addChild(label)
	spriteChip:setPosition(X, Y)
	return spriteChip
end
