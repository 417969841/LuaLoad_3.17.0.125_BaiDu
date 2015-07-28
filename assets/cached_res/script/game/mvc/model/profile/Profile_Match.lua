module(..., package.seeall)
--用于存储比赛列表
local MatchListTable = {}
--用于展示比赛列表
local showMatchListTable = nil

local regConditions = {}

MatchListTable["TimeStamp"] = 0
MatchListTable["MatchList"] = {}
MatchListTable["SendTimes"] = 0 --发送次数

MatchApplyConditionKeyTable = {}
MatchApplyConditionKeyTable["coin"] = "coin"
MatchApplyConditionKeyTable["yuanbao"] = "yuanbao"
MatchApplyConditionKeyTable["vipLevel"] = "vipLevel"
MatchApplyConditionKeyTable["ladderRank"] = "ladderRank"
MatchApplyConditionKeyTable["pieces"] = "pieces"
MatchApplyConditionKeyTable["djq"] = "djq"
MatchApplyConditionKeyTable["ticket"] = "ticket"

local curPlayedMatchID = nil; --当前进行的比赛ID

local goMatch = {}--请求进入比赛消息
local matchJs = {}--解析及时开赛
local matchRefund = {} --解析退赛
local matchSync = {}--比赛列表数据同步
local matchCondition  = {} --比赛报名条件同步
local MATID_V2_MATCH_LIST_REGCNTTable = {}--请求当前比赛已报名人数

local MATID_START_NOTIFYTable = {}--开赛通知
local MATID_ENTER_MATCHTable = {}--请求进入比赛
local isMatchListChange = false;

function getCurPlayedMatchID()
	return curPlayedMatchID
end

function setCurPlayedMatchID(mID)
	curPlayedMatchID = mID
end

function clearData()
	--用于存储比赛列表
	MatchListTable = {}
	--用于展示比赛列表
	showMatchListTable = nil
	regConditions = {}
	MatchListTable["TimeStamp"] = 0
	MatchListTable["MatchList"] = {}
	MatchListTable["SendTimes"] = 0 --发送次数

	goMatch = {}--请求进入比赛消息
	matchJs = {}--解析及时开赛
	matchRefund = {} --解析退赛
	matchSync = {}--比赛列表数据同步
	matchCondition  = {} --比赛报名条件同步
	MATID_V2_MATCH_LIST_REGCNTTable = {}--请求当前比赛已报名人数
	curPlayedMatchID = nil
end

local matchData = {
	-- …MatchID int 比赛ID
	MatchID,
	-- …MatchTitle text 比赛标题
	MatchTitle,
	-- …MatchType Byte 比赛类型 0区间赛 1即时赛 2 定点赛（周赛）4 定局赛（3人、6人赛）6 月赛 7 闯关赛
	mnMatchType,
	-- …TitlePictureUrl Text 标题图片路径
	TitlePicUrl,
	-- …TagPicUrl Text 推荐类型url 6- 普通赛7- 推荐赛
	TagPicUrl,
	-- 奖品图片（比赛列表用）
	PrizeImgUrl,
	-- …MatchLevel byte 级别 0新手场1中级场2高级场
	MatchLevel,
	-- …MatchStatus byte 赛制状态 0无效 1 有效
	MatchStatus,
	-- …DeleteFlag Byte 删除标志 0否 1 是
	DeleteFlag,
	-- …RegUserCnt short 已报名人数
	RegUserCnt,--10
	PlayerCnt,
	-- ...RegType Byte 1 报名 2 激战
	PlayerCntTitle = "",
	-- …MinReg short 最小报名人数 随时开赛的比赛有效
	MinReg,
	-- …MaxReg short 最大报名人数 随时开赛的比赛有效
	MaxReg,
	-- …StartTime text 开赛时间 定点开赛的比赛有效
	StartTime,

	StartTime_long,
	-- …RegType Byte 是否报名本场比赛 0 报名 1 退赛 2下一关 3 复活
	mnRegType,
	-- 0：未报名，1：（已报名）退赛/继续
	RegStatus,
	-- …Condition Text 报名条件
	Condition,
	-- 最高奖品描述（报名界面用）
	MaxLevelPrize,--20
	-- …MaxLevelPrizePriceUrl Text 最高奖品图片url
	MaxLevelPrizePriceUrl,
	-- ...Orderby Byte 排序
	Orderby,
	IsCollect,
	MatchRule,
	-- ...Honor Short 赠送荣誉值
	Honor,
	-- ...RegCoin Short 报名金币数
	RegCoin,
	-- ...RegRongyuzhi Short 报名荣誉值数
	RegRongyuzhi,
	-- 是否用门票报名 0 否 1 是
	NeedTicket,
	-- ...MinVipLevel Int 需要的VIP最小等级
	MinVipLevel,
	-- 是否有门票 1有 0没有
	hasTicket,
}

