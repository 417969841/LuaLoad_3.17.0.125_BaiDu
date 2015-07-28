---------------用户状态---------------------
--无任何操作
STATUS_PLAYER_NONE = 0
--观看
STATUS_PLAYER_WATCH = 1
--坐下
STATUS_PLAYER_SITDOWN = 2
--准备
STATUS_PLAYER_READY = 3
--游戏中
STATUS_PLAYER_PLAYING = 4
--看牌
STATUS_PLAYER_LOOKCARD = 5
--比牌失败
STATUS_PLAYER_PK_FAILURE = 6
--弃牌
STATUS_PLAYER_DISCARD = 7
--游戏结果
STATUS_PLAYER_GAMERESULT = 8
---------------下注类型---------------------
--下底注
TYPE_BET_ANTE = 1
--跟注
TYPE_BET_CALL = 2
--加注
TYPE_BET_RAISE = 3
--全押
TYPE_BET_ALLIN = 4
--比牌押注
TYPE_BET_PK = 5
---------------牌桌状态---------------------
--牌桌等待状态
STATUS_TABLE_WAITTING = 1
--牌桌准备状态
STATUS_TABLE_READY = 2
--牌桌游戏进行中
STATUS_TABLE_PLAYING = 3
--牌桌游戏进结果
STATUS_TABLE_RESULT = 4
--------------聊天类型----------------------
--聊天类型：普通表情
TYPE_CHAT_COMMON = 1
--聊天类型：高级表情
TYPE_CHAT_SUPERIOR = 2
--聊天类型：文字
TYPE_CHAT_TEXT = 3

--数据存储Key
--播放音效
KEY_SET_EFFECT = "key_set_effect_play"
--播放音乐
KEY_SET_BGMUSIC = "key_set_bgmusic_play"
--播放震动
KEY_SET_VIBRATE = "key_set_vibrate_play"

JinHuaTableConfig ={}

JinHuaTableConfig.GameID = 4 -- 扎金花gameID
JinHuaTableConfig.JinHuaVerCode = 17629184 -- 扎金花版本号1.13

JinHuaTableConfig.TableDefaultWidth = 1136 -- 牌桌默认宽度
JinHuaTableConfig.TableDefaultHeight = 640 -- 牌桌默认高度
JinHuaTableConfig.TableRealHeight = JinHuaTableConfig.TableDefaultHeight; -- 牌桌实际高度
JinHuaTableConfig.TableProportion = 1.4 --JinHuaTableConfig.TableDefaultWidth / JinHuaTableConfig.TableDefaultHeight;--牌桌比例(宽/高)

JinHuaTableConfig.TableScaleX = 1 -- 牌桌缩放比例x
JinHuaTableConfig.TableScaleY = 1 -- 牌桌缩放比例y
JinHuaTableConfig.cardWidth = 70
JinHuaTableConfig.cardHeight = 90
JinHuaTableConfig.cardScale = 0.62
--庄、弃、败等icon的宽 高
JinHuaTableConfig.iconWidth = 38
JinHuaTableConfig.iconHeight = 38
--屏幕适配Y轴偏移
JinHuaTableConfig.fitY = 0
--屏幕适配X轴偏移
JinHuaTableConfig.fitX = 0
--人数
JinHuaTableConfig.playerCnt = 5
--人物形象背景位置
JinHuaTableConfig.playerBGWidth = JinHuaTableConfig.TableDefaultWidth * 94 / 800;
JinHuaTableConfig.playerBGHeight = JinHuaTableConfig.TableDefaultHeight * 119 / 480;
--筹码区：左右下上
JinHuaTableConfig.rangLeft = 0
JinHuaTableConfig.rangRight = 0
JinHuaTableConfig.rangBottom = 0
JinHuaTableConfig.rangTop = 0
JinHuaTableConfig.isPad = false -- 适配一些宽高比小于1.775的

JinHuaTableConfig.sendCardsSpritePositionX = 0 --牌堆位置 x轴
JinHuaTableConfig.sendCardsSpritePositionY = 0 --牌堆位置 y轴
JinHuaTableConfig.cardsSpriteStartPositionX = 0 -- 发牌的起始位置
JinHuaTableConfig.cardsSpriteStartPositionY = 0 -- 发牌的起始位置

JinHuaTableConfig.bubbleSpriteMoveDistance = 0 -- 气泡移动的距离
--JinHuaTableConfig.playerWidth = 90 -- 玩家的宽度
--JinHuaTableConfig.playerHeight = 116 -- 玩家的高度

JinHuaTableConfig.myCard1Rotation = -15 -- 我的牌的旋转角度
JinHuaTableConfig.myCard2Rotation = 0
JinHuaTableConfig.myCard3Rotation = 15

JinHuaTableConfig.tableBgPic1X = JinHuaTableConfig.TableDefaultWidth / 2; -- 牌桌背景的贴图X坐标
JinHuaTableConfig.tableBgPic1Y = JinHuaTableConfig.TableDefaultHeight *3 / 4; -- 牌桌背景的贴图Y坐标

JinHuaTableConfig.enterTablePromptX = 0 -- 进入牌桌提示
JinHuaTableConfig.enterTablePromptY = 0

