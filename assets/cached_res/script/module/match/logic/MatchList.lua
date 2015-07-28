module("MatchList",package.seeall)

--比赛模式
ROOM_ITEM_MATCHMIANFEI = 0 --免费赢奖
ROOM_ITEM_MATCHTIANTI = 1 --天梯专区

theCurrentItemID = -1 --当前显示的比赛标签(为了比赛列表同步时不会播放动画)

--比赛列表部分
MatchTable = {}
MatchTable["MatchList"] = {}

MatchItem = {} --比赛控件
itemLiMenuWidth = 0 --setting 离 menu的距离
MatchItemLayout = {} --比赛控件layout
MatchJiangbeiTable = {}
MatchTitleTable = {}
MatchSpecilImage = {}
local showrooms = {}

--比赛时钟队列
local MatchalarmClock = {}
MatchalarmClock.userid = 0

--[[--
--获取比赛闹钟队列
--]]
function getMatchalarmClock()
	return MatchalarmClock
end

function initMatchColock()
	if(MatchalarmClock.userid ~= profile.User.getSelfUserID())then
		CCDirector:sharedDirector():getRunningScene():stopActionByTag(1001)
		local alarmHistoryTable = Common.LoadTable(profile.User.getSelfUserID().."AlarmQueue")
		if(alarmHistoryTable)then
			MatchalarmClock = {}
			table.foreach(alarmHistoryTable, function(i, v)
				if(tonumber(i) > 0)then
					table.insert(MatchalarmClock,v)
				else
					MatchalarmClock[i] = v
				end
			end
			)
			--除掉过期的比赛
			for i = #MatchalarmClock,1,-1 do
				if(MatchalarmClock[i].startTime < Common.getServerTime())then
					table.remove(MatchalarmClock,i)
				else
					MatchalarmClock[i].time = MatchalarmClock[i].startTime - Common.getServerTime()
				end
			end

		else
			MatchalarmClock = {}
			MatchalarmClock.userid = profile.User.getSelfUserID()
		end

		local array = CCArray:create()
		array:addObject(CCDelayTime:create(1))
		array:addObject(CCCallFuncN:create(matchAlarmClockCallBack))
		seq = CCSequence:create(array)
		local callback = CCRepeatForever:create(seq)
		callback:setTag(1001)
		CCDirector:sharedDirector():getRunningScene():runAction(callback)
	end
end

--[[--
--创建比赛闹钟类型 time为int 秒
--]]
function createAlarmClockTable(MatchID, time, MatchTitle, MatchInstanceID, needConCnt, nStartTimeLong, nRegStatus)
	local itemTable = {}
	itemTable.MatchID = MatchID
	itemTable.time = time
	itemTable.startTime = Common.getServerTime() + time
	itemTable.MatchTitle = MatchTitle
	itemTable.MatchInstanceID = MatchInstanceID
	itemTable.needConCnt = needConCnt
	itemTable.startTimeLong = nStartTimeLong
	itemTable.regStatus = nRegStatus

	return itemTable
end

