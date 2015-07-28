--menu
MENU_ID_CARDTYPE = 1
MENU_ID_SET = 2
MENU_ID_CHANGETABLE = 3
MENU_ID_STANDUP = 4
MENU_ID_STANDUP_NEXTROUND = 5
MENU_ID_QUIT = 6
CHECK_BOX_NEXT_ROUND_STAND_UP = 7 -- 下局站起旁观单选框
-- pk
BTN_ID_PK = 8
BTN_ID_PK_2 = 9
BTN_ID_PK_3 = 10
BTN_ID_PK_4 = 11
BTN_ID_PK_5 = 12
BTN_ID_PK_CANCEL = 13
BTN_ID_NOPK = 14
-- 加注
BTN_ID_RAISE_1 = 15
BTN_ID_RAISE_2 = 16
BTN_ID_RAISE_3 = 17
BTN_ID_RAISE_4 = 18
BTN_ID_RAISE_ALL = 19
BTN_ID_RAISE_CANCEL = 20
BTN_ID_RAISE = 21
BTN_ID_ALLIN = 22
--坐下
BTN_SIT_ID_1 = 23
BTN_SIT_ID_2 = 24
BTN_SIT_ID_3 = 25
BTN_SIT_ID_4 = 26
BTN_SIT_ID_5 = 27
--加注文本
TEXT_ID_RAISE_1 = 28
TEXT_ID_RAISE_2 = 29
TEXT_ID_RAISE_3 = 30
TEXT_ID_RAISE_4 = 31
-- groupBtnTable
BTN_ID_FOLD = 32 --弃牌
BTN_ID_CHECK = 33 -- 看牌
BTN_ID_CALL = 34 -- 跟注
BTN_ID_READY = 35 -- 准备
BTN_ID_RECHARGE = 36 -- 充值
BTN_ID_CHAT = 37 --聊天
BTN_ID_CHANGECARD = 38 -- 换牌
BTN_ALWAYS_BET_COIN = 39 -- 押到底
CHECK_BOX_ALWAYS_BET = 40 -- 押到底单选框

JinHuaTableButtonGroup = {}
local buttonGroupSprite
local groupBtnTable = {} -- 总按钮组

--放弃,比牌,看牌,加注,跟注,跟到底
local foldText, pkText, checkText, raiseText, callText, allInText, alwaysBetCoinText
--菜单，牌型，设置，换桌，站起旁观，退出
local btnMenu,btnMenuSelect
--按钮坐标
local btnStandUp_LocX,btnStandUp_LocY,btnQuit_LocX,btnQuit_LocY
local duihaoBgTexture, duihaoTexture
local changeCardCountText, noPKCountText -- 换牌卡，禁比卡数量文本
local changeCardCountTextBg, noPKCountTextBg
-- 换牌动画提示
local changeCardClickPromptAnim = nil

local changeCardButtonLocX -- 换牌按钮位置
local changeCardButtonLocY
local rechargeButtonLocY -- 充值按钮位置
local layerMenu

--放大缩小PK按钮
local function blinkPK(button)
	local scale1 = CCScaleTo:create(0.5,0.8)
	local scale2 = CCScaleTo:create(0.5,1.0)
	local sequence = CCSequence:createWithTwoActions(scale1,scale2)
	button:runAction(CCRepeatForever:create(sequence))
end

--隐藏菜单按钮
function JinHuaTableButtonGroup.hideMenuBtns()
	groupBtnTable[MENU_ID_CARDTYPE]:setVisible(false)
	groupBtnTable[MENU_ID_SET]:setVisible(false)
	groupBtnTable[MENU_ID_CHANGETABLE]:setVisible(false)
	groupBtnTable[MENU_ID_STANDUP]:setVisible(false)
	groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:setVisible(false)
	groupBtnTable[MENU_ID_QUIT]:setVisible(false)
	groupBtnTable[BTN_SIT_ID_4]:setEnabled(true)
	groupBtnTable[BTN_SIT_ID_5]:setEnabled(true)
	groupBtnTable[BTN_ID_CHANGECARD]:setEnabled(true)
	groupBtnTable[BTN_ID_NOPK]:setEnabled(true)
	btnMenu:setVisible(true)
	btnMenu:setEnabled(true)
	btnMenuSelect:setVisible(false)
	btnMenuSelect:setEnabled(false)
end

local function callBack_showSprite(sender)
	sender:setVisible(true)
end

--显示菜单按钮
local function showMenuBtns()
	Common.setUmengUserDefinedInfo("table_inner_btn_click", "菜单箭头")
	groupBtnTable[BTN_ID_CHANGECARD]:setEnabled(false)
	groupBtnTable[BTN_ID_NOPK]:setEnabled(false)
	groupBtnTable[BTN_SIT_ID_4]:setEnabled(false)
	groupBtnTable[BTN_SIT_ID_5]:setEnabled(false)
	--CCCallFuncN:create(callBack)回调的参数即调用此action的控件
	local array = CCArray:create()
	array:addObject(CCCallFuncN:create(callBack_showSprite))
	array:addObject(CCFadeIn:create(0.1))
	groupBtnTable[MENU_ID_CARDTYPE]:runAction(CCSequence:create(array))

	array = CCArray:create()
	array:addObject(CCDelayTime:create(0.025))
	array:addObject(CCCallFuncN:create(callBack_showSprite))
	array:addObject(CCFadeIn:create(0.1))
	groupBtnTable[MENU_ID_SET]:runAction(CCSequence:create(array))

	array = CCArray:create()
	array:addObject(CCDelayTime:create(0.05))
	array:addObject(CCCallFuncN:create(callBack_showSprite))
	array:addObject(CCFadeIn:create(0.1))
	groupBtnTable[MENU_ID_CHANGETABLE]:runAction(CCSequence:create(array))

	local gameData = profile.JinHuaGameData.getGameData()
	if gameData and gameData.mySSID then
		--如果已经坐下，显示站起按钮
		array = CCArray:create()
		array:addObject(CCDelayTime:create(0.075))
		array:addObject(CCCallFuncN:create(callBack_showSprite))
		array:addObject(CCFadeIn:create(0.1))
		groupBtnTable[MENU_ID_STANDUP]:runAction(CCSequence:create(array))

		array = CCArray:create()
		array:addObject(CCDelayTime:create(0.075))
		array:addObject(CCCallFuncN:create(callBack_showSprite))
		array:addObject(CCFadeIn:create(0.1))
		groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:runAction(CCSequence:create(array))

		groupBtnTable[MENU_ID_QUIT]:setPosition(btnQuit_LocX,btnQuit_LocY)
		array = CCArray:create()
		array:addObject(CCDelayTime:create(0.1))
		array:addObject(CCCallFuncN:create(callBack_showSprite))
		array:addObject(CCFadeIn:create(0.1))
		groupBtnTable[MENU_ID_QUIT]:runAction(CCSequence:create(array))
	else
		groupBtnTable[MENU_ID_QUIT]:setPosition(btnStandUp_LocX,btnStandUp_LocY)
		array = CCArray:create()
		array:addObject(CCDelayTime:create(0.075))
		array:addObject(CCCallFuncN:create(callBack_showSprite))
		array:addObject(CCFadeIn:create(0.1))
		groupBtnTable[MENU_ID_QUIT]:runAction(CCSequence:create(array))
	end
end

