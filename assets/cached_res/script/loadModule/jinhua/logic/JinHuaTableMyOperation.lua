module("JinHuaTableMyOperation", package.seeall)

--震动定时ID
local vibrateId = nil
--我的下注数据
local betData
-- 是否跟到底
local isAlwaysBetCoin = false
-- 当前轮是否换过牌
local isCurrentRoundHaveChangedCard = nil
-- 上次换牌的轮数
local lastChangeCardRound = -1
-- 是否下局站起旁观
local isNextRoundStandUp = false
--押满金额
local allInValue = nil
--开牌
local showCard = false
-- 超时弃牌延时
local daleyGiveUpCardThread = nil
-- 超时弃牌的次数
local giveUpCardCount = 0
--本局换牌剩余次数
local changeCardRemainTime = 3



-- 隐藏pk按钮
local function hidePKBtns()
	JinHuaTableButtonGroup.hideBtn(BTN_ID_PK_CANCEL)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_PK_2)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_PK_3)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_PK_4)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_PK_5)
end

--隐藏加注按钮
local function hideRaiseBtns()
	JinHuaTableButtonGroup.hideBtn(BTN_ID_RAISE_ALL)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_RAISE_1)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_RAISE_2)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_RAISE_3)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_RAISE_4)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_RAISE_CANCEL)
end

--显示加注按钮
local function showRaiseBtns()
	JinHuaTableButtonGroup.showBtn(BTN_ID_RAISE_ALL)
	JinHuaTableButtonGroup.showBtn(BTN_ID_RAISE_1)
	JinHuaTableButtonGroup.showBtn(BTN_ID_RAISE_2)
	JinHuaTableButtonGroup.showBtn(BTN_ID_RAISE_3)
	JinHuaTableButtonGroup.showBtn(BTN_ID_RAISE_4)
	JinHuaTableButtonGroup.showBtn(BTN_ID_RAISE_CANCEL)
end

--隐藏操作按钮
local function hideOpBtns()
	JinHuaTableButtonGroup.hideBtn(BTN_ID_FOLD)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_PK)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_CHECK)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_RAISE)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_CALL)
end

--显示操作按钮
local function showOpBtns()
	JinHuaTableButtonGroup.showBtn(BTN_ID_FOLD)
	JinHuaTableButtonGroup.showBtn(BTN_ID_PK)
	JinHuaTableButtonGroup.showBtn(BTN_ID_CHECK)
	JinHuaTableButtonGroup.showBtn(BTN_ID_RAISE)
	JinHuaTableButtonGroup.showBtn(BTN_ID_CALL)
end

-- 操作完更新按钮处理（操作 弃牌，加注，比牌，跟注）
function operateEndUpdateBtns()
	hideRaiseBtns()
	JinHuaTableButtonGroup.setDisable(BTN_ID_CALL)
	JinHuaTableButtonGroup.setDisable(BTN_ID_RAISE)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_ALLIN)
	JinHuaTableButtonGroup.setDisable(BTN_ID_PK)
	showOpBtns()
end

--所以操作按钮不可点
function disableAllTableOperationButtons()
	JinHuaTableButtonGroup.setDisable(BTN_ID_FOLD)
	JinHuaTableButtonGroup.setDisable(BTN_ID_PK)
	JinHuaTableButtonGroup.setDisable(BTN_ID_CHECK)
	JinHuaTableButtonGroup.setDisable(BTN_ID_RAISE)
	JinHuaTableButtonGroup.setDisable(BTN_ID_CALL)
	JinHuaTableButtonGroup.setDisable(BTN_ALWAYS_BET_COIN)
	JinHuaTableButtonGroup.hideBtn(CHECK_BOX_ALWAYS_BET)
	isAlwaysBetCoin = false
end

--[[--
隐藏充值，聊天，换牌，禁比按钮
]]
function dismissFunctionBtns()
	JinHuaTableButtonGroup.hideBtn(BTN_ID_RECHARGE)
--	JinHuaTableButtonGroup.hideBtn(BTN_ID_CHAT)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_CHANGECARD)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_NOPK)
end

--清除桌上按钮
function clearAllTableBtns()
	JinHuaTableButtonGroup.hideMenuBtns()
	JinHuaTableButtonGroup.hideBtn(BTN_ID_READY)

