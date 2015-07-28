module("WanRenJinHuaLogic", package.seeall)
view = nil

local mainLayer = nil -- 游戏层
local menuLayer = nil -- 按钮层

function quitTable()
	sendJHROOMID_MINI_JINHUA_QUIT_GAME()
	mvcEngine.createModule(GameConfig.getTheLastBaseLayer())
end

-- 显示退出框
function showQuitPop()
	if WanRenJinHuaBetArea.isSelfBet then -- 如果下注了
		mvcEngine.createModule(GUI_TABLE_EXIT);
		TableExitLogic.setExitText(TableExitLogic.getTableExitType().WANRENJINHUA_QUIT);
	else
		quitTable()
	end
end

function onKeypad(event)
	if event == "backClicked" then
		showQuitPop()
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化万人金花牌桌
--]]
local function initWanRenJinHuaTable()
	-- 这几个方法执行顺序不可变
	WanRenJinHuaConfig.initTableSizeAndScale() -- 设置缩放比例
	CCEGLView:sharedOpenGLView():setDesignResolutionSize(GameConfig.ScreenWidth, GameConfig.ScreenHeight, kResolutionNoBorder);
	--WanRenJinHuaConfig.preTableFitCoordinate() -- 设置适配属性
	WanRenJinHuaConfig.initWanRenJinHuaConfig()
end

-- 绘制牌桌背景
local function createTableBg(layer)
	local tableBg = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("bg_wanrenjinhua.png", pathTypeInApp))
	tableBg:setAnchorPoint(ccp(0,0))
	tableBg:setPosition(0, 0)
	layer:addChild(tableBg)

	-- 标题下面的底
	local picRect = CCRectMake(0, 0, 30, 116) -- 图片原始大小
	local insetRect = CCRectMake(5,20,20,40)
	local tableBgDi = CCScale9Sprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_wangrenjinhua_dibu2.png"), picRect, insetRect )
	local showSize = CCSizeMake(TableConfig.TableDefaultWidth, WanRenJinHuaConfig.DealerInfoBgHight)
	tableBgDi:setPreferredSize(showSize)
	tableBgDi:setAnchorPoint(ccp(0,1))
	tableBgDi:setPosition(WanRenJinHuaConfig.fitX, WanRenJinHuaConfig.DealerInfoBgTopY)
	layer:addChild(tableBgDi)

	-- 创建选注区背景
	local picRect = CCRectMake(0, 0, 146, 36) -- 图片原始大小
	local insetRect = CCRectMake(40, 10, 60, 10)
	local betCoinGroupBg = CCScale9Sprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_wanrenjinhua_di1.png"), picRect, insetRect )
	local showSize = CCSizeMake(TableConfig.TableDefaultWidth/2+50, 36*TableConfig.TableScaleY)
	betCoinGroupBg:setPreferredSize(showSize)
	betCoinGroupBg:setAnchorPoint(ccp(1,0.5))
	betCoinGroupBg:setPosition(TableConfig.TableDefaultWidth-WanRenJinHuaConfig.fitX, 33.5+WanRenJinHuaConfig.fitY)
	layer:addChild(betCoinGroupBg)
end

-- 由牌桌同步消息显示牌桌结果框
local function showTableResult(data)
	mvcEngine.createModule(GUI_WANRENJINHUA_RESULT)
	WanRenResultPopLogic.setResultData(data["dealerWinCoin"], data["bigWinner"], data["winCoin"])
end

-- 绘制
local function drawWanRenJinHuaTable()
	mainLayer = CCLayer:create()
	menuLayer = CCMenu:create()

	menuLayer:setAnchorPoint(ccp(0,0))
	menuLayer:setPosition(0, 0)
	createTableBg(mainLayer)
	-- 绘制标题
	createWanRenJinHuaTitle(mainLayer)
	local WanRenJinHuaSynDataTable = profile.WanRenJinHua.getWanRenJinHuaSynDataTable()
	WanRenJinHuaConfig.CurrentInning = WanRenJinHuaSynDataTable["inning"]
	WanRenJinHuaConfig.TableStatus = WanRenJinHuaSynDataTable["status"]
	-- 绘制下注区域
	createWanRenJinHuaBetArea(mainLayer, WanRenJinHuaSynDataTable)
	-- 绘制每个注池自己赢得的金币数
	createWanRenJinHuaSelfWinCoinNum(mainLayer, WanRenJinHuaSynDataTable["coins"])
	-- 绘制每个注池自己下注的金币数
	createWanRenJinHuaSelfBetNum(mainLayer, WanRenJinHuaSynDataTable["myBetCoin"])

	-- 绘制牌
	createWanRenJinHuaTableCard(mainLayer, WanRenJinHuaSynDataTable["cardIndex"])
	-- 绘制桌面上已下的筹码
	createWanRenJinHuaTableCoin(mainLayer, WanRenJinHuaSynDataTable["betIndex"])
	-- 绘制选择下注的按钮
	createWanRenJinHuaBetCoin(menuLayer, WanRenJinHuaSynDataTable["chips"])
	-- 绘制个人信息
	createWanRenJinHuaUserInfo(mainLayer, WanRenJinHuaSynDataTable)
	createWanRenJinHuaDealerInfo(mainLayer, WanRenJinHuaSynDataTable)
	-- 按钮
	createWanRenJinHuaMenuButton(menuLayer)
	-- 启动倒计时
	WanRenJinHuaTimer.startTimer(mainLayer, WanRenJinHuaSynDataTable["time"])
	-- 显示结果
	if WanRenJinHuaSynDataTable["status"] == WanRenJinHuaConfig.WanRenJinHuaResultState then
		showTableResult(WanRenJinHuaSynDataTable)
	end
	view:addChild(mainLayer)
	view:addChild(menuLayer)