------------------------------牌桌适配常量-------------------------------------------------------------------------------------------------------------------------------
--[[--玩家图片参数--]]--
local PLAYER_PIC_WIDTH = JinHuaTableConfig.TableDefaultWidth /9 ;--玩家的宽度 (127.8\126.2     9/80)
local PLAYER_PIC_HEIGHT = JinHuaTableConfig.TableDefaultHeight / 4;-- 玩家的高度(154.7\160    29/ 120)
local FROM_THE_BUBBLE_MOVES = JinHuaTableConfig.TableDefaultHeight / 20; --气泡移动的距离(  3/80)
--[[--发牌参数--]]--
local CARDS_SPRITE_POSITION_X = JinHuaTableConfig.TableDefaultWidth / 2; --牌堆位置X轴
local CARDS_SPRITE_POSITION_Y = JinHuaTableConfig.TableDefaultHeight * 5 / 6; --牌堆位置Y轴
--[[--按钮参数--]]--
local BTN_X_AXIS_INTERVAL = JinHuaTableConfig.TableDefaultWidth / 90 ; --放弃等按钮按钮在X轴的间隔(18.46\18.47  13/800)
local FIRST_BTN_DISTANCE_LEFT_SIDE = JinHuaTableConfig.TableDefaultWidth / 4.5 ; --第一个按钮(放弃按钮)距离左侧的距离(157.62\157.78  111 / 800)
local CHAT_BTN_X_POSITION = JinHuaTableConfig.TableDefaultWidth / 6.5; --聊天按钮x坐标所在位置
local RECHARGE_BTN_X_POSITION = JinHuaTableConfig.TableDefaultWidth / 11;--充值按钮x坐标所在位置
--[[--加注列表按钮参数--]]--
local RAISE_BTN_LIST_IN_THE_INTERVAL_X_AXIS = JinHuaTableConfig.TableDefaultWidth / 45; --加注列表按钮在X轴的间隔(25.56\25.59 18 / 800)
local FIRST_BTN_RAISE_DISTANCE_LEFT_SIDE = JinHuaTableConfig.TableDefaultWidth / 3; --第一个加注列表按钮距离左侧的距离(343.64\344.24  242 / 800)
--[[--客户端第一个玩家参数--]]--
local TABLE_PLAYER_1_LOCATION_X = JinHuaTableConfig.TableDefaultWidth * 2 / 5 ; --玩家1位置x轴(431.68\436.92 304 / 800)
local TABLE_PLAYER_1_LOCATION_y = JinHuaTableConfig.TableDefaultHeight *5 / 24 ; --玩家1位置y轴( 100 /480)
local SPRITE_PLAYER_1_LOC_Y_DISTANCE_BET_COIN_Y = JinHuaTableConfig.TableDefaultHeight / 16;--玩家1坐标的Y轴距离已押金额label的Y轴距离()
local SPRITE_PLAYER_1_LOC_X_DISTANCE_ICOIN_X = JinHuaTableConfig.TableDefaultWidth / 8 ; --庄、弃、败等iconX距离玩家位置X(137.74\137.7  97 / 800)
local SPRITE_PLAYER_1_LOC_Y_DISTANCE_ICOIN_Y = JinHuaTableConfig.TableDefaultHeight / 5; --庄、弃、败等iconY距离玩家位置y(126.67\126.73  95 / 480)
local SPRITE_PLAYER_1_LOC_X_DISTANCE_CARD_LOC_X = JinHuaTableConfig.TableDefaultWidth * 2 / 15; --玩家1的牌的x轴距离玩家X轴的距离(143.42\ 101 / 800)
local SPRITE_PLAYER_1_LOC_Y_DISTANCE_CARD_LOC_Y = JinHuaTableConfig.TableDefaultHeight / 17; --玩家1的牌的y轴距离玩家y轴的距离(44 33 / 480)
--[[--客户端第二个玩家参数--]]--
local TABLE_PLAYER_2_LOCATION_X = JinHuaTableConfig.TableDefaultWidth / 9 ; --玩家2位置x轴(127.8  90 / 800)
local TABLE_PLAYER_2_LOCATION_Y = JinHuaTableConfig.TableDefaultHeight / 4; --玩家2位置y轴(169.33 127 / 480)
local SPRITE_PLAYER_2_LOC_X_DISTANCE_BET_COIN_X = JinHuaTableConfig.TableDefaultWidth / 200;--玩家2坐标的X轴距离已押金额label的X距离(4 / 800 )
local SPRITE_PLAYER_2_LOC_Y_DISTANCE_BET_COIN_Y = JinHuaTableConfig.TableDefaultHeight / 15;--玩家2坐标的Y轴距离已押金额label的Y距离(44 33 / 480)
local SPRITE_PLAYER_2_LOC_Y_DISTANCE_ICOIN_Y = JinHuaTableConfig.TableDefaultHeight / 9; --庄、弃、败等iconY距离玩家位置y(54.67 41 / 480)
local SPRITE_PLAYER_2_LOC_X_DISTANCE_CARD_LOC_X = JinHuaTableConfig.TableDefaultWidth / 8; --玩家2牌的x轴距离玩家X轴的距离(144.84 102 / 800)
local SPRITE_PLAYER_2_LOC_Y_DISTANCE_CARD_LOC_Y = JinHuaTableConfig.TableDefaultHeight / 12; --玩家2牌的y轴距离玩家y轴的距离(72  54 / 480)
--[[--客户端第三个玩家参数--]]--
local TABLE_PLAYER_3_LOCATION_X =JinHuaTableConfig.TableDefaultWidth / 73; --玩家3位置x轴(15.62 11 / 800)
local TABLE_PLAYER_3_LOCATION_Y = JinHuaTableConfig.TableDefaultHeight * 5 / 8; --玩家3位置y轴(396 297 / 480)
local SPRITE_PLAYER_3_LOC_X_DISTANCE_BET_COIN_X = JinHuaTableConfig.TableDefaultWidth /114;--玩家3坐标的X轴距离已押金额label的X距离(9.94 7 / 800)
local SPRITE_PLAYER_3_LOC_Y_DISTANCE_BET_COIN_Y = JinHuaTableConfig.TableDefaultHeight * 5 / 9;--玩家3坐标的Y轴距离已押金额label的Y距离(352 264 / 480)
local SPRITE_PLAYER_3_LOC_X_DISTANCE_ICOIN_X  = JinHuaTableConfig.TableDefaultWidth * 3 / 20; --庄、弃、败等iconX距离玩家位置X(160.46  113 / 800)
local SPRITE_PLAYER_3_LOC_Y_DISTANCE_ICOIN_Y = JinHuaTableConfig.TableDefaultHeight * 5 / 6; --庄、弃、败等iconY距离玩家位置y(522.67 392 / 480)
local SPRITE_PLAYER_3_LOC_X_DISTANCE_CARD_LOC_X = JinHuaTableConfig.TableDefaultWidth  / 7; --玩家3牌的x轴距离玩家X轴的距离(160.46 113 / 800)
local SPRITE_PLAYER_3_LOC_Y_DISTANCE_CARD_LOC_Y = JinHuaTableConfig.TableDefaultHeight *  7 / 10; --玩家3牌的y轴距离玩家y轴的距离(468 351 / 480)
--[[--客户端第四个玩家参数--]]--
local TABLE_PLAYER_4_LOCATION_X = JinHuaTableConfig.TableDefaultWidth * 7 / 8; --玩家4位置x轴( 698 / 800)
local TABLE_PLAYER_4_LOCATION_Y = JinHuaTableConfig.TableDefaultHeight * 5 / 8; --玩家4位置y轴(396 297 / 480)
local SPRITE_PLAYER_4_LOC_X_DISTANCE_BET_COIN_X = JinHuaTableConfig.TableDefaultWidth * 7 / 8;--玩家4坐标的X轴距离已押金额label的X距离(694 /800)
local SPRITE_PLAYER_4_LOC_Y_DISTANCE_BET_COIN_Y = JinHuaTableConfig.TableDefaultHeight * 5 / 9;--玩家4坐标的Y轴距离已押金额label的Y距离(352 264 / 480)
local SPRITE_PLAYER_4_LOC_X_DISTANCE_ICOIN_X = JinHuaTableConfig.TableDefaultWidth * 13 / 16; --庄、弃、败等iconX距离玩家位置X(655 / 800)
local SPRITE_PLAYER_4_LOC_Y_DISTANCE_ICOIN_Y = JinHuaTableConfig.TableDefaultHeight * 5 / 6; --庄、弃、败等iconY距离玩家位置y(522.67 392 / 480)
local SPRITE_PLAYER_4_LOC_X_DISTANCE_CARD_LOC_X = JinHuaTableConfig.TableDefaultWidth * 7 / 9; --玩家4牌的x轴距离玩家X轴的距离(627 / 800)
local SPRITE_PLAYER_4_LOC_Y_DISTANCE_CARD_LOC_Y = JinHuaTableConfig.TableDefaultHeight * 7 / 10; --玩家4牌的y轴距离玩家y轴的距离(468 351 / 480)
--[[--客户端第五个玩家参数--]]--
local TABLE_PLAYER_5_LOCATION_X = JinHuaTableConfig.TableDefaultWidth * 3 / 4; --玩家位置x轴(619 / 800)
local TABLE_PLAYER_5_LOCATION_Y = JinHuaTableConfig.TableDefaultHeight / 4; --玩家位置y轴(169.33 127 / 480)
local SPRITE_PLAYER_5_LOC_X_DISTANCE_BET_COIN_X = JinHuaTableConfig.TableDefaultWidth / 200;--玩家5坐标的X轴距离已押金额label的X距离(4 / 800)
local SPRITE_PLAYER_5_LOC_Y_DISTANCE_BET_COIN_Y = JinHuaTableConfig.TableDefaultHeight / 15;--玩家5坐标的Y轴距离已押金额label的Y距离(44 33 / 480)
local SPRITE_PLAYER_5_LOC_X_DISTANCE_ICOIN_X = JinHuaTableConfig.TableDefaultHeight / 11; --庄、弃、败等iconX距离玩家位置X(43 / 480)
local SPRITE_PLAYER_5_LOC_Y_DISTANCE_ICOIN_Y = JinHuaTableConfig.TableDefaultHeight / 5; --庄、弃、败等iconY距离玩家位置y(95 / 480)
local SPRITE_PLAYER_5_LOC_X_DISTANCE_CARD_LOC_X = JinHuaTableConfig.TableDefaultWidth / 12; --玩家5牌的x轴距离玩家X轴的距离( 71 / 800)
local SPRITE_PLAYER_5_LOC_Y_DISTANCE_CARD_LOC_Y = JinHuaTableConfig.TableDefaultHeight /11; --玩家5牌的y轴距离玩家y轴的距离(72  54 / 480)
--[[--进入牌桌提示参数--]]--
local ENTER_TABLE_TIPS_X = JinHuaTableConfig.TableDefaultWidth * 3 / 80;
local ENTER_TABLE_TIPS_Y = JinHuaTableConfig.TableDefaultHeight / 24;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 初始化下方按钮组左标
local function initTableBottomBtnLocation()
	--按钮组x坐标
	JinHuaTableConfig.btnsX = FIRST_BTN_DISTANCE_LEFT_SIDE * JinHuaTableConfig.TableScaleX
	--按钮组中按钮间距
	JinHuaTableConfig.btnGapWidth = BTN_X_AXIS_INTERVAL * JinHuaTableConfig.TableScaleX
	if JinHuaTableConfig.fitX>0 then
		-- 防止右边超出屏幕
		local dis = JinHuaTableConfig.fitX/4
		if dis > JinHuaTableConfig.btnGapWidth then
			JinHuaTableConfig.btnsX = JinHuaTableConfig.btnsX - (JinHuaTableConfig.fitX - JinHuaTableConfig.btnGapWidth*4)
			JinHuaTableConfig.btnGapWidth = 0
		else
			JinHuaTableConfig.btnGapWidth = JinHuaTableConfig.btnGapWidth-dis
		end
	end

	JinHuaTableConfig.btnChatX = CHAT_BTN_X_POSITION *  JinHuaTableConfig.TableScaleX
	JinHuaTableConfig.btnRechargeX = RECHARGE_BTN_X_POSITION *  JinHuaTableConfig.TableScaleX