--[[--
--比赛闹钟回调函数
--]]
function matchAlarmClockCallBack()
	if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
		HallLogic.logicSendCommonMsgTime();
	end

	if #MatchalarmClock > 0 then
		for i = 1, #MatchalarmClock do
			if MatchalarmClock[i] == nil then
				Common.log("MatchalarmClock["..i.."] == nil")
				return;
			end

			if MatchalarmClock[i].regStatus == 0 then
				-- 该比赛已经被退赛（自动退赛）
				removeAlarmQueue(MatchalarmClock[i].MatchID)
				return;
			end

			if MatchalarmClock[i].startTimeLong == nil then
				return;
			end

			local countDownCnt = math.modf((MatchalarmClock[i].startTimeLong - Common.getServerTime()*1000)/1000) -- 动态计算倒计时
			countDownCnt = countDownCnt - 1
			Common.log("countDownCnt = "..countDownCnt)
			Common.log("#MatchalarmClock = "..#MatchalarmClock)

			if (countDownCnt == 300) then
				-- 还有5分钟开赛时
				-- 弹toast提醒
				local strTip = "您报名的" .."\"" .. MatchalarmClock[i].MatchTitle .. "\"" .. "将在5分钟后开始"
				Common.showToast(strTip, 2)
			elseif countDownCnt == 120 then
				-- 还有2分钟开赛时
				if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
					if TableConsole.mode == TableConsole.MATCH then
					--弹框让用户选择继续比赛，还是参加新比赛
					--						matchjijiangkaisaiLogic.leftCallbackFunction = function()
					--							mvcEngine.destroyModule(GUI_MATCH_JIJIANGKAISHI)
					--
					--							sendMATID_V4_CHOOSE(TableConsole.m_sMatchInstanceID, 1) -- 1：退出当前比赛进入新比赛
					--							if TableNotEndedLogic.view ~= nil then
					--								-- 如果此时是在等待分桌，则直接退出牌桌
					--								TableLogic.exitLordTable()
					--								return
					--							end
					--							TableConsole.bShouldExitCurrentMatch = true
					--							Common.showToast("为了参赛，请在2分钟内完成本局游戏", 2)
					--						end
					--						matchjijiangkaisaiLogic.rightCallbackFunction = function()
					--							mvcEngine.destroyModule(GUI_MATCH_JIJIANGKAISHI)
					--						end
					--
					--						matchjijiangkaisaiLogic.tableMode = 1
					--						matchjijiangkaisaiLogic.strTitleTips = "另一场【"..MatchalarmClock[i].MatchTitle.."】比赛, 将在2分钟后开始, 是否参加？"
					--						mvcEngine.createModule(GUI_MATCH_JIJIANGKAISHI)
					elseif TableConsole.mode == TableConsole.ROOM then
						if TableConsole.isPlayingDoudizhu() then
							local strTip = "您报名的" .."\"" .. MatchalarmClock[i].MatchTitle .. "\"" .. "将在2分钟后开始"
							Common.showToast(strTip, 2)
						else
							-- 退出房间
							TableConsole.bShouldShowJijiangkaisai = true
							TableConsole.tJijiangkaisaiMatchItem = MatchalarmClock[i]
							TableLogic.exitLordTable()
						end
					end
				end
			elseif countDownCnt == 60 then
				-- 还有1分钟开赛
				local userCurCoin = profile.User.getSelfCoin()
				local needConCnt = MatchalarmClock[i].needConCnt
				if tonumber(userCurCoin) < tonumber(needConCnt) then
					-- 用户金币不足比赛入场金币时
					local strTip = "您报名的" .."\"" .. MatchalarmClock[i].MatchTitle .. "\"" .. "将在1分钟后开始".."入场金币需要"..needConCnt.."但是您目前金币不足，请充值"
					mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
					SystemPromptDialogLogic.matchNeedCoin = needConCnt
					SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().RECHARGE_FOR_MATCH, nil, strTip);
				end
			elseif countDownCnt <= 0 then
				TableConsole.msMatchTitle = MatchalarmClock[i].MatchTitle;
				removeAlarmQueue(MatchalarmClock[i].MatchID)
			end
		end
	end
end

--[[--
--点击比赛ITEM V4
--]]
local function onClickMatch(matchInfo, showrooms)

	if matchInfo == nil then
		Common.log("matchInfo = nil")
		return
	end

	if showrooms == nil then
		Common.log("showrooms = nil")
		return
	end

	MatchDetailLogic.setNowEntrance(1)
	MatchDetailLogic.setDetailWithMatchItem_V4(matchInfo)
	mvcEngine.createModule(GUI_MATCHDETAIL)
	sendMATID_V4_MATCHDETAIL(profile.GameDoc.loadmatchDetailsTable(profile.User.getSelfVipLevel(),matchInfo.MatchID),profile.User.getSelfVipLevel(),matchInfo.MatchID)
	sendMATID_V4_AWARDS(profile.GameDoc.loadmatchAwardsDetailsTable(matchInfo.MatchID),matchInfo.MatchID)
	Common.log("zblaaaaa      send_matchid = " .. matchInfo.MatchID)


	MatchDetailLogic.setDetailWithMatchItem_V4(matchInfo)
	mvcEngine.createModule(GUI_MATCHDETAIL)
end

function initMatchListData(matchScrollView)
	if matchScrollView ~= nil then
		matchScrollView:removeAllChildren();
	end

	MatchItem = {};
	MatchJiangbeiTable = {};
	MatchTitleTable = {};
	MatchSpecilImage = {};
	MatchItemLayout = {};
end

--[[--
--更新比赛图片的图片
--MatchJiangbeiTable  MatchTitleTable
--]]
local function updataMatchJiangbeiGooods(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]

	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and MatchJiangbeiTable[""..id] ~= nil then
		local matchItem = showrooms[tonumber(id)]
		matchItem.localPrizeImgUrl = photoPath -- 奖杯本地图片地址存储一下，方便比赛详情时再使用

		MatchJiangbeiTable[""..id]:loadTexture(photoPath)
	end
end

