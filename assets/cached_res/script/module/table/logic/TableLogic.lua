--牌桌，底层
module("TableLogic", package.seeall)
view = nil

Panel_bg = nil--背景
Panel_bottom = nil--底部区
Panel_top = nil--顶部区
Panel_Top_Button = nil--顶部菜单
Panel_Table_Button = nil--顶部牌桌按钮
Panel_Table_Info = nil -- 顶部按钮底数和基数
Panel_CentreButton = nil--中部按钮区
Panel_takeout = nil--出牌控制
Panel_opencard_start = nil--明牌开始控制
Panel_callscore = nil--叫分控制
Panel_call_landlord = nil--叫地主控制
Panel_grab_landlord = nil--抢地主控制
Panel_doublescore = nil--加倍控制
Panel_open_takeout = nil--地主首次出牌明牌控制
Panel_open_initcard = nil--发牌阶段明牌控制
Panel_Trust_Play = nil--托管控制
Panel_game_start = nil--开始控制(普通房间)
Panel_left_score = nil -- 上家积分panel
Panel_right_score = nil -- 下家积分panel
Panel_120 = nil

LabelAtlas_beishu = nil--当前倍数
LabelAtlas_difen = nil--底分
Label_coin = nil--金币
Label_jifen = nil-- 积分
label_right_jifen = nil -- 下家积分
label_left_jifen = nil -- 上家积分
Label_time = nil -- 系统时间
Label_939 = nil -- 用户排名信息lbl

Label_PromptMsg = nil -- 牌桌顶部提示信息

topMenuShowModel = 0 -- 顶部菜单栏显示模式：0-未知 1-底数和基数菜单栏 2-设置菜单栏

Button_top_show = nil--显示顶部菜单按钮
button_recharge = nil--充值
button_gift = nil--礼包
iv_light = nil--礼包后面的光
button_exit = nil--退出
button_chat = nil--聊天
button_setting = nil--设置
button_tuoguan = nil--托管
btn_match_ranking = nil--比赛排名

iv_jinbi = nil--金币标示
iv_jifen = nil -- 积分标示
iv_difen = nil--底分标示
--出牌按钮
btn_takeout_right = nil
btn_takeout_centre = nil
btn_takeout_left = nil
iv_takeout_right = nil
iv_takeout_centre = nil
iv_takeout_left = nil

--明牌开始按钮
btn_opencard_start_right = nil
btn_opencard_start_left = nil
Image_fengkuangchuangguan = nil
--叫分按钮
btn_callscore_right = nil
btn_callscore_centre_right = nil
btn_callscore_centre_left = nil
btn_callscore_left = nil
--叫地主按钮
btn_call_landlord_right = nil
btn_call_landlord_left = nil
--抢地主按钮
btn_grab_landlord_right = nil
btn_grab_landlord_left = nil
--加倍按钮
btn_doublescore_right = nil
btn_doublescore_centre = nil
btn_doublescore_left = nil
--地主首次出牌明牌按钮
btn_open_takeout_right = nil
btn_open_takeout_left = nil
--发牌阶段明牌开始按钮
btn_open_initcard = nil
--显示明牌倍数
iv_open_initcard = nil
--解除托管按钮
btn_Trust_Play = nil
--开始按钮
btn_game_start = nil
--牌桌背景
ImageView_background = nil

--加倍图片
panel_beishudonghua = nil
image_beishu = nil
labelAtlas_beishu = nil

MenuCountdown = 0;

--普通模式踢人按钮 left:上家 ; right:下家
btn_game_start_kick_left = nil
btn_game_start_kick_right = nil

panel_topleft = nil
Image_battery = nil
Image_battery1 = nil
Image_battery2 = nil
Image_battery3 = nil

Image_wifi_bg = nil
Image_wifi1 = nil
Image_wifi2 = nil
Image_wifi3 = nil

Panel_PassCard = nil;--
btn_PassCard = nil;-- 要不起
iv_Trust_Play = nil;--



lastReceiveHBTimeLong = -1 --记录上次接收到心跳消息时得时间戳

--light精灵
local lightSprite = nil
local btnPullPosY = 0
local menuBgPosY = 0

--[[
设置顶部栏菜单按钮能否点击
]]
function setTopMenuButtonTouchEnabled(bValue)
	button_exit:setTouchEnabled(bValue)
	button_chat:setTouchEnabled(bValue)
	button_setting:setTouchEnabled(bValue)
	button_tuoguan:setTouchEnabled(bValue)
end

--[[--
--更新系统信息:时间、电量
--]]
local function updateSysInfo()
	--系统时间
	local Hour = os.date("%H", Common.getServerTime());
	local Minute = os.date("%M", Common.getServerTime());
	Label_time:setText(Hour..":"..Minute);

	--系统剩余电量
	local currBatteryLevel = Common.getDeviceBatteryLevel()
	updateBatteryImageByValue(currBatteryLevel)
end

--[[
检测设备当前网络情况
]]
function updateNetworkStatus()
	if view == nil then
		--牌桌界面不存在时直接返回
		return
	end

	if lastReceiveHBTimeLong == -1 then
		--第一次接收到心跳
		lastReceiveHBTimeLong = Common.getServerTime()
	end

	local currentReceiveHBTimeLong = Common.getServerTime()
	local interval = currentReceiveHBTimeLong - lastReceiveHBTimeLong
	--[[
	Common.log("心跳回来了 lastReceiveHBTimeLong = "..lastReceiveHBTimeLong)
	Common.log("心跳回来了 currentReceiveHBTimeLong = "..currentReceiveHBTimeLong)
	Common.log("心跳回来了 interval = "..interval)
	]]
	if interval >= 0 and interval <= 5 then
		--网络信号强
		Image_wifi_bg:stopAllActions()

		Image_wifi1:setVisible(true)
		Image_wifi2:setVisible(true)
		Image_wifi3:setVisible(true)
	elseif interval > 5 and interval <= 10 then
		--网络信号中
		Image_wifi_bg:stopAllActions()

		Image_wifi1:setVisible(true)
		Image_wifi2:setVisible(true)
		Image_wifi3:setVisible(false)
	elseif interval > 10 and interval <= 15 then
		--网络信号弱
		Image_wifi_bg:stopAllActions()

		Image_wifi1:setVisible(true)
		Image_wifi2:setVisible(false)
		Image_wifi3:setVisible(false)
	else
		--网络信号无
		Image_wifi1:setVisible(false)
		Image_wifi2:setVisible(false)
		Image_wifi3:setVisible(false)
		Image_wifi4:setVisible(false)

		--执行快没电时的动画
		local arr = CCArray:create()
		local delay1 = CCDelayTime:create(0.16)
		local delay2 = CCDelayTime:create(0.88)
		arr:addObject(delay1)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_wifi4:setVisible(true)
			end
		))
		arr:addObject(delay1)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_wifi4:setVisible(false)
			end
		))
		arr:addObject(delay1)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_wifi4:setVisible(true)
			end
		))

		arr:addObject(delay1)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_wifi4:setVisible(true)
			end
		))
		arr:addObject(delay1)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_wifi4:setVisible(false)
			end
		))
		arr:addObject(delay1)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_wifi4:setVisible(true)
			end
		))

		arr:addObject(delay1)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_wifi4:setVisible(true)
			end
		))
		arr:addObject(delay1)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_wifi4:setVisible(false)
			end
		))
		arr:addObject(delay1)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_wifi4:setVisible(true)
			end
		))

		arr:addObject(delay2)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_wifi4:setVisible(false)
			end
		))
		Image_wifi_bg:runAction(CCRepeatForever:create(CCSequence:create(arr)))
	end

	lastReceiveHBTimeLong = currentReceiveHBTimeLong
end

--[[
根据剩余电量值，更新图片标示
nBatteryLevel:剩余电量
]]
function updateBatteryImageByValue(nBatteryLevel)
	if nBatteryLevel == -1 then
		--错误
		return
	end

	if nBatteryLevel > 70 then
		Image_battery1:setVisible(true)
		Image_battery2:setVisible(true)
		Image_battery3:setVisible(true)

		Image_battery:stopAllActions()
	elseif nBatteryLevel > 40 then
		Image_battery1:setVisible(true)
		Image_battery2:setVisible(true)
		Image_battery3:setVisible(false)

		Image_battery:stopAllActions()
	elseif nBatteryLevel > 10 then
		Image_battery1:setVisible(true)
		Image_battery2:setVisible(false)
		Image_battery3:setVisible(false)

		Image_battery:stopAllActions()
	else
		Image_battery1:setVisible(false)
		Image_battery2:setVisible(false)
		Image_battery3:setVisible(false)

		--执行快没电时的动画
		local arr = CCArray:create()
		local delay1 = CCDelayTime:create(3)
		local delay2 = CCDelayTime:create(0.5)
		local delay3 = CCDelayTime:create(0.15)
		arr:addObject(delay1)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_battery:loadTexture(Common.getResourcePath("ui_desk_battery_no.png"))
			end
		))
		arr:addObject(delay2)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_battery:loadTexture(Common.getResourcePath("ui_desk_battery0.png"))
			end
		))
		arr:addObject(delay2)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_battery:loadTexture(Common.getResourcePath("ui_desk_battery_no.png"))
			end
		))
		arr:addObject(delay3)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_battery:loadTexture(Common.getResourcePath("ui_desk_battery0.png"))
			end
		))
		arr:addObject(delay3)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_battery:loadTexture(Common.getResourcePath("ui_desk_battery_no.png"))
			end
		))
		arr:addObject(delay3)
		arr:addObject(CCCallFuncN:create(
			function()
				Image_battery:loadTexture(Common.getResourcePath("ui_desk_battery0.png"))
			end
		))

		Image_battery:runAction(CCSequence:create(arr))
	end
