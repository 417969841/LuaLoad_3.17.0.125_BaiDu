------------------------------------------------------------------
--[[------------------------斗地主心跳消息----------------------- ]]
------------------------------------------------------------------
function sendIdleMsg()
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DDZID_READY)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------------------------------------------------------
--[[------------------------斗地主牌桌消息----------------------- ]]
------------------------------------------------------------------

--[[--
* 发送开始游戏请求
*
* @param IsOpenCards 是否明牌开始
--]]
function sendDDZID_READY(IsOpenCardsReady)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DDZID_READY)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	if TableConsole.m_sMatchInstanceID == nil then
		nMBaseMessage:writeString("Room");
	else
		nMBaseMessage:writeString(TableConsole.m_sMatchInstanceID);
	end
	-- IsOpenCardsReady byte 是否明牌开始 0否 1是V2.25开始支持明牌
	nMBaseMessage:writeByte(IsOpenCardsReady);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
* 发送明牌请求
*
* @param OpenCardsTimes
*            明牌倍数
--]]
function sendLORDID_OPEN_CARDS(OpenCardsTimes)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + LORDID_OPEN_CARDS)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	-- MatchInstanceID text 比赛实例ID
	nMBaseMessage:writeString(TableConsole.m_sMatchInstanceID);
	-- OpenCardsTimes byte 明牌几倍 4倍；3倍；2倍；1:不明牌；
	nMBaseMessage:writeByte(OpenCardsTimes);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
* 发送叫分请求
--]]
function sendDDZID_CALLSCORE(nScore)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DDZID_CALLSCORE)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	nMBaseMessage:writeString(TableConsole.m_sMatchInstanceID);
	-- 已经叫到分值 ---1表示必须叫分
	nMBaseMessage:writeByte(nScore);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
* 发送出牌请求
--]]
function sendDDZID_TAKEOUTCARD(normalCardList, laiziCardlist)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DDZID_TAKEOUTCARD)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	-- MatchInstanceID text 比赛实例ID
	nMBaseMessage:writeString(TableConsole.m_sMatchInstanceID);
	-- CardsCnt byte 牌数 出了多少张牌
	nMBaseMessage:writeByte(#normalCardList);
	if (#normalCardList > 0) then
		-- 后面跟牌值
		for i = 1, #normalCardList do
			-- ...CardVal byte 牌值
			nMBaseMessage:writeByte(normalCardList[i].mnTheEndValue);
		end
	end
	-- LaiziCardsCnt byte 癞子牌牌数 癞子牌变化后的牌
	nMBaseMessage:writeByte(#laiziCardlist);
	if (#laiziCardlist > 0) then
		for i = 1, #laiziCardlist do
			-- ... LaiziCardVal byte 癞子牌变化后的牌值
			nMBaseMessage:writeByte(laiziCardlist[i].mnTheEndValue);
			-- ... OriginalCardVal byte 癞子牌变化前的原始牌值
			nMBaseMessage:writeByte(laiziCardlist[i].mnTheOriginalValue);
		end
	end

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("发送出牌请求 ===== ")
end

--[[--
* 发送抢地主请求
--]]
function sendLORDID_GRAB_LANDLORD(isGrab)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + LORDID_GRAB_LANDLORD)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	-- MatchInstanceID text 比赛实例ID
	nMBaseMessage:writeString(TableConsole.m_sMatchInstanceID);
	-- isGrab byte 是否抢地主 0不抢，1抢
	nMBaseMessage:writeByte(isGrab);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()

end

--[[--
* 发送加倍请求
*
* @param isDoubleScore
--]]
function sendLORDID_DOUBLE_SCORE(isDoubleScore)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + LORDID_DOUBLE_SCORE)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	-- MatchInstanceID text 比赛实例ID
	nMBaseMessage:writeString(TableConsole.m_sMatchInstanceID);
	-- isDoubleScore byte 是否加倍 0不加倍1加倍
	nMBaseMessage:writeByte(isDoubleScore);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()

end

--[[--
* 发送托管/解除托管操作
*
* @param nType
--]]
function sendTrustPlayReq(nType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_TRUST_PLAY)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	nMBaseMessage:writeString(TableConsole.m_sMatchInstanceID);
	nMBaseMessage:writeByte(nType);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--发送同步自己的手牌
--]]
function sendSyncHandCards()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + LORDID_SYNC_HAND_CARDS)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	nMBaseMessage:writeString(TableConsole.m_sMatchInstanceID);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-----------------------游戏ROOM_ID 消息----------------------]]

--[[--
* 请求退出房间
*
* @param nTrustQuit
--]]
function sendExitRoom(nTrustQuit)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + ROOMID_QUIT_ROOM)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	nMBaseMessage:writeByte(nTrustQuit);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
* 进房间
*
* @param roomid
--]]
function sendEnterRoom(roomid)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + ROOMID_ENTER_ROOM)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()

	-- Pub.showProgressDialog("启动牌桌，请稍候...");
	-- RoomID int 房间ID
	nMBaseMessage:writeInt(roomid);
	-- IsSupportHappyV2 byte 支持的玩法 0支持V1欢乐 1支持V2欢乐
	nMBaseMessage:writeByte(1);

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 斗地主房间列表消息协议]]
function sendROOMID_ROOM_LIST_NEW(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + ROOMID_ROOM_LIST_NEW)
	nMBaseMessage:setMsgVer(3) --消息版本号

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--RoomMode  房间模式 0普通模式 	1疯狂模式
	nMBaseMessage:writeByte(0)
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(time)
	--AppVersionCode Int 平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode())


	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("请求斗地主房间列表"..time)
end

--[[--
* 快速开始
*
* @param forceEnterRoomType
*            强制进入指定类型的房间 -1服务器自动选择 0普通 1欢乐 2癞子
--]]
function sendQuickEnterRoom(forceEnterRoomType)
	-- Pub.showProgressDialog("启动牌桌，请稍候...");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + ROOMID_QUICK_START)
	nMBaseMessage:setMsgVer(1) --消息版本号

	nMBaseMessage:writeStart()

	-- GameID int GameID
	nMBaseMessage:writeInt(GameConfig.GAME_ID);
	-- RoomID int 房间ID
	nMBaseMessage:writeInt(-1);
	-- IsSupportHappyV2 byte 支持的玩法 0:支持V1欢乐 1:支持V2欢乐
	nMBaseMessage:writeByte(1);
	-- IsSupportLaizi byte 是否支持癞子玩法 0：不支持1：支持
	nMBaseMessage:writeByte(1);
	-- ForceEnterRoomType byte 强制进入指定类型的房间 -1服务器自动选择 0普通 1欢乐 2癞子
	nMBaseMessage:writeByte(forceEnterRoomType);

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------------------------------------------------------
--[[------------------------BASEID   消息----------------------- ]]
------------------------------------------------------------------

--[[--
-- 发送注册请求
]]
function sendBASEID_REGISTER(imei)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_REGISTER)
	nMBaseMessage:setMsgVer(2) --消息版本号
	nMBaseMessage:writeStart()

	--IMIE	text	IMIE号和MAC	以html5/android/ios +’_’开头+IMIE_MAC
	nMBaseMessage:writeString(imei)
	--NickName	text	昵称	（若为空则自动生成）
	nMBaseMessage:writeString("")
	--Password	text	密码	（若为空则自动生成）
	nMBaseMessage:writeString("")
	--AppVersionCode	Int	平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--PlatVer	Text	平台版本
	nMBaseMessage:writeString(Common.getVersionName())
	--RegChannelID	text	注册渠道号
	nMBaseMessage:writeString(""..Common.getChannelID())
	--RobotModel	Byte	机器人型号	0普通用户  1,2,3 机器人等级
	nMBaseMessage:writeByte(0)
	--mobile	Text	手机号码	自动获取的
	nMBaseMessage:writeString("")
	--PlatformCode	byte	客户端类型
	--	public static final int OSID_ANDROID = 1;
	--	public static final int OSID_HTML5 = 2;
	--	public static final int OSID_IPHONE = 3;
	--	public static final int OSID_LUA_ANDROID = 4;
	--	public static final int OSID_LUA_IOS = 5;
	if Common.platform == Common.TargetIos then
		-- iOS平台
		nMBaseMessage:writeByte(5)
	elseif Common.platform == Common.TargetAndroid then
		--Android
		nMBaseMessage:writeByte(4)
	else
		nMBaseMessage:writeByte(4)
	end
	--GameID	byte	发起注册的游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--IntroducerUserID	int	推荐人的ID	从apk包中解析出来的ID
	nMBaseMessage:writeInt(Common.getIntroducerID());
	--Enctype byte 字符串编码类型 0 : Unicode1 : Utf-8
	nMBaseMessage:writeInt(0);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[--
--发送登录请求
]]
function sendBASEID_LOGIN(username, password, imei)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_LOGIN)
	nMBaseMessage:writeStart()
	--IMIE	text	IMIE号和MAC	以html5/android/ios +’_’开头+IMIE_MAC
	nMBaseMessage:writeString(imei)
	--NickName	text	昵称	（若为空则自动生成）
	nMBaseMessage:writeString(username)
	--Password	text	密码	（若为空则自动生成）
	nMBaseMessage:writeString(password)
	--AppVersionCode	Int	平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--RegChannelID	text	注册渠道号
	nMBaseMessage:writeString(""..Common.getChannelID())
	--PlatformCode	byte	客户端类型
	--	public static final int OSID_ANDROID = 1;
	--	public static final int OSID_HTML5 = 2;
	--	public static final int OSID_IPHONE = 3;
	--	public static final int OSID_LUA_ANDROID = 4;
	--	public static final int OSID_LUA_IOS = 5;
	if Common.platform == Common.TargetIos then
		-- iOS平台
		nMBaseMessage:writeByte(5)
	elseif Common.platform == Common.TargetAndroid then
		--Android
		nMBaseMessage:writeByte(4)
	else
		nMBaseMessage:writeByte(4)
	end
	--GameID	byte	发起注册的游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求取出基本信息]]
function sendBASEID_GET_BASEINFO()
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_GET_BASEINFO)

	nMBaseMessage:writeStart()
	--UserID  用户ID
	nMBaseMessage:writeInt()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求修改基本信息]]
function sendBASEID_EDIT_BASEINFO(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_EDIT_BASEINFO)


	local userID = dataTable["userID"]
	local editCnt = dataTable["editCnt"]
	local editContentTable= {}
	for i = 1,editCnt do
		editContentTable[i] = {}
		editContentTable[i].attID = dataTable["editContent"][i].attID
		editContentTable[i].attVal = dataTable["editContent"][i].attVal
		Common.log("edituserinfo"..editContentTable[i].attVal)
	end

	nMBaseMessage:writeStart()
	nMBaseMessage:writeInt(userID)
	nMBaseMessage:writeByte(editCnt)
	for i = 1,editCnt do
		nMBaseMessage:writeByte(editContentTable[i].attID)
		nMBaseMessage:writeString(editContentTable[i].attVal)
	end
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("修改个人信息请求 = ")
end


--[[-- 请求获取弹出公告消息]]
function sendBASEID_V2_GET_POP_NOTICE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_V2_GET_POP_NOTICE)

	nMBaseMessage:writeStart()
	--userID  用户ID
	nMBaseMessage:writeInt(profile.User.getSelfUserID())
	--versionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("请求获取弹出公告消息")
end

--[[-- 请求取出兑奖信息]]
function sendBASEID_GET_AWARD()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_GET_AWARD)

	nMBaseMessage:writeStart()
	--userID  用户ID
	nMBaseMessage:writeInt()
	--password  密码
	nMBaseMessage:writeString()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求同步客户端时间]]
function sendBASEID_TIMESTAMP_SYNC()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_TIMESTAMP_SYNC)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 检测游戏版本升级]]
function sendBASEID_PLAT_VERSION()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_PLAT_VERSION)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()

	nMBaseMessage:writeByte(1);
	nMBaseMessage:writeString(GameConfig.APP_NAME);
	--	nMBaseMessage:writeString("lord");
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	nMBaseMessage:writeByte(Common.getConnectionType());
	nMBaseMessage:writeByte(GameConfig.GAME_ID);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------------------------------------------------------
--[[----------------------GIFTBAGID礼包模块-----------------------]]
------------------------------------------------------------------

