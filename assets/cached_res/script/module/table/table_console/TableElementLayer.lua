--存放牌桌上的所有动画(人物动画、牌型动画等)，上层按钮，位于牌桌第三层
module("TableElementLayer", package.seeall)

local TableElementLayer = nil--牌桌元素layer
local iv_photo = nil--头像
local iv_photo_bg = nil--头像背景框
local ivPhotoAmin = nil--身份头像
local ivPhotoAmin_half = nil--头像半身按钮
local SelfVipCoin = nil--自己的VIP图片
local SelfVipLevelLabelAtlas = nil--自己的VIP等级
local baoxianglight = nil--宝箱背景光
local baoxiang = nil--宝箱
local baoxianglabel = nil--宝箱数字
local PlayerCardCnt = {}--存放剩余牌数
local tableResult = nil--结算
local ttWuFaShengDuan = nil--天梯无法升段

local ClockCCSprite = nil--闹钟精灵
local ClockCountdown = nil--闹钟数字

local UserVipCoin = {}--用户vip标示
local UserVipLevelLabelAtlas = {}--用户vip等级
local isFlyText = false;--是否正在显示飘字
local flyLabel = nil;--飘字label
local flyWords = {}--飘字
local textTipsLabel = {}--人物叫分/抢地主/加倍提示文字
local textTipsBg = {}--人物叫分/抢地主/加倍提示背景
local WinCoinLabelAtlasTable = {}--输赢金币
local playOutImageTable = {}--输光图片
local DoubleIcon = {}--加倍图标
local TableDetailText = nil;--牌桌房间信息提示label
local TableCrazyMissionText = nil;--疯狂闯关关数label
local TableWaitTips = nil;--牌桌等待提示label
local TableCostLabel = nil;--桌费提示label
local textChatBg = {}--聊天表情背景
local textChatLabel = {}--聊天文字
local chatEmtionBg = {}--表情背景
local emtionImage = {}--表情动画
local softGuidePopBg = nil --软引导气泡背景
local softGuidePopLabel = nil --软引导气泡文字
local softGuideFingerImg = nil --软引导手指图片

time = 60 -- 充值剩余时间，单位秒。默认60秒
destinationTimeStemp = -1 -- 倒计时结束时间的时间戳，单位秒

local softGuideAnimationBg = nil --软引导背景
local softGuideAnimationLabel = nil --最小金币软引导文字
isSameTime = false --是否是同一盘

--牌桌内聊天音乐
local chatMusicContent = {"大家好！给各位请安","这牌你也敢叫地主？简直是自寻死路","喂！你倒是快点啊","拖时间是没用滴！","出啊，好牌都留着下蛋啊","不怕神一样的对手，就怕猪一样的队友","你很啰嗦耶，安静打牌好不","别崇拜哥，哥只是个传说","和你合作真是太愉快了！","不好意思各位，我要先走一步了","这把牌实在太烂了","牌好，心情就好"}

local atlasview = nil -- 遮罩view
local atlas = nil -- 倒计时

--[[--
--比赛充值等待倒计时回调
--]]
local function setTime()

	local currentTimeStemp = Common.getServerTime() -- 获取当前时间戳，单位秒
	local residualTimeStemp = math.floor(destinationTimeStemp) - math.floor(currentTimeStemp) -- 充值剩余时间戳，单位秒
	if atlas ~= nil then
		Common.log("atlas ~= nil")

		Common.log("destinationTimeStemp = "..destinationTimeStemp)
		Common.log("currentTimeStemp = "..currentTimeStemp)
		Common.log("residualTimeStemp = "..residualTimeStemp)
		atlas:setStringValue(""..residualTimeStemp)
	end

	if residualTimeStemp <= 0 then
		Common.log("you are lost")

		-- 比赛V4离开充值等待区
		MatchRechargeCoin.sendLeaveRechargeWaiting(0)
	end
end

--[[--
--比赛充值等待遮罩
--]]
function addRechargeWaitingOverlay()
	atlasview = cocostudio.createView("countdown.json")
	atlasview:setZOrder(1000000000)
	atlas = cocostudio.getUILabelAtlas(atlasview,"AtlasLabel_5")
	atlas:setStringValue(time)
	TableElementLayer:addChild(atlasview)

	destinationTimeStemp = Common.getServerTime() + time -- time:充值倒计时

	local delay = CCDelayTime:create(1);
	local array = CCArray:create();
	array:addObject(delay);
	array:addObject(CCCallFuncN:create(setTime));
	local seq = CCSequence:create(array);
	atlas:runAction(CCRepeatForever:create(seq));
end

--[[--
--离开比赛充值等待遮罩
--]]
function removeRechargeWaitingOverlay()
	if atlasview ~= nil and atlas ~= nil then
		Common.log("removeRechargeWaitingOverlay")

		atlas:stopAllActions()
		atlasview:removeFromParentAndCleanup(true)
		atlasview = nil
		time = 60
	end
end

--[[--
--创建元素层
]]
local function creatElementLayer()
	TableElementLayer = CCLayer:create()
	TableElementLayer:registerScriptTouchHandler(TableOnTouchForElement.OnTouchEvent)
	setElementLayerTouchEnabled(true)
	TableElementLayer:setZOrder(2)
	initElement()
end

function getElementLayer()
	if TableElementLayer == nil then
		creatElementLayer()
	end
	return TableElementLayer
end

--[[--
--设置牌桌元素触摸监听
--]]
function setElementLayerTouchEnabled(isTouchEnabled)
	TableElementLayer:setTouchEnabled(isTouchEnabled)
	if iv_photo_bg ~= nil then
		iv_photo_bg:setEnabled(isTouchEnabled)
	end
	if ivPhotoAmin_half ~= nil then
		ivPhotoAmin_half:setEnabled(isTouchEnabled)
	end
	if tableResult ~= nil then
		tableResult:setEnabled(isTouchEnabled)
	end
	if baoxiang ~= nil then
		baoxiang:setEnabled(isTouchEnabled)
	end
end

local function onClick()
	mvcEngine.createModule(GUI_TABLE_SELF_USER_INFO)
	TableSelfUserInfoLogic.setSelfUserInfo()
end

--[[--
--头像监听
--]]
local function portraitCallback()
	Common.setButtonScale(iv_photo_bg, onClick)
	Common.setButtonScale(iv_photo)
end

local function PhotoAminCallback()
	Common.setButtonScale(ivPhotoAmin, onClick)
end

--[[--
--宝箱监听
--]]
function baoxiangCallback()
	Common.setButtonScale(baoxiang)
	if (TableConsole.baohePro < TableConsole.baoheMax) then
		Common.showToast("打满" .. TableConsole.baoheMax .. "局，即可点击宝盒获得【兑奖券 碎片 】+【金币】等超值物品！", 2)
	else
		hideBaoXiang();
		sendBAOHE_V4_GET_LIST(TableConsole.m_nRoomID);
	end
end

local isShowLadderPop = true;--是否显示过

--[[--
--弹出天梯奖励
--]]
function showTTUpJiangLi()
	TTShengjiLogic.setFlag(1, profile.User.getSelfLadderLevel(), profile.User.getSelfLadderDuan())
	mvcEngine.createModule(GUI_TTSHENGJI)
	isShowLadderPop = true
	setTableResultAlpha(255)
end

--[[--
--结算监听
--]]
local function tableResultCallback()

	Common.setButtonScale(tableResult)

	if TableConsole.mode == TableConsole.ROOM then
		GameArmature.closeTiantiAnim()
--		setWuFaShengDuanVisible(false);
		if isShowLadderPop then
			TableLogic.showGameResultView()--显示结算界面
		else
			if TableConsole.LadderChangeRank == 1 then
				--升级有奖励
				if profile.User.getSelfLadderLevel() == 5 or profile.User.getSelfLadderLevel() == 10 then
				--已经主动弹出
				else
					--升级无奖励
					TTShengjiLogic.setFlag(0, profile.User.getSelfLadderLevel(), profile.User.getSelfLadderDuan())
					mvcEngine.createModule(GUI_TTSHENGJI)
					isShowLadderPop = true
					setTableResultAlpha(255)
				end
			elseif TableConsole.LadderChangeRank == -1 or TableConsole.LadderChangeRank == 255 then
				--降级
				if TableConsole.LadderChangeDuan == -1 or TableConsole.LadderChangeDuan == 255 then
					--降段
					mvcEngine.createModule(GUI_TT_JIANGDUAN)
					isShowLadderPop = true
					setTableResultAlpha(255)
				else
					TableLogic.showGameResultView()--显示结算界面
					isShowLadderPop = true
					setTableResultAlpha(255)
				end
			elseif TableConsole.LadderChangeRank == 0 then
				--无法升级
				Common.log("sendGIFTBAGID_REQUIRE_GIFTBAG=="..profile.User.getSelfLadderUpScore().."=="..profile.User.getSelfLadderScore())
				if profile.User.getSelfLadderUpScore() <= profile.User.getSelfLadderScore()then
--					TTGetTxzLogic.setValue(profile.User.getSelfLadderDuan())
--					mvcEngine.createModule(GUI_TTGETTXZ)
					TTShengjiLogic.ladderUpgradeGifts()
					isShowLadderPop = true
					setTableResultAlpha(255)
				else
					--不升不降
					TableLogic.showGameResultView()--显示结算界面
				end
			end
		end
	else
		--比赛
		TableLogic.showGameResultView()--显示结算界面
	end
end