end

--[[
执行加倍动画
nBeishu:倍数
]]
function exeDoubleAnimation(nBeishu)
	local function animationCallback()
		panel_beishudonghua:setVisible(false)
	end

	image_beishu:setScale(0.1)
	labelAtlas_beishu:setScale(0.1)
	labelAtlas_beishu:setStringValue(""..nBeishu)
	panel_beishudonghua:setVisible(true)

	local scaleBig = CCScaleTo:create(0.2, 1.1)
	local scaleSmall = CCScaleTo:create(0.1, 0.9)
	local scaleNormal = CCScaleTo:create(0.05, 1)
	local arr = CCArray:create()
	arr:addObject(scaleBig)
	arr:addObject(scaleSmall)
	arr:addObject(scaleNormal)
	local seq = CCSequence:create(arr)
	image_beishu:runAction(seq)

	local scaleBig1 = CCScaleTo:create(0.2, 1.1)
	local scaleSmall1 = CCScaleTo:create(0.1, 0.9)
	local scaleNormal1 = CCScaleTo:create(0.05, 1)
	local arr1 = CCArray:create()
	arr1:addObject(scaleBig1)
	arr1:addObject(scaleSmall1)
	arr1:addObject(scaleNormal1)
	arr1:addObject(CCDelayTime:create(1))
	arr1:addObject(CCCallFunc:create(animationCallback))
	local seq1 = CCSequence:create(arr1)
	labelAtlas_beishu:runAction(seq1)
end