--[[--
--
--请求获取用户充值信息

-- ]]
function sendGIFTBAGID_USER_ENCHARGE_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_USER_ENCHARGE_INFO)
	nMBaseMessage:writeStart()
	--GameID Byte 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[--
--
-- 发送通用礼包请求消息
--
-- @param #number type 礼包类别ID
-- @param #number inBackPack 时间间隔限制是否无效 1:无效,0:有效,2:无条件弹出
-- @param #number IsRepurchase 是否为重新购买 0：不重购，1：重购
--
-- ]]
function sendGIFTBAGID_REQUIRE_GIFTBAG(type, inBackPack, IsRepurchase)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_REQUIRE_GIFTBAG)
	nMBaseMessage:writeStart()

	-- GameID Byte 游 戏 ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- GiftBagType int 礼 包 类 别 ID 服 务 器 判 断 更 准 确
	nMBaseMessage:writeInt(tonumber(type));
	-- InBackPack byte 时 间 间 隔 限 制 是 否 无 效 1 :无 效 , 0 :有 效
	nMBaseMessage:writeByte(inBackPack);
	-- IsRepurchase	byte 是否为重新购买 0：不重购，1：重购
	if IsRepurchase ~= nil then
		nMBaseMessage:writeByte(IsRepurchase);
	else
		nMBaseMessage:writeByte(0);
	end

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求客户端展示礼包]]
function sendGIFTBAGID_SHOW_GIFTBAG(GiftTypeID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_SHOW_GIFTBAG)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GiftID  礼包ID
	nMBaseMessage:writeInt(GiftTypeID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求使用元宝购买礼包]]
function sendGIFTBAGID_BUY_GIFTBAG(GiftID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_BUY_GIFTBAG)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GiftID  礼包ID
	nMBaseMessage:writeInt(GiftID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求用户背包中新礼包状态]]
function sendGIFTBAGID_NEWGIFT_TYPE(isShow)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_NEWGIFT_TYPE)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--IsShow  是否有/查看新礼包
	nMBaseMessage:writeByte(isShow)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求用户可购买礼包列表]]
function sendGIFTBAGID_GIFTBAG_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_GIFTBAG_LIST)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求用户礼包状态]]
function sendGIFTBAGID_GET_GIFTBAG_MSG()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_GET_GIFTBAG_MSG)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求用户删除背包礼包列表]]
function sendGIFTBAGID_PUSH_DELBACKLIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_PUSH_DELBACKLIST)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求首充礼包图标是否显示]]
function sendGIFTBAGID_SHOW_FIRSTPAY_ICON(Position)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_SHOW_FIRSTPAY_ICON)

	nMBaseMessage:writeStart()

	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--Position	byte	图标位置	1主界面；2牌桌上
	nMBaseMessage:writeByte(Position)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求循环礼包]]
function sendGIFTBAGID_GET_LOOP_GIFT(Position)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_GET_LOOP_GIFT)

	nMBaseMessage:writeStart()

	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--Position	byte	图标位置	1主界面；2牌桌上；3充值界面；102水果机；103金皇冠；104万人金花；105万人水果派
	nMBaseMessage:writeByte(Position)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------------------DBID数据库消息----------------------------]]
--[[--
--请求破产送金
]]
function sendMANAGERID_GIVE_AWAY_GOLD(type)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GIVE_AWAY_GOLD)
	nMBaseMessage:writeStart()

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- RoomType byte 房间类型 0普通 1欢乐 2癞子
	nMBaseMessage:writeByte(type);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()

end

--[[--
--取自己或他人的详细信息
--@param #number userid 用户ID
]]
function sendDBID_USER_INFO(userid)
	Common.log("请求自己或他人的详细信息********************* userid = " .. userid)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_USER_INFO)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()

	nMBaseMessage:writeInt(userid)
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求背包物品列表]]
function sendDBID_BACKPACK_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	profile.Pack.setPackTableDone(false);
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_BACKPACK_LIST)
	nMBaseMessage:setMsgVer(6) --消息版本号
	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求背包商品数量]]
function sendDBID_BACKPACK_GOODS_COUNT(itemID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_BACKPACK_GOODS_COUNT)

	nMBaseMessage:writeStart()
	--ItemID
	nMBaseMessage:writeInt(itemID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求得到短信通道号码]]
function sendDBID_GET_SMS_NUMBER()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_GET_SMS_NUMBER)

	nMBaseMessage:writeStart()
	--OperatorID  运营商
	nMBaseMessage:writeByte(Common.getOperater())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑换列表]]
function sendDBID_EXCHANGE_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_EXCHANGE_LIST)

	nMBaseMessage:writeStart()
	--Timestamp
	nMBaseMessage:writeLong(0)
	--
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求服务器列表]]
function sendDBID_SERVER_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_SERVER_LIST)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
-- 请求购买商品
--#number ItemID 商品ID
--#number Num 购买数量
-- ]]
function sendDBID_PAY_GOODS(ItemID, Num)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_PAY_GOODS)

	Common.log("send message convert"..ItemID.."----"..Num)
	nMBaseMessage:writeStart()
	--ItemID
	nMBaseMessage:writeInt(ItemID)
	--Num
	nMBaseMessage:writeInt(Num)
	--BackgroundColor  购买成功webview的背景颜色
	nMBaseMessage:writeString("")
	--GameID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

function sendDBID_GET_SERVER_CONFIG(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_GET_SERVER_CONFIG)

	nMBaseMessage:writeStart()
	--VarCnt  变量数目
	nMBaseMessage:writeInt(#dataTable)
	--…VarName  变量名
	for i = 1,#dataTable do
		nMBaseMessage:writeString(dataTable[i])
	end
	--VersionCode  版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--Imsi  运营商代码(Imsi)
	nMBaseMessage:writeString(Common.getImsi())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求获取服务器通用配置]]
function sendDBID_GET_SERVER_CONFIG(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_GET_SERVER_CONFIG)

	nMBaseMessage:writeStart()
	--VarCnt  变量数目
	nMBaseMessage:writeInt(#dataTable)
	--…VarName  变量名
	for i = 1,#dataTable do
		nMBaseMessage:writeString(dataTable[i])
	end
	--VersionCode  版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--Imsi  运营商代码(Imsi)
	nMBaseMessage:writeString(Common.getImsi())
	--ICCID Text 手机sim卡iccid
	nMBaseMessage:writeString(Common.getICCID());

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取修改昵称的次数]]
function sendDBID_GET_NICKNAME_MODIFY_TIMES()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_GET_NICKNAME_MODIFY_TIMES)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取指定商品详情（可多个）]]
function sendDBID_MALL_GOODS_DETAIL()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_MALL_GOODS_DETAIL)

	nMBaseMessage:writeStart()
	--Num  同时请求多少个商品
	nMBaseMessage:writeInt()
	--...GoodsID  商品ID
	nMBaseMessage:writeInt()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求商城商品列表]]
function sendDBID_MALL_GOODS_LIST(Timestamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_MALL_GOODS_LIST)
	nMBaseMessage:setMsgVer(7) --消息版本号

	nMBaseMessage:writeStart()
	--Timestamp
	nMBaseMessage:writeLong(Timestamp)
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求通过昵称发送消息]]
function sendDBID_V2_SEND_MSG_NICKNAME(toNickname,sendvalue)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_SEND_MSG_NICKNAME)

	nMBaseMessage:writeStart()
	--ReciverNickName  接收者用户昵称
	nMBaseMessage:writeString(toNickname)
	--MessageContent  消息内容
	nMBaseMessage:writeString(sendvalue)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求用户客户端手机信息]]
function sendDBID_USER_PHONE_MSG(userID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_USER_PHONE_MSG)

	nMBaseMessage:writeStart()
	--UserID  用户ID
	nMBaseMessage:writeInt(userID)
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVer  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	--ChannelID  渠道号
	nMBaseMessage:writeInt(Common.getChannelID())
	--moblieType  手机型号
	nMBaseMessage:writeString("")
	--moblieNumber  手机号码
	nMBaseMessage:writeString(Common.getTelephonyNumber())
	--Imei  Imei
	nMBaseMessage:writeString(Common.getDeviceInfo())
	--MacAddr  Mac地址
	nMBaseMessage:writeString(Common.getMacAddr())
	--ConnectionType  连接类型
	nMBaseMessage:writeString(Common.getConnectionType())
	--Imsi  运营商代码(Imsi)
	nMBaseMessage:writeString(Common.getImsi())
	--SysVerNumber  系统版本号
	nMBaseMessage:writeString("")
	--ScreenSize  手机屏幕尺寸
	nMBaseMessage:writeString("")
	--OsID  手机终端ID
	if Common.platform == Common.TargetIos then
		nMBaseMessage:writeByte(5)
	elseif Common.platform == Common.TargetAndroid then
		nMBaseMessage:writeByte(4)
	else
		nMBaseMessage:writeByte(0)
	end
	--ICCID Text 手机sim卡iccid
	nMBaseMessage:writeString(Common.getICCID());
	--CPUInfo 手机CPU信息
	--MemoryInfo 内存信息

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求屏蔽某玩家站内信
--]]--
function sendDBID_SHIELD_MAIL_USERID(gameId,type)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_SHIELD_MAIL_USERID)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()
	-- 被屏蔽用户ID
	nMBaseMessage:writeInt(gameId)
	-- 操作类别
	nMBaseMessage:writeByte(type)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()

end

--[[--
--请求移动支付方式
--]]
function sendMANAGERID_MOBILE_PAYMENT_MODE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_MOBILE_PAYMENT_MODE)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	-- GameID byte 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- VersionCode Int 游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	--ICCID	Text	SIM卡ICCID
	nMBaseMessage:writeString(Common.getICCID());
	--IMEI	Text	手机IMEI和MAC地址
	nMBaseMessage:writeString(Common.getDeviceInfo());

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求联通支付方式
--]]
function sendMANAGERID_CU_PAYMENT_MODE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_CU_PAYMENT_MODE)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	-- GameID byte 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- VersionCode Int 游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	--ICCID	Text	SIM卡ICCID
	nMBaseMessage:writeString(Common.getICCID());
	--IMEI	Text	手机IMEI和MAC地址
	nMBaseMessage:writeString(Common.getDeviceInfo());

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求电信支付方式
--]]
function sendMANAGERID_CT_PAYMENT_MODE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_CT_PAYMENT_MODE)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	-- GameID byte 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- VersionCode Int 游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	--ICCID	Text	SIM卡ICCID
	nMBaseMessage:writeString(Common.getICCID());
	--IMEI	Text	手机IMEI和MAC地址
	nMBaseMessage:writeString(Common.getDeviceInfo());

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求找回密码]]
function sendDBID_FIND_PASSWORD(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_FIND_PASSWORD)


	local username = dataTable["username"]
	local phonenum = dataTable["phonenum"]
	local imei = dataTable["imei"]

	nMBaseMessage:writeStart()
	--NickName  用户昵称
	nMBaseMessage:writeString(username)
	--Tel  手机
	nMBaseMessage:writeString(phonenum)
	--IMEI  imei
	--nMBaseMessage:writeString("android_865721010237506_null")
	nMBaseMessage:writeString(imei)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--请求短信支付]]
function sendMANAGERID_SMS_RECHARGE(ProductDetail, PaymentInformation, payChannel, position)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MANAGERID_SMS_RECHARGE);
	nMBaseMessage:writeStart();

	-- GameID Byte 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- Int 充值金额（fen）
	nMBaseMessage:writeInt(ProductDetail.price);
	-- int 游戏版本号(不带渠道号)
	nMBaseMessage:writeInt(Common.getVersionCode());
	-- ChannelID Int 渠道号
	nMBaseMessage:writeInt(Common.getChannelID());
	-- IsDirectExchangeCoin Byte 是否直接兑换成金币 1是0否
	nMBaseMessage:writeByte(PaymentInformation.isChangeCoin);
	-- Imsi Text 运营商代码(Imsi)--已抛弃
	nMBaseMessage:writeString("");
	-- GiftBagID int 礼包ID 若不为0，则充值后直接购买礼包；
	nMBaseMessage:writeInt(PaymentInformation.giftID);
	-- subtype Byte 支付子类型 默认为0
	nMBaseMessage:writeByte(ProductDetail.mnSubtype);
	-- RechargeWay Byte 支付渠道号 9：华建电信；10：移动游戏基地
	nMBaseMessage:writeByte(payChannel);
	-- Position Int 位置编码
	nMBaseMessage:writeInt(position);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--请求支付