end

-- 初始化下注区
local function initTableBetCoinRange()
	if JinHuaTableConfig.isPad then
		JinHuaTableConfig.rangLeft = JinHuaTableConfig.TableDefaultWidth / 5 * 2
		JinHuaTableConfig.rangRight = JinHuaTableConfig.TableDefaultWidth / 5 * 3
		JinHuaTableConfig.rangBottom = JinHuaTableConfig.TableDefaultHeight / 30 * 20
		JinHuaTableConfig.rangTop = JinHuaTableConfig.TableDefaultHeight / 30 * 26
	else
		JinHuaTableConfig.rangLeft = JinHuaTableConfig.TableDefaultWidth / 5 * 2  --5分之2处
		JinHuaTableConfig.rangRight = JinHuaTableConfig.TableDefaultWidth / 5 * 3 --5分之3处
		JinHuaTableConfig.rangBottom = JinHuaTableConfig.TableDefaultHeight / 5 * 3 --5分之3处
		JinHuaTableConfig.rangTop = JinHuaTableConfig.TableDefaultHeight / 5 * 4 --5分之4处
	end
end

-- 初始化加注按钮组位置
local function initTableRaiseBtnLocation()
	--加注按钮组x坐标
	JinHuaTableConfig.btnsRaiseX = FIRST_BTN_RAISE_DISTANCE_LEFT_SIDE * JinHuaTableConfig.TableScaleX
	--加注按钮组中按钮间距
	JinHuaTableConfig.btnRaiseGapWidth = RAISE_BTN_LIST_IN_THE_INTERVAL_X_AXIS * JinHuaTableConfig.TableScaleX
	if JinHuaTableConfig.fitX>0 then
		local dis = JinHuaTableConfig.fitX/5
		if dis>JinHuaTableConfig.btnRaiseGapWidth then
			JinHuaTableConfig.btnsRaiseX = JinHuaTableConfig.btnsRaiseX-(JinHuaTableConfig.fitX-JinHuaTableConfig.btnRaiseGapWidth*5)
			JinHuaTableConfig.btnRaiseGapWidth = 0
		else
			JinHuaTableConfig.btnRaiseGapWidth = JinHuaTableConfig.btnRaiseGapWidth-dis
		end
	end
