module("JinHuaTableTreasure", package.seeall)

local tableTreasureCloseSprite -- 关闭状态
local tableTreasureOpenSprite -- 打开状态
local tableTreasureLabel -- 宝箱文字
local isTableTreasureCanOpen = false -- 宝箱是否可以打开
local loadingAnimSprite -- loading
local tableTreasureX -- 宝箱位置
local tableTreasureY
local tableTreasurePro -- 还差多少局可开启

-- loading旋转动画
local function runLoadingAnim()
	local loadingAnimTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("loading_small.png", pathTypeInApp))
	loadingAnimSprite = CCSprite:createWithTexture(loadingAnimTexture)
	loadingAnimSprite:setAnchorPoint(ccp(0.5, 0.5))
	loadingAnimSprite:setPosition(ccp(tableTreasureCloseSprite:getContentSize().width/2, tableTreasureCloseSprite:getContentSize().height/2))
	tableTreasureCloseSprite:addChild(loadingAnimSprite)
	local loadingRotateAnim = CCRotateBy:create(1.5, 360)

	loadingAnimSprite:runAction(CCRepeatForever:create(loadingRotateAnim))
	loadingAnimSprite:setVisible(false)
end

-- 创建牌桌宝箱关闭状态
local function createTableTreasureCloseSprite(tableParentLayer)
	local tableTreasureCloseTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("paizhuo_treasure0.png", pathTypeInApp))
	tableTreasureCloseSprite = CCSprite:createWithTexture(tableTreasureCloseTexture)
	tableTreasureCloseSprite:setAnchorPoint(ccp(0.5, 0.5))
	tableTreasureCloseSprite:setPosition(tableTreasureX, tableTreasureY)
	runLoadingAnim()
	tableParentLayer:addChild(tableTreasureCloseSprite)
end

-- 创建牌桌宝箱开启状态
local function createTableTreasureOpenSprite(tableParentLayer)
	local tableTreasureOpenTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("paizhuo_treasure1.png", pathTypeInApp))
	tableTreasureOpenSprite = CCSprite:createWithTexture(tableTreasureOpenTexture)
	tableTreasureOpenSprite:setAnchorPoint(ccp(0.5, 0.5))
	tableTreasureOpenSprite:setPosition(tableTreasureX, tableTreasureY)
	tableParentLayer:addChild(tableTreasureOpenSprite)
end

-- 创建宝箱文字
local function createTableTreasureText(tableParentLayer)
--	tableTreasureLabel = CCLabelTTF:create("0/20", "Arial", 24)
	tableTreasureLabel = CCLabelAtlas:create("2142", getJinHuaResource("desk_atlas_2.png"), 24, 31, 48)
--	tableTreasureLabel:setColor(ccc3(255, 255, 255))
	tableTreasureLabel:setAnchorPoint(ccp(0.5, 1))
	tableTreasureLabel:setPosition(JinHuaTableConfig.TableDefaultWidth *33*JinHuaTableConfig.TableScaleX / 800 + JinHuaTableConfig.fitX, JinHuaTableConfig.TableDefaultHeight*23*JinHuaTableConfig.TableScaleY/480 + JinHuaTableConfig.fitY)
	tableTreasureLabel:setScale(0.8)
	tableParentLayer:addChild(tableTreasureLabel)
end

function initTableTreasure(tableParentLayer)
	isTableTreasureCanOpen = false
	tableTreasureX = JinHuaTableConfig.TableDefaultWidth * 30 / 800 * JinHuaTableConfig.TableScaleX + JinHuaTableConfig.fitX
	tableTreasureY = JinHuaTableConfig.TableDefaultHeight * 37 / 480 * JinHuaTableConfig.TableScaleY + JinHuaTableConfig.fitY
	createTableTreasureOpenSprite(tableParentLayer)
	createTableTreasureCloseSprite(tableParentLayer)
	createTableTreasureText(tableParentLayer)
	showTableTreasureCloseState()
end

-- 停止宝箱震动动画
local function stopShakeAnim()
	tableTreasureCloseSprite:cleanup()
	--设回原来的位置
	tableTreasureCloseSprite:setPosition(tableTreasureX, tableTreasureY)
end

-- 开始宝箱震动动画
local function startShakeAnim()
	local array = CCArray:create()
	array:addObject(CCMoveBy:create(0.05,ccp(3,0)))
	array:addObject(CCMoveBy:create(0.05,ccp(-6,0)))
	array:addObject(CCMoveBy:create(0.05,ccp(3,0)))
	array:addObject(CCDelayTime:create(1.0))
	tableTreasureCloseSprite:runAction(CCRepeatForever:create(CCSequence:create(array)))
end

-- 显示宝箱loading
function showTreasureLoading()
	loadingAnimSprite:setVisible(true)
end

-- 隐藏宝箱loading
function dismissTreasureLoading()
	loadingAnimSprite:setVisible(false)
end

function getTableTreasureCloseSprite()
	return tableTreasureCloseSprite
end

-- 更新宝箱的进度
function updateTableTreasureText(treasurePro, treasureMax)

	local mTreasurePro = ""
	for i = 1,string.len(treasurePro) do
		local subValue = string.sub(treasurePro,i,i) + 2
		if subValue == 10 then
			subValue = ":"
		elseif subValue == 11 then
			subValue = ";"
		end
		mTreasurePro = mTreasurePro .. subValue
	end

	local mTreasureMax = ""
	for i = 1,string.len(treasureMax) do
		local subValue = string.sub(treasureMax,i,i) + 2
		if subValue == 10 then
			subValue = ":"
		elseif subValue == 11 then
			subValue = ";"
		end
		mTreasureMax = mTreasureMax .. subValue
	end
	tableTreasureLabel:setString(mTreasurePro.."1"..mTreasureMax)

	if treasureMax ~= 0 and treasurePro >= treasureMax then
		if not isTableTreasureCanOpen then
			isTableTreasureCanOpen = true
			startShakeAnim()
		end
	else
		if isTableTreasureCanOpen then
			stopShakeAnim()
			isTableTreasureCanOpen = false
		end
		tableTreasurePro = treasureMax - treasurePro
	end
end

-- 显示打开状态
function showTableTreasureOpenState()
	tableTreasureOpenSprite:setVisible(true)
	tableTreasureCloseSprite:setVisible(false)
	tableTreasureLabel:setVisible(false)
end

-- 显示关闭状态
function showTableTreasureCloseState()
	tableTreasureOpenSprite:setVisible(false)
	tableTreasureCloseSprite:setVisible(true)
	tableTreasureLabel:setVisible(true)
end

--[[--
隐藏宝箱
]]
function hide()
    tableTreasureOpenSprite:setVisible(false);
    tableTreasureCloseSprite:setVisible(false);
    tableTreasureLabel:setVisible(false);
end

-- 宝箱碰撞检测并执行相关碰撞
-- 碰撞返回true 否则返回false
function checkAndDoTableTreasureCollide(x, y)
	-- 宝箱点击
	if tableTreasureCloseSprite:boundingBox():containsPoint(ccp(x,y)) then
		if isTableTreasureCanOpen then
			showTreasureLoading()
			sendBAOHE_GET_TREASURE_V2()
		else
			Common.showToast("局数不足,还不能开启!", 2)
		end
		return true
	end
	return false
end