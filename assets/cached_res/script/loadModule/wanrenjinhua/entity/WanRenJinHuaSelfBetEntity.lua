-- 自己下注数显示
function WanRenJinHuaSelfBetEntity(coinValue)
	local countLabel = CCLabelTTF:create("$ "..coinValue, "Arial", 22)
	countLabel:setColor(ccc3(255, 255, 255))
	return countLabel
end