--[[--
--更新比赛左上角图片
--]]
local function updataMatchSpecialImage(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]

	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and MatchSpecilImage[""..id] ~= nil then
		Common.log("updataMatchSpecialImage id = "..tonumber(id))
		MatchSpecilImage[""..id]:loadTexture(photoPath)
	end
end

--[[--
--更新比赛标题的图片
--]]
local function updataMatchTitleGooods(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and MatchTitleTable[""..id] ~= nil then
		MatchTitleTable[""..id]:loadTexture(photoPath)
	end
end

--[[--
--显示比赛列表
--]]
function showMatchList(itemID, matchScrollView, isOpenSelectMatchInfo, openMatchName)
	if matchScrollView == nil then
		return;
	end
	initMatchListData(matchScrollView);

	local isShowListAnim = true;--是否显示列表动画

	if theCurrentItemID == itemID then
		isShowListAnim = false;
	else
		isShowListAnim = true;
	end

	theCurrentItemID = itemID;

	--加载比赛列表
	--table     0标准 1欢乐玩法 2癞子玩法
	--itemID    0癞子 1  欢乐 2  普通
	local cellSize = 0
	if MatchTable["MatchList"] ~= nil then
		cellSize = #MatchTable["MatchList"]
	end
	if(cellSize == 0 )then
		Common.showProgressDialog("数据加载中,请稍后...")
		return;
	end

	local roomlength = 0
	for x = 1, cellSize do
		if itemID == ROOM_ITEM_MATCHTIANTI and MatchTable["MatchList"][x].MatchTag == 2 then
			--天梯
			roomlength = roomlength + 1
			showrooms[roomlength] = {}
			showrooms[roomlength] = MatchTable["MatchList"][x]
		elseif itemID == ROOM_ITEM_MATCHMIANFEI and MatchTable["MatchList"][x].MatchTag == 1 then
			--免费赢奖
			roomlength = roomlength + 1
			showrooms[roomlength] = {}
			showrooms[roomlength] = MatchTable["MatchList"][x]
		end
	end

	Common.log("比赛列表"..cellSize.."=="..#showrooms.."=="..itemID)
	Common.log("roomlength = "..roomlength)

	local viewW = 0
	local viewH = 422;
	local viewX = 36
	local viewY = 49;
	local viewWMax = 1057;
	local cellWidth = 261; --每个元素的宽
	local cellHeight = 360; --每个元素的高
	local hangSize = 1

	local cellTime = 100
	local lieSize = roomlength
	local spacingW = 8; --横向间隔
	local spacingH = 0 --纵向间隔

	if lieSize * cellWidth + spacingW * (lieSize - 1) > viewWMax then
		viewW = lieSize * cellWidth + spacingW * (lieSize - 1)+20
	else
		viewW = viewWMax + 21--设置的显示区域必须比真实区域小
	end

	Common.log("viewX = "..viewX)
	Common.log("viewY = "..viewY)

	matchScrollView:setSize(CCSizeMake(viewWMax, viewH))
	matchScrollView:setInnerContainerSize(CCSizeMake(viewW, viewH))
	matchScrollView:setPosition(ccp(viewX, viewY))
	matchScrollView:setAnchorPoint(ccp(0, 0))
	matchScrollView:setColor(ccc3(255,195,118))
	--适配需要：对列表进行缩放横坐标和纵坐标的缩放
	matchScrollView:setScaleX(GameConfig.ScaleAbscissa);
	matchScrollView:setScaleY(GameConfig.ScaleOrdinate);

	local OffsetX = 0 --横向向位移，用于对齐scrol-lView左侧
	if viewWMax > lieSize * cellWidth + spacingW * (lieSize - 1) then
		OffsetX = lieSize * cellWidth + spacingW * (lieSize - 1) - viewWMax;
	end

	for i = 0, roomlength - 1 do
		local matchInfo = showrooms[i + 1];
		local RoomName = matchInfo.MatchTitle
		local matchStartTimeTag = matchInfo.matchStartTimeTag --定点开赛的开赛时间描述
		if matchStartTimeTag == nil then
			matchStartTimeTag = ""
		end
		local MatchID = matchInfo.MatchID
		local MatchType = matchInfo.MatchType --比赛类型0区间赛 1即时赛2 定点赛（周赛）4 定局赛（3人、6人赛）6 月赛7 闯关赛
		local ConditionText = matchInfo.ConditionText --报名条件
		local TitlePictureUrl = matchInfo.TitlePictureUrl
		local PrizeImgUrl = matchInfo.PrizeImgUrl
		local specialLabelImgUrl = matchInfo.specialLabelURL

		local playerCnt = matchInfo.playerCnt
		local StartTime_long = matchInfo.MatchStartTime
		local RegStatus = matchInfo.RegStatus

		--房间顶部背景
		local imgbg = "bg_fangjian.png"
		local imgmidbg = "ui_macth_label0.png"

		--状态
		local layout = ccs.image({
			scale9 = true,
			image = Common.getResourcePath(imgbg),
			size = CCSizeMake(cellWidth, cellHeight),
		})
		layout:setScale9Enabled(true);

		layout:setAnchorPoint(ccp(0.5, 0.5))
		local button = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			text = "",
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = {
				[ccs.TouchEventType.began] = function(uiwidget)
					layout:setScale(1.05);
				end,
				[ccs.TouchEventType.moved] = function(uiwidget)
				end,
				[ccs.TouchEventType.ended] = function(uiwidget)
					layout:setScale(1);

					onClickMatch(matchInfo, showrooms);
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
					layout:setScale(1);
				end,
			}
		})
		--房间名称背景
		local roomNameBg = ccs.image({
			scale9 = true,
			image = Common.getResourcePath(imgmidbg),
			size = CCSizeMake(269, 64),
		})
		roomNameBg:setScaleX(cellWidth/269)
		--对号
		local duihaoImage = ccs.image({
			scale9 = true,
			image = Common.getResourcePath("ic_login_sign_pass.png"),
			size = CCSizeMake(92, 97),
		})
		duihaoImage:setTouchEnabled(false);

		--新版使用图片做标题 PrizeImgUrl  PrizeImgUrl
		--房间奖杯
		local roomJiangbei = ccs.image({
			scale9 = true,
			image = "",
		})

		--MatchJiangbeiTable  MatchTitleTable  updataMatchJiangbeiGooods  updataMatchTitleGooods
		MatchJiangbeiTable[""..(i + 1)] = roomJiangbei;

		if isShowListAnim then
			MatchJiangbeiTable[""..(i + 1)]:setVisible(false);
		end
		if PrizeImgUrl ~= nil and  PrizeImgUrl ~= ""  then
			Common.getPicFile(PrizeImgUrl, (i + 1), true, updataMatchJiangbeiGooods)
		end

		--房间名称
		local textRoomName = ccs.image({
			scale9 = true,
			image = "",
		})
		MatchTitleTable[""..(i + 1)] = textRoomName;
		if isShowListAnim then
			MatchTitleTable[""..(i + 1)]:setVisible(false);
		end
		if TitlePictureUrl ~= nil and  TitlePictureUrl ~= ""  then
			Common.getPicFile(TitlePictureUrl, (i + 1), true, updataMatchTitleGooods)
		end

		-- 左上角图片
		local specialLabelImg = ccs.image({
			scale9 = true,
			image = "",
		})
		MatchSpecilImage[""..(i+1)] = specialLabelImg
		if isShowListAnim then
			-- 如果list有动画，则先隐藏
			MatchSpecilImage[""..(i+1)]:setVisible(false);
		end
		--下载左上角图片，并更新UI
		if specialLabelImgUrl ~= nil and  specialLabelImgUrl ~= ""  then
			Common.log("specialLabelImgUrl = "..specialLabelImgUrl)
			Common.getPicFile(specialLabelImgUrl, (i + 1), true, updataMatchSpecialImage)
		end

		-- 牌桌玩法img
		local tableType = matchInfo.TableType
		if tableType ~= 0 then
			local imgTableType = nil
			if tableType == 1 then
				imgTableType = Common.getResourcePath("bg_huanle.png")
			elseif tableType == 2 then
				imgTableType = Common.getResourcePath("bg_laizi.png")
			end

			local imageTableType = ccs.image({
				scale9 = false,
				image = imgTableType,
				size = CCSizeMake(39, 67),
			})

			local tagimageX = cellWidth / 2 - 51;
			local tagimageY = 146;
			SET_POS(imageTableType, tagimageX, tagimageY);
			layout:addChild(imageTableType)
		end

		--激战人数
		local strPlayerNumFrontName = ""
		if matchInfo.MatchType == 2 then
			strPlayerNumFrontName = "报名人数:"
		elseif matchInfo.MatchType == 1 then
			strPlayerNumFrontName = "激战人数:"
		end

		local textJizhan = ccs.label({
			text = strPlayerNumFrontName..playerCnt.."人",
			size = CCSizeMake(cellWidth, 30),
			color = ccc3(249,235,219),
		})
		-- 报名条件文字描述
		local textJinbi = ccs.label({
			text = ConditionText,
			size = CCSizeMake(cellWidth, 30),
			color = ccc3(93,60,35),
		})
		-- 比赛时间描述，由服务器更新返回的字符串
		local textTime = ccs.label({
			text = matchStartTimeTag,
			size = CCSizeMake(cellWidth, 30),
			color = ccc3(144,51,15),
		})

		--左上角的图片+label
		local leftTopImg = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_exchange_remainder.png"),
			size = CCSizeMake(183, 70),
		})

		--马上开始
		local starttimesoon = getStartTime(tonumber(StartTime_long - Common.getServerTime()*1000))
		Common.log("starttimesoon = "..starttimesoon)

		local kaisaiTimeOrSoonStart = ccs.label({
			text = starttimesoon,
			size = CCSizeMake(cellWidth, 30),
			color = ccc3(236, 178, 32),
		})
		kaisaiTimeOrSoonStart:setFontSize(25)
		kaisaiTimeOrSoonStart:setVisible(false)

		--锁
		local suo = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_match_2level_chuangguansai_suo.png"),
			size = CCSizeMake(74, 89),
		})
		--顶部蒙黑
		local menghei = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			pressed = Common.getResourcePath("bg_macth_zhezhao.png"),
			normal = Common.getResourcePath("bg_macth_zhezhao.png"),
			text = "",
		})
		menghei:setTouchEnabled(false)

		SET_POS(button, 0,0)
		SET_POS(roomNameBg, -5, 155 - cellHeight/2)
		SET_POS(roomJiangbei, -10, 245 - cellHeight/2)
		SET_POS(textTime, -5, 105 - cellHeight/2)
		SET_POS(textRoomName, 0, 160 - cellHeight/2)
		SET_POS(specialLabelImg, 55 - cellWidth/2, cellHeight / 2-57)
		--		SET_POS(jzRenshuBg, 0, 38 - cellHeight/2)
		SET_POS(textJizhan, 0, 45 - cellHeight/2)
		SET_POS(textJinbi,  -8, 75 - cellHeight/2)
		SET_POS(leftTopImg, -8,  125)
		SET_POS(kaisaiTimeOrSoonStart, -8, 125)
		SET_POS(menghei, -3,  0)
		SET_POS(suo, -8, 70)
		SET_POS(duihaoImage, 0,  0)
		SET_POS(layout, i*(cellWidth + spacingW) + 10 + cellWidth / 2, cellHeight/2 + 25)

		layout:addChild(roomJiangbei)
		layout:addChild(roomNameBg)
		layout:addChild(textTime)
		layout:addChild(textRoomName)
		layout:addChild(specialLabelImg)
		layout:addChild(jzRenshuBg)
		layout:addChild(textJizhan)
		layout:addChild(textJinbi)
		layout:addChild(duihaoImage)
		layout:addChild(menghei)
		layout:addChild(suo)
		layout:addChild(leftTopImg)
		layout:addChild(kaisaiTimeOrSoonStart)
		layout:addChild(button);

		matchScrollView:addChild(layout)

		if matchInfo.RegStatus == 1 then
			-- 已报名
			duihaoImage:setVisible(true)
			leftTopImg:setVisible(true)
			kaisaiTimeOrSoonStart:setVisible(true)

			menghei:setVisible(false)
			suo:setVisible(false)
		else
			-- 未报名
			if profile.Match.canApplyMatch(matchInfo) then
				-- 能报名
				Common.log(""..matchInfo.MatchID.."能报名")

				duihaoImage:setVisible(false)
				leftTopImg:setVisible(false)
				menghei:setVisible(false)
				suo:setVisible(false)
			else
				-- 不能报名
				Common.log(""..matchInfo.MatchID.."不能报名")

				menghei:setVisible(true)
				suo:setVisible(true)

				duihaoImage:setVisible(false)
				leftTopImg:setVisible(false)
			end
		end

		MatchItem[i+1] = {};
		MatchItem[i+1].MatchID = MatchID
		MatchItem[i+1].layout = layout
		MatchItem[i+1].duihaoImage = duihaoImage--对号
		MatchItem[i+1].leftTopImg = leftTopImg--左上角标
		MatchItem[i+1].kaisaiTimeOrSoonStart = kaisaiTimeOrSoonStart -- 开始时间
		MatchItem[i+1].textJizhan = textJizhan --激战人数
		MatchItem[i+1].textTime = textTime

		if isShowListAnim then
			table.insert(MatchItemLayout, layout);
		end
	end

	if isShowListAnim then
		-- 播完动画之后显示图标
		local function callbackShowImage(index)
			if MatchJiangbeiTable[""..index] ~= nil then
				MatchJiangbeiTable[""..index]:setVisible(true);
			end
			if MatchJiangbeiTable[""..index] ~= nil then
				MatchTitleTable[""..index]:setVisible(true);
			end
			if MatchSpecilImage[""..index] ~= nil then
				MatchSpecilImage[""..index]:setVisible(true);
			end
		end
		LordGamePub.showLandscapeList(MatchItemLayout, callbackShowImage);
	end

	openSelectMatchInfo(showrooms, isOpenSelectMatchInfo, openMatchName)
