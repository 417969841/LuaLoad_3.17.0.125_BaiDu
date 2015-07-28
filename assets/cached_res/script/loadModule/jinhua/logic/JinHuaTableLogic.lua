module("JinHuaTableLogic", package.seeall)

view = nil

--牌桌layer
local parentLayer = nil
--牌桌信息
local GameData
local forthLayer -- 第四层 存放tips

--初始化数据
local function initData()
    parentLayer = nil
    GameData = nil
    JinHuaTableCard.clear()
    JinHuaTableCoin.clear()
    JinHuaTablePlayer.clear()
    JinHuaTableTips.clear()
    JinHuaTableMyOperation.clear()
end

--初始化
local function initTableConfig()
    initData()
    initTableSizeAndScale()
    -- avoid memory leak
    --	collectgarbage("setpause", 100)
    --	collectgarbage("setstepmul", 5000)
    CCEGLView:sharedOpenGLView():setDesignResolutionSize(JinHuaTableConfig.TableDefaultWidth, JinHuaTableConfig.TableRealHeight, kResolutionNoBorder)
    initTableElmentsCoordinate()
end

-- 更新背包道具数量
local function updateBACKPACK_GOODS_COUNT()
    sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_ID_SUPERIORFACE)
    sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_ID_CHANGECARD)
    sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_ID_NO_PK)
end

function onKeypad(event)
    if event == "backClicked" then
        if JinHuaTableButtonGroup.getIsMenuShow() then
            JinHuaTableButtonGroup.hideMenuBtns()
            return
        end

        if GameData.mySSID then
            JinHuaTableMyOperation.onClick_btnQuit()
        else
            JinHuaTableMyOperation.quitGameRoom()
        end
    elseif event == "menuClicked" then
    end
end


-- 事件监听
local function layerFarmTouchListener(x, y)
    -- 隐藏菜单
    if JinHuaTableButtonGroup.getIsMenuShow() then
        JinHuaTableButtonGroup.hideMenuBtns()
        return
    end
    -- 宝箱点击
    if JinHuaTableTreasure.checkAndDoTableTreasureCollide(x, y) then
        return
    end
    -- 点击玩家区域
    if JinHuaTablePlayer.checkAndDoTablePlayerCollide(x, y) then
        return
    end
end

local function onTouch(eventType, x, y)
    if eventType == "began" then
        return true
    elseif eventType == "moved" then
    else
        return layerFarmTouchListener(x, y)
    end
end

-- create farm
local function createLayerFarm()
    parentLayer = CCLayer:create()
    -- 背景模块
    JinHuaTableBackground.createJinHuaTableBackground(parentLayer)
    -- 玩家模块
    JinHuaTablePlayer.create(parentLayer)
    -- 标题模块
    JinHuaTableTitle.createTitle(parentLayer)
    --金币堆模块
    JinHuaTableCoin.createTableCoins(parentLayer, GameData.chips)
    -- 初始化宝箱模块
    JinHuaTableTreasure.initTableTreasure(parentLayer)

    parentLayer:registerScriptTouchHandler(onTouch)
    parentLayer:setTouchEnabled(true)
    return parentLayer
end

-- 进入牌桌提示
local function enterTablePrompt()
    if GameData.status ~= STATUS_TABLE_WAITTING and GameData.status ~= STATUS_TABLE_READY then
        -- 没有在打牌
        if not profile.JinHuaGameData.isMePlayingThisRound() then
            JinHuaTableTips.showEnterTableTips()
        end
    else
        JinHuaTableMyOperation.onClick_btnReady()
    end
end

local function StartTable()
    JinHuaTableFunctions.preloadTableArmatureData()
    JinHuaTableSound.initJinHuaTableSound()
    GameData = profile.JinHuaGameData.getGameData()

    local sencondLayer = JinHuaTableButtonGroup.createTableMenu()
    local firstLayer = createLayerFarm()
    local thirdLayer = JinHuaPKAnim.createPKLayer()
    forthLayer = CCLayer:create()
    view:addChild(firstLayer)
    view:addChild(sencondLayer)
    view:addChild(thirdLayer)
    view:addChild(forthLayer)
    enterTablePrompt()
    ResumeSocket("Intable")

    -- 新手引导
