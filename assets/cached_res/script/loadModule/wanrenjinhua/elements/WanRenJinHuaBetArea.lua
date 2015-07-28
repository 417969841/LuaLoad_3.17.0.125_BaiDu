WanRenJinHuaBetArea = {}

WanRenJinHuaBetArea.isBetFull = false -- 注池是否已满
WanRenJinHuaBetArea.isSelfBet = false -- 本局自己是否下过注

local tableBetAreaSprites = {}
local mainLayer
local winAnimSprite = {} -- 输赢动画

-- 绘制下注区域
-- layer 要加的层
-- 数据
function createWanRenJinHuaBetArea(layer, data)
	mainLayer = layer

	-- 是否压满状态
	if data["isBetFull"] == 1 then
		Common.showToast(data["betFullMessage"], 2)
		WanRenJinHuaBetArea.isBetFull = true
	else
		WanRenJinHuaBetArea.isBetFull = false
	end

	for i = 1, 4 do
		tableBetAreaSprites[i] = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ic_wanrenjinhua_xiazhu"..i..".png"))
		tableBetAreaSprites[i]:setAnchorPoint(ccp(0.5, 0.5))
		tableBetAreaSprites[i]:setPosition(WanRenJinHuaConfig.BetAreaX[i], WanRenJinHuaConfig.BetAreaY[i])
		mainLayer:addChild(tableBetAreaSprites[i])

		-- 输赢动画
		winAnimSprite[i] = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("bg_wanrenjinhua_xiazhu_zhezhao.png"))
		winAnimSprite[i]:setPosition(WanRenJinHuaConfig.BetAreaX[i], WanRenJinHuaConfig.BetAreaY[i])

		local animation = CCAnimation:create()
		animation:addSpriteFrameWithFileName(WanRenJinHuaConfig.getWanRenJinHuaResource("bg_wanrenjinhua_xiazhu_zhezhao.png"))
		animation:addSpriteFrameWithFileName(WanRenJinHuaConfig.getWanRenJinHuaResource("touming_bg.png"))
		animation:setDelayPerUnit(0.3)
		winAnimSprite[i]:runAction( CCRepeatForever:create( CCAnimate:create(animation) ) )
		winAnimSprite[i]:setVisible(false)
		mainLayer:addChild(winAnimSprite[i])
	end
end

-- 显示赢动画
local function showWinAnim(sender)
	sender:setVisible(true)
end

-- 开始赢动画
-- 位置
-- 延迟时间
function WanRenJinHuaBetArea.startWinAnim(index, delayTime)
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(delayTime))
	array:addObject(CCCallFuncN:create(showWinAnim))
	winAnimSprite[index]:runAction(CCSequence:create(array))
end

--充值引导
local function showRechargeGuide()
	if WanRenJinHuaUserInfo.getUserCoin() >= 10000 then
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 10000, RechargeGuidePositionID.WanRenJinHuaPositionC)
	else
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 10000, RechargeGuidePositionID.WanRenJinHuaPositionB)
	end
end

-- 下注
local function selfBetCoin(index)
	if BetCoinGroup.getSelectedBetCoinValue() ~= 0 then
		WanRenJinHuaSound.playEffectMusic(WanRenJinHuaSound.SOUND_BET)
		local wanRenJinHuaTableCoinEntity = WanRenJinHuaTableCoinEntity(BetCoinGroup.getSelectedBetCoinValue(), WanRenJinHuaConfig.TableCoinRang_Left[index], WanRenJinHuaConfig.TableCoinRang_Right[index], WanRenJinHuaConfig.TableCoinRang_Bottom[index], WanRenJinHuaConfig.TableCoinRang_Top[index])
		local startX = BetCoinGroup.getBetCoinPosX()
		local startY = 33.5
		local endX = wanRenJinHuaTableCoinEntity:getPositionX()
		local endY = wanRenJinHuaTableCoinEntity:getPositionY()
		wanRenJinHuaTableCoinEntity:setPosition(startX, startY)
		wanRenJinHuaTableCoinEntity:setTag(CoinsOnTable.getCoinNum()+1)
		mainLayer:addChild(wanRenJinHuaTableCoinEntity)
		CoinsOnTable.addSelfTableCoinEntity(index, wanRenJinHuaTableCoinEntity, BetCoinGroup.getSelectedBetCoinValue())
		wanRenJinHuaTableCoinEntity:runAction(CCMoveTo:create(0.3, ccp(endX, endY)))
		sendJHGAMEID_MINI_JINHUA_BET(WanRenJinHuaConfig.CurrentInning, index, BetCoinGroup.getSelectedBetCoinValue(), CoinsOnTable.getCoinNum())
	else
		showRechargeGuide()
	end
end

-- 清理
function WanRenJinHuaBetArea.clearBetArea()
	for i=1, #winAnimSprite do
		winAnimSprite[i]:setVisible(false)
	end
end

-- 检测并执行点击下注区域碰撞检测
function WanRenJinHuaBetArea.checkAndDoTouchBetAreaCollide(x, y)
	if WanRenJinHuaConfig.TableStatus == WanRenJinHuaConfig.WanRenJinHuaResultState then
		return false
	end
	if WanRenJinHuaBetArea.isBetFull then -- 如果下满了
		Common.showToast(profile.WanRenJinHua.getWanRenJinHuaBetFullMessage(), 2)
		return false
	end

	for i=1, #tableBetAreaSprites do
		if tableBetAreaSprites[i] then
			if tableBetAreaSprites[i]:boundingBox():containsPoint(ccp(x,y)) then
				selfBetCoin(i)
				return true
			end
		end
	end
	return false
end
