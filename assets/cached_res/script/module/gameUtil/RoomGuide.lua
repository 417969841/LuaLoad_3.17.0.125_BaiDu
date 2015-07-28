module("RoomGuide", package.seeall)
--房间的引导
--金币不足5000-弹出破产送金-元宝兑换金币--弹首充礼包--充值引导--引导低倍--获取金币

mTguideroomtable = nil--筛选的房间列表
mTguidematchtable = nil --筛选的比赛列表
--[[--
--筛选比赛
--@param #number selfcoin 自己的金币
--@param #table guideroomtable 当前玩法比赛列表
--@return #table 比赛信息
--]]
function GuideMatchType(selfcoinnum,RegCoin,showmatch)
	mTguidematchtable = showmatch

	if tonumber(selfcoinnum) > tonumber(RegCoin) then

	else
		--金币不足
		--不送金
		local timecha = Common.getDataForSqlite(CommSqliteConfig.ConvertCoinInRoomGuide .. profile.User.getSelfUserID())
		local convertcoinflag = true
		if timecha ~= nil then
			local datecha, now = Common.getTimeDifference(timecha)
			if  (tonumber(datecha) <= 24) then
				convertcoinflag = false
			else
			end
		else
		end
		if profile.User.getSelfYuanBao() >= 10 and convertcoinflag then
			--不能破产送金，就判断元宝够10个吗，够的话，兑换
			ConvertCoinInRoomLogic.setMinCoin(RegCoin)
			mvcEngine.createModule(GUI_CONVERTCOININROOM)
		else
			--不够10个元宝，弹出首充礼包
			if profile.Gift.getIsPayGift(QuickPay.First_Pay_GiftTypeID) then
				--可以购买首充礼包
				sendGIFTBAGID_REQUIRE_GIFTBAG(QuickPay.First_Pay_GiftTypeID, 1)
			else
				--不可购买礼包，则显示充值引导
				local num =  RegCoin - selfcoinnum
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, num, RechargeGuidePositionID.MatchListPositionA)
			end
		end
	end
end
--[[--
--获得合适的比赛
--@param #number selfcoin 自己的金币
--@param #table guidematchtable 当前玩法房间列表
--@return #table 房间信息
--]]
function getBestMatchInfo(selfcoin, guidematchtable)
	local matchtable = nil
	for i=1,#guidematchtable do
		--自己的金币大于最大的房间，尽最大的房间
		local num = #guidematchtable+1-i
		--先取比他的金币数最小的比赛，
		for k = 1, guidematchtable[num].ConditionCnt do
			--Common.log("选择比赛"..selfcoin.."=="..guidematchtable[num].Cond[k].OptionsCnt)
			if guidematchtable[num].Cond[k].OptionsCode == 101
				and tonumber(selfcoin) >= tonumber(guidematchtable[num].Cond[k].OptionsCnt) then
				matchtable = guidematchtable[num]
				break
			end
		end
	end
	return matchtable
end
--[[--
--筛选房间
--@param #number selfcoin 自己的金币
--@param #table guideroomtable 当前玩法房间列表
--@return #table 房间信息
--]]
function getBestRoomInfo(selfcoin, guideroomtable)
	local roomtable = nil
	for i = 1, #guideroomtable do
		--自己的金币大于最大的房间，尽最大的房间
		if tonumber(selfcoin) <= tonumber(guideroomtable[i].RegMaxCoin) and tonumber(selfcoin) >= tonumber(guideroomtable[i].RegCoin) then
			roomtable = guideroomtable[i]
			break
		end
	end
	if roomtable == nil then
		for i = 1, #guideroomtable do
			if tonumber(selfcoin) >= tonumber(guideroomtable[i].RegMaxCoin) then
				roomtable = guideroomtable[i]
				break
			end
		end
	end
	return roomtable
end

--[[--
--去合适的房间
--]]
function goToBestRoom(type, roomtable)
	RoomCoinNotFitLogic.setType(type, roomtable)
	mvcEngine.createModule(GUI_ROOMCOINNOTFIT)
end
--[[--
--进房间金币不符的引导
--@param #number selfcoin 自己的金币
--@param #number RegMinCoin 当前房间金币下限
--@param #number RegMaxCoin 当前房间金币上限
--@param #table guideroomtable 当前玩法房间列表
--]]
function GuideRoomType(selfcoin, RegMinCoin, RegMaxCoin, guideroomtable, TableType, RoomID)

	mTguideroomtable = guideroomtable

	if tonumber(selfcoin) > tonumber(RegMaxCoin) then
		--进入高倍房间
		local roomtable = getBestRoomInfo(selfcoin, guideroomtable)
		if roomtable ~= nil then
			goToBestRoom(RoomCoinNotFitLogic.getGoToRoomType().GO_TO_HIGH_ROOM, roomtable)
		else
		--异常处理
		end
	else
		--金币不足
		--		if LordGamePub.logicGiveCoin()then
		--			--可以破产送金
		--			--能破产送金，就发消息
		--			Common.log("*******************发送破产送金*******************")
		--			sendMANAGERID_GIVE_AWAY_GOLD(TableType)
		--		else
		--不可送金
		local timecha = Common.getDataForSqlite(CommSqliteConfig.ConvertCoinInRoomGuide .. profile.User.getSelfUserID())

		local convertcoinflag = true
		if timecha ~= nil and timecha ~= "" then
			local datecha, now = Common.getTimeDifference(timecha)
			if  (tonumber(datecha) <= 24) then
				convertcoinflag = false
			else
			end
		else
		end

		if profile.User.getSelfYuanBao() >= 10 and convertcoinflag then
			--不能破产送金，就判断元宝够10个吗，够的话，兑换
			ConvertCoinInRoomLogic.setMinCoin(RegMinCoin)
			mvcEngine.createModule(GUI_CONVERTCOININROOM)
		else
			--不够10个元宝，发送进入房间
			Common.showProgressDialog("进入房间中,请稍后...")
			sendEnterRoom(RoomID)
			--				if profile.Gift.getIsPayGift(QuickPay.First_Pay_GiftTypeID) then
			--					--可以购买首充礼包
			--					sendGIFTBAGID_REQUIRE_GIFTBAG(QuickPay.First_Pay_GiftTypeID, 1)
			--				else
			--					--不可购买礼包，则显示充值引导
			--					local num =  RegMinCoin - selfcoin
			--					CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, num, RechargeGuidePositionID.RoomListPositionA)
			--				end
		end
		--		end

	end
end
