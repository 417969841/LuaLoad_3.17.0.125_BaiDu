module(..., package.seeall)
--
--处理牌桌数据
--
local QuickStart = {}--快速开始数据
local EnterRoom = {}--进入房间数据
local QuitRoom = {}--退出房间数据
local ReadyData = {}--准备数据
local InitCardData = {}--发牌数据
local CallScore = {}--叫分数据
local ReserveCard = {}--底牌数据
local TakeOutCard = {}--出牌数据
local TrustPlay = {}--托管数据
local GrabLandlord = {}--抢地主数据
local DoubleScore = {}--加倍数据
local OpenCards = {}--明牌数据
local StartDouble = {}--开始加倍数据
local TableChanged = {}--牌桌改变数据
local GameResultData = {}--牌局结果数据
local TableSync = {}--牌桌同步数据
local StatusChanged = {}--比赛阶段改变数据
local TableNotEnded = {}--当前未结束的牌桌数
local MatchResult = {}--比赛结果数据
local MatchRankSync = {}--比赛排名同步数据
local MatchCertificate = {}--比赛奖状数据
local MatchChargeWaiting = {}--比赛充值等待区数据
local chatMsg = {}--牌桌聊天
local giveUp = {}--认输
local syncHandCards = {}--同步手牌
local matchAllUserList = {}--比赛用户列表
local tableMatchTips = {} -- 存储小提示table
local tableGoodsCount = {} --商品数量数据

local matchDetails = {}  --比赛详情
local matchAwardsDetails = {} --比赛奖励详情

local isGameSync = false;--是否已经断线续玩

--[[
获取存储商品数量table
]]
function getGoodsCountTable()
	return tableGoodsCount
end

--[[
获取存储小提示table
]]
function getMatchTipsTable()
	return tableMatchTips
end

function getMatchRankSync()
	return MatchRankSync
end

--[[
返回比赛充值等待区结果
]]
function getMatchChargeWaiting()
	return MatchChargeWaiting
end

--[[
返回比赛奖状结果
]]
function getMatchCertificate()
	return MatchCertificate
end

--[[--
--获取是否已经断线续玩
--]]
function getIsGameSync()
	return isGameSync;
end
--[[--
--设置是否已经断线续玩
--]]
function setIsGameSync(isSync)
	isGameSync = isSync;
end

--[[--
--获取快速开始数据
--]]
function getQuickStartData()
	return QuickStart
end

--[[--
--获取进入房间数据
--]]
function getEnterRoomData()
	return EnterRoom
end

--[[--
--获取退出房间数据
--]]
function getQuitRoomData()
	return QuitRoom
end

--[[--
--获取准备数据
--]]
function getReadyData()
	return ReadyData
end

--[[--
--获取发牌数据
--]]
function getInitCardData()
	return InitCardData
end

--[[--
--获取叫分数据
--]]
function getCallScoreData()
	return CallScore
end

--[[--
--获取底牌数据
--]]
function getReserveCardData()
	return ReserveCard
end

--[[--
--获取出牌数据
--]]
function getTakeOutCardData()
	return TakeOutCard
end

--[[--
--获取托管数据
--]]
function getTrustPlayData()
	return TrustPlay
end

--[[--
--获取抢地主数据
--]]
function getGrabLandlordData()
	return GrabLandlord
end

--[[--
--获取加倍数据
--]]
function getDoubleScoreData()
	return DoubleScore
end

--[[--
--获取明牌数据
--]]
function getOpenCardsData()
	return OpenCards
end

--[[--
--获取开始加倍数据
--]]
function getStartDoubleData()
	return StartDouble
end

--[[--
--获取牌桌改变数据
--]]
function getTableChangedData()
	return TableChanged
end

--[[--
--获取牌局结果数据
--]]
function getGameResultData()
	return GameResultData
end

--[[--
--获取牌桌同步数据
--]]
function getTableSyncData()
	return TableSync
end

--[[--
--获取比赛阶段改变数据
--]]
function getStatusChanged()
	return StatusChanged
end

--[[--
--获取当前未结束的牌桌数
--]]
function getTableNotEnded()
	return TableNotEnded
end

--[[--
--获取比赛结果
--]]
function getMatchResult()
	return MatchResult
end

--[[--
--获取退赛数据
--]]
function getGiveUpData()
	return giveUp
end

--[[--
--获取退赛数据
--]]
function getSyncHandCards()
	return syncHandCards
