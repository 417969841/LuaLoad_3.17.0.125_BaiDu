module("GameConfig", package.seeall)
--游戏id
GAME_ID = 1
JINHUA_GAME_ID = 4

ServerPhone = "18210234002";
ServerQQ = "249112220"
APP_NAME = "lord"
TimeDifference = 0
NeedToInstallApp = false;--是否需要安装应用 false 否true 1
AppFilePath = "";--下载完的app存放的路径

STAY_TIME = 4001 -- 用户停留时间(用户活动ID, 斗地主的活动ID)
enterGameTime = 0 -- 用户进入游戏的时间

ScreenWidth = 1136 -- 屏幕宽度（分辨率）
ScreenHeight = 640 -- 屏幕高度（分辨率）

--如果当前屏幕的比例是大于1.6,则使用1136x640的UI工程(1136 / 640 = 1.7)
--如果当前屏幕的比例是大于1.4小于1.6,则使用960x640的UI工程(960 / 640 = 1.5)
--如果当前屏幕的比例是小于1.4,则使用的UI工程(待定)
SCREEN_PROPORTION_GREAT = 1.6;--大的屏幕比例
SCREEN_PROPORTION_SMALL = 1.4;--小的屏幕比例
RealProportion = 1.775;--真实的屏幕比例(默认是1.775)
ScaleAbscissa = 1; --横坐标的缩放
ScaleOrdinate= 1; --纵坐标的缩放

IOSChannelID = 0 --ios的渠道号

PAYMENT_SMS = 0--自有短代
PAYMENT_IAP = 1--iap
PAYMENT_91 = 2--91
PAYMENT_HAIMA = 3--海马

--ios的支付方式  0：自有短代   1:iap   2:91  3:海马
PaymentForIphone = 0
--IAP支付模式   sandbox:测试环境       itunes：支付环境
PayType = "sandbox"

--ios海马升级配置
mnIOSForce = 0 --nForce == 1强制更新 0非强制
mnIOSTest = 0 --nTest == 1调试模式 0非调试模式(发包时必须要是0)

--高级表情包物品ID
GOODS_ID_SUPERIORFACE = 12
--换牌道具物品ID
GOODS_ID_CHANGECARD = 24
--禁比道具物品ID
GOODS_ID_NO_PK = 25

-- 高级表情包item id
ITEM_ID_SUPERIORFACE_30 = 19
ITEM_ID_SUPERIORFACE_7 = 20
ITEM_ID_SUPERIORFACE_2 = 21

-- 记牌器item id
GOODS_JIPAIQI = 4;-- 记牌器
GOODS_GAOJIBIAOQINGBAO = 39 --高级表情包

--高级表情使用剩余时间
remainSuperiorFaceTime = 0

--移动支付方式定义
PAYMENT_ONLY_MM = 1;-- 只显示MM
PAYMENT_ONLY_SMSONLINE = 2;-- 只显示网游基地
PAYMENT_NO_MM_NO_SMSONLINE_SHOW_OTHERS = 3;-- 不显示MM,不显示网游基地,显示其他支付
PAYMENT_SHOW_MM_OTHERS = 4;-- 显示MM及其他支付
PAYMENT_SHOW_SMSONLINE_OTHERS = 5;-- 显示网游基地及其他支付
PAYMENT_ONLY_PURSE = 6; --显示手机钱包支付
PAYMENT_SHOW_EPAY = 7;--显示宜支付

PAYMENT_SHOW_YINBEIKE_CMCC = 76 --银贝壳移动
PAYMENT_SHOW_YINBEIKE_UNI = 77 --银贝壳联通
PAYMENT_SHOW_YINBEIKE_CT = 78 --银贝壳电信

PAYMENT_SHOW_HONGRUAN_SDK_CMCC = 83 --红软移动
PAYMENT_SHOW_HONGRUAN_SDK_UNICOM = 84 --红软联通
PAYMENT_SHOW_HONGRUAN_SDK_CT = 85 --红软电信
--电信支付方式定义
PAYMENT_NO_SHOW_TELECOM = 0;--不显示电信支付
PAYMENT_SHOW_HUAJIAN_OTHERS = 1; -- 显示华健电信
PAYMENT_SHOW_CTESTORE_OTHERS = 2; -- 显示天翼空间
--联通支付方式定义
PAYMENT_NO_SHOW_UNICOM = 0;--不显示电信支付
PAYMENT_SHOW_HUAJIAN_UNICOM_OTHERS = 1; -- 显示联通短代
PAYMENT_SHOW_WOSTORE_OTHERS = 2; -- 显示联通沃商店
PAYMENT_SHOW_WOJIA = 6; -- 显示同趣联通WO+