--]]
function sendMANAGERID_V3_RECHARGE(ProductDetail, PaymentInformation, payChannel, position)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_V3_RECHARGE)
	nMBaseMessage:writeStart()

	-- GameID Byte 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- rechargeAmount Int 充值金额（fen）
	nMBaseMessage:writeInt(ProductDetail.price);
	-- ChannelID Int 渠道id
	nMBaseMessage:writeInt(Common.getChannelID());
	-- ScreenSize Text 屏幕尺寸
	nMBaseMessage:writeString("800");
	-- IsDirectExchangeCoin Byte 是否直接兑换成金币 1是0否
	nMBaseMessage:writeByte(PaymentInformation.isChangeCoin);
	-- RechargeWay Byte 1：充值卡，2：支付宝，3：银联

	-- 模拟支付测试
	--nMBaseMessage:writeByte(999);
	nMBaseMessage:writeByte(payChannel);
	-- GiftBagID int 礼包ID 若不为0，则充值后直接购买礼包；
	nMBaseMessage:writeInt(PaymentInformation.giftID);
	-- Position Int 位置编码
	nMBaseMessage:writeInt(position);
	--SerialNumber long 流水号
	nMBaseMessage:writeLong(ProductDetail.SerialNumber);

	if payChannel ==  profile.PayChannelData.ALI_PAY then
		-- 支付宝子协议
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profile.PayChannelData.WEIXIN_PAY then
		-- 微信子协议
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profile.PayChannelData.UNION_PAY then
		-- 银联子协议
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profile.PayChannelData.SMS_UNICOM then
		-- 联通沃商店子协议
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profile.PayChannelData.MM_PAY_V2 then
		-- MM子协议
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profile.PayChannelData.HUAJIAN_DIANXIN_PAY then
		-- 电信短代支付
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profile.PayChannelData.SMS_ONLINE then
		-- 移动短代支付
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profile.PayChannelData.HUAJIAN_LIANTONG_PAY then
		-- 联通短代支付
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profile.PayChannelData.RECHARGE_CARD_PAY then
		-- 充值卡子协议
		--ParamCnt	byte	特殊支付方式的参数表	不同支付方式分别定义
		nMBaseMessage:writeByte(4);
		--…ParamValue	Text	参数值
		-- e宝子协议
		-- Pa8_cardNo Text 卡号
		nMBaseMessage:writeString(ProductDetail.Pa8_cardNo);
		-- Pa9_cardPwd Text 密码
		nMBaseMessage:writeString(ProductDetail.Pa9_cardPwd);
		-- Pa7_cardAmt Int 卡面额(分)
		nMBaseMessage:writeString("" ..ProductDetail.price);
		-- Pd_frpId Text 支付渠道编码
		nMBaseMessage:writeString(ProductDetail.Pd_frpId);
	elseif payChannel ==  profile.PayChannelData.RECHARGE_91 then
		-- 91
		nMBaseMessage:writeByte(0);
	--		nMBaseMessage:writeString(PaymentInformation.orderID);
	--		nMBaseMessage:writeInt(PaymentInformation.giftID);
	--		-- subtype Byte 支付子类型 默认为0
	--		nMBaseMessage:writeByte(ProductDetail.mnSubtype);
	--		-- Position Int 位置编码 默认为0
	--		nMBaseMessage:writeInt(position);
	elseif payChannel ==  profile.PayChannelData.HAIMA_PAY then
		-- 海马
		nMBaseMessage:writeByte(0);
	--		nMBaseMessage:writeString("");
	--		nMBaseMessage:writeInt(PaymentInformation.giftID);
	--		-- subtype Byte 支付子类型 默认为0
	--		nMBaseMessage:writeByte(ProductDetail.mnSubtype);
	--		-- Position Int 位置编码 默认为0
	--		nMBaseMessage:writeInt(position);
	elseif payChannel ==  profile.PayChannelData.IAP_PAY then
		-- iap支付
		nMBaseMessage:writeByte(0);
	--		nMBaseMessage:writeInt(PaymentInformation.giftID);
	--		-- subtype Byte 支付子类型 默认为0
	--		nMBaseMessage:writeByte(ProductDetail.mnSubtype);
	--		-- Position Int 位置编码 默认为0
	--		nMBaseMessage:writeInt(position);
	elseif payChannel == profile.PayChannelData.NEW_UNION_PAY then
		--新银联支付
		nMBaseMessage:writeByte(0);
	elseif payChannel == profile.PayChannelData.EPAY then
		--宜支付
		nMBaseMessage:writeByte(0);
	elseif payChannel == profile.PayChannelData.YINBEIKEPAY_CMCC then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profile.PayChannelData.YINBEIKEPAY_UNI then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profile.PayChannelData.YINBEIKEPAY_CT then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profile.PayChannelData.HONGRUAN_SDK_CMCC then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profile.PayChannelData.HONGRUAN_SDK_UNICOM then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profile.PayChannelData.HONGRUAN_SDK_CT then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profile.PayChannelData.RECHARGE_WOJIA then
		nMBaseMessage:writeByte(0);
	end

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------------------------------------------------------
--[[------------------------IM_ID聊天室消息----------------------- ]]
------------------------------------------------------------------

--[[-- 请求进入聊天室]]
function sendIMID_ENTER_CHAT_ROOM(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_ENTER_CHAT_ROOM)
	nMBaseMessage:writeStart()
	--ChatRoomID  聊天室ID（目前填写游戏ID即可）
	nMBaseMessage:writeInt(GameConfig.GAME_ID)
	--NickName  昵称
	nMBaseMessage:writeString(dataTable["NickName"])
	--IsFirstEnter  是否第一次进入
	nMBaseMessage:writeByte(dataTable["IsFirstEnter"])
	--ChatRoomName  聊天室标识（与ChatRoomID共同做Key）
	nMBaseMessage:writeString(dataTable["ChatRoomName"])
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求聊天室发言]]
function sendIMID_CHAT_ROOM_SPEAK(sendChat)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_CHAT_ROOM_SPEAK)
	nMBaseMessage:writeStart()
	--RoomID  聊天室ID（目前填写游戏ID即可）
	nMBaseMessage:writeInt(GameConfig.GAME_ID)
	--SpeechText  发言内容
	nMBaseMessage:writeString(sendChat)

	--ChatRoomName  聊天室标识（与ChatRoomID共同做Key）
	--nMBaseMessage:writeString()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求退出聊天室]]
function sendIMID_QUIT_CHAT_ROOM()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_QUIT_CHAT_ROOM)

	nMBaseMessage:writeStart()
	--RoomID  聊天室ID（目前填写游戏ID即可）
	nMBaseMessage:writeInt(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求显示聊天室当前最新消息]]
function sendIMID_GET_LAST_CHAT_ROOM_SPEAK()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_GET_LAST_CHAT_ROOM_SPEAK)

	nMBaseMessage:writeStart()
	--RoomID  聊天室ID（目前填写游戏ID即可）
	nMBaseMessage:writeInt(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--屏蔽举报某玩家聊天

function sendIMID_OPERATE_CHAT_USER_TYPE(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_OPERATE_CHAT_USER_TYPE)

	nMBaseMessage:writeStart()
	--OperateUserID	int	被举报用户ID
	nMBaseMessage:writeInt(dataTable["OperateUserID"])
	Common.log("OperateUserID",dataTable["OperateUserID"])
	--OperateType	byte	操作类别	0：屏蔽  1：举报
	nMBaseMessage:writeByte(dataTable["OperateType"])
	Common.log("OperateType",dataTable["OperateType"])
	--RoomID  聊天室ID（目前填写游戏ID即可）
	nMBaseMessage:writeInt(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--进入小游戏聊天室
--]]
function sendIMID_MINI_ENTER_CHAT_ROOM(MiniGameType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_ENTER_CHAT_ROOM)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型  1 水果机 2 金皇冠 3 …
	nMBaseMessage:writeByte(MiniGameType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--退出小游戏聊天室
--]]
function sendIMID_MINI_QUIT_CHAT_ROOM(MiniGameType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_QUIT_CHAT_ROOM)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型  1 水果机 2 金皇冠 3 …
	nMBaseMessage:writeByte(MiniGameType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--小游戏发送消息
--]]
function sendIMID_MINI_SEND_MESSAGE(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_SEND_MESSAGE)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型  1 水果机 2 金皇冠 3 …
	nMBaseMessage:writeByte(dataTable["MiniGameType"])
	--MessageContent	Text	消息内容
	nMBaseMessage:writeString(dataTable["MessageContent"])
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-----------------------打赏模块 REWARDS 消息----------------------]]
--[[--
--请求小游戏打赏基本信息(MINI_REWARDS_BASEINFO)
--]]
function sendIMID_MINI_REWARDS_BASEINFO(MiniGameType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_REWARDS_BASEINFO)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型
	nMBaseMessage:writeByte(MiniGameType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求小游戏打赏(MINI_REWARDS_RESULT)
--]]
function sendIMID_MINI_REWARDS_RESULT(MiniGameType, RewardType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_REWARDS_RESULT)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型
	nMBaseMessage:writeByte(MiniGameType)
	--RewardType	byte	红包类型	1 小 2 大
	nMBaseMessage:writeByte(RewardType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求小游戏打赏领奖 (MINI_REWARDS_COLLECT)
--]]
function sendIMID_MINI_REWARDS_COLLECT(MiniGameType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_REWARDS_COLLECT)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型
	nMBaseMessage:writeByte(MiniGameType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

----[[--
----请求小游戏打赏是否有记录 (IMID_MINI_REWARDS_JUDGE)
----]]
--function sendIMID_MINI_REWARDS_JUDGE(MiniGameType)
--	if Services:getMessageService():getCutOut() then
--		return
--	end
--	local nMBaseMessage = NMBaseMessage:new()
--	nMBaseMessage:setMessageType(REQ + IMID_MINI_REWARDS_COLLECT)
--
--	nMBaseMessage:writeStart()
--	--GameID	byte	ID
--	nMBaseMessage:writeByte(GameConfig.GAME_ID)
--	--GameVersionCode  游戏版本号
--	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
--	--MiniGameType 小游戏类型
--	nMBaseMessage:writeByte(MiniGameType)
--	nMBaseMessage:writeOver()
--	local messageService = Services:getMessageService()
--	messageService:sendMessage(nMBaseMessage)
--	nMBaseMessage:delete()
--end

--[[--
--小游戏领取打赏V3 (IMID_MINI_GET_REWARDS_V3)
--]]
function sendIMID_MINI_GET_REWARDS_V3(MiniGameType, CheckCode)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_GET_REWARDS_V3)

	nMBaseMessage:writeStart()

	--MiniGameType	Byte	小游戏类型	1 老虎机 2金皇冠 3…
	nMBaseMessage:writeByte(MiniGameType)
	--CheckCode	Int	验证码	发话者ID
	nMBaseMessage:writeInt(CheckCode)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


------------------------------------------------------------------
--[[------------------------MANAGERID消息----------------------- ]]
------------------------------------------------------------------

--[[--
--获取初始化图片
--]]
function sendMANAGERID_GET_INIT_PIC(TimeStamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_INIT_PIC)

	nMBaseMessage:writeStart()

	--GameID	Byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--TimeStamp	Long	时间戳
	nMBaseMessage:writeLong(TimeStamp)
	--version	Int	版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求绑定用户手机号]]
function sendMANAGERID_BINDING_USER_PHONE_NUMBER()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_BINDING_USER_PHONE_NUMBER)

	nMBaseMessage:writeStart()
	--Phone_number  手机号
	nMBaseMessage:writeString()
	--UserID  用户ID
	nMBaseMessage:writeInt()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑奖]]
function sendMANAGERID_EXCHANGE_AWARD(goodid,username,phone,youbian,address,orderID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_EXCHANGE_AWARD)

	nMBaseMessage:writeStart()
	--GoodID  物品ID
	nMBaseMessage:writeInt(goodid)
	--Name  姓名
	nMBaseMessage:writeString(username)
	--PhoneNumber  电话
	nMBaseMessage:writeString(phone)
	--PostCode  邮编
	nMBaseMessage:writeString(youbian)
	--Address  地址
	nMBaseMessage:writeString(address)
	--OrderID 订单号
	nMBaseMessage:writeInt(orderID)
	--GameID 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获得用户充值记录]]
function sendGET_RECHARGE_RECORD(PageStartID,PageSize)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GET_RECHARGE_RECORD)

	nMBaseMessage:writeStart()
	--Start  起始数
	nMBaseMessage:writeInt(PageStartID)
	--Count  每页数
	nMBaseMessage:writeByte(PageSize)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取绑定手机号随机码]]
function sendMANAGERID_GET_BINDING_PHONE_RANDOM()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_BINDING_PHONE_RANDOM)
	Common.log("sendMANAGERID_GET_BINDING_PHONE_RANDOM")
	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取所有奖品]]
function sendMANAGERID_GET_PRESENTS(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_PRESENTS)

	nMBaseMessage:writeStart()
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(time)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取游戏基地支付说明数据]]
function sendMANAGERID_MOBILE_PAY_DATA()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_MOBILE_PAY_DATA)

	nMBaseMessage:writeStart()
	--GameId  游戏id
	nMBaseMessage:writeByte()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取自己兑换的奖品列表]]
function sendMANAGERID_GET_EXCHANGE_AWARDS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_EXCHANGE_AWARDS)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求支付数据列表
--@param #table PayData 请求的支付列表类型
--]]
function sendPAYMENT_DATA_LIST(PayData)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + PAYMENT_DATA_LIST)
	nMBaseMessage:writeStart()
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(0)
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	--PayChannelSize	byte	需要获取的支付列表类型数
	nMBaseMessage:writeByte(#PayData)
	--…PayChannelType	byte	支付列表类型
	for i = 1, #PayData do
		nMBaseMessage:writeByte(PayData[i])
	end

	Common.log("请求支付数据列表")
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
--[[-- 请求得到当前手机绑定的用户列表]]
function sendBASEID_GET_IMEIUSERS(imei)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_GET_IMEIUSERS)

	nMBaseMessage:writeStart()
	Common.log("imei"..imei)
	--IMEI  IMEI号和MAC
	--nMBaseMessage:writeString("android_865721010237506_null")
	nMBaseMessage:writeString(imei)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[--请求门票]]
