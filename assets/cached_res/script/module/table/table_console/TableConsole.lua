module("TableConsole", package.seeall)

mode = 0;-- 1是比赛模式 ，2是房间模式
MATCH = 1;
ROOM = 2;

-- 0标准
TABLE_TYPE_NORMAL = 0;
-- 1欢乐玩法
TABLE_TYPE_HAPPY = 1;
-- 2癞子玩法
TABLE_TYPE_OMNIPOTENT = 2;

--------------聊天类型----------------------

--聊天类型：文本
TYPE_CHAT_TEXT = 1
--聊天类型：普通表情
TYPE_CHAT_FACE = 2
--聊天类型：互动表情
TYPE_CHAT_INTERACT = 3
--聊天类型：高级表情
TYPE_CHAT_FACE_SUPERIOR = 4

--牌桌游戏阶段状态
STAT_WAITING_TABLE = 0;-- 等待分桌
STAT_WAITING_READY = 1; -- 等待玩家举手
STAT_SETOUT = 2; -- 准备(发牌阶段)
STAT_CALLSCORE = 3; -- 叫分/叫地主
STAT_GRAB_LANDLORD = 4; -- 抢地主
STAT_DOUBLE_SCORE = 5; -- 加倍
STAT_TAKEOUT = 6; -- 出牌
STAT_GAME_RESULT = 7; -- 游戏结果
STAT_MATCH_RESULT = 8; -- 比赛结果

--牌桌按钮状态
Button_takeout = 1--出牌控制
Button_opencard_start = 2--明牌开始控制
Button_callscore = 3--叫分控制
Button_call_landlord = 4--叫地主控制
Button_grab_landlord = 5--抢地主控制
Button_doublescore = 6--加倍控制
Button_open_takeout = 7--地主首次出牌明牌控制
Button_open_initcard = 8--发牌阶段明牌控制

--牌桌个人相关
m_nGameStatus = 0;--牌桌游戏阶段状态
m_nGameID = 1;-- 游戏ID
m_nRoomID = 0--房间ID
m_nMatchID = 0;--比赛ID
m_nTableID = 0;--
m_nSeatID = -1;--自己的座位号

--牌桌比赛相关信息
m_nRank = 0;-- 自己的名次
msMatchTitle = nil;-- 比赛标题
m_nCurrUser= 0;-- 当前人数
mbIsEmigrated = false;-- 是否闯关赛

--牌桌房间相关信息
m_aPlayer = {}--牌桌用户信息
mnTableType = 0 --牌桌游戏模式 0标准 1欢乐玩法2癞子玩法
isGameResultReady = false;--是否是一局结束后的准备
m_bSendContinue = false;--是否已经发过准备
mnIsOpenCardsReady = 0;--明牌开始的牌值
m_nRemainCardCnt = 54;
m_bSetout = false;
m_bTakeout = false;
--STAT_CALLSCORE = 3;叫分 STAT_GRAB_LANDLORD = 4;抢地主 STAT_DOUBLE_SCORE = 5;加倍 STAT_TAKEOUT = 6;出牌
m_nCurrBtnType = 0;

-- 记牌器牌值
cardRecord = {};

msRoomTitle = nil;-- 房间标题
TableHintMsg = nil--进入房间后牌桌上显示的提示
msBaseChipText = nil--房间筹码基数提示语
m_nRoombaseChip = nil -- 房间金币底数
local m_nCurrPlayer = -1;-- 当前操作的玩家
m_nCurrCallScore = 0;-- 已经叫到的分值
local m_nMultiple = 1;-- 倍数
local m_nBaseChip = 0;-- 筹码基数
mnRoomMinCoin = 0;-- 当前房间金币下限
mnReservedCardTimes = 1;-- 底牌特殊牌型倍数
mbIsShowReservedCard = false;-- 是否已经显示过底牌特殊牌型
msReservedCardName = nil;-- 底牌特殊牌型名称
m_bSendTableNotEnded = false;-- 是否处于牌桌等待状态
m_nNotEndedCnt = 0;--当前剩余未结束的比赛桌数
m_bReadTableChanged = false;
m_bIsWaitingTable = false;--是否进入等候区
m_bReadInitCard = false;
m_nUserCnt = 0;-- 桌上用户数
m_nInitTimerVal= 0;-- 倒计时初始值
m_sMatchInstanceID = nil; --当前比赛实例
m_sGameTask = nil;-- 游戏任务
m_bScoreFlag = false;
msNoticeText = nil;-- 开赛广播的文字
mnLaiziCardVal = -1;-- 癞子牌牌值(老虎机动画以后)
tempLaiziCardVal = -1;-- 癞子牌牌值(发底牌后，老虎机动画之前)

--牌桌宝箱相关
m_nTreasureLockDuration = 0;-- 宝箱锁定时长 秒

isSendOpenCards = false;
m_bShowPlayers = false;
-- 本局第一个叫分的玩家座位号
m_nCallScorePlayerSeat = 0;

INIT_TIMER = 15;
INIT_TIMER_SELF_LOSS = 0;
m_nCountdownCnt = INIT_TIMER;--当前剩余时间
takeoutTime = 0;-- 连续超时次数

m_anPlayerCardType = {}--牌桌上的牌类型( 下标是牌桌的位置+1 ====== pos + 1 )

m_bSendTakeOutCard = false;
m_bPassFlag = false;
local m_anOutCard = {}--本次打出的手牌
local tableCost = 0;--桌费
IsOpenCardsEnd = 0;--是否明牌结束
--牌桌上玩家的位置数字 自己0;下家1;上家2;
MYSELF_PLAYER_NUMBER = 0
RIGHT_PLAYER_NUMBER = 1
LEFT_PLAYER_NUMBER = 2
--要踢掉的玩家的下标
local position = nil
--是否是玩家被踢出后的等待状态
local isAfterKickWait = false

RoomLevel = 0;
baohePro = 0;--已完成局数
baoheMax = 0;--总局数

local roomIsWin = false --牌桌胜利或是失败
local roomMultiple = 0 --牌桌倍数
isCrazyStage = false --是否是疯狂闯关
canPlayCrazy = false --是否可以闯关
stoneRechargeId = nil --购买复活石的引导ID
crazyIsLord = false --闯关中是否是地主
crazyMission = nil --闯关关数

removePlayerTable = {} --玩家退出标志table
kickPlayerTable = {} --玩家踢人标志table

bShouldExitCurrentMatch = false -- 是否退出当前比赛
bShouldShowJijiangkaisai = false -- 是否显示即将开赛弹框
bMatchIsOvered = false -- 比赛是否已结束
bHallShouldShowCertificateAlert = false -- 是否显示奖状弹框
tJijiangkaisaiMatchItem = -1 -- 即将开赛的比赛

softGuideTableText = "SoftGuideTable" --软引导Table存储名称
softGuideTable = Common.LoadTable(softGuideTableText) --软引导Table
pLastForceQuitMatchInstance = nil; -- 上一次强退比赛的比赛实例
m_bSelfDidMingpai = false; -- 自己是否已明牌

local gameResultAction = nil -- 牌局结束动画

--[[--
--判断牌局是否正在进行中
--]]
function isPlayingDoudizhu()
	Common.log("isPlayingDoudizhu m_nGameStatus = "..m_nGameStatus)
	if m_nGameStatus >= STAT_WAITING_READY and m_nGameStatus <= STAT_TAKEOUT then
		return true
	end

	return false
end

--[[--
--重置牌桌数据
--]]
function releaseTableData()
	Common.log("重置牌桌数据")
	mode = 0;-- 1是比赛模式 ，2是房间模式

	--牌桌个人相关
	m_nGameStatus = 0;--牌桌游戏阶段状态
	m_nGameID = 1;-- 游戏ID
	m_nRoomID = 0--房间ID
	m_nMatchID = 0;--比赛ID
	m_nTableID = 0;--
	m_nSeatID = -1;--自己的座位号

	--牌桌比赛相关信息
	m_nRank = 0;-- 自己的名次
	msMatchTitle = nil;-- 比赛标题
	m_nCurrUser= 0;-- 当前人数
	mbIsEmigrated = false;-- 是否闯关赛

	--牌桌房间相关信息
	m_aPlayer = {}--牌桌用户信息
	mnTableType = 0 --牌桌游戏模式 0标准 1欢乐玩法2癞子玩法
	isGameResultReady = false;--是否是一局结束后的准备
	m_bSendContinue = false;--是否已经发过准备
	mnIsOpenCardsReady = 0;--明牌开始的牌值
	m_nRemainCardCnt = 54;
	m_bSetout = false;
	m_bTakeout = false;
	m_nCurrBtnType = 0;
	-- 记牌器牌值
	cardRecord = {};

	msRoomTitle = nil;-- 房间标题
	TableHintMsg = nil--进入房间后牌桌上显示的提示
	msBaseChipText = nil--房间筹码基数提示语
	m_nCurrPlayer = -1;-- 当前操作的玩家
	m_nCurrCallScore = 0;-- 已经叫到的分值
	m_nMultiple = 1;-- 倍数
	m_nBaseChip = 0;-- 筹码基数
	mnRoomMinCoin = 0;-- 当前房间金币下限
	mnReservedCardTimes = 1;-- 底牌特殊牌型倍数
	mbIsShowReservedCard = false;-- 是否已经显示过底牌特殊牌型
	msReservedCardName = nil;-- 底牌特殊牌型名称
	m_bSendTableNotEnded = false;-- 是否处于牌桌等待状态
	m_nNotEndedCnt = 0;--当前剩余未结束的比赛桌数
	m_bReadTableChanged = false;
	m_bIsWaitingTable = false;
	m_bReadInitCard = false;
	m_nUserCnt = 0;-- 桌上用户数
	m_nInitTimerVal= 0;-- 倒计时初始值
	--m_sMatchInstanceID = nil;
	m_sGameTask = nil;-- 游戏任务
	m_bScoreFlag = false;
	msNoticeText = nil;-- 开赛广播的文字
	mnLaiziCardVal = -1;-- 癞子牌牌值(老虎机动画以后)
	tempLaiziCardVal = -1;-- 癞子牌牌值(发底牌后，老虎机动画之前)

	--牌桌宝箱相关
	m_nTreasureLockDuration = 0;-- 宝箱锁定时长 秒

	isSendOpenCards = false;
	m_bShowPlayers = false;
	-- 本局第一个叫分的玩家座位号
	m_nCallScorePlayerSeat = 0;

	INIT_TIMER = 15;
	INIT_TIMER_SELF_LOSS = 0;
	m_nCountdownCnt = INIT_TIMER;--当前剩余时间
	takeoutTime = 0;-- 连续超时次数

	m_anPlayerCardType = {}--牌桌上的牌类型( 下标是牌桌的位置+1 ====== pos + 1 )

	m_bSendTakeOutCard = false;
	m_bPassFlag = false;
	m_anOutCard = {}--本次打出的手牌
	tableCost = 0;
	IsOpenCardsEnd = 0;--是否明牌结束
	RoomLevel = 0;
	baohePro = 0;
	baoheMax = 0;
	bMatchIsOvered = false -- 比赛是否已结束
	pLastForceQuitMatchInstance = nil;

	gameResultAction = nil

	m_bSelfDidMingpai = nil;

--TableElementLayer.setDiZhu(5)
end

--[[--
--设置桌费
--]]
function setTableCost(Cost)
	if Cost ~= nil then
		tableCost = Cost;
	end
end

--[[--
--获取桌费
--]]
function getTableCost()
	return tableCost;
end

function getCurrPlayer()
	return m_nCurrPlayer
end

--[[--
--设置当期操作用户
--]]
function setCurrPlayer(seatID)
	m_nCurrPlayer = seatID
	TableElementLayer.showClock(m_nCurrPlayer)
end

--[[--
--获取当前倍数
--]]
function getMultiple()
	return m_nMultiple
end
--[[--
--设置当前倍数
--]]
function setMultiple(multiple)
	if multiple <= 0 then
		return;
	end
	local isShowBig = false;
	if multiple > m_nMultiple then
		isShowBig = true;
	end
	m_nMultiple = multiple
	TableLogic.updataTableMultiple(m_nMultiple, isShowBig)
end
--[[--
--获取当前筹码基数
--]]
function getBaseChip()
	return m_nBaseChip
end
--[[--
--设置当前筹码基数
--]]
function setBaseChip(baseChip)
	m_nBaseChip = baseChip
	TableLogic.updataTableBaseChip(m_nBaseChip)
end

--[[
取出TableCard_NUM数组里一张牌的index,即是what
]]
function getWhatByValue(nVal)
	local what = 0;
	if (nVal < 52) then
		what = nVal % 13;
	elseif (nVal == 52) then
		-- 小王
		what = 13;
	elseif (nVal == 53) then
		-- 大王
		what = 14;
	end
	--Common.log("getWhatByValue what = "..what)

	return what;
end

--[[--
--设置记牌器数据
--]]
local function setCardRecord(nVal)
	--Common.log("setCardRecord nVal = "..nVal)
	cardRecord["What_"..TableCard_NUM[getWhatByValue(nVal) + 1]] = cardRecord["What_"..TableCard_NUM[getWhatByValue(nVal) + 1]] + 1;
end

--[[--
-- 初始化记牌器
--]]
local function initCardRecord()
	cardRecord = {};
	for i = 1, #TableCard_NUM do
		cardRecord["What_"..TableCard_NUM[i]] = 0;
	end
end

--[[--
* 判断是否是癞子牌
*
* @param valOrWhat
* @return
--]]
function isLaizi(valOrWhat)
	local isLaizi = false;
	if (valOrWhat < 52 and mnLaiziCardVal >= 0) then
		if (mnLaiziCardVal % 13 == valOrWhat % 13) then
			isLaizi = true;
		end
	end
	return isLaizi;
end

--[[
判断是否是癞子牌，记牌器需要在发完底牌时直到癞子牌，故添加此方法
]]
function isLaiziEarly(valOrWhat)
	local isLaizi = false;
	if (valOrWhat < 52 and tempLaiziCardVal >= 0) then
		if (tempLaiziCardVal % 13 == valOrWhat % 13) then
			isLaizi = true;
		end
	end
	return isLaizi;
end

function getSelfSeat()
	return m_nSeatID;
end

function getRightSeat()
	if #m_aPlayer > 0 then
		for i = 1, #m_aPlayer do
			local player = m_aPlayer[i]
			if player.m_nPos == 1 then
				-- 下家
				return player.m_nSeatID
			end
		end
	end
end

function getLeftSeat()
	if #m_aPlayer > 0 then
		for i = 1, #m_aPlayer do
			local player = m_aPlayer[i]
			if player.m_nPos == 2 then
				-- 上家
				return player.m_nSeatID
			end
		end
	end
end

--[[--
--得到牌桌上的用户数量
--]]
function getPlayerCnt()
	return m_nUserCnt;
end

--[[--
--获取地主的座位号
--]]
function getPlayerSeatIDforLord()
	local seatID = nil;
	if (m_aPlayer ~= nil) then
		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				if (m_aPlayer[i].m_bIsLord) then
					seatID = m_aPlayer[i].m_nSeatID;
				end
			end
		end
	end
	return seatID;
end

--[[--
根据用户的userid，得到用户
--]]
function getPlayerPosByUserID(UserID)
	if (m_aPlayer ~= nil) then
		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				if (m_aPlayer[i].m_nUserID == UserID) then
					return m_aPlayer[i];
				end
			end
		end
	end
end

--[[--
-- 根据座位号取出玩家在牌桌中位置
--
-- @param #number nSeatID 座位号
-- @return
--]]
function getPlayerPosBySeat(nSeatID)
	local i = (nSeatID - getSelfSeat() + m_nUserCnt) % m_nUserCnt;
	return i;
end

--[[--
-- 根据玩家在牌桌上的位置取出其座位号
-- @number i pos
-- @return
--]]
function getPlayerSeatByPos(i)
	local nSeat = (i + getSelfSeat()) % m_nUserCnt;
	return nSeat;
end


--[[--
-- 根据座位号取出玩家数组的下标
--
-- @param #number nSeatID 座位号
-- @return local
--]]
function getPlayerIdxBySeat(nSeatID)
	if (m_aPlayer ~= nil) then
		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				if (m_aPlayer[i].m_nSeatID == nSeatID) then
					return i;
				end
			end
		end
	end
	return -1;
end

--[[--
--通过座位号获取用户信息
--@param #number nSeatID 座位号
--@return #TablePlayer 用户信息
--]]
function getPlayer(nSeatID)
	Common.log("nSeatID = "..nSeatID)
	if (m_aPlayer ~= nil) then
		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				if (m_aPlayer[i].m_nSeatID == nSeatID) then
					return m_aPlayer[i];
				end
			end
		end
	end
	Common.log("m_aPlayer is nil")
	return nil;
end