--[[--
--初始化元素层
--]]
function initElement()
	--宝箱
	baoxianglight = CCSprite:create(Common.getResourcePath("light.png"))
	baoxianglight:setScale(0.8)
	baoxianglight:setAnchorPoint(ccp(0.5, 0.5));
	baoxianglight:setPosition(1075, 40);
	baoxianglight:setZOrder(-1);
	TableElementLayer:addChild(baoxianglight);

	baoxianglabel = CCLabelTTF:create("", "", 28)
	baoxianglabel:setColor(ccc3(255, 255, 255))
	baoxianglabel:setPosition(1090, 15)
	TableElementLayer:addChild(baoxianglabel)

	hideBaoXiang()

	--头像
	iv_photo = CCSprite:create(Common.getResourcePath("hall_portrait_default.png"))
	iv_photo:setScale(1)
	iv_photo:setAnchorPoint(ccp(0.5, 0.5));
	iv_photo:setPosition(64, 45);
	TableElementLayer:addChild(iv_photo)

	iv_photo_bg = CCMenuItemImage:create(Common.getResourcePath("hall_portrait.png"), Common.getResourcePath("hall_portrait.png"))
	iv_photo_bg:setAnchorPoint(ccp(0.5, 0.5));
	iv_photo_bg:registerScriptTapHandler(portraitCallback)
	local menu = CCMenu:createWithItem(iv_photo_bg)
	menu:setPosition(64, 45)
	TableElementLayer:addChild(menu)

	ivPhotoAmin = CCMenuItemImage:create(Common.getResourcePath("ic_desk_touxiang_farmer.png"), Common.getResourcePath("ic_desk_touxiang_farmer.png"))
	ivPhotoAmin:setAnchorPoint(ccp(0.5, 0.5));
	ivPhotoAmin:setVisible(false);
	ivPhotoAmin:setPosition(64, 60);
	TableElementLayer:addChild(ivPhotoAmin)

	ivPhotoAmin_half = CCMenuItemImage:create(Common.getResourcePath("ivPhotoAmin_half.png"), Common.getResourcePath("ivPhotoAmin_half.png"))
	ivPhotoAmin_half:setAnchorPoint(ccp(0.5, 0.5));
	ivPhotoAmin_half:registerScriptTapHandler(PhotoAminCallback)
	ivPhotoAmin_half:setVisible(false);
	local menu = CCMenu:createWithItem(ivPhotoAmin_half)
	menu:setPosition(64, 30)
	TableElementLayer:addChild(menu)

	SelfVipCoin = CCSprite:create(Common.getResourcePath("hall_vip_icon.png"));--自己的VIP图片
	SelfVipCoin:setAnchorPoint(ccp(0, 1));
	TableElementLayer:addChild(SelfVipCoin)
	SelfVipLevelLabelAtlas = CCLabelAtlas:create("0", Common.getResourcePath("num_vip_level.png"), 12, 19, 48);--自己的VIP等级
	SelfVipLevelLabelAtlas:setAnchorPoint(ccp(0, 1));
	TableElementLayer:addChild(SelfVipLevelLabelAtlas)

	local VipLevel = profile.User.getSelfVipLevel()
	local vipType = VIPPub.getUserVipType(VipLevel)
	if vipType >= VIPPub.VIP_1 then
		SelfVipLevelLabelAtlas:setString(""..vipType)
		SelfVipCoin:setPosition(48 - 30, 55)--用户vip标示
		SelfVipLevelLabelAtlas:setPosition(48 + 30, 40)--用户vip等级
		SelfVipCoin:setVisible(true)
		SelfVipLevelLabelAtlas:setVisible(true)
	else
		SelfVipCoin:setVisible(false)
		SelfVipLevelLabelAtlas:setVisible(false)
	end
	--暂时隐藏自己的VIP标示
	SelfVipCoin:setVisible(false)
	SelfVipLevelLabelAtlas:setVisible(false)

	--结算/天梯ICON
	tableResult = CCMenuItemImage:create(Common.getResourcePath("ic_desk_result.png"), Common.getResourcePath("ic_desk_result.png"))
	tableResult:registerScriptTapHandler(tableResultCallback)
	local menu = CCMenu:createWithItem(tableResult)
	menu:setPosition(1075, 150)
	TableElementLayer:addChild(menu)
	hideTableResult()
	--无法升段
--	ttWuFaShengDuan = CCSprite:create(Common.getResourcePath("ic_desk_wufashengduan.png"))
--	ttWuFaShengDuan:setPosition(1075, 150);
--	TableElementLayer:addChild(ttWuFaShengDuan)
--	setWuFaShengDuanVisible(false);

	--剩余牌数
	for i = 1, 2 do
		local CardCnt = CCLabelAtlas:create("0", Common.getResourcePath("num_desk_shijian.png"), 28, 41, 48);
		CardCnt:setAnchorPoint(ccp(0.5, 0.5));
		CardCnt:setVisible(false)
		CardCnt:setPosition(TableConfig.StandardPos[i + 1][1], TableConfig.StandardPos[i + 1][2] - 120)
		table.insert(PlayerCardCnt, CardCnt)
		TableElementLayer:addChild(CardCnt)

		local VipCoin = CCSprite:create(Common.getResourcePath("hall_vip_icon.png"));
		VipCoin:setAnchorPoint(ccp(0, 1));
		VipCoin:setZOrder(100 + i + 2)
		local VipLevelLabelAtlas = CCLabelAtlas:create("0", Common.getResourcePath("num_vip_level.png"), 12, 19, 48);
		VipLevelLabelAtlas:setAnchorPoint(ccp(0, 1));
		VipLevelLabelAtlas:setZOrder(100 + i + 3)

		table.insert(UserVipCoin, VipCoin)
		TableElementLayer:addChild(VipCoin)
		table.insert(UserVipLevelLabelAtlas, VipLevelLabelAtlas)
		TableElementLayer:addChild(VipLevelLabelAtlas)
	end

	ClockCCSprite = CCSprite:create(Common.getResourcePath("naozhong_1.png"))
	ClockCountdown = CCLabelAtlas:create("0", Common.getResourcePath("num_desk_shijian.png"), 28, 41, 48);
	ClockCountdown:setAnchorPoint(ccp(0.5, 0.5));
	ClockCountdown:setPosition(47, 42);
	ClockCCSprite:addChild(ClockCountdown)
	ClockCCSprite:setVisible(false)
	TableElementLayer:addChild(ClockCCSprite)

	TableWaitTips = CCLabelTTF:create("", "", 28)
	TableWaitTips:setColor(ccc3(80, 34, 19))
	TableWaitTips:setPosition(ccp(TableConfig.TableDefaultWidth / 2, TableConfig.TableDefaultHeight * 0.5))
	TableWaitTips:setVisible(false)
	TableElementLayer:addChild(TableWaitTips)

	TableCostLabel = CCLabelTTF:create("", "", 28)
	TableCostLabel:setColor(ccc3(90, 44, 32))
	TableCostLabel:setPosition(ccp(970, 85))
	TableCostLabel:setVisible(false)
	TableElementLayer:addChild(TableCostLabel)

	updataUserInfo()

	--创建记牌器
	jipaiqiLogic.createView()
	TableElementLayer:addChild(jipaiqiLogic.view)
end

--[[--
--设置桌费提示是否显示
--]]
function setTableCostLabelVisible(Visible)
	TableCostLabel:setVisible(Visible)

	if TableConsole.mode == TableConsole.ROOM then
		if TableConsole.getTableCost() > 0 then
			TableCostLabel:setString("本场每局消耗"..TableConsole.getTableCost().."金币");
		else
			TableCostLabel:setVisible(false)
		end
	elseif TableConsole.mode == TableConsole.MATCH then
		if TableConsole.getTableCost() > 0 and TableConsole.getBaseChip() > 0 then
			local strCost = ""..TableConsole.getBaseChip().."金币底，每局消耗"..TableConsole.getTableCost().."金币"
			TableCostLabel:setString(strCost);
		else
			TableCostLabel:setVisible(false)
		end
	end
end

--[[--
--设置个人头像是否可以点击
--]]
function setPhotoAminEnabled(Enabled)
	ivPhotoAmin_half:setEnabled(Enabled)
end

--[[--
--设置身份头像是否显示
--]]
function setPhotoAminVisible(Visible)
	if TableConsole.getPlayer(TableConsole.getSelfSeat()).m_bIsLord then
		if TableConsole.getPlayer(TableConsole.getSelfSeat()).mnSex == 2 then
			--女
			ivPhotoAmin:setNormalSpriteFrame(CCSpriteFrame:create(Common.getResourcePath("ic_desk_touxiang_landlord_w.png"), CCRect(0, 0, 135, 120)))
			ivPhotoAmin:setSelectedSpriteFrame(CCSpriteFrame:create(Common.getResourcePath("ic_desk_touxiang_landlord_w.png"), CCRect(0, 0, 135, 120)))
		else
			--男
			ivPhotoAmin:setNormalSpriteFrame(CCSpriteFrame:create(Common.getResourcePath("ic_desk_touxiang_landlord.png"), CCRect(0, 0, 135, 120)))
			ivPhotoAmin:setSelectedSpriteFrame(CCSpriteFrame:create(Common.getResourcePath("ic_desk_touxiang_landlord.png"), CCRect(0, 0, 135, 120)))
		end
	else
		if TableConsole.getPlayer(TableConsole.getSelfSeat()).mnSex == 2 then
			--女
			ivPhotoAmin:setNormalSpriteFrame(CCSpriteFrame:create(Common.getResourcePath("ic_desk_touxiang_farmer_w.png"), CCRect(0, 0, 135, 120)))
			ivPhotoAmin:setSelectedSpriteFrame(CCSpriteFrame:create(Common.getResourcePath("ic_desk_touxiang_farmer_w.png"), CCRect(0, 0, 135, 120)))
		else
			--男
			ivPhotoAmin:setNormalSpriteFrame(CCSpriteFrame:create(Common.getResourcePath("ic_desk_touxiang_farmer.png"), CCRect(0, 0, 135, 120)))
			ivPhotoAmin:setSelectedSpriteFrame(CCSpriteFrame:create(Common.getResourcePath("ic_desk_touxiang_farmer.png"), CCRect(0, 0, 135, 120)))
		end
	end
	ivPhotoAmin:setVisible(Visible)
	ivPhotoAmin_half:setVisible(Visible)
	setPhotoAminEnabled(Visible)
end

--[[--
--设置个人头像是否可以点击
--]]
function setPhotoEnabled(Enabled)
	iv_photo_bg:setEnabled(Enabled)
end

function setPhotoImage(Visible)
	iv_photo:setVisible(Visible)
	iv_photo_bg:setVisible(Visible)
	setPhotoEnabled(Visible)
end

--[[--
--隐藏房间信息
--]]
function hideTableDetailText()
	TableElementLayer:removeChild(TableDetailText, true);
	TableDetailText = nil;
end

--[[--
--在开始前，显示房间信息
--]]
function showTableDetailText()
	if (TableConsole.mode == TableConsole.MATCH) then
		return;
	end
	-- 排除普通房间
	if (TableConsole.m_nGameStatus == TableConsole.STAT_WAITING_TABLE and TableConsole.msRoomTitle ~= nil and TableConsole.msBaseChipText ~= nil and TableConsole.mnTableType ~= TableConsole.TABLE_TYPE_NORMAL) then
		TableDetailText = FontStyle.CCLabelTTFAddOutlineAndShadow(nil, TableConsole.msRoomTitle .. "  " .. TableConsole.msBaseChipText .. "房间", "", 36, ccc3(255, 255, 255), ccc3(132,60,8), 2, 3, 191)
		TableDetailText:setPosition(ccp(TableConfig.TableDefaultWidth / 2, TableConfig.TableDefaultHeight * 0.6))
		TableDetailText:setZOrder(100)
		TableElementLayer:addChild(TableDetailText);
	end
end

--[[--
--隐藏闯关关数
--]]
function hideTableCrazyMissionText()
	TableElementLayer:removeChild(TableCrazyMissionText, true);
	TableCrazyMissionText = nil;
end

--[[--
--在开始前，显示闯关关数
--]]
function showTableCrazyMissionText()
	if (TableConsole.mode == TableConsole.MATCH) then
		return;
	end
	-- 排除普通房间
	TableCrazyMissionText = FontStyle.CCLabelTTFAddOutlineAndShadow(nil, "第" .. TableConsole.crazyMission .. "关", "", 24, ccc3(255, 255, 255), ccc3(132,60,8), 2, 3, 191)
	TableCrazyMissionText:setPosition(ccp(TableConfig.TableDefaultWidth / 2, TableConfig.TableDefaultHeight * 0.6 + 40))
	TableCrazyMissionText:setZOrder(100)
	TableElementLayer:addChild(TableCrazyMissionText);
end