end

--[[--
--一号位站起/坐下UI更新
--@param #boolean isMe 是否是自己坐一号位
]]
local function initTablePlayerLocation_1()
	if not JinHuaTableConfig.spritePlayers then
		JinHuaTableConfig.spritePlayers = {}
	end
	if not JinHuaTableConfig.spritePlayers[1] then
		JinHuaTableConfig.spritePlayers[1] = {}
	end
	--玩家精灵位置
	JinHuaTableConfig.spritePlayers[1].locX = TABLE_PLAYER_1_LOCATION_X * JinHuaTableConfig.TableScaleX + JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[1].locY = TABLE_PLAYER_1_LOCATION_y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	--已押金额总数的label位置
	JinHuaTableConfig.spritePlayers[1].betCoinX = JinHuaTableConfig.spritePlayers[1].locX - JinHuaTableConfig.TableScaleX
	JinHuaTableConfig.spritePlayers[1].betCoinY = JinHuaTableConfig.spritePlayers[1].locY - SPRITE_PLAYER_1_LOC_Y_DISTANCE_BET_COIN_Y * JinHuaTableConfig.TableScaleY
	--庄、弃、败等icon的位置
	JinHuaTableConfig.spritePlayers[1].iconX = JinHuaTableConfig.spritePlayers[1].locX + SPRITE_PLAYER_1_LOC_X_DISTANCE_ICOIN_X * JinHuaTableConfig.TableScaleX + JinHuaTableConfig.iconWidth/2
	JinHuaTableConfig.spritePlayers[1].iconY = JinHuaTableConfig.spritePlayers[1].locY + SPRITE_PLAYER_1_LOC_Y_DISTANCE_ICOIN_Y * JinHuaTableConfig.TableScaleY + JinHuaTableConfig.iconHeight/2

	--牌位置的X轴
	local cardLocX = JinHuaTableConfig.spritePlayers[1].locX + SPRITE_PLAYER_1_LOC_X_DISTANCE_CARD_LOC_X * JinHuaTableConfig.TableScaleX
	--牌位置的Y轴
	local cardLocY = JinHuaTableConfig.spritePlayers[1].locY + SPRITE_PLAYER_1_LOC_Y_DISTANCE_CARD_LOC_Y * JinHuaTableConfig.TableScaleY
	--牌的位置(对于我的牌在TablePlayerEntity中设置角度)
	JinHuaTableConfig.spritePlayers[1].cards = {}
	JinHuaTableConfig.spritePlayers[1].cards[1] = {}
	JinHuaTableConfig.spritePlayers[1].cards[2] = {}
	JinHuaTableConfig.spritePlayers[1].cards[3] = {}
	JinHuaTableConfig.spritePlayers[1].cards[1].locX = cardLocX + JinHuaTableConfig.cardWidth*JinHuaTableConfig.cardScale/2
	JinHuaTableConfig.spritePlayers[1].cards[1].locY = cardLocY
	JinHuaTableConfig.spritePlayers[1].cards[2].locX = cardLocX + JinHuaTableConfig.cardWidth*JinHuaTableConfig.cardScale
	JinHuaTableConfig.spritePlayers[1].cards[2].locY = cardLocY
	JinHuaTableConfig.spritePlayers[1].cards[3].locX = cardLocX + JinHuaTableConfig.cardWidth*JinHuaTableConfig.cardScale*3/2
	JinHuaTableConfig.spritePlayers[1].cards[3].locY = cardLocY
	--1号比牌按钮位置(比牌按钮在别人比牌的时候出现)
	JinHuaTableConfig.spritePlayers[1].pkX = JinHuaTableConfig.spritePlayers[1].cards[2].locX
	JinHuaTableConfig.spritePlayers[1].pkY = JinHuaTableConfig.spritePlayers[1].cards[2].locY+JinHuaTableConfig.cardHeight/4
