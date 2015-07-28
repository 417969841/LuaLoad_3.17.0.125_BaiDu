function BetedCoinLabel(x, y)

    local self = CCSprite:create()
    local coinImg, coinLabel, bg

    local function init()
        local bgTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_bg_betCoin.png", pathTypeInApp))
        bg = CCSprite:createWithTexture(bgTexture)
        bg:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2)
        local coinTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_bet_coin.png", pathTypeInApp))
        coinImg =CCSprite:createWithTexture(coinTexture)
        coinImg:setPosition(bg:getContentSize().width / 5, bg:getContentSize().height / 2)

        coinLabel = CCLabelTTF:create("", "Arial", 19)
        coinLabel:setColor(ccc3(255, 255, 255))
        coinLabel:setPosition(coinImg:getPositionX() + coinImg:getContentSize().width + 10, bg:getContentSize().height / 2)

        self:addChild(bg)
        self:addChild(coinImg)
        self:addChild(coinLabel)
        self:setAnchorPoint(ccp(0, 0))
        self:setPosition(x, y)
    end

    function self.setBetCoin(value)
        self.betCoins = value
        if value > 0 then
            coinLabel:setString("" .. value)
            self:setVisible(true)
        else
            self:setVisible(false)
        end
    end

    init()
    return self
end