--[[--
-- 3.03初始化牌桌
--]]
local function initView()
	Panel_bottom = cocostudio.getUIPanel(view, "Panel_bottom")--底部区
	Panel_top = cocostudio.getUIPanel(view, "Panel_top")--顶部区
	Panel_Top_Button = cocostudio.getUIPanel(view, "Panel_Top_Button")--顶部菜单
	menuBgPosY = Panel_Top_Button:getPosition().y

	Panel_Table_Button = cocostudio.getUIPanel(view, "Panel_Table_Button") -- 顶部设置按钮panel
	Panel_Table_Info = cocostudio.getUIPanel(view, "Panel_Table_Info") -- 顶部底数和基数按钮panel

	Panel_CentreButton = cocostudio.getUIPanel(view, "Panel_CentreButton")--中部按钮区
	Panel_bg = cocostudio.getUIPanel(view, "Panel_bg")--背景
	Panel_takeout = cocostudio.getUIPanel(view, "Panel_takeout")--出牌控制
	Panel_opencard_start = cocostudio.getUIPanel(view, "Panel_opencard_start")--明牌开始控制
	Panel_callscore = cocostudio.getUIPanel(view, "Panel_callscore")--叫分控制
	Panel_call_landlord = cocostudio.getUIPanel(view, "Panel_call_landlord")--叫地主控制
	Panel_grab_landlord = cocostudio.getUIPanel(view, "Panel_grab_landlord")--抢地主控制
	Panel_doublescore = cocostudio.getUIPanel(view, "Panel_doublescore")--加倍控制
	Panel_open_takeout = cocostudio.getUIPanel(view, "Panel_open_takeout")--地主首次出牌明牌控制
	Panel_open_initcard = cocostudio.getUIPanel(view, "Panel_open_initcard")--发牌阶段明牌控制
	Panel_Trust_Play = cocostudio.getUIPanel(view, "Panel_Trust_Play")--托管控制
	Panel_game_start = cocostudio.getUIPanel(view, "Panel_game_start")--开始控制

	Panel_left_score = cocostudio.getUIPanel(view, "Panel_left_score")
	Panel_left_score:setVisible(false);

	Panel_right_score = cocostudio.getUIPanel(view, "Panel_right_score")
	Panel_right_score:setVisible(false);

	Panel_120 = cocostudio.getUIPanel(view, "Panel_120")

	button_recharge = cocostudio.getUIButton(view, "button_recharge")--快速充值
	button_gift = cocostudio.getUIButton(view, "button_gift")--礼包
	Common.setButtonVisible(button_gift, false)
	iv_light = cocostudio.getUIImageView(view,"ImageView_782")
	iv_light:runAction(CCRepeatForever:create(CCRotateBy:create(2, 360)))

	Button_top_show = cocostudio.getUIButton(view, "Button_top_show")--显示顶部菜单按钮
	btnPullPosY = Button_top_show:getPosition().y

	button_exit = cocostudio.getUIButton(view, "button_exit")--退出
	button_chat = cocostudio.getUIButton(view, "button_chat")--聊天
	button_setting = cocostudio.getUIButton(view, "button_setting")--设置
	button_jipai = cocostudio.getUIButton(view, "button_jipai")--记牌器

	button_tuoguan = cocostudio.getUIButton(view, "button_tuoguan")--托管
	btn_match_ranking = cocostudio.getUIButton(view, "btn_match_ranking")--比赛排名

	--出牌按钮
	btn_takeout_right = cocostudio.getUIButton(view, "btn_takeout_right")
	btn_takeout_centre = cocostudio.getUIButton(view, "btn_takeout_centre")
	btn_takeout_left = cocostudio.getUIButton(view, "btn_takeout_left")

	iv_takeout_right = cocostudio.getUIImageView(view, "iv_takeout_right")
	iv_takeout_centre = cocostudio.getUIImageView(view, "iv_takeout_centre")
	iv_takeout_left = cocostudio.getUIImageView(view, "iv_takeout_left")

	--明牌开始按钮
	btn_opencard_start_right = cocostudio.getUIButton(view, "btn_opencard_start_right")
	btn_opencard_start_left  = cocostudio.getUIButton(view, "btn_opencard_start_left")

	--叫分按钮
	btn_callscore_right = cocostudio.getUIButton(view, "btn_callscore_right")
	btn_callscore_centre_right = cocostudio.getUIButton(view, "btn_callscore_centre_right")
	btn_callscore_centre_left = cocostudio.getUIButton(view, "btn_callscore_centre_left")
	btn_callscore_left = cocostudio.getUIButton(view, "btn_callscore_left")
	--叫地主按钮
	btn_call_landlord_right = cocostudio.getUIButton(view, "btn_call_landlord_right")
	btn_call_landlord_left = cocostudio.getUIButton(view, "btn_call_landlord_left")
	--抢地主按钮
	btn_grab_landlord_right = cocostudio.getUIButton(view, "btn_grab_landlord_right")
	btn_grab_landlord_left = cocostudio.getUIButton(view, "btn_grab_landlord_left")
	--加倍按钮
	btn_doublescore_right = cocostudio.getUIButton(view, "btn_doublescore_right")
	btn_doublescore_centre = cocostudio.getUIButton(view, "btn_doublescore_centre")
	btn_doublescore_left = cocostudio.getUIButton(view, "btn_doublescore_left")
	--地主首次出牌明牌按钮
	btn_open_takeout_right = cocostudio.getUIButton(view, "btn_open_takeout_right")
	btn_open_takeout_left = cocostudio.getUIButton(view, "btn_open_takeout_left")
	--发牌阶段明牌开始按钮
	btn_open_initcard = cocostudio.getUIButton(view, "btn_open_initcard")
	iv_open_initcard = cocostudio.getUIImageView(view, "iv_open_initcard")
	iv_open_initcard:loadTexture(Common.getResourcePath("ui_open_deal_4.png"))
	--解除托管
	btn_Trust_Play = cocostudio.getUIButton(view, "btn_Trust_Play")
	--开始按钮
	btn_game_start = cocostudio.getUIButton(view, "btn_game_start")
	--牌桌背景
	ImageView_background = cocostudio.getUIImageView(view, "ImageView_background")

	--加倍图片
	panel_beishudonghua = cocostudio.getUIPanel(view, "Panel_beishudonghua")
	panel_beishudonghua:setAnchorPoint(ccp(0, 0)) --panel的锚点如果不为0，里面的空间布局会有问题
	image_beishu = cocostudio.getUIImageView(view, "Image_103")
	image_beishu:setZOrder(10000)
	labelAtlas_beishu = cocostudio.getUILabelAtlas(view, "AtlasLabel_104")
	labelAtlas_beishu:setZOrder(10000)
	panel_beishudonghua:setVisible(false)

	--疯狂闯关logo
	Image_fengkuangchuangguan = cocostudio.getUIImageView(view, "Image_fengkuangchuangguan");
	if TableConsole.isCrazyStage == false then
		Image_fengkuangchuangguan:setVisible(false)
	end

	iv_jinbi = cocostudio.getUIImageView(view, "iv_jinbi")
	iv_jifen = cocostudio.getUIImageView(view, "iv_jinbi_0_0")

	iv_difen = cocostudio.getUIImageView(view, "iv_difen")

	Label_PromptMsg = cocostudio.getUILabel(view, "Label_122")
	Label_PromptMsg:setText("")

	iv_beishu = cocostudio.getUILabel(view, "iv_beishu")

	LabelAtlas_beishu = cocostudio.getUILabelAtlas(view, "LabelAtlas_beishu")--当前倍数
	LabelAtlas_beishu:setStringValue("0")
	LabelAtlas_difen = cocostudio.getUILabelAtlas(view, "LabelAtlas_difen")--底分
	if TableConsole.mode == TableConsole.ROOM and TableConsole.m_nRoombaseChip ~= nil then
		LabelAtlas_difen:setStringValue(""..TableConsole.m_nRoombaseChip)
	else
		LabelAtlas_difen:setVisible(false)
	end

	Label_coin = cocostudio.getUILabel(view, "Label_coin")--金币
	Label_coin:setText(profile.User.getSelfCoin())
	Label_jifen = cocostudio.getUILabel(view, "Label_jifensuipian_0")
	Label_jifen:setText("")

	Label_right_jifen = cocostudio.getUILabel(view, "Label_jifensuipian_1_0")
	Label_left_jifen = cocostudio.getUILabel(view, "Label_jifensuipian_1")

	Label_939 = cocostudio.getUILabel(view, "Label_939")
	Label_939:setText("")

	Label_time = cocostudio.getUILabel(view, "Label_time")

	panel_topleft = cocostudio.getUIPanel(view, "panel_topleft")

	Image_battery = cocostudio.getUIImageView(view, "Image_battery")
	Image_battery1 = cocostudio.getUIImageView(view, "Image_battery1")
	Image_battery2 = cocostudio.getUIImageView(view, "Image_battery2")
	Image_battery3 = cocostudio.getUIImageView(view, "Image_battery3")

	Image_wifi_bg = cocostudio.getUIImageView(view, "Image_wifi_bg")
	Image_wifi1 = cocostudio.getUIImageView(view, "Image_wifi1")
	Image_wifi2 = cocostudio.getUIImageView(view, "Image_wifi2")
	Image_wifi3 = cocostudio.getUIImageView(view, "Image_wifi3")
	Image_wifi4 = cocostudio.getUIImageView(view, "Image_wifi4")
	Image_wifi4:setVisible(false)

	--要不起按钮
	Panel_PassCard = cocostudio.getUIPanel(view, "Panel_PassCard");
	btn_PassCard = cocostudio.getUIButton(view, "btn_PassCard");
	iv_Trust_Play = cocostudio.getUIImageView(view, "iv_Trust_Play");
	Panel_PassCard:setTouchEnabled(false)
	setYaobuqiState(false)

	--第一次更新系统信息
	updateSysInfo()

	--每20秒更新一次
	local arr = CCArray:create()
	local delay = CCDelayTime:create(20)
	arr:addObject(delay)
	arr:addObject(CCCallFuncN:create(updateSysInfo))
	Label_time:runAction(CCRepeatForever:create(CCSequence:create(arr)))

	-- 如果是房间，需要隐藏一些UI
	if TableConsole.mode == TableConsole.ROOM then
		Panel_120:setVisible(false)
		iv_jifen:loadTexture(Common.getResourcePath("ic_sign_suipian.png"))
	end

	-- 设置顶部菜单默认显示底数和基数
	topMenuShowModel = 1
	exchangeTopMenu()

	getKickButton();

	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Common.getResourcePath("card.plist"))

	view:addChild(TableCardLayer.getCardLayer())
	view:addChild(TableElementLayer.getElementLayer())

	TableElementLayer.showServerMsg()

	setRoomOrMatchTable()

	--动画
	GameArmature.initTableArmature()

	--	local handCards = {37,24,11,36,23,10,48,35,22,40,27,14}--AAAKKKQQQ444
	--	local handCards = {36,23,10,48,35,22,40,27,14,1}--KKKQQQ4444
	--	local handCards = {1,2,2,3,29,3,28,40}--3laizi
	--	0==3
	--	1==4
	--	2==5
	--	3==6
	--	4==7
	--	5==8
	--	6==9
	--	7==10
	--	8==J
	--	9==Q
	--	10==K
	--	11==A
	--	12==2
	--	13==XIAO
	--	14==DA
	--牌型提示测试
	--	TableConsole.m_nSeatID = 0;
	--	TableConsole.m_aPlayer = {};
	--	TableConsole.m_nUserCnt = 3
	--	TableConsole.mnLaiziCardVal = 1
	--	TableConsole.m_nGameStatus = TableConsole.STAT_CALLSCORE
	--	for i = 1, TableConsole.m_nUserCnt do
	--		TableConsole.m_aPlayer[i] = TablePayer:new();
	--
	--		local nSeatID = i - 1;
	--		TableConsole.m_aPlayer[i].m_nSeatID = nSeatID;
	--		TableConsole.m_aPlayer[i].m_nPos = TableConsole.getPlayerPosBySeat(nSeatID);
	--	end
	--	local handCards = {11,24,37,50,12,25,0,13,2,3}--顺子/连对/三同张/飞机
	--
	--	--	local handCards = {4,4,7,7,9,9,11,11,12}
	--	--  local handCards = {0,0,0,0,1,11,12}
	--
	--	TableCardLayer.addHandCard(handCards, true)
	--	TableCardLayer.refreshHandCards()
	--
	--	TableCardManage.initData(TableCardLayer.getSelfCards())
	--
	--	--  local tableCard = {0,1,2,3,4,5,6}--顺子
	--	--	local tableCard = {0,0,1,1,2,2}--连对
	--	--	local tableCard = {0,0,0}--三同张
	--	--	local tableCard = {0,0,0,1,1,1}--飞机（无翅膀）
	--	--	local tableCard = {0,0,0,1,1,1,2,2}--飞机（翅膀）
	--	--	local tableCard = {0,0,0,1,1,1,2,2,3,3}--飞机（翅膀）
	--	--	local tableCard = {0,13,26,1}
	--	local tableCard = {10,23,36,49,12,25,4,17}
	--	local alCardList = {};
	--	for i = 1,  #tableCard do
	--		local cardData = TableTakeOutCard:new()
	--		-- ... HunCardVal byte 癞子牌变化后的牌值
	--		local nEndVal = tableCard[i];
	--		-- ... OriginalCardVal byte 癞子牌变化前的原始牌值
	--		local OriginalCardVal = tableCard[i];
	--		cardData.mnTheOriginalValue = OriginalCardVal;
	--		cardData.mnTheEndValue = nEndVal;
	--		table.insert(alCardList, cardData)
	--	end
	--	TableCardLayer.addTableCard(alCardList, 1)
	--	TableCardLayer.refreshTableCardsBySeat(1)
	--	TableCardLayer.setAllHandCardsMarked(false)
	--	TableCardLayer.setCardLayerTouchEnabled(true)
	--牌型提示测试end

	--showGiftIcon();

	TableElementLayer.showTableDetailText();

	CommDialogConfig.closeLogicTime();
end

--[[--
--设置牌桌按键是否可用(用于新手引导)
--]]
function setTableButtonEnabled(Enabled)
	TableCardLayer.setCardLayerTouchEnabled(Enabled)
	TableLogic.view:setTouchEnabled(Enabled)
	TableElementLayer.setPhotoEnabled(Enabled)
end

--[[--
--显示礼包图标
--]]
function showGiftIcon()
	if CommDialogConfig.getNewUserGiudeFinish() then
		--完成新手引导
		if profile.Gift.isShowFirstGiftIcon() then
			button_gift:loadTextures(Common.getResourcePath("ic_hall_shouchong.png"), Common.getResourcePath("ic_hall_shouchong.png"), "")
		else
			button_gift:loadTextures(Common.getResourcePath("ic_hall_recharge.png"), Common.getResourcePath("ic_hall_recharge.png"), "")
		end
		Common.setButtonVisible(button_gift, true)
	else
		--没完成新手引导
		Common.setButtonVisible(button_gift, false)
	end
