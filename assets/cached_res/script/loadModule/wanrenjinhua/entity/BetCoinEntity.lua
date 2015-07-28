module("BetCoinEntity", package.seeall)

--[[--
--创建下注按钮实体
--@param #number coinValue 下注金额
--]]
function createBetCoinEntity(coinValue)
	local self = CCMenuItemImage:create(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_bg_raise0.png"), WanRenJinHuaConfig.getWanRenJinHuaResource("desk_bg_raise1.png"), WanRenJinHuaConfig.getWanRenJinHuaResource("desk_bg_raise2.png"))
	local betCoinText

	local function create()
		local text = ""
		if tonumber(coinValue) > 9999  then
			text = math.modf(tonumber(coinValue) / 10000)
			betCoinText = CCLabelAtlas:create(text, WanRenJinHuaConfig.getWanRenJinHuaResource("num_wanrenjinhua_chouma.png"), 210 / 10, 30, 48)
			betCoinText:setAnchorPoint(ccp(0.5, 0.5))
			betCoinText:setPosition(self:getContentSize().width/3, self:getContentSize().height/2)

			-- 万字
			local wanSprite = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_wanrenjinhua_chouma_wan.png"))
			wanSprite:setAnchorPoint(ccp(0, 0.5))
			wanSprite:setPosition(self:getContentSize().width/3+betCoinText:getContentSize().width/2, self:getContentSize().height/2)
			self:addChild(wanSprite)
		else
			text = ""..coinValue
			betCoinText = CCLabelAtlas:create(text, WanRenJinHuaConfig.getWanRenJinHuaResource("num_wanrenjinhua_chouma.png"), 210/10, 30, 48)
			betCoinText:setAnchorPoint(ccp(0.5, 0.5))
			betCoinText:setPosition(self:getContentSize().width/2, self:getContentSize().height/2)
		end

		self:addChild(betCoinText)
	end

	create()
	return self
end

--[[--
--透明下载按钮
--]]
function TransparentBetBtn()
	local BetBtn = CCMenuItemImage:create(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_bg_raise3.png"),WanRenJinHuaConfig.getWanRenJinHuaResource("desk_bg_raise3.png"),WanRenJinHuaConfig.getWanRenJinHuaResource("desk_bg_raise3.png"));
	return BetBtn;
end