--	JinHuaTableButtonGroup.hideBtn(BTN_ID_CHAT)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_CHANGECARD)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_NOPK)
	disableAllTableOperationButtons()
end

-- 显示充值，聊天，禁比，换牌功能按钮
function showFunctionBtns()
	JinHuaTableButtonGroup.showBtn(BTN_ID_RECHARGE)
--	JinHuaTableButtonGroup.showBtn(BTN_ID_CHAT)
	JinHuaTableButtonGroup.showBtn(BTN_ID_CHANGECARD)
	JinHuaTableButtonGroup.showBtn(BTN_ID_NOPK)
end

--隐藏坐下按钮
function hideSitBtns()
	JinHuaTableButtonGroup.hideBtn(BTN_SIT_ID_1)
	JinHuaTableButtonGroup.hideBtn(BTN_SIT_ID_2)
	JinHuaTableButtonGroup.hideBtn(BTN_SIT_ID_3)
	JinHuaTableButtonGroup.hideBtn(BTN_SIT_ID_4)
	JinHuaTableButtonGroup.hideBtn(BTN_SIT_ID_5)
	JinHuaTableTips.clearAllSitTips()
end

-- 更新我的下注按钮
--跟注按钮  -1表示不可跟注
local function updateMyBetBtns()
	if betData.callCoin == -1 then
		JinHuaTableButtonGroup.setDisable(BTN_ID_CALL)
	else
		JinHuaTableButtonGroup.setEnable(BTN_ID_CALL)
	end
end

-- 更新我的pk和开牌按钮
--比牌按钮  0 不能操作，1 比牌 2 开牌
local function updateMyPKAndShowCardBtns()
	if betData.compareCard == 0 then
		JinHuaTableButtonGroup.setDisable(BTN_ID_PK)
	elseif betData.compareCard == 1 then
		JinHuaTableButtonGroup.setEnable(BTN_ID_PK)
		JinHuaTableTips.showTipPK()
	elseif betData.compareCard == 2 then
		JinHuaTableButtonGroup.setEnable(BTN_ID_PK)
		showCard = true
		JinHuaTableTips.showTipOpenCard()
	end
end

-- 更新看牌按钮
--看牌按钮   0不能看牌， 1可以看牌
local function updateMyLookCardBtns()
	if betData.isMe then
		if betData.cardValues and #betData.cardValues == 3 and betData.cardSprites[1] then
			JinHuaTableButtonGroup.setDisable(BTN_ID_CHECK)
		else
			JinHuaTableButtonGroup.setEnable(BTN_ID_CHECK)
		end
	end
end

-- 更新加注按钮列表
local function updateMyRaiseCoinBtns()
	-- 当前下注人并不是我  我的加注列表不需要更新
	if not betData.raiseCoin then
		return
	end

	--加注列表，如果数组数量不为0，则只能显示押满按钮或加注列表
	local canRaiseCnt = 0
	--加注列表
	for i=1, #betData.raiseCoin do
		local raiseCoin = betData.raiseCoin[i]
		if not raiseCoin then
			break
		end
		if i == 1 then
			if raiseCoin.raiseStatus == 1 then
				JinHuaTableButtonGroup.setEnable(BTN_ID_RAISE_ALL)
				canRaiseCnt = canRaiseCnt + 1
			else
				JinHuaTableButtonGroup.setDisable(BTN_ID_RAISE_ALL)
			end
		else
			JinHuaTableButtonGroup.setText(TEXT_ID_RAISE_1+i-2, raiseCoin.raiseValue)
			if raiseCoin.raiseStatus==1 then
				JinHuaTableButtonGroup.setEnable(BTN_ID_RAISE_1+i-2)
				canRaiseCnt = canRaiseCnt+1
			else
				JinHuaTableButtonGroup.setDisable(BTN_ID_RAISE_1+i-2)
			end
		end
	end

	-- 加注不可点
	if canRaiseCnt == 0 then
		JinHuaTableButtonGroup.setDisable(BTN_ID_RAISE)
	else
		-- 只显示全压
		if canRaiseCnt == 1 and betData.raiseCoin[1] and betData.raiseCoin[1].raiseStatus == 1 then
			JinHuaTableButtonGroup.showBtn(BTN_ID_ALLIN)
			JinHuaTableButtonGroup.hideBtn(BTN_ID_RAISE)
		else -- 显示加注
			JinHuaTableButtonGroup.showBtn(BTN_ID_RAISE)
			JinHuaTableButtonGroup.hideBtn(BTN_ID_ALLIN)
			JinHuaTableButtonGroup.setEnable(BTN_ID_RAISE)
		end
	end