--[[--
--显示牌桌等待提示文字
--]]
function showTableWaitTips()

	local nowPlayer = nil;
	local pos = 0;
	local text = nil;

	if TableConsole.m_nGameStatus == TableConsole.STAT_WAITING_TABLE then
		-- 等待分桌
		if (TableConsole.m_bSendContinue) then
			if TableConsole.TableHintMsg ~= nil then
				text = "正在为您智能匹配对手,请稍候...\n"..TableConsole.TableHintMsg;
				TableWaitTips:setPosition(ccp(TableConfig.TableDefaultWidth / 2, TableConfig.TableDefaultHeight * 0.5))
			else
				text = "正在为您智能匹配对手,请稍候...\n";
				TableWaitTips:setPosition(ccp(TableConfig.TableDefaultWidth / 2, TableConfig.TableDefaultHeight * 0.55))
			end
		end

		if (text == nil) then
			GameArmature.hideLoadingAnim()
			TableWaitTips:setString("")
			TableWaitTips:setVisible(false)
		else
			GameArmature.showLoadingAnim()
			TableWaitTips:setString(text)
			TableWaitTips:setVisible(true)
		end
		return;
	end
	if (text == nil) then
		TableWaitTips:setString("")
		TableWaitTips:setVisible(false)
	end

	GameArmature.hideLoadingAnim()

	if (TableConsole.getCurrPlayer() ~= -1) then
		nowPlayer = TableConsole.getPlayer(TableConsole.getCurrPlayer());
		pos = TableConsole.getPlayerPosBySeat(TableConsole.getCurrPlayer());
	end

	if TableConsole.m_nGameStatus >= TableConsole.STAT_CALLSCORE then
		if (nowPlayer == nil) then
			return;
		end
		if (nowPlayer.m_bTrustPlay) then
			return;
		end
	end

	if TableConsole.m_nGameStatus == TableConsole.STAT_WAITING_READY then
		-- 准备
		-- 等待玩家举手
		if (TableConsole.isGameResultReady and TableConsole.mode == TableConsole.ROOM) then
			if not TableConsole.m_bIsWaitingTable then
				text = "等待其他人开始\n请稍候...";
			end
			if (TableConsole.m_bSendTableNotEnded) then
				text = "正在为您智能匹配对手,请稍候...";
			end
		end
	elseif TableConsole.m_nGameStatus == TableConsole.STAT_SETOUT then
	-- 发牌
	elseif TableConsole.m_nGameStatus == TableConsole.STAT_CALLSCORE then
		-- 叫分/叫地主
		if (TableConsole.getCurrPlayer() ~= TableConsole.getSelfSeat()) then

			if TableConsole.mnTableType == TableConsole.TABLE_TYPE_NORMAL then
				if pos == 1 then
					if nowPlayer.m_sNickName == "" or TableConsole.mode == TableConsole.MATCH then
						-- 比赛模式，只显示上下家，不显示昵称
						text = "等待 下家 叫分...";
					else
						text = "等待 '" .. nowPlayer.m_sNickName .. "' (下家)叫分...";
					end
				elseif pos == 2 then
					if nowPlayer.m_sNickName == "" or TableConsole.mode == TableConsole.MATCH then
						-- 比赛模式，只显示上下家，不显示昵称
						text = "等待 上家 叫分...";
					else
						text = "等待 '" .. nowPlayer.m_sNickName .. "' (上家)叫分...";
					end
				end
			elseif TableConsole.mnTableType == TableConsole.TABLE_TYPE_HAPPY or TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT then
				if pos == 1 then
					if nowPlayer.m_sNickName == "" or TableConsole.mode == TableConsole.MATCH then
						text = "等待 下家 叫地主...";
					else
						text = "等待 '" .. nowPlayer.m_sNickName .. "' (下家)叫地主...";
					end
				elseif pos == 2 then
					if nowPlayer.m_sNickName == "" or TableConsole.mode == TableConsole.MATCH then
						text = "等待 上家 叫地主...";
						Common.log("mode == 7   mode =" .. TableConsole.mode)
					else
						text = "等待 '" .. nowPlayer.m_sNickName .. "' (上家)叫地主...";
					end
				end
			end
		end
	elseif TableConsole.m_nGameStatus == TableConsole.STAT_GRAB_LANDLORD then
		-- 抢地主
		if (TableConsole.getCurrPlayer() ~= TableConsole.getSelfSeat()) then
			if pos == 1 then
				if nowPlayer.m_sNickName == "" or TableConsole.mode == TableConsole.MATCH then
					text = "等待 下家 叫分...";
				else
					text = "等待 '" .. nowPlayer.m_sNickName .. "' (下家)抢地主...";
				end
			elseif pos == 2 then
				if nowPlayer.m_sNickName == "" or TableConsole.mode == TableConsole.MATCH then
					text = "等待 上家 叫分...";
				else
					text = "等待 '" .. nowPlayer.m_sNickName .. "' (上家)抢地主...";
				end
			end
		end
	elseif TableConsole.m_nGameStatus == TableConsole.STAT_DOUBLE_SCORE then
		-- 加倍
		if (TableConsole.getPlayer(TableConsole.getSelfSeat()).m_nDoubleScore >= 0) then
			for i = 0, TableConsole.getPlayerCnt() - 1 do
				local nSeat = TableConsole.getPlayerSeatByPos(i);
				local p = TableConsole.getPlayer(nSeat);
				if (p ~= nil) then
					if (p.m_nDoubleScore == -1) then
						text = "等待其他人加倍...";
						break;
					end
				end
			end
		end
	elseif TableConsole.m_nGameStatus == TableConsole.STAT_TAKEOUT then
	-- 出牌
	elseif TableConsole.m_nGameStatus == TableConsole.STAT_GAME_RESULT then
	-- 游戏结果
	elseif TableConsole.m_nGameStatus == TableConsole.STAT_MATCH_RESULT then
	-- 比赛结果
	end


	if (TableConsole.m_nGameStatus >= TableConsole.STAT_CALLSCORE) then
		if (TableConsole.m_nCountdownCnt <= 0) then
			-- 超时
			if TableConsole.mode == TableConsole.MATCH then
				if pos == 1 then
					text = "下家 ".." 网络延时，请稍候...";
				elseif pos == 2 then
					text = "上家 ".." 网络延时，请稍候...";
				end
			elseif TableConsole.mode == TableConsole.ROOM then
				if pos == 1 then
					text = "下家 " .. nowPlayer.m_sNickName .. " 网络延时，请稍候...";
				elseif pos == 2 then
					text = "上家 " .. nowPlayer.m_sNickName .. " 网络延时，请稍候...";
				end
			end
		end
	end

	if (text == nil) then
		TableWaitTips:setString("")
		TableWaitTips:setVisible(false)
		return;
	end

	TableWaitTips:setString(text)
	TableWaitTips:setPosition(ccp(TableConfig.TableDefaultWidth / 2, TableConfig.TableDefaultHeight * 0.6))
	TableWaitTips:setVisible(true)
end

--[[--
--隐藏加倍图标
--]]
function hideDoubleIcon()
	for i = 1, table.maxn(DoubleIcon) do
		if DoubleIcon[i] ~= nil then
			TableElementLayer:removeChild(DoubleIcon[i], true);
		end
	end
	DoubleIcon = {};
end

--[[--
--显示加倍图标
--]]
function showDoubleIcon(SeatID, doubelNum)
	local suffix = TableConsole.getPlayerPosBySeat(SeatID) + 1
	if doubelNum == 2 then
		DoubleIcon[suffix] = CCSprite:create(Common.getResourcePath("ui_desk_2bei.png"))
	elseif doubelNum == 4 then
		DoubleIcon[suffix] = CCSprite:create(Common.getResourcePath("ui_desk_4bei.png"))
	end
	if DoubleIcon[suffix] ~= nil then
		DoubleIcon[suffix]:stopAllActions();
		if suffix == 1 then
			DoubleIcon[suffix]:setPosition(TableConfig.StandardPos[suffix][1] + 100, TableConfig.StandardPos[suffix][2] + 20);
		elseif suffix == 2 then
			DoubleIcon[suffix]:setPosition(TableConfig.StandardPos[suffix][1] + 40, TableConfig.StandardPos[suffix][2] - 60);
		elseif suffix == 3 then
			DoubleIcon[suffix]:setPosition(TableConfig.StandardPos[suffix][1] - 40, TableConfig.StandardPos[suffix][2] - 60);
		end
		DoubleIcon[suffix]:setZOrder(100)
		TableElementLayer:addChild(DoubleIcon[suffix])

		local moveUp = CCMoveBy:create(0.25,ccp(0,50));
		local moveDown = CCMoveBy:create(0.25,ccp(0,-50));
		local arr = CCArray:create();
		arr:addObject(moveUp);
		arr:addObject(moveDown);
		local seq = CCSequence:create(arr);
		DoubleIcon[suffix]:runAction(seq);
	end
end

--[[--
--设置无法升段是否显示
--]]
function setWuFaShengDuanVisible(Visible)
	if ttWuFaShengDuan ~= nil then
		ttWuFaShengDuan:setVisible(Visible)
	end
end

--[[--
--隐藏结算信息
--]]
function hideGameResultData()
	for i = 1, #WinCoinLabelAtlasTable do
		TableElementLayer:removeChild(WinCoinLabelAtlasTable[i], true);
	end
	WinCoinLabelAtlasTable = {};
	for i = 1, #playOutImageTable do
		TableElementLayer:removeChild(playOutImageTable[i], true);
	end
	playOutImageTable = {};
end