--    SimulateTableUtil.initSimulateTableView();
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("load_res/JinHua/JinHuaTable.json")
	local gui = GUI_JINHUA_TABLE
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

function createView()
    --	CCDirector:sharedDirector():setDisplayStats(true)
    Common.closeProgressDialog()
    updateBACKPACK_GOODS_COUNT()
--    sendBAOHE_GET_PRO()
    initTableConfig()

    initLayer();
    view:setTag(getDiffTag())
    GameStartConfig.addChildForScene(view)

    GameConfig.setTheCurrentBaseLayer(GUI_JINHUA_TABLE)

    StartTable()

    showRewardMsg()
end

function showRewardMsg()
	local quickStartTable = profile.TableQuickStart.getResultTable()
	if quickStartTable == nil or quickStartTable["IsSend"] == nil or quickStartTable["SendMsg"] == nil then
		return
	end

	if quickStartTable["IsSend"] == 1 and quickStartTable["SendMsg"] ~= "" then
		Common.showToast(quickStartTable["SendMsg"],4)
	end
end

function requestMsg()
end

--接收消息
function resumeSocket()
    ResumeSocket("resumeSocket")
end

-- 获得牌桌绘制层
function getTableParentLayer()
    return parentLayer
end

function getForthLayer()
    return forthLayer
end

--下注数，单注，总注，轮数数值重置
function resetData()
    JinHuaTablePlayer.resetPlayerBetCoin()

    GameData.singleCoin = 0
    GameData.totalPoolCoin = 0
    GameData.round = 0
    JinHuaTableTitle.updateTitle()
    JinHuaTableMyOperation.updateIsCanChangeCardState()
end

-- 在游戏结果后初始化一些数据
local function initGameDataAfterGameResult()
    GameData.status = STATUS_TABLE_READY
    JinHuaTableMyOperation.setAllInValue(nil)
    JinHuaTableButtonGroup.hideChangeCardAnim()
    JinHuaTablePlayer.resetCurrentCSID()
    JinHuaTableTips.initTipsData()
end

function getParentLayer()
    return parentLayer
end

