module("CommShareConfig", package.seeall)

--webview预加载
local ROOMSTREAKLIM = 5 --牌桌连胜分享最低次数限制
local ROOMMULTIPLELIM = 500 --牌桌最高倍分享最低倍数限制
local MATCHLEVELLIM = 3 --比赛名次分享最低名次限制
local CRAZYLEVELLIM = 10 --疯狂闯关分享最低关卡限制
local COINRANKINGSHARE = "COINRANKINGSHARE" --本地数据KEY，用于限制每天一次自动弹出自动分享
local isCoinRankingShared = 1 --今日已经自动分享赚金榜
isCrazyShareEnabled = false --默认闯关不可分享

MINIGAMESTREAK = 1 --小游戏连胜
MINIGAMEPRIZE = 2 --小游戏中特等奖和一等奖
PACKTABLESTREAK = 3 --牌桌连胜
PACKTABLEMULTIPLE = 4 --牌桌最高倍
EXCHANGEENTITY = 5 --兑奖券兑换实物
COINRANKING = 6 --赚金排行榜Top100
MATCHENTITY = 7 --比赛获得实物
MATCHRANKING = 8 --比赛获得前三名
CRAZYLEVEL = 9 --疯狂闯关分享
SWITCH_SHARE_TYPE = nil;--分享类型 1:主动分享 2:被动分享
SHARE_TYPE_INITIATIVE = 1;--主动
SHARE_TYPE_PASSIVE = 2;--被动
SHARE_TYPE_REDGIFT = 3;--红包

--分享图片URL
local MINIGAMEURL = "http://f.99sai.com/game-share-v2/minigame.png" --小游戏分享
local PACKTABLESTREAKURL = "http://f.99sai.com/game-share-v2/liansheng.png" --牌桌连胜
local PACKTABLEMULTIPLEURL = "http://f.99sai.com/game-share-v2/zuigaobei.png" --牌桌最高倍
local EXCHANGEENTITYURL = "http://f.99sai.com/game-share-v2/shiwujiang.png" --兑奖券兑换实物
local COINRANKINGURL = "http://f.99sai.com/game-share-v2/paiming.png" --赚金排行榜Top100
local MATCHENTITYURL = "http://f.99sai.com/game-share-v2/shiwujiang.png" --比赛获得实物
local MATCHRANKINGURL = "http://f.99sai.com/game-share-v2/paiming.png" --比赛获得前三名
local CRAZYLEVELURL = "http://f.99sai.com/game-share-v2/chuangguan.png" --疯狂闯关分享
--local MINIGAMEURL = "http://f.99sai.com/game-share-v2/shiwujiang.png" --小游戏分享

showImageChild = nil --分享弹窗展示实物图片,图片在点击查看详细信息时进行初始化

local PACKTABLENUM = "PACKTABLENUM" --普通牌桌连胜次数和倍数存入本地
local currentShareType = nil --记录当前分享类型

--病毒传播分享
isExitEnabled = false --是否可以退出程序
isRedGiftShareFirst = false --今日是否进行过红包分享
redGiftBaseInfoTable = nil --红包分享基本信息table
OldRewardText = nil --老用户分享文本
OldRewardQuitText = nil --老用户退出分享确定文本
NewRewardText = nil --
MinLimitCoin = nil --弹出红包分享的最低金币限制
BindOpenFlag = nil --IOS是否可以弹出绑定邀请码框
local isRedGiftShareReceiveRewardEnabled = false --是否可以领取红包分享奖励
local REDGIFTSHARETIME = "REDGIFTSHARETIME" --红包分享本地时间控制
isNewUserEnabled = false--是否未领取新手红包
isContinueNewGuide = false--完成分享是否可以开始新手引导
isNewUserBLoginShare = false--是否是可以新用户分享
isCanNewUserShareAndNewGuide = false--是否是可以新用户分享并且开始新手引导（开始新手引导以后赋值为false）
isSuccessShare = false --成功分享
local THEFIRSTSHAREA = 1 --A用户首次分享出现红包
local THESECONDSHAREA = 2 --A用户点击红包后
local THETHIRDSHAREA = 3 --A用户


function notUsedFun()

end