end

-- 初始化位置2的玩家左标
local function initTablePlayerLocation_2()
	JinHuaTableConfig.spritePlayers[2] = {}
	--玩家精灵位置
	JinHuaTableConfig.spritePlayers[2].locX = TABLE_PLAYER_2_LOCATION_X * JinHuaTableConfig.TableScaleX+ JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[2].locY = TABLE_PLAYER_2_LOCATION_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	--已押金额总数的label位置
	JinHuaTableConfig.spritePlayers[2].betCoinX = JinHuaTableConfig.spritePlayers[2].locX - SPRITE_PLAYER_2_LOC_X_DISTANCE_BET_COIN_X * JinHuaTableConfig.TableScaleX
	JinHuaTableConfig.spritePlayers[2].betCoinY = JinHuaTableConfig.spritePlayers[2].locY - SPRITE_PLAYER_2_LOC_Y_DISTANCE_BET_COIN_Y * JinHuaTableConfig.TableScaleY
	--牌位置的X轴
	local cardLocX = JinHuaTableConfig.spritePlayers[2].locX + SPRITE_PLAYER_2_LOC_X_DISTANCE_CARD_LOC_X * JinHuaTableConfig.TableScaleX
	--牌位置的Y轴
	local cardLocY = JinHuaTableConfig.spritePlayers[2].locY + SPRITE_PLAYER_2_LOC_Y_DISTANCE_CARD_LOC_Y * JinHuaTableConfig.TableScaleY
	--庄、弃、败等icon的位置
	JinHuaTableConfig.spritePlayers[2].iconX = cardLocX + JinHuaTableConfig.iconWidth/2
	JinHuaTableConfig.spritePlayers[2].iconY = cardLocY + SPRITE_PLAYER_2_LOC_Y_DISTANCE_ICOIN_Y * JinHuaTableConfig.TableScaleY + JinHuaTableConfig.iconHeight/2
	--牌的位置
	JinHuaTableConfig.spritePlayers[2].cards = {}
	JinHuaTableConfig.spritePlayers[2].cards[1] = {}
	JinHuaTableConfig.spritePlayers[2].cards[2] = {}
	JinHuaTableConfig.spritePlayers[2].cards[3] = {}
	JinHuaTableConfig.spritePlayers[2].cards[1].locX = cardLocX + JinHuaTableConfig.cardWidth*JinHuaTableConfig.cardScale/2
	JinHuaTableConfig.spritePlayers[2].cards[1].locY = cardLocY
	JinHuaTableConfig.spritePlayers[2].cards[2].locX = cardLocX + JinHuaTableConfig.cardWidth*JinHuaTableConfig.cardScale
	JinHuaTableConfig.spritePlayers[2].cards[2].locY = cardLocY
	JinHuaTableConfig.spritePlayers[2].cards[3].locX = cardLocX + (JinHuaTableConfig.cardWidth+ JinHuaTableConfig.cardWidth/2)*JinHuaTableConfig.cardScale
	JinHuaTableConfig.spritePlayers[2].cards[3].locY = cardLocY
	--2号比牌按钮位置
	JinHuaTableConfig.spritePlayers[2].pkX = JinHuaTableConfig.spritePlayers[2].cards[2].locX
	JinHuaTableConfig.spritePlayers[2].pkY = JinHuaTableConfig.spritePlayers[2].cards[2].locY+JinHuaTableConfig.cardHeight/4