end

-- 更新我的操作按钮
function updateMyOperationBtns(currentPlayer)
	betData = currentPlayer
	JinHuaTableButtonGroup.setEnable(BTN_ID_FOLD)
	updateMyBetBtns()
	updateMyPKAndShowCardBtns()
	updateMyLookCardBtns()
	updateMyRaiseCoinBtns()
end

--准备
function onClick_btnReady()
	local GameData = profile.JinHuaGameData.getGameData()
	if GameData.status == STATUS_TABLE_WAITTING or GameData.status == STATUS_TABLE_READY then
		sendJHID_READY_REQ()
	end
	JinHuaTableButtonGroup.hideBtn(BTN_ID_READY)
end

-- 暂停超时弃牌
local function pauseDaleyGiveUpCardThread()
	if daleyGiveUpCardThread then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(daleyGiveUpCardThread)
		daleyGiveUpCardThread = nil
	end
end

-- 检测是否超过自动弃牌上限数
local function checkIsAutoGiveUpCountFull()
	if (giveUpCardCount >= 3) then
		giveUpCardCount = 0
		return true
	end
end

-- 退出牌桌
function quitGameRoom()
	local GameData = profile.JinHuaGameData.getGameData()
	sendJHID_QUIT_TABLE(GameData.roomId,GameData.tableId)
	ResumeSocket("QuitJinHuaTable");
	mvcEngine.createModule(GUI_HALL)
end

--[[--
--点击弃牌后做的事
--]]
function afterOnClickBtnFold()
	local tableConfirmPopView = JinHuaTableConfirmPopLogic.getTableConfirmPopView();
	if tableConfirmPopView ~= nil then
		--超时弃牌时,如果打开了"系统提示框"要关掉
--		Common.ViewSacleSmall(tableConfirmPopView,1,0.1,0.5,0.5,JinHuaTableConfirmPopLogic.close)
		JinHuaTableConfirmPopLogic.close()
	end
	pauseDaleyGiveUpCardThread()
	sendJHID_DISCARD_REQ()
	JinHuaTableButtonGroup.setDisable(BTN_ID_FOLD)
	JinHuaTableButtonGroup.hideBtn(BTN_ID_ALLIN)
	JinHuaTableButtonGroup.showBtn(BTN_ID_RAISE)
	onClick_btnPK_Cancel()
	JinHuaTablePlayer.updateTableAfterSelfFoldCard()

	if (checkIsAutoGiveUpCountFull()) then
		quitGameRoom()
	end
end

--[[--
--弃牌
--]]
function onClick_btnFold()
	local GameData = profile.JinHuaGameData.getGameData();
	--第6轮点击换桌会弹出提示框
	if GameData.round > 5 then
		mvcEngine.createModule(GUI_JINHUA_TABLECONFIRMPOP)
		JinHuaTableConfirmPopLogic.setTag(JinHuaTableConfirmPopLogic.getTag().TAG_FOLD_TIPS)
	else
		afterOnClickBtnFold();
	end
end

-- 清空连续弃牌数据
local function clearGiveUpCardCount()
	giveUpCardCount = 0
end

--看牌
function onClick_btnCheck()
	clearGiveUpCardCount()
	JinHuaTablePlayer.lookCardStopTimer()
--	if UserGuideUtil.isUserGuide == true then
--		SimulateTableUtil.simulateSelfLookCard();
--		SimulateTableUtil.delaySetOnlyRaiseBtnEnableAndPrompt();
--	else
--		sendJHID_LOOK_CARDS_REQ();
--	end

	sendJHID_LOOK_CARDS_REQ();

	JinHuaTableButtonGroup.setDisable(BTN_ID_CHECK);
end

