--dataTable["players"][i].userId = nMBaseMessage:readInt()
--dataTable["players"][i].nickName = nMBaseMessage:readUTF()
--dataTable["players"][i].photoUrl = nMBaseMessage:readUTF()
--dataTable["players"][i].SSID = nMBaseMessage:readInt()
-- 下金币数
--dataTable["players"][i].betCoins = nMBaseMessage:readInt()
-- 剩余金币数
--dataTable["players"][i].remainCoins = nMBaseMessage:readInt()
-- 牌桌状态
--dataTable["players"][i].status = nMBaseMessage:readByte()
--dataTable["players"][i].vipLevel = nMBaseMessage:readInt()
--dataTable["players"][i].sex = nMBaseMessage:readByte()
--dataTable["players"][i].noPK = true
--dataTable["players"][i]["cardValues"][i1] = nMBaseMessage:readInt()
-- 牌型
--dataTable["players"][i].cardType = nMBaseMessage:readByte()
--  -- 跟注金额，如果为-1则按钮不可用
-- dataTable["currentPlayer"]["callCoin"] = nMBaseMessage:readInt()
--比牌按钮  0 不能操作，1 比牌 2 开牌
-- currentPlayer.compareCard
-- lookCard  0不能看牌， 1可以看牌
-- raiseCoin = {} 加注列表，如果数组数量为0，则不显示加注

JinHuaTablePlayerEntity = {
    mPlayerSprite = nil, -- 玩家精灵
    spritePic, -- 头像
    labelName, -- 名字
    labelCoin, -- 金币
    playerDarkCover, --蒙黑
    jinbiSprite, -- 禁比精灵
    betedCoinLabel, -- 下的金币数
    readyIcon, -- 准备
    cardTypeSprite, -- 玩家牌型背景
    cardTypeLabel, -- 玩家牌型label
    goldSprite,
    cardSprites = {} -- 牌精灵
}

JinHuaTablePlayerEntity.__index = JinHuaTablePlayerEntity

-- 玩家精灵
local function createPlayerSprite(self)
    self.mPlayerSprite = CCSprite:create(getJinHuaResource("desk_player_bg.png", pathTypeInApp))
    self.mPlayerSprite:setAnchorPoint(ccp(0, 0))
    self.mPlayerSprite:setPosition(JinHuaTableConfig.spritePlayers[self.CSID].locX, JinHuaTableConfig.spritePlayers[self.CSID].locY)
end

-- 头像
local function createPlayerPhotoBg(self)
    local sizeBg = self.mPlayerSprite:getContentSize()
    --头像
    self.spritePic = CCSprite:create(getJinHuaResource("desk_playerhead_bg.png", pathTypeInApp))
    self.spritePic:setPosition(sizeBg.width / 2, sizeBg.height / 2)
    self.mPlayerSprite:addChild(self.spritePic)
end

-- 头像
local function createPlayerPhoto(self)
    local sizeBg = self.mPlayerSprite:getContentSize()
    --头像
    self.spritePic = CCSprite:create(getJinHuaResource("desk_playerhead.png", pathTypeInApp))
    self.spritePic:setPosition(sizeBg.width / 2, sizeBg.height / 2)
    self.mPlayerSprite:addChild(self.spritePic)
end

-- 名字
local function createPlayerLabelName(self)
    local sizeBg = self.mPlayerSprite:getContentSize()
    local sizePic = self.spritePic:getContentSize()
    local nickName = self.nickName
    --名字的最大长度（超出最大长度截取+..）
    self.labelName = CCLabelTTF:create(nickName, "Arial", 18)
    self.labelName:setColor(ccc3(240, 229, 232))
    local nameSize = self.labelName:getContentSize()
    local nameMaxWidth = sizeBg.width - 5
    while nameSize.width > nameMaxWidth do
        nickName = LordGamePub.SubUTF8String(nickName,-2)
        self.labelName:setString(nickName.."..")
        nameSize = self.labelName:getContentSize()
    end
        --玩家姓名的Y轴
    local labelNameY  = sizeBg.height - (sizeBg.height / 2 - sizePic.height / 2) / 2
    self.labelName:setPosition(sizeBg.width / 2, labelNameY)
    self.mPlayerSprite:addChild(self.labelName)
end