function sendTICKET_GET_TICKET_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + TICKET_GET_TICKET_LIST)

	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求回话列表]]
function sendDBID_V2_GET_CONVERSATION_LIST(PageStartID,PageSize)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_GET_CONVERSATION_LIST)

	nMBaseMessage:writeStart()
	--PageStartID  本页请求起始ID
	nMBaseMessage:writeInt(PageStartID)
	--PageSize  每页几条数据
	nMBaseMessage:writeByte(PageSize)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
--[[-- 请求会话详情]]
function sendDBID_V2_GET_CONVERSATION(ConversationID,PageSize,PageStartID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_GET_CONVERSATION)

	nMBaseMessage:writeStart()
	--ConversationID  会话ID
	nMBaseMessage:writeInt(ConversationID)
	--PageStartID  本页请求起始ID
	nMBaseMessage:writeInt(PageStartID)
	--PageSize  每页几条数据
	nMBaseMessage:writeByte(PageSize)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
--[[-- 请求删除会话]]
function sendDBID_V2_DELETE_CONVERSATION(ConversationID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_DELETE_CONVERSATION)

	nMBaseMessage:writeStart()
	--ConversationID  会话ID
	nMBaseMessage:writeInt(ConversationID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求删除会话]]
function sendDBID_V2_EMPTY_CONVERSITION(ConversationID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_EMPTY_CONVERSITION)

	nMBaseMessage:writeStart()
	--ConversationID  会话ID
	nMBaseMessage:writeInt(ConversationID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求发送会话]]
function sendDBID_V2_SEND_MESSAGE(userID,msg,phonenum,phonetype,imei,connecttype,version)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_SEND_MESSAGE)

	nMBaseMessage:writeStart()
	--ReciverUserID  接收者用户ID
	nMBaseMessage:writeInt(userID)
	--MessageContent  消息内容
	nMBaseMessage:writeString(msg)
	--moblieType  手机型号
	nMBaseMessage:writeString(phonetype)
	--moblieNo  手机号码
	nMBaseMessage:writeString(phonenum)
	--Imei  Imei
	nMBaseMessage:writeString(imei)
	--ConnectionType  连接类型
	nMBaseMessage:writeString(connecttype)
	--gameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--Version  版本
	nMBaseMessage:writeString(version)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求签到：获取签到内容]]
function sendMANAGERID_DAILY_SIGN()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_DAILY_SIGN)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求宝盒：获取宝盒进度]]
function sendBAOHE_GET_PRO()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BAOHE_GET_PRO)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.JINHUA_GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求宝盒：获取宝藏V2]]
function sendBAOHE_GET_TREASURE_V2()
	Common.log("sendBAOHE_GET_TREASURE_V2")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BAOHE_GET_TREASURE_V2)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.JINHUA_GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑奖列表]]
function sendMANAGERID_PRIZE_PIECES_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_PRIZE_PIECES_LIST)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑奖操作]]
function sendMANAGERID_PIECES_COMPOUND_DETAILS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_PIECES_COMPOUND_DETAILS)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--PiecesID  碎片ID
	nMBaseMessage:writeInt()

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑奖操作]]
function sendMANAGERID_GET_PIECES_SHOP_LIST(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_PIECES_SHOP_LIST)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(time)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑奖券碎片兑奖]]
function sendMANAGERID_PIECES_EXCHANGE(goodID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_PIECES_EXCHANGE)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GoodID  物品id
	nMBaseMessage:writeInt(goodID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求我的奖品]]
function sendMANAGERID_GET_EXCHANGE_AWARDS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_EXCHANGE_AWARDS)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求新充值卡备选奖品列表]]
function sendNEW_GET_ALTERNATIVE_PRIZE_LIST(awardID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + NEW_GET_ALTERNATIVE_PRIZE_LIST)

	nMBaseMessage:writeStart()
	--PrizeID  奖品ID
	nMBaseMessage:writeInt(awardID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求新充值卡备选奖品列表2]]
function sendNEW_GET_ALTERNATIVE_PRIZE(awardID,type)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + NEW_GET_ALTERNATIVE_PRIZE)

	nMBaseMessage:writeStart()
	--PrizeID  奖品ID
	nMBaseMessage:writeInt(awardID)
	--ItemType  备选奖品类型
	nMBaseMessage:writeByte(type)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求新获取自己赢得的奖品列表]]
function sendNEW_GET_PRIZE_LIST(time,num)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + NEW_GET_PRIZE_LIST)

	nMBaseMessage:writeStart()
	--AwardTime  最后一个奖品的获奖日期
	nMBaseMessage:writeLong(time)
	--Count  请求数量
	nMBaseMessage:writeByte(num)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求碎片合成操作]]
function sendMANAGERID_COMPOUND_V2(PiecesID,num)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_COMPOUND_V2)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--PiecesID  碎片ID
	nMBaseMessage:writeInt(PiecesID)
	--compoundNum  合成兑奖券的数量
	nMBaseMessage:writeInt(num)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求碎片合成列表]]
function sendMANAGERID_PIECES_COMPOUND_DETAILS_V2()
	if Services:getMessageService():getCutOut() then
		return
	end
	profile.Pack.setPriceCompoundDone(false);
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_PIECES_COMPOUND_DETAILS_V2)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--lua脚本版本检测]]
function sendMANAGERID_LUA_SCRIPT_VERSION()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_LUA_SCRIPT_VERSION)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--ScriptVerCode	Int	脚本版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--netType byte 网络类型 0未知1 wifi 2 2G 33G
	nMBaseMessage:writeByte(Common.getConnectionType())
	--isFullPackage	byte 是否是完整包  0不是，1是
	if GameConfig.gameIsFullPackage() then
		nMBaseMessage:writeByte(1)
	else
		nMBaseMessage:writeByte(0)
	end

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--lua脚本版本MD5校验]]
function sendMANAGERID_LUA_SCRIPT_MD5(VersionCode,ScriptVerCode,ScriptMD5)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_LUA_SCRIPT_MD5)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--VersionCode	Int	游戏版本号	(游戏版本号+渠道号)
	nMBaseMessage:writeInt(VersionCode)
	--ScriptVerCode	Int	脚本版本号
	nMBaseMessage:writeInt(ScriptVerCode)
	--ScriptMD5	Text	脚本MD5	将脚本资源文件MD5拼接所得字符串，再取MD5值后上传。如果为空字符串，则表示本次不校验MD5
	nMBaseMessage:writeString(ScriptMD5)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.7.100 小游戏列表状态消息(MANAGERID_MINIGAME_LIST_TYPE)
function sendMANAGERID_MINIGAME_LIST_TYPE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_MINIGAME_LIST_TYPE)
	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-----------------------老虎机模块 SLOTID 消息----------------------]]

--[[--
--请求老虎机准备信息(SLOT_READY_INFO)
--]]
function sendSLOT_READY_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + SLOT_READY_INFO)

	nMBaseMessage:writeStart()

	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求老虎机奖金表信息(SLOT_PRIZE_LIST)
--]]
function sendSLOT_PRIZE_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + SLOT_PRIZE_LIST)

	nMBaseMessage:writeStart()
	--timestamp	long	时间戳
	nMBaseMessage:writeLong(0)
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求老虎机滚动信息(SLOT_ROLL_MESSAGE)
--]]
function sendSLOT_ROLL_MESSAGE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + SLOT_ROLL_MESSAGE)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--LatestItemID	Int	上次取到的最后一条信息的ID，第一次取为0
	nMBaseMessage:writeInt(FruitMachineLogic.FruitMessageOfLastID)
	--Limit	short	想取多少条，最多200
	nMBaseMessage:writeShort(20)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求老虎机中奖信息(SLOT_ACCEPT_THE_PRIZE)
--]]
function sendSLOT_ACCEPT_THE_PRIZE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + SLOT_ACCEPT_THE_PRIZE)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--Coin	int	押注
	nMBaseMessage:writeInt(tonumber(FruitMachineLogic.LabelAtlas_raise_coin:getStringValue()))
	--   nMBaseMessage:writeInt(200)
	--VersionCode	int	游戏版本号
	--	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求比倍中奖信息(SLOT_RICK_COLLECT_MONEY)
--]]
function sendSLOT_RICK_COLLECT_MONEY(datatable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + SLOT_RICK_COLLECT_MONEY)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--Num	int	比倍次数	Loop
	nMBaseMessage:writeInt(#datatable)
	--     nMBaseMessage:writeInt(0)
	Common.log("wxf-------------datatableLength: " .. #datatable)
	for i = 1,#datatable do
		Common.log("wxf--------------------sendSLOT_RICK_COLLECT_MONEY:  " .. datatable[i])
		nMBaseMessage:writeByte(datatable[i])
	end
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
老虎机中奖纪录（SLOT_RICK_WINNING_RECORD）
--]]
function sendSLOT_RICK_WINNING_RECORD(timestamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + SLOT_RICK_WINNING_RECORD)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeLong(timestamp)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-----------------------金皇冠模块 JHGID 消息----------------------]]
--[[--
--请求金皇冠准备信息(JHG_READY_INFO)
--]]
function sendJHG_READY_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHG_READY_INFO)
	Common.log("****************金皇冠发送准备信息请求***************")
	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求金皇冠滚动信息(JHG_ROLL_MESSAGE)
--]]
function sendJHG_ROLL_MESSAGE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHG_ROLL_MESSAGE)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--LatestItemID	Int	上次取到的最后一条信息的ID，第一次取为0
	Common.log("JHGMessageOfLastID----------------"..JinHuangGuanLogic.JHGMessageOfLastID)
	nMBaseMessage:writeInt(JinHuangGuanLogic.JHGMessageOfLastID)
	--Limit	short	想取多少条，最多200
	nMBaseMessage:writeShort(20)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求金皇开始信息(JHG_START_GAME)
--]]
function sendJHG_START_GAME()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHG_START_GAME)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--Coin	int	押注
	nMBaseMessage:writeInt(JinHuangGuanLogic.currentStake)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求金皇冠换牌信息(JHG_CHANGE_PAI)
--]]
function sendJHG_CHANGE_PAI()

	if JinHuangGuanLogic.remainArray.PaiArray == nil then
		return;
	end

	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHG_CHANGE_PAI)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--RemainsArray	Loop
	local num = 0
	for i = 1,5 do
		if(JinHuangGuanLogic.remainArray[i] == nil)then
			num = num +  1
		end
	end
	nMBaseMessage:writeInt(num)
	--…remain	Byte	用户需要换的牌
	for i = 1,5 do
		if(JinHuangGuanLogic.remainArray[i] == nil)then
			Common.log("需要换的牌",JinHuangGuanLogic.remainArray.PaiArray[i].puke)
			nMBaseMessage:writeByte(JinHuangGuanLogic.remainArray.PaiArray[i].puke)
		end
	end
	--VersionCode	int	游戏版本号
	--	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
金皇冠中奖纪录（JHG_WINNING_RECORD）
--]]
function sendJHG_WINNING_RECORD(timestamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHG_WINNING_RECORD)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeLong(timestamp)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	Common.log("fly----------------sendJHG_WINNING_RECORD  ",timestamp)
	nMBaseMessage:delete()
end

--[[--
--请求比倍中奖信息(JHG_RICK_COLLECT_MONEY)
--]]
function sendJHG_RICK_COLLECT_MONEY(datatable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHG_RICK_COLLECT_MONEY)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--Num	int	比倍次数	Loop
	nMBaseMessage:writeInt(#datatable)
	--     nMBaseMessage:writeInt(0)
	--	Common.log("fly-------------datatableLength: " .. #datatable)
	for i = 1,#datatable do
		--	Common.log("fly--------------------sendJHG_RICK_COLLECT_MONEY:  " .. datatable[i])
		nMBaseMessage:writeByte(datatable[i])
	end
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求ituns商城验证]]
function sendMANAGERID_VALIDATE_IAP(receipt,goodid,userID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_VALIDATE_IAP)

	nMBaseMessage:writeStart()
	--加密json信息
	nMBaseMessage:writeString(receipt)
	--支付方式，测试还是支付
	nMBaseMessage:writeString(GameConfig.PayType)
	--订单号
	nMBaseMessage:writeString(goodid)
	--userID
	nMBaseMessage:writeString(userID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-----------------------游戏MATCH_ID 消息----------------------]]

--[[--
--请求当前未结束的牌桌数
--]]
function sendMatchTableNotEnded()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_TABLE_NOTENDED)
	nMBaseMessage:setMsgVer(0) --消息版本号

	nMBaseMessage:writeStart()

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- 比赛ID
	nMBaseMessage:writeString(TableConsole.m_sMatchInstanceID);

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
斗地主比赛列表
function sendMATID_MATCH_LIST_NEW(time)
if Services:getMessageService():getCutOut() then
return
end
local nMBaseMessage = NMBaseMessage:new()
nMBaseMessage:setMessageType(REQ + MATID_MATCH_LIST_NEW)
nMBaseMessage:setMsgVer(1) --消息版本号