function callback_Panel_table(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消
	end
end

-- 坐下
function processJHID_SIT_DOWN()
    local sitDownData = profile.JinHuaGameData.getSitDownData()
    JinHuaTablePlayer.updateTableSitDownByServer(sitDownData)
end

--弃牌
function processJHID_DISCARD()
    Common.log("processJHID_DISCARD")
    local foldCardData = profile.JinHuaGameData.getFoldCardData()
    JinHuaTablePlayer.updateTableAfterFoldCardByServer(foldCardData)
end

--PK应答
function processJHID_PK()
    PauseSocket("processJHID_PK")
    local PKData = profile.JinHuaGameData.getPKData()
    if PKData["result"] == 0 then
        Common.showToast(PKData["message"], 1)
        ResumeSocket("processJHID_PK")
        return
    end

    JinHuaTableMyOperation.closeScheduleTimer()
    JinHuaPKAnim.startPK(PKData)
    JinHuaTableTitle.updateTitle()
    JinHuaTableMyOperation.updateIsCanChangeCardState()
end

--开牌
function processJHID_SHOW_CARDS()
    PauseSocket("processJHID_SHOW_CARDS")
    local showCardData = profile.JinHuaGameData.getShowCardData()
    showCardData.CSID = profile.JinHuaGameData.getUserCSID(showCardData.seatID)
    JinHuaTableCoin.creatAllInBetCoins(showCardData.CSID, showCardData.thisTimeBetCoins)

    --设置下一个玩家
    JinHuaTablePlayer.refreshCurrentPlayer(showCardData.nextPlayer)
    JinHuaTableTitle.updateTitle()
    JinHuaTableMyOperation.updateIsCanChangeCardState()--更新是否可换牌提示
end

--结果
function processJHID_GAME_RESULT()
    PauseSocket("processJHID_GAME_RESULT")
    initGameDataAfterGameResult()
    JinHuaTableCard.startResultShow()
    JinHuaTableMyOperation.disableAllTableOperationButtons()
    JinHuaTablePlayer.initPlayerNoPKState()
    JinHuaTablePlayer.clearAllTimer()
    sendBAOHE_GET_PRO()
    JinHuaTableSound.playBackgroundMusic()
end

--站起应答
function processJHID_STAND_UP()
    Common.log("processJHID_STAND_UP")
    local standUpData = profile.JinHuaGameData.getStandUpData()
    JinHuaTablePlayer.updateTableAfterStandUpByServer(standUpData)
end

-- 购买商品
function processDBID_PAY_GOODS()
    local resultData = profile.BuyGoods.getBuyGoodsData()
    local result = resultData["result"] --是否成功1是0否
    local resultMsg = resultData["resultMsg"]
    local ItemID = resultData["ItemID"]
    if result == 1 then
        --购买成功，关闭对话框
        updateBACKPACK_GOODS_COUNT()

        -- 弹出换牌界面
        local mySelf = profile.JinHuaGameData.getMySelf()
        if ItemID == GameConfig.ITEM_ID_CHANGECARD and GameData.mySSID and mySelf.cardSprites[1] and mySelf.cardSprites[1].getValue() and not JinHuaPKAnim.isPKLayerShowing() then
            JinHuaTableChangeCardPopLogic.setCardValues(mySelf.cardSprites[1].getValue(),mySelf.cardSprites[2].getValue(),mySelf.cardSprites[3].getValue())
            mvcEngine.createModule(GUI_JINHUA_TABLECHANGECARDPOP)
        end

        -- 自动发送高级表情
        if ItemID == GameConfig.ITEM_ID_SUPERIORFACE_30 or ItemID == GameConfig.ITEM_ID_SUPERIORFACE_7 or ItemID == GameConfig.ITEM_ID_SUPERIORFACE_2 then
            if ChatPopLogic.getSendChatSuperiorPosition() >= 0 then
                sendJHID_CHAT_REQ(TYPE_CHAT_SUPERIOR,""..ChatPopLogic.getSendChatSuperiorPosition())
                ChatPopLogic.clearSendChatSuperiorPosition()
            end
        end
    end
    Common.showToast(resultMsg, 2)
end

--准备应答
function processJHID_READY()
    local readyData = profile.JinHuaGameData.getReadyData()
    JinHuaTablePlayer.updateTableAfterPlayerReadyServerBack(readyData)
end

--聊天应答
function processJHID_CHAT()
    Common.log("processJHID_CHAT")
    local chatMsg = profile.JinHuaGameData.getChatMsg()
    JinHuaTablePlayer.updateTableAfterPlayerChatServerBack(chatMsg)
end

--换桌应答
function processJHID_CHANGE_TABLE()
    Common.log("processJHID_CHANGE_TABLE")
    local changeTable = profile.JinHuaGameData.getChangeTable()
    if changeTable.Result == 0 then
        Common.showToast(changeTable.ResultTxt, 2)
    end
end

--牌桌同步
function processJHID_TABLE_SYNC()
    PauseSocket("processJHID_TABLE_SYNC")
    Common.closeProgressDialog()
    mvcEngine.createModule(GUI_JINHUA_TABLE)
end

--换牌
function processJHID_CHANGE_CARD()
    Common.log("Table..processJHID_CHANGE_CARD : ")
    local changeCardData = profile.JinHuaGameData.getChangeCardData()
    JinHuaTablePlayer.updateTableAfterPlayerChangeCardServerBack(changeCardData)
end

--发牌
function processJHID_INIT_CARDS()
    PauseSocket("processJHID_INIT_CARDS")
    JinHuaTableCard.updateTableAfterSendCardByServer()
end

--[[--
--下注应答
--@param #number bet_type 下注类型
						0   NONE 无任何操作
						1    ANTE 下底注
						2   CALL    跟注
						3   RAISE 加注
						4   ALLIN 全压
						5   PK		比牌
--@param #type bet_coin description
--]]
function processJHID_BET(bet_type, bet_coin)
    PauseSocket("processJHID_BET")
    JinHuaTablePlayer.updateTableAfterBetCoinByServer()
end

-- 获取宝箱进度
function processBAOHE_GET_PRO()
    local baoheTable = profile.JinHuaTableTreasure.getTreasureProTable()
    if baoheTable then
        JinHuaTableTreasure.updateTableTreasureText(baoheTable["Progress"], baoheTable["Max"])
    end
end

-- 获取宝藏
function processBAOHE_GET_TREASURE_V2()
    local baohePrizeTable = profile.JinHuaTableTreasure.getTreasurePrizeTable()
    JinHuaTableTreasure.dismissTreasureLoading()
    if baohePrizeTable["Result"] == 1 then
        JinHuaTableTreasure.updateTableTreasureText(baohePrizeTable["Progress"], baohePrizeTable["Max"])
        JinHuaTableTreasure.showTableTreasureOpenState()
        mvcEngine.createModule(GUI_JINHUA_TABLETREASUREPOP)
        updateBACKPACK_GOODS_COUNT()
    else
        Common.showToast(baohePrizeTable["ResultMsg"], 2)
    end
end

--看牌
function processJHID_LOOK_CARDS()
    Common.log("processJHID_LOOK_CARDS")
    local checkCardData = profile.JinHuaGameData.getCheckCardData()
    Common.log("LookCard CSID="..checkCardData.CSID)
    JinHuaTablePlayer.updateTableAfterLookCardByServer(checkCardData)
end

-- 禁比应答
function processJHID_NO_COMPARE()
    Common.log("processJHID_NO_COMPARE")
    local jinbiTable = profile.JinHuaGameData.getNoPKData()
    JinHuaTablePlayer.updateTableAfterJinbiByServer(jinbiTable)
end

-- 背包物品数量
function processDBID_BACKPACK_GOODS_COUNT()
    local backPackGoodsCountData = profile.JinHuaGameData.getBackPackGoodsCountData()
    if backPackGoodsCountData.ItemID == GameConfig.GOODS_ID_CHANGECARD then
        JinHuaTableButtonGroup.updateChangeCardCountText()
    elseif backPackGoodsCountData.ItemID == GameConfig.GOODS_ID_NO_PK then
        JinHuaTableButtonGroup.updateNoPkCountText()
    end
end

--收到退出牌桌应答
function processJHID_QUIT_TABLE()
    Common.log("收到退出牌桌应答")
    mvcEngine.createModule(GUI_HALL)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
    framework.addSlot2Signal( JHID_BET, processJHID_BET)
    framework.addSlot2Signal( JHID_READY, processJHID_READY)
    framework.addSlot2Signal( JHID_INIT_CARDS, processJHID_INIT_CARDS )
    framework.addSlot2Signal( JHID_LOOK_CARDS, processJHID_LOOK_CARDS )
    framework.addSlot2Signal( JHID_DISCARD , processJHID_DISCARD )
    framework.addSlot2Signal( JHID_PK , processJHID_PK )
    framework.addSlot2Signal( JHID_SHOW_CARDS , processJHID_SHOW_CARDS )
    framework.addSlot2Signal( JHID_GAME_RESULT , processJHID_GAME_RESULT )
    framework.addSlot2Signal( JHID_STAND_UP, processJHID_STAND_UP)
    framework.addSlot2Signal( JHID_SIT_DOWN, processJHID_SIT_DOWN)
    framework.addSlot2Signal( JHID_QUIT_TABLE, processJHID_QUIT_TABLE)
    framework.addSlot2Signal( JHID_CHAT , processJHID_CHAT )
    framework.addSlot2Signal( JHID_CHANGE_TABLE , processJHID_CHANGE_TABLE )
    framework.addSlot2Signal( JHID_TABLE_SYNC , processJHID_TABLE_SYNC )
    framework.addSlot2Signal( JHID_CHANGE_CARD , processJHID_CHANGE_CARD )
    framework.addSlot2Signal( DBID_PAY_GOODS, processDBID_PAY_GOODS)
    framework.addSlot2Signal( BAOHE_GET_PRO, processBAOHE_GET_PRO)
    framework.addSlot2Signal( BAOHE_GET_TREASURE_V2, processBAOHE_GET_TREASURE_V2)
    framework.addSlot2Signal( JHID_NO_COMPARE , processJHID_NO_COMPARE )
    framework.addSlot2Signal( DBID_BACKPACK_GOODS_COUNT, processDBID_BACKPACK_GOODS_COUNT)

--    framework.addSlot2Signal( MANAGERID_GET_JINHUA_USER_GUIDE_PRIZE, UserGuideUtil.userGuidePrizeGetSuccCallBack)
end

function removeSlot()
    changeTableRemoveSlot()
    framework.removeSlotFromSignal(JHID_TABLE_SYNC , processJHID_TABLE_SYNC )

    parentLayer = nil;
    JinHuaTableMyOperation.closeScheduleTimer()
    JinHuaTableTitle.clearTableTitle()
    JinHuaTableSound.stopPlayBackgroundMusic()
    --设置分辨率大小
    CCEGLView:sharedOpenGLView():setDesignResolutionSize(JinHuaTableConfig.TableDefaultWidth, JinHuaTableConfig.TableRealHeight,kResolutionExactFit)
    JinHuaTableButtonGroup.clear();
end

-- 移除除了牌桌同步之外的所有消息
function changeTableRemoveSlot()
    framework.removeSlotFromSignal(JHID_BET , processJHID_BET )
    framework.removeSlotFromSignal(JHID_READY , processJHID_READY )
    framework.removeSlotFromSignal(JHID_INIT_CARDS , processJHID_INIT_CARDS )
    framework.removeSlotFromSignal(JHID_LOOK_CARDS , processJHID_LOOK_CARDS )
    framework.removeSlotFromSignal(JHID_DISCARD , processJHID_DISCARD )
    framework.removeSlotFromSignal(JHID_PK , processJHID_PK )
    framework.removeSlotFromSignal(JHID_SHOW_CARDS , processJHID_SHOW_CARDS )
    framework.removeSlotFromSignal(JHID_GAME_RESULT , processJHID_GAME_RESULT )
    framework.removeSlotFromSignal(JHID_STAND_UP, processJHID_STAND_UP)
    framework.removeSlotFromSignal(JHID_SIT_DOWN, processJHID_SIT_DOWN)
    framework.removeSlotFromSignal(JHID_QUIT_TABLE, processJHID_QUIT_TABLE)
    framework.removeSlotFromSignal(JHID_CHAT , processJHID_CHAT )
    framework.removeSlotFromSignal(JHID_CHANGE_TABLE , processJHID_CHANGE_TABLE )
    framework.removeSlotFromSignal(JHID_CHANGE_CARD , processJHID_CHANGE_CARD )
    framework.removeSlotFromSignal(DBID_PAY_GOODS, processDBID_PAY_GOODS)
    framework.removeSlotFromSignal(BAOHE_GET_PRO, processBAOHE_GET_PRO)
    framework.removeSlotFromSignal(BAOHE_GET_TREASURE_V2, processBAOHE_GET_TREASURE_V2)
    framework.removeSlotFromSignal(JHID_NO_COMPARE , processJHID_NO_COMPARE )
    framework.removeSlotFromSignal(DBID_BACKPACK_GOODS_COUNT, processDBID_BACKPACK_GOODS_COUNT)
--    framework.removeSlotFromSignal(MANAGERID_GET_JINHUA_USER_GUIDE_PRIZE, UserGuideUtil.userGuidePrizeGetSuccCallBack)
end

-- 游戏切到前台的时候执行
function doAfterGameRestart()
    if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
        removeAllSocketMessage()
        sendJHID_TABLE_SYNC()
    end
end