--移动支付方式,默认显示MM支付(4)的包，才可以切换;默认显示游戏基地支付(5)的包，不切换
PAYMENT_METHOD_STATUS = 5;-- 显示支付方式的模式
--电信支付方式,可切换
PAYMENT_METHOD_STATUS_DIANXIN = 1;-- 显示支付方式的模式
--联通支付方式,可切换
PAYMENT_METHOD_STATUS_LIANTONG = 1;-- 显示支付方式的模式

isRegister = false; --是否是刚注册

isFirstEnterGame = false; --是否是本游戏新用户(首次进入游戏)
-- 牌桌音效下载地址
URL_TABLE_MUSIC = "http://f.99sai.com/remote-res/jinhua/jinhua-music-V1.0.zip";
-- 二次加载路径
DIR_RELOAD = "TqPic/reload";
-- 元宝与金钱的兑换倍数
MONEY_TO_YUANBAO = 7;
--是否已经建立Socket连接
isConnect = false;
--不是新注册用户，判断是否进行过新手引导
isFirstSendTaskState = false;
--推荐人用户ID
IntroducerID = 0
--是否已经检测脚本版本
isCheckScript = false;
--是否是完整包
isFullPackage = true;
--是否可以弹出礼包和绑定手机弹框
isShowHallGiftOrBindPhone = true;
--绑定手机后有礼包弹出
hasShowHallGift = false

--音乐和音效
local GameMusicOff = -1;
local GameSoundOff = -1;
local GameAutomation = -1;

local GameRevibrate = 1; -- 牌桌震动，默认第一次是开启的

--WEBVIEW预加载_URL地址
URL_TABLE_LOGIN = "http://f.99sai.com/lord/ServiceTermV2.html"--登录页面用户协议
URL_TABLE_LUKEYTURN_HELP = "http://f.99sai.com/html/rotary/rotary_intro.html";--幸运转盘帮助
URL_TABLE_MONTHSIGN_HELP = "http://f.99sai.com/html/monthly_sign/monthly_sign_intro.html";--月签帮助
--URL_TABLE_CUSTOMSERVICE_SERVICE  = "http://f.99sai.com/lord/v300/lordHelp5.html" --客服常见问题
--URL_TABLE_CUSTOMSERVICE_HELP = "http://f.99sai.com/lord/v300/lordHelp1.html" --客服游戏帮助
URL_TABLE_CUSTOMSERVICE_HELP = "http://f.99sai.com/lord/v300/lordHelp9.html" --客服游戏帮助,常见问题
URL_TABLE_TTHELP = "http://f.99sai.com/lord/ladder/about_ladder.html" --天梯信息帮助
URL_TABLE_CRAZYSTAGE_HELP = "http://f.99sai.com/html/crazy_stage/CrazyStageHelp314.html" --疯狂闯关帮助
--URL_TABLE_CRAZYRULE = "http://f.99sai.com/html/crazy_stage/CrazyStageHelp.html"; --闯关规则内容
URL_XY_PLATFORM_GIFT_BAG = "http://f.99sai.com/html/third_platform/xyplatform_giftbag.html";--XY平台兑换礼包
URL_TABLE_PAIHANGBANG_HEIP = "http://f.99sai.com/operational/recharge_rank/RechargeRankHelp.html"; --每日充值榜帮助
--[[--
--获取当前包是否是完整包
--@return #boolean true:完整包，false:精简包
--]]
function gameIsFullPackage()
	return isFullPackage
end

--[[--
--获取音乐开关--音乐默认适时开启  1开启, 0关闭
--@return #boolean 是否开启音乐true开启
--]]
function getGameMusicOff()
	if GameMusicOff < 0 then
		GameMusicOff = Common.getDataForSqlite(CommSqliteConfig.GameMusicOffData)
		if GameMusicOff == nil then
			GameMusicOff = 1
		end
	end
	if GameMusicOff == 1 then
		return true;
	else
		return false;
	end