--播放换牌按钮动画
local function addChangeCardClickPromptAnim()
	--    然后创建armature类，并将进行初始化
	changeCardClickPromptAnim = CCArmature:create("change_card_click_prompt_anim")
	--    然后选择播放动画0，并进行缩放和位置设置
	changeCardClickPromptAnim:getAnimation():playByIndex(0)
	changeCardClickPromptAnim:setAnchorPoint(ccp(0.5,0.5))
	changeCardClickPromptAnim:setPosition(groupBtnTable[BTN_ID_CHANGECARD]:getContentSize().width/2,groupBtnTable[BTN_ID_CHANGECARD]:getContentSize().height/2)
	groupBtnTable[BTN_ID_CHANGECARD]:addChild(changeCardClickPromptAnim)
	changeCardClickPromptAnim:setVisible(false)
end

--获取当前菜单显示状态
function JinHuaTableButtonGroup.getIsMenuShow()
	if groupBtnTable[MENU_ID_CARDTYPE] ~= nil and groupBtnTable[MENU_ID_CARDTYPE]:isVisible() then
		return true
	else
		return false
	end
end

local function onClick_btnMenu()
    -- 新手引导
--    if UserGuideUtil.isUserGuide == true then
--        Common.showToast("您需要完成新手引导才能体验更多功能哦！", 2);
--        return;
--    end

	if groupBtnTable[MENU_ID_CARDTYPE]:isVisible() then
		JinHuaTableButtonGroup.hideMenuBtns()
	else
		btnMenu:setVisible(false)
		btnMenu:setEnabled(false)
		btnMenuSelect:setVisible(true)
		btnMenuSelect:setEnabled(true)
		showMenuBtns()
	end
end

local function onClick_btnMenuSelect()
	if groupBtnTable[MENU_ID_CARDTYPE]:isVisible() then
		JinHuaTableButtonGroup.hideMenuBtns()
		btnMenu:setVisible(true)
		btnMenu:setEnabled(true)
		btnMenuSelect:setVisible(false)
		btnMenuSelect:setEnabled(false)
	else
		showMenuBtns()
	end
end

-- 添加按钮事件
local function addBtnCallBack()
	groupBtnTable[BTN_ID_READY]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnReady)
	groupBtnTable[BTN_ID_FOLD]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnFold)
	groupBtnTable[BTN_ID_CHECK]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnCheck)
	groupBtnTable[BTN_ID_CALL]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnCall)
	groupBtnTable[BTN_ALWAYS_BET_COIN]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnAlwaysBetCoin)
	groupBtnTable[BTN_ID_RAISE]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnRaise)
	groupBtnTable[BTN_ID_ALLIN]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnAllIn)
	groupBtnTable[BTN_ID_PK]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnPK)
	groupBtnTable[BTN_ID_PK_2]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnPK_2)
	groupBtnTable[BTN_ID_PK_3]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnPK_3)
	groupBtnTable[BTN_ID_PK_4]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnPK_4)
	groupBtnTable[BTN_ID_PK_5]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnPK_5)
	groupBtnTable[BTN_ID_PK_CANCEL]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnPK_Cancel)
	groupBtnTable[BTN_ID_RAISE_ALL]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnRaise_All)
	groupBtnTable[BTN_ID_RAISE_1]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnRaise_1)
	groupBtnTable[BTN_ID_RAISE_2]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnRaise_2)
	groupBtnTable[BTN_ID_RAISE_3]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnRaise_3)
	groupBtnTable[BTN_ID_RAISE_4]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnRaise_4)
	groupBtnTable[BTN_ID_RAISE_CANCEL]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnRaise_Cancel)

	groupBtnTable[BTN_SIT_ID_1]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnSit_1)
	groupBtnTable[BTN_SIT_ID_2]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnSit_2)
	groupBtnTable[BTN_SIT_ID_3]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnSit_3)
	groupBtnTable[BTN_SIT_ID_4]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnSit_4)
	groupBtnTable[BTN_SIT_ID_5]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnSit_5)

	groupBtnTable[MENU_ID_CARDTYPE]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnCardType)
	groupBtnTable[MENU_ID_SET]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnSet)
	groupBtnTable[MENU_ID_CHANGETABLE]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnChangeTable)
	groupBtnTable[MENU_ID_STANDUP]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnStandUp)
	groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnStandUpNextRound)
	groupBtnTable[MENU_ID_QUIT]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnQuit)

	groupBtnTable[BTN_ID_RECHARGE]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnRecharge)
	groupBtnTable[BTN_ID_CHAT]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnChat)
	groupBtnTable[BTN_ID_CHANGECARD]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnChangeCard)
	groupBtnTable[BTN_ID_NOPK]:registerScriptTapHandler(JinHuaTableMyOperation.onClick_btnNoPK)
end