end

--打开比赛   isOpenSelectMatchInfo  openMatchName
function openSelectMatchInfo(showrooms, isOpenSelectMatchInfo, openMatchName)
	if isOpenSelectMatchInfo == 1 then
		local matchInfo = {}
		for i=1,#showrooms do
			if openMatchName == showrooms[i].MatchTitle then
				matchInfo = showrooms[i]
				break;
			end
		end
		--打开比赛
		if matchInfo ~= {} then
			--MatchDetailLogic.setDetail(matchInfo.RegStatus, matchInfo.MatchID, matchInfo.Cond[1].OptionsCode, 0, matchInfo)
			MatchDetailLogic.setDetail(matchInfo.RegStatus, matchInfo.MatchID, 100, 0, matchInfo)
			mvcEngine.createModule(GUI_MATCHDETAIL)
		end
	end
	isOpenSelectMatchInfo = 0
end

--[[--
--解析报名比赛
--]]
function reg_match_V4()
	Common.closeProgressDialog()

	local table = profile.Match.getGoMatch()

	local time = table["MatchStartTime"]
	local result = table["Result"]
	local MatchInstanceID =  table["MatchInstanceID"]
	local msg = table["Msg"]
	local MatchID = table["MatchID"]
	local ServerTime = table["ServerTime"]

	Common.log("报名比赛 MatchID = "..MatchID.." result = "..result.." MatchInstanceID = "..MatchInstanceID.." msg = "..msg.."time = "..time .. "ServerTime = " .. ServerTime)

	local DetaleTable = {} --获取当前比赛
	for j=1, #MatchTable["MatchList"] do
		if MatchTable["MatchList"][j].MatchID == MatchID then
			DetaleTable =  MatchTable["MatchList"][j]
			break;
		end
	end

	--刷新界面
	if result == 0 then
		--报名成功
		local StartTime_long = 0;

		for j=1, #MatchTable["MatchList"] do
			if MatchTable["MatchList"][j].MatchID ==  MatchID then
				MatchTable["MatchList"][j].RegStatus = 1
				MatchTable["MatchList"][j].matchInstanceID = MatchInstanceID
				StartTime_long = time
				matchTitle = MatchTable["MatchList"][j].MatchTitle
				break;
			end
		end

		--设置时间
		for i=1, #MatchItem do
			if MatchItem[i].MatchID == MatchID then
				MatchItem[i].duihaoImage:setVisible(true)
				if tonumber(time) ~= 0 then
					MatchItem[i].leftTopImg:setVisible(true)
					--设置马上开始时间
					Common.log("StartTime_long = "..StartTime_long)
					local timeShow = getStartTime(StartTime_long - Common.getServerTime()*1000)
					Common.log("timeShow = "..timeShow)

					MatchItem[i].kaisaiTimeOrSoonStart:setVisible(true)
					MatchItem[i].kaisaiTimeOrSoonStart:setText(timeShow)
				end

				local wintSprite = MatchItem[i].duihaoImage
				wintSprite:setPosition(ccp(0,0))
				wintSprite:setScale(8)

				local scaleAction =  CCScaleTo:create(0.25, 1)
				local ease = CCEaseOut:create(scaleAction,0.8)
				local array = CCArray:create()
				array:addObject(ease)
				array:addObject(CCDelayTime:create(2))
				local seq = CCSequence:create(array)
				wintSprite:setZOrder(10)
				wintSprite:runAction(seq)
				break;
			end
		end

		DetaleTable.MaxRegCnt = 0
		DetaleTable.RegCnt = 0
		if DetaleTable.MatchType == 1 then
			--及时赛
			JsMatchDetailLogic.DetaleTable = DetaleTable
			TableConsole.msMatchTitle = matchTitle;
			mvcEngine.createModule(GUI_JSMATCHDETAIL)
		elseif DetaleTable.MatchType == 2 then
			-- 定点赛
			local needConCnt = DetaleTable.freezeCoin; -- 比赛的入场金币

			addToAlarmQueue(createAlarmClockTable(MatchID, math.modf((StartTime_long -  Common.getServerTime()*1000)/1000), matchTitle, MatchInstanceID, needConCnt, StartTime_long, DetaleTable.RegStatus))
			ImageToast.createView(nil,Common.getResourcePath("ic_match_2level_baoming_chenggong.png"),"", msg, 4)
			Common.addAlarm(time, MatchInstanceID, MatchID, ServerTime, matchTitle)
		end
	elseif result == 4 then
		--报名失败
		local function startBaoming()
			profile.Match.didBaomingMatch(table, tonumber(table["RegType"]), 1)
		end
		TimeNotFitLogic.noticeMsg = table.Msg
		TimeNotFitLogic.func = startBaoming
		mvcEngine.createModule(GUI_TIMENOTFIT)
	else
		--报名失败
		Common.showToast(msg, 2)
	end