--[[--
--删除指定座位号的用户
--@param #number nSeatID 座位号
--]]
function removePlayer(nSeatID)
	local nIdx = getPlayerIdxBySeat(nSeatID);
	if (nIdx == -1 or nIdx > #m_aPlayer) then

	else
		GameArmature.hideTableArmature(m_aPlayer[nIdx].m_nPos)
		m_aPlayer[nIdx] = {};
	end
	TableElementLayer.setTableUserInfo();
end

--[[--
--删除所用用户
--@param #number nSeatID 座位号
--]]
function removePlayerAll()
	m_aPlayer = {}
	TableElementLayer.setTableUserInfo();
end

--[[--
-- 根据当前已经叫到的分值显示叫分按钮
--]]
function setDoubleScoreBtn(CanDoubleMax)
	CanDoubleMax = 2
	--	LordMgr.getInst().updateUI(LordMgr.GAMEBTN_ALL_ENABLE, true, -1);
	if CanDoubleMax == 0 then
	--不可加倍
	--m_nHlocalID = NO_DOUBLE;
	--m_nHlocalCnt = HINT_MAX * 4;
	--		LordMgr.getInst().updateUI(LordMgr.GAMEBTN_HIDE, true, -1);
	elseif CanDoubleMax == 2 then
	--可以加两倍
	--		LordMgr.getInst().updateUI(LordMgr.GAMEBTN_SHOW, true, -1);
	--		LordMgr.getInst().updateUI(LordMgr.GAMEBTN_2_GRAY, true, -1);
	elseif CanDoubleMax == 4 then
	--可以加四倍
	--		LordMgr.getInst().updateUI(LordMgr.GAMEBTN_SHOW, true, -1);
	end
end

--[[--
--设置牌桌所有用户动画
--]]
function setAllTablePalyerAnim(nAnimType)
	if (m_aPlayer ~= nil) then
		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				if (m_aPlayer[i].m_nSeatID ~= getSelfSeat()) then
					m_aPlayer[i]:setAnim(nAnimType)
				end
			end
		end
	end
end

--[[--
--设置牌桌状态
--@param #number nStatus 牌桌状态
--]]
function setStatus(nStatus)
	Common.log("setStatus nStatus = "..nStatus)

	m_nGameStatus = nStatus;
	if m_nGameStatus == STAT_WAITING_TABLE then
		-- 等待分桌
		if isAfterKickWait == false then
			GameArmature.hideAllTableArmature();
			removePlayerAll();
		else
			isAfterKickWait = false
		end
	elseif m_nGameStatus == STAT_WAITING_READY then
		-- 等待玩家举手
		-- 不再显示加倍信息
		if (m_aPlayer ~= nil) then
			for i = 1, #m_aPlayer do
				if (m_aPlayer[i] ~= nil) then
					m_aPlayer[i].m_nDoubleScore = -1;
				end
			end
		end
		TableElementLayer.showTableWaitTips()
	elseif m_nGameStatus == STAT_SETOUT then
		-- 准备
		m_bSetout = false;
		if (mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT) then
			--欢乐/癞子
			setCurrPlayer(-1)
			--[[
			if mode == ROOM then
			-- 如果是房间模式，则在发牌阶段显示明牌按钮
			m_nCurrBtnType = Button_open_initcard
			if (getPlayer(getSelfSeat()).mnOpenCardsTimes == 1 and getPlayer(getSelfSeat()).m_bTrustPlay == false) then
			TableLogic.changeShowButtonPanel(m_nCurrBtnType)
			end
			else
			-- 不显示任何按钮
			TableLogic.hideGameBtn()
			end
			]]
			if getPlayer(getSelfSeat()).mnOpenCardsTimes == 1 and getPlayer(getSelfSeat()).m_bTrustPlay == false and mode == ROOM then
				m_nCurrBtnType = Button_open_initcard
				TableLogic.changeShowButtonPanel(m_nCurrBtnType)
			end
		else
			--普通
			PauseSocket("发牌");
		end
	elseif m_nGameStatus == STAT_CALLSCORE then
		-- 叫分
		IsOpenCardsEnd = 0;

		Common.log("叫分m_nCurrPlayer ==== "..m_nCurrPlayer)
		if (m_nCurrPlayer == -1) then
			return;
		end
		ResumeSocket("叫分");

		m_nCurrCallScore = 0;

		if (mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT) then
			--欢乐/癞子(叫地主)
			m_nCurrBtnType = Button_call_landlord
			--显示叫分按钮
			if (m_nCurrPlayer == getSelfSeat() and getPlayer(getSelfSeat()).m_bTrustPlay == false) then
				TableLogic.changeShowButtonPanel(m_nCurrBtnType);
			end
			TableElementLayer.showClock(m_nCurrPlayer);
		else
			--普通(叫分)
			m_nCurrBtnType = Button_callscore

			--显示叫分按钮
			if (m_nCurrPlayer == getSelfSeat() and getPlayer(getSelfSeat()).m_bTrustPlay == false) then
				TableLogic.changeShowButtonPanel(m_nCurrBtnType);
				TableLogic.setCallScoreBtn(m_nCurrCallScore);
			end
			TableElementLayer.showClock(m_nCurrPlayer);
		end
	elseif m_nGameStatus == STAT_GRAB_LANDLORD then
		-- 抢地主
		m_nCurrBtnType = Button_grab_landlord;
	elseif m_nGameStatus == STAT_DOUBLE_SCORE then
		-- 加倍
		--		Common.log("zblaaaz........加倍1")
		m_nCurrBtnType = Button_doublescore;
		if (m_nCurrPlayer == getSelfSeat() and getPlayer(getSelfSeat()).m_bTrustPlay == false) then
			--			Common.log("zblaaaz........加倍2")
			--设置
			setLandLordDouble()
			TableLogic.changeShowButtonPanel(m_nCurrBtnType)
		end
	elseif m_nGameStatus == STAT_TAKEOUT then
		-- 出牌
		m_bTakeout = false;
		m_nCurrBtnType = Button_takeout;
		--牌桌软引导动画 选牌提示
		if softGuideTable == nil then
			TableElementLayer.showSoftGuideSlitherPick()
			softGuideTable = {}
			softGuideTable[profile.User.getSelfUserID() .. ""] = {}
			softGuideTable[profile.User.getSelfUserID() .. ""].pick = true
			Common.SaveTable(softGuideTableText,softGuideTable)
		elseif softGuideTable[profile.User.getSelfUserID() .. ""] == nil then
			TableElementLayer.showSoftGuideSlitherPick()
			softGuideTable[profile.User.getSelfUserID() .. ""] = {}
			softGuideTable[profile.User.getSelfUserID() .. ""].pick = true
			Common.SaveTable(softGuideTableText,softGuideTable)
		elseif softGuideTable[profile.User.getSelfUserID() .. ""].pick == nil then
			TableElementLayer.showSoftGuideSlitherPick()
			softGuideTable[profile.User.getSelfUserID() .. ""].pick = true
			Common.SaveTable(softGuideTableText,softGuideTable)
		end
	elseif m_nGameStatus == STAT_GAME_RESULT then
	-- 游戏结果
	elseif m_nGameStatus == STAT_MATCH_RESULT then
	-- 比赛结果
	end
end

--[[--
--检测牌中有多少张癞子牌
--
--@param cardList
--@param nCardCnt
--@return
--]]
local function hasLaiZiCardNum(cardList)
	local LaiZiNum = 0;
	for i = 1, #cardList do
		if (cardList[i].mbLaiZi) then
			LaiZiNum = LaiZiNum + 1;
		end
	end
	return LaiZiNum;
end

--[[--
--设置出牌后的一些效果
--
--@param #type nCardCnt 出牌的数量
--@param #type nPlayer 玩家seatID
--@param #type isNewBout 是否新一轮出牌
--]]
local function setTakeOutEffect(nCardCnt, nPlayer, isNewBout)
	local nPos = getPlayerPosBySeat(nPlayer)
	Common.log("设置出牌后的一些效果    nPos ======== "..nPos)
	m_anPlayerCardType[nPos + 1] = -1;-- 不要时牌型为-1
	local pauseRecv = false;
	if TableCardLayer.getPlayerTableCards() == nil then
		return pauseRecv;
	end
	if (TableCardLayer.getPlayerTableCards()[nPos + 1] == nil) then
		return pauseRecv;
	end
	local nCardCnt = #TableCardLayer.getPlayerTableCards()[nPos + 1]
	if (nCardCnt == 0) then

	else
		local nType = TableCardManage.GetCardType(TableCardLayer.getPlayerTableCards()[nPos + 1], nCardCnt);
		m_anPlayerCardType[nPos + 1] = nType;
		local nSoundID = nil;

		if nType == TableCardManage.TYPE_ONE then
			-- 单张
			local nNum = hasLaiZiCardNum(TableCardLayer.getPlayerTableCards()[nPos + 1]);
			if (nNum > 0) then
			-- 单出癞子牌
			--						if (Console.logicTableLaiZiTips(Console.TableLaiZiHlocal2)) {
			--							LordActivity.mnLaiZiCardTipsType = Console.TableLaiZiHlocal2;
			--							LordMgr.getInst().updateUI(LordMgr.SHOW_LAIZI_TIPS, false, 100);
			--						}
			end
			if TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 0 then
				nSoundID = AudioManager.TableVoice.CARD_3;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 1 then
				nSoundID = AudioManager.TableVoice.CARD_4;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 2 then
				nSoundID = AudioManager.TableVoice.CARD_5;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 3 then
				nSoundID = AudioManager.TableVoice.CARD_6;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 4 then
				nSoundID = AudioManager.TableVoice.CARD_7;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 5 then
				nSoundID = AudioManager.TableVoice.CARD_8;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 6 then
				nSoundID = AudioManager.TableVoice.CARD_9;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 7 then
				nSoundID = AudioManager.TableVoice.CARD_10;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 8 then
				nSoundID = AudioManager.TableVoice.CARD_J;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 9 then
				nSoundID = AudioManager.TableVoice.CARD_Q;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 10 then
				nSoundID = AudioManager.TableVoice.CARD_K;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 11 then
				nSoundID = AudioManager.TableVoice.CARD_A;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 12 then
				nSoundID = AudioManager.TableVoice.CARD_2;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 13 then
				nSoundID = AudioManager.TableVoice.XIAOWANG;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 14 then
				nSoundID = AudioManager.TableVoice.DAWANG;
			end
		elseif nType == TableCardManage.TYPE_TWO then
			-- 对，要有多少对的说明

			if TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 0 then
				nSoundID = AudioManager.TableVoice.DUI_3;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 1 then
				nSoundID = AudioManager.TableVoice.DUI_4;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 2 then
				nSoundID = AudioManager.TableVoice.DUI_5;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 3 then
				nSoundID = AudioManager.TableVoice.DUI_6;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 4 then
				nSoundID = AudioManager.TableVoice.DUI_7;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 5 then
				nSoundID = AudioManager.TableVoice.DUI_8;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 6 then
				nSoundID = AudioManager.TableVoice.DUI_9;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 7 then
				nSoundID = AudioManager.TableVoice.DUI_10;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 8 then
				nSoundID = AudioManager.TableVoice.DUI_J;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 9 then
				nSoundID = AudioManager.TableVoice.DUI_Q;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 10 then
				nSoundID = AudioManager.TableVoice.DUI_K;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 11 then
				nSoundID = AudioManager.TableVoice.DUI_A;
			elseif TableCardLayer.getPlayerTableCards()[nPos + 1][1].m_nWhat == 12 then
				nSoundID = AudioManager.TableVoice.DUI_2;
			end
		elseif nType == TableCardManage.TYPE_MANY_THREE or
			nType == TableCardManage.TYPE_MANY_THREE_ONE or
			nType == TableCardManage.TYPE_MANY_THREE_TWO then
			-- 飞机
			setAllTablePalyerAnim(GameArmature.ARMATURE_ZHADAN)
			GameArmature.setTableArmature(GameArmature.ARMATURE_TABLE_FEIJI)
			if (isNewBout) then
				-- 新回合
				local next = math.random(0, 1);
				if next == 0 then
					nSoundID = AudioManager.TableVoice.FEIJI;
				elseif next == 1 then
					nSoundID = AudioManager.TableVoice.HUIJI;
				end
			end

			AudioManager.playLordSound(AudioManager.TableSound.SOUND_FEIJI, false, AudioManager.SOUND);
		elseif nType == TableCardManage.TYPE_STRAIGHT then
			-- 顺子，5张或更多的连张
			GameArmature.setTableArmature(GameArmature.ARMATURE_TABLE_SHUNZI)
			if (isNewBout) then
				-- 新回合
				nSoundID = AudioManager.TableVoice.SHUNZI;
			end

			AudioManager.playLordSound(AudioManager.TableSound.SOUND_SHUNZI, false, AudioManager.SOUND);
		elseif nType == TableCardManage.TYPE_FOUR then
			-- 四同张，炸弹

			-- 设备是否需要震动
			if GameConfig.getGameVibrate() then
				-- 设备开始震动
				Common.doVibrate()
			end

			local nLaiZiNum = hasLaiZiCardNum(TableCardLayer.getPlayerTableCards()[nPos + 1]);
			setAllTablePalyerAnim(GameArmature.ARMATURE_ZHADAN)
			GameArmature.setTableArmature(GameArmature.ARMATURE_TABLE_ZHADAN)
			local next = math.random(0, 2);
			if next == 0 then
				nSoundID = AudioManager.TableVoice.ZHADAN;
			elseif next == 1 then
				nSoundID = AudioManager.TableVoice.ZHADNI;
			elseif next == 2 then
				nSoundID = AudioManager.TableVoice.ZHADANFANBEI;
			end

			AudioManager.playLordSound(AudioManager.TableSound.SOUND_ZHADAN, false, AudioManager.SOUND);
			if (nLaiZiNum == 4) then
				-- 天炸
				setMultiple(m_nMultiple * 4)
				--								m_nBombTimes = m_nBombTimes * 4;
				--								if (Console.logicTableLaiZiTips(Console.TableLaiZiHlocal5)) {
				--									LordActivity.mnLaiZiCardTipsType = Console.TableLaiZiHlocal5;
				--									LordMgr.getInst().updateUI(LordMgr.SHOW_LAIZI_TIPS, false, 100);
				--								}
			elseif (nLaiZiNum > 0 and nLaiZiNum < 4) then
				-- 软炸
				setMultiple(m_nMultiple * 2)
				--								m_nBombTimes = m_nBombTimes * 2;
				--								if (Console.logicTableLaiZiTips(Console.TableLaiZiHlocal3)) {
				--									LordActivity.mnLaiZiCardTipsType = Console.TableLaiZiHlocal3;
				--									LordMgr.getInst().updateUI(LordMgr.SHOW_LAIZI_TIPS, false, 100);
				--								}
			elseif (nLaiZiNum == 0) then
				-- 硬炸
				setMultiple(m_nMultiple * 2)
				--				m_nBombTimes = m_nBombTimes * 2;
				--								if (Console.logicTableLaiZiTips(Console.TableLaiZiHlocal4)) {
				--									LordActivity.mnLaiZiCardTipsType = Console.TableLaiZiHlocal4;
				--									LordMgr.getInst().updateUI(LordMgr.SHOW_LAIZI_TIPS, false, 100);
				--								}
			end
			if not TableCardLayer.getPlayerCardsIsGone() then
				AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.ZHADAN_BACKGROUND)
			end
			if mnTableType == TABLE_TYPE_OMNIPOTENT then
				--牌桌软引导动画 炸弹牌型
				--				softGuideTable = Common.LoadTable(softGuideTableText)
				if softGuideTable == nil then
					TableElementLayer.showSoftGuideBomb()
					softGuideTable = {}
					softGuideTable[profile.User.getSelfUserID() .. ""] = {}
					softGuideTable[profile.User.getSelfUserID() .. ""].bomb = true
					Common.SaveTable(softGuideTableText,softGuideTable)
				elseif softGuideTable[profile.User.getSelfUserID() .. ""] == nil then
					TableElementLayer.showSoftGuideBomb()
					softGuideTable[profile.User.getSelfUserID() .. ""] = {}
					softGuideTable[profile.User.getSelfUserID() .. ""].bomb = true
					Common.SaveTable(softGuideTableText,softGuideTable)
				elseif softGuideTable[profile.User.getSelfUserID() .. ""].bomb == nil then
					TableElementLayer.showSoftGuideBomb()
					softGuideTable[profile.User.getSelfUserID() .. ""].bomb = true
					Common.SaveTable(softGuideTableText,softGuideTable)
				end
			end
		elseif nType == TableCardManage.TYPE_TWO_CAT then
			-- 火箭

			-- 设备是否需要震动
			if GameConfig.getGameVibrate() then
				-- 设备开始震动
				Common.doVibrate()
			end

			setAllTablePalyerAnim(GameArmature.ARMATURE_ZHADAN)
			GameArmature.setTableArmature(GameArmature.ARMATURE_TABLE_HUOJIAN)
			nSoundID = AudioManager.TableVoice.HUOJIAN;
			AudioManager.playLordSound(AudioManager.TableSound.SOUND_HUOJIAN, false, AudioManager.SOUND);

			setMultiple(m_nMultiple * 2)

			if not TableCardLayer.getPlayerCardsIsGone() then
				AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.ZHADAN_BACKGROUND)
			end
			if mnTableType == TABLE_TYPE_OMNIPOTENT then
				--牌桌软引导动画 炸弹牌型
				--				softGuideTable = Common.LoadTable(softGuideTableText)
				if softGuideTable == nil then
					TableElementLayer.showSoftGuideBomb()
					softGuideTable = {}
					softGuideTable[profile.User.getSelfUserID() .. ""] = {}
					softGuideTable[profile.User.getSelfUserID() .. ""].bomb = true
					Common.SaveTable(softGuideTableText,softGuideTable)
				elseif softGuideTable[profile.User.getSelfUserID() .. ""] == nil then
					TableElementLayer.showSoftGuideBomb()
					softGuideTable[profile.User.getSelfUserID() .. ""] = {}
					softGuideTable[profile.User.getSelfUserID() .. ""].bomb = true
					Common.SaveTable(softGuideTableText,softGuideTable)
				elseif softGuideTable[profile.User.getSelfUserID() .. ""].bomb == nil then
					TableElementLayer.showSoftGuideBomb()
					softGuideTable[profile.User.getSelfUserID() .. ""].bomb = true
					Common.SaveTable(softGuideTableText,softGuideTable)
				end
			end
		elseif nType == TableCardManage.TYPE_MANY_TWO then
			-- 连对
			if (isNewBout) then
				-- 新回合
				nSoundID = AudioManager.TableVoice.LIANDUI;
			end
		elseif nType == TableCardManage.TYPE_THREE then
			-- 三个
			nSoundID = AudioManager.TableVoice.SANGE;
		elseif nType == TableCardManage.TYPE_THREE_ONE then
			-- 三带1
			if (isNewBout) then
				-- 新回合
				nSoundID = AudioManager.TableVoice.SANDAIYI;
			end
		elseif nType == TableCardManage.TYPE_THREE_SAMETWO then
			-- 三带1对
			if (isNewBout) then
				-- 新回合
				nSoundID = AudioManager.TableVoice.SANDAIYIDUI;
			end
		elseif nType == TableCardManage.TYPE_FOUR_TWO or nType == TableCardManage.TYPE_FOUR_SAMETWO then
			-- 4带二
			-- 4带1对
			if (isNewBout) then
				-- 新回合
				nSoundID = AudioManager.TableVoice.SIDAIER;
			end
		elseif nType == TableCardManage.TYPE_FOUR_TWOSAMETWO then
			-- 4带2对
			if (isNewBout) then
				-- 新回合
				nSoundID = AudioManager.TableVoice.SIDAILIANGDUI;
			end
		elseif nType == TableCardManage.TYPE_STRAIGHT then
		end

		--牌桌软引导动画 更多提示
		if nType == TableCardManage.TYPE_FOUR or nType == TableCardManage.TYPE_TWO_CAT then
		-- 防止和炸弹动画冲突
		else
			--			softGuideTable = Common.LoadTable(softGuideTableText)
			if softGuideTable == nil then
				TableElementLayer.showSoftGuideMore()
				softGuideTable = {}
				softGuideTable[profile.User.getSelfUserID() .. ""] = {}
				softGuideTable[profile.User.getSelfUserID() .. ""].more = true
				Common.SaveTable(softGuideTableText,softGuideTable)
			elseif softGuideTable[profile.User.getSelfUserID() .. ""] == nil then
				TableElementLayer.showSoftGuideMore()
				softGuideTable[profile.User.getSelfUserID() .. ""] = {}
				softGuideTable[profile.User.getSelfUserID() .. ""].more = true
				Common.SaveTable(softGuideTableText,softGuideTable)
			elseif softGuideTable[profile.User.getSelfUserID() .. ""].more == nil then
				TableElementLayer.showSoftGuideMore()
				softGuideTable[profile.User.getSelfUserID() .. ""].more = true
				Common.SaveTable(softGuideTableText,softGuideTable)
			end
		end


		if (getPlayer(nPlayer).m_nCardCnt > 2 or getPlayer(nPlayer).m_nCardCnt == 0) then
			-- 剩最后两张牌不报牌
			if (nSoundID ~= nil) then
				AudioManager.playLordSound(nSoundID, false, getPlayer(nPlayer).mnSex);
			else
				if (not isNewBout) then
					-- 如果不是新回合
					local next = math.random(0, 2);
					if next == 0 then
						AudioManager.playLordSound(AudioManager.TableVoice.YASI, false, getPlayer(nPlayer).mnSex);
					elseif next == 1 then
						AudioManager.playLordSound(AudioManager.TableVoice.GUANSHANG, false, getPlayer(nPlayer).mnSex);
					elseif next == 2 then
						AudioManager.playLordSound(AudioManager.TableVoice.DANI, false, getPlayer(nPlayer).mnSex);
					end
				end
			end
		end
		if (getPlayer(nPlayer).m_nCardCnt == 0) then
		-- 没有手牌时，不显示按钮
		-- LordMgr.getInst().updateUI(LordMgr.GAMEBTN_HIDE, true, -1);
		end

	end
	return pauseRecv;
end


--[[--
--发送准备请求
--@param #number OpenCardsReady 明牌倍数,普通房间发0
--]]
function sendContinue(OpenCardsReady)
	Common.log("发送准备请求")
	GameArmature.closeTiantiAnim();
	TableElementLayer.setWuFaShengDuanVisible();
	TableElementLayer.hideTableResult();
	TableElementLayer.setTableCostLabelVisible(false);
	sendDDZID_READY(OpenCardsReady);
	m_bSendContinue = true;
	mnIsOpenCardsReady = OpenCardsReady;
	if isGameResultReady then
		setStatus(STAT_WAITING_READY);
	end
	TableElementLayer.hideTableDetailText();
	TableElementLayer.showTableWaitTips();
end

--[[--
--发送叫分请求
--@param #number nScore 0,1,2,3
--]]
function sendCallScore(nScore)
	setCurrPlayer(-1)
	sendDDZID_CALLSCORE(nScore)
	Common.log("发送叫分请求=================")
end

function logicTimeDelayed()
	if (INIT_TIMER_SELF_LOSS >= 10) then
		INIT_TIMER_SELF_LOSS = 10;
	else
		takeoutTime = takeoutTime + 1;
		if (takeoutTime >= 2) then
			INIT_TIMER_SELF_LOSS = INIT_TIMER_SELF_LOSS + 5;
			takeoutTime = 0;
			Common.showToast("因多次出牌缓慢,您的出牌时间被减少到" .. (INIT_TIMER - INIT_TIMER_SELF_LOSS) .. "秒", 2);
		end
	end
end