end

--[[--
--显示退出牌桌提示界面
--]]
function showExitView()
	mvcEngine.createModule(GUI_TABLE_EXIT);
	TableExitLogic.setExitText(TableExitLogic.getTableExitType().LORD_TABLE);
end

--[[--
--退出牌桌逻辑判断
--]]
function eixtTableLogic()
	if TableConsole.mode == TableConsole.MATCH then
		showExitView();
	elseif TableConsole.mode == TableConsole.ROOM then
		if (TableConsole.m_nGameStatus == TableConsole.STAT_WAITING_TABLE or
			TableConsole.m_nGameStatus == TableConsole.STAT_GAME_RESULT or
			TableConsole.m_nGameStatus == TableConsole.STAT_WAITING_READY) then
			if (TableConsole.m_bSendContinue) then
				showExitView();
			else
				TableLogic.exitLordTable()
			end
		else
			showExitView();
		end
	end
end

function onKeypad(event)
	if event == "backClicked" then
		if NewUserGuideLogic.getNewUserFlag() then
			mvcEngine.createModule(GUI_SKIPNEWUSERGUIDE);
		else
			eixtTableLogic();
		end
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("Table.json")
	local gui = GUI_TABLE
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)

	GameConfig.setTheCurrentBaseLayer(GUI_TABLE);

	initView();

	hideGameBtn();

	Common.closeProgressDialog();
	ResumeSocket("createView");
end

--[[--
--设置房间/比赛背景及音乐
--]]
function setRoomOrMatchTable()
	if TableConsole.isCrazyStage == false then
		ImageView_background:loadTexture(Common.getResourcePath("ui_lord_bg2.png"));
	else
		if GameConfig.gameIsFullPackage() then
			ImageView_background:loadTexture(Common.getResourcePath("lord_game_res/chuangguan.png"));
		else
			ImageView_background:loadTexture(Common.getResourcePath("ui_lord_bg2.png"));
		end
	end

	ImageView_background:setScaleX(GameConfig.ScreenWidth / ImageView_background:getContentSize().width)
	ImageView_background:setScaleY(GameConfig.ScreenHeight / ImageView_background:getContentSize().height)

	if (TableConsole.mode == TableConsole.ROOM) then
		TableElementLayer.setTableCostLabelVisible(true)
		Common.setButtonVisible(btn_match_ranking, false);
		AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.ROOM_BACKGROUND);
		iv_jinbi:loadTexture(Common.getResourcePath("ic_hall_recharge_jinbi.png"));
		iv_difen:loadTexture(Common.getResourcePath("ic_desk_difen.png"));
	elseif (TableConsole.mode == TableConsole.MATCH) then
		Common.setButtonVisible(btn_match_ranking, true);
		AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.MATCH_BACKGROUND);
		iv_jinbi:loadTexture(Common.getResourcePath("ic_hall_recharge_jinbi.png"));
		iv_jifen:loadTexture(Common.getResourcePath("ic_macth_jifen.png"));
		iv_difen:loadTexture(Common.getResourcePath("ic_desk_jishu.png"));
	end
end

--[[--
--更新用户金币/积分
--]]
function updataUserCoin()
	if Label_coin ~= nil then
		if (TableConsole.mode == TableConsole.ROOM) then
			Common.log("自己的剩余金币："..profile.User.getSelfCoin())
			Common.log("自己的碎片金币："..profile.User.getSelfdjqPieces())
			Label_coin:setText(profile.User.getSelfCoin())
			Label_jifen:setText(profile.User.getSelfdjqPieces())
		elseif (TableConsole.mode == TableConsole.MATCH) then
			if Label_coin ~= nil then
				-- 因为牌局结束之后m_aPlayer为空，不能从这里获取玩家信息，所以直接从profile里获取自己的金币数量，刷新界面
				Label_coin:setText(profile.User.getSelfCoin())
			end
			if TableConsole.getPlayer(TableConsole.getSelfSeat()) ~= nil then
				Common.log("自己的积分:"..TableConsole.getPlayer(TableConsole.getSelfSeat()).scoreCnt)
				Label_jifen:setText(TableConsole.getPlayer(TableConsole.getSelfSeat()).scoreCnt)
			end
			if TableConsole.getPlayer(TableConsole.getPlayerSeatByPos(1)) ~= nil then
				-- 下家的积分
				Panel_right_score:setVisible(true)
				Label_right_jifen:setText(TableConsole.getPlayer(TableConsole.getPlayerSeatByPos(1)).scoreCnt)
			end
			if TableConsole.getPlayer(TableConsole.getPlayerSeatByPos(2)) ~= nil then
				-- 上家的积分
				Panel_left_score:setVisible(true)
				Label_left_jifen:setText(TableConsole.getPlayer(TableConsole.getPlayerSeatByPos(2)).scoreCnt)
			end
		end
	end
end

--[[
设置上下家的积分是否显示
bVisible:是否显示
]]
function setOtherUserScore(bVisible)
	Panel_right_score:setVisible(bVisible)
	Panel_left_score:setVisible(bVisible)
end

--[[--
--显示牌桌结果界面
--]]
function showGameResultView()
	if MatchRechargeCoin.bIsRechargeWaiting == true then
		-- 如果是在充值等待区时，不显示结算界面
		ResumeSocket("readGameResult");
		return
	end
	LabelAtlas_difen:setVisible(true)
	LabelAtlas_beishu:setVisible(true)
	mvcEngine.createModule(GUI_TABLE_GAME_RESULT)
end

--[[--
--隐藏底金数与倍数
--]]
function hideGameResultDifenAndBeishu()
	LabelAtlas_difen:setVisible(false)
	LabelAtlas_beishu:setVisible(false)
end

--[[--
--退出牌桌
--]]
function exitLordTable()
	TableConsole.ExitTableForMsg()

	TableConsole.resetCrazy()
	--	GameConfig.setTheLastBaseLayer(GUI_TABLE)
	HallLogic.setLastLayer(true);
--	mvcEngine.createModule(GUI_HALL)

	mvcEngine.createModule(GameConfig.getTheLastBaseLayer())
--	LordGamePub.showBaseLayerAction(view)
end

function requestMsg()
	--如果不是断线续玩,才创建覆盖层
	if not NewUserCreateLogic.getNewUserGameSync() then
		NewUserCreateLogic.FinishStateInterface();
	end

	sendBAOHE_V4_GET_PRO(TableConsole.m_nRoomID);
end


--[[--
--设置发牌时明牌按钮状态
--]]
function setOpenInitCardsButton()
	if iv_open_initcard ~= nil then
		if TableCardLayer.OpenInitCard == 4 then
			--显示四倍明牌
			iv_open_initcard:loadTexture(Common.getResourcePath("ui_open_deal_4.png"))
			Common.newSetButtonScale(btn_open_initcard, 1.8, 1.5)
		elseif  TableCardLayer.OpenInitCard == 3 then
			--显示三倍明牌
			iv_open_initcard:loadTexture(Common.getResourcePath("ui_open_deal_3.png"))
			Common.newSetButtonScale(btn_open_initcard, 1.8, 1.5)
		elseif  TableCardLayer.OpenInitCard == 2 then
			--显示二倍明牌
			iv_open_initcard:loadTexture(Common.getResourcePath("ui_open_deal_2.png"))
			Common.newSetButtonScale(btn_open_initcard, 1.8, 1.5)
		end
	end
end

--[[--
--更新倍数
--@param #number val 倍数(-1为不显示)
--@param #boolean isShowBig 是否变大
--]]
function updataTableMultiple(val, isShowBig)
	if isShowBig then
		local scaleBig = CCScaleTo:create(0.25, 2)
		local scaleSmall = CCScaleTo:create(0.25, 1.2)
		local arr = CCArray:create()
		arr:addObject(scaleBig)
		arr:addObject(scaleSmall)
		local seq = CCSequence:create(arr)
		LabelAtlas_beishu:runAction(seq)
	end

	if val < 0 then
		LabelAtlas_beishu:setVisible(false)
	else
		LabelAtlas_beishu:setStringValue(""..val);
		LabelAtlas_beishu:setVisible(true)
	end
end

--[[--
--更新底分
--@param #number val 倍数(-1为不显示)
--]]
function updataTableBaseChip(val)
	if val < 0 then
		LabelAtlas_difen:setVisible(false)
	else
		LabelAtlas_difen:setStringValue(""..val);
		LabelAtlas_difen:setVisible(true)
	end
end