-- 初始化下边的按钮栏
local function initDownMenuBtn()
	--截取文字
	local frameWidth = 67
	local frameHeight = 35
	local texture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_btn_text.png", pathTypeInApp))

	local rect = CCRectMake(0, 0, frameWidth, frameHeight)
	--截取出图片
	local frameFold = CCSpriteFrame:createWithTexture(texture, rect)

	rect = CCRectMake(0, frameHeight, frameWidth, frameHeight)
	local framePK = CCSpriteFrame:createWithTexture(texture, rect)

	rect = CCRectMake(0, frameHeight * 2, frameWidth, frameHeight)
	local frameCheck = CCSpriteFrame:createWithTexture(texture, rect)

	rect = CCRectMake(0, frameHeight * 3, frameWidth, frameHeight)
	local frameRaise = CCSpriteFrame:createWithTexture(texture, rect)

	rect = CCRectMake(0, frameHeight * 4, frameWidth, frameHeight)
	local frameCall = CCSpriteFrame:createWithTexture(texture, rect)

	--按钮：放弃
	groupBtnTable[BTN_ID_FOLD] = CCMenuItemImage:create(getJinHuaResource("desk_btn_bg_normal.png", pathTypeInApp), getJinHuaResource("desk_btn_bg_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_FOLD]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_FOLD]:setPosition(JinHuaTableConfig.btnsX, JinHuaTableConfig.fitY)
	foldText = CCSprite:createWithSpriteFrame(frameFold)
	foldText:setPosition(groupBtnTable[BTN_ID_FOLD]:getContentSize().width / 2, groupBtnTable[BTN_ID_FOLD]:getContentSize().height * 6 / 11)
	groupBtnTable[BTN_ID_FOLD]:addChild(foldText)

	--按钮：比牌
	groupBtnTable[BTN_ID_PK] = CCMenuItemImage:create(getJinHuaResource("desk_btn_bg_normal.png", pathTypeInApp), getJinHuaResource("desk_btn_bg_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_PK]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_PK]:setPosition(groupBtnTable[BTN_ID_FOLD]:getPositionX() + groupBtnTable[BTN_ID_FOLD]:getContentSize().width + JinHuaTableConfig.btnGapWidth, groupBtnTable[BTN_ID_FOLD]:getPositionY())
	pkText = CCSprite:createWithSpriteFrame(framePK)
	pkText:setPosition(groupBtnTable[BTN_ID_PK]:getContentSize().width / 2, groupBtnTable[BTN_ID_PK]:getContentSize().height * 6 / 11)
	groupBtnTable[BTN_ID_PK]:addChild(pkText)

	--按钮：比牌取消
	groupBtnTable[BTN_ID_PK_CANCEL] = CCMenuItemImage:create(getJinHuaResource("desk_btn_cancel_normal.png", pathTypeInApp), getJinHuaResource("desk_btn_cancel_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_PK_CANCEL]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_PK_CANCEL]:setPosition(groupBtnTable[BTN_ID_FOLD]:getPositionX() + groupBtnTable[BTN_ID_FOLD]:getContentSize().width + JinHuaTableConfig.btnGapWidth, groupBtnTable[BTN_ID_FOLD]:getPositionY())
	groupBtnTable[BTN_ID_PK_CANCEL]:setVisible(false)

	--按钮：看牌
	groupBtnTable[BTN_ID_CHECK] = CCMenuItemImage:create(getJinHuaResource("desk_btn_bg_normal.png", pathTypeInApp), getJinHuaResource("desk_btn_bg_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_CHECK]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_CHECK]:setPosition(groupBtnTable[BTN_ID_PK]:getPositionX() + groupBtnTable[BTN_ID_FOLD]:getContentSize().width + JinHuaTableConfig.btnGapWidth, groupBtnTable[BTN_ID_FOLD]:getPositionY())
	checkText = CCSprite:createWithSpriteFrame(frameCheck)
	checkText:setPosition(groupBtnTable[BTN_ID_CHECK]:getContentSize().width / 2, groupBtnTable[BTN_ID_CHECK]:getContentSize().height * 6 / 11)
	groupBtnTable[BTN_ID_CHECK]:addChild(checkText)

	--按钮：加注
	groupBtnTable[BTN_ID_RAISE] = CCMenuItemImage:create(getJinHuaResource("desk_btn_bg_normal.png", pathTypeInApp), getJinHuaResource("desk_btn_bg_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_RAISE]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_RAISE]:setPosition(groupBtnTable[BTN_ID_CHECK]:getPositionX() + groupBtnTable[BTN_ID_FOLD]:getContentSize().width + JinHuaTableConfig.btnGapWidth, groupBtnTable[BTN_ID_FOLD]:getPositionY())
	raiseText = CCSprite:createWithSpriteFrame(frameRaise)
	raiseText:setPosition(groupBtnTable[BTN_ID_FOLD]:getContentSize().width / 2, groupBtnTable[BTN_ID_FOLD]:getContentSize().height * 6 / 11)
	groupBtnTable[BTN_ID_RAISE]:addChild(raiseText)
	--按钮：AllIn
	groupBtnTable[BTN_ID_ALLIN] = CCMenuItemImage:create(getJinHuaResource("desk_btn_bg_normal.png", pathTypeInApp), getJinHuaResource("desk_btn_bg_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_ALLIN]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_ALLIN]:setPosition(groupBtnTable[BTN_ID_CHECK]:getPositionX() + groupBtnTable[BTN_ID_FOLD]:getContentSize().width + JinHuaTableConfig.btnGapWidth, groupBtnTable[BTN_ID_FOLD]:getPositionY())
	allInText = CCSprite:create(getJinHuaResource("desk_text_raiseall.png", pathTypeInApp))
	allInText:setPosition(groupBtnTable[BTN_ID_FOLD]:getContentSize().width / 2, groupBtnTable[BTN_ID_FOLD]:getContentSize().height * 6 / 11)
	groupBtnTable[BTN_ID_ALLIN]:addChild(allInText)
	groupBtnTable[BTN_ID_ALLIN]:setVisible(false)

	--按钮：跟注
	groupBtnTable[BTN_ID_CALL] = CCMenuItemImage:create(getJinHuaResource("desk_btn_bg_normal.png", pathTypeInApp), getJinHuaResource("desk_btn_bg_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_CALL]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_CALL]:setPosition(groupBtnTable[BTN_ID_RAISE]:getPositionX() + groupBtnTable[BTN_ID_FOLD]:getContentSize().width + JinHuaTableConfig.btnGapWidth, groupBtnTable[BTN_ID_FOLD]:getPositionY())
	callText = CCSprite:createWithSpriteFrame(frameCall)
	callText:setPosition(groupBtnTable[BTN_ID_FOLD]:getContentSize().width / 2, groupBtnTable[BTN_ID_FOLD]:getContentSize().height * 6 / 11)
	groupBtnTable[BTN_ID_CALL]:addChild(callText)
	groupBtnTable[BTN_ID_CALL]:setVisible(false)

	--按钮：跟到底
	-- 复选框
	groupBtnTable[CHECK_BOX_ALWAYS_BET] = CCSprite:createWithTexture(duihaoTexture)
	local alwaysBetCoinSelectedDiSprite = CCSprite:createWithTexture(duihaoBgTexture)
	-- 文字
	local alwaysBetCoinTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_always_bet_coin_text.png", pathTypeInApp))
	alwaysBetCoinText = CCSprite:createWithTexture(alwaysBetCoinTexture)
	groupBtnTable[BTN_ALWAYS_BET_COIN] = CCMenuItemImage:create(getJinHuaResource("desk_btn_bg_normal.png", pathTypeInApp), getJinHuaResource("desk_btn_bg_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ALWAYS_BET_COIN]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ALWAYS_BET_COIN]:setPosition(groupBtnTable[BTN_ID_RAISE]:getPositionX() + groupBtnTable[BTN_ID_FOLD]:getContentSize().width + JinHuaTableConfig.btnGapWidth, groupBtnTable[BTN_ID_FOLD]:getPositionY())
	-- 文字和复选框位置
	groupBtnTable[CHECK_BOX_ALWAYS_BET]:setPosition(groupBtnTable[BTN_ALWAYS_BET_COIN]:getContentSize().width/6,groupBtnTable[BTN_ALWAYS_BET_COIN]:getContentSize().height/2)
	alwaysBetCoinSelectedDiSprite:setPosition(groupBtnTable[BTN_ALWAYS_BET_COIN]:getContentSize().width/6,groupBtnTable[BTN_ALWAYS_BET_COIN]:getContentSize().height/2)
	alwaysBetCoinText:setPosition(alwaysBetCoinSelectedDiSprite:getPositionX() + alwaysBetCoinSelectedDiSprite:getContentSize().width/2 + alwaysBetCoinText:getContentSize().width/2 + 5,groupBtnTable[BTN_ALWAYS_BET_COIN]:getContentSize().height/2)
	groupBtnTable[BTN_ALWAYS_BET_COIN]:addChild(alwaysBetCoinSelectedDiSprite)
	groupBtnTable[BTN_ALWAYS_BET_COIN]:addChild(groupBtnTable[CHECK_BOX_ALWAYS_BET])
	groupBtnTable[BTN_ALWAYS_BET_COIN]:addChild(alwaysBetCoinText)
	groupBtnTable[CHECK_BOX_ALWAYS_BET]:setVisible(false)

	JinHuaTableButtonGroup.setDisable(BTN_ID_FOLD)
	JinHuaTableButtonGroup.setDisable(BTN_ID_PK)
	JinHuaTableButtonGroup.setDisable(BTN_ID_CHECK)
	JinHuaTableButtonGroup.setDisable(BTN_ID_RAISE)
	JinHuaTableButtonGroup.setDisable(BTN_ID_CALL)
	JinHuaTableButtonGroup.setDisable(BTN_ALWAYS_BET_COIN)
end

--按钮：准备
local function initReadyBtn()
	groupBtnTable[BTN_ID_READY] = CCMenuItemImage:create(getJinHuaResource("desk_btn_ready_normal.png",pathTypeInApp),getJinHuaResource("desk_btn_ready_selected.png",pathTypeInApp))
--	groupBtnTable[BTN_ID_READY]:setPosition(400*JinHuaTableConfig.TableScaleX,195*JinHuaTableConfig.TableScaleY+groupBtnTable[BTN_ID_READY]:getContentSize().height/2)
	groupBtnTable[BTN_ID_READY]:setPosition(JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX /2, JinHuaTableConfig.TableDefaultHeight *JinHuaTableConfig.TableScaleY / 2.5 +groupBtnTable[BTN_ID_READY]:getContentSize().height/2)
	groupBtnTable[BTN_ID_READY]:setVisible(false)
end

--按钮：PK
local function initPkBtn()
	groupBtnTable[BTN_ID_PK_2] = CCMenuItemImage:create(getJinHuaResource("desk_btn_pk_mormal.png",pathTypeInApp),getJinHuaResource("desk_btn_pk_selected.png",pathTypeInApp))
	groupBtnTable[BTN_ID_PK_2]:setPosition(JinHuaTableConfig.spritePlayers[2].pkX,JinHuaTableConfig.spritePlayers[2].pkY)
	groupBtnTable[BTN_ID_PK_3] = CCMenuItemImage:create(getJinHuaResource("desk_btn_pk_mormal.png",pathTypeInApp),getJinHuaResource("desk_btn_pk_selected.png",pathTypeInApp))
	groupBtnTable[BTN_ID_PK_3]:setPosition(JinHuaTableConfig.spritePlayers[3].pkX,JinHuaTableConfig.spritePlayers[3].pkY)
	groupBtnTable[BTN_ID_PK_4] = CCMenuItemImage:create(getJinHuaResource("desk_btn_pk_mormal.png",pathTypeInApp),getJinHuaResource("desk_btn_pk_selected.png",pathTypeInApp))
	groupBtnTable[BTN_ID_PK_4]:setPosition(JinHuaTableConfig.spritePlayers[4].pkX,JinHuaTableConfig.spritePlayers[4].pkY)
	groupBtnTable[BTN_ID_PK_5] = CCMenuItemImage:create(getJinHuaResource("desk_btn_pk_mormal.png",pathTypeInApp),getJinHuaResource("desk_btn_pk_selected.png",pathTypeInApp))
	groupBtnTable[BTN_ID_PK_5]:setPosition(JinHuaTableConfig.spritePlayers[5].pkX,JinHuaTableConfig.spritePlayers[5].pkY)
	groupBtnTable[BTN_ID_PK_2]:setVisible(false)
	groupBtnTable[BTN_ID_PK_3]:setVisible(false)
	groupBtnTable[BTN_ID_PK_4]:setVisible(false)
	groupBtnTable[BTN_ID_PK_5]:setVisible(false)
	blinkPK(groupBtnTable[BTN_ID_PK_2])
	blinkPK(groupBtnTable[BTN_ID_PK_3])
	blinkPK(groupBtnTable[BTN_ID_PK_4])
	blinkPK(groupBtnTable[BTN_ID_PK_5])
end

-- 加注列表
local function initRaiseListBtn()
	--按钮：加注：押满
	groupBtnTable[BTN_ID_RAISE_ALL] = CCMenuItemImage:create(getJinHuaResource("desk_bg_raise_normal.png", pathTypeInApp), getJinHuaResource("desk_bg_raise_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_RAISE_ALL]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_RAISE_ALL]:setPosition(JinHuaTableConfig.btnsRaiseX, JinHuaTableConfig.fitY+2)
	local raiseAllText = CCSprite:create(getJinHuaResource("desk_text_raiseall.png", pathTypeInApp))
	raiseAllText:setPosition(groupBtnTable[BTN_ID_RAISE_ALL]:getContentSize().width / 2, groupBtnTable[BTN_ID_RAISE_ALL]:getContentSize().height / 2)
	groupBtnTable[BTN_ID_RAISE_ALL]:addChild(raiseAllText)
	groupBtnTable[BTN_ID_RAISE_ALL]:setVisible(false)

	--按钮：加注：加注额1
	groupBtnTable[BTN_ID_RAISE_1] = CCMenuItemImage:create(getJinHuaResource("desk_bg_raise_normal.png", pathTypeInApp), getJinHuaResource("desk_bg_raise_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_RAISE_1]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_RAISE_1]:setPosition(groupBtnTable[BTN_ID_RAISE_ALL]:getPositionX() + groupBtnTable[BTN_ID_RAISE_ALL]:getContentSize().width + JinHuaTableConfig.btnRaiseGapWidth, groupBtnTable[BTN_ID_RAISE_ALL]:getPositionY())
	--desk_num1.png每个数字的宽(198X24)
	local eachNumberWidthInDeskNum1Pic = 198 / 11;
	local eachNumberHeightInDeskNum1Pic = 24;
	-- 1058为显示值   48为0的asic值
	groupBtnTable[TEXT_ID_RAISE_1] = CCLabelAtlas:create("1058", getJinHuaResource("desk_num1.png"), eachNumberWidthInDeskNum1Pic, eachNumberHeightInDeskNum1Pic, 48)
	groupBtnTable[TEXT_ID_RAISE_1]:setAnchorPoint(ccp(0.5,0.5))
	groupBtnTable[TEXT_ID_RAISE_1]:setPosition(groupBtnTable[BTN_ID_RAISE_1]:getContentSize().width / 2, groupBtnTable[BTN_ID_RAISE_1]:getContentSize().height / 2)
	groupBtnTable[BTN_ID_RAISE_1]:addChild(groupBtnTable[TEXT_ID_RAISE_1])
	groupBtnTable[BTN_ID_RAISE_1]:setVisible(false)

	--按钮：加注：加注额2
	groupBtnTable[BTN_ID_RAISE_2] = CCMenuItemImage:create(getJinHuaResource("desk_bg_raise_normal.png", pathTypeInApp), getJinHuaResource("desk_bg_raise_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_RAISE_2]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_RAISE_2]:setPosition(groupBtnTable[BTN_ID_RAISE_1]:getPositionX() + groupBtnTable[BTN_ID_RAISE_1]:getContentSize().width + JinHuaTableConfig.btnRaiseGapWidth, groupBtnTable[BTN_ID_RAISE_1]:getPositionY())
	groupBtnTable[TEXT_ID_RAISE_2] = CCLabelAtlas:create("2058", getJinHuaResource("desk_num1.png"), eachNumberWidthInDeskNum1Pic, eachNumberHeightInDeskNum1Pic, 48)
	groupBtnTable[TEXT_ID_RAISE_2]:setAnchorPoint(ccp(0.5,0.5))
	groupBtnTable[TEXT_ID_RAISE_2]:setPosition(groupBtnTable[BTN_ID_RAISE_2]:getContentSize().width / 2, groupBtnTable[BTN_ID_RAISE_2]:getContentSize().height / 2)
	groupBtnTable[BTN_ID_RAISE_2]:addChild(groupBtnTable[TEXT_ID_RAISE_2])
	groupBtnTable[BTN_ID_RAISE_2]:setVisible(false)

	--按钮：加注：加注额3
	groupBtnTable[BTN_ID_RAISE_3] = CCMenuItemImage:create(getJinHuaResource("desk_bg_raise_normal.png", pathTypeInApp), getJinHuaResource("desk_bg_raise_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_RAISE_3]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_RAISE_3]:setPosition(groupBtnTable[BTN_ID_RAISE_2]:getPositionX() + groupBtnTable[BTN_ID_RAISE_2]:getContentSize().width + JinHuaTableConfig.btnRaiseGapWidth, groupBtnTable[BTN_ID_RAISE_2]:getPositionY())
	groupBtnTable[TEXT_ID_RAISE_3] = CCLabelAtlas:create("3058", getJinHuaResource("desk_num1.png"), eachNumberWidthInDeskNum1Pic, eachNumberHeightInDeskNum1Pic, 48)
	groupBtnTable[TEXT_ID_RAISE_3]:setAnchorPoint(ccp(0.5,0.5))
	groupBtnTable[TEXT_ID_RAISE_3]:setPosition(groupBtnTable[BTN_ID_RAISE_3]:getContentSize().width / 2, groupBtnTable[BTN_ID_RAISE_3]:getContentSize().height / 2)
	groupBtnTable[BTN_ID_RAISE_3]:addChild(groupBtnTable[TEXT_ID_RAISE_3])
	groupBtnTable[BTN_ID_RAISE_3]:setVisible(false)

	--按钮：加注：加注额4
	groupBtnTable[BTN_ID_RAISE_4] = CCMenuItemImage:create(getJinHuaResource("desk_bg_raise_normal.png", pathTypeInApp), getJinHuaResource("desk_bg_raise_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_RAISE_4]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_RAISE_4]:setPosition(groupBtnTable[BTN_ID_RAISE_3]:getPositionX() + groupBtnTable[BTN_ID_RAISE_3]:getContentSize().width + JinHuaTableConfig.btnRaiseGapWidth, groupBtnTable[BTN_ID_RAISE_3]:getPositionY())
	groupBtnTable[TEXT_ID_RAISE_4] = CCLabelAtlas:create("4058", getJinHuaResource("desk_num1.png"), eachNumberWidthInDeskNum1Pic, eachNumberHeightInDeskNum1Pic, 48)
	groupBtnTable[TEXT_ID_RAISE_4]:setAnchorPoint(ccp(0.5,0.5))
	groupBtnTable[TEXT_ID_RAISE_4]:setPosition(groupBtnTable[BTN_ID_RAISE_4]:getContentSize().width / 2, groupBtnTable[BTN_ID_RAISE_4]:getContentSize().height / 2)
	groupBtnTable[BTN_ID_RAISE_4]:addChild(groupBtnTable[TEXT_ID_RAISE_4])
	groupBtnTable[BTN_ID_RAISE_4]:setVisible(false)

	--按钮：加注：取消
	groupBtnTable[BTN_ID_RAISE_CANCEL] = CCMenuItemImage:create(getJinHuaResource("desk_raise_cancel_normal.png", pathTypeInApp), getJinHuaResource("desk_raise_cancel_selected.png", pathTypeInApp))
	groupBtnTable[BTN_ID_RAISE_CANCEL]:setAnchorPoint(ccp(0, 0))
	groupBtnTable[BTN_ID_RAISE_CANCEL]:setPosition(groupBtnTable[BTN_ID_RAISE_4]:getPositionX() + groupBtnTable[BTN_ID_RAISE_4]:getContentSize().width + JinHuaTableConfig.btnRaiseGapWidth, groupBtnTable[BTN_ID_RAISE_4]:getPositionY())
	groupBtnTable[BTN_ID_RAISE_CANCEL]:setVisible(false)
end

local function updateCountText(countLabel, count)
	-- 位数
	local digitCount = JinHuaTableFunctions.getDigitCount(count)
	if digitCount > 2 then
		countLabel:setFontSize(14)
		countLabel:setString("99+")
	else
		countLabel:setString(""..count)
	end
end

-- 更新换牌卡数量显示
function JinHuaTableButtonGroup.updateChangeCardCountText()
	updateCountText(changeCardCountText, GameConfig.remainChangeCardCnt)
end

-- 更新禁比卡数量显示
function JinHuaTableButtonGroup.updateNoPkCountText()
	updateCountText(noPKCountText, GameConfig.remainNoPKCnt)
end

--充值，聊天，换牌，禁比
local function initTableOtherOperateBtn()
	local menuBgNorSprite = CCSprite:create(getJinHuaResource("desk_btn_recharge_normal.png",pathTypeInApp))
	local menuBgSelectedSprite = CCSprite:create(getJinHuaResource("desk_btn_recharge_normal.png",pathTypeInApp))

	--充值
--	rechargeButtonLocY = GameConfig.ScreenHeight * 194 *JinHuaTableConfig.TableScaleY / 480;
	groupBtnTable[BTN_ID_RECHARGE] =  CCMenuItemSprite:create(menuBgNorSprite, menuBgSelectedSprite)
	groupBtnTable[BTN_ID_RECHARGE]:setAnchorPoint(ccp(0,0.5))
	groupBtnTable[BTN_ID_RECHARGE]:setPosition(JinHuaTableConfig.btnRechargeX,groupBtnTable[BTN_ID_RECHARGE]:getContentSize().width * 2 / 3)
--	local rechargeSprite = CCSprite:create(getJinHuaResource("desk_btn_recharge_normal.png",pathTypeInApp))
--	rechargeSprite:setAnchorPoint(ccp(0.5,0.5))
--	rechargeSprite:setPosition(groupBtnTable[BTN_ID_RECHARGE]:getContentSize().width/2,groupBtnTable[BTN_ID_RECHARGE]:getContentSize().height/2)
--	groupBtnTable[BTN_ID_RECHARGE]:addChild(rechargeSprite)

	--聊天
	menuBgNorSprite = CCSprite:create(getJinHuaResource("desk_btn_chat_normal.png",pathTypeInApp))
	menuBgSelectedSprite = CCSprite:create(getJinHuaResource("desk_btn_chat_normal.png",pathTypeInApp))
	groupBtnTable[BTN_ID_CHAT] = CCMenuItemSprite:create(menuBgNorSprite, menuBgSelectedSprite)
	groupBtnTable[BTN_ID_CHAT]:setAnchorPoint(ccp(0,0.5))
	--聊天按钮Y轴
--	local btnTableChatY = rechargeButtonLocY-GameConfig.ScreenHeight *JinHuaTableConfig.TableScaleY / 6.8;
	groupBtnTable[BTN_ID_CHAT]:setPosition(JinHuaTableConfig.btnChatX,groupBtnTable[BTN_ID_CHAT]:getContentSize().width * 2 / 3)
--	local chatSprite = CCSprite:create(getJinHuaResource("desk_btn_chat_normal.png",pathTypeInApp))
--	chatSprite:setAnchorPoint(ccp(0.5,0.5))
--	chatSprite:setPosition(groupBtnTable[BTN_ID_CHAT]:getContentSize().width/2,groupBtnTable[BTN_ID_CHAT]:getContentSize().height/2)
--	groupBtnTable[BTN_ID_CHAT]:addChild(chatSprite)

	--换牌
	menuBgNorSprite = CCSprite:create(getJinHuaResource("desk_bg_btn_nor.png",pathTypeInApp))
	menuBgSelectedSprite = CCSprite:create(getJinHuaResource("desk_bg_btn_press.png",pathTypeInApp))
	menuBgNorSprite:setFlipX(true)
	menuBgSelectedSprite:setFlipX(true)

	changeCardButtonLocX = (JinHuaTableConfig.TableDefaultWidth-35)*JinHuaTableConfig.TableScaleX-JinHuaTableConfig.fitX -- 换牌按钮位置
	changeCardButtonLocY = JinHuaTableConfig.TableDefaultHeight *194 *JinHuaTableConfig.TableScaleY / 480
	local changeCardCountBgTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("hall_player_emil_red.png", pathTypeInApp))
	changeCardCountTextBg = CCSprite:createWithTexture(changeCardCountBgTexture)
	changeCardCountTextBg:setAnchorPoint(ccp(0.5, 0.5))
	changeCardCountText = CCLabelTTF:create("0", "Arial", 24)
	changeCardCountText:setColor(ccc3(255, 255, 255))
	changeCardCountText:setAnchorPoint(ccp(0.5, 0.5))
	groupBtnTable[BTN_ID_CHANGECARD] = CCMenuItemSprite:create(menuBgNorSprite, menuBgSelectedSprite)
	groupBtnTable[BTN_ID_CHANGECARD]:setAnchorPoint(ccp(1,0.5))
	groupBtnTable[BTN_ID_CHANGECARD]:setPosition(JinHuaTableConfig.TableDefaultWidth-JinHuaTableConfig.fitX,changeCardButtonLocY)

	local changeCardSprite = CCSprite:create(getJinHuaResource("desk_btn_changecard_normal.png",pathTypeInApp))
	changeCardSprite:setAnchorPoint(ccp(0.5,0.5))
	changeCardSprite:setPosition(groupBtnTable[BTN_ID_CHANGECARD]:getContentSize().width/2,groupBtnTable[BTN_ID_CHANGECARD]:getContentSize().height/2)
	changeCardCountTextBg:setPosition(0, changeCardSprite:getContentSize().height)
	changeCardCountText:setPosition(0, changeCardSprite:getContentSize().height)
	changeCardSprite:addChild(changeCardCountTextBg)
	changeCardSprite:addChild(changeCardCountText)
	groupBtnTable[BTN_ID_CHANGECARD]:addChild(changeCardSprite)
	addChangeCardClickPromptAnim()

	--禁比
	menuBgNorSprite = CCSprite:create(getJinHuaResource("desk_bg_btn_nor.png",pathTypeInApp))
	menuBgSelectedSprite = CCSprite:create(getJinHuaResource("desk_bg_btn_press.png",pathTypeInApp))
	menuBgNorSprite:setFlipX(true)
	menuBgSelectedSprite:setFlipX(true)

	noPKCountTextBg = CCSprite:createWithTexture(changeCardCountBgTexture)
	noPKCountTextBg:setAnchorPoint(ccp(0.5, 0.5))
	noPKCountText = CCLabelTTF:create("0", "Arial", 24)
	noPKCountText:setColor(ccc3(255, 255, 255))
	noPKCountText:setAnchorPoint(ccp(0.5, 0.5))
	groupBtnTable[BTN_ID_NOPK] = CCMenuItemSprite:create(menuBgNorSprite, menuBgSelectedSprite)
	groupBtnTable[BTN_ID_NOPK]:setAnchorPoint(ccp(1,0.5))
	--禁比按钮Y轴
	local btnTableNoPkY = changeCardButtonLocY-TableConfig.TableDefaultHeight * TableConfig.TableScaleY / 6.8;
	groupBtnTable[BTN_ID_NOPK]:setPosition(JinHuaTableConfig.TableDefaultWidth-JinHuaTableConfig.fitX,btnTableNoPkY)

	local noPkSprite = CCSprite:create(getJinHuaResource("desk_btn_nopk_normal.png",pathTypeInApp))
	noPkSprite:setAnchorPoint(ccp(0.5,0.5))
	noPkSprite:setPosition(groupBtnTable[BTN_ID_NOPK]:getContentSize().width/2,groupBtnTable[BTN_ID_NOPK]:getContentSize().height/2)
	noPKCountTextBg:setPosition(0, noPkSprite:getContentSize().height)
	noPKCountText:setPosition(0, noPkSprite:getContentSize().height)
	noPkSprite:addChild(noPKCountTextBg)
	noPkSprite:addChild(noPKCountText)
	groupBtnTable[BTN_ID_NOPK]:addChild(noPkSprite)

	--菜单：菜单
	btnMenu = CCMenuItemImage:create(getJinHuaResource("desk_menu_normal.png", pathTypeInApp), getJinHuaResource("desk_menu_normal.png", pathTypeInApp))
	btnMenu:setAnchorPoint(ccp(1,1))
	local btnMenuX = JinHuaTableConfig.TableDefaultWidth
	btnMenu:setPosition(btnMenuX *JinHuaTableConfig.TableScaleX  - JinHuaTableConfig.fitX, JinHuaTableConfig.TableDefaultHeight*JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY)
	btnMenu:registerScriptTapHandler(onClick_btnMenu)

	btnMenuSelect = CCMenuItemImage:create(getJinHuaResource("desk_menu_selected.png", pathTypeInApp), getJinHuaResource("desk_menu_selected.png", pathTypeInApp))
	btnMenuSelect:setAnchorPoint(ccp(1,1))
	local btnMenuX = JinHuaTableConfig.TableDefaultWidth
	btnMenuSelect:setPosition(btnMenuX *JinHuaTableConfig.TableScaleX  - JinHuaTableConfig.fitX, JinHuaTableConfig.TableDefaultHeight*JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY)
	btnMenuSelect:registerScriptTapHandler(onClick_btnMenuSelect)
	btnMenuSelect:setVisible(false)
	btnMenuSelect:setEnabled(false)
end

-- 下拉菜单
local function initMenuBtn()
	--菜单：文字
	local frameWidth = 52
	local frameHeight = 27
	local menuTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_menu_text.png", pathTypeInApp))
	local rect = CCRectMake(0, 0, frameWidth, frameHeight)
	local frameCardType = CCSpriteFrame:createWithTexture(menuTexture, rect)

	rect = CCRectMake(0, frameHeight, frameWidth, frameHeight)
	local frameSet = CCSpriteFrame:createWithTexture(menuTexture, rect)

	rect = CCRectMake(0, frameHeight * 2, frameWidth, frameHeight)
	local frameChangeTable = CCSpriteFrame:createWithTexture(menuTexture, rect)

	rect = CCRectMake(0, frameHeight * 3, frameWidth, frameHeight)
	local frameStandUp = CCSpriteFrame:createWithTexture(menuTexture, rect)

	rect = CCRectMake(0, frameHeight * 4, frameWidth, frameHeight)
	local frameQuit = CCSpriteFrame:createWithTexture(menuTexture, rect)

	--菜单：牌型
	groupBtnTable[MENU_ID_CARDTYPE] = CCMenuItemImage:create(getJinHuaResource("desk_menu_btn_nomal.png", pathTypeInApp), getJinHuaResource("desk_menu_btn_selected.png", pathTypeInApp))
	groupBtnTable[MENU_ID_CARDTYPE]:setAnchorPoint(ccp(1,1))
	--牌型按钮X轴
	local btnMenuIdCardTypeX = JinHuaTableConfig.TableDefaultWidth * JinHuaTableConfig.TableScaleX  - JinHuaTableConfig.fitX
	groupBtnTable[MENU_ID_CARDTYPE]:setPosition(btnMenuIdCardTypeX,btnMenu:getPositionY()-btnMenu:getContentSize().height)
	local text = CCSprite:createWithSpriteFrame(frameCardType)
	text:setPosition(groupBtnTable[MENU_ID_CARDTYPE]:getContentSize().width/2,groupBtnTable[MENU_ID_CARDTYPE]:getContentSize().height/2)
	groupBtnTable[MENU_ID_CARDTYPE]:addChild(text)
	groupBtnTable[MENU_ID_CARDTYPE]:setVisible(false)

	--菜单：设置
	groupBtnTable[MENU_ID_SET] = CCMenuItemImage:create(getJinHuaResource("desk_menu_btn_nomal.png", pathTypeInApp), getJinHuaResource("desk_menu_btn_selected.png", pathTypeInApp))
	groupBtnTable[MENU_ID_SET]:setAnchorPoint(ccp(1,1))
	groupBtnTable[MENU_ID_SET]:setPosition(groupBtnTable[MENU_ID_CARDTYPE]:getPositionX(),groupBtnTable[MENU_ID_CARDTYPE]:getPositionY()-groupBtnTable[MENU_ID_CARDTYPE]:getContentSize().height)
	text = CCSprite:createWithSpriteFrame(frameSet)
	text:setPosition(groupBtnTable[MENU_ID_SET]:getContentSize().width/2,groupBtnTable[MENU_ID_SET]:getContentSize().height/2)
	groupBtnTable[MENU_ID_SET]:addChild(text)
	groupBtnTable[MENU_ID_SET]:setVisible(false)

	--菜单：换桌
	groupBtnTable[MENU_ID_CHANGETABLE] = CCMenuItemImage:create(getJinHuaResource("desk_menu_btn_nomal.png", pathTypeInApp), getJinHuaResource("desk_menu_btn_selected.png", pathTypeInApp))
	groupBtnTable[MENU_ID_CHANGETABLE]:setAnchorPoint(ccp(1,1))
	groupBtnTable[MENU_ID_CHANGETABLE]:setPosition(groupBtnTable[MENU_ID_SET]:getPositionX(),groupBtnTable[MENU_ID_SET]:getPositionY()-groupBtnTable[MENU_ID_SET]:getContentSize().height)
	text = CCSprite:createWithSpriteFrame(frameChangeTable)
	text:setPosition(groupBtnTable[MENU_ID_CHANGETABLE]:getContentSize().width/2,groupBtnTable[MENU_ID_CHANGETABLE]:getContentSize().height/2)
	groupBtnTable[MENU_ID_CHANGETABLE]:addChild(text)
	groupBtnTable[MENU_ID_CHANGETABLE]:setVisible(false)
	--菜单：旁观
	groupBtnTable[MENU_ID_STANDUP] = CCMenuItemImage:create(getJinHuaResource("desk_menu_btn_nomal.png", pathTypeInApp), getJinHuaResource("desk_menu_btn_selected.png", pathTypeInApp))
	groupBtnTable[MENU_ID_STANDUP]:setAnchorPoint(ccp(1,1))
	btnStandUp_LocX = groupBtnTable[MENU_ID_CHANGETABLE]:getPositionX()
	btnStandUp_LocY = groupBtnTable[MENU_ID_CHANGETABLE]:getPositionY()-groupBtnTable[MENU_ID_CHANGETABLE]:getContentSize().height
	groupBtnTable[MENU_ID_STANDUP]:setPosition(btnStandUp_LocX,btnStandUp_LocY)
	text = CCSprite:createWithSpriteFrame(frameStandUp)
	text:setPosition(groupBtnTable[MENU_ID_STANDUP]:getContentSize().width/2,groupBtnTable[MENU_ID_STANDUP]:getContentSize().height/2)
	groupBtnTable[MENU_ID_STANDUP]:addChild(text)
	groupBtnTable[MENU_ID_STANDUP]:setVisible(false)

	--菜单：下局旁观
	local standUpNextRoundSelectedDiSprite = CCSprite:createWithTexture(duihaoBgTexture)
	-- 对勾
	groupBtnTable[CHECK_BOX_NEXT_ROUND_STAND_UP] = CCSprite:createWithTexture(duihaoTexture)
	-- 按钮文字
	local menuStandUpNextRoundTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_menu_text2.png", pathTypeInApp))
	text = CCSprite:createWithTexture(menuStandUpNextRoundTexture)
	groupBtnTable[MENU_ID_STANDUP_NEXTROUND] = CCMenuItemImage:create(getJinHuaResource("desk_menu_btn_nomal.png", pathTypeInApp), getJinHuaResource("desk_menu_btn_selected.png", pathTypeInApp))
	groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:setAnchorPoint(ccp(1,1))
	groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:setPosition(groupBtnTable[MENU_ID_STANDUP]:getPositionX(),groupBtnTable[MENU_ID_STANDUP]:getPositionY()-groupBtnTable[MENU_ID_STANDUP]:getContentSize().height)
	standUpNextRoundSelectedDiSprite:setPosition(groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:getContentSize().width/6,groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:getContentSize().height/2)
	groupBtnTable[CHECK_BOX_NEXT_ROUND_STAND_UP]:setPosition(groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:getContentSize().width/6,groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:getContentSize().height/2)
	text:setPosition(standUpNextRoundSelectedDiSprite:getPositionX() + standUpNextRoundSelectedDiSprite:getContentSize().width/2 + text:getContentSize().width/2 + 5,groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:getContentSize().height/2)
	groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:addChild(text)
	groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:addChild(standUpNextRoundSelectedDiSprite)
	groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:addChild(groupBtnTable[CHECK_BOX_NEXT_ROUND_STAND_UP])
	groupBtnTable[CHECK_BOX_NEXT_ROUND_STAND_UP]:setVisible(false)
	groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:setVisible(false)

	--菜单：退出
	groupBtnTable[MENU_ID_QUIT] = CCMenuItemImage:create(getJinHuaResource("desk_menu_btn_nomal.png", pathTypeInApp), getJinHuaResource("desk_menu_btn_selected.png", pathTypeInApp))
	groupBtnTable[MENU_ID_QUIT]:setAnchorPoint(ccp(1,1))
	btnQuit_LocX = groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:getPositionX()
	btnQuit_LocY = groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:getPositionY()-groupBtnTable[MENU_ID_STANDUP_NEXTROUND]:getContentSize().height
	groupBtnTable[MENU_ID_QUIT]:setPosition(btnQuit_LocX,btnQuit_LocY)
	text = CCSprite:createWithSpriteFrame(frameQuit)
	text:setPosition(groupBtnTable[MENU_ID_QUIT]:getContentSize().width/2,groupBtnTable[MENU_ID_QUIT]:getContentSize().height/2)
	groupBtnTable[MENU_ID_QUIT]:addChild(text)
	groupBtnTable[MENU_ID_QUIT]:setVisible(false)
end

-- 初始化坐下按钮
local function initSitDownBtn()
	local playerBgH = JinHuaTableConfig.playerBGHeight/2
	local playerBgW = JinHuaTableConfig.playerBGWidth/2
	--坐下按钮
	--1号位坐下按钮
	groupBtnTable[BTN_SIT_ID_1] = CCMenuItemImage:create(getJinHuaResource("desk_btn_sit_normal.png",pathTypeInApp),getJinHuaResource("desk_btn_sit_selected.png",pathTypeInApp))
	groupBtnTable[BTN_SIT_ID_1]:setPosition(JinHuaTableConfig.spritePlayers[1].locX+playerBgW,JinHuaTableConfig.spritePlayers[1].locY+playerBgH)
	--2号位坐下按钮
	groupBtnTable[BTN_SIT_ID_2] = CCMenuItemImage:create(getJinHuaResource("desk_btn_sit_normal.png",pathTypeInApp),getJinHuaResource("desk_btn_sit_selected.png",pathTypeInApp))
	groupBtnTable[BTN_SIT_ID_2]:setPosition(JinHuaTableConfig.spritePlayers[2].locX+playerBgW,JinHuaTableConfig.spritePlayers[2].locY+playerBgH)
	--3号位坐下按钮
	groupBtnTable[BTN_SIT_ID_3] = CCMenuItemImage:create(getJinHuaResource("desk_btn_sit_normal.png",pathTypeInApp),getJinHuaResource("desk_btn_sit_selected.png",pathTypeInApp))
	groupBtnTable[BTN_SIT_ID_3]:setPosition(JinHuaTableConfig.spritePlayers[3].locX+playerBgW,JinHuaTableConfig.spritePlayers[3].locY+playerBgH)
	--4号位坐下按钮
	groupBtnTable[BTN_SIT_ID_4] = CCMenuItemImage:create(getJinHuaResource("desk_btn_sit_normal.png",pathTypeInApp),getJinHuaResource("desk_btn_sit_selected.png",pathTypeInApp))
	groupBtnTable[BTN_SIT_ID_4]:setPosition(JinHuaTableConfig.spritePlayers[4].locX+playerBgW,JinHuaTableConfig.spritePlayers[4].locY+playerBgH)
	--5号位坐下按钮
	groupBtnTable[BTN_SIT_ID_5] = CCMenuItemImage:create(getJinHuaResource("desk_btn_sit_normal.png",pathTypeInApp),getJinHuaResource("desk_btn_sit_selected.png",pathTypeInApp))
	groupBtnTable[BTN_SIT_ID_5]:setPosition(JinHuaTableConfig.spritePlayers[5].locX+playerBgW,JinHuaTableConfig.spritePlayers[5].locY+playerBgH)
	groupBtnTable[BTN_SIT_ID_1]:setVisible(false)
	groupBtnTable[BTN_SIT_ID_2]:setVisible(false)
	groupBtnTable[BTN_SIT_ID_3]:setVisible(false)
	groupBtnTable[BTN_SIT_ID_4]:setVisible(false)
	groupBtnTable[BTN_SIT_ID_5]:setVisible(false)
end

local function addBtnToButtonGroupSprite()
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_FOLD])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_PK])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_CHECK])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_RAISE])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_CALL])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ALWAYS_BET_COIN])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_PK_CANCEL])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_READY])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_PK_2])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_PK_3])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_PK_4])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_PK_5])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_RAISE_ALL])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_RAISE_1])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_RAISE_2])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_RAISE_3])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_RAISE_4])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_RAISE_CANCEL])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_RECHARGE])
--	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_CHAT])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_CHANGECARD])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_NOPK])
	buttonGroupSprite:addChild(groupBtnTable[BTN_SIT_ID_1])
	buttonGroupSprite:addChild(groupBtnTable[BTN_SIT_ID_2])
	buttonGroupSprite:addChild(groupBtnTable[BTN_SIT_ID_3])
	buttonGroupSprite:addChild(groupBtnTable[BTN_SIT_ID_4])
	buttonGroupSprite:addChild(groupBtnTable[BTN_SIT_ID_5])
	buttonGroupSprite:addChild(groupBtnTable[MENU_ID_CARDTYPE])
	buttonGroupSprite:addChild(groupBtnTable[MENU_ID_SET])
	buttonGroupSprite:addChild(groupBtnTable[MENU_ID_CHANGETABLE])
	buttonGroupSprite:addChild(groupBtnTable[MENU_ID_STANDUP])
	buttonGroupSprite:addChild(groupBtnTable[MENU_ID_STANDUP_NEXTROUND])
	buttonGroupSprite:addChild(groupBtnTable[MENU_ID_QUIT])
	buttonGroupSprite:addChild(groupBtnTable[BTN_ID_ALLIN])
	buttonGroupSprite:addChild(btnMenu)
	buttonGroupSprite:addChild(btnMenuSelect)