--[[--
--下载实物url图片回调函数
--]]
local function updataEntityImage(dataInApp)
	local photoPath = nil
	if Common.platform == Common.TargetIos then
		photoPath = dataInApp["useravatorInApp"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(dataInApp, "#")
		local id = string.sub(dataInApp, 1, i-1)
		photoPath = string.sub(dataInApp, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and currentShareType ~= nil then
		CommShareLogic.setShowImageChild(photoPath)
		mvcEngine.createModule(GUI_COMMSHARE) --显示分享界面
		--清空数据
		currentShareType = nil
		showImageChild = nil
	end
end

--[[--
--下载背景图片url图片回调函数
--]]
local function updataBgImage(dataInApp)
	local photoPath = nil
	if Common.platform == Common.TargetIos then
		photoPath = dataInApp["useravatorInApp"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(dataInApp, "#")
		local id = string.sub(dataInApp, 1, i-1)
		photoPath = string.sub(dataInApp, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" then
		CommShareLogic.setShareBaseInfo(currentShareType, photoPath)
		if showImageChild ~= nil then
			Common.getPicFile(showImageChild, 0, true, updataEntityImage)
		else
			Common.log("currentShareType === "..currentShareType)
			mvcEngine.createModule(GUI_COMMSHARE) --显示分享界面
			--清空数据
			currentShareType = nil
			showImageChild = nil
		end
	end
end

--[[--
--非比赛牌桌连胜分享
@parm isWin 牌桌胜利或是失败
@parm multiple 牌桌倍数
--]]
function showPackTableSharePanel(isWin, multiple)
	Common.log("CommonShareLogic====showPackTableSharePanel")
	--记录连胜次数
	local num = 0
	--记录牌桌倍数
	local mul = 1
	local timeStamp = 0
	local winStreakNum = {}
	local itemTable = Common.LoadTable(PACKTABLENUM) --获取本地存储的连胜次数
	local nowStamp = Common.getServerTime()
	if CommDialogConfig.getNewUserGiudeFinish() == true then
		--如果牌桌赢了
		if isWin then
			--如果本地数据为空
			if itemTable == nil then
				--赢的次数为1
				winStreakNum["WinNum"] = 1
				--倍数为当前牌桌的倍数
				winStreakNum["Multiple"] = multiple
				--存储当前时间
				winStreakNum["TableTime"] = nowStamp
				num = 1
				mul = multiple
			else
				timeStamp = winStreakNum["TableTime"]
				winStreakNum = itemTable
				winStreakNum["WinNum"] = winStreakNum["WinNum"] + 1
				num = winStreakNum["WinNum"]
				mul = multiple
				nowStamp = tonumber(nowStamp);
				timeStamp = tonumber(timeStamp);
				--每12个小时清空牌桌数据
				if (nowStamp - timeStamp) / (3600 * 12) > 1 then
					--赢的次数为1
					winStreakNum["WinNum"] = 1
					--倍数为0
					winStreakNum["Multiple"] = 0
					--存储当前时间
					winStreakNum["TableTime"] = Common.getServerTime()
				end
			end
			if num >= ROOMSTREAKLIM and HallGiftShowLogic.isShow == false and Common.getPicExists(PACKTABLESTREAKURL) then --如果连胜次数大于5次，优先于倍数分享
				currentShareType = PACKTABLESTREAK
				CommShareLogic.setShowNum(num)
				Common.getPicFile(PACKTABLESTREAKURL, 0, true, updataBgImage)
			elseif mul >= ROOMMULTIPLELIM and winStreakNum["Multiple"] <= mul and HallGiftShowLogic.isShow == false and Common.getPicExists(PACKTABLEMULTIPLEURL) then --如果倍数大于500且不小于历史倍数
				currentShareType = PACKTABLEMULTIPLE
				--倍数为最高倍数
				winStreakNum["Multiple"] = mul
				CommShareLogic.setShowNum(mul)
				Common.getPicFile(PACKTABLEMULTIPLEURL, 0, true, updataBgImage)
			else
				Common.getPicFile(PACKTABLESTREAKURL, 0, true, notUsedFun)
				Common.getPicFile(PACKTABLEMULTIPLEURL, 0, true, notUsedFun)
			end
		else
			--如果数据为空且输了牌桌
			if itemTable == nil then
				winStreakNum["WinNum"] = 1
				winStreakNum["Multiple"] = 1
			else
				winStreakNum = itemTable
				winStreakNum["WinNum"] = 0
			end
		end
		--将连胜次数和倍数存入本地
		Common.SaveTable(PACKTABLENUM, winStreakNum)
	end
end

--[[--
--兑换实物分享
@parm imgUrl 实物图片地址
--]]
function showExchangeSharePanel(imgUrl)
	Common.log("CommonShareLogic====showExchangeSharePanel")
	if CommDialogConfig.getNewUserGiudeFinish() == true then
		currentShareType = EXCHANGEENTITY
		if imgUrl == nil and Common.getPicExists(EXCHANGEENTITYURL) then
			--如果因为逻辑问题不能直接传值获得图片地址，则需要提前对showImageChild进行初始化
			Common.getPicFile(EXCHANGEENTITYURL, 0, true, updataBgImage)
		elseif Common.getPicExists(EXCHANGEENTITYURL) then
			--直接通过传值得到实物图片地址
			showImageChild = imgUrl
			Common.getPicFile(EXCHANGEENTITYURL, 0, true, updataBgImage)
		else
			Common.getPicFile(EXCHANGEENTITYURL, 0, true, notUsedFun)
		end
	else
		showImageChild = nil
	end
end

--[[--
--自动弹出赚金排行榜分享
@parm num 赚金排行榜排名
--]]
function autoCoinRankingSharePanel(num)
	Common.log("CommonShareLogic====autoCoinRankingSharePanel")
	local timeStamp = Common.getDataForSqlite(COINRANKINGSHARE)
	local nowStamp = Common.getServerTime()
	if timeStamp == nil or timeStamp == "" then
		Common.setDataForSqlite(COINRANKINGSHARE, nowStamp);
		showCoinRankingSharePanel(num)
	else
		nowStamp = tonumber(nowStamp);
		timeStamp = tonumber(timeStamp);
		--每12个小时可以自动弹出赚金榜排名分享
		if (nowStamp - timeStamp) / (3600 * 12) > 1 then
			Common.setDataForSqlite(COINRANKINGSHARE, Common.getServerTime());
			showCoinRankingSharePanel(num)
		end
	end
end

--[[--
--排行榜分享
@parm num 赚金排行榜排名
--]]
function showCoinRankingSharePanel(num)
	Common.log("CommonShareLogic====showCoinRankingSharePanel")
	if Common.getPicExists(COINRANKINGURL) then
		currentShareType = COINRANKING
		CommShareLogic.setShowNum(num)
		Common.getPicFile(COINRANKINGURL, 0, true, updataBgImage)
	else
		Common.getPicFile(COINRANKINGURL, 0, true, notUsedFun)
	end
end

--[[--
--比赛获得实物或前三名分享
@parm parameter 奖状信息table
--]]
function showMatchSharePanel(table)
	Common.log("CommonShareLogic====showMatchSharePanel")
	if table.PhysicalCnt == 1 and Common.getPicExists(MATCHENTITYURL) then --比赛获得实物
		currentShareType = MATCHENTITY
		showImageChild = table.AwardPicUrl
		Common.getPicFile(MATCHENTITYURL, 0, true, updataBgImage)
	elseif table.Rank <= MATCHLEVELLIM and Common.getPicExists(MATCHRANKINGURL) then --比赛获得好名次
		currentShareType = MATCHRANKING
		CommShareLogic.setShowNum(table.Rank)
		Common.getPicFile(MATCHRANKINGURL, 0, true, updataBgImage)
	else
		Common.getPicFile(MATCHENTITYURL, 0, true, notUsedFun)
		Common.getPicFile(MATCHRANKINGURL, 0, true, notUsedFun)
	end
end

--[[--
--闯关赛分享
@parm level 闯关当前关卡showPackTableSharePanel
--]]
function showCrazySharePanel(level)
	Common.log("CommonShareLogic====showCrazySharePanel")
	if level >= CRAZYLEVELLIM and isCrazyShareEnabled and Common.getPicExists(CRAZYLEVELURL) then
		currentShareType = CRAZYLEVEL
		CommShareLogic.setShowNum(level)
		Common.getPicFile(CRAZYLEVELURL, 0, true, updataBgImage)
		isCrazyShareEnabled = false
	else
		Common.getPicFile(CRAZYLEVELURL, 0, true, notUsedFun)
	end
end

--[[--
--小游戏分享
@parm gameType 分享类型
@parm num 分享数字
--]]
function showMiniGameSharePanel(gameType, num)
	Common.log("CommonShareLogic====showMiniGameSharePanel")
	if Common.getPicExists(MINIGAMEURL) then
		currentShareType = gameType
		CommShareLogic.setShowNum(num)
		Common.getPicFile(MINIGAMEURL, 0, true, updataBgImage)
	else
		Common.getPicFile(MINIGAMEURL, 0, true, notUsedFun)
	end
end


--------------------------------病毒传播分享--------------------------------------

--[[--
--红包分享
--]]
function selectRedGiftShareType()
	if isRedGiftShareFirst() then
		--如果今日是第一次红包分享
		RedGiftShareLogic.setUIVisibledByProgress(THEFIRSTSHAREA)
		mvcEngine.createModule(GUI_RED_GIFT_SHARE)
	else
		--今日不是第一次红包分享，进行普通分享
		if isOpenRedGiftShare() == true then
			mvcEngine.createModule(GUI_INITIATIVE_SHARE)
		end
	end
end

--[[--
--判断今日是否是第一次进行红包分享
--]]
function isRedGiftShareFirst()
	local timeStamp = Common.getDataForSqlite(REDGIFTSHARETIME)
	local nowStamp = Common.getServerTime()
	--红包分享功能没有开放
	if isOpenRedGiftShare() == false then
--		Common.showToast("红包功能未开启",2)
		return false
	end
	--判断今日是否是第一次进行红包分享（12个小时为准）
	if timeStamp == nil or timeStamp == "" then
		return true
	else
		nowStamp = tonumber(nowStamp);
		timeStamp = tonumber(timeStamp);
		if (nowStamp - timeStamp) / (60 * 5) > 1 then
			return true
		else
			return false
		end
	end
end

--[[--
--判断红包分享功能是否开放
--]]
function isOpenRedGiftShare()
	--红包分享功能没有开放
	if redGiftBaseInfoTable ~= nil and  redGiftBaseInfoTable.RedPackageOpenFlag == 1 then
		return true
	else
		return false
	end
end

--[[--
--获得红包分享基本信息
--]]
function getRedGiftShareBaseInfo()
	return redGiftBaseInfoTable
end

isReadRedGiftBaseInfo = false--是否已经接收了红包基本信息消息

--[[--
--保存红包分享基本信息
--]]
function saveLocalRedGiftShareBaseInfo()
	Common.log("fly============请求到红包基本信息")
	redGiftBaseInfoTable = profile.RedGiftShare.getOPERID_SHARING_V3_BASE_INFO()
	isReadRedGiftBaseInfo = true
	if redGiftBaseInfoTable ~= nil then
		OldRewardText = redGiftBaseInfoTable.OldRewardText
		OldRewardQuitText = redGiftBaseInfoTable.OldRewardQuitText
		MinLimitCoin = redGiftBaseInfoTable.MinLimitCoin
		NewRewardText = redGiftBaseInfoTable.NewRewardText
		BindOpenFlag = redGiftBaseInfoTable.BindOpenFlag
	end
end

--[[--
--是否可以显示红包（IOS是推荐输入框）
--]]
function isCanShowRedGift()
	if isOpenRedGiftShare() then
		--当前有红包活动
		if Common.platform == Common.TargetAndroid then
			--推荐人不为空
			if Common.getIntroducerID() ~= 0 then
				--可以弹出红包
				return true
			end
			--如果可以弹出IOS绑定框
		elseif Common.platform == Common.TargetIos then
			--ios绑定推荐人弹框能弹出
			if CommShareConfig.BindOpenFlag == 1 then
				--可以弹出红包
				return true
			end
		end
	end
	return false
end

--[[--
--判断显示红包分享逻辑
--]]
function showRedGiftShareView()
	if isReadRedGiftBaseInfo and GameConfig.isRegister and isCanShowRedGift() then
		--接受过消息&&注册用户&&可以显示红包
		--如果可以领取新用户红包
		if Common.platform == Common.TargetAndroid then
			--推荐人不为空
			selectRedGiftShareType()
		elseif Common.platform == Common.TargetIos then
			--如果可以弹出IOS绑定框
			--设置弹出框为IOS绑定推荐人页面
			RedeemLogic.setCurViewType(RedeemLogic.getViewTypeTable().TAG_INVITE_PRIZE);
			--创建弹出框
			mvcEngine.createModule(GUI_REDEEM)
		end
	end
end

--[[--
--断线重连后发送分享领奖消息
--]]
function sendRedGiftShareReceiveReward()
	--如果可以领取分享成功奖励
	if isRedGiftShareReceiveRewardEnabled == true then
		sendOPERID_REQUEST_GAME_SHARING_REWARD()
	elseif isNewUserBLoginShare == true then
		--如果是新用户首次分享成功
		if CommShareConfig.isSuccessShare == true then
			--领取新用户首次分享奖励
			sendOPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD()
		end
		--如果今日是第一次红包分享且是新用户则分享后进行新手引导判断
		if isContinueNewGuide == true then
			--请求新手引导，并请求奖励
			if 	profile.NewUserGuide.getisNewUserGuideisEnable()== true then
				sendCOMMONS_GET_NEWUSERGUIDE_AWARD(1);
			end
			isContinueNewGuide = false
		end
	end
end

--[[--
--设置是否可以领取红包分享奖励
--]]
function setRedGiftShareReceiveRewardEnabled(flag)
	isRedGiftShareReceiveRewardEnabled = flag
end

--[[--
--判断用户是否是注册新用户
--]]
function setNewUserEnabled(flag)
	isNewUserEnabled = flag
end

--[[--
--判断用户是否是注册新用户
--]]
function setContinueNewGuideEnabled(flag)
	isContinueNewGuide = flag
end

--if Common.platform == Common.TargetAndroid then
--  --android平台
--  local javaClassName = "com.tongqu.client.utils.SMSUtils"
--  local javaMethodName = "doSendSMSTo"
--  local javaParams = {
--    "111111",
--    "aaaaa",
--  }
--  luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
--end