end
--[[--
--设置音乐开关--音乐默认适时开启  1开启, 0关闭
--@param #boolean isOff 是否开启音乐
--]]
function setGameMusicOff(isOff)
	if isOff then
		--音乐开启
		GameMusicOff = 1;
		if AudioManager.getOldMusicName() == nil then
			if getTheCurrentBaseLayer() == GUI_HALL then
				AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.HALL_BACKGROUND);
			elseif getTheCurrentBaseLayer() == GUI_TABLE then
				if (TableConsole.mode == TableConsole.ROOM) then
					AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.ROOM_BACKGROUND);
				elseif (TableConsole.mode == TableConsole.MATCH) then
					Common.setButtonVisible(btn_match_ranking, true);
					AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.MATCH_BACKGROUND);
				end
			end
		else
			AudioManager.resumeBackgroundMusic();
		end
	else
		--音乐关闭
		GameMusicOff = 0;
		AudioManager.stopBgMusic();
	end
	Common.setDataForSqlite(CommSqliteConfig.GameMusicOffData, GameMusicOff)
end

--[[--
--获取音效开关--音效默认是开启   1开启, 0关闭
--@return #boolean 是否开启音效true开启
--]]
function getGameSoundOff()
	if GameSoundOff < 0 then
		GameSoundOff = Common.getDataForSqlite(CommSqliteConfig.GameSoundOffData)
		if GameSoundOff == nil then
			GameSoundOff = 1
		end
	end
	if GameSoundOff == 1 then
		return true;
	else
		return false;
	end
end
--[[--
--设置音效开关--音效默认是开启   1开启, 0关闭
--@param #boolean isOff 是否开启音效
--]]
function setGameSoundOff(isOff)
	if isOff then
		--音效开启
		GameSoundOff = 1;
	else
		--音效关闭
		GameSoundOff = 0;
		AudioManager.stopAllSound()
	end
	Common.setDataForSqlite(CommSqliteConfig.GameSoundOffData, GameSoundOff)
end

--[[--
--获取是否自动提示
--@return #boolean 是否自动提示true开启
--]]
function getGameAutomation()
	if GameAutomation  < 0 then
		GameAutomation = Common.getDataForSqlite(CommSqliteConfig.GameAutomationData)
		if GameAutomation == nil then
			GameAutomation = 0
		end
	end
	if GameAutomation == 1 then
		return true;
	else
		return false;
	end
end
--[[--
--设置自动提示开关
--@param #boolean isOff 是否开启自动提示
--]]
function setGameAutomation(isOff)
	if isOff then
		--音效开启
		GameAutomation = 1;
	else
		--音效关闭
		GameAutomation = 0;
	end
	Common.setDataForSqlite(CommSqliteConfig.GameAutomationData, GameAutomation)
end

--[[--
--获取是否震动
--@return #boolean 是否震动true开启
--]]
function getGameVibrate()
	if GameRevibrate  < 0 then
		GameRevibrate = Common.getDataForSqlite(CommSqliteConfig.GameVibrateData)
		if GameRevibrate == nil then
			GameRevibrate = 0
		end
	end
	if GameRevibrate == 1 then
		return true;
	else
		return false;
	end
end
--[[--
--设置震动开关
--@param #boolean isOff 是否开启震动
--]]
function setGameVibrate(isOff)
	if isOff then
		--震动开启
		GameRevibrate = 1;
	else
		--震动关闭
		GameRevibrate = 0;
	end
	Common.setDataForSqlite(CommSqliteConfig.GameVibrateData, GameRevibrate)
end

--[[----------- 界面层级数据 ------------]]

--上一底层界面
local theLastBaseLayer = nil

--[[--
-- 获取上一底层界面名称
]]
function getTheLastBaseLayer()

	if theLastBaseLayer == nil then
		theLastBaseLayer = GUI_HALL
	end

	if getTheCurrentBaseLayer() == theLastBaseLayer then
		--如果已经无法确定上一层级界面,则返回大厅
		return GUI_HALL
	else
		return theLastBaseLayer
	end
end

--[[--
-- 设置获取上一底层界面名称
]]
function setTheLastBaseLayer(lastBaseLayer)
	theLastBaseLayer = lastBaseLayer

end

--当前底层界面
local theCurrentBaseLayer = nil

--[[--
-- 获取当前底层界面名称
]]
function getTheCurrentBaseLayer()

	return theCurrentBaseLayer
end

--[[--
-- 设置获取当前底层界面名称
]]
function setTheCurrentBaseLayer(CurrentBaseLayer)
	theCurrentBaseLayer = CurrentBaseLayer

	--每次跳转界面要做的逻辑处理
	if theCurrentBaseLayer ~= GUI_LOADING and theCurrentBaseLayer ~= GUI_LOGIN then
		sendGIFTBAGID_USER_ENCHARGE_INFO()--请求个人充值金额
		sendGIFTBAGID_GET_GIFTBAG_MSG()--请求礼包状态

		if theCurrentBaseLayer == GUI_HALL then
		--profile.Gift.sendFirstGiftIconMsg(1);
		elseif theCurrentBaseLayer == GUI_TABLE then
			profile.Gift.sendFirstGiftIconMsg(2);
		end
	end