-----------------------------------------------比赛列表---------------

--[[--
--获取比赛列表
--]]
function getMatchList()
	return MatchListTable
end

--[[--
--加载本地房间列表数据
--]]--
function loadMatchListTable()
	MatchListTable = Common.LoadTable(profile.User.getSelfUserID().."LordMatchList")
	if MatchListTable == nil then
		MatchListTable = {}
		MatchListTable["TimeStamp"] = 0
		MatchListTable["SendTimes"] = 0
		MatchListTable["MatchList"] = {}
	end
end

local function loadShowMatchListTable()
	showMatchListTable = Common.LoadTable(profile.User.getSelfUserID().."LordMatchList")
	if showMatchListTable == nil then
		showMatchListTable = {}
		showMatchListTable["TimeStamp"] = 0
		showMatchListTable["SendTimes"] = 0
		showMatchListTable["MatchList"] = {}
	end
end

function loadRegConditions()
	regConditions = Common.LoadTable(profile.User.getSelfUserID().."LordRegConditions")
	if regConditions == nil then
		regConditions = {}
	end
end

--[[时间戳]]
function getTimestamp()
	local value = MatchListTable["TimeStamp"]
	if value == nil then
		return 0
	else
		return value
	end
end

function setTimestamp(value)
	MatchListTable["TimeStamp"] = value
end

--[[发送次数]]
function getSendTimes()
	local value = MatchListTable["SendTimes"]
	if value == nil then
		return 0
	else
		return value
	end
end

function setSendTimes(value)
	MatchListTable["SendTimes"] = value
end

--[[
3.03 比赛列表
]]
function setMatchTable_V4(dataTable)
	--只要时间戳不一样，就更新本地list
	if MatchListTable["TimeStamp"] ~= dataTable["TimeStamp"] then
		--时间戳不一样
		Common.log("重新加载比赛列表，时间戳不一样")
		for i = 1, #dataTable["MatchList"] do
			MatchListTable["MatchList"][i] = {}
			MatchListTable["MatchList"][i].MatchID = dataTable["MatchList"][i].MatchID
			MatchListTable["MatchList"][i].MatchTitle = dataTable["MatchList"][i].MatchTitle
			MatchListTable["MatchList"][i].MatchType = dataTable["MatchList"][i].MatchType
			MatchListTable["MatchList"][i].MatchTag = dataTable["MatchList"][i].MatchTag
			MatchListTable["MatchList"][i].TitlePictureUrl = dataTable["MatchList"][i].TitlePictureUrl
			MatchListTable["MatchList"][i].TableType = dataTable["MatchList"][i].TableType
			MatchListTable["MatchList"][i].StartTime = dataTable["MatchList"][i].StartTime
			MatchListTable["MatchList"][i].ConditionText = dataTable["MatchList"][i].ConditionText
			MatchListTable["MatchList"][i].Orderby = dataTable["MatchList"][i].Orderby
			MatchListTable["MatchList"][i].RegType = dataTable["MatchList"][i].RegType

			MatchListTable["MatchList"][i].Condition = {}
			local strConditionWithoutLeftBracket = string.gsub(dataTable["MatchList"][i].Condition, "{", "")
			local strConditionWithoutRightBracket = string.gsub(strConditionWithoutLeftBracket, "}", "")
			-- split condition with ||
			local conditionsWithOr = LordGamePub.split(strConditionWithoutRightBracket, "||")
			for j = 1, #conditionsWithOr do
				MatchListTable["MatchList"][i].Condition[j] = {}
				-- split condition with &&
				local conditionsWithAnd = LordGamePub.split(conditionsWithOr[j], "&&")
				MatchListTable["MatchList"][i].Condition[j] = conditionsWithAnd;
			end

			MatchListTable["MatchList"][i].PrizeImgUrl = dataTable["MatchList"][i].PrizeImgUrl
			MatchListTable["MatchList"][i].PrizeDesc = dataTable["MatchList"][i].PrizeDesc
			MatchListTable["MatchList"][i].freezeCoin = dataTable["MatchList"][i].freezeCoin
			MatchListTable["MatchList"][i].specialLabelURL = dataTable["MatchList"][i].specialLabelURL
			MatchListTable["MatchList"][i].TicketName = dataTable["MatchList"][i].TicketName
			MatchListTable["MatchList"][i].TicketCount = dataTable["MatchList"][i].TicketCnt
			
			MatchListTable["MatchList"][i].RegStatus = 0
			MatchListTable["MatchList"][i].playerCnt = 0
			MatchListTable["MatchList"][i].MatchStartTime = 0
		end
		if MatchListTable ~= nil then
			Common.SaveTable(profile.User.getSelfUserID().."LordMatchList", MatchListTable)
		end
	end

	framework.emit(MATID_V4_MATCH_LIST)