--[[--
--显示结算信息
--]]
function showGameResultData()
	for i = 1, #TableConsole.mnWin_Pos do
		local WinChip = TableConsole.mnWin_Pos[i].WinChip;
		local pos = TableConsole.mnWin_Pos[i].pos;
		local seat = TableConsole.getPlayerSeatByPos(pos)
		local viplevel = TableConsole.getPlayer(seat).mnVipLevel;

		local WinCoinLabelAtlas = CCLabelAtlas:create(":"..WinChip, Common.getResourcePath("num_desk_win.png"), 47, 67, 48)
		WinCoinLabelAtlas:setAnchorPoint(ccp(0.5, 0.5));
		WinCoinLabelAtlas:setZOrder(100)
		if pos == 0 then
			WinCoinLabelAtlas:setPosition(ccp(TableConfig.EmtionPos[pos+1][1], TableConfig.EmtionPos[pos+1][2] - 200))
		else
			WinCoinLabelAtlas:setPosition(ccp(TableConfig.EmtionPos[pos+1][1], TableConfig.EmtionPos[pos+1][2] - 100))
		end
		TableElementLayer:addChild(WinCoinLabelAtlas)

		if VIPPub.getUserVipType(viplevel) >= VIPPub.VIP_3 then
			local addCoin = CCSprite:create(Common.getResourcePath("ic_desk_jinbijiacheng.png"))
			addCoin:setAnchorPoint(ccp(0.5, 0.5));
			addCoin:setPosition(64, -30);
			WinCoinLabelAtlas:addChild(addCoin)

			local addCoinWenzi = CCSprite:create(Common.getResourcePath("VIPjiacheng.png"))
			addCoinWenzi:setAnchorPoint(ccp(0.5, 0.5));
			addCoinWenzi:setPosition(64, -30);
			WinCoinLabelAtlas:addChild(addCoinWenzi)
		end

		table.insert(WinCoinLabelAtlasTable, WinCoinLabelAtlas);
		local move = CCMoveBy:create(0.5,ccp(0,200));
		local arr = CCArray:create();
		arr:addObject(move);
		local seq = CCSequence:create(arr);
		WinCoinLabelAtlas:runAction(seq);
	end
	for i = 1, #TableConsole.mnLoss_Pos do
		local WinChip = TableConsole.mnLoss_Pos[i].WinChip;
		local pos = TableConsole.mnLoss_Pos[i].pos;
		local seat = TableConsole.getPlayerSeatByPos(pos)
		local viplevel = TableConsole.getPlayer(seat).mnVipLevel;
		local WinCoinLabelAtlas = CCLabelAtlas:create(":"..math.abs(WinChip), Common.getResourcePath("num_desk_loss.png"), 47, 67, 48)
		WinCoinLabelAtlas:setAnchorPoint(ccp(0.5, 0.5));
		WinCoinLabelAtlas:setZOrder(100)

		if pos == 0 then
			WinCoinLabelAtlas:setPosition(ccp(TableConfig.EmtionPos[pos+1][1], TableConfig.EmtionPos[pos+1][2] - 200))
		else
			WinCoinLabelAtlas:setPosition(ccp(TableConfig.EmtionPos[pos+1][1], TableConfig.EmtionPos[pos+1][2] - 100))
		end
		TableElementLayer:addChild(WinCoinLabelAtlas)

		table.insert(WinCoinLabelAtlasTable, WinCoinLabelAtlas);

		local move = CCMoveBy:create(0.5,ccp(0,200));
		local arr = CCArray:create();
		arr:addObject(move);
		local seq = CCSequence:create(arr);
		WinCoinLabelAtlas:runAction(seq);
		Common.log("TableConsole.getPlayer(seat).m_nCoin == "..TableConsole.getPlayer(seat).m_nCoin);
		if tonumber(TableConsole.getPlayer(seat).m_nCoin) <= 1 then
			local playOutImage = CCSprite:create(Common.getResourcePath("shuguangle.png"))
			playOutImage:setScale(1)
			playOutImage:setAnchorPoint(ccp(0.5, 0.5))
			playOutImage:setZOrder(100)
			if pos == 0 then
				playOutImage:setPosition(ccp(TableConfig.EmtionPos[pos+1][1], TableConfig.EmtionPos[pos+1][2] - 130))
			else
				playOutImage:setPosition(ccp(TableConfig.EmtionPos[pos+1][1], TableConfig.EmtionPos[pos+1][2] - 30))
			end
			TableElementLayer:addChild(playOutImage)

			table.insert(playOutImageTable, playOutImage);

			local moveImage = CCMoveBy:create(0.5,ccp(0,200));
			local arrImage = CCArray:create();
			arrImage:addObject(moveImage);
			local seqImage = CCSequence:create(arrImage);
			playOutImage:runAction(seqImage);
		end
	end
end

--[[--
--移除用户提示信息, 含动画效果
--]]
function removePlayerTips(label, bg, suffix, tips)
	Common.log("removePlayerTips".." suffix = "..suffix)

	local function callBack()
		label:setVisible(false);
		bg:setVisible(false);

		if tips ~= nil then
			--tips不为空则需要更新气泡
			createTipsBg(suffix)
			createTipsTextLbl(suffix, tips)

			showBubbleAnimation(textTipsBg[suffix], textTipsLabel[suffix])
		end
	end

	hideBubbleAnimation(bg, label, callBack)
end

--[[--
--隐藏用户提示信息
--@param #number suffix 用户的座位号+1,传-1的时候表示隐藏所有的提示
--]]
function hidePlayerTips(suffix, tips)
--	Common.log("hidePlayerTips suffix = "..suffix .. "         tips = " .. tips)
	if suffix == -1 then
		for i = 1, table.maxn(textTipsBg) do
			if textTipsLabel[i] ~= nil and textTipsBg[i] ~= nil then
				removePlayerTips(textTipsLabel[i], textTipsBg[i], suffix, tips)
			end
		end
	else
		if textTipsLabel[suffix] ~= nil and textTipsBg[suffix] ~= nil then
			removePlayerTips(textTipsLabel[suffix], textTipsBg[suffix], suffix, tips)
		end
	end
end

--[[--
--显示用户提示信息
--@param #number SeatID 用户座位号
--@param #string tips 提示信息
--]]
function showPlayerTips(SeatID, tips)
	Common.log("用户提示信息 ==== SeatID == "..SeatID .. "       " .. tips)

	local suffix = TableConsole.getPlayerPosBySeat(SeatID) + 1

	hidePlayerChatTips(suffix)
	hideEmtion(suffix)

	if textTipsBg[suffix] == nil then
		createTipsBg(suffix)
		createTipsTextLbl(suffix, tips)

		showBubbleAnimation(textTipsBg[suffix], textTipsLabel[suffix])
	else
		hidePlayerTips(suffix, tips)
	end
end

--[[--
--bg:气泡背景
--content:气泡内容
--]]
function hideBubbleAnimation(bg, content, callBack)
	--添加气泡消失动画
	local scaleSmall = CCScaleTo:create(0.2, 0.5)
	local arr = CCArray:create()
	arr:addObject(scaleSmall)
	local seq = CCSequence:create(arr)
	bg:runAction(seq)

	--添加气泡里文字消失动画
	local scaleSmallLabel = CCScaleTo:create(0.2, 0.5)
	local arrLabel = CCArray:create()
	arrLabel:addObject(scaleSmallLabel)
	arrLabel:addObject(CCCallFunc:create(callBack))
	local seqLabel = CCSequence:create(arrLabel)
	content:runAction(seqLabel)
end

--[[--
--item:气泡元素，如气泡背景或文字等
--]]
function hideBubbleItemAnimation(item, callBack)
	local scaleSmall = CCScaleTo:create(0.2, 0.5)
	local arr = CCArray:create()
	arr:addObject(scaleSmall)
	arr:addObject(CCCallFunc:create(callBack))
	local seq = CCSequence:create(arr)
	item:runAction(seq)
end

--[[--
--bg:气泡背景
--content:气泡内容
--]]
function showBubbleAnimation(bg, content)
	Common.log("showBubbleAnimation")
	--添加气泡背景出来动画
	bg:setScale(0.1)
	local scaleBig = CCScaleTo:create(0.2, 1.1)
	local scaleSmall = CCScaleTo:create(0.1, 0.9)
	local scaleNormal = CCScaleTo:create(0.05, 1)
	local arr = CCArray:create()
	arr:addObject(scaleBig)
	arr:addObject(scaleSmall)
	arr:addObject(scaleNormal)
	local seq = CCSequence:create(arr)
	bg:runAction(seq)

	--添加气泡里面文字出来动画
	content:setScale(0.1)
	local scaleBig = CCScaleTo:create(0.2, 1.1)
	local scaleSmall = CCScaleTo:create(0.1, 0.9)
	local scaleNormal = CCScaleTo:create(0.05, 1)
	local arr = CCArray:create()
	arr:addObject(scaleBig)
	arr:addObject(scaleSmall)
	arr:addObject(scaleNormal)
	local seq = CCSequence:create(arr)
	content:runAction(seq)
end

--[[--
--创建气泡背景
--]]
function createTipsBg(suffix)
	Common.log("createTipsBg")
	if textTipsBg[suffix] ~= nil then
		textTipsBg[suffix]:removeFromParentAndCleanup(true)
		textTipsBg[suffix] = nil
	end

	if suffix == 1 or suffix == 3 then
		textTipsBg[suffix] = LordGamePub.createPointNineSprite(Common.getResourcePath("ui_desk_qipao.png"), 25, 25, 150, 61)
	else
		textTipsBg[suffix] = LordGamePub.createPointNineSprite(Common.getResourcePath("ui_desk_qipao_right.png"), 25, 25, 150, 61)
	end

	if suffix == 1 then
		--自己
		textTipsBg[suffix]:setPosition(TableConfig.EmtionPos[suffix][1], TableConfig.EmtionPos[suffix][2])
	elseif suffix == 3 then
		--上家
		textTipsBg[suffix]:setPosition(TableConfig.EmtionPos[suffix][1] - 50, TableConfig.EmtionPos[suffix][2])
	elseif suffix == 2 then
		--下家
		textTipsBg[suffix]:setPosition(TableConfig.EmtionPos[suffix][1] + 50, TableConfig.EmtionPos[suffix][2])
	end

	textTipsBg[suffix]:setAnchorPoint(ccp(0.5,0.5));
	TableElementLayer:addChild(textTipsBg[suffix]);
end

--[[--
--创建气泡文字
--]]
function createTipsTextLbl(suffix, tips)
	Common.log("createTipsTextLbl")
	if textTipsLabel[suffix] ~= nil then
		textTipsLabel[suffix]:removeFromParentAndCleanup(true)
		textTipsLabel[suffix] = nil
	end

	textTipsLabel[suffix] = CCLabelTTF:create("", "", 32)
	textTipsLabel[suffix]:setColor(ccc3(60,60,60))
	textTipsLabel[suffix]:setString(tips);
	textTipsLabel[suffix]:setAnchorPoint(ccp(0.5,0.5));
	textTipsLabel[suffix] = FontStyle.CCLabelTTFAddStroke(textTipsLabel[suffix], tips , "", 32, ccc3(60,60,60), ccc3(255, 255, 255), 2)
	if suffix == 1 then
		--自己
		if TableCardLayer.getHandCardsCnt() > 9 then
			textTipsLabel[suffix]:setPosition(TableConfig.EmtionPos[suffix][1] + 5, TableConfig.EmtionPos[suffix][2])
			textTipsBg[suffix]:setPosition(TableConfig.EmtionPos[suffix][1], TableConfig.EmtionPos[suffix][2])
		else
			--手牌不足9张对话气泡下移
			textTipsLabel[suffix]:setPosition(TableConfig.EmtionPos[suffix][1] + 5 + 30, TableConfig.EmtionPos[suffix][2] - 120)
			textTipsBg[suffix]:setPosition(TableConfig.EmtionPos[suffix][1] + 30, TableConfig.EmtionPos[suffix][2] - 120)
		end
	elseif suffix == 3 then
		--上家
		textTipsLabel[suffix]:setPosition(TableConfig.EmtionPos[suffix][1] + 5 - 50, TableConfig.EmtionPos[suffix][2])
	elseif suffix == 2 then
		--下家
		textTipsLabel[suffix]:setPosition(TableConfig.EmtionPos[suffix][1] - 5 + 50, TableConfig.EmtionPos[suffix][2])
	end
	TableElementLayer:addChild(textTipsLabel[suffix]);
end

--[[--
--隐藏飘字
--]]
local function hideFlyText()
	TableElementLayer:removeChild(flyLabel, true);
	flyLabel = nil;
	isFlyText = false;
	showServerMsg();
end

