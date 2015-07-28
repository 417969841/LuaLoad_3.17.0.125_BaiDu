BetCoinGroup = {}

local WanRenJinHuaBetViewListTable = {} -- 下注UI列表
local WanRenJinHuaBetTransparentBtnTable = {} -- 下注透明按钮
local BetCoinsCount = {} -- 筹码列表
local selectedIndex = -1 -- 选中的位置
local rechargeFuncName = {}; --下注按钮触发充值方法
local betCoinFuncName = {};--下注方法
local menuLayer = nil;--按钮layer

local function onClickBtnWanRenJinHuaBetCoin(index)
	for i = 1, #WanRenJinHuaBetViewListTable do
		if WanRenJinHuaBetViewListTable[i]:isEnabled() then
			if i == index then
				WanRenJinHuaBetViewListTable[i]:selected()
				selectedIndex = index
			else
				WanRenJinHuaBetViewListTable[i]:unselected()
			end
		end
	end
end

--[[
--点击万人金花下注按钮金币不够触发充值引导
--@param #number index 下注下标
--]]
local function onClickBtnWanRenJinHuaRecharge(index)
	CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, BetCoinsCount[index].coinValue * 10, RechargeGuidePositionID.WanRenJinHuaPositionD)
end

function onClickBtnWanRenJinHuaBetCoin_1()
	onClickBtnWanRenJinHuaBetCoin(1)
end

function onClickBtnWanRenJinHuaBetCoin_2()
	onClickBtnWanRenJinHuaBetCoin(2)
end

function onClickBtnWanRenJinHuaBetCoin_3()
	onClickBtnWanRenJinHuaBetCoin(3)
end

function onClickBtnWanRenJinHuaBetCoin_4()
	onClickBtnWanRenJinHuaBetCoin(4)
end

function onClickBtnWanRenJinHuaBetCoin_5()
	onClickBtnWanRenJinHuaBetCoin(5)
end

function onClickBtnWanRenJinHuaRecharge_1()
	onClickBtnWanRenJinHuaRecharge(1)
end

function onClickBtnWanRenJinHuaRecharge_2()
	onClickBtnWanRenJinHuaRecharge(2)
end

function onClickBtnWanRenJinHuaRecharge_3()
	onClickBtnWanRenJinHuaRecharge(3)
end

function onClickBtnWanRenJinHuaRecharge_4()
	onClickBtnWanRenJinHuaRecharge(4)
end

function onClickBtnWanRenJinHuaRecharge_5()
	onClickBtnWanRenJinHuaRecharge(5)
end

--[[--
--初始化方法table
--]]
local function initClickListenerFuncTable()
	rechargeFuncName = {
		onClickBtnWanRenJinHuaRecharge_1,
		onClickBtnWanRenJinHuaRecharge_2,
		onClickBtnWanRenJinHuaRecharge_3,
		onClickBtnWanRenJinHuaRecharge_4,
		onClickBtnWanRenJinHuaRecharge_5
	}
end

local function addClickListener()
	WanRenJinHuaBetViewListTable[1]:registerScriptTapHandler(onClickBtnWanRenJinHuaBetCoin_1)
	WanRenJinHuaBetViewListTable[2]:registerScriptTapHandler(onClickBtnWanRenJinHuaBetCoin_2)
	WanRenJinHuaBetViewListTable[3]:registerScriptTapHandler(onClickBtnWanRenJinHuaBetCoin_3)
	WanRenJinHuaBetViewListTable[4]:registerScriptTapHandler(onClickBtnWanRenJinHuaBetCoin_4)
	WanRenJinHuaBetViewListTable[5]:registerScriptTapHandler(onClickBtnWanRenJinHuaBetCoin_5)
end

-- 初始化
local function initBetCoinGroup()
	WanRenJinHuaBetViewListTable = {}
	WanRenJinHuaBetTransparentBtnTable = {}
	BetCoinsCount = {}
	rechargeFuncName = {};
	betCoinFuncName = {};
	menuLayer = nil;
	selectedIndex = -1
end

