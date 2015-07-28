WanRenJinHuaSelfBetNum = {}

local selfBetNumEntitys = {}
local sefBetNum = {}

-- 自己的下注数
-- layer 要加的层
-- 数据
function createWanRenJinHuaSelfBetNum(layer, data)
	sefBetNum = {0, 0, 0, 0}
	for i = 1, 4 do
		if WanRenJinHuaConfig.TableStatus == WanRenJinHuaConfig.WanRenJinHuaResultState then
			selfBetNumEntitys[i] = WanRenJinHuaSelfBetEntity(0)
			selfBetNumEntitys[i]:setVisible(false)
		else
			if data and data[i] then
				sefBetNum[i] = data[i].count
			end
			selfBetNumEntitys[i] = WanRenJinHuaSelfBetEntity(sefBetNum[i])
			if tonumber(sefBetNum[i]) == 0 then -- 为0的时候不显示
				selfBetNumEntitys[i]:setVisible(false)
			else
				selfBetNumEntitys[i]:setVisible(true)
			end
		end
		selfBetNumEntitys[i]:setAnchorPoint(ccp(0.5, 0.5))
		selfBetNumEntitys[i]:setPosition(WanRenJinHuaConfig.SelfBetNumLabelX[i], WanRenJinHuaConfig.SelfBetNumLabelY[i])
		layer:addChild(selfBetNumEntitys[i])
	end
end

-- 隐藏自己下注数
function WanRenJinHuaSelfBetNum.dismissSelfBetNum()
	for i = 1, #selfBetNumEntitys do
		if selfBetNumEntitys[i] then
			selfBetNumEntitys[i]:setVisible(false)
			sefBetNum = {0, 0, 0, 0}
		end
	end
end

-- 隐藏自己下金币数
local function dismissSelfBetNum(sender)
	sender:setVisible(false)
end

-- 隐藏指定位置的自己下注数
function WanRenJinHuaSelfBetNum.delayDismissSelfBetNumByIndex(index, delayTime)
	if selfBetNumEntitys[index] then
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(delayTime))
		array:addObject(CCCallFuncN:create(dismissSelfBetNum))
		selfBetNumEntitys[index]:runAction(CCSequence:create(array))
		sefBetNum[index] = 0
	end
end

-- 更新自己在某池的下注数
function WanRenJinHuaSelfBetNum.updateSelfBetNum(index, count)
	if selfBetNumEntitys[index] then
		sefBetNum[index] = count
		selfBetNumEntitys[index]:setString("$ "..tostring(count))
		selfBetNumEntitys[index]:setVisible(true)
	end
end

-- 自己在某注池是否下过注
function WanRenJinHuaSelfBetNum.isThisAreaBet(index)
	if tonumber(sefBetNum[index]) > 0 then
		return true
	end
	return false
end

-- 清空
function WanRenJinHuaSelfBetNum.clear()
    selfBetNumEntitys = {}
end