-- 显示用户比牌按钮
local function showPlayerPKBtns()
	local pkCnt = 0
	local pkId
	local players = JinHuaTablePlayer.getPlayers()
	for i = 1, table.maxn(players) do
		if players[i] and (players[i].status == STATUS_PLAYER_PLAYING or players[i].status == STATUS_PLAYER_LOOKCARD) then
			Common.log(i.."状态："..players[i].status)
			if i==2 then
				JinHuaTableButtonGroup.showBtn(BTN_ID_PK_2)
				pkCnt = pkCnt+1
				pkId = BTN_ID_PK_2
			elseif i==3 then
				JinHuaTableButtonGroup.showBtn(BTN_ID_PK_3)
				pkCnt = pkCnt+1
				pkId = BTN_ID_PK_3
			elseif i==4 then
				JinHuaTableButtonGroup.showBtn(BTN_ID_PK_4)
				pkCnt = pkCnt+1
				pkId = BTN_ID_PK_4
			elseif i==5 then
				JinHuaTableButtonGroup.showBtn(BTN_ID_PK_5)
				pkCnt = pkCnt+1
				pkId = BTN_ID_PK_5
			end
		end
	end

	if pkCnt == 1 then
		if pkId then
			if pkId==BTN_ID_PK_2 then
				onClick_btnPK_2()
			elseif pkId==BTN_ID_PK_3 then
				onClick_btnPK_3()
			elseif pkId==BTN_ID_PK_4 then
				onClick_btnPK_4()
			elseif pkId==BTN_ID_PK_5 then
				onClick_btnPK_5()
			end
		end
	end
end

--比牌
function onClick_btnPK()
	if showCard then
		sendJHID_SHOW_CARDS_REQ()
		showCard = false
		operateEndUpdateBtns()
		JinHuaTablePlayer.closeBetTimer(currentCSID)
		return
	end

	showPlayerPKBtns()
end

--PKCancel
function onClick_btnPK_Cancel()
	hidePKBtns()
end

-- 点击pk执行操作
local function clickPkBtnFunc(playerCSID)
	local players = JinHuaTablePlayer.getPlayers()
	if players[playerCSID] then
		if players[playerCSID].noPK then
			Common.showToast("他使用了【禁比】，你不能和他比牌", 2)
		else
			operateEndUpdateBtns()
			pauseDaleyGiveUpCardThread()
		end
		onClick_btnPK_Cancel()

--		if UserGuideUtil.isUserGuide == true then
--			SimulateTableUtil.simulatePK();
--		else
--			sendJHID_PK_REQ(players[playerCSID].SSID);
--		end

		sendJHID_PK_REQ(players[playerCSID].SSID);
	end
end

--PK2
function onClick_btnPK_2()
	clickPkBtnFunc(2)
end
--PK3
function onClick_btnPK_3()
	clickPkBtnFunc(3)
end
--PK4
function onClick_btnPK_4()
	clickPkBtnFunc(4)
end
--PK5
function onClick_btnPK_5()
	clickPkBtnFunc(5)
end

--跟注
function onClick_btnCall()
	pauseDaleyGiveUpCardThread()
	clearGiveUpCardCount()

	-- 不是新手引导
--	if UserGuideUtil.isUserGuide == false then
--		sendJHID_BET_REQ(betData.callCoin,TYPE_BET_CALL)
--	end

	sendJHID_BET_REQ(betData.callCoin,TYPE_BET_CALL)

	JinHuaTablePlayer.selfClickToBetCoin(TYPE_BET_CALL,betData.callCoin)
	operateEndUpdateBtns()
	onClick_btnPK_Cancel()

--	-- 新手引导
--	if UserGuideUtil.isUserGuide == true then
--		SimulateTableUtil.selfBetCall_2();
--		SimulateTableUtil.disDisableAllBtn();
--		SimulateTableUtil.delayDoXiaomiBetCall();
--	end
end

--跟到底
function onClick_btnAlwaysBetCoin()
	if (isAlwaysBetCoin) then
		JinHuaTableButtonGroup.hideBtn(CHECK_BOX_ALWAYS_BET)
		isAlwaysBetCoin = false
	else
		JinHuaTableButtonGroup.showBtn(CHECK_BOX_ALWAYS_BET)
		isAlwaysBetCoin = true
	end
end