end

--[[--
--获取比赛用户列表
--]]
function getMatchAllUserList()
	return matchAllUserList
end

function getLORDID_CHAT_MSG()
	return chatMsg
end

--[[--
-- 获取断线重连后是否是在闯关赛中
--]]--
function getIsInCrazyStage()
	if TableSync == nil then
		return false
	end

	local m_nUserCnt = #TableSync["PlayerList"]
	local userID = profile.User.getSelfUserID()
	for i = 1, m_nUserCnt do
		local m_nUserID = TableSync["PlayerList"][i].UserID
		local m_nIsInCrazy = TableSync["PlayerList"][i].isInCrazy
		Common.log("m_nUserID is " .. m_nUserCnt .. ";userID is " .. userID)
		if m_nUserID == userID and m_nIsInCrazy == 1 then
			Common.log("isInCrazy is true userID is " .. m_nUserCnt)
			return true
		end
	end

	return false
end

--[[--
-- 3.03 比赛排名同步V4
--]]
function readMatchRank_Sync_V4(dataTable)
	--[[比赛结果假数据
	dataTable = {}
	dataTable.matchInstance = "75001351"
	dataTable.Rank = 1
	dataTable.Socre = 1
	dataTable.Coin = 1
	dataTable.playerCount = 1
	]]

	MatchRankSync = dataTable
	framework.emit(MATID_V4_PROMPT_SYNC)
end

--[[--
--接收当前未结束的牌桌数
--
function readTableNotEnded(dataTable)
TableNotEnded = dataTable
framework.emit(MATID_TABLE_NOTENDED)
end
]]

--[[--
--3.03接收当前未结束的牌桌数(比赛等待分桌V4)
--]]
function readTableNotEnded_V4(dataTable)
	TableNotEnded = dataTable
	framework.emit(MATID_V4_WAITING)
end

--[[--
--比赛阶段改变
--
function readStatusChanged(dataTable)
StatusChanged = dataTable
framework.emit(MATID_STATUS_CHANGED)
end
]]

--[[--
--接收快速开始数据
--]]
function readROOMID_QUICK_START(dataTable)
	Common.log("接收快速开始消息-----------------")
	QuickStart = dataTable
	framework.emit(ROOMID_QUICK_START)
end

--[[--
--接收进入房间数据
--]]
function readROOMID_ENTER_ROOM(dataTable)
	Common.log("接收进入房间消息-----------------")
	EnterRoom = dataTable
	framework.emit(ROOMID_ENTER_ROOM)
end

--[[--
--接收退出房间数据
--]]
function readROOMID_QUIT_ROOM(dataTable)
	Common.log("接收退出房间消息-----------------")
	QuitRoom = dataTable
	framework.emit(ROOMID_QUIT_ROOM)
end
--[[--
--接收准备消息0x110001
--]]
function readDDZID_READY(dataTable)
	Common.log("接收准备消息-----------------")
	ReadyData = dataTable
	framework.emit(DDZID_READY)
end

--[[--
--接收发牌消息0x110002
--]]
function readDDZID_INITCARD(dataTable)
	Common.log("接收发牌消息-----------------")
	InitCardData = dataTable
	framework.emit(DDZID_INITCARD)
end

--[[--
--接收叫分消息0x110003
--]]
function readDDZID_CALLSCORE(dataTable)
	Common.log("接收叫分消息-----------------")
	CallScore = dataTable
	framework.emit(DDZID_CALLSCORE)
end

--[[--
--接收发底牌消息0x110004
--]]
function readDDZID_SENDRESERVECARD(dataTable)
	Common.log("接收发底牌消息-----------------")
	ReserveCard = dataTable
	framework.emit(DDZID_SENDRESERVECARD)
end

--[[--
--接收出牌消息0x110005
--]]
function readDDZID_TAKEOUTCARD(dataTable)
	Common.log("接收出牌消息-----------------")
	TakeOutCard = dataTable
	framework.emit(DDZID_TAKEOUTCARD)
end

--[[--
--接收托管和解除托管(LORDID_TRUST_PLAY)0x110007
--]]
function readMATID_TRUST_PLAY(dataTable)
	Common.log("接收出牌消息-----------------")
	TrustPlay = dataTable
	framework.emit(MATID_TRUST_PLAY)
end