end

--[[--
--根据GUI获取layer的层级
--]]
function getModuleLayerByGUI(sGui)
	if ModuleTable[sGui] ~= nil then
		return Layer[ModuleTable[sGui]["layer"]];
	else
		Common.log("Common.getModuleLayerByGUI(" .. sGui .. ") is nil");
		return nil;
	end
end

--[[--
--设置当前屏幕的分辨率
--一级界面设置显示屏幕比例(本期3.06pad版留黑边)
--二三级界面使用当前一级界面屏幕比例进行缩放(对应屏幕比例的UI不存在)
--@param #UILayer UIView 进行适配的view
--@param #String gui 当前界面的GUI
--@param #number UIDesignWidth UI工程的宽
--@param #number UIDesignHeight UI工程的宽
--@param #type kResolution 适配的方式 kResolutionExactFit(拉伸)、kResolutionShowAll(留黑边)
--]]
function setCurrentScreenResolution(UIView, gui, UIDesignWidth, UIDesignHeight, kResolution)
	if gui ~= nil and  getModuleLayerByGUI(gui) == 1 then
		--如果是一级界面,设置游戏分辨率
		ScreenWidth = UIDesignWidth;
		ScreenHeight = UIDesignHeight;
		CCEGLView:sharedOpenGLView():setDesignResolutionSize(ScreenWidth,ScreenHeight, kResolution);
	else
		--不是一级界面,二三级界面使用当前一级界面屏幕比例进行缩放
		if UIDesignWidth ~= ScreenWidth then
			--如果当前游戏设计的分辨率的宽不等于当前UI工程的宽,将当前的UI进行缩放
			UIView:setScaleX(ScreenWidth / UIDesignWidth);
		end
		if UIDesignHeight ~= ScreenHeight then
			--如果当前游戏设计的分辨率的宽不等于当前UI工程的宽,将当前的UI进行缩放
			UIView:setScaleY(ScreenHeight / UIDesignHeight);
		end
		--二三级界面适配需要：将锚点设为(0,0)
		UIView:setAnchorPoint(ccp(0,0));
	end
end

local hallShowMode = 0 --当前大厅显示模式
local JinHuaHallShowMode = 0 --当前金花大厅显示模式

--[[--
-- 获取当前大厅显示模式
]]
function getHallShowMode()
	return hallShowMode
end

--[[--
-- 设置当前大厅显示模式
]]
function setHallShowMode(ShowMode)
	hallShowMode = ShowMode
end

--[[--
-- 获取金花大厅显示模式
]]
function getJinHuaHallShowMode()
	return JinHuaHallShowMode
end

--[[--
-- 设置金花大厅显示模式
]]
function setJinHuaHallShowMode(ShowMode)
	JinHuaHallShowMode = ShowMode
end

local hallTableState = 1 --显示当前的选择状态

--[[--
-- 获取当前的选择状态
]]
function getHallTableState()
	Common.log("获取当前的选择状态hallTableState ==========  "..hallTableState)
	return hallTableState
end

--[[--
-- 设置当前的选择状态
]]
function setHallTableState(TableState)
	hallTableState = TableState
end

local hallRoomItem = 0 --房间类型

--[[--
-- 获取房间类型
]]
function getHallRoomItem()
	return hallRoomItem
end

--[[--
--设置房间类型
]]
function setHallRoomItem(RoomItem)
	hallRoomItem = RoomItem
end

local rechargeShowState = 0 --当前支付界面显示状态

--[[--
-- 获取当前支付界面显示状态
]]
function getRechargeShowState()
	return rechargeShowState
end

--[[--
-- 设置当前支付界面显示状态
]]
function setRechargeShowState(RechargeShowState)
	rechargeShowState = RechargeShowState
end

--[[----------- 公共数据定义 ------------]]

mnHallInitSendMsg = false --在大厅界面是否发送公共消息请求
--isHallSendFirst = false --在大厅判断是否每日是否发送

--[[--
--初始化游戏公共数据
]]
function initGameCommonData()
	mnHallInitSendMsg = false;
	isFirstSendTaskState = false;
	remainSuperiorFaceTime = 0
--	isHallSendFirst = false
end

--系统弹出框
function showAlertDialog(sMsg)
	local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
	local javaMethodName = "showAndroidDialog"
	local javaParams = {
		sMsg,
	}
	luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
end

--[[---------是否是第一次进入大厅页面----------]]
mnIsFirstInHall = true