end

local function mainLayerTouchListener(x, y)
	-- 下注区域点击
	if WanRenJinHuaBetArea.checkAndDoTouchBetAreaCollide(x, y) then
		return
	elseif WanRenJinHuaUserInfo.checkAndDoTouchSelfUserInfoCollide(x, y) then
		return
	elseif WanRenJinHuaDealerInfo.checkAndDoTouchDealerUserInfoCollide(x, y) then
		return
	end
end

local function onTouch(eventType, x, y)
	if eventType == "began" then
		return true
	elseif eventType == "moved" then
	else
		return mainLayerTouchListener(x, y)
	end
end

-- 添加触碰事件
local function addTouchListener()
	mainLayer:registerScriptTouchHandler(onTouch)
	mainLayer:setTouchEnabled(true)
end

-- 开始游戏
local function startGame()
	drawWanRenJinHuaTable()
	addTouchListener()
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("load_res/WanRenJinHua/WanRenJinHua.json")
	local gui = GUI_WANRENJINHUA
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

function createView()
	Common.closeProgressDialog()
	initWanRenJinHuaTable()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)
	GameConfig.setTheCurrentBaseLayer(GUI_WANRENJINHUA)
	startGame()
end

function requestMsg()
end

-- 设置是否响应触碰事件
function setTouchEnable(isCanTouch)
	mainLayer:setTouchEnabled(isCanTouch)
	menuLayer:setEnabled(isCanTouch)
end

-- 清理牌桌
function ClearTable()
	-- 牌
	WanRenJinHuaTableCard.clearCards()
	-- 弹框
	closeWanRenResultPop()
	-- 下注区
	WanRenJinHuaBetArea.clearBetArea()
	-- 筹码
	CoinsOnTable.removeAllCoinsOnTable(mainLayer)
	-- 我的输赢金币数
	WanRenJinHuaSelfWinCoinNum.removeSelfWinCoinNum(mainLayer)
end

-- 下注消息
function processJHGAMEID_MINI_JINHUA_BET()
	local WanRenJinHuaBetDataTable = profile.WanRenJinHua.getWanRenJinHuaBetDataTable()
	if WanRenJinHuaBetDataTable["result"] == 0 then
		Common.showToast(WanRenJinHuaBetDataTable["message"], 2)
		mainLayer:removeChildByTag(WanRenJinHuaBetDataTable["tag"], true)
	else
		WanRenJinHuaUserInfo.updateUserInfo(WanRenJinHuaBetDataTable["surplusCoin"])
		BetCoinGroup.updateBetCoin(WanRenJinHuaBetDataTable["chips"])
		WanRenJinHuaSelfBetNum.updateSelfBetNum(WanRenJinHuaBetDataTable["location"], WanRenJinHuaBetDataTable["betCoins"])
		WanRenJinHuaBetArea.isSelfBet = true
	end
end

-- 发牌消息
function processJHGAMEID_MINI_JINHUA_DEAL()
	WanRenJinHuaBetArea.isBetFull = false
	WanRenJinHuaConfig.TableStatus = WanRenJinHuaConfig.WanRenJinHuaBetState
	ClearTable()
	local WanRenJinHuaDealData = profile.WanRenJinHua.getWanRenJinHuaSendCardDataTable()
	WanRenJinHuaConfig.CurrentInning = WanRenJinHuaDealData["inning"]
	WanRenJinHuaTableCard.sendCard(mainLayer, WanRenJinHuaDealData["cardIndex"])
	BetCoinGroup.updateBetCoin(WanRenJinHuaDealData["chips"])
	sendJHGAMEID_MINI_JINHUA_HISTORY() -- 预加载历史记录
	-- 启动倒计时
	WanRenJinHuaTimer.startTimer(mainLayer, WanRenJinHuaDealData["time"])
end

-- 游戏结果消息
function processJHGAMEID_MINI_JINHUA_RESULT()
	WanRenJinHuaConfig.TableStatus = WanRenJinHuaConfig.WanRenJinHuaResultState
	local WanRenJinHuaResultData = profile.WanRenJinHua.getWanRenJinHuaResultDataTable()
	createWanRenJinHuaSelfWinCoinNum(mainLayer, WanRenJinHuaResultData["coins"])
	WanRenJinHuaTableCard.showCard(WanRenJinHuaResultData["AllJinhuaResult"])
	BetCoinGroup.disableAllBetCoin()
	CoinsOnTable.updateTableCoin(mainLayer, WanRenJinHuaResultData["betIndex"])

	-- 启动倒计时
	WanRenJinHuaTimer.startTimer(mainLayer, WanRenJinHuaResultData["time"])