--[[--
--接收抢地主(LORDID_GRAB_LANDLORD)0x110009
--]]
function readLORDID_GRAB_LANDLORD(dataTable)
	Common.log("接收抢地主消息-----------------")
	GrabLandlord = dataTable
	framework.emit(LORDID_GRAB_LANDLORD)
end

--[[--
--接收加倍(LORDID_DOUBLE_SCORE)0x11000a
--]]
function readLORDID_DOUBLE_SCORE(dataTable)
	Common.log("接收加倍消息-----------------")
	DoubleScore = dataTable
	framework.emit(LORDID_DOUBLE_SCORE)
end

--[[--
--接收明牌(LORDID_OPEN_CARDS)0x11000b
--]]
function readLORDID_OPEN_CARDS(dataTable)
	Common.log("接收明牌消息-----------------")
	OpenCards = dataTable
	framework.emit(LORDID_OPEN_CARDS)
end

--[[--
--接收开始加倍(LORDID_START_DOUBLE)0x11000c
--]]
function readLORDID_START_DOUBLE(dataTable)
	Common.log("接收开始加倍消息-----------------")
	StartDouble = dataTable
	framework.emit(LORDID_START_DOUBLE)
end

--[[--
--接收牌桌改变
--]]
function readGAMEID_TABLE_CHANGED(dataTable)
	Common.log("接收牌桌改变消息-----------------")

	TableChanged = dataTable
	framework.emit(GAMEID_TABLE_CHANGED)
end

--[[--
--接收游戏结果
--]]
function readGAMEID_GAMERESULT(dataTable)
	Common.log("接收游戏结果消息-----------------")
	GameResultData = dataTable
	framework.emit(GAMEID_GAMERESULT)
end

--[[--
--接收断线续玩桌子同步
--]]
function readGAMEID_TABLE_SYNC(dataTable)
	Common.log("接收断线续玩桌子同步消息-----------------")
	TableSync = dataTable;
	setIsGameSync(true);
	framework.emit(GAMEID_TABLE_SYNC);
end

--聊天应答
function readLORDID_CHAT_MSG(dataTable)
	Common.log("readLORDID_CHAT_MSG")
	chatMsg = dataTable
	framework.emit(LORDID_CHAT_MSG)
end

--[[--
--认输
--]]
function readLORDID_GIVE_UP(dataTable)
	giveUp = dataTable
	framework.emit(LORDID_GIVE_UP)
end

--[[--
--同步自己的手牌
--]]
function readLORDID_SYNC_HAND_CARDS(dataTable)
	syncHandCards = dataTable
	framework.emit(LORDID_SYNC_HAND_CARDS)
end

--[[--
--获取比赛用户列表
--
function readMATID_V28_ALL_USER_LIST(dataTable)
matchAllUserList = dataTable
framework.emit(MATID_V28_ALL_USER_LIST)
end
]]

--[[--
--3.03获取比赛用户列表(比赛排名V4)
--]]
function readMATID_V4_ALL_USER_LIST(dataTable)
	matchAllUserList = dataTable
	framework.emit(MATID_V4_RANK)
end

function readMATID_V4_CERTIFICATE_V4(dataTable)
	MatchCertificate = dataTable
	framework.emit(MATID_V4_CERTIFICATE)
end

--[[
set充值等待区数据
]]
function setMATID_V4_RechargeWaiting_V4(dataTable)
	MatchChargeWaiting = dataTable
	framework.emit(MATID_V4_RECHARGE_WAITING)
end

--[[
set充值等待区数据
]]
function setMATID_V4_TIPS(dataTable)
	tableMatchTips = dataTable
	framework.emit(MATID_V4_TIPS)
end

function setMSG_IDLE(dataTable)
	framework.emit(MSG_IDLE)
end

function setDBID_BACKPACK_GOODS_COUNT(dataTable)
	tableGoodsCount = dataTable
	framework.emit(DBID_BACKPACK_GOODS_COUNT)
end


--[[--
--比赛详情
--]]--
function loadmatchDetailsTable(vip,id)
	matchDetails = Common.LoadTable("matchDetails".. vip .. id)
	if matchDetails == nil or matchAwardsDetails == "" then
		matchDetails = {}
		matchDetails["TimeStamp"] = 0
	end
	return matchDetails["TimeStamp"]
end
--loadmatchDetailsTable()