end

function isHasTian(time)
	local c = "天"
	local param1, param2 = string.find(time, c)
	if param1 and param2 then
		return 1
	else
		return 0
	end
end

--计算马上开始时间
function getStartTime(time)
	if time <= 0 or time == nil then
		--为空或者负数 显示空
		return "马上开始"
	elseif time <= 100*1000 then
		--小于100秒，显示 马上开始
		return "马上开始"
	end

	--计算时间
	local timeM = math.floor(time / 1000 / 60)+1--多少分钟
	local timeShowD = math.floor(timeM/(60*24))--显示多少天
	local timeShowH = math.floor((timeM / 60) % 24)--显示多少小时
	local timeShowM = timeM % 60--显示多少分钟
	local timeShow = ""
	if timeShowD ~= 0 then
		timeShow = timeShowD.."天"..timeShowH.."小时"
	elseif timeShowH ~= 0 then
		timeShow = timeShowH.."小时"..timeShowM.."分"
	else
		timeShow = timeShowM.."分钟"
	end
	return timeShow
end

--[[--
--解析退赛
--]]
function refund_match_V4()
	Common.closeProgressDialog()
	local table = profile.Match.RefundMatch()
	local Result = table["Result"]
	local MsgTxt = table["MsgTxt"]
	local MatchID = table["MatchID"]

	Common.log("tuipiao Result = ".. Result)
	--刷新界面
	if Result == 0 then
		-- 退票成功
		removeAlarmQueue(MatchID)
		for j=1, #MatchTable["MatchList"] do
			if MatchTable["MatchList"][j].MatchID ==  MatchID then
				MatchTable["MatchList"][j].RegStatus = 0;
				break;
			end
		end

		for i=1, #MatchItem do
			if MatchItem[i].MatchID ==  MatchID then
				MatchItem[i].duihaoImage:setVisible(false)
				MatchItem[i].leftTopImg:setVisible(false)
				MatchItem[i].kaisaiTimeOrSoonStart:setVisible(false)
				break;
			end
		end
	end
	Common.showToast(MsgTxt,2)