end

local function initTableButton()
	buttonGroupSprite = CCMenu:create()
	-- 复选框
	duihaoBgTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("btn_gouxuan1.png", pathTypeInApp))
	duihaoTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("btn_gouxuan2.png", pathTypeInApp))
	initDownMenuBtn()
	initReadyBtn()
	initPkBtn()
	initRaiseListBtn()
	initTableOtherOperateBtn()
	initMenuBtn()
	initSitDownBtn()
	addBtnToButtonGroupSprite()
	addBtnCallBack()

	buttonGroupSprite:setAnchorPoint(ccp(0, 0))
	buttonGroupSprite:setPosition(0, 0)
end

--返回比牌按钮的中心点X坐标，TopY坐标
function JinHuaTableButtonGroup.getPKTipLoc()
	local x = groupBtnTable[BTN_ID_PK]:getPositionX()+groupBtnTable[BTN_ID_PK]:getContentSize().width/2
	local y = groupBtnTable[BTN_ID_PK]:getPositionY()+groupBtnTable[BTN_ID_PK]:getContentSize().height
	return x,y
end

--准备按钮上中边沿坐标
--function JinHuaTableButtonGroup.getReadyTopLoc()
--	return 400*JinHuaTableConfig.TableScaleX,195*JinHuaTableConfig.TableScaleY+groupBtnTable[BTN_ID_READY]:getContentSize().height
--end