end

-- 初始化位置3的玩家左标
local function initTablePlayerLocation_3()
	JinHuaTableConfig.spritePlayers[3] = {}
	--玩家精灵位置
	JinHuaTableConfig.spritePlayers[3].locX = TABLE_PLAYER_3_LOCATION_X * JinHuaTableConfig.TableScaleX+ JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[3].locY = TABLE_PLAYER_3_LOCATION_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	--已押金额总数的label位置
	JinHuaTableConfig.spritePlayers[3].betCoinX = SPRITE_PLAYER_3_LOC_X_DISTANCE_BET_COIN_X * JinHuaTableConfig.TableScaleX+ JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[3].betCoinY = SPRITE_PLAYER_3_LOC_Y_DISTANCE_BET_COIN_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	--庄、弃、败等icon的位置
	JinHuaTableConfig.spritePlayers[3].iconX = SPRITE_PLAYER_3_LOC_X_DISTANCE_ICOIN_X * JinHuaTableConfig.TableScaleX + JinHuaTableConfig.iconWidth/2 + JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[3].iconY = SPRITE_PLAYER_3_LOC_Y_DISTANCE_ICOIN_Y * JinHuaTableConfig.TableScaleY + JinHuaTableConfig.iconHeight/2 - JinHuaTableConfig.fitY
	--牌的位置
	JinHuaTableConfig.spritePlayers[3].cards = {}
	JinHuaTableConfig.spritePlayers[3].cards[1] = {}
	JinHuaTableConfig.spritePlayers[3].cards[2] = {}
	JinHuaTableConfig.spritePlayers[3].cards[3] = {}
	JinHuaTableConfig.spritePlayers[3].cards[1].locX = SPRITE_PLAYER_3_LOC_X_DISTANCE_CARD_LOC_X * JinHuaTableConfig.TableScaleX+ JinHuaTableConfig.cardWidth*JinHuaTableConfig.cardScale/2+ JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[3].cards[1].locY = SPRITE_PLAYER_3_LOC_Y_DISTANCE_CARD_LOC_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	JinHuaTableConfig.spritePlayers[3].cards[2].locX = SPRITE_PLAYER_3_LOC_X_DISTANCE_CARD_LOC_X * JinHuaTableConfig.TableScaleX+ JinHuaTableConfig.cardWidth*JinHuaTableConfig.cardScale+ JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[3].cards[2].locY = SPRITE_PLAYER_3_LOC_Y_DISTANCE_CARD_LOC_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	JinHuaTableConfig.spritePlayers[3].cards[3].locX = SPRITE_PLAYER_3_LOC_X_DISTANCE_CARD_LOC_X * JinHuaTableConfig.TableScaleX+(JinHuaTableConfig.cardWidth+ JinHuaTableConfig.cardWidth/2)*JinHuaTableConfig.cardScale+ JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[3].cards[3].locY = SPRITE_PLAYER_3_LOC_Y_DISTANCE_CARD_LOC_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	--3号比牌按钮位置
	JinHuaTableConfig.spritePlayers[3].pkX = JinHuaTableConfig.spritePlayers[3].cards[2].locX
	JinHuaTableConfig.spritePlayers[3].pkY = JinHuaTableConfig.spritePlayers[3].cards[2].locY+JinHuaTableConfig.cardHeight/4
end