end

--[[--
--比赛同步
--]]
function match_sync_V4()
	Common.log("match_sync_V4")
	MatchTable["MatchList"] = profile.Match.getMatchTable() --更新比赛数据

	if GameConfig.getHallShowMode() == HallLogic.getMatchListMode() then
		--当前显示比赛列表
		if #MatchTable["MatchList"] > 0 then
			if GameConfig.getHallShowMode() == HallLogic.getMatchListMode() and profile.Match.getMatchListChange() then
				HallLogic.changeHallView(GameConfig.getHallShowMode(), GameConfig.getHallRoomItem())
			else
				for j=1,#MatchTable["MatchList"] do
					for i=1, #MatchItem do
						if MatchItem[i].MatchID == MatchTable["MatchList"][j].MatchID then
							-- 同步比赛数据
							local matchItem = showrooms[i]
							matchItem.MatchStatus = MatchTable["MatchList"][j].MatchStatus
							matchItem.TicketCount = MatchTable["MatchList"][j].TicketCount
							matchItem.MatchStartTime = MatchTable["MatchList"][j].MatchStartTime
							matchItem.RegStatus = MatchTable["MatchList"][j].RegStatus
							matchItem.playerCnt = MatchTable["MatchList"][j].playerCnt
							matchItem.StartTime = MatchTable["MatchList"][j].matchStartTimeTag

							-- 同步比赛闹钟数据
							if #MatchalarmClock > 0 then
								for i=1,#MatchalarmClock do
									if MatchalarmClock[i].MatchID == MatchTable["MatchList"][j].MatchID then
										Common.log("同步比赛闹钟数据")
										MatchalarmClock[i].RegStatus = MatchTable["MatchList"][j].RegStatus
									end
								end
							end

							-- 刷新UI
							local strPlayerNumFrontName = ""
							if MatchTable["MatchList"][j].MatchType == 2 then
								strPlayerNumFrontName = "报名人数:"
							elseif MatchTable["MatchList"][j].MatchType == 1 then
								strPlayerNumFrontName = "激战人数:"
							end

							local playcntnum = MatchTable["MatchList"][j].playerCnt
							MatchItem[i].textJizhan:setText(strPlayerNumFrontName..playcntnum.."人")
							MatchItem[i].textTime:setText(MatchTable["MatchList"][j].matchStartTimeTag)

							if MatchTable["MatchList"][j].RegStatus == 1 then
								--已报名
								Common.log("比赛列表同步-"..""..MatchTable["MatchList"][j].MatchTitle.."-已报名")
								MatchItem[i].duihaoImage:setVisible(true)
								MatchItem[i].leftTopImg:setVisible(true)

								local timeShow = getStartTime(MatchTable["MatchList"][j].MatchStartTime -  Common.getServerTime()*1000)
								MatchItem[i].kaisaiTimeOrSoonStart:setVisible(true)
								MatchItem[i].kaisaiTimeOrSoonStart:setText(timeShow)
							else
								--未报名
								Common.log("比赛列表同步-"..""..MatchTable["MatchList"][j].MatchTitle.."-未报名")
								MatchItem[i].duihaoImage:setVisible(false)
								MatchItem[i].leftTopImg:setVisible(false)
								MatchItem[i].kaisaiTimeOrSoonStart:setVisible(false)
							end
						end
					end
				end
			end
		end
	end