-- 自己拥有的金币数label
local function createPlayerLabelCoin(self)
    local sizeBg = self.mPlayerSprite:getContentSize()
    local sizePic = self.spritePic:getContentSize()
	self.goldSprite = CCSprite:create(getJinHuaResource("desk_coin_logo.png", pathTypeInApp))
	self.goldSprite:setPosition(sizeBg.width / 2 - self.spritePic:getContentSize().width / 2 + self.goldSprite:getContentSize().width / 2,(sizeBg.height / 2 - sizePic.height / 2) / 2)
	self.mPlayerSprite:addChild(self.goldSprite)
    self.labelCoin = CCLabelTTF:create(self.remainCoins, "Arial", 18)
    local labelCoinSize = self.labelCoin:getContentSize()
    self.labelCoin:setColor(ccc3(245, 225, 89))
    self.labelCoin:setAnchorPoint(ccp(0,0.5))

    self.labelCoin:setPosition(self.goldSprite:getPositionX() + self.goldSprite:getContentSize().width / 2 + 2, (sizeBg.height / 2 - sizePic.height / 2) / 2)
    self.mPlayerSprite:addChild(self.labelCoin)
end

--蒙灰遮挡
local function createPlayerDarkCover(self)
    local sizeBg = self.mPlayerSprite:getContentSize()
    self.playerDarkCover = CCSprite:create(getJinHuaResource("desk_player_cover.png", pathTypeInApp))
    self.playerDarkCover:setPosition(sizeBg.width/2,sizeBg.height/2)
    self.playerDarkCover:setVisible(false)
    self.mPlayerSprite:addChild(self.playerDarkCover)
end

-- 创建禁比图标
local function createJinbiSprite(self)
    local sizeBg = self.mPlayerSprite:getContentSize()
    self.jinbiSprite = CCSprite:create(getJinHuaResource("jinbi_icon.png",pathTypeInApp))
    self.jinbiSprite:setAnchorPoint(ccp(0.5,0.5))
    local jinbiSize = self.jinbiSprite:getContentSize()
    local jinbiX = 0
    local jinbiY = sizeBg.height - jinbiSize.height/2 - 2*JinHuaTableConfig.TableScaleY
    if self.CSID > 3 then
        jinbiX = jinbiSize.width/2 + 2*JinHuaTableConfig.TableScaleX
    else
        jinbiX = sizeBg.width - jinbiSize.width/2 - 2*JinHuaTableConfig.TableScaleX
    end
    self.jinbiSprite:setPosition(jinbiX, jinbiY)
    self.jinbiSprite:setScale(2)
    self:dismissJinbiIcon()
    self.mPlayerSprite:addChild(self.jinbiSprite)
end

-- 改变界面上的金币
local function changeCoinNumOnView(self, coinNum)
    local sizeBg = self.mPlayerSprite:getContentSize()
    local sizePic = self.spritePic:getContentSize()
    self.labelCoin:setString(coinNum)
    self:setBetCoin()
    self.labelCoin:setPosition(self.goldSprite:getPositionX() + self.goldSprite:getContentSize().width / 2 + 2, (sizeBg.height / 2 - sizePic.height / 2) / 2)
end

--创建已压金币数label, 没有加到mPlayerSprite,直接加到了layer上面
local function createBetedCoinLabel(self)
    self.betedCoinLabel = BetedCoinLabel(JinHuaTableConfig.spritePlayers[self.CSID].betCoinX, JinHuaTableConfig.spritePlayers[self.CSID].betCoinY)
    self:setBetCoin()
end

-- 创建准备图标
local function createReadyIcon(self)
    self.readyIcon = CCSprite:create(getJinHuaResource("desk_icon_ready.png", pathTypeInApp))
    self.readyIcon:setPosition(JinHuaTableConfig.spritePlayers[self.CSID].pkX, JinHuaTableConfig.spritePlayers[self.CSID].pkY)
    self.readyIcon:setVisible(false)
end

-- 创建玩家界面
local function createPlayerView(self)
    createPlayerSprite(self)
    --背景
    createPlayerPhotoBg(self)
    createPlayerPhoto(self)
    createPlayerLabelName(self)
    createPlayerLabelCoin(self)
    createPlayerDarkCover(self)
    createJinbiSprite(self)
    createBetedCoinLabel(self)
    createReadyIcon(self)
end

-- 隐藏禁比
function JinHuaTablePlayerEntity:dismissJinbiIcon()
    if self.jinbiSprite:isVisible() then
        self.jinbiSprite:setVisible(false)
        self.jinbiSprite:setScale(2)
    end
end

--设置已压金币数
function JinHuaTablePlayerEntity:setBetCoin()
    self.betedCoinLabel.setBetCoin(self.betCoins)
end

-- 显示禁比动画
function JinHuaTablePlayerEntity:showJinbiAnim()
    if self.noPK then
        self.jinbiSprite:setVisible(true)
        local array = CCArray:create()
        array:addObject(CCScaleTo:create(0.5,1))
        self.jinbiSprite:runAction(CCSequence:create(array))
    end