nMBaseMessage:writeStart()
--GameID  游戏ID
nMBaseMessage:writeInt(GameConfig.GAME_ID)
--TimeStamp  时间戳
nMBaseMessage:writeLong(time)
--GameVersionCode  游戏版本号
nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

nMBaseMessage:writeOver()
local messageService=Services:getMessageService()
messageService:sendMessage(nMBaseMessage)
nMBaseMessage:delete()
end
]]

--[[
3.03 斗地主比赛列表
]]
function sendMATID_V4_MATCH_LIST(time)
	Common.log("sendMATID_V4_MATCH_LIST")
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V4_MATCH_LIST)
	nMBaseMessage:setMsgVer(0) --消息版本号

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeInt(GameConfig.GAME_ID)
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(time)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
3.03 比赛动态信息同步V4
]]
function sendMATID_V4_MATCH_SYNC()
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V4_MATCH_SYNC)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
3.03 比赛报名V4
]]
function sendMATID_V4_REG_MATCH(gameID, matchID, regTypeIndex, IgnoreRegedOtherMatch)
	if Services:getMessageService():getCutOut() then
		return
	end
	if matchID == nil then
		Common.log("matchID =============== nil");
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V4_REG_MATCH)
	nMBaseMessage:setMsgVer(0) --消息版本号

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--MatchID  比赛ID
	nMBaseMessage:writeInt(matchID)
	--RegType	Byte	报名类型
	nMBaseMessage:writeByte(regTypeIndex)

	--是否忽略其他已报名的比赛
	nMBaseMessage:writeByte(IgnoreRegedOtherMatch)

	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
3.03 退票V4
]]
function sendMATID_V4_REFUND(matchID)
	Common.log("sendMATID_V4_REFUND")

	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V4_REFUND)
	nMBaseMessage:setMsgVer(0) --消息版本号

	nMBaseMessage:writeStart()
	--MatchID  比赛ID
	nMBaseMessage:writeInt(matchID)

	nMBaseMessage:writeOver()

	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
3.03 报名人数同步V4
]]
function sendMATID_V4_REGCNT(matchID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V4_REGCNT)
	nMBaseMessage:setMsgVer(0) --消息版本号

	nMBaseMessage:writeStart()
	--MatchID  比赛ID
	nMBaseMessage:writeInt(matchID)

	nMBaseMessage:writeOver()

	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
3.03 进入比赛V4
]]
function sendMATID_V4_ENTER_MATCH(gameID, matchInstanceID)
	if Services:getMessageService():getCutOut() then
		return
	end
	Common.log("sendMATID_V4_ENTER_MATCH gameID = "..gameID)
	Common.log("sendMATID_V4_ENTER_MATCH matchInstanceID = "..matchInstanceID)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V4_ENTER_MATCH)
	nMBaseMessage:setMsgVer(0) --消息版本号

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(gameID)
	-- MatchInstanceID 比赛实例ID
	nMBaseMessage:writeString(matchInstanceID);

	nMBaseMessage:writeOver()

	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
3.03 比赛V4离开充值等待区
]]
function sendMATID_V4_LEAVING_RECHARGE_WAITING(matchInstanceID, isResume)
	if Services:getMessageService():getCutOut() then
		return
	end

	Common.log("sendMATID_V4_LEAVING_RECHARGE_WAITING isResume = "..isResume)

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V4_LEAVING_RECHARGE_WAITING)
	nMBaseMessage:setMsgVer(0) --消息版本号

	nMBaseMessage:writeStart()
	nMBaseMessage:writeInt(matchInstanceID)
	nMBaseMessage:writeByte(isResume)
	nMBaseMessage:writeOver()

	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
3.03 比赛排名V4
]]
function sendMATID_V4_RANK(gameID, matchInstanceID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V4_RANK)
	nMBaseMessage:setMsgVer(0) --消息版本号

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(gameID)
	-- MatchInstanceID 比赛实例ID
	nMBaseMessage:writeString(matchInstanceID);

	nMBaseMessage:writeOver()

	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
3.03 比赛等待分桌V4
]]
function sendMATID_V4_WAITING(matchInstanceID)
	if Services:getMessageService():getCutOut() then
		return
	end
	Common.log("sendMATID_V4_WAITING")
	Common.log("matchInstanceID = "..matchInstanceID)

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V4_WAITING)
	nMBaseMessage:setMsgVer(0) --消息版本号

	nMBaseMessage:writeStart()
	-- MatchInstanceID 比赛实例ID
	nMBaseMessage:writeString(matchInstanceID);

	nMBaseMessage:writeOver()

	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
3.03 比赛小提示V4
nTipIndex:当前滚动的小提示在提示文字列表中的索引号,如果为首次请求该字段为-1
]]
function sendMATID_V4_TIPS(nTipIndex)
	if Services:getMessageService():getCutOut() then
		return
	end
	Common.log("sendMATID_V4_TIPS nTipIndex = "..nTipIndex)

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V4_TIPS)
	nMBaseMessage:setMsgVer(0) --消息版本号

	nMBaseMessage:writeStart()
	nMBaseMessage:writeInt(nTipIndex)
	nMBaseMessage:writeOver()

	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
3.03 比赛闹钟选择比赛V4
matchInstanceID:当前比赛的比赛实例id
nChoose:用户选择是否进入新比赛, 0：留在当前比赛牌桌 1：退出当前比赛进入新比赛
]]
function sendMATID_V4_CHOOSE(matchInstanceID, nChoose)
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V4_CHOOSE)
	nMBaseMessage:setMsgVer(0) --消息版本号

	nMBaseMessage:writeStart()
	nMBaseMessage:writeString(matchInstanceID)
	nMBaseMessage:writeByte(nChoose)
	nMBaseMessage:writeOver()

	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--比赛报名人数同步]]
function sendMATID_MATCH_LIST_REGCNT()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_MATCH_LIST_REGCNT)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("比赛报人数同步")
end


--[[-- 请求同步比赛列表]]
function sendMATID_V2_MATCH_LIST_SYNC()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V2_MATCH_LIST_SYNC)

	nMBaseMessage:writeStart()
	Common.log("同步报名send")
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

---------------------比赛相关--------------------------------
--[[-- 请求报名参赛]]
function sendGAMEID_REG_MATCH(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GAMEID_REG_MATCH)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(dataTable.gameID)
	--MatchID  比赛ID
	nMBaseMessage:writeInt(dataTable.MatchID)
	--RegType	Byte	报名类型	101 金币 102 荣誉值 103 门票 104 天梯等级 105 VIP 106 兑奖券碎片
	nMBaseMessage:writeByte(dataTable.OptionsCode)
	--TicketID	int	门票ID	0 系统决定使用 其他为门票ID
	nMBaseMessage:writeInt(dataTable.MenPiaoId)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求进入比赛]]
function sendMATID_ENTER_MATCH(matchid)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_ENTER_MATCH)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--MatchInstanceID  比赛实例ID
	nMBaseMessage:writeString(matchid)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
--[[-- 请求玩家报名条件列表]]
function sendMATID_MATCH_CONDITIONS()
	Common.log("报名条件会掉send")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_MATCH_CONDITIONS)

	nMBaseMessage:writeStart()
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 获取本期之星数据]]
function sendMATID_STAR_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_STAR_INFO)

	nMBaseMessage:writeStart()
	--GameID 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求退票]]
function sendMATID_REFUND(type,matchid,matchInstanceID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_REFUND)

	nMBaseMessage:writeStart()
	--RefundType  退票类型
	nMBaseMessage:writeByte(type)
	--MatchID  比赛ID
	nMBaseMessage:writeInt(matchid)
	--MatchInstanceID  比赛实例
	nMBaseMessage:writeString(matchInstanceID)
	Common.log("退赛请求"..matchid.."=="..matchInstanceID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.2.19比赛列表报名人数
function sendMATID_V2_MATCH_LIST_REGCNT(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V2_MATCH_LIST_REGCNT)

	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(dataTable.GameID)
	--MatchID  比赛ID
	nMBaseMessage:writeInt(dataTable.MatchID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--获取比赛中用户列表
--]]
function sendMATID_V28_ALL_USER_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MATID_V28_ALL_USER_LIST)

	nMBaseMessage:writeStart()
	--MatchInstanceID	text	比赛实例ID
	nMBaseMessage:writeString(TableConsole.m_sMatchInstanceID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-----------------------排行榜 消息----------------------]]
-----------------组织RankListGetRankDataBean [00650002]--------------------
function sendRankListGetRankDataBean(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + RankListGetRankDataBean)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 请求的起始位置
	nMBaseMessage:writeInt(dataTable["startCount"])
	--组织 每页显示数目
	nMBaseMessage:writeInt(dataTable["pageSize"])
	--组织 最后一次显示的排名榜，1每日赚金榜2今日充值榜3土豪榜4昨日充值榜，0无
	nMBaseMessage:writeByte(dataTable["lastShowRanking"])
	--组织 请求显示哪一个排名榜，1每日赚金榜2今日充值榜3土豪榜4昨日充值榜，0无
	nMBaseMessage:writeByte(dataTable["requestShowRanking"])
	--组织 上次更新时间
	nMBaseMessage:writeLong(dataTable["lastUpdateTime"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


-----------------组织RankListCheckSelfRankingBean [00650003]--------------------
function sendRankListCheckSelfRankingBean(dateTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + RankListCheckSelfRankingBean)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------打招呼消息-------------------
function sendDBID_V2_SAY_HELLO(userID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_SAY_HELLO)
	nMBaseMessage:writeStart()
	--userid
	nMBaseMessage:writeInt(userID)
	--gameid
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------财神基本信息消息-------------------
function sendFORTUNE_GET_INFORMATION()
	Common.log("发送财神消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + FORTUNE_GET_INFORMATION)
	nMBaseMessage:writeStart()
	--消息体结束
	nMBaseMessage:writeByte(-1)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end




-----------------请求财神领奖时间同步-------------------
function sendFORTUNE_TIME_SYNC()
	Common.log("发送财神时间同步消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + FORTUNE_TIME_SYNC)
	nMBaseMessage:writeStart()
	--消息体结束
	nMBaseMessage:writeByte(-1)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------请求财神领奖-------------------
function sendFORTUNE_GET_AWARD()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + FORTUNE_GET_AWARD)
	nMBaseMessage:writeStart()
	--消息体结束
	nMBaseMessage:writeByte(-1)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------请求财神上香-------------------
function sendFORTUNE_OFFER_SACRIFICE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + FORTUNE_OFFER_SACRIFICE)
	nMBaseMessage:writeStart()
	--消息体结束
	nMBaseMessage:writeByte(-1)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------请求财神通知消息-------------------
function sendFORTUNE_RELEASE_NOTIFICATION()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + FORTUNE_RELEASE_NOTIFICATION)
	nMBaseMessage:writeStart()
	--消息体结束
	nMBaseMessage:writeByte(-1)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------请求删除IMEI下绑定的用户账号-------------------
function sendMANAGERID_DELETE_IMEIUSERS(IMEI,DeleteName)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_DELETE_IMEIUSERS)
	nMBaseMessage:writeStart()
	--IMEI
	nMBaseMessage:writeString(IMEI)
	--DeleteName
	nMBaseMessage:writeString(DeleteName)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
-----------------第二版VIP信息同步-------------------
function sendMANAGERID_GET_VIP_MSG()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_VIP_MSG)
	nMBaseMessage:writeStart()
	--gameid
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()

	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
--[[-- 请求VIP列表_V3(MANAGERID_VIP_LIST_V3)]]
function sendMANAGERID_VIP_LIST_V3(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_VIP_LIST_V3)
	nMBaseMessage:setMsgVer(4)

	nMBaseMessage:writeStart()
	--timestamp  时间戳
	nMBaseMessage:writeLong(time)
	--gameid
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求VIP等级列表(MANAGERID_VIP_LEVEL_LIST)]]
function sendMANAGERID_VIP_LEVEL_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_VIP_LEVEL_LIST)
	nMBaseMessage:writeStart()
	--gameid
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()

	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求天梯排行榜]]
function sendLadder_TOP(start,num)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + LADDER_TOP)

	nMBaseMessage:writeStart()
	--start  开始数
	nMBaseMessage:writeInt(start)
	--count  取出来数
	nMBaseMessage:writeInt(num)
	--gameId  游戏id
	nMBaseMessage:writeInt(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
--领工资
function sendLADDER_SALARY()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + LADDER_SALARY)
	nMBaseMessage:setMsgVer(1)
	nMBaseMessage:writeStart()

	--gameid
	Common.log("天梯领工资1")
	nMBaseMessage:writeInt(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()

	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[----------------活动------------------------]]

