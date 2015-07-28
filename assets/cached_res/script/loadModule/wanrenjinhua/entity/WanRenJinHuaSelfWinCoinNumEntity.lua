-- 自己输赢金币数显示
function WanRenJinHuaSelfWinCoinNumEntity(coinValue)
	local countLabel
	if tonumber(coinValue) < 0 then
		local absCoinValue = math.abs(coinValue)
		countLabel = CCLabelAtlas:create(":"..absCoinValue, WanRenJinHuaConfig.getWanRenJinHuaResource("num_wanrenjinhua_lost.png"), 253/11, 30, 48)
	else
		countLabel = CCLabelAtlas:create(":"..coinValue, WanRenJinHuaConfig.getWanRenJinHuaResource("num_wanrenjinhua_win.png"), 253/11, 30, 48)
	end

	-- 获取金币数
	function countLabel.getCoinValue()
		return tonumber(coinValue)
	end

	return countLabel
end