--加注
function onClick_btnRaise()
	clearGiveUpCardCount()
	hideOpBtns()
	showRaiseBtns()
end

-- 全下操作
local function playerClickAllIn()
	pauseDaleyGiveUpCardThread()
	sendJHID_BET_REQ(0,TYPE_BET_ALLIN)
	local minCoin
	if allInValue then
		minCoin = allInValue
	else
		minCoin = JinHuaTablePlayer.getMinCoin()
	end
	JinHuaTablePlayer.selfClickToBetCoin(TYPE_BET_ALLIN, minCoin)
	operateEndUpdateBtns()
	onClick_btnPK_Cancel()
end

--全下
function onClick_btnAllIn()
	playerClickAllIn()
end

--RaiseAll 压满
function onClick_btnRaise_All()
	playerClickAllIn()
	Common.log("压满onClick_btnRaise_All+++++++++++++++++++++")
end

-- 点击加注按钮执行
-- index 加注码位置
local function clickRaiseBtnFunc(index)
	pauseDaleyGiveUpCardThread();
	-- 不是新手引导
--	if UserGuideUtil.isUserGuide == false then
--		sendJHID_BET_REQ(betData.raiseCoin[index].raiseValue,TYPE_BET_RAISE);
--	end

	sendJHID_BET_REQ(betData.raiseCoin[index].raiseValue,TYPE_BET_RAISE);

	JinHuaTablePlayer.selfClickToBetCoin(TYPE_BET_RAISE,betData.raiseCoin[index].raiseValue);
	operateEndUpdateBtns();
	onClick_btnPK_Cancel();

--	if UserGuideUtil.isUserGuide == true then
--		SimulateTableUtil.setRaiseCoinCountByClickIndex(index);
--		SimulateTableUtil.selfBetRaise_1();
--		SimulateTableUtil.disDisableAllBtn();
--		SimulateTableUtil.startNextRound();
--	end
end

--Raise1
function onClick_btnRaise_1()
	clickRaiseBtnFunc(2)
end

--Raise2
function onClick_btnRaise_2()
	clickRaiseBtnFunc(3)
end

--Raise3
function onClick_btnRaise_3()
	clickRaiseBtnFunc(4)
end

--Raise4
function onClick_btnRaise_4()
	clickRaiseBtnFunc(5)
end

--RaiseCancel
function onClick_btnRaise_Cancel()
	hideRaiseBtns()
	showOpBtns()
end

--menu点击：牌型
function onClick_btnCardType()
	Common.setUmengUserDefinedInfo("table_inner_btn_click", "牌型")
	JinHuaTableButtonGroup.hideMenuBtns()
	mvcEngine.createModule(GUI_JINHUA_TABLECARDTYPEPOP)
end

--menu点击：设置
function onClick_btnSet()
	Common.setUmengUserDefinedInfo("table_inner_btn_click", "设置")
	JinHuaTableButtonGroup.hideMenuBtns()
	mvcEngine.createModule(GUI_JINHUA_TABLESETPOP)
end

--[[--
--点击换桌后做的事
--]]
function afterOnClickBtnChangeTable()
	Common.setUmengUserDefinedInfo("table_inner_btn_click", "换桌")
	Common.showProgressDialog("换桌中,请稍后...")
	JinHuaTableLogic.changeTableRemoveSlot()
	ResumeSocket("changeTable")
	clearAllTableBtns()
	sendJHID_CHANGE_TABLE_REQ()
end

--[[--
--menu点击：换桌
--]]
function onClick_btnChangeTable()
	local GameData = profile.JinHuaGameData.getGameData();
	--第6局点击换桌会弹出提示框(我在打牌)
	if profile.JinHuaGameData.isMePlayingThisRound() and GameData.round > 5 then
		mvcEngine.createModule(GUI_JINHUA_TABLECONFIRMPOP)
		JinHuaTableConfirmPopLogic.setTag(JinHuaTableConfirmPopLogic.getTag().TAG_CHANGE_TABLE_TIPS)
	else
		afterOnClickBtnChangeTable();
	end
end

--充值
function onClick_btnRecharge()
	local GameData = profile.JinHuaGameData.getGameData()
	mvcEngine.createModule(GUI_PAYGUIDEPROMPT)
