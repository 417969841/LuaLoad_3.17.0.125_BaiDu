module("WanRenJinHuaConfig", package.seeall)

WanRenJinHuaBetState = 2 -- 下注状态
WanRenJinHuaResultState = 3 -- 结果状态

BetCoinStartX = 0 -- 要下注列表最后一个下注按钮X轴
BetCoinStartY = 0 -- 要下注列表最后一个下注按钮Y轴
BetCoinDistance = 0 -- 下注按钮间隔距离

TableCoinRang_Left = {} -- 已经下的筹码在桌上的显示区域
TableCoinRang_Right = {}
TableCoinRang_Top = {}
TableCoinRang_Bottom = {}
-- 牌的位置
TableCardPositionX = {}--庄家、押注池1、押注池2、押注池3、押注池4、
TableCardPositionY = {}
-- 自己下注数显示的位置
SelfBetNumLabelX = {}
SelfBetNumLabelY = {}
TableTimerX = 0 --倒计时位置
TableTimerY = 0
CurrentInning = 0 -- 当前局数
TableStatus = 0 -- 牌桌状态
BetAreaX = {} -- 下注区域
BetAreaY = {}
WanRenJinHuaBtnX = {};--万人金花按钮(上庄、帮助、历史)
WanRenJinHuaBtnY = {};--万人金花按钮(上庄、帮助、历史)

SelfUserInfoRectWidth = 0
SelfUserInfoRectHeight = 0

DealerInfoX = 0 -- 庄家个人信息位置
DealerInfoY = 0
SelfUserInfoX = 0 -- 自己的个人信息的位置

CardRotation = {-15, 0, 15} -- 牌的旋转角度

CardScale = 0.8 -- 牌的缩放比例

SendCardPositionX = 0
SendCardPositionY = 0

BetAllNumX = {} -- 每个注池上下注总数的坐标
BetAllNumY = {}

-- 牌型名字
CardTypeName = {dilong="dilong", baozi="baozi", duizi="duizi", tonghua="tonghua", gaopai="gaopai", tonghuashun="tonghuashun", shunzi="shunzi"}

----万人金花移植于金花的config----
fitY = 0--屏幕适配Y轴偏移
fitX = 0--屏幕适配X轴偏移
--TableProportion = TableConfig.TableDefaultWidth / TableConfig.TableDefaultHeight;--牌桌比例(宽/高)
isPad = false -- 适配一些宽高比小于1.6的
SysTemTimeX = 0;--系统时间X轴
WanRenJinHuaTitleY = 0;--万人金花标题的Y
SelfUserInfoElementsPositionX = {};--个人信息元素位置(头像、金币、名字、充值引导)
SelfUserInfoElementsPositionY = {};
DealerInfoBgHight = 0;--庄家信息栏背景(包括帮助按钮等)
DealerInfoBgTopY = 0;--庄家信息栏上部的Y
DealerMarkPosition = {};--庄的标志
EachCardDistanceX = {};--三张牌中，距离中间牌X轴的距离

