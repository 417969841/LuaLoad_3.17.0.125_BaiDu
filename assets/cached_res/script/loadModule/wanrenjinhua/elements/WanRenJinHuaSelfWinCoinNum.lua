WanRenJinHuaSelfWinCoinNum = {}

local allWinCoinNum = 0 -- 自己赢的金币总数
local selfWinCoinNumEntitys = {} -- 自己赢得的金币数
WanRenJinHuaSelfWinCoinNum.winCountValueTable = {} -- 自己赢的金币

-- 自己的下注数
-- layer 要加的层
-- 数据
function createWanRenJinHuaSelfWinCoinNum(layer, data)
	allWinCoinNum = 0
	for i = 1, 4 do
		local coinCountValue = 0
		if WanRenJinHuaConfig.TableStatus == WanRenJinHuaConfig.WanRenJinHuaResultState then
			if data and data[i] then
				coinCountValue = data[i].count
			else
				coinCountValue = 0
			end
			selfWinCoinNumEntitys[i] = WanRenJinHuaSelfWinCoinNumEntity(coinCountValue)
		else
			selfWinCoinNumEntitys[i] = WanRenJinHuaSelfWinCoinNumEntity(0)
		end
		WanRenJinHuaSelfWinCoinNum.winCountValueTable[i] = coinCountValue
		Common.log("赢金币coinCountValue"..coinCountValue)
		selfWinCoinNumEntitys[i]:setAnchorPoint(ccp(0.5, 0.5))
		selfWinCoinNumEntitys[i]:setPosition(WanRenJinHuaConfig.SelfBetNumLabelX[i], WanRenJinHuaConfig.SelfBetNumLabelY[i])
		selfWinCoinNumEntitys[i]:setVisible(false)
		layer:addChild(selfWinCoinNumEntitys[i])
		allWinCoinNum = allWinCoinNum + coinCountValue
	end
end

-- 显示自己赢金币数
local function showSelfWinNum(sender)
	sender:setVisible(true)
end

-- 显示自己赢金币数
-- delayTime 延时
function WanRenJinHuaSelfWinCoinNum.delayToShowSelfWinNum(index, delayTime)
	Common.log("delayToShowSelfWinNum==============="..index)
	if selfWinCoinNumEntitys[index].getCoinValue() == 0 and not WanRenJinHuaSelfBetNum.isThisAreaBet(index) then -- 输赢为0，并且没有在次下过注
		selfWinCoinNumEntitys[index]:setVisible(false)
		return
	else
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(delayTime))
		array:addObject(CCCallFuncN:create(showSelfWinNum))
		selfWinCoinNumEntitys[index]:runAction(CCSequence:create(array))
	end
end

-- 隐藏自己输赢数
function WanRenJinHuaSelfWinCoinNum.removeSelfWinCoinNum(layer)
	for i = 1, #selfWinCoinNumEntitys do
		if selfWinCoinNumEntitys[i] then
			layer:removeChild(selfWinCoinNumEntitys[i], true)
		end
	end
end

-- 自己赢的金币总数
function WanRenJinHuaSelfWinCoinNum.getAllSelfWinCoinNum()
	return allWinCoinNum
end

function WanRenJinHuaSelfWinCoinNum.clear()
    selfWinCoinNumEntitys = {}
end