--设置显示文字
function JinHuaTableButtonGroup.setText(ID,text)
	local showText = ""
	if text>9999 then
		showText = math.modf(text / 1000)..":"
	else
		showText = ""..text
	end
	if ID==TEXT_ID_RAISE_1 then
		groupBtnTable[TEXT_ID_RAISE_1]:setString(showText)
	elseif ID==TEXT_ID_RAISE_2 then
		groupBtnTable[TEXT_ID_RAISE_2]:setString(showText)
	elseif ID==TEXT_ID_RAISE_3 then
		groupBtnTable[TEXT_ID_RAISE_3]:setString(showText)
	elseif ID==TEXT_ID_RAISE_4 then
		groupBtnTable[TEXT_ID_RAISE_4]:setString(showText)
	end
end

function JinHuaTableButtonGroup.hideBtn(groupBtnId)
	if groupBtnTable[groupBtnId] then
		groupBtnTable[groupBtnId]:setVisible(false)
	end
end

function JinHuaTableButtonGroup.showBtn(groupBtnId)
	if groupBtnTable[groupBtnId] then
		groupBtnTable[groupBtnId]:setVisible(true)
	end
end

--enable状态
function JinHuaTableButtonGroup.setEnable(groupBtnId)
	if groupBtnTable[groupBtnId] then
		groupBtnTable[groupBtnId]:setEnabled(true)
		groupBtnTable[groupBtnId]:setOpacity(255)
	end