--	PayGuidePromptLogic.setTableQuickPay(true)
	local roomInfo = profile.JinHuaRoomData.getRoomById(GameData.roomId)
	if roomInfo and roomInfo.roomID then
		local roomId = roomInfo.roomID
		if roomId == 1 then
			PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, 1000, RechargeGuidePositionID.TablePositionB)
		elseif roomId == 2 then
			PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, 80000, RechargeGuidePositionID.TablePositionB)
		elseif roomId == 3 then
			PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, 260000, RechargeGuidePositionID.TablePositionB)
		elseif roomId == 4 then
			PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, 80000, RechargeGuidePositionID.TablePositionB)
		elseif roomId == 5 then
			PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, 260000, RechargeGuidePositionID.TablePositionB)
		end
	else
		PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, 80000, RechargeGuidePositionID.TablePositionB)
	end
end

--聊天
function onClick_btnChat()
	Common.setUmengUserDefinedInfo("table_inner_btn_click", "聊天")
	mvcEngine.createModule(GUI_JINHUA_CHATPOP)
end

-- 换牌操作
local function changeCardOperation()
	local GameData = profile.JinHuaGameData.getGameData()
	local roomInfo = profile.JinHuaRoomData.getRoomById(GameData.roomId)
	Common.log("roomInfo.roomType is " .. roomInfo.roomType)
	if roomInfo and roomInfo.roomType ~= 2 then
		Common.showToast("千王场才可使用换牌功能", 2)
		return
	end
	if GameData.round<3 then
		Common.showToast("第3轮后才能使用换牌哦", 2)
		return
	end
	if changeCardRemainTime<1 then
		Common.showToast("每局最多使用三次换牌道具", 2)
		return
	end
	if isCurrentRoundHaveChangedCard and GameData.round == lastChangeCardRound then
		Common.showToast("您本轮已经换过牌了", 2)
		return
	end

	local players = JinHuaTablePlayer.getPlayers()
	local mySelf = profile.JinHuaGameData.getMySelf()
	if GameData.mySSID and mySelf.cardSprites[1] and (players[1].status == STATUS_PLAYER_LOOKCARD or players[1].status == STATUS_PLAYER_PLAYING) then
		if mySelf.cardSprites[1].getValue() then
			JinHuaTableChangeCardPopLogic.setCardValues(mySelf.cardSprites[1].getValue(),mySelf.cardSprites[2].getValue(),mySelf.cardSprites[3].getValue())
			--设置本局换牌的次数
			JinHuaTableChangeCardPopLogic.setChangeCardRemainTime(changeCardRemainTime);
			mvcEngine.createModule(GUI_JINHUA_TABLECHANGECARDPOP)
		else -- 未看牌换牌
			JinHuaTablePlayer.changeCardWhenNotSee = true
			onClick_btnCheck()
		end
	else
		Common.showToast("请等待下局开始", 2)
	end
end

--换牌按钮
function onClick_btnChangeCard()
	Common.setUmengUserDefinedInfo("table_inner_btn_click", "换牌")
	-- 符合弹出购买框条件
	if (changeCardRemainTime == 3 and tonumber(GameConfig.remainChangeCardCnt) < 1) or (changeCardRemainTime == 2 and tonumber(GameConfig.remainChangeCardCnt) < 2)
		or (changeCardRemainTime == 1 and tonumber(GameConfig.remainChangeCardCnt) < 4) then
		mvcEngine.createModule(GUI_JINHUA_TABLEGOODSBUYPOP)
		JinHuaTableGoodsBuyPopLogic.setGoodsInfo(QuickPay.Pay_Guide_changecard_GuideTypeID,RechargeGuidePositionID.TablePositionG)
		return
	end
	changeCardOperation()
end