end

function getMatchTable()
	if showMatchListTable == nil or isMatchListChange then
		loadShowMatchListTable()
	end

	return MatchListTable["MatchList"]
end

------------------比赛其他相关--------------
--报名比赛之后要存比赛实例
function setMatchInstanceID(MatchID,MatchInstanceID)
	for j=1,#MatchListTable["MatchList"] do
		if MatchListTable["MatchList"][j].MatchID == MatchID then
			MatchListTable["MatchList"][j].matchInstanceID = MatchInstanceID
			break;
		end
	end
	if MatchListTable ~= nil then
		Common.SaveTable(profile.User.getSelfUserID().."LordMatchList", MatchListTable)
	end
end

function getMATID_START_NOTIFYTable()
	return MATID_START_NOTIFYTable
end

--[[
3.03 开赛通知比赛消息
]]
function readMATID_V4_START_NOTIFY(dataTable)
	Common.log("readMATID_V4_START_NOTIFY")

	MATID_START_NOTIFYTable = dataTable
	framework.emit(MATID_V4_START_NOTIFY)
end

--请求进入比赛
function getMATID_ENTER_MATCHTable()
	return MATID_ENTER_MATCHTable
end

--[[
3.03 请求进入比赛
]]
function readMATID_V4_ENTER_MATCH(dataTable)
	MATID_ENTER_MATCHTable = dataTable
	framework.emit(MATID_V4_ENTER_MATCH)
end

function getMatchStartTime(matchID)
	local time = 30*60*1000
	for i=1,#MatchListTable["MatchList"] do
		if MatchListTable["MatchList"][i].MatchID == matchID then
			time =  MatchListTable["MatchList"][i].MatchStartTime
			break
		end
	end
	return time
end

--[[
3.03 报名人数同步V4
]]
function setMatchRegcnt_V4(dataTable)
	MATID_V2_MATCH_LIST_REGCNTTable = dataTable
	framework.emit(MATID_V4_REGCNT)
end

function getMATID_V2_MATCH_LIST_REGCNTTable()
	return MATID_V2_MATCH_LIST_REGCNTTable
end

function getGoMatch()
	return goMatch
end

--解析及时开赛
function setJsMatch(dataTable)
	matchJs = dataTable
	framework.emit(MATID_REG_MATCH)
end

function getJsMatch()
	return matchJs
end

--[[
3.03解析退赛
]]
function setMatchRefund_V4(dataTable)
	matchRefund = dataTable
	framework.emit(MATID_V4_REFUND)
end

function RefundMatch()
	return matchRefund
end

--[[
3.03 设置比赛同步
]]
function setMatchListSync_V4(dataTable)
	Common.log("setMatchListSync_V4")
	isMatchListChange = false;
	for i=1, #dataTable["MatchList"] do
		for j=1, #MatchListTable["MatchList"] do
			if dataTable["MatchList"][i].MatchID == MatchListTable["MatchList"][j].MatchID then
				if MatchListTable["MatchList"][j].MatchStatus ~= dataTable["MatchList"][i].MatchStatus then
					MatchListTable["MatchList"][j].MatchStatus = dataTable["MatchList"][i].MatchStatus
					isMatchListChange = true;
				end
				MatchListTable["MatchList"][j].TicketCount = dataTable["MatchList"][i].TicketCount
				MatchListTable["MatchList"][j].MatchStartTime = dataTable["MatchList"][i].MatchStartTime
				MatchListTable["MatchList"][j].RegStatus = dataTable["MatchList"][i].RegStatus
				MatchListTable["MatchList"][j].playerCnt = dataTable["MatchList"][i].playerCnt
				MatchListTable["MatchList"][j].matchStartTimeTag = dataTable["MatchList"][i].matchStartTimeTag
			end
		end
	end

	--setShowMatchListSync_V4()
	if MatchListTable ~= nil then
		Common.SaveTable(profile.User.getSelfUserID().."LordMatchList", MatchListTable)
	end

	framework.emit(MATID_V4_MATCH_SYNC)
