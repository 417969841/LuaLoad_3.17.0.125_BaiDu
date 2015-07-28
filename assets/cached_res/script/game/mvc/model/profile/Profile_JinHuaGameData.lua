module(..., package.seeall)

-- player
-- player.noPK 禁比
-- player.sex 性别 1男2女
MALE = 1 -- 男
FEMALE = 2 -- 女

local GameData = {}
local betChipData = {}
local initCardData = {}
local checkCardData = {}
local foldCardData = {}
local gameResultData = {}
local PKData = {}
local showCardData = {}
local readyData = {}
local mySelf = {}
local sitDownData = {}
local standUpData = {}
local chatMsg = {}
local changeTable = {}
local changeCardData = {}
local noPKData = {} -- 禁比
local backPackGoodsCountData = {} -- 背包物品

-- 得到我的服务器座位号
local function setMySSID()
	local myId = profile.User.getSelfUserID()
	Common.log("牌桌同步：table.maxn"..table.maxn(GameData["players"]))
	for i=1,table.maxn(GameData["players"]) do
		if GameData["players"][i] and GameData["players"][i].userId == myId then
			mySelf = GameData["players"][i]
			GameData.mySSID = GameData["players"][i].SSID
			Common.log("我的服务端位置号："..GameData.mySSID)
			GameData["players"][i].isMe = true
			break
		end
	end
end

--获取用户客户端座位号（服务端座位号）
function getUserCSID(ssid)
	if (ssid == nil) then
		return
	end
	if GameData.mySSID then
		return (ssid - GameData.mySSID + 5)%5+1
	else
		return ssid+1
	end
end

--设置当前庄家客户端座位号
local function setDealerCSID()
	GameData.dealerCSID = getUserCSID(GameData.dealerSSID)
end

--设置所有用户客户端座位号
local function setUserCSID()
	for i=1,table.maxn(GameData["players"]) do
		local v = GameData["players"][i]
		if v ~= nil and v.SSID ~= nil then
			v.CSID = getUserCSID(v.SSID)
		end
	end
end

--按照客户端顺序设置玩家数组
local function setUserArrayOrder()
	local users = {}
	for i=1,table.maxn(GameData["players"]) do
		if GameData["players"][i] then
			users[GameData["players"][i].CSID] = GameData["players"][i]
		end
	end
	GameData["players"] = users
end

--[[--
--修改个人金币数据
]]
function setMySelfCoin(coin)
	if mySelf ~= nil then
		mySelf.remainCoins = coin
	end
end

function clearData()
	GameData = {}
	betChipData = {}
	initCardData = {}
	checkCardData = {}
	foldCardData = {}
	gameResultData = {}
	PKData = {}
	showCardData = {}
	readyData = {}
	mySelf = {}
	sitDownData = {}
	standUpData = {}
	chatMsg = {}
	changeTable = {}
	changeCardData = {}
end

-- 自己站起更新玩家信息
function updatePlayerInfo_SelfStand()
	Common.log("自己站起更新玩家信息")
	if GameData["players"][1] and GameData["players"][1].userId == profile.User.getSelfUserID() then
		GameData["players"][1]=nil
	end
	GameData.mySSID = nil
	mySelf.status = STATUS_PLAYER_WATCH
	mySelf.betCoins = 0
	setDealerCSID()
	setUserCSID()
	setUserArrayOrder()
end

-- 自己坐下更新玩家信息
function updatePlayerInfo_SelfSit(seatId)
	Common.log("自己坐下更新玩家信息")
	mySelf.SSID = seatId
	mySelf.status = STATUS_PLAYER_SITDOWN
	for i = 1,JinHuaTableConfig.playerCnt do
		if GameData["players"][i]==nil then
			GameData["players"][i] = mySelf
			break
		end
	end

	setMySSID()
	setDealerCSID()
	setUserCSID()
	setUserArrayOrder()
end

-- 本局我是否在打牌中
function isMePlayingThisRound()
	local players = GameData["players"]
	if GameData.mySSID and mySelf.cardSprites[1] and players[1] and (players[1].status == STATUS_PLAYER_LOOKCARD or players[1].status == STATUS_PLAYER_PLAYING) then -- 在打牌中
		return true
	end
	return false
end

--获取玩家
function getPlayers()
	return GameData["players"]
end