--[[--
--显示飘字
--]]
function showServerMsg()
	if not isFlyText and flyWords ~= nil and #flyWords > 0 then
		isFlyText = true;
		local msg = flyWords[1];
		table.remove(flyWords, 1);
		msg = string.gsub(msg,"|","\n")
		msg = string.gsub(msg,"-","")
		flyLabel = FontStyle.CCLabelTTFAddStroke(nil, msg, "", 36, ccc3(255, 241, 127), ccc3(132, 60 ,8), 2)
		flyLabel = FontStyle.CCLabelTTFAddOutlineAndShadow(flyLabel, msg, "", 36, ccc3(255, 241, 127), ccc3(132, 60 ,8), 2, 4, 191)
		flyLabel:setPosition(ccp(TableConfig.TableDefaultWidth / 2, TableConfig.TableDefaultHeight / 4))
		flyLabel:setZOrder(100)
		TableElementLayer:addChild(flyLabel);

		local ccmove = CCMoveBy:create(3,ccp(0, TableConfig.TableDefaultHeight / 2))
		local arr = CCArray:create()
		arr:addObject(ccmove)
		arr:addObject(CCCallFuncN:create(hideFlyText))
		local seq = CCSequence:create(arr)
		flyLabel:runAction(seq)
	end
end

--[[--
--添加飘字
--]]
function addServerMsg(ServerMsg)
	table.insert(flyWords, ServerMsg);
	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		showServerMsg();
	end
end

--[[--
--显示用户飞入
--]]
function showPlayerInfo()
	PauseSocket("showPlayerInfo");

	--[[
	if TableConsole.mode == TableConsole.MATCH and MatchRechargeCoin.bIsRechargeWaiting == false then
	--比赛中，并且不是在充值等待区时添加loading界面
	Common.showProgressDialog("牌局即将开始, 请稍后...")
	end
	]]

	for i = 1 , TableConsole.getPlayerCnt() - 1 do
		local seatID = TableConsole.getPlayerSeatByPos(i);
		local player = TableConsole.getPlayer(seatID);
		TableFlyUserInfo.showFlyUserInfo(player)
	end
end

--[[--
--设置结算Icon的透明度
--]]
function setTableResultAlpha(alpha)
	if alpha == 0 then
		isShowLadderPop = false
	end
	tableResult:setOpacity(alpha);
end

--[[--
--隐藏结算icon
--]]
function hideTableResult()
	isShowLadderPop = true
	tableResult:setVisible(false)
end

--[[--
--显示结算icon
--]]
function showTableResult()
	isShowLadderPop = true
	setTableResultAlpha(255)
	tableResult:setVisible(true)
end

--[[--
--隐藏宝箱
--]]
function hideBaoXiang()
	if baoxianglight ~= nil then
		baoxianglight:setVisible(false)
		baoxianglight:stopAllActions();
	end
	if baoxiang ~= nil then
		baoxiang:setVisible(false)
		baoxiang:stopAllActions();
	end
	if baoxianglabel ~= nil then
		baoxianglabel:setVisible(false)
	end
end

--[[--
--更新宝箱数据
--]]
function UpdataBaoXiangData()
	if baoxiang == nil then
		if TableConsole.RoomLevel == 0 then
			baoxiang = CCMenuItemImage:create(Common.getResourcePath("ic_activity_baoxiang_mu.png"), Common.getResourcePath("ic_activity_baoxiang_mu.png"))
		elseif TableConsole.RoomLevel == 1 then
			baoxiang = CCMenuItemImage:create(Common.getResourcePath("ic_activity_baoxiang_tie.png"), Common.getResourcePath("ic_activity_baoxiang_tie.png"))
		elseif TableConsole.RoomLevel == 2 then
			baoxiang = CCMenuItemImage:create(Common.getResourcePath("ic_activity_baoxiang_jin.png"), Common.getResourcePath("ic_activity_baoxiang_jin.png"))
		elseif TableConsole.RoomLevel == 3 then
			baoxiang = CCMenuItemImage:create(Common.getResourcePath("ic_activity_baoxiang_zuanshi.png"), Common.getResourcePath("ic_activity_baoxiang_zuanshi.png"))
		else
			baoxiang = CCMenuItemImage:create(Common.getResourcePath("ic_activity_baoxiang_zuanshi.png"), Common.getResourcePath("ic_activity_baoxiang_zuanshi.png"))
		end
		baoxiang:registerScriptTapHandler(baoxiangCallback)
		local menu = CCMenu:createWithItem(baoxiang)
		menu:setScale(0.8)
		menu:setPosition(960, -30)
		TableElementLayer:addChild(menu)
	end
	if baoxiang ~= nil and baoxianglabel ~= nil and baoxianglight ~= nil then
		if not baoxiang:isVisible() then
			baoxiang:setVisible(true)
		end
		baoxiang:stopAllActions();
		baoxiang:setScale(1);
		baoxiang:setRotation(0);
		if TableConsole.baohePro >= TableConsole.baoheMax then
			baoxianglight:setVisible(true)
			baoxianglight:runAction(CCRepeatForever:create(CCRotateBy:create(5,360)));
			LordGamePub.showShakeAnimate(baoxiang)
		else
			baoxianglight:stopAllActions();
			baoxianglight:setVisible(false)
		end
		TableElementLayer:removeChild(baoxianglabel, true)
		baoxianglabel = CCLabelTTF:create("", "", 28)
		baoxianglabel:setColor(ccc3(255, 255, 255))
		baoxianglabel:setPosition(1090, 15)
		baoxianglabel:setString(TableConsole.baohePro .. "/" .. TableConsole.baoheMax);
		baoxianglabel = FontStyle.CCLabelTTFAddStroke(baoxianglabel, TableConsole.baohePro .. "/" .. TableConsole.baoheMax , "", 28, ccc3(255, 255, 255), ccc3(0, 0, 0), 2)
		TableElementLayer:addChild(baoxianglabel)
	end
end

function shakeRight()
	local array = CCArray:create()
	array:addObject(CCRotateBy:create(0.02, 10))
	array:addObject(CCRotateBy:create(0.02, -10))
	array:addObject(CCCallFuncN:create(shakeLeft))
	ClockCCSprite:runAction(CCSequence:create(array))
end

function shakeLeft()
	local array = CCArray:create()
	array:addObject(CCRotateBy:create(0.02, -10))
	array:addObject(CCRotateBy:create(0.02, 10))
	array:addObject(CCCallFuncN:create(shakeRight))
	ClockCCSprite:runAction(CCSequence:create(array))
end

--[[--
--抖动闹钟
--]]
local function shakeClock()
	if ClockCCSprite ~= nil and ClockCCSprite:isVisible() then
		if TableConsole.getCurrPlayer() == TableConsole.getSelfSeat() then
			-- 自己的倒计时时，设备需要震动
			if GameConfig.getGameVibrate() then
				-- 设备开始震动
				Common.doVibrate()
			end
		end
		shakeRight();
	end
end

local CountdownCnt = 0;

--[[--
--倒计时计数
--]]
local function Countdown(sender)
	TableConsole.m_nCountdownCnt = TableConsole.m_nCountdownCnt - 1
	if TableConsole.getCurrPlayer() == TableConsole.getSelfSeat() then
		CountdownCnt = TableConsole.m_nCountdownCnt - TableConsole.INIT_TIMER_SELF_LOSS
	else
		CountdownCnt = TableConsole.m_nCountdownCnt
	end
	showTableWaitTips()
	if CountdownCnt > 0 then
		sender:setString(""..CountdownCnt);
		showClockCountdown();
		if CountdownCnt <= 5 then
			if CountdownCnt == 5 or (CountdownCnt == 4 and TableConsole.INIT_TIMER_SELF_LOSS == 10) then
				if ClockCCSprite ~= nil and ClockCCSprite:isVisible() then
					ClockCCSprite:stopAllActions();
					shakeClock()
				end
			end
			AudioManager.playLordSound(AudioManager.TableSound.DAOJISHI, false, AudioManager.SOUND);
		end
	else
		if TableConsole.getCurrPlayer() == TableConsole.getSelfSeat() then
			TableLogic.hideGameBtn();
			TableConsole.logicTimeDelayed();
			--自己的回合
			TableConsole.sendTableTrustPlayReq(2)
			ClockCCSprite:setVisible(false)
		else
			sender:setString(""..CountdownCnt);
		end
	end
end

--[[--
--显示倒计时
--]]
function showClockCountdown()
	if TableConsole.m_nGameStatus >= TableConsole.STAT_CALLSCORE and
		TableConsole.m_nGameStatus < TableConsole.STAT_GAME_RESULT then
		if TableConsole.getCurrPlayer() == TableConsole.getSelfSeat() then
			CountdownCnt = TableConsole.m_nCountdownCnt - TableConsole.INIT_TIMER_SELF_LOSS
		else
			CountdownCnt = TableConsole.m_nCountdownCnt
		end
		ClockCountdown:setString(""..CountdownCnt);
		local delay = CCDelayTime:create(1)
		local arr = CCArray:create()
		arr:addObject(delay)
		arr:addObject(CCCallFuncN:create(Countdown))
		local seq = CCSequence:create(arr)
		ClockCountdown:runAction(seq)
	end
end

--[[--
--设置显示闹钟
--]]
function showClock(SeatID)
	showTableWaitTips()
	if TableConsole.m_nGameStatus >= TableConsole.STAT_CALLSCORE and
		TableConsole.m_nGameStatus < TableConsole.STAT_GAME_RESULT then
		if SeatID == -1 then
			if ClockCCSprite ~= nil then
				ClockCCSprite:setVisible(false);
			end
			return
		end
		if ClockCCSprite ~= nil then
			if not ClockCCSprite:isVisible() then
				ClockCCSprite:setVisible(true)
			end
			ClockCCSprite:stopAllActions();
			ClockCCSprite:setRotation(0)
			local pos = TableConsole.getPlayerPosBySeat(SeatID)
			local offX = 0;
			local offY = 0;
			if pos == 1 then
				offX = -110
				offY = 0
			elseif pos == 2 then
				offX = 110
				offY = 0
			else
				offX = 0
				offY = 0
			end
			ClockCCSprite:setPosition(TableConfig.TableCardsPos[pos + 1][1] + offX, 400 + offY)
			ClockCountdown:stopAllActions();
			showClockCountdown()
		end
	end
end

--[[--
--隐藏闹钟
--]]
local function hideClock()
	ClockCCSprite:setVisible(false);
	ClockCCSprite:stopAllActions();
end

--[[--
--更新用户剩余牌数
--]]
function updataUserCardCnt()
	for i = 1, TableConsole.getPlayerCnt() - 1 do
		if PlayerCardCnt[i] ~= nil then
			if not PlayerCardCnt[i]:isVisible() then
				PlayerCardCnt[i]:setVisible(true)
			end
			PlayerCardCnt[i]:setString("" .. TableConsole.getPlayer(TableConsole.getPlayerSeatByPos(i)).m_nCardCnt)
		end
	end
end

--[[--
--隐藏用户剩余牌数
--]]
local function hidePlayerCardCnt()
	for i = 1, TableConsole.getPlayerCnt() - 1 do
		if PlayerCardCnt[i] ~= nil then
			PlayerCardCnt[i]:setVisible(false)
		end
	end
end

function hideElement()
	hideClock()--隐藏闹钟
	hidePlayerCardCnt()--隐藏玩家剩余牌数