-- 初始化位置4的玩家左标
local function initTablePlayerLocation_4()
	JinHuaTableConfig.spritePlayers[4] = {}
	--玩家精灵位置
	JinHuaTableConfig.spritePlayers[4].locX = TABLE_PLAYER_4_LOCATION_X * JinHuaTableConfig.TableScaleX- JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[4].locY = TABLE_PLAYER_4_LOCATION_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	--已押金额总数的label位置
	JinHuaTableConfig.spritePlayers[4].betCoinX = SPRITE_PLAYER_4_LOC_X_DISTANCE_BET_COIN_X * JinHuaTableConfig.TableScaleX- JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[4].betCoinY = SPRITE_PLAYER_4_LOC_Y_DISTANCE_BET_COIN_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	--庄、弃、败等icon的位置
	JinHuaTableConfig.spritePlayers[4].iconX = SPRITE_PLAYER_4_LOC_X_DISTANCE_ICOIN_X * JinHuaTableConfig.TableScaleX + JinHuaTableConfig.iconWidth/2- JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[4].iconY = SPRITE_PLAYER_4_LOC_Y_DISTANCE_ICOIN_Y * JinHuaTableConfig.TableScaleY + JinHuaTableConfig.iconHeight/2 - JinHuaTableConfig.fitY
	--牌位置
	JinHuaTableConfig.spritePlayers[4].cards = {}
	JinHuaTableConfig.spritePlayers[4].cards[1] = {}
	JinHuaTableConfig.spritePlayers[4].cards[2] = {}
	JinHuaTableConfig.spritePlayers[4].cards[3] = {}
	JinHuaTableConfig.spritePlayers[4].cards[1].locX = SPRITE_PLAYER_4_LOC_X_DISTANCE_CARD_LOC_X * JinHuaTableConfig.TableScaleX+ JinHuaTableConfig.cardWidth*JinHuaTableConfig.cardScale/2- JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[4].cards[1].locY = SPRITE_PLAYER_4_LOC_Y_DISTANCE_CARD_LOC_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	JinHuaTableConfig.spritePlayers[4].cards[2].locX = SPRITE_PLAYER_4_LOC_X_DISTANCE_CARD_LOC_X * JinHuaTableConfig.TableScaleX+ JinHuaTableConfig.cardWidth*JinHuaTableConfig.cardScale- JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[4].cards[2].locY = SPRITE_PLAYER_4_LOC_Y_DISTANCE_CARD_LOC_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	JinHuaTableConfig.spritePlayers[4].cards[3].locX = SPRITE_PLAYER_4_LOC_X_DISTANCE_CARD_LOC_X * JinHuaTableConfig.TableScaleX+(JinHuaTableConfig.cardWidth+ JinHuaTableConfig.cardWidth/2)*JinHuaTableConfig.cardScale- JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[4].cards[3].locY = SPRITE_PLAYER_4_LOC_Y_DISTANCE_CARD_LOC_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	--4号比牌按钮位置
	JinHuaTableConfig.spritePlayers[4].pkX = JinHuaTableConfig.spritePlayers[4].cards[2].locX
	JinHuaTableConfig.spritePlayers[4].pkY = JinHuaTableConfig.spritePlayers[4].cards[2].locY+JinHuaTableConfig.cardHeight/4
end

-- 初始化位置5的玩家左标
local function initTablePlayerLocation_5()
	JinHuaTableConfig.spritePlayers[5] = {}
	--玩家精灵位置
	JinHuaTableConfig.spritePlayers[5].locX = TABLE_PLAYER_5_LOCATION_X * JinHuaTableConfig.TableScaleX - JinHuaTableConfig.fitX
	JinHuaTableConfig.spritePlayers[5].locY = TABLE_PLAYER_5_LOCATION_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
	--已押金额总数的label位置
	JinHuaTableConfig.spritePlayers[5].betCoinX = JinHuaTableConfig.spritePlayers[5].locX - SPRITE_PLAYER_5_LOC_X_DISTANCE_BET_COIN_X * JinHuaTableConfig.TableScaleX
	JinHuaTableConfig.spritePlayers[5].betCoinY = JinHuaTableConfig.spritePlayers[5].locY - SPRITE_PLAYER_5_LOC_Y_DISTANCE_BET_COIN_Y * JinHuaTableConfig.TableScaleY
	--牌位置的X轴
	local cardLocX = JinHuaTableConfig.spritePlayers[5].locX - SPRITE_PLAYER_5_LOC_X_DISTANCE_CARD_LOC_X * JinHuaTableConfig.TableScaleX
	--牌位置的Y轴
	local cardLocY = JinHuaTableConfig.spritePlayers[5].locY + SPRITE_PLAYER_5_LOC_Y_DISTANCE_CARD_LOC_Y * JinHuaTableConfig.TableScaleY
	--庄、弃、败等icon的位置
	JinHuaTableConfig.spritePlayers[5].iconX = JinHuaTableConfig.spritePlayers[5].locX - SPRITE_PLAYER_5_LOC_X_DISTANCE_ICOIN_X * JinHuaTableConfig.TableScaleX + JinHuaTableConfig.iconWidth/2
	JinHuaTableConfig.spritePlayers[5].iconY = JinHuaTableConfig.spritePlayers[5].locY + SPRITE_PLAYER_5_LOC_Y_DISTANCE_ICOIN_Y * JinHuaTableConfig.TableScaleY + JinHuaTableConfig.iconHeight/2
	--牌位置
	JinHuaTableConfig.spritePlayers[5].cards = {}
	JinHuaTableConfig.spritePlayers[5].cards[1] = {}
	JinHuaTableConfig.spritePlayers[5].cards[2] = {}
	JinHuaTableConfig.spritePlayers[5].cards[3] = {}
	JinHuaTableConfig.spritePlayers[5].cards[1].locX = cardLocX + JinHuaTableConfig.cardWidth*JinHuaTableConfig.cardScale/2
	JinHuaTableConfig.spritePlayers[5].cards[1].locY = cardLocY
	JinHuaTableConfig.spritePlayers[5].cards[2].locX = cardLocX + JinHuaTableConfig.cardWidth*JinHuaTableConfig.cardScale
	JinHuaTableConfig.spritePlayers[5].cards[2].locY = cardLocY
	JinHuaTableConfig.spritePlayers[5].cards[3].locX = cardLocX +(JinHuaTableConfig.cardWidth+ JinHuaTableConfig.cardWidth/2)*JinHuaTableConfig.cardScale
	JinHuaTableConfig.spritePlayers[5].cards[3].locY = cardLocY
	--5号比牌按钮位置
	JinHuaTableConfig.spritePlayers[5].pkX = JinHuaTableConfig.spritePlayers[5].cards[2].locX
	JinHuaTableConfig.spritePlayers[5].pkY = JinHuaTableConfig.spritePlayers[5].cards[2].locY+JinHuaTableConfig.cardHeight/4