--[[--
--请求宝盒V3：获取宝盒进度(BAOHE_V4_GET_PRO)
--]]
function sendBAOHE_V4_GET_PRO(RoomID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BAOHE_V4_GET_PRO)
	nMBaseMessage:setMsgVer(0)
	nMBaseMessage:writeStart()

	--GameId	Byte	游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--RoomID	int	房间ID
	nMBaseMessage:writeInt(RoomID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求宝盒V3：获取宝盒列表(BAOHE_V4_GET_LIST)
--]]
function sendBAOHE_V4_GET_LIST(RoomID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BAOHE_V4_GET_LIST)
	nMBaseMessage:setMsgVer(0)
	nMBaseMessage:writeStart()

	--GameId	Byte	游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--RoomID	int	房间ID
	nMBaseMessage:writeInt(RoomID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求宝盒V3：宝盒领奖(BAOHE_V4_GET_PRIZE)
--]]
function sendBAOHE_V4_GET_PRIZE(RoomID, Position)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BAOHE_V4_GET_PRIZE)
	nMBaseMessage:setMsgVer(0)
	nMBaseMessage:writeStart()

	--GameId	Byte	游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--RoomID	int	房间ID
	nMBaseMessage:writeInt(RoomID)
	--Position	byte	宝盒编号（从左至右0，1，2）
	nMBaseMessage:writeByte(Position)
	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode());

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end



--[[--
--请求活动列表消息
__]]--
function sendOPERID_GET_OPER_TASK_LIST_V2(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_OPER_TASK_LIST_V2)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本号+渠道号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--活动数量
	nMBaseMessage:writeByte(#dataTable)
	for i = 1,#dataTable do
		nMBaseMessage:writeInt(dataTable[i].GameID)
		nMBaseMessage:writeInt(dataTable[i].Version)
	end
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求每日登陆公告消息
--]]--
function sendOPERID_GET_DAILY_NOTIFY_INFO(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_DAILY_NOTIFY_INFO)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本号+渠道号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--时间戳
	nMBaseMessage:writeLong(time)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


-----------------组织GetOperTaskList [00610005]--------------------
function sendOPERID_GET_OPER_TASK_LIST(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_OPER_TASK_LIST)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


-----------------组织OPERID_GODDESS_GET_INFO [00610006]--------------------
function sendOPERID_GODDESS_GET_INFO(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GODDESS_GET_INFO)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------组织OPERID_GODDESS_RESET [00610007]--------------------
function sendOPERID_GODDESS_RESET(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GODDESS_RESET)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------组织OPERID_GODDESS_GET_GIFT [00610008]--------------------
function sendOPERID_GODDESS_GET_GIFT(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GODDESS_GET_GIFT)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	--组织 礼包ID。从1到4。
	nMBaseMessage:writeInt(dataTable["GiftID"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

---------------------福星高照-----------------
-----------------组织OPERID_FXGZ_GET_INFO [00610009]--------------------
function sendOPERID_FXGZ_GET_INFO(dataTable)
	Common.log("发送福星高照信息请求")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_FXGZ_GET_INFO)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end



-----------------组织OPERID_FXGZ_PLAY [0061000a]--------------------
function sendOPERID_FXGZ_PLAY(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_FXGZ_PLAY)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end





--9.1.1获取当前每日任务(DAILYTASKID_CURRENT_TASK)
function sendDAILYTASKID_CURRENT_TASK()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DAILYTASKID_CURRENT_TASK)
	nMBaseMessage:setMsgVer(1)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--9.1.2 五星任务奖励(DAILYTASKID_FIVESTAR_AWARD)
function sendDAILYTASKID_FIVESTAR_AWARD()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DAILYTASKID_FIVESTAR_AWARD)
	nMBaseMessage:setMsgVer(1)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--9.1.3手动刷新任务(DAILYTASKID_REFRESH_TASK)
function sendDAILYTASKID_REFRESH_TASK(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DAILYTASKID_REFRESH_TASK)
	nMBaseMessage:setMsgVer(0)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeByte(dataTable["gameID"])
	--任务ID
	nMBaseMessage:writeInt(dataTable["tasked"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--9.1.4立即完成(DAILYTASKID_COMPLETE_TASK)
function sendDAILYTASKID_COMPLETE_TASK(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DAILYTASKID_COMPLETE_TASK)
	nMBaseMessage:setMsgVer(0)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeByte(dataTable["gameID"])
	--任务ID
	nMBaseMessage:writeInt(dataTable["tasked"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--9.1.5领取奖励(DAILYTASKID_GET_AWARD)
function sendDAILYTASKID_GET_AWARD(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DAILYTASKID_GET_AWARD)
	nMBaseMessage:setMsgVer(1)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeByte(dataTable["gameID"])
	--任务ID
	nMBaseMessage:writeInt(dataTable["tasked"])

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--9.1.6任务状态变化(DAILYTASKID_TASK_STATUS_CHANGE)
function sendDAILYTASKID_TASK_STATUS_CHANGE()
	Common.log("sendDAILYTASKID_TASK_STATUS_CHANGE")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DAILYTASKID_TASK_STATUS_CHANGE)
	nMBaseMessage:setMsgVer(0)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--任务ID
	--	nMBaseMessage:writeInt(dataTable["tasked"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求合成信息]]
function sendMANAGERID_COMPOUND_INFO(lastnum,num)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_COMPOUND_INFO)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--LatestItemID  上次取到的最后一
	nMBaseMessage:writeInt(lastnum)
	--Limit  想取多少条，最多200
	nMBaseMessage:writeShort(num)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--新手任务基本信息
function sendCOMMONS_V3_NEWUSER_TASK_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_V3_NEWUSER_TASK_INFO);
	nMBaseMessage:writeStart();
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--获取新手任务是否完成
function sendCOMMONS_V3_NEWUSER_TASK_IS_COMPLETE()

	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_V3_NEWUSER_TASK_IS_COMPLETE);
	nMBaseMessage:writeStart();
	--GameID 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--请求新手任务奖励
function sendCOMMONS_V3_NEWUSER_TASK_AWARD(TaskNumber)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_V3_NEWUSER_TASK_AWARD);
	nMBaseMessage:writeStart();
	--任务号奖励
	nMBaseMessage:writeInt(TaskNumber);
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--跳过新手引导
function sendCOMMONS_SKIP_NEWUSERGUIDE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_SKIP_NEWUSERGUIDE);
	nMBaseMessage:writeStart();
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete()
end

--同步新手引导状态
function sendCOMMONS_SYN_NEWUSERGUIDE_STATE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_SYN_NEWUSERGUIDE_STATE);
	nMBaseMessage:writeStart();
	--GAME_ID 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--获取新手引导基本信息
function sendCOMMONS_GET_BASEINFO_NEWUSERGUIDE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_GET_BASEINFO_NEWUSERGUIDE);
	nMBaseMessage:writeStart();
	--GAME_ID 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--领取新手引导奖励
function sendCOMMONS_GET_NEWUSERGUIDE_AWARD(TaskType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + COMMONS_GET_NEWUSERGUIDE_AWARD)
	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--任务编号    1注册，2打牌，3兑奖，4领话费
	nMBaseMessage:writeByte(TaskType)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--请求新手引导方案
function sendCOMMONS_GET_NEWUSERGUIDE_SCHEME()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + COMMONS_GET_NEWUSERGUIDE_SCHEME)
	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("新手引导方案，客户端向服务器请求！");
end

--根据URL获取web页面源码
function sendCOMMONS_HTTPPROXY(URL, HashCode, Key)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + COMMONS_HTTPPROXY)
	nMBaseMessage:writeStart()
	--URL	Text	请求页面的URL
	nMBaseMessage:writeString(URL)
	--HashCode	Int	请求页面的hash值
	nMBaseMessage:writeInt(HashCode)
	--Key	string	请求存入本地的key
	nMBaseMessage:writeString(Key)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--3.7.108 查看是否有新公告
function sendMANAGERID_GET_HAVE_NEW_GONGGAO(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_HAVE_NEW_GONGGAO)
	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode	int	游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--time Long 时间戳
	nMBaseMessage:writeLong(time)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.7.109 获取活动网址【V3客户端】
function sendMANAGERID_V3_GET_ACTIVITY_LIST(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_V3_GET_ACTIVITY_LIST)
	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode	int	游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--time Long 时间戳
	nMBaseMessage:writeLong(time)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.7.110 获取每日签到信息
function sendMANAGERID_DAILY_SIGN_V4()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_DAILY_SIGN_V4)
	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.7.111 获取是否有新活动【Lua客户端】
function sendMANAGERID_GET_HAVE_NEW_HUODONG(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_HAVE_NEW_HUODONG)
	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode	int	游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--time Long 时间戳
	nMBaseMessage:writeLong(time)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.7.112 获取可兑奖的奖品列表
function sendMANAGERID_GET_EXCHANGBLE_AWARDS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_EXCHANGBLE_AWARDS)
	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--聊天
function sendLORDID_CHAT_MSG(MatchInstanceID, type, msg)
	Common.log("sendLORDID_CHAT_MSG")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + LORDID_CHAT_MSG)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeString(MatchInstanceID)--比赛失利
	nMBaseMessage:writeInt(0)--userid
	nMBaseMessage:writeByte(type)--类型
	nMBaseMessage:writeString(msg)--消息

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--天梯阶段信息
function sendLADDERID2_LADDER_LEVEL_UP_NOTICE(ladderLevel, oldLadderLevel)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + LADDERID2_LADDER_LEVEL_UP_NOTICE)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--天梯等级
	nMBaseMessage:writeByte(1)
	nMBaseMessage:writeInt(ladderLevel)
	--升级前的天梯等级
	nMBaseMessage:writeByte(2)
	nMBaseMessage:writeInt(oldLadderLevel)
	nMBaseMessage:writeByte(-1)
	Common.log("发送天梯请求"..ladderLevel..oldLadderLevel)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--获取未使用门票数量
function sendMANAGERID_GET_UNUSED_TICKET_CNT()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_UNUSED_TICKET_CNT)
	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------获取跑马灯内容消息------------]]
function sendOPERID_ACTIVITY_MARQUEE(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_ACTIVITY_MARQUEE)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	--组织 表明请求位置
	nMBaseMessage:writeInt(dataTable["position"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------请求现金奖品列表 (OPERID_GET_CASH_AWARD_LIST)------------]]
-----------------组织ActivityMarquee [00610012]--------------------
function sendOPERID_GET_CASH_AWARD_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_CASH_AWARD_LIST)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[---------------3.15.19 请求同步现金限量奖品数量 (OPERID_GET_CASH_AWARD_REMAINDER)------------]]
-----------------组织ActivityMarquee [00610013]--------------------
function sendOPERID_GET_CASH_AWARD_REMAINDER(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_CASH_AWARD_REMAINDER)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--AwardsCnt int
	nMBaseMessage:writeInt(#dataTable)
	--AwardID int 循环
	for i = 1,#dataTable do
		nMBaseMessage:writeInt(dataTable[i])
	end
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.20 请求兑换限量奖品 ------------]]
-----------------组织ActivityMarquee [00610014]--------------------
function sendOPERID_EXCHANGE_LIMITED_AWARD(awardID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_EXCHANGE_LIMITED_AWARD)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeInt(awardID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.29 请求我的奖品中现金奖品列表 ------------]]
-----------------组织ActivityMarquee [0061001D]--------------------
function sendOPERID_GET_CASH_PRIZE_LIST(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_CASH_PRIZE_LIST)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeLong(time)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.30 请求我的奖品中现金奖品列表 ------------]]
-----------------组织ActivityMarquee [0061001E]--------------------
function sendOPERID_PRIZE_EXCHANGE_MOBILE_FARE(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_PRIZE_EXCHANGE_MOBILE_FARE)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeInt(dataTable.PrizeID)
	nMBaseMessage:writeString(dataTable.ContactName)
	nMBaseMessage:writeString(dataTable.TelNumber)
	nMBaseMessage:writeString(dataTable.IDNumber)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.31 请求我的奖品中现金奖品列表 ------------]]
-----------------组织ActivityMarquee [0061001F]--------------------
function sendOPERID_PRIZE_EXCHANGE_GAME_COIN(PrizeID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_PRIZE_EXCHANGE_GAME_COIN)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeInt(PrizeID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.32 闯关赛基本信息 ------------]]
-----------------组织ActivityMarquee [00610020]--------------------
function sendOPERID_CRAZY_STAGE_BASE_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_CRAZY_STAGE_BASE_INFO)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.33 开始闯关消息 ------------]]
-----------------组织ActivityMarquee [00610021]--------------------
function sendOPERID_CRAZY_STAGE_BEGIN()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_CRAZY_STAGE_BEGIN)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.35 闯关领奖消息 ------------]]
-----------------组织ActivityMarquee [00610023]--------------------
function sendOPERID_CRAZY_STAGE_RECEIVE_AWARD()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_CRAZY_STAGE_RECEIVE_AWARD)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.36 闯关复活(OPERID_CRAZY_STAGE_RELIVE) ------------]]
-----------------组织ActivityMarquee [00610024]--------------------
function sendOPERID_CRAZY_STAGE_RELIVE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_CRAZY_STAGE_RELIVE)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeInt(Common.getVersionCode())
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.37 闯关重置消息(OPERID_CRAZY_STAGE_RESET) ------------]]
-----------------组织ActivityMarquee [00610025]--------------------
function sendOPERID_CRAZY_STAGE_RESET()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_CRAZY_STAGE_RESET)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.38 闯关排行榜(OPERID_CRAZY_STAGE_RANK) ------------]]
-----------------组织ActivityMarquee [00610026]--------------------
function sendOPERID_CRAZY_STAGE_RANK(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_CRAZY_STAGE_RANK)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--TimeStamp Long
	nMBaseMessage:writeLong(time)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.39 闯关开始打牌验证消息(OPERID_CRAZY_STAGE_VALIDATE) ------------]]
