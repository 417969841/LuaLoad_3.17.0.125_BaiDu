------------------------------------------------------------------
--[[------------------------斗地主心跳消息----------------------- ]]
------------------------------------------------------------------

function read80000000(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = MSG_IDLE
	dataTable["messageName"] = "MSG_IDLE"
	return dataTable
end

------------------------------------------------------------------
--[[------------------------斗地主本地重连消息----------------------- ]]
------------------------------------------------------------------

function read3e9(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = NETERR_CONN_FAILED
	dataTable["messageName"] = "NETERR_CONN_FAILED"
	return dataTable
end

function read3ea(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = NETERR_NET_BROKEN
	dataTable["messageName"] = "NETERR_NET_BROKEN"
	return dataTable
end

function read3eb(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = NETERR_CONN_SUCC
	dataTable["messageName"] = "NETERR_CONN_SUCC"
	return dataTable
end

--切出游戏
function read3ed(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = GAME_ENTER_BACKGROUND
	dataTable["messageName"] = "GAME_ENTER_BACKGROUND"
	return dataTable
end

--进入游戏
function read3ee(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = GAME_ENTER_FOREGROUND
	dataTable["messageName"] = "GAME_ENTER_FOREGROUND"
	return dataTable
end

------------------------------------------------------------------
--[[-----------------------游戏GAME_ID 消息----------------------]]
------------------------------------------------------------------

--[[--
* 收到牌桌改变事件
*
* @param helper
--]]
function read40001(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = REQ + GAMEID_TABLE_CHANGED
	dataTable["messageName"] = "GAMEID_TABLE_CHANGED"
	--Mode	byte	比赛1 房间2
	dataTable["mode"] = nMBaseMessage:readByte();
	--Common.log("dataTable[mode] == "..dataTable["mode"])
	--MatchInstanceID	text	比赛实例ID
	dataTable["m_sMatchInstanceID"] = nMBaseMessage:readString();
	--RoomID	int	房间
	dataTable["nRoomID"] = nMBaseMessage:readInt();
	--Common.log("read40001 nRoomID = "..dataTable["nRoomID"])
	--
	dataTable["nTableID"] = nMBaseMessage:readInt();
	--Common.log("read40001 nTableID = "..dataTable["nTableID"])

	if (nTableID ~= -1 and nTableID ~= 65535) then
		--SeatID	byte	桌号(-1为等候区)
		dataTable["nSeatID1"] = nMBaseMessage:readByte();
		--Common.log("read40001 nSeatID1 = "..dataTable["nSeatID1"])
		--InitTimer	short	初始倒计时值
		dataTable["nInitTimerVal"] = nMBaseMessage:readShort();
		--InitChip	Long	初始筹码
		dataTable["nInitHoleChip"] = nMBaseMessage:readLong();
		--TreasureLockDuration	short	宝箱锁定时长	单位：秒
		dataTable["m_nTreasureLockDuration"] = nMBaseMessage:readShort();
		if (dataTable["m_nTreasureLockDuration"] == 65535) then
			dataTable["m_nTreasureLockDuration"] = -1;
		end
		--IsAllRobot	Byte	是否全为机器人 	1是0否
		dataTable["nIsAllRobot"] = nMBaseMessage:readByte();
		dataTable["UserList"] = {}
		--UserCnt	byte	同桌人数
		dataTable["UserCnt"] = nMBaseMessage:readInt()
		--Common.log("同桌人数 = " .. dataTable["UserCnt"])
		for i = 1, dataTable["UserCnt"] do
			dataTable["UserList"][i] = {}
			local length = nMBaseMessage:readShort()
			local pos = nMBaseMessage:getReadPos()
			--Common.log("UserList---length = " .. length)
			--			...UserID	Int	用户ID
			dataTable["UserList"][i].nUserID = nMBaseMessage:readInt();
			--Common.log("nUserID = " .. dataTable["UserList"][i].nUserID)
			--...SeatID	byte	座位号
			dataTable["UserList"][i].nSeatID = nMBaseMessage:readByte();
			--Common.log("nSeatID = " .. dataTable["UserList"][i].nSeatID)
			--...NickName	text	昵称
			dataTable["UserList"][i].m_sNickName = nMBaseMessage:readString();
			--...PhotoUrl	Text	头像Url
			dataTable["UserList"][i].m_sPhotoUrl = nMBaseMessage:readString();
			--...ChipCnt	long	金币数
			dataTable["UserList"][i].m_nChipCnt = nMBaseMessage:readLong();
			--Common.log("m_nChipCnt = " .. dataTable["UserList"][i].m_nChipCnt)
			--...Title	Text	称号
			dataTable["UserList"][i].m_sTitle = nMBaseMessage:readString();
			--...MasterScore	Int	大师分
			dataTable["UserList"][i].m_nMasterScore = nMBaseMessage:readInt();
			--...WinRate	Text	胜率
			dataTable["UserList"][i].sWinRate = nMBaseMessage:readString();
			--...BrokenRate	Text	逃跑率
			dataTable["UserList"][i].sBrokenRate = nMBaseMessage:readString();
			--…VipLevel	int	VIP等级
			dataTable["UserList"][i].mnVipLevel = nMBaseMessage:readInt();
			--Common.log("read40001 mnVipLevel = " .. dataTable["UserList"][i].mnVipLevel);
			--…Age	Int	年龄
			dataTable["UserList"][i].age = nMBaseMessage:readInt();
			--…Sex	Int	性别
			dataTable["UserList"][i].sex = nMBaseMessage:readInt();
			--…City	Text	城市
			dataTable["UserList"][i].city = nMBaseMessage:readString();
			--…mLadderSegment	Int	天梯段位
			dataTable["UserList"][i].ladderDuan = nMBaseMessage:readInt();
			--…mLadderRank	Int	天梯等级
			dataTable["UserList"][i].ladderLevel = nMBaseMessage:readInt();
			--…mLadderRound	Int	天梯局数
			dataTable["UserList"][i].round = nMBaseMessage:readInt();
			--…TitlePicUrl	Text	玩家称号图片URL
			dataTable["UserList"][i].titlePicUrl = nMBaseMessage:readString();
			--…isNewTablePlayer	byte	是不是新加入牌桌的人，用于判断是否可被踢1是新人（不可踢），0不是新人（可踢）
			dataTable["UserList"][i].isNewTablePlayer = nMBaseMessage:readByte();

			-- 积分
			dataTable["UserList"][i].scoreCnt = nMBaseMessage:readLong();
			--Common.log("scoreCnt = "..dataTable["UserList"][i].scoreCnt)

			nMBaseMessage:setReadPos(pos + length)
		end

		--			MatchID	Int	比赛ID
		dataTable["nMatchID"] = nMBaseMessage:readInt();
		--Chip	Int	冲榜积分
		dataTable["m_nPunchListScore"] = nMBaseMessage:readInt();
		--Rank	Int	冲榜名次
		dataTable["m_nPunchListRank"] = nMBaseMessage:readInt();
		--EndTime	Short	冲榜倒计时
		dataTable["m_nPunchListDuration"] = nMBaseMessage:readShort();
		--AutoReady	byte	客户端是否自动准备	0不需要自动准备 1自动准备
		dataTable["autoReady"] = nMBaseMessage:readByte();
		--TableType	byte	牌桌游戏类型	0标准玩法 1欢乐玩法
		dataTable["mnTableType"] = nMBaseMessage:readByte();
		dataTable["tableFee"] = nMBaseMessage:readInt();
		--Common.log("tableFee = "..dataTable["tableFee"])
	else
		-- 如果桌号是-1，则进入了等候区
		--Common.log("进入了Table等候区");
	end
	return dataTable
end

--[[--解析服务器通知 ]]
function read40002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = REQ + GAMEID_SERVER_MSG
	dataTable["messageName"] = "GAMEID_SERVER_MSG"
	--Common.log("================== 解析服务器通知 ===============")

	-- Type Byte 类型 1:充值弹窗 2:飘字 3:比赛播报 4.系统公告 5.强制退出 6.Toast,7.冲榜飘字,8.普通弹框
	dataTable["nType"] = nMBaseMessage:readByte();
	-- Msg text 比赛状态的客户端提示语
	dataTable["sMsg"] = nMBaseMessage:readString();
	-- 充值是否成功（充值特有）1成功，0失败
	dataTable["isSucceed"] = nMBaseMessage:readByte();

	return dataTable
end

--[[--
* 解析牌局结果
*
* @param helper
--]]
function read40003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = REQ + GAMEID_GAMERESULT
	dataTable["messageName"] = "GAMEID_GAMERESULT"
	-- MatchInstanceID text 比赛实例ID
	dataTable["sMatchInstanceID"] = nMBaseMessage:readString();
	-- RoomID Int 房间ID
	dataTable["roomId"] = nMBaseMessage:readInt();
	-- TableID Int 桌号
	dataTable["tableId"] = nMBaseMessage:readInt();
	-- EventType Byte 触发流程类型 0,无;1金蛋;2充值;3.下局翻倍;4换房间(其中金蛋这种类型客户端不处理)
	dataTable["eventType"] = nMBaseMessage:readByte();
	-- EventData Text 事件相关数据 1.换房间标注房间ID{roomID:123}2.充值标注充值金额{money:xxx}
	dataTable["eventData"] = nMBaseMessage:readString();
	-- EventMsg Text 事件提示信息
	dataTable["eventMsg"] = nMBaseMessage:readString();
	dataTable["PlayerList"] = {}
	dataTable["RemainCardCnt"] = {}
	local nPlayerCnt = nMBaseMessage:readInt();
	for i = 1, nPlayerCnt do
		dataTable["PlayerList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- …UserID int 用户ID
		dataTable["PlayerList"][i].userid = nMBaseMessage:readInt();
		-- …SeatID Byte 座位号
		dataTable["PlayerList"][i].seatid = nMBaseMessage:readByte();
		-- …WinChip int 金币变化 包含任务的倍数计算
		dataTable["PlayerList"][i].m_nWinChip = nMBaseMessage:readInt();
		-- …RemainChip long 剩余金币
		dataTable["PlayerList"][i].m_nChipCnt = nMBaseMessage:readLong();
		-- …RemainCardCnt byte 剩余牌数
		dataTable["PlayerList"][i].m_nRemainCardCnt = nMBaseMessage:readByte();
		dataTable["RemainCardCnt"][i] = {}
		for j = 1, dataTable["PlayerList"][i].m_nRemainCardCnt do
			-- ……CardVal byte 牌值
			dataTable["RemainCardCnt"][i][j] = nMBaseMessage:readByte();
		end
		-- …VipCoinAddition int 玩家Vip金币加成百分比 普通玩家：100黄金VIP：120
		dataTable["PlayerList"][i].mnVipCoinAddition = nMBaseMessage:readInt();
		-- …doubleScore Int 加倍倍数 是否加倍 -1是还没加倍 ，0不加倍, 2两倍 4 Vip四倍
		dataTable["PlayerList"][i].m_nDoubleScore = nMBaseMessage:readInt();

		-- 积分变化
		dataTable["PlayerList"][i].m_nWinScoreCnt = nMBaseMessage:readInt();
		-- 剩余积分
		dataTable["PlayerList"][i].m_nRemainScoreCnt = nMBaseMessage:readInt();
		-- 结算类型
		dataTable["PlayerList"][i].m_nAccountsType = nMBaseMessage:readByte();
		-- 手头金币
		dataTable["PlayerList"][i].m_nHandCoin = nMBaseMessage:readLong();
		-- 对手昵称
		dataTable["PlayerList"][i].m_nopponentNickName = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(pos + length)
	end

	dataTable["nMultipleDetail"] = {}
	-- MultipleDetail int 倍数明细 Loop
	local nMultipleDetail = nMBaseMessage:readInt();
	for i = 1, nMultipleDetail do
		dataTable["nMultipleDetail"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …detail text 描述
		dataTable["nMultipleDetail"][i].detail = nMBaseMessage:readString();
		-- …multiple Int 倍数
		dataTable["nMultipleDetail"][i].multiple = nMBaseMessage:readByte();
		nMBaseMessage:setReadPos(pos + length)
	end
	-- tableCost int 桌费
	dataTable["tableCost"] = nMBaseMessage:readInt();
	-- IsSpring Byte 是否春天 0否 1是
	dataTable["IsSpring"] = nMBaseMessage:readByte();
	-- RoomMinCoin Int 当前房间金币下限
	dataTable["mnRoomMinCoin"] = nMBaseMessage:readInt();

	return dataTable
end

--[[--
* 接收断线续玩消息
*
* @param helper
--]]
function read40004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = REQ + GAMEID_TABLE_SYNC
	dataTable["messageName"] = "GAMEID_TABLE_SYNC"
	--Common.log("牌桌收到断线续玩消息readTableSync--------------------------------->");

	--[[--*********************** 协议接收 **************************--]]
	-- GameID byte 游戏ID
	dataTable["nGameID"] = nMBaseMessage:readByte();
	if (dataTable["nGameID"] ~= GameConfig.GAME_ID) then
		return dataTable;
	end
	-- Mode Byte 模式 1 比赛 2 房间
	dataTable["mode"] = nMBaseMessage:readByte();
	--Common.log("read40004 mode = " .. dataTable["mode"]);
	-- MatchInstanceID text 比赛实例ID
	dataTable["m_sMatchInstanceID"] = nMBaseMessage:readString();
	-- RoomID int 房间ID
	dataTable["m_nRoomID"] = nMBaseMessage:readInt();
	--Common.log("房间ID:" .. dataTable["m_nRoomID"]);
	-- TableID int 桌子ID
	dataTable["m_nTableID"] = nMBaseMessage:readInt();
	--Common.log("桌子ID:" .. dataTable["m_nTableID"]);

	--[[--*********************** 斗地主子协议 **************************--]]
	-- MatchTitle text 比赛标题
	dataTable["msMatchTitle"] = nMBaseMessage:readString();
	-- InitTimerVal byte 初始倒计时
	dataTable["nInitTimerVal"] = nMBaseMessage:readByte();
	-- TableType byte 房间游戏类型 0标准玩法 1欢乐玩法
	dataTable["mnTableType"] = nMBaseMessage:readByte();
	-- TableStatus byte 桌子状态
	-- STAT_WAITING = 0;STAT_CALL_SCORE = 1;STAT_PLAYING =2;
	-- STAT_CHUANGGUAN_WAITING =
	-- 3;STAT_GRAB_LOARD=4;STAT_DOUBLE_SCORE=5;
	dataTable["nTableStatus"] = nMBaseMessage:readByte();
	-- CallScore byte 当前叫分
	dataTable["m_nCurrCallScore"] = nMBaseMessage:readByte();
	-- LordSeat byte 地主座位
	dataTable["nLordSeat"] = nMBaseMessage:readByte();
	-- SelfSeat byte 自己的座位号
	dataTable["m_nSeatID"] = nMBaseMessage:readByte();
	-- CurrPlayer byte 当前出牌或叫分的人
	dataTable["currPlayer"] = nMBaseMessage:readByte();
	-- BaseChip int 筹码基数
	dataTable["m_nBaseChip"] = nMBaseMessage:readInt();
	-- GameTask text 游戏任务(仅限普通房间)
	dataTable["m_sGameTask"] = nMBaseMessage:readString();
	-- Times Byte 倍数(废弃字段)
	nMBaseMessage:readByte();
	-- MatchID Int 比赛ID
	dataTable["matchID"] = nMBaseMessage:readInt();
	-- 房间冲榜
	-- Chip Int 冲榜积分
	dataTable["m_nPunchListScore"] = nMBaseMessage:readInt();
	-- Rank Int 冲榜名次
	dataTable["m_nPunchListRank"] = nMBaseMessage:readInt();
	-- EndTime Short 冲榜倒计时
	dataTable["m_nPunchListDuration"] = nMBaseMessage:readShort();

	--[[--****************** 恢复玩家数据 ********************--]]

	dataTable["PlayerList"] = {}
	-- PlayerCnt int 玩家数量 loop***********************
	local PlayerCnt = nMBaseMessage:readInt();
	--Common.log("玩家数量  = " .. PlayerCnt)
	for i = 1, PlayerCnt do
		dataTable["PlayerList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("PlayerList---length = " .. length)

		-- …UserID Int
		dataTable["PlayerList"][i].UserID = nMBaseMessage:readInt();
		-- ...SeatID byte 座位号
		dataTable["PlayerList"][i].nSeatID = nMBaseMessage:readByte();
		--Common.log("dataTable[PlayerList][i].nSeatID = "..dataTable["PlayerList"][i].nSeatID)
		-- ...NickName text 昵称
		dataTable["PlayerList"][i].m_sNickName = nMBaseMessage:readString();
		-- ...ChipCnt long 积分/金币数
		dataTable["PlayerList"][i].m_nChipCnt = nMBaseMessage:readLong();
		-- ...Title Text 称号
		dataTable["PlayerList"][i].m_sTitle = nMBaseMessage:readString();
		-- ...CardsCnt Byte 剩余牌数
		dataTable["PlayerList"][i].m_nCardCnt = nMBaseMessage:readByte();
		-- ...TrustType Byte 托管类型 0解除托管 1手动托管 2超时托管 3断线托管 4托管退出
		dataTable["PlayerList"][i].nTrustType = nMBaseMessage:readByte();
		--Common.log("read40004 nTrustType = "..dataTable["PlayerList"][i].nTrustType)
		-- ...MasterPlayer Byte 冲榜高手标志
		dataTable["PlayerList"][i].m_nMasterPlayer = nMBaseMessage:readByte();
		-- …VipLevel int VIP等级
		dataTable["PlayerList"][i].mnVipLevel = nMBaseMessage:readInt();
		-- …callScore byte 叫地主状态 -1还没开始叫地主0 不叫1 一分2 二分3 三分
		dataTable["PlayerList"][i].m_nCallScore = nMBaseMessage:readByte();
		-- …grabLord byte 抢地主 -1还没开始抢地主，0不抢地主，1抢地主
		dataTable["PlayerList"][i].m_nGrabScore = nMBaseMessage:readByte();
		-- …doubleScore byte 是否加倍 -1还没开始加倍，0不加倍，2加两倍 4加四倍
		dataTable["PlayerList"][i].m_nDoubleScore = nMBaseMessage:readByte();
		-- …CanDoubleMax Byte 玩家最高可加的倍数 0不能加倍2可以加2倍4 可以加4倍
		dataTable["PlayerList"][i].m_nCanDoubleMax = nMBaseMessage:readByte();
		-- …NoDoubleReason Byte 不能加倍的原因 1自己金币不足0别人金币不足
		dataTable["PlayerList"][i].m_nNoDoubleReason = nMBaseMessage:readByte();
		-- …MinCoins Int 满足加倍条件的最低金币数
		dataTable["PlayerList"][i].m_nMinCoins = nMBaseMessage:readInt();

		-- …OpenCardsTimes byte 明牌倍数 5倍；3倍；2倍；1：不明牌
		dataTable["PlayerList"][i].mnOpenCardsTimes = nMBaseMessage:readByte();
		--Common.log("read40004 mnOpenCardsTimes = "..dataTable["PlayerList"][i].mnOpenCardsTimes)

		-- …PlaerCards ByteArray 明牌者手当前中的牌 不明牌者为0长度的byte数组
		local PlayerCards = nMBaseMessage:readShort()
		local PlayerCardsPos = nMBaseMessage:getReadPos()
		dataTable["PlayerList"][i].PlayerCards = {}
		--Common.log("PlayerCards = "..PlayerCards)
		for j = 1,PlayerCards do
			dataTable["PlayerList"][i].PlayerCards[j] = nMBaseMessage:readByte();
		end
		--
		nMBaseMessage:setReadPos(PlayerCardsPos + PlayerCards)

		-- …Sex Int 性别
		dataTable["PlayerList"][i].mnSex = nMBaseMessage:readInt();

		-- …TitlePicUrl Text 玩家称号图片URL
		dataTable["PlayerList"][i].titlePicUrl = nMBaseMessage:readString();

		-- …IsInCrazy	Byte	是否是闯关玩家	1 是，0不是
		dataTable["PlayerList"][i].isInCrazy = nMBaseMessage:readByte();
		--Common.log("isInCrazy is " .. dataTable["PlayerList"][i].isInCrazy)
		-- …MatchScore	Int	比赛积分
		dataTable["PlayerList"][i].matchScore = nMBaseMessage:readInt();
		--Common.log("matchScore is " .. dataTable["PlayerList"][i].matchScore)
		nMBaseMessage:setReadPos(pos + length)
	end

	--[[--****************** 恢复自己手牌数据 ********************--]]
	dataTable["SelfCards"] = {}
	-- SelfCardsCnt int 手上的牌数量 Loop*****************
	local SelfCardsCnt = nMBaseMessage:readInt();
	--Common.log("玩家数量  = " .. PlayerCnt)
	for i = 1, SelfCardsCnt do
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- ...CardVal byte 手上的牌值
		dataTable["SelfCards"][i] = nMBaseMessage:readByte();
		nMBaseMessage:setReadPos(pos + length)
	end

	--[[--****************** 恢复底牌数据 ********************--]]
	dataTable["CommCards"] = {}
	-- CommCardsCnt int 底牌数量 Loop******************
	local nCommCardsCnt = nMBaseMessage:readInt();
	for i = 1, nCommCardsCnt do
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- ...CommCardsVal byte 底牌
		dataTable["CommCards"][i] = nMBaseMessage:readByte();
		--Common.log("CommCards = "..dataTable["CommCards"][i])
		nMBaseMessage:setReadPos(pos + length)
	end

	--[[--****************** 恢复记牌器与上一手牌 ********************--]]
	dataTable["TakeoutAction"] = {}
	dataTable["TakeoutCardVal"] = {}
	-- TakeoutActionCnt int 出牌行为数量 Loop 从地主的座位号开始循环出牌日志
	local nTakeoutActionCnt = nMBaseMessage:readInt();
	for i = 1, nTakeoutActionCnt do
		dataTable["TakeoutAction"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …CardCnt byte 本次出牌数量
		dataTable["TakeoutAction"][i].cardCnt = nMBaseMessage:readByte();
		dataTable["TakeoutCardVal"][i] = {}
		for j = 1, dataTable["TakeoutAction"][i].cardCnt do
			-- ……CardVal byte 牌值
			dataTable["TakeoutCardVal"][i][j] = nMBaseMessage:readByte();
		end
		nMBaseMessage:setReadPos(pos + length)
	end
	-- 牌桌倍数SelfTimes int Int型的倍数 前面byte型倍数不够用
	dataTable["m_nMultiple"] = nMBaseMessage:readInt();
	-- HunCardVal byte 癞子牌牌值
	dataTable["laiziCardVal"] = nMBaseMessage:readByte();

	--[[--****************** 恢复牌桌上的牌 ********************--]]
	dataTable["TableCards"] = {}
	dataTable["CardVal"] = {}
	-- TableCards int 牌桌上牌值数量 Loop从座位号0开始循环
	local TableCards = nMBaseMessage:readInt();
	--Common.log("牌桌上牌值数量 TableCards === "..TableCards)
	for i = 1, TableCards do
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["TableCards"][i] = {}
		-- …CardCnt byte 本次出牌数量
		dataTable["TableCards"][i].CardCnt = nMBaseMessage:readByte();
		--Common.log("本次出牌数量  dataTable[TableCards][i].CardCnt === "..dataTable["TableCards"][i].CardCnt)
		dataTable["CardVal"][i] = {}
		for j = 1, dataTable["TableCards"][i].CardCnt do
			dataTable["CardVal"][i][j] = {}
			-- ……CardVal byte 牌值
			dataTable["CardVal"][i][j].nVal = nMBaseMessage:readByte();
			--Common.log("牌值  dataTable[CardVal][i][j].nVal === "..dataTable["CardVal"][i][j].nVal)
			-- ……isLaiZiCard byte 是否是癞子牌 0：不是；1：是
			dataTable["CardVal"][i][j].isLaiZiCard = nMBaseMessage:readByte();
		end
		nMBaseMessage:setReadPos(pos + length)
	end
	dataTable["BaseSocre"] = nMBaseMessage:readInt();
	--Common.log("BaseSocre = "..dataTable["BaseSocre"])

	dataTable["rechargeTimeRemain"] = nMBaseMessage:readInt();
	--Common.log("rechargeTimeRemain = "..dataTable["rechargeTimeRemain"])

	dataTable["MinCoin"] = nMBaseMessage:readInt();
	--Common.log("MinCoin = "..dataTable["MinCoin"])


	return dataTable
end

--[[--
-- 解析用户属性变更
--
-- @param helper
]]
function read80040006(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GAMEID_USER_ATTR
	dataTable["messageName"] = "GAMEID_USER_ATTR"
	local UserAttrCN =  nMBaseMessage:readInt()
	--Common.log("UserAttrCN ============== "..UserAttrCN)
	-- UserAttrCN byte 用户属性变化列表 Loop
	dataTable["UserAttr"] = {}
	for i = 1, UserAttrCN do
		dataTable["UserAttr"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …name Text 属性名
		-- 金币：coin元宝：yuanbao荣誉值：honor兑奖券：duijiang VIP等级：viplevel
		dataTable["UserAttr"][i].name = nMBaseMessage:readString();
		--Common.log("name ============== "..dataTable["UserAttr"][i].name)
		-- …value Text 属性值
		dataTable["UserAttr"][i].value = nMBaseMessage:readString();
		--Common.log("value ============== "..dataTable["UserAttr"][i].value)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

------------------------------------------------------------------
--[[------------------------斗地主牌桌消息----------------------- ]]
------------------------------------------------------------------

--[[--
* 解析开始游戏应答
*
* @param helper
--]]
function read80110001(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = DDZID_READY + ACK
	dataTable["messageName"] = "DDZID_READY"
	--Common.log("解析开始游戏应答 ======= ");
	dataTable["sMatchInstanceID"] = nMBaseMessage:readString();
	dataTable["nContinueSeat"] = nMBaseMessage:readByte();
	dataTable["nUserID"] = nMBaseMessage:readInt();
	-- OpenCardsTimes byte 明牌倍数
	dataTable["OpenCardsTimes"] = nMBaseMessage:readByte();
	-- IsReadySucceed byte 是否成功举手 1成功，0不成功
	dataTable["IsReadySucceed"] = nMBaseMessage:readByte();
	-- resultMsg Text 失败原因
	dataTable["resultMsg"] = nMBaseMessage:readString();
	-- operateType byte 举手失败的后续操作类型 0显示举手失败原因1显示充值引导2请求破产送金
	dataTable["operateType"] = nMBaseMessage:readByte();
	return dataTable
end

--[[--
* 解析发牌应答
*
* @param helper
--]]
function read110002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = REQ + DDZID_INITCARD
	dataTable["messageName"] = "DDZID_INITCARD"
	dataTable["sMatchInstanceID"] = nMBaseMessage:readString();
	-- 当前的牌是那一家的
	dataTable["nSeat"] = nMBaseMessage:readByte();
	-- 金币基数
	dataTable["m_nBaseChip"] = nMBaseMessage:readInt();
	--Common.log("read110002 m_nBaseChip = "..dataTable["m_nBaseChip"])
	-- 第一个叫分的玩家
	dataTable["m_nCallScorePlayerSeat"] = nMBaseMessage:readByte();

	dataTable["nSelfCardCnt"] = nMBaseMessage:readByte();
	dataTable["SelfCard"] = {}
	-- 后面跟17张牌
	for i = 1, dataTable["nSelfCardCnt"] do
		dataTable["SelfCard"][i] = nMBaseMessage:readByte();
		--Common.log("read110002="..i.."="..dataTable["SelfCard"][i])
	end

	dataTable["m_sGameTask"] = nMBaseMessage:readString();
	-- 是否高手，只2人，去除自己
	dataTable["userCnt"] = nMBaseMessage:readByte();
	for i = 1, dataTable["userCnt"] do
		-- userID
		nMBaseMessage:readInt();
		-- 冲榜高手
		nMBaseMessage:readByte();
	end
	-- 积分基数
	dataTable["BaseSocre"] = nMBaseMessage:readInt();
	--Common.log("read110002 BaseSocre = "..dataTable["BaseSocre"])

	dataTable["tableFee"] = nMBaseMessage:readInt();
	--Common.log("read110002 tableFee = "..dataTable["tableFee"])
	return dataTable
end

--[[--
* 解析明牌倍数
*
* @param helper
--]]
function read8011000b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + LORDID_OPEN_CARDS
	dataTable["messageName"] = "LORDID_OPEN_CARDS"

	-- MatchInstanceID text 比赛实例ID
	dataTable["sMatchInstanceID"] = nMBaseMessage:readString();
	-- LastOpenCardsSeat byte 明牌者的座位号
	dataTable["LastOpenCardsSeat"] = nMBaseMessage:readByte();

	-- OpenCardsTimes byte 明几倍
	dataTable["OpenCardsTimes"] = nMBaseMessage:readByte();
	--Common.log("OpenCardsTimes = "..dataTable["OpenCardsTimes"])

	-- MaxTimes int 当前牌桌总倍数
	dataTable["m_nMultiple"] = nMBaseMessage:readInt();
	-- IsOpenCardsEnd byte 是否明牌结束 0未结束，1明牌结束---发牌阶段的明牌才有效
	dataTable["IsOpenCardsEnd"] = nMBaseMessage:readByte();
	-- FirstCallSeat byte 第一个叫分的玩家---发牌阶段的明牌才有效
	dataTable["FirstCallSeat"] = nMBaseMessage:readByte();
	-- CardCnt ByteArray 明牌手中的牌
	local CardCnt = nMBaseMessage:readShort()
	local CardCntPos = nMBaseMessage:getReadPos()
	dataTable["CardCnt"] = {}
	for i = 1,CardCnt do
		dataTable["CardCnt"][i] = nMBaseMessage:readByte();
	end
	--
	nMBaseMessage:setReadPos(CardCntPos + CardCnt)
	return dataTable
end

--[[--
* 解析叫分应答
*
* @param helper
--]]
function read80110003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = DDZID_CALLSCORE + ACK
	dataTable["messageName"] = "DDZID_CALLSCORE"
	-- MatchInstanceID text 比赛实例ID
	dataTable["sMatchInstanceID"] = nMBaseMessage:readString();
	-- 下一次叫牌座位 由服务器添加
	dataTable["m_nCallScorePlayerSeat"] = nMBaseMessage:readByte();
	-- 已经叫到分值 ---1表示必须叫分
	dataTable["m_nCurrCallScore"] = nMBaseMessage:readByte();
	-- 上一家叫的分值0：不叫1：1分2：2分3：3分
	dataTable["nLastCallScore"] = nMBaseMessage:readByte();
	-- 上一家的位置
	dataTable["nLastCallSeat"] = nMBaseMessage:readByte();
	-- NextGrabSeat byte 下一次抢地主座位号
	dataTable["NextGrabSeat"] = nMBaseMessage:readByte();
	-- CurrTimes int 当前倍数 服务器决定叫分x几倍
	dataTable["CurrTimes"] = nMBaseMessage:readInt();
	return dataTable
end

--[[--
* 解析抢地主应答
*
* @param helper
--]]
function read80110009(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = LORDID_GRAB_LANDLORD + ACK
	dataTable["messageName"] = "LORDID_GRAB_LANDLORD"
	-- MatchInstanceID text 比赛实例ID
	dataTable["sMatchInstanceID"] = nMBaseMessage:readString();
	-- MaxTimes byte 倍数
	dataTable["multiple"] = nMBaseMessage:readByte();
	-- NextGrabSeat byte 下一个抢地主的座位号
	dataTable["m_nCallScorePlayerSeat"] = nMBaseMessage:readByte();
	-- LastGrabSeat byte 上一个抢地主的座位号
	dataTable["nLastGrabSeat"] = nMBaseMessage:readByte();
	-- LastGrabScore byte 0不抢，1抢
	dataTable["nLastGrabScore"] = nMBaseMessage:readByte();
	-- MaxTimesV2 int 新倍数 V2版欢乐使用
	dataTable["m_nMultiple"] = nMBaseMessage:readInt();
	return dataTable
end

--[[--
* 解析托管应答
*
* @param helper
--]]
function read80110007(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = MATID_TRUST_PLAY + ACK
	dataTable["messageName"] = "MATID_TRUST_PLAY"

	dataTable["MatchInstanceID"] = nMBaseMessage:readString();
	dataTable["nSeatID"] = nMBaseMessage:readByte();
	dataTable["type"] = nMBaseMessage:readByte();
	--Common.log("read80110007 type = "..dataTable["type"])

	return dataTable
end

--[[--
* 解析开始加倍
*
* @param helper
--]]
function read11000c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = LORDID_START_DOUBLE + REQ
	dataTable["messageName"] = "LORDID_START_DOUBLE"
	dataTable["DoubleStatusList"] = {}
	-- DoubleStatusList int 玩家是否能加倍列表 loop
	local nDoubleStatusListSize = nMBaseMessage:readInt();
	for i = 1, nDoubleStatusListSize do
		dataTable["DoubleStatusList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …seatId byte 玩家座位号
		dataTable["DoubleStatusList"][i].nPlayer = nMBaseMessage:readByte();
		-- …status Byte 玩家最高可加的倍数 0不能加倍2可以加2倍4 可以加4倍
		dataTable["DoubleStatusList"][i].status = nMBaseMessage:readByte();
		-- …NoDoubleReason Byte 不能加倍的原因 1自己金币不足0别人金币不足
		dataTable["DoubleStatusList"][i].m_nNoDoubleReason = nMBaseMessage:readByte();
		-- …MinCoins Int 满足加倍条件的最低金币数
		dataTable["DoubleStatusList"][i].m_nMinCoins = nMBaseMessage:readInt();
		-- …MinCommonCoins Int 满足普通加倍条件的最低金币数
		dataTable["DoubleStatusList"][i].m_nCommonMinCoins = nMBaseMessage:readInt();
		-- ...MinSuperCoins Int 满足超级加倍条件的最低金币数
		dataTable["DoubleStatusList"][i].m_nSuperMinCoins = nMBaseMessage:readInt();
		nMBaseMessage:setReadPos(pos + length)
	end
	-- 地主是谁
	dataTable["nLordSeat"] = nMBaseMessage:readByte();
	return dataTable
end


--[[--
* 解析加倍应答
*
* @param helper
--]]
function read8011000a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = LORDID_DOUBLE_SCORE + ACK
	dataTable["messageName"] = "LORDID_DOUBLE_SCORE"
	-- MatchInstanceID text 比赛实例ID
	dataTable["sMatchInstanceID"] = nMBaseMessage:readString();
	-- LastDoubleSeat byte
	dataTable["LastDoubleSeat"] = nMBaseMessage:readByte();
	-- doubleScore byte 加几倍 0不加倍2两倍 4 加四倍
	dataTable["doubleScore"] = nMBaseMessage:readByte();
	--Common.log("read8011000a doubleScore = "..dataTable["doubleScore"])
	-- IsDoubleEnd Byte 是否加倍结束 0加倍未结束，1加倍结束
	dataTable["IsDoubleEnd"] = nMBaseMessage:readByte();
	-- LordSeat byte 地主座位
	dataTable["nLordSeat"] = nMBaseMessage:readByte();
	dataTable["PlayerList"] = {}
	-- PlayerCnt byte 同桌人数 loop
	local PlayerCnt = nMBaseMessage:readInt();
	for i = 1, PlayerCnt do
		dataTable["PlayerList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …PlayerSeat byte 座位号
		dataTable["PlayerList"][i].PlayerSeat = nMBaseMessage:readByte();
		-- …MaxTimes int 倍数
		dataTable["PlayerList"][i].MaxTimes = nMBaseMessage:readInt();
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end


--[[--
* 解析发底牌应答
*
* @param helper
--]]
function read110004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = DDZID_SENDRESERVECARD + REQ
	dataTable["messageName"] = "DDZID_SENDRESERVECARD"

	dataTable["sMatchInstanceID"] = nMBaseMessage:readString();
	-- 地主是谁
	dataTable["nLordSeat"] = nMBaseMessage:readByte();
	-- 底牌数
	local nCnt = nMBaseMessage:readByte();
	dataTable["ReservedCard"] = {}
	for i = 1, nCnt do
		dataTable["ReservedCard"][i] = nMBaseMessage:readByte();
	end
	if (TableConsole.mnTableType == TableConsole.TABLE_TYPE_HAPPY or TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT) then
		dataTable["DoubleStatusList"] = {}
		-- DoubleStatusList int 玩家是否能加倍列表 loop
		local nDoubleStatusListSize = nMBaseMessage:readInt();
		for i = 1, nDoubleStatusListSize do
			local length = nMBaseMessage:readShort()
			local pos = nMBaseMessage:getReadPos()
			-- …seatId byte 玩家座位号
			nMBaseMessage:readByte();
			-- …status Byte 玩家最高可加的倍数 0不能加倍2可以加2倍4 可以加4倍
			nMBaseMessage:readByte();
			-- …NoDoubleReason Byte 不能加倍的原因 1自己金币不足0别人金币不足
			nMBaseMessage:readByte();
			-- …MinCoins Int 满足加倍条件的最低金币数
			nMBaseMessage:readInt();
			nMBaseMessage:setReadPos(pos + length)
		end
		-- ReservedCardTimes int 特殊牌型倍数 同花x2；三同张x3；顺子x3；单王x2；双王x3；其他x1;
		dataTable["mnReservedCardTimes"] = nMBaseMessage:readInt();
		-- MaxTimes int 当前牌桌总倍数
		dataTable["m_nMultiple"] = nMBaseMessage:readInt();
		-- ReservedCardName Text 特殊牌型名称
		dataTable["msReservedCardName"] = nMBaseMessage:readString();
		-- HunCardVal byte 癞子牌牌值
		dataTable["HunCardVal"] = nMBaseMessage:readByte();
	end
	return dataTable
end

--[[--
-- 解析出牌应答
--
-- @param helper
--]]
function read80110005(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = DDZID_TAKEOUTCARD + ACK
	dataTable["messageName"] = "DDZID_TAKEOUTCARD"
	-- MatchInstanceID text 比赛实例ID
	dataTable["sMatchInstanceID"] = nMBaseMessage:readString();
	-- TakeOutSeat byte 出牌者玩家的座位号
	dataTable["nPlayer"] = nMBaseMessage:readByte();
	-- NextSeat byte 下一个出牌的玩家
	dataTable["m_nCurrPlayer"] = nMBaseMessage:readByte();
	-- CardsCnt byte 牌数 出了多少张牌
	dataTable["nNormalCardCnt"] = nMBaseMessage:readByte();
	dataTable["NormalCard"] = {}
	-- 取出牌
	for i = 1, dataTable["nNormalCardCnt"] do
		dataTable["NormalCard"][i] = {}
		-- ...CardVal byte 牌值 非癞子牌
		dataTable["NormalCard"][i].nVal = nMBaseMessage:readByte();
	end
	-- LaiziCardsCnt byte 癞子牌牌数 癞子牌变化后的牌
	dataTable["nLaiziCardCnt"] = nMBaseMessage:readByte();
	dataTable["LaiziCard"] = {}

	for i = 1, dataTable["nLaiziCardCnt"] do
		dataTable["LaiziCard"][i] = {}
		-- ... HunCardVal byte 癞子牌变化后的牌值
		dataTable["LaiziCard"][i].nEndVal = nMBaseMessage:readByte();
		-- ... OriginalCardVal byte 癞子牌变化前的原始牌值
		dataTable["LaiziCard"][i].OriginalCardVal = nMBaseMessage:readByte();
	end
	return dataTable
end

--[[--
* 解析同步自己的手牌
*
* @param helper
--]]
function read8011000e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + LORDID_SYNC_HAND_CARDS
	dataTable["messageName"] = "LORDID_SYNC_HAND_CARDS"
	--Common.log("同步自己的手牌");
	-- CardVal	ByteArray	手中的牌
	local CardCnt = nMBaseMessage:readShort()
	local CardCntPos = nMBaseMessage:getReadPos()
	dataTable["CardVal"] = {}
	for i = 1,CardCnt do
		dataTable["CardVal"][i] = nMBaseMessage:readByte();
	end
	nMBaseMessage:setReadPos(CardCntPos + CardCnt)
	return dataTable
end

--[[-----------------------游戏ROOM_ID 消息----------------------]]

--[[--
* 解析退出房间
*
* @param helper
--]]
function read80030004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + ROOMID_QUIT_ROOM
	dataTable["messageName"] = "ROOMID_QUIT_ROOM"
	--Common.log("readExitRoom");
	-- SeatID Byte 退出玩家座位号
	dataTable["nSeatID"] = nMBaseMessage:readByte();
	-- UserID Int 玩家ID
	dataTable["UserID"] = nMBaseMessage:readInt();
	-- IsKickOut byte 是否被踢出房间 1是踢出 0正常
	dataTable["IsKickOut"] = nMBaseMessage:readByte();
	-- goBankrupt byte 破差送金次数
	dataTable["goBankrupt"] = nMBaseMessage:readByte();
	return dataTable
end

--[[--
* 解析进入房间
*
* @param helper
--]]
function read80030005(nMBaseMessage)
	--Common.log("read80030005 comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + ROOMID_ENTER_ROOM
	dataTable["messageName"] = "ROOMID_ENTER_ROOM"
	--Pub.closeProgressDialog();
	-- RoomID Int 房间ID
	dataTable["nRoomID"] = nMBaseMessage:readInt();
	-- MatchInstanceID text 比赛实例ID
	nMBaseMessage:readString();
	-- Result byte 进入结果 0 成功 1 失败
	dataTable["result"] = nMBaseMessage:readByte();
	-- ResultMsg text 提示语 失败时返回提示语
	dataTable["ResultMsg"] = nMBaseMessage:readString();
	--Common.log("read80030005 ResultMsg = "..dataTable["ResultMsg"])

	if (dataTable["result"] == 1) then
	--return dataTable;
	end
	-- GameID byte
	nMBaseMessage:readByte();
	-- RoomTitle text 标题
	dataTable["msRoomTitle"] = nMBaseMessage:readString();
	-- CurrPlayerCnt short 当前人数
	dataTable["CurrPlayerCnt"] = nMBaseMessage:readShort();
	-- TableHintMsg text 进入房间后牌桌上显示的提示
	dataTable["TableHintMsg"] = nMBaseMessage:readString();
	-- TableType byte 房间牌桌类型 0普通玩法 1欢乐玩法 2癞子玩法
	dataTable["mnTableType"] = nMBaseMessage:readByte();

	-- BaseChipText Text 房间筹码基数提示语
	dataTable["msBaseChipText"] = nMBaseMessage:readString();
	--Common.log("msBaseChipText = "..dataTable["msBaseChipText"])

	-- TableCost Int 房间桌费
	dataTable["TableCost"] = nMBaseMessage:readInt();
	-- 比赛ID
	dataTable["MatchID"] = nMBaseMessage:readInt();
	-- FailType
	dataTable["FailType"] = nMBaseMessage:readByte();
	--PopRechargeGuid	byte	是否弹出充值引导	0不弹出 1弹出
	dataTable["PopRechargeGuid"] = nMBaseMessage:readByte();
	--NeedCoinCnt	int	还需要充值多少金币才能进入
	dataTable["NeedCoinCnt"] = nMBaseMessage:readInt();

	-- 房间金币底数
	dataTable["baseChip"] = nMBaseMessage:readInt();
	--Common.log("baseChip = "..dataTable["baseChip"])

	return dataTable
end

--[[-- 斗地主房间列表]]
function read80030016(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + ROOMID_ROOM_LIST_NEW
	dataTable["messageName"] = "ROOMID_ROOM_LIST_NEW"

	--SendTimes  房间列表发送次数
	dataTable["SendTimes"] = nMBaseMessage:readByte()
	--Common.log("房间列表发送次数 = " .. dataTable["SendTimes"])
	--updataRoomCnt  房间更新数量
	dataTable["Room"] = {}
	local updataRoomCnt = nMBaseMessage:readInt()
	dataTable["updataRoomCnt"] = updataRoomCnt
	--消息协议分两种，时间戳不一样，返回房间列表，一样，返回激战人数
	--updataRoomCnt是0，返回激战人数
	if updataRoomCnt == 0 then
		local RoomCnt = nMBaseMessage:readShort()
		--Common.log("Room---RoomCnt = " .. updataRoomCnt.."="..RoomCnt)
		for i = 1, RoomCnt do
			dataTable["Room"][i] = {}
			--…RoomID
			dataTable["Room"][i].RoomID = nMBaseMessage:readInt()
			--Common.log("Room---RoomID = " .. dataTable["Room"][i].RoomID)
			--…playerCnt
			dataTable["Room"][i].playerCnt = nMBaseMessage:readInt()
			--Common.log("Room---playerCnt = " .. dataTable["Room"][i].playerCnt)
		end
	else
		for i = 1, updataRoomCnt do
			dataTable["Room"][i] = {}
			local length = nMBaseMessage:readShort()
			local pos = nMBaseMessage:getReadPos()
			--Common.log("Room---length = " .. length)
			--…RoomID  房间ID
			dataTable["Room"][i].RoomID = nMBaseMessage:readInt()
			--Common.log("Room---房间ID = " .. dataTable["Room"][i].RoomID)
			--…GameID  游戏ID
			dataTable["Room"][i].GameID = nMBaseMessage:readByte()
			--…DeleteFlag  删除标志
			dataTable["Room"][i].DeleteFlag = nMBaseMessage:readByte()
			--....TableFee  桌费
			dataTable["Room"][i].TableFee = nMBaseMessage:readInt()
			--....EntryConditions  进入条件
			dataTable["Room"][i].EntryConditions = nMBaseMessage:readString()
			--Common.log("Room---进入条件 = " .. dataTable["Room"][i].EntryConditions)
			--....playerCnt  激战人数
			dataTable["Room"][i].playerCnt = nMBaseMessage:readInt()
			--....TitleUrl  标题图片
			dataTable["Room"][i].TitleUrl = nMBaseMessage:readString()
			--....prizeUrl  奖品图片
			dataTable["Room"][i].prizeUrl = nMBaseMessage:readString()
			--....Rank  房间排序字段
			dataTable["Room"][i].Rank = nMBaseMessage:readByte()
			--....RegCoin  进入房间最低金币数
			dataTable["Room"][i].RegCoin = nMBaseMessage:readInt()
			--....TableType  TableType
			dataTable["Room"][i].TableType = nMBaseMessage:readByte()
			--Common.log("Room---length = " .. dataTable["Room"][i].TableType)
			--....RegMaxCoin  进入房间最高金币数
			dataTable["Room"][i].RegMaxCoin = nMBaseMessage:readLong()
			--....RoomName  房间名称
			dataTable["Room"][i].RoomName = nMBaseMessage:readString()
			--Common.log("房间列表1"..dataTable["Room"][i].RoomID..dataTable["Room"][i].RoomName..dataTable["Room"][i].EntryConditions)

			nMBaseMessage:setReadPos(pos + length)

		end
	end
	--TimeStamp  时间戳
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	--Common.log("时间戳 = " .. dataTable["TimeStamp"])

	return dataTable
end

--[[--
* 解析快速开始
*
* @param helper
--]]
function read80030018(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + ROOMID_QUICK_START
	dataTable["messageName"] = "ROOMID_QUICK_START"
	--		Pub.closeProgressDialog();
	-- Result byte 进入房间结果 1、金币不足
	dataTable["result"] = nMBaseMessage:readByte();
	-- ResultMsg text 提示语 失败时返回提示语
	dataTable["ResultMsg"] = nMBaseMessage:readString();
	--Common.log("提示语 : " .. dataTable["ResultMsg"]);
	-- needCoinCnt int 进入最低欢乐房间仍缺多少金币
	dataTable["needCoinCnt"] = nMBaseMessage:readInt();
	--Common.log("进入最低欢乐房间仍缺多少金币 : " .. dataTable["needCoinCnt"]);
	-- RemainCount byte 当天剩余破产送金次数 消息版本号：1
	dataTable["mnRemainCount"] = nMBaseMessage:readByte();
	-- RoomType byte 进入的房间类型 0普通 1欢乐 2癞子
	dataTable["roomType"] = nMBaseMessage:readByte();
	-- PopRechargeGuid	byte	是否弹出充值引导	0不弹出 1弹出
	dataTable["PopRechargeGuid"] = nMBaseMessage:readByte();
	return dataTable
end

------------------------------------------------------------------
--[[------------------------BASEID   消息----------------------- ]]
------------------------------------------------------------------

--[[--
--接收注册消息
]]
function read80010001(nMBaseMessage)
	--Common.log("read80010001")
	local dataTable = {}
	dataTable["messageType"] = (ACK + BASEID_REGISTER)
	dataTable["messageName"] = "BASEID_REGISTER"

	--Result  注册结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("注册结果 = " .. dataTable["Result"])
	--ResultTxt  提示语内容
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("提示语内容 = " .. dataTable["ResultTxt"])
	--UserID  用户ID
	dataTable["UserID"] = nMBaseMessage:readInt()
	--Common.log("用户ID = " .. dataTable["UserID"])
	--NickName  昵称
	dataTable["NickName"] = nMBaseMessage:readString()
	--Common.log("昵称 = " .. dataTable["NickName"])
	--Password  密码
	dataTable["Password"] = nMBaseMessage:readString()
	--Common.log("密码 = " .. dataTable["Password"])
	--YuanBao  元宝
	dataTable["YuanBao"] = nMBaseMessage:readInt()
	--Common.log("元宝 = " .. dataTable["YuanBao"])
	--Coin  金币
	dataTable["Coin"] = nMBaseMessage:readLong()
	--Common.log("金币 = " .. dataTable["Coin"])
	--honor  荣誉值
	dataTable["honor"] = nMBaseMessage:readInt()
	--Common.log("荣誉值 = " .. dataTable["honor"])
	--PhotoUrl  头像URL
	dataTable["PhotoUrl"] = nMBaseMessage:readString()
	--Common.log("头像URL = " .. dataTable["PhotoUrl"])
	--SessionID  当前Socket连接的SessionID
	dataTable["SessionID"] = nMBaseMessage:readLong()
	--Common.log("当前Socket连接的SessionID = " .. dataTable["SessionID"])

	return dataTable
end

--[[--
--接收登录消息
]]
function read80010002(nMBaseMessage)
	--Common.log("read80010002 == " .. nMBaseMessage:getLength())
	local dataTable = {}
	dataTable["messageType"] = (ACK + BASEID_LOGIN)
	dataTable["messageName"] = "BASEID_LOGIN"

	--UserID  用户ID
	dataTable["UserID"] = nMBaseMessage:readInt()
	--Common.log("用户ID = " .. dataTable["UserID"])
	--result  是否成功
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("是否成功 = " .. dataTable["result"])
	--ResultTxt  提示语内容
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("提示语内容 = " .. dataTable["ResultTxt"])
	--InitLoginInfoChanged  是否修改过原始登录信息
	dataTable["InitLoginInfoChanged"] = nMBaseMessage:readByte()
	--Common.log("是否修改过原始登录信息 = " .. dataTable["InitLoginInfoChanged"])
	--NickName  昵称
	dataTable["NickName"] = nMBaseMessage:readString()
	--Common.log("昵称 = " .. dataTable["NickName"])
	--PhotoUrl  头像URL
	dataTable["PhotoUrl"] = nMBaseMessage:readString()
	--Common.log("头像URL = " .. dataTable["PhotoUrl"])
	--Coin  金币
	dataTable["Coin"] = nMBaseMessage:readLong()
	--Common.log("金币 = " .. dataTable["Coin"])
	--UnreadMsgCnt  未读消息数量
	dataTable["UnreadMsgCnt"] = nMBaseMessage:readInt()
	--Common.log("未读消息数量 = " .. dataTable["UnreadMsgCnt"])
	--SessionID  当前Socket连接的SessionID
	dataTable["SessionID"] = nMBaseMessage:readLong()
	--Common.log("当前Socket连接的SessionID = " .. dataTable["SessionID"])
	--VipLevel  VIP等级
	dataTable["VipLevel"] = nMBaseMessage:readInt()
	--Common.log("VIP等级 = " .. dataTable["VipLevel"])
	--yuanbao  元宝
	dataTable["yuanbao"] = nMBaseMessage:readInt()
	--Common.log("元宝 = " .. dataTable["yuanbao"])
	--UserExtData  用户信息数据
	--byte数组
	--    byte[] data = getBytes();
	local length = nMBaseMessage:readShort();
	local pos = nMBaseMessage:getReadPos();

	-----------------------
	----- 接收游戏相关数据
	------------------------
	nMBaseMessage:setReadPos(pos + length)

	return dataTable
end

--[[-- 解析取出基本信息]]
function read80010003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_GET_BASEINFO
	dataTable["messageName"] = "BASEID_GET_BASEINFO"

	--UserID  用户ID
	dataTable["UserID"] = nMBaseMessage:readInt()
	--Common.log("read80010003 == 用户ID = " .. dataTable["UserID"])
	--NickName  昵称
	dataTable["NickName"] = nMBaseMessage:readString()
	--Common.log("昵称 = " .. dataTable["NickName"])
	--Sex  性别
	dataTable["Sex"] = nMBaseMessage:readByte()
	--Common.log("性别 = " .. dataTable["Sex"])
	--Age  年龄
	dataTable["Age"] = nMBaseMessage:readByte()
	--Common.log("年龄 = " .. dataTable["Age"])
	--City  城市
	dataTable["City"] = nMBaseMessage:readString()
	--Common.log("城市 = " .. dataTable["City"])
	--PhotoUrl  头像URL
	dataTable["PhotoUrl"] = nMBaseMessage:readString()

	--Common.log("头像URL = " .. dataTable["PhotoUrl"])
	--sign  个性签名
	dataTable["sign"] = nMBaseMessage:readString()
	--Common.log("个性签名 = " .. dataTable["sign"])
	--Coin  金币
	dataTable["Coin"] = nMBaseMessage:readLong()
	--Common.log("read80010003 金币 = " .. dataTable["Coin"])
	--yuanBao  元宝
	dataTable["yuanBao"] = nMBaseMessage:readInt()
	--Common.log("元宝 = " .. dataTable["yuanBao"])
	--Honor  荣誉值
	dataTable["Honor"] = nMBaseMessage:readInt()
	--Common.log("荣誉值 = " .. dataTable["Honor"])
	--DuiJiangQuan  兑奖券
	dataTable["DuiJiangQuan"] = nMBaseMessage:readInt()
	--Common.log("兑奖券 = " .. dataTable["DuiJiangQuan"])
	--commendationCnt  奖状数
	dataTable["commendationCnt"] = nMBaseMessage:readInt()
	--Common.log("奖状数 = " .. dataTable["commendationCnt"])
	--VipLevel  VIP等级
	dataTable["VipLevel"] = nMBaseMessage:readInt()
	--Common.log("VIP等级 = " .. dataTable["VipLevel"])
	--djqPieces  兑奖券碎片
	dataTable["djqPieces"] = nMBaseMessage:readInt()
	--Common.log("兑奖券碎片 = " .. dataTable["djqPieces"])
	return dataTable
end

--[[-- 解析修改基本信息]]
function read80010004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_EDIT_BASEINFO
	dataTable["messageName"] = "BASEID_EDIT_BASEINFO"

	--Result  修改结果
	dataTable["Result"] = nMBaseMessage:readByte()
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("修改个人信息返回 = " .. dataTable["ResultTxt"])
	return dataTable
end


--[[-- 解析获取弹出公告消息]]
function read80010011(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_V2_GET_POP_NOTICE
	dataTable["messageName"] = "BASEID_V2_GET_POP_NOTICE"

	--GameID  游戏ID
	dataTable["GameID"] = nMBaseMessage:readByte()
	--PopNoticeID  消息ID
	dataTable["PopNoticeID"] = nMBaseMessage:readInt()
	--Content  弹出内容
	dataTable["Content"] = nMBaseMessage:readString()
	--Title  弹出框标题
	dataTable["Title"] = nMBaseMessage:readString()
	--Position  弹出位置
	dataTable["Position"] = nMBaseMessage:readByte()
	--IslogoutPop  是否为退出弹出框
	dataTable["IslogoutPop"] = nMBaseMessage:readByte()
	--IsPush  是否为推送
	dataTable["IsPush"] = nMBaseMessage:readByte()

	dataTable["time"] = nMBaseMessage:readLong()

	return dataTable
end

--[[-- 解析取出兑奖信息]]
function read80010006(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_GET_AWARD
	dataTable["messageName"] = "BASEID_GET_AWARD"

	--result  请求结果
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("请求结果 = " .. dataTable["result"])
	--ResultTxt  提示语内容
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("提示语内容 = " .. dataTable["ResultTxt"])
	--RealName  真实姓名
	dataTable["RealName"] = nMBaseMessage:readString()
	--Common.log("真实姓名 = " .. dataTable["RealName"])
	--Tel  手机
	dataTable["Tel"] = nMBaseMessage:readString()
	--Common.log("手机 = " .. dataTable["Tel"])
	--Address  地址
	dataTable["Address"] = nMBaseMessage:readString()
	--Common.log("地址 = " .. dataTable["Address"])
	--PostCode  邮编
	dataTable["PostCode"] = nMBaseMessage:readString()
	--Common.log("邮编 = " .. dataTable["PostCode"])
	--IDCard  身份证
	dataTable["IDCard"] = nMBaseMessage:readString()
	--Common.log("身份证 = " .. dataTable["IDCard"])
	return dataTable
end

--[[-- 解析同步客户端时间]]
function read8001000d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_TIMESTAMP_SYNC
	dataTable["messageName"] = "BASEID_TIMESTAMP_SYNC"

	--TimeStamp  服务器当前时间戳
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	return dataTable
end

--[[-- 解析版本检测]]
function read8001000c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_PLAT_VERSION
	dataTable["messageName"] = "BASEID_PLAT_VERSION"

	Common.closeProgressDialog();
	dataTable["VersionData"] = {}

	-- apkVerCnt byte APK数量
	local apkCnt = nMBaseMessage:readInt()
	for i = 1, apkCnt do
		dataTable["VersionData"][i] = {}

		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- …apkName Text APK包名 例如package="com.tongqu.client.platform"
		dataTable["VersionData"][i].gameName = nMBaseMessage:readString()
		-- …apkVerCode Int APK版本号
		dataTable["VersionData"][i].packageVerCode = nMBaseMessage:readInt()
		-- …updateType byte 升级方案0不升级1建议升级2强制升级3需要安装
		dataTable["VersionData"][i].updateType = nMBaseMessage:readByte()
		-- …updataTxt Text 升级提示
		dataTable["VersionData"][i].updateTxt = nMBaseMessage:readString()
		-- …apkUpdateUrl Text 升级Url地址
		dataTable["VersionData"][i].updateUrl = nMBaseMessage:readString()
		-- …notificationTxt Text 通知栏文字
		dataTable["VersionData"][i].NotificationTxt = nMBaseMessage:readString()
		-- …updataAwardTxt Text 升级奖励文字 HTML
		dataTable["VersionData"][i].updataAwardTxt = nMBaseMessage:readString()
		-- …updataAppSizeTxt Text 升级包版本大小说明 HTML
		dataTable["VersionData"][i].updateAppSizeTxt = nMBaseMessage:readString()

		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

------------------------------------------------------------------
--[[-----------------------GIFTBAGID礼包消息----------------------]]
------------------------------------------------------------------

--[[--
解析获取用户充值信息
-- ]]
function read80510001(nMBaseMessage)
	--Common.log("read80510001")
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_USER_ENCHARGE_INFO
	dataTable["messageName"] = "GIFTBAGID_USER_ENCHARGE_INFO"
	--EnchargeAmount int 充值总金额
	dataTable["EnchargeAmount"] = nMBaseMessage:readInt();

	return dataTable
end

--[[--
--
-- 解析通用礼包请求消息
--
-- ]]
function read80510003(nMBaseMessage)
	--    Pub.closeProgressDialog();
	--此协议只有在所请求的礼包不可购买的时候才会回复/可购买时返回3.8.4或3.8.5
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_REQUIRE_GIFTBAG
	dataTable["messageName"] = "GIFTBAGID_REQUIRE_GIFTBAG"
	-- GiftBagType int 礼包类别ID，此礼包不可购买
	dataTable["giftBagType"] = nMBaseMessage:readInt();
	--Common.log("giftBagType = "..dataTable["giftBagType"])
	return dataTable
end

--[[--
-- 解析推送双核礼包
]]
function read80510005(nMBaseMessage)
	--Common.log("解析推送双核礼包********************")
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_PUSH_DUAL_GIFTBAG
	dataTable["messageName"] = "GIFTBAGID_PUSH_DUAL_GIFTBAG"

	-- GiftBagType int 礼 包 类 别 ID
	dataTable["mGiftBagType"] = nMBaseMessage:readInt();
	-- BannerUrl Text banner 图 片 地 址
	dataTable["BannerUrl"] = nMBaseMessage:readString();
	-- TitleText Text 标 题 文 本
	dataTable["TitleText"] = nMBaseMessage:readString();
	-- GiftAwardNum Byte 礼 包 中 物 品 个 数
	local mnGiftAwardNum = nMBaseMessage:readInt()

	dataTable["GiftBagData"] = {}
	for i = 1, mnGiftAwardNum do
		dataTable["GiftBagData"][i] = {}

		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- … GiftBagType int 礼 包 类 别 ID
		dataTable["GiftBagData"][i].mnGiftBagType = dataTable["mGiftBagType"];
		-- … GiftID int 礼 包 ID
		dataTable["GiftBagData"][i].mnGiftID = nMBaseMessage:readInt();
		-- … GiftName Text 礼 包 名 称
		dataTable["GiftBagData"][i].msGiftName = nMBaseMessage:readString();
		-- … GiftPrice int 礼 包 价 格 ( 元)
		dataTable["GiftBagData"][i].mnGiftPriceRMB = nMBaseMessage:readInt();
		-- … GiftPrice int 礼 包 价 格 ( 元)
		dataTable["GiftBagData"][i].mnGiftPriceYuanBao = nMBaseMessage:readInt();
		-- … GiftImageUrl Text 礼 包 banner 图 片 地 址
		dataTable["GiftBagData"][i].msGiftImageUrl = nMBaseMessage:readString();
		-- … ButtonText Text 按 钮 文 本
		dataTable["GiftBagData"][i].msTitleMsg = nMBaseMessage:readString();
		-- … BuyCount int 购 买 次 数
		dataTable["GiftBagData"][i].mnBuyCount = nMBaseMessage:readInt();

		nMBaseMessage:setReadPos(pos + length)
	end
	-- AllowTableShow byte 是 否 允 许 在 牌 桌 弹 出 1 :允 许 ， 0 :不 允 许
	dataTable["mnAllowTableShow"] = nMBaseMessage:readByte();
	-- PaymentType byte 支 付 类 型 1 :RMB ， 0 :元 宝
	dataTable["mnPaymentType"] = nMBaseMessage:readByte();
	-- RechargeMode	Byte	支付方式	0双按钮 1短代
	dataTable["RechargeMode"] = nMBaseMessage:readByte();
	--Common.log("dataTable[RechargeMode] === "..dataTable["RechargeMode"])

	return dataTable
end

--[[-- 解析使用元宝购买礼包]]
function read80510006(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_BUY_GIFTBAG
	dataTable["messageName"] = "GIFTBAGID_BUY_GIFTBAG"

	--result  是否成功1是0否
	dataTable["result"] = nMBaseMessage:readByte()
	--GiftBagType  礼包类别ID
	dataTable["GiftBagType"] = nMBaseMessage:readInt()
	--GiftID  礼包ID
	dataTable["GiftID"] = nMBaseMessage:readInt()
	--resultMsg
	dataTable["resultMsg"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 解析用户背包中新礼包状态]]
function read8051000b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_NEWGIFT_TYPE
	dataTable["messageName"] = "GIFTBAGID_NEWGIFT_TYPE"

	--result  是否有新礼包1是0否
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("是否有新礼包1是0否 = " .. dataTable["result"])
	return dataTable
end

--[[-- 解析用户可购买礼包列表]]
function read80510009(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_GIFTBAG_LIST
	dataTable["messageName"] = "GIFTBAGID_GIFTBAG_LIST"

	--GiftBagCnt  礼包数量
	dataTable["GiftBagData"] = {}
	local GiftBagCnt = nMBaseMessage:readInt()
	for i = 1, GiftBagCnt do
		dataTable["GiftBagData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("GiftBagData---length = " .. length)
		--…GiftBagType  礼包类别ID
		dataTable["GiftBagData"][i].GiftBagType = nMBaseMessage:readInt()
		--Common.log("GiftBagData---礼包类别ID = " .. dataTable["GiftBagData"][i].GiftBagType)
		--…Name  名称
		dataTable["GiftBagData"][i].Name = nMBaseMessage:readString()
		--Common.log("GiftBagData---名称 = " .. dataTable["GiftBagData"][i].Name)
		--…goodsType  商品类型
		dataTable["GiftBagData"][i].goodsType = nMBaseMessage:readByte()
		--Common.log("GiftBagData---商品类型 = " .. dataTable["GiftBagData"][i].goodsType)
		--…IconURL  图标url
		dataTable["GiftBagData"][i].IconURL = nMBaseMessage:readString()
		--Common.log("GiftBagData---图标url = " .. dataTable["GiftBagData"][i].IconURL)
		--…Description  描述
		dataTable["GiftBagData"][i].Description = nMBaseMessage:readString()
		--Common.log("GiftBagData---描述 = " .. dataTable["GiftBagData"][i].Description)
		nMBaseMessage:setReadPos(pos + length)
	end
	--VipGiftNum
	dataTable["VipGiftData"] = {}
	local VipGiftNum = nMBaseMessage:readInt()
	--Common.log("VipGiftData---VipGiftNum = " .. VipGiftNum)
	for i = 1, VipGiftNum do
		dataTable["VipGiftData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("VipGiftData---length = " .. length)
		--…VipGiftID  Vip礼包ID
		dataTable["VipGiftData"][i].VipGiftID = nMBaseMessage:readInt()
		--Common.log("VipGiftData---Vip礼包ID = " .. dataTable["VipGiftData"][i].VipGiftID)
		--…backpackName  背包显示名称
		dataTable["VipGiftData"][i].backpackName = nMBaseMessage:readString()
		--Common.log("VipGiftData---背包显示名称 = " .. dataTable["VipGiftData"][i].backpackName)
		--…Name  名称
		dataTable["VipGiftData"][i].Name = nMBaseMessage:readString()
		--Common.log("VipGiftData---名称 = " .. dataTable["VipGiftData"][i].Name)
		--…goodsType  商品类型
		dataTable["VipGiftData"][i].goodsType = nMBaseMessage:readByte()
		--Common.log("VipGiftData---商品类型 = " .. dataTable["VipGiftData"][i].goodsType)
		--…IconURL  图标url
		dataTable["VipGiftData"][i].IconURL = nMBaseMessage:readString()
		--Common.log("VipGiftData---图标url = " .. dataTable["VipGiftData"][i].IconURL)
		--…Title  标题
		dataTable["VipGiftData"][i].Title = nMBaseMessage:readString()
		--Common.log("VipGiftData---标题 = " .. dataTable["VipGiftData"][i].Title)
		--…Description  描述
		dataTable["VipGiftData"][i].Description = nMBaseMessage:readString()
		--Common.log("VipGiftData---描述 = " .. dataTable["VipGiftData"][i].Description)
		--…ConsumeType  消耗类型
		dataTable["VipGiftData"][i].ConsumeType = nMBaseMessage:readByte()
		--Common.log("VipGiftData---消耗类型 = " .. dataTable["VipGiftData"][i].ConsumeType)
		--…Consume  单价
		dataTable["VipGiftData"][i].Consume = nMBaseMessage:readInt()
		--Common.log("VipGiftData---单价 = " .. dataTable["VipGiftData"][i].Consume)
		--…statusTagUrl  状态标签url
		dataTable["VipGiftData"][i].statusTagUrl = nMBaseMessage:readString()
		--Common.log("VipGiftData---状态标签url = " .. dataTable["VipGiftData"][i].statusTagUrl)
		--…needVipMinLevel  购买所需的最小VIP等级
		dataTable["VipGiftData"][i].needVipMinLevel = nMBaseMessage:readInt()
		--Common.log("VipGiftData---购买所需的最小VIP等级 = " .. dataTable["VipGiftData"][i].needVipMinLevel)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析用户礼包状态]]
function read80510008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_GET_GIFTBAG_MSG
	dataTable["messageName"] = "GIFTBAGID_GET_GIFTBAG_MSG"

	--GiftBagCnt  礼包数量
	dataTable["GiftBagData"] = {}
	local GiftBagCnt = nMBaseMessage:readInt()
	for i = 1, GiftBagCnt do
		dataTable["GiftBagData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…GiftBagType  礼包类别ID
		dataTable["GiftBagData"][i].GiftBagType = nMBaseMessage:readInt()
		--…IsPayGift  是否可以购买此类礼包
		dataTable["GiftBagData"][i].IsPayGift = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end
	--RemainCount  当天剩余破产送金次数
	dataTable["RemainCount"] = nMBaseMessage:readByte()
	return dataTable
end

--[[-- 解析用户删除背包礼包列表]]
function read8051000a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_PUSH_DELBACKLIST
	dataTable["messageName"] = "GIFTBAGID_PUSH_DELBACKLIST"

	--GameID  游戏ID
	dataTable["GameID"] = nMBaseMessage:readByte()
	--GiftBagCnt  礼包数量
	dataTable["GiftBagData"] = {}
	local GiftBagCnt = nMBaseMessage:readInt()
	for i = 1, GiftBagCnt do
		dataTable["GiftBagData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…GiftBagType  礼包类别ID
		dataTable["GiftBagData"][i].GiftBagType = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析首充礼包图标是否显示]]
function read8051000d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_SHOW_FIRSTPAY_ICON
	dataTable["messageName"] = "GIFTBAGID_SHOW_FIRSTPAY_ICON"

	--Visible	byte	是否可见	1是 0否
	dataTable["Visible"] = nMBaseMessage:readByte()
	return dataTable
end

------------------------------------------------------------------
--[[-----------------------DBID数据库消息-------------------------]]
------------------------------------------------------------------

--[[--
--
-- 解析自己或他人的详细信息
--
-- ]]
function read80060002(nMBaseMessage)
	--Common.log("read80060002解析自己或他人的详细信息")
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_USER_INFO
	dataTable["messageName"] = "DBID_USER_INFO"
	-- UserID Int 用户ID
	dataTable["UserID"] = nMBaseMessage:readInt();
	--Common.log("用户ID：" .. dataTable["UserID"]);
	-- NickName text 昵称
	dataTable["NickName"] = nMBaseMessage:readString();
	--Common.log("昵称：" .. dataTable["NickName"]);
	-- Sex byte 性别 1男 2女
	dataTable["Sex"] = nMBaseMessage:readByte();
	-- Age byte 年龄
	dataTable["age"] = nMBaseMessage:readByte();
	-- City text 城市 如 :北京-海淀
	dataTable["city"] = nMBaseMessage:readString();
	-- PhotoUrl text 头像URL
	dataTable["photourl"] = nMBaseMessage:readString();
	-- Sign text 个性签名
	dataTable["sign"] = nMBaseMessage:readString();
	-- Coin long 金币
	dataTable["coin"] = nMBaseMessage:readLong();
	-- YuanBao int 元宝
	dataTable["yuanbao"] = nMBaseMessage:readInt();
	-- TaoJin int 荣誉值
	dataTable["honor"] = nMBaseMessage:readInt();
	-- GameID byte 游戏ID
	dataTable["gameid"] = nMBaseMessage:readByte();
	-- DuiJiangQuan int 兑奖券 MsgVer >= 1时发送
	dataTable["duijiang"] = nMBaseMessage:readInt();
	-- commendationCnt int 奖状数 MsgVer >= 1时发送
	dataTable["commendationCnt"] = nMBaseMessage:readInt();

	--byte数组
	--    byte[] data = getBytes();
	local length = nMBaseMessage:readShort();
	local pos = nMBaseMessage:getReadPos();

	-----------------------
	----- 接收游戏相关数据
	------------------------
	--GameID	GameID  UserID   MasterScore  Grade  Title
	dataTable["GameID"] = nMBaseMessage:readByte()
	--UserID	Int	用户ID
	dataTable["UserID"] = nMBaseMessage:readInt()
	--MasterScore	Int	大师分
	dataTable["MasterScore"] = nMBaseMessage:readInt()
	--Grade	Text	等级
	dataTable["Grade"] = nMBaseMessage:readString()
	--Title	Text	称号
	dataTable["Title"] = nMBaseMessage:readString()
	--WinRate	Byte	胜率
	dataTable["WinRate"] = nMBaseMessage:readByte()
	--EscapeRate	Byte	断线率
	dataTable["EscapeRate"] = nMBaseMessage:readByte()
	--duan	int	段位
	dataTable["duan"] = nMBaseMessage:readInt()
	--rank	int	等级
	dataTable["rank"] = nMBaseMessage:readInt()
	--Common.log("rank = "..dataTable["rank"])
	--score	int	天梯分
	dataTable["score"] = nMBaseMessage:readInt()
	--Common.log("score = "..dataTable["score"])
	--nextScore	int	下一等级需要的天梯分
	dataTable["nextScore"] = nMBaseMessage:readInt()
	--Common.log("titnti===1".."=="..dataTable["score"].."==="..dataTable["nextScore"].."=="..dataTable["duan"])
	--salary	int	工资
	dataTable["salary"] = nMBaseMessage:readInt()
	--isSalary	Byte	是否领过工资	1没领过 0领过 2没有资格
	dataTable["isSalary"] = nMBaseMessage:readByte()
	--InitScore	int	当前段初始天梯分
	dataTable["InitScore"] = nMBaseMessage:readInt()
	--Round	int	当前局数
	dataTable["Round"] = nMBaseMessage:readInt()
	--LadderTitleUrl	Text	天梯称号网址
	dataTable["LadderTitleUrl"] = nMBaseMessage:readString()
	--LadderRanking	Int	天梯排名LadderRanking
	dataTable["LadderRanking"] = nMBaseMessage:readInt()

	nMBaseMessage:setReadPos(pos + length)

	--VipLevel int VIP等级
	dataTable["mnVipLevel"] = nMBaseMessage:readInt();
	--Common.log("read80060002 mnVipLevel = "..dataTable["mnVipLevel"])
	--LawLimitRemind text 法律风险相关提示语 亲，您今天已经累计输掉3000万金币了，达到单日上限，无法继续游戏了。
	dataTable["lawLimitRemind"] = nMBaseMessage:readString();
	--DjqPieces int 兑奖券碎片数量
	dataTable["djqPieces"] = nMBaseMessage:readInt();
	--HistoryMaxCoin long 历史最高金币数
	dataTable["historyMaxCoin"] = nMBaseMessage:readLong();
	dataTable["BirthDay"] = nMBaseMessage:readString()
	--Common.log("read80060002 == 生日 = " .. dataTable["BirthDay"])

	return dataTable
end


--[[-- 解析背包物品列表]]
function read80060045(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_BACKPACK_LIST
	dataTable["messageName"] = "DBID_BACKPACK_LIST"

	--Num  背包中物品数量
	dataTable["BackPackData"] = {}
	local Num = nMBaseMessage:readInt()
	for i = 1, Num do
		dataTable["BackPackData"][i] = {}
		--…ID  物品ID
		dataTable["BackPackData"][i].ID = nMBaseMessage:readInt()
		--Common.log("ID = "..dataTable["BackPackData"][i].ID)

		--…itemNum  物品数量
		dataTable["BackPackData"][i].itemNum = nMBaseMessage:readInt()
		--Common.log("itemNum = "..dataTable["BackPackData"][i].itemNum)

		--…backpackName  背包显示名称
		dataTable["BackPackData"][i].backpackName = nMBaseMessage:readString()
		--Common.log("backpackName = "..dataTable["BackPackData"][i].backpackName)

		--…Name  名称
		dataTable["BackPackData"][i].Name = nMBaseMessage:readString()
		--Common.log("read80060045 == Name=== " .. dataTable["BackPackData"][i].Name);
		--…goodsType  商品类型
		dataTable["BackPackData"][i].goodsType = nMBaseMessage:readByte()
		--…goodsProperty  属性 0时效行，1数量型
		dataTable["BackPackData"][i].goodsProperty = nMBaseMessage:readByte()
		--…IconURL  图标url
		dataTable["BackPackData"][i].IconURL = nMBaseMessage:readString()
		--…Title  标题
		dataTable["BackPackData"][i].Title = nMBaseMessage:readString()
		--…Description  描述
		dataTable["BackPackData"][i].Description = nMBaseMessage:readString()
		--Common.log("read80060045 == Description=== " .. dataTable["BackPackData"][i].Description);
		--…PurchaseLowerLimit  购买数量下限
		dataTable["BackPackData"][i].PurchaseLowerLimit = nMBaseMessage:readInt()
		--…PurchaseUpperLimit  购买数量上限
		dataTable["BackPackData"][i].PurchaseUpperLimit = nMBaseMessage:readInt()
		--…ConsumeType  消耗类型
		dataTable["BackPackData"][i].ConsumeType = nMBaseMessage:readByte()
		--…Consume  单价
		dataTable["BackPackData"][i].Consume = nMBaseMessage:readInt()
		--…VipConsume  Vip单价
		dataTable["BackPackData"][i].VipConsume = nMBaseMessage:readInt()
		--…statusTagUrl  状态标签url
		dataTable["BackPackData"][i].statusTagUrl = nMBaseMessage:readString()
		--…VipUpperLimit  Vip时效上限
		dataTable["BackPackData"][i].VipUpperLimit = nMBaseMessage:readInt()
		--Common.log("VipUpperLimit = "..dataTable["BackPackData"][i].VipUpperLimit)

		--…backpackUpperLimit  背包存储上限
		dataTable["BackPackData"][i].backpackUpperLimit = nMBaseMessage:readInt()
	end
	--VipNum  Vip数量
	dataTable["VipDiscountData"] = {}
	local VipNum = nMBaseMessage:readInt()
	for i = 1, VipNum do
		dataTable["VipDiscountData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("VipDiscountData---length = " .. length)
		--…vipLevel  Vip等级
		dataTable["VipDiscountData"][i].vipLevel = nMBaseMessage:readInt()
		--Common.log("VipDiscountData---Vip等级 = " .. dataTable["VipDiscountData"][i].vipLevel)
		--…vipDiscount  Vip折扣
		dataTable["VipDiscountData"][i].vipDiscount = nMBaseMessage:readInt()
		--Common.log("VipDiscountData---Vip折扣 = " .. dataTable["VipDiscountData"][i].vipDiscount)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析背包商品数量]]
function read80060049(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_BACKPACK_GOODS_COUNT
	dataTable["messageName"] = "DBID_BACKPACK_GOODS_COUNT"

	--Type  0时效型 1数量型
	dataTable["Type"] = nMBaseMessage:readByte()
	--Common.log("0时效型 1数量型 = " .. dataTable["Type"])
	--Num  时效型单位（秒）,数量型单位（个）
	dataTable["Num"] = nMBaseMessage:readLong()
	--Common.log("时效型单位（秒）,数量型单位（个） = " .. dataTable["Num"])
	--ItemID  商品类型ID
	dataTable["ItemID"] = nMBaseMessage:readInt()
	--Common.log("商品类型ID = " .. dataTable["ItemID"])
	return dataTable
end

--[[-- 解析得到短信通道号码]]
function read80060031(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_GET_SMS_NUMBER
	dataTable["messageName"] = "DBID_GET_SMS_NUMBER"

	--NumberCnt  上行目标号码数量
	dataTable["NumberTable"] = {}
	local NumberCnt = nMBaseMessage:readByte()
	for i = 1, NumberCnt do
		dataTable["NumberTable"][i] = {}
		--…SmsNumber
		dataTable["NumberTable"][i].SmsNumber = nMBaseMessage:readString()
		--Common.log("NumberTable--- = " .. dataTable["NumberTable"][i].SmsNumber)
	end
	--MoblieNumber  绑定的手机号
	dataTable["MoblieNumber"] = nMBaseMessage:readString()
	--Common.log("绑定的手机号 = " .. dataTable["MoblieNumber"])
	return dataTable
end

--[[-- 解析兑换列表]]
function read80060046(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_EXCHANGE_LIST
	dataTable["messageName"] = "DBID_EXCHANGE_LIST"
	--Timestamp
	dataTable["Timestamp"] = nMBaseMessage:readLong()
	--Common.log(" = " .. dataTable["Timestamp"])
	--Num
	dataTable["GoodsData"] = {}
	local Num = nMBaseMessage:readInt()
	for i = 1, Num do
		dataTable["GoodsData"][i] = {}
		--…ID
		dataTable["GoodsData"][i].ID = nMBaseMessage:readInt()
		--Common.log("GoodsData---ID= " .. dataTable["GoodsData"][i].ID)
		--…Name  名称
		dataTable["GoodsData"][i].Name = nMBaseMessage:readString()
		--Common.log("GoodsData---名称 = " .. dataTable["GoodsData"][i].Name)
		--…goodsType  商品类型
		dataTable["GoodsData"][i].goodsType = nMBaseMessage:readByte()
		--Common.log("GoodsData---商品类型 = " .. dataTable["GoodsData"][i].goodsType)
		--…IconURL  图标url
		dataTable["GoodsData"][i].IconURL = nMBaseMessage:readString()
		--Common.log("GoodsData---图标url = " .. dataTable["GoodsData"][i].IconURL)
		--…Title  标题
		dataTable["GoodsData"][i].Title = nMBaseMessage:readString()
		--Common.log("GoodsData---标题 = " .. dataTable["GoodsData"][i].Title)
		--…Description  描述
		dataTable["GoodsData"][i].Description = nMBaseMessage:readString()
		--Common.log("GoodsData---描述 = " .. dataTable["GoodsData"][i].Description)
		--…PurchaseLowerLimit  购买数量下限
		dataTable["GoodsData"][i].PurchaseLowerLimit = nMBaseMessage:readInt()
		--Common.log("GoodsData---购买数量下限 = " .. dataTable["GoodsData"][i].PurchaseLowerLimit)
		--…PurchaseUpperLimit  购买数量上限
		dataTable["GoodsData"][i].PurchaseUpperLimit = nMBaseMessage:readInt()
		--Common.log("GoodsData---购买数量上限 = " .. dataTable["GoodsData"][i].PurchaseUpperLimit)
		--…ConsumeType  消耗类型
		dataTable["GoodsData"][i].ConsumeType = nMBaseMessage:readByte()
		--Common.log("GoodsData---消耗类型 = " .. dataTable["GoodsData"][i].ConsumeType)
		--…Consume  单价
		dataTable["GoodsData"][i].Consume = nMBaseMessage:readInt()
		--Common.log("GoodsData---单价 = " .. dataTable["GoodsData"][i].Consume)
		--…VipConsume  Vip单价
		dataTable["GoodsData"][i].VipConsume = nMBaseMessage:readInt()
		--Common.log("GoodsData---Vip单价 = " .. dataTable["GoodsData"][i].VipConsume)
		--…operationTagUrl  运营标签url
		dataTable["GoodsData"][i].operationTagUrl = nMBaseMessage:readString()
		--Common.log("GoodsData---运营标签url = " .. dataTable["GoodsData"][i].operationTagUrl)
		--…exchangeCoin  兑换金币数
		dataTable["GoodsData"][i].exchangeCoin = nMBaseMessage:readInt()
		--Common.log("GoodsData---兑换金币数 = " .. dataTable["GoodsData"][i].exchangeCoin)
	end
	return dataTable
end

--[[-- 解析服务器列表]]
function read60032(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = REQ + DBID_SERVER_LIST
	dataTable["messageName"] = "DBID_SERVER_LIST"

	--EnableServerCnt  可用的服务器数量
	dataTable["EnableServerTable"] = {}
	local EnableServerCnt = nMBaseMessage:readShort()
	for i = 1, EnableServerCnt do
		dataTable["EnableServerTable"][i] = {}
		--…EnableServerIP  可用的服务器地址
		dataTable["EnableServerTable"][i].EnableServerIP = nMBaseMessage:readString()
		--Common.log("EnableServerTable---可用的服务器地址 = " .. dataTable["EnableServerTable"][i].EnableServerIP)
	end
	--DisableServerCnt  停用的服务器数量
	dataTable["DisableServerTable"] = {}
	local DisableServerCnt = nMBaseMessage:readShort()
	for i = 1, DisableServerCnt do
		dataTable["DisableServerTable"][i] = {}
		--…DisableServerIP  停用的服务器地址
		dataTable["DisableServerTable"][i].DisableServerIP = nMBaseMessage:readString()
		--Common.log("DisableServerTable---停用的服务器地址 = " .. dataTable["DisableServerTable"][i].DisableServerIP)
	end
	return dataTable
end

--[[-- 解析购买商品]]
function read80060047(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_PAY_GOODS
	dataTable["messageName"] = "DBID_PAY_GOODS"

	--isVIp  1是0否
	dataTable["isVIp"] = nMBaseMessage:readByte()
	--Common.log("1是0否 = " .. dataTable["isVIp"])
	--result  是否成功1是0否
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("是否成功1是0否 = " .. dataTable["result"])
	--resultMsg
	dataTable["resultMsg"] = nMBaseMessage:readString()
	--Common.log(" 是否成功1是0否 =消息 " .. dataTable["resultMsg"])
	--ItemID
	dataTable["ItemID"] = nMBaseMessage:readInt()
	--Common.log(" = " .. dataTable["ItemID"])
	return dataTable
end

--[[-- 解析获取服务器通用配置]]
function read8006004f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_GET_SERVER_CONFIG
	dataTable["messageName"] = "DBID_GET_SERVER_CONFIG"

	--VarCnt  变量数目
	dataTable["ConfigValueData"] = {}
	local VarCnt = nMBaseMessage:readInt()
	for i = 1, VarCnt do
		dataTable["ConfigValueData"][i] = {}
		--…VarValue  变量值
		dataTable["ConfigValueData"][i].VarValue = nMBaseMessage:readString()
	end
	return dataTable
end

--[[-- 解析获取修改昵称的次数]]
function read80060050(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_GET_NICKNAME_MODIFY_TIMES
	dataTable["messageName"] = "DBID_GET_NICKNAME_MODIFY_TIMES"

	--ModifyTimes  修改昵称的次数
	dataTable["ModifyTimes"] = nMBaseMessage:readInt()
	--Common.log("修改昵称的次数 = " .. dataTable["ModifyTimes"])
	return dataTable
end

--[[-- 解析获取指定商品详情（可多个）]]
function read80060052(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_MALL_GOODS_DETAIL
	dataTable["messageName"] = "DBID_MALL_GOODS_DETAIL"

	--Num
	dataTable["GoodsData"] = {}
	local Num = nMBaseMessage:readInt()
	for i = 1, Num do
		dataTable["GoodsData"][i] = {}
		--…ID
		dataTable["GoodsData"][i].ID = nMBaseMessage:readInt()
		--Common.log("GoodsData--- = " .. dataTable["GoodsData"][i].ID)
		--…Name  名称
		dataTable["GoodsData"][i].Name = nMBaseMessage:readString()
		--Common.log("GoodsData---名称 = " .. dataTable["GoodsData"][i].Name)
		--…gameType  所属游戏
		dataTable["GoodsData"][i].gameType = nMBaseMessage:readByte()
		--Common.log("GoodsData---所属游戏 = " .. dataTable["GoodsData"][i].gameType)
		--…goodsType  商品类型
		dataTable["GoodsData"][i].goodsType = nMBaseMessage:readByte()
		--Common.log("GoodsData---商品类型 = " .. dataTable["GoodsData"][i].goodsType)
		--…IconURL  图标url
		dataTable["GoodsData"][i].IconURL = nMBaseMessage:readString()
		--Common.log("GoodsData---图标url = " .. dataTable["GoodsData"][i].IconURL)
		--…Title  标题
		dataTable["GoodsData"][i].Title = nMBaseMessage:readString()
		--Common.log("GoodsData---标题 = " .. dataTable["GoodsData"][i].Title)
		--…Description  描述
		dataTable["GoodsData"][i].Description = nMBaseMessage:readString()
		--Common.log("GoodsData---描述 = " .. dataTable["GoodsData"][i].Description)
		--…PurchaseLowerLimit  购买数量下限
		dataTable["GoodsData"][i].PurchaseLowerLimit = nMBaseMessage:readInt()
		--Common.log("GoodsData---购买数量下限 = " .. dataTable["GoodsData"][i].PurchaseLowerLimit)
		--…PurchaseUpperLimit  购买数量上限
		dataTable["GoodsData"][i].PurchaseUpperLimit = nMBaseMessage:readInt()
		--Common.log("GoodsData---购买数量上限 = " .. dataTable["GoodsData"][i].PurchaseUpperLimit)
		--…ConsumeType  消耗类型
		dataTable["GoodsData"][i].ConsumeType = nMBaseMessage:readByte()
		--Common.log("GoodsData---消耗类型 = " .. dataTable["GoodsData"][i].ConsumeType)
		--…Consume  单价
		dataTable["GoodsData"][i].Consume = nMBaseMessage:readInt()
		--Common.log("GoodsData---单价 = " .. dataTable["GoodsData"][i].Consume)
		--…VipConsume  Vip单价
		dataTable["GoodsData"][i].VipConsume = nMBaseMessage:readInt()
		--Common.log("GoodsData---Vip单价 = " .. dataTable["GoodsData"][i].VipConsume)
		--…operationTagUrl  运营标签url
		dataTable["GoodsData"][i].operationTagUrl = nMBaseMessage:readString()
		--Common.log("GoodsData---运营标签url = " .. dataTable["GoodsData"][i].operationTagUrl)
	end
	return dataTable
end

--[[-- 解析商城商品列表]]
function read80060044(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_MALL_GOODS_LIST
	dataTable["messageName"] = "DBID_MALL_GOODS_LIST"

	--Timestamp
	dataTable["Timestamp"] = nMBaseMessage:readLong()
	--Num
	dataTable["GoodsTable"] = {}
	local Num = nMBaseMessage:readInt()
	--Common.log("GoodsTable---- = Num" .. Num)
	for i = 1, Num do
		dataTable["GoodsTable"][i] = {}
		--…ID
		dataTable["GoodsTable"][i].ID = nMBaseMessage:readInt()
		--Common.log("GoodsTable--- = " .. dataTable["GoodsTable"][i].ID)
		--…Name  名称
		dataTable["GoodsTable"][i].Name = nMBaseMessage:readString()
		--Common.log("GoodsTable---名称 = " .. dataTable["GoodsTable"][i].Name)
		--…gameType  所属游戏
		dataTable["GoodsTable"][i].gameType = nMBaseMessage:readByte()
		--Common.log("GoodsTable---所属游戏 = " .. dataTable["GoodsTable"][i].gameType)
		--…goodsType  商品类型
		dataTable["GoodsTable"][i].goodsType = nMBaseMessage:readByte()
		--Common.log("GoodsTable---商品类型 = " .. dataTable["GoodsTable"][i].goodsType)
		--…IconURL  图标url
		dataTable["GoodsTable"][i].IconURL = nMBaseMessage:readString()
		--Common.log("GoodsTable---图标url = " .. dataTable["GoodsTable"][i].IconURL)
		--…Title  标题
		dataTable["GoodsTable"][i].Title = nMBaseMessage:readString()
		--Common.log("GoodsTable---标题 = " .. dataTable["GoodsTable"][i].Title)
		--…Description  描述
		dataTable["GoodsTable"][i].Description = nMBaseMessage:readString()
		--Common.log("GoodsTable---描述 = " .. dataTable["GoodsTable"][i].Description)
		--…PurchaseLowerLimit  购买数量下限
		dataTable["GoodsTable"][i].PurchaseLowerLimit = nMBaseMessage:readInt()
		--Common.log("GoodsTable---购买数量下限 = " .. dataTable["GoodsTable"][i].PurchaseLowerLimit)
		--…PurchaseUpperLimit  购买数量上限
		dataTable["GoodsTable"][i].PurchaseUpperLimit = nMBaseMessage:readInt()
		--Common.log("GoodsTable---购买数量上限 = " .. dataTable["GoodsTable"][i].PurchaseUpperLimit)
		--…ConsumeType  消耗类型
		dataTable["GoodsTable"][i].ConsumeType = nMBaseMessage:readByte()
		--Common.log("GoodsTable---消耗类型 = " .. dataTable["GoodsTable"][i].ConsumeType)
		--…Consume  单价
		dataTable["GoodsTable"][i].Consume = nMBaseMessage:readInt()
		--Common.log("GoodsTable---单价 = " .. dataTable["GoodsTable"][i].Consume)
		--…VipConsume  Vip单价
		dataTable["GoodsTable"][i].VipConsume = nMBaseMessage:readInt()
		--Common.log("GoodsTable---Vip单价 = " .. dataTable["GoodsTable"][i].VipConsume)
		--…operationTagUrl  运营标签url
		dataTable["GoodsTable"][i].operationTagUrl = nMBaseMessage:readString()
		--Common.log("GoodsTable---运营标签url = " .. dataTable["GoodsTable"][i].operationTagUrl)
	end
	--VipNum  Vip数量
	dataTable["VipDiscountTable"] = {}
	local VipNum = nMBaseMessage:readInt()
	for i = 1, VipNum do
		dataTable["VipDiscountTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("VipDiscountTable---length = " .. length)
		--…vipLevel  Vip等级
		dataTable["VipDiscountTable"][i].vipLevel = nMBaseMessage:readInt()
		--Common.log("VipDiscountTable---Vip等级 = " .. dataTable["VipDiscountTable"][i].vipLevel)
		--…vipDiscount  Vip折扣
		dataTable["VipDiscountTable"][i].vipDiscount = nMBaseMessage:readInt()
		--Common.log("VipDiscountTable---Vip折扣 = " .. dataTable["VipDiscountTable"][i].vipDiscount)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[--充值结果通知]]
function read8006005b(nMBaseMessage)

	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_RECHARGE_RESULT_NOTIFICATION
	dataTable["messageName"] = "DBID_RECHARGE_RESULT_NOTIFICATION"
	--充值结果类型0：失败 1：购买金币成功2：购买元宝成功3：购买礼包成功
	dataTable["result"] = nMBaseMessage:readByte()
	--本次充值元宝数量
	dataTable["yuanbaoCount"] = nMBaseMessage:readInt()
	--充值结果提示语
	dataTable["resultMsg"] = nMBaseMessage:readString()
	--是否短代充值  0：非短代 1：短代
	dataTable["isSmsRecharge"] = nMBaseMessage:readByte()
	--当前VIP等级
	dataTable["newVipLevel"] = nMBaseMessage:readInt()
	--充值引导ID
	dataTable["rechargeID"] = nMBaseMessage:readInt()
	--Giftype	Int	礼包类型
	dataTable["Giftype"] = nMBaseMessage:readInt()
	--price	int	人民币价格（分）	单位：分
	dataTable["price"] = nMBaseMessage:readInt()
	--IsGift	byte	是否为礼包	0不是，1是礼包
	dataTable["IsGift"] = nMBaseMessage:readByte()
	--IsExchange	byte	是否兑换金币
	dataTable["IsExchange"] = nMBaseMessage:readByte()

	return dataTable
end

--[[-- 解析通过昵称发送消息]]
function read80060017(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_SEND_MSG_NICKNAME
	dataTable["messageName"] = "DBID_V2_SEND_MSG_NICKNAME"

	--Result  结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--ResultTxt  失败原因
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("ResultTxt============"..dataTable["ResultTxt"])
	return dataTable
end

--[[-- 解析找回密码]]
function read8006000c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_FIND_PASSWORD
	dataTable["messageName"] = "DBID_FIND_PASSWORD"

	--Result  是否成功
	dataTable["Result"] = nMBaseMessage:readByte()
	--ResultTxt  结果提示语
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--NewPassword  新密码
	dataTable["NewPassword"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 解析进入聊天室]]
function read80050001(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_ENTER_CHAT_ROOM
	dataTable["messageName"] = "IMID_ENTER_CHAT_ROOM"

	--ResultID   结果。 0成功 1失败
	dataTable["ResultID"] = nMBaseMessage:readByte()
	--ResultText  结果文本内容
	dataTable["ResultText"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 解析聊天室发言]]
function read80050003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_CHAT_ROOM_SPEAK
	dataTable["messageName"] = "IMID_CHAT_ROOM_SPEAK"

	--SpeakerUserID  发言者用户ID
	dataTable["SpeakerUserID"] = nMBaseMessage:readInt()
	--SpeakerNickName  发言者昵称
	dataTable["SpeakerNickName"] = nMBaseMessage:readString()
	--SpeechText  发言内容
	dataTable["SpeechText"] = nMBaseMessage:readString()
	--Color  ARGB方式存储。可用4个getByte()分别读取
	dataTable["ARGB0"] = nMBaseMessage:readByte()
	dataTable["ARGB1"] = nMBaseMessage:readByte()
	dataTable["ARGB2"] = nMBaseMessage:readByte()
	dataTable["ARGB3"] = nMBaseMessage:readByte()
	--TextSize  字体大小
	dataTable["TextSize"] = nMBaseMessage:readInt()
	--vip等级
	dataTable["VipLevel"] = nMBaseMessage:readInt()
	--ActionInT
	dataTable["ActionId"] = nMBaseMessage:readInt()
	--ActionString
	dataTable["ActionParam"] = nMBaseMessage:readInt()
	return dataTable
end

--[[-- 解析显示聊天室当前最新消息]]
function read80050005(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_GET_LAST_CHAT_ROOM_SPEAK
	dataTable["messageName"] = "IMID_GET_LAST_CHAT_ROOM_SPEAK"

	--SpeechText  当前最新的发言内容
	dataTable["SpeechText"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 屏蔽举报某玩家聊天]]
function read80050007(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_OPERATE_CHAT_USER_TYPE
	dataTable["messageName"] = "IMID_OPERATE_CHAT_USER_TYPE"

	--result	byte	操作结果	0：成功  1：失败
	dataTable["byte"] = nMBaseMessage:readByte()
	--resultMsg	text	结果提示语
	dataTable["resultMsg"] = nMBaseMessage:readString()
	return dataTable
end

--[[--
--获取小游戏发送的消息
--]]
function read8005000a(nMBaseMessage)
	local dataTable = {}
	--	--Common.log("read8005000a----------------")
	dataTable["messageType"] = ACK + IMID_MINI_SEND_MESSAGE
	dataTable["messageName"] = "IMID_MINI_SEND_MESSAGE"
	--SenderNickname	Text	发送者昵称
	dataTable["SenderNickname"] = nMBaseMessage:readString()
	--MessageContent	Text	消息内容
	dataTable["MessageContent"] = nMBaseMessage:readString()
	--Result	Byte	结果	0 失败 1成功
	dataTable["Result"] = nMBaseMessage:readByte()
	--ResultTxt	Text	失败原因
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	return dataTable
end


--[[-----------------------小游戏打赏模块 AWARDS 消息----------------------]]
--[[--
--解析小游戏打赏基本信息(MINI_REWARDS_BASEINFO)
--]]
function read8005000b(nMBaseMessage)
	--	--Common.log("read8005000b----------------")
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_MINI_REWARDS_BASEINFO
	dataTable["messageName"] = "IMID_MINI_REWARDS_BASEINFO"

	--	PromptOne Text 打赏第一条提示语
	dataTable["PromptOne"] = nMBaseMessage:readString()
	--	PromptTwo Text 打赏第二条提示语
	dataTable["PromptTwo"] = nMBaseMessage:readString()
	--	RewardLevel	Int	赢多少钱可以打赏
	dataTable["RewardLevel"] = nMBaseMessage:readInt()
	--Common.log("dataTable.RewardLevel = "..dataTable.RewardLevel)
	--	RewardMsg	Loop	打赏基本信息
	dataTable["RewardMsg"] = {}

	local RewardMsg = nMBaseMessage:readInt()
	for i = 1, RewardMsg do
		dataTable["RewardMsg"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--		…RewardType	Byte	红包类型
		dataTable["RewardMsg"][i].RewardType = nMBaseMessage:readByte()
		--		…RewardInfo	Text	红包提示
		dataTable["RewardMsg"][i].RewardInfo = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--Common.log("dataTable[RewardMsg] = "..#dataTable["RewardMsg"])
	return dataTable
end

--[[--
--解析小游戏打赏(MINI_REWARDS_RESULT)
--]]
function read8005000c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_MINI_REWARDS_RESULT
	dataTable["messageName"] = "IMID_MINI_REWARDS_RESULT"

	--Successed	Byte	打赏结果	0 失败 1成功
	dataTable["Successed"] = nMBaseMessage:readByte()
	return dataTable
end

--[[--
--解析小游戏打赏领奖 (MINI_REWARDS_COLLECT)
--]]
function read8005000d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_MINI_REWARDS_COLLECT
	dataTable["messageName"] = "IMID_MINI_REWARDS_COLLECT"
	-- PromptMsg	Loop	提示信息
	dataTable["PromptMsg"] = {}
	local PromptMsg = nMBaseMessage:readInt()
	for i = 1, PromptMsg do
		dataTable["PromptMsg"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…Name	Text	打赏人姓名
		dataTable["PromptMsg"][i].Name = nMBaseMessage:readString()
		--…Content	Text	领奖信息
		dataTable["PromptMsg"][i].Content = nMBaseMessage:readString()
		--Common.log("dataTable[i].Name = "..dataTable["PromptMsg"][i].Name.."dataTable[i].Content = "..dataTable["PromptMsg"][i].Content)
		--…UserPic	Text	打赏者头像
		dataTable["PromptMsg"][i].UserPic = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--	RewardNum	Int	赏金总额
	dataTable["RewardNum"] = nMBaseMessage:readInt()
	return dataTable
end

--[[--
--解析小游戏请求打赏(MINI_REWARDS_JUDGE)
--]]
function read8005000e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_MINI_REWARDS_JUDGE
	dataTable["messageName"] = "IMID_MINI_REWARDS_JUDGE"

	--Judge	Byte	服务器含有待请求的领奖信息	1
	dataTable["Judge"] = nMBaseMessage:readByte()

	return dataTable
end

--[[--
--系统发送打赏V3消息(IMID_CHAT_ROOM_SEND_REWARD_V3)
--]]
function read8005000f(nMBaseMessage)
	Common.log("read8005000f=======================")
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_CHAT_ROOM_SEND_REWARD_V3
	dataTable["messageName"] = "IMID_CHAT_ROOM_SEND_REWARD_V3"

	--SpeakerUserID  发言者用户ID
	dataTable["SpeakerUserID"] = nMBaseMessage:readInt()
	--SpeakerNickName  发言者昵称
	dataTable["SpeakerNickName"] = nMBaseMessage:readString()
	--SpeechText  发言内容
	dataTable["SpeechText"] = nMBaseMessage:readString()
	--Color  ARGB方式存储。可用4个getByte()分别读取
	dataTable["ARGB0"] = nMBaseMessage:readByte()
	dataTable["ARGB1"] = nMBaseMessage:readByte()
	dataTable["ARGB2"] = nMBaseMessage:readByte()
	dataTable["ARGB3"] = nMBaseMessage:readByte()
	--TextSize  字体大小
	dataTable["TextSize"] = nMBaseMessage:readInt()
	--vip等级
	dataTable["VipLevel"] = nMBaseMessage:readInt()
	--ActionInT
	dataTable["ActionId"] = nMBaseMessage:readInt()
	--ActionString
	dataTable["ActionParam"] = nMBaseMessage:readInt()
	--CheckCode
	dataTable["CheckCode"] = nMBaseMessage:readInt()
	return dataTable
end

--[[--
--小游戏领取打赏V3 (IMID_MINI_GET_REWARDS_V3）
--]]
function read80050010(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_MINI_GET_REWARDS_V3
	dataTable["messageName"] = "IMID_MINI_GET_REWARDS_V3"

	--result	Byte	结果(1成功，2失败)
	dataTable["result"] = nMBaseMessage:readByte()
	--Pic	Text	奖励图片
	dataTable["Pic"] = nMBaseMessage:readString()
	--Description	Text	奖励信息
	dataTable["Description"] = nMBaseMessage:readString()
	--Msg	Text	陈述信息
	dataTable["Msg"] = nMBaseMessage:readString()

	return dataTable
end

--[[--
--获取初始化图片
--]]
function read8007001c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_INIT_PIC
	dataTable["messageName"] = "MANAGERID_GET_INIT_PIC"

	--TimeStamp	Long	时间戳
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	--picList	Int	图片列表	Loop
	dataTable["picList"] = {}
	local picList = nMBaseMessage:readInt()
	for i = 1, picList do
		dataTable["picList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--…picUrl	Text	图片url
		dataTable["picList"][i].picUrl = nMBaseMessage:readString()
		--Common.log("picUrl ====== "..dataTable["picList"][i].picUrl)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析破产送金]]
function read8007004e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GIVE_AWAY_GOLD
	dataTable["messageName"] = "MANAGERID_GIVE_AWAY_GOLD"

	-- RemainCount byte 当天剩余破产送金次数
	dataTable["mnRemainCount"] = nMBaseMessage:readByte()
	--ResultMsg  提示语
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	--IsSuccess byte 是否成功1成功0不成功
	dataTable["isSuccess"] = nMBaseMessage:readByte()

	return dataTable
end

--[[-- 解析绑定用户手机号]]
function read8007001d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_BINDING_USER_PHONE_NUMBER
	dataTable["messageName"] = "MANAGERID_BINDING_USER_PHONE_NUMBER"

	--Result
	dataTable["Result"] = nMBaseMessage:readByte()
	--ResultMsg  提示语
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 解析兑奖]]
function read80070019(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_EXCHANGE_AWARD
	dataTable["messageName"] = "MANAGERID_EXCHANGE_AWARD"

	--Result  0-成功 1-失败
	dataTable["Result"] = nMBaseMessage:readInt()
	Common.log("read80070019 == "..dataTable["Result"])
	--Message  Toast的信息
	dataTable["Message"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 解析获得用户充值记录]]
function read80070023(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GET_RECHARGE_RECORD
	dataTable["messageName"] = "GET_RECHARGE_RECORD"

	--RechargeRecords  充值记录
	dataTable["RechargeRecordData"] = {}
	local RechargeRecords = nMBaseMessage:readInt()
	for i = 1, RechargeRecords do
		dataTable["RechargeRecordData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…rechargeValue  充值金额
		dataTable["RechargeRecordData"][i].rechargeValue = nMBaseMessage:readInt()
		--…rechargeChannel  充值渠道
		dataTable["RechargeRecordData"][i].rechargeChannel = nMBaseMessage:readString()
		--…rechargeTime  充值时间
		dataTable["RechargeRecordData"][i].rechargeTime = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析获取绑定手机号随机码]]
function read80070029(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_BINDING_PHONE_RANDOM
	dataTable["messageName"] = "MANAGERID_GET_BINDING_PHONE_RANDOM"

	--ResultMsg  随机码
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	--Common.log("随机码 = " .. dataTable["ResultMsg"])
	return dataTable
end

--[[-- 解析获取所有奖品]]
function read80070018(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_PRESENTS
	dataTable["messageName"] = "MANAGERID_GET_PRESENTS"

	--TimeStamp  时间戳
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	--Count  数量
	dataTable["PrizeData"] = {}
	local Count = nMBaseMessage:readInt()
	for i = 1, Count do
		dataTable["PrizeData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…GoodID  物品id
		dataTable["PrizeData"][i].GoodID = nMBaseMessage:readInt()
		--…ShortName  短名称
		dataTable["PrizeData"][i].ShortName = nMBaseMessage:readString()
		--…Name  名称
		dataTable["PrizeData"][i].Name = nMBaseMessage:readString()
		--…Prize  需要兑奖券价格
		dataTable["PrizeData"][i].Prize = nMBaseMessage:readInt()
		--…Picture  列表界面大图
		dataTable["PrizeData"][i].Picture = nMBaseMessage:readString()
		--…Description  明细界面的说明
		dataTable["PrizeData"][i].Description = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析获取游戏基地支付说明数据]]
function read8007002b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_MOBILE_PAY_DATA
	dataTable["messageName"] = "MANAGERID_MOBILE_PAY_DATA"

	--GoalPhone  目标手机号
	dataTable["GoalPhone"] = nMBaseMessage:readString()
	--Common.log("目标手机号 = " .. dataTable["GoalPhone"])
	--FeeType  默认填写12
	dataTable["FeeType"] = nMBaseMessage:readString()
	--Common.log("默认填写12 = " .. dataTable["FeeType"])
	--CPID  合作方业务代码
	dataTable["CPID"] = nMBaseMessage:readString()
	--Common.log("合作方业务代码 = " .. dataTable["CPID"])
	--CPServiceID  网游业务代码
	dataTable["CPServiceID"] = nMBaseMessage:readString()
	--Common.log("网游业务代码 = " .. dataTable["CPServiceID"])
	--FID  默认填写1000
	dataTable["FID"] = nMBaseMessage:readString()
	--Common.log("默认填写1000 = " .. dataTable["FID"])
	--PackageID  默认填写000000000000
	dataTable["PackageID"] = nMBaseMessage:readString()
	--Common.log("默认填写000000000000 = " .. dataTable["PackageID"])
	--CPSign  默认填写000000
	dataTable["CPSign"] = nMBaseMessage:readString()
	--Common.log("默认填写000000 = " .. dataTable["CPSign"])
	--GameName  游戏名称
	dataTable["GameName"] = nMBaseMessage:readString()
	--Common.log("游戏名称 = " .. dataTable["GameName"])
	--payData  商品说明数据
	dataTable["payData"] = {}
	local payData = nMBaseMessage:readInt()
	for i = 1, payData do
		dataTable["payData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…payCode  计费代码
		dataTable["payData"][i].payCode = nMBaseMessage:readString()
		--…name  商品名称
		dataTable["payData"][i].name = nMBaseMessage:readString()
		--…describe  商品描述
		dataTable["payData"][i].describe = nMBaseMessage:readString()
		--…price  资费说明
		dataTable["payData"][i].price = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析获取自己兑换的奖品列表]]
function read8007001a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_EXCHANGE_AWARDS
	dataTable["messageName"] = "MANAGERID_GET_EXCHANGE_AWARDS"

	--Count  奖品数量
	dataTable["AwardData"] = {}
	local Count = nMBaseMessage:readInt()
	for i = 1, Count do
		dataTable["AwardData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…AwardID  奖品ID
		dataTable["AwardData"][i].AwardID = nMBaseMessage:readInt()
		--…Name  名称
		dataTable["AwardData"][i].Name = nMBaseMessage:readString()
		--…Status  状态
		dataTable["AwardData"][i].Status = nMBaseMessage:readByte()
		--Common.log("xwh excharge Status is " .. dataTable["AwardData"][i].Status)
		--…Date  购买日期
		dataTable["AwardData"][i].Date = nMBaseMessage:readLong()
		--…PictureUrl  图片路径
		dataTable["AwardData"][i].PictureUrl = nMBaseMessage:readString()
		--…Description  商品介绍
		dataTable["AwardData"][i].Description = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析支付数据列表]]
function read80070015(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + PAYMENT_DATA_LIST
	dataTable["messageName"] = "PAYMENT_DATA_LIST"
	--TimeStamp  时间戳
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	--PayQuickNum  快捷支付数量
	dataTable["PayQuickData"] = {}
	local PayQuickNum = nMBaseMessage:readInt()
	for i = 1, PayQuickNum do
		dataTable["PayQuickData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…PayTypeID  支付渠道ID
		dataTable["PayQuickData"][i].PayTypeID = nMBaseMessage:readByte()
		--…QuickName  快捷支付标题
		dataTable["PayQuickData"][i].QuickName = nMBaseMessage:readString()
		--…QuickDescription  快捷支付描述
		dataTable["PayQuickData"][i].QuickDescription = nMBaseMessage:readString()
		--…QuickPrice  快捷支付价格(RMB)
		dataTable["PayQuickData"][i].QuickPrice = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--PayChannelDataNum  所有支付渠道数据的数量
	dataTable["PayChannelData"] = {}
	local PayChannelDataNum = nMBaseMessage:readInt()
	--Common.log("支付数据列表 --- =PayChannelDataNum " .. PayChannelDataNum)
	for i = 1, PayChannelDataNum do
		dataTable["PayChannelData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("支付数据列表   PayChannelData---length = " .. length)
		--…PayTypeID  支付渠道ID
		dataTable["PayChannelData"][i].PayTypeID = nMBaseMessage:readByte()
		--…GoodsID  商品编号
		dataTable["PayChannelData"][i].GoodsID = nMBaseMessage:readByte()
		--        --Common.log("PayChannelData---商品编号 = " .. dataTable["PayChannelData"][i].GoodsID)
		--…GoodsName  商品名称
		dataTable["PayChannelData"][i].GoodsName = nMBaseMessage:readString()
		-- --Common.log("PayChannelData---商品名称 = " .. dataTable["PayChannelData"][i].GoodsName)
		--…GoodsDescription  商品描述
		dataTable["PayChannelData"][i].GoodsDescription = nMBaseMessage:readString()
		-- --Common.log("PayChannelData---商品描述 = " .. dataTable["PayChannelData"][i].GoodsDescription)
		--…GoodsPrice  商品价格
		dataTable["PayChannelData"][i].GoodsPrice = nMBaseMessage:readString()
		--		  --Common.log("PayChannelData---商品价格 = " .. dataTable["PayChannelData"][i].GoodsPrice)
		--…GoodsNum  一次购买商品数量
		dataTable["PayChannelData"][i].GoodsNum = nMBaseMessage:readByte()
		--   --Common.log("PayChannelData---一次购买商品数量 = " .. dataTable["PayChannelData"][i].GoodsNum)
		--…MMPayCode  短信支付代码
		dataTable["PayChannelData"][i].MMPayCode = nMBaseMessage:readString()
		-- --Common.log("PayChannelData---短信支付代码 = " .. dataTable["PayChannelData"][i].MMPayCode)
		--…Messageformat  发送短信格式
		dataTable["PayChannelData"][i].Messageformat = nMBaseMessage:readString()
		-- --Common.log("PayChannelData---发送短信格式 = " .. dataTable["PayChannelData"][i].Messageformat)
		--…Discount  优惠百分比(%)
		dataTable["PayChannelData"][i].Discount = nMBaseMessage:readInt()
		--  --Common.log("PayChannelData---优惠百分比(%) = " .. dataTable["PayChannelData"][i].Discount)
		--…Status  是否可用
		dataTable["PayChannelData"][i].Status = nMBaseMessage:readByte()
		--  --Common.log("PayChannelData---是否可用 = " .. dataTable["PayChannelData"][i].Status)
		--…Subtype  支付子类型
		dataTable["PayChannelData"][i].Subtype = nMBaseMessage:readByte()
		--  --Common.log("PayChannelData---支付子类型 = " .. dataTable["PayChannelData"][i].Subtype)
		--…coinUrl  购买物品图标
		dataTable["PayChannelData"][i].coinUrl = nMBaseMessage:readString()
		--  --Common.log("PayChannelData---购买物品图标 = " .. dataTable["PayChannelData"][i].coinUrl)
		--…tagUrl  物品标签
		dataTable["PayChannelData"][i].tagUrl = nMBaseMessage:readString()
		-- --Common.log("PayChannelData---物品标签 = " .. dataTable["PayChannelData"][i].tagUrl)
		--…addYuanbao  额外赠送的元宝数
		dataTable["PayChannelData"][i].addYuanbao = nMBaseMessage:readInt()
		--  --Common.log("PayChannelData---额外赠送的元宝数 = " .. dataTable["PayChannelData"][i].addYuanbao)
		--…NewName  商品名称
		dataTable["PayChannelData"][i].NewName = nMBaseMessage:readString()
		--  --Common.log("PayChannelData---商品名称 = " .. dataTable["PayChannelData"][i].NewName)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[--
--解析移动支付方式
--]]
function read8007005e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_MOBILE_PAYMENT_MODE
	dataTable["messageName"] = "MANAGERID_MOBILE_PAYMENT_MODE"
	--PaymentMode int 移动支付方式 0：不显示移动支付1：显示MM支付2：显示短代支付3：带验证码的短代（已废弃）
	dataTable["PaymentMode"] = nMBaseMessage:readInt()
	--Common.log("移动支付方式PaymentMode ====== " .. dataTable["PaymentMode"]);
	return dataTable
end

--[[--
--解析联通支付方式
--]]
function read80070071(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_CU_PAYMENT_MODE
	dataTable["messageName"] = "MANAGERID_CU_PAYMENT_MODE"
	--PaymentMode int 联通支付方式 0：不显示联通支付1：显示联通短代支付2：显示沃商店支付
	dataTable["PaymentMode"] = nMBaseMessage:readInt()
	--Common.log("联通支付方式PaymentMode ====== " .. dataTable["PaymentMode"]);
	return dataTable
end

--[[--
--解析电信支付方式
--]]
function read8007005f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_CT_PAYMENT_MODE
	dataTable["messageName"] = "MANAGERID_CT_PAYMENT_MODE"
	--PaymentMode int 电信支付方式 0：不显示电信支付1：显示华建支付2：显示天翼空间支付
	dataTable["PaymentMode"] = nMBaseMessage:readInt()
	--Common.log("电信支付方式PaymentMode ====== " .. dataTable["PaymentMode"]);
	return dataTable
end

--[[--
--解析支付
--]]
function read80070079(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_V3_RECHARGE
	dataTable["messageName"] = "MANAGERID_V3_RECHARGE"
	--Common.log("解析支付***************");
	-- result byte 兑换结果 0失败 1成功
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("result = "..dataTable["result"])

	-- msg text 信息
	dataTable["payMsg"] = nMBaseMessage:readString()
	--Common.log("msg ===================== " .. dataTable["payMsg"])

	--OrderId text 订单号/银联签名
	dataTable["OrderId"] = nMBaseMessage:readString()
	--Common.log("OrderId ===================== " .. dataTable["OrderId"])
	-- 支付渠道
	dataTable["payChannel"] = nMBaseMessage:readByte()
	--Common.log("payChannel ===================== " .. dataTable["payChannel"])
	--KvLoop loop KeyValue循环 用于微信支付或其他扩展信息
	dataTable["KvLoop"] = {}
	local KvLoopNum = nMBaseMessage:readInt()
	--Common.log("支付数据列表 --- KvLoopNum " .. KvLoopNum)
	for i = 1, KvLoopNum do
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …Key Text
		local key = nMBaseMessage:readString();
		-- …Value Text
		dataTable["KvLoop"][key] = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(pos + length)
	end
	dataTable["smsList"] = {}
	--SmsData loop 多条短信指令和目标号码循环
	local smsCount = nMBaseMessage:readInt()
	--Common.log("支付数据列表 --- smsCount " .. smsCount)
	for i = 1, smsCount do
		dataTable["smsList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…TelephoneNumber text 目标号码
		dataTable["smsList"][i].number = nMBaseMessage:readString()
		--Common.log("解析number: " .. dataTable["smsList"][i].number)
		--…SmsMsg text 短信内容
		dataTable["smsList"][i].smsContent = nMBaseMessage:readString()
		--Common.log("解析smsContent: " .. dataTable["smsList"][i].smsContent)

		--…IsDataSms byte 是否二进制短信	0文本短信 1二进制短信
		dataTable["smsList"][i].IsDataSms = nMBaseMessage:readByte()
		--…DestinationPort	short	二进制短信目标端口
		dataTable["smsList"][i].DestinationPort = nMBaseMessage:readShort()

		nMBaseMessage:setReadPos(pos + length)
	end
	--SmsHint text 短信发出后的弹框提示
	dataTable["SmsHint"] = nMBaseMessage:readString()
	--SerialNumber long 流水号
	dataTable["SerialNumber"] = nMBaseMessage:readLong()
	--Position Int	位置编码	默认为0
	dataTable["Position"] = nMBaseMessage:readInt()
	--Common.log("Position ===================== " .. dataTable["Position"])

	return dataTable
end

--[[--
--解析短信的支付
--]]
function read80070044(nMBaseMessage)

	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_SMS_RECHARGE
	dataTable["messageName"] = "MANAGERID_SMS_RECHARGE"
	--Common.log("解析短信支付********************")
	-- result byte 兑换结果 0失败 1成功
	local result = nMBaseMessage:readByte()
	-- msg text 提示信息
	local payMsg = nMBaseMessage:readString()
	--Common.log("解析短信支付********************Paymsg:" .. payMsg)
	-- RechargeWay Byte 支付渠道号 9：华建电信；10：移动游戏基地
	local rechargeWay = nMBaseMessage:readByte()
	--Common.log("解析短信支付********************result:" .. rechargeWay)

	--Common.log("解析短信支付********************result:" .. result)

	if result == 0 then

	--    dataTable["smsList"] = {}
	--        local smsCount = nMBaseMessage:readInt()
	--        --Common.log("smsList:-" .. smsCount)
	--            dataTable["smsList"][1] = {}
	--
	--            dataTable["smsList"][1].number = "18701134349"
	--            dataTable["smsList"][1].smsContent = "qerwqruioewuroipeqwkjf"
	--
	--             dataTable["smsList"][2] = {}
	--
	--            dataTable["smsList"][2].number = "18701134349"
	--            dataTable["smsList"][2].smsContent = "qerwqruioewuroipeqwkjf"

	elseif rechargeWay == profile.PayChannelData.HUAJIAN_DIANXIN_PAY then
		-- 华建电信子协议
		-- 获取目标号码（无用）
		local phoneNumber = nMBaseMessage:readString()
		-- 获取目标收到的短信（无用）
		local smsText = nMBaseMessage:readString()

		--Common.log("解析短信支付********************phoneNumber:" .. phoneNumber)
		--Common.log("解析短信支付********************smsText:" .. smsText)

		if (smsText ~= nil and phoneNumber ~= nil) then
			dataTable["phoneNumber"] = phoneNumber
			dataTable["smsText"] = smsText
			dataTable["rechargeWay"] = profile.PayChannelData.HUAJIAN_DIANXIN_PAY
		end
		--	elseif rechargeWay == profile.PayChannelData.SHENGFENG_DIANXIN_PAY then
		--	-- 盛丰电信
	elseif rechargeWay == profile.PayChannelData.SMS_ONLINE then
		-- 获取目标号码（无用）
		local phoneNumber = nMBaseMessage:readString()
		-- 获取目标收到的短信（无用）
		local smsText = nMBaseMessage:readString()
		dataTable["rechargeWay"] = profile.PayChannelData.SMS_ONLINE
		--Common.log("解析短信支付********************phoneNumber:" .. phoneNumber)
		--Common.log("解析短信支付********************smsText:" .. smsText)
		-- 开始Loop
		dataTable["smsList"] = {}
		local smsCount = nMBaseMessage:readInt()
		--Common.log("解析smsList:  " .. smsCount)
		for i=1, smsCount do
			dataTable["smsList"][i] = {}
			local length = nMBaseMessage:readShort()
			--Common.log("解析readShort:  " .. length)
			local pos = nMBaseMessage:getReadPos()
			dataTable["smsList"][i].number = nMBaseMessage:readString()
			--Common.log("解析number: " .. dataTable["smsList"][i].number)
			dataTable["smsList"][i].smsContent = nMBaseMessage:readString()
			--Common.log("解析smsContent: " .. dataTable["smsList"][i].smsContent)
			nMBaseMessage:setReadPos(pos + length)
		end
	elseif rechargeWay == profile.PayChannelData.HUAJIAN_LIANTONG_PAY then
		-- 华建联通子协议
		-- 获取目标号码（无用）
		local phoneNumber = nMBaseMessage:readString()
		-- 获取目标收到的短信（无用）
		local smsText = nMBaseMessage:readString()

		--Common.log("解析联通短信支付********************phoneNumber:" .. phoneNumber)
		--Common.log("解析联通短信支付********************smsText:" .. smsText)

		if (smsText ~= nil and phoneNumber ~= nil) then
			dataTable["phoneNumber"] = phoneNumber
			dataTable["smsText"] = smsText
			dataTable["rechargeWay"] = profile.PayChannelData.HUAJIAN_LIANTONG_PAY
		end
	end
	return dataTable
end


--[[-- 解析得到当前手机绑定的用户列表]]
function read80010008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_GET_IMEIUSERS
	dataTable["messageName"] = "BASEID_GET_IMEIUSERS"

	--Result  查询结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("查询结果 = " .. dataTable["Result"])
	--ResultTxt  提示语内容
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("提示语内容 = " .. dataTable["ResultTxt"])
	--TotalBindCnt  当前手机总共绑定次数
	dataTable["TotalBindCnt"] = nMBaseMessage:readByte()
	--Common.log("当前手机总共绑定次数 = " .. dataTable["TotalBindCnt"])
	--NickCnt  昵称数量
	dataTable["NickTable"] = {}
	local NickCnt = nMBaseMessage:readByte()
	for i = 1, NickCnt do
		dataTable["NickTable"][i] = {}
		--…NickName  昵称
		dataTable["NickTable"][i].NickName = nMBaseMessage:readString()
		--Common.log("NickTable---昵称 = " .. dataTable["NickTable"][i].NickName)
	end
	--BindingMobile  绑定的手机号
	dataTable["BindingMobile"] = nMBaseMessage:readString()
	--Common.log("绑定的手机号 = " .. dataTable["BindingMobile"])
	--头像
	local NickCnt2 = nMBaseMessage:readByte()
	for i = 1, NickCnt2 do
		--…NickName  昵称
		local useravator  = nMBaseMessage:readString()
		dataTable["NickTable"][i].UserAvator = useravator
		--Common.log("绑定的手机号 头像= " .. dataTable["NickTable"][i].UserAvator)
	end
	return dataTable
end

--[[-- 解析门票]]
function read8007003a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + TICKET_GET_TICKET_LIST
	dataTable["messageName"] = "TICKET_GET_TICKET_LIST"
	--TicketLoop	Loop	门票循环
	local TicketLoopCnt = nMBaseMessage:readInt()
	--Common.log("收到门票消息",TicketLoopCnt)
	dataTable["TicketLoop"] = {}
	for i = 1,TicketLoopCnt do
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["TicketLoop"][i] = {}
		--…TicketId	Int	门票id
		dataTable["TicketLoop"][i].TicketId = nMBaseMessage:readInt()
		--Common.log("门票ID",dataTable["TicketLoop"][i].TicketId)
		--…TicketName	Text	门票名称
		dataTable["TicketLoop"][i].TicketName = nMBaseMessage:readString()
		--Common.log("门票名字",dataTable["TicketLoop"][i].TicketName)
		--…TicketGameNamePic	Text	游戏名称角标url
		dataTable["TicketLoop"][i].TicketGameNamePic = nMBaseMessage:readString()
		--…TicketIcon	Text	门票图标url
		dataTable["TicketLoop"][i].TicketIcon = nMBaseMessage:readString()
		--…TicketStatus	Byte	门票状态	1已使用0未使用
		dataTable["TicketLoop"][i].TicketStatus = nMBaseMessage:readByte()
		--…TicketRemainMillions	Long	门票过期时间（秒）
		dataTable["TicketLoop"][i].TicketRemainMillions = nMBaseMessage:readLong()
		--…GameID	byte	游戏ID
		dataTable["TicketLoop"][i].GameID = nMBaseMessage:readByte()
		--…MatchID	int	比赛ID
		dataTable["TicketLoop"][i].MatchID = nMBaseMessage:readInt()
		--…MatchDetailUrl	text	比赛详情WebView的URL
		dataTable["TicketLoop"][i].MatchDetailUrl = nMBaseMessage:readString()
		--…PackageName	Text	游戏安卓包名
		dataTable["TicketLoop"][i].PackageName = nMBaseMessage:readString()
		--…MinVersion	Int	游戏最低版本
		dataTable["TicketLoop"][i].MinVersion = nMBaseMessage:readInt()
		--…TicketExpirationTime	Text	门票过期时间
		dataTable["TicketLoop"][i].TicketExpirationTime = nMBaseMessage:readString()
		--…MatchStartTime	Text	比赛开始时间
		dataTable["TicketLoop"][i].MatchStartTime = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析回话列表]]
function read80060011(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_GET_CONVERSATION_LIST
	dataTable["messageName"] = "DBID_V2_GET_CONVERSATION_LIST"

	--ConversationCnt  会话数量
	dataTable["MessageData"] = {}
	local ConversationCnt = nMBaseMessage:readByte()
	--Common.log("消息数量 = " .. ConversationCnt)
	for i = 1, ConversationCnt do
		dataTable["MessageData"][i] = {}
		--…ConversationID
		dataTable["MessageData"][i].ConversationID = nMBaseMessage:readInt()
		--Common.log("--- = " .. dataTable["MessageData"][i].ConversationID)
		--…UserID  用户ID
		dataTable["MessageData"][i].UserID = nMBaseMessage:readInt()
		--Common.log("---用户ID = " .. dataTable["MessageData"][i].UserID)
		--…IsSysMsg  是否为系统消息
		dataTable["MessageData"][i].IsSysMsg = nMBaseMessage:readByte()
		--Common.log("---是否为系统消息 = " .. dataTable["MessageData"][i].IsSysMsg)
		--...SenderNickName  发信人昵称
		dataTable["MessageData"][i].SenderNickName = nMBaseMessage:readString()
		--Common.log("发信人昵称 = " .. dataTable["MessageData"][i].SenderNickName)
		--…PhotoUrl  头像url
		dataTable["MessageData"][i].PhotoUrl = nMBaseMessage:readString()
		--Common.log("---头像url = " .. dataTable["MessageData"][i].PhotoUrl)
		--...LastMsgContent  最后一条信息的内容
		dataTable["MessageData"][i].LastMsgContent = nMBaseMessage:readString()
		--Common.log("最后一条信息的内容 = " .. dataTable["MessageData"][i].LastMsgContent)
		--...LastMsgTime  最新消息的时间
		dataTable["MessageData"][i].LastMsgTime = nMBaseMessage:readString()
		--Common.log("最新消息的时间 = " .. dataTable["MessageData"][i].LastMsgTime)
		--…TotalMsgCnt  总消息数量
		dataTable["MessageData"][i].TotalMsgCnt = nMBaseMessage:readShort()
		--Common.log("---总消息数量 = " .. dataTable["MessageData"][i].TotalMsgCnt)
		--…UnreadMessageCnt  未读信息数量
		dataTable["MessageData"][i].UnreadMessageCnt = nMBaseMessage:readShort()
		--Common.log("---未读信息数量 = " .. dataTable["MessageData"][i].UnreadMessageCnt)
	end
	return dataTable
end

--[[-- 解析会话详情]]
function read80060012(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_GET_CONVERSATION
	dataTable["messageName"] = "DBID_V2_GET_CONVERSATION"

	--ConversationID  会话ID
	dataTable["ConversationID"] = nMBaseMessage:readInt()
	--Common.log("会话ID = " .. dataTable["ConversationID"])
	--UserInfo  用户信息
	dataTable["UserInfo"] = nMBaseMessage:readString()
	--Common.log("用户信息 = " .. dataTable["UserInfo"])
	--MessageCnt  消息数量
	dataTable["MessageTable"] = {}
	local MessageCnt = nMBaseMessage:readByte()
	for i = 1, MessageCnt do
		dataTable["MessageTable"][i] = {}
		--…MessageID
		dataTable["MessageTable"][i].MessageID = nMBaseMessage:readInt()
		--Common.log("MessageTable--- = " .. dataTable["MessageTable"][i].MessageID)
		--...Content  内容
		dataTable["MessageTable"][i].Content = nMBaseMessage:readString()
		--Common.log("内容 = " .. dataTable["MessageTable"][i].Content)
		--...CreateTime  消息时间
		dataTable["MessageTable"][i].CreateTime = nMBaseMessage:readString()
		--Common.log("消息时间 = " .. dataTable["MessageTable"][i].CreateTime)
		--…Sender  发消息的人
		dataTable["MessageTable"][i].Sender = nMBaseMessage:readByte()
		--Common.log("MessageTable---发消息的人 = " .. dataTable["MessageTable"][i].Sender)
	end
	dataTable["IsShield"] = nMBaseMessage:readByte()
	--	--Common.log("aab................IsShield=" .. dataTable["IsShield"])
	return dataTable
end

--[[-- 解析删除会话]]
function read80060014(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_DELETE_CONVERSATION
	dataTable["messageName"] = "DBID_V2_DELETE_CONVERSATION"

	--Result  结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("结果 = " .. dataTable["Result"])
	--ResultTxt  失败原因
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("失败原因 = " .. dataTable["ResultTxt"])
	return dataTable
end

--[[-- 解析清空会话]]
function read80060013(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_EMPTY_CONVERSITION
	dataTable["messageName"] = "DBID_V2_EMPTY_CONVERSITION"

	--Result  结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("结果 = " .. dataTable["Result"])
	--ResultTxt  失败原因
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("失败原因 = " .. dataTable["ResultTxt"])
	return dataTable
end

--[[-- 解析发送会话]]
function read80060015(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_SEND_MESSAGE
	dataTable["messageName"] = "DBID_V2_SEND_MESSAGE"

	--Result  结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("解析发送会话结果 = " .. dataTable["Result"])
	--ResultTxt  失败原因
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("解析发送会话失败原因 = " .. dataTable["ResultTxt"])
	return dataTable
end

--[[-- 解析签到：获取签到内容]]
function read80070046(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_DAILY_SIGN
	dataTable["messageName"] = "MANAGERID_DAILY_SIGN"

	--IsFirstSign  是否当日首次请求
	dataTable["IsFirstSign"] = nMBaseMessage:readByte()
	--Common.log("是否当日首次请求 = " .. dataTable["IsFirstSign"])
	--ContinueDays  连续登陆天数
	dataTable["ContinueDays"] = nMBaseMessage:readShort()
	--Common.log("连续登陆天数 = " .. dataTable["ContinueDays"])
	--SignedCnt  本月已经签了多少天
	dataTable["SignedCnt"] = nMBaseMessage:readByte()
	--Common.log("本月已经签了多少天 = " .. dataTable["SignedCnt"])
	--FullCnt  本月需要签多少天
	dataTable["FullCnt"] = nMBaseMessage:readByte()
	--Common.log("本月需要签多少天 = " .. dataTable["FullCnt"])
	--SignStatus  签到状态
	dataTable["SignStatus"] = nMBaseMessage:readByte()
	--Common.log("签到状态 = " .. dataTable["SignStatus"])
	--NoticeTextUrl  Vip加成图片提示url
	dataTable["NoticeTextUrl"] = nMBaseMessage:readString()
	--Common.log("Vip加成图片提示url = " .. dataTable["NoticeTextUrl"])
	--CurrDate  今天的日期
	dataTable["CurrDate"] = nMBaseMessage:readByte()
	--Common.log("今天的日期 = " .. dataTable["CurrDate"])
	--Cnt  天数
	dataTable["DailySignRewardData"] = {}
	local Cnt = nMBaseMessage:readInt()
	for i = 1, Cnt do
		dataTable["DailySignRewardData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("DailySignRewardData---length = " .. length)
		--…Coin  金币
		dataTable["DailySignRewardData"][i].Coin = nMBaseMessage:readInt()
		--Common.log("DailySignRewardData---金币 = " .. dataTable["DailySignRewardData"][i].Coin)
		--…Honor  荣誉值
		dataTable["DailySignRewardData"][i].Honor = nMBaseMessage:readInt()
		--Common.log("DailySignRewardData---荣誉值 = " .. dataTable["DailySignRewardData"][i].Honor)
		nMBaseMessage:setReadPos(pos + length)
	end
	--VipCnt  Vip奖励
	dataTable["VipDailySignRewardData"] = {}
	local VipCnt = nMBaseMessage:readInt()
	for i = 1, VipCnt do
		dataTable["VipDailySignRewardData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("VipDailySignRewardData---length = " .. length)
		--…VipLevel  Vip等级
		dataTable["VipDailySignRewardData"][i].VipLevel = nMBaseMessage:readInt()
		--Common.log("VipDailySignRewardData---Vip等级 = " .. dataTable["VipDailySignRewardData"][i].VipLevel)
		--…VipAward  Vip加成奖励
		dataTable["VipDailySignRewardData"][i].VipAward = nMBaseMessage:readString()
		--Common.log("VipDailySignRewardData---Vip加成奖励 = " .. dataTable["VipDailySignRewardData"][i].VipAward)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析宝盒：获取宝盒进度]]
function read8007003b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BAOHE_GET_PRO
	dataTable["messageName"] = "BAOHE_GET_PRO"

	--Progress  已完成局数
	dataTable["Progress"] = nMBaseMessage:readShort()
	--Common.log("已完成局数 = " .. dataTable["Progress"])
	--Max  总局数
	dataTable["Max"] = nMBaseMessage:readShort()
	--Common.log("总局数 = " .. dataTable["Max"])
	return dataTable
end

--[[-- 解析宝盒：获取宝藏V2]]
function read80070054(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BAOHE_GET_TREASURE_V2
	dataTable["messageName"] = "BAOHE_GET_TREASURE_V2"

	--Result  1 成功 0 失败
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("1 成功 0 失败 = " .. dataTable["Result"])
	--ResultMsg  提示语
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	--Common.log("提示语 = " .. dataTable["ResultMsg"])
	--TreasureCnt  奖励物品个数
	dataTable["TableTreasureData"] = {}
	local TreasureCnt = nMBaseMessage:readInt()
	for i = 1, TreasureCnt do
		dataTable["TableTreasureData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("TableTreasureData---length = " .. length)
		--…TreasurePicUrl  物品图片url
		dataTable["TableTreasureData"][i].TreasurePicUrl = nMBaseMessage:readString()
		--Common.log("TableTreasureData---物品图片url = ".. dataTable["TableTreasureData"][i].TreasurePicUrl)
		--…TreasureDiscription  物品描述
		dataTable["TableTreasureData"][i].TreasureDiscription = nMBaseMessage:readString()
		--Common.log("TableTreasureData---物品描述 = ".. dataTable["TableTreasureData"][i].TreasureDiscription)
		--…Multiple  奖品倍数
		dataTable["TableTreasureData"][i].Multiple = nMBaseMessage:readInt()
		--Common.log("TableTreasureData---奖品倍数 = ".. dataTable["TableTreasureData"][i].Multiple)
		--…lastTreasureCount  最终奖品数目
		dataTable["TableTreasureData"][i].lastTreasureCount = nMBaseMessage:readInt()
		--Common.log("TableTreasureData---最终奖品数目 = ".. dataTable["TableTreasureData"][i].lastTreasureCount)
		nMBaseMessage:setReadPos(pos + length)
	end
	--Progress  已完成局数
	dataTable["Progress"] = nMBaseMessage:readShort()
	--Common.log("已完成局数 = " .. dataTable["Progress"])
	--Max  总局数
	dataTable["Max"] = nMBaseMessage:readShort()
	--Common.log("总局数 = " .. dataTable["Max"])
	return dataTable
end

--[[-- 解析兑奖列表]]
function read8007004f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_PRIZE_PIECES_LIST
	dataTable["messageName"] = "MANAGERID_PRIZE_PIECES_LIST"

	--PiecesNum  碎片数量
	dataTable["AwardTable"] = {}
	local PiecesNum = nMBaseMessage:readInt()
	--Common.log("AwardTable---PiecesNum = " .. PiecesNum)
	for i = 1, PiecesNum do
		dataTable["AwardTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…PiecesID  碎片ID
		dataTable["AwardTable"][i].PiecesID = nMBaseMessage:readInt()
		--…Name  名称
		dataTable["AwardTable"][i].Name = nMBaseMessage:readString()
		--…IconURL  图标url
		dataTable["AwardTable"][i].IconURL = nMBaseMessage:readString()
		--…NeedNum  所需的碎片
		dataTable["AwardTable"][i].NeedNum = nMBaseMessage:readInt()
		--…ExistingNum  已有的碎片
		dataTable["AwardTable"][i].ExistingNum = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end
	--ExchangeNum  兑换券数量
	dataTable["AwardIDTable"] = {}
	local ExchangeNum = nMBaseMessage:readInt()
	for i = 1, ExchangeNum do
		dataTable["AwardIDTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…ExchangeID  兑换券ID
		dataTable["AwardIDTable"][i].ExchangeID = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end
--[[-- 解析兑奖操作]]
function read80070050(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_PIECES_COMPOUND_DETAILS
	dataTable["messageName"] = "MANAGERID_PIECES_COMPOUND_DETAILS"

	--PiecesID  碎片ID
	dataTable["PiecesID"] = nMBaseMessage:readInt()
	--Name  名称
	dataTable["Name"] = nMBaseMessage:readString()
	--IconURL  图标url
	dataTable["IconURL"] = nMBaseMessage:readString()
	--NeedNum  所需的碎片
	dataTable["NeedNum"] = nMBaseMessage:readInt()
	--ExistingNum  已有的碎片
	dataTable["ExistingNum"] = nMBaseMessage:readInt()
	--PiecesDetails  碎片详情
	dataTable["PiecesDetails"] = nMBaseMessage:readString()
	--CompoundRate  默认合成成功率
	dataTable["CompoundRate"] = nMBaseMessage:readInt()
	--AddSuccessRate  增加合成成功率阶梯
	dataTable["AwardTable"] = {}
	local AddSuccessRate = nMBaseMessage:readInt()
	for i = 1, AddSuccessRate do
		dataTable["AwardTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("AwardTable---length = " .. length)
		--…AddRate  增加的成功率
		dataTable["AwardTable"][i].AddRate = nMBaseMessage:readInt()
		--Common.log("AwardTable---增加的成功率 = ".. dataTable["AwardTable"][i].AddRate)
		--…NeedYuanBao  需要的元宝数
		dataTable["AwardTable"][i].NeedYuanBao = nMBaseMessage:readInt()
		--Common.log("AwardTable---需要的元宝数 = ".. dataTable["AwardTable"][i].NeedYuanBao)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析兑奖操作]]
function read80070059(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_PIECES_SHOP_LIST
	dataTable["messageName"] = "MANAGERID_GET_PIECES_SHOP_LIST"

	--ChipNum  拥有的兑奖券碎片数量
	dataTable["ChipNum"] = nMBaseMessage:readInt()
	--TimeStamp  时间戳
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	--Count  数量
	dataTable["AwardTable"] = {}
	local Count = nMBaseMessage:readInt()
	--Common.log("AwardTablesuipian---Count = " .. Count)
	for i = 1, Count do
		dataTable["AwardTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--…GoodID  物品id
		dataTable["AwardTable"][i].GoodID = nMBaseMessage:readInt()
		--…ShortName  短名称
		dataTable["AwardTable"][i].ShortName = nMBaseMessage:readString()
		--…Name  名称
		dataTable["AwardTable"][i].Name = nMBaseMessage:readString()
		--…Prize  兑换需要的碎片数量
		dataTable["AwardTable"][i].Prize = nMBaseMessage:readInt()
		--…Picture  列表界面大图
		dataTable["AwardTable"][i].Picture = nMBaseMessage:readString()
		--…Description  明细界面的说明
		dataTable["AwardTable"][i].Description = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析兑奖券碎片兑奖]]
function read8007005a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_PIECES_EXCHANGE
	dataTable["messageName"] = "MANAGERID_PIECES_EXCHANGE"

	--GoodID  物品id
	dataTable["GoodID"] = nMBaseMessage:readInt()
	--Common.log("物品id = " .. dataTable["GoodID"])
	--Result  合成是否成功
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("合成是否成功 = " .. dataTable["Result"])
	--ResultMsg  提示信息
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	--Common.log("提示信息 = " .. dataTable["ResultMsg"])
	return dataTable
end



--[[-- 解析新充值卡备选奖品列表]]
function read80070035(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + NEW_GET_ALTERNATIVE_PRIZE_LIST
	dataTable["messageName"] = "NEW_GET_ALTERNATIVE_PRIZE_LIST"

	--PrizeID  奖品ID
	dataTable["PrizeID"] = nMBaseMessage:readInt()
	--Count  备选奖品数量
	dataTable["AwardChange"] = {}
	local Count = nMBaseMessage:readInt()
	for i = 1, Count do
		dataTable["AwardChange"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…itemType  备选奖品类型
		dataTable["AwardChange"][i].itemType = nMBaseMessage:readByte()
		--…itemName  备选奖品名称
		dataTable["AwardChange"][i].itemName = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end



--[[-- 解析新充值卡备选奖品列表2]]
function read80070036(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + NEW_GET_ALTERNATIVE_PRIZE
	dataTable["messageName"] = "NEW_GET_ALTERNATIVE_PRIZE"

	--Result  1 成功 0 失败
	dataTable["Result"] = nMBaseMessage:readByte()
	--exchargeFlag  领奖类型
	dataTable["exchargeFlag"] = nMBaseMessage:readByte()
	--PrizeTip  提示信息
	dataTable["PrizeTip"] = nMBaseMessage:readString()
	--CardNO  卡号
	dataTable["CardNO"] = nMBaseMessage:readString()
	--Password  密码
	dataTable["Password"] = nMBaseMessage:readString()
	--PrizeID  奖品ID
	dataTable["PrizeID"] = nMBaseMessage:readInt()
	--PrizeName  奖品名称
	dataTable["PrizeName"] = nMBaseMessage:readString()
	return dataTable
end


--[[-- 解析新获取自己赢得的奖品列表]]
function read80070034(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + NEW_GET_PRIZE_LIST
	dataTable["messageName"] = "NEW_GET_PRIZE_LIST"

	--PrizeCnt  奖品数量
	dataTable["MyPrize"] = {}
	local PrizeCnt = nMBaseMessage:readInt()
	--Common.log(PrizeCnt.."macmyid")
	for i = 1, PrizeCnt do
		dataTable["MyPrize"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--...PrizeID  奖品ID
		dataTable["MyPrize"][i].PrizeID = nMBaseMessage:readInt()
		--Common.log(dataTable["MyPrize"][i].PrizeID.."macmyid")
		--...PrizeName  实物奖名称
		dataTable["MyPrize"][i].PrizeName = nMBaseMessage:readString()
		--...PrizeStatus  奖品状态
		dataTable["MyPrize"][i].PrizeStatus = nMBaseMessage:readByte()
		--Common.log("xwh excharge Status is " .. dataTable["MyPrize"][i].PrizeStatus)
		--...AwardTime  获奖日期
		dataTable["MyPrize"][i].AwardTime = nMBaseMessage:readLong()
		--...PictureUrl  图片路径
		dataTable["MyPrize"][i].PictureUrl = nMBaseMessage:readString()
		--...ValidDate  有效期
		dataTable["MyPrize"][i].ValidDate = nMBaseMessage:readLong()
		--...Category  奖品类型
		dataTable["MyPrize"][i].Category = nMBaseMessage:readByte()
		--Common.log("xwh excharge Category is " .. dataTable["MyPrize"][i].Category)
		--…prizeMatch  获奖比赛
		dataTable["MyPrize"][i].prizeMatch = nMBaseMessage:readString()
		--…isExpired  是否过期
		dataTable["MyPrize"][i].isExpired = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析碎片合成操作]]
function read80070056(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_COMPOUND_V2
	dataTable["messageName"] = "MANAGERID_COMPOUND_V2"

	--PiecesID  碎片ID
	dataTable["PiecesID"] = nMBaseMessage:readInt()
	--Common.log("碎片ID = " .. dataTable["PiecesID"])
	--Result  合成是否成功
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("合成是否成功 = " .. dataTable["Result"])
	--ResultMsg  提示信息
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	--Common.log("提示信息 = " .. dataTable["ResultMsg"])
	return dataTable
end


--[[-- 解析碎片合成列表]]
function read80070055(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_PIECES_COMPOUND_DETAILS_V2
	dataTable["messageName"] = "MANAGERID_PIECES_COMPOUND_DETAILS_V2"

	--PiecesID  碎片ID
	dataTable["PiecesID"] = nMBaseMessage:readInt()
	--Name  名称
	dataTable["Name"] = nMBaseMessage:readString()
	--Common.log("read80070055 Name==" .. dataTable["Name"]);
	--IconURL  图标url
	dataTable["IconURL"] = nMBaseMessage:readString()
	--ExistingNum  已有的碎片
	dataTable["ExistingNum"] = nMBaseMessage:readInt()
	--Common.log("read80070055 ExistingNum==" .. dataTable["ExistingNum"]);
	--NeedNum  合成一张兑奖券需要的碎片数
	dataTable["NeedNum"] = nMBaseMessage:readInt()
	--NeedYuanBao  合成一张兑奖券需要的元宝数
	dataTable["NeedYuanBao"] = nMBaseMessage:readInt()
	--PiecesIntro  碎片简介
	dataTable["PiecesIntro"] = nMBaseMessage:readString()
	--PiecesDetails  碎片详情
	dataTable["PiecesDetails"] = nMBaseMessage:readString()
	--CompoundSympolDetails  合成符详情
	dataTable["CompoundSympolDetails"] = nMBaseMessage:readString()
	return dataTable
end

--3.7.100 小游戏列表状态消息(MANAGERID_MINIGAME_LIST_TYPE)
function read80070064(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_MINIGAME_LIST_TYPE
	dataTable["messageName"] = "MANAGERID_MINIGAME_LIST_TYPE"
	--typeList	Loop		Loop
	dataTable["typeList"] = {}
	local typeListCnt = nMBaseMessage:readInt()
	--Common.log("typeListCnt === "..typeListCnt)
	for i = 1, typeListCnt do
		dataTable["typeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--……MiniGameID			转盘ID：101 老虎机ID：102 金皇冠ID：103
		dataTable["typeList"][i].MiniGameID = nMBaseMessage:readInt()
		--Common.log("MiniGameID === "..dataTable["typeList"][i].MiniGameID)
		--…MiniGameState	byte	小游戏显示状态	不显示：0 显示不带锁：1 显示带锁：2

		dataTable["typeList"][i].MiniGameState = nMBaseMessage:readByte()
		--Common.log("MiniGameID MiniGameState === "..dataTable["typeList"][i].MiniGameState)

		--Common.log("小游戏状态 === ",dataTable["typeList"][i].MiniGameID,dataTable["typeList"][i].MiniGameState)
		--…StateMsgTxt	text	用户点击后的toast	带锁时有意义
		dataTable["typeList"][i].StateMsgTxt =nMBaseMessage:readString()
		--…MiniGameIconUrl	text
		dataTable["typeList"][i].MiniGameIconUrl = nMBaseMessage:readString()
		--		--Common.log("sdf.....MiniGameID = " .. dataTable["typeList"][i].MiniGameID .."                      MiniGameIconUrl" .. dataTable["typeList"][i].MiniGameIconUrl)
		nMBaseMessage:setReadPos(pos + length)
	end


	return dataTable
end

--[[-----------------------老虎机模块 SLOTID 消息----------------------]]

--[[--
--解析老虎机准备信息(SLOT_READY_INFO)
--]]
function read80530001(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + SLOT_READY_INFO
	dataTable["messageName"] = "SLOT_READY_INFO"

	--IntroduceUrl	text	关键玩法图片地址
	dataTable["IntroduceUrl"] = nMBaseMessage:readString()

	--Raise 	Loop		Loop
	dataTable["Raise"] = {}
	local RaiseCnt = nMBaseMessage:readInt()
	--Common.log("RaiseCnt === "..RaiseCnt)
	for i = 1, RaiseCnt do
		dataTable["Raise"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…coin	int	金币数
		dataTable["Raise"][i].coin = nMBaseMessage:readInt()
		--…rate	int	彩金加奖比例
		dataTable["Raise"][i].rate = nMBaseMessage:readInt()
		--Common.log("dataTable[i].rate"..dataTable["Raise"][i].rate)
		nMBaseMessage:setReadPos(pos + length)
	end

	--handsel777	int	中777的彩金百分比	50
	dataTable["handsel777"] = nMBaseMessage:readInt()
	--handselBibei5	int	比倍5次彩金百分比	10
	dataTable["handselBibei5"] = nMBaseMessage:readInt()
	--handselBibei8	int	比倍8次彩金百分比	50
	dataTable["handselBibei8"] = nMBaseMessage:readInt()

	--VipRaise	Loop	Vip彩金比例	vip1，vip2….
	dataTable["VipRaise"] = {}
	local VipRaiseCnt = nMBaseMessage:readInt()
	for i = 1, VipRaiseCnt do
		dataTable["VipRaise"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…fourHand	Int	Vip四手彩金比例
		dataTable["VipRaise"][i].fourHand = nMBaseMessage:readInt()
		--…sixHand	Int	Vip六手彩金比例
		dataTable["VipRaise"][i].sixHand = nMBaseMessage:readInt()
		--Common.log("VipRaise4"..dataTable["VipRaise"][i].fourHand)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[--
--解析老虎机奖金表信息(SLOT_PRIZE_LIST)
--]]
function read80530002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + SLOT_PRIZE_LIST
	dataTable["messageName"] = "SLOT_PRIZE_LIST"

	--	时间戳
	dataTable["timestamp"] = nMBaseMessage:readLong()


	--Prize 	Loop		Loop
	dataTable["PrizeList"] = {}
	local PrizeCnt = nMBaseMessage:readInt()
	--Common.log("PrizeCnt === "..PrizeCnt)
	for i = 1, PrizeCnt do
		dataTable["PrizeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…level	text	奖励等级
		dataTable["PrizeList"][i].level = nMBaseMessage:readString()
		--…img	text	图像编号字符串“0,0,0”
		dataTable["PrizeList"][i].img = nMBaseMessage:readString()
		--…prizedesc	text	奖励描述
		dataTable["PrizeList"][i].prizedesc = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--extraPrize	text	特等级奖励描述
	dataTable["extraPrize"] = nMBaseMessage:readString()
	return dataTable
end

--[[--
--解析老虎机滚动信息(SLOT_ROLL_MESSAGE)
--]]
function read80530003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + SLOT_ROLL_MESSAGE
	dataTable["messageName"] = "SLOT_ROLL_MESSAGE"

	--HandselMsg	text	彩金信息
	dataTable["HandselMsg"] = nMBaseMessage:readString()
	--WinMsgNum	Int		Loop
	dataTable["WinMsgNum"] = {}
	local WinMsgNumCnt = nMBaseMessage:readInt()
	--Common.log("WinMsgNumCnt === "..WinMsgNumCnt)
	for i = 1, WinMsgNumCnt do
		dataTable["WinMsgNum"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…ItemID	Int	信息的ID
		dataTable["WinMsgNum"][i].ItemID = nMBaseMessage:readInt()
		--…msg	Text	中奖信息
		dataTable["WinMsgNum"][i].msg = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end



--[[--
--解析老虎机中奖信息(SLOT_ACCEPT_THE_PRIZE)
--]]
function read80530004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + SLOT_ACCEPT_THE_PRIZE
	dataTable["messageName"] = "SLOT_ACCEPT_THE_PRIZE"

	--success	byte	是否获胜	0 失败 1获胜
	dataTable["success"] = nMBaseMessage:readByte()
	--img	String	0,0,0
	dataTable["img"] = nMBaseMessage:readString()

	--coin	int	赢金币数	>=0
	dataTable["coin"] = nMBaseMessage:readInt()

	--PrizeLevel	text	奖励等级
	dataTable["PrizeLevel"] = nMBaseMessage:readString()
	--Winpool	byte	是否可获得奖池	0 否 1是
	dataTable["Winpool"] = nMBaseMessage:readByte()
	--WinCoinNum 	Int 	获得奖池的金币数
	dataTable["WinCoinNum"] = nMBaseMessage:readInt()

	--pollMsg	Text	获得奖池奖励描述
	dataTable["pollMsg"] = nMBaseMessage:readString()

	--JoinRisk	byte	是否可参加比倍	0 否 1是
	dataTable["JoinRisk"] = nMBaseMessage:readByte()
	--WinTime	Byte[]	可赢次数	加密

	local length = nMBaseMessage:readShort()
	local pos = nMBaseMessage:getReadPos()
	dataTable["WinTime"] = ""
	for i = 1,length do
		if(i ~= length)then
			dataTable["WinTime"] = dataTable["WinTime"]..nMBaseMessage:readByte()..","
		else
			dataTable["WinTime"] = dataTable["WinTime"]..nMBaseMessage:readByte()
		end
	end
	dataTable["WinTime"] = Common.decryptUseDES(dataTable["WinTime"],length,"llypwzh@20131001")
	nMBaseMessage:setReadPos(pos + length)

	--RickMsgUrl	text	比倍关键玩法图片地址
	dataTable["RickMsgUrl"] = nMBaseMessage:readString()
	--RiskWinCoinList		当前比倍彩金数	loop
	dataTable["RiskWinCoinList"] = {}
	local RiskWinCnt = nMBaseMessage:readInt()
	--Common.log("RiskWinCoinListCnt === "..RiskWinCnt)
	--    RiskWinCnt = 1
	for i = 1, RiskWinCnt do
		dataTable["RiskWinCoinList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…RiskNum	byte	比倍次数
		dataTable["RiskWinCoinList"][i].RiskNum = nMBaseMessage:readByte()
		--…RiskWinCoinNum	int	当前次数所得比倍彩金数
		dataTable["RiskWinCoinList"][i].RiskWinCoinNum = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end
	--SlotScrollUrl	text	比倍条幅图片地址
	dataTable["SlotScrollUrl"] = nMBaseMessage:readString()
	--SlotScrollTxt	text	比倍条幅文字
	dataTable["SlotScrollTxt"] = nMBaseMessage:readString()
	return dataTable

end


--[[--
--解析比倍机收钱信息(SLOT_RICK_COLLECT_MONEY)
--]]
function read80530005(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + SLOT_RICK_COLLECT_MONEY
	dataTable["messageName"] = "SLOT_RICK_COLLECT_MONEY"

	--Successed	byte	信息是否提交成功	0 失败 1成功
	dataTable["Successed"] = nMBaseMessage:readByte()
	--Coin	Int	赢得金币数	>=0
	dataTable["Coin"] = nMBaseMessage:readInt()
	--mmLoveYou	Text	美女感谢语
	dataTable["mmLoveYou"] = nMBaseMessage:readString()
	return dataTable
end

--[[--
--解析老虎机中奖纪录(SLOT_RICK_WINNING_RECORD)
--]]
function read8053000b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + SLOT_RICK_WINNING_RECORD
	dataTable["messageName"] = "SLOT_RICK_WINNING_RECORD"

	dataTable["Timestamp"] = nMBaseMessage:readLong()


	dataTable["RecordList"] = {}
	local RecordList = nMBaseMessage:readInt()
	for i = 1, RecordList do
		dataTable["RecordList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…nickname	Text	昵称
		dataTable["RecordList"][i].nickname = nMBaseMessage:readString()
		--…coin	Int	金币数
		dataTable["RecordList"][i].coin = nMBaseMessage:readInt()
		--…play time	Int	比倍次数
		dataTable["RecordList"][i].playTime = nMBaseMessage:readInt()
		--…vip level	Int	Vip等级
		dataTable["RecordList"][i].vipLevel = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end


	return dataTable
end


--[[-----------------------金皇冠模块 JHGID 消息----------------------]]
--[[--
--解析金皇冠准备信息(JHG_READY_INFO)
--]]
function read80530006(nMBaseMessage)
	--Common.log("****************金皇冠收到准备信息***************")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHG_READY_INFO
	dataTable["messageName"] = "JHG_READY_INFO"

	--IsFirstPlay	Byte	是否是第一次玩	0，1
	dataTable["IsFirstPlay"] = nMBaseMessage:readByte()

	--Raise 	Loop		Loop
	dataTable["Raise"] = {}
	local RaiseCnt = nMBaseMessage:readInt()
	--Common.log("RaiseCnt === "..RaiseCnt)
	for i = 1, RaiseCnt do
		dataTable["Raise"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…coin	int	金币数
		dataTable["Raise"][i].coin = nMBaseMessage:readInt()
		--…rate	int	彩金加奖比例
		dataTable["Raise"][i].rate = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end
	--TimesOfRule	Loop		Loop
	dataTable["TimesOfRule"] = {}
	local TimesOfRuleCnt = nMBaseMessage:readInt()
	--Common.log("TimesOfRuleCnt === "..TimesOfRuleCnt)
	for i = 1,TimesOfRuleCnt do
		dataTable["TimesOfRule"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…Times	int	翻倍机的倍数
		dataTable["TimesOfRule"][i].Times = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end
	--VipRaise	Loop	Vip彩金比例	vip1，vip2….
	dataTable["VipRaise"] = {}
	local VipRaiseCnt = nMBaseMessage:readInt()
	for i = 1, VipRaiseCnt do
		dataTable["VipRaise"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…fourHand	Int	Vip四手彩金比例
		dataTable["VipRaise"][i].fourHand = nMBaseMessage:readInt()
		--…sixHand	Int	Vip六手彩金比例
		dataTable["VipRaise"][i].sixHand = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[--
--解析金皇冠滚动信息(JHG_ROLL_MESSAGE)
--]]
function read80530007(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JHG_ROLL_MESSAGE
	dataTable["messageName"] = "JHG_ROLL_MESSAGE"

	--HandselMsg	text	彩金信息
	dataTable["HandselMsg"] = nMBaseMessage:readString()
	--WinMsgNum	Int		Loop
	dataTable["WinMsgNum"] = {}
	local WinMsgNumCnt = nMBaseMessage:readInt()
	--Common.log("WinMsgNumCnt === "..WinMsgNumCnt)
	for i = 1, WinMsgNumCnt do
		dataTable["WinMsgNum"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…ItemID	Int	信息的ID
		dataTable["WinMsgNum"][i].ItemID = nMBaseMessage:readInt()
		--…msg	Text	中奖信息
		dataTable["WinMsgNum"][i].msg = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[--
--解析金皇冠开始信息(JHG_START_GAME)
--]]
function read80530008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JHG_START_GAME
	dataTable["messageName"] = "JHG_START_GAME"
	--PukeArray	Loop
	dataTable["PukeArray"] = {}
	local PukeArrayCnt = nMBaseMessage:readInt()
	--Common.log("PukeArrayCnt === "..PukeArrayCnt)
	for i = 1, PukeArrayCnt do
		dataTable["PukeArray"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--……puke	Byte	用户的牌
		dataTable["PukeArray"][i].puke = nMBaseMessage:readByte()
		--……isRemain	Byte	是否建议保留	0否，1是
		dataTable["PukeArray"][i].isRemain = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end


--[[--
--解析金皇冠换牌信息(JHG_CHANGE_PAI)
--]]
function read80530009(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JHG_CHANGE_PAI
	dataTable["messageName"] = "JHG_CHANGE_PAI"

	--AfterChangeOfPai	Loop		Loop
	dataTable["AfterChangeOfPai"] = {}
	local AfterChangeOfPaiCnt = nMBaseMessage:readInt()
	--Common.log("AfterChangeOfPaiCnt === "..AfterChangeOfPaiCnt)
	for i = 1, AfterChangeOfPaiCnt do
		dataTable["AfterChangeOfPai"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…pai	Byte	用户换来的牌
		dataTable["AfterChangeOfPai"][i].pai = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end
	--WinType	Byte	中奖类型	1-9，0代表没中奖
	dataTable["WinType"] = nMBaseMessage:readByte()

	--coin	int	赢金币数	>=0
	dataTable["coin"] = nMBaseMessage:readInt()

	--WinPais	Loop		Loop
	dataTable["WinPais"] = {}
	local WinPaisCnt = nMBaseMessage:readInt()
	--Common.log("WinPaisOfPaiCnt === "..WinPaisCnt)
	for i = 1, WinPaisCnt do
		dataTable["WinPais"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…pai	Byte	中奖牌
		dataTable["WinPais"][i].pai = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end

	--Winpool	byte	是否可获得奖池	0 否 1是
	dataTable["Winpool"] = nMBaseMessage:readByte()

	--WinCoinNum 	Int 	获得奖池的金币数
	dataTable["WinCoinNum"] = nMBaseMessage:readInt()

	--pollMsg	Text	获得奖池奖励描述
	dataTable["pollMsg"] = nMBaseMessage:readString()

	--JoinRisk	byte	是否可参加比倍	0 否 1是
	dataTable["JoinRisk"] = nMBaseMessage:readByte()

	--WinTime	Byte[]	可赢次数	加密
	local length = nMBaseMessage:readShort()
	local pos = nMBaseMessage:getReadPos()
	dataTable["WinTime"] = ""
	for i = 1,length do
		if(i ~= length)then
			dataTable["WinTime"] = dataTable["WinTime"]..nMBaseMessage:readByte()..","
		else
			dataTable["WinTime"] = dataTable["WinTime"]..nMBaseMessage:readByte()
		end
	end
	dataTable["WinTime"] = Common.decryptUseDES(dataTable["WinTime"],length,"llypwzh@20131001")

	nMBaseMessage:setReadPos(pos + length)

	--RickMsgUrl	text	比倍关键玩法图片地址
	dataTable["RickMsgUrl"] = nMBaseMessage:readString()
	--Common.log("RiskWinCoinListCnt === "..dataTable.RickMsgUrl)
	--RiskWinCoinList		当前比倍彩金数	loop
	dataTable["RiskWinCoinList"] = {}
	local RiskWinCnt = nMBaseMessage:readInt()
	--Common.log("RiskWinCoinListCnt === "..RiskWinCnt)
	for i = 1, RiskWinCnt do
		dataTable["RiskWinCoinList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…RiskNum	byte	比倍次数
		dataTable["RiskWinCoinList"][i].RiskNum = nMBaseMessage:readByte()
		--…RiskWinCoinNum	int	当前次数所得比倍彩金数
		dataTable["RiskWinCoinList"][i].RiskWinCoinNum = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end
	--SlotScrollTxt	text	比倍条幅文字
	dataTable["SlotScrollTxt"] = nMBaseMessage:readString()
	return dataTable
end

--[[--
--解析金皇冠中奖纪录(JHG_WINNING_RECORD)
--]]
function read8053000c(nMBaseMessage)
	--Common.log("FLY-------------------read8053000c")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHG_WINNING_RECORD
	dataTable["messageName"] = "JHG_WINNING_RECORD"

	dataTable["Timestamp"] = nMBaseMessage:readLong()

	dataTable["RecordList"] = {}
	local RecordList = nMBaseMessage:readInt()
	--Common.log("fly----RecordList === "..RecordList)
	for i = 1, RecordList do
		dataTable["RecordList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…nickname	Text	昵称
		dataTable["RecordList"][i].nickname = nMBaseMessage:readString()
		--…coin	Int	金币数
		dataTable["RecordList"][i].coin = nMBaseMessage:readInt()
		--…play time	Int	比倍次数
		dataTable["RecordList"][i].playTime = nMBaseMessage:readInt()
		--…vip level	Int	Vip等级
		dataTable["RecordList"][i].vipLevel = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--[[--
--解析比倍机收钱信息(JHG_RICK_COLLECT_MONEY)
--]]
function read8053000a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JHG_RICK_COLLECT_MONEY
	dataTable["messageName"] = "JHG_RICK_COLLECT_MONEY"

	--Successed	byte	信息是否提交成功	0 失败 1成功
	dataTable["Successed"] = nMBaseMessage:readByte()
	--Common.log("--金皇冠Successedbyte信息是否提交成功"..dataTable["Successed"])
	--Coin	Int	赢得金币数 >= 0
	dataTable["Coin"] = nMBaseMessage:readInt()
	--Common.log("--金皇冠CoinInt赢得金币数"..dataTable["Coin"])

	return dataTable
end


--[[-- 解析ituns商城验证]]
function read8007001f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_VALIDATE_IAP
	dataTable["messageName"] = "MANAGERID_VALIDATE_IAP"

	--Result  验证结果
	dataTable["Result"] = nMBaseMessage:readString()
	--Common.log("验证结果 = " .. dataTable["Result"])
	--Msg  原因
	dataTable["Msg"] = nMBaseMessage:readString()
	--Common.log("原因 = " .. dataTable["Msg"])
	return dataTable
end

--[[-- lua脚本版本检测]]
function read80070061(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_LUA_SCRIPT_VERSION
	dataTable["messageName"] = "MANAGERID_LUA_SCRIPT_VERSION"
	--ScriptVerCode	Text 脚本版本号
	dataTable["ScriptVerCode"] = nMBaseMessage:readString()
	--updateType	byte	升级方案	0、不升级--1、提示升级--2、强制升级--3、有新版本，不提升(wifi下后台升级)--4、后台升级(wifi、2G下均后台升级)
	dataTable["updateType"] = nMBaseMessage:readByte()
	--updataTxt	Text	升级提示	HTML
	dataTable["updataTxt"] = nMBaseMessage:readString()
	--Common.log("lua脚本版本检测 read " .. dataTable["updataTxt"] .. ";" .. dataTable["updateType"])
	--ScriptUpdateUrl	Text	脚本升级Url地址
	dataTable["ScriptUpdateUrl"] = nMBaseMessage:readString()
	--fileDelListTxtUrl	Text	删除文件列表
	dataTable["fileDelListTxtUrl"] = nMBaseMessage:readString()

	return dataTable
end

--[[-- lua脚本版本MD5校验]]
function read80070062(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_LUA_SCRIPT_MD5
	dataTable["messageName"] = "MANAGERID_LUA_SCRIPT_MD5"

	--isFailure	byte	脚本是否有损坏	0没有损坏1有损坏--如果没有损坏，后面的字段可以不发
	dataTable["isFailure"] = nMBaseMessage:readByte()
	--ScriptVerCode	Text 脚本版本号
	dataTable["ScriptVerCode"] = nMBaseMessage:readString()
	--updataTxt	Text	修复脚本提示	HTML
	dataTable["updataTxt"] = nMBaseMessage:readString()
	--ScriptUpdateUrl	Text	脚本修复Url地址
	dataTable["ScriptUpdateUrl"] = nMBaseMessage:readString()

	return dataTable
end


-----------------解析RankListGetRankDataBean--------------------
function read80650002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + RankListGetRankDataBean
	dataTable["messageName"] = "RankListGetRankDataBean"
	--Common.log("收到排行榜信息")
	--解析List< RankListItem 列表>
	local arrayTable0 = {}
	local cnt = nMBaseMessage:readByte()
	--Common.log("收到排行榜信息cnt",cnt)
	for i0=1,cnt do
		--解析Bean  RankListItem 列表
		beanTable1 = {}
		local length = nMBaseMessage:readShort()
		if length ~= 0 then
			local pos = nMBaseMessage:getReadPos()
			--解析 名次
			beanTable1.rankNum = nMBaseMessage:readInt()
			--解析 头像url
			beanTable1.photoUrl = nMBaseMessage:readUTF()
			--解析 用户昵称
			beanTable1.nickName = nMBaseMessage:readUTF()
			--解析 vip级别
			beanTable1.vipLevel = nMBaseMessage:readInt()
			--Common.log("vip等级别"..beanTable1.vipLevel)
			--解析 在每日金币榜中:代表金币总值 在每日充值榜中:代表当天充值了多少 在每日赢取榜中:代表当天赢取了多少
			beanTable1.rankingData = nMBaseMessage:readLong()
			nMBaseMessage:setReadPos(pos + length)
		end


		arrayTable0[i0] = beanTable1
	end
	dataTable["RankListItemClientList"] = arrayTable0
	--解析 颁奖规则
	dataTable["prizeGivingRule"] = nMBaseMessage:readUTF()
	--Common.log("prizeGivingRule is " ..  dataTable["prizeGivingRule"])
	--解析 我的排名
	dataTable["selfRankingNum"] = nMBaseMessage:readInt()
	--解析 更新时间
	dataTable["updateRankingTime"] = nMBaseMessage:readLong()
	--解析 显示哪一个排行榜1每日赚金榜2今日充值榜3土豪榜4昨日充值榜
	dataTable["witchRankingList"] = nMBaseMessage:readByte()
	return dataTable
end



-----------------解析RankListCheckSelfRankingBean--------------------
function read80650003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + RankListCheckSelfRankingBean
	dataTable["messageName"] = "RankListCheckSelfRankingBean"

	--解析 进入排名提示
	dataTable["enterRankingPrompt"] = nMBaseMessage:readUTF()
	return dataTable
end

-----------------解析打招呼消息--------------------
function read80060025(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_SAY_HELLO
	dataTable["messageName"] = "DBID_V2_SAY_HELLO"

	--解析     0成功1失败
	dataTable["Result"] = nMBaseMessage:readByte()
	--解析 提示语
	dataTable["Msg"] = nMBaseMessage:readString()
	return dataTable
end

-----------------财神基本信息消息-------------------

function read80630001(nMBaseMessage)
	--Common.log("收到财神消息")
	local dataTable = {}
	dataTable["messageType"] = ACK + FORTUNE_GET_INFORMATION
	dataTable["messageName"] = "FORTUNE_GET_INFORMATION"

	--是否可以免费领取;0：不可以；1：可以
	nMBaseMessage:readByte()
	dataTable["FreeAward"] = nMBaseMessage:readByte()
	--当前财运值
	nMBaseMessage:readByte()
	dataTable["FortuneValue"] = nMBaseMessage:readInt()

	--剩余供品数量
	nMBaseMessage:readByte()
	dataTable["SacrificeValue"] = nMBaseMessage:readInt()
	--奖励物品列表<奖品URL,奖品数量>
	nMBaseMessage:readByte()
	dataTable["ArrayList"] = {}
	local ArrayListcont = nMBaseMessage:readByte()

	for i = 1,ArrayListcont do
		dataTable["ArrayList"][i] = {}
		dataTable["ArrayList"][i]["url"] = nMBaseMessage:readUTF()
		dataTable["ArrayList"][i]["num"] = nMBaseMessage:readInt()
	end

	--财神说明
	nMBaseMessage:readByte()
	dataTable["FortuneIntroduction"] = nMBaseMessage:readUTF()
	--财神详情Url
	nMBaseMessage:readByte()
	dataTable["FortuneDetailsUrl"] = nMBaseMessage:readUTF()
	--财运值衰减提示文字
	nMBaseMessage:readByte()
	dataTable["AttenuationTips"] = nMBaseMessage:readUTF()
	--获取财神香提示
	nMBaseMessage:readByte()
	dataTable["caishenchongzhiNotice"] = nMBaseMessage:readUTF()
	return dataTable
end

-----------------解析财神领奖时间同步--------------------
function read80630002(nMBaseMessage)
	--Common.log("收到财神时间同步消息")
	local dataTable = {}
	dataTable["messageType"] = ACK + FORTUNE_TIME_SYNC
	dataTable["messageName"] = "FORTUNE_TIME_SYNC"

	--解析     是否开启财神活动;0：未开启；1：开启
	nMBaseMessage:readByte()
	dataTable["IsOpenFortune"] = nMBaseMessage:readByte()
	--Common.log("IsOpenFortune*********",dataTable["IsOpenFortune"])
	--解析 领奖倒计时(单位：毫秒)(开启状态为1的情况下：0:可领奖励    >0：倒计时时间)
	nMBaseMessage:readByte()
	dataTable["AwardTime"] = tonumber(nMBaseMessage:readLong())
	--Common.log("AwardTime*********",dataTable["AwardTime"])
	return dataTable
end




-----------------解析财神领奖--------------------
function read80630003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + FORTUNE_GET_AWARD
	dataTable["messageName"] = "FORTUNE_GET_AWARD"

	--解析     是否成功
	nMBaseMessage:readByte()
	dataTable["IsSuccess"] = nMBaseMessage:readByte()
	--Common.log("IsSuccess*********",dataTable["IsSuccess"])
	--解析 提示信息
	nMBaseMessage:readByte()
	dataTable["Notice"] = nMBaseMessage:readUTF()
	--Common.log("Notice*********",dataTable["Notice"])
	--获得的奖励物品列表<奖品URL,奖品描述>
	dataTable["ArrayList"] = {}
	nMBaseMessage:readByte()
	local ArrayListcont = nMBaseMessage:readByte()

	for i = 1,ArrayListcont do
		dataTable["ArrayList"][i] = {}
		dataTable["ArrayList"][i]["url"] = nMBaseMessage:readUTF()
		dataTable["ArrayList"][i]["mes"] = nMBaseMessage:readUTF()
		--Common.log("ArrayList*********",dataTable["ArrayList"][i]["url"])
		--Common.log("ArrayList*********",dataTable["ArrayList"][i]["mes"])
	end

	return dataTable
end

-----------------解析财神上香--------------------
function read80630004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + FORTUNE_OFFER_SACRIFICE
	dataTable["messageName"] = "FORTUNE_OFFER_SACRIFICE"


	--解析     是否成功
	nMBaseMessage:readByte()
	dataTable["IsSuccess"] = nMBaseMessage:readByte()
	--Common.log("IsSuccess*********",dataTable["IsSuccess"])
	--解析 提示信息
	nMBaseMessage:readByte()
	dataTable["Notice"] = nMBaseMessage:readUTF()
	--Common.log("Notice*********",dataTable["Notice"])
	--解析 剩余供品数量
	nMBaseMessage:readByte()
	dataTable["SacrificeValue"] = nMBaseMessage:readInt()
	--Common.log("SacrificeValue*********",dataTable["SacrificeValue"])
	--解析 当前财运值
	nMBaseMessage:readByte()
	dataTable["FortuneValue"] = nMBaseMessage:readInt()
	--Common.log("FortuneValue*********",dataTable["FortuneValue"])


	--当前奖励物品列表<奖品URL,奖品数量>
	dataTable["ArrayList"] = {}
	nMBaseMessage:readByte()
	local ArrayListcont = nMBaseMessage:readByte()

	for i = 1,ArrayListcont do
		dataTable["ArrayList"][i] = {}
		dataTable["ArrayList"][i]["url"] = nMBaseMessage:readUTF()
		--Common.log("ArrayList*****url***",dataTable["ArrayList"][i]["url"])
		dataTable["ArrayList"][i]["num"] = nMBaseMessage:readInt()
		--Common.log("ArrayList****num****",dataTable["ArrayList"][i]["num"])
	end

	return dataTable
end



-----------------解析财神通知--------------------
function read80630005(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + FORTUNE_RELEASE_NOTIFICATION
	dataTable["messageName"] = "FORTUNE_RELEASE_NOTIFICATION"

	--解析     财神通知标题
	nMBaseMessage:readByte()
	dataTable["Title"] = nMBaseMessage:readUTF()
	--Common.log("Title****",dataTable["Title"])
	--解析 财神通知内容
	nMBaseMessage:readByte()
	dataTable["Notification"] = nMBaseMessage:readUTF()
	--Common.log("Notification****",dataTable["Notification"])
	return dataTable

end
-----------------第二版VIP信息同步-------------------
function read8007004a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_VIP_MSG
	dataTable["messageName"] = "MANAGERID_GET_VIP_MSG"

	--VipLevel	Int	当前vip等级
	dataTable["VipLevel"] = nMBaseMessage:readInt()
	--VipExpirationDate	Long	Vip到期时间
	dataTable["VipExpirationDate"] = nMBaseMessage:readLong();
	--Amount	Int	当月累计充值金额
	dataTable["Amount"] = nMBaseMessage:readInt()
	--Balance	Int	到达下一级vip的差额
	dataTable["Balance"] = nMBaseMessage:readInt()
	--Common.log("vip22222"..dataTable["VipLevel"]..dataTable["Amount"]..dataTable["Balance"])

	return dataTable
end

--[[-- 解析VIP列表_V3(MANAGERID_VIP_LIST_V3)]]
function read8007004c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_VIP_LIST_V3
	dataTable["messageName"] = "MANAGERID_VIP_LIST_V3"

	--timestamp  时间戳
	dataTable["timestamp"] = nMBaseMessage:readLong()
	--Common.log("时间戳 = " .. dataTable["timestamp"])
	--VipInfo  VIP说明界面信息
	dataTable["VipInfo"] = nMBaseMessage:readString()
	--Common.log("VIP说明界面信息 = " .. dataTable["VipInfo"])
	--VipLooper  VIP信息
	dataTable["vipTable"] = {}
	local VipLooper = nMBaseMessage:readInt()
	for i = 1, VipLooper do
		dataTable["vipTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("vipTable---length = " .. length)
		--…vipLevel  VIP 等级
		dataTable["vipTable"][i].vipLevel = nMBaseMessage:readInt()
		--Common.log("vipTable---VIP 等级 = ".. dataTable["vipTable"][i].vipLevel)
		--…vipQualification  VIP 获得条件
		dataTable["vipTable"][i].vipQualification = nMBaseMessage:readString()
		--Common.log("vipTable---VIP 获得条件 = ".. dataTable["vipTable"][i].vipQualification)
		--…vipPrivilege  VIP 特权
		dataTable["vipTable"][i].vipPrivilege = nMBaseMessage:readString()
		--Common.log("vipTable---VIP 特权 = ".. dataTable["vipTable"][i].vipPrivilege)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[--解析VIP列表_V3(MANAGERID_VIP_LEVEL_LIST)]]
function read8007004d(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MANAGERID_VIP_LEVEL_LIST;
	dataTable["messageName"] = "MANAGERID_VIP_LEVEL_LIST";
	dataTable["VipLevelListTable"] = {};
	local vipLevellist_Count = nMBaseMessage:readInt();
	for i = 1 , vipLevellist_Count do
		dataTable["VipLevelListTable"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		dataTable["VipLevelListTable"][i].vipLevel = nMBaseMessage:readInt();
		dataTable["VipLevelListTable"][i].needMoney = nMBaseMessage:readInt();
		nMBaseMessage:setReadPos(length + pos)
	end
	dataTable["VipMaxLevel"] = nMBaseMessage:readInt();
	return dataTable
end

--[[---------------天梯模块----------------]]

--[[-- 解析天梯排行榜]]
function read80520029(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + LADDER_TOP
	dataTable["messageName"] = "LADDER_TOP"

	--LadderRank  天梯排名
	dataTable["LadderRank"] = nMBaseMessage:readInt()
	--Common.log("天梯排名 = " .. dataTable["LadderRank"])
	--LadderScore  天梯积分
	dataTable["LadderScore"] = nMBaseMessage:readInt()
	--Common.log("天梯积分 = " .. dataTable["LadderScore"])
	--topCnt  排名返回数
	dataTable["TtPaihangtable"] = {}
	local topCnt = nMBaseMessage:readInt()
	for i = 1, topCnt do
		dataTable["TtPaihangtable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("TtPaihangtable---length = " .. length)
		--…rank  排名
		dataTable["TtPaihangtable"][i].rank = nMBaseMessage:readInt()
		--Common.log("TtPaihangtable---排名 = ".. dataTable["TtPaihangtable"][i].rank)
		--…userId  用户id
		dataTable["TtPaihangtable"][i].userId = nMBaseMessage:readInt()
		--Common.log("TtPaihangtable---用户id = ".. dataTable["TtPaihangtable"][i].userId)
		--…userName  用户名
		dataTable["TtPaihangtable"][i].userName = nMBaseMessage:readString()
		--Common.log("TtPaihangtable---用户名 = ".. dataTable["TtPaihangtable"][i].userName)
		--…userPic  用户头像
		dataTable["TtPaihangtable"][i].userPic = nMBaseMessage:readString()
		--Common.log("TtPaihangtable---用户头像 = ".. dataTable["TtPaihangtable"][i].userPic)
		--…score  天梯分
		dataTable["TtPaihangtable"][i].score = nMBaseMessage:readInt()
		--Common.log("TtPaihangtable---天梯分 = ".. dataTable["TtPaihangtable"][i].score)
		--…vip  Vip等级
		dataTable["TtPaihangtable"][i].vip = nMBaseMessage:readInt()
		--Common.log("TtPaihangtable---Vip等级 = ".. dataTable["TtPaihangtable"][i].vip)
		dataTable["TtPaihangtable"][i].duan = nMBaseMessage:readInt()
		--Common.log("TtPaihangtable--- 段位= ".. dataTable["TtPaihangtable"][i].duan)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end
--[[-- 解析天梯领工资]]
function read8052002b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + LADDER_SALARY
	dataTable["messageName"] = "LADDER_SALARY"

	--LadderRank  天梯排名
	dataTable["result"] = nMBaseMessage:readByte()
	--LadderRank  天梯排名
	dataTable["MsgTxt"] = nMBaseMessage:readString()
	--Common.log("天梯领工资2"..dataTable["result"]..dataTable["MsgTxt"])
	return dataTable
end

--[[-- 解析天梯游戏结束]]
function read80520028(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + LADDER_GAME_OVER
	dataTable["messageName"] = "LADDER_GAME_OVER"

	-- changeDuan byte 段改变情况 0 不变，1升级，-1降级
	dataTable["changeDuan"] = nMBaseMessage:readByte();
	-- duan int 段位
	dataTable["duan"] = nMBaseMessage:readInt();
	-- changeRank int 等级改变情况 0 不变，1升级，-1降级
	dataTable["changeRank"] = nMBaseMessage:readByte();
	-- rank int 等级
	dataTable["rank"] = nMBaseMessage:readInt();
	-- score int 当前天梯分
	dataTable["score"] = nMBaseMessage:readInt();
	-- nextScore int 下一等级的天梯分
	dataTable["nextScore"] = nMBaseMessage:readInt();
	-- salary int 工资
	dataTable["salary"] = nMBaseMessage:readInt();
	dataTable["notice1"] = nMBaseMessage:readString();
	dataTable["notice2"] = nMBaseMessage:readString();
	--LadderRank	byte	升级或降级对应的天梯分	Loop
	dataTable["LadderLevel"] = {}
	local LevelCnt = nMBaseMessage:readInt()
	for i = 1, LevelCnt do
		dataTable["LadderLevel"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…duan	int	段
		dataTable["LadderLevel"][i].duan = nMBaseMessage:readInt();
		--…rank	Int	等级
		dataTable["LadderLevel"][i].level = nMBaseMessage:readInt();
		--…score	int	分
		dataTable["LadderLevel"][i].score = nMBaseMessage:readInt();
		nMBaseMessage:setReadPos(pos + length)
	end
	--InitScore	int	当前段初始天梯分
	dataTable["InitScore"] = nMBaseMessage:readInt();
	--round	Int	回合数
	dataTable["round"] = nMBaseMessage:readInt();
	--IsReceiveLadder	Byte	是否领过工资	1没领过 0领过 2没有资格
	dataTable["IsReceiveLadder"] = nMBaseMessage:readByte();
	--Maxduan	Int	历史最高段
	dataTable["maxDuan"] = nMBaseMessage:readInt();
	--掉落物品列表
	dataTable["prizes"] = {}
	local prizeNum = nMBaseMessage:readInt()
	for i = 1, prizeNum do
		dataTable["prizes"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…text	Text	掉落物品名称
		dataTable["prizes"][i].name = nMBaseMessage:readString();
		--…url	text	掉落物品图片
		dataTable["prizes"][i].url = nMBaseMessage:readString();
		--…count	Int	掉落数目
		dataTable["prizes"][i].num = nMBaseMessage:readInt();
		nMBaseMessage:setReadPos(pos + length)
	end
	--tipPrizes	byte	下级奖励提示	Loop
	dataTable["tipPrizes"] = {}
	local tipPrizeNum = nMBaseMessage:readInt()
	for i = 1, tipPrizeNum do
		dataTable["tipPrizes"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…text	Text	奖励物品名称
		dataTable["tipPrizes"][i].name = nMBaseMessage:readString();
		--…url	text	奖励物品图片
		dataTable["tipPrizes"][i].url = nMBaseMessage:readString();
		--…count	Int	奖励数目
		dataTable["tipPrizes"][i].num = nMBaseMessage:readInt();
		nMBaseMessage:setReadPos(pos + length)
	end
	--boxIconUrl	text	升级宝箱图标url
	dataTable["boxIconUrl"] = nMBaseMessage:readString();
	--MaxLevel	Int	历史最高等级（段*100+等级）
	dataTable["maxLevel"] = nMBaseMessage:readInt();

	return dataTable
end

--[[--
--解析天梯帮助
--]]--
function read80520030(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + Ladder_MSG_HELP
	dataTable["messageName"] = "Ladder_MSG_HELP"
	dataTable["helpMSG"] = {}
	local count = nMBaseMessage:readInt()
	for i = 1, count do
		dataTable["helpMSG"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["helpMSG"][i].helpUrl = nMBaseMessage:readString();
		dataTable["helpMSG"][i].helpWord = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end


---------------------比赛相关--------------------------------


--[[--
--解析比赛结果
--]]
function read20009(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = REQ + MATID_RESULT
	dataTable["messageName"] = "MATID_RESULT"

	dataTable["MatchInstanceID"] = nMBaseMessage:readString();
	dataTable["m_nRank"] = nMBaseMessage:readInt();
	-- HaveValuablyAward byte 是否有实物奖励 0无1有
	dataTable["nHaveValuablyAward"] = nMBaseMessage:readByte();
	-- Award text 奖励内容
	dataTable["sAward"] = nMBaseMessage:readString();
	-- ResultCode Text 比赛结果HTML源码
	dataTable["sResultCode"] = nMBaseMessage:readString();
	-- HaveCertificate byte 是否颁发奖状 0否 1是
	dataTable["nHaveCertificate"] = nMBaseMessage:readByte();
	-- Date Text 获奖日期
	dataTable["date"] = nMBaseMessage:readString();
	nMBaseMessage:readByte();
	nMBaseMessage:readString();
	dataTable["PhysicalCnt"] = nMBaseMessage:readByte();

	return dataTable
end

--[[--
--接收当前未结束的牌桌数
--]]
function read8002000b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_TABLE_NOTENDED
	dataTable["messageName"] = "MATID_TABLE_NOTENDED"
	dataTable["m_nNotEndedCnt"] = nMBaseMessage:readShort();
	return dataTable
end

--[[--
--比赛阶段改变
--]]
function read20007(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = REQ + MATID_STATUS_CHANGED
	dataTable["messageName"] = "MATID_STATUS_CHANGED"

	dataTable["MatchInstanceID"] = nMBaseMessage:readString();
	dataTable["nStatusID"] = nMBaseMessage:readByte();
	dataTable["sMsg"] = nMBaseMessage:readString();

	return dataTable
end

--[[-- 斗地主比赛列表]]
function read8002001e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_MATCH_LIST_NEW
	dataTable["messageName"] = "MATID_MATCH_LIST_NEW"

	--SendTimes  比赛列表发送次数
	dataTable["SendTimes"] = nMBaseMessage:readByte()
	--Common.log("比赛列表发送次数 = " .. dataTable["SendTimes"])
	--MatchCnt  比赛数量
	dataTable["MatchList"] = {}
	local MatchCnt = nMBaseMessage:readInt()
	--Common.log("比赛数量 = " .. MatchCnt)
	for i = 1, MatchCnt do
		dataTable["MatchList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("MatchList---length = " .. length)
		--…MatchID  比赛ID
		dataTable["MatchList"][i].MatchID = nMBaseMessage:readInt()
		--Common.log("MatchList---比赛ID = ".. dataTable["MatchList"][i].MatchID)
		--…MatchTitle  比赛标题
		dataTable["MatchList"][i].MatchTitle = nMBaseMessage:readString()
		--Common.log("MatchList---比赛标题 = ".. dataTable["MatchList"][i].MatchTitle)
		--…MatchType  比赛类型
		dataTable["MatchList"][i].MatchType = nMBaseMessage:readByte()
		--Common.log("MatchList---比赛类型 = ".. dataTable["MatchList"][i].MatchType)
		--…TitlePictureUrl  标题图片路径
		dataTable["MatchList"][i].TitlePictureUrl = nMBaseMessage:readString()
		--Common.log("MatchList---标题图片路径 = ".. dataTable["MatchList"][i].TitlePictureUrl)
		--…TagPicUrl  推荐类型url
		dataTable["MatchList"][i].TagPicUrl = nMBaseMessage:readString()
		--Common.log("MatchList---推荐类型url = ".. dataTable["MatchList"][i].TagPicUrl)
		--…PrizeImgUrl  奖品图片（列表）
		dataTable["MatchList"][i].PrizeImgUrl = nMBaseMessage:readString()
		--Common.log("MatchList---奖品图片（列表） = ".. dataTable["MatchList"][i].PrizeImgUrl)
		--…MatchLevel  级别
		dataTable["MatchList"][i].MatchLevel = nMBaseMessage:readByte()
		--Common.log("MatchList---级别 = ".. dataTable["MatchList"][i].MatchLevel)
		--…MatchStatus  赛制状态
		dataTable["MatchList"][i].MatchStatus = nMBaseMessage:readByte()
		--Common.log("MatchList---赛制状态 = ".. dataTable["MatchList"][i].MatchStatus)
		--…DeleteFlag  删除标志
		dataTable["MatchList"][i].DeleteFlag = nMBaseMessage:readByte()
		--Common.log("MatchList---删除标志 = ".. dataTable["MatchList"][i].DeleteFlag)
		--…RegUserCnt  已报名人数
		dataTable["MatchList"][i].RegUserCnt = nMBaseMessage:readShort()
		--Common.log("MatchList---已报名人数 = ".. dataTable["MatchList"][i].RegUserCnt)
		--…MinReg  最小报名人数
		dataTable["MatchList"][i].MinReg = nMBaseMessage:readShort()
		--Common.log("MatchList---最小报名人数 = ".. dataTable["MatchList"][i].MinReg)
		--…MaxReg  最大报名人数
		dataTable["MatchList"][i].MaxReg = nMBaseMessage:readShort()
		--Common.log("MatchList---最大报名人数 = ".. dataTable["MatchList"][i].MaxReg)
		--…StartTime  开赛时间
		dataTable["MatchList"][i].StartTime = nMBaseMessage:readString()
		--Common.log("MatchList---开赛时间 = ".. dataTable["MatchList"][i].StartTime)
		--…Condition  报名条件
		dataTable["MatchList"][i].Condition = nMBaseMessage:readString()

		--…MaxLevelPrize  最高奖品描述
		dataTable["MatchList"][i].MaxLevelPrize = nMBaseMessage:readString()
		--Common.log("MatchList---最高奖励 = ".. dataTable["MatchList"][i].MaxLevelPrize)

		--…MaxLevelPrizePriceUrl  最高奖品图片url
		dataTable["MatchList"][i].MaxLevelPrizePriceUrl = nMBaseMessage:readString()
		--...Orderby  排序
		dataTable["MatchList"][i].Orderby = nMBaseMessage:readByte()
		--...RegType  1 报名 2 激战
		dataTable["MatchList"][i].RegType = nMBaseMessage:readByte()
		--...Honor  赠送荣誉值
		dataTable["MatchList"][i].Honor = nMBaseMessage:readShort()
		--...RegCoin  报名金币数
		dataTable["MatchList"][i].RegCoin = nMBaseMessage:readShort()
		--...RegRongyuzhi  报名荣誉值数
		dataTable["MatchList"][i].RegRongyuzhi = nMBaseMessage:readShort()
		--...NeedTicket  是否用门票报名
		dataTable["MatchList"][i].NeedTicket = nMBaseMessage:readByte()
		--...MinVipLevel  需要的VIP最小等级
		dataTable["MatchList"][i].MinVipLevel = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end
	--TimeStamp  时间戳
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	--Common.log("时间戳 = " .. dataTable["TimeStamp"])
	return dataTable
end

--[[
3.03 斗地主比赛列表
]]
function read80020025(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_MATCH_LIST
	dataTable["messageName"] = "MATID_V4_MATCH_LIST"

	--TimeStamp  时间戳
	dataTable["TimeStamp"] = nMBaseMessage:readLong()

	--MatchCnt  比赛数量
	dataTable["MatchList"] = {}
	local MatchCnt = nMBaseMessage:readInt()
	--Common.log("read80020025 比赛数量 = " .. MatchCnt)

	for i = 1, MatchCnt do
		dataTable["MatchList"][i] = {}
		local length = nMBaseMessage:readShort() -- current loop length
		local pos = nMBaseMessage:getReadPos()
		--Common.log("MatchList---length = " .. length)
		--Common.log("MatchList---pos = " .. pos)

		--…MatchID  比赛ID
		dataTable["MatchList"][i].MatchID = nMBaseMessage:readInt()
		--Common.log("MatchList---比赛ID = ".. dataTable["MatchList"][i].MatchID)

		--…MatchTitle  比赛标题
		dataTable["MatchList"][i].MatchTitle = nMBaseMessage:readString()
		--Common.log("MatchList---比赛标题 = ".. dataTable["MatchList"][i].MatchTitle)

		--…MatchType  比赛类型
		dataTable["MatchList"][i].MatchType = nMBaseMessage:readByte()
		--Common.log("MatchList---比赛类型 = ".. dataTable["MatchList"][i].MatchType)

		--MatchTag
		dataTable["MatchList"][i].MatchTag = nMBaseMessage:readByte()
		--Common.log("MatchList---MatchTag = ".. dataTable["MatchList"][i].MatchTag)

		--…TitlePictureUrl  标题图片路径
		dataTable["MatchList"][i].TitlePictureUrl = nMBaseMessage:readString()
		--Common.log("MatchList---TitlePictureUrl = ".. dataTable["MatchList"][i].TitlePictureUrl)

		--TableType
		dataTable["MatchList"][i].TableType = nMBaseMessage:readByte()
		--Common.log("MatchList---TableType = ".. dataTable["MatchList"][i].TableType)

		--…StartTime  开赛时间
		dataTable["MatchList"][i].matchStartTimeTag = nMBaseMessage:readString()
		--Common.log("MatchList---matchStartTimeTag = ".. dataTable["MatchList"][i].matchStartTimeTag)

		--ConditionText  报名条件
		dataTable["MatchList"][i].ConditionText = nMBaseMessage:readString()
		--Common.log("MatchList---ConditionText = ".. dataTable["MatchList"][i].ConditionText)

		--...Orderby  排序
		dataTable["MatchList"][i].Orderby = nMBaseMessage:readByte()
		--Common.log("MatchList---Orderby = ".. dataTable["MatchList"][i].Orderby)

		--...RegType  1 报名 2 激战
		dataTable["MatchList"][i].RegType = nMBaseMessage:readByte()
		--Common.log("MatchList---RegType = ".. dataTable["MatchList"][i].RegType)

		--Condition  报名条件
		dataTable["MatchList"][i].Condition = nMBaseMessage:readString()
		--Common.log("MatchList---Condition = ".. dataTable["MatchList"][i].Condition)

		--PrizeImgUrl
		dataTable["MatchList"][i].PrizeImgUrl = nMBaseMessage:readString()
		--Common.log("MatchList---PrizeImgUrl = ".. dataTable["MatchList"][i].PrizeImgUrl)

		--PrizeDesc
		dataTable["MatchList"][i].PrizeDesc = nMBaseMessage:readString()
		--Common.log("MatchList---PrizeDesc = ".. dataTable["MatchList"][i].PrizeDesc)

		--freezeCoin
		dataTable["MatchList"][i].freezeCoin = nMBaseMessage:readInt()
		--Common.log("MatchList---freezeCoin = ".. dataTable["MatchList"][i].freezeCoin)

		dataTable["MatchList"][i].specialLabelURL = nMBaseMessage:readString()
		--Common.log("MatchList---specialLabelURL = ".. dataTable["MatchList"][i].specialLabelURL)

		dataTable["MatchList"][i].TicketName = nMBaseMessage:readString()
		--Common.log("MatchList---TicketName = ".. dataTable["MatchList"][i].TicketName)

		dataTable["MatchList"][i].TicketCnt = nMBaseMessage:readShort()
		--Common.log("MatchList---TicketCnt = ".. dataTable["MatchList"][i].TicketCnt)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--[[
3.03 比赛动态信息同步
]]
function read80020026(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_MATCH_SYNC
	dataTable["messageName"] = "MATID_V4_MATCH_SYNC"

	--MatchCnt  比赛数量
	dataTable["MatchList"] = {}
	local MatchCnt = nMBaseMessage:readInt()
	--Common.log("read80020026 比赛数量 = " .. MatchCnt)

	for i = 1, MatchCnt do
		dataTable["MatchList"][i] = {}
		local length = nMBaseMessage:readShort() -- current loop length
		local pos = nMBaseMessage:getReadPos()

		--…MatchID
		dataTable["MatchList"][i].MatchID = nMBaseMessage:readInt()
		--Common.log("MATID_V4_MATCH_SYNC MatchList---比赛ID = ".. dataTable["MatchList"][i].MatchID)

		--MatchStatus
		dataTable["MatchList"][i].MatchStatus = nMBaseMessage:readByte()
		--Common.log("MATID_V4_MATCH_SYNC MatchList---MatchStatus = ".. dataTable["MatchList"][i].MatchStatus)

		--TicketCount
		dataTable["MatchList"][i].TicketCount = nMBaseMessage:readInt()
		--Common.log("MATID_V4_MATCH_SYNC MatchList---TicketCount = ".. dataTable["MatchList"][i].TicketCount)

		--MatchStartTime
		dataTable["MatchList"][i].MatchStartTime = nMBaseMessage:readLong()
		--Common.log("MATID_V4_MATCH_SYNC MatchList---MatchStartTime = ".. dataTable["MatchList"][i].MatchStartTime)

		--RegStatus
		dataTable["MatchList"][i].RegStatus = nMBaseMessage:readByte()
		--Common.log("MATID_V4_MATCH_SYNC MatchList---RegStatus = ".. dataTable["MatchList"][i].RegStatus)

		--playerCnt
		dataTable["MatchList"][i].playerCnt = nMBaseMessage:readInt()
		--Common.log("MATID_V4_MATCH_SYNC MatchList---playerCnt = ".. dataTable["MatchList"][i].playerCnt)

		--matchStartTimeTag
		dataTable["MatchList"][i].matchStartTimeTag = nMBaseMessage:readString()
		--Common.log("MATID_V4_MATCH_SYNC MatchList---matchStartTimeTag = ".. dataTable["MatchList"][i].matchStartTimeTag)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--[[
3.03 比赛报名
]]
function read80020027(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_REG_MATCH
	dataTable["messageName"] = "MATID_V4_REG_MATCH"

	--…MatchID  比赛ID
	dataTable["MatchID"] = nMBaseMessage:readInt()
	--Common.log("read80020027 MatchID "..dataTable["MatchID"])

	--MatchInstanceID
	dataTable["MatchInstanceID"] = nMBaseMessage:readString()

	--Result
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("read80020027 Result = "..dataTable["Result"])

	--Msg
	dataTable["Msg"] = nMBaseMessage:readString()
	--Common.log("read80020027 Msg = "..dataTable["Msg"])

	--MsBeforeMatchStart
	dataTable["MatchStartTime"] = nMBaseMessage:readLong()
	--Common.log("read80020027 MatchStartTime = "..dataTable["MatchStartTime"])

	--TicketID
	dataTable["TicketID"] = nMBaseMessage:readInt()

	--ServerTime	Long	服务器时间	服务器当前时间戳(用于客户端闹铃)
	dataTable["ServerTime"] = nMBaseMessage:readLong()

	--Result
	dataTable["RegType"] = nMBaseMessage:readByte()
	--Common.log("read80020027 RegType = "..dataTable["RegType"])

	return dataTable
end

--[[
3.03 退票V4
]]
function read80020028(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_REFUND
	dataTable["messageName"] = "MATID_V4_REFUND"

	--Result
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("read80020028 Result "..dataTable["Result"])

	--MsgTxt
	dataTable["MsgTxt"] = nMBaseMessage:readString()
	--Common.log("read80020028 MsgTxt "..dataTable["MsgTxt"])

	--…MatchID
	dataTable["MatchID"] = nMBaseMessage:readInt()
	--Common.log("read80020028 MatchID "..dataTable["MatchID"])

	return dataTable
end

--[[
3.03 报名人数同步V4
]]
function read80020029(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_REGCNT
	dataTable["messageName"] = "MATID_V4_REGCNT"

	--RegCnt
	dataTable["RegCnt"] = nMBaseMessage:readShort()

	--MaxRegCnt
	dataTable["MaxRegCnt"] = nMBaseMessage:readShort()
	--Common.log("read80020029 MaxRegCnt = "..dataTable["MaxRegCnt"])

	return dataTable
end

--[[--3.03 开赛通知V4]]
function read8002002a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_START_NOTIFY
	dataTable["messageName"] = "MATID_V4_START_NOTIFY"

	--GameID
	dataTable["GameID"] = nMBaseMessage:readByte()
	--Common.log("read8002002a GameID = "..dataTable["GameID"])

	--MatchInstanceID
	dataTable["MatchInstanceID"] = nMBaseMessage:readString()
	--Common.log("read8002002a MatchInstanceID = "..dataTable["MatchInstanceID"])

	--Msg
	dataTable["Msg"] = nMBaseMessage:readString()
	--Common.log("read8002002a Msg = "..dataTable["Msg"])

	--MatchID
	dataTable["MatchID"] = nMBaseMessage:readInt()
	--Common.log("read8002002a MatchID = "..dataTable["MatchID"])

	dataTable["regCnt"] = nMBaseMessage:readShort()
	--Common.log("read8002002a regCnt = "..dataTable["regCnt"])

	dataTable["maxRegCnt"] = nMBaseMessage:readShort()
	--Common.log("read8002002a maxRegCnt = "..dataTable["maxRegCnt"])

	return dataTable
end

--[[
3.03 进入比赛V4
]]
function read8002002b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_ENTER_MATCH
	dataTable["messageName"] = "MATID_V4_ENTER_MATCH"

	--Result
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("read8002002b Result = "..dataTable["Result"])

	--ResultMsg
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	--Common.log("read8002002b ResultMsg = "..dataTable["ResultMsg"])

	--GameID
	dataTable["GameID"] = nMBaseMessage:readByte()
	--Common.log("read8002002b GameID = "..dataTable["GameID"])

	--MatchTitle
	dataTable["MatchTitle"] = nMBaseMessage:readString()
	--Common.log("read8002002b MatchTitle = "..dataTable["MatchTitle"])

	--MatchID
	dataTable["MatchID"] = nMBaseMessage:readInt()
	--Common.log("read8002002b MatchID = "..dataTable["MatchID"])

	return dataTable
end

--[[
3.03 比赛V4进入充值等待区
]]
function read8002002c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_RECHARGE_WAITING
	dataTable["messageName"] = "MATID_V4_RECHARGE_WAITING"

	--MatchInstanceID
	dataTable["MatchInstanceID"] = nMBaseMessage:readInt()
	--Common.log("read8002002c MatchInstanceID = "..dataTable["MatchInstanceID"])

	--GiftId
	dataTable["GiftId"] = nMBaseMessage:readInt()
	--Common.log("read8002002c GiftId = "..dataTable["GiftId"])

	dataTable["ReliefTime"] = nMBaseMessage:readByte()
	--Common.log("read8002002c ReliefTime = "..dataTable["ReliefTime"])

	dataTable["MinCoin"] = nMBaseMessage:readInt()
	--Common.log("read8002002c MinCoin = "..dataTable["MinCoin"])

	return dataTable
end

--[[
3.03 比赛排名V4
]]
function read8002002e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_RANK
	dataTable["messageName"] = "MATID_V4_RANK"

	dataTable["playerCount"] = nMBaseMessage:readInt()
	--Common.log("read8002002e playerCount = "..dataTable["playerCount"])

	-- 读取LOOP的规则
	dataTable["RankList"] = {}
	local count = nMBaseMessage:readInt()
	--Common.log("read8002002e count = "..count)

	for i = 1, count do
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["RankList"][i] = {}
		dataTable["RankList"][i]["rank"] = nMBaseMessage:readInt()
		--Common.log("read8002002e rank = "..dataTable["RankList"][i]["rank"])

		dataTable["RankList"][i]["score"] = nMBaseMessage:readInt()
		--Common.log("read8002002e score = "..dataTable["RankList"][i]["score"])

		dataTable["RankList"][i]["NickName"] = nMBaseMessage:readString()
		--Common.log("read8002002e NickName = "..dataTable["RankList"][i]["NickName"])

		dataTable["RankList"][i]["photoUrl"] = nMBaseMessage:readString()
		--Common.log("read8002002e photoUrl = "..dataTable["RankList"][i]["photoUrl"])

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--[[
3.03 比赛等待分桌V4
]]
function read8002002f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_WAITING
	dataTable["messageName"] = "MATID_V4_WAITING"

	dataTable["TipString"] = nMBaseMessage:readString()
	--Common.log("TipString = "..dataTable["TipString"])

	return dataTable
end

--[[
3.03 比赛排名同步V4
]]
function read80020030(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_PROMPT_SYNC
	dataTable["messageName"] = "MATID_V4_PROMPT_SYNC"

	dataTable["matchInstance"] = nMBaseMessage:readString()
	--Common.log("read80020030 matchInstance = "..dataTable["matchInstance"])

	dataTable["Rank"] = nMBaseMessage:readInt()
	--Common.log("read80020030 Rank = "..dataTable["Rank"])

	dataTable["playerCount"] = nMBaseMessage:readInt() -- 当前剩余玩家数量

	dataTable["PromptMsg"] = nMBaseMessage:readString()
	--Common.log("read80020030 PromptMsg = "..dataTable["PromptMsg"])

	return dataTable
end

--[[
3.03 比赛奖状V4
]]
function read80020031(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_CERTIFICATE
	dataTable["messageName"] = "MATID_V4_CERTIFICATE"

	dataTable["ResultText"] = nMBaseMessage:readString()
	--Common.log("ResultText = "..dataTable["ResultText"])

	dataTable["CertificateType"] = nMBaseMessage:readByte()
	--Common.log("CertificateType = "..dataTable["CertificateType"])

	dataTable["Date"] = nMBaseMessage:readString()
	--Common.log("Date = "..dataTable["Date"])

	dataTable["PhysicalCnt"] = nMBaseMessage:readByte()
	--Common.log("PhysicalCnt = "..dataTable["PhysicalCnt"])

	dataTable["AwardPicUrl"] = nMBaseMessage:readString()
	--Common.log("AwardPicUrl = "..dataTable["AwardPicUrl"])

	dataTable["Awards"] = {}
	local count = nMBaseMessage:readInt()
	--Common.log("read80020031 count = "..count)

	for i = 1, count do
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["Awards"][i] = {}
		dataTable["Awards"][i]["AwardsContent"] = nMBaseMessage:readString()
		dataTable["Awards"][i]["AwardsPic"] = nMBaseMessage:readString()
		--Common.log("AwardsContent = "..dataTable["Awards"][i]["AwardsContent"])
		--Common.log("AwardsPic = "..dataTable["Awards"][i]["AwardsPic"])
		nMBaseMessage:setReadPos(pos + length)
	end

	dataTable["MatchStatusLevel"] = nMBaseMessage:readInt()
	--Common.log("MatchStatusLevel = "..dataTable["MatchStatusLevel"])
	dataTable["Rank"] = nMBaseMessage:readInt()
	dataTable["matchID"] = nMBaseMessage:readInt()
	dataTable["matchTitle"] = nMBaseMessage:readString()
	return dataTable
end

--[[
3.03 比赛复活结果通知 V4
]]
function read80020032(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_RESUME_NOTIFY
	dataTable["messageName"] = "MATID_V4_RESUME_NOTIFY"

	dataTable["NotifyStr"] = nMBaseMessage:readString()
	--Common.log("NotifyStr = "..dataTable["NotifyStr"])

	dataTable["syncUserID"] = nMBaseMessage:readInt()
	--Common.log("syncUserID = "..dataTable["syncUserID"])

	dataTable["coin"] = nMBaseMessage:readInt()
	--Common.log("coin = "..dataTable["coin"])

	dataTable["TrustType"] = nMBaseMessage:readByte()
	--Common.log("TrustType = "..dataTable["TrustType"])

	return dataTable
end

--[[
3.03 比赛小提示V4
]]
function read80020033(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_TIPS
	dataTable["messageName"] = "MATID_V4_TIPS"

	dataTable["TipText"] = nMBaseMessage:readString()
	--Common.log("TipText = "..dataTable["TipText"])

	dataTable["tipIndex"] = nMBaseMessage:readInt()
	--Common.log("tipIndex = "..dataTable["tipIndex"])

	return dataTable
end

--[[-- 解析同步比赛列表]]
function read80020012(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V2_MATCH_LIST_SYNC
	dataTable["messageName"] = "MATID_V2_MATCH_LIST_SYNC"

	--MatchCnt  比赛数量
	--Common.log("解析同步比赛列表")
	dataTable["Match"] = {}
	local MatchCnt = nMBaseMessage:readShort()
	for i = 1, MatchCnt do
		dataTable["Match"][i] = {}
		--local length = nMBaseMessage:readShort()
		--local pos = nMBaseMessage:getReadPos()
		--...MatchID  比赛ID
		dataTable["Match"][i].MatchID = nMBaseMessage:readShort()
		--Common.log("比赛ID = " .. dataTable["Match"][i].MatchID)
		--...MatchStatus  比赛状态
		dataTable["Match"][i].MatchStatus = nMBaseMessage:readByte()
		--Common.log("比赛状态 = " .. dataTable["Match"][i].MatchStatus)
		--...MatchStartTime  比赛开始时间
		dataTable["Match"][i].MatchStartTime = nMBaseMessage:readString()
		--Common.log("比赛开始时间 = " .. dataTable["Match"][i].MatchStartTime)
		--...MatchStartTime  比赛开始时间
		dataTable["Match"][i].MatchStartTimeLong = nMBaseMessage:readLong()
		--Common.log("比赛开始时间 = " .. dataTable["Match"][i].MatchStartTime)
		--…RegType  是否报名本场比赛
		dataTable["Match"][i].RegType = nMBaseMessage:readByte()
		--Common.log("Match---是否报名本场比赛 = "..dataTable["Match"][i].RegType)
		--....playerCnt  激战人数
		dataTable["Match"][i].playerCnt = nMBaseMessage:readShort()
		--Common.log("激战人数 = " .. dataTable["Match"][i].playerCnt)

		--nMBaseMessage:setReadPos(pos + length)
	end
	--HasTicket  有门票比赛IDs
	dataTable["HasTicket"] = nMBaseMessage:readString()
	--Common.log("有门票比赛IDs = " .. dataTable["HasTicket"])
	return dataTable
end
--[[-- 解析比赛同步消息]]
function read8002000a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_MATCH_LIST_REGCNT
	dataTable["messageName"] = "MATID_MATCH_LIST_REGCNT"

	dataTable["Match"] = {}
	local MatchCnt = nMBaseMessage:readShort()
	for i = 1, MatchCnt do
		dataTable["Match"][i] = {}
		dataTable["Match"][i].MatchID = nMBaseMessage:readInt()
		dataTable["Match"][i].RegCnt = nMBaseMessage:readInt()

	end
	--Common.log("报名人数同步"..#dataTable["Match"])
	return dataTable
end

--[[-- 解析报名参赛]]
function read80020003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_REG_MATCH
	dataTable["messageName"] = "MATID_REG_MATCH"

	--MatchID  比赛ID
	dataTable["MatchID"] = nMBaseMessage:readInt()
	--Common.log("比赛ID = " .. dataTable["MatchID"])
	--MatchInstanceID  比赛实例ID
	dataTable["MatchInstanceID"] = nMBaseMessage:readString()
	--Common.log("比赛实例ID = " .. dataTable["MatchInstanceID"])
	--Result  报名结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("报名结果 = " .. dataTable["Result"])
	--Msg  原因
	dataTable["Msg"] = nMBaseMessage:readString()
	--Common.log("原因 = " .. dataTable["Msg"])
	--MsBeforeMatchStart  还有多少毫秒开赛
	dataTable["MsBeforeMatchStart"] = nMBaseMessage:readLong()
	--Common.log("还有多少毫秒开赛 = " .. dataTable["MsBeforeMatchStart"])
	return dataTable
end

--[[-- 解析报名参赛]]
function read80040007(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GAMEID_REG_MATCH
	dataTable["messageName"] = "GAMEID_REG_MATCH"

	--MatchID  比赛ID
	dataTable["MatchID"] = nMBaseMessage:readInt()
	--Common.log("比赛ID = " .. dataTable["MatchID"])
	--MatchInstanceID  比赛实例ID
	dataTable["MatchInstanceID"] = nMBaseMessage:readString()
	--Common.log("比赛实例ID = " .. dataTable["MatchInstanceID"])
	--Result  报名结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("报名结果 = " .. dataTable["Result"])
	--Msg  原因
	dataTable["Msg"] = nMBaseMessage:readString()
	--Common.log("原因 = " .. dataTable["Msg"])
	--MsBeforeMatchStart  还有多少毫秒开赛
	dataTable["MsBeforeMatchStart"] = nMBaseMessage:readLong()
	--Common.log("还有多少毫秒开赛 = " .. dataTable["MsBeforeMatchStart"])
	--TicketID	int	门票ID
	dataTable["TicketID"] = nMBaseMessage:readInt()
	return dataTable
end

--[[-- 解析开赛通知]]
function read20004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = REQ + MATID_START_NOTIFY
	dataTable["messageName"] = "MATID_START_NOTIFY"

	--GameID  游戏ID
	dataTable["GameID"] = nMBaseMessage:readByte()
	--Common.log("游戏ID = " .. dataTable["GameID"])
	--MatchInstanceID  比赛实例ID
	dataTable["MatchInstanceID"] = nMBaseMessage:readString()
	--Common.log("比赛实例ID = " .. dataTable["MatchInstanceID"])
	--Msg  开赛提示语
	dataTable["Msg"] = nMBaseMessage:readString()
	--Common.log("开赛提示语 = " .. dataTable["Msg"])
	--MatchID  比赛ID
	dataTable["MatchID"] = nMBaseMessage:readInt()
	--Common.log("比赛ID = " .. dataTable["MatchID"])
	return dataTable
end
--[[-- 解析进入比赛]]
function read80020005(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_ENTER_MATCH
	dataTable["messageName"] = "MATID_ENTER_MATCH"

	--Result  进入结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("进入结果 = " .. dataTable["Result"])
	--ResultMsg  提示语
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	--Common.log("提示语 = " .. dataTable["ResultMsg"])
	--GameID
	dataTable["GameID"] = nMBaseMessage:readByte()
	--Common.log(" = " .. dataTable["GameID"])
	--MatchTitle  比赛标题
	dataTable["MatchTitle"] = nMBaseMessage:readString()
	--Common.log("比赛标题 = " .. dataTable["MatchTitle"])
	--MatchID  比赛ID
	dataTable["MatchID"] = nMBaseMessage:readInt()
	--Common.log("比赛ID = " .. dataTable["MatchID"])
	return dataTable
end

--[[-- 解析比赛玩家列表]]
function read8002001c(nMBaseMessage)
	if MatchRankingLogic.m_nReadAllUserCnt > 0 then
		return;
	end
	MatchRankingLogic.m_nReadAllUserCnt = 1
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V28_ALL_USER_LIST
	dataTable["messageName"] = "MATID_V28_ALL_USER_LIST"
	--	UserCnt	Byte	用户数量
	dataTable["UserCnt"] = nMBaseMessage:readByte()
	dataTable["UserList"] = {};
	for i = 1, dataTable["UserCnt"] do
		dataTable["UserList"][i] = {};
		--...NickName	Text	昵称
		dataTable["UserList"][i].NickName = nMBaseMessage:readString()
		--...Chip	Int	积分
		dataTable["UserList"][i].Chip = nMBaseMessage:readInt()
		--...VipLevel	Int	用户VIP等级
		dataTable["UserList"][i].VipLevel = nMBaseMessage:readInt()
	end
	--SelfRank	Short	名次	分批次发送时，只在第一个包中发送
	dataTable["SelfRank"] = nMBaseMessage:readShort()
	--PhotoUrl1st	Text	第一名PhotoUrl	分批次发送时，只在第一个包中发送
	dataTable["PhotoUrl1st"] = nMBaseMessage:readString()
	--PhotoUrl2nd	Text	第二名PhotoUrl	分批次发送时，只在第一个包中发送
	dataTable["PhotoUrl2nd"] = nMBaseMessage:readString()
	--PhotoUrl3th	Text	第三名PhotoUrl	分批次发送时，只在第一个包中发送
	dataTable["PhotoUrl3th"] = nMBaseMessage:readString()
	return dataTable

end

--[[-- 解析玩家报名条件列表]]
function read80020023(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_MATCH_CONDITIONS
	dataTable["messageName"] = "MATID_MATCH_CONDITIONS"

	--MatchCnt  比赛数量
	dataTable["MatchCnt"] = nMBaseMessage:readInt()
	local cnt = dataTable["MatchCnt"]
	--Common.log("解析玩家报名条件列表比赛数量 = " .. dataTable["MatchCnt"])
	dataTable["MatchList"] = {}
	for i = 1,cnt do
		dataTable["MatchList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--...MatchId  比赛Id
		dataTable["MatchList"][i].MatchId = nMBaseMessage:readInt()
		--Common.log("解析玩家报名条件列表比赛数量比赛Id = " ..dataTable["MatchList"][i].MatchId)
		--...ConditionCnt  报名条件数量
		local ConditionCnt = nMBaseMessage:readInt()
		if ConditionCnt == 0 then
			dataTable["MatchList"][i].ConditionCnt = 1
			dataTable["MatchList"][i]["1"] = {}
			-- ......OptionsCnt Int 条件值
			dataTable["MatchList"][i]["1"].OptionsCnt = 0;
			-- ......OptionsCode Byte 报名条件编码
			dataTable["MatchList"][i]["1"].OptionsCode = 100;
			-- ......OptionsDesc Text 报名条件描述
			dataTable["MatchList"][i]["1"].OptionsDesc = "";
			-- ......Enable Byte 是否满足条件
			dataTable["MatchList"][i]["1"].Enable = 1;
		else
			dataTable["MatchList"][i].ConditionCnt = ConditionCnt
			for j = 1, ConditionCnt do
				dataTable["MatchList"][i][""..j] = {}
				local length = nMBaseMessage:readShort()
				local pos = nMBaseMessage:getReadPos()
				--Common.log("解析玩家报名条件列表比赛数量Table---length = " .. length)
				--......OptionsCnt  条件值
				dataTable["MatchList"][i][""..j].OptionsCnt = nMBaseMessage:readInt()
				--Common.log("解析玩家报名条件列表比赛数量条件值 = " .. dataTable["MatchList"][i][j].OptionsCnt)
				--......OptionsCode  报名条件编码
				dataTable["MatchList"][i][""..j].OptionsCode = nMBaseMessage:readByte()
				--Common.log("解析玩家报名条件列表比赛数量报名条件编码 = " .. dataTable["MatchList"][i][j].OptionsCode)
				--......OptionsDesc  报名条件描述
				dataTable["MatchList"][i][""..j].OptionsDesc = nMBaseMessage:readString()
				--Common.log("解析玩家报名条件列表比赛数量报名条件描述 = " .. dataTable["MatchList"][i][j].OptionsDesc)
				--......Enable  是否满足条件
				dataTable["MatchList"][i][""..j].Enable = nMBaseMessage:readByte()
				--Common.log("解析玩家报名条件列表比赛数量是否满足条件 = " .."=="..j.. dataTable["MatchList"][i][j].Enable)
				nMBaseMessage:setReadPos(pos + length)

			end
		end
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--3.2.36 获取本期之星信息
function read80020024(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_STAR_INFO
	dataTable["messageName"] = "MATID_STAR_INFO"
	--NickName	String	本期之星昵称
	dataTable["NickName"] = nMBaseMessage:readString()
	--Common.log("MATID_STAR_INFO NickName " .. dataTable["NickName"])
	--HeadPic	String	本期之星头像图片地址
	dataTable["HeadPic"] = nMBaseMessage:readString()
	--Common.log("MATID_STAR_INFO HeadPic " .. dataTable["HeadPic"])
	--AwardPic String 本期之星奖品图片地址
	dataTable["AwardPic"] = nMBaseMessage:readString()
	--Common.log("MATID_STAR_INFO AwardPic " .. dataTable["AwardPic"])
	--MatchPic String 本期之星比赛名称图片地址
	dataTable["MatchPic"] = nMBaseMessage:readString()
	--Common.log("MATID_STAR_INFO MatchPic " .. dataTable["MatchPic"])
	--AwardDesc String 本期之星获奖详细信息文本
	dataTable["AwardDesc"] = nMBaseMessage:readString()
	--Common.log("MATID_STAR_INFO AwardDesc " .. dataTable["AwardDesc"])
	return dataTable
end

--3.2.19比赛列表报名人数
function read80020013(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V2_MATCH_LIST_REGCNT
	dataTable["messageName"] = "MATID_V2_MATCH_LIST_REGCNT"
	--RegCnt	Short	报名人数
	dataTable["RegCnt"] = nMBaseMessage:readShort()

	return dataTable
end


--[[--接受是否有新的公告]]
function read8007006c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_HAVE_NEW_GONGGAO
	dataTable["messageName"] = "MANAGERID_GET_HAVE_NEW_GONGGAO"
	--Result	byte	结果	0：没有新公告;1：有新公告
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("read8007006c Result " .. dataTable["Result"])
	return dataTable
end

function read8007006d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_V3_GET_ACTIVITY_LIST
	dataTable["messageName"] = "MANAGERID_V3_GET_ACTIVITY_LIST"
	--UrlCnt	活动数量
	dataTable["UrlCnt"] = nMBaseMessage:readInt()
	--Common.log("活动数 = " .. dataTable["UrlCnt"])
	dataTable["UrlList"] = {}
	for i = 1, dataTable["UrlCnt"] do
		dataTable["UrlList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Url Text 图片地址
		dataTable["UrlList"][i].Url = nMBaseMessage:readString()
		--Common.log("read8007006d Url " .. dataTable["UrlList"][i].Url)
		--Title Text 活动标题
		dataTable["UrlList"][i].Title = nMBaseMessage:readString()
		--Common.log("read8007006d Title " .. dataTable["UrlList"][i].Title)
		--Date Text 活动日期
		dataTable["UrlList"][i].Date = nMBaseMessage:readString()
		--Common.log("read8007006d Date " .. dataTable["UrlList"][i].Date)
		--ActionID Byte 动作类型
		dataTable["UrlList"][i].ActionID = nMBaseMessage:readByte()
		--Common.log("read8007006d ActionID " .. dataTable["UrlList"][i].ActionID)
		--ParamCnt Byte 参数数量
		dataTable["UrlList"][i].ParamCnt = nMBaseMessage:readByte()
		--Common.log("read8007006d ParamCnt " .. dataTable["UrlList"][i].ParamCnt)
		dataTable["UrlList"][i]["ParamVal"] = {}
		for j = 1,dataTable["UrlList"][i]["ParamCnt"] do
			dataTable["UrlList"][i]["ParamVal"][j] = nMBaseMessage:readString()
			--Common.log("read8007006d ParamVal " .. dataTable["UrlList"][i]["ParamVal"][j])
		end
		nMBaseMessage:setReadPos(pos + length)
	end
	dataTable["time"] = nMBaseMessage:readLong()
	--Common.log("read8007006d time " .. dataTable["time"])
	return dataTable
end

function read8007006e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_DAILY_SIGN_V4
	dataTable["messageName"] = "MANAGERID_DAILY_SIGN_V4"

	dataTable["isFirstSign"] = nMBaseMessage:readByte()
	--Common.log("read8007006e isFirstSign " .. dataTable["isFirstSign"])
	dataTable["continueDays"] = nMBaseMessage:readInt()
	--Common.log("read8007006e continueDays " .. dataTable["continueDays"])
	dataTable["multiple"] = nMBaseMessage:readString()
	--Common.log("read8007006e multiple " .. dataTable["multiple"])
	dataTable["RewardCnt"] = nMBaseMessage:readInt()
	--Common.log("read8007006e RewardCnt " .. dataTable["RewardCnt"])
	dataTable["rewardList"] = {}
	for i = 1, dataTable["RewardCnt"] do
		dataTable["rewardList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--nowCoin Int 当前金币奖励
		dataTable["rewardList"][i].nowCoin = nMBaseMessage:readInt()
		--Common.log("read8007006e nowCoin " .. dataTable["rewardList"][i].nowCoin)
		--nowPiece Int 当前碎片奖励
		dataTable["rewardList"][i].nowPiece = nMBaseMessage:readInt()
		--Common.log("read8007006e nowPiece " .. dataTable["rewardList"][i].nowPiece)
		--nextCoin Int 下等级金币奖励
		dataTable["rewardList"][i].nextCoin = nMBaseMessage:readInt()
		--Common.log("read8007006e nextCoin " .. dataTable["rewardList"][i].nextCoin)
		--nextPiece Int 下等级碎片奖励
		dataTable["rewardList"][i].nextPiece = nMBaseMessage:readInt()
		--Common.log("read8007006e nextPiece " .. dataTable["rewardList"][i].nextPiece)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--是否有新活动
function read8007006f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_HAVE_NEW_HUODONG
	dataTable["messageName"] = "MANAGERID_GET_HAVE_NEW_HUODONG"
	--Result	byte	结果	0：没有新活动;1：有新活动
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("read8007006f result " .. dataTable["Result"])
	return dataTable
end

--获取可兑奖的奖品列表
function read80070070(nMBaseMessage)
	--Common.log("read80070070 ")
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_EXCHANGBLE_AWARDS
	dataTable["messageName"] = "MANAGERID_GET_EXCHANGBLE_AWARDS"
	dataTable["ExchangableAwardsList"] = {}
	local ExchangableAwardsListCnt = nMBaseMessage:readInt();
	--Common.log("read80070070 Cnt " .. ExchangableAwardsListCnt)
	for i = 1, ExchangableAwardsListCnt do
		dataTable["ExchangableAwardsList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …AwardID Int 奖品id
		dataTable["ExchangableAwardsList"][i].awardID = nMBaseMessage:readInt();
		--Common.log("read80070070 awardID " .. dataTable["ExchangableAwardsList"][i].awardID)
		-- …AwardStatus Int 奖品状态
		dataTable["ExchangableAwardsList"][i].awardStatus = nMBaseMessage:readInt();
		--Common.log("read80070070 awardStatus " .. dataTable["ExchangableAwardsList"][i].awardStatus)
		-- …AwardMsg Text 可合成兑奖提示信息
		dataTable["ExchangableAwardsList"][i].awardMsg = nMBaseMessage:readString();
		--Common.log("read80070070 awardMsg " .. dataTable["ExchangableAwardsList"][i].awardMsg)
		-- …AwardNeedYuanBao	Int	充值引导所需要的元宝数	只有需要充值引导才可合成兑奖时才返回,否则返回0
		dataTable["ExchangableAwardsList"][i].awardNeedYuanBao = nMBaseMessage:readInt();
		--Common.log("read80070070 awardNeedYuanBao " .. dataTable["ExchangableAwardsList"][i].awardNeedYuanBao)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--------------------活动解析---------------------

--[[--
---解析宝盒V3：获取宝盒进度(BAOHE_V4_GET_PRO)
--]]
function read8061001a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BAOHE_V4_GET_PRO
	dataTable["messageName"] = "BAOHE_V4_GET_PRO"
	--RoomLevel	Byte	房间等级	0,1,2,3
	dataTable["RoomLevel"] = nMBaseMessage:readByte()
	--Progress  已完成局数
	dataTable["Progress"] = nMBaseMessage:readShort()
	--Common.log("已完成局数 = " .. dataTable["Progress"])
	--Max  总局数
	dataTable["Max"] = nMBaseMessage:readShort()
	--Common.log("总局数 = " .. dataTable["Max"])
	return dataTable
end
--[[--
---解析宝盒V3：获取宝盒列表(BAOHE_V4_GET_LIST)
--]]
function read8061001b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BAOHE_V4_GET_LIST
	dataTable["messageName"] = "BAOHE_V4_GET_LIST"

	dataTable["TreasureBoxList"] = {}
	--	TreasureBoxList	loop	宝盒列表
	local BoxNum = nMBaseMessage:readInt()
	for i = 1, BoxNum do
		dataTable["TreasureBoxList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…Position	byte	宝盒编号（从左至右0，1，2）
		dataTable["TreasureBoxList"][i].Position = nMBaseMessage:readByte()
		--…state	byte		0：未打开 1：已打开
		dataTable["TreasureBoxList"][i].state = nMBaseMessage:readByte()
		--…description	Text	宝盒奖品描述	未打开的宝盒数据传空字符串
		dataTable["TreasureBoxList"][i].description = nMBaseMessage:readString()
		--…PrizeUrl	Text	宝盒奖品图片	未打开的宝盒数据传空字符串
		dataTable["TreasureBoxList"][i].PrizeUrl = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--最多开几次宝盒
	dataTable["openCountMax"] = nMBaseMessage:readInt();
	return dataTable
end
--[[--
---解析宝盒V3：宝盒领奖(BAOHE_V4_GET_PRIZE)
--]]
function read8061001c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BAOHE_V4_GET_PRIZE
	dataTable["messageName"] = "BAOHE_V4_GET_PRIZE"
	--Result	Byte	1 成功 0 失败
	dataTable["Result"] = nMBaseMessage:readByte()
	--ResultMsg	Text	提示语
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	dataTable["TreasurePrizeList"] = {}
	--TreasureCnt	Loop	奖励物品个数
	local PrizeNum = nMBaseMessage:readInt()
	for i = 1, PrizeNum do
		dataTable["TreasurePrizeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…TreasurePicUrl	Text	物品图片url
		dataTable["TreasurePrizeList"][i].TreasurePicUrl = nMBaseMessage:readString()
		--…TreasureDiscription	Text	物品描述
		dataTable["TreasurePrizeList"][i].TreasureDiscription = nMBaseMessage:readString()
		--…Multiple	int	奖品倍数
		dataTable["TreasurePrizeList"][i].Multiple = nMBaseMessage:readInt()
		--…lastTreasureCount	int	最终奖品数目
		dataTable["TreasurePrizeList"][i].lastTreasureCount = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end

	dataTable["TreasureBoxList"] = {}
	--	TreasureBoxList	loop	宝盒列表
	local BoxNum = nMBaseMessage:readInt()
	for i = 1, BoxNum do
		dataTable["TreasureBoxList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…Position	byte	宝盒编号（从左至右0，1，2）
		dataTable["TreasureBoxList"][i].Position = nMBaseMessage:readByte()
		--…state	byte		0：未打开 1：已打开
		dataTable["TreasureBoxList"][i].state = nMBaseMessage:readByte()
		--…description	Text	宝盒奖品描述
		dataTable["TreasureBoxList"][i].description = nMBaseMessage:readString()
		--…PrizeUrl	Text	宝盒奖品图片
		dataTable["TreasureBoxList"][i].PrizeUrl = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--Progress	Short	已完成局数
	dataTable["Progress"] = nMBaseMessage:readShort()
	--Max  总局数
	dataTable["Max"] = nMBaseMessage:readShort()
	--Position	byte	宝盒编号（从左至右0，1，2）
	dataTable["Position"] = nMBaseMessage:readByte()
	return dataTable
end

--[[--
--解析退票
--]]
function read80020008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_REFUND
	dataTable["messageName"] = "MATID_REFUND"
	--Result  退出结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--MsgTxt  结果描述
	dataTable["MsgTxt"] = nMBaseMessage:readString()
	--MatchID  比赛ID
	dataTable["MatchID"] = nMBaseMessage:readInt()
	--Common.log("退赛回来"..dataTable["Result"].."=="..dataTable["MsgTxt"].."=="..dataTable["MatchID"])
	return dataTable
end



--[[--
--解析OPERID_GET_OPER_TASK_LIST_V2
--]]
function read80610036(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GET_OPER_TASK_LIST_V2
	dataTable["messageName"] = "OPERID_GET_OPER_TASK_LIST_V2"

	local arrayTable0 = {}
	dataTable["operTaskList"] = {}
	local Cnt = nMBaseMessage:readInt();
	--Common.log("huodong...cnt = " .. Cnt)
	--	dataTable["typeList"] = {};
	for i = 1, Cnt do
		--		dataTable["typeList"][i] = {};
		arrayTable0[i] = {}
		local beanTable1 = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--TaskID
		beanTable1.taskId= nMBaseMessage:readInt();
		--Common.log("huodong...TaskId = " .. beanTable1.taskId)
		--活动图片URL
		beanTable1.taskPhotoUrl = nMBaseMessage:readString();
		--Common.log("huodong...TaskPhotoUrl = " .. beanTable1.taskPhotoUrl)
		--活动名称
		beanTable1.taskTitle = nMBaseMessage:readString();
		--Common.log("huodong...TaskTitle = " .. beanTable1.taskTitle)
		--活动时间提示
		beanTable1.taskTimePrompt = nMBaseMessage:readString();
		--Common.log("huodong...TaskTimePrompt = " .. beanTable1.taskTimePrompt)
		--是否需要更新
		beanTable1.isUpdate = nMBaseMessage:readByte();
		--Common.log("huodong...isUpdate = " .. beanTable1.isUpdate)
		--脚本升级Url地址
		beanTable1.ScriptUpdateUrl = nMBaseMessage:readString()
		--Common.log("huodong...ScriptUpdateUrl = " .. beanTable1.ScriptUpdateUrl)
		--删除文件列表
		beanTable1.fileDelListTxtUrl = nMBaseMessage:readString();
		--Common.log("huodong...fileDelListTxtUrl = " .. beanTable1.fileDelListTxtUrl)
		nMBaseMessage:setReadPos(pos + length);
		arrayTable0[i] = beanTable1
	end
	dataTable["operTaskList"] = arrayTable0
	return dataTable
end

--[[--
--解析OPERID_GET_DAILY_NOTIFY_INFO
--]]
function read80610037(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GET_DAILY_NOTIFY_INFO
	dataTable["messageName"] = "OPERID_GET_DAILY_NOTIFY_INFO"

	--StarNickName	String	本期之星昵称
	dataTable["StarNickName"] = nMBaseMessage:readString()
	--Common.log("read80610037 StarNickName is " .. dataTable["StarNickName"])
	--StarAwardPic	String	本期之星获奖图片
	dataTable["StarAwardPic"] = nMBaseMessage:readString()
	--Common.log("read80610037 StarAwardPic is " .. dataTable["StarAwardPic"])
	--StarAwardTimeStamp	Long	本期之星时间戳
	dataTable["StarAwardTimeStamp"] = nMBaseMessage:readLong()
	--Common.log("read80610037 StarAwardTimeStamp is " .. dataTable["StarAwardTimeStamp"])
	--StarAwardDesc	String	本期之星获奖详细文本
	dataTable["StarAwardDesc"] = nMBaseMessage:readString()
	--Common.log("read80610037 StarAwardDesc is " .. dataTable["StarAwardDesc"])

	--NotifyInfoList	Loop	公告与活动的列表	Loop
	local NotifyInfoListCnt = nMBaseMessage:readInt()
	dataTable["NotifyInfoListCnt"] = NotifyInfoListCnt
	--Common.log("read80610037 NotifyInfoListCnt is " .. NotifyInfoListCnt)
	dataTable["NotifyInfoList"] = {}
	for i = 1, NotifyInfoListCnt do
		dataTable["NotifyInfoList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--NotifyName	String	公告或者活动的名字
		dataTable["NotifyInfoList"][i]["NotifyName"] = nMBaseMessage:readString()
		--Common.log("read80610037 NotifyName is " .. dataTable["NotifyInfoList"][i]["NotifyName"])
		--NotifyStamp	Long	公告的时间戳
		dataTable["NotifyInfoList"][i]["NotifyStamp"] = nMBaseMessage:readLong()
		--Common.log("read80610037 StarAwardTimeStamp is " .. dataTable["NotifyInfoList"][i]["NotifyStamp"])
		--NofityType	Int	        类型:用于标示是公告还是活动	    0:公告 1:活动
		dataTable["NotifyInfoList"][i]["NofityType"] = nMBaseMessage:readInt()
		--Common.log("read80610037 NofityType is " .. dataTable["NotifyInfoList"][i]["NofityType"])
		--NotifyDes	String	所要展示的内容	当是活动时:此处为活动的图片地址  当是公告时:此处为公告的具体内容
		dataTable["NotifyInfoList"][i]["NotifyDes"] = nMBaseMessage:readString()
		--Common.log("read80610037 NotifyDes is " .. dataTable["NotifyInfoList"][i]["NotifyDes"])
		--NotifyParamID	String	活动参数ID	标示是哪个活动,用于触发事件
		dataTable["NotifyInfoList"][i]["NotifyParamID"] = nMBaseMessage:readString()
		--Common.log("read80610037 NotifyParamID is " .. dataTable["NotifyInfoList"][i]["NotifyParamID"])

		nMBaseMessage:setReadPos(pos + length)
	end
	dataTable["GongGaoLastTimeStamp"] = nMBaseMessage:readLong()
	return dataTable
end



--[[--
--解析OPERID_GET_OPER_TASK_LIST
--]]
function read80610005(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GET_OPER_TASK_LIST
	dataTable["messageName"] = "OPERID_GET_OPER_TASK_LIST"


	--解析List<活动列表>
	local arrayTable0 = {}
	local cnt = nMBaseMessage:readByte()
	--Common.log("cnt = " .. cnt)
	for i0=1,cnt do
		--解析Bean 活动列表
		local beanTable1 = {}
		local length = nMBaseMessage:readShort()
		if length ~= 0 then
			local pos = nMBaseMessage:getReadPos()
			--解析 活动ID
			beanTable1.taskId = nMBaseMessage:readInt()
			--Common.log("taskId = " .. beanTable1["taskId"])
			--解析 活动图片URL
			beanTable1.taskPhotoUrl = nMBaseMessage:readUTF()
			--Common.log("taskPhotoUrl = " .. beanTable1["taskPhotoUrl"])
			--解析 活动名称
			beanTable1.taskTitle = nMBaseMessage:readUTF()
			--Common.log("taskTitle = " .. beanTable1["taskTitle"])
			--解析 活动时间提示
			beanTable1.taskTimePrompt = nMBaseMessage:readUTF()
			--Common.log("taskTimePrompt = " .. beanTable1["taskTimePrompt"])
			nMBaseMessage:setReadPos(pos + length)
		end
		arrayTable0[i0] = beanTable1
	end
	dataTable["operTaskList"] = arrayTable0
	dataTable["huoDongInfo"] = nMBaseMessage:readUTF()
	return dataTable
end



-----------------解析OPERID_GODDESS_GET_INFO--------------------
function read80610006(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GODDESS_GET_INFO
	dataTable["messageName"] = "OPERID_GODDESS_GET_INFO"
	--解析List<爱心排行榜<昵称，爱心值>>
	arrayTable2 = {}
	local cnt = nMBaseMessage:readByte()

	for i2=1,cnt do
		arrayTable2[i2] = {}
		arrayTable2[i2].username = nMBaseMessage:readUTF()
		arrayTable2[i2].Likeability = nMBaseMessage:readInt()
	end
	dataTable["LikeabilityList"] = arrayTable2
	--解析List<奖品列表>
	arrayTable3 = {}
	local cnt = nMBaseMessage:readByte()
	for i3=1,cnt do
		--解析Bean 奖品列表
		beanTable4 = {}
		local length = nMBaseMessage:readShort()
		if length ~= 0 then
			local pos = nMBaseMessage:getReadPos()
			--解析 奖品1图标Url
			beanTable4.gifturl1 = nMBaseMessage:readUTF()
			--Common.log("beanTable4.gifturl1",beanTable4.gifturl1)
			--解析 奖品1数量
			beanTable4.giftnum1 = nMBaseMessage:readInt()
			--Common.log("beanTable4.giftnum1",beanTable4.giftnum1)
			--解析 奖品2图标Url
			beanTable4.gifturl2 = nMBaseMessage:readUTF()
			--Common.log("beanTable4.gifturl2",beanTable4.gifturl2)
			--解析 奖品2数量
			beanTable4.giftnum2 = nMBaseMessage:readInt()
			--Common.log("beanTable4.giftnum2",beanTable4.giftnum2)
			--解析 获得奖品需要的局数
			beanTable4.giftLevel = nMBaseMessage:readInt()
			--Common.log("beanTable4.giftLevel",beanTable4.giftLevel)
			--解析 奖品状态。0为不能领；1为可以领；2为领取完了
			beanTable4.giftStatus = nMBaseMessage:readInt()
			--Common.log("beanTable4.giftStatus",beanTable4.giftStatus)
			nMBaseMessage:setReadPos(pos + length)
		end
		arrayTable3[i3] = beanTable4
	end


	dataTable["GiftList"] = arrayTable3
	--解析 我的排名

	dataTable["SelfRank"] = nMBaseMessage:readInt()
	--Common.log("SelfRank",dataTable["SelfRank"])
	--解析 任务完成度。百分比
	dataTable["rateofprogress"] = nMBaseMessage:readInt()
	--Common.log("rateofprogress",dataTable["rateofprogress"])
	--解析 刷新任务所需的元宝数
	dataTable["expend"] = nMBaseMessage:readInt()
	--Common.log("expend",dataTable["expend"])
	--解析 活动结束倒计时
	dataTable["Time"] = nMBaseMessage:readLong()
	--Common.log("Time",dataTable["Time"])
	--已经打了多少局
	dataTable["completeNum"] = nMBaseMessage:readInt()
	--勤劳值
	dataTable["labourValue"] = nMBaseMessage:readInt()
	--Common.log("labourValue = ",dataTable["labourValue"])
	return dataTable
end


-----------------解析OPERID_GODDESS_RESET--------------------
function read80610007(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GODDESS_RESET
	dataTable["messageName"] = "OPERID_GODDESS_RESET"
	--解析 刷新是否成功
	dataTable["isSuccesse"] = nMBaseMessage:readByte()
	--解析 提示信息
	dataTable["Mes"] = nMBaseMessage:readUTF()
	--Common.log("Mes",dataTable["Mes"])
	return dataTable
end



-----------------解析OPERID_GODDESS_GET_GIFT--------------------
function read80610008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GODDESS_GET_GIFT
	dataTable["messageName"] = "OPERID_GODDESS_GET_GIFT"
	--解析 领取是否成功
	dataTable["isSuccesse"] = nMBaseMessage:readInt()
	--解析 提示信息
	dataTable["Mes"] = nMBaseMessage:readUTF()
	--Common.log("Mes",dataTable["Mes"])
	--解析List<奖品列表>
	arrayTable5 = {}
	local cnt = nMBaseMessage:readByte()
	--Common.log("zblzxcnt=",cnt)
	for i5=1,cnt do
		arrayTable5[i5] = {}
		arrayTable5[i5].url = nMBaseMessage:readUTF()
		--Common.log("zblzxurl",arrayTable5[i5].url)
		arrayTable5[i5].mes = nMBaseMessage:readUTF()
		--Common.log("zblzxmes",arrayTable5[i5].mes)
	end
	dataTable["Awardlist"] = arrayTable5
	--解析 我的排名
	dataTable["SelfRank"] = nMBaseMessage:readInt()
	--Common.log("SelfRank",dataTable["SelfRank"])
	--解析List<爱心排行榜<昵称，爱心值>>
	arrayTable6 = {}
	local cnt = nMBaseMessage:readByte()
	for i6=1,cnt do
		arrayTable6[i6] = {}
		arrayTable6[i6].username = nMBaseMessage:readUTF()
		arrayTable6[i6].Likeability = nMBaseMessage:readInt()
	end
	dataTable["LikeabilityList"] = arrayTable6
	dataTable["GiftID"] = nMBaseMessage:readInt()
	return dataTable
end



---------------------福星高照-----------------
-----------------解析FxgzGetInfo--------------------
function read80610009(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_FXGZ_GET_INFO
	dataTable["messageName"] = "OPERID_FXGZ_GET_INFO"
	--解析 能够获取的最高奖励
	dataTable["TopAward"] = nMBaseMessage:readInt()
	--解析 下注金额
	dataTable["Xiazhu"] = nMBaseMessage:readInt()
	--解析 剩余次数
	dataTable["ShengYu"] = nMBaseMessage:readInt()
	return dataTable
end



-----------------解析OPERID_FXGZ_PLAY--------------------
function read8061000a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_FXGZ_PLAY
	dataTable["messageName"] = "OPERID_FXGZ_PLAY"

	--解析 是否成功
	dataTable["isSuccesse"] = nMBaseMessage:readInt()
	--解析 提示信息
	dataTable["Mes"] = nMBaseMessage:readUTF()
	--解析 本次获得元宝数
	dataTable["Money"] = nMBaseMessage:readInt()
	return dataTable
end


--9.1.1获取当前每日任务(DAILYTASKID_CURRENT_TASK)

function read80090001(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DAILYTASKID_CURRENT_TASK
	dataTable["messageName"] = "DAILYTASKID_CURRENT_TASK"
	--TaskID	int	任务ID
	dataTable["TaskID"] = nMBaseMessage:readInt()
	--Common.log("TaskID",dataTable["TaskID"])

	--TaskTitle	Text	任务标题
	dataTable["Title"] = nMBaseMessage:readString()
	--Common.log("Title",dataTable["Title"])

	--StarLevel	Int	星级
	dataTable["StarLevel"] = nMBaseMessage:readInt()
	--Common.log("StarLevel",dataTable["StarLevel"])

	--Description	Text	描述
	dataTable["Description"] = nMBaseMessage:readString()
	--Common.log("Description",dataTable["Description"])

	--Proceeding	Byte	进度
	dataTable["Proceeding"] = nMBaseMessage:readByte()
	--Common.log("Proceeding",dataTable["Proceeding"])

	--AllProceeding	Byte	总进度数
	dataTable["AllProceeding"] = nMBaseMessage:readByte()
	--Common.log("AllProceeding",dataTable["AllProceeding"])

	--Award	Text	奖励
	dataTable["Award"] = nMBaseMessage:readString()
	--Common.log("Award",dataTable["Award"])

	--RefreshTime	Int	刷新次数
	dataTable["RefreshTime"] = nMBaseMessage:readInt()
	--Common.log("RefreshTime",dataTable["SelfRefreshTimeRank"])

	--RefreshPrice	Int	刷新价格
	dataTable["RefreshPrice"] = nMBaseMessage:readInt()
	--Common.log("RefreshPrice",dataTable["RefreshPrice"])

	--CompletePrice	Int	直接完成价格
	dataTable["CompletePrice"] = nMBaseMessage:readInt()
	--Common.log("CompletePrice",dataTable["CompletePrice"])


	--CurrentStarLevel	Int	当前星级
	dataTable["CurrentStarLevel"] = nMBaseMessage:readInt()
	--Common.log("CurrentStarLevel",dataTable["CurrentStarLevel"])

	return dataTable
end
--9.1.2 五星任务奖励(DAILYTASKID_FIVESTAR_AWARD)
function read80090002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DAILYTASKID_FIVESTAR_AWARD
	dataTable["messageName"] = "DAILYTASKID_FIVESTAR_AWARD"

	dataTable["gift"] = {}

	local cnt = nMBaseMessage:readInt();
	for i = 1, cnt do

		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		dataTable["gift"][i] = {}
		dataTable["gift"][i].Title = nMBaseMessage:readString()
		--Common.log("Title",dataTable["gift"][i].Title)

		dataTable["gift"][i].TitleUrl = nMBaseMessage:readString()
		--Common.log("TitleUrl",dataTable["gift"][i].TitleUrl)

		dataTable["gift"][i].isGiven = nMBaseMessage:readByte()
		--Common.log("isGiven",dataTable["gift"][i].isGiven)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--9.1.3手动刷新任务(DAILYTASKID_REFRESH_TASK)
function read80090003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DAILYTASKID_REFRESH_TASK
	dataTable["messageName"] = "DAILYTASKID_REFRESH_TASK"

	--Result	Byte	0-成功 1-没有足够元宝 2-任务没有初始化过
	dataTable["Result"] = nMBaseMessage:readByte()
	--Message	Text	失败原因
	dataTable["Message"] = nMBaseMessage:readString()
	return dataTable
end

---- 9.1.4立即完成(DAILYTASKID_COMPLETE_TASK)
function read80090004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DAILYTASKID_COMPLETE_TASK
	dataTable["messageName"] = "DAILYTASKID_COMPLETE_TASK"

	--Result	byte	结果是否领取成功1是0否
	dataTable["Result"] = nMBaseMessage:readByte()
	--Message	Text	消息
	dataTable["Message"] = nMBaseMessage:readString()
	return dataTable
end


---- 9.1.5领取奖励(DAILYTASKID_GET_AWARD)
function read80090005(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DAILYTASKID_GET_AWARD
	dataTable["messageName"] = "DAILYTASKID_GET_AWARD"

	--Result	Byte	0-失败 1-成功 2-VIP 5星 3 iOS需要充值后才能领5星奖

	dataTable["Result"] = nMBaseMessage:readByte()
	--Message	Text	消息
	dataTable["Message"] = nMBaseMessage:readString()

	--AwardMessage	Text	奖品消息（2000金币）
	dataTable["AwardMessage"] = nMBaseMessage:readString()

	--AwardUrl	Text	奖品URL
	dataTable["AwardUrl"] = nMBaseMessage:readString()

	return dataTable
end

--9.1.6任务状态变化(DAILYTASKID_TASK_STATUS_CHANGE)
function read80090006(nMBaseMessage)
	--Common.log("readDAILYTASKID_TASK_STATUS_CHANGE")
	local dataTable = {}
	dataTable["messageType"] = ACK + DAILYTASKID_TASK_STATUS_CHANGE
	dataTable["messageName"] = "DAILYTASKID_TASK_STATUS_CHANGE"

	--Result	Byte	0-否 1-第一次领取 2-完成
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("readDAILYTASKID_TASK_STATUS_CHANGE result " .. dataTable["Result"])
	return dataTable
end

--[[-- 解析合成信息]]
function read80070051(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_COMPOUND_INFO
	dataTable["messageName"] = "MANAGERID_COMPOUND_INFO"

	--CompoundNum  合成信息数量
	dataTable["ComTable"] = {}
	local CompoundNum = nMBaseMessage:readInt()
	--Common.log("ComTable---合成信息 = ".. CompoundNum)
	for i = 1, CompoundNum do
		dataTable["ComTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("ComTable---length = " .. length)
		--…ItemID  信息的ID
		dataTable["ComTable"][i].ItemID = nMBaseMessage:readInt()
		--Common.log("ComTable---信息的ID = ".. dataTable["ComTable"][i].ItemID)
		--…CompoundText  合成信息
		dataTable["ComTable"][i].CompoundText = nMBaseMessage:readString()
		--Common.log("ComTable---合成信息 = ".. dataTable["ComTable"][i].CompoundText)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--聊天
function read80110008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + LORDID_CHAT_MSG
	dataTable["messageName"] = "LORDID_CHAT_MSG"
	-- FromUserID int 发言者UID
	dataTable["FromUserID"] = nMBaseMessage:readInt()
	-- ToUserID int 互动类聊天的目标玩家UID 非互动类写0
	dataTable["ToUserID"] = nMBaseMessage:readInt()
	-- ChatType byte 1文字2表情3互动
	dataTable["ChatType"] = nMBaseMessage:readByte()
	-- ChatContent text 聊天语内容 服务器仅仅做转发，不理解其内容
	dataTable["ChatContent"] = nMBaseMessage:readString()
	-- CostCoin int 花费的金币数
	dataTable["CostCoin"] = nMBaseMessage:readInt()

	--Common.log("聊天返回"..dataTable["FromUserID"].."-"..dataTable["ChatType"].."-"..dataTable["ChatContent"])

	return dataTable
end

--新手任务基本信息
function read80650010(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + COMMONS_V3_NEWUSER_TASK_INFO;
	dataTable["messageName"] = "COMMONS_V3_NEWUSER_TASK_INFO";
	--当前任务号
	dataTable["taskNum"] = nMBaseMessage:readInt();
	--当前任务是否完成，1完成，0未完成
	dataTable["isComplete"] = nMBaseMessage:readByte();
	--任务标题
	dataTable["taskTitle"] = nMBaseMessage:readString();
	--任务达成条件
	dataTable["taskRequirement"] = nMBaseMessage:readString();
	--任务进度
	dataTable["taskSchedule"] = nMBaseMessage:readString();
	--任务奖励
	dataTable["taskAward"] = nMBaseMessage:readString();
	local AwardList = nMBaseMessage:readInt();
	dataTable["awardList"] = {};
	for i = 1,AwardList do
		dataTable["awardList"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		dataTable["awardList"][i].picUrl = nMBaseMessage:readString();
		dataTable["awardList"][i].awardDescription = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(length + pos);
	end
	return dataTable;
end

--新手任务是否完成
function read80650011(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + COMMONS_V3_NEWUSER_TASK_IS_COMPLETE;
	dataTable["messageName"] = "COMMONS_V3_NEWUSER_TASK_IS_COMPLETE";
	--完成任务号，如果全部完成传-1，0全部未完成
	dataTable["taskNum"] = nMBaseMessage:readInt();
	return dataTable;
end

--新手任务奖励
function read80650012(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + COMMONS_V3_NEWUSER_TASK_AWARD;
	dataTable["messageName"] = "COMMONS_V3_NEWUSER_TASK_AWARD";
	--新手任务号
	dataTable["taskNum"] = nMBaseMessage:readInt();
	--是否领奖成功，1成功，0未成功
	dataTable["isSuccess"] = nMBaseMessage:readByte();
	--是否所有奖励都领取，1全领取，0未全领取
	dataTable["allComplete"] = nMBaseMessage:readByte();
	--提示语
	dataTable["ResultTxt"] = nMBaseMessage:readString();
	local AwardList = nMBaseMessage:readInt();
	dataTable["awardList"] = {};
	for i=1,AwardList do
		dataTable["awardList"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		dataTable["awardList"][i].PicUrl = nMBaseMessage:readString();
		dataTable["awardList"][i].PicDescription = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(length + pos);
	end
	return dataTable;
end


--跳过新手引导
function read8065000c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + COMMONS_SKIP_NEWUSERGUIDE;
	dataTable["messageName"] = "COMMONS_SKIP_NEWUSERGUIDE"
	--是否跳过成功，0未成功，1成功
	dataTable["SkipResult"] = nMBaseMessage:readByte();
	--跳过提示语
	dataTable["SkipTxt"] = nMBaseMessage:readString();
	return dataTable
end

--同步新手引导状态
function read8065000f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + COMMONS_SYN_NEWUSERGUIDE_STATE;
	dataTable["messageName"] = "COMMONS_SYN_NEWUSERGUIDE_STATE"

	--IsComplete 判断新手引导是否完成，0未完成，1完成，2已跳过
	dataTable["IsComplete"] = nMBaseMessage:readByte();
	--Common.log("判断新手引导是否完成，0未完成，1完成，2已跳过dataTable.IsComplete ==="..dataTable["IsComplete"]);
	--新手引导状态列表
	dataTable["TaskStateLoop"] = nMBaseMessage:readInt();
	dataTable["TaskState"] = {};
	for i = 1,dataTable["TaskStateLoop"] do
		dataTable["TaskState"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--任务编号    1注册，2打牌，3兑奖，4领话费
		dataTable["TaskState"][i].TaskType = nMBaseMessage:readByte();
		--判断是否完成任务,0未完成,1完成
		dataTable["TaskState"][i].TaskState = nMBaseMessage:readByte();
		nMBaseMessage:setReadPos(length + pos);
	end
	return dataTable;

end

--获取新手引导基本信息
function read8065000d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + COMMONS_GET_BASEINFO_NEWUSERGUIDE
	dataTable["messageName"] = "COMMONS_GET_BASEINFO_NEWUSERGUIDE"
	local PromptValue = nMBaseMessage:readInt()
	dataTable["TaskMsgLoop"] = {}
	for i=1,PromptValue do
		dataTable["TaskMsgLoop"][i] = {}
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--任务编号    1注册，2打牌，3兑奖，4领话费
		dataTable["TaskMsgLoop"][i].TaskType = nMBaseMessage:readByte();
		--获取提示内容
		dataTable["TaskMsgLoop"][i].ResultTxt = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(length + pos);
	end

	return dataTable
end

--领取新手引导奖励
function read8065000e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + COMMONS_GET_NEWUSERGUIDE_AWARD
	dataTable["messageType"] = "COMMONS_GET_NEWUSERGUIDE_AWARD"
	--新手引导阶段类型,1注册，2打牌，3兑奖，4领话费
	dataTable["TaskType"] = nMBaseMessage:readByte()
	--是否领取成功，0未成功，1成功
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("新手引导领取奖励是否成功========"..dataTable["Result"]);
	--提示语
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--新手任务奖品
	local PrizeLoopCnt = nMBaseMessage:readInt()
	dataTable["PrizeLoop"] = {}
	for i=1,PrizeLoopCnt do
		dataTable["PrizeLoop"][i] = {}
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		dataTable["PrizeLoop"][i].PrizeUrl = nMBaseMessage:readString()
		dataTable["PrizeLoop"][i].PrizeDescription = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(length + pos);
	end
	return dataTable
end

--新手引导方案
function read80650013(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + COMMONS_GET_NEWUSERGUIDE_SCHEME
	dataTable["messageType"] = "COMMONS_GET_NEWUSERGUIDE_SCHEME"
	--是否进行过公共模块新手引导，1是，0否
	dataTable["isFinishCommon"] = nMBaseMessage:readByte()
	--Common.log("新手引导方案，服务器向客户端发送数据！");
	return dataTable
end

--根据URL获取web页面源码
function read80650014(nMBaseMessage)
	--Common.log("read80650014-------------------------")
	local dataTable = {}
	dataTable["messageType"] = ACK + COMMONS_HTTPPROXY
	dataTable["messageType"] = "COMMONS_HTTPPROXY"
	--是否进行过公共模块新手引导，1是，0否
	dataTable["HashCode"] = nMBaseMessage:readInt()
	dataTable["Html"] = nMBaseMessage:readString()
	dataTable["Key"] = nMBaseMessage:readString()
	print(dataTable.Html, "Html = ")
	return dataTable
end

--天梯阶段信息
function read80620004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + LADDERID2_LADDER_LEVEL_UP_NOTICE
	dataTable["messageName"] = "LADDERID2_LADDER_LEVEL_UP_NOTICE"

	--byte
	nMBaseMessage:readByte()
	--length
	local cnt1 = nMBaseMessage:readByte()
	dataTable["jiangli"] = {}
	for i = 1, cnt1 do
		dataTable["jiangli"][i] = {}
		--天梯等级
		nMBaseMessage:readByte()
		dataTable["jiangli"][i].ladderLevel = nMBaseMessage:readInt()
		--当前等级奖励累计金币数，到达5级或10级才能领取。（界面上的分子）
		nMBaseMessage:readByte()
		dataTable["jiangli"][i].currentCoinCnt = nMBaseMessage:readInt()
		--到达5或10级领取金币数（0表示已领过）（界面上的分母）
		nMBaseMessage:readByte()
		dataTable["jiangli"][i].sumCoinCnt = nMBaseMessage:readInt()
		--获取奖品描述（例：达到青铜5级时一次性发放）
		nMBaseMessage:readByte()
		dataTable["jiangli"][i].getCoinDes = nMBaseMessage:readUTF()
		--Common.log("天体阶段信息"..dataTable["jiangli"][i].ladderLevel.."-"..dataTable["jiangli"][i].currentCoinCnt)
		--Common.log("天体阶段信息"..dataTable["jiangli"][i].sumCoinCnt.."-"..dataTable["jiangli"][i].getCoinDes)
		nMBaseMessage:readByte()
	end
	--byte
	nMBaseMessage:readByte()
	--length
	local cnt2 = nMBaseMessage:readByte()
	dataTable["tequan"] = {}
	for i = 1, cnt2 do
		dataTable["tequan"][i] = {}
		--天梯等级
		nMBaseMessage:readByte()
		dataTable["tequan"][i].ladderLevel = nMBaseMessage:readInt()
		--新等级特权HTML
		nMBaseMessage:readByte()
		dataTable["tequan"][i].privilegeHtml = nMBaseMessage:readUTF()
		--Common.log("天体阶段信息"..dataTable["tequan"][i].ladderLevel.."-"..dataTable["tequan"][i].privilegeHtml)
		nMBaseMessage:readByte()
	end
	return dataTable

end

--获取未使用门票数量
function read8007003f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_UNUSED_TICKET_CNT
	dataTable["messageName"] = "MANAGERID_GET_UNUSED_TICKET_CNT"
	dataTable["number"] = nMBaseMessage:readShort()
	return dataTable
end

--[[----------获取活动走马灯信息----------]]
function read8061000b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_ACTIVITY_MARQUEE
	dataTable["messageName"] = "OPERID_ACTIVITY_MARQUEE"
	--firstStrNum是游戏产生的走马灯消息数
	dataTable["firstStrNum"] = nMBaseMessage:readByte()
	--Common.log("read8061000b firstStrNum == " .. dataTable["firstStrNum"])
	--firstStrTable是游戏产生的走马灯消息Table
	dataTable["firstStrTable"] = {}
	for i=1, dataTable["firstStrNum"] do
		dataTable["firstStrTable"][i] = nMBaseMessage:readUTF()
		--Common.log("read8061000b firstStrTable == " .. dataTable["firstStrTable"][i])
	end
	--secStrNum是游戏策划想让玩家看到的走马灯消息数
	dataTable["secStrNum"] = nMBaseMessage:readByte()
	--Common.log("read8061000b secStrNum == " .. dataTable["secStrNum"])
	--secStrTable是游戏策划想让玩家看到的走马灯消息Table
	dataTable["secStrTable"] = {}
	for i=1, dataTable["secStrNum"] do
		dataTable["secStrTable"][i] = nMBaseMessage:readUTF()
		--Common.log("read8061000b secStrTable == " .. dataTable["secStrTable"][i])
	end
	return dataTable
end

--[[-------------请求现金奖品列表 (OPERID_GET_CASH_AWARD_LIST)------------]]
function read80610012(nMBaseMessage)
	--Common.log("read80610012 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GET_CASH_AWARD_LIST
	dataTable["messageName"] = "OPERID_GET_CASH_AWARD_LIST"
	local AwardsListCnt = nMBaseMessage:readInt()
	dataTable["AwardsList"] = {}
	for i = 1, AwardsListCnt do
		dataTable["AwardsList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …awardID int 物品id
		dataTable["AwardsList"][i].GoodID = nMBaseMessage:readInt() + 10000;
		--Common.log("read80610012 Loop " .. i .. " awardID == " .. dataTable["AwardsList"][i].GoodID)
		-- …shortName String 短名称
		dataTable["AwardsList"][i].ShortName = nMBaseMessage:readString();
		--Common.log("read80610012 Loop " .. i .. " shortName == " .. dataTable["AwardsList"][i].ShortName)
		-- …name String 名称
		dataTable["AwardsList"][i].Name = nMBaseMessage:readString();
		--Common.log("read80610012 Loop " .. i .. " name == " .. dataTable["AwardsList"][i].Name)
		-- …prize int 需要兑奖券价格
		dataTable["AwardsList"][i].Prize = nMBaseMessage:readInt();
		--Common.log("read80610012 Loop " .. i .. " prize == " .. dataTable["AwardsList"][i].Prize)
		-- …picture String 列表界面大图
		dataTable["AwardsList"][i].Picture = nMBaseMessage:readString();
		--Common.log("read80610012 Loop " .. i .. " picture == " .. dataTable["AwardsList"][i].Picture)
		-- …description String 明细界面的说明
		dataTable["AwardsList"][i].Description = nMBaseMessage:readString();
		--Common.log("read80610012 Loop " .. i .. " description == " .. dataTable["AwardsList"][i].Description)
		-- …AwardStatus Int 是否可兑奖
		dataTable["AwardsList"][i].AwardStatus = nMBaseMessage:readInt();
		--Common.log("read80610012 Loop " .. i .. " AwardStatus == " .. dataTable["AwardsList"][i].AwardStatus)
		-- …AwardMsg String 可合成兑奖提示信息
		dataTable["AwardsList"][i].AwardMsg = nMBaseMessage:readString();
		--Common.log("read80610012 Loop " .. i .. " AwardMsg == " .. dataTable["AwardsList"][i].AwardMsg)
		-- …AwardNeedYuanBao	Int	充值引导所需要的元宝数	只有需要充值引导才可合成兑奖才返回,否则返回0
		dataTable["AwardsList"][i].AwardNeedYuanBao = nMBaseMessage:readInt();
		--Common.log("read80610012 Loop " .. i .. " AwardNeedYuanBao == " .. dataTable["AwardsList"][i].AwardNeedYuanBao)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-------------请求同步现金限量奖品数量 (OPERID_GET_CASH_AWARD_REMAINDER)------------]]
function read80610013(nMBaseMessage)
	--Common.log("read80610013 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GET_CASH_AWARD_REMAINDER
	dataTable["messageName"] = "OPERID_GET_CASH_AWARD_REMAINDER"
	local RemainderListCnt = nMBaseMessage:readInt()
	dataTable["RemainderList"] = {}
	for i = 1, RemainderListCnt do
		dataTable["RemainderList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …awardID int 物品id
		dataTable["RemainderList"][i].awardID = nMBaseMessage:readInt() + 10000;
		--Common.log("read80610013 Loop " .. i .. " awardID == " .. dataTable["RemainderList"][i].awardID)
		-- …remainder int 剩余数目
		dataTable["RemainderList"][i].remainder = nMBaseMessage:readInt();
		--Common.log("read80610013 Loop " .. i .. " remainder == " .. dataTable["RemainderList"][i].remainder)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-------------请求兑换限量奖品 (OPERID_EXCHANGE_LIMITED_AWARD)------------]]
function read80610014(nMBaseMessage)
	--Common.log("read80610014 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_EXCHANGE_LIMITED_AWARD
	dataTable["messageName"] = "OPERID_EXCHANGE_LIMITED_AWARD"
	--Result	Int	0-成功 1-失败
	dataTable["result"] = nMBaseMessage:readInt()
	--Common.log("read80610014 result " .. dataTable["result"])
	--Message	Text	Toast的信息
	dataTable["message"] = nMBaseMessage:readString()
	--Common.log("read80610014 message " .. dataTable["message"])
	--PicUrl	Text	奖品图片url	兑换成功后返回
	dataTable["picUrl"] = nMBaseMessage:readString()
	--Common.log("read80610014 picUrl " .. dataTable["picUrl"])
	return dataTable
end

--[[-------------请求我的奖品中现金奖品列表 (OPERID_GET_CASH_PRIZE_LIST)------------]]
function read8061001d(nMBaseMessage)
	--Common.log("read8061001d Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GET_CASH_PRIZE_LIST
	dataTable["messageName"] = "OPERID_GET_CASH_PRIZE_LIST"
	local CashPrizeListCnt = nMBaseMessage:readInt()
	--Common.log("read8061001d CashPrizeListCnt is " .. CashPrizeListCnt)
	dataTable["CashPrizeList"] = {}
	for i = 1, CashPrizeListCnt do
		dataTable["CashPrizeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …PrizeID int 奖品id
		dataTable["CashPrizeList"][i].id = nMBaseMessage:readInt() + 10000;
		--Common.log("read8061001d Loop " .. i .. " PrizeID == " .. dataTable["CashPrizeList"][i].id)
		-- …PrizeName String 短名称
		dataTable["CashPrizeList"][i].name = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " PrizeName == " .. dataTable["CashPrizeList"][i].name)
		-- …PictureUrl String 图片地址
		dataTable["CashPrizeList"][i].url = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " url == " .. dataTable["CashPrizeList"][i].url)
		-- …ExchangbleAmount int 兑换所需奖品个数
		dataTable["CashPrizeList"][i].ExchangbleAmount = nMBaseMessage:readInt();
		--Common.log("read8061001d Loop " .. i .. " ExchangbleAmount == " .. dataTable["CashPrizeList"][i].ExchangbleAmount)
		-- …TotalityAmount int 拥有的奖品个数综合
		dataTable["CashPrizeList"][i].TotalityAmount = nMBaseMessage:readInt();
		--Common.log("read8061001d Loop " .. i .. " TotalityAmount == " .. dataTable["CashPrizeList"][i].TotalityAmount)
		dataTable["CashPrizeList"][i].HistoryAmount = nMBaseMessage:readInt();
		--Common.log("read8061001d Loop " .. i .. " HistoryAmount == " .. dataTable["CashPrizeList"][i].HistoryAmount)
		dataTable["CashPrizeList"][i].Description = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " Description == " .. dataTable["CashPrizeList"][i].Description)
		dataTable["CashPrizeList"][i].type = 3;
		dataTable["CashPrizeList"][i].status = 0;
		dataTable["CashPrizeList"][i].date = 0;
		dataTable["CashPrizeList"][i].Category = 0;
		dataTable["CashPrizeList"][i].isExpired = 0;
		nMBaseMessage:setReadPos(pos + length)
	end

	local CashPrizeExchangedListCnt = nMBaseMessage:readInt()
	dataTable["CashPrizeExchangedList"] = {}
	--Common.log("read8061001d CashPrizeExchangedListCnt is " .. CashPrizeExchangedListCnt)
	for i = 1, CashPrizeExchangedListCnt do
		dataTable["CashPrizeExchangedList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …PrizeID int 奖品id
		dataTable["CashPrizeExchangedList"][i].id = nMBaseMessage:readInt() + 10000;
		--Common.log("read8061001d Loop " .. i .. " PrizeID == " .. dataTable["CashPrizeExchangedList"][i].id)
		-- …PrizeName String 短名称
		dataTable["CashPrizeExchangedList"][i].name = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " PrizeName == " .. dataTable["CashPrizeExchangedList"][i].name)
		-- …PrizeStatus Byte 奖品状态
		dataTable["CashPrizeExchangedList"][i].status = nMBaseMessage:readByte();
		--Common.log("read8061001d Loop " .. i .. " status == " .. dataTable["CashPrizeExchangedList"][i].status)
		-- …PrizeTime Long 获奖时间
		dataTable["CashPrizeExchangedList"][i].date = nMBaseMessage:readLong();
		--Common.log("read8061001d Loop " .. i .. " date == " .. dataTable["CashPrizeExchangedList"][i].date)
		-- …PictureUrl String 图片地址
		dataTable["CashPrizeExchangedList"][i].url = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " url == " .. dataTable["CashPrizeExchangedList"][i].url)
		dataTable["CashPrizeExchangedList"][i].Description = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " Description == " .. dataTable["CashPrizeExchangedList"][i].Description)
		dataTable["CashPrizeExchangedList"][i].type = 3;
		dataTable["CashPrizeExchangedList"][i].Category = 0;
		dataTable["CashPrizeExchangedList"][i].isExpired = 0;
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-------------请求现金奖品兑现成话费 (OPERID_PRIZE_EXCHANGE_MOBILE_FARE)------------]]
function read8061001e(nMBaseMessage)
	--Common.log("read8061001e Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_PRIZE_EXCHANGE_MOBILE_FARE
	dataTable["messageName"] = "OPERID_PRIZE_EXCHANGE_MOBILE_FARE"
	dataTable["result"] = nMBaseMessage:readInt()
	--Common.log("read8061001e result " .. dataTable["result"])
	dataTable["message"] = nMBaseMessage:readString()
	--Common.log("read8061001e message " .. dataTable["message"])
	return dataTable
end

--[[-------------31请求现金奖品兑现成金币 (OPERID_PRIZE_EXCHANGE_GAME_COIN)------------]]
function read8061001f(nMBaseMessage)
	--Common.log("read8061001f Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_PRIZE_EXCHANGE_GAME_COIN
	dataTable["messageName"] = "OPERID_PRIZE_EXCHANGE_GAME_COIN"
	dataTable["result"] = nMBaseMessage:readInt()
	--Common.log("read8061001f result " .. dataTable["result"])
	dataTable["message"] = nMBaseMessage:readString()
	--Common.log("read8061001f message " .. dataTable["message"])
	return dataTable
end

--[[-------------闯关赛基本信息 (OPERID_CRAZY_GAME_USER_INFO)------------]]
function read80610020(nMBaseMessage)
	--Common.log("read80610020 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_CRAZY_STAGE_BASE_INFO
	dataTable["messageName"] = "OPERID_CRAZY_GAME_USER_INFO"
	--TimeStamp	Long	时间戳	时间戳现用于昨日奖励的显示
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	--…MaxLevel	Short	最高关卡
	dataTable["MaxLevel"] = nMBaseMessage:readShort()
	--Common.log("read80610020 MaxLevel is " .. dataTable["MaxLevel"])
	--…CurrentLevel  当前关卡
	dataTable["CurrentLevel"] = nMBaseMessage:readShort()
	--Common.log("read80610020 CurrentLevel is " .. dataTable["CurrentLevel"])
	--…CurrentRank  当前排名
	dataTable["CurrentRank"] = nMBaseMessage:readString()
	--Common.log("read80610020 CurrentRank is " .. dataTable["CurrentRank"])
	--…ReliveNumber  今日复活次数
	dataTable["ReliveNumber"] = nMBaseMessage:readInt()
	--Common.log("read80610020 ReliveNumber is " .. dataTable["ReliveNumber"])
	--…ReliveStoneNumber  复活石个数
	dataTable["ReliveStoneNumber"] = nMBaseMessage:readInt()
	--Common.log("read80610020 ReliveStoneNumber is " .. dataTable["ReliveStoneNumber"])
	--…NeedStoneNumber  需要的复活石数量
	dataTable["NeedStoneNumber"] = nMBaseMessage:readInt()
	--Common.log("read80610020 NeedStoneNumber is " .. dataTable["NeedStoneNumber"])
	--…MinCoin  需要最少金币数
	dataTable["MinCoin"] = nMBaseMessage:readInt()
	--Common.log("read80610020 MinCoin is " .. dataTable["MinCoin"])
	--…CurrentMaxLevel  当前最高关数
	dataTable["CurrentMaxLevel"] = nMBaseMessage:readShort()
	--Common.log("read80610020 CurrentMaxLevel is " .. dataTable["CurrentMaxLevel"])
	--…Receivable  当前关卡是否可领奖	0-	不能领奖  1-	可领奖
	dataTable["Receivable"] = nMBaseMessage:readByte()
	--Common.log("read80610020 Receivable is " .. dataTable["Receivable"])
	--…ReliveRecharge	Int	复活充值引导id
	dataTable["ReliveRecharge"] = nMBaseMessage:readInt()
	--Common.log("read80610020 ReliveRecharge is " .. dataTable["ReliveRecharge"])
	--…ReliveRechargePrice	Int	复活充值引导所需的money
	dataTable["ReliveRechargePrice"] = nMBaseMessage:readInt()
	--Common.log("read80610020 ReliveRechargePrice is " .. dataTable["ReliveRechargePrice"])
	--…ReliveRechargeNum	Int 	复活石充值数量
	dataTable["ReliveRechargeNum"] = nMBaseMessage:readInt()
	--Common.log("read80610020 ReliveRechargeNum is " .. dataTable["ReliveRechargeNum"])
	--…ReliveStroneRecharge	Int	复活石充值引导id
	dataTable["ReliveStroneRecharge"] = nMBaseMessage:readInt()
	--Common.log("read80610020 ReliveStroneRecharge is " .. dataTable["ReliveStroneRecharge"])
	--…ReliveStroneRechartgePrice	Int	复活石充值引导所需的money
	dataTable["ReliveStroneRechartgePrice"] = nMBaseMessage:readInt()
	--Common.log("read80610020 ReliveStroneRechartgePrice is " .. dataTable["ReliveStroneRechartgePrice"])
	--…ReliveStroneRechargeNum	Int 	复活石充值数量
	dataTable["ReliveStroneRechargeNum"] = nMBaseMessage:readInt()
	--Common.log("read80610020 ReliveStroneRechargeNum is " .. dataTable["ReliveStroneRechargeNum"])
	--…Rule  玩法描述
	dataTable["Rule"] = nMBaseMessage:readString()
	--Common.log("read80610020 Rule is " .. dataTable["Rule"])

	dataTable["AwardCnt"] = nMBaseMessage:readInt()
	--Common.log("read80610020 AwardCnt is " .. dataTable["AwardCnt"])
	dataTable["AwardList"] = {}
	for i = 1,dataTable["AwardCnt"] do
		dataTable["AwardList"][i] = {}
		dataTable["AwardList"][i].StageAwardCnt = nMBaseMessage:readInt()
		--Common.log("read80610020 StageAwardCnt is " .. dataTable["AwardList"][i].StageAwardCnt)
		dataTable["AwardList"][i]["StageAwardList"] = {}
		for j = 1,dataTable["AwardList"][i].StageAwardCnt do
			dataTable["AwardList"][i]["StageAwardList"][j] = {}
			local length = nMBaseMessage:readShort()
			local pos = nMBaseMessage:getReadPos()
			--count 奖励数量
			dataTable["AwardList"][i]["StageAwardList"][j].count = nMBaseMessage:readInt()
			--Common.log("read80610020 count is " .. dataTable["AwardList"][i]["StageAwardList"][j].count)
			--description 奖励描述
			dataTable["AwardList"][i]["StageAwardList"][j].description = nMBaseMessage:readString()
			--Common.log("read80610020 description is " .. dataTable["AwardList"][i]["StageAwardList"][j].description)
			--url 图片地址
			dataTable["AwardList"][i]["StageAwardList"][j].url = nMBaseMessage:readString()
			--Common.log("read80610020 url is " .. dataTable["AwardList"][i]["StageAwardList"][j].url)
			--shortDes 奖励图片短描述
			dataTable["AwardList"][i]["StageAwardList"][j].shortDes = nMBaseMessage:readString()
			--Common.log("read80610020 shortDes is " .. dataTable["AwardList"][i]["StageAwardList"][j].shortDes)
			--……awardID	Int	奖品ID
			dataTable["AwardList"][i]["StageAwardList"][j].awardID = nMBaseMessage:readInt()
			--Common.log("read80610020 awardID is " .. dataTable["AwardList"][i]["StageAwardList"][j].awardID)
			nMBaseMessage:setReadPos(pos + length)
		end
	end
	--showLottery	Byte	是否显示过抽奖机会	1是显示过，0未显示过
	dataTable["showLottery"] = nMBaseMessage:readByte()
	--是否需要复活
	dataTable["status"] = nMBaseMessage:readByte()
	--免费复活次数
	dataTable["freeReliveCount"] = nMBaseMessage:readByte()
	--Common.log("read80610020 showLottery is " .. dataTable["showLottery"])
	return dataTable
end


--[[-------------开始闯关消息(OPERID_CRAZY_GAME_BEGIN)------------]]
function read80610021(nMBaseMessage)
	--Common.log("read80610021 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_CRAZY_STAGE_BEGIN
	dataTable["messageName"] = "OPERID_CRAZY_STAGE_BEGIN"
	--Status	Byte	闯关是否符合条件	1可以闯关，2金币不足，3 需要复活 ，4需要领奖，5 已达到最高关数，6已达到复活次数,7 其他错误
	dataTable["Success"] = nMBaseMessage:readByte()
	--Common.log("read80610021 Success " .. dataTable["Success"])
	--Message	Text	提示内容	当不能闯关时该字段有效
	dataTable["Message"] = nMBaseMessage:readString()
	--Common.log("read80610021 Message " .. dataTable["Message"])
	--NeedCoin	Int	缺少的金币数	当status为2时需要
	dataTable["NeedCoin"] = nMBaseMessage:readInt()
	--Common.log("read80610021 NeedCoin " .. dataTable["NeedCoin"])
	return dataTable
end

--[[-------------闯关结果(OPERID_CRAZY_GAME_RESULT)------------]]
function read80610022(nMBaseMessage)
	--Common.log("read80610022 Comming")
	local dataTable = {}
	dataTable["messageType"] = REQ + OPERID_CRAZY_STAGE_RESULT
	dataTable["messageName"] = "OPERID_CRAZY_STAGE_RESULT"
	--Success	Byte	闯关是否符合条件	1成功，0失败 需要复活石，2失败，复活次数达到上线
	dataTable["Success"] = nMBaseMessage:readByte()
	--Common.log("read80610022 Success " .. dataTable["Success"])
	--ReliveStoneNumber	Int	拥有复活石个数
	dataTable["ReliveStoneNumber"] = nMBaseMessage:readInt()
	--Common.log("read80610022 ReliveStoneNumber " .. dataTable["ReliveStoneNumber"])
	--NeedReliveStone	Int	需要复活石个数
	dataTable["NeedReliveStone"] = nMBaseMessage:readInt()
	--Common.log("read80610022 NeedReliveStone " .. dataTable["NeedReliveStone"])
	--ReliveRecharge	Int	复活充值引导id
	dataTable["ReliveRecharge"] = nMBaseMessage:readInt()
	--Common.log("read80610022 ReliveRecharge " .. dataTable["ReliveRecharge"])
	--ReliveRechargePrice	Int	复活充值引导所需的money
	dataTable["ReliveRechargePrice"] = nMBaseMessage:readInt()
	--Common.log("read80610022 ReliveRechargePrice " .. dataTable["ReliveRechargePrice"])
	--ReliveRechargeNum	Int 	复活石充值数量
	dataTable["ReliveRechargeNum"] = nMBaseMessage:readInt()
	--Common.log("read80610022 ReliveRechargeNum " .. dataTable["ReliveRechargeNum"])
	--CurrentLevel	Short	当前关数
	dataTable["CurrentLevel"] = nMBaseMessage:readShort()
	--Common.log("read80610022 CurrentLevel " .. dataTable["CurrentLevel"])
	--Message	Text	闯关结果提示文字
	dataTable["Message"] = nMBaseMessage:readString()
	--Common.log("read80610022 Message " .. dataTable["Message"])
	--免费复活次数
	dataTable["freeReliveCount"] = nMBaseMessage:readByte()
	return dataTable
end

--[[-------------闯关领奖消息(OPERID_CRAZY_STAGE_RECEIVE_AWARD)------------]]
function read80610023(nMBaseMessage)
	--Common.log("read80610023 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_CRAZY_STAGE_RECEIVE_AWARD
	dataTable["messageName"] = "OPERID_CRAZY_STAGE_RECEIVE_AWARD"
	--Success	Byte	领奖是否成功	1成功，0失败
	dataTable["Success"] = nMBaseMessage:readByte()
	--Common.log("read80610023 Success " .. dataTable["Success"])
	--Message	Text	提示内容
	dataTable["Message"] = nMBaseMessage:readString()
	--Common.log("read80610023 Message " .. dataTable["Message"])
	return dataTable
end

--[[-------------闯关复活(OPERID_CRAZY_STAGE_RELIVE)------------]]
function read80610024(nMBaseMessage)
	--Common.log("read80610024 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_CRAZY_STAGE_RELIVE
	dataTable["messageName"] = "OPERID_CRAZY_STAGE_RELIVE"
	--ReliveSuccess	Byte	复活是否成功	1成功，0失败
	dataTable["ReliveSuccess"] = nMBaseMessage:readByte()
	--Common.log("read80610024 ReliveSuccess " .. dataTable["ReliveSuccess"])
	--Message	Text	提示内容
	dataTable["Message"] = nMBaseMessage:readString()
	--Common.log("read80610024 Message " .. dataTable["Message"])
	return dataTable
end

--[[-------------闯关重置消息(OPERID_CRAZY_STAGE_RESET)------------]]
function read80610025(nMBaseMessage)
	--Common.log("read80610025 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_CRAZY_STAGE_RESET
	dataTable["messageName"] = "OPERID_CRAZY_STAGE_RESET"
	--ReliveSuccess	Byte	复活是否成功	1成功，0失败
	dataTable["Success"] = nMBaseMessage:readByte()
	--Common.log("read80610025 Success " .. dataTable["Success"])
	--Message	Text	提示内容
	dataTable["Message"] = nMBaseMessage:readString()
	--Common.log("read80610025 Message " .. dataTable["Message"])
	return dataTable
end

--[[-------------闯关排行榜(OPERID_CRAZY_STAGE_RANK)------------]]
function read80610026(nMBaseMessage)
	--Common.log("read80610026 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_CRAZY_STAGE_RANK
	dataTable["messageName"] = "OPERID_CRAZY_STAGE_RANK"
	--TimeStamp	Long	时间戳	1成功，0失败
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	--Common.log("read80610026 TimeStamp " .. dataTable["TimeStamp"])
	dataTable["TopCnt"] = nMBaseMessage:readInt();
	--Common.log("read80610026 TopCnt " .. dataTable["TopCnt"])
	dataTable["TopList"] = {}
	for i = 1, dataTable["TopCnt"] do
		dataTable["TopList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …userName text 用户名
		dataTable["TopList"][i].userName = nMBaseMessage:readString();
		--Common.log("read80610026 userName " .. dataTable["TopList"][i].userName)
		-- …userPic	Text	用户头像
		dataTable["TopList"][i].userPic = nMBaseMessage:readString();
		--Common.log("read80610026 userPic " .. dataTable["TopList"][i].userPic)
		-- …score	Int	闯关关数
		dataTable["TopList"][i].score = nMBaseMessage:readInt();
		--Common.log("read80610026 score " .. dataTable["TopList"][i].score)
		-- …vip	Int	Vip等级
		dataTable["TopList"][i].vip = nMBaseMessage:readInt();
		--Common.log("read80610026 vip " .. dataTable["TopList"][i].vip)
		-- …award	Text	奖励信息
		dataTable["TopList"][i].award = nMBaseMessage:readString();
		--Common.log("read80610026 award " .. dataTable["TopList"][i].award)
		-- …url	Text	头像地址
		dataTable["TopList"][i].url = nMBaseMessage:readString();
		--Common.log("read80610026 url " .. dataTable["TopList"][i].url)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-------------闯关开始验证(OPERID_CRAZY_STAGE_VALIDATE)------------]]
function read80610027(nMBaseMessage)
	--Common.log("read80610027 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_CRAZY_STAGE_VALIDATE
	dataTable["messageName"] = "OPERID_CRAZY_STAGE_VALIDATE"
	--Status	Byte	闯关是否符合条件	1可以闯关，2金币不足，3 需要复活 ，4需要领奖，5 已达到最高关数，6已达到复活次数
	dataTable["Status"] = nMBaseMessage:readByte()
	--Common.log("read80610027 Status " .. dataTable["Status"])
	--Message	Text	闯关失败消息
	dataTable["Message"] = nMBaseMessage:readString()
	--Common.log("read80610027 Message " .. dataTable["Message"])
	--Amount	Int	所差金币或者复活石的数量
	dataTable["Amount"] = nMBaseMessage:readInt()
	--Common.log("read80610027 Amount " .. dataTable["Amount"])
	return dataTable
end

--[[-------------闯关昨日获取奖励提示消息(OPERID_CRAZY_STAGE_YESTERDAY_AWARDS)------------]]
function read80610028(nMBaseMessage)
	--Common.log("read80610028 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_CRAZY_STAGE_YESTERDAY_AWARDS
	dataTable["messageName"] = "OPERID_CRAZY_STAGE_YESTERDAY_AWARDS"
	--AwardsContent	Text	昨日闯关奖励信息	HTML
	dataTable["AwardsContent"] = nMBaseMessage:readString()
	--Common.log("read80610027 AwardsContent " .. dataTable["AwardsContent"])
	return dataTable
end

--[[-- 闯关今日排行榜]]
function read80610039(nMBaseMessage)
	--Common.log("read80610039==============")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_CRAZY_STAGE_TODAY_RANK
	dataTable["messageName"] = "OPERID_CRAZY_STAGE_TODAY_RANK"
	-- TimeStamp	Long	时间戳
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	-- TopCnt	Int	排名返回数	Loop
	dataTable["TopCnt"] = nMBaseMessage:readInt();
	--Common.log("read80610039========"..dataTable["TopCnt"])

	dataTable["TopList"] = {}
	for i = 1, dataTable["TopCnt"] do
		dataTable["TopList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …userName	Text	用户名
		dataTable["TopList"][i].userName = nMBaseMessage:readString()
		--Common.log("80610039======"..dataTable["TopList"][i].userName)
		-- …userPic	Text	用户头像
		dataTable["TopList"][i].userPic = nMBaseMessage:readString()
		-- …score	Int	闯关关数
		dataTable["TopList"][i].score = nMBaseMessage:readInt()
		-- …vip	Int	Vip等级
		dataTable["TopList"][i].vip = nMBaseMessage:readInt()
		-- …award	Text	奖励信息
		dataTable["TopList"][i].award = nMBaseMessage:readString()
		-- …url	Text	奖励图片
		dataTable["TopList"][i].url = nMBaseMessage:readString()

		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析牌桌等待提示]]
function read80060035(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_WATING_TIPS
	dataTable["messageName"] = "DBID_V2_WATING_TIPS"

	--AddCnt  添加数量
	local addCnt = nMBaseMessage:readByte()
	--Common.log("---提示num = ".. addCnt)
	dataTable["AddMsg"] = {}
	for i=1,addCnt do
		dataTable["AddMsg"][i] = {}
		--…tipID  提示ID
		dataTable["AddMsg"][i].tipID = nMBaseMessage:readInt()
		--Common.log("---提示ID = ".. dataTable["AddMsg"][i].tipID)
		--…CategoryURL  类别URL
		dataTable["AddMsg"][i].CategoryURL = nMBaseMessage:readString()
		--Common.log("---类别URL = ".. dataTable["AddMsg"][i].CategoryURL)
		--…Title  标题
		dataTable["AddMsg"][i].Title = nMBaseMessage:readString()
		--Common.log("---标题 = ".. dataTable["AddMsg"][i].Title)
		--…Tip  提示内容
		dataTable["AddMsg"][i].Tip = nMBaseMessage:readString()
		--Common.log("---提示内容 = ".. dataTable["AddMsg"][i].Tip)
	end
	--DeleteCnt  删除数量
	dataTable["DeleteMsg"] = {}
	local DeleteCnt = nMBaseMessage:readByte()
	for i = 1, DeleteCnt do
		dataTable["DeleteMsg"][i] = {}
		--…TipID  提示ID
		dataTable["DeleteMsg"][i].TipID = nMBaseMessage:readInt()
		--Common.log("DeleteMsg---提示ID = ".. dataTable["DeleteMsg"][i].TipID)
	end
	--TimeStamp  时间戳
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	--Common.log("时间戳 = " .. dataTable["TimeStamp"])
	--isDisplayAlone  是否单独显示1是0否
	dataTable["isDisplayAlone"] = nMBaseMessage:readByte()
	--Common.log("是否单独显示1是0否 = " .. dataTable["isDisplayAlone"])
	return dataTable
end

--[[-- 解析牌桌踢人消息]]
function read8003001c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + ROOMID_KICK_OUT_PLAYER
	dataTable["messageName"] = "ROOMID_KICK_OUT_PLAYER"
	--获取踢人结果 1为成功;0为失败
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("dataTable[result] " .. dataTable["result"])
	return dataTable
end

--[[-- 解析牌桌被踢消息]]
function read3001d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = REQ + ROOMID_PLAYER_BE_KICKED_OUT
	dataTable["messageName"] = "ROOMID_PLAYER_BE_KICKED_OUT"
	--被踢提示语
	dataTable["BeKickedOutMsg"] = nMBaseMessage:readString()
	--踢人者viplevel
	dataTable["VipLevel"] = nMBaseMessage:readInt()
	--踢人者昵称
	dataTable["NickName"] = nMBaseMessage:readString()
	return dataTable
end

--[[--解析牌桌举报消息]]
function read80070065(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_PLAYER_REPORT
	dataTable["messageName"] = "MANAGERID_PLAYER_REPORT"
	--举报结果
	dataTable["result"] = nMBaseMessage:readByte()
	--结果提示语
	dataTable["resultText"] = nMBaseMessage:readString()
	return dataTable
end

---------[[-- 月签  ---]]-------
-----------------月签[25天版]月签基本信息MONTH_SIGN_REWARD_LIST--------------------
function read80610017(nMBaseMessage)
	--Common.log("read80610017 应答月签基本信息");
	local dataTable = {}
	dataTable["messageType"] = ACK + MONTH_SIGN_REWARD_LIST
	dataTable["messageName"] = "MONTH_SIGN_REWARD_LIST"

	--时间戳
	dataTable["timeStamp"] = nMBaseMessage:readLong()
	--月签活动介绍
	dataTable["monthSignIntroduction"] = nMBaseMessage:readString()
	--月签奖品
	dataTable["monthSignPrize"] = {}
	--月签奖品种类数量
	local cnt = nMBaseMessage:readInt()
	for i = 1 , cnt do
		dataTable["monthSignPrize"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--奖品类型 0金币 1道具 2碎片 3 转盘
		dataTable["monthSignPrize"][i]["prizeType"] = nMBaseMessage:readByte()
		--奖品标题图片地址(PrizeType=3 传空)
		dataTable["monthSignPrize"][i]["prizeTitleUrl"] = nMBaseMessage:readString()
		--		--Common.log("zblbt.......标题 == " .. dataTable["monthSignPrize"][i]["prizeTitleUrl"])
		--奖品图片地址(PrizeType=3 传空)
		dataTable["monthSignPrize"][i]["prizePicUrl"] = nMBaseMessage:readString()
		--奖品数量描述
		dataTable["monthSignPrize"][i]["thisPrizeNumInfo"] = nMBaseMessage:readString()
		--领取奖品提示语
		dataTable["monthSignPrize"][i]["thisPrizeTips1"] = nMBaseMessage:readString()
		--领取奖品提示语(PrizeType=3 传空)
		dataTable["monthSignPrize"][i]["thisPrizeTips2"] = nMBaseMessage:readString()
		--奖品标题
		dataTable["monthSignPrize"][i]["awardTitle"] = nMBaseMessage:readString()
		--		--Common.log("zbl奖品: =   " .. dataTable["monthSignPrize"][i]["awardTitle"])
		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

-----------------用户月签基本信息USERS_MONTH_SIGN_BASIC_INFO--------------------
function read80610018(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + USERS_MONTH_SIGN_BASIC_INFO
	dataTable["messageName"] = "USERS_MONTH_SIGN_BASIC_INFO"

	--用户当前Vip等级所对应的领取转盘机会
	dataTable["VIPLevelTurnTable"] = {}
	--用户当前Vip等级所对应的领取转盘机会的次数
	local cnt = nMBaseMessage:readInt()
	for i = 1 , cnt do
		dataTable["VIPLevelTurnTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--第N天
		dataTable["VIPLevelTurnTable"][i]["day"] = nMBaseMessage:readInt()
		--用户当前Vip转盘次数
		dataTable["VIPLevelTurnTable"][i]["times"] = nMBaseMessage:readInt()
		--下一VIP等级比当前VIP多转盘次数
		dataTable["VIPLevelTurnTable"][i]["nextVipMultiTimes"] = nMBaseMessage:readInt()
		--领取奖品提示语
		dataTable["VIPLevelTurnTable"][i]["thisPrizeTips1"] = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--签到日期
	dataTable["isSignDate"] = {}
	--从1号到当前日期的签到次数(包括今天)
	local cnt = nMBaseMessage:readInt()
	for i = 1, cnt do
		dataTable["isSignDate"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--日期
		dataTable["isSignDate"][i]["date"] = nMBaseMessage:readInt()
		--签到状态 0 未签到(没有游戏签到) 1签到 2 缺签到(一个游戏签一个没签)
		dataTable["isSignDate"][i]["status"] = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end

	--领取奖品的类型 0金币 1道具 2碎片 3 转盘
	dataTable["TodayReceivePrizeType"] = nMBaseMessage:readByte();
	--Common.log("read80610018  TodayReceivePrizeType ==" .. dataTable["TodayReceivePrizeType"]);
	--今天签到奖品详情
	dataTable["TodayPrizeDetails"] = nMBaseMessage:readString();
	--Common.log("read80610018  TodayPrizeDetails ==" .. dataTable["TodayPrizeDetails"]);

	return dataTable
end

-----------------月签签到SIGN_TO_MONTH_SIGN--------------------
function read80610019(nMBaseMessage)
	--Common.log("read80610019 应答月签签到");
	local dataTable = {}
	dataTable["messageType"] = ACK + SIGN_TO_MONTH_SIGN
	dataTable["messageName"] = "SIGN_TO_MONTH_SIGN"

	--是否成功签到 0 否 1是
	dataTable["result"] = nMBaseMessage:readByte()
	--成功或失败提示语
	dataTable["msg"] = nMBaseMessage:readString()
	--领取奖品的类型 0金币 1道具 2碎片 3 转盘
	dataTable["receivePrizeType"] = nMBaseMessage:readByte()
	--奖品的详情
	dataTable["PrizeDetails"] = nMBaseMessage:readString()

	return dataTable
end

---幸运转盘-----
-----------------转盘基本信息(TURNTABLE_BASIC_INFO)[00610015]--------------------
function read80610015(nMBaseMessage)
	--Common.log("read80610015 应答转盘基本信息 ")
	local dataTable = {}
	dataTable["messageType"] = ACK + TURNTABLE_BASIC_INFO
	dataTable["messageName"] = "TURNTABLE_BASIC_INFO"

	--抽奖类型 0免费抽奖 1消耗金币 2消耗元宝
	dataTable["lotteryType"] = nMBaseMessage:readByte()
	--抽奖次数
	dataTable["lotteryCnt"] = nMBaseMessage:readInt()
	--时间戳
	dataTable["timeStamp"] = nMBaseMessage:readLong()
	--转盘玩法详情
	dataTable["turnTablePlayIntroduction"] = nMBaseMessage:readString()
	--转盘奖品数量
	local cnt = nMBaseMessage:readInt()
	dataTable["turnTablePrize"] = {}
	for i=1 , cnt do
		dataTable["turnTablePrize"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--奖品ID
		dataTable["turnTablePrize"][i]["prizeID"] = nMBaseMessage:readInt()
		--奖品标题图片地址
		dataTable["turnTablePrize"][i]["prizeTitleUrl"] = nMBaseMessage:readString()
		--奖品图片地址
		dataTable["turnTablePrize"][i]["prizePicUrl"] = nMBaseMessage:readString()
		--奖品描述
		dataTable["turnTablePrize"][i]["thisPrizeInfo"] = nMBaseMessage:readString()
		--奖品描述URL(3.15添加)
		dataTable["turnTablePrize"][i]["PrizeDesUrl"] = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

-----------------转盘抽奖信息(TURNTABLE_LOTTERY_INFO)[00610016]--------------------
function read80610016(nMBaseMessage)
	--Common.log("read80610016 应答转盘抽奖信息 ")
	local dataTable = {}
	dataTable["messageType"] = ACK + TURNTABLE_LOTTERY_INFO
	dataTable["messageName"] = "TURNTABLE_LOTTERY_INFO"

	--抽奖结果 0抽奖失败(成本不够、次数不够等) 1中奖
	dataTable["result"] = nMBaseMessage:readByte()
	--抽奖结果提示语
	dataTable["msg"] = nMBaseMessage:readString()
	--抽中的奖品ID
	dataTable["prizeID"] = nMBaseMessage:readInt()
	--剩余抽奖次数
	dataTable["lotteryCnt"] = nMBaseMessage:readInt()
	--奖品详情
	dataTable["PrizeDetails"] = nMBaseMessage:readString()

	return dataTable
end

-----------------获取大厅公告(MANAGERID_GET_SYSTEM_LIST_NOTICE)[0070072]--------------------
function read80070072(nMBaseMessage)
	--Common.log("read80070072 应答获取大厅公告");
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_SYSTEM_LIST_NOTICE
	dataTable["messageName"] = "MANAGERID_GET_SYSTEM_LIST_NOTICE"

	--公告数量(服务器一般会给最新10条)
	local cnt = nMBaseMessage:readInt()
	dataTable["SystemListNotice"] = {}
	for i=1 , cnt do
		dataTable["SystemListNotice"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--公告ID
		dataTable["SystemListNotice"][i]["NoticeID"] = nMBaseMessage:readByte()
		--公告内容
		dataTable["SystemListNotice"][i]["NoticeMsg"] = nMBaseMessage:readString()

		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

-----------------获取大厅按钮状态(MANAGERID_GET_BUTTONS_STATUS)[0070073]--------------------
function read80070073(nMBaseMessage)
	--Common.log("read80070073 应答获取大厅按钮状态");
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_BUTTONS_STATUS
	dataTable["messageName"] = "MANAGERID_GET_BUTTONS_STATUS"

	--大厅按钮列表
	local cnt = nMBaseMessage:readInt()
	dataTable["HallButton"] = {}
	for i=1 , cnt do
		dataTable["HallButton"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--按钮ID
		dataTable["HallButton"][i]["ButtonID"] = nMBaseMessage:readInt()
		--按钮状态   0 普通(开启) 1 变灰 2 隐藏
		dataTable["HallButton"][i]["ButtonStatus"] = nMBaseMessage:readByte()
		--开启提示语  (只有变灰的按钮才会有提示语)
		dataTable["HallButton"][i]["OpenConditionMsg"] = nMBaseMessage:readString()

		--Common.log("按钮ID：" .. dataTable["HallButton"][i]["ButtonID"] .. " 按钮状态(0 普通1 变灰 2 隐藏)：" .. dataTable["HallButton"][i]["ButtonStatus"]);
		--Common.log("按钮ID：" .. dataTable["HallButton"][i]["ButtonID"] .. " 开启提示语：" .. dataTable["HallButton"][i]["OpenConditionMsg"]);
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

----------------[[----------小游戏---扎金花--------------]]---------------------------------------
--牌桌同步(如果玩家断线重连时，服务端会推送牌桌同步)
function read80200001(nMBaseMessage)
	--Common.log("read80200001 牌桌同步牌桌同步")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_TABLE_SYNC
	dataTable["messageName"] = "TableSync"

	--  房间ID
	dataTable["roomId"] = nMBaseMessage:readInt()
	--Common.log("roomId=" .. dataTable["roomId"])

	--  牌桌ID
	dataTable["tableId"] = nMBaseMessage:readInt()
	--Common.log("tableId=" .. dataTable["tableId"])

	--  牌桌状态
	dataTable["status"] = nMBaseMessage:readByte()
	--Common.log("status=" .. dataTable["status"])

	--   庄家位置
	dataTable["dealerSSID"] = nMBaseMessage:readInt()
	--Common.log("dealerSSID=" .. dataTable["dealerSSID"])

	--  单注金额
	dataTable["singleCoin"] = nMBaseMessage:readInt()
	--Common.log("singleCoin=" .. dataTable["singleCoin"])

	--  总注
	dataTable["totalPoolCoin"] = nMBaseMessage:readInt()
	--Common.log("totalPoolCoin=" .. dataTable["totalPoolCoin"])

	--  轮数
	dataTable["round"] = nMBaseMessage:readInt()
	--Common.log("round=" .. dataTable["round"])

	--  下一个玩家, 这里是游戏开始的第一个玩家
	local length = nMBaseMessage:readShort()
	--Common.log("length="..length)
	if length~=0 then
		dataTable["currentPlayer"] = {}
		local pos = nMBaseMessage:getReadPos()
		--Common.log("pos="..pos)
		--  -- 下一个玩家位置
		dataTable["currentPlayer"]["SSID"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][SSID]="..dataTable["currentPlayer"]["SSID"])
		--  -- 跟注金额，如果为-1则按钮不可用
		dataTable["currentPlayer"]["callCoin"] = nMBaseMessage:readInt()
		-- 加注列表
		dataTable["currentPlayer"]["raiseCoin"] = {}
		local cnt = nMBaseMessage:readByte()
		--Common.log("cnt="..cnt)
		for i=1,cnt do
			dataTable["currentPlayer"]["raiseCoin"][i] = {}
			--加注列表的加注的金额
			dataTable["currentPlayer"]["raiseCoin"][i].raiseValue = nMBaseMessage:readInt()
			--加注列表中加注金额的状态 0 此金额不可加注 1 此金额可加注
			dataTable["currentPlayer"]["raiseCoin"][i].raiseStatus = nMBaseMessage:readByte()
			--			--Common.log("dataTable[currentPlayer][raiseCoin].value ="..dataTable["currentPlayer"]["raiseCoin"][i].raiseValue.." status="..dataTable["currentPlayer"]["raiseCoin"][i].raiseStatus)
		end
		--  -- 0 不能操作，1 比牌 2 开牌
		dataTable["currentPlayer"]["compareCard"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][compareCard]="..dataTable["currentPlayer"]["compareCard"])
		--  -- 0不能看牌， 1可以看牌
		dataTable["currentPlayer"]["lookCard"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][lookCard]="..dataTable["currentPlayer"]["lookCard"])
		nMBaseMessage:setReadPos(pos + length)
	end
	--  牌桌总座位数
	dataTable["seatCnt"] = nMBaseMessage:readInt()
	--Common.log("seatCnt=" .. dataTable["seatCnt"])

	-- 玩家信息
	dataTable["players"] = {}
	--  玩家数量
	local cnt = nMBaseMessage:readByte()
	--Common.log("cnt=" .. cnt)
	for i = 1, cnt do
		dataTable["players"][i] = {}
		local length = nMBaseMessage:readShort()
		--Common.log("length=" .. length)
		local pos = nMBaseMessage:getReadPos()
		--Common.log("pos=" .. pos)
		--玩家ID
		dataTable["players"][i].userId = nMBaseMessage:readInt()
		--Common.log(i .. "userId=" .. dataTable["players"][i].userId)
		--昵称
		dataTable["players"][i].nickName = nMBaseMessage:readUTF()
		--Common.log(i .. "nickName=" .. dataTable["players"][i].nickName)
		--照片URL
		dataTable["players"][i].photoUrl = nMBaseMessage:readUTF()
		--Common.log(i .. "photoUrl=" .. dataTable["players"][i].photoUrl)
		--服务端座位号
		dataTable["players"][i].SSID = nMBaseMessage:readInt()
		--Common.log(i .. "SSID=" .. dataTable["players"][i].SSID)
		--已下注金额
		dataTable["players"][i].betCoins = nMBaseMessage:readInt()
		--Common.log(i .. "betCoins=" .. dataTable["players"][i].betCoins)
		--剩余金币
		dataTable["players"][i].remainCoins = nMBaseMessage:readInt()
		--Common.log(i .. "remainCoins=" .. dataTable["players"][i].remainCoins)
		--状态
		dataTable["players"][i].status = nMBaseMessage:readByte()
		--Common.log(i .. "status=" .. dataTable["players"][i].status)
		--Vip等级
		dataTable["players"][i].vipLevel = nMBaseMessage:readInt()
		--Common.log(i .. "vipLevel=" .. dataTable["players"][i].vipLevel)
		--性别
		dataTable["players"][i].sex = nMBaseMessage:readByte()
		--禁比状态
		local noPKByte = nMBaseMessage:readByte()
		if noPKByte == 1 then
			dataTable["players"][i].noPK = true
		else
			dataTable["players"][i].noPK = false
		end
		--牌数
		local cardCnt = nMBaseMessage:readByte()
		--Common.log("cardCnt=" .. cardCnt)
		dataTable["players"][i]["cardValues"] = {}
		for i1 = 1, cardCnt do
			--牌值
			dataTable["players"][i]["cardValues"][i1] = nMBaseMessage:readInt()
			--Common.log(i1.."dataTable[cardValues]=" .. dataTable["players"][i]["cardValues"][i1])
		end
		-- 牌型
		dataTable["players"][i].cardType = nMBaseMessage:readByte()
		--Common.log("牌桌同步    cardType=" .. dataTable["players"][i].cardType)
		nMBaseMessage:setReadPos(pos + length)
	end

	--下注明细列表数
	local chipCnt = nMBaseMessage:readByte()
	--Common.log("筹码 chipCnt="..chipCnt)
	if chipCnt >0 then
		dataTable["chips"] = {}
	end
	for i3 = 1, chipCnt do
		dataTable["chips"][i3] = {}
		--是否看牌 0否， 1看牌
		dataTable["chips"][i3].lookCard = nMBaseMessage:readByte()
		--是否押满 0 否， 1押满
		dataTable["chips"][i3].allIn = nMBaseMessage:readByte()
		--押注金币
		dataTable["chips"][i3].coins = nMBaseMessage:readInt()
		--Common.log("筹码 dataTable[chips][raiseCoin].lookCard =" .. dataTable["chips"][i3].lookCard .. " allin=" .. dataTable["chips"][i3].allIn.." coins="..dataTable["chips"][i3].coins)
	end
	return dataTable

end

---准备
function read80200002(nMBaseMessage)
	--Common.log("read80200002")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_READY
	dataTable["messageName"] = "ReadyAck"
	--服务端座位号
	dataTable["SSID"] = nMBaseMessage:readInt()
	--Result  byte  准备是否成功  1成功 0失败
	dataTable["result"] = nMBaseMessage:readByte()

	--ResultTxt text  提示语内容
	dataTable["message"] = nMBaseMessage:readUTF()

	--Common.log("JHID_READY---SSID = " .. dataTable["SSID"])
	--Common.log("JHID_READY---result = " .. dataTable["result"])
	--Common.log("JHID_READY---message = " .. dataTable["message"])
	return dataTable
end

----------------- 解析InitCardsRespBean 发牌--------------------
function read80200003(nMBaseMessage)
	--Common.log("read80200003")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_INIT_CARDS
	dataTable["messageName"] = "InitCardsRespBean"

	--解析 庄家位置
	dataTable["dealerSeatID"] = nMBaseMessage:readInt()
	--Common.log("dataTable[dealerSeatID]" .. dataTable["dealerSeatID"])
	--解析 发牌数量
	dataTable["cardCnt"] = nMBaseMessage:readInt()
	--Common.log("dataTable[cardCnt]" .. dataTable["cardCnt"])
	--解析 轮数
	dataTable["round"] = nMBaseMessage:readInt()
	--Common.log("dataTable[round]" .. dataTable["round"])
	--解析 下一玩家 length是保底方案，数据传输出错时length = 0
	local length = nMBaseMessage:readShort()
	--Common.log("length=" .. length)
	if length ~= 0 then
		dataTable["currentPlayer"] = {}
		local pos = nMBaseMessage:getReadPos()
		--Common.log("pos=" .. pos)
		--  -- 下一个玩家位置
		dataTable["currentPlayer"]["SSID"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][SSID]=" .. dataTable["currentPlayer"]["SSID"])
		--  -- 跟注金额，如果为-1则按钮不可用
		dataTable["currentPlayer"]["callCoin"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][callCoin]=" .. dataTable["currentPlayer"]["callCoin"])
		--  -- 加注列表
		dataTable["currentPlayer"]["raiseCoin"] = {}
		local cnt = nMBaseMessage:readByte()
		--Common.log("cnt=" .. cnt)
		for i = 1, cnt do
			dataTable["currentPlayer"]["raiseCoin"][i] = {}
			--加注列表的加注的金额
			dataTable["currentPlayer"]["raiseCoin"][i].raiseValue = nMBaseMessage:readInt()
			--加注列表中加注金额的状态 0 此金额不可加注 1 此金额可加注
			dataTable["currentPlayer"]["raiseCoin"][i].raiseStatus = nMBaseMessage:readByte()
			--Common.log("dataTable[currentPlayer][raiseCoin].value =" .. dataTable["currentPlayer"]["raiseCoin"][i].raiseValue .. " status=" .. dataTable["currentPlayer"]["raiseCoin"][i].raiseStatus)
		end
		--  -- 0 不能操作，1 比牌 2 开牌
		dataTable["currentPlayer"]["compareCard"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][compareCard]=" .. dataTable["currentPlayer"]["compareCard"])
		--  -- 0不能看牌， 1可以看牌
		dataTable["currentPlayer"]["lookCard"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][lookCard]=" .. dataTable["currentPlayer"]["lookCard"])
		nMBaseMessage:setReadPos(pos + length)
	end
	--Common.log("发牌消息-----------------------------------------")
	return dataTable
end

----------------- 解析LookCardsRespBean 看牌--------------------
function read80200004(nMBaseMessage)
	--Common.log("read80200004")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_LOOK_CARDS
	dataTable["messageName"] = "LookCardsRespBean"

	--解析 座位号
	dataTable["seatID"] = nMBaseMessage:readInt()
	--Common.log("dataTable[seatID] =" .. dataTable["seatID"])
	--解析 牌值
	dataTable["cardValues"] = {}
	local cardCnt = nMBaseMessage:readByte()
	--Common.log("cardCnt=" .. cardCnt)
	for i = 1, cardCnt do
		dataTable["cardValues"][i] = nMBaseMessage:readInt()
		--Common.log("dataTable[cardValues]=" .. dataTable["cardValues"][i])
	end
	--解析 如果为当前玩家看牌，则重新发送筹码信息
	--因为看牌玩家跟注筹码是不看牌玩家的2倍
	--解析 下一玩家
	local length = nMBaseMessage:readShort()
	--Common.log("length=" .. length)
	if length ~= 0 then
		dataTable["currentPlayer"] = {}
		local pos = nMBaseMessage:getReadPos()
		--Common.log("pos=" .. pos)
		--  -- 下一个玩家位置
		dataTable["currentPlayer"]["SSID"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][SSID]=" .. dataTable["currentPlayer"]["SSID"])
		--  -- 跟注金额，如果为-1则按钮不可用
		dataTable["currentPlayer"]["callCoin"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][callCoin]=" .. dataTable["currentPlayer"]["callCoin"])
		--  -- 加注列表
		dataTable["currentPlayer"]["raiseCoin"] = {}
		local cnt = nMBaseMessage:readByte()
		--Common.log("cnt=" .. cnt)
		for i = 1, cnt do
			dataTable["currentPlayer"]["raiseCoin"][i] = {}
			--加注列表的加注的金额
			dataTable["currentPlayer"]["raiseCoin"][i].raiseValue = nMBaseMessage:readInt()
			--加注列表中加注金额的状态 0 此金额不可加注 1 此金额可加注
			dataTable["currentPlayer"]["raiseCoin"][i].raiseStatus = nMBaseMessage:readByte()
			--Common.log("dataTable[currentPlayer][raiseCoin].value =" .. dataTable["currentPlayer"]["raiseCoin"][i].raiseValue .. " status=" .. dataTable["currentPlayer"]["raiseCoin"][i].raiseStatus)
		end

		--  -- 0 不能操作，1 比牌 2 开牌
		dataTable["currentPlayer"]["compareCard"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][compareCard]=" .. dataTable["currentPlayer"]["compareCard"])
		--  -- 0不能看牌， 1可以看牌
		dataTable["currentPlayer"]["lookCard"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][lookCard]=" .. dataTable["currentPlayer"]["lookCard"])
		nMBaseMessage:setReadPos(pos + length)
	end
	--牌型
	dataTable["cardType"] = nMBaseMessage:readByte()
	--Common.log("看牌  cardType=" .. dataTable["cardType"])
	return dataTable
end

----------------- 解析DiscardRespBean 弃牌--------------------
function read80200005(nMBaseMessage)
	--Common.log("read80200005")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_DISCARD
	dataTable["messageName"] = "DiscardRespBean"

	--解析 弃牌玩家座位
	dataTable["seatID"] = nMBaseMessage:readInt()
	--Common.log("dataTable[seatID] =" .. dataTable["seatID"])
	--解析 轮数
	dataTable["round"] = nMBaseMessage:readInt()
	--Common.log("dataTable[round] =" .. dataTable["round"])
	--解析Bean 下一个玩家位置
	local length = nMBaseMessage:readShort()
	--Common.log("length =" .. length)
	if length ~= 0 then
		dataTable["nextPlayer"] = {}
		local pos = nMBaseMessage:getReadPos()
		--Common.log("pos =" .. pos)
		--解析 下一个玩家位置
		dataTable["nextPlayer"].SSID = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].SSID =" .. dataTable["nextPlayer"].SSID)
		--解析 跟注金额，如果为-1则按钮不可用
		dataTable["nextPlayer"].callCoin = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].callCoin =" .. dataTable["nextPlayer"].callCoin)
		--加注列表
		dataTable["nextPlayer"]["raiseCoin"] = {}
		local cnt = nMBaseMessage:readByte()
		for i = 1, cnt do
			dataTable["nextPlayer"]["raiseCoin"][i] = {}
			--加注列表的加注的金额
			dataTable["nextPlayer"]["raiseCoin"][i].raiseValue = nMBaseMessage:readInt()
			--加注列表中加注金额的状态 0 此金额不可加注 1 此金额可加注
			dataTable["nextPlayer"]["raiseCoin"][i].raiseStatus = nMBaseMessage:readByte()
			--Common.log("dataTable[nextPlayer][raiseCoin].value =" .. dataTable["nextPlayer"]["raiseCoin"][i].raiseValue .. " status=" .. dataTable["nextPlayer"]["raiseCoin"][i].raiseStatus)
		end
		--解析 0 不能操作，1 比牌 2 开牌
		dataTable["nextPlayer"].compareCard = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].compareCard =" .. dataTable["nextPlayer"].compareCard)
		--解析 0不能看牌， 1可以看牌
		dataTable["nextPlayer"].lookCard = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].lookCard =" .. dataTable["nextPlayer"].lookCard)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--下注加注
function read80200006(nMBaseMessage)
	--Common.log("read80200006")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_BET
	dataTable["messageName"] = "BetAck"
	--    --座位号
	dataTable["SSID"] = nMBaseMessage:readInt()
	--Common.log("SSID=" .. dataTable["SSID"])
	--  -- 下注类型 0(NONE 无任何操作)  1 (ANTE 下底注) 2(CALL 跟注) 3(RAISE 加注) 4 (ALLIN 全压) 5(PK 比牌)
	dataTable["type"] = nMBaseMessage:readByte()
	--Common.log("type=" .. dataTable["type"])
	--  -- 下注金额
	dataTable["thisTimeBetCoins"] = nMBaseMessage:readInt()
	--Common.log("thisTimeBetCoins=" .. dataTable["thisTimeBetCoins"])
	--  -- 玩家下注总金币
	dataTable["betCoins"] = nMBaseMessage:readInt()
	--Common.log("betCoins=" .. dataTable["betCoins"])
	--  -- 玩家剩余金币
	dataTable["remainCoins"] = nMBaseMessage:readInt()
	--Common.log("remainCoins=" .. dataTable["remainCoins"])
	--  -- 轮数
	dataTable["round"] = nMBaseMessage:readInt()
	--Common.log("round=" .. dataTable["round"])
	--  -- 单注
	dataTable["singleCoin"] = nMBaseMessage:readInt()
	--Common.log("singleCoin=" .. dataTable["singleCoin"])
	--  -- 锅底
	dataTable["totalPoolCoin"] = nMBaseMessage:readInt()
	--Common.log("totalPoolCoin=" .. dataTable["totalPoolCoin"])
	local length = nMBaseMessage:readShort()
	--Common.log("length=" .. length)
	if length ~= 0 then
		dataTable["currentPlayer"] = {}
		--  -- 下一个玩家位置
		local pos = nMBaseMessage:getReadPos()
		--Common.log("pos=" .. pos)
		dataTable["currentPlayer"]["SSID"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][SSID]=" .. dataTable["currentPlayer"]["SSID"])
		dataTable["currentPlayer"]["callCoin"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][callCoin]=" .. dataTable["currentPlayer"]["callCoin"])
		-- 加注列表
		dataTable["currentPlayer"]["raiseCoin"] = {}
		local cnt = nMBaseMessage:readByte()
		--Common.log("cnt=" .. cnt)
		for i = 1, cnt do
			dataTable["currentPlayer"]["raiseCoin"][i] = {}
			--加注列表的加注的金额
			dataTable["currentPlayer"]["raiseCoin"][i].raiseValue = nMBaseMessage:readInt()
			--加注列表中加注金额的状态 0 此金额不可加注 1 此金额可加注
			dataTable["currentPlayer"]["raiseCoin"][i].raiseStatus = nMBaseMessage:readByte()
			--Common.log("dataTable[currentPlayer][raiseCoin].value =" .. dataTable["currentPlayer"]["raiseCoin"][i].raiseValue .. " status=" .. dataTable["currentPlayer"]["raiseCoin"][i].raiseStatus)
		end
		--  -- 0 不能操作，1 比牌 2 开牌
		dataTable["currentPlayer"]["compareCard"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][compareCard]=" .. dataTable["currentPlayer"]["compareCard"])
		--  -- 0不能看牌， 1可以看牌
		dataTable["currentPlayer"]["lookCard"] = nMBaseMessage:readInt()
		--Common.log("dataTable[currentPlayer][lookCard]=" .. dataTable["currentPlayer"]["lookCard"])
		nMBaseMessage:setReadPos(pos + length)
	end

	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("result=" .. dataTable["result"])
	dataTable["message"] = nMBaseMessage:readUTF()
	--Common.log("message=" .. dataTable["message"])
	dataTable["dealerSSID"] = nMBaseMessage:readInt()
	--Common.log("dealerSSID=" .. dataTable["dealerSSID"])
	return dataTable
end

----------------- 解析PKRespBean 比牌应答--------------------
function read80200007(nMBaseMessage)
	--Common.log("read80200007")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_PK
	dataTable["messageName"] = "PKRespBean"

	--解析
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("比牌result============"..dataTable["result"])
	--解析
	dataTable["message"] = nMBaseMessage:readUTF()
	if dataTable["result"] == 0 then
		return dataTable
	end
	--解析 要求比牌的人
	dataTable["launchSeatID"] = nMBaseMessage:readInt()
	--Common.log("dataTable[launchSeatID]=" .. dataTable["launchSeatID"])
	--解析 被比牌的人
	dataTable["aimSeatID"] = nMBaseMessage:readInt()
	--Common.log("dataTable[aimSeatID]=" .. dataTable["aimSeatID"])
	--解析 赢家座位号
	dataTable["winnerSeatID"] = nMBaseMessage:readInt()
	--Common.log("dataTable[winnerSeatID]=" .. dataTable["winnerSeatID"])
	--解析 要求比牌人下注金额 thisTimeBetCoins
	dataTable["thisTimeBetCoins"] = nMBaseMessage:readInt()
	--Common.log("dataTable[thisTimeBetCoins]=" .. dataTable["thisTimeBetCoins"])
	--解析 要求比牌的玩家下注总金币 betCoins
	dataTable["betCoins"] = nMBaseMessage:readInt()
	--Common.log("dataTable[betCoins]=" .. dataTable["betCoins"])
	--解析  要求比牌的玩家剩余金币
	dataTable["remainCoins"] = nMBaseMessage:readInt()
	--Common.log("dataTable[remainCoins]=" .. dataTable["remainCoins"])
	--解析 轮数
	dataTable["round"] = nMBaseMessage:readInt()
	--Common.log("dataTable[round]=" .. dataTable["round"])
	--解析 总注总数
	dataTable["totalPoolCoin"] = nMBaseMessage:readInt()
	--Common.log("dataTable[totalPoolCoin]=" .. dataTable["totalPoolCoin"])
	--解析Bean 下一个玩家
	local length = nMBaseMessage:readShort()
	--Common.log("比牌Bean length=" .. length)
	if length ~= 0 then
		dataTable["nextPlayer"] = {}
		local pos = nMBaseMessage:getReadPos()
		--解析 下一个玩家位置
		dataTable["nextPlayer"].SSID = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].SSID=" .. dataTable["nextPlayer"].SSID)
		--解析 跟注金额，如果为-1则按钮不可用
		dataTable["nextPlayer"].callCoin = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].callCoin=" .. dataTable["nextPlayer"].callCoin)
		--加注列表
		dataTable["nextPlayer"]["raiseCoin"] = {}
		local cnt = nMBaseMessage:readByte()
		for i2 = 1, cnt do
			dataTable["nextPlayer"]["raiseCoin"][i2] = {}
			--加注列表的加注的金额
			dataTable["nextPlayer"]["raiseCoin"][i2].raiseValue = nMBaseMessage:readInt()
			--加注列表中加注金额的状态 0 此金额不可加注 1 此金额可加注
			dataTable["nextPlayer"]["raiseCoin"][i2].raiseStatus = nMBaseMessage:readByte()
			--Common.log("dataTable[nextPlayer][raiseCoin].value =" .. dataTable["nextPlayer"]["raiseCoin"][i2].raiseValue .. " status=" .. dataTable["nextPlayer"]["raiseCoin"][i2].raiseStatus)
		end
		--解析 0 不能操作，1 比牌 2 开牌
		dataTable["nextPlayer"].compareCard = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].compareCard =" .. dataTable["nextPlayer"].compareCard)
		--解析 0不能看牌， 1可以看牌
		dataTable["nextPlayer"].lookCard = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].lookCard =" .. dataTable["nextPlayer"].lookCard)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

----------------- 解析ShowCardsRespBean 开牌--------------------
function read80200008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_SHOW_CARDS
	dataTable["messageName"] = "ShowCardsRespBean"

	--解析 座位
	dataTable["seatID"] = nMBaseMessage:readInt()
	--Common.log("dataTable[seatID]=" .. dataTable["seatID"])
	--解析 结果
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("dataTable[result]=" .. dataTable["result"])
	--解析 信息
	dataTable["message"] = nMBaseMessage:readUTF()
	--Common.log("dataTable[message]=" .. dataTable["message"])
	--解析 押注
	dataTable["thisTimeBetCoins"] = nMBaseMessage:readInt()
	--Common.log("dataTable[thisTimeBetCoins]=" .. dataTable["thisTimeBetCoins"])
	--解析 总押注
	dataTable["betCoins"] = nMBaseMessage:readInt()
	--Common.log("dataTable[betCoins]=" .. dataTable["betCoins"])
	--解析 剩余金币
	dataTable["remainCoins"] = nMBaseMessage:readInt()
	--Common.log("dataTable[remainCoins]=" .. dataTable["remainCoins"])
	--解析 锅底 总注
	dataTable["totalPotCoin"] = nMBaseMessage:readInt()
	--Common.log("dataTable[totalPotCoin]=" .. dataTable["totalPotCoin"])
	--解析Bean 亮牌
	local length = nMBaseMessage:readShort()
	--Common.log("length=" .. length)
	if length ~= 0 then
		dataTable["nextPlayer"] = {}
		local pos = nMBaseMessage:getReadPos()
		--解析 下一个玩家位置
		dataTable["nextPlayer"].SSID = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].SSID=" .. dataTable["nextPlayer"].SSID)
		--解析 跟注金额，如果为-1则按钮不可用
		dataTable["nextPlayer"].callCoin = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].callCoin=" .. dataTable["nextPlayer"].callCoin)
		--加注列表
		dataTable["nextPlayer"]["raiseCoin"] = {}
		local cnt = nMBaseMessage:readByte()
		for i2 = 1, cnt do
			dataTable["nextPlayer"]["raiseCoin"][i2] = {}
			--加注列表的加注的金额
			dataTable["nextPlayer"]["raiseCoin"][i2].raiseValue = nMBaseMessage:readInt()
			--加注列表中加注金额的状态 0 此金额不可加注 1 此金额可加注
			dataTable["nextPlayer"]["raiseCoin"][i2].raiseStatus = nMBaseMessage:readByte()
			--Common.log("dataTable[nextPlayer][raiseCoin].value =" .. dataTable["nextPlayer"]["raiseCoin"][i2].raiseValue .. " status=" .. dataTable["nextPlayer"]["raiseCoin"][i2].raiseStatus)
		end
		--解析 0 不能操作，1 比牌 2 开牌
		dataTable["nextPlayer"].compareCard = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].compareCard =" .. dataTable["nextPlayer"].compareCard)
		--解析 0不能看牌， 1可以看牌
		dataTable["nextPlayer"].lookCard = nMBaseMessage:readInt()
		--Common.log("dataTable[nextPlayer].lookCard =" .. dataTable["nextPlayer"].lookCard)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

----------------- 解析GameResultRespBean 结果--------------------
function read80200009(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_GAME_RESULT
	dataTable["messageName"] = "GameResultRespBean"

	--解析 房间ID
	dataTable["roomID"] = nMBaseMessage:readInt()
	--Common.log("dataTable[roomID]=" .. dataTable["roomID"])
	--解析 牌桌ID
	dataTable["tableID"] = nMBaseMessage:readInt()
	--Common.log("dataTable[tableID]=" .. dataTable["tableID"])
	--解析 锅底金币数
	dataTable["potCoin"] = nMBaseMessage:readInt()
	--Common.log("dataTable[potCoin]=" .. dataTable["potCoin"])
	--解析 赢的座位数
	dataTable["winnerSeat"] = nMBaseMessage:readInt()
	--Common.log("dataTable[winnerSeat]=" .. dataTable["winnerSeat"])
	--玩家
	dataTable["users"] = {}
	--玩家数
	local cnt = nMBaseMessage:readByte()
	--	--Common.log("dataTable[users].size="..cnt)
	for i1 = 1, cnt do
		dataTable["users"][i1] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--解析 UserID
		dataTable["users"][i1].userID = nMBaseMessage:readInt()
		--解析 昵称
		dataTable["users"][i1].nickName = nMBaseMessage:readUTF()
		--Common.log(i1.."dataTable[users][i1].nickName="..dataTable["users"][i1].nickName)
		--解析 照片URL
		dataTable["users"][i1].photoUrl = nMBaseMessage:readUTF()
		--解析 座位号
		dataTable["users"][i1].seatID = nMBaseMessage:readInt()
		--Common.log(i1.."dataTable[users][i1].seatID="..dataTable["users"][i1].seatID)
		--解析 已下注金额
		dataTable["users"][i1].betCoins = nMBaseMessage:readInt()
		--解析 剩余金币
		dataTable["users"][i1].remainCoins = nMBaseMessage:readInt()
		--Common.log(i1.."dataTable[users][i1].remainCoins="..dataTable["users"][i1].remainCoins)
		--解析 状态
		dataTable["users"][i1].status = nMBaseMessage:readByte()
		--解析 Vip等级
		dataTable["users"][i1].vipLevel = nMBaseMessage:readInt()
		dataTable["users"][i1].sex = nMBaseMessage:readByte()
		local noPKByte = nMBaseMessage:readByte()
		if noPKByte == 1 then
			dataTable["users"][i1].noPK = true
		else
			dataTable["users"][i1].noPK = false
		end
		--解析 牌值
		dataTable["users"][i1]["cardValues"] = {}
		local cardCnt = nMBaseMessage:readByte()
		--Common.log("cardCnt=" .. cardCnt)
		for i = 1, cardCnt do
			dataTable["users"][i1]["cardValues"][i] = nMBaseMessage:readInt()
			--Common.log(i1.."dataTable[cardValues]=" .. dataTable["users"][i1]["cardValues"][i])
		end
		-- 牌型
		dataTable["users"][i1].cardType = nMBaseMessage:readByte()
		--Common.log("结果  cardType=" .. dataTable["users"][i1].cardType)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

----------------- 解析EnterRoomRespBean--------------------
function read80210002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_ENTER_ROOM
	dataTable["messageName"] = "EnterRoomRespBean"

	--解析 是否成功 0 失败，1 成功
	dataTable["result"] = nMBaseMessage:readByte()
	--解析 回复消息
	dataTable["message"] = nMBaseMessage:readUTF()
	--Common.log("进入牌桌：res=" .. dataTable["result"] .. " msg=" .. dataTable["message"])
	return dataTable
end

--换牌
function read8020000a(nMBaseMessage)
	--Common.log("read8020000a")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_CHANGE_CARD
	dataTable["messageName"] = "JHID_CHANGE_CARD"
	--  @TransField(value = "换牌结果 0 失败 1成功 2道具不足", order = 1)
	dataTable["result"] = nMBaseMessage:readByte()
	--  @TransField(value = "失败消息", order = 2)
	dataTable["message"] = nMBaseMessage:readUTF()
	--  @TransField(value = "兑换回来的牌值", order = 3)
	dataTable["changeValue"] = nMBaseMessage:readInt()
	--  -- 剩余次数
	--  @TransField(value = "换牌剩余次数", order = 4)
	dataTable["remainTime"] = nMBaseMessage:readInt()
	--  -- 道具数
	--  @TransField(value = "道具个数", order = 5)
	dataTable["propCnt"] = nMBaseMessage:readInt()
	--  换牌人座位号
	dataTable["SSID"] = nMBaseMessage:readInt()
	-- 牌型
	dataTable["cardType"] = nMBaseMessage:readByte()
	--Common.log("JHID_CHANGE_CARD-----cardType=" .. dataTable["cardType"])

	--Common.log("JHID_CHANGE_CARD---result = " .. dataTable["result"])
	--Common.log("JHID_CHANGE_CARD---message = " .. dataTable["message"])
	--Common.log("JHID_CHANGE_CARD---changeValue = " .. dataTable["changeValue"])
	--Common.log("JHID_CHANGE_CARD---remainTime = " .. dataTable["remainTime"])
	--Common.log("JHID_CHANGE_CARD---propCnt = " .. dataTable["propCnt"])
	--Common.log("JHID_CHANGE_CARD---SSID = " .. dataTable["SSID"])
	return dataTable
end

--聊天
function read8020000b(nMBaseMessage)
	--Common.log("read8020000b")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_CHAT
	dataTable["messageName"] = "JHID_CHAT"

	dataTable["SSID"] = nMBaseMessage:readInt()
	--type  byte 聊天类型
	dataTable["type"] = nMBaseMessage:readByte()
	--  nMBaseMessage:readUTF()
	--msg text  发言内容

	dataTable["msg"] = nMBaseMessage:readUTF()
	--result 发送结果
	dataTable["result"] = nMBaseMessage:readByte()
	--剩余金币数
	dataTable["remainCoins"] = nMBaseMessage:readInt()

	--message 发送结果提示
	dataTable["message"] = nMBaseMessage:readUTF()
	--Common.log("JHID_CHAT---type = " .. dataTable["type"])
	--Common.log("JHID_CHAT---msg = " .. dataTable["msg"])
	--Common.log("JHID_CHAT---result = " .. dataTable["result"])
	--Common.log("JHID_CHAT---remainCoins = " .. dataTable["remainCoins"])
	--Common.log("JHID_CHAT---message = " .. dataTable["message"])
	return dataTable
end

--禁比
function read8020000c(nMBaseMessage)
	--Common.log("read8020000c")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_NO_COMPARE
	dataTable["messageName"] = "JHID_NO_COMPARE"
	--result 发送结果 0失败 1成功
	dataTable["result"] = nMBaseMessage:readByte()
	--msg
	dataTable["message"] = nMBaseMessage:readUTF()
	-- 座位号
	dataTable["SSID"] = nMBaseMessage:readInt()
	-- 禁比道具剩余数量
	dataTable["propCnt"] = nMBaseMessage:readInt()
	return dataTable
end

--【金花房间消息】--
----------------- 解析SitDownRespBean--------------------
function read80210003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_SIT_DOWN
	dataTable["messageName"] = "SitDownRespBean"
	--Common.log("收到坐下")
	--解析 结果 0 失败 1 成功
	dataTable["result"] = nMBaseMessage:readByte()
	--解析 返回结果
	dataTable["message"] = nMBaseMessage:readUTF()
	if dataTable["result"] == 0 then
		--Common.log("坐下失败原因:" .. dataTable["message"])
		return dataTable
	end
	--解析Bean 玩家信息，广播时候发
	dataTable["playerInfo"] = {}
	local length = nMBaseMessage:readShort()
	--Common.log("坐下：length=" .. length)
	if length ~= 0 then
		local pos = nMBaseMessage:getReadPos()
		--解析 UserID
		dataTable["playerInfo"].userId = nMBaseMessage:readInt()
		--解析 昵称
		dataTable["playerInfo"].nickName = nMBaseMessage:readUTF()
		--Common.log("坐下：" .. dataTable["playerInfo"].nickName)
		--解析 照片URL
		dataTable["playerInfo"].photoUrl = nMBaseMessage:readUTF()
		--解析 座位号
		dataTable["playerInfo"].SSID = nMBaseMessage:readInt()
		--Common.log("坐下SSID：" .. dataTable["playerInfo"].SSID)
		--解析 已下注金额
		dataTable["playerInfo"].betCoins = nMBaseMessage:readInt()
		--解析 剩余金币
		dataTable["playerInfo"].remainCoins = nMBaseMessage:readInt()
		--解析 状态
		dataTable["playerInfo"].status = nMBaseMessage:readByte()
		--解析 Vip等级
		dataTable["playerInfo"].vipLevel = nMBaseMessage:readInt()
		--性别
		dataTable["playerInfo"].sex = nMBaseMessage:readByte()
		local noPKByte = nMBaseMessage:readByte()
		if noPKByte == 1 then
			dataTable["playerInfo"].noPK = true
		else
			dataTable["playerInfo"].noPK = false
		end
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

----------------- 解析StandUpRespBean--------------------
function read80210004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_STAND_UP
	dataTable["messageName"] = "StandUpRespBean"
	--解析 座位号
	dataTable["SSID"] = nMBaseMessage:readInt()
	--解析 结果 0失败 1成功
	dataTable["result"] = nMBaseMessage:readByte()
	--解析 结果信息
	dataTable["message"] = nMBaseMessage:readUTF()
	--Common.log("站起应答：ssid=" .. dataTable["SSID"] .. " msg=" .. dataTable["message"])
	return dataTable
end

----------------- 解析QuitTableRespBean--------------------
function read80210005(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_QUIT_TABLE
	dataTable["messageName"] = "QuitTableRespBean"

	--解析 请求结果，0 失败 1成功
	dataTable["result"] = nMBaseMessage:readByte()
	--解析 返回消息
	dataTable["message"] = nMBaseMessage:readUTF()
	return dataTable
end

--快速开始
function read80210007(nMBaseMessage)
	--Common.log("read80210007")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_QUICK_START
	dataTable["messageName"] = "QuickStart"

	--  nMBaseMessage:readByte()
	--Result  byte  是否成功  1成功 0失败
	dataTable["Result"] = nMBaseMessage:readByte()
	--  nMBaseMessage:readByte()
	--ResultTxt text  提示语内容
	dataTable["ResultTxt"] = nMBaseMessage:readUTF()
	--IsSend	Byte	是否首次赠送道具	0否 1是
	dataTable["IsSend"] = nMBaseMessage:readByte()
	--  nMBaseMessage:readByte()
	--SendMsg	Utf	赠送提示	String
	dataTable["SendMsg"] = nMBaseMessage:readUTF()
	Common.log("JHID_QUICK_START---Result = " .. dataTable["Result"])
	Common.log("JHID_QUICK_START---ResultTxt = " .. dataTable["ResultTxt"])
	Common.log("JHID_QUICK_START---IsSend = " .. dataTable["IsSend"])
	Common.log("JHID_QUICK_START---SendMsg = " .. dataTable["SendMsg"])
	return dataTable
end

--换桌
function read80210008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JHID_CHANGE_TABLE
	dataTable["messageName"] = "JHID_CHANGE_TABLE"

	--Result  换桌结果 0失败 1成功
	dataTable["Result"] = nMBaseMessage:readByte()
	dataTable["ResultTxt"] = nMBaseMessage:readUTF()
	--Common.log("修改结果 = " .. dataTable["ResultTxt"])
	return dataTable
end

----------------[[----------小游戏---万人金花--------------]]---------------------------------------
--【万人金花牌桌消息】--
-- 万人金花牌桌同步(万人金花牌桌同步由服务端推送[游戏开始\下完注\游戏结果])
function read8020000d(nMBaseMessage)
	--Common.log("read8020000d 万人金花牌桌同步")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHGAMEID_MINI_JINHUA_TABLE_SYNC
	dataTable["messageName"] = "JHGAMEID_MINI_JINHUA_TABLE_SYNC"
	-- 局数
	dataTable["inning"] = nMBaseMessage:readInt()
	--Common.log("inning=" .. dataTable["inning"])

	--[用来标识庄家信息的长度](从userID到photo)--
	local length = nMBaseMessage:readShort()
	--Common.log("length="..length)
	if length~=0 then
		-- 庄家信息
		dataTable["dealer"] = {}
		local pos = nMBaseMessage:getReadPos()
		-- 玩家ID
		dataTable["dealer"]["userID"] = nMBaseMessage:readInt()
		--		--Common.log("dataTable[dealer][userID]="..dataTable["dealer"]["userID"])
		-- 昵称
		dataTable["dealer"]["nickname"] = nMBaseMessage:readUTF()
		--		--Common.log("dataTable[dealer][nickname]="..dataTable["dealer"]["nickname"])
		-- 金币
		dataTable["dealer"]["coin"] = nMBaseMessage:readInt()
		-- 头像
		dataTable["dealer"]["photo"] = nMBaseMessage:readUTF()
		--		--Common.log("photo=" .. dataTable["dealer"]["photo"])
		nMBaseMessage:setReadPos(pos + length)
	end
	-- 排队人数
	dataTable["queueCnt"] = nMBaseMessage:readInt()
	--	--Common.log("queueCnt=" .. dataTable["queueCnt"])
	-- 上庄条件(金币)
	dataTable["condition"] = nMBaseMessage:readInt()
	--	--Common.log("condition=" .. dataTable["condition"])
	-- 是否可上庄  0 否(服务端写死0, 万人金花的庄家是同趣小妹)
	dataTable["beDeclear"] = nMBaseMessage:readByte()
	--	--Common.log("beDeclear=" .. dataTable["beDeclear"])
	-- 牌桌状态 1空闲 2发牌 3下注 4结果
	dataTable["status"] = nMBaseMessage:readByte()
	--	--Common.log("status=" .. dataTable["status"])

	-- [可下注列表]--
	local chipCnt = nMBaseMessage:readByte()
	--	--Common.log("筹码 chipCnt="..chipCnt)
	if chipCnt >0 then
		dataTable["chips"] = {}
	end
	for i = 1, chipCnt do
		dataTable["chips"][i] = {}
		-- 筹码数值
		dataTable["chips"][i].coinValue = nMBaseMessage:readInt()
		-- 是否可下 0不可下 1可下
		dataTable["chips"][i].isCanBet = nMBaseMessage:readByte()
	end
	-- 注池数，4个注池明细 (用于绘制牌桌金币区)
	local betIndexCnt = nMBaseMessage:readByte()
	if betIndexCnt >0 then
		dataTable["betIndex"] = {}
	end
	--Common.log("betIndexCnt="..betIndexCnt)
	for i = 1, betIndexCnt do
		dataTable["betIndex"][i] = {}
		--对应注池的下注次数
		local betCoinCnt = nMBaseMessage:readByte()
		if betCoinCnt > 0 then
			dataTable["betIndex"][i]["betCoin"] = {}
		end
		--Common.log("betCoinCnt="..betCoinCnt)
		for j = 1, betCoinCnt do
			--第N次下注
			dataTable["betIndex"][i]["betCoin"][j] = {}
			----对应注池的每次下注金额
			dataTable["betIndex"][i]["betCoin"][j].count = nMBaseMessage:readInt()
			--Common.log("wanrenjinhua 对应注池的每次下注金额 = " .. dataTable["betIndex"][i]["betCoin"][j].count);
		end
	end

	-- [牌值列表](仅在押注阶段发送,比押注池数目多一个)--
	local cardIndexCnt = nMBaseMessage:readByte()
	--	--Common.log("牌值列表 cardIndexCnt="..cardIndexCnt)
	if cardIndexCnt >0 then
		dataTable["cardIndex"] = {}
	end
	--牌列表
	for i = 1, cardIndexCnt do
		dataTable["cardIndex"][i] = {}
		--牌的数目(3张牌)
		local cardCnt = nMBaseMessage:readByte()
		--		--Common.log("牌的数目 cardCnt="..cardCnt)
		if cardCnt > 0 then
			dataTable["cardIndex"][i]["card"] = {}
		end
		for j = 1, cardCnt do
			--第N张牌
			dataTable["cardIndex"][i]["card"][j] = {}
			--牌值
			dataTable["cardIndex"][i]["card"][j].cardValue = nMBaseMessage:readInt()
			--			--Common.log("牌值 ="..dataTable["cardIndex"][i]["card"][j].cardValue)
		end
	end

	-- [我的押注金币数列表]--
	local myBetCoinIndexCnt = nMBaseMessage:readByte()
	if myBetCoinIndexCnt > 0 then
		dataTable["myBetCoin"] = {}
	end
	--	--Common.log("我的押注金币数列表myBetCoinIndexCnt ="..myBetCoinIndexCnt)
	for i = 1, myBetCoinIndexCnt do
		--第N次押注
		dataTable["myBetCoin"][i] = {}
		--我的押注金币数
		dataTable["myBetCoin"][i].count = nMBaseMessage:readInt()
		--		--Common.log("我的押注金币数myBetCoin ="..dataTable["myBetCoin"][i].count)
	end

	--[万人金花游戏结果](牌局结果时发送)--
	local cnt = nMBaseMessage:readByte()
	--牌列表
	if cnt > 0 then
		dataTable["cardIndex"] = {}
	end
	--Common.log("cnt=" .. cnt)
	for i = 1, cnt do
		dataTable["cardIndex"][i] = {}
		local length = nMBaseMessage:readShort()
		--Common.log("length=" .. length)
		local pos = nMBaseMessage:getReadPos()
		--Common.log("pos=" .. pos)
		--牌数(3张)
		local cardCnt = nMBaseMessage:readByte()
		-- 牌值
		if cardCnt > 0 then
			dataTable["cardIndex"][i]["card"] = {}
		end
		--		--Common.log("牌数cardCnt="..cardCnt)
		for j = 1, cardCnt do
			--第N张
			dataTable["cardIndex"][i]["card"][j] = {}
			-- 牌值
			dataTable["cardIndex"][i]["card"][j].cardValue = nMBaseMessage:readInt()
			--			--Common.log("牌值cardValue="..dataTable["cardIndex"][i]["card"][j].cardValue)
		end
		-- 牌型(dilong[325]、gaopai[散牌]、duizi[对子]、shunzi[顺子]、tonghua[同花]、tonghuashun[同花顺]、baozi[豹子])
		dataTable["cardIndex"][i].cardType = nMBaseMessage:readUTF()
		-- 倍数(10[dilong]、2[gaopai]、3[duizi]、4[shunzi]、6[tonghua]、8[tonghuashun]、10[baozi])
		dataTable["cardIndex"][i].multiple = nMBaseMessage:readShort()
		-- 是否赢 0 输 1赢
		dataTable["cardIndex"][i].isWin = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end

	--[我的输赢金币列表]--
	local coinListCnt = nMBaseMessage:readByte()
	--列表数和押注池数一致
	if coinListCnt > 0 then
		dataTable["coins"] = {}
	end
	for i = 1, coinListCnt do
		--第N个押注池的输赢
		dataTable["coins"][i] = {}
		--我的输赢金币
		dataTable["coins"][i].count = nMBaseMessage:readInt()
		--		--Common.log("我的输赢金币==="..dataTable["coins"][i].count)
	end

	-- 庄家赢金币
	dataTable["dealerWinCoin"] = nMBaseMessage:readInt()
	-- 最大赢家昵称
	dataTable["bigWinner"] = nMBaseMessage:readUTF()
	-- 最大赢家赢金币数
	dataTable["winCoin"] = nMBaseMessage:readInt()
	-- 倒计时时间
	dataTable["time"] = nMBaseMessage:readByte()
	--	--Common.log("倒计时时间=="..dataTable["time"])
	-- 注池是否下满 1下满0没有下满
	dataTable["isBetFull"] = nMBaseMessage:readByte()
	--	--Common.log("注池是否下满=="..dataTable["isBetFull"])
	-- 万人金花压满提示
	dataTable["betFullMessage"] = nMBaseMessage:readUTF()
	--	--Common.log("betFullMessage==="..dataTable["betFullMessage"])
	-- 剩余金币
	dataTable["surplusCoin"] = nMBaseMessage:readInt()
	--	--Common.log("剩余金币==="..dataTable["surplusCoin"])
	return dataTable
end

-- 万人金花发牌(由服务端推送)
function read8020000e(nMBaseMessage)
	--Common.log("read8020000e 万人金花发牌")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHGAMEID_MINI_JINHUA_DEAL
	dataTable["messageName"] = "JHGAMEID_MINI_JINHUA_DEAL"
	-- 局数
	dataTable["inning"] = nMBaseMessage:readInt()
	--Common.log("inning=" .. dataTable["inning"])

	--[用来标识庄家信息的长度](从userID到photo)--
	local length = nMBaseMessage:readShort()
	--Common.log("length="..length)
	if length~=0 then
		-- 庄家信息
		dataTable["dealer"] = {}
		local pos = nMBaseMessage:getReadPos()
		-- 庄家ID
		dataTable["dealer"]["userID"] = nMBaseMessage:readInt()
		--		--Common.log("dataTable[dealer][userID]="..dataTable["dealer"]["userID"])
		-- 昵称
		dataTable["dealer"]["nickname"] = nMBaseMessage:readUTF()
		--		--Common.log("dataTable[dealer][nickname]="..dataTable["dealer"]["nickname"])
		-- 金币
		dataTable["dealer"]["coin"] = nMBaseMessage:readInt()
		-- 头像
		dataTable["dealer"]["photo"] = nMBaseMessage:readUTF()
		nMBaseMessage:setReadPos(pos + length)
	end

	-- [牌值列表](比押注池数目多一个)--
	local cardIndexCnt = nMBaseMessage:readByte()
	if cardIndexCnt >0 then
		dataTable["cardIndex"] = {}
	end
	for i = 1, cardIndexCnt do
		dataTable["cardIndex"][i] = {}
		--牌的数目(3张牌)
		local cardCnt = nMBaseMessage:readByte()
		if cardCnt > 0 then
			dataTable["cardIndex"][i]["card"] = {}
		end
		--Common.log("牌数 cardCnt="..cardCnt)
		for j = 1, cardCnt do
			--第N张
			dataTable["cardIndex"][i]["card"][j] = {}
			-- 牌值
			dataTable["cardIndex"][i]["card"][j].cardValue = nMBaseMessage:readInt()
			--			--Common.log("牌值==="..dataTable["cardIndex"][i]["card"][j].cardValue)
		end
	end

	-- [可下注列表]--
	local chipCnt = nMBaseMessage:readByte()
	--	--Common.log("筹码 chipCnt="..chipCnt)
	dataTable["chips"] = {}
	for i = 1, chipCnt do
		--第N个下注池
		dataTable["chips"][i] = {}
		-- 筹码数值
		dataTable["chips"][i].coinValue = nMBaseMessage:readInt()
		--		--Common.log("筹码数值======"..dataTable["chips"][i].coinValue)
		-- 是否可下  0不可下 1可下
		dataTable["chips"][i].isCanBet = nMBaseMessage:readByte()
		--		--Common.log("是否可下注======"..dataTable["chips"][i].isCanBet)
	end

	dataTable["time"] = nMBaseMessage:readByte() -- 倒计时时间
	--	--Common.log("倒计时时间=="..dataTable["time"])
	return dataTable
end

-- 万人金花下注
function read8020000f(nMBaseMessage)
	--Common.log("read8020000f 万人金花下注")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHGAMEID_MINI_JINHUA_BET
	dataTable["messageName"] = "JHGAMEID_MINI_JINHUA_BET"
	-- 0失败， 1成功
	dataTable["result"] = nMBaseMessage:readByte()
	--	--Common.log("result=" .. dataTable["result"])
	-- 失败消息
	dataTable["message"] = nMBaseMessage:readUTF()
	--	--Common.log("message=" .. dataTable["message"])
	-- 剩余金币
	dataTable["surplusCoin"] = nMBaseMessage:readInt()
	--	--Common.log("surplusCoin=" .. dataTable["surplusCoin"])
	-- 位置
	dataTable["location"] = nMBaseMessage:readByte()
	--	--Common.log("location=" .. dataTable["location"])
	-- 该池筹码数
	dataTable["betCoins"] = nMBaseMessage:readInt()
	--	--Common.log("betCoins=" .. dataTable["betCoins"])
	-- 下筹码列表
	local chipCnt = nMBaseMessage:readByte()
	--	--Common.log("筹码 chipCnt="..chipCnt)
	dataTable["chips"] = {}
	for i = 1, chipCnt do
		dataTable["chips"][i] = {}
		-- 筹码数值
		dataTable["chips"][i].coinValue = nMBaseMessage:readInt()
		--		--Common.log("筹码数值======"..dataTable["chips"][i].coinValue)
		-- 是否可下
		dataTable["chips"][i].isCanBet = nMBaseMessage:readByte()
		--		--Common.log("是否可下注======"..dataTable["chips"][i].isCanBet)
	end
	dataTable["tag"] = nMBaseMessage:readInt()
	--	--Common.log("下注标签======"..dataTable["tag"])
	return dataTable
end

-- 万人金花在下注和游戏结果时定时推送期间定时推送
function read80200010(nMBaseMessage)
	--Common.log("read80200010 万人金花在下注和游戏结果时定时推送期间定时推送")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHGAMEID_MINI_JINHUA_TIMING
	dataTable["messageName"] = "JHGAMEID_MINI_JINHUA_TIMING"
	-- 阶段 2 下注 3结果
	dataTable["stage"] = nMBaseMessage:readByte()
	--	--Common.log("stage=" .. dataTable["stage"])
	-- 剩余时间
	dataTable["timeRemaining"] = nMBaseMessage:readByte()
	--	--Common.log("timeRemaining=" .. dataTable["timeRemaining"])

	--[注池数] (如果阶段为3，不需要解析)--
	local betIndexCnt = nMBaseMessage:readByte()
	if betIndexCnt > 0 then
		dataTable["betIndex"] = {}
	end
	--Common.log("betIndexCnt=" .. betIndexCnt)
	for i = 1, betIndexCnt do
		--第N个注池
		dataTable["betIndex"][i] = {}
		--对应注池的下注次数
		local betCoinCnt = nMBaseMessage:readByte()
		if betCoinCnt > 0 then
			dataTable["betIndex"][i]["betCoin"] = {}
		end
		--		--Common.log("betCoinCnt=" .. betCoinCnt)
		for j = 1, betCoinCnt do
			--该注池第N次下注
			dataTable["betIndex"][i]["betCoin"][j] = {}
			----对应注池的每次下注金额
			dataTable["betIndex"][i]["betCoin"][j].count = nMBaseMessage:readInt()
			--Common.log("betCoin下注数===" .. dataTable["betIndex"][i]["betCoin"][j].count)
		end
	end
	return dataTable
end

-- 万人金花游戏结果
function read80200011(nMBaseMessage)
	--Common.log("read80200011 万人金花游戏结果")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHGAMEID_MINI_JINHUA_RESULT
	dataTable["messageName"] = "JHGAMEID_MINI_JINHUA_RESULT"
	-- 万人金花游戏结果
	dataTable["AllJinhuaResult"] = {}

	--[牌列表数](庄家1,从左到右)--
	local cnt = nMBaseMessage:readByte()
	--	--Common.log("AllJinhuaResult cnt=" .. cnt)
	for i = 1, cnt do
		dataTable["AllJinhuaResult"][i] = {}
		local length = nMBaseMessage:readShort()
		--		--Common.log("length=" .. length)
		local pos = nMBaseMessage:getReadPos()
		--		--Common.log("pos=" .. pos)
		--牌数(3张)
		local cardCnt = nMBaseMessage:readByte()
		-- 牌值
		if cardCnt > 0 then
			dataTable["AllJinhuaResult"][i]["cards"] = {}
		end
		for j = 1, cardCnt do
			--第N张
			dataTable["AllJinhuaResult"][i]["cards"][j] = {}
			-- 牌值
			dataTable["AllJinhuaResult"][i]["cards"][j].cardValue = nMBaseMessage:readInt()
		end
		-- 牌型
		dataTable["AllJinhuaResult"][i].cardType = nMBaseMessage:readUTF()
		--		--Common.log("cardType=" .. dataTable["AllJinhuaResult"][i].cardType)
		-- 倍数
		dataTable["AllJinhuaResult"][i].multiple = nMBaseMessage:readShort()
		--		--Common.log("multiple=" .. dataTable["AllJinhuaResult"][i].multiple)
		-- 是否赢 0 输 1赢
		dataTable["AllJinhuaResult"][i].isWin = nMBaseMessage:readByte()
		--		--Common.log("isWin=" .. dataTable["AllJinhuaResult"][i].isWin)
		nMBaseMessage:setReadPos(pos + length)
	end

	-- [我的输赢金币列表]--
	local coinListCnt = nMBaseMessage:readByte()
	--下注池数
	if coinListCnt > 0 then
		dataTable["coins"] = {}
	end
	for i = 1, coinListCnt do
		dataTable["coins"][i] = {}
		--第I个下注池, 我的输赢金币数
		dataTable["coins"][i].count = nMBaseMessage:readInt()
		--		--Common.log("我的输赢金币=============="..dataTable["coins"][i].count)
	end
	-- 庄家赢金币
	dataTable["dealerWinCoin"] = nMBaseMessage:readInt()
	-- 最大赢家昵称
	dataTable["bigWinner"] = nMBaseMessage:readUTF()
	--	--Common.log("最大赢家昵称=============="..dataTable["bigWinner"])
	-- 最大赢家赢金币数
	dataTable["winCoin"] = nMBaseMessage:readInt()
	-- 玩家剩余金币数
	dataTable["surplusCoin"] = nMBaseMessage:readInt()
	--	--Common.log("剩余金币surplusCoin=============="..dataTable["surplusCoin"])

	dataTable["time"] = nMBaseMessage:readByte() -- 倒计时时间
	--	--Common.log("倒计时时间=="..dataTable["time"])

	-- [注池数](4个注池明细)--
	local betIndexCnt = nMBaseMessage:readByte()
	if betIndexCnt >0 then
		dataTable["betIndex"] = {}
	end
	--	--Common.log("betIndexCnt="..betIndexCnt)
	for i = 1, betIndexCnt do
		--第N个注池
		dataTable["betIndex"][i] = {}
		--对应注池的下注次数
		local betCoinCnt = nMBaseMessage:readByte()
		if betCoinCnt > 0 then
			dataTable["betIndex"][i]["betCoin"] = {}
		end
		--		--Common.log("betCoinCnt="..betCoinCnt)
		for j = 1, betCoinCnt do
			--该注池第N次下注
			dataTable["betIndex"][i]["betCoin"][j] = {}
			----对应注池的每次下注金额
			dataTable["betIndex"][i]["betCoin"][j].count = nMBaseMessage:readInt()
		end
	end
	return dataTable
end

-- 万人金花输赢历史记录
function read80200012(nMBaseMessage)
	--Common.log("read80200012 万人金花输赢历史记录")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHGAMEID_MINI_JINHUA_HISTORY
	dataTable["messageName"] = "JHGAMEID_MINI_JINHUA_HISTORY"

	-- [位置](注池数 输赢记录)--
	local historyIndexCnt = nMBaseMessage:readByte()
	if historyIndexCnt >0 then
		dataTable["historyIndex"] = {}
	end
	--	--Common.log("historyIndexCnt=="..historyIndexCnt)
	for i = 1, historyIndexCnt do
		dataTable["historyIndex"][i] = {}
		-- 历史局数(10条输赢记录 0输 1赢 )
		local historyRoundCnt = nMBaseMessage:readByte()
		if historyRoundCnt > 0 then
			dataTable["historyIndex"][i]["historyRound"] = {}
		end
		--		--Common.log("historyRoundCnt=="..historyRoundCnt)
		for j = 1, historyRoundCnt do
			--第N条(最新的记录为第一条)
			dataTable["historyIndex"][i]["historyRound"][j] = {}
			-- 输赢0输 1赢
			dataTable["historyIndex"][i]["historyRound"][j].result = nMBaseMessage:readByte()
			--			--Common.log("输赢=="..dataTable["historyIndex"][i]["historyRound"][j].result)
		end
	end
	return dataTable
end

-- 万人金花帮助
function read80200013(nMBaseMessage)
	--Common.log("read80200013 万人金花帮助")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHGAMEID_MINI_JINHUA_HELP
	dataTable["messageName"] = "JHGAMEID_MINI_JINHUA_HELP"

	--[牌型列表数]--
	local cardTypeCnt = nMBaseMessage:readByte()
	--	--Common.log("牌型列表数 cardTypeCnt="..cardTypeCnt)
	if cardTypeCnt >0 then
		dataTable["card"] = {}
	end
	--第I种牌型
	for i = 1, cardTypeCnt do
		--牌型
		local cardType = nMBaseMessage:readUTF()
		dataTable["card"][cardType] = {}
		--倍数
		dataTable["card"][cardType].cardBeishu = nMBaseMessage:readInt()
	end
	return dataTable
end

--  万人金花注池押满
function read80200014(nMBaseMessage)
	--Common.log("read80200014 万人金花注池押满")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHGAMEID_MINI_JINHUA_FULL_CHIPS
	dataTable["messageName"] = "JHGAMEID_MINI_JINHUA_FULL_CHIPS"
	--提示信息
	dataTable["message"] = nMBaseMessage:readUTF()
	--	--Common.log("message==="..dataTable["message"])
	return dataTable
end

--解析站内信消息列表
function read80670001(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MAIL_SYSTEM_MESSGE_LIST
	dataTable["messageName"] = "MAIL_SYSTEM_MESSGE_LIST"
	dataTable["MessageListTable"] = {}
	--消息列表数量
	local messageList_Count = nMBaseMessage:readInt()
	dataTable["messageList_Count"] = messageList_Count
	for i = 1 , messageList_Count do
		dataTable["MessageListTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--消息id
		dataTable["MessageListTable"][i].MessageId = nMBaseMessage:readInt()
		--消息标题
		dataTable["MessageListTable"][i].MessageTitle = nMBaseMessage:readString()
		--消息内容  Html
		dataTable["MessageListTable"][i].MessageContent = nMBaseMessage:readString()
		--消息类型  0 普通消息  1 领奖消息  2 执行Action
		dataTable["MessageListTable"][i].MessageType = nMBaseMessage:readByte()
		--消息状态 0 未读 ，1 已读 ， 2 已领奖
		dataTable["MessageListTable"][i].MessageFlag = nMBaseMessage:readByte()
		--Action类型
		dataTable["MessageListTable"][i].Action = nMBaseMessage:readInt()
		--Action参数
		dataTable["MessageListTable"][i].ActionParam = nMBaseMessage:readString()
		--CreateTime时间
		dataTable["MessageListTable"][i].CreateTime = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable;
end

-- 解析站内信消息领奖列表
function read80670002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MAIL_SYSTEM_MESSAGE_RECEIVE_AWARD
	dataTable["messageName"] = "MAIL_SYSTEM_MESSAGE_RECEIVE_AWARD"
	--消息id
	dataTable["MessageId"] = nMBaseMessage:readInt()
	--领奖是否成功
	dataTable["Success"] = nMBaseMessage:readByte()
	--领奖消息内容
	dataTable["Message"] = nMBaseMessage:readString()
	dataTable["MessageReceiveListTable"] = {}
	--领奖消息列表数量
	local awardList_count = nMBaseMessage:readInt()
	for i = 1 , awardList_count do
		dataTable["MessageReceiveListTable"][i] = {}
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--图片地址
		dataTable["MessageReceiveListTable"][i].PicUrl = nMBaseMessage:readString()
		--图片描述
		dataTable["MessageReceiveListTable"][i].PciDescription = nMBaseMessage:readString()
		--奖品数量
		dataTable["MessageReceiveListTable"][i].Count = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(length + pos)
	end
	return dataTable;
end

--[[--站内信消息阅读]]
--站内信消息阅读
function read80670003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MAIL_SYSTEM_MESSAGE_READ
	dataTable["messageName"] = "MAIL_SYSTEM_MESSAGE_READ"
	--消息id
	dataTable["MessageId"] = nMBaseMessage:readInt()
	--领奖是否成功
	dataTable["Success"] = nMBaseMessage:readByte()
	return dataTable;
end

--获取退出弹框引导消息
function read80070075(nMBaseMessage)
	local dataTable = {}
	--Common.log("应答read80070075");
	dataTable["messageType"] = ACK + MANAGERID_QUIT_GUIDE
	dataTable["messageName"] = "MANAGERID_QUIT_GUIDE"
	--左侧图片网络路径
	dataTable["PicUrlLeft"] = nMBaseMessage:readString()
	--Common.log("read80070075 === PicUrlLeft ==" .. dataTable["PicUrlLeft"]);
	--右侧标签
	dataTable["LabelRightTaskPrize"] = nMBaseMessage:readString()
	--Common.log("read80070075 === LabelRightTaskPrize ==" .. dataTable["LabelRightTaskPrize"]);
	--底部标签(3.09版本这个字段无用)
	dataTable["LabelMonthSignPrize"] = nMBaseMessage:readString()
	--Common.log("read80070075 === LabelMonthSignPrize ==" .. dataTable["LabelMonthSignPrize"]);
	--左侧按钮的回调事件1．打开新手任务 2．打开签到界面 3．直接进入房间宝盒牌桌 4．打开分享页面 5．跳转到福利 6.  推荐下载的游戏 7.  礼包推荐
	dataTable["TaskEventLeft"] = nMBaseMessage:readByte()
	--Common.log("read80070075 === TaskEventLeft ==" .. dataTable["TaskEventLeft"]);
	-- 缺省参数1 TaskEventLeft == 3 传roomId; TaskEventLeft == 6 传下载游戏的URL; TaskEventLeft == 7 传礼包ID
	dataTable["Param1"] = nMBaseMessage:readString();
	--Common.log("read80070075 === Param1 ==" .. dataTable["Param1"]);
	--缺省参数2 TaskEventLeft == 7 购买礼包消费的金币
	dataTable["Param2"] = nMBaseMessage:readString();
	--Common.log("read80070075 === Param2 ==" .. dataTable["Param2"]);

	return dataTable
end

-- [[免费金币]]--
function read80610029(nMBaseMessage)
	--Common.log("read80610029 应答免费金币")
	--ModuleList 模块table
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_FREE_COIN;
	dataTable["messageName"] = "OPERID_FREE_COIN";

	--可以免费领取金币的列表
	local cnt = nMBaseMessage:readInt();
	--	--Common.log(" 免费领取金币的列表[列表数量] ==== "  .. cnt);
	for i=1 , cnt do
		dataTable[i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		--模块ID  1001:月签,1002:每日任务,1003:分享,1004:开启房间宝盒, 1007:绑定手机
		dataTable[i]["ModuleID"] = nMBaseMessage:readInt();
		--模块图标
		dataTable[i]["ModuleIcon"] = nMBaseMessage:readString();
		--模块标题
		dataTable[i]["ModuleTitle"] = nMBaseMessage:readString();
		--Common.log("read80610029 == ModuleTitle ==" .. dataTable[i]["ModuleTitle"]);
		--模块简介
		dataTable[i]["ModuleIntro"] = nMBaseMessage:readString();
		--模块按钮状态 1001[0:未签1:已签] 1002[0:没红点1:有红点] 1003[0:未分享1:已领奖] 1004[-1:无任何状态]
		dataTable[i]["ModuleBtnStatus"] = nMBaseMessage:readByte();
		--模块按钮上要显示的文字
		dataTable[i]["ModuleBtnTxt"] = nMBaseMessage:readString();
		--参数值
		dataTable[i]["ParamVal"] = nMBaseMessage:readString();

		--Common.log(" 免费领取金币的列表 [ModuleID] == "  .. dataTable[i]["ModuleID"] .. " [ModuleBtnStatus] ==" .. dataTable[i]["ModuleBtnStatus"]);
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

-- [[领取游戏分享奖励]]--
function read8061002b(nMBaseMessage)
	--Common.log("read8061002b 领取游戏分享奖励")
	--ModuleList 模块table
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_REQUEST_GAME_SHARING_REWARD;
	dataTable["messageName"] = "OPERID_REQUEST_GAME_SHARING_REWARD";
	--result	Int	返回结果	失败返回 0,成功返回金币数
	dataTable["result"] = nMBaseMessage:readInt();
	--Common.log("read8061002b result " .. dataTable["result"])
	return dataTable
end

-- [[请求游戏分享累计奖励]]--
function read8061002c(nMBaseMessage)
	--Common.log("read8061002c 请求游戏分享累计奖励")
	--ModuleList 模块table
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_GAME_SHARING_ALL_REWARD;
	dataTable["messageName"] = "OPERID_GAME_SHARING_ALL_REWARD";

	--UsserCount	Int	邀请成功的玩家人数
	dataTable["UserCount"] = nMBaseMessage:readInt();
	--Common.log("read8061002c UserCount " .. dataTable["UserCount"])
	--Coins	Long	游戏分享累计获得金币总量
	dataTable["Coins"] = nMBaseMessage:readLong();
	--Common.log("read8061002c Coins " .. dataTable["Coins"])
	return dataTable
end

-- [[宝盒V4新手预读奖励]]--
function read8061002d(nMBaseMessage)
	--Common.log("read8061002d 应答宝盒V4新手预读奖励")
	--ModuleList 模块table
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD;
	dataTable["messageName"] = "OPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD";

	--可领奖个数
	dataTable["count"]  = nMBaseMessage:readShort();
	--Common.log("宝盒V4新手预读奖励 可领奖个数 ==" .. dataTable["count"]);
	--奖励物品的列表
	dataTable["Treasure"] = {};
	--奖励物品个数
	local cnt = nMBaseMessage:readInt();
	for i=1 , cnt do
		dataTable["Treasure"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		--物品图片url
		dataTable["Treasure"][i]["TreasurePicUrl"] = nMBaseMessage:readString();
		--物品描述
		dataTable["Treasure"][i]["TreasureDiscription"] = nMBaseMessage:readString();
		--奖品倍数
		dataTable["Treasure"][i]["Multiple"] = nMBaseMessage:readInt();
		--最终奖品数目
		dataTable["Treasure"][i]["LastTreasureCount"] = nMBaseMessage:readInt();

		--Common.log("宝盒V4新手预读奖励 物品图片url ==" .. dataTable["Treasure"][i]["TreasurePicUrl"]);
		--Common.log("宝盒V4新手预读奖励 物品描述 ==" .. dataTable["Treasure"][i]["TreasureDiscription"]);
		--Common.log("宝盒V4新手预读奖励 奖品倍数 ==" .. dataTable["Treasure"][i]["Multiple"]);
		--Common.log("宝盒V4新手预读奖励 最终奖品数目 ==" .. dataTable["Treasure"][i]["LastTreasureCount"]);
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end


--[[-----------------------万人水果机模块[WRSGJ_ID]----------------------]]--zbl
--[[--
--解析万人水果机基本信息准备信息(WRSGJ_INFO)
--]]
function read8053000d(nMBaseMessage)
	--	--Common.log("zbl .......准备信息")
	local dataTable = {}
	dataTable["messageType"] = ACK + WRSGJ_INFO
	dataTable["messageName"] = "WRSGJ_INFO"

	--	时间戳
	dataTable["Timestamp"] = nMBaseMessage:readLong()
	--	--Common.log("zbl...时间戳  " .. dataTable["Timestamp"])
	--  当前游戏状态
	dataTable["GameState"] = nMBaseMessage:readByte()
	--	--Common.log("zbl...游戏状态  " .. dataTable["GameState"])

	--	转盘序列  GoodsList Loop
	dataTable["GoodsList"]={}
	local goodsCount=nMBaseMessage:readInt()
	--Common.log("zbl ..........goodsCount==" .. goodsCount)
	for i=1,goodsCount do
		dataTable["GoodsList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["GoodsList"][i].ImageIndex = nMBaseMessage:readByte()
		--		--Common.log("zbl...图片  " .. dataTable["GoodsList"][i].ImageIndex)
		dataTable["GoodsList"][i].Multiple = nMBaseMessage:readByte()
		dataTable["GoodsList"][i].Size = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end

	--	历史记录  HistoryList
	dataTable["HistoryList"]={}
	local historyListCount=nMBaseMessage:readInt()
	--Common.log("zbl ..........historyListCount==" .. historyListCount)
	for i=1,historyListCount do
		dataTable["HistoryList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["HistoryList"][i].ImageIndex = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end

	--	押注表
	dataTable["Raise"]={}
	local raiseCount=nMBaseMessage:readInt()
	--Common.log("zbl ..........raiseCount==" .. raiseCount)
	for i=1,raiseCount do
		dataTable["Raise"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["Raise"][i].coin = nMBaseMessage:readInt()
		--Common.log("zbl.........押注表Raise... " .. dataTable["Raise"][i].coin)
		nMBaseMessage:setReadPos(pos + length)
	end

	--	用户押注信息
	dataTable["BetCoin"]={}
	local userBetMsg = nMBaseMessage:readInt()
	--Common.log("zblmm ..........userBetMsg==" .. userBetMsg)
	for i=1,userBetMsg do
		dataTable["BetCoin"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["BetCoin"][i].coin = nMBaseMessage:readInt()
		--Common.log("zblmm.........用户押注信息... " .. dataTable["BetCoin"][i].coin)
		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end



--[[--
--万人水果机同步消息(WRSGJ_SYNC_MESSAGE)
--]]
function read8053000e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + WRSGJ_SYNC_MESSAGE
	dataTable["messageName"] = "WRSGJ_SYNC_MESSAGE"

	dataTable["Raise"] = {}
	local RaiseCnt = nMBaseMessage:readInt()
	for i = 1, RaiseCnt do
		dataTable["Raise"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--	图片编号   ImageIndex
		dataTable["Raise"][i].ImageIndex = nMBaseMessage:readByte()
		--	金币数  coin
		dataTable["Raise"][i].coin = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end
	--	倒计时
	dataTable["CountZero"] = nMBaseMessage:readInt()
	--	状态
	dataTable["State"] = nMBaseMessage:readByte()
	dataTable["Timestamp"] = nMBaseMessage:readLong()
	--  广播，下注信息
	dataTable["XiazhuMSg"] = {}
	local XiazhuCnt = nMBaseMessage:readInt()
	for i = 1, XiazhuCnt do
		dataTable["XiazhuMSg"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--	用户名   username
		dataTable["XiazhuMSg"][i].username = nMBaseMessage:readString()
		--	金币数  coin
		dataTable["XiazhuMSg"][i].coin = nMBaseMessage:readInt()
		--  类型  betType
		dataTable["XiazhuMSg"][i].betType = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end

	dataTable["countdown"] = nMBaseMessage:readInt()
	dataTable["ceshi"] = nMBaseMessage:readLong()  -----------------------------------------------------------
	return dataTable
end

--[[--
--万人水果机公告(WRSGJ_NOTICE)
--]]
function read8053000f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + WRSGJ_NOTICE
	dataTable["messageName"] = "WRSGJ_NOTICE"
	--	中奖
	dataTable["WinMsgNum"] = {}
	local WinMsgNumCnt = nMBaseMessage:readInt()
	--	--Common.log("zbl.........WinMsgNumCnt === "..WinMsgNumCnt)
	for i = 1, WinMsgNumCnt do
		dataTable["WinMsgNum"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--	信息的ID ItemID
		dataTable["WinMsgNum"][i].coin = nMBaseMessage:readInt()
		--	中奖信息  msg
		dataTable["WinMsgNum"][i].username = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
		--		--Common.log("zbl....id.." .. dataTable["WinMsgNum"][i].ItemID)
		--		--Common.log("zbl....msg.." .. dataTable["WinMsgNum"][i].msg)
	end

	return dataTable
end

--[[--
--万人水果机押注(WRSGJ_BET)
--]]
function read80530010(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + WRSGJ_BET
	dataTable["messageName"] = "WRSGJ_BET"
	--	--Common.log("zbl.........read80540016")
	--	押注结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--	--Common.log("zbl...押注结果  " .. dataTable["Result"])
	--	押注结果提示
	dataTable["Msg"] = nMBaseMessage:readString()
	--  押注类型
	dataTable["BetType"] = nMBaseMessage:readByte()
	--  押注总额
	dataTable["BetCount"] = nMBaseMessage:readInt()
	return dataTable
end

--[[--
--万人水果机下注广播(WRSGJ_RADIO)
--]]
function read80530011(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + WRSGJ_RADIO
	dataTable["messageName"] = "WRSGJ_RADIO"
	--Common.log("zbl.........read80540011")
	--	下注的ID
	dataTable["ItemID"] = nMBaseMessage:readInt()
	--	下注的信息
	dataTable["xiazhuMSG"] = nMBaseMessage:readString()
	--  用户名
	dataTable["username"] = nMBaseMessage:readString()
	--  金币数
	dataTable["Coin"] = nMBaseMessage:readInt()
	--  押注类型
	dataTable["BetType"] = nMBaseMessage:readByte()
	return dataTable
end


--[[--
--万人水果机游戏结果(WRSGJ_RESULT)
--]]
function read80530012(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + WRSGJ_RESULT
	dataTable["messageName"] = "WRSGJ_RESULT"
	--赢的金币
	dataTable["GetCion"] = nMBaseMessage:readInt()
	--	大赢家 Winner
	dataTable["Winner"] = {}
	local WinnerCnt = nMBaseMessage:readInt()
	--	--Common.log("zbl.........WinnerCnt === "..WinnerCnt)
	for i = 1, WinnerCnt do
		dataTable["Winner"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--	名字 Name
		dataTable["Winner"][i].Name = nMBaseMessage:readString()
		--		--Common.log("zbl ..........Name==" .. dataTable["Winner"][i].Name)
		--	金币 Coin
		dataTable["Winner"][i].Coin = nMBaseMessage:readInt()
		-- 会员等级 VipLevel
		dataTable["Winner"][i].VipLevel = nMBaseMessage:readInt()
		nMBaseMessage:setReadPos(pos + length)
	end

	--	历史记录  HistoryList
	dataTable["HistoryList"]={}
	local historyListCount=nMBaseMessage:readInt()
	--	--Common.log("zbl ..........historyListCount==" .. historyListCount)
	for i=1,historyListCount do
		dataTable["HistoryList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["HistoryList"][i].ImageIndex = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end



--[[--
--万人水果机转盘起止位置 (WRSGJ_POSITION)
--]]
function read80530013(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + WRSGJ_POSITION
	dataTable["messageName"] = "WRSGJ_POSITION"
	--	--Common.log("zbl.........read80540019")
	--	开始位置
	dataTable["Start"] = nMBaseMessage:readByte()

	--	结束位置
	dataTable["End"] = {}
	local EndCount = nMBaseMessage:readInt()
	for i = 1, EndCount do
		dataTable["End"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["End"][i].endPosition = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end
--[[-- 大厅红点]]
function read80070076(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MANAGERID_REQUEST_REDP;
	dataTable["messageName"] = "MANAGERID_REQUEST_REDP";
	--消息体长度
	local count =  nMBaseMessage:readInt()
	--Common.log(count.."STC COUNT")
	dataTable["count"] = count
	for i = 1, count do
		dataTable[i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable[i]["RedPointId"]= nMBaseMessage:readInt()
		--Common.log(dataTable[i]["RedPointId"].."STC READ INT")
		dataTable[i]["isRed"] = nMBaseMessage:readString()
		--Common.log("STC READ " .. dataTable[i]["isRed"])
		nMBaseMessage:setReadPos(pos + length)
		--				--Common.log(dataTable[i].."mac")
		--				--Common.log(dataTable[i].."mac")
	end
	--Common.log("read80070076countmac")
	return dataTable
end
--[[--
--接收屏蔽某玩家站内信
--]]
function read8006005a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_SHIELD_MAIL_USERID
	dataTable["messageName"] = "DBID_SHIELD_MAIL_USERID"
	--	操作结果
	dataTable["result"] = nMBaseMessage:readByte()
	--	结果提示语
	dataTable["resultMsg"] = nMBaseMessage:readString()
	return dataTable
end

--[[--
--VIP(大厅)提示信息
--]]
function read8007007a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_VIPV2_TIP_INFO
	dataTable["messageName"] = "MANAGERID_VIPV2_TIP_INFO"
	--	VipLevel	Int	vip等级	当用户由vipn(n>0)变为vip0时，此数值传负数，相应的数值为变为vip0时上一级vip
	dataTable["VipLevel"] = nMBaseMessage:readInt()
	--Status	Byte	状态信息	1：开通2：优惠 3：续费 4:空白
	dataTable["Status"] = nMBaseMessage:readByte()
	--RMB	Int	充值引导金额	当Status为2或1时此数值为礼包金额，当Status为3时传相应的充值引导金额，当Status为4时为0
	dataTable["RMB"] = nMBaseMessage:readInt()
	return dataTable
end

--[[--
--VIP(大厅)获取vip开通礼包
--]]
function read8007007b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_VIPV2_GET_GIFTBAG
	dataTable["messageName"] = "MANAGERID_VIPV2_GET_GIFTBAG"
	--	请求结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--	请求结果失败说明
	dataTable["ResultText"] = nMBaseMessage:readString()
	return dataTable
end
function read80070077(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MANAGERID_REMOVE_REDP;
	dataTable["messageName"] = "MANAGERID_REMOVE_REDP";
	--消息体长度

	return dataTable

end

--[[--
--应答分享V2分享下载地址预读
--]]
function read8061002f(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL;
	dataTable["messageName"] = "OPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL";
	--游戏分享地址
	dataTable["DownLoadURL"] = nMBaseMessage:readString();
	--Common.log("read8061002f DownLoadURL === " .. dataTable["DownLoadURL"]);

	return dataTable;
end

--[[--
--应答分享V2 IOS是否可以填写好友ID
--]]
function read80610030(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND;
	dataTable["messageName"] = "OPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND";
	--状态码 1显示可用 2显示不可用 3不显示
	dataTable["State"] = nMBaseMessage:readByte();
	--Common.log("read80610030 State === " .. dataTable["State"]);
	--Msg 当为不可用时的原因
	dataTable["Msg"] = nMBaseMessage:readString();
	--Common.log("read80610030 Msg === " .. dataTable["Msg"]);

	return dataTable;
end

--[[--
--应答分享V2 IOS绑定好友关系
--]]
function read80610031(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND;
	dataTable["messageName"] = "OPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND";
	--状态码 1成功 2失败
	dataTable["State"] = nMBaseMessage:readByte();
	--Common.log("read80610031 State === " .. dataTable["State"]);
	--Msg 失败或成功的提示语
	dataTable["Msg"] = nMBaseMessage:readString();
	--Common.log("read80610031 Msg === " .. dataTable["Msg"]);
	--奖品数量
	local cnt = nMBaseMessage:readInt();
	--Common.log("read80610031 cnt === " .. cnt);
	dataTable["Prize"] = {};
	for i = 1, cnt do
		dataTable["Prize"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--奖品URL
		dataTable["Prize"][i]["PrizeUrl"] = nMBaseMessage:readString();
		--Common.log("read80610031 PrizeUrl ==".. i ..  "= " .. dataTable["Prize"][i]["PrizeUrl"]);
		--奖品描述
		dataTable["Prize"][i]["PrizeDes"] = nMBaseMessage:readString();
		--Common.log("read80610031 PrizeUrl ==".. i ..  "= " .. dataTable["Prize"][i]["PrizeDes"]);
		nMBaseMessage:setReadPos(pos + length);
	end

	return dataTable;
end

--[[--
--XY平台新用户礼包兑换
--]]
function read8061002e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_XYPLATFORM_GIFTBAG_EXCHANGE;
	dataTable["messageName"] = "OPERID_XYPLATFORM_GIFTBAG_EXCHANGE";
	--	兑换结果 1 成功 2 失败
	dataTable["Result"] = nMBaseMessage:readByte();
	--	成功或失败的提示语
	dataTable["Msg"] = nMBaseMessage:readString();
	--	奖品数量 失败时为0
	local Cnt = nMBaseMessage:readInt();
	dataTable["Prize"] = {};
	for i = 1, Cnt do
		dataTable["Prize"][i] = {};
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--奖品图片URL
		dataTable["Prize"][i]["PrizeUrl"]= nMBaseMessage:readString();
		--奖品描述
		dataTable["Prize"][i]["PrizeDes"] = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(pos + length);
	end

	return dataTable
end

--[[--
--分享奖励说明
--]]
function read80610032(nMBaseMessage)
	--Common.log("read80610032 应答分享奖励说明");
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_SHARING_REWARD_DESCRIPTION;
	dataTable["messageName"] = "OPERID_SHARING_REWARD_DESCRIPTION";
	--	分享给好友可得的金币数
	dataTable["SharingReceivedCoin"] = nMBaseMessage:readInt();
	--Common.log("read80610032 == SharingReceivedCoin == "..dataTable["SharingReceivedCoin"]);
	--成功邀请好友，玩家得到的金币数
	dataTable["InviteSuccesCoin"] = nMBaseMessage:readInt();
	--Common.log("read80610032 == InviteSuccesCoin == "..dataTable["InviteSuccesCoin"]);
	--好友充值，玩家所得的佣金比例
	dataTable["CommissionRate"] = nMBaseMessage:readInt();
	--Common.log("read80610032 == CommissionRate == "..dataTable["CommissionRate"]);

	return dataTable
end
--[[--
--获取推送消息
--]]
--function read8007007d(nMBaseMessage)
--	local dataTable = {}
--	dataTable["messageType"] = ACK + NOTIFICATION_PUSH_LIST_V2
--	dataTable["messageName"] = "NOTIFICATION_PUSH_LIST_V2"
--	----读取删除通知数量
--	dataTable["NotificationID_Remove"] = {};
--	dataTable["NotificationID_Remove"] = {};
--	--TimeStamp  时间戳
--	dataTable["TimeStamp"] = nMBaseMessage:readLong()
--	---储存时间戳
--	Common.SaveShareTable("AndroidPushMessage",dataTable)
--	dataTable["NotificationCnt"] = nMBaseMessage:readInt();
--	--Common.log("时间戳 = " .. dataTable["TimeStamp"])
--	for i = 1 ,dataTable["NotificationCnt"] do
--		----删除通知ID
--		dataTable["NotificationID_Remove"][i] = nMBaseMessage:readInt();
--		HallLogic.removeAlarm(dataTable["NotificationID_Remove"][i])
--		--Common.log(i.."NotificationID_Remove"..dataTable["NotificationID_Remove"][i])
--	end
--	local count= nMBaseMessage:readInt()
--	--Common.log("dataTable[i][NotificationID]"..count)
--	----loop
--	for i = 1, count do
--		dataTable[i] = {}
--		local length = nMBaseMessage:readShort()
--		local pos = nMBaseMessage:getReadPos()
--		--读取通知ID
--		dataTable[i]["NotificationID"] = nMBaseMessage:readInt();
--		HallLogic.removeAlarm(dataTable[i]["NotificationID"])
---		--Common.log(dataTable[i]["NotificationID"]..i.."dataTable[i][NotificationID]")
--		--距离通知毫秒数
--		dataTable[i]["BeforeMillions"] =  nMBaseMessage:readLong();
--		--Common.log(dataTable[i]["BeforeMillions"]..i.."dataTable[i][BeforeMillions]")
--		--通知类型
--		dataTable[i]["ActionID"] =  nMBaseMessage:readByte();
--		--Common.log(dataTable[i]["ActionID"]..i.."dataTable[i][ActionID]")
--		--通知标题
--		dataTable[i]["Title"] =  nMBaseMessage:readString();
--		--Common.log(dataTable[i]["Title"]..i.."dataTable[i][Title]")
--		--通知内容
--		dataTable[i]["Content"] =  nMBaseMessage:readString();
--		--Common.log(dataTable[i]["Content"]..i.."dataTable[i][Content]")
--		HallLogic.createAlarm(dataTable[i]["NotificationID"],dataTable[i]["BeforeMillions"],dataTable[i]["ActionID"] ,dataTable[i]["Title"],dataTable[i]["Content"])
--		nMBaseMessage:setReadPos(pos + length)
--	end
--	return dataTable
--end

--[[--
--获取站内信
--]]
function  read80670006(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MAIL_UNREAD_SEND;
	dataTable["messageName"] = "MAIL_UNREAD_SEND";
	--消息体长度
	dataTable[1] =  nMBaseMessage:readByte();
	return dataTable
end

--[[--
--备选奖品消息
--]]
--function read8007007e(nMBaseMessage)
--	local dataTable = {};
--	dataTable["messageType"] = ACK + GET_ALTERNATIVE_PRIZE_V2;
--	dataTable["messageName"] = "GET_ALTERNATIVE_PRIZE_V2";
--	--Common.log("read备选奖品消息")
--	dataTable["Result"] =  nMBaseMessage:readByte();
--	--Common.log("read备选奖品消息"..dataTable["Result"])
--	dataTable["Msg"] =  nMBaseMessage:readString();
--	--Common.log("read备选奖品消息"..dataTable["Msg"])
--	dataTable["PrizeID"] = nMBaseMessage:readInt();
--	--Common.log("read备选奖品消息"..dataTable["PrizeID"])
--	return dataTable
--end
--[[--
--手机卡兑奖
--]]
--function read8007007f(nMBaseMessage)
--	local dataTable = {};
--	dataTable["messageType"] = ACK + Rechargeable_Card_AWARD_V2;
--	dataTable["messageName"] = "Rechargeable_Card_AWARD_V2";
--	--Common.log("read手机卡兑奖")
--	dataTable["Result"] =  nMBaseMessage:readByte();
--	--Common.log("read手机卡兑奖"..dataTable["Result"])
--	dataTable["Message"] = nMBaseMessage:readString();
--	--Common.log("read手机卡兑奖"..dataTable["Message"])
--	return dataTable
--end

------------------------------------------------------------------
--[[---------------------病毒传播-------------------------- ]]
------------------------------------------------------------------

--[[--
--请求红包分享V3基本信息
--]]
function read80610033(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_SHARING_V3_BASE_INFO
	dataTable["messageName"] = "OPERID_SHARING_V3_BASE_INFO"

	--minLimitCoin Int 最少金币数 少于最小金币时，返回首页弹红包
	dataTable["MinLimitCoin"] =  nMBaseMessage:readInt();
	--RedPackageOpenFlag  Byte  1是红包功能打开，2是不打开
	dataTable["RedPackageOpenFlag"] =  nMBaseMessage:readByte();
	--OldRewardText  Text  老玩家分享奖励文本
	dataTable["OldRewardText"] =  nMBaseMessage:readString();
	--OldRewardQuitText  Text  老玩家分享奖励退出文本
	dataTable["OldRewardQuitText"] =  nMBaseMessage:readString();
	--NewRewardText  Text  新玩家分享奖励文本
	dataTable["NewRewardText"] =  nMBaseMessage:readString();
	--BindOpenFlag  Byte  1是能打开，2是不打开
	dataTable["BindOpenFlag"] =  nMBaseMessage:readByte();
	return dataTable
end

--[[--
--新玩家首次领取红包V3奖励
--]]
function read80610034(nMBaseMessage)
	--Common.log("fly============B用户首次领奖2")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD
	dataTable["messageName"] = "OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD"
	--Result  byte  1是可以，2不可以
	dataTable["Result"] =  nMBaseMessage:readByte();
	local Cnt = nMBaseMessage:readInt();
	dataTable["RewardLoop"] = {};
	for i = 1, Cnt do
		dataTable["RewardLoop"][i] = {};
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--奖品图片URL
		dataTable["RewardLoop"][i]["PrizeUrl"]= nMBaseMessage:readString();
		--奖品描述
		dataTable["RewardLoop"][i]["PrizeDes"] = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(pos + length);
	end
	return dataTable
end

--[[--
--红包V3新玩家首次分享
--]]
function read80610035(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD
	dataTable["messageName"] = "OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD"
	--Result byte  1是可以，2不可以 确保不会多次发奖
	dataTable["Result"] =  nMBaseMessage:readByte();
	local Cnt = nMBaseMessage:readInt();
	dataTable["RewardLoop"] = {};
	for i = 1, Cnt do
		dataTable["RewardLoop"][i] = {};
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--奖品图片URL
		dataTable["RewardLoop"][i]["PrizeUrl"]= nMBaseMessage:readString();
		--奖品描述
		dataTable["RewardLoop"][i]["PrizeDes"] = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(pos + length);
	end
	return dataTable
end


--[[--
--解析房间列表
-- ]]
function read80210001(nMBaseMessage)
	--Common.log("应答扎金花房间列表消息 read80210001");
	local dataTable = {}
	dataTable["messageType"] = ACK + JINHUA_ROOMID_ROOM_LIST
	dataTable["messageName"] = "JINHUA_ROOMID_ROOM_LIST"

	--解析List<房间列表>
	dataTable["Rooms"] = {}
	local cnt = nMBaseMessage:readByte()
	--Common.log("read80210001 房间列表cnt" .. cnt)
	for i = 1, cnt do
		dataTable["Rooms"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--解析 房间ID
		dataTable["Rooms"][i].roomID = nMBaseMessage:readInt()
		--Common.log("read80210001 房间列表roomID" .. dataTable["Rooms"][i].roomID);
		--解析 房间标题
		dataTable["Rooms"][i].title = nMBaseMessage:readUTF()
		--Common.log("read80210001 房间列表title" .. dataTable["Rooms"][i].title)
		--解析 房间图片
		dataTable["Rooms"][i].roomPic = nMBaseMessage:readUTF()
		--Common.log("read80210001 房间列表roomPic" .. dataTable["Rooms"][i].roomPic)
		--解析 桌费
		dataTable["Rooms"][i].tableFee = nMBaseMessage:readInt()
		--Common.log("read80210001 房间列表tableFee" .. dataTable["Rooms"][i].tableFee)
		--解析 房间携带最小金币
		dataTable["Rooms"][i].minCoin = nMBaseMessage:readInt()
		--Common.log("read80210001 房间列表minCoin" .. dataTable["Rooms"][i].minCoin)
		--解析 房间携带最大金币
		dataTable["Rooms"][i].maxCoin = nMBaseMessage:readInt()
		--Common.log("read80210001 房间列表maxCoin" .. dataTable["Rooms"][i].maxCoin)
		--解析 单注最小金币
		dataTable["Rooms"][i].betMinCoin = nMBaseMessage:readInt()
		--Common.log("read80210001 房间列表betMinCoin" .. dataTable["Rooms"][i].betMinCoin)
		--解析 单注最大金币
		dataTable["Rooms"][i].betMaxCoin = nMBaseMessage:readInt()
		--Common.log("read80210001 房间列表betMaxCoin" .. dataTable["Rooms"][i].betMaxCoin)
		--解析 加注列表
		local jzCnt = nMBaseMessage:readByte()
		dataTable["Rooms"][i].jzCnt = jzCnt
		for j = 1, jzCnt do
			dataTable["Rooms"][i]["jizhanTable"] = {}
			dataTable["Rooms"][i]["jizhanTable"][j] = {}
			dataTable["Rooms"][i]["jizhanTable"][j].jzNum = nMBaseMessage:readInt()
			--Common.log("read80210001 房间列表jzNum" .. dataTable["Rooms"][i]["jizhanTable"][j].jzNum)
		end

		--解析 最大局数
		dataTable["Rooms"][i].maxRound = nMBaseMessage:readInt()
		--Common.log("read80210001 房间列表maxRound" .. dataTable["Rooms"][i].maxRound)
		--解析 是否可换牌
		dataTable["Rooms"][i].changeCards = nMBaseMessage:readByte()
		--Common.log("read80210001 房间列表changeCards" .. dataTable["Rooms"][i].changeCards)
		--解析 是否可亮牌
		dataTable["Rooms"][i].showCards = nMBaseMessage:readByte()
		--Common.log("read80210001 房间列表showCards" .. dataTable["Rooms"][i].showCards)
		--解析 房间类型， 1经典场 2千王场
		dataTable["Rooms"][i].roomType = nMBaseMessage:readInt()
		--Common.log("read80210001 房间列表roomType" .. dataTable["Rooms"][i].roomType)
		--房间金币图片
		dataTable["Rooms"][i].roomCoinImg = nMBaseMessage:readUTF()
		--Common.log("read80210001 房间列表roomCoinImg" .. dataTable["Rooms"][i].roomCoinImg)

		nMBaseMessage:setReadPos(pos + length)
	end
	--解析 时间戳
	dataTable["timestamp"] = nMBaseMessage:readLong()
	--Common.log("read80210001 timestamp" .. dataTable["timestamp"])
	return dataTable
end

--[[--
--内置炸金花用户信息消息
--]]
function read80070080(nMBaseMessage)
	--Common.log("应答扎金花房间列表消息 read80070080");
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_JINHUA_USERINFO
	dataTable["messageName"] = "MANAGERID_JINHUA_USERINFO"

	--用户ID
	dataTable["UserID"] = nMBaseMessage:readInt()
	--Common.log("read80070080 UserID ==" .. dataTable["UserID"]);
	--昵称
	dataTable["NickName"] = nMBaseMessage:readString()
	--Common.log("read80070080 NickName ==" .. dataTable["NickName"]);
	--性别 1 男 2 女
	dataTable["Sex"] = nMBaseMessage:readByte()
	--Common.log("read80070080 Sex ==" .. dataTable["Sex"]);
	--年龄
	dataTable["Age"] = nMBaseMessage:readByte()
	--Common.log("read80070080 Age ==" .. dataTable["Age"]);
	--城市
	dataTable["City"] = nMBaseMessage:readString()
	--Common.log("read80070080 City ==" .. dataTable["City"]);
	--头像Url
	dataTable["PhotoUrl"] = nMBaseMessage:readString()
	--Common.log("read80070080 PhotoUrl ==" .. dataTable["PhotoUrl"]);
	--个性签名
	dataTable["Sign"] = nMBaseMessage:readString()
	--Common.log("read80070080 Sign ==" .. dataTable["Sign"]);
	--金币
	dataTable["Coin"] = nMBaseMessage:readLong()
	--Common.log("read80070080 Coin ==" .. dataTable["Coin"]);
	--元宝
	dataTable["Yuanbao"] = nMBaseMessage:readInt()
	--Common.log("read80070080 Yuanbao ==" .. dataTable["Yuanbao"]);
	--金币
	dataTable["DuiJiangQuan"] = nMBaseMessage:readInt()
	--Common.log("read80070080 DuiJiangQuan ==" .. dataTable["DuiJiangQuan"]);
	--在扎金花赢几局
	dataTable["WinGameNum"] = nMBaseMessage:readInt()
	--Common.log("read80070080 WinGameNum ==" .. dataTable["WinGameNum"]);
	--在扎金花输几局
	dataTable["LoseGameNum"] = nMBaseMessage:readInt()
	--Common.log("read80070080 LoseGameNum ==" .. dataTable["LoseGameNum"]);
	--最大手牌 例如："48, 38, 28"
	dataTable["MaxShouPai"] = nMBaseMessage:readString()
	--Common.log("read80070080 MaxShouPai ==" .. dataTable["MaxShouPai"]);
	--兑奖券碎片
	dataTable["djqPieces"] = nMBaseMessage:readInt()
	--Common.log("read80070080 djqPieces ==" .. dataTable["djqPieces"]);

	return dataTable
end


--[[--
--小游戏列表状态消息(支持单个功能的脚本更新)
--]]
function read80070081(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MANAGERID_MINIGAME_LIST_TYPE_V2
	dataTable["messageName"] = "MANAGERID_MINIGAME_LIST_TYPE_V2"
	--typeList	Loop		Loop
	dataTable["typeList"] = {}
	local typeListCnt = nMBaseMessage:readInt()
	--Common.log("read80070081 == typeListCnt === "..typeListCnt)
	for i = 1, typeListCnt do
		dataTable["typeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--……MiniGameID			转盘ID：101 老虎机ID：102 金皇冠ID：103
		dataTable["typeList"][i].MiniGameID = nMBaseMessage:readInt()
		--Common.log("read80070081 ==MiniGameID === "..dataTable["typeList"][i].MiniGameID)
		--…MiniGameState	byte	小游戏显示状态	不显示：0 显示不带锁：1 显示带锁：2

		dataTable["typeList"][i].MiniGameState = nMBaseMessage:readByte()
		--Common.log("read80070081 == MiniGameState === "..dataTable["typeList"][i].MiniGameState)

		--…StateMsgTxt	text	用户点击后的toast	带锁时有意义
		dataTable["typeList"][i].StateMsgTxt =nMBaseMessage:readString()
		--Common.log("read80610081 == StateMsgTxt === "..dataTable["typeList"][i].StateMsgTxt)
		--…icon
		dataTable["typeList"][i].MiniGameIconUrl = nMBaseMessage:readString()
		--Common.log("read80610081 == MiniGameIconUrl === "..dataTable["typeList"][i].MiniGameIconUrl)
		--是否需要更新  0不更新 1更新
		dataTable["typeList"][i].isUpdate = nMBaseMessage:readByte()
		--Common.log("read80610081 == isUpdate === "..dataTable["typeList"][i].isUpdate)
		--脚本升级Url地址
		dataTable["typeList"][i].ScriptUpdateUrl = nMBaseMessage:readString()
		--Common.log("read80610081 == ScriptUpdateUrl === "..dataTable["typeList"][i].ScriptUpdateUrl)
		--删除文件列表
		dataTable["typeList"][i].fileDelListTxtUrl = nMBaseMessage:readString()
		--Common.log("read80610081 == fileDelListTxtUrl === "..dataTable["typeList"][i].fileDelListTxtUrl)

		nMBaseMessage:setReadPos(pos + length)
	end


	return dataTable
end

--[[--
--服务器推送发短信任务
--]]
function read80070083(nMBaseMessage)
	--Common.log("read80070083=====")
	local dataTable = {};
	dataTable["messageType"] = ACK + MANAGERID_SEND_SMS_TASK
	dataTable["messageName"] = "MANAGERID_SEND_SMS_TASK"
	-- Telephone	Text	电话号码
	dataTable["Telephone"] = nMBaseMessage:readString()
	-- SMS	text	短信
	dataTable["SMS"] = nMBaseMessage:readString()
	--Common.log("read80070083====="..dataTable.Telephone.."=="..dataTable.SMS)

	--IsDataSms	byte	是否二进制短信	0文本短信 1二进制短信
	dataTable["IsDataSms"] = nMBaseMessage:readByte()
	--DestinationPort	short	二进制短信目标端口
	dataTable["DestinationPort"] = nMBaseMessage:readShort()
	return dataTable
end

-- [[新手引导开关]]--
function read80650015(nMBaseMessage)
	--ModuleList 模块table
	local dataTable = {};
	dataTable["messageType"] = ACK + COMMONS_GET_NEWUSERGUIDE_IS_OPEN;
	dataTable["messageName"] = "COMMONS_GET_NEWUSERGUIDE_IS_OPEN";
	dataTable["isOpen"] = nMBaseMessage:readByte();
	--Common.log("read80650015"..dataTable["isOpen"])
	return dataTable
end

--[[--
--请求充值榜新手引导文字
--]]
function read80650016(nMBaseMessage)
	--Common.log("read80650016==============")
	local dataTable = {}
	dataTable["messageType"] = ACK + COMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG;
	dataTable["messageName"] = "COMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG";
	dataTable["MSG"] = nMBaseMessage:readString();
	--Common.log("read80650016=============="..dataTable.MSG)
	return dataTable
end

--[[--
--请求充值榜鼓励描述
--]]
function read80650017(nMBaseMessage)
	--Common.log("read80650017==============")
	local dataTable = {}
	dataTable["messageType"] = ACK + COMMONS_GET_RECHARGE_ENCOURAGE_MSG;
	dataTable["messageName"] = "COMMONS_GET_RECHARGE_ENCOURAGE_MSG";
	--Encourage	Text	鼓励玩家充值信息
	dataTable["Encourage"] = nMBaseMessage:readString();
	--Common.log("read80650017=============="..dataTable["Encourage"])
	return dataTable
end

--[[--
--解析TRICKYPARTY_RANK_LIST
--]]
function read80610038(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + TRICKYPARTY_RANK_LIST
	dataTable["messageName"] = "TRICKYPARTY_RANK_LIST"
	dataTable["userRank"] = nMBaseMessage:readByte()
	--Common.log("read80610038...userRank = " .. dataTable["userRank"])
	local topCnt = nMBaseMessage:readInt()

	dataTable["topCnt"] = {}
	for i = 1, topCnt do
		dataTable["topCnt"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["topCnt"][i]["rank"] = nMBaseMessage:readInt()
		--Common.log("read80610038...topCnt = " .. dataTable["topCnt"][i]["rank"])
		dataTable["topCnt"][i]["userPic"] = nMBaseMessage:readString()
		--Common.log("read80610038...userPic = " .. dataTable["topCnt"][i]["userPic"])
		dataTable["topCnt"][i]["vip"] = nMBaseMessage:readInt()
		--Common.log("read80610038...vip = " .. dataTable["topCnt"][i]["vip"])
		dataTable["topCnt"][i]["userName"] = nMBaseMessage:readString()
		--Common.log("read80610038...userName = " .. dataTable["topCnt"][i]["userName"])
		dataTable["topCnt"][i]["goodsNumber"] = nMBaseMessage:readInt()
		--Common.log("read80610038...goodsNumber = " .. dataTable["topCnt"][i]["goodsNumber"])
		nMBaseMessage:setReadPos(pos + length)
	end
	dataTable["NewUserRank"] = nMBaseMessage:readInt()
	return dataTable
end

-- [[大厅走马灯小游戏获奖信息]]--

function read80530014(nMBaseMessage)
	--ModuleList 模块table
	local dataTable = {};
	dataTable["messageType"] = ACK + MINI_COMMON_WINNING_RECORD;
	dataTable["messageName"] = "MINI_COMMON_WINNING_RECORD";
	dataTable["timestamp"] = nMBaseMessage:readLong()
	dataTable["nMultipleDetail"] = {}
	dataTable["nMultipleDetail"][1] = {}
	dataTable["nMultipleDetail"][1]["content"] = ""
	local count = nMBaseMessage:readInt();
	for i = 1, count do
		dataTable["nMultipleDetail"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …detail text 描述
		dataTable["nMultipleDetail"][i].content = nMBaseMessage:readString();
		-- …multiple Int 倍数
		dataTable["nMultipleDetail"][i].actionId = nMBaseMessage:readInt();
		dataTable["nMultipleDetail"][i].status = nMBaseMessage:readInt();
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end
function read80530015(nMBaseMessage)

	local dataTable = {};
	dataTable["messageType"] = ACK + MINI_COMMON_RECOMMEND;
	dataTable["messageName"] = "MINI_COMMON_RECOMMEND";
	-- …detail text 描述
	dataTable.content = nMBaseMessage:readString();
	dataTable.actionId = nMBaseMessage:readInt();
	return dataTable
end

--[[--
--小游戏引导(牌桌连胜和破产)
--]]--
function read80530016(nMBaseMessage)
	Common.log("read80530015==================")
	local dataTable = {};
	dataTable["messageType"] = ACK + MINI_COMMON_NEWGUIDE;
	dataTable["messageName"] = "MINI_COMMON_NEWGUIDE";
	-- …MiniGameId	Int	小游戏ID
	dataTable.actionId = nMBaseMessage:readInt();
	-- …GuideImageURL	Text	小游戏引导图片
	dataTable.GuideImageURL = nMBaseMessage:readString();
	return dataTable
end


--[[--
--3.16比赛详情
--]]--
function read80020035(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_MATCHDETAIL
	dataTable["messageName"] = "MATID_V4_MATCHDETAIL"

	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	--Common.log("zblaaa..TimeStamp = "..dataTable["TimeStamp"])
	dataTable["Vip"] = nMBaseMessage:readInt()
	--Common.log("zblaaa..Vip = "..dataTable["Vip"])
	dataTable["MatchDetail"] = nMBaseMessage:readString()
	--Common.log("zblaaa..MatchDetail = "..dataTable["MatchDetail"])
	--	dataTable["MatchAwards"] = nMBaseMessage:readString()
	--	--Common.log("zblaaa..MatchAwards = "..dataTable["MatchAwards"])
	dataTable["regButtonType"] = nMBaseMessage:readByte()
	--Common.log("zblaaa..regButtonType = "..dataTable["regButtonType"])
	dataTable["regButtonString"] = nMBaseMessage:readString()
	--Common.log("zblaaa..regButtonString = "..dataTable["regButtonString"])
	dataTable["Regindex"] = nMBaseMessage:readByte()
	--Common.log("zblaaa..Regindex = "..dataTable["Regindex"])
	dataTable["matchID"] = nMBaseMessage:readInt()
	--Common.log("zblaaa..read_matchID1 = "..dataTable["matchID"])
	return dataTable
end

--[[--
--3.16比赛奖励详情
--]]--
function read80020036(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MATID_V4_AWARDS
	dataTable["messageName"] = "MATID_V4_AWARDS"
	dataTable["TimeStamp"] = nMBaseMessage:readLong()
	--Common.log("zblaaa1..TimeStamp = "..dataTable["TimeStamp"])
	dataTable["MatchAwards"] = nMBaseMessage:readString()
	--Common.log("zblaaa..MatchAwards = "..dataTable["MatchAwards"])
	dataTable["matchID"] = nMBaseMessage:readInt()
	--Common.log("zblaaa..matchID = "..dataTable["matchID"])
	return dataTable
end