--[[--
--设置菜单按钮是否可用
--]]
local function setTableMenuTouchEnabled(isVisible)
	Button_top_show:setTouchEnabled(isVisible)
	button_exit:setTouchEnabled(isVisible)
	button_chat:setTouchEnabled(isVisible)
	button_setting:setTouchEnabled(isVisible)
	button_jipai:setTouchEnabled(isVisible)
	button_tuoguan:setTouchEnabled(isVisible)
end

--[[--
--显示菜单动画结束
--]]
local function TableMenuShowAnimEnd()
	--显示
	setTableMenuTouchEnabled(true)
	Button_top_show:loadTextures(Common.getResourcePath("ui_desk_top3_nor.png"), Common.getResourcePath("ui_desk_top3_press.png"), "")
	Button_top_show:setTouchEnabled(true)
end

--[[--
--菜单按钮显示动画完毕
--]]
local function showTableButtonAnimEnd()
	setTableMenuTouchEnabled(true)
	MenuCountdown = 0;
	upMenuCountdown();
end

--[[--
--显示记牌器逻辑
--]]
function showJiPaiAnim()
	--先判断背包是不是有记牌器
	if profile.Pack.getJipaiqiValidDate() > 0 then
		Common.log("已经购买过记牌器")
		if jipaiqiLogic.bJipaiqiViewDidShow == true then
			jipaiqiLogic.hideJipaiqiView()
		else
			jipaiqiLogic.showJipaiqiView()
		end
	else
		Common.log("未购买过记牌器")
		if jipaiqiLogic.bJipaiqiBuyViewDidShow == true then
			jipaiqiLogic.hideBuyJipaiqiView()
		else
			jipaiqiLogic.showBuyJipaiqiView()
		end
	end
end

--[[
更新记牌器有效期
]]
function updateJipaiqiYouxiaoqi()
	if view ~= nil then
		--获取记牌器的剩余时间，单位为小时
		local jipaiqiValidDate = profile.Pack.getJipaiqiValidDate()
		jipaiqiLogic.updateJipaiqiYouxiaoqiView(jipaiqiValidDate)
	end
end

--[[--
--当前是否显示出牌按钮
--]]
function isShowTakeoutButton()
	if Panel_takeout:isVisible() or Panel_open_takeout:isVisible() then
		return true
	else
		return false
	end
end

--开始按钮(普通房间)
local function setGameStartButtonVisible(Visible)
	Panel_game_start:setVisible(Visible)
	Panel_game_start:setTouchEnabled(Visible)
	Common.setButtonVisible(btn_game_start, Visible)
end

--解除托管按钮
local function setTrustPlayButtonVisible(Visible)
	Panel_Trust_Play:setVisible(Visible)
	Panel_Trust_Play:setTouchEnabled(Visible)
	Common.setButtonVisible(btn_Trust_Play, Visible)
end

--[[--
--判断出牌按钮是否可用
--]]
function logicTakeoutButtonEnabled()
	Common.log("判断出牌按钮是否可用 ========= ");
	if TableCardLayer.isNotSelectCard() then
		--如果没有选中的牌
		--出牌按钮不可用
		btn_takeout_right:loadTextures(Common.getResourcePath("btn_dark0.png"), Common.getResourcePath("btn_dark0.png"), "")
		btn_takeout_right:setTouchEnabled(false);

		iv_takeout_right:loadTexture(Common.getResourcePath("ui_takeout_text3_3.png"))

		--		Panel_PassCard:setVisible(true)
		--		btn_PassCard:setVisible(true)
		--		Panel_PassCard:setTouchEnabled(true)
	else
		--出牌按钮可用
		btn_takeout_right:loadTextures(Common.getResourcePath("btn_gerenziliao0.png"), Common.getResourcePath("btn_gerenziliao0.png"), "")
		btn_takeout_right:setTouchEnabled(true);

		iv_takeout_right:loadTexture(Common.getResourcePath("ui_takeout_text3_2.png"))

		--		Panel_PassCard:setVisible(false)
		--		btn_PassCard:setVisible(false)
		--		Panel_PassCard:setTouchEnabled(false)
	end
end

--出牌按钮
local function setTakeoutButtonVisible(Visible)
	Panel_takeout:setVisible(Visible)
	Panel_takeout:setTouchEnabled(Visible)
	Common.setButtonVisible(btn_takeout_right, Visible)
	Common.setButtonVisible(btn_takeout_centre, Visible)
	Common.setButtonVisible(btn_takeout_left, Visible)
	if TableConsole.m_nGameStatus == TableConsole.STAT_TAKEOUT and TableCardLayer.getIsNewBout(TableConsole.getSelfSeat()) then
		--如果是自己自由出牌回合
		--不要、提示不可用
		btn_takeout_left:loadTextures(Common.getResourcePath("btn_dark0.png"), Common.getResourcePath("btn_dark0.png"), "")
		btn_takeout_left:setTouchEnabled(false)
		btn_takeout_centre:loadTextures(Common.getResourcePath("btn_dark0.png"), Common.getResourcePath("btn_dark0.png"), "")
		btn_takeout_centre:setTouchEnabled(false)

		iv_takeout_left:loadTexture(Common.getResourcePath("ui_takeout_text0_1.png"))
		iv_takeout_centre:loadTexture(Common.getResourcePath("ui_takeout_text2_1.png"))
	else
		btn_takeout_left:loadTextures(Common.getResourcePath("btn_green.png"), Common.getResourcePath("btn_green.png"), "")
		btn_takeout_centre:loadTextures(Common.getResourcePath("btn_green.png"), Common.getResourcePath("btn_green.png"), "")

		iv_takeout_left:loadTexture(Common.getResourcePath("ui_takeout_text0.png"))
		iv_takeout_centre:loadTexture(Common.getResourcePath("ui_takeout_text2.png"))
	end
	if Visible then
		logicTakeoutButtonEnabled();
	end
end

--明牌开始按钮
local function setOpencardStartButtonVisible(Visible)
	Panel_opencard_start:setVisible(Visible)
	Panel_opencard_start:setTouchEnabled(Visible)
	Common.setButtonVisible(btn_opencard_start_right, Visible)
	Common.setButtonVisible(btn_opencard_start_left, Visible)
	if TableConsole.isCrazyStage == true then
		Image_fengkuangchuangguan:setVisible(Visible)
		if Visible == true then
			TableElementLayer.showTableCrazyMissionText()
		else
			TableElementLayer.hideTableCrazyMissionText();
		end
	else
		Image_fengkuangchuangguan:setVisible(false)
		TableElementLayer.hideTableCrazyMissionText();
	end
end

--叫分按钮
local function setCallscoreButtonVisible(Visible)
	Panel_callscore:setVisible(Visible)
	Panel_callscore:setTouchEnabled(Visible)
	Common.setButtonVisible(btn_callscore_right, Visible)
	Common.setButtonVisible(btn_callscore_centre_right, Visible)
	Common.setButtonVisible(btn_callscore_centre_left, Visible)
	Common.setButtonVisible(btn_callscore_left, Visible)
end

--叫地主按钮
local function setCallLandlordButtonVisible(Visible)
	Panel_call_landlord:setVisible(Visible)
	Panel_call_landlord:setTouchEnabled(Visible)
	Common.setButtonVisible(btn_call_landlord_right, Visible)
	Common.setButtonVisible(btn_call_landlord_left, Visible)
end

--抢地主按钮
local function setGrabLandlordButtonVisible(Visible)
	Panel_grab_landlord:setVisible(Visible)
	Panel_grab_landlord:setTouchEnabled(Visible)
	Common.setButtonVisible(btn_grab_landlord_right, Visible)
	Common.setButtonVisible(btn_grab_landlord_left, Visible)
end

--加倍按钮
local function setDoublescoreButtonVisible(Visible)
	Panel_doublescore:setVisible(Visible)
	Panel_doublescore:setTouchEnabled(Visible)
	Common.setButtonVisible(btn_doublescore_right, Visible)
	Common.setButtonVisible(btn_doublescore_centre, Visible)
	Common.setButtonVisible(btn_doublescore_left, Visible)
end

--地主首次出牌明牌按钮
local function setOpenTakeoutButtonVisible(Visible)
	Panel_open_takeout:setVisible(Visible)
	Panel_open_takeout:setTouchEnabled(Visible)
	Common.setButtonVisible(btn_open_takeout_right, Visible)
	Common.setButtonVisible(btn_open_takeout_left, Visible)
end

--发牌阶段明牌开始按钮
local function setOpenInitcardButtonVisible(Visible)
	Panel_open_initcard:setVisible(Visible)
	Panel_open_initcard:setTouchEnabled(Visible)
	Common.setButtonVisible(btn_open_initcard, Visible)
end

--开始踢人按钮
local function setStartKickButtonVisible(Visible)
	Common.setButtonVisible(btn_game_start_kick_right, Visible)
	Common.setButtonVisible(btn_game_start_kick_left, Visible)