end

--[[--
--更新个人头像
--]]
local function updataUserPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
	Common.log("photoPath ==== "..photoPath);
	if (photoPath ~= nil and photoPath ~= "" and iv_photo ~= nil) then
		local texture = CCTextureCache:sharedTextureCache():addImage(photoPath)
		iv_photo:setTexture(texture)
	end
end

--[[--
--设置牌桌上的用户信息
--]]
function setTableUserInfo()
	for i = 1 , TableConsole.getPlayerCnt() - 1 do
		local seatID = TableConsole.getPlayerSeatByPos(i);
		local player = TableConsole.getPlayer(seatID);
		Common.log("setTableUserInfo i ======== "..i)
		if player ~= nil and TableConsole.mode == TableConsole.ROOM then
			--用户存在
			local vipType = VIPPub.getUserVipType(player.mnVipLevel)
			if vipType >= VIPPub.VIP_1 then
				UserVipLevelLabelAtlas[i]:setString(""..vipType)
				if i == 1 then
					UserVipCoin[i]:setPosition(TableConfig.StandardPos[i + 1][1] - 50, TableConfig.StandardPos[i + 1][2] + 120)--用户vip标示
					UserVipLevelLabelAtlas[i]:setPosition(TableConfig.StandardPos[i + 1][1] + 7, TableConfig.StandardPos[i + 1][2] + 114)--用户vip等级
				elseif i == 2 then
					UserVipCoin[i]:setPosition(TableConfig.StandardPos[i + 1][1] - 30, TableConfig.StandardPos[i + 1][2] + 120)--用户vip标示
					UserVipLevelLabelAtlas[i]:setPosition(TableConfig.StandardPos[i + 1][1] + 27, TableConfig.StandardPos[i + 1][2] + 114)--用户vip等级
				end
				UserVipLevelLabelAtlas[i]:setVisible(true)
				UserVipCoin[i]:setVisible(true)
			else
				UserVipLevelLabelAtlas[i]:setVisible(false)
				UserVipCoin[i]:setVisible(false)
			end
		else
			UserVipLevelLabelAtlas[i]:setVisible(false)
			UserVipCoin[i]:setVisible(false)
		end
	end
end

--[[--
--更新用户信息
--]]
function updataUserInfo()
	Common.log("更新用户信息 =================")
	local photoUrl = profile.User.getSelfPhotoUrl()
	if photoUrl ~= nil and photoUrl ~= "" then
		Common.getPicFile(photoUrl, 0, true, updataUserPhoto)
	end

	TableLogic.updataUserCoin()

	-- 更新金币后，如果在比赛里，金币不足时，触发金币充值步骤
	MatchRechargeCoin.rechargeNext()
end

-- 隐藏移除动画
function hideAnim(sender)
	getElementLayer():removeChild(sender, true)
end

--移除聊天气泡
function showTextEnd(sender)
	--getElementLayer():removeChild(sender, true)

	local function callBack()
		sender:setVisible(false);
		--getElementLayer():removeChild(sender, true)
	end

	hideBubbleItemAnimation(sender, callBack)
end

function hideEmtionBg(sender)
	getElementLayer():removeChild(sender, true)
end

--表情背景
function setEmtionBg(curplace)
	local parentAnchorPoint
	local locX,locY
	locX = TableConfig.EmtionPos[curplace][1]
	locY =  TableConfig.EmtionPos[curplace][2]

	if chatEmtionBg[curplace] ~= nil then
		chatEmtionBg[curplace]:stopAllActions()
		chatEmtionBg[curplace]:removeFromParentAndCleanup(true)
		chatEmtionBg[curplace] = nil
	end

	chatEmtionBg[curplace] = LordGamePub.createPointNineSpriteByScaleWH(Common.getResourcePath("ui_desk_qipao.png"), 25, 10, 25,40 ,200, 140)

	if curplace == 1 then
		if TableCardLayer.getHandCardsCnt() > 9 then
			locY = locY + 30
		else
			--手牌不足9张对话气泡下移
			local offX = 10 + 5*(10 - TableCardLayer.getHandCardsCnt());
			local offY = - 80 - 5*(10 - TableCardLayer.getHandCardsCnt());
			if offX > 40 then
				offX = 40
			end
			if offY < -100 then
				offY = -100
			end
			locY = locY + 30 + offY
			locX = locX + offX
		end
	elseif curplace == 3 then
		locX = locX - 50
	elseif curplace == 2 then
		locX = locX + 50
	end
	if curplace == 1 or curplace == 3 then
		chatEmtionBg[curplace]:setScaleX(1)
		parentAnchorPoint = ccp(0.5,0.5)
	elseif curplace == 2 then
		chatEmtionBg[curplace]:setScaleX(-1)
		parentAnchorPoint = ccp(0.5,0.5)
	end
	chatEmtionBg[curplace]:setAnchorPoint(parentAnchorPoint)
	chatEmtionBg[curplace]:setPosition(locX,locY)
	chatEmtionBg[curplace]:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(5),CCCallFuncN:create(showTextEnd)))

	getElementLayer():addChild(chatEmtionBg[curplace])
end

--播放普通表情
function playChatCommonEmotion(pos, emotionIndex)
	if pos ~= nil then
		local curplace = pos + 1;

		emotionIndex = string.match(emotionIndex, "%d+")

		setEmtionBg(curplace)
		hidePlayerTips(curplace)
		hidePlayerChatTips(curplace)
		--    然后创建armature类，并将进行初始化
		if emtionImage[curplace] ~= nil then
			emtionImage[curplace]:stopAllActions()
			emtionImage[curplace]:removeFromParentAndCleanup(true)
			emtionImage[curplace] = nil
		end
		emtionImage[curplace] = CCArmature:create("putongbiaoqing")
		--    然后选择播放动画0，并进行缩放和位置设置
		emtionImage[curplace]:getAnimation():playByIndex(tonumber(emotionIndex) - 1)
		emtionImage[curplace]:setPosition(chatEmtionBg[curplace]:getPosition())
		emtionImage[curplace]:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(5.0),CCCallFuncN:create(showTextEnd)))
		--    最后将armature添加到场景中
		emtionImage[curplace]:setScale(1.5)
		getElementLayer():addChild(emtionImage[curplace])

		showBubbleAnimation(chatEmtionBg[curplace], emtionImage[curplace])
	end
end

--隐藏普通表情
function hideEmtion(suffix)
	if emtionImage[suffix] ~= nil and chatEmtionBg[suffix] ~= nil then
		TableElementLayer:removeChild(emtionImage[suffix], true);
		TableElementLayer:removeChild(chatEmtionBg[suffix], true);
		emtionImage[suffix] = nil
		chatEmtionBg[suffix] = nil
	end
end

--播放高级表情
function playChatSuperiorEmotion(pos, emotionIndex)
	if pos ~= nil then
		local curplace = pos + 1;

		emotionIndex = string.match(emotionIndex, "%d+")

		setEmtionBg(curplace)
		hidePlayerTips(curplace)
		hidePlayerChatTips(curplace)
		--    然后创建armature类，并将进行初始化
		emtionImage[curplace] = CCArmature:create("gaojibiaoqing")
		--    然后选择播放动画0，并进行缩放和位置设置
		emtionImage[curplace]:getAnimation():playByIndex(tonumber(emotionIndex) - 1)
		emtionImage[curplace]:setPosition(chatEmtionBg[curplace]:getPosition())
		emtionImage[curplace]:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(5.0),CCCallFuncN:create(showTextEnd)))
		--    最后将armature添加到场景中
		emtionImage[curplace]:setScale(1.5)
		getElementLayer():addChild(emtionImage[curplace])

		showBubbleAnimation(chatEmtionBg[curplace], emtionImage[curplace])
	end
end

--显示聊天气泡
function showChatText(pos, msg)
	--设置“不要”不显示
	--local curplace = TableConsole.getPlayerPosBySeat(pos) + 1
	local curplace = pos + 1
	--关闭表情和提示
	hideEmtion(curplace)
	hidePlayerTips(curplace)
	if TableConsole.m_aPlayer[curplace] then
		local index = #(ChatPopLogic.getChatLog())
		ChatPopLogic.getChatLog()[index+1] = {}
		local nSeat = TableConsole.getPlayerSeatByPos(pos)
		local p = TableConsole.getPlayer(nSeat)
		ChatPopLogic.getChatLog()[index+1].nickName = p.m_sNickName
		ChatPopLogic.getChatLog()[index+1].msg = msg
	end

	ChatPopLogic.upDataChatListToScrollView();

	local parentAnchorPoint;
	local locX,locY,ziX,ziY;
	locX = TableConfig.EmtionPos[curplace][1]
	locY =  TableConfig.EmtionPos[curplace][2]
	ziX = TableConfig.EmtionPos[curplace][1]
	ziY =  TableConfig.EmtionPos[curplace][2]
	parentAnchorPoint = ccp(0.5,0.5)

	--气泡文字label
	if textChatLabel[curplace] ~= nil then
		textChatLabel[curplace]:stopAllActions()
		textChatLabel[curplace]:removeFromParentAndCleanup(true)
		textChatLabel[curplace] = nil
	end

	textChatLabel[curplace] = CCLabelTTF:create(msg, "Arial", 25)
	local nameSize = textChatLabel[curplace]:getContentSize()
	if nameSize.width > 250 then
		--分多行显示
		--textChatLabel[curplace] = CCLabelTTF:create(msg, "Arial", 25, CCSizeMake(250, 0), kCCTextAlignmentLeft);
	end

	--气泡背景
	if textChatBg[curplace] ~= nil then
		textChatLabel[curplace]:stopAllActions()
		textChatBg[curplace]:removeFromParentAndCleanup(true)
		textChatBg[curplace] = nil
	end

	local size = CCSizeMake(textChatLabel[curplace]:getContentSize().width + 60 ,textChatLabel[curplace]:getContentSize().height + 40);
	if curplace == 2 then
		textChatBg[curplace] = LordGamePub.createPointNineSpriteByScaleWH(Common.getResourcePath("ui_desk_qipao_right.png"), 25, 10, 25, 40 , size.width, size.height);
	else
		textChatBg[curplace] = LordGamePub.createPointNineSpriteByScaleWH(Common.getResourcePath("ui_desk_qipao.png"), 25, 10, 25, 40 , size.width, size.height);
	end

	if curplace == 1 then
		--自己
		locX = locX + textChatBg[curplace]:getContentSize().width / 2 - 100;
		locY = locY + 20
		ziX = ziX+ textChatBg[curplace]:getContentSize().width / 2 - 100;
		ziY = ziY + 20
	elseif curplace == 3 then
		--上家
		locX = locX + textChatBg[curplace]:getContentSize().width / 2 - 100;
		ziX = ziX + textChatBg[curplace]:getContentSize().width / 2 - 100;
	elseif curplace == 2 then
		--下家
		locX = locX - textChatBg[curplace]:getContentSize().width / 2 + 100;
		ziX = ziX - textChatBg[curplace]:getContentSize().width / 2 + 100;
	end

	textChatLabel[curplace]:setColor(ccc3(0,0,0));

	if curplace == 1 or curplace == 3 then
		textChatBg[curplace]:setScaleX(1)
	elseif curplace == 2 then
		textChatBg[curplace]:setScaleX(-1)
	end
	textChatBg[curplace]:setPosition(locX, locY)
	textChatBg[curplace]:setAnchorPoint(parentAnchorPoint)
	textChatBg[curplace]:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(4),CCCallFuncN:create(showTextEnd)))

	textChatLabel[curplace]:setPosition(ziX, ziY)
	textChatLabel[curplace]:setAnchorPoint(parentAnchorPoint)
	textChatLabel[curplace] = FontStyle.CCLabelTTFAddStroke(textChatLabel[curplace], msg , "Arial", 25, ccc3(60,60,60), ccc3(255, 255, 255), 2)
	textChatLabel[curplace]:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(4),CCCallFuncN:create(showTextEnd)))

	getElementLayer():addChild(textChatBg[curplace])
	getElementLayer():addChild(textChatLabel[curplace])

	showBubbleAnimation(textChatBg[curplace], textChatLabel[curplace])