end

--同步showlist
function setShowMatchListSync()
	if showMatchListTable == nil then
		return
	end
	for i=1,#showMatchListTable["MatchList"] do
		for j=1,#MatchListTable["MatchList"] do
			if showMatchListTable["MatchList"][i].MatchID == MatchListTable["MatchList"][j].MatchID then
				showMatchListTable["MatchList"][i].RegStatus = MatchListTable["MatchList"][j].RegStatus
				showMatchListTable["MatchList"][i].RegType =  MatchListTable["MatchList"][j].RegType
				showMatchListTable["MatchList"][i].PlayerCnt = MatchListTable["MatchList"][j].PlayerCnt
				showMatchListTable["MatchList"][i].StartTime = MatchListTable["MatchList"][j].StartTime
				showMatchListTable["MatchList"][i].StartTime_long =  MatchListTable["MatchList"][j].StartTime_long
			end
		end
	end
end

--[[
3.03 同步showlist
]]
function setShowMatchListSync_V4()
	for i=1,#showMatchListTable["MatchList"] do
		for j=1,#MatchListTable["MatchList"] do
			if showMatchListTable["MatchList"][i].MatchID == MatchListTable["MatchList"][j].MatchID then
				showMatchListTable["MatchList"][i].playerCnt = MatchListTable["MatchList"][j].playerCnt
			end
		end
	end
end

--返回比赛是否改变
function getMatchListChange()
	return isMatchListChange
end

function getMatchSync()
	return matchSync
end

function getMatchCondition()

end