end

--[[--
--更新比赛列表
--]]
function updateMatchTable()
	Common.closeProgressDialog()

	MatchTable["MatchList"] = profile.Match.getMatchTable()
	if GameConfig.getHallShowMode() == HallLogic.getMatchListMode() then
		HallLogic.changeHallView(GameConfig.getHallShowMode(), GameConfig.getHallRoomItem())
	end
end

--[[--
--将比赛闹钟加入闹钟队列
--]]
function addToAlarmQueue(Matchtable)
	if(MatchalarmClock)then
		table.insert(MatchalarmClock, Matchtable)
		Common.SaveTable(profile.User.getSelfUserID().."AlarmQueue", MatchalarmClock)
	else
		return
	end
end

-- 将比赛移除闹钟队列
function removeAlarmQueue(MatchID)
	for i = 1, #MatchalarmClock do
		if(MatchalarmClock[i].MatchID == MatchID)then
			table.remove(MatchalarmClock, i)
			Common.SaveTable(profile.User.getSelfUserID().."AlarmQueue",MatchalarmClock)
			break
		end
	end

	if #MatchalarmClock == 0 then
		--如果闹钟队列里面没有比赛了，则停止定时器
		CCDirector:sharedDirector():getRunningScene():stopActionByTag(1001)
	end

	Common.removeAlarm(MatchID)