--[[-
--设置透明的点击按钮
--]]
local function setWanRenJinHuaBetTransparentBtn(index)
	if WanRenJinHuaBetTransparentBtnTable[index] == nil  then
		WanRenJinHuaBetTransparentBtnTable[index] = BetCoinEntity.TransparentBetBtn();
		WanRenJinHuaBetTransparentBtnTable[index]:registerScriptTapHandler(rechargeFuncName[index])
		WanRenJinHuaBetTransparentBtnTable[index]:setAnchorPoint(ccp(0.5, 0))
		WanRenJinHuaBetTransparentBtnTable[index]:setPosition(WanRenJinHuaConfig.BetCoinStartX - (#BetCoinsCount - index)*WanRenJinHuaConfig.BetCoinDistance, WanRenJinHuaConfig.BetCoinStartY)
		menuLayer:addChild(WanRenJinHuaBetTransparentBtnTable[index])
	end
	WanRenJinHuaBetTransparentBtnTable[index]:setEnabled(true);
end

--[[-
--移除透明的点击按钮
--]]
local function removeWanRenJinHuaBetTransparentBtn(index)
	if WanRenJinHuaBetTransparentBtnTable[index] ~= nil then
		WanRenJinHuaBetTransparentBtnTable[index]:setEnabled(false);
		WanRenJinHuaBetTransparentBtnTable[index]:unregisterScriptTapHandler();
		menuLayer:removeChild(WanRenJinHuaBetTransparentBtnTable[index],true)
		WanRenJinHuaBetTransparentBtnTable[index] = nil;
	end
end

-- 创建可下注列表
local function createBetCoin(data)
	if not data then
		return
	end

	local maxCanBet = 1 -- 最大可下的筹码
	local betCoinNum = #data
	BetCoinsCount = data;
	for i = 1, betCoinNum do
		if not WanRenJinHuaBetViewListTable[i] then
			local betCoinValue = data[i].coinValue
			WanRenJinHuaBetViewListTable[i] = BetCoinEntity.createBetCoinEntity(betCoinValue)
		end
		if data[i].isCanBet == 0 then
			WanRenJinHuaBetViewListTable[i]:setEnabled(false)
			if WanRenJinHuaConfig.TableStatus == WanRenJinHuaConfig.WanRenJinHuaBetState then
				--下注阶段,则创建透明按钮
				setWanRenJinHuaBetTransparentBtn(i);
			else
				removeWanRenJinHuaBetTransparentBtn(i);
			end
		else
			WanRenJinHuaBetViewListTable[i]:setEnabled(true)
			maxCanBet = i
		end
	end
	if WanRenJinHuaBetViewListTable[maxCanBet] and data[maxCanBet].isCanBet == 1 then
		WanRenJinHuaBetViewListTable[maxCanBet]:selected()
		selectedIndex = maxCanBet
	end
end

-- 绘制下注列表
-- layer 要加的层
-- 数据
function createWanRenJinHuaBetCoin(layer, data)
	if not data then
		return
	end

	initBetCoinGroup()
	menuLayer = layer;
	initClickListenerFuncTable();
	createBetCoin(data)
	local betCoinNum = #data
	for i = 1, betCoinNum do
		WanRenJinHuaBetViewListTable[i]:setAnchorPoint(ccp(0.5, 0))
		WanRenJinHuaBetViewListTable[i]:setPosition(WanRenJinHuaConfig.BetCoinStartX - (betCoinNum - i)*WanRenJinHuaConfig.BetCoinDistance, WanRenJinHuaConfig.BetCoinStartY)
		layer:addChild(WanRenJinHuaBetViewListTable[i])
	end

	addClickListener()
end

-- 更新可下注列表
function BetCoinGroup.updateBetCoin(data)
	if not data then
		return
	end

	local maxCanBet = -1 -- 最大可下的筹码
	local betCoinNum = #data
	for i = 1, betCoinNum do
		if data[i].isCanBet == 0 then
			WanRenJinHuaBetViewListTable[i]:setEnabled(false)
			setWanRenJinHuaBetTransparentBtn(i);
		else
			WanRenJinHuaBetViewListTable[i]:setEnabled(true)
			removeWanRenJinHuaBetTransparentBtn(i);
			maxCanBet = i
		end
	end

	-- 如果之前选中的注不可下了
	if not WanRenJinHuaBetViewListTable[selectedIndex] or data[selectedIndex].isCanBet == 0 then
		if WanRenJinHuaBetViewListTable[maxCanBet] and data[maxCanBet].isCanBet == 1 then
			WanRenJinHuaBetViewListTable[maxCanBet]:selected()
		end
		selectedIndex = maxCanBet
	else
		WanRenJinHuaBetViewListTable[selectedIndex]:selected()
	end
end

-- 得到选中的筹码值
function BetCoinGroup.getSelectedBetCoinValue()
	local coinValue = 0;
	if selectedIndex ~= -1 then
		coinValue = BetCoinsCount[selectedIndex].coinValue
	end
	return coinValue;
end

-- 使所有下注按钮不可用
function BetCoinGroup.disableAllBetCoin()
	for i = 1, #WanRenJinHuaBetViewListTable do
		if WanRenJinHuaBetViewListTable[i] then
			WanRenJinHuaBetViewListTable[i]:setEnabled(false)
		end
		if WanRenJinHuaBetTransparentBtnTable[i] ~= nil then
			removeWanRenJinHuaBetTransparentBtn(i);
		end
	end
end

-- 获取index位置的下注按钮的x坐标
function BetCoinGroup.getBetCoinPosX()
	return WanRenJinHuaBetViewListTable[selectedIndex]:getPositionX()
end