end

--金币变更 设置金币
function JinHuaTablePlayerEntity:setCoin()
    changeCoinNumOnView(self, self.remainCoins)
end

-- 增加玩家金币数目，在飞金币时用
function JinHuaTablePlayerEntity:addPlayerCoin(addNum)
    local coinNum = string.sub(self.labelCoin:getString(),1,-1)
    local currentShowingRemainCoins = tonumber(coinNum)
    if (currentShowingRemainCoins < self.remainCoins) then
        changeCoinNumOnView(self, currentShowingRemainCoins + addNum)
    else
        self:setCoin()
    end
end

-- 获取当前显示的金币数
function JinHuaTablePlayerEntity:getCurrentShowingCoinNum()
    local coinNum = string.sub(self.labelCoin:getString(),1,-1)
    return tonumber(coinNum)
end

--显示准备Icon
function JinHuaTablePlayerEntity:showReadyIcon()
    self.readyIcon:setVisible(true)
end

--隐藏准备Icon
function JinHuaTablePlayerEntity:hideReadyIcon()
    self.readyIcon:setVisible(false)
end

--获取中心点X坐标
function JinHuaTablePlayerEntity:getCenterX()
    return self:getPositionX()+self:getContentSize().width / 2
end

--获取中心点Y坐标
function JinHuaTablePlayerEntity:getCenterY()
    return self:getPositionY()+self:getContentSize().height / 2
end

--遮盖头像
function JinHuaTablePlayerEntity:setPlayerDarkCoverVisible()
    self.playerDarkCover:setVisible(true)
end

--取消头像遮盖
function JinHuaTablePlayerEntity:setPlayerDarkCoverdGone()
    self.playerDarkCover:setVisible(false)
end

-- 根据性别获取默认头像图片
local function getHeadPhotoTextureBySex(self)
    local texture
    if self.sex == 1 then
        texture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_playerhead1.png", pathTypeInApp))
    else
        texture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_playerhead0.png", pathTypeInApp))
    end
    return texture
end

-- 设置头像
function JinHuaTablePlayerEntity:setPortrait(path)
    local texture
    if path == nil or path == "" then
        texture = getHeadPhotoTextureBySex(self)
    else
        texture = CCTextureCache:sharedTextureCache():addImage(path)
        if texture == nil then
            texture = getHeadPhotoTextureBySex(self)
        end
    end

    if texture ~= nil then
        self.spritePic:setTexture(texture)
    end
end

-- 创建没有被看的牌
local function createNotBeLookedCard(self)
    -- 一定要有，不然会去直接操作元表， 修改的都是同一数据
    self.cardSprites = {}
    for i=1, 3 do
        self.cardSprites[i] = CardSprite()
        self.cardSprites[i]:setAnchorPoint(ccp(0.5, 0))
        self.cardSprites[i]:setPosition(JinHuaTableConfig.spritePlayers[self.CSID].cards[i].locX, JinHuaTableConfig.spritePlayers[self.CSID].cards[i].locY)
        self.cardSprites[i]:setScale(JinHuaTableConfig.cardScale)
    end

    local cardTypePosX, cardTypePosY
    if self.isMe then
        cardTypePosX = JinHuaTableConfig.spritePlayers[self.CSID].cards[2].locX
        cardTypePosY = JinHuaTableConfig.spritePlayers[self.CSID].cards[2].locY-8*JinHuaTableConfig.TableScaleY
        -- 自己的牌的话有角度和大小特殊显示
        JinHuaTableCard.setMyCardScaleAndRotation(self.cardSprites[1], self.cardSprites[2], self.cardSprites[3])
    else
        if self.CSID <= 3 then
            cardTypePosX = JinHuaTableConfig.spritePlayers[self.CSID].cards[2].locX+self.cardSprites[1]:getContentSize().width/4
        else
            cardTypePosX = JinHuaTableConfig.spritePlayers[self.CSID].cards[2].locX-self.cardSprites[1]:getContentSize().width/4
        end
        cardTypePosY = JinHuaTableConfig.spritePlayers[self.CSID].cards[2].locY-20*JinHuaTableConfig.TableScaleY
    end
    self.cardTypeSprite = CCSprite:create(getJinHuaResource("bg_desk_paixing.png",pathTypeInApp))
    self.cardTypeSprite:setAnchorPoint(ccp(0.5, 1))
    self.cardTypeSprite:setPosition(cardTypePosX, cardTypePosY)
    self.cardTypeSprite:setVisible(false)

    self.cardTypeLabel = CCLabelTTF:create("散牌", "Arial", 24)
    self.cardTypeLabel:setColor(ccc3(255, 255, 255))
    self.cardTypeLabel:setAnchorPoint(ccp(0.5, 0.5))
    self.cardTypeLabel:setPosition(self.cardTypeSprite:getContentSize().width/2, self.cardTypeSprite:getContentSize().height/2)
    self.cardTypeSprite:addChild(self.cardTypeLabel)
    for i=1, #self.cardSprites do
        JinHuaTableLogic.getTableParentLayer():addChild(self.cardSprites[i])
    end
    JinHuaTableLogic.getTableParentLayer():addChild(self.cardTypeSprite)