--游戏初始信息
function getGameData()
	return GameData
end

-- 获得禁比数据
function getNoPKData()
	return noPKData
end

--获取发牌数据
function getInitCardData()
	return initCardData
end


--看牌数据
function getCheckCardData()
	return checkCardData
end

--押注信息
function getBetChipData()
	return betChipData
end

--弃牌数据
function getFoldCardData()
	return foldCardData
end

--PK数据
function getPKData()
	return PKData
end


--准备数据
function getReadyData()
	return readyData
end

--开牌数据
function getShowCardData()
	return showCardData
end

--游戏结果数据
function getGameResultData()
	return gameResultData
end

--站起数据
function getStandUpData()
	return standUpData
end

--坐下数据
function getSitDownData()
	return sitDownData
end

--我的数据
function getMySelf()
	return mySelf
end

--聊天信息
function getChatMsg()
	return chatMsg
end

--聊天信息
function getChangeTable()
	return changeTable
end

--换牌信息
function getChangeCardData()
	return changeCardData
end
-- 背包物品
function getBackPackGoodsCountData()
	return backPackGoodsCountData
end

-- 牌桌同步消息
function readJHID_TABLE_SYNC(dataTable)
	GameData = dataTable
	setMySSID()
	setDealerCSID()
	setUserCSID()
	setUserArrayOrder()
	framework.emit(JHID_TABLE_SYNC)
end

--押注应答
function readJHID_BET(dataTable)
	betChipData = dataTable
	local CSID = getUserCSID(betChipData.SSID)
	betChipData.CSID = CSID
	Common.log("readJHID_BET CSID="..CSID)
	--  Common.log("readJHID_BET [players][CSID]="..GameData["players"][CSID].nickName)
	if GameData["players"] and GameData["players"][CSID] then
		GameData["players"][CSID].betCoins = dataTable["betCoins"]
		GameData["players"][CSID].remainCoins = dataTable["remainCoins"]
		GameData["round"] = dataTable["round"]
		GameData["totalPoolCoin"] = dataTable["totalPoolCoin"]
		GameData["singleCoin"] = dataTable["singleCoin"]
		if betChipData["currentPlayer"] then
			betChipData["currentPlayer"].CSID = getUserCSID(betChipData["currentPlayer"].SSID)
		end
		if betChipData.type==TYPE_BET_ANTE and betChipData.dealerSSID then
			GameData.dealerSSID = betChipData.dealerSSID
			setDealerCSID()
		end
		framework.emit(JHID_BET)
	end

end

--准备应答
function readJHID_READY(dataTable)
	Common.log("readJHID_READY")
	if GameData.mySSID then
		Common.log("准备 我的服务端位置："..GameData.mySSID)
	end
	readyData = dataTable
	readyData.CSID = getUserCSID(readyData.SSID)
	Common.log("准备 客户端位置："..readyData.CSID)
	if GameData["players"] and GameData.players[readyData.CSID] and readyData.result == 1 then
		GameData.players[readyData.CSID].status = STATUS_PLAYER_READY
	end
	framework.emit(JHID_READY)
end

--发牌应答
function readJHID_INIT_CARDS(dataTable)
	Common.log("readJHID_INIT_CARDS")
	initCardData = dataTable
	GameData.dealerSSID = initCardData.dealerSeatID
	GameData.round = initCardData.round
	setDealerCSID()
	if initCardData["currentPlayer"] then
		initCardData["currentPlayer"].CSID = getUserCSID(initCardData["currentPlayer"].SSID)
	end
	framework.emit(JHID_INIT_CARDS)
end

--看牌应答
function readJHID_LOOK_CARDS(dataTable)
	Common.log("readJHID_LOOK_CARDS")
	checkCardData = dataTable
	checkCardData.CSID = getUserCSID(checkCardData["seatID"])
	framework.emit(JHID_LOOK_CARDS)
end

--弃牌应答
function readJHID_DISCARD(dataTable)
	Common.log("readJHID_DISCARD")
	foldCardData = dataTable
	foldCardData.CSID = getUserCSID(foldCardData["seatID"])
	GameData.round = foldCardData.round
	if foldCardData.nextPlayer then
		foldCardData.nextPlayer.CSID = getUserCSID(foldCardData.nextPlayer.SSID)
	end
	framework.emit(JHID_DISCARD)