end
--[[--
--隐藏聊天气泡
--@param #number suffix 用户的座位号+1,传-1的时候表示隐藏所有的提示
--]]
function hidePlayerChatTips(suffix)
	if textChatLabel[suffix] ~= nil and textChatBg[suffix] ~= nil then
		local function callBack()
			TableElementLayer:removeChild(textChatLabel[suffix], true);
			TableElementLayer:removeChild(textChatBg[suffix], true);
			textChatLabel[suffix] = nil;
			textChatBg[suffix] = nil;
		end
		callBack()
	end
end

--判断说了一句话，选择音效
function checkChatMusic(contentname)
	if GameConfig.gameIsFullPackage() then
		for i=1,#chatMusicContent do
			local param1, param2 = string.find(contentname, chatMusicContent[i])
			if param1 and param2 then
				return AudioManager.TableVoice["CHAT_"..(i-1)]
			end
		end
	else
		return ""
	end
end

--[[--
-- 显示软引导动画:癞子提示
--]]--
function showSoftGuideOmniPotentTips()
	local locX = GameConfig.ScreenWidth * 3 / 4 + 50
	local locY = GameConfig.ScreenHeight * 4 / 5 + 80

	--文字label
	softGuidePopLabel = CCLabelTTF:create("癞子牌可以代替任何牌(除王以外)", "Arial", 25)
	--气泡
	local size = CCSizeMake(softGuidePopLabel:getContentSize().width + 60 ,softGuidePopLabel:getContentSize().height + 40);
	softGuidePopBg = LordGamePub.createPointNineSpriteByScaleWH(Common.getResourcePath("ui_desk_qipao.png"), 25, 10, 25, 40 , size.width, size.height);

	softGuidePopLabel:setColor(ccc3(0,0,0));

	softGuidePopBg:setPosition(locX,locY)
	softGuidePopBg:setAnchorPoint(ccp(0.5,0.5))
	softGuidePopBg:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(3),CCCallFuncN:create(showTextEnd)))
	softGuidePopLabel:setPosition(locX,locY)
	softGuidePopLabel:setAnchorPoint(ccp(0.5,0.5))
	softGuidePopLabel = FontStyle.CCLabelTTFAddStroke(softGuidePopLabel, "癞子牌可以代替任何牌(除王以外)" , "", 25, ccc3(60,60,60), ccc3(255, 255, 255), 2)
	softGuidePopLabel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(3),CCCallFuncN:create(showTextEnd)))

	getElementLayer():addChild(softGuidePopBg)
	getElementLayer():addChild(softGuidePopLabel)

	showBubbleAnimation(softGuidePopBg, softGuidePopLabel)
end

--[[--
-- 显示软引导动画:炸弹类型
--]]--
function showSoftGuideBomb()
	local locX = GameConfig.ScreenWidth / 2
	local locY = GameConfig.ScreenHeight / 2 + 100

	--手指图片 精灵
	softGuideFingerImg = CCSprite:create(Common.getResourcePath("bomb_tips.png"))
	softGuideFingerImg:setAnchorPoint(ccp(0.5,0.5))
	softGuideFingerImg:setPosition(locX,locY)

	local fadein = CCFadeIn:create(0.5)
	local fadeout = CCFadeOut:create(0.5)
	local delay2 = CCDelayTime:create(3)
	local array = CCArray:create();
	local function callBackFunc()
		getElementLayer():removeChild(softGuideFingerImg, true)
	end
	local callBack = CCCallFuncN:create(callBackFunc)

	array:addObject(fadein);
	array:addObject(delay2);
	array:addObject(fadeout);
	array:addObject(callBack);

	local seq = CCSequence:create(array);

	getElementLayer():addChild(softGuideFingerImg)

	softGuideFingerImg:runAction(seq);
end

--[[--
-- 显示软引导动画:更多指引
--]]--
function showSoftGuideMore()

	local locX = GameConfig.ScreenWidth * 5 / 6 - 75
	local locY = GameConfig.ScreenHeight * 2 / 3 + 100

	--文字label
	softGuidePopLabel = CCLabelTTF:create("更多功能在这里哦", "Arial", 25)
	--气泡
	local size = CCSizeMake(softGuidePopLabel:getContentSize().width + 60 ,softGuidePopLabel:getContentSize().height + 40);
	softGuidePopBg = LordGamePub.createPointNineSpriteByScaleWH(Common.getResourcePath("ui_desk_qipao_right.png"), 25, 10, 25, 40 , size.width, size.height);

	softGuidePopLabel:setColor(ccc3(0,0,0));

	local bgX = locX - 200
	local bgY = locY - 50

	movePoint = ccp(locX, locY - 70)

	softGuidePopBg:setPosition(bgX,bgY)
	--softGuidePopBg:setScale(-1)
	softGuidePopBg:setAnchorPoint(ccp(0.5,0.5))
	softGuidePopBg:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(3),CCCallFuncN:create(showTextEnd)))
	softGuidePopLabel:setPosition(bgX,bgY)
	softGuidePopLabel:setAnchorPoint(ccp(0.5,0.5))
	softGuidePopLabel = FontStyle.CCLabelTTFAddStroke(softGuidePopLabel, "更多功能在这里哦" , "", 25, ccc3(60,60,60), ccc3(255, 255, 255), 2)
	softGuidePopLabel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(3),CCCallFuncN:create(showTextEnd)))


	--手指图片 精灵
	softGuideFingerImg = CCSprite:create(Common.getResourcePath("ic_gerenziliao_tianti_level_schedule.png"))
	softGuideFingerImg:setRotation(-90)
	softGuideFingerImg:setAnchorPoint(ccp(0.5,0.5))
	softGuideFingerImg:setPosition(locX,locY - 50)
	local delay1 = CCDelayTime:create(0.5)
	local move1 = CCMoveTo:create(0.25,movePoint)
	local move2 = CCMoveTo:create(0.1,ccp(locX,locY - 50))
	local delay2 = CCDelayTime:create(1)
	local array = CCArray:create();
	local function callBackFunc()
		getElementLayer():removeChild(softGuideFingerImg, true)
	end
	local callBack = CCCallFuncN:create(callBackFunc)
	array:addObject(delay1);
	array:addObject(move1);
	array:addObject(move2);
	array:addObject(move1);
	array:addObject(move2);
	array:addObject(move1);
	array:addObject(move2);
	array:addObject(move1);
	array:addObject(delay2);
	array:addObject(callBack);

	local seq = CCSequence:create(array);

	getElementLayer():addChild(softGuidePopBg)
	getElementLayer():addChild(softGuidePopLabel)
	getElementLayer():addChild(softGuideFingerImg)

	showBubbleAnimation(softGuidePopBg, softGuidePopLabel)

	softGuideFingerImg:runAction(seq);
end

--[[--
-- 显示软引导动画:滑动选牌
--]]--
function showSoftGuideSlitherPick()

	local locX = GameConfig.ScreenWidth * 5 / 6 + 150
	local locY = GameConfig.ScreenHeight * 1 / 5 + 50

	--文字label
	softGuidePopLabel = CCLabelTTF:create("滑动可智能选牌", "Arial", 25)
	--气泡
	local size = CCSizeMake(softGuidePopLabel:getContentSize().width + 60 ,softGuidePopLabel:getContentSize().height + 40);
	softGuidePopBg = LordGamePub.createPointNineSpriteByScaleWH(Common.getResourcePath("ui_desk_qipao.png"), 25, 10, 25, 40 , size.width, size.height);

	softGuidePopLabel:setColor(ccc3(0,0,0));

	local bgX = locX - 200
	local bgY = locY + 100

	movePoint = ccp(locX - 400, locY - 100)

	softGuidePopBg:setPosition(bgX,bgY)
	softGuidePopBg:setAnchorPoint(ccp(0.5,0.5))
	softGuidePopBg:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2.5),CCCallFuncN:create(showTextEnd)))
	softGuidePopLabel:setPosition(bgX,bgY)
	softGuidePopLabel:setAnchorPoint(ccp(0.5,0.5))
	softGuidePopLabel = FontStyle.CCLabelTTFAddStroke(softGuidePopLabel, "滑动可智能选牌" , "", 25, ccc3(60,60,60), ccc3(255, 255, 255), 2)
	softGuidePopLabel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2.5),CCCallFuncN:create(showTextEnd)))

	--手指图片 精灵
	softGuideFingerImg = CCSprite:create(Common.getResourcePath("xiaoshou.png"))
	softGuideFingerImg:setAnchorPoint(ccp(0.5,0.5))
	softGuideFingerImg:setPosition(locX,locY - 100)
	local delay1 = CCDelayTime:create(0.5)
	local move1 = CCMoveTo:create(1,movePoint)
	local move2 = CCMoveTo:create(0.01,ccp(locX,locY - 100))
	local delay2 = CCDelayTime:create(0.2)
	local array = CCArray:create();
	local function callBackFunc()
		getElementLayer():removeChild(softGuideFingerImg, true)
	end
	local callBack = CCCallFuncN:create(callBackFunc)
	array:addObject(delay1);
	array:addObject(move1);
	array:addObject(delay1);
	array:addObject(move2);
	array:addObject(delay2);
	array:addObject(move1);
	array:addObject(delay1);
	array:addObject(callBack);

	local seq = CCSequence:create(array);

	getElementLayer():addChild(softGuidePopBg)
	getElementLayer():addChild(softGuidePopLabel)
	getElementLayer():addChild(softGuideFingerImg)

	showBubbleAnimation(softGuidePopBg, softGuidePopLabel)

	softGuideFingerImg:runAction(seq);
end

