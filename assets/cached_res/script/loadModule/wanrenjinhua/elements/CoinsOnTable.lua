CoinsOnTable = {}

local coinNumTable -- 记录下注数量
local tableCoinEntitys = {} -- 筹码
local tableCoinNumLabels = {} -- 注池筹码数label
local tableCoinNumWanSprite = {} -- 注池筹码数万字精灵
--local coinSpriteBatchNode

-- 新建一个桌上筹码的实例，index哪个注区
local function newWanRenJinHuaTableCoinEntity(layer, index, tableCoinValue)
	local tableCoinEntity = WanRenJinHuaTableCoinEntity(tableCoinValue, WanRenJinHuaConfig.TableCoinRang_Left[index], WanRenJinHuaConfig.TableCoinRang_Right[index], WanRenJinHuaConfig.TableCoinRang_Bottom[index], WanRenJinHuaConfig.TableCoinRang_Top[index])
	tableCoinEntity:setTag(#tableCoinEntitys+1)
--	coinSpriteBatchNode:addChild(tableCoinEntity)
	layer:addChild(tableCoinEntity)
	table.insert(tableCoinEntitys, tableCoinEntity)
end

-- 获取万精灵的x位置
local function getWanSpritePositionX(index)
	return WanRenJinHuaConfig.BetAllNumX[index]+tableCoinNumLabels[index]:getContentSize().width/6
end

-- 创建万字精灵
local function createTableCoinNumWanSprite(layer, index)
	tableCoinNumWanSprite[index] = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_wanrenjinhua_wan.png"))
	tableCoinNumWanSprite[index]:setAnchorPoint(ccp(0, 0.5))
	tableCoinNumWanSprite[index]:setPosition(getWanSpritePositionX(index), WanRenJinHuaConfig.BetAllNumY[index])
	layer:addChild(tableCoinNumWanSprite[index])
end

-- 创建下注总数label
-- layer 被添加的层
-- 位置
-- 金币数目
local function createTableCoinNumLabel(layer, index, coinValue)
	if coinValue > 9999 then
		local text = tonumber(coinValue) / 10000
		tableCoinNumLabels[index] = CCLabelAtlas:create(text, WanRenJinHuaConfig.getWanRenJinHuaResource("num_wanrenjinhua_xiazhu.png"), 276/12, 34, 46)
		tableCoinNumLabels[index]:setAnchorPoint(ccp(0.5, 0.5))
		tableCoinNumLabels[index]:setPosition(WanRenJinHuaConfig.BetAllNumX[index]-tableCoinNumLabels[index]:getContentSize().width/3, WanRenJinHuaConfig.BetAllNumY[index])

		createTableCoinNumWanSprite(layer, index)
	else
		tableCoinNumLabels[index] = CCLabelAtlas:create(tostring(coinValue), WanRenJinHuaConfig.getWanRenJinHuaResource("num_wanrenjinhua_xiazhu.png"), 276/12, 34, 46)
		tableCoinNumLabels[index]:setAnchorPoint(ccp(0.5, 0.5))
		tableCoinNumLabels[index]:setPosition(WanRenJinHuaConfig.BetAllNumX[index], WanRenJinHuaConfig.BetAllNumY[index])
		if coinValue == 0 then
			tableCoinNumLabels[index]:setVisible(false)
		end
	end

	layer:addChild(tableCoinNumLabels[index])
end

-- 更新注池下注数
local function updateTableCoinNumLabel(layer, index, coinValue)
	if coinValue > 9999 then
		local text = tonumber(coinValue) / 10000
		tableCoinNumLabels[index]:setString(tostring(text))
		tableCoinNumLabels[index]:setPosition(WanRenJinHuaConfig.BetAllNumX[index]-tableCoinNumLabels[index]:getContentSize().width/3, WanRenJinHuaConfig.BetAllNumY[index])

		if not tableCoinNumWanSprite[index] then
			createTableCoinNumWanSprite(layer, index)
		else
			tableCoinNumWanSprite[index]:setVisible(true)
			tableCoinNumWanSprite[index]:setPosition(getWanSpritePositionX(index), WanRenJinHuaConfig.BetAllNumY[index])
			tableCoinNumWanSprite[index]:setZOrder(10)
		end
	elseif tonumber(coinValue) == 0 then -- 为0不显示
		tableCoinNumLabels[index]:setVisible(false)
		return
	else
		tableCoinNumLabels[index]:setString(tostring(coinValue))
		tableCoinNumLabels[index]:setPosition(WanRenJinHuaConfig.BetAllNumX[index], WanRenJinHuaConfig.BetAllNumY[index])
	end
	tableCoinNumLabels[index]:setVisible(true)
	tableCoinNumLabels[index]:setZOrder(10)
end

-- 初始化数据
local function initCoinData()
	tableCoinEntitys = {}
	coinNumTable = {0, 0, 0, 0}
end

-- 绘制桌面上已下的金币
-- layer 要加的层
-- 数据
function createWanRenJinHuaTableCoin(layer, data)
	if not data then
		return
	end

	initCoinData() -- 初始化

--	coinSpriteBatchNode = CCSpriteBatchNode:create(Common.getResourcePath("desk_coin_bg.png", pathTypeInApp))
--	layer:addChild(coinSpriteBatchNode)
	for i = 1, 4 do
		local allCoinCount = 0
		if data[i]["betCoin"] then
			local coinNum = #data[i]["betCoin"]
			for j = 1, coinNum do
				newWanRenJinHuaTableCoinEntity(layer, i, data[i]["betCoin"][j].count)
				allCoinCount = allCoinCount + data[i]["betCoin"][j].count
			end
			coinNumTable[i] = coinNum
		end
		createTableCoinNumLabel(layer, i, allCoinCount)
	end
end

-- 更新桌面上已下的金币
-- layer 要加的层
-- 数据
function CoinsOnTable.updateTableCoin(layer, data)
	if not data then
		return
	end

	for i = 1, 4 do
		local allCoinCount = 0
		if data[i]["betCoin"] then
			local coinNum = #data[i]["betCoin"]
			for j = coinNumTable[i]+1, coinNum do
				newWanRenJinHuaTableCoinEntity(layer, i, data[i]["betCoin"][j].count)
			end

			-- 计算下服务器的下注数
			for j = 1, coinNum do
				allCoinCount = allCoinCount + data[i]["betCoin"][j].count
			end

			if coinNum > coinNumTable[i] then
				coinNumTable[i] = coinNum
			end
		end
		updateTableCoinNumLabel(layer, i, allCoinCount)
	end
end

-- 移除掉所有的筹码
function CoinsOnTable.removeAllCoinsOnTable(layer)
	for i=1, #tableCoinEntitys do
		if tableCoinEntitys[i] then
			layer:removeChild(tableCoinEntitys[i], true)
		end
	end

	-- 移除注数
	for i=1, 4 do
		if tableCoinNumLabels[i] then
			tableCoinNumLabels[i]:setVisible(false)
		end
		if tableCoinNumWanSprite[i] then
			tableCoinNumWanSprite[i]:setVisible(false)
		end
	end

	initCoinData()
end

-- 获取金币数量
function CoinsOnTable.getCoinNum()
	return #tableCoinEntitys
end

-- 添加自己下的金币
function CoinsOnTable.addSelfTableCoinEntity(index, tableCoinEntity, coinValue)
	table.insert(tableCoinEntitys, tableCoinEntity)
	coinNumTable[index] = coinNumTable[index] + 1
end

-- 清理牌桌
function CoinsOnTable.clearTable()
	for i=1, #tableCoinNumWanSprite do
		tableCoinNumWanSprite[i] = nil
	end
--	coinSpriteBatchNode = nil
end