end

-- 关闭结果框
function closeWanRenResultPop()
	if WanRenResultPopLogic.isShowing then
		mvcEngine.destroyModule(GUI_WANRENJINHUA_RESULT)
	end
end

-- 倒计时消息
function processJHGAMEID_MINI_JINHUA_TIMING()
	local WanRenJinHuaTimingData = profile.WanRenJinHua.getWanRenJinHuaTimerDataTable()
	if WanRenJinHuaTimingData["stage"] == WanRenJinHuaConfig.WanRenJinHuaBetState then -- 阶段 2下注 3结果
		CoinsOnTable.updateTableCoin(mainLayer, WanRenJinHuaTimingData["betIndex"])
	end
end

-- 牌桌同步消息
function processJHGAMEID_MINI_JINHUA_TABLE_SYNC()
	Common.closeProgressDialog()
	mvcEngine.createModule(GUI_WANRENJINHUA)
end

-- 注池满消息推送
function processJHGAMEID_MINI_JINHUA_FULL_CHIPS()
	Common.showToast(profile.WanRenJinHua.getWanRenJinHuaBetFullMessage(), 2)
	WanRenJinHuaBetArea.isBetFull = true
end

-- 更新个人金币数
function updataUserInfo()
	WanRenJinHuaUserInfo.updateUserInfo(profile.User.getSelfCoin());
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end


function addSlot()
	AudioManager.pauseBgMusic();--暂停音乐
	framework.addSlot2Signal(JHGAMEID_MINI_JINHUA_BET, processJHGAMEID_MINI_JINHUA_BET)
	framework.addSlot2Signal(JHGAMEID_MINI_JINHUA_DEAL, processJHGAMEID_MINI_JINHUA_DEAL)
	framework.addSlot2Signal(JHGAMEID_MINI_JINHUA_RESULT, processJHGAMEID_MINI_JINHUA_RESULT)
	framework.addSlot2Signal(JHGAMEID_MINI_JINHUA_TIMING, processJHGAMEID_MINI_JINHUA_TIMING)
	framework.addSlot2Signal(JHGAMEID_MINI_JINHUA_TABLE_SYNC, processJHGAMEID_MINI_JINHUA_TABLE_SYNC)
	framework.addSlot2Signal(JHGAMEID_MINI_JINHUA_FULL_CHIPS, processJHGAMEID_MINI_JINHUA_FULL_CHIPS)
	framework.addSlot2Signal(DBID_USER_INFO, updataUserInfo)
end

-- 移除出了牌桌同步以外的消息处理
function removeSlotExceptTableSync()
	framework.removeSlotFromSignal(JHGAMEID_MINI_JINHUA_BET, processJHGAMEID_MINI_JINHUA_BET)
	framework.removeSlotFromSignal(JHGAMEID_MINI_JINHUA_DEAL, processJHGAMEID_MINI_JINHUA_DEAL)
	framework.removeSlotFromSignal(JHGAMEID_MINI_JINHUA_RESULT, processJHGAMEID_MINI_JINHUA_RESULT)
	framework.removeSlotFromSignal(JHGAMEID_MINI_JINHUA_TIMING, processJHGAMEID_MINI_JINHUA_TIMING)
	framework.removeSlotFromSignal(JHGAMEID_MINI_JINHUA_FULL_CHIPS, processJHGAMEID_MINI_JINHUA_FULL_CHIPS)
	framework.removeSlotFromSignal(DBID_USER_INFO, updataUserInfo)
end

function removeSlot()
	removeSlotExceptTableSync()
	framework.removeSlotFromSignal(JHGAMEID_MINI_JINHUA_TABLE_SYNC, processJHGAMEID_MINI_JINHUA_TABLE_SYNC)

	CCEGLView:sharedOpenGLView():setDesignResolutionSize(GameConfig.ScreenWidth, GameConfig.ScreenHeight, kResolutionExactFit);

	WanRenJinHuaTitle.clearTableTitle()
	WanRenJinHuaUserInfo.closeSchedule()
	WanRenJinHuaTimer.closeTimerSchedule()
	WanRenJinHuaTableCard.clearData()
	WanRenJinHuaSelfWinCoinNum.clear()
	WanRenJinHuaSelfBetNum.clear()
	CoinsOnTable.clearTable()
	AudioManager.resumeBgMusic();--恢复音乐
end

-- 游戏切到前台的时候执行
function doAfterGameRestart()
	if GameConfig.getTheCurrentBaseLayer() == GUI_WANRENJINHUA then
		removeAllSocketMessage()
		AudioManager.pauseBgMusic();--暂停音乐
	end
end