--[[--
--发送出牌请求
--]]
function sendTakeOutCard(takeOutData)
	if (m_nCountdownCnt - INIT_TIMER_SELF_LOSS < 6) then
		logicTimeDelayed();
	else
		takeoutTime = 0;
	end
	TableLogic.hideGameBtn()
	local normalCardList = {}
	local laiziCardlist = {}
	m_anOutCard = {}
	for i = 1, #takeOutData do
		if (takeOutData[i].mbIsLaiZi) then
			table.insert(laiziCardlist, takeOutData[i]);
		else
			table.insert(normalCardList, takeOutData[i]);
		end
		m_anOutCard[i] = takeOutData[i].mnTheOriginalValue;
	end
	local p = getPlayer(getSelfSeat());
	local isNewBout = true;-- 是否是新的回合

	isNewBout = TableCardLayer.getIsNewBout(getSelfSeat());

	if #m_anOutCard ~= 0 then
		--移除手牌
		TableCardLayer.removeHandCard(m_anOutCard);
		TableCardLayer.refreshHandCards();

		if TableCardLayer.getHandCardsCnt() == 1 then
			-- 剩一张
			local next = math.random(0, 1);
			if next == 0 then
				AudioManager.playLordSound(AudioManager.TableVoice.ZUIHOUYIZHANG1, false, p.mnSex);
			elseif next == 1 then
				AudioManager.playLordSound(AudioManager.TableVoice.ZUIHOUYIZHANG2, false, p.mnSex);
			end
		elseif TableCardLayer.getHandCardsCnt() == 2 then
			-- 剩两张
			local next = math.random(0, 1);
			if next == 0 then
				AudioManager.playLordSound(AudioManager.TableVoice.ZUIHOUERZHANG1, false, p.mnSex);
			elseif next == 1 then
				AudioManager.playLordSound(AudioManager.TableVoice.ZUIHOUERZHANG2, false, p.mnSex);
			end
		elseif TableCardLayer.getHandCardsCnt() == 0 then
			--移除明牌标志
			TableCardLayer.removeMingpaiFlagSprite()
		end

		AudioManager.playLordSound(AudioManager.TableSound.CHUPAI, false, AudioManager.SOUND);

		--直接添加到桌子上
		TableCardLayer.addTableCard(takeOutData, getSelfSeat())
		TableCardLayer.refreshTableCardsBySeat(getSelfSeat())

		setTakeOutEffect(#takeOutData, getSelfSeat(), isNewBout);
	else
		local next = math.random(0, 3);
		if next == 0 then
			AudioManager.playLordSound(AudioManager.TableVoice.BUYAO, false, p.mnSex);
		elseif next == 1 then
			AudioManager.playLordSound(AudioManager.TableVoice.YAOBUQI, false, p.mnSex);
		elseif next == 2 then
			AudioManager.playLordSound(AudioManager.TableVoice.PASS, false, p.mnSex);
		elseif next == 3 then
			AudioManager.playLordSound(AudioManager.TableVoice.GUO, false, p.mnSex);
		end
		p:setAnim(GameArmature.ARMATURE_BUYAO);
	end

	-- 清除即将出牌人桌上的牌
	local nextPlayer = (getSelfSeat() + 1 + #m_aPlayer) % #m_aPlayer;
	if (nextPlayer < #m_aPlayer and nextPlayer > -1) then
		Common.log("清除即将出牌人桌上的牌" .. nextPlayer);
		TableCardLayer.clearTableCardsBySeat(nextPlayer)
		if (#m_anOutCard == 0) then
			TableElementLayer.showPlayerTips(getSelfSeat(), "不要");
		end
		if isNewBout then
			TableElementLayer.hidePlayerTips(-1);
		else
			TableElementLayer.hidePlayerTips(TableConsole.getPlayerPosBySeat(nextPlayer) + 1);
		end
	end

	m_bSendTakeOutCard = true;
	setCurrPlayer(-1)
	sendDDZID_TAKEOUTCARD(normalCardList, laiziCardlist)
end

--[[--
-- 出牌
--]]
function takeOut()
	local isValid, CardsNum = TableCardLayer.isValidOutCards()
	if (isValid) then
		if (TableCardLayer.isHaveMoreLaiZiVal()) then
			--显示癞子牌选择界面
			mvcEngine.createModule(GUI_TABLE_SELECT_LAIZI)
			SelectLaiziCardLogic.setLaiziCardsData(TableCardLayer.getCardsSelectTable())
		else
			sendTakeOutCard(TableCardLayer.getPopUpCardsVal(TableCardLayer.getThenOneCardsSelect()));
		end
	else
		TableCardManage.initData(TableCardLayer.getSelfCards())
		if CardsNum ~= nil and CardsNum > 0 then
			Common.showToast("您的出牌不符合规则", 2)
			--牌桌软引导动画 取消选牌
			--			softGuideTable = Common.LoadTable(softGuideTableText)
			if softGuideTable == nil then
				TableElementLayer.showSoftGuideAbandon()
				softGuideTable = {}
				softGuideTable[profile.User.getSelfUserID() .. ""] = {}
				softGuideTable[profile.User.getSelfUserID() .. ""].abandon = true
				Common.SaveTable(softGuideTableText,softGuideTable)
			elseif softGuideTable[profile.User.getSelfUserID() .. ""] == nil then
				TableElementLayer.showSoftGuideAbandon()
				softGuideTable[profile.User.getSelfUserID() .. ""] = {}
				softGuideTable[profile.User.getSelfUserID() .. ""].abandon = true
				Common.SaveTable(softGuideTableText,softGuideTable)
			elseif softGuideTable[profile.User.getSelfUserID() .. ""].abandon == nil then
				TableElementLayer.showSoftGuideAbandon()
				softGuideTable[profile.User.getSelfUserID() .. ""].abandon = true
				Common.SaveTable(softGuideTableText,softGuideTable)
			end
		else
			Common.showToast("请选择要出的牌", 2)
		end
		m_nHlocalID = CARD_WRONGFUL;-- 出牌不合法
		m_nHlocalCnt = HINT_MAX;
	end
end

--[[--
--不出
--]]
function pass()
	Common.log("pass")
	TableCardLayer.unSelectAllHandCards();
	local nilData = {};
	sendTakeOutCard(nilData);
	TableLogic.hideGameBtn();
	TableCardLayer.hideNoBigCard();
end

--[[--
--进入牌桌
--]]
function EnterGame()
	sendDBID_BACKPACK_LIST()--背包
	GameConfig.setTheLastBaseLayer(GameConfig.getTheCurrentBaseLayer())
	mvcEngine.createModule(GUI_TABLE)
	if mode == ROOM and mnTableType ~= TABLE_TYPE_NORMAL then
		TableLogic.changeGameStartButton(true);
		TableElementLayer.showTableWaitTips();
	end
end

--[[--
--快速开始逻辑处理
--]]
local function QuickStartManage()
	local quickData = profile.GameDoc.getQuickStartData()
	if quickData ~= nil then
		Common.closeProgressDialog();
		-- RemainCount byte 当天剩余破产送金次数 消息版本号：1
		profile.User.mnRemainCount = quickData["mnRemainCount"];
		-- RoomType byte 进入的房间类型 0普通 1欢乐 2癞子
		if (tonumber(profile.User.mnRemainCount) > 0) then
			sendMANAGERID_GIVE_AWAY_GOLD(quickData["roomType"]);
		else
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, quickData["needCoinCnt"], RechargeGuidePositionID.PatternSelectPositionB)
		end
		Common.showToast(quickData["ResultMsg"], 2)
	end
end

--[[--
--进入房间逻辑处理
--]]
local function EnterRoomManage()
	local EnterRoom = profile.GameDoc.getEnterRoomData()
	if EnterRoom ~= nil then
		-- RoomID Int 房间ID
		-- MatchInstanceID text 比赛实例ID
		-- Result byte 进入结果 0 成功 1 失败
		-- ResultMsg text 提示语 失败时返回提示语
		-- FailType 0 weizhi 1 有未结束的游戏 2 有即将开始的比赛
		if (EnterRoom["result"] == 1) then
			Common.closeProgressDialog();
			if EnterRoom["FailType"] == 0 then
				Common.showToast(EnterRoom["ResultMsg"], 2)
				--PopRechargeGuid	byte	是否弹出充值引导	0不弹出 1弹出
				local PopRechargeGuid = EnterRoom["PopRechargeGuid"];
				--NeedCoinCnt	int	还需要充值多少金币才能进入
				local NeedCoinCnt = EnterRoom["NeedCoinCnt"];
				if (PopRechargeGuid == 1) then
					CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, NeedCoinCnt, RechargeGuidePositionID.RoomListPositionA)
				end
			elseif EnterRoom["FailType"] == 1 then
				Common.showToast(EnterRoom["ResultMsg"], 2)
			elseif EnterRoom["FailType"] == 2 then
				if RoomCoinNotFitLogic.view ~= nil then
					-- 如果此时，弹出金币不够不能进入房间时，先关掉之
					mvcEngine.destroyModule(GUI_ROOMCOINNOTFIT)
				end

				matchjijiangkaisaiLogic.leftCallbackFunction = function()
					if GameLoadModuleConfig.getFruitIsExists() then
						mvcEngine.destroyModule(GUI_MATCH_JIJIANGKAISHI)

						-- 开始小游戏
						GameConfig.setTheLastBaseLayer(GUI_HALL)
						mvcEngine.createModule(GUI_MINIGAME_FRUIT_MACHINE, LordGamePub.runSenceAction(HallLogic.view, nil, true))
					end
				end
				matchjijiangkaisaiLogic.rightCallbackFunction = function()
					mvcEngine.destroyModule(GUI_MATCH_JIJIANGKAISHI)

					-- 退赛返回房间
					Common.showProgressDialog("进入房间中,请稍后...");
					sendMATID_V4_REFUND(tonumber(EnterRoom["MatchID"]))
					sendQuickEnterRoom(-1);
				end
				matchjijiangkaisaiLogic.tableMode = 3
				matchjijiangkaisaiLogic.strTitleTips = EnterRoom.ResultMsg
				mvcEngine.createModule(GUI_MATCH_JIJIANGKAISHI)
			end

			return;
		end

		-- GameID byte
		-- RoomTitle text 标题
		msRoomTitle = EnterRoom["msRoomTitle"]
		-- CurrPlayerCnt short 当前人数
		-- TableHintMsg text 进入房间后牌桌上显示的提示
		TableHintMsg = EnterRoom["TableHintMsg"];
		-- TableType byte 房间牌桌类型 0普通玩法 1欢乐玩法2癞子房
		mnTableType = EnterRoom["mnTableType"];
		-- BaseChipText Text 房间筹码基数提示语
		msBaseChipText = EnterRoom["msBaseChipText"];
		Common.log("msRoomTitle==" .. msRoomTitle .. "   msBaseChipText==" .. msBaseChipText);
		--TableCost	Int	房间桌费
		setTableCost(EnterRoom["TableCost"])

		m_nRoomID = EnterRoom["nRoomID"];

		m_nRoombaseChip = EnterRoom["baseChip"];

		mode = ROOM;

		EnterGame();
	end
end

--[[--
--退出牌桌时发送消息
--]]
function ExitTableForMsg()
	if (mode == MATCH) then
		if (m_nGameStatus ~= STAT_MATCH_RESULT) then
			sendTableTrustPlayReq(4);
		end
	else
		if (m_bReadInitCard) then
			-- 发牌后或为游戏结果时为正常退出，其余为强退
			if (m_nGameStatus == STAT_GAME_RESULT) then
				sendExitRoom(0);
			else
				sendExitRoom(1);
				sendTableTrustPlayReq(4);
			end
		else
			-- 发牌之前为正常退出
			sendExitRoom(0);
		end
	end
end

--[[--
--退出房间逻辑处理
--]]
local function QuitRoomManage()
	local QuitRoom = profile.GameDoc.getQuitRoomData()
	Common.log("readExitRoom");
	-- SeatID Byte 退出玩家座位号
	local nSeatID = QuitRoom["nSeatID"];
	Common.log("nSeatID=" .. nSeatID);
	-- UserID Int 玩家ID
	local UserID = QuitRoom["UserID"];
	-- IsKickOut byte 是否被踢出房间 1是踢出 0正常
	local IsKickOut = QuitRoom["IsKickOut"];
	Common.log("IsKickOut=" .. IsKickOut);
	-- goBankrupt byte 破差送金次数
	local goBankrupt = QuitRoom["goBankrupt"];
	Common.log("goBankrupt=" .. goBankrupt);

	if (nSeatID == getSelfSeat()) then
		if NewUserGuideLogic.getNewUserFlag()then
			return;
		end
		if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
			TableLogic.exitLordTable()
			Common.log("readExitRoom readExitRoom");
		end
	else
		--隐藏退出房间玩家下面的踢出按钮
		TableLogic.hideKickButton(getPlayerPosBySeat(nSeatID))
		local pos = getPlayerPosBySeat(nSeatID)
		if kickPlayerTable["" .. pos] ~= nil and kickPlayerTable["" .. pos] == true then
			kickPlayerTable = {}
			removePlayerTable = {}
			return
		end
		removePlayerTable["" .. pos] = true
		removePlayer(nSeatID);
	end
	if (nSeatID == getSelfSeat() and IsKickOut == 1 and goBankrupt >= 2) then

	end
end

--[[
生成一个随机数字数组
1~nLength之间
]]
function createRandomNumberArray(nLength)
	local tRandomNumber = {}

	-- 使用系统时间作为随机序列种子
	math.randomseed(os.time())

	for i=1,nLength do
		local nRandomNumber = math.random(1, nLength)
		tRandomNumber["i"] = tonumber(nRandomNumber)
		Common.log("tRandomNumber.i = "..tRandomNumber["i"])
	end

	return tRandomNumber
end

--[[
通过一个随机数，来交换数组元素的位置
tExchange:要交换元素位置的数组
]]
function exchangeIndexWithRandomNumber(tExchange)
	local nTableLength = #tExchange
	if nTableLength == 1 then
		return
	end

	math.randomseed(os.time())
	local nRandomNumber = math.random(1, nTableLength)
	nRandomNumber = nRandomNumber - 1 -- lua数组从1开始，为了避免数组越界，这里减1
	for i=1,nRandomNumber do
		local temp = -1
		temp = tExchange[i]
		tExchange[i] = tExchange[i+1]
		tExchange[i+1] = temp
	end
end

--[[--
--显示用户
--]]
function showTablePlayer()
	-- 添加小人出场动画延迟
	PauseSocket("showTablePlayer");

	local function showLeftPlayer()
		local player = getPlayer(getPlayerSeatByPos(2));
		if player ~= nil then
			player:setAnim(GameArmature.ARMATURE_NONGMIN_JINRU);
		end
	end

	local function showRightPlayer()
		local player = getPlayer(getPlayerSeatByPos(1));
		if player ~= nil then
			player:setAnim(GameArmature.ARMATURE_NONGMIN_JINRU);
		end
	end

	local delay = CCDelayTime:create(0.5)
	local array = CCArray:create()

	local pos = math.random(1, 2);
	if pos == 1 then
		--下家先显示
		array:addObject(CCCallFunc:create(showRightPlayer))
		array:addObject(delay)
		array:addObject(CCCallFunc:create(showLeftPlayer))
	elseif pos == 2 then
		--上家先显示
		array:addObject(CCCallFunc:create(showLeftPlayer))
		array:addObject(delay)
		array:addObject(CCCallFunc:create(showRightPlayer))
	end
	array:addObject(CCCallFunc:create(TableElementLayer.setTableUserInfo))
	array:addObject(CCCallFunc:create(ResumeSocket))
	local sq = CCSequence:create(array)
	CCDirector:sharedDirector():getRunningScene():runAction(sq)
end

--[[--
--牌桌改变逻辑处理
--]]
local function TableChangedManage()
	Common.log("========接收牌桌改变处理==========")

	-- 关闭loading界面
	Common.closeProgressDialog()

	local TableChanged = profile.GameDoc.getTableChangedData()

	if TableConsole.pLastForceQuitMatchInstance ~= nil and TableConsole.pLastForceQuitMatchInstance == TableChanged["m_sMatchInstanceID"] then
		-- 如果当前牌桌改变的比赛实例和上一次退出的比赛实例相同，则直接返回
		return
	end

	if TableNotEndedLogic.view ~= nil then
		-- 关闭等待分桌弹框
		mvcEngine.destroyModule(GUI_TABLE_NOT_ENDED)
	end

	m_bShowPlayers = false;

	ChatPopLogic.clearChatList();

	tempLaiziCardVal = -1;
	mnLaiziCardVal = -1;
	TableCardLayer.setLaiZiReservedCard(-1)
	mnReservedCardTimes = 1;
	mbIsShowReservedCard = false;
	mnFlag = 0;
	mode = TableChanged["mode"];
	Common.log("mode =========" .. mode);
	if mode == ROOM then
		--隐藏踢人按钮
		TableLogic.changeKickButton(false);
	end
	m_sMatchInstanceID = TableChanged["m_sMatchInstanceID"];

	m_nRoomID = TableChanged["nRoomID"];
	m_nTableID = TableChanged["nTableID"];
	if (m_nTableID ~= -1 and m_nTableID ~= 65535) then
		if GameConfig.getTheCurrentBaseLayer() ~= GUI_TABLE then
			EnterGame();
		else
			setStatus(STAT_WAITING_TABLE);
		end

		m_nSeatID = TableChanged["nSeatID1"];
		m_nInitTimerVal = TableChanged["nInitTimerVal"];
		local nInitHoleChip = TableChanged["nInitHoleChip"];
		Common.log("我的房间号:" .. m_nRoomID);
		Common.log("我的桌子号:" .. m_nTableID);
		Common.log("我的座位号:" .. m_nSeatID);

		m_nTreasureLockDuration = TableChanged["m_nTreasureLockDuration"];
		if (m_nTreasureLockDuration == 65535) then
			m_nTreasureLockDuration = -1;
		end
		local nIsAllRobot = TableChanged["nIsAllRobot"];

		m_nUserCnt = TableChanged["UserCnt"];

		if (m_nUserCnt > 0) then
			m_aPlayer = {};
		end

		local flag = 0

		for i = 1, m_nUserCnt do
			m_aPlayer[i] = TablePayer:new();

			local nUserID = TableChanged["UserList"][i].nUserID;
			local nSeatID = TableChanged["UserList"][i].nSeatID;
			if (nSeatID == m_nSeatID) then
				Common.log("自己的座位号是：" .. nSeatID);
			end
			m_aPlayer[i].m_nUserID = nUserID;
			Common.log("m_nUserID：" .. m_aPlayer[i].m_nUserID);
			m_aPlayer[i].m_nSeatID = nSeatID;
			m_aPlayer[i].m_nPos = getPlayerPosBySeat(nSeatID);
			m_aPlayer[i].m_sNickName = TableChanged["UserList"][i].m_sNickName;
			Common.log("m_sNickName：" .. m_aPlayer[i].m_sNickName);
			m_aPlayer[i].m_sPhotoUrl = TableChanged["UserList"][i].m_sPhotoUrl;
			Common.log("m_sPhotoUrl：" .. m_aPlayer[i].m_sPhotoUrl);
			m_aPlayer[i].m_nChipCnt = TableChanged["UserList"][i].m_nChipCnt;
			m_aPlayer[i].scoreCnt = TableChanged["UserList"][i].scoreCnt;
			m_aPlayer[i].m_sTitle = TableChanged["UserList"][i].m_sTitle;
			m_aPlayer[i].m_nMasterScore = TableChanged["UserList"][i].m_nMasterScore;
			m_aPlayer[i].m_nWinRate = TableChanged["UserList"][i].sWinRate;
			m_aPlayer[i].m_nBrokenRate = TableChanged["UserList"][i].sBrokenRate;
			m_aPlayer[i].m_nCallScore = -1;
			m_aPlayer[i].m_nCardCnt = -1;
			m_aPlayer[i].m_bIsLord = false;
			m_aPlayer[i].mnVipLevel = TableChanged["UserList"][i].mnVipLevel;
			local age = TableChanged["UserList"][i].age;
			local sex = TableChanged["UserList"][i].sex;
			local city = TableChanged["UserList"][i].city;
			local strSex = " ";
			if (sex == 1 or sex == 0) then
				strSex = "男";
			elseif (sex == 2) then
				strSex = "女";
			end
			local strAge = "保密";
			if (age > 0) then
				strAge = age .. "岁";
			end
			m_aPlayer[i].mnSex = sex;
			m_aPlayer[i].userSex = strSex;
			m_aPlayer[i].userAge = strAge;
			m_aPlayer[i].userAddress = city;
			m_aPlayer[i].ladderDuan = TableChanged["UserList"][i].ladderDuan;
			m_aPlayer[i].ladderLevel = TableChanged["UserList"][i].ladderLevel;
			m_aPlayer[i].round = TableChanged["UserList"][i].round;
			m_aPlayer[i].titlePicUrl = TableChanged["UserList"][i].titlePicUrl;
			-- …isNewTablePlayer byte 是不是新加入牌桌的人，用于判断是否可被踢
			m_aPlayer[i].isNewTablePlayer = TableChanged["UserList"][i].isNewTablePlayer;
			if (m_aPlayer[i].isNewTablePlayer == 1) then
			--	playerChangeUpdate(m_aPlayer[i].m_nSeatID);
			end
			TableLogic.updataUserCoin()
			-- 系统称号图片下载
			if (nSeatID == m_nSeatID) then
				TableElementLayer.updataUserInfo()
			else
				if m_aPlayer[i].m_nPos == 1 then
					GameArmature.updataFarmerRight(m_aPlayer[i].mnSex)
				else
					GameArmature.updataFarmerLeft(m_aPlayer[i].mnSex)
				end
				GameArmature.removeLord()
			end
		end

		local nMatchID = TableChanged["nMatchID"];
		if (nMatchID ~= 0) then
			m_nMatchID = nMatchID;
		end

		Common.log("m_nMatchID=" .. m_nMatchID);
		local m_nPunchListScore = TableChanged["m_nPunchListScore"];
		Common.log("m_nPunchListScore=" .. m_nPunchListScore);
		local m_nPunchListRank = TableChanged["m_nPunchListRank"];
		Common.log("m_nPunchListRank=" .. m_nPunchListRank);
		local m_nPunchListDuration = TableChanged["m_nPunchListDuration"];
		Common.log("m_nPunchListDuration=" .. m_nPunchListDuration);
		-- AutoReady byte 客户端是否自动准备 0不需要自动准备 1自动准备
		local autoReady = TableChanged["autoReady"];
		-- TableType byte 牌桌游戏类型 0标准玩法 1欢乐玩法
		mnTableType = TableChanged["mnTableType"];
		Common.log("autoReady 是否自动准备 == " .. autoReady);
		Common.log("mnTableType牌桌游戏类型 == " .. mnTableType);

		if (isGameResultReady == false and (mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT)) then
			-- 如果不是一局结束后的准备
			if (msRoomTitle ~= nil and msBaseChipText ~= nil) then
				local text = nil
				if isCrazyStage == true then
					text = "-【疯狂闯关】" .. "-|-" .. "第" .. crazyMission .. "关" .. "-";
				else
					text = "-【" .. msRoomTitle .. "】" .. "-|-" .. msBaseChipText .. "-";
				end
				TableElementLayer.addServerMsg(text);
			end
		end

		m_bSendTableNotEnded = false;

		-- 不要飞出玩家信息弹框动画，直接显示用户，开始比赛
		showTablePlayer();

		-- 上下家飞出玩家信息框
		-- TableElementLayer.showPlayerInfo();

		if (mode == MATCH) then
			-- 进入比赛开始阶段
			Common.log("进入比赛开始阶段");
			hideTableNotEndedView();
			TableLogic.callback_btn_game_start(RELEASE_UP);
		elseif (mode == ROOM) then
			Common.log("进入房间开始阶段");
			if (m_bReadTableChanged == false) then
				if (isGameResultReady or (mnTableType ~= TABLE_TYPE_HAPPY and mnTableType ~= TABLE_TYPE_OMNIPOTENT)) then
					-- 如果是一局结束后的准备or是在普通房间
					--显示开始按钮
					if (not m_bSendContinue) then
						TableLogic.changeGameStartButton(true);
					end
				else
				-- 第一次收到欢乐房间TableChanged
				end
				if (autoReady == 1) then
					if (mnTableType == TABLE_TYPE_NORMAL) then
						--自动准备
						TableLogic.callback_btn_game_start(RELEASE_UP)
					else
						if (m_bSendContinue) then
							sendContinue(mnIsOpenCardsReady);
						end
					end
				end
			else
				if (m_bSendContinue) then
					sendContinue(mnIsOpenCardsReady);
				end
			end
		end
		setStatus(STAT_WAITING_READY);
		m_bIsWaitingTable = false;
	else
		if GameConfig.getTheCurrentBaseLayer() ~= GUI_TABLE then
			return;
		end
		-- 如果桌号是-1，则进入了等候区
		Common.log("进入了Table等候区");
		setStatus(STAT_WAITING_TABLE);
		sendTableNotEnded();
		m_nNotEndedCnt = 0;
		m_bSendTableNotEnded = true;
		m_bIsWaitingTable = true;
	end
	m_bReadTableChanged = true;
end

--[[--
-- 断线续玩后解除托管
--]]
local function tableSyncRemoveTrust()
	sendTableTrustPlayReq(0);
end

--牌桌等待阶段
TABLE_SYNC_WAITING = 0;
--叫分阶段
TABLE_SYNC_CALL_SCORE = 1;
--打牌阶段
TABLE_SYNC_PLAYING = 2;
--闯关赛等待断线续玩阶段
TABLE_SYNC_CHUANGGUAN_WAITING = 3;
--抢地主阶段
TABLE_SYNC_GRAB_LOARD = 4;
--加倍阶段
TABLE_SYNC_DOUBLE_SCORE = 5;
--等待明牌(比赛发牌阶段)
TABLE_SYNC_WAIT_OPENG_CARD = 6
--比赛等待分桌
TABLE_SYNC_WAIT_TABLE = 7
--充值等待
TABLE_SYNC_WAIT_RECHARGE = 8

--[[--
--牌桌断线续玩逻辑处理
--]]
local function TableSyncManage()
	local TableSync = profile.GameDoc.getTableSyncData()

	--[[--*********************** 协议接收 **************************--]]
	--	LordActivity.reportPlayer.clear();

	-- 初始化数据
	releaseTableData()
	local isInCrazy = profile.GameDoc.getIsInCrazyStage()
	if isInCrazy == true then
		isCrazyStage = true
		canPlayCrazy = true
	end

	--设置当前状态为新手断线重连
	NewUserCreateLogic.setNewUserGameSync(true);

	initCardRecord();

	-- Mode Byte 模式 1 比赛 2 房间
	mode = TableSync["mode"];
	Common.log("模式 1 比赛 2 房间  =" .. mode);

	-- 重新启动牌桌
	EnterGame();

	-- MatchInstanceID text 比赛实例ID
	m_sMatchInstanceID = TableSync["m_sMatchInstanceID"];
	-- RoomID int 房间ID
	m_nRoomID = TableSync["m_nRoomID"];
	Common.log("房间ID:" .. m_nRoomID);
	-- TableID int 桌子ID
	m_nTableID = TableSync["m_nTableID"];
	Common.log("桌子ID:" .. m_nTableID);

	--[[--*********************** 斗地主子协议 **************************--]]
	-- MatchTitle text 比赛标题
	msMatchTitle = TableSync["msMatchTitle"];
	Common.log("比赛标题:" .. msMatchTitle);
	-- InitTimerVal byte 初始倒计时
	local nInitTimerVal = TableSync["nInitTimerVal"];
	Common.log("初始倒计时:" .. nInitTimerVal);
	-- TableType byte 房间游戏类型 0标准玩法 1欢乐玩法
	mnTableType = TableSync["mnTableType"];
	Common.log("房间游戏类型 0标准玩法 1欢乐玩法 : " .. mnTableType);
	-- TableStatus byte 桌子状态
	-- STAT_WAITING = 0;STAT_CALL_SCORE = 1;STAT_PLAYING =2;
	-- STAT_CHUANGGUAN_WAITING =
	-- 3;STAT_GRAB_LOARD=4;STAT_DOUBLE_SCORE=5;
	local nTableStatus = TableSync["nTableStatus"];
	Common.log("桌子状态 nTableStatus=" .. nTableStatus);
	-- CallScore byte 当前叫分
	m_nCurrCallScore = TableSync["m_nCurrCallScore"];
	Common.log("当前叫分 = " .. m_nCurrCallScore);
	-- LordSeat byte 地主座位
	local nLordSeat = TableSync["nLordSeat"];
	Common.log("地主座位号 = " .. nLordSeat);
	-- SelfSeat byte 自己的座位号
	m_nSeatID = TableSync["m_nSeatID"];
	Common.log("自己的座位号 = " .. m_nSeatID);
	-- CurrPlayer byte 当前出牌或叫分的人
	local currPlayer = TableSync["currPlayer"];
	Common.log("当前回合人的 = " .. currPlayer);
	-- BaseChip int 筹码基数
	Common.log("筹码基数 = " .. m_nBaseChip);
	-- GameTask text 游戏任务(仅限普通房间)
	-- m_sGameTask = helper.getText();
	-- Common.log("游戏任务 = " .. m_sGameTask);
	-- MatchID Int 比赛ID
	m_nMatchID = TableSync["matchID"];
	Common.log("比赛ID matchID = " .. m_nMatchID);

	--	HallLogic.setMatchIDAndTitle(m_nMatchID , msMatchTitle)
	--
	--		--[[--****************** 恢复玩家数据 ********************--]]
	-- PlayerCnt int 玩家数量 loop***********************
	m_nUserCnt = #TableSync["PlayerList"];
	Common.log("m_nUserCnt = " .. m_nUserCnt);
	--
	--		int[][] tempWinChip = new int[3][2];-- 临时存储本局输赢数据
	--		if (m_aPlayer ~= nil) {
	--			for (int i = 0; i < m_aPlayer.length; i++) {
	--				tempWinChip[i][0] = m_aPlayer[i].m_nUserID;
	--				tempWinChip[i][1] = m_aPlayer[i].m_nWinChip;
	--			}
	--		}
	if (m_nUserCnt > 0) then
		m_aPlayer = {};
	end
	local tempOpenCardVal = {}--下标为SeatID + 1

	for i = 1, m_nUserCnt do
		m_aPlayer[i] = TablePayer:new();
		-- …UserID Int
		m_aPlayer[i].m_nUserID = TableSync["PlayerList"][i].UserID;
		Common.log("UserID = " .. m_aPlayer[i].m_nUserID);
		-- ...SeatID byte 座位号
		m_aPlayer[i].m_nSeatID = TableSync["PlayerList"][i].nSeatID;

		--			for (int j = 0; j < tempWinChip.length; j++) {-- 恢复本局输赢数据
		--				if (tempWinChip[j][0] == UserID) {
		--					m_aPlayer[i].m_nWinChip = tempWinChip[j][1];
		--					break;
		--				}
		--			}
		--			CommonMessage.getInstance().sendDBID_USER_INFO(m_aPlayer[i].m_nUserID);
		if (m_aPlayer[i].m_nSeatID == nLordSeat) then
			m_aPlayer[i].m_bIsLord = true;
		end
		m_aPlayer[i].m_nPos = getPlayerPosBySeat(m_aPlayer[i].m_nSeatID);
		-- ...NickName text 昵称
		m_aPlayer[i].m_sNickName = TableSync["PlayerList"][i].m_sNickName;
		Common.log(" 昵称  m_aPlayer[i].m_sNickName ========= "..m_aPlayer[i].m_sNickName)
		-- ...ChipCnt long 积分/金币数
		m_aPlayer[i].m_nChipCnt = TableSync["PlayerList"][i].m_nChipCnt;
		-- ...Title Text 称号
		m_aPlayer[i].m_sTitle = TableSync["PlayerList"][i].m_sTitle;
		-- ...CardsCnt Byte 剩余牌数
		m_aPlayer[i].m_nCardCnt = TableSync["PlayerList"][i].m_nCardCnt;
		Common.log(" 剩余牌数  m_aPlayer[i].m_nCardCnt ========= "..m_aPlayer[i].m_nCardCnt)
		-- ...TrustType Byte 托管类型 0解除托管 1手动托管 2超时托管 3断线托管 4托管退出
		local nTrustType = TableSync["PlayerList"][i].nTrustType;
		Common.log("托管类型  nTrustType = " .. nTrustType);
		if (nTrustType == 0) then
			Common.log("TableSyncManage m_bTrustPlay = false")
			m_aPlayer[i].m_bTrustPlay = false;
		else
			m_aPlayer[i].m_bTrustPlay = true;
		end
		-- ...MasterPlayer Byte 冲榜高手标志
		m_aPlayer[i].m_nMasterPlayer = TableSync["PlayerList"][i].m_nMasterPlayer;
		-- …VipLevel int VIP等级
		m_aPlayer[i].mnVipLevel = TableSync["PlayerList"][i].mnVipLevel;
		-- …callScore byte 叫地主状态 -1还没开始叫地主0 不叫1 一分2 二分3 三分
		m_aPlayer[i].m_nCallScore = TableSync["PlayerList"][i].m_nCallScore;
		-- …grabLord byte 抢地主 -1还没开始抢地主，0不抢地主，1抢地主
		m_aPlayer[i].m_nGrabScore = TableSync["PlayerList"][i].m_nGrabScore;
		-- …doubleScore byte 是否加倍 -1还没开始加倍，0不加倍，2加两倍 4加四倍
		m_aPlayer[i].m_nDoubleScore = TableSync["PlayerList"][i].m_nDoubleScore;
		-- …CanDoubleMax Byte 玩家最高可加的倍数 0不能加倍2可以加2倍4 可以加4倍
		m_aPlayer[i].m_nCanDoubleMax = TableSync["PlayerList"][i].m_nCanDoubleMax;
		-- …NoDoubleReason Byte 不能加倍的原因 1自己金币不足0别人金币不足
		m_aPlayer[i].m_nNoDoubleReason = TableSync["PlayerList"][i].m_nNoDoubleReason;
		-- …MinCoins Int 满足加倍条件的最低金币数
		m_aPlayer[i].m_nMinCoins = TableSync["PlayerList"][i].m_nMinCoins;
		-- …OpenCardsTimes byte 明牌倍数 5倍；3倍；2倍；1：不明牌
		m_aPlayer[i].mnOpenCardsTimes = TableSync["PlayerList"][i].mnOpenCardsTimes;
		-- …PlaerCards ByteArray 明牌者手当前中的牌 不明牌者为0长度的byte数组
		tempOpenCardVal[m_aPlayer[i].m_nSeatID + 1] = TableSync["PlayerList"][i].PlayerCards
		-- …Sex Int 性别
		m_aPlayer[i].mnSex = TableSync["PlayerList"][i].mnSex;

		-- …TitlePicUrl Text 玩家称号图片URL
		m_aPlayer[i].titlePicUrl = TableSync["PlayerList"][i].titlePicUrl;

		m_aPlayer[i].scoreCnt = TableSync["PlayerList"][i].matchScore

		if (m_aPlayer[i].m_nSeatID == m_nSeatID) then
			Common.log("自己的座位号是：" .. m_aPlayer[i].m_nSeatID);
			if (m_aPlayer[i].mnOpenCardsTimes > 1) then
				--自己是名牌的，设置为名牌状态
				Common.log("自己是名牌的，设置为名牌状态")
				m_bSelfDidMingpai = true
			end
		end

		if (m_aPlayer[i].nSeatID == m_nSeatID) then
		else
			if m_aPlayer[i].m_nPos == 1 then
				GameArmature.updataFarmerRight(m_aPlayer[i].mnSex)
			else
				GameArmature.updataFarmerLeft(m_aPlayer[i].mnSex)
			end
			GameArmature.removeLord()
			-- 恢复玩家明牌数据
			if (m_aPlayer[i].mnOpenCardsTimes > 1) then
			--					if (m_aPlayer[i].m_nPos == 1) {
			--						for (int j = 0; j < CardCnt.length; j++) {
			--							playerCardVal_1.add((int) CardCnt[j]);
			--						}
			--					} elseif (m_aPlayer[i].m_nPos == 2) {
			--						for (int j = 0; j < CardCnt.length; j++) {
			--							playerCardVal_2.add((int) CardCnt[j]);
			--						}
			--					}
			end
		end
	end

	--[[--****************** 恢复自己手牌数据 ********************--]]
	-- 手牌暂存
	local tempSelfCardVal = TableSync["SelfCards"];

	--[[--****************** 恢复底牌数据 ********************--]]
	local tempCommCardVal = TableSync["CommCards"];-- 底牌临时数据

	--[[--****************** 恢复记牌器与上一手牌 ********************--]]

	for i = 1, #TableSync["TakeoutAction"] do
		--if (i % 3 == 0) {
		--	setCardVal(false);
		--}
		--local player = (nLordSeat + i) % 3;
		for j = 1, TableSync["TakeoutAction"][i].cardCnt do
			setCardRecord(TableSync["TakeoutCardVal"][i][j])
			--currCardVal[player][j] = nVal;
		end
	end


	Common.log("牌桌倍数:" .. m_nMultiple);
	-- HunCardVal byte 癞子牌牌值
	local laiziCardVal = TableSync["laiziCardVal"];
	Common.log("癞子牌  laiziCardVal = " .. laiziCardVal);

	--[[--****************** 恢复牌桌上的牌 ********************--]]
	-- TableCards int 牌桌上牌值数量 Loop从座位号0开始循环
	local TableCards = #TableSync["TableCards"];
	local anTmpTableCards = {};-- 牌值
	local anTmpIsLaiZiCard = {};-- 是否是癞子
	for i = 1, TableCards do
		-- …CardCnt byte 本次出牌数量
		local cardCnt = TableSync["TableCards"][i].CardCnt;
		Common.log("本次出牌数量 cardCnt === " .. cardCnt);
		anTmpTableCards[i] = {};
		anTmpIsLaiZiCard[i] = {};
		for j = 1, cardCnt do
			-- ……CardVal byte 牌值
			local nVal = TableSync["CardVal"][i][j].nVal;
			-- ……isLaiZiCard byte 是否是癞子牌 0：不是；1：是
			local isLaiZiCard = TableSync["CardVal"][i][j].isLaiZiCard;
			anTmpTableCards[i][j] = nVal;
			anTmpIsLaiZiCard[i][j] = isLaiZiCard;
		end
	end

	-- 如果有等待分桌，直接关掉
	--hideTableNotEndedView()

	--[[--****************************** 消息协议接收完毕 *******************************--]]

	--[[--****************************** 逻辑处理 *******************************--]]

	-- 如果是房间，需要隐藏一些UI
	if mode == ROOM then
		if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
			TableLogic.Panel_120:setVisible(false)
			TableLogic.iv_jifen:loadTexture(Common.getResourcePath("ic_caishen_suipian.png"))
		end
	end

	--解除托管
	sendTableTrustPlayReq(0);
	--设置手牌区域可点
	TableCardLayer.setAllHandCardsMarked(false);
	TableCardLayer.setCardLayerTouchEnabled(true);

	TableLogic.updataUserCoin();

	-- 基数设置
	if TableSync["mode"] == ROOM then
		setBaseChip(TableSync["m_nBaseChip"]);
	elseif TableSync["mode"] == MATCH then
		setBaseChip(TableSync["BaseSocre"]);
	end

	TableElementLayer.updataUserCardCnt();

	-- 牌桌倍数SelfTimes int Int型的倍数 前面byte型倍数不够用
	if (mnTableType == TABLE_TYPE_NORMAL) then
		setMultiple(TableSync["m_nMultiple"] * m_nCurrCallScore);
	else
		setMultiple(TableSync["m_nMultiple"])
	end

	if (nTableStatus == TABLE_SYNC_PLAYING and mnTableType == TABLE_TYPE_OMNIPOTENT) then
		-- 如果是打牌阶段
		mnLaiziCardVal = laiziCardVal;
		TableCardLayer.setLaiZiReservedCard(mnLaiziCardVal)
		Common.log("癞子牌牌值  mnLaiziCardVal ============= " .. mnLaiziCardVal);
	end
	-- 确定癞子牌之后再创建牌
	-- 手牌
	TableCardLayer.addHandCard(tempSelfCardVal, true)
	TableCardLayer.refreshHandCards()

	-- 底牌
	Common.log("#tempCommCardVal = "..#tempCommCardVal)
	Common.log("nTableStatus = "..nTableStatus)

	--[[
	for i = 1, #tempCommCardVal do
	if (nTableStatus == TABLE_SYNC_CALL_SCORE) then
	local card = TableCard:new(0, FACE_BACK, false);
	TableCardLayer.addReservedCard(card)
	elseif (nTableStatus == TABLE_SYNC_PLAYING) then
	local card = TableCard:new(tempCommCardVal[i], FACE_FRONT, false);
	TableCardLayer.addReservedCard(card)
	end
	end
	]]

	for i = 1, #tempCommCardVal do
		if (nTableStatus == TABLE_SYNC_PLAYING) then
			local card = TableCard:new(tempCommCardVal[i], FACE_FRONT, false);
			TableCardLayer.addReservedCard(card)
		else
			local card = TableCard:new(0, FACE_BACK, false);
			TableCardLayer.addReservedCard(card)
		end
	end

	TableCardLayer.refreshReservedCards(true)

	TableLogic.setRoomOrMatchTable()
	if (mode == MATCH) then
	--LordMgr.getInst().updateUI(LordMgr.RANKING_UPDATE, true, -1);
	elseif (mode == ROOM) then

	end
	--		m_bSendTableNotEnded = false;
	--		LordMgr.getInst().updateUI(LordMgr.NOTENDED_HIDE, true, -1);
	--		LordMgr.getInst().updateUI(LordMgr.EMIGRATED_HIDE, true, -1);
	--		LordMgr.getInst().updateUI(LordMgr.HAPPY_TABLE_PROMPT_HIDE, true, -1);
	--		if (mode == MATCH) {
	--			sendGET_EGG_LIST(matchID);
	--			GameDoc.getInst().sendMATID_MATCH_VIP_CHIP(matchID);
	--		}
	Common.log("自己的座位号 = " .. m_nSeatID);

	if nTableStatus == TABLE_SYNC_WAITING then
		Common.log("nTableStatus == TABLE_SYNC_WAITING")
		-- 牌桌等待阶段
		m_nGameStatus = STAT_WAITING_READY;
		isGameResultReady = true;
		m_nCountdownCnt = -1;
		setCurrPlayer(currPlayer)
		--getPlayer(getSelfSeat()).m_bTrustPlay = false;
		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				if (m_aPlayer[i].m_nSeatID ~= getSelfSeat()) then
					m_aPlayer[i]:setAnim(GameArmature.ARMATURE_DAIJI)
				end
			end
		end
		if (mode == MATCH) then
			sendContinue(0);
			TableLogic.changeGameStartButton(false) -- 隐藏开始按钮
		elseif (mode == ROOM) then
			TableLogic.changeGameStartButton(true) --显示开始按钮
		end
	elseif nTableStatus == TABLE_SYNC_CALL_SCORE then
		-- 叫分阶段
		Common.log("nTableStatus == TABLE_SYNC_CALL_SCORE")



		m_nCountdownCnt = INIT_TIMER;
		setCurrPlayer(currPlayer)

		if mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT then
			m_nCurrBtnType = Button_call_landlord;
		else
			m_nCurrBtnType = Button_callscore;
		end

		m_nGameStatus = STAT_CALLSCORE;

		if (getPlayer(getSelfSeat()).m_bTrustPlay) then
			tableSyncRemoveTrust();
		else
			if (m_nCurrPlayer == getSelfSeat()) then
				TableLogic.changeShowButtonPanel(m_nCurrBtnType)
			else
			end
		end

		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				if (m_aPlayer[i].m_nSeatID ~= getSelfSeat()) then
					if (m_aPlayer[i].m_bTrustPlay) then
						m_aPlayer[i]:setAnim(GameArmature.ARMATURE_TUOGUAN);
					else
						m_aPlayer[i]:setAnim(GameArmature.ARMATURE_DAIJI);
					end
				end
			end
		end
	elseif nTableStatus == TABLE_SYNC_PLAYING then
		Common.log("nTableStatus == TABLE_SYNC_PLAYING")
		-- 打牌阶段
		m_nCurrBtnType = Button_takeout;
		m_nGameStatus = STAT_TAKEOUT;

		m_bTakeout = true;
		m_nCountdownCnt = INIT_TIMER;
		setCurrPlayer(currPlayer);
		TableCardLayer.unSelectAllHandCards();
		TableElementLayer.setPhotoAminVisible(true);
		TableElementLayer.setPhotoImage(false);

		-- 还原另外二人桌上的牌
		for seat = 1, m_nUserCnt do
			if (seat - 1 ~= getSelfSeat() and anTmpTableCards[seat] ~= nil) then
				local alCardList = {};
				for i = 1,  #anTmpTableCards[seat] do
					local cardData = TableTakeOutCard:new()
					-- ... HunCardVal byte 癞子牌变化后的牌值
					local nEndVal = anTmpTableCards[seat][i];
					-- ... OriginalCardVal byte 癞子牌变化前的原始牌值
					local OriginalCardVal = anTmpTableCards[seat][i];
					if (anTmpIsLaiZiCard[seat][i] == 1) then
						cardData.mbIsLaiZi = true;
					else
						cardData.mbIsLaiZi = false;
					end
					cardData.mnTheOriginalValue = OriginalCardVal;
					cardData.mnTheEndValue = nEndVal;
					table.insert(alCardList, cardData)
				end
				TableCardLayer.addTableCard(alCardList, seat - 1, true)
				TableCardLayer.refreshTableCardsBySeat(seat - 1)
			end
		end
		Common.log("getSelfSeat() ===== "..getSelfSeat())
		if (getPlayer(getSelfSeat()).m_bTrustPlay) then
			-- 断线续完，解除托管
			Common.log("断线续完，解除托管===========")
			tableSyncRemoveTrust();
		--TableLogic.changeShowButtonPanel(m_nCurrBtnType)
		else
			if (m_nCurrPlayer == getSelfSeat()) then
				TableLogic.changeShowButtonPanel(m_nCurrBtnType)
			else
			end
		end
		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				if (m_aPlayer[i].m_nSeatID ~= getSelfSeat()) then
					if (m_aPlayer[i].m_bTrustPlay) then
						m_aPlayer[i]:setAnim(GameArmature.ARMATURE_TUOGUAN);
					else
						m_aPlayer[i]:setAnim(GameArmature.ARMATURE_DAIJI);
					end
				end
			end
		end
	elseif nTableStatus == TABLE_SYNC_CHUANGGUAN_WAITING then
		Common.log("nTableStatus == TABLE_SYNC_CHUANGGUAN_WAITING")
		-- 闯关赛等待断线续玩阶段
		--			mbIsEmigrated = true;
		--			m_nCountdownCnt = -1;
		--			m_nCurrPlayer = currPlayer;
		--			getPlayer(getSelfSeat()).m_bTrustPlay = false;
		--			LordMgr.getInst().updateUI(LordMgr.GAMEBTN_HIDE, true, -1);
		--			LordMgr.getInst().updateUI(LordMgr.EMIGRATED_UPDATE, true, -1);
		--			LordMgr.getInst().updateUI(LordMgr.RANKING_SHOW, true, -1);
		--			LordMgr.getInst().updateUI(LordMgr.TOP_HIDE, true, -1);
		--			LordMgr.getInst().updateUI(LordMgr.HIDE_MATCH_NOTICE, true, -1);
		--			LordMgr.getInst().updateUI(LordMgr.TRUST_DISABLE, true, -1);
		--			for (int i = 0; i < m_nUserCnt; i++) {
		--				m_aPlayer[i].setAnim(ResMgr.PLAYER_ANIM_DAIJI1, -1);
		--			}
		--			m_nGameStatus = STAT_WAITING_TABLE;
	elseif nTableStatus == TABLE_SYNC_GRAB_LOARD then
		Common.log("nTableStatus == TABLE_SYNC_GRAB_LOARD")
		-- 抢地主阶段
		-- 开始抢地主时，不再显示叫地主信息
		for i = 1, m_nUserCnt do
			if (m_aPlayer[i] ~= nil) then
				m_aPlayer[i].m_nCallScore = -1;
			end
		end
		m_nCurrPlayer = currPlayer;
		m_nCountdownCnt = INIT_TIMER;
		setStatus(STAT_GRAB_LANDLORD);
		if (getPlayer(getSelfSeat()).m_bTrustPlay) then
			tableSyncRemoveTrust();
		else
			if (m_nCurrPlayer == getSelfSeat()) then
				TableLogic.changeShowButtonPanel(m_nCurrBtnType)
			else
			end
		end
		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				if (m_aPlayer[i].m_nSeatID ~= getSelfSeat()) then
					if (m_aPlayer[i].m_bTrustPlay) then
						m_aPlayer[i]:setAnim(GameArmature.ARMATURE_TUOGUAN);
					else
						m_aPlayer[i]:setAnim(GameArmature.ARMATURE_DAIJI);
					end
				end
			end
		end
	elseif nTableStatus == TABLE_SYNC_DOUBLE_SCORE then
		Common.log("nTableStatus == TABLE_SYNC_DOUBLE_SCORE")
		-- 加倍阶段
		-- 开始加倍时，不再显示抢地主信息
		for i = 1, m_nUserCnt do
			if (m_aPlayer[i] ~= nil) then
				m_aPlayer[i].m_nGrabScore = -1;
			end
		end
		m_nCurrPlayer = currPlayer;
		setStatus(STAT_DOUBLE_SCORE);
		if (getPlayer(getSelfSeat()).m_nCanDoubleMax > 0) then
			m_nCountdownCnt = INIT_TIMER;
		else
			m_nCountdownCnt = -1;
		end
		setDoubleScoreBtn(getPlayer(getSelfSeat()).m_nCanDoubleMax);
		if (getPlayer(getSelfSeat()).m_bTrustPlay) then
			tableSyncRemoveTrust();
		end
		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				if (m_aPlayer[i].m_nSeatID ~= getSelfSeat()) then
					if (m_aPlayer[i].m_bTrustPlay) then
						m_aPlayer[i]:setAnim(GameArmature.ARMATURE_TUOGUAN);
					else
						m_aPlayer[i]:setAnim(GameArmature.ARMATURE_DAIJI);
					end
				end
			end
		end
	elseif nTableStatus == TABLE_SYNC_WAIT_RECHARGE then
		Common.log("nTableStatus == TABLE_SYNC_WAIT_RECHARGE")
		-- 充值等待弹框
		if tonumber(TableSync.rechargeTimeRemain) > 0 then
			TableElementLayer.time = tonumber(TableSync.rechargeTimeRemain)
		else
			MatchRechargeCoin.sendLeaveRechargeWaiting(0)
			return
		end

		Common.log("恢复充值等待弹框")
		MatchRechargeCoin.bIsRechargeWaiting = true
		MatchRechargeCoin.tRecharge.MatchInstanceID = TableSync.m_sMatchInstanceID
		MatchRechargeCoin.tRecharge.MinCoin = TableSync.MinCoin

		Common.log("TableSync.rechargeTimeRemain = "..TableSync.rechargeTimeRemain)
		if tonumber(TableSync.rechargeTimeRemain) > 0 then
			TableElementLayer.time = tonumber(TableSync.rechargeTimeRemain)
		end
		TableElementLayer.addRechargeWaitingOverlay()
		mvcEngine.createModule(GUI_MATCH_TABLE_DENGDAIDAOZHANG)
	elseif nTableStatus == TABLE_SYNC_WAIT_OPENG_CARD then
		Common.log("nTableStatus == TABLE_SYNC_WAIT_OPENG_CARD")
		TableCardLayer.isDealEnd = true;--已经发完牌
		m_nCurrPlayer = currPlayer;
		setStatus(STAT_SETOUT);
		TableConsole.sendTableOpenCards(1);
		TableElementLayer.showClock(m_nCurrPlayer);
		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				if (m_aPlayer[i].m_nSeatID ~= getSelfSeat()) then
					if (m_aPlayer[i].m_bTrustPlay) then
						m_aPlayer[i]:setAnim(GameArmature.ARMATURE_TUOGUAN);
					else
						m_aPlayer[i]:setAnim(GameArmature.ARMATURE_DAIJI);
					end
				end
			end
		end
	elseif nTableStatus == TABLE_SYNC_WAIT_TABLE then
		Common.log("nTableStatus == TABLE_SYNC_WAIT_TABLE")
		sendMATID_V4_WAITING(TableSync.m_sMatchInstanceID)
	else
		Common.log("nTableStatus == 未知阶段")
		-- 未知阶段
		m_nCountdownCnt = -1;
		sendTableNotEnded();
		m_nNotEndedCnt = 0;
		m_bSendTableNotEnded = true;
		m_nGameStatus = STAT_WAITING_TABLE;
	end

	-- 显示玩家明牌
	for i = 1, m_nUserCnt do
		if tempOpenCardVal[i] ~= nil and #tempOpenCardVal[i] > 0 then
			TableCardLayer.addOpenCards(tempOpenCardVal[i], i - 1)
			TableCardLayer.refreshOpenCardsBySeat(i - 1)
		end
	end

	if (mode == ROOM and (mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT)) then
		sendBAOHE_V4_GET_PRO(m_nRoomID);
	end
	TableElementLayer.setTableUserInfo();

	if isPlayingDoudizhu() == true and profile.Pack.getJipaiqiValidDate() > 0 then
		--牌局进行中，显示记牌器
		--等恢复手牌之后，排除自己的手牌在记牌器里
		excludeSelfCardsInJipaiqi()
		jipaiqiLogic.showJipaiqiView()
	end
end

--[[--
--牌桌准备逻辑处理
--]]
local function TableReadyManage()
	local Ready = profile.GameDoc.getReadyData()
	Common.closeProgressDialog();
	local nContinueSeat = Ready["nContinueSeat"];
	Common.log("nContinueSeat ======= " .. nContinueSeat);
	local nUserID = Ready["nUserID"];
	Common.log("nUserID ======= " .. nUserID);
	-- OpenCardsTimes byte 明牌倍数
	local OpenCardsTimes = Ready["OpenCardsTimes"];
	Common.log("明牌倍数 ======= " .. OpenCardsTimes);
	-- IsReadySucceed byte 是否成功举手 1成功，0不成功
	local IsReadySucceed = Ready["IsReadySucceed"];
	Common.log("IsReadySucceed ======= " .. IsReadySucceed);
	-- resultMsg Text 失败原因
	local resultMsg = Ready["resultMsg"];
	-- operateType byte 举手失败的后续操作类型 0显示举手失败原因1显示充值引导2请求破产送金
	local operateType = Ready["operateType"];
	Common.log("operateType ======= " .. operateType);
	if (IsReadySucceed == 0) then
		m_bSendContinue = false;
		TableElementLayer.showTableWaitTips()
		if operateType == 0 then
			Common.showToast(resultMsg, 2)
		elseif operateType == 1 then
			-- 显示引导
			local isShowQuickPay = false;
			local differenceCoin = 0;
			differenceCoin = (mnRoomMinCoin - profile.User.getSelfCoin());
			Common.log("differenceCoin ======= " .. differenceCoin);
			if (differenceCoin > 0) then
				isShowQuickPay = true;
			end
			if (isShowQuickPay) then
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, differenceCoin, RechargeGuidePositionID.TablePositionC)
			else
				Common.showToast(resultMsg, 2)
			end
			--elseif operateType == 2 then 3.07版本以后不再请求破产送金
			--sendMANAGERID_GIVE_AWAY_GOLD(mnTableType);
		else
			Common.showToast(resultMsg, 2)
		end
		TableLogic.changeGameStartButton(true)
	else
		if (not m_bReadTableChanged) then
			return;
		end
		if (getPlayer(nContinueSeat) == nil) then
			return;
		end
		if (getSelfSeat() == nContinueSeat) then
			if (OpenCardsTimes < 1) then
				OpenCardsTimes = 1;
			end
			getPlayer(getSelfSeat()).mnOpenCardsTimes = OpenCardsTimes;
		end
		getPlayer(nContinueSeat).m_bReady = true;
		getPlayer(nContinueSeat).mnOpenCardsTimes = OpenCardsTimes;
	--		for  i = 1, #m_aPlayer do
	--			if (m_aPlayer[i] == nil or not m_aPlayer[i].m_bReady) then
	--				return;
	--			end
	--		end
	end
end

--[[--
--牌桌发牌逻辑处理
--]]
local function TableInitCardManage()
	-- 如果此时有等待分桌弹框，直接关掉
	hideTableNotEndedView()

	local InitCard = profile.GameDoc.getInitCardData()

	TableElementLayer.hidePlayerTips(-1)

	if (mode == MATCH) then
		-- 积分基数
		setBaseChip(InitCard["BaseSocre"]);
	else
		-- 金币基数
		setBaseChip(InitCard["m_nBaseChip"]);

		m_bShowPlayers = true;
	end
	if (getPlayer(getSelfSeat()).mnOpenCardsTimes ~= 5) then
		isSendOpenCards = false;
	end
	isGameResultReady = false;
	m_bReadTableChanged = false;
	m_bIsWaitingTable = false;
	m_bReadInitCard = true;
	m_bSendTableNotEnded = false;
	m_bSendContinue = false;
	mnIsOpenCardsReady = 0;
	m_bSendTakeOutCard = false;
	m_nRemainCardCnt = 54;
	tempLaiziCardVal = -1;
	mnLaiziCardVal = -1;
	TableCardLayer.setLaiZiReservedCard(-1)
	TableCardLayer.removeAllHandCards()
	TableCardLayer.removeAllReservedCards()
	TableCardLayer.removeAllOpenCards();

	initCardRecord();
	-- 当前的牌是那一家的

	--setBaseChip(InitCard["m_nBaseChip"])
	-- 第一个叫分的玩家
	m_nCallScorePlayerSeat = InitCard["m_nCallScorePlayerSeat"];
	INIT_TIMER_SELF_LOSS = 0;
	m_nCountdownCnt = INIT_TIMER;
	setCurrPlayer(m_nCallScorePlayerSeat)
	Common.log("readInitCard m_nCurrPlayer=" .. m_nCurrPlayer);
	-- 后面跟17张牌
	local handVar = {}
	for i = 1,InitCard["nSelfCardCnt"] do
		table.insert(handVar, InitCard["SelfCard"][i])
	end

	TableCardLayer.TableDealCards()

	TableCardLayer.addHandCard(handVar, false)
	TableCardLayer.refreshHandCards()

	--记牌器排除自己的手牌
	jipaiqiLogic.bDidExcludeSelfCards = false
	excludeSelfCardsInJipaiqi()
	-- 如果玩家已购买了记牌器，则打开
	if profile.Pack.getJipaiqiValidDate() > 0 then
		jipaiqiLogic.showJipaiqiView()
	end

	Common.log("selfSeat = "..getSelfSeat())

	if getPlayer(getSelfSeat()).m_bTrustPlay then
		Common.log("当前是托管")
		TableLogic.changeTrustPlayButton(true)

		TableCardLayer.setAllHandCardsMarked(true);
		TableCardLayer.setCardLayerTouchEnabled(false);
	else
		Common.log("当前不是托管")
		TableCardLayer.setAllHandCardsMarked(false);
		TableCardLayer.setCardLayerTouchEnabled(true);
	end

	--TableCardLayer.TableDealCards()

	for i = 1, 3 do
		local card = TableCard:new(0, FACE_BACK, false);
		TableCardLayer.addReservedCard(card)
	end
	TableCardLayer.refreshReservedCards()

	mnReservedCardTimes = 1;
	mbIsShowReservedCard = false;
	setMultiple(1);
	m_nBombTimes = 1;
	m_nRocketTimes = 1;
	for i = 1, #m_aPlayer do
		if (m_aPlayer[i] ~= nil) then
			m_aPlayer[i].m_bReady = false;
			m_aPlayer[i].m_bIsLord = false;
			m_aPlayer[i].m_nCallScore = -1;
			m_aPlayer[i].m_nDoubleScore = -1;
			if (m_aPlayer[i].mnOpenCardsTimes ~= 5) then
				m_aPlayer[i].mnOpenCardsTimes = 1;
			end
		end
	end

	if (mode == ROOM and (mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT)) then
		sendBAOHE_V4_GET_PRO(m_nRoomID);
	end
	setStatus(STAT_SETOUT);

	--如果此时有等待分桌弹框，直接关掉
	hideTableNotEndedView()
end

--[[--
--牌桌叫分逻辑处理
--]]
local function TableCallScoreManage()
	--关闭等待分桌弹框
	hideTableNotEndedView()

	local CallScore = profile.GameDoc.getCallScoreData()

	-- 下一次叫牌座位 由服务器添加
	m_nCallScorePlayerSeat = CallScore["m_nCallScorePlayerSeat"];
	setCurrPlayer(m_nCallScorePlayerSeat)
	m_nCountdownCnt = INIT_TIMER;
	-- 已经叫到分值 ---1表示必须叫分
	m_nCurrCallScore = CallScore["m_nCurrCallScore"];
	-- 上一家叫的分值0：不叫1：1分2：2分3：3分
	local nLastCallScore = CallScore["nLastCallScore"];
	-- 上一家的位置
	local nLastCallSeat = CallScore["nLastCallSeat"];
	-- NextGrabSeat byte 下一次抢地主座位号
	local NextGrabSeat = CallScore["NextGrabSeat"];
	-- CurrTimes local 当前倍数 服务器决定叫分x几倍
	local CurrTimes = CallScore["CurrTimes"];

	Common.log("当前倍数 服务器决定叫分x几倍："..CurrTimes);
	Common.log("自己的座位号：" .. getSelfSeat());
	Common.log(NextGrabSeat .. "号玩家开始抢地主");
	Common.log(nLastCallSeat .. "号玩家叫分" .. nLastCallScore .. "，下一个叫分玩家：" .. m_nCurrPlayer);
	getPlayer(nLastCallSeat).m_nCallScore = nLastCallScore;

	TableElementLayer.hidePlayerTips(TableConsole.getPlayerPosBySeat(m_nCallScorePlayerSeat) + 1)
	if (mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT) then
		--欢乐/癞子
		if (NextGrabSeat >= 0 and NextGrabSeat <= 2) then
			setCurrPlayer(NextGrabSeat)
			-- 第一次开始抢地主
			setStatus(STAT_GRAB_LANDLORD);
			if (m_nCurrPlayer == getSelfSeat() and getPlayer(getSelfSeat()).m_bTrustPlay == false) then
				-- 显示抢地主按钮
				TableLogic.changeShowButtonPanel(m_nCurrBtnType)
			end
		else
			Common.log("叫分逻辑处理 m_nGameStatus ：" .. m_nGameStatus);
			-- 显示叫分按钮
			if (m_nCurrPlayer == getSelfSeat() and getPlayer(getSelfSeat()).m_bTrustPlay == false) then
				TableLogic.changeShowButtonPanel(m_nCurrBtnType)
			end
		end

		if (CurrTimes > 0) then
			setMultiple(CurrTimes)
		end

		if (nLastCallScore == 3) then
			TableElementLayer.showPlayerTips(nLastCallSeat, "叫地主")
			TableLogic.exeDoubleAnimation(3)

			local next = math.random(0, 1);
			if next == 0 then
				AudioManager.playLordSound(AudioManager.TableVoice.JIAODIZHU, false, getPlayer(nLastCallSeat).mnSex);
			elseif next == 1 then
				AudioManager.playLordSound(AudioManager.TableVoice.WOSHIDIZHU, false, getPlayer(nLastCallSeat).mnSex);
			end
		elseif (nLastCallScore == 0) then
			TableElementLayer.showPlayerTips(nLastCallSeat, "不叫")
			AudioManager.playLordSound(AudioManager.TableVoice.BUJIAO, false, getPlayer(nLastCallSeat).mnSex);
		end
	else
		--普通
		-- 显示叫分按钮
		if (m_nCurrPlayer == getSelfSeat() and getPlayer(getSelfSeat()).m_bTrustPlay == false) then
			TableLogic.changeShowButtonPanel(m_nCurrBtnType);
			TableLogic.setCallScoreBtn(m_nCurrCallScore);
		end
		if (m_nCurrCallScore > 0) then
			setMultiple(m_nCurrCallScore)
			TableLogic.exeDoubleAnimation(m_nCurrCallScore)
			Common.log("readCallScore m_nMultiple =" .. m_nMultiple);
		end
		if (nLastCallScore == 3) then
			TableElementLayer.showPlayerTips(nLastCallSeat, "3分")
			TableLogic.exeDoubleAnimation(3)
			AudioManager.playLordSound(AudioManager.TableVoice.SANFEN, false, getPlayer(nLastCallSeat).mnSex);
		elseif (nLastCallScore == 2) then
			TableElementLayer.showPlayerTips(nLastCallSeat, "2分")
			TableLogic.exeDoubleAnimation(2)
			AudioManager.playLordSound(AudioManager.TableVoice.LIANGFEN, false, getPlayer(nLastCallSeat).mnSex);
		elseif (nLastCallScore == 1) then
			TableElementLayer.showPlayerTips(nLastCallSeat, "1分")
			TableLogic.exeDoubleAnimation(1)
			AudioManager.playLordSound(AudioManager.TableVoice.YIFEN, false, getPlayer(nLastCallSeat).mnSex);
		elseif (nLastCallScore == 0) then
			TableElementLayer.showPlayerTips(nLastCallSeat, "不叫")
			getPlayer(nLastCallSeat):setAnim(GameArmature.ARMATURE_BUYAO);
			AudioManager.playLordSound(AudioManager.TableVoice.BUJIAO, false, getPlayer(nLastCallSeat).mnSex);
		end
	end
end

--[[--
-- 设置玩家的牌数及动画
--
-- @param nLordSeat
--]]
function setGameBeginPlayer(nLordSeat)

	if mnTableType == TABLE_TYPE_NORMAL then
		-- 设置每个玩家的牌数
		for i = 1, #m_aPlayer do
			if ((i - 1) == nLordSeat) then
				getPlayer(i - 1).m_nCardCnt = 20;
			else
				getPlayer(i - 1).m_nCardCnt = 17;
			end
			if (getPlayer(i - 1).m_bTrustPlay) then
				getPlayer(i - 1):setAnim(GameArmature.ARMATURE_TUOGUAN);
			--else
			--getPlayer(i - 1):setAnim(GameArmature.ARMATURE_DAIJI);
			end
		end
	elseif mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT then
		-- 设置每个玩家的牌数
		for i = 1, #m_aPlayer do
			if ((i - 1) == nLordSeat) then
				getPlayer(i-1).m_nCardCnt = 20;
			else
				getPlayer(i-1).m_nCardCnt = 17;
			end
		end
	end

	TableElementLayer.updataUserCardCnt()
end

--[[--
-- 设置牌局开始时的底牌、自己的手牌、状态切换
--
--@param nLordSeat
--]]
function setGameBeginData(nLordSeat)
	if (getSelfSeat() == nLordSeat) then
		getPlayer(getSelfSeat()).m_nCardCnt = 20;
	else
	--			for (local i = 0; i < m_self.m_nCardCnt; i++) {
	--				m_aSelfCards[i].m_bMatrixComputed = true;
	--			}
	end

	m_nCountdownCnt = 30;
	-- 切换屏幕状态到出牌阶段
	setStatus(STAT_TAKEOUT);

	if (mnTableType == TABLE_TYPE_NORMAL) then
		-- 普通房间显示牌桌任务/比赛中显示排名
		if (mode == MATCH) then
		--				LordMgr.getInst().updateUI(LordMgr.RANKING_UPDATE, true, -1);
		--				LordMgr.getInst().updateUI(LordMgr.RANKING_SHOW, false, 1000);
		else
		--				LordMgr.getInst().updateUI(LordMgr.TASK_SHOW, true, -1);
		--				LordMgr.getInst().updateUI(LordMgr.TASK_HIDE, false, 5000);
		end
	end
end

isShowLaiZiAnim_LordSeat = -1;--地主座位号

--[[--
--设置牌局开始时的按钮显示
--
--@param nLordSeat
--]]
function setGameBeginBtn(nLordSeat)
	-- 地主先出牌
	setCurrPlayer(nLordSeat)
	if (mnTableType == TABLE_TYPE_OMNIPOTENT) then
		-- 设置癞子牌后，刷新手牌和底牌
		isShowLaiZiAnim_LordSeat = -1
		ResumeSocket("设置癞子牌");
		mnLaiziCardVal = tempLaiziCardVal;
		tempLaiziCardVal = -1;
		if (mnLaiziCardVal >= 0) then
			-- 此时创建牌时，还不能准确判断是否是癞子牌,因此要手动赋值 mbLaiZi
			TableCardLayer.setLaiZiReservedCard(mnLaiziCardVal)
			TableCardLayer.refreshHandCardsValForLaizi()
			TableCardLayer.refreshReservedCardsValForLaizi()
			for i = 1, #m_aPlayer do
				if (m_aPlayer[i].mnOpenCardsTimes > 1) then
					TableCardLayer.refreshOpenCardsValForLaizi(m_aPlayer[i].m_nSeatID)
				end
			end
		end

		-- 更新记牌器，癞子牌显示绿色
		jipaiqiLogic.updataJipaiData()
	end

	--TableCardManage.initData(TableCardLayer.getSelfCards())

	if (getSelfSeat() == nLordSeat and getPlayer(getSelfSeat()).m_bTrustPlay == false) then
		--			refreshTakeOutBtnStatus(true);
		--			LordMgr.getInst().updateUI(LordMgr.GAMEBTN_SHOW, true, -1);
		if mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT then
			if getPlayer(getSelfSeat()).mnOpenCardsTimes == 1 then
				--自己是地主并且没有明牌
				m_nCurrBtnType = Button_open_takeout
			end
		end
		TableLogic.changeShowButtonPanel(m_nCurrBtnType)
	end
	AudioManager.playLordSound(AudioManager.TableSound.KAISHI, false, AudioManager.SOUND);
	if TableConsole.getPlayer(TableConsole.getSelfSeat()).m_bIsLord then
		TableCardLayer.lordReservedCardsTips()
	end
end


--[[--
--开始出牌状态相关设置
--]]
function startTakeout(nLordSeat)
	setGameBeginPlayer(nLordSeat);
	if mnTableType == TABLE_TYPE_NORMAL or mnTableType == TABLE_TYPE_HAPPY then
		setGameBeginData(nLordSeat);
		setGameBeginBtn(nLordSeat);
	elseif mnTableType == TABLE_TYPE_OMNIPOTENT then
		PauseSocket("解析发底牌应答");
		isShowLaiZiAnim_LordSeat = nLordSeat;
		setGameBeginData(nLordSeat);
		GameArmature.setTableArmature(GameArmature.ARMATURE_TABLE_LAOHUJI)
		--setGameBeginBtn(nLordSeat);
	end
end

--[[
设置记牌器，排除自己的手牌
]]
function excludeSelfCardsInJipaiqi()
	if jipaiqiLogic.bDidExcludeSelfCards == true then
		Common.log("已排除自己手牌")
		return;
	end

	local tSelfCards = TableCardLayer.getSelfCards()
	for i=1,#tSelfCards do
		-- 获取牌值
		local nValue = tSelfCards[i].m_nValue
		setCardRecord(nValue)
	end
	jipaiqiLogic.bDidExcludeSelfCards = true;

	-- 刷新记牌器页面
	jipaiqiLogic.updataJipaiData()
end

--[[
设置记牌器，排除底牌
tDipaiCards:包含底牌的table
]]
function excludeDipaiCardsInJipaiqi(tDipaiCards)
	for i=1, #tDipaiCards do
		-- 获取牌值
		local nValue = tDipaiCards[i]
		setCardRecord(nValue)
	end

	-- 刷新记牌器页面
	jipaiqiLogic.updataJipaiData()
end

--[[--
--牌桌发底牌逻辑处理
--]]
local function TableReserveCardManage()
	local function TableReserveCard()
		local ReserveCard = profile.GameDoc.getReserveCardData();
		TableElementLayer.hidePlayerTips(-1);
		-- 地主是谁
		local nLordSeat = ReserveCard["nLordSeat"];
		setCurrPlayer(-1);
		getPlayer(nLordSeat).m_bIsLord = true;

		Common.log(nLordSeat .. "号玩家成为地主");

		TableElementLayer.setSameTime()  --设置不是同一局

		-- 底牌数
		local ReserveCardVal = {}
		for i = 1, #ReserveCard["ReservedCard"] do
			table.insert(ReserveCardVal, ReserveCard["ReservedCard"][i])
			if TableCardLayer.getReservedCards()[i] ~= nil then
				TableCardLayer.getReservedCards()[i]:setValue(ReserveCard["ReservedCard"][i])
			end
		end

		if getSelfSeat() == nLordSeat then
			-- 自己是地主，则在记牌器里排除底牌
			excludeDipaiCardsInJipaiqi(ReserveCardVal)
		end

		TableCardLayer.refreshReservedCards()
		TableCardLayer.turnReserveCard(1)
		--TODO
		if (getSelfSeat() == nLordSeat) then
			TableCardLayer.unSelectAllHandCards()
			-- 如果自己是地主则把这三张底牌收入手中
			TableCardLayer.addHandCard(ReserveCardVal, true)
			TableCardLayer.refreshHandCards()
		else
			if (getPlayer(nLordSeat).mnOpenCardsTimes > 1) then
				TableCardLayer.addOpenCards(ReserveCardVal, nLordSeat)
				TableCardLayer.refreshOpenCardsBySeat(nLordSeat)
			end
		end

		if (mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT) then
			-- ReservedCardTimes local 特殊牌型倍数 同花x2；三同张x3；顺子x3；单王x2；双王x3；其他x1;
			mnReservedCardTimes = ReserveCard["mnReservedCardTimes"];
			Common.log("特殊牌型倍数 ReservedCardTimes ============= " .. mnReservedCardTimes);
			-- MaxTimes local 当前牌桌总倍数
			local delay = CCDelayTime:create(2.1);
			local array = CCArray:create();
			array:addObject(delay);
			array:addObject(CCCallFuncN:create(function()
				setMultiple(ReserveCard["m_nMultiple"])
			end));
			local seq = CCSequence:create(array);
			TableLogic.view:runAction(seq);

			Common.log("当前牌桌总倍数 m_nMultiple ============= " .. m_nMultiple);
			-- ReservedCardName Text 特殊牌型名称
			msReservedCardName = ReserveCard["msReservedCardName"];
			-- HunCardVal byte 癞子牌牌值
			tempLaiziCardVal = ReserveCard["HunCardVal"];
			Common.log("癞子牌 = "..tempLaiziCardVal)
			Common.log("癞子牌 index = "..tonumber(tempLaiziCardVal%13))
			-- 使用临时tempLaiziCardVal是因为此时客户端未展示癞子牌，要等老虎机动画结束之后在确认癞子牌值
		else
			if nLordSeat == getSelfSeat() then
				GameArmature.showArmatureShifted(getPlayerPosBySeat(getSelfSeat()));
			else
				GameArmature.showArmatureShifted(getPlayerPosBySeat(getSelfSeat()));
				GameArmature.showArmatureShifted(getPlayerPosBySeat(nLordSeat));
			end
			TableElementLayer.setPhotoAminVisible(true);
			TableElementLayer.setPhotoImage(false);
			getPlayer(nLordSeat):setAnim(GameArmature.ARMATURE_DAIJI);
		end

		for i = 1, #m_aPlayer do
			if (m_aPlayer[i] ~= nil) then
				m_aPlayer[i].m_nGrabScore = -1;
			end
		end
		startTakeout(nLordSeat);
	end

	if mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT then
		--为了显示最后一个人的加倍信息，暂停一秒
		local delay = CCDelayTime:create(1);
		local array = CCArray:create();
		array:addObject(delay);
		array:addObject(CCCallFuncN:create(TableReserveCard));
		local seq = CCSequence:create(array);
		TableLogic.view:runAction(seq);
	else
		TableReserveCard();
	end
end

--[[--
--牌桌出牌逻辑处理
--]]
local function TableTakeOutCardManage()
	local TakeOutCard = profile.GameDoc.getTakeOutCardData()
	if (m_nGameStatus ~= STAT_TAKEOUT) then
		return;
	end
	m_nCurrBtnType = Button_takeout
	-- TakeOutSeat byte 出牌者玩家的座位号
	local nPlayer = TakeOutCard["nPlayer"];
	Common.log("出牌者 玩家的座位号nPlayer ================ " .. nPlayer);
	local p = getPlayer(nPlayer);
	m_nCountdownCnt = INIT_TIMER;
	-- NextSeat byte 下一个出牌玩家
	-- 下一个出牌的玩家
	setCurrPlayer(TakeOutCard["m_nCurrPlayer"])
	Common.log("下一个出牌的玩家m_nCurrPlayer ================ " .. m_nCurrPlayer);

	local alCardList = {};

	-- CardsCnt byte 牌数 出了多少张牌
	local nNormalCardCnt = TakeOutCard["nNormalCardCnt"];
	-- 取出牌
	for  i = 1,  nNormalCardCnt do
		local cardData = TableTakeOutCard:new()
		-- ...CardVal byte 牌值 非癞子牌
		local nVal = TakeOutCard["NormalCard"][i].nVal;
		cardData.mbIsLaiZi = false;
		cardData.mnTheOriginalValue = nVal;
		cardData.mnTheEndValue = nVal;
		table.insert(alCardList, cardData)
		Common.log("m_nSeatID = "..m_nSeatID)

		if nPlayer ~= m_nSeatID then
			-- 如果不是自己出牌，则设置记牌器，因为初始化的时候已经排除了自己的手牌
			setCardRecord(cardData.mnTheOriginalValue)
		end
		--currCardVal[nPlayer][i] = cardData.mnTheEndValue;-- 添加上一手牌
	end

	-- LaiziCardsCnt byte 癞子牌牌数 癞子牌变化后的牌
	local nLaiziCardCnt = TakeOutCard["nLaiziCardCnt"];
	for i = 1,  nLaiziCardCnt do
		local cardData = TableTakeOutCard:new()
		-- ... HunCardVal byte 癞子牌变化后的牌值
		local nEndVal = TakeOutCard["LaiziCard"][i].nEndVal;
		-- ... OriginalCardVal byte 癞子牌变化前的原始牌值
		local OriginalCardVal = TakeOutCard["LaiziCard"][i].OriginalCardVal;
		cardData.mbIsLaiZi = true;
		cardData.mnTheOriginalValue = OriginalCardVal;
		cardData.mnTheEndValue = nEndVal;
		table.insert(alCardList, cardData)
		Common.log("m_nSeatID = "..m_nSeatID)

		if nPlayer ~= m_nSeatID then
			-- 如果不是自己出牌，则设置记牌器，因为初始化的时候已经排除了自己的手牌
			setCardRecord(cardData.mnTheOriginalValue)
		end
		--currCardVal[nPlayer][nNormalCardCnt + i] = cardData.mnTheEndValue;-- 添加上一手牌
	end
	-- 总牌数
	local nCardCnt = #alCardList;

	-- 判断之前出的牌与服务器应答的牌是否一致,如果不一致，以服务器为准
	local isSuccess = true;
	local equalNum = 0;
	if (nPlayer == getSelfSeat() and nCardCnt > 0) then
		m_bPassFlag = false;
		if (m_bSendTakeOutCard) then
			--自己主动出牌
			if (#alCardList == #m_anOutCard) then
				for i = 1, #alCardList do
					for j = 1, #m_anOutCard do
						if (alCardList[i].mnTheOriginalValue == m_anOutCard[j]) then
							equalNum = equalNum + 1;
							break;
						end
					end
				end
				if (equalNum == #alCardList) then
					isSuccess = true;
				else
					isSuccess = false;
				end
			else
				isSuccess = false;
			end
		else
			--服务器帮助出牌
			isSuccess = false;
		end
	end

	--更新记牌器
	jipaiqiLogic.updataJipaiData()

	if nPlayer ~= getSelfSeat() then
		--别人出的牌
		p:setAnim(GameArmature.ARMATURE_CHUPAI);
		TableCardLayer.addTableCard(alCardList, nPlayer)
		TableCardLayer.refreshTableCardsBySeat(nPlayer)
		--移除明牌
		if nCardCnt > 0 and p.mnOpenCardsTimes > 1  then
			TableCardLayer.removeOpenCardsBySeat(alCardList, nPlayer)
			TableCardLayer.refreshOpenCardsBySeat(nPlayer)
		end
	else
		--自己出的牌
		if not isSuccess then
			Common.log("出牌失败......");
			local OutCard = {}
			for i = 1, #alCardList do
				OutCard[i] = alCardList[i].mnTheOriginalValue;
			end
			TableCardLayer.removeHandCard(OutCard);
			TableCardLayer.refreshHandCards();
			TableCardLayer.addTableCard(alCardList, nPlayer);
			TableCardLayer.refreshTableCardsBySeat(nPlayer);
			sendSyncHandCards();
		end
	end

	if (nPlayer ~= getSelfSeat() or not m_bSendTakeOutCard or not isSuccess) then
		local isNewBout = true;-- 是否是新的回合
		if (nPlayer == getSelfSeat()) then
			if (not m_bSendTakeOutCard) then
				-- 托管或者服务器为自己出牌
				if (nCardCnt == 0) then
					local next = math.random(0, 3);
					if next == 0 then
						AudioManager.playLordSound(AudioManager.TableVoice.BUYAO, false, p.mnSex);
					elseif next == 1 then
						AudioManager.playLordSound(AudioManager.TableVoice.YAOBUQI, false, p.mnSex);
					elseif next == 2 then
						AudioManager.playLordSound(AudioManager.TableVoice.PASS, false, p.mnSex);
					elseif next == 3 then
						AudioManager.playLordSound(AudioManager.TableVoice.GUO, false, p.mnSex);
					end
					p:setAnim(GameArmature.ARMATURE_BUYAO);
				end

				if (nCardCnt == 0) then
					TableElementLayer.showPlayerTips(nPlayer, "不要");
				end
				TableElementLayer.hidePlayerTips(TableConsole.getPlayerPosBySeat(m_nCurrPlayer) + 1);
			end
		else
			if (nCardCnt == 0) then
				isNewBout = false;
				local next = math.random(0, 3);
				if next == 0 then
					AudioManager.playLordSound(AudioManager.TableVoice.BUYAO, false, p.mnSex);
				elseif next == 1 then
					AudioManager.playLordSound(AudioManager.TableVoice.YAOBUQI, false, p.mnSex);
				elseif next == 2 then
					AudioManager.playLordSound(AudioManager.TableVoice.PASS, false, p.mnSex);
				elseif next == 3 then
					AudioManager.playLordSound(AudioManager.TableVoice.GUO, false, p.mnSex);
				end
				p:setAnim(GameArmature.ARMATURE_BUYAO);
			else
				if p.m_nCardCnt == 1 then
					-- 剩一张
					local next = math.random(0, 1);
					if next == 0 then
						AudioManager.playLordSound(AudioManager.TableVoice.ZUIHOUYIZHANG1, false, p.mnSex);
					elseif next == 1 then
						AudioManager.playLordSound(AudioManager.TableVoice.ZUIHOUYIZHANG2, false, p.mnSex);
					end
				elseif p.m_nCardCnt == 2 then
					-- 剩两张
					local next = math.random(0, 1);
					if next == 0 then
						AudioManager.playLordSound(AudioManager.TableVoice.ZUIHOUERZHANG1, false, p.mnSex);
					elseif next == 1 then
						AudioManager.playLordSound(AudioManager.TableVoice.ZUIHOUERZHANG2, false, p.mnSex);
					end
				elseif p.m_nCardCnt == 3 then
					-- 最后三张
					AudioManager.playLordSound(AudioManager.TableSound.SOUND_SHENGSAN, false, AudioManager.SOUND);
				end

				isNewBout = TableCardLayer.getIsNewBout(nPlayer);

				AudioManager.playLordSound(AudioManager.TableSound.CHUPAI, false, AudioManager.SOUND);
			end

			if (nCardCnt == 0) then
				TableElementLayer.showPlayerTips(nPlayer, "不要");
			end
			if isNewBout then
				TableElementLayer.hidePlayerTips(-1);
			else
				TableElementLayer.hidePlayerTips(TableConsole.getPlayerPosBySeat(m_nCurrPlayer) + 1);
			end
		end

		TableCardManage.initData(TableCardLayer.getSelfCards())
		setTakeOutEffect(nCardCnt, nPlayer, isNewBout);

		-- 清除即将出牌人桌上的牌
		if (m_nCurrPlayer < #m_aPlayer and m_nCurrPlayer > -1) then
			Common.log("清除即将出牌人桌上的牌" .. m_nCurrPlayer);
			TableCardLayer.clearTableCardsBySeat(m_nCurrPlayer)
		end
	end

	if (m_nCurrPlayer < getPlayerCnt() and m_nCurrPlayer > -1 and nPlayer ~= getSelfSeat() and (TableCardLayer.getHandCardsCnt() == 1 or not getPlayer(getSelfSeat()).m_bTrustPlay)) then
		if (nCardCnt > 0) then
			local pos = getPlayerPosBySeat(nPlayer)
			if (TableCardLayer.getPlayerTableCards()[pos + 1] ~= nil and #TableCardLayer.getPlayerTableCards()[pos + 1] > 0) then
				local b = false;
				b = TableCardManage.Search(TableCardLayer.getPlayerTableCards()[pos + 1], false);
				if (not b) then
					--没有更大的牌
					if not getPlayer(getSelfSeat()).m_bTrustPlay then
						TableCardLayer.showNoBigCard();
						TableCardLayer.unSelectAllHandCards()
					end
					TableCardManage.initData(TableCardLayer.getSelfCards());
				end
			end
		end
		-- 下一个出牌玩家为自己
		if (m_nCurrPlayer == getSelfSeat()) and not getPlayer(getSelfSeat()).m_bTrustPlay then
			if TableCardLayer.isYaobuqi then
				--要不起(没有更大的牌)
				TableLogic.setYaobuqiState(true)
			else
				TableLogic.changeShowButtonPanel(m_nCurrBtnType);
				TableLogic.setYaobuqiState(false)
			end
			-- 自动提示
			if (GameConfig.getGameAutomation() and TableCardLayer.isNotSelectCard())then
				-- 如果开启自动提示&&自己没有选中牌
				for i = 2, 1, -1 do
					if (TableCardLayer.getPlayerTableCards()[i + 1] ~= nil and #TableCardLayer.getPlayerTableCards()[i + 1] > 0) then
						local b = false;
						if (not getPlayer(getSelfSeat()).m_bIsLord and not getPlayer(getPlayerSeatByPos(i)).m_bIsLord) then
							--自己是农民时另一个农民出牌
							b = TableCardManage.Search(TableCardLayer.getPlayerTableCards()[i + 1], false);
						else
							b = TableCardManage.Search(TableCardLayer.getPlayerTableCards()[i + 1], true);
						end
						if (not b) then
							--没有更大的牌
							TableCardManage.initData(TableCardLayer.getSelfCards());
							Common.log("zbl....没有更大的牌00000000")
						else
							--设置出牌按钮当前可用
							TableLogic.logicTakeoutButtonEnabled();
						end
						break;
					end
				end
			end
			local isAble = true; -- 是否有牌大过上家
			local nPassCnt = 0;
			local nSeat = m_nCurrPlayer;
			for i = 1, 2 do
				nSeat = (nSeat - 1 + 3) % 3;-- 找到自己的上家
				local pos = getPlayerPosBySeat(nSeat)
				if (m_anPlayerCardType[pos + 1] == TableCardManage.TYPE_TWO_CAT) then
					-- 上家出了双王，自动过牌
					pass();
					break;
				elseif (TableCardLayer.getHandCardsCnt() == 1) then
					-- 如果自己只剩一张牌
					if (m_anPlayerCardType[pos + 1] >= TableCardManage.TYPE_TWO) then
						-- 上家牌牌型为对子以上，自动过牌
						pass();
						break;
					elseif (m_anPlayerCardType[pos + 1] == -1) then
						nPassCnt = nPassCnt + 1;
						if (nPassCnt == 2) then
							-- 两个上家都为不要时，自动出牌
							-- 出最后一张牌，不显示按钮
							TableLogic.hideGameBtn();
							local takeOutData = {};
							local TakeOutCardData = {};
							if (TableCardLayer.getSelfCards()[1].mbLaiZi) then
								TakeOutCardData.mbIsLaiZi = true;
							else
								TakeOutCardData.mbIsLaiZi = false;
							end
							TakeOutCardData.mnTheOriginalValue = TableCardLayer.getSelfCards()[1].m_nValue;
							TakeOutCardData.mnTheEndValue = TableCardLayer.getSelfCards()[1].m_nValue;-- 最后一张牌是癞子的话，也是按原牌值出牌，不需要变换牌值
							table.insert(takeOutData, TakeOutCardData);
							sendTakeOutCard(takeOutData);
							break;
						end
					end
				elseif (TableCardLayer.getHandCardsCnt() > 1) then
				-- 自己还有多张牌
				--if (m_anPlayerCardType[nSeat] == -1) {
				--	nPassCnt++;
				--	if (nPassCnt == 2) {-- 上俩家都为不要时
				--		refreshTakeOutBtnStatus(false);
				--		LordMgr.getInst().updateUI(LordMgr.GAMEBTN_SHOW, false, -1);
				--		break;
				--	}
				--}
				end
				--if (m_anPlayerTableCardsCnt[nSeat] > 0) then
				-- --上家出牌
				--	refreshTakeOutBtnStatus(false);
				--	LordMgr.getInst().updateUI(LordMgr.GAMEBTN_SHOW, false, -1);
				--	isAble = m_CardDoc.Search(TableCardLayer.getPlayerTableCards()[nSeat], m_anPlayerTableCardsCnt[nSeat], false);
				--	break;
				--end
			end
			--if (not isAble) then
			--	LordMgr.getInst().updateUI(LordMgr.PASS1, mMyTakeOutCardTime, false, 5000);
			--	Common.log("mMyTakeOutCardTime=" + mMyTakeOutCardTime);
			--end
		end
	end

	--重置数据
	m_anOutCard = {}
	m_bSendTakeOutCard = false;
end

--[[--
--设置自己托管时的状态
--
--@param bTrustPlay
--]]
local function setTrustPlayStatus(bTrustPlay)
	if (bTrustPlay) then
		--托管
		if (m_nGameStatus == STAT_SETOUT or m_nGameStatus == STAT_CALLSCORE or m_nGameStatus == STAT_TAKEOUT) then
			TableLogic.hideGameBtn()
		end
		TableLogic.changeTrustPlayButton(true)
		TableCardLayer.setAllHandCardsMarked(true)
		TableCardLayer.setCardLayerTouchEnabled(false)
	else
		--解除托管
		if mnTableType == TABLE_TYPE_NORMAL then
			if (m_nGameStatus == STAT_SETOUT or m_nGameStatus == STAT_CALLSCORE or m_nGameStatus == STAT_TAKEOUT) then
				if (m_nCurrPlayer == getSelfSeat()) then
					TableLogic.changeShowButtonPanel(m_nCurrBtnType)
				end
			end
		elseif mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT then
			if (m_nGameStatus == STAT_SETOUT or m_nGameStatus == STAT_CALLSCORE or m_nGameStatus == STAT_GRAB_LANDLORD or m_nGameStatus == STAT_DOUBLE_SCORE or m_nGameStatus == STAT_TAKEOUT) then
				if (m_nCurrPlayer == getSelfSeat()) then
					TableLogic.changeShowButtonPanel(m_nCurrBtnType)
				end
			end
		end
		TableLogic.changeTrustPlayButton(false)
		TableCardLayer.setAllHandCardsMarked(false)
		TableCardLayer.setCardLayerTouchEnabled(true)
	end
end

--[[--
--发送托管/解脱请求
--]]
function sendTableTrustPlayReq(nType)
	if (nType == 1 or nType == 2) then
		if m_nGameStatus >= STAT_CALLSCORE then
			if getCurrPlayer() == getSelfSeat() then
				setCurrPlayer(-1)
			end
		end
	end
	sendTrustPlayReq(nType);
end

--[[--
--存储被踢玩家的下标
--]]
function setBekickOutPlayerPosition(playerPosition)
	position = playerPosition
end

--[[--
--获得被踢玩家的下标
--]]
function getBekickOutPlayerPosition()
	return position
end
--[[--
--牌桌托管逻辑处理
--]]
local function TableTrustPlayManage()
	local TrustPlay = profile.GameDoc.getTrustPlayData()
	Common.closeProgressDialog();
	--String[] s = { "0解除托管", "1手动托管", "2超时托管", "3断线托管", "4托管退出" };
	local nSeatID = TrustPlay["nSeatID"];
	local type = TrustPlay["type"];
	if type > 0 then
		getPlayer(nSeatID).m_bTrustPlay = true;
		TableElementLayer.trustAlert(nSeatID)
		--		Common.log("zbl....type>0")
	else
		--		Common.log("zbl....type<0")
		getPlayer(nSeatID).m_bTrustPlay = false;
	end
	getPlayer(nSeatID).m_nTrustType = type;
	local nAnimType = 0;
	if (getPlayer(nSeatID).m_bTrustPlay) then
		nAnimType = GameArmature.ARMATURE_TUOGUAN;
	else
		nAnimType = GameArmature.ARMATURE_DAIJI;
	end
	getPlayer(nSeatID):setAnim(nAnimType);
	if (nSeatID == getSelfSeat()) then
		if type > 0 then
			if m_nGameStatus == STAT_TAKEOUT then
				--当前是出牌阶段
				sendSyncHandCards();
				TableCardLayer.clearTableCardsBySeat(getSelfSeat());
				TableCardLayer.hideNoBigCard();
			end
		end
		setTrustPlayStatus(getPlayer(nSeatID).m_bTrustPlay);
	end
end


--[[--
--发送抢地主请求
--]]
function sendTableGrabLandlord(isGrab)
	setCurrPlayer(-1)
	sendLORDID_GRAB_LANDLORD(isGrab)
end

--[[--
--牌桌抢地主逻辑处理
--]]
local function TableGrabLandlordManage()
	local GrabLandlord = profile.GameDoc.getGrabLandlordData()

	-- pauseSocketRecv("抢地主");
	m_nCountdownCnt = INIT_TIMER;
	-- LordMgr.getInst().updateUI(LordMgr.RESUME, false, 1000);
	-- NextGrabSeat byte 下一个抢地主的座位号
	m_nCallScorePlayerSeat = GrabLandlord["m_nCallScorePlayerSeat"];
	Common.log("下一个抢地主的座位号: " .. m_nCallScorePlayerSeat);
	-- LastGrabSeat byte 上一个抢地主的座位号
	local nLastGrabSeat = GrabLandlord["nLastGrabSeat"];
	Common.log("上一个抢地主的座位号: " .. nLastGrabSeat);
	-- LastGrabScore byte 0不抢，1抢
	local nLastGrabScore = GrabLandlord["nLastGrabScore"];
	Common.log("是否抢地主0不抢，1抢: " .. nLastGrabScore);
	-- MaxTimesV2 local 新倍数 V2版欢乐使用
	setMultiple(GrabLandlord["m_nMultiple"])
	Common.log("MaxTimesV2 local 新倍数 V2版欢乐使用 :" .. m_nMultiple);
	setCurrPlayer(m_nCallScorePlayerSeat)
	getPlayer(nLastGrabSeat).m_nGrabScore = nLastGrabScore;
	if (m_nCallScorePlayerSeat == getSelfSeat() and getPlayer(getSelfSeat()).m_bTrustPlay == false) then
		TableLogic.changeShowButtonPanel(m_nCurrBtnType)
	end
	TableElementLayer.hidePlayerTips(TableConsole.getPlayerPosBySeat(m_nCallScorePlayerSeat) + 1)
	-- 抢地主音效
	if (nLastGrabScore == 1) then
		TableElementLayer.showPlayerTips(nLastGrabSeat, "抢地主")
		TableLogic.exeDoubleAnimation(2)
		local next = math.random(0, 2);
		if next == 0 then
			AudioManager.playLordSound(AudioManager.TableVoice.QIANGDIZHU1, false, getPlayer(nLastGrabSeat).mnSex);
		elseif next == 1 then
			AudioManager.playLordSound(AudioManager.TableVoice.QIANGDIZHU2, false, getPlayer(nLastGrabSeat).mnSex);
		elseif next == 2 then
			AudioManager.playLordSound(AudioManager.TableVoice.QIANGDIZHU3, false, getPlayer(nLastGrabSeat).mnSex);
		end
	elseif (nLastGrabScore == 0) then
		TableElementLayer.showPlayerTips(nLastGrabSeat, "不抢")
		getPlayer(nLastGrabSeat):setAnim(GameArmature.ARMATURE_BUYAO);
		AudioManager.playLordSound(AudioManager.TableVoice.BUQIANG, false, getPlayer(nLastGrabSeat).mnSex);
	end
end

--[[--
--发送加倍请求
--@param isDoubleScore
--]]
function sendTableDoubleScore(isDoubleScore)
	setCurrPlayer(-1)

	if isDoubleScore == 0 then
		--如果点击不加倍，直接发送消息，不判断后面的情况
		sendLORDID_DOUBLE_SCORE(isDoubleScore)
		TableLogic.hideGameBtn()
		return
	end
	if  getPlayer(getSelfSeat()).m_nCanDoubleMax == 4 then
		--能够超级加倍,发送请求消息
		sendLORDID_DOUBLE_SCORE(isDoubleScore)
		TableLogic.hideGameBtn()
	elseif  getPlayer(getSelfSeat()).m_nCanDoubleMax == 2 then
		--只能够普通加倍
		if isDoubleScore == 2 then
			--加倍，发送消息
			sendLORDID_DOUBLE_SCORE(isDoubleScore)
			TableLogic.hideGameBtn()
		else
			--超级加倍，弹toast
			CarryOutDoubleOperation(isDoubleScore)
		end
	else
		--不满足加倍条件，弹出相应toast
		CarryOutDoubleOperation(isDoubleScore)
	end
end

--[[--
--牌桌加倍逻辑处理
--]]
local function TableDoubleScoreManage()
	local DoubleScore = profile.GameDoc.getDoubleScoreData()

	--		pauseSocketRecv("加倍");
	--		LordMgr.getInst().updateUI(LordMgr.RESUME, false, 1000);
	-- LastDoubleSeat byte
	local LastDoubleSeat = DoubleScore["LastDoubleSeat"];
	-- doubleScore byte 加几倍 0不加倍2两倍 4 加四倍
	local doubleScore = DoubleScore["doubleScore"];

	Common.log("doubleScore = "..doubleScore)

	for i = 1, #DoubleScore["PlayerList"] do
		-- …PlayerSeat byte 座位号
		local PlayerSeat = DoubleScore["PlayerList"][i].PlayerSeat;
		Common.log("PlayerSeat byte 座位号: ==" .. PlayerSeat);
		-- …MaxTimes local 倍数
		local MaxTimes = DoubleScore["PlayerList"][i].MaxTimes;
		Common.log("MaxTimes local 倍数: ==" .. MaxTimes);

		if (PlayerSeat == getSelfSeat()) then
			setMultiple(MaxTimes)
		end
		getPlayer(PlayerSeat).m_nGrabScore = -1;-- 开始加倍时，不再显示抢地主信息
	end

	if (LastDoubleSeat ~= -1 and LastDoubleSeat ~= 255) then
		getPlayer(LastDoubleSeat).m_nDoubleScore = doubleScore;
	end

	TableElementLayer.showDoubleIcon(LastDoubleSeat, doubleScore)
	-- 加倍音效
	if doubleScore == 1 then
		Common.log("不加倍")
		TableElementLayer.showPlayerTips(LastDoubleSeat, "不加倍")
		getPlayer(LastDoubleSeat):setAnim(GameArmature.ARMATURE_BUYAO);
		AudioManager.playLordSound(AudioManager.TableVoice.BUJIABEI, false, getPlayer(LastDoubleSeat).mnSex);
	elseif doubleScore == 2 then
		TableElementLayer.showPlayerTips(LastDoubleSeat, "加倍")
		AudioManager.playLordSound(AudioManager.TableVoice.JIABEI, false, getPlayer(LastDoubleSeat).mnSex);
		AudioManager.playLordSound(AudioManager.TableSound.JIABEI_BG, false, AudioManager.SOUND);

		TableLogic.exeDoubleAnimation(2)
	elseif doubleScore == 4 then
		TableElementLayer.showPlayerTips(LastDoubleSeat, "超级加倍")
		AudioManager.playLordSound(AudioManager.TableVoice.JIABEISUPER, false, getPlayer(LastDoubleSeat).mnSex);
		AudioManager.playLordSound(AudioManager.TableSound.JIABEI_BG, false, AudioManager.SOUND);

		TableLogic.exeDoubleAnimation(4)
	end
end

--[[--
--发送明牌请求
--@param OpenCardsTimes 明牌倍数
--]]
function sendTableOpenCards(OpenCardsTimes)
	if (isSendOpenCards or  getPlayer(getSelfSeat()).mnOpenCardsTimes > 1) then
		return;
	end
	isSendOpenCards = true;
	getPlayer(getSelfSeat()).mnOpenCardsTimes = OpenCardsTimes;
	sendLORDID_OPEN_CARDS(OpenCardsTimes)
end

--[[--
--牌桌明牌逻辑处理
--]]
local function TableOpenCardsManage()
	local OpenCards = profile.GameDoc.getOpenCardsData()

	Common.log("解析明牌倍数==========================");
	-- LastOpenCardsSeat byte 明牌者的座位号
	local LastOpenCardsSeat = OpenCards["LastOpenCardsSeat"];
	Common.log("明牌者的座位号 LastOpenCardsSeat == " .. LastOpenCardsSeat);
	-- OpenCardsTimes byte 明几倍
	local OpenCardsTimes = OpenCards["OpenCardsTimes"];
	Common.log("明几倍 OpenCardsTimes == " .. OpenCardsTimes);
	-- IsOpenCardsEnd byte 是否明牌结束 0未结束，1明牌结束---发牌阶段的明牌才有效
	IsOpenCardsEnd = OpenCards["IsOpenCardsEnd"];
	Common.log("是否明牌结束 0未结束，1明牌结束 IsOpenCardsEnd == " .. IsOpenCardsEnd);
	-- FirstCallSeat byte 第一个叫分的玩家---发牌阶段的明牌才有效
	m_nCallScorePlayerSeat = OpenCards["FirstCallSeat"];
	Common.log("第一个叫分的玩家 m_nCallScorePlayerSeat == " .. m_nCallScorePlayerSeat);
	-- CardCnt ByteArray 明牌手中的牌
	if LastOpenCardsSeat > 3 or LastOpenCardsSeat < 0 then
		return;
	end

	-- MaxTimes local 当前牌桌总倍数
	setMultiple(OpenCards["m_nMultiple"])
	Common.log("当前牌桌总倍数 m_nMultiple == " .. m_nMultiple);

	getPlayer(LastOpenCardsSeat).mnOpenCardsTimes = OpenCardsTimes;
	if (OpenCardsTimes > 1) then
		TableCardLayer.addOpenCards(OpenCards["CardCnt"], LastOpenCardsSeat)
		TableCardLayer.refreshOpenCardsBySeat(LastOpenCardsSeat)

		if LastOpenCardsSeat == getSelfSeat() then
			m_bSelfDidMingpai = true
			TableCardLayer.refreshHandCards();
		end

		if (OpenCardsTimes == 5) then
			AudioManager.playLordSound(AudioManager.TableVoice.OPENSTART, false, getPlayer(LastOpenCardsSeat).mnSex);
			AudioManager.playLordSound(AudioManager.TableSound.JIABEI_BG, false, AudioManager.SOUND);
		else
			AudioManager.playLordSound(AudioManager.TableVoice.OPENCARD, false, getPlayer(LastOpenCardsSeat).mnSex);
			AudioManager.playLordSound(AudioManager.TableSound.JIABEI_BG, false, AudioManager.SOUND);
		end

		TableLogic.exeDoubleAnimation(OpenCardsTimes)
	end

	Common.log("明牌逻辑处理m_nGameStatus ：" .. m_nGameStatus);
	if (IsOpenCardsEnd == 1 and m_nGameStatus <= STAT_CALLSCORE) then
		setCurrPlayer(m_nCallScorePlayerSeat)
		if (TableCardLayer.isDealEnd) then
			--已经发牌结束
			setStatus(STAT_CALLSCORE);
		end
	end
	--	LordMgr.getInst().updateUI(LordMgr.CHIP_UPDATE, true, -1);
end

--[[--
--牌桌开始加倍逻辑处理
--]]
local function TableStartDoubleManage()
	local StartDouble = profile.GameDoc.getStartDoubleData()

	for i = 1, #StartDouble["DoubleStatusList"] do
		-- …seatId byte 玩家座位号
		local nPlayer = StartDouble["DoubleStatusList"][i].nPlayer;
		Common.log("zblaaazseatId byte 玩家座位号 = " .. nPlayer);
		-- …status Byte 玩家最高可加的倍数 0不能加倍2可以加2倍4 可以加4倍
		local status = StartDouble["DoubleStatusList"][i].status;
		Common.log("zblaaaz玩家最高可加的倍数 0不能加倍2可以加2倍4 可以加4倍 = " .. status);
		-- …NoDoubleReason Byte 不能加倍的原因 1自己金币不足0别人金币不足
		local m_nNoDoubleReason = StartDouble["DoubleStatusList"][i].m_nNoDoubleReason;
		Common.log("zblaaaz不能加倍的原因 1自己金币不足0别人金币不足 = " .. m_nNoDoubleReason);
		-- …MinCoins Int 满足加倍条件的最低金币数
		local m_nMinCoins = StartDouble["DoubleStatusList"][i].m_nMinCoins;
		Common.log("zblaaaz满足加倍条件的最低金币数 = " .. m_nMinCoins);
		local m_nCommonMinCoins = StartDouble["DoubleStatusList"][i].m_nCommonMinCoins;
		Common.log("zblaaaz满足普通加倍条件的最低金币数 = " .. m_nCommonMinCoins);
		local m_nMinSuperCoins = StartDouble["DoubleStatusList"][i].m_nSuperMinCoins;
		Common.log("zblaaaz满足超级加倍条件的最低金币数 = " .. m_nMinSuperCoins);
		getPlayer(nPlayer).m_nCanDoubleMax = status;
		getPlayer(nPlayer).m_nNoDoubleReason = m_nNoDoubleReason;
		getPlayer(nPlayer).m_nMinCoins = m_nMinCoins;
		getPlayer(nPlayer).m_nCommonMinCoins = m_nCommonMinCoins;
		getPlayer(nPlayer).m_nMinSuperCoins = m_nMinSuperCoins;

	end
	-- 地主是谁
	local nLordSeat = StartDouble["nLordSeat"];
	Common.log("地主是谁 ============= nLordSeat == " .. nLordSeat);
	Common.log("自己的座位号 ============= " .. getSelfSeat());
	getPlayer(nLordSeat).m_bIsLord = true;
	if nLordSeat == getSelfSeat() then
		GameArmature.showArmatureShifted(getPlayerPosBySeat(getSelfSeat()));
	else
		GameArmature.showArmatureShifted(getPlayerPosBySeat(getSelfSeat()));
		GameArmature.showArmatureShifted(getPlayerPosBySeat(nLordSeat));
	end
	TableElementLayer.setPhotoAminVisible(true);
	TableElementLayer.setPhotoImage(false);
	getPlayer(nLordSeat):setAnim(GameArmature.ARMATURE_DAIJI);
	TableElementLayer.hidePlayerTips(-1);
	-- 开始加倍
	getPlayer(getSelfSeat()).m_nGrabScore = -1;
	if (getPlayer(getSelfSeat()).m_nCanDoubleMax > 0) then
		m_nCountdownCnt = INIT_TIMER;
		setCurrPlayer(getSelfSeat())
	else
		setCurrPlayer(-1)
		m_nCountdownCnt = -1;
	end
	setStatus(STAT_DOUBLE_SCORE);
	setDoubleScoreBtn(getPlayer(getSelfSeat()).m_nCanDoubleMax);

end

mnWin_Pos = {};
mnLoss_Pos = {};

--[[--
--重置用户信息
--]]
local function resetPlayerInfo()
	for i = 1, #m_aPlayer do
		m_aPlayer[i].m_bIsLord = false;
	end
	GameArmature.showDoubleFarmer()--重置成两个农民形象
end

--[[--
--牌局结束信息重置
--]]
function GameResultAfterMsg()
	Common.log("牌局结束信息重置")
	if isPlayingDoudizhu() then
		-- 如果是在牌局中，则直接返回（断线重连回来）
		return
	end

	if getPlayerSeatIDforLord() == getSelfSeat() then
		GameArmature.showArmatureShifted(getPlayerPosBySeat(getSelfSeat()));
	else
		GameArmature.showArmatureShifted(getPlayerPosBySeat(getSelfSeat()));
		if getPlayerSeatIDforLord() ~= nil and getPlayerPosBySeat(getPlayerSeatIDforLord()) ~= nil then
			GameArmature.showArmatureShifted(getPlayerPosBySeat(getPlayerSeatIDforLord()));
		end
	end
	TableElementLayer.setPhotoAminVisible(false);
	TableElementLayer.setPhotoImage(true);
	resetPlayerInfo();

	--移除明牌标志
	--TableCardLayer.removeMingpaiFlagSprite()

	if mode == ROOM then
		TableLogic.changeKickButton(true)
		TableElementLayer.hideGameResultData();
		--房间
		ResumeSocket("readGameResult");
		if isCrazyStage == false then
			--不是闯关赛时,得到结果后显示开始按钮
			TableLogic.changeGameStartButton(true)--显示开始按钮
		end
		--结算
		TableElementLayer.showTableResult() --显示结算icon
		TableElementLayer.hideDoubleIcon();
		TableElementLayer.setTableCostLabelVisible(true)
		BindPhoneConfig.showBindPhoneLayerOnTable()
		logicLadderUp();
	else
		--比赛
		TableLogic.showGameResultView() --显示结算界面
		TableLogic.setOtherUserScore(false)
		TableElementLayer.setTableCostLabelVisible(true)
		TableElementLayer.hideDoubleIcon();
	end

	TableCardLayer.hideNoBigCard();
	jipaiqiLogic.clearJipaiData()--清空记牌器
	TableCardLayer.removeAllCards()--删除牌桌上所有的牌
	--TableLogic.updataTableMultiple(-1)--重置牌桌显示倍数
	--TableLogic.updataTableBaseChip(-1)--重置牌桌底分

	-- 设置倍数为0
	TableLogic.updataTableMultiple(0, false)

	TableHintMsg = nil--清除牌桌中央的提示文字

	if (mode == ROOM) then
		AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.ROOM_BACKGROUND)
	elseif (mode == MATCH) then
		AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.MATCH_BACKGROUND)
	end
	--mode,1比赛模式，2房间模式，1mnTableType牌桌模式，TABLE_TYPE_HAPPY，1欢乐；TABLE_TYPE_OMNIPOTENT，2癞子
	if (mode == ROOM and (mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT)) then
		sendBAOHE_V4_GET_PRO(m_nRoomID);
		--未完成新手引导、完成一局打牌
		if CommDialogConfig.getNewUserGiudeFinish() == false  then
			--新手引导牌局结束
			NewUserGuideLogic.newUserEndBoard = true;
			--新手引导,为了防止消息回来的慢,先将局数加上,能够开启宝箱
			baohePro = baoheMax;
			TableElementLayer.UpdataBaoXiangData();
			NewUserCreateLogic.JumpInterface(nil,NewUserCoverOtherLogic.getTaskState());
		end
	end

	--播完结束动画检测是否有新比赛开始
	if mode == ROOM then
		local matchalarmClock = MatchList.getMatchalarmClock()
		if matchalarmClock ~= nil then
			if #matchalarmClock > 0 then
				for i=1, #matchalarmClock do
					if matchalarmClock[i] ~= nil and matchalarmClock[i].startTimeLong ~= nil then
						local countDownCnt = math.modf((matchalarmClock[i].startTimeLong -  Common.getServerTime()*1000)/1000) -- 动态计算倒计时
						if countDownCnt < 120 then
							-- 闹钟队列里有比赛在2分钟之内开赛的比赛
							-- 退出房间
							TableConsole.bShouldShowJijiangkaisai = true
							TableConsole.tJijiangkaisaiMatchItem = matchalarmClock[i]
							TableLogic.exitLordTable()
						end
					end
				end
			end
		end
	end

	--检测脚本升级
	CommDialogConfig.checkScriptVersion();
end

--[[--
--牌桌游戏结果逻辑处理
--]]
local function TableGameResultManage()
	Common.log("============解析牌局结果============");
	--持续在牌桌内玩时，需要更新个人信息以便获得房间盘数
	if (profile.User.getSelfUserID() ~= 0) then
		sendDBID_USER_INFO(profile.User.getSelfUserID());
	end
	PauseSocket("readGameResult");

	local GameResult = profile.GameDoc.getGameResultData()

	TableElementLayer.hidePlayerTips(-1)
	isGameResultReady = true;

	profile.Gift.sendFirstGiftIconMsg(2);

	-- 隐藏底牌
	TableCardLayer.hideReservedCards()

	-- 暂时隐藏记牌器
	jipaiqiLogic.hideJipaiqiViewWithoutChangeStatus()

	if ((mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT)) then
		TableCardLayer.removeAllOpenCards();
		isSendOpenCards = false;
	end

	mnWin_Pos = {};
	mnLoss_Pos = {};

	INIT_TIMER_SELF_LOSS = 0;

	AudioManager.stopBgMusic(true);
	-- MatchInstanceID text 比赛实例ID
	-- RoomID Int 房间ID
	local roomId = GameResult["roomId"];
	Common.log("roomId = " .. roomId);
	-- TableID Int 桌号
	local tableId = GameResult["tableId"];
	Common.log("tableId = " .. tableId);
	-- UserCnt Int 用户数目 Loop
	local bSelfWin = false;
	local nPlayerCnt = #GameResult["PlayerList"]
	for i = 1, nPlayerCnt do
		-- …UserID local 用户ID
		local userid = GameResult["PlayerList"][i].userid;
		Common.log("userid = " .. userid);
		-- …SeatID Byte 座位号
		local seatid = GameResult["PlayerList"][i].seatid;
		Common.log("seatid = " .. seatid);
		local p = getPlayer(seatid);
		-- …WinChip local 金币变化 包含任务的倍数计算
		p.m_nWinChip = GameResult["PlayerList"][i].m_nWinChip;
		Common.log("p.m_nWinChip = " .. p.m_nWinChip);

		-- …RemainChip long 剩余金币
		p.m_nChipCnt = GameResult["PlayerList"][i].m_nChipCnt;
		-- 积分变化
		p.m_nWinScoreCnt = GameResult["PlayerList"][i].m_nWinScoreCnt;
		-- 剩余积分
		p.scoreCnt = GameResult["PlayerList"][i].m_nRemainScoreCnt;
		-- 结算类型
		p.accountsType = GameResult["PlayerList"][i].m_nAccountsType;
		-- 手头金币
		p.handCoin = GameResult["PlayerList"][i].m_nHandCoin;
		-- 对手昵称
		p.opponentNickName = GameResult["PlayerList"][i].m_nopponentNickName
		-- 同步金币数
		if (mode == ROOM) then
			p.m_nCoin = p.m_nChipCnt;
		end

		Common.log("p.m_nChipCnt = " .. p.m_nChipCnt);
		-- …RemainCardCnt byte 剩余牌数
		-- ……CardVal byte 牌值


		if (p.m_nSeatID ~= getSelfSeat()) then
			TableCardLayer.addRemainCards(GameResult["RemainCardCnt"][i], p.m_nSeatID)
		end
		-- …VipCoinAddition local 玩家Vip金币加成百分比 普通玩家：100黄金VIP：120
		p.mnVipCoinAddition = GameResult["PlayerList"][i].mnVipCoinAddition;
		Common.log("p.mnVipCoinAddition = " .. p.mnVipCoinAddition);
		-- …doubleScore Int 加倍倍数 是否加倍 -1是还没加倍 ，0不加倍, 2两倍 4 Vip四倍
		p.m_nDoubleScore =  GameResult["PlayerList"][i].m_nDoubleScore;
		Common.log("p.m_nDoubleScore = " .. p.m_nDoubleScore);
		-- 为剩余牌排序

		if (seatid == getSelfSeat()) then
			-- 自己
			local isWin = isPlayerWin(p) -- 自己是否胜利

			profile.User.setSelfCoin(p.m_nChipCnt)

			if isWin == true then
				bSelfWin = true;
				AudioManager.playLordSound(AudioManager.TableSound.WIN, false, AudioManager.SOUND);
			else
				bSelfWin = false;
				AudioManager.playLordSound(AudioManager.TableSound.LOSS, false, AudioManager.SOUND);
			end
			TableElementLayer.newUserLackCoinWarm(bSelfWin,getSelfSeat())
		else
			-- 上下家
			local isWin = isPlayerWin(p) -- 上下家是否胜利

			if isWin == true then
				p:setAnim(GameArmature.ARMATURE_SHENGLI);
			else
				p:setAnim(GameArmature.ARMATURE_SHIBAI);
			end
		end
		p.m_nCallScore = -1;
		p.m_nMasterPlayer = 0;

		TableLogic.updataUserCoin();
	end

	local tempMultiple = 1;
	if (mnTableType == TABLE_TYPE_NORMAL and getPlayer(getSelfSeat()).m_bIsLord) then
		tempMultiple = tempMultiple * 2;
	end
	for i = 1, #GameResult["nMultipleDetail"] do
		-- …multiple Int 倍数
		local multiple = GameResult["nMultipleDetail"][i].multiple;
		tempMultiple = tempMultiple * multiple;
	end
	-- tableCost local 桌费
	setTableCost(GameResult["tableCost"]);
	Common.log("tableCost ===桌费=== " .. tableCost);
	Common.log("tableCost ===桌费===111 " .. GameResult["tableCost"]);
	-- IsSpring Byte 是否春天 0否 1是
	local IsSpring = GameResult["IsSpring"];
	-- RoomMinCoin Int 当前房间金币下限
	mnRoomMinCoin = GameResult["mnRoomMinCoin"];

	setMultiple(tempMultiple);

	--	--判断是否是闯关,是闯关则将是否是地主记录
	--	if getPlayer(getSelfSeat()).m_bIsLord == true then
	--		crazyIsLord = true
	--	else
	--		crazyIsLord = false
	--	end
	--输赢结算
	if (mode == ROOM) then
		for i = 1, nPlayerCnt do
			local nSeat = getPlayerSeatByPos(i - 1);
			local p = getPlayer(nSeat);
			if (p ~= nil) then
				p.m_nWinChip = p.m_nWinChip + tableCost;
				--				Common.log("zbl...winchip = " ..p.m_nWinChip)
				if (p.m_nWinChip > 0) then
					local win = {};
					win.pos = p.m_nPos;
					win.WinChip = p.m_nWinChip;-- 飞金币的数加上桌费
					table.insert(mnWin_Pos, win)
					--					Common.log("zbl...判断1")
				end
				if (p.m_nWinChip < 0) then
					local loss = {};
					loss.pos = p.m_nPos;
					loss.WinChip = p.m_nWinChip;-- 飞金币的数加上桌费
					table.insert(mnLoss_Pos, loss)
					--					Common.log("zbl...判断2")
				end
				--				Common.log("zbl...判断3 ")
			end
		end
	else
		--		Common.log("zbl...判断4")
		mnWin_Pos = {};
		mnLoss_Pos = {};
	end

	if (bSelfWin) then
		if (#mnWin_Pos == 1) then
			-- 作为地主赢
			AudioManager.playLordSound(AudioManager.TableVoice.LORD_WIN, false, getPlayer(getSelfSeat()).mnSex);
		elseif #mnWin_Pos == 2 then
			-- 作为农民赢
			AudioManager.playLordSound(AudioManager.TableVoice.FARMER_WIN, false, getPlayer(getSelfSeat()).mnSex);
		end
	end

	setStatus(STAT_GAME_RESULT);
	local selfIndex = getPlayerIdxBySeat(getSelfSeat())
	GameResultLogic.setGameResultPlayer(m_aPlayer, selfIndex)

	if (IsSpring == 1) then
		--春天动画
		GameArmature.setTableArmature(GameArmature.ARMATURE_TABLE_CHUNTIAN)
	end

	mnReservedCardTimes = 1;
	mbIsShowReservedCard = false;
	TableElementLayer.hideElement()--隐藏闹钟

	local function GameResultNext()
		TableCardLayer.removeAllTableCards()--隐藏牌桌上的牌
		if mode == ROOM then
			--			if isCrazyStage == false then --牌桌分享不包括闯关赛
			--
			--			end
			--房间飞金币
			if isCrazyStage == false then --牌桌分享不包括闯关赛
				Common.log("isCrazyStage is false")
				--				CommShareConfig.showPackTableSharePanel(bSelfWin, tempMultiple)
				roomIsWin = bSelfWin
				roomMultiple = tempMultiple
			else
				CommShareConfig.isCrazyShareEnabled = true
				TableLogic.button_gift:setVisible(false)
				TableLogic.button_gift:setTouchEnabled(false)
				TableLogic.iv_light:setVisible(false)
				TableLogic.iv_light:setTouchEnabled(false)
			end

			TableCardLayer.flyCoin()
			TableElementLayer.showGameResultData();
		else
			--比赛出结果
			local delay = CCDelayTime:create(3)
			local array = CCArray:create()
			array:addObject(delay)
			array:addObject(CCCallFuncN:create(GameResultAfterMsg))
			local seq = CCSequence:create(array)
			TableLogic.view:runAction(seq)
		end
	end

	--显示最后一套牌
	local delay = CCDelayTime:create(2)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(GameResultNext))
	local seq = CCSequence:create(array)
	TableLogic.view:runAction(seq)

	if bShouldExitCurrentMatch == true then
		-- 退出当前比赛
		bShouldExitCurrentMatch = false
		TableLogic.exitLordTable()
	end
end

--[[--
--获取宝盒进度
--]]
local function TableBaoHeGetPro()
	local Pro = profile.TreasureChests.getTreasureChestsPro()
	--RoomLevel	Byte	房间等级	0,1,2,3
	RoomLevel = Pro["RoomLevel"];
	-- Progress Short 已完成局数
	baohePro = Pro["Progress"];
	-- Max Short 总局数
	baoheMax = Pro["Max"];
	--未完成新手引导、完成一局打牌,已经预先展示宝盒了
	if CommDialogConfig.getNewUserGiudeFinish() == false  and NewUserGuideLogic.newUserEndBoard then
		return;
	end
	if (mode == ROOM and (mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT)) then
		TableElementLayer.UpdataBaoXiangData();
	end

end

--新手引导
function showNewUserGuide()
	--发送第二个新手引导请求奖励
	Common.showProgressDialog("数据加载中...")
	if 	profile.NewUserGuide.getisNewUserGuideisEnable()== true then
		sendCOMMONS_GET_NEWUSERGUIDE_AWARD(2);
	end
end

--[[--
--获取宝箱列表
--]]
local function TableBaoHeGetList()
	if (mode == ROOM and (mnTableType == TABLE_TYPE_HAPPY or mnTableType == TABLE_TYPE_OMNIPOTENT)) then
		mvcEngine.createModule(GUI_TREASURE_CHESTS);
		TreasureChestsLogic.updataPrizeListData();
	end
end

--[[--
--获取宝盒奖励
--]]
local function TableBaoHeGetTreasure()
	local Prize = profile.TreasureChests.getTreasureChestsPrize()
	--Result  1 成功 0 失败
	if (Prize["Result"] == 0) then
		TableElementLayer.UpdataBaoXiangData()
		Common.showToast(Prize["ResultMsg"], 2)
		return;
	end
	if not TreasureChestsLogic.isShowView then
		for i = 1, #Prize["TreasurePrizeList"] do
			--…TreasurePicUrl  物品图片url
			local PicUrl = Prize["TreasurePrizeList"][i].TreasurePicUrl;
			Common.log("TableTreasureData---物品图片url = ".. PicUrl)
			--…TreasureDiscription  物品描述
			local Discription = Prize["TreasurePrizeList"][i].TreasureDiscription;
			Common.log("TableTreasureData---物品描述 = ".. Discription)
			--…Multiple  奖品倍数
			local Multiple = Prize["TreasurePrizeList"][i].Multiple;
			Common.log("TableTreasureData---奖品倍数 = ".. Multiple)
			--…lastTreasureCount  最终奖品数目
			local Count = Prize["TreasurePrizeList"][i].lastTreasureCount;
			Common.log("TableTreasureData---最终奖品数目 = ".. Count)
			if Multiple > 0 then
				ImageToast.createView(PicUrl, nil, Discription, "恭喜您获取" .. Multiple .. "倍宝盒奖励", 2)
			else
				ImageToast.createView(PicUrl, nil, Discription, "恭喜您获取宝盒奖励", 2)
			end
			if i == 1 then
				ImageToast.OverFunction = showNewUserGuide;
			end
		end
	end

	--Progress  已完成局数
	baohePro = Prize["Progress"]
	Common.log("已完成局数 = " .. Prize["Progress"])
	--Max  总局数
	baoheMax = Prize["Max"]
	Common.log("总局数 = " .. Prize["Max"])
	TableElementLayer.UpdataBaoXiangData()
	sendDBID_BACKPACK_LIST()--背包

end

--[[--
--比赛阶段改变
--]]
local function readStatusChanged()
	local StatusChanged = profile.GameDoc.getStatusChanged()
	Common.log("比赛阶段改变 ================= ")
	m_nNotEndedCnt = 0;
	sendTableNotEnded();
	m_bSendTableNotEnded = true;
end

--[[--
--请求当前未结束的牌桌数
--]]
function sendTableNotEnded()
	if (mode == ROOM) then
		return;
	end
	sendMatchTableNotEnded()
end

--[[--
--3.03显示牌桌等待界面
strTipString:提示文字
--]]
function showTableNotEndedView_V4(strTipString)
	if TableNotEndedLogic.isShow() then
		Common.log("isShow = true")
		TableNotEndedLogic.stringTips = strTipString
		TableNotEndedLogic.update()
	else
		Common.log("isShow = false")
		mvcEngine.createModule(GUI_TABLE_NOT_ENDED)
		TableNotEndedLogic.stringTips = strTipString
		TableNotEndedLogic.update()
	end
end

--[[--
--关闭牌桌等待界面
--]]
function hideTableNotEndedView()
	if TableNotEndedLogic.isShow() or TableNotEndedLogic.view ~= nil then
		TableNotEndedLogic.CloseView()
	end
end

--[[--
--请求等待分桌
--]]
function updateWaitingDialog()
	sendMATID_V4_WAITING(m_sMatchInstanceID)
end

--[[--
--3.03当前未结束的牌桌数(比赛等待分桌V4)
--]]
local function readTableNotEnded_V4()
	if bMatchIsOvered == true then
		-- 如果比赛已经结束，弹出了奖状，则不处理该消息
		Common.log("如果比赛已经结束，弹出了奖状，则不处理该消息")
		return
	end

	if isPlayingDoudizhu() then
		-- 如果比赛没有结束，不处理等待分桌消息
		Common.log("如果比赛没有结束，不处理该消息")
		return
	end

	if MatchRechargeCoin.bIsRechargeWaiting == true then
		-- 如果是在充值等待区，不处理等待分桌消息
		Common.log("如果是在充值等待区，不处理等待分桌消息")
		return
	end

	local TableNotEnded = profile.GameDoc.getTableNotEnded()
	if TableNotEnded["TipString"] == "" then
		-- 等待分桌，返回空字符串时，直接返回
		return
	end

	-- 设置倍数为0
	TableLogic.updataTableMultiple(0, false)
	-- 设置底金为0
	TableLogic.updataTableBaseChip(0)

	-- 比赛等待分桌UI
	showTableNotEndedView_V4(TableNotEnded["TipString"])

	-- 每5秒请求一次等待分桌, 刷新提示语
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(5))
	array:addObject(CCCallFuncN:create(updateWaitingDialog))
	seq = CCSequence:create(array)
	CCDirector:sharedDirector():getRunningScene():runAction(seq)
end

--[[--
--比赛奖状V4
--]]
local function readMatchCertificate_V4()
	--关闭等待分桌弹框
	hideTableNotEndedView()
	--	HallLogic.setMatchIDAndTitle(m_nMatchID , msMatchTitle)
	AudioManager.stopBgMusic(true);
	m_bSendTableNotEnded = false;
	bMatchIsOvered = true;
	bHallShouldShowCertificateAlert = false

	local matchCertificate = profile.GameDoc.getMatchCertificate()

	if tonumber(matchCertificate["MatchStatusLevel"]) == 3 then
		-- 决赛阶段
		if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
			-- 牌桌中
			-- 则先返回比赛列表，再弹出奖状
			bHallShouldShowCertificateAlert = true

			TableLogic.exitLordTable()
			return
		end
	end

	--	CertificateLogic.setMatchIDAndTitle(m_nMatchID,msMatchTitle)
	mvcEngine.createModule(GUI_TABLE_CERTIFICATEVIEW)
	CertificateLogic.updataCertificate_V4(matchCertificate)
end

LadderChangeDuan = 0--段改变情况0 不变，1升级，-1降级
LadderChangeRank = 0--等级改变情况 0 不变，1升级，-1降级

--[[--
--判断天梯升级情况
--]]
function logicLadderUp()
	if NewUserGuideLogic.getNewUserFlag() then
		return;
	end
	if LadderChangeRank == 1 then
		if LadderChangeDuan == 1 then
			sendDBID_BACKPACK_LIST()--背包
			GameArmature.showTiantiShengDuanAnim()
			AudioManager.playLordSound(AudioManager.TableSound.TT_DUAN_UP, false, AudioManager.SOUND);
		end
		if profile.User.getSelfLadderLevel() == 5 or profile.User.getSelfLadderLevel() == 10 then
			--升级有奖励
			if CrazyResultLogic.isShow == false and CrazyBuyStoneLogic.isShow == false then
				TableElementLayer.showTTUpJiangLi();
			end
			sendDBID_BACKPACK_LIST()--背包
			--GameArmature.showTiantiAnim("lingqujiangli");
			--TableElementLayer.setTableResultAlpha(0);
		else
			--升级无奖励
			GameArmature.showTiantiAnim("tiantishengji")
			TableElementLayer.setTableResultAlpha(0)
			if mode == ROOM and not BindPhoneConfig.isShowBindPhone then
				CommShareConfig.showPackTableSharePanel(roomIsWin, roomMultiple)
				roomIsWin = false
				roomMultiple = 0
			end
		end
	elseif LadderChangeRank == -1 or LadderChangeRank == 255 then
		--降级
		GameArmature.showTiantiAnim("tiantijiangji")
		TableElementLayer.setTableResultAlpha(0)
	elseif LadderChangeRank == 0 then
		--不升不降
		--无法升级
		if profile.User.getSelfLadderUpScore() <= profile.User.getSelfLadderScore() then
			--TableElementLayer.setWuFaShengDuanVisible(true);
			GameArmature.showTiantiAnim("wufashengduan")
			TableElementLayer.setTableResultAlpha(0)
		end
		if mode == ROOM and not BindPhoneConfig.isShowBindPhone then
			CommShareConfig.showPackTableSharePanel(roomIsWin, roomMultiple)
			roomIsWin = false
			roomMultiple = 0
		end
	end
end

--[[--
--天梯游戏结束信息
--]]
local function TableLadderGameOver()
	local LadderGameOver = profile.TianTiData.getTTGameOverData()
	Common.log("天梯游戏结束信息  ==================== ")
	-- changeDuan byte 段改变情况 0 不变，1升级，-1降级
	LadderChangeDuan = LadderGameOver["changeDuan"]
	-- duan int 段位
	profile.User.setSelfLadderDuan(LadderGameOver["duan"])
	-- changeRank int 等级改变情况 0 不变，1升级，-1降级
	LadderChangeRank = LadderGameOver["changeRank"]
	Common.log("LadderChangeRank ========== "..LadderChangeRank)
	-- rank int 等级
	profile.User.setSelfLadderLevel(LadderGameOver["rank"])
	-- score int 当前天梯分
	profile.User.setSelfLadderScore(LadderGameOver["score"])
	-- nextScore int 下一等级的天梯分(升级积分)
	profile.User.setSelfLadderUpScore(LadderGameOver["nextScore"])
	-- InitScore	int	当前段初始天梯分(降级积分)
	profile.User.setSelfLadderDownScore(LadderGameOver["InitScore"])
end

--聊天应答
local function TableChatMsg()
	local chatMsg = profile.GameDoc.getLORDID_CHAT_MSG()

	-- FromUserID int 发言者UID
	local FromUserID = chatMsg["FromUserID"];
	-- ToUserID int 互动类聊天的目标玩家UID 非互动类写0
	local ToUserID = chatMsg["ToUserID"]
	-- ChatType byte 1文字2表情3互动3高级
	local ChatType = chatMsg["ChatType"]
	-- ChatContent text 聊天语内容 服务器仅仅做转发，不理解其内容
	local ChatContent = chatMsg["ChatContent"]
	-- CostCoin int 花费的金币数
	local CostCoin = chatMsg["CostCoin"]

	if chatMsg["ChatType"] == 0 then
		Common.showToast(chatMsg["ChatContent"], 2)
		return
	end

	local user = getPlayerPosByUserID(FromUserID);
	if user == nil then
		return;
	end

	local curPos = user.m_nPos; --012
	local sex = user.mnSex;

	if tonumber(ChatType) == TYPE_CHAT_TEXT then
		--文本
		local musicname = TableElementLayer.checkChatMusic(ChatContent)
		if musicname ~= "" and musicname ~= nil then
			AudioManager.playLordSound(musicname, false, sex)
		end
		TableElementLayer.showChatText(curPos, ChatContent)
	elseif tonumber(ChatType) == TYPE_CHAT_FACE then
		--普通表情
		TableElementLayer.playChatCommonEmotion(curPos, ChatContent)
	elseif tonumber(ChatType) == TYPE_CHAT_INTERACT then
	--互动表情
	elseif tonumber(ChatType) == TYPE_CHAT_FACE_SUPERIOR then
		--高级表情
		TableElementLayer.playChatSuperiorEmotion(curPos, ChatContent)
	end
end

--[[--
--同步手牌
--]]
local function TableSyncHandCards()
	local SyncHandCards = profile.GameDoc.getSyncHandCards()
	TableCardLayer.removeAllHandCards();
	TableCardLayer.addHandCard(SyncHandCards["CardVal"], true);
	TableCardLayer.refreshHandCards();
	local selfSeat = getSelfSeat()
	Common.log("TableSyncHandCards selfSeat = "..selfSeat)
	local selfPlayer = getPlayer(selfSeat)
	if selfPlayer ~= nil then
		if selfPlayer.m_bTrustPlay then
			TableCardLayer.setAllHandCardsMarked(true)
		end
	end
end

--[[--
-- 踢人之后的数据处理
--]]
function afterKickOutPlayer()
	removePlayer(m_aPlayer[position].m_nSeatID);
	isAfterKickWait = true;
	setStatus(STAT_WAITING_TABLE);
end

--[[--
-- 重置闯关赛变量
--]]--
function resetCrazy()
	isCrazyStage = false --是否是疯狂闯关
	canPlayCrazy = false --是否可以闯关
	stoneRechargeId = nil --购买复活石的引导ID
end

--[[--
-- 验证闯关赛是否可进行
--]]--
function crazyValidate()
	sendOPERID_CRAZY_STAGE_VALIDATE()
end

--[[--
--主动踢人消息接收,成功则提示
--]]
local function readKickOutPlayer()

	if removePlayerTable["" .. position] ~= nil and removePlayerTable["" .. position] == true then
		kickPlayerTable = {}
		removePlayerTable = {}
		return
	end
	kickPlayerTable["" .. position] = true

	if profile.TableKick.getKickResult() == true then
		if m_aPlayer[position] ~= nil then
			m_bReadTableChanged = true
			TableLogic.hideKickButton(m_aPlayer[position].m_nPos)
			m_aPlayer[position]:setAnim(GameArmature.ARMATURE_NONGMIN_TIREN)
		else
			Common.showToast("玩家已离开房间",2)
		end
	elseif profile.TableKick.getKickResult() == false then
		if m_aPlayer[position] ~= nil then
			Common.showToast("踢人失败",2)
		else
			Common.showToast("玩家已离开房间",2)
		end
	end
end

--[[--
--被踢消息接收,跳入大厅页面并且弹出被踢提示框
--]]
local function readBeKickOut()
	mvcEngine.createModule(GUI_HALL)
end

local function readMatchRankSync_V4()
	local rankSyncTable = profile.GameDoc.getMatchRankSync()
	TableLogic.updateRankSync(rankSyncTable)
end

--[[--
--充值等待区数据
--]]
local function readMATID_V4_RECHARGE_WAITING_V4()
	Common.log("readMATID_V4_RECHARGE_WAITING_V4")
	if MatchRechargeCoin.bIsRechargeWaiting == true then
		-- 当前已经是在充值等待区，直接返回
		Common.log("当前已经是在充值等待区，直接返回")
		return
	end

	-- 比赛充值等待遮罩
	TableElementLayer.addRechargeWaitingOverlay()

	local tRechargeWaiting = profile.GameDoc.getMatchChargeWaiting()
	MatchRechargeCoin.tRecharge = tRechargeWaiting
	MatchRechargeCoin.rechargeStart()

end

--[[--
--比赛小提示V4
--]]
local function readMATID_V4_TIPS()
	Common.log("readMATID_V4_TIPS")
	local tableMatchTips = profile.GameDoc.getMatchTipsTable()
	if TableNotEndedLogic.view == nil then
		mvcEngine.createModule(GUI_TABLE_NOT_ENDED)
		TableNotEndedLogic.updateTips(tableMatchTips.tipIndex, tableMatchTips.TipText)
	else
		TableNotEndedLogic.updateTips(tableMatchTips.tipIndex, tableMatchTips.TipText)
	end
end

--[[--
--购买结果消息接收,购买复活石并复活
--]]
local function readRechargeResult()
	Common.log("readRechargeResult")
	local rechargeResultTable = profile.RechargeResult.getRechargeResultTable()
	Common.log("readRechargeResult rechargeID is " .. rechargeResultTable["rechargeID"])
	if rechargeResultTable ~= nil then
		if rechargeResultTable["rechargeID"] ~= nil and rechargeResultTable["rechargeID"] ~= "" then
			if stoneRechargeId ~= nil and stoneRechargeId == rechargeResultTable["rechargeID"] then
				--发送复活消息
				Common.showProgressDialog("数据加载中...")
				if CrazyBuyStoneLogic.isShow == true then
					mvcEngine.destroyModule(GUI_CRAZY_BUY_STONE)
				end
				sendOPERID_CRAZY_STAGE_RELIVE()
			end
		end
	end
end

local CRAZY_RELIVE_SUCCESS = 1;--复活成功
local CRAZY_RELIVE_FAIL = 0;--复活失败

--[[--
--闯关复活消息接收,复活是否成功
--]]
local function readReliveResult()
	Common.closeProgressDialog()
	Common.log("readReliveResult")
	local reliveResultTable = profile.CrazyStage.getCrazyStageRelive()
	if reliveResultTable ~= nil then
		if reliveResultTable["ReliveSuccess"] ~= nil then
			if reliveResultTable["ReliveSuccess"] == CRAZY_RELIVE_SUCCESS then
				--可以继续闯关
				canPlayCrazy = true
				TableLogic.changeGameStartButton(true)--显示开始按钮
				Common.showToast("复活成功！您可以继续闯关了，加油！",2)
			else
				--提示复活失败
				Common.showToast(reliveResultTable["Message"],2)
			end
		end
	end
end

local CRAZY_RESULT_FAIL = 0;--闯关失败
local CRAZY_RESULT_SUCCESS = 1;--闯关成功
local CRAZY_RESULT_RELIVE_LIMITED = 2;--闯关失败且复活达到上限
local CRAZY_RESULT_FAIL_AND_PERSENT = 3;--闯关失败且获得复活石奖励

--[[--
--闯关结果消息接收,成功与否,弹框的弹出选择
--]]
local function readCrazyResult()
	Common.log("readCrazyResult")
	--判断是否是闯关,是闯关则将是否是地主记录
	if getPlayer(getSelfSeat()).m_bIsLord == true then
		crazyIsLord = true
	else
		crazyIsLord = false
	end
	local crazyResultTable = profile.CrazyStage.getCrazyStageResult()
	if crazyResultTable ~= nil then
		local currentLevel = crazyResultTable.CurrentLevel
		ChuangGuanLogic.setBeforeLevel(currentLevel)
		if crazyResultTable["Success"] ~= nil then
			if crazyResultTable["Success"] == CRAZY_RESULT_SUCCESS then
				--闯关成功
				canPlayCrazy = true
				CrazyResultLogic.setValue(true,true,crazyIsLord,crazyResultTable["ReliveStoneNumber"],crazyResultTable["NeedReliveStone"],crazyResultTable["CurrentLevel"],false,crazyResultTable["Message"])
				CrazyResultLogic.canBeShow = true
				local function showResult()
					if HallGiftShowLogic.isShow == false then
						mvcEngine.createModule(GUI_CRAZY_RESULT)
					end
				end
				local delay = CCDelayTime:create(3)
				local array = CCArray:create()
				array:addObject(delay)
				array:addObject(CCCallFuncN:create(showResult))
				local seq = CCSequence:create(array)
				TableLogic.view:runAction(seq)
				--				CommShareConfig.showCrazySharePanel(currentLevel)
			elseif crazyResultTable["Success"] == CRAZY_RESULT_RELIVE_LIMITED then
				CrazyResultLogic.setValue(true,false,crazyIsLord,crazyResultTable["ReliveStoneNumber"],crazyResultTable["NeedReliveStone"],crazyResultTable["CurrentLevel"],true,crazyResultTable["Message"])
				CrazyResultLogic.canBeShow = true
				local function showResult()
					if HallGiftShowLogic.isShow == false then
						mvcEngine.createModule(GUI_CRAZY_RESULT)
					end
				end
				local delay = CCDelayTime:create(3)
				local array = CCArray:create()
				array:addObject(delay)
				array:addObject(CCCallFuncN:create(showResult))
				local seq = CCSequence:create(array)
				TableLogic.view:runAction(seq)
			else
				--闯关失败
				if crazyResultTable.CurrentLevel ~= 1 then
					canPlayCrazy = false
				end
				if crazyResultTable["ReliveStoneNumber"] >= crazyResultTable["NeedReliveStone"] then
					CrazyResultLogic.setValue(true,false,crazyIsLord,crazyResultTable["ReliveStoneNumber"],crazyResultTable["NeedReliveStone"],currentLevel,false,crazyResultTable["Message"])
					CrazyResultLogic.canBeShow = true
					if HallGiftShowLogic.isShow == false then
						mvcEngine.createModule(GUI_CRAZY_RESULT)
					end
				else
					CrazyBuyStoneLogic.setValue(true,crazyIsLord,crazyResultTable["ReliveStoneNumber"],crazyResultTable["NeedReliveStone"],crazyResultTable["ReliveRecharge"],crazyResultTable["ReliveRechargePrice"],crazyResultTable["ReliveRechargeNum"])
					CrazyBuyStoneLogic.canBeShow = true
					if CrazyBuyStoneLogic.isShow == false then
						mvcEngine.createModule(GUI_CRAZY_BUY_STONE)
					end
				end
				--获得赠送的复活石时,弹出获奖动画
				if crazyResultTable["Success"] == CRAZY_RESULT_FAIL_AND_PERSENT then
					ImageToast.createView(nil,Common.getResourcePath("ic_chuangguan_fuhuoshi.png"),"复活石x3","获得奖励成功",2)
				end
			end
		end
	end
	TableLogic.button_gift:setVisible(true)
	TableLogic.button_gift:setTouchEnabled(true)
	TableLogic.iv_light:setVisible(true)
	TableLogic.iv_light:setTouchEnabled(true)
end

local VALIDATE_SUCCESS = 1 --可以闯关
local VALIDATE_NEED_COIN = 2 --金币不足
local VALIDATE_NEED_RELIVE = 3 --需要复活
local VALIDATE_NEED_RECHIVE = 4 --需要领奖
local VALIDATE_MAX_MISSION = 5 --已经达到最大关数
local VALIDATE_MAX_RELIVE = 6 --已经达到复活最大数
VALIDATE_BEGIN_MODE = 0
local function readCrazyValidate()
	local validateTable = profile.CrazyStage.getCrazyStageValidateTable()
	if validateTable.Status ~= nil then
		if validateTable.Status == VALIDATE_SUCCESS then
			if mode == ROOM then
				--隐藏踢人按钮
				TableLogic.changeKickButton(false);
			end
			TableConsole.sendContinue(VALIDATE_BEGIN_MODE);
			TableLogic.hideGameBtn()
		elseif validateTable.Status == VALIDATE_NEED_COIN then
			-- 显示引导
			local isShowQuickPay = false;
			local differenceCoin = 0;
			if validateTable.Amount == nil or validateTable.Amount == 0 then
				validateTable.Amount = 4000
			end
			if validateTable.Message == nil or validateTable.Message == "" then
				validateTable.Message = "【疯狂闯关】最少需要4000金币才能进入"
			end
			differenceCoin = (validateTable.Amount - profile.User.getSelfCoin());
			Common.log("differenceCoin ======= " .. differenceCoin);
			if (differenceCoin > 0) then
				isShowQuickPay = true;
			end
			if (isShowQuickPay) then
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, differenceCoin, RechargeGuidePositionID.ReliveStoneB)
				Common.showToast(validateTable.Message, 2)
			end
		else
			resetCrazy()
			Common.showToast(validateTable.Message, 2)
			mvcEngine.createModule(GUI_CHUANGGUAN)
		end
	end
end

--[[
判断一个玩家在一句牌局后的输赢
player:玩家
]]
function isPlayerWin(player)
	if TableConsole.mode == TableConsole.ROOM then
		if player.m_nWinChip > 0 then
			return true
		end
	else
		if player.m_nWinScoreCnt > 0 then
			return true
		end
	end

	return false
end


--[[--
--执行加倍操作  Version: 3.15
--num :操作数   0:不加倍  2:加倍  4：超级加倍
--]]--
function CarryOutDoubleOperation(num)
	--	if getPlayer(getSelfSeat()).m_nCanDoubleMax ~= 0 then
	--不能加倍
	local lackCoinText = nil
	local choseSelforOtherText = nil  --选择自己或者别人的text
	local choseCommonOrSuperText = nil  --选择加倍或者超级加倍的text
	if getPlayer(getSelfSeat()).m_nNoDoubleReason == 0 then
		-- 0 :别人金币不足  1:自己金币不足
		choseSelforOtherText = "对方金币不足"
	else
		choseSelforOtherText = "自己金币不足"
	end
	if num == 2 then
		--加倍
		choseCommonOrSuperText = getPlayer(getSelfSeat()).m_nCommonMinCoins .. ",无法加倍"
	else
		--超级加倍
		choseCommonOrSuperText = getPlayer(getSelfSeat()).m_nMinSuperCoins .. ",无法超级加倍"
	end
	lackCoinText = choseSelforOtherText .. choseCommonOrSuperText;
	Common.showToast(lackCoinText,2)
	--	end
end

--[[--
--自己是地主，抢完地主立即设置加倍
--]]--
function setLandLordDouble()
	if getPlayer(getSelfSeat()).m_bIsLord == true then
		--如果自己是地主
		setMultiple(m_nMultiple * 2);
	end
end



--牌桌相关的公共消息
framework.addSlot2Signal(ROOMID_QUICK_START, QuickStartManage)
framework.addSlot2Signal(ROOMID_ENTER_ROOM, EnterRoomManage)
framework.addSlot2Signal(GAMEID_TABLE_CHANGED, TableChangedManage)
framework.addSlot2Signal(GAMEID_TABLE_SYNC, TableSyncManage)

--[[--
--添加牌桌内消息监听
--]]
function addSignal()
	--牌桌公共
	framework.addSlot2Signal(DBID_USER_INFO, TableElementLayer.updataUserInfo)
	framework.addSlot2Signal(BASEID_GET_BASEINFO, TableElementLayer.updataUserInfo)
	--牌桌独有
	framework.addSlot2Signal(BAOHE_V4_GET_PRO, TableBaoHeGetPro)
	framework.addSlot2Signal(BAOHE_V4_GET_LIST, TableBaoHeGetList)
	framework.addSlot2Signal(BAOHE_V4_GET_PRIZE, TableBaoHeGetTreasure)
	framework.addSlot2Signal(ROOMID_QUIT_ROOM, QuitRoomManage)
	framework.addSlot2Signal(DDZID_READY, TableReadyManage)
	framework.addSlot2Signal(DDZID_INITCARD, TableInitCardManage)
	framework.addSlot2Signal(DDZID_CALLSCORE, TableCallScoreManage)
	framework.addSlot2Signal(DDZID_SENDRESERVECARD, TableReserveCardManage)
	framework.addSlot2Signal(DDZID_TAKEOUTCARD, TableTakeOutCardManage)
	framework.addSlot2Signal(MATID_TRUST_PLAY, TableTrustPlayManage)
	framework.addSlot2Signal(LORDID_GRAB_LANDLORD, TableGrabLandlordManage)
	framework.addSlot2Signal(LORDID_DOUBLE_SCORE, TableDoubleScoreManage)
	framework.addSlot2Signal(LORDID_OPEN_CARDS, TableOpenCardsManage)
	framework.addSlot2Signal(LORDID_START_DOUBLE, TableStartDoubleManage)
	framework.addSlot2Signal(GAMEID_GAMERESULT, TableGameResultManage)
	framework.addSlot2Signal(LADDER_GAME_OVER, TableLadderGameOver)
	framework.addSlot2Signal(LORDID_CHAT_MSG, TableChatMsg)
	framework.addSlot2Signal(LORDID_SYNC_HAND_CARDS, TableSyncHandCards)
	framework.addSlot2Signal(ROOMID_KICK_OUT_PLAYER, readKickOutPlayer)
	framework.addSlot2Signal(ROOMID_PLAYER_BE_KICKED_OUT, readBeKickOut)
	-- 3.03 牌桌新消息
	framework.addSlot2Signal(MATID_V4_WAITING, readTableNotEnded_V4)
	framework.addSlot2Signal(MATID_V4_PROMPT_SYNC, readMatchRankSync_V4)
	framework.addSlot2Signal(MATID_V4_CERTIFICATE, readMatchCertificate_V4)
	framework.addSlot2Signal(MATID_V4_RECHARGE_WAITING, readMATID_V4_RECHARGE_WAITING_V4)
	framework.addSlot2Signal(MATID_V4_TIPS, readMATID_V4_TIPS)


	framework.addSlot2Signal(DBID_RECHARGE_RESULT_NOTIFICATION, readRechargeResult)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_RELIVE, readReliveResult)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_RESULT, readCrazyResult)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_VALIDATE, readCrazyValidate)


	framework.addSlot2Signal(MSG_IDLE, TableLogic.updateNetworkStatus) --接收心跳消息
	framework.addSlot2Signal(DBID_BACKPACK_LIST, TableLogic.updateJipaiqiYouxiaoqi)