--[[
判断用户能否报名一个比赛
]]
function canApplyMatch(matchItem)
	local tConditions = matchItem.Condition
	Common.log("#tConditions = "..#tConditions)
	for i = 1, #tConditions do
		local tSubConditions = tConditions[i]

		Common.log("#tSubConditions = "..#tSubConditions)
		for j = 1, #tSubConditions do
			local expression = tSubConditions[j]
			-- find >=
			Common.log("expression = "..expression)
			local dayudengyuPos = string.find(expression, ">=")

			if tonumber(dayudengyuPos) > 0 then
				-- split >=
				local tDayudengyu = LordGamePub.split(expression, ">=")
				local name = tDayudengyu[1]
				local value = tDayudengyu[2]
				local uValue = getUserValueWithName(name)
				if name == "coin" then
					-- 如果是金币，需要加上押金金币，来做比较
					value = tonumber(value) + tonumber(matchItem.freezeCoin)
				end

				if name == "ticket" then
					uValue = getTicketWithMatchItem(matchItem)
				end

				Common.log("j = "..j.." name = ".. name)
				
				-- compare uValue to value with >=
				Common.log("value = ".. value)
				Common.log("uValue = ".. uValue)

				if tonumber(uValue) >= tonumber(value) then
					matchItem.Condition[i].enable = true
				else
					matchItem.Condition[i].enable = false

					-- &&里面只要有一个条件不满足，则不满足，故直接break
					break
				end
			end
		end
	end

	local canBmConditionCnt = getMatchApplyConditionCnt(matchItem.Condition)
	Common.log("Condition cnt = "..canBmConditionCnt)
	if canBmConditionCnt > 0 then
		return true
	end

	return false
end

--[[
返回一个比赛满足报名条件的数量
tCondition:报名条件数组
]]
function getMatchApplyConditionCnt(tCondition)
	local cnt = 0
	for i = 1, #tCondition do
		if tCondition[i].enable ==true then
			cnt = cnt+1
		end
	end

	return cnt
end

--[[
根据字符切出一个表达式的key
sExpression:表达式
cChar:分割符
]]
function getKeyWithExpression(sExpression, cChar)
	return LordGamePub.split(sExpression, cChar)[1]
end

--[[
根据字符切出一个表达式的value
sExpression:表达式
cChar:分割符
]]
function getValueWithExpression(sExpression, cChar)
	return LordGamePub.split(sExpression, cChar)[2]
end

--[[
根据字符切出一个表达式的value
sExpression:表达式
cChar:分割符
index:要取出的值的下标
]]
function getValueWithExpression2(sExpression, cChar, index)
	return LordGamePub.split(sExpression, cChar)[index]
end

--[[
返回用户name对应的value
]]
function getUserValueWithName(kName)
	if kName == MatchApplyConditionKeyTable["coin"] then
		Common.log("myself coin = "..profile.User.getSelfCoin())
		return profile.User.getSelfCoin()
	elseif kName == MatchApplyConditionKeyTable["vipLevel"] then
		local vipLevel = profile.User.getSelfVipLevel()--vip级别
		return VIPPub.getUserVipType(vipLevel) --vip level: 1 or 2 or 3...
	elseif kName == MatchApplyConditionKeyTable["ladderRank"] then
		--[[
		天梯等级的计算公式：一共3位数
		百位数-代表段位
		后两位-代表级
		如：
		206—2段6级
		312—3段12级
		]]
		local duan = profile.User.getSelfLadderDuan()
		--local rank = profile.User.getSelfLadderRanking()
		local rank = profile.User.getSelfLadderLevel()
		Common.log("duan = "..duan)
		Common.log("rank = "..rank)
		local ladderRank3bit = ""
		if tonumber(rank) >= 10 then
			-- 得到一个3位数的天梯等级
			ladderRank3bit = ""..duan..rank
		else
			ladderRank3bit = ""..duan.."0"..rank
		end
		return ladderRank3bit
	elseif kName == MatchApplyConditionKeyTable["ticket"] then
	elseif kName == MatchApplyConditionKeyTable["yuanbao"] then
		return profile.User.getSelfYuanBao()
	elseif kName == MatchApplyConditionKeyTable["djq"] then
		return profile.User.getDuiJiangQuan()
	elseif kName == MatchApplyConditionKeyTable["pieces"] then
		return profile.User.getSelfdjqPieces()
	end
end

--[[
根据比赛实例获取拥有的门票数量
]]
function getTicketWithMatchItem(matchItem)
	return matchItem.TicketCount
end

--[[
3.03 设置比赛报名
]]
function setMatchReg_V4(dataTable)
	goMatch = dataTable
	framework.emit(MATID_V4_REG_MATCH)
end

--[[
准备报名一个比赛
]]
function prepareBaomingMatch(matchItem)
	Common.log("matchItem.MatchID = "..matchItem.MatchID)
	--[[是否有5分钟内开始的比赛,弹toast提示
	local timecha = math.modf(getMatchStartTime(matchItem.MatchID) / 1000)
	Common.log("timecha = "..timecha)
	local ismag = MatchList.isTimeDistanceTooSmall_V4(timecha, 5*60)
	if(ismag)then
	Common.showToast("您有一场比赛5分钟内开始的比赛，请做好准备", 2);
	return
	end
	]]

	-- 是否有30分钟内开始的比赛,弹框提示
	--[[
	local timecha1 = math.modf(getMatchStartTime(matchItem.MatchID) / 1000)
	Common.log("timecha1 = "..timecha1)
	local ismag1 = MatchList.isTimeDistanceTooSmall_V4(timecha1, 30*60)
	if(ismag1)then
	TimeNotFitLogic.noticeMsg = "该比赛与您已报名的" .."\"" .. ismag1 .. "\"" .. "马上开始时间间隔较近(小于30分钟),确认参赛吗？"
	mvcEngine.createModule(GUI_TIMENOTFIT)
	return
	end
	]]

	local cnt = getMatchApplyConditionCnt(matchItem.Condition) -- 报名条件的数量
	Common.log("prepareBaomingMatch cnt = "..cnt)
	return cnt
end

--[[
报名一个比赛
]]
function didBaomingMatch(matchItem, regTypeIndex, IgnoreRegedOtherMatch)
	Common.showProgressDialog("正在报名，请稍后...")
	Common.log("matchItem.MatchID = "..matchItem.MatchID)
	sendMATID_V4_REG_MATCH(GameConfig.GAME_ID, matchItem.MatchID, regTypeIndex, IgnoreRegedOtherMatch)
end

-- 解析完服务器返回数据后的回调
registerMessage(MATID_V4_MATCH_LIST, setMatchTable_V4) --比赛列表V4
registerMessage(MATID_V4_MATCH_SYNC, setMatchListSync_V4) --比赛动态信息同步V4
registerMessage(MATID_V4_REG_MATCH,  setMatchReg_V4) --比赛报名V4
registerMessage(MATID_V4_REFUND, setMatchRefund_V4) --退票V4
registerMessage(MATID_V4_REGCNT, setMatchRegcnt_V4) --即时开赛报名人数同步V4
registerMessage(MATID_V4_START_NOTIFY, readMATID_V4_START_NOTIFY) -- 开赛通知V4
registerMessage(MATID_V4_ENTER_MATCH, readMATID_V4_ENTER_MATCH) -- 进入比赛V4