--禁比
function onClick_btnNoPK()
	local GameData = profile.JinHuaGameData.getGameData()
	local players = JinHuaTablePlayer.getPlayers()
	Common.setUmengUserDefinedInfo("table_inner_btn_click", "禁比")
	if tonumber(GameConfig.remainNoPKCnt) > 0 then
		local mySelf = profile.JinHuaGameData.getMySelf()
		if GameData.mySSID and mySelf.cardSprites[1] and (players[1].status == STATUS_PLAYER_LOOKCARD or players[1].status == STATUS_PLAYER_PLAYING) then
			if mySelf.noPK then
				Common.showToast("本局已使用过禁比卡", 2)
			else
				mvcEngine.createModule(GUI_JINHUA_TABLECONFIRMPOP)
				JinHuaTableConfirmPopLogic.setTag(JinHuaTableConfirmPopLogic.getTag().TAG_NOPK)
			end
		else
			Common.showToast("请等待下局开始", 2)
		end
	else
		mvcEngine.createModule(GUI_JINHUA_TABLEGOODSBUYPOP)
		JinHuaTableGoodsBuyPopLogic.setGoodsInfo(QuickPay.Pay_Guide_no_pk_GuideTypeID,RechargeGuidePositionID.TablePositionG)
	end
end

--menu点击：旁观  站起
function onClick_btnStandUp()
	Common.setUmengUserDefinedInfo("table_inner_btn_click", "站起")
	mvcEngine.createModule(GUI_JINHUA_TABLECONFIRMPOP)
	JinHuaTableConfirmPopLogic.setTag(JinHuaTableConfirmPopLogic.getTag().TAG_STANDUP)
end

-- 取消下局旁观
local function cancelStandUpNextRound()
	JinHuaTableButtonGroup.hideBtn(CHECK_BOX_NEXT_ROUND_STAND_UP)
	isNextRoundStandUp = false
end

--menu点击: 下局站起旁观
function onClick_btnStandUpNextRound()
	if (isNextRoundStandUp) then
		cancelStandUpNextRound()
	else
		JinHuaTableButtonGroup.showBtn(CHECK_BOX_NEXT_ROUND_STAND_UP)
		isNextRoundStandUp = true
	end
end

--坐下点击：座位1
function onClick_btnSit_1()
	JinHuaTablePlayer.sitDownMe(0)
end

--坐下点击：座位2
function onClick_btnSit_2()
	JinHuaTablePlayer.sitDownMe(1)
end

--坐下点击：座位3
function onClick_btnSit_3()
	JinHuaTablePlayer.sitDownMe(2)
end

--坐下点击：座位4
function onClick_btnSit_4()
	JinHuaTablePlayer.sitDownMe(3)
end

--坐下点击：座位5
function onClick_btnSit_5()
	JinHuaTablePlayer.sitDownMe(4)
end

--menu点击：退出
function onClick_btnQuit()
	Common.setUmengUserDefinedInfo("table_inner_btn_click", "退出")
--	mvcEngine.createModule(GUI_JINHUA_TABLECONFIRMPOP)
--	JinHuaTableConfirmPopLogic.setTag(JinHuaTableConfirmPopLogic.getTag().TAG_QUIT)
	mvcEngine.createModule(GUI_JINHUA_TABLEEXIT)

end

-- 设置换牌的当前轮数
function setLastChangeCardRound()
	local GameData = profile.JinHuaGameData.getGameData()
	isCurrentRoundHaveChangedCard = true
	lastChangeCardRound = GameData.round
end

-- 清空上次换牌轮数
local function clearLastChangeCardRound()
	isCurrentRoundHaveChangedCard = false
	lastChangeCardRound = -1
end

--[[--
-- 检测当前是否可以换牌
--]]
local function checkIsCanChangeCard()
	local GameData = profile.JinHuaGameData.getGameData()
	local roomInfo = profile.JinHuaRoomData.getRoomById(GameData.roomId)
	--roomInfo不为nil,房间类型为2(千王场),局数大于等于3，剩余换牌次数大于等于1
	if roomInfo ~= nil and roomInfo.roomType == 2 and GameData.round>=3 and changeCardRemainTime>=1  then
	--当前轮是否换过牌为false
		if not isCurrentRoundHaveChangedCard and GameData.round ~= lastChangeCardRound then
			return profile.JinHuaGameData.isMePlayingThisRound()
		end
	end
	return false;
end

-- 更新是否可以换牌提示
function updateIsCanChangeCardState()
	local GameData = profile.JinHuaGameData.getGameData()
	-- 轮数变更
	if (GameData.round ~= lastChangeCardRound) then
		clearLastChangeCardRound()

		if (checkIsCanChangeCard()) then
			JinHuaTableButtonGroup.showChangeCardAnim() --显示换牌特效
		else
			JinHuaTableButtonGroup.hideChangeCardAnim() --隐藏换牌特效
		end
	end