end

--检测是否有两个相差小于30分钟的比赛 time为int 秒
function isTimeDistanceTooSmall(time)
	for i = 1,#MatchalarmClock do
		local newtime = time - Common.getServerTime()
		Common.log("已报名的比赛"..MatchalarmClock[i].MatchTitle..MatchalarmClock[i].time.."==="..newtime)
		if(math.abs(MatchalarmClock[i].time - newtime)<=30*60)then
			return MatchalarmClock[i].MatchTitle
		end
	end
	return false
end

--[[--
--判断一定时间内是否有开始的比赛
--time:比赛开始时间（秒单位）
--nTime:时间点（秒单位）
--]]
function isTimeDistanceTooSmall_V4(time, nTime)
	for i = 1,#MatchalarmClock do
		local newtime = time - Common.getServerTime()
		Common.log("newtime = "..newtime)
		Common.log("MatchalarmClock[i].time = "..MatchalarmClock[i].time)
		Common.log("已报名的比赛"..MatchalarmClock[i].MatchTitle..MatchalarmClock[i].time.."==="..newtime)
		if(math.abs(MatchalarmClock[i].time - newtime)<=nTime)then
			return MatchalarmClock[i].MatchTitle
		end
	end
	return false
end

function releaseData()
	MatchTable = {}
	MatchTable["MatchList"] = {}
	MatchItem = {}--比赛控件
	itemLiMenuWidth = 0--setting 离 menu的距离
	MatchItemLayout = {}--比赛控件layout
	MatchJiangbeiTable = {}
	MatchTitleTable = {}
end