-----------------组织ActivityMarquee [00610027]--------------------
function sendOPERID_CRAZY_STAGE_VALIDATE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_CRAZY_STAGE_VALIDATE)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-------------3.15.40 闯关昨日获取奖励提示消息(OPERID_CRAZY_STAGE_YESTERDAY_AWARDS) ------------]]
-----------------组织ActivityMarquee [00610028]--------------------
function sendOPERID_CRAZY_STAGE_YESTERDAY_AWARDS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_CRAZY_STAGE_YESTERDAY_AWARDS)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("sendOPERID_CRAZY_STAGE_YESTERDAY_AWARDS")
end

--[[-- 闯关今日排行榜]]
function sendOPERID_CRAZY_STAGE_TODAY_RANK(TimeStamp)
	Common.log("OPERID_CRAZY_STAGE_TODAY_RANK====================")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_CRAZY_STAGE_TODAY_RANK)
	nMBaseMessage:writeStart()
	-- GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	-- TimeStamp	Long	时间戳
	nMBaseMessage:writeLong(TimeStamp)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求牌桌等待提示]]
function sendDBID_V2_WATING_TIPS(time,matchid)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_WATING_TIPS)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(time)
	--MatchID  比赛ID
	nMBaseMessage:writeInt(matchid)
	Common.log("---提示num = ".. matchid..time)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求牌桌踢人]]
function sendROOMID_KICK_OUT_PLAYER(playerID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + ROOMID_KICK_OUT_PLAYER)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--被踢用户ID
	nMBaseMessage:writeInt(playerID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求牌桌举报]]
function sendMANAGERID_PLAYER_REPORT(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_PLAYER_REPORT)
	nMBaseMessage:writeStart()
	--被举报用户ID
	nMBaseMessage:writeInt(dataTable["playerID"])
	--被举报用户昵称
	nMBaseMessage:writeString(dataTable["userName"])
	--比赛实例ID
	nMBaseMessage:writeString(dataTable["matchInstanceID"])
	--举报理由:1：色情头像;2：玩家作弊;3：聊天内容
	nMBaseMessage:writeString(dataTable["reportReason"])
	--举报时间
	nMBaseMessage:writeLong(dataTable["time"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
* 添加ios deviceToken
*
* @param deviceToken串
*
--]]
function sendADD_DEVICE_TOKEN(deviceToken)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + ADD_DEVICE_TOKEN)
	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--被踢用户ID
	nMBaseMessage:writeString(deviceToken)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
上传错误信息
--]]
function sendSTATID_COMMIT_EXCEPTION_INFO(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + STATID_COMMIT_EXCEPTION_INFO)
	nMBaseMessage:writeStart()
	--UserID 用户ID int
	nMBaseMessage:writeInt(dataTable["userId"])
	--ExceptionInfo 错误信息 String
	nMBaseMessage:writeString(dataTable["userId"] .. "-" .. Common.getVersionName() .. "-" .. Common.getChannelID() .. "-" .. dataTable["exceptionInfo"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("sendSTATID_COMMIT_EXCEPTION_INFO");
end

---------[[-- 月签  ---]]-------
-----------------月签[25天版]MONTH_SIGN_REWARD_LIST [00610017]--------------------
function sendMONTH_SIGN_REWARD_LIST(timeStamp)
	Common.log("发送月签[25天版]消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MONTH_SIGN_REWARD_LIST)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--时间戳 timeStamp
	nMBaseMessage:writeLong(timeStamp)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------用户月签基本信息USERS_MONTH_SIGN_BASIC_INFO [00610018]--------------------
function sendUSERS_MONTH_SIGN_BASIC_INFO(userId)
	Common.log("发送用户月签基本信息消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + USERS_MONTH_SIGN_BASIC_INFO)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--UserID
	nMBaseMessage:writeInt(userId)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------月签签到SIGN_TO_MONTH_SIGN [00610019]--------------------
function sendSIGN_TO_MONTH_SIGN()
	Common.log("发送月签签到消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + SIGN_TO_MONTH_SIGN)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

----幸运转盘-----
-----------------转盘基本信息(TURNTABLE_BASIC_INFO)[00610015]--------------------
function sendTURNTABLE_BASIC_INFO(timeStamp)
	Common.log("发送幸运转盘消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + TURNTABLE_BASIC_INFO)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--时间戳 timeStamp
	nMBaseMessage:writeLong(timeStamp)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------转盘抽奖信息(TURNTABLE_LOTTERY_INFO)[00610016]--------------------
function sendTURNTABLE_LOTTERY_INFO(lotteryType)
	Common.log("发送幸运转盘抽奖消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + TURNTABLE_LOTTERY_INFO)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--抽奖类型 0免费抽奖 1消耗金币 2消耗元宝
	nMBaseMessage:writeByte(lotteryType)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
-- 用户统计消息
--]]
function sendSTAID_COMMIT_ACTIVITY_STAY(stayTime)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + STAID_COMMIT_ACTIVITY_STAY)
	nMBaseMessage:writeStart()

	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	--活动数量
	nMBaseMessage:writeByte(1)
	--用户活动ID
	nMBaseMessage:writeShort(GameConfig.STAY_TIME)
	-- ...EnterTime	Long	进入时间戳	毫秒
	nMBaseMessage:writeLong(GameConfig.enterGameTime*1000)
	-- ...StayTime	Short	停留时间	秒
	nMBaseMessage:writeShort(stayTime)
	Common.log("用户停留时间======="..stayTime)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--获取大厅公告
--]]
function sendMANAGERID_GET_SYSTEM_LIST_NOTICE()
	Common.log("发送获取大厅公告消息");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_SYSTEM_LIST_NOTICE)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--获取大厅按钮状态
--]]
function sendMANAGERID_GET_BUTTONS_STATUS()
	Common.log("发送获取大厅按钮状态");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_BUTTONS_STATUS)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------[[----小游戏----万人金花--------]]-------------
--【万人金花房间消息】--
-- 万人金花进入房间消息(服务器不回万人金花进入房间消息,直接推送万人金花牌桌同步消息)
function sendJHROOMID_MINI_JINHUA_ENTER_GAME()
	Common.log("发送万人金花进入房间消息");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHROOMID_MINI_JINHUA_ENTER_GAME)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()

	--     游戏ID(万人金花不发GAME_ID默认是3,进入扎金花)
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-- 万人金花退出房间消息(服务器不回万人金花退出房间消息)
function sendJHROOMID_MINI_JINHUA_QUIT_GAME()

	Common.log("发送万人金花退出房间消息");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHROOMID_MINI_JINHUA_QUIT_GAME)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()

	-- 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()

end

--【扎金花牌桌消息】--
--请求牌桌同步
function sendJHID_TABLE_SYNC()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_TABLE_SYNC)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--准备
function sendJHID_READY_REQ()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_READY)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--看牌
function sendJHID_LOOK_CARDS_REQ()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_LOOK_CARDS)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--弃牌
function sendJHID_DISCARD_REQ()
	Common.log("发送弃牌消息")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_DISCARD)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--下注、押注
function sendJHID_BET_REQ(betCoin, betType)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_BET)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	--    下注额度
	nMBaseMessage:writeInt(betCoin)
	--	下注类型
	nMBaseMessage:writeByte(betType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("下注===================betCon====="..betCoin.."   betType========"..betType)
end

--比牌
function sendJHID_PK_REQ(SSID)
	Common.log("比牌发送：sendJHID_PK_REQ")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_PK)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	--  座位号
	nMBaseMessage:writeInt(SSID)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--开牌
function sendJHID_SHOW_CARDS_REQ()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_SHOW_CARDS)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--换牌
function sendJHID_CHANGE_CARD_REQ(cardValue)
	Common.log("sendJHID_CHANGE_CARD_REQ+++++++++++++")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_CHANGE_CARD)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeByte(cardValue)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--聊天
function sendJHID_CHAT_REQ(type,msg)
	Common.log("sendJHID_CHAT_REQ")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_CHAT)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeByte(type)
	nMBaseMessage:writeUTF(msg)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-- 禁比
function sendJHID_NO_COMPARE_REQ()
	Common.log("sendJHID_NO_COMPARE_REQ+++++++++++++++")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_NO_COMPARE)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--【金花房间消息】--
--坐下
function sendJHID_SIT_DOWN(roomId,tableId,seatId)
	Common.log("发送坐下")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_SIT_DOWN)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeInt(roomId)
	nMBaseMessage:writeInt(tableId)
	nMBaseMessage:writeInt(seatId)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--站起
function sendJHID_STAND_UP()
	Common.log("发送站起")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_STAND_UP)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--退出房间
function sendJHID_QUIT_TABLE(roomId,tableId)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_QUIT_TABLE)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeInt(roomId)
	nMBaseMessage:writeInt(tableId)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--快速开始
function sendJHID_QUICK_START_REQ()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_QUICK_START)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeByte(JinHuaTableConfig.JinHuaVerCode)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--换桌
function sendJHID_CHANGE_TABLE_REQ()
	Common.log("发送换桌+++++++++++++++++++++")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_CHANGE_TABLE)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--进入房间
function sendJHID_ENTER_ROOM(roomId)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHID_ENTER_ROOM)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeInt(roomId)
	Common.log("发送进入房间请求id=="..roomId)
	nMBaseMessage:writeInt(-1)
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeByte(JinHuaTableConfig.JinHuaVerCode)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--【万人金花牌桌消息】--
-- 万人金花下注
function sendJHGAMEID_MINI_JINHUA_BET(round, index, coinNum, tag)
	Common.log("发送万人金花下注消息");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHGAMEID_MINI_JINHUA_BET)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()

	--轮数
	nMBaseMessage:writeInt(round)
	--位置， 1， 2， 3， 4
	nMBaseMessage:writeByte(index)
	--押注金币
	nMBaseMessage:writeInt(coinNum)
	--金币tag
	nMBaseMessage:writeInt(tag)

	-- GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-- 万人金花输赢历史消息
function sendJHGAMEID_MINI_JINHUA_HISTORY()
	Common.log("发送万人金花输赢历史消息");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHGAMEID_MINI_JINHUA_HISTORY)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-- 万人金花帮助消息
function sendJHGAMEID_MINI_JINHUA_HELP()
	Common.log("发送万人金花帮助消息");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JHGAMEID_MINI_JINHUA_HELP)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求站内信消息领奖列表]]
function sendMAIL_SYSTEM_MESSAGE_RECEIVE_AWARD(MessageId)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MAIL_SYSTEM_MESSAGE_RECEIVE_AWARD)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--消息id
	nMBaseMessage:writeInt(MessageId)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求站内信消息列表]]
function sendMAIL_SYSTEM_MESSGE_LIST(LastMessageId,Count)
	Common.log("Client2Server")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MAIL_SYSTEM_MESSGE_LIST)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--上条消息id
	nMBaseMessage:writeInt(LastMessageId)
	--列表数量
	nMBaseMessage:writeInt(Count)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("Client2Server1")
end

--站内信消息阅读
function sendMAIL_SYSTEM_MESSAGE_READ(MessageId)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MAIL_SYSTEM_MESSAGE_READ)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--上条消息id
	nMBaseMessage:writeInt(MessageId)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
--退出弹框引导
--@param #String ClientInstallGameList 已经安装的游戏ID的拼接字符串,英文逗号隔开
--]]
function sendMANAGERID_QUIT_GUIDE(ClientInstallGameList)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_QUIT_GUIDE)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--玩家手机已经安装的同趣游戏ID列表,英文逗号隔开
	nMBaseMessage:writeString(ClientInstallGameList);


	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("发送 sendMANAGERID_QUIT_GUIDE");
end

--[[免费金币]]--
function sendOPERID_FREE_COIN()
	Common.log("发送免费金币消息");

	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_FREE_COIN);
	nMBaseMessage:setExtData(3);
	nMBaseMessage:writeStart();

	-- GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--渠道号
	nMBaseMessage:writeString("" .. Common.getChannelID());

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[领取游戏分享奖励]]--
function sendOPERID_REQUEST_GAME_SHARING_REWARD()
	Common.log("领取游戏分享奖励");
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_REQUEST_GAME_SHARING_REWARD);
	nMBaseMessage:writeStart();

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[请求游戏分享累计奖励]]--
function sendOPERID_GAME_SHARING_ALL_REWARD()
	Common.log("请求游戏分享累计奖励");
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_GAME_SHARING_ALL_REWARD);
	nMBaseMessage:writeStart();

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[宝盒V4新手预读奖励]]--
function sendOPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD()
	Common.log("发送宝盒V4新手预读奖励");

	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD);
	nMBaseMessage:setExtData(3);
	nMBaseMessage:writeStart();

	-- GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