end

-- 设置牌被看了
local function setCardsLooked(self)
    if self.isMe then
        if not self.cardValues then -- 保底方案，看牌状态没牌
            return
        end
        for i=1, table.maxn(self.cardValues) do
            if self.cardValues[i] then
                self.cardSprites[i].setValue(self.cardValues[i])
                self.cardSprites[i].showFront()
            end
        end
    else
        if self.CSID > 3 then -- 在右边
            self.cardSprites[1]:setPosition(JinHuaTableConfig.spritePlayers[self.CSID].cards[3].locX,JinHuaTableConfig.spritePlayers[self.CSID].cards[3].locY)
            self.cardSprites[1]:setRotation(-86)
            self.cardSprites[2]:setPosition(JinHuaTableConfig.spritePlayers[self.CSID].cards[3].locX,JinHuaTableConfig.spritePlayers[self.CSID].cards[3].locY)
            self.cardSprites[2]:setRotation(-43)
        else -- 在左边
            self.cardSprites[2]:setPosition(JinHuaTableConfig.spritePlayers[self.CSID].cards[1].locX,JinHuaTableConfig.spritePlayers[self.CSID].cards[1].locY)
            self.cardSprites[2]:setRotation(43)
            self.cardSprites[3]:setPosition(JinHuaTableConfig.spritePlayers[self.CSID].cards[1].locX,JinHuaTableConfig.spritePlayers[self.CSID].cards[1].locY)
            self.cardSprites[3]:setRotation(86)
        end
    end
end

-- 生成三张牌并添加到层
function JinHuaTablePlayerEntity:createCard()
    if self.status == STATUS_PLAYER_PLAYING then
        createNotBeLookedCard(self)
    end
    -- 看牌
    if self.status == STATUS_PLAYER_LOOKCARD then
        createNotBeLookedCard(self)
        setCardsLooked(self)
    end
end

-- 移除牌
function JinHuaTablePlayerEntity:removeCard(layer)
    if self.cardSprites then
        for i=1, #self.cardSprites do
            layer:removeChild(self.cardSprites[i], true)
            self.cardSprites[i] = nil
        end
    end

    if self.cardTypeSprite then
        layer:removeChild(self.cardTypeSprite, true)
        self.cardTypeSprite = nil
    end
end

-- 添加玩家实体元素到层
function JinHuaTablePlayerEntity:addPlayerElementToLayer(layer)
    layer:addChild(self.mPlayerSprite)
    layer:addChild(self.betedCoinLabel)
    layer:addChild(self.readyIcon)
end

-- 移除玩家实体元素
function JinHuaTablePlayerEntity:removePlayerElementFromLayer(layer)
    layer:removeChild(self.mPlayerSprite, true)
    layer:removeChild(self.betedCoinLabel, true)
    layer:removeChild(self.readyIcon, true)
    self.mPlayerSprite = nil
    self.betedCoinLabel = nil
    self.readyIcon = nil
end

function JinHuaTablePlayerEntity:getPositionX()
    if self.mPlayerSprite ~= nil then
        return self.mPlayerSprite:getPositionX()
    end
end

function JinHuaTablePlayerEntity:getPositionY()
    if self.mPlayerSprite ~= nil then
        return self.mPlayerSprite:getPositionY()
    end
end

function JinHuaTablePlayerEntity:getPosition()
    if self.mPlayerSprite ~= nil then
        return self.mPlayerSprite:getPosition()
    end
end

function JinHuaTablePlayerEntity:getContentSize()
    if self.mPlayerSprite ~= nil then
        return self.mPlayerSprite:getContentSize()
    end
end

function JinHuaTablePlayerEntity:boundingBox()
    if self.mPlayerSprite ~= nil then
        return self.mPlayerSprite:boundingBox()
    end
end

function JinHuaTablePlayerEntity:create(player)
    local self = player
    setmetatable(self, JinHuaTablePlayerEntity)

    createPlayerView(self)
    return self
end