end

--[[--
--获取踢人按钮控件
--]]
function getKickButton()
	btn_game_start_kick_left = cocostudio.getUIButton(view, "btn_game_start_kick1")
	btn_game_start_kick_right = cocostudio.getUIButton(view, "btn_game_start_kick2")
	setStartKickButtonVisible(false)
end
--[[--
--隐藏牌桌按钮
--]]
function hideGameBtn()
	setGameStartButtonVisible(false)
	setTrustPlayButtonVisible(false)
	setTakeoutButtonVisible(false)
	setOpencardStartButtonVisible(false)
	setCallscoreButtonVisible(false)
	setCallLandlordButtonVisible(false)
	setGrabLandlordButtonVisible(false)
	setDoublescoreButtonVisible(false)
	setOpenTakeoutButtonVisible(false)
	setOpenInitcardButtonVisible(false)
end

--[[--
--根据当前已经叫到的分值显示叫分按钮
--]]
function setCallScoreBtn(m_nCurrCallScore)
	btn_callscore_right:setTouchEnabled(true)
	btn_callscore_centre_right:loadTextures(Common.getResourcePath("btn_gerenziliao0.png"), Common.getResourcePath("btn_gerenziliao0.png"), "")
	btn_callscore_centre_right:setTouchEnabled(true)
	btn_callscore_centre_left:loadTextures(Common.getResourcePath("btn_gerenziliao0.png"), Common.getResourcePath("btn_gerenziliao0.png"), "")
	btn_callscore_centre_left:setTouchEnabled(true)
	btn_callscore_left:setTouchEnabled(true)
	if m_nCurrCallScore == 1 then
		btn_callscore_centre_left:loadTextures(Common.getResourcePath("btn_dark0.png"), Common.getResourcePath("btn_dark0.png"), "")
		btn_callscore_centre_left:setTouchEnabled(false)
	elseif m_nCurrCallScore == 2 then
		btn_callscore_centre_left:loadTextures(Common.getResourcePath("btn_dark0.png"), Common.getResourcePath("btn_dark0.png"), "")
		btn_callscore_centre_left:setTouchEnabled(false)
		btn_callscore_centre_right:loadTextures(Common.getResourcePath("btn_dark0.png"), Common.getResourcePath("btn_dark0.png"), "")
		btn_callscore_centre_right:setTouchEnabled(false)
	end
end

--[[--
--设置托管按钮显示
--]]
function changeTrustPlayButton(isShow)
	if isShow then
		--显示解脱按钮时，不显示其他按钮
		hideGameBtn()
	end
	setTrustPlayButtonVisible(isShow)
end

--[[--
--设置开始按钮显示
--]]
function changeGameStartButton(isShow)

	if TableConsole.mnTableType == TableConsole.TABLE_TYPE_HAPPY or TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT then
		--明牌开始控制
		hideGameBtn()
		setOpencardStartButtonVisible(isShow)
	else
		--开始控制
		hideGameBtn()
		setGameStartButtonVisible(isShow)
	end
end

--[[--
--设置踢人按钮显示
--]]
function changeKickButton(isShow)
	setStartKickButtonVisible(isShow)
end

--[[--
--隐藏某个踢人按钮(根据位置)
--]]
function hideKickButton(number)
	if number == TableConsole.RIGHT_PLAYER_NUMBER then
		Common.setButtonVisible(btn_game_start_kick_right, false)
	elseif number == TableConsole.LEFT_PLAYER_NUMBER then
		Common.setButtonVisible(btn_game_start_kick_left, false)
	end
end
--[[--
--变换牌桌按钮显示
--]]
function changeShowButtonPanel(CurrBtnType)
	hideGameBtn()
	Common.log("CurrBtnType ======= "..CurrBtnType)
	if CurrBtnType == TableConsole.Button_takeout then
		--出牌控制
		setTakeoutButtonVisible(true)
		--		--牌桌软引导动画 选牌提示
		--		TableConsole.softGuideTable = Common.LoadShareTable(TableConsole.softGuideTableText)
		--		if TableConsole.softGuideTable == nil then
		--			TableElementLayer.showSoftGuideSlitherPick()
		--			TableConsole.softGuideTable = {}
		--			TableConsole.softGuideTable[profile.User.getSelfUserID()] = {}
		--			TableConsole.softGuideTable[profile.User.getSelfUserID()].pick = true
		--			Common.SaveShareTable(TableConsole.softGuideTableText,TableConsole.softGuideTable)
		--		elseif TableConsole.softGuideTable[profile.User.getSelfUserID()] == nil then
		--			TableElementLayer.showSoftGuideSlitherPick()
		--			TableConsole.softGuideTable[profile.User.getSelfUserID()] = {}
		--			TableConsole.softGuideTable[profile.User.getSelfUserID()].pick = true
		--			Common.SaveShareTable(TableConsole.softGuideTableText,TableConsole.softGuideTable)
		--		elseif softGuideTable[profile.User.getSelfUserID()].pick == nil then
		--			TableElementLayer.showSoftGuideSlitherPick()
		--			TableConsole.softGuideTable[profile.User.getSelfUserID()].pick = true
		--			Common.SaveShareTable(TableConsole.softGuideTableText,TableConsole.softGuideTable)
		--		end

		--		--牌桌软引导动画 癞子提示
		--		if TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT then
		--			TableConsole.softGuideTable = Common.LoadShareTable(TableConsole.softGuideTableText)
		--			if TableConsole.softGuideTable == nil then
		--				TableElementLayer.showSoftGuideOmniPotentTips()
		--				TableConsole.softGuideTable = {}
		--				TableConsole.softGuideTable[profile.User.getSelfUserID()] = {}
		--				TableConsole.softGuideTable[profile.User.getSelfUserID()].omni = true
		--				Common.SaveShareTable(TableConsole.softGuideTableText,TableConsole.softGuideTable)
		--			elseif TableConsole.softGuideTable[profile.User.getSelfUserID()] == nil then
		--				TableElementLayer.showSoftGuideOmniPotentTips()
		--				TableConsole.softGuideTable[profile.User.getSelfUserID()] = {}
		--				TableConsole.softGuideTable[profile.User.getSelfUserID()].omni = true
		--				Common.SaveShareTable(TableConsole.softGuideTableText,TableConsole.softGuideTable)
		--			elseif softGuideTable[profile.User.getSelfUserID()].omni == nil then
		--				TableElementLayer.showSoftGuideOmniPotentTips()
		--				TableConsole.softGuideTable[profile.User.getSelfUserID()].omni = true
		--				Common.SaveShareTable(TableConsole.softGuideTableText,TableConsole.softGuideTable)
		--			end
		--		end

	elseif CurrBtnType == TableConsole.Button_callscore then
		--叫分控制
		if TableConsole.mnTableType == TableConsole.TABLE_TYPE_NORMAL then
			-- 标准场
			setCallscoreButtonVisible(true)
		else
			-- 欢乐或癞子场
			setCallLandlordButtonVisible(true)
		end
	elseif CurrBtnType == TableConsole.Button_call_landlord then
		--叫地主控制
		setCallLandlordButtonVisible(true)
	elseif CurrBtnType == TableConsole.Button_grab_landlord then
		--抢地主控制
		setGrabLandlordButtonVisible(true)
	elseif CurrBtnType == TableConsole.Button_doublescore then
		--加倍控制
		setDoublescoreButtonVisible(true)
	elseif CurrBtnType == TableConsole.Button_open_takeout then
		--地主首次出牌明牌控制
		setOpenTakeoutButtonVisible(true)
	elseif CurrBtnType == TableConsole.Button_open_initcard then
		--发牌阶段明牌控制
		setOpenInitcardButtonVisible(true)
	end
end


