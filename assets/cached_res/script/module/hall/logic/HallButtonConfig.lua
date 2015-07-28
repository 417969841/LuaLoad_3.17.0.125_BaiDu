--
--大厅按钮配置
--
module("HallButtonConfig",package.seeall)

------Button Id---------------------
BTN_ID_MATCH_GAME = 1001;--比赛赢奖
BTN_ID_LEISURE_GAME = 1002;--休闲房间
BTN_ID_LUCKY_GAME = 1003;--幸运游戏
BTN_ID_PK_GAME = 1004;--疯狂闯关
BTN_ID_ACTIVITY = 1006;--活动
BTN_ID_CAI_SHEN = 1007;--财神
BTN_ID_RECHARGE = 1009;--充值
BTN_ID_CHAT = 1010;--聊天
BTN_ID_FREE_COIN = 1011;--免费金币

--按钮状态
BUTTON_STATUS_OPEN = 0;--正常(开启)
BUTTON_STATUS_GRAY = 1;--变灰(半透明)
BUTTON_STATUS_HIDE = 2;--隐藏

--所在view的位置
HALL_LOCATION_TOP = 1; --大厅上部
HALL_LOCATION_MID = 2; --大厅中部

----所在panel位置(从左到右)
PANEL_LOCATION_LEFT = 1;--第一位置
PANEL_LOCATION_CENTRE_LEFT = 2;--第二位置
PANEL_LOCATION_CENTRE = 3;--第三位置
PANEL_LOCATION_CENTRE_RIGHT = 4;--第四位置
PANEL_LOCATION_RIGHT = 5;--第五位置

--------------按钮中部的坐标---------------------------------------------------
--比赛赢奖、疯狂闯关不开启
MID_Y = 129;--中部的Y轴(比赛、房间、幸运游戏、闯关的Y轴)
CHAT_Y = 87;--聊天Y坐标

--比赛赢奖未开启(中间有四个按钮)
--CHAT_X = 36;--聊天X坐标
--MATCH_GAME_X = 451;--比赛赢奖X坐标(不显示)
--LEISURE_GAME_X = 256;--休闲房间X坐标(默认位置)
--LUCKY_GAME_X = 568;--幸运游戏X坐标(默认位置)
--PK_GAME_X = 880;--闯关X坐标(默认位置)

--中间有五个按钮
--比赛赢奖未开启按钮顺序：聊天、休闲房间、疯狂闯关、幸运游戏、比赛赢奖
--比赛赢奖开启按钮顺序：聊天、休闲房间、比赛赢奖、疯狂闯关、幸运游戏
MID_FOUR_BTN_LEFT_X = 31;--第一个按钮X轴
MID_FOUR_BTN_CENTRE_LEFT_X = 192;--第二个按钮X轴
MID_FOUR_BTN_CENTRE_X = 452;--第三个按钮X轴
MID_FOUR_BTN_CENTRE_RIGHT_X = 711;--第四个按钮X轴
MID_FOUR_BTN_RIGHT_X = 966--第五个按钮X轴

--------------按钮上部的坐标---------------------------------------------------
TOP_Y = 38;--上部的Y轴(财神、活动、免费金币、充值的Y)

--财神不开启(右上角的三个按钮)
CAI_SHEN_X = 987;--财神X轴(不显示)
FREE_COIN_X = 798;--免费金币X轴(默认位置)
ACTIVITY_X = 892;--活动X轴(默认位置)
RECHARGE_X = 1078;--充值X轴(默认位置)

--财神开启时(右上角的四个按钮)
TOP_FOUR_BTN_LEFT_X = 798;--第一个按钮(免费金币)
TOP_FOUR_BTN_CENTRE_LEFT_X = 892;--第二个按钮(活动)
TOP_FOUR_BTN_CENTRE_X = 987;--第三个按钮(财神)
TOP_FOUR_BTN_CENTRE_RIGHT_X = 1078;--第四个按钮(充值)

--[[--
--设置按钮位置值
--]]
function setButtonPositionValue()

	--------------按钮中部的坐标---------------------------------------------------
	--比赛赢奖、疯狂闯关不开启
	MID_Y = 129 * GameConfig.ScaleOrdinate;--中部的Y轴(比赛、房间、幸运游戏、闯关的Y轴)
	CHAT_Y = 87 * GameConfig.ScaleOrdinate;--聊天Y坐标

	--	--比赛赢奖未开启(中间有四个按钮)
	--	CHAT_X = 36 * GameConfig.ScaleAbscissa;--聊天X坐标
	--	MATCH_GAME_X = 451 * GameConfig.ScaleAbscissa;--比赛赢奖X坐标(不显示)
	--	LEISURE_GAME_X = 256 * GameConfig.ScaleAbscissa;--休闲房间X坐标(默认位置)
	--	LUCKY_GAME_X = 568 * GameConfig.ScaleAbscissa;--幸运游戏X坐标(默认位置)
	--	PK_GAME_X = 880 * GameConfig.ScaleAbscissa;--闯关X坐标(默认位置)

	--比赛赢奖开启(中间有五个按钮)
	MID_FOUR_BTN_LEFT_X = 31 * GameConfig.ScaleAbscissa;--第一个按钮X轴(聊天)
	MID_FOUR_BTN_CENTRE_LEFT_X = 192 * GameConfig.ScaleAbscissa;--第二个按钮X轴(休闲房间)
	MID_FOUR_BTN_CENTRE_X = 452 * GameConfig.ScaleAbscissa;--第三个按钮X轴(比赛赢奖)
	MID_FOUR_BTN_CENTRE_RIGHT_X = 711 * GameConfig.ScaleAbscissa;--第四个按钮X轴(疯狂闯关)
	MID_FOUR_BTN_RIGHT_X = 966 * GameConfig.ScaleAbscissa--第五个按钮X轴(幸运游戏)

	--------------按钮上部的坐标---------------------------------------------------
	TOP_Y = 38 * GameConfig.ScaleOrdinate;--上部的Y轴(财神、活动、免费金币、充值的Y)

	--财神不开启(右上角的三个按钮)
	CAI_SHEN_X = 987 * GameConfig.ScaleAbscissa;--财神X轴(不显示)
	FREE_COIN_X = 798 * GameConfig.ScaleAbscissa;--免费金币X轴(默认位置)
	ACTIVITY_X = 892 * GameConfig.ScaleAbscissa;--活动X轴(默认位置)
	RECHARGE_X = 1078 * GameConfig.ScaleAbscissa;--充值X轴(默认位置)

	--财神开启时(右上角的四个按钮)
	TOP_FOUR_BTN_LEFT_X = 798 * GameConfig.ScaleAbscissa;--第一个按钮(免费金币)
	TOP_FOUR_BTN_CENTRE_LEFT_X = 892 * GameConfig.ScaleAbscissa;--第二个按钮(活动)
	TOP_FOUR_BTN_CENTRE_X = 987 * GameConfig.ScaleAbscissa;--第三个按钮(财神)
	TOP_FOUR_BTN_CENTRE_RIGHT_X = 1078 * GameConfig.ScaleAbscissa;--第四个按钮(充值)
end