local FIT_CONFIG_X = 40; --适配可视点分界(1:1.65)
------------------大于1.65的参数---------------------------
local MAX_FIRST_BET_AREA_X_MID_POINT = 183; --第一个下注区的x轴中间
local LAST_BET_BTN_X = 1036;--最后一个下注按钮的X轴
local BET_COIN_DISTANCE_X = 109;--下注列表每个按钮之间的距离
local BET_AREA_DISTANCE_X = 256;--每个押注区的X轴的距离(和每副牌的距离一致)
local BET_AREA_Y = 264;--押注池中点的Y
local BET_AREA_SIZE_WIDTH = 218 / 2; --下注区宽的一半
local BET_AREA_SIZE_HEIGHT = 214 / 2; --下注区高的一半
local NOT_BET_AREA_HEIGHT_TOP = 20; --下注池不能下注局的高(上部)
local NOT_BET_AREA_HEIGHT_BOTTOM = 10; --下注池不能下注局的高(下部)
local TABLE_CARD_POSITION_Y = 418; --牌的高度
local DECLEAR_CARD_POSITION_X_TABLE_MIDDLE = 2;--庄家的牌X轴的距离牌桌的中点
local DECLEAR_CARD_POSITION_Y = 518;--庄家的牌Y轴的距离
local OWN_TOTAL_BET_NUM_Y = 140; --自己下注总金额数的Y轴(每个押注池)
local COUNT_DOWN_POSITION_X = 800;--倒计时位置X轴
local COUNT_DOWN_POSITION_Y = 518;--倒计时位置Y轴
local SELF_USER_INFO_RECT_WIDTH = 408;--个人信息的宽
local SELF_USER_INFO_RECT_HEIGHT = 122;--个人信息的高
local DEALER_INFO_X = 180; --庄家信息X轴
local DEALER_INFO_Y = 580; --庄家信息Y轴
local DEALER_INFO_BG_HEIGHT = 100; --庄家信息栏背景
local DEALER_INFO_BG_TOP_Y = 70; --庄家信息栏上面的Y距离屏幕最上面
local SELF_USER_INFO_X = 8; --个人信息X轴
local SEND_CARD_POSITION_Y = 145;--发牌位置Y轴
local BET_ALL_NUM_POSITION_Y_TABLE_MIDDLE = 30;--每个注池总金额距离注池中点
local HELP_BTN_X = 922;--帮助按钮
local HISTORY_BTN_X = 1035;--历史
local ALL_BTN_Y = 518;--帮助和历史等的Y轴
local UP_DEALER_BTN_X = 50;--上庄按钮X轴
local UP_DEALER_BTN_Y = 518;--上庄按钮Y轴
local WAN_REN_JIN_HUA_TITLE_Y = 604;--万人金花标题的Y轴
local SELF_USER_COIN_IMG_X = 110;        --金币图片
local SELF_USER_COIN_IMG_Y = 23;
local SELF_USER_COIN_NUM_X = 160;        --金币数
local SELF_USER_COIN_NUM_Y = 23;
local SELF_USER_NAME_X = 110;		--昵称
local SELF_USER_NAME_Y = 67;
local SELF_USER_IMG_X = 60		--头像
local SELF_USER_IMG_Y = 60
local SELF_USER_RECHARGE_X = 360 --充值引导
local SELF_USER_RECHARGE_Y = 65
local DEALER_MARK_X = 263;--庄的标志
local DEALER_MARK_Y = 490;--
local EACH_CARD_DISTANCE_X = 30;--每个牌之间的距离(三张牌)
------------------小于1.65的参数---------------------------
local MIN_FIRST_BET_AREA_X_MID_POINT = 127; --第一个下注区的x轴中间