--[[--
--比赛排名按钮
--]]
function callback_btn_match_ranking(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--		mvcEngine.createModule(GUI_MATCH_RANKING)
		MatchDetailLogic.setNowEntrance(2)
--		MatchDetailLogic.setDetailWithMatchItem_V4(matchInfo)
		sendMATID_V4_MATCHDETAIL(profile.GameDoc.loadmatchDetailsTable(profile.User.getSelfVipLevel(),TableConsole.m_nMatchID),profile.User.getSelfVipLevel(),TableConsole.m_nMatchID)
		mvcEngine.createModule(GUI_MATCHDETAIL)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--开始按钮
--]]
function callback_btn_game_start(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.log("点击的是开始=================")
		if TableConsole.mode == TableConsole.ROOM then
			--隐藏踢人按钮
			changeKickButton(false);
		end
		TableConsole.sendContinue(0);
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[
顶部菜单栏交替
]]
function callback_Button_top_show(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起

		setMenuBgMode()

	elseif component == CANCEL_UP then
	--取消
	end
end

--[[
交换顶部菜单栏
]]
function exchangeTopMenu()
	if topMenuShowModel == 1 then
		-- show 底数和基数菜单栏
		Panel_Table_Button:setVisible(false)
		setTopMenuButtonTouchEnabled(false)

		Panel_Table_Info:setVisible(true)
	elseif topMenuShowModel == 2 then
		-- show 设置按钮菜单栏
		Panel_Table_Button:setVisible(true)
		setTopMenuButtonTouchEnabled(true)

		Panel_Table_Info:setVisible(false)
	end
end

--[[
菜单背景mode设置
]]
function setMenuBgMode()
	-- set topMenuShowModel
	if topMenuShowModel == 1 then
		topMenuShowModel = 2
	elseif topMenuShowModel == 2 then
		topMenuShowModel = 1
	end

	-- exe Button_top_show Animation
	btnTopShowAnimation()
end

--[[
顶部菜单和拉下按钮的执行动画
]]
function btnTopShowAnimation()
	-- 清除之前的动画
	Panel_Top_Button:stopAllActions()

	-- 拉杆动画
	local btnPullDown = CCMoveTo:create(0.2, ccp(Button_top_show:getPosition().x, btnPullPosY-20))
	local btnPullUp = CCMoveTo:create(0.2, ccp(Button_top_show:getPosition().x, btnPullPosY))
	local btnPullArr = CCArray:create()
	btnPullArr:addObject(btnPullDown)
	btnPullArr:addObject(btnPullUp)
	local btnPullSeq= CCSequence:create(btnPullArr)
	Button_top_show:runAction(btnPullSeq)

	-- 如果当前顶部栏显示菜单按钮模式，则上移顶部兰背景
	if TableCardLayer.dipaiBgLayer ~= nil then
		if topMenuShowModel == 2 then
			TableCardLayer.moveUpDipaiBgLayer()
		end
	end

	-- 顶部菜单栏动画
	local menuBgUp = CCMoveTo:create(0.2, ccp(Panel_Top_Button:getPosition().x, menuBgPosY+Panel_Top_Button:getContentSize().height))
	local menuBgDown = CCMoveTo:create(0.2, ccp(Panel_Top_Button:getPosition().x, menuBgPosY))
	local menuBgArr = CCArray:create()
	menuBgArr:addObject(menuBgUp)
	if TableCardLayer.dipaiBgLayer ~= nil then
		if topMenuShowModel == 1 then
			menuBgArr:addObject(CCCallFuncN:create(TableCardLayer.moveDownDipaiBgLayer))
		end
	end
	menuBgArr:addObject(CCCallFuncN:create(exchangeTopMenu))
	menuBgArr:addObject(menuBgDown)
	-- mode:2时5秒之后切换为mode:1
	if topMenuShowModel == 2 then
		local delay = CCDelayTime:create(5)
		menuBgArr:addObject(delay)
		menuBgArr:addObject(CCCallFuncN:create(setMenuBgMode))
	end

	Panel_Top_Button:runAction(CCSequence:create(menuBgArr))
end

function moveDipaiBgLayer()
	--底牌动画
	if TableCardLayer.dipaiBgLayer ~= nil then
		if topMenuShowModel == 2 then
			TableCardLayer.moveUpDipaiBgLayer()
		elseif topMenuShowModel == 1 then
			TableCardLayer.moveDownDipaiBgLayer()
		end
	end
end

--[[
开始购买记牌器
]]
function startBuyJipaiqi()
	if ServerConfig.getQuickPayIsShow() then
		--[[
		if Common.getOperater() == Common.UNKNOWN then
		--非短代支付
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_jipai_GiftTypeID, 0, RechargeGuidePositionID.TablePositionE)
		else
		--短代支付，直接调用SDK
		local PaymentTable = QuickPay.getPaymentTable(QuickPay.Pay_Guide_jipai_GiftTypeID, 0, 0, true)
		QuickPay.PayGuide(PaymentTable, PaymentTable.PayTypeID, RechargeGuidePositionID.TablePositionE, 0)
		end
		]]

		--不管什么支付，都先弹出充值引导弹框
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_jipai_GiftTypeID, 0, RechargeGuidePositionID.TablePositionE)
	else
		Common.showToast("您的道具已耗尽，请前往‘商城’购买!", 2);
	end
end

--[[--
--记牌器购买, 延长记牌器时间
]]
function callback_Button_jipaizi_add(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		startBuyJipaiqi()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--记牌器弹框
--]]
function callback_Button_jipaizi_lijigoumai_0(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--showJiPaiAnim()
		--先判断背包是不是有记牌器
		sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_JIPAIQI) --查看记牌器信息
		if profile.Pack.getJipaiqiValidDate() > 0 then
			Common.log("已经购买过记牌器")

			if TableConsole.isPlayingDoudizhu() then
				-- 在牌局中, 显示记牌器
				if jipaiqiLogic.bJipaiqiViewDidShow == true then
					jipaiqiLogic.hideJipaiqiView()
				else
					jipaiqiLogic.showJipaiqiView()
				end
			else
				-- 没在牌局中, 显示记牌器有效期
				if jipaiqiLogic.bJipaiqiYouxiaoqiViewDidShow == true then
					jipaiqiLogic.hideYouxiaoqiJipaiqiView()
				else
					jipaiqiLogic.showYouxiaoqiJipaiqiView()
				end
			end

		else
			Common.log("未购买过记牌器")
			-- 弹框购买
			if ServerConfig.getQuickPayIsShow() then

				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_jipai_GiftTypeID, 0, RechargeGuidePositionID.TablePositionE)
				--[[
				if Common.getOperater() == Common.UNKNOWN then
				--非短代支付
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_jipai_GiftTypeID, 0, RechargeGuidePositionID.TablePositionE)
				else
				--短代支付，直接调用SDK
				local PaymentTable = QuickPay.getPaymentTable(QuickPay.Pay_Guide_jipai_GiftTypeID, 0, 0, true)
				QuickPay.PayGuide(PaymentTable, PaymentTable.PayTypeID, RechargeGuidePositionID.TablePositionE, 0)
				end
				]]
			else
				Common.showToast("您的道具已耗尽，请前往‘商城’购买!", 2);
			end
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--充值
--]]
function callback_button_recharge(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local myyuanbao = profile.User.getSelfYuanBao()
		if myyuanbao >= 50 then
			Common.openConvertCoin()
		else
			--充值引导
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
			PayGuidePromptLogic.setEnterType(true)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--礼包
--]]
function callback_button_gift(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if profile.Gift.isShowFirstGiftIcon() then
			--可以购买首充
			sendGIFTBAGID_GET_LOOP_GIFT(2)
		else
			--充值引导
			local baseChip = 20
			if TableConsole.msBaseChipText == nil then
				baseChip = 50;
			else
				baseChip = tonumber(string.match(TableConsole.msBaseChipText, "%d+"));
			end
			if baseChip == 20 then
				--20倍房间中取支付列表中≥5中最低的价格
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 3000, RechargeGuidePositionID.TablePositionB)
			elseif baseChip == 50 then
				--50倍房间中取支付列表中≥10中最低的价格
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
			elseif baseChip == 100 then
				--100倍房间中取支付列表中≥20中最低的价格
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 15000, RechargeGuidePositionID.TablePositionB)
			elseif baseChip == 300 then
				--300倍房间中取支付列表中≥20中最低的价格
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 15000, RechargeGuidePositionID.TablePositionB)
			else
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 3000, RechargeGuidePositionID.TablePositionB)
			end
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--退出
--]]
function callback_button_exit(component)
	if component == PUSH_DOWN then
		--按下
		MenuCountdown = 0;
	elseif component == RELEASE_UP then
		--抬起
		--如果是在进行新手引导，提示是否跳过
		if(NewUserGuideLogic.getNewUserFlag())then
			mvcEngine.createModule(GUI_SKIPNEWUSERGUIDE)
		else
			eixtTableLogic();
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--聊天
--]]
function callback_button_chat(component)
	if component == PUSH_DOWN then
		--按下
		MenuCountdown = 0;
	elseif component == RELEASE_UP then
		--抬起
		sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_JIPAIQI) --查看记牌器信息
		mvcEngine.createModule(GUI_CHATPOP)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--设置