end

--disable状态
function JinHuaTableButtonGroup.setDisable(groupBtnId)
	if groupBtnTable[groupBtnId] then
		groupBtnTable[groupBtnId]:setEnabled(false)
		groupBtnTable[groupBtnId]:setOpacity(127)
	end
end

--获取按钮组
function JinHuaTableButtonGroup.getGroupBtnTable()
	return groupBtnTable
end

--[[--
设置菜单按钮不可点
]]
function JinHuaTableButtonGroup.setMenuButtonDisable()
    btnMenu:setEnabled(false);
    btnMenuSelect:setEnabled(false);
end

-- 显示换牌动画
function JinHuaTableButtonGroup.showChangeCardAnim()
	changeCardClickPromptAnim:setVisible(true)
end
-- 隐藏换牌动画
function JinHuaTableButtonGroup.hideChangeCardAnim()
	changeCardClickPromptAnim:setVisible(false)
end

function JinHuaTableButtonGroup.getButtonGroupSprite()
	return buttonGroupSprite
end

function JinHuaTableButtonGroup.createTableMenu()
	layerMenu = CCLayer:create()
	initTableButton()
	layerMenu:addChild(buttonGroupSprite, 1)
	return layerMenu
end

function JinHuaTableButtonGroup.clear()
    groupBtnTable = {};
end