--[[--
--初始化万人金花配置参数
--]]
function initWanRenJinHuaConfig()
	local betAreaStartX -- 第一个下注区的中间  (牌的位置, 及筹码区的位置, 及自己下注和赢金币数的位置都是以此为基点)
	if fitX >= FIT_CONFIG_X then
		betAreaStartX = MIN_FIRST_BET_AREA_X_MID_POINT*TableConfig.TableScaleX + fitX
	else
		betAreaStartX = MAX_FIRST_BET_AREA_X_MID_POINT*TableConfig.TableScaleX + fitX
	end

	BetCoinStartX = LAST_BET_BTN_X;

	BetCoinDistance = BET_COIN_DISTANCE_X * TableConfig.TableScaleX
	BetCoinStartY = fitY

	local betAreaDistanceX = BET_AREA_DISTANCE_X * GameConfig.ScaleAbscissa * TableConfig.TableScaleX -- 每个下注区的间隔
	local betAreaStartY =BET_AREA_Y * TableConfig.TableScaleY + fitY -- 下注区高度
	BetAreaX = {betAreaStartX, betAreaStartX+betAreaDistanceX, betAreaStartX+2*betAreaDistanceX, betAreaStartX+3*betAreaDistanceX}
	BetAreaY = {betAreaStartY, betAreaStartY, betAreaStartY, betAreaStartY}

	local betAreaSizeX = BET_AREA_SIZE_WIDTH *TableConfig.TableScaleX -- 下注区域一半的大小
	local betAreaSizeY = BET_AREA_SIZE_HEIGHT *TableConfig.TableScaleY
	local tableCoinRangBottomY = BetAreaY[1] - betAreaSizeY + NOT_BET_AREA_HEIGHT_BOTTOM -- 下注区底部
	local tableCoinRangTopY = BetAreaY[1] + betAreaSizeY - NOT_BET_AREA_HEIGHT_TOP * TableConfig.TableScaleY -- 下注区顶部

	TableCoinRang_Left = {BetAreaX[1]-betAreaSizeX, BetAreaX[2]-betAreaSizeX, BetAreaX[3]-betAreaSizeX, BetAreaX[4]-betAreaSizeX}
	TableCoinRang_Right = {BetAreaX[1]+betAreaSizeX, BetAreaX[2]+betAreaSizeX, BetAreaX[3]+betAreaSizeX, BetAreaX[4]+betAreaSizeX}
	TableCoinRang_Bottom = {tableCoinRangBottomY, tableCoinRangBottomY, tableCoinRangBottomY, tableCoinRangBottomY}
	TableCoinRang_Top = {tableCoinRangTopY, tableCoinRangTopY, tableCoinRangTopY, tableCoinRangTopY}

	local tableCardStartX = betAreaStartX * GameConfig.ScaleAbscissa -- 第一副非庄家牌的位置
	local tableCardDistanceX = BET_AREA_DISTANCE_X * GameConfig.ScaleAbscissa *TableConfig.TableScaleX -- 每副牌的距离
	local tableCardPositionY = TABLE_CARD_POSITION_Y*TableConfig.TableScaleY -- 高度
	TableCardPositionX = {TableConfig.TableDefaultWidth/2+ DECLEAR_CARD_POSITION_X_TABLE_MIDDLE, tableCardStartX, tableCardStartX+tableCardDistanceX, tableCardStartX+2*tableCardDistanceX, tableCardStartX+3*tableCardDistanceX}
	TableCardPositionY = {DECLEAR_CARD_POSITION_Y*TableConfig.TableScaleY - fitY, tableCardPositionY, tableCardPositionY, tableCardPositionY, tableCardPositionY}
	EachCardDistanceX =  {- EACH_CARD_DISTANCE_X * TableConfig.TableScaleX, 0, EACH_CARD_DISTANCE_X * TableConfig.TableScaleX}

	local betNumLabelY = OWN_TOTAL_BET_NUM_Y * TableConfig.TableScaleY + fitY -- 自己下注数的位置
	SelfBetNumLabelX = {TableCardPositionX[2], TableCardPositionX[3], TableCardPositionX[4], TableCardPositionX[5]}
	SelfBetNumLabelY = {betNumLabelY, betNumLabelY, betNumLabelY, betNumLabelY}

	TableTimerX = COUNT_DOWN_POSITION_X * GameConfig.ScaleAbscissa*TableConfig.TableScaleX - fitX --倒计时位置
	TableTimerY = COUNT_DOWN_POSITION_Y*TableConfig.TableScaleY - fitY

	SelfUserInfoRectWidth = SELF_USER_INFO_RECT_WIDTH * TableConfig.TableScaleX -- 自己个人信息的大小
	SelfUserInfoRectHeight = SELF_USER_INFO_RECT_HEIGHT * TableConfig.TableScaleY

	DealerInfoBgTopY = TableConfig.TableRealHeight-DEALER_INFO_BG_TOP_Y*TableConfig.TableScaleY-fitY
	-- 庄家个人信息位置
	DealerInfoX = DEALER_INFO_X * TableConfig.TableScaleX + fitX
	DealerInfoY = DEALER_INFO_Y * TableConfig.TableScaleY
	DealerInfoBgHight = DEALER_INFO_BG_HEIGHT * TableConfig.TableScaleY
	SelfUserInfoX = SELF_USER_INFO_X + fitX

	SendCardPositionX =	TableConfig.TableDefaultWidth/2 -- 发牌位置
	SendCardPositionY = SEND_CARD_POSITION_Y*TableConfig.TableScaleY + fitY

	local betAllNumXStart = betAreaStartX -- 第一个注池总注数
	local betAllNumY = TableConfig.TableRealHeight/2 + BET_ALL_NUM_POSITION_Y_TABLE_MIDDLE*TableConfig.TableScaleY + fitY -- 注池总注数显示高度
	BetAllNumX = {betAllNumXStart, betAllNumXStart + tableCardDistanceX, betAllNumXStart + 2*tableCardDistanceX, betAllNumXStart + 3*tableCardDistanceX}
	BetAllNumY = {betAllNumY, betAllNumY, betAllNumY, betAllNumY}

	--帮助
	local helpBtnX = HELP_BTN_X;
	local helpBtnY = ALL_BTN_Y;
	--历史
	local historyBtnX = HISTORY_BTN_X;
	local historyBtnY = ALL_BTN_Y;
	--上庄
	local upDealerBtnX = UP_DEALER_BTN_X;
	local upDealerBtnY = UP_DEALER_BTN_Y;

	WanRenJinHuaBtnX["help"] = helpBtnX;
	WanRenJinHuaBtnY["help"] = helpBtnY;
	WanRenJinHuaBtnX["history"] = historyBtnX;
	WanRenJinHuaBtnY["history"] = historyBtnY;
	WanRenJinHuaBtnX["upDealer"] = upDealerBtnX;
	WanRenJinHuaBtnY["upDealer"] = upDealerBtnY;

	SysTemTimeX = HISTORY_BTN_X;
	WanRenJinHuaTitleY = WAN_REN_JIN_HUA_TITLE_Y*TableConfig.TableScaleY-fitY;

	SelfUserInfoElementsPositionX.selfUserCoinImg = SELF_USER_COIN_IMG_X *TableConfig.TableScaleX + fitX
	SelfUserInfoElementsPositionX.selfUserCoinNum = SELF_USER_COIN_NUM_X *TableConfig.TableScaleX + fitX
	SelfUserInfoElementsPositionX.selfUserName = SELF_USER_NAME_X *TableConfig.TableScaleX + fitX
	SelfUserInfoElementsPositionX.selfUserImg = SELF_USER_IMG_X *TableConfig.TableScaleX + fitX
	SelfUserInfoElementsPositionX.selfUserRecharge = SELF_USER_RECHARGE_X;

	SelfUserInfoElementsPositionY.selfUserCoinImg = SELF_USER_COIN_IMG_Y *TableConfig.TableScaleY + fitY
	SelfUserInfoElementsPositionY.selfUserCoinNum = SELF_USER_COIN_NUM_Y *TableConfig.TableScaleY + fitY
	SelfUserInfoElementsPositionY.selfUserName = SELF_USER_NAME_Y *TableConfig.TableScaleY + fitY
	SelfUserInfoElementsPositionY.selfUserImg = SELF_USER_IMG_Y *TableConfig.TableScaleY + fitY
	SelfUserInfoElementsPositionY.selfUserRecharge = SELF_USER_RECHARGE_Y *TableConfig.TableScaleY + fitY

	DealerMarkPosition["X"] = DEALER_MARK_X * TableConfig.TableScaleX - fitX
	DealerMarkPosition["Y"] = DEALER_MARK_Y * TableConfig.TableScaleY - fitY