--]]
function callback_button_setting(component)
	if component == PUSH_DOWN then
		--按下
		MenuCountdown = 0;
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_SETTING)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--托管
--]]
function callback_button_tuoguan(component)
	Common.log("callback_button_tuoguan")
	if component == PUSH_DOWN then
		--按下
		MenuCountdown = 0;
	elseif component == RELEASE_UP then
		--抬起
		--托管
		local player = TableConsole.getPlayer(TableConsole.getSelfSeat())
		if player ~= nil then
			if player.m_bTrustPlay == true then
				-- 解除托管
				TableConsole.sendTableTrustPlayReq(0)

				CommDialogConfig.startSimulateSync(1)
			else
				TableConsole.sendTableTrustPlayReq(1)
			end
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--解除托管
--]]
function callback_btn_Trust_Play(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.log("解除托管===========");
		TableConsole.sendTableTrustPlayReq(0)

		CommDialogConfig.startSimulateSync(1)

		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--出牌
--]]
function callback_btn_takeout_right(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.takeOut()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--提示
--]]
function callback_btn_takeout_centre(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableCardLayer.CardsPrompt()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--不要
--]]
function callback_btn_takeout_left(component)
	if btn_takeout_left:isTouchEnabled() then
		if component == PUSH_DOWN then
		--按下
		elseif component == RELEASE_UP then
			--抬起
			TableConsole.pass()
		elseif component == CANCEL_UP then
		--取消
		end
	end
end

--[[--
--开始（欢乐/癞子场）
--]]
function callback_btn_opencard_start_right(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.log("点击的是欢乐/癞子场========开始")
		if TableConsole.isCrazyStage == true and TableConsole.canPlayCrazy == false then
			Common.showToast("还未完成复活,请稍后",2)
			return
		elseif TableConsole.isCrazyStage == true then
			TableConsole.VALIDATE_BEGIN_MODE = 0
			TableConsole.crazyValidate()
			return
		end
		if mode == ROOM then
			--隐藏踢人按钮
			TableLogic.changeKickButton(false);
		end
		TableConsole.sendContinue(0);
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--明牌开始x5（欢乐/癞子场）
--]]
function callback_btn_opencard_start_left(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.log("点击的是明牌开始X5======开始");
		if TableConsole.isCrazyStage == true and TableConsole.canPlayCrazy == false then
			Common.showToast("还未完成复活,请稍后",2)
			return
		elseif TableConsole.isCrazyStage == true then
			TableConsole.VALIDATE_BEGIN_MODE = 1
			TableConsole.crazyValidate()
			return
		end
		if mode == ROOM then
			--隐藏踢人按钮
			TableLogic.changeKickButton(false);
		end
		TableConsole.sendContinue(1);
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--3分
--]]
function callback_btn_callscore_right(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendCallScore(3)
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--2分
--]]
function callback_btn_callscore_centre_right(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendCallScore(2)
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--1分
--]]
function callback_btn_callscore_centre_left(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendCallScore(1)
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--不叫（普通房间叫分阶段）
--]]
function callback_btn_callscore_left(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendCallScore(0)
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--叫地主
--]]
function callback_btn_call_landlord_right(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendCallScore(3)
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--不叫地主
--]]
function callback_btn_call_landlord_left(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendCallScore(0)
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--不抢
--]]
function callback_btn_grab_landlord_left(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendTableGrabLandlord(0)
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--抢地主
--]]
function callback_btn_grab_landlord_right(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendTableGrabLandlord(1)
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--超级加倍x4
--]]
function callback_btn_doublescore_right(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendTableDoubleScore(4)
		--		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--加倍x2
--]]
function callback_btn_doublescore_centre(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendTableDoubleScore(2)
		--		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--不加倍
--]]
function callback_btn_doublescore_left(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendTableDoubleScore(0)
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--地主首次出牌按钮（欢乐/癞子场）
--]]
function callback_btn_open_takeout_right(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.m_nCurrBtnType = TableConsole.Button_takeout;
		TableConsole.takeOut()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--地主首次出牌明牌x2（欢乐/癞子场）
--]]
function callback_btn_open_takeout_left(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.isSendOpenCards = false;
		TableConsole.sendTableOpenCards(2)
		TableConsole.m_nCurrBtnType = TableConsole.Button_takeout;
		changeShowButtonPanel(TableConsole.m_nCurrBtnType)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--发牌阶段明牌（欢乐/癞子场）
--]]
function callback_btn_open_initcard(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.sendTableOpenCards(TableCardLayer.OpenInitCard)
		hideGameBtn()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 踢出上家按钮
--]]
function callback_btn_game_start_kick1(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.log("callback_btn_game_start_kick1")
		--根据玩家在牌桌上的位置取出玩家的座位号
		local nSeat = TableConsole.getPlayerSeatByPos(TableConsole.LEFT_PLAYER_NUMBER)
		--根据玩家的座位号取出玩家数组的下标
		local position = TableConsole.getPlayerIdxBySeat(nSeat)
		--将数组下标存起来
		TableConsole.setBekickOutPlayerPosition(position)
		--如果玩家不是VIP,提示他.如果是VIP,比较自己与对方VIP等级
		if profile.User.getSelfVipLevel() > 0 then
			--如果玩家是VIP
			if profile.User.getSelfVipLevel() > TableConsole.m_aPlayer[position].mnVipLevel then
				--如果玩家VIP等级高于对方VIP等级,那么发踢人消息去踢人
				sendROOMID_KICK_OUT_PLAYER(TableConsole.m_aPlayer[position].m_nUserID)
			elseif profile.User.getSelfVipLevel() == TableConsole.m_aPlayer[position].mnVipLevel then
				--如果玩家VIP等级等于对方,提示玩家
				Common.showToast("亲,对方的VIP等级和您一样,您踢不动TA哦!",2)
			else
				--如果玩家VIP等级小于对方,提示玩家
				Common.showToast("亲,对方的VIP比您高(" .. VIPPub.getUserVipName(VIPPub.getUserVipType(TableConsole.m_aPlayer[position].mnVipLevel)) .. "),您踢不动TA哦!",2)
			end
		else
			--如果玩家不是VIP,提示玩家
			Common.showToast("亲,只有VIP会员才能【踢人】哦!",2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 踢出下家按钮
--]]
function callback_btn_game_start_kick2(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.log("callback_btn_game_start_kick2")
		--根据玩家在牌桌上的位置取出玩家的座位号
		local nSeat = TableConsole.getPlayerSeatByPos(TableConsole.RIGHT_PLAYER_NUMBER)
		--根据玩家的座位号取出玩家数组的下标
		local position = TableConsole.getPlayerIdxBySeat(nSeat)
		--将数组下标存起来
		TableConsole.setBekickOutPlayerPosition(position)
		--如果玩家不是VIP,提示他.如果是VIP,比较自己与对方VIP等级
		if profile.User.getSelfVipLevel() > 0 then
			--如果玩家是VIP
			if profile.User.getSelfVipLevel() > TableConsole.m_aPlayer[position].mnVipLevel then
				--如果玩家VIP等级高于对方VIP等级,那么发踢人消息去踢人
				sendROOMID_KICK_OUT_PLAYER(TableConsole.m_aPlayer[position].m_nUserID)
			elseif profile.User.getSelfVipLevel() == TableConsole.m_aPlayer[position].mnVipLevel then
				--如果玩家VIP等级等于对方,提示玩家
				Common.showToast("亲,对方的VIP等级和您一样,您踢不动TA哦!",2)
			else
				--如果玩家VIP等级小于对方,提示玩家
				Common.showToast("亲,对方的VIP比您高(" .. VIPPub.getUserVipName(VIPPub.getUserVipType(TableConsole.m_aPlayer[position].mnVipLevel)) .. "),您踢不动TA哦!",2)
			end
		else
			--如果玩家不是VIP,提示玩家
			Common.showToast("亲,只有VIP会员才能【踢人】哦!",2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_PassCard(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		TableConsole.pass()
	elseif component == CANCEL_UP then
	--取消

	end
end


--[[--
--更新排名信息
--]]
function updateRankSync(tRankSync)
	local rank = tRankSync.Rank
	local playerCount = tRankSync.playerCount
	Label_939:setText(""..rank.."/"..playerCount)
	Label_PromptMsg:setText(tRankSync.PromptMsg)
end

--[[--
--更新要不起按钮状态
--]]
function setYaobuqiState(state)
	Panel_PassCard:setVisible(state)
	btn_PassCard:setTouchEnabled(state)
	btn_PassCard:setVisible(state)
end
--[[--
--释放界面的私有数据
--]]
function releaseData()
	lastReceiveHBTimeLong = -1
	if Label_time ~= nil then
		Label_time:stopAllActions();
	end
end

function addSlot()
	TableConsole.addSignal()
end

function removeSlot()
	TableLogic.view:stopAllActions();
	ChatPopLogic.clearChatList();
	TableConsole.removeSignal()
	TableCardLayer.reomveAllCardLayer()
	TableElementLayer.reomveAllElementLayer()
	AudioManager.stopBgMusic(true)
	AudioManager.stopAllSound()
	ResumeSocket("TableRemoveSlot");
	AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.HALL_BACKGROUND)
end