--[[--
-- 显示软引导动画:放弃选牌
--]]--
function showSoftGuideAbandon()
	--文字label
	softGuidePopLabel = CCLabelTTF:create("点击空白处取消选牌", "Arial", 25)
	--气泡
	local size = CCSizeMake(softGuidePopLabel:getContentSize().width + 60 ,softGuidePopLabel:getContentSize().height + 40);
	softGuidePopBg = LordGamePub.createPointNineSpriteByScaleWH(Common.getResourcePath("ui_desk_qipao.png"), 25, 10, 25, 40 , size.width, size.height);

	softGuidePopLabel:setColor(ccc3(0,0,0));

	local locX = GameConfig.ScreenWidth * 3 / 5
	local locY = GameConfig.ScreenHeight * 2 / 4 + 150
	softGuidePopBg:setPosition(locX + 100,locY)
	softGuidePopBg:setAnchorPoint(ccp(0.5,0.5))
	softGuidePopBg:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(3),CCCallFuncN:create(showTextEnd)))
	softGuidePopLabel:setPosition(locX + 100,locY)
	softGuidePopLabel:setAnchorPoint(ccp(0.5,0.5))
	softGuidePopLabel = FontStyle.CCLabelTTFAddStroke(softGuidePopLabel, "点击空白处取消选牌" , "", 25, ccc3(60,60,60), ccc3(255, 255, 255), 2)
	softGuidePopLabel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(3),CCCallFuncN:create(showTextEnd)))

	--手指图片 精灵
	softGuideFingerImg = CCSprite:create(Common.getResourcePath("xiaoshou.png"))
	softGuideFingerImg:setAnchorPoint(ccp(0.5,0.5))
	softGuideFingerImg:setPosition(locX,locY - 100)

	local delay1 = CCDelayTime:create(0.5)
	local rotateBy1 = CCRotateBy:create(0.1,-25)
	local rotateBy2 = CCRotateBy:create(0.1,25)
	local delay2 = CCDelayTime:create(1)
	local array = CCArray:create();
	local function callBackFunc()
		getElementLayer():removeChild(softGuideFingerImg, true)
	end
	local callBack = CCCallFuncN:create(callBackFunc)
	array:addObject(delay1);
	array:addObject(rotateBy1);
	array:addObject(rotateBy2);
	array:addObject(rotateBy1);
	array:addObject(rotateBy2);
	array:addObject(delay2);
	array:addObject(rotateBy1);
	array:addObject(rotateBy2);
	array:addObject(rotateBy1);
	array:addObject(rotateBy2);
	array:addObject(delay1);
	array:addObject(callBack);

	local seq = CCSequence:create(array);

	getElementLayer():addChild(softGuidePopBg)
	getElementLayer():addChild(softGuidePopLabel)
	getElementLayer():addChild(softGuideFingerImg)

	showBubbleAnimation(softGuidePopBg, softGuidePopLabel)

	softGuideFingerImg:runAction(seq);
end


function reomveAllElementLayer()
	GameArmature.removeArmature();
	if jipaiqiLogic.view ~= nil then
		jipaiqiLogic.view:removeFromParentAndCleanup(true)
		jipaiqiLogic.releaseData()
		jipaiqiLogic.view = nil
	end

	atlasview = nil -- 遮罩view
	atlas = nil -- 倒计时
	SelfVipCoin = nil--自己的VIP图片
	SelfVipLevelLabelAtlas = nil--自己的VIP等级
	baoxianglight = nil
	baoxiang = nil--宝箱
	baoxianglabel = nil--宝箱数字
	PlayerCardCnt = {}--存放剩余牌数
	tableResult = nil--结算
	ttWuFaShengDuan = nil;
	ClockCCSprite = nil--闹钟精灵
	UserVipCoin = {}--用户vip标示
	UserVipLevelLabelAtlas = {}--用户vip等级
	isFlyText = false;--是否正在显示飘字
	flyLabel = nil;--飘字label
	flyWords = {}--飘字
	textTipsLabel = {}--人物叫分/抢地主/加倍提示文字
	textTipsBg = {}--人物叫分/抢地主/加倍提示背景
	WinCoinLabelAtlasTable = {}--输赢金币
	playOutImageTable = {}
	DoubleIcon = {}--加倍图标
	TableDetailText = nil;--牌桌房间信息提示label
	TableCrazyMissionText = nil;--疯狂闯关关数label
	TableWaitTips = nil;--牌桌等待提示label
	TableCostLabel = nil
	iv_photo = nil--头像
	iv_photo_bg = nil--头像背景框
	ivPhotoAmin = nil
	ivPhotoAmin_half = nil
	isFlyText = nil

	TableElementLayer:stopAllActions();
	TableElementLayer:removeFromParentAndCleanup(true);
	TableElementLayer = nil
end

--[[--
-- 新用户金币不足提醒显示软引导动画
--]]--
function showNewUserSoftGuideTips(num)
	local newUserIsThird = Common.LoadTable("newUserIsThird"); --保证调用三次之后就不调用了
	if newUserIsThird == nil then
		newUserIsThird = {}
		newUserIsThird[1] = 1	-- 1: 自己手头金币不足无法正常赢
		newUserIsThird[2] = 1	-- 2：对手手头金币不足，无法正常赢
		newUserIsThird[3] = 1	-- 3：对手手头金币不足，无法正常输
		newUserIsThird[4] = 1	-- 4: 用户托管
	end
	if newUserIsThird[num] <= 3 then
		-- 3: 只允许3次
		newUserIsThird[num] = newUserIsThird[num] + 1
		Common.SaveTable("newUserIsThird", newUserIsThird)
	else
		return
	end


	local pWinSize=CCDirector:sharedDirector():getWinSize()
	--	pWinSize=CCDirector:sharedDirector():getVisibleWinSize()
	local locX = pWinSize.width * 0.5
	local locY
	if num == 4 then
	--4：用户托管
		locY = pWinSize.height * 0.65
	else
		locY = pWinSize.height * 0.5
	end
	--气泡
	local size = CCSizeMake(softGuideAnimationLabel:getContentSize().width + 60 ,softGuideAnimationLabel:getContentSize().height + 100);
	softGuideAnimationBg = LordGamePub.createPointNineSpriteByScaleWH(Common.getResourcePath("ui_ddz_BG.png"), 10, 40, 10, 40 ,size.width, size.height);

	softGuideAnimationLabel:setColor(ccc3(255,255,255));

	softGuideAnimationBg:setPosition(locX,locY)
	softGuideAnimationBg:setAnchorPoint(ccp(0.5,0.5))
	getElementLayer():addChild(softGuideAnimationBg)

	softGuideAnimationLabel:setPosition(locX,locY)
	softGuideAnimationLabel:setAnchorPoint(ccp(0.5,0.5))
	getElementLayer():addChild(softGuideAnimationLabel)

	showBubbleAnimation(softGuideAnimationBg, softGuideAnimationLabel)

	local delay = CCDelayTime:create(5)
	local array = CCArray:create()
	array:addObject(delay)

	array:addObject(CCCallFuncN:create(function()
		local function callBack()
			getElementLayer():removeChild(softGuideAnimationBg,true)
			getElementLayer():removeChild(softGuideAnimationLabel,true)
		end

		hideBubbleAnimation(softGuideAnimationBg, softGuideAnimationLabel, callBack)
	end
	))
	local seq = CCSequence:create(array)
	getElementLayer():runAction(seq)
end


--[[--
--新用户金币不足提醒
--]]
function newUserLackCoinWarm(isWin,num)
	Common.log("zblnum= " .. num)
	local GameResult = profile.GameDoc.getGameResultData()
	if GameResult["PlayerList"][num+1].m_nAccountsType == 0 then
	-- 0:正常输赢
	elseif GameResult["PlayerList"][num+1].m_nAccountsType == 1 then
		-- 1：自己手头金币不足无法正常输赢
		if isWin then
			softGuideAnimationLabel = CCLabelTTF:create("您手头的金币为" .. GameResult["PlayerList"][num+1].m_nHandCoin .. "，\n 故最多只能赢取" .. GameResult["PlayerList"][num+1].m_nHandCoin .. "金币", "Arial", 25)
			showNewUserSoftGuideTips(1)
			-- 1: 自己手头金币不足无法正常赢
		else
			Common.log("自己金币不足，输了")
		end
	elseif GameResult["PlayerList"][num+1].m_nAccountsType == 2 then
		-- 2：对手手头金币不足，无法正常输赢
		if isWin then
			Common.log("对手金币不足，但赢了                      " .. GameResult["PlayerList"][num+1].m_nopponentNickName)
			softGuideAnimationLabel = CCLabelTTF:create(GameResult["PlayerList"][num+1].m_nopponentNickName .. "  输光了，\n 您无法赢取更多金币。" , "Arial", 25)
			showNewUserSoftGuideTips(2)
			-- 2：对手手头金币不足，无法正常赢
		else
			Common.log("对手金币不足，输了     "  .. GameResult["PlayerList"][num+1].m_nopponentNickName)
			softGuideAnimationLabel = CCLabelTTF:create(GameResult["PlayerList"][num+1].m_nopponentNickName .. " 金币不足，\n 无法赢取您更多金币。", "Arial", 25)
			showNewUserSoftGuideTips(3)
			-- 3：对手手头金币不足，无法正常输
		end
	end
end

function setSameTime()
	isSameTime = false
end

--[[--
--托管提醒
--]]
function trustAlert(nSeatID)
	if TableConsole.getPlayer(TableConsole.getSelfSeat()).m_bIsLord == false
		and TableConsole.getPlayer(TableConsole.getLeftSeat()).m_bIsLord == false
		and TableConsole.getPlayer(TableConsole.getRightSeat()).m_bIsLord == false then
			Common.log("还未确认出地主")
			return
	end
	if isSameTime  then
		-- 是同一局
		Common.log("同一局")
		return
	else
		isSameTime = true
	end
	if nSeatID == TableConsole.getSelfSeat() then
		--自己
		if TableConsole.getPlayer(TableConsole.getSelfSeat()).m_nCardCnt <= 1 then
			--自己手牌为1张时
			return
		end
		if TableConsole.getPlayer(TableConsole.getSelfSeat()).m_bIsLord then
			softGuideAnimationLabel = CCLabelTTF:create("您托管了，系统自动过牌", "Arial", 25)
		else
			softGuideAnimationLabel = CCLabelTTF:create("您托管了，若失败将负担\n未托管农民的损失 !", "Arial", 25)
		end
	elseif nSeatID == TableConsole.getLeftSeat() then
		--上家
		if TableConsole.getPlayer(TableConsole.getLeftSeat()).m_nCardCnt <= 1 then
			--上家手牌为1张时
			return
		end
		if TableConsole.getPlayer(TableConsole.getLeftSeat()).m_bIsLord then
			--上家是地主
			softGuideAnimationLabel = CCLabelTTF:create("上家托管了，系统自动过牌", "Arial", 25)
		else
			softGuideAnimationLabel = CCLabelTTF:create("上家托管了，若失败将负担\n未托管农民的损失 !", "Arial", 25)
		end
	elseif nSeatID == TableConsole.getRightSeat() then
		--下家
		if TableConsole.getPlayer(TableConsole.getRightSeat()).m_nCardCnt <= 1 then
			--下家手牌为1张时
			return
		end
		if TableConsole.getPlayer(TableConsole.getRightSeat()).m_bIsLord then
			--下家是地主
			softGuideAnimationLabel = CCLabelTTF:create("下家托管了，系统自动过牌", "Arial", 25)
		else
			softGuideAnimationLabel = CCLabelTTF:create("下家托管了，若失败将负担\n未托管农民的损失 !", "Arial", 25)
		end
	end
	showNewUserSoftGuideTips(4)
	-- 4: 用户托管
end