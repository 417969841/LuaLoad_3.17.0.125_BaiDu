module("MatchRechargeCoin", package.seeall)

tRecharge = {} -- 充值等待区数据表
m_nCurRechargeType = -1 -- -1:未知充值类型	0:礼包充值类型	1:破产送金类型	2:充值引导
bIsRechargeWaiting = false -- 是否已进入充值等待区
bIsRecharging = false -- 是否正在充值

function rechargeStart()
	-- send libao
	Common.log("rechargeStart 弹礼包")
	bIsRechargeWaiting = true
	bIsRecharging = true

	if profile.Gift.getIsPayGift(tRecharge.GiftId) then
		-- 礼包可以购买
		sendGiftbag(tRecharge.GiftId)
	elseif LordGamePub.logicGiveCoin() then
		-- 进行破产送金
		sendPochansongjin()
	else
		-- 充值引导框
		showChongzhiyindao()
	end

	-- 关闭音效
	GameConfig.setGameSoundOff(false)
end

--[[--
--每一次金币变化时的处理
--]]
function rechargeNext()
	Common.log("rechargeNext 金币发生变化")

	if bIsRechargeWaiting == false then
		-- 没有进入充值等待区，直接返回
		return
	end

	if coinIsEnough() == true then
		-- 比赛V4离开充值等待区
		Common.log("金币足够，可以继续比赛，离开充值等待区")
		Common.log("我现在的金币："..profile.User.getSelfCoin())
		if m_nCurRechargeType == 1 then
			--如果是破产送金复活的话，弹toast提示
			Common.showToast("您已通过破产送金复活了，继续比赛", 1)
		end

		sendLeaveRechargeWaiting(1)
		return
	end

	if bIsRecharging == false then
		-- 现在进行充值
		if m_nCurRechargeType == 0 then
			-- 使用破产送金
			Common.log("rechargeNext 开始破产送金")

			sendPochansongjin()
		elseif m_nCurRechargeType == 1 or m_nCurRechargeType == 2 then
		-- 使用充值引导
		-- Common.log("rechargeNext 开始充值引导")
		-- showChongzhiyindao()
		end
	end
end

--[[--
--金币是否足够继续比赛
--]]
function coinIsEnough()
	-- userinfo coin
	local userCurCoin = profile.User.getSelfCoin()
	if tonumber(userCurCoin) >= tonumber(tRecharge.MinCoin) then
		return true
	end

	return false
end

function sendGiftbag()
	-- 记录当前系统时间
	local curTime1 = Common.getServerTime()
	Common.log("curTime1 = "..curTime1)

	Common.log("tRecharge.GiftId = "..tRecharge.GiftId)
	m_nCurRechargeType = 0
	sendGIFTBAGID_REQUIRE_GIFTBAG(tRecharge.GiftId, 0)
end

function sendPochansongjin()
	local matchID = profile.Match.getCurPlayedMatchID()
	local tMatchList = profile.Match.getMatchTable()
	Common.log("tMatchList cnt = "..#tMatchList)
	for i = 1, #tMatchList do
		local mID = tMatchList[i].MatchID
		Common.log("mID = "..mID)
		Common.log("matchID = "..matchID)
		if matchID == mID then
			-- 找到当前进行的比赛，得到TableType，发送破产送金
			Common.log("sendPochansongjin 开始破产送金")
			m_nCurRechargeType = 1
			bIsRecharging = true
			local tableType = tMatchList[i].TableType
			sendMANAGERID_GIVE_AWAY_GOLD(tableType)
		end
	end
end

function showChongzhiyindao()
	if bIsRechargeWaiting == true then
		m_nCurRechargeType = 2
		bIsRecharging = true
		local userCurCoin = profile.User.getSelfCoin()
		local needConCnt = tRecharge.MinCoin - userCurCoin
		Common.log("needConCnt = "..needConCnt)
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, needConCnt, RechargeGuidePositionID.MatchListPositionI)
	end
end

--[[--
--比赛V4离开充值等待区
--isResume:
--0：放弃复活
--1：请求复活
--]]
function sendLeaveRechargeWaiting(isResume)
	if HallGiftCloseLogic.view ~= nil then
		mvcEngine.destroyModule(GUI_GIFT_CLOSE_VIEW)
	end

	if HallGiftShowLogic.view ~= nil then
		mvcEngine.destroyModule(GUI_GIFT_SHOW_VIEW)
	end

	if SendGoldLogic.view ~= nil then


			Common.log("当前已返回，下面不在执行！");
			mvcEngine.destroyModule(GUI_SENDGOLD)

	end

	if PayGuidePromptLogic.view ~= nil then
		mvcEngine.destroyModule(GUI_PAYGUIDEPROMPT)
	end

	if MatchDengdaidaozhangLogic.view ~= nil then
		mvcEngine.destroyModule(GUI_MATCH_TABLE_DENGDAIDAOZHANG)
	end

	if bIsRechargeWaiting == true then
		bIsRechargeWaiting = false
		m_nCurRechargeType = -1
		TableElementLayer.removeRechargeWaitingOverlay()
		Common.log("tRecharge.MatchInstanceID = "..tRecharge.MatchInstanceID)
		Common.log("isResume = "..isResume)
		sendMATID_V4_LEAVING_RECHARGE_WAITING(tRecharge.MatchInstanceID, isResume)

		if isResume == 1 then
			-- 如果是请求复活，则请求等待分桌
			sendMATID_V4_WAITING(tRecharge.MatchInstanceID)
		end
	end

	-- 恢复音效
	GameConfig.setGameSoundOff(true)
end