end

-- 获取资源路径
function getWanRenJinHuaResource(fileName)
	return Common.getResourcePath("load_res/WanRenJinHua/"..fileName, pathTypeInApp)
end

--[[--
--初始化牌桌的大小和缩放比
--]]--
function initTableSizeAndScale()
	TableConfig.TableScaleY = 1
	--	local wdh = GameConfig.ScreenWidth / GameConfig.ScreenHeight
	--	if wdh < TableProportion then
	--		isPad = true
	--		-- 宽度固定1136，算出高度大小
	--		TableConfig.TableRealHeight = TableConfig.TableDefaultWidth / GameConfig.ScreenWidth * GameConfig.ScreenHeight
	--		TableConfig.TableScaleY = TableConfig.TableRealHeight / TableConfig.TableDefaultHeight
	--	end

	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--如果手机当前的分比率小于1.6且大于1.4,使用960x640的UI工程
		TableConfig.TableScaleX = 1.7 / 1.5;
	else
		TableConfig.TableScaleX = 1;
	end

end

--[[--
--适配预处理
--]]
function preTableFitCoordinate()
	local origin = CCDirector:sharedDirector():getVisibleOrigin()
	Common.log("适配预处理=== origin.y ==[" .. origin.y .. "] origin.x == [" .. origin.x .. "]");
	fitY = origin.y -- 可视原点
	fitX = origin.x
end