function readMATID_V4_MATCHDETAIL(dataTable)
	if matchDetails["TimeStamp"] ~= dataTable["TimeStamp"] then
		matchDetails = dataTable
		Common.SaveTable("matchDetails" .. dataTable["Vip"] .. dataTable["matchID"], matchDetails)
	end
	framework.emit(MATID_V4_MATCHDETAIL)
end
function getMATID_V4_MATCHDETAIL()
	return matchDetails
end
function getmatchDetailsTimeStamp()
	return matchDetails["TimeStamp"]
end


--[[--
--比赛奖励详情
--]]--
function loadmatchAwardsDetailsTable(id)
	matchAwardsDetails = Common.LoadTable("matchAwardsDetails" .. id)
	if matchAwardsDetails == nil or matchAwardsDetails == "" then
		matchAwardsDetails = {}
		matchAwardsDetails["TimeStamp"] = 0
	end
	return matchAwardsDetails["TimeStamp"]
end
--loadmatchAwardsDetailsTable()

function readMATID_V4_AWARDS(dataTable)
	if matchAwardsDetails["TimeStamp"] ~= dataTable["TimeStamp"] then
		matchAwardsDetails = dataTable
		Common.SaveTable("matchAwardsDetails" .. dataTable["matchID"], matchAwardsDetails)
	end
	framework.emit(MATID_V4_AWARDS)
end
function getreadMATID_V4_AWARDS()
	return matchAwardsDetails
end
function getAwardsDetailsTimeStamp()
	return matchAwardsDetails["TimeStamp"]
end


registerMessage(ROOMID_QUICK_START, readROOMID_QUICK_START)
registerMessage(ROOMID_ENTER_ROOM, readROOMID_ENTER_ROOM)
registerMessage(ROOMID_QUIT_ROOM, readROOMID_QUIT_ROOM)
registerMessage(DDZID_READY, readDDZID_READY)
registerMessage(DDZID_INITCARD, readDDZID_INITCARD)
registerMessage(DDZID_CALLSCORE, readDDZID_CALLSCORE)
registerMessage(DDZID_SENDRESERVECARD, readDDZID_SENDRESERVECARD)
registerMessage(DDZID_TAKEOUTCARD, readDDZID_TAKEOUTCARD)
registerMessage(MATID_TRUST_PLAY, readMATID_TRUST_PLAY)
registerMessage(LORDID_GRAB_LANDLORD, readLORDID_GRAB_LANDLORD)
registerMessage(LORDID_DOUBLE_SCORE, readLORDID_DOUBLE_SCORE)
registerMessage(LORDID_OPEN_CARDS, readLORDID_OPEN_CARDS)
registerMessage(LORDID_START_DOUBLE, readLORDID_START_DOUBLE)
registerMessage(GAMEID_TABLE_CHANGED, readGAMEID_TABLE_CHANGED)
registerMessage(GAMEID_GAMERESULT, readGAMEID_GAMERESULT)
registerMessage(GAMEID_TABLE_SYNC, readGAMEID_TABLE_SYNC)
registerMessage(LORDID_SYNC_HAND_CARDS, readLORDID_SYNC_HAND_CARDS)
registerMessage(LORDID_CHAT_MSG, readLORDID_CHAT_MSG)
registerMessage(LORDID_GIVE_UP, readLORDID_GIVE_UP)

--3.03牌桌新消息协议
registerMessage(MATID_V4_WAITING, readTableNotEnded_V4) -- 比赛等待分桌V4
registerMessage(MATID_V4_PROMPT_SYNC, readMatchRank_Sync_V4) -- 比赛排名同步V4
registerMessage(MATID_V4_RANK, readMATID_V4_ALL_USER_LIST) -- 比赛排名V4
registerMessage(MATID_V4_CERTIFICATE, readMATID_V4_CERTIFICATE_V4) -- 比赛奖状V4
registerMessage(MATID_V4_RECHARGE_WAITING, setMATID_V4_RechargeWaiting_V4) -- 比赛进入充值等待区V4
registerMessage(MATID_V4_TIPS, setMATID_V4_TIPS) -- 比赛小提示V4
registerMessage(MSG_IDLE, setMSG_IDLE) -- 心跳消息
registerMessage(DBID_BACKPACK_GOODS_COUNT, setDBID_BACKPACK_GOODS_COUNT)

--3.16比赛详情
registerMessage(MATID_V4_MATCHDETAIL, readMATID_V4_MATCHDETAIL)
registerMessage(MATID_V4_AWARDS, readMATID_V4_AWARDS)