end

--[[--
-- 换牌成功后更新数据
--@param #number remainChangeCardCnt 剩余换牌道具个数
--@param #number changeCardRemainTime_copy 换牌剩余次数
--]]
function updateDataAfterChangeCardSucc(remainChangeCardCnt, changeCardRemainTime_copy)
	GameConfig.remainChangeCardCnt = remainChangeCardCnt
	changeCardRemainTime = changeCardRemainTime_copy
	JinHuaTableButtonGroup.updateChangeCardCountText()
	JinHuaTableButtonGroup.hideChangeCardAnim()
end

-- 暂停震动任务
function pauseVibrateSchedule()
	if vibrateId then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(vibrateId)
		vibrateId = nil
	end
end

--震动
function vibrate()
	if JinHuaTableSound.isVibrateOn and vibrateId then
		Common.vibrate()
	end
	pauseVibrateSchedule()
end

-- 设置轮到我操作
-- return  如果要开启计时器返回true
function setMyTurnToOperate_ReturnIfNeedMyTimer(player)
	if (isAlwaysBetCoin) then
		if (betData.callCoin <= 0) then
			onClick_btnRaise_All()
		else
			onClick_btnCall()
		end
	elseif player.status ~= STATUS_PLAYER_DISCARD then
		JinHuaTableButtonGroup.showBtn(BTN_ID_CALL)
		JinHuaTableButtonGroup.hideBtn(BTN_ALWAYS_BET_COIN)
		if not vibrateId then
			vibrateId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(vibrate, 10, false)
		end
		return true
	end
end

-- 别人的回合更新我的下注按钮
function updateMyBetBtnsOnOthersTurn()
	JinHuaTableButtonGroup.hideBtn(BTN_ID_CALL)
	JinHuaTableButtonGroup.showBtn(BTN_ALWAYS_BET_COIN)
	if profile.JinHuaGameData.isMePlayingThisRound() then -- 在打牌中
		JinHuaTableButtonGroup.setEnable(BTN_ALWAYS_BET_COIN)
	else
		JinHuaTableButtonGroup.setDisable(BTN_ALWAYS_BET_COIN)
	end
end

-- 超时弃牌
function overTimeGiveUpCard()
--	if (not daleyGiveUpCardThread) and UserGuideUtil.isUserGuide ~= true then
	if (not daleyGiveUpCardThread) then
		giveUpCardCount = giveUpCardCount + 1
		daleyGiveUpCardThread = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(afterOnClickBtnFold, 2, false)
	end
end

-- 本局结束后操作
function gameResultOperation()
--	if UserGuideUtil.isUserGuide == true then
--		sendMANAGERID_GET_JINHUA_USER_GUIDE_PRIZE(UserGuideUtil.GET_NORMAL_PRIZE);
--		return;
--	end

	local GameData = profile.JinHuaGameData.getGameData()
	if (isNextRoundStandUp) then
		JinHuaTablePlayer.selfStandUp()
		cancelStandUpNextRound()
	elseif GameData.mySSID and JinHuaTablePlayer.getPlayers()[1].status ~= STATUS_PLAYER_READY then
		onClick_btnReady()
	end
end

--隐藏座位
function hideSit(csid)
	local GameData = profile.JinHuaGameData.getGameData()
	if not GameData.mySSID then
		Common.log("坐下   座位隐藏+++++++++++++++++++++")
		JinHuaTableButtonGroup.hideBtn(BTN_SIT_ID_1+csid-1)
		JinHuaTableTips.removeSitTip(csid)
	end
end

-- 发牌更新数据
function updateDataSendCard()
	changeCardRemainTime = 3
	showCard = false
end

-- 关闭任务计时器
function closeScheduleTimer()
	pauseVibrateSchedule()
	pauseDaleyGiveUpCardThread()
end

-- 设置全压的金币数
function setAllInValue(value)
	allInValue = value
end

function clear()
	isAlwaysBetCoin = false
	isNextRoundStandUp = false
	allInValue = nil
	showCard = false
	changeCardRemainTime = 3
	clearLastChangeCardRound()
	clearGiveUpCardCount()
end