end

--比牌应答
function readJHID_PK(dataTable)
	Common.log("readJHID_PK")
	PKData = dataTable
	if GameData["players"] and PKData["result"] == 1 then
		local csid = getUserCSID(PKData.launchSeatID)
		--要求比牌的人
		PKData.launchCSID = csid

		if not GameData["players"][csid] then
			return
		end
		--要求比牌玩家下注的总金额
		GameData["players"][csid].betCoins = PKData["betCoins"]
		--要求比牌玩家剩余的金币
		GameData["players"][csid].remainCoins = PKData["remainCoins"]
		GameData.round = PKData.round
		GameData.totalPoolCoin = PKData.totalPoolCoin
		--要求比牌的人
		PKData.winCSID = getUserCSID(PKData.winnerSeatID)
		--被比牌的人客户端座位号
		PKData.aimCSID = getUserCSID(PKData.aimSeatID)
		if PKData.winnerSeatID==PKData.launchSeatID then
		--如果赢的人是要求比牌的人，输的座位号为被比牌的人座位号
			PKData.lossCSID = PKData.aimCSID
		else
		--如果赢的人是被比牌的人，输的座位号为要求比牌的人座位号
			PKData.lossCSID = PKData.launchCSID
		end
		if PKData.nextPlayer then
			PKData.nextPlayer.CSID = getUserCSID(PKData.nextPlayer.SSID)
		end
	end
	framework.emit(JHID_PK)
end

--开牌应答
function readJHID_SHOW_CARDS(dataTable)
	Common.log("readJHID_SHOW_CARDS")
	if not GameData["players"] then
		return
	end
	showCardData = dataTable
	if showCardData.result==1 then
		GameData.totalPoolCoin = showCardData.totalPotCoin
		showCardData.CSID = getUserCSID(showCardData.seatID)
		if showCardData.nextPlayer then
			showCardData.nextPlayer.CSID = getUserCSID(showCardData.nextPlayer.SSID)
		end
		if GameData["players"][showCardData.CSID] then
			GameData["players"][showCardData.CSID].betCoins = showCardData.betCoins
			GameData["players"][showCardData.CSID].remainCoins = showCardData.betCoins
		end
	end
	framework.emit(JHID_SHOW_CARDS)
end

--结果应答
function readJHID_GAME_RESULT(dataTable)
	Common.log("readJHID_GAME_RESULT")
	if not GameData["players"] then
		return
	end
	gameResultData = dataTable
	gameResultData.CSID = getUserCSID(gameResultData.winnerSeat)
	Common.log("winner CSID==============================="..gameResultData.CSID)
	if gameResultData.users then
		for var=1, #gameResultData.users do
			local user = gameResultData.users[var]
			for i=1, table.maxn(GameData["players"]) do
				local player = GameData["players"][i]
				if player and player.userId == user.userID then
					player.betCoins = user.betCoins
					player.remainCoins = user.remainCoins
					player.status = user.status
					player.cardValues = user.cardValues
					player.cardType = user.cardType
					break
				end
			end
		end
	end
	framework.emit(JHID_GAME_RESULT)
end


--坐下应答
function readJHID_SIT_DOWN(dataTable)
	Common.log("readJHID_SIT_DOWN")
	if not GameData["players"] then
		return
	end
	sitDownData = dataTable
	if sitDownData["result"]==0 then
		--坐下失败
		framework.emit(JHID_SIT_DOWN)
		return
	end
	if sitDownData.playerInfo and sitDownData.playerInfo.userId then

		Common.log("readJHID_SIT_DOWN "..sitDownData.playerInfo.nickName)
		sitDownData.playerInfo.CSID = getUserCSID(sitDownData.playerInfo.SSID)
		Common.log("readJHID_SIT_DOWN CSID="..sitDownData.playerInfo.CSID.." SSID="..sitDownData.playerInfo.SSID)
		if sitDownData.playerInfo.userId == profile.User.getSelfUserID() then
			mySelf.remainCoins = sitDownData.playerInfo.remainCoins
			mySelf.status = sitDownData.playerInfo.status
			mySelf.remainCoins = sitDownData.playerInfo.remainCoins
		else
			GameData["players"][sitDownData.playerInfo.CSID] = sitDownData.playerInfo
		end
		framework.emit(JHID_SIT_DOWN)
	end
end

--站起应答
function readJHID_STAND_UP(dataTable)
	Common.log("readJHID_STAND_UP")
	if GameData.mySSID then
		Common.log("站起 我的服务端位置："..GameData.mySSID)
	end
	standUpData = dataTable
	standUpData.CSID = getUserCSID(standUpData.SSID)
	--如果是我 并且我主动要求站起（不考虑站起失败）
	if mySelf.SSID and mySelf.SSID == standUpData.SSID and mySelf.status == STATUS_PLAYER_WATCH then
		mySelf.SSID = nil
		return
	end

	framework.emit(JHID_STAND_UP)
end

--换桌应答
function readJHID_CHANGE_TABLE(dataTable)
	Common.log("readJHID_CHANGE_TABLE")
	changeTable = dataTable
	framework.emit(JHID_CHANGE_TABLE)

end
--聊天应答
function readJHID_CHAT(dataTable)
	Common.log("readJHID_CHAT")
	chatMsg = dataTable
	chatMsg.CSID = getUserCSID(chatMsg.SSID)
	framework.emit(JHID_CHAT)

end
--换牌应答
function readJHID_CHANGE_CARD(dataTable)
	Common.log("readJHID_CHANGE_CARD")
	changeCardData = dataTable
	changeCardData.CSID = getUserCSID(changeCardData.SSID)
	framework.emit(JHID_CHANGE_CARD)
end
--禁比应答
function readJHID_NO_COMPARE(dataTable)
	Common.log("readJHID_NO_COMPARE")
	noPKData = dataTable
	noPKData.CSID = getUserCSID(noPKData["SSID"])
	GameData["players"][noPKData.CSID].noPK = true
	framework.emit(JHID_NO_COMPARE)
end

--退出牌桌应答
function readJHID_QUIT_TABLE(dataTable)
	Common.log("readJHID_QUIT_TABLE")
	local quitTableRes = dataTable
	framework.emit(JHID_QUIT_TABLE)
end

--背包商品数量
function readDBID_BACKPACK_GOODS_COUNT(dataTable)
	Common.log("readDBID_BACKPACK_GOODS_COUNT id = "..dataTable.ItemID)
	Common.log("readDBID_BACKPACK_GOODS_COUNT num = "..dataTable.Num)
	backPackGoodsCountData = dataTable
	--高级表情
	if dataTable.ItemID == GameConfig.GOODS_ID_SUPERIORFACE then
		GameConfig.remainSuperiorFaceTime = dataTable.Num
		--换桌道具
	elseif dataTable.ItemID == GameConfig.GOODS_ID_CHANGECARD then
		GameConfig.remainChangeCardCnt = dataTable.Num
	elseif dataTable.ItemID == GameConfig.GOODS_ID_NO_PK then
		GameConfig.remainNoPKCnt = dataTable.Num
	end
	framework.emit(DBID_BACKPACK_GOODS_COUNT)
end

registerMessage(JHID_TABLE_SYNC, readJHID_TABLE_SYNC);
registerMessage(JHID_BET , readJHID_BET);
registerMessage(JHID_READY , readJHID_READY);
registerMessage(JHID_INIT_CARDS , readJHID_INIT_CARDS);
registerMessage(JHID_LOOK_CARDS , readJHID_LOOK_CARDS);
registerMessage(JHID_DISCARD , readJHID_DISCARD);
registerMessage(JHID_PK , readJHID_PK);
registerMessage(JHID_SHOW_CARDS , readJHID_SHOW_CARDS);
registerMessage(JHID_GAME_RESULT , readJHID_GAME_RESULT);
registerMessage(JHID_SIT_DOWN , readJHID_SIT_DOWN);
registerMessage(JHID_STAND_UP , readJHID_STAND_UP);
registerMessage(JHID_CHANGE_TABLE , readJHID_CHANGE_TABLE);
registerMessage(JHID_CHAT , readJHID_CHAT);
registerMessage(JHID_CHANGE_CARD , readJHID_CHANGE_CARD);
registerMessage(JHID_NO_COMPARE , readJHID_NO_COMPARE);
registerMessage(JHID_QUIT_TABLE , readJHID_QUIT_TABLE);
registerMessage(DBID_BACKPACK_GOODS_COUNT , readDBID_BACKPACK_GOODS_COUNT);