end

-- 初始化发牌位置
local function initSendCardPosition()
	JinHuaTableConfig.sendCardsSpritePositionX = CARDS_SPRITE_POSITION_X * JinHuaTableConfig.TableScaleX
	JinHuaTableConfig.sendCardsSpritePositionY = CARDS_SPRITE_POSITION_Y * JinHuaTableConfig.TableScaleY + JinHuaTableConfig.cardHeight*JinHuaTableConfig.cardScale - JinHuaTableConfig.fitY
	JinHuaTableConfig.cardsSpriteStartPositionX = CARDS_SPRITE_POSITION_X * JinHuaTableConfig.TableScaleX
	JinHuaTableConfig.cardsSpriteStartPositionY = CARDS_SPRITE_POSITION_Y * JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY
end

-- 初始化牌桌的大小和缩放比
function initTableSizeAndScale()
	JinHuaTableConfig.TableScaleX = 1
	local wdh = GameConfig.ScreenWidth / GameConfig.ScreenHeight
	if wdh < JinHuaTableConfig.TableProportion then
		JinHuaTableConfig.isPad = true
		-- 宽度固定1136，算出高度大小
		JinHuaTableConfig.TableRealHeight = JinHuaTableConfig.TableDefaultWidth / GameConfig.ScreenWidth * GameConfig.ScreenHeight
		--		JinHuaTableConfig.TableScaleY = JinHuaTableConfig.TableRealHeight / JinHuaTableConfig.TableDefaultHeight
	end
end

--适配预处理
function preTableFitCoordinate()
	local origin = CCDirector:sharedDirector():getVisibleOrigin()
	Common.log("适配预处理=== origin.y ==[" .. origin.y .. "] origin.x == [" .. origin.x .. "]");
	JinHuaTableConfig.fitY = 0 -- 可视原点
	JinHuaTableConfig.fitX = 0
end

local function initOtherPositioin()
	JinHuaTableConfig.enterTablePromptX = JinHuaTableConfig.spritePlayers[1].cards[1].locX - ENTER_TABLE_TIPS_X*JinHuaTableConfig.TableScaleX
	JinHuaTableConfig.enterTablePromptY = JinHuaTableConfig.spritePlayers[1].cards[1].locY + ENTER_TABLE_TIPS_Y*JinHuaTableConfig.TableScaleY
end

--[[--
--适配预处理，牌桌元素位置初始化
--]]
function initTableElmentsCoordinate()
	preTableFitCoordinate()
	--- 气泡移动的距离
	JinHuaTableConfig.bubbleSpriteMoveDistance = FROM_THE_BUBBLE_MOVES * JinHuaTableConfig.TableScaleY
	JinHuaTableConfig.playerWidth = PLAYER_PIC_WIDTH * JinHuaTableConfig.TableScaleX
	JinHuaTableConfig.playerHeight = PLAYER_PIC_HEIGHT * JinHuaTableConfig.TableScaleY

	initSendCardPosition()
	initTableBottomBtnLocation()
	initTableBetCoinRange()
	initTableRaiseBtnLocation()
	-- 玩家位置
	initTablePlayerLocation_1()
	initTablePlayerLocation_2()
	initTablePlayerLocation_3()
	initTablePlayerLocation_4()
	initTablePlayerLocation_5()

	initOtherPositioin()
end

-- 获取资源路径
function getJinHuaResource(fileName)
	return Common.getResourcePath("load_res/JinHua/"..fileName, pathTypeInApp)
end

--[[--
--获取扎金花版本号
--]]
function JinHuaTableConfig.getJinHuaVerCode()
	return JinHuaTableConfig.JinHuaVerCode;
end