-----------------万人水果机(WRSGJ_INFO)[80530014]--------------------
function sendWRSGJ_INFO(timeStamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + WRSGJ_INFO)
	--消息版本号
	nMBaseMessage:setMsgVer(0)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--时间戳 timeStamp
	nMBaseMessage:writeLong(timeStamp)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


-------------------万人水果机同步消息(WRSGJ_SYNC_MESSAGE)----------------------------
function sendWRSGJ_SYNC_MESSAGE(hasSendResult,timestamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + WRSGJ_SYNC_MESSAGE)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--是否推送过 0 , 1
	nMBaseMessage:writeByte(hasSendResult)
	--上一局前三名下注的时间戳
	nMBaseMessage:writeLong(timestamp)
	nMBaseMessage:writeLong(os.time())
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------万人水果机公告(WRSGJ_NOTICE）----------------------------------------
function sendWRSGJ_NOTICE(num )
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + WRSGJ_NOTICE)
	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--Limit  想取多少条，最多200
	nMBaseMessage:writeShort(num)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-------------------万人水果机押注( WRSGJ_BET ）----------------------------
function sendWRSGJ_BET( index,num )
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + WRSGJ_BET)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--类型
	nMBaseMessage:writeByte(index)
	--押注金额
	nMBaseMessage:writeInt(num)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-------------VIP(大厅)提示信息-------------
function sendMANAGERID_VIPV2_TIP_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_VIPV2_TIP_INFO)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-------------VIP(大厅)获取vip开通礼包-------------
function sendMANAGERID_VIPV2_GET_GIFTBAG(type,price)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_VIPV2_GET_GIFTBAG)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--礼包类型
	nMBaseMessage:writeByte(type)
	--请求礼包金额
	nMBaseMessage:writeInt(price)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
------------------------------------------------------------------
--[[------------------------斗地主大厅请求红点消息----------------------- ]]
------------------------------------------------------------------
function sendMANAGERID_REQUEST_REDP(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_REQUEST_REDP)
	nMBaseMessage:writeStart()
	--GAME ID
	--Common.log("sendMANAGERID_REQUEST_REDP ")
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GAME VersionCode
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--Loop
	nMBaseMessage:writeInt(#dataTable)
	for i = 1,#dataTable do
		--Common.log("sendMANAGERID_REQUEST_REDP ")
		nMBaseMessage:writeInt(dataTable[i]["RedPointId"])
	end
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------------------------------------------------------
--[[------------------------斗地主大厅删除红点消息----------------------- ]]
------------------------------------------------------------------
function sendMANAGERID_REMOVE_REDP(ModuleId, taskId)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_REMOVE_REDP)
	nMBaseMessage:writeStart()
	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GAME VersionCode
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	Common.log(ModuleId.."sendMANAGERID_REMOVE_REDP")
	Common.log(taskId.."sendMANAGERID_REMOVE_REDP")
	--loop
	nMBaseMessage:writeInt(ModuleId)
	nMBaseMessage:writeInt(taskId)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--分享V2分享下载地址预读
--]]
function sendOPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL()
	if Services:getMessageService():getCutOut() then
		return;
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL);
	nMBaseMessage:writeStart();
	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode());
	--渠道号
	nMBaseMessage:writeString("" .. Common.getChannelID());

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--分享V2 IOS是否可以填写好友ID
--]]
function sendOPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND()
	if Services:getMessageService():getCutOut() then
		return;
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND);
	nMBaseMessage:writeStart();
	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode());
	--渠道号
	nMBaseMessage:writeString("" .. Common.getChannelID());

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--分享V2 IOS绑定好友关系
--@param #String OldFriendID 邀请人用户ID
--]]
function sendOPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND(OldFriendID)
	if Services:getMessageService():getCutOut() then
		return;
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND);
	nMBaseMessage:writeStart();
	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode());
	--渠道号
	nMBaseMessage:writeString("" .. Common.getChannelID());
	--邀请人用户ID
	nMBaseMessage:writeInt(OldFriendID);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--XY平台新用户礼包兑换
--@param #String CDKEY 礼包兑换码
--]]
function sendOPERID_XYPLATFORM_GIFTBAG_EXCHANGE(CDKEY)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_XYPLATFORM_GIFTBAG_EXCHANGE)
	nMBaseMessage:writeStart()

	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--礼包兑换码
	nMBaseMessage:writeString(CDKEY)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--分享奖励说明
--]]
function sendOPERID_SHARING_REWARD_DESCRIPTION()
	Common.log("sendOPERID_SHARING_REWARD_DESCRIPTION 请求分享奖励说明");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_SHARING_REWARD_DESCRIPTION)
	nMBaseMessage:writeStart()

	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------------------------------------------------------
--[[------------------------推送通知消息----------------------- ]]
------------------------------------------------------------------
function sendNOTIFICATION_PUSH_LIST_V2()
	if Services:getMessageService():getCutOut() then
		return
	end
	Common.log("sendNOTIFICATION_PUSH_LIST_V2")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + NOTIFICATION_PUSH_LIST_V2)
	nMBaseMessage:writeStart()

	--AppVersionCode Int 平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode())

	--平台
	if Common.platform == Common.TargetIos then
		-- iOS平台
		nMBaseMessage:writeByte(5)
	elseif Common.platform == Common.TargetAndroid then
		--Android
		nMBaseMessage:writeByte(4)
	else
		nMBaseMessage:writeByte(4)
	end
	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--时间戳
	--TimeStamp  时间戳

	nMBaseMessage:writeLong(0)

	--	Common.log("NOTIFICATION_PUSH_LIST_V2"..Common.LoadShareTable("AndroidPushMessage")["TimeStamp"])
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------------------------------------------------------
--[[---------------------备选奖品领奖-------------------------- ]]
------------------------------------------------------------------
function sendGET_ALTERNATIVE_PRIZE_V2(PrizeID, ItemType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GET_ALTERNATIVE_PRIZE_V2)
	nMBaseMessage:writeStart()
	Common.log("备选奖品领奖")
	nMBaseMessage:writeInt(PrizeID)
	Common.log("备选奖品领奖"..PrizeID)
	nMBaseMessage:writeByte(ItemType)
	Common.log("备选奖品领奖"..ItemType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
------------------------------------------------------------------
--[[---------------------手机卡兑奖-------------------------- ]]
------------------------------------------------------------------
function sendRechargeable_Card_AWARD_V2(PrizeId, Name, PhoneNumber)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + Rechargeable_Card_AWARD_V2)
	nMBaseMessage:writeStart()
	Common.log("手机卡兑奖")
	nMBaseMessage:writeInt(PrizeId)
	Common.log("手机卡兑奖"..PrizeId)
	nMBaseMessage:writeString(Name)
	Common.log("手机卡兑奖"..Name)
	nMBaseMessage:writeString(PhoneNumber)
	Common.log("手机卡兑奖"..PhoneNumber)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------------------------------------------------------
--[[---------------------病毒传播-------------------------- ]]
------------------------------------------------------------------

--请求红包分享V3基本信息
function sendOPERID_SHARING_V3_BASE_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_SHARING_V3_BASE_INFO)
	nMBaseMessage:writeStart()

	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--verCode Int 版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	--RegChannelID text  注册渠道号
	nMBaseMessage:writeString(""..Common.getChannelID())
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--新玩家首次领取红包V3奖励
function sendOPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD)
	nMBaseMessage:writeStart()

	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--verCode Int 版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--红包V3新玩家首次分享
function sendOPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD)
	nMBaseMessage:writeStart()

	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--verCode Int 版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--扎金花房间列表
--]]--
function sendJINHUA_ROOMID_ROOM_LIST(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()

	Common.log("请求扎金花房间列表")
	nMBaseMessage:setMessageType(REQ + JINHUA_ROOMID_ROOM_LIST)
	nMBaseMessage:setExtData(3)
	nMBaseMessage:writeStart()
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(time)
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	nMBaseMessage:writeInt(JinHuaTableConfig.getJinHuaVerCode());

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--扎金花进入大厅消息(用作数据统计)
--]]--
function sendJHID_ENTER_JH_MINI()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()

	Common.log("请求扎金花进入大厅")
	nMBaseMessage:setMessageType(REQ + JHID_ENTER_JH_MINI)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeByte(GameConfig.GAME_ID);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--扎金花退出大厅消息(用作数据统计)
--]]--
function sendJHID_QUIT_JH_MINI()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()

	Common.log("请求扎金花退出大厅")
	nMBaseMessage:setMessageType(REQ + JHID_QUIT_JH_MINI)
	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--内置炸金花用户信息消息
--]]--
function sendMANAGERID_JINHUA_USERINFO(userID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()

	Common.log("请求内置炸金花用户信息消息")
	nMBaseMessage:setMessageType(REQ + MANAGERID_JINHUA_USERINFO)
	nMBaseMessage:writeStart()

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	nMBaseMessage:writeInt(userID);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--小游戏列表状态消息(支持单个功能的脚本更新)
--]]--
function sendMANAGERID_MINIGAME_LIST_TYPE_V2(MiniGameTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()

	Common.log("小游戏列表状态消息(支持单个功能的脚本更新)")
	nMBaseMessage:setMessageType(REQ + MANAGERID_MINIGAME_LIST_TYPE_V2)
	nMBaseMessage:writeStart()

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--AppVersionCode	Int	平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--小游戏数量
	nMBaseMessage:writeByte(#MiniGameTable)
	for i = 1, #MiniGameTable do
		--小游戏ID
		nMBaseMessage:writeInt(MiniGameTable[i].GameID)
		--小游戏版本 从1开始
		nMBaseMessage:writeInt(MiniGameTable[i].Version)
	end

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[--
--天梯帮助
--]]--
function sendLadder_MSG_HELP(MiniGameTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()

	nMBaseMessage:setMessageType(REQ + Ladder_MSG_HELP)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[新手引导开关]]--
function sendCOMMONS_GET_NEWUSERGUIDE_IS_OPEN()

	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_GET_NEWUSERGUIDE_IS_OPEN);
	nMBaseMessage:writeStart();
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--AppVersionCode Int 平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode()+ Common.getChannelID())
	Common.log("sendCOMMONS_GET_NEWUSERGUIDE_IS_OPENverson"..Common.getVersionCode().."chanelid"..Common.getChannelID())
	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--请求充值榜新手引导文字
--]]--
function sendCOMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG(type)
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG);
	nMBaseMessage:writeStart();

	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--AppVersionCode Int 平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode()+ Common.getChannelID())
	--RequireType	Byte	请求引导信息类型	1：首次进入引导提示 2：排名掉落引导提示
	nMBaseMessage:writeByte(type)
	nMBaseMessage:writeOver();

	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--请求充值榜鼓励描述
--]]--
function sendCOMMONS_GET_RECHARGE_ENCOURAGE_MSG()
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_GET_RECHARGE_ENCOURAGE_MSG);
	nMBaseMessage:writeStart();

	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--AppVersionCode Int 平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode()+ Common.getChannelID())
	nMBaseMessage:writeOver();

	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--请求整蛊派对排行榜
--]]--
function sendTRICKYPARTY_RANK_LIST(gameNumber)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + TRICKYPARTY_RANK_LIST)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeInt(GameConfig.GAME_ID)
	--游戏号
	nMBaseMessage:writeInt(gameNumber)
	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[大厅走马灯小游戏获奖信息]]--
function sendMINI_COMMON_WINNING_RECORD(TimeStamp)
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MINI_COMMON_WINNING_RECORD);
	nMBaseMessage:writeStart();
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--TimeStamp  时间戳
	Common.log("MINI_COMMON_WINNING_RECORD_send"..TimeStamp)
	nMBaseMessage:writeLong(TimeStamp)
	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end
--[[大厅走马灯小游戏获奖信息]]--
function sendMINI_COMMON_RECOMMEND()
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MINI_COMMON_RECOMMEND);
	nMBaseMessage:writeStart();
	--GameID  游戏ID
	Common.log("sendMINI_COMMON_RECOMMEND")
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--比赛详情
--]]--
function sendMATID_V4_MATCHDETAIL(TimeStamp,Vip,matchID)
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MATID_V4_MATCHDETAIL);
	nMBaseMessage:writeStart();
	--TimeStamp
	Common.log("sendMATID_V4_MATCHDETAIL")
	nMBaseMessage:writeLong(TimeStamp)
	nMBaseMessage:writeInt(Vip)
	nMBaseMessage:writeInt(matchID)
	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--比赛详情
--]]--
function sendMATID_V4_AWARDS(TimeStamp,matchID)
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MATID_V4_AWARDS);
	nMBaseMessage:writeStart();
	--TimeStamp
	Common.log("sendMATID_V4_AWARDS")
	nMBaseMessage:writeLong(TimeStamp)
	nMBaseMessage:writeInt(matchID)
	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end