end

--[[--
--删除牌桌内消息监听
--]]
function removeSignal()
	--牌桌公共
	framework.removeSlotFromSignal(DBID_USER_INFO, TableElementLayer.updataUserInfo)
	framework.removeSlotFromSignal(BASEID_GET_BASEINFO, TableElementLayer.updataUserInfo)
	--牌桌独有
	framework.removeSlotFromSignal(BAOHE_V4_GET_PRO, TableBaoHeGetPro)
	framework.removeSlotFromSignal(BAOHE_V4_GET_LIST, TableBaoHeGetList)
	framework.removeSlotFromSignal(BAOHE_V4_GET_PRIZE, TableBaoHeGetTreasure)
	framework.removeSlotFromSignal(ROOMID_QUIT_ROOM, QuitRoomManage)
	framework.removeSlotFromSignal(DDZID_READY, TableReadyManage)
	framework.removeSlotFromSignal(DDZID_INITCARD, TableInitCardManage)
	framework.removeSlotFromSignal(DDZID_CALLSCORE, TableCallScoreManage)
	framework.removeSlotFromSignal(DDZID_SENDRESERVECARD, TableReserveCardManage)
	framework.removeSlotFromSignal(DDZID_TAKEOUTCARD, TableTakeOutCardManage)
	framework.removeSlotFromSignal(MATID_TRUST_PLAY, TableTrustPlayManage)
	framework.removeSlotFromSignal(LORDID_GRAB_LANDLORD, TableGrabLandlordManage)
	framework.removeSlotFromSignal(LORDID_DOUBLE_SCORE, TableDoubleScoreManage)
	framework.removeSlotFromSignal(LORDID_OPEN_CARDS, TableOpenCardsManage)
	framework.removeSlotFromSignal(LORDID_START_DOUBLE, TableStartDoubleManage)
	framework.removeSlotFromSignal(GAMEID_GAMERESULT, TableGameResultManage)
	framework.removeSlotFromSignal(LADDER_GAME_OVER, TableLadderGameOver)
	framework.removeSlotFromSignal(LORDID_CHAT_MSG, TableChatMsg)
	framework.removeSlotFromSignal(LORDID_SYNC_HAND_CARDS, TableSyncHandCards)
	framework.removeSlotFromSignal(ROOMID_KICK_OUT_PLAYER, readKickOutPlayer)
	framework.removeSlotFromSignal(ROOMID_PLAYER_BE_KICKED_OUT, readBeKickOut)
	-- 3.03 牌桌新消息
	framework.removeSlotFromSignal(MATID_V4_WAITING, readTableNotEnded_V4)
	framework.removeSlotFromSignal(MATID_V4_PROMPT_SYNC, readMatchRankSync_V4)
	framework.removeSlotFromSignal(MATID_V4_CERTIFICATE, readMatchCertificate_V4)
	framework.removeSlotFromSignal(MATID_V4_RECHARGE_WAITING, readMATID_V4_RECHARGE_WAITING_V4)
	framework.removeSlotFromSignal(MATID_V4_TIPS, readMATID_V4_TIPS)

	framework.removeSlotFromSignal(DBID_RECHARGE_RESULT_NOTIFICATION, readRechargeResult)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_RELIVE, readReliveResult)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_RESULT, readCrazyResult)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_VALIDATE, readCrazyValidate)

	framework.removeSlotFromSignal(MSG_IDLE, TableLogic.updateNetworkStatus)
	framework.removeSlotFromSignal(DBID_BACKPACK_LIST, TableLogic.updateJipaiqiYouxiaoqi)
end