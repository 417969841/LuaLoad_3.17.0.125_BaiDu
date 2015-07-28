module("HallLogic",package.seeall)

--界面
view = nil

--控件
--top
img_useravator = nil--头像
img_useravatorbg = nil
img_userinfo = nil
ImageView_vip = nil;--VIP图片
LabelAtlas_viplevel = nil;--VIP等级
maskImageView = nil;--VIP遮罩
btn_VIPkaitong = nil;--
lab_nickname = nil;--昵称
Image_NickNameBg = nil;
lab_coin = nil--金币
lab_YuanBao = nil;--增加元宝按钮
btn_YuanBao = nil;--元宝数
btn_lucky_game = nil--幸运游戏(小游戏)
btn_caishen = nil--财神
btn_chongzhi = nil --充值
btn_FreeCoin = nil;--免费金币
lab_time = nil
btn_back = nil
--img_topbg = nil --顶部背景
itemLabel = nil
--mid
btn_matchgame = nil--比赛赢奖
btn_leisuregame = nil--休闲房间
btn_hall_huodong = nil--活动(活动专区)
btn_pk_game = nil;--疯狂闯关
btn_quickstart = nil--快速开始
scroll_roomlist = nil --房间列表
scroll_matchlist = nil--比赛列表
panel_top = nil;--大厅上部
panel_hall = nil--大厅中部
panel_end = nil;--大厅下部
panel_room = nil
panel_match = nil
bg_Light = nil;--发光背景(用于在新功能开启的时候)
--mid 按钮
img_laizi = nil--癞子
img_happy = nil--欢乐
img_common = nil--普通
img_mianfei  = nil--免费
img_tianti = nil--天梯
--end
btn_message = nil--消息(站内信)
btn_shop = nil--商城
btn_gift = nil--兑奖(礼包)
btn_rankinglist = nil --排行榜
btn_chat = nil--聊天按钮
--text_chat = nil--聊天内容
panel_menubg = nil
panel_chat = nil
btn_setting = nil--更多(设置)
btnUITable = {};--大厅button的UI
btnArmaFucTable = {};--按钮骨骼动画的方法
--changeButtonDataTable = {};--更改的大厅按钮数据 table
isPanelHallAnimationPlay = false;--panel_hall动画是否正在进行
isPanelTopAnimationPlay = false;--panel_top动画是否正在进行
hasChangeBtnStatusData = false;--是否有新的button数据(按钮状态是否需要改变)
hasChangeCaiShenData = {};--是否有新的财神数据
isUnlockAnimationPlay = false; --解锁动画是否正在进行
hasGiftShowDataChange = false; --是否有礼包消息需要更新
isNewUserGuideArrowShow = false;--新手引导箭头是否存在(完成新手引导后有提示指向"快速开始"的箭头)
img_menutanhao = nil --menu上的叹号
hallUnlockTimeTable = {};--大厅解锁的时间集

freeCoinAwardTips = nil; --免费金币领奖提示
btn_hall_shouchong = nil  --首冲
--ImageView_faguang = nil; --发光图片
ImageVie_Arrow = nil; --提示箭头
labelNotice = nil;--系统公告
local MatchID = nil  --比赛ID
local MatchTitle = nil  --比赛标题
local ARROW_X = 730;--箭头的X轴
local MiniGame_TanKuang = true
--公共数据
local isMenuShow = 0--按钮是否显示，0不显示1显示，默认不显示
size = nil
local scaleNum = 1.2 -- 按钮放大倍数
local lookTimer = nil --时间计时器
local IS_NOT_VIP = 0;--不是VIP
local TAG_TAN_HAO = 11;--叹号tag
local TAG_LABEL_NOTICE = 12;--公告label的tag
local TAG_ARROW = 21;--箭头的tag
local TAG_LIGHT_BG = 22;--发光背景
--ZOrder
local ZOrderLow = 1
local ZOrderHigh = 2

--panel_chat 数据
local chatPanelSize = nil; --panel 大小
local chatPanelPoint = nil; --panel 位置
local NOTICE_MOVE_TIME = 0.02;--公告移动的时间
local CHAT_PANEL_WIDTH_MULTIPLE = 2.8;--panel_chat宽的倍数
local ONE_WORD_WIDTH =10;--一个字的宽

--全局变量
local MODE_HALL = 0 --大厅模式
local MODE_ROOMLIST = 1 --休闲房间列表模式
local MODE_MATCHLIST = 2 --比赛列表模式
local MODE_MINIGAME = 3 --mini小游戏模式
local matchTypeClick = 0 --点击的比赛模式
local MiniGame_Duijiang = 0
local theCurrentItemID = -1;--当前显示的比赛标签(为了比赛列表同步时不会播放动画)

--房间模式
local ROOM_ITEM_ROOMLAIZI = 0 --癞子房间
local ROOM_ITEM_ROOMHAPPY = 1 --欢乐房间
local ROOM_ITEM_ROOMCOMMON = 2 --普通房间
local ID_FRUIT_MACHINE = 102;--老虎机GameID
local ID_JIN_HUANG_GUAN = 103;--金皇冠GameID
local ID_WAN_REN_JIN_HUA = 104;--万人金花GameID
local ID_WAN_REN_FRUIT_MACHINE = 105;--万人水果派
local ID_JIN_HUA = 106;--扎金花
--房间列表部分
local RoomTable = {}
RoomTable["rooms"] = {}
RoomTable["getUpdataRoomCnt"] = -1
roomItemList = {}
RoomJiangbeiTable = {}
RoomTableJz = {}--激战人数

--站内信
MessageTable = {}

is_first_join_room = true

--财神倒计时
caishenDaojishi = 0
GanTanHao = nil
LabelAtlas_DaoJiShi = nil--财神倒计时控件

--当前门票数量
local menpiaoNum = 0
--打开比赛
local isOpenSelectMatchInfo = 0
local openMatchName = ""
--scroll判断是否到最左或者最右
--ImageView_leftshade = nil
--ImageView_rightshade = nil
img_menubg = nil
--字的按上和按下效果
zi_common = nil
zi_huanle= nil
zi_laizi = nil
zi_mfyj = nil
zi_ttzq = nil

--活动图片地址
local oprationalPhotoPath = nil

timeIndex = 0--定时器时间针

--bIsChangingHallView = false; -- 当前是否在切换大厅界面
local isLastLayer = false;--牌桌是不是上一个界面
local isHaveCertificate = false; --界面是否有奖状
--按钮ID table
--local buttonIDTable = {};
local function callJavaMethodFunction(null)
	Common.AndroidExitSendOnlineTime()
end
function onKeypad(event)
	if event == "backClicked" then
		if GameConfig.getHallShowMode() ~= MODE_HALL then
			changeHallView(MODE_HALL)

			GotoHallAnimation()
		else
--			mvcEngine.createModule(GUI_ANDROID_EXIT);
			if CommShareConfig.isOpenRedGiftShare() == true and CommShareConfig.isRedGiftShareFirst() == true and CommShareConfig.isExitEnabled == false then
			CommShareConfig.selectRedGiftShareType()
			CommShareConfig.isExitEnabled = true
		else
			local javaClassName = "com.tongqu.client.lord.BaiDuBaseActivity"
			local javaMethodName = "baiDuExitGame"
			local javaParams = {
				callJavaMethodFunction,
			}

			luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
		end
		end
	elseif event == "menuClicked" then
	end
end

local function initHallData()
	RoomTable["rooms"] = profile.RoomData.getRoomTable()
	RoomTable["getUpdataRoomCnt"] = profile.RoomData.getUpdataRoomCnt()
	MatchList.MatchTable["MatchList"] = profile.Match.getMatchTable()
end

function getMatchListMode()
	return MODE_MATCHLIST;
end

--更新个人头像
local function updataUserPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		local id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
	if (photoPath ~= nil and photoPath ~= "" and img_useravator ~= nil) then
		img_useravator:loadTexture(photoPath)
		--		img_useravator:setScale(88/img_useravator:getSize().height)
		--设置头像在SD卡的位置
		Common.setDataForSqlite(CommSqliteConfig.SelfAvatorInSD..profile.User.getSelfUserID(),photoPath)
	else

	end
end

local function updataRoomJiangbeiGooods(path)
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
	if photoPath ~= nil and photoPath ~= "" and RoomJiangbeiTable[""..id] ~= nil then
		RoomJiangbeiTable[""..id]:loadTexture(photoPath)
	end
end

-- 更新活动icon图标
local function updataOprationalBtn(path)
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
	if photoPath ~= nil and photoPath ~= "" and btn_hall_huodong ~= nil then
		oprationalPhotoPath = photoPath
		--		btn_hall_huodong:loadTextures(photoPath, photoPath, "")
	end
end

local function setUserIdForTestin()
	if Common.platform == Common.TargetAndroid then
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "setUserID"
		local javaParams = {
			profile.User.getSelfUserID(),
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	elseif Common.platform == Common.TargetIos then
		local javaParams = {
			userID = profile.User.getSelfUserID(),
		}
		local ok, ret = luaoc.callStaticMethod("AppController", "setTestingAgentWithUserID", javaParams);
	end
end

--[[--
--初始化大厅按钮实体
--]]
function initHallButtonEntity()
	--比赛赢奖实体(参数：控件、ID、是否有骨骼动画)
	local MatchGameEntity = HallButton:new(btn_matchgame, HallButtonConfig.BTN_ID_MATCH_GAME, true);
	MatchGameEntity:setDefaultPosition(HallButtonConfig.MID_FOUR_BTN_RIGHT_X, HallButtonConfig.MID_Y);
	MatchGameEntity:setStatus(HallButtonConfig.BUTTON_STATUS_GRAY);
	MatchGameEntity:setHallLocation(HallButtonConfig.HALL_LOCATION_MID);
	MatchGameEntity:setPanelLocation(HallButtonConfig.PANEL_LOCATION_RIGHT);
	MatchGameEntity:setDecorativeAnimation(GameArmature.showMatchGameBtnArmature, GameArmature.removeMatchGameBtnArmature);
	HallButtonManage.setButtonEntity(HallButtonConfig.BTN_ID_MATCH_GAME, MatchGameEntity);
	--休闲房间实体
	local LeisureGameEntity = HallButton:new(btn_leisuregame, HallButtonConfig.BTN_ID_LEISURE_GAME, true);
	LeisureGameEntity:setDefaultPosition(HallButtonConfig.MID_FOUR_BTN_CENTRE_LEFT_X, HallButtonConfig.MID_Y);
	LeisureGameEntity:setStatus(HallButtonConfig.BUTTON_STATUS_OPEN);
	LeisureGameEntity:setHallLocation(HallButtonConfig.HALL_LOCATION_MID);
	LeisureGameEntity:setPanelLocation(HallButtonConfig.PANEL_LOCATION_CENTRE_LEFT);
	LeisureGameEntity:setDecorativeAnimation(GameArmature.showLeisureGameBtnArmature, GameArmature.removeLeisureGameBtnArmature);
	HallButtonManage.setButtonEntity(HallButtonConfig.BTN_ID_LEISURE_GAME, LeisureGameEntity);
	--疯狂闯关实体
	local PkGameEntity = HallButton:new(btn_pk_game, HallButtonConfig.BTN_ID_PK_GAME, true);
	PkGameEntity:setDefaultPosition(HallButtonConfig.MID_FOUR_BTN_CENTRE_X, HallButtonConfig.MID_Y);
	PkGameEntity:setStatus(HallButtonConfig.BUTTON_STATUS_OPEN);
	PkGameEntity:setHallLocation(HallButtonConfig.HALL_LOCATION_MID);
	PkGameEntity:setPanelLocation(HallButtonConfig.PANEL_LOCATION_CENTRE_RIGHT);
	PkGameEntity:setDecorativeAnimation(GameArmature.showPkGameBtnArmature, GameArmature.removePkGameBtnArmature);
	HallButtonManage.setButtonEntity(HallButtonConfig.BTN_ID_PK_GAME, PkGameEntity);
	--幸运游戏实体
	local LuckyGameEntity = HallButton:new(btn_lucky_game, HallButtonConfig.BTN_ID_LUCKY_GAME, true);
	LuckyGameEntity:setDefaultPosition(HallButtonConfig.MID_FOUR_BTN_CENTRE_RIGHT_X, HallButtonConfig.MID_Y);
	LuckyGameEntity:setStatus(HallButtonConfig.BUTTON_STATUS_OPEN);
	LuckyGameEntity:setHallLocation(HallButtonConfig.HALL_LOCATION_MID);
	LuckyGameEntity:setPanelLocation(HallButtonConfig.PANEL_LOCATION_CENTRE);
	LuckyGameEntity:setDecorativeAnimation(GameArmature.showLuckyGameBtnArmature, GameArmature.removeLuckyGameBtnArmature);
	HallButtonManage.setButtonEntity(HallButtonConfig.BTN_ID_LUCKY_GAME, LuckyGameEntity);
	--活动实体
	local ActivityEntity = HallButton:new(btn_hall_huodong, HallButtonConfig.BTN_ID_ACTIVITY, false);
	ActivityEntity:setDefaultPosition(HallButtonConfig.ACTIVITY_X, HallButtonConfig.TOP_Y);
	ActivityEntity:setStatus(HallButtonConfig.BUTTON_STATUS_OPEN);
	ActivityEntity:setHallLocation(HallButtonConfig.HALL_LOCATION_TOP);
	ActivityEntity:setPanelLocation(HallButtonConfig.PANEL_LOCATION_CENTRE_LEFT);
	HallButtonManage.setButtonEntity(HallButtonConfig.BTN_ID_ACTIVITY, ActivityEntity);
	--财神实体
	local CaiShenEntity = HallButton:new(btn_caishen, HallButtonConfig.BTN_ID_CAI_SHEN, true);
	CaiShenEntity:setDefaultPosition(HallButtonConfig.CAI_SHEN_X, HallButtonConfig.TOP_Y);
	CaiShenEntity:setStatus(HallButtonConfig.BUTTON_STATUS_GRAY);
	CaiShenEntity:setHallLocation(HallButtonConfig.HALL_LOCATION_TOP);
	--CaiShenEntity:setDecorativeAnimation(GameArmature.showCaiShenBtnArmature, GameArmature.removeCaishenBtnArmature);
	HallButtonManage.setButtonEntity(HallButtonConfig.BTN_ID_CAI_SHEN, CaiShenEntity);
	--充值实体
	local RechargeEntity = HallButton:new(btn_chongzhi, HallButtonConfig.BTN_ID_RECHARGE, false);
	RechargeEntity:setDefaultPosition(HallButtonConfig.RECHARGE_X, HallButtonConfig.TOP_Y);
	RechargeEntity:setStatus(HallButtonConfig.BUTTON_STATUS_OPEN);
	RechargeEntity:setHallLocation(HallButtonConfig.HALL_LOCATION_TOP);
	RechargeEntity:setPanelLocation(HallButtonConfig.PANEL_LOCATION_CENTRE);
	HallButtonManage.setButtonEntity(HallButtonConfig.BTN_ID_RECHARGE, RechargeEntity);
	--免费金币实体
	local FreeCoinEntity = HallButton:new(btn_FreeCoin, HallButtonConfig.BTN_ID_FREE_COIN, false);
	FreeCoinEntity:setDefaultPosition(HallButtonConfig.FREE_COIN_X, HallButtonConfig.TOP_Y);
	FreeCoinEntity:setStatus(HallButtonConfig.BUTTON_STATUS_OPEN);
	FreeCoinEntity:setHallLocation(HallButtonConfig.HALL_LOCATION_TOP);
	FreeCoinEntity:setPanelLocation(HallButtonConfig.PANEL_LOCATION_LEFT);
	HallButtonManage.setButtonEntity(HallButtonConfig.BTN_ID_FREE_COIN, FreeCoinEntity);
	--聊天实体
	local ChatEntity = HallButton:new(btn_chat, HallButtonConfig.BTN_ID_CHAT, false);
	ChatEntity:setDefaultPosition(HallButtonConfig.MID_FOUR_BTN_LEFT_X, HallButtonConfig.CHAT_Y);
	ChatEntity:setStatus(HallButtonConfig.BUTTON_STATUS_OPEN);
	ChatEntity:setHallLocation(HallButtonConfig.HALL_LOCATION_MID);
	ChatEntity:setPanelLocation(HallButtonConfig.PANEL_LOCATION_LEFT);
	HallButtonManage.setButtonEntity(HallButtonConfig.BTN_ID_CHAT, ChatEntity);
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_HALL;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("Hall.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("Hall.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("Hall_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

--[[--
--大厅生成界面
]]
function createView()
	--初始化当前界面
	initLayer();
	HallButtonConfig.setButtonPositionValue();
	view:setTag(getDiffTag())
	GameConfig.setTheCurrentBaseLayer(GUI_HALL)
	--全局变量
	size = CCDirector:sharedDirector():getWinSize()

	--检测客户端安装的应用
	LordGamePub.detectClientInstalledApp();

	ResumeSocket("Hall");

	initView()

	--createAlarm()
	--发送显示红点消息
	GameStartConfig.addChildForScene(view)

	-- 同步比赛列表数据
	sendMATID_V4_MATCH_SYNC()
	--加载首页动画
	GameArmature.loadHallArmature()
	--加载牌桌动画
	GameArmature.loadTableArmature()
	--新手引导开关请求
	sendCOMMONS_GET_NEWUSERGUIDE_IS_OPEN()
	--请求大厅中奖信息
	if Common.getDataForSqlite("MINI_COMMON_WINNING_RECORD") ~= nil then
		sendMINI_COMMON_WINNING_RECORD(Common.getDataForSqlite("MINI_COMMON_WINNING_RECORD"))
	else
		sendMINI_COMMON_WINNING_RECORD(0)
	end

	--更新用户信息
	updataUserInfo()

	setUserIdForTestin();

	if GameConfig.mnIsFirstInHall == true then
		GameConfig.mnIsFirstInHall = false
	else
		if oprationalPhotoPath ~= nil and oprationalPhotoPath ~= "" then
		--btn_hall_huodong:loadTextures(oprationalPhotoPath, oprationalPhotoPath, "")
		end
	end

	if (profile.User.getSelfUserID() ~= 0) then
		sendDBID_USER_INFO(profile.User.getSelfUserID());
	end
	--发送全局消息
	sendGameCommonMessage();
	--发送红点消息
	sendMANAGERID_REQUEST_REDP(HongDianLogic.getMANAGERID_REQUEST_REDP_HongDian_Table())
	--更新消息
	slot_GetMessageList()
	sendBASEID_TIMESTAMP_SYNC();
	--站内信
	sendDBID_V2_GET_CONVERSATION_LIST(0,10);
	--AudioManager.loadTableEffect()
	AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.HALL_BACKGROUND)
	--弹出绑定手机界面
	showBindPhoneLayer()
end

function showBindPhoneLayer()
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(3))
	array:addObject(CCCallFuncN:create(
		function ()
			--绑定手机界面
			BindPhoneConfig.showBindPhoneCommonLayer()
		end
	))
	local seq = CCSequence:create(array);
	view:runAction(seq);
end
--[[--
--发送不同平台的支付列表/版本更新消息
--]]
local function sendPlatformMessage()
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		-- iOS平台
		local PayData = {
			profile.PayChannelData.ALI_PAY, -- 支付宝
			profile.PayChannelData.WEIXIN_PAY, -- 微信
			profile.PayChannelData.SMS_ONLINE, --移动短代
			profile.PayChannelData.HUAJIAN_DIANXIN_PAY, --电信短代
			profile.PayChannelData.RECHARGE_91 ,  -- 91
			profile.PayChannelData.IAP_PAY ,   -- iap支付
			profile.PayChannelData.HAIMA_PAY ,--海马IOS
			profile.PayChannelData.HUAJIAN_LIANTONG_PAY --联通短代
		}
		sendPAYMENT_DATA_LIST(PayData) --发送支付列表请求

		-- 获取token
		Common.sendIOSDeviceToken();
		if GameConfig.PaymentForIphone == GameConfig.PAYMENT_SMS then
		--短代
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_IAP then
		--iap
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_91 then
		--91
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_HAIMA then
			--海马IOS版本检测
			Common.upDataGameVersionForIOS(GameConfig.mnIOSForce, GameConfig.mnIOSTest);
		end

	elseif Common.platform == Common.TargetAndroid then
		--android平台
		local PayData = {
			profile.PayChannelData.ALI_PAY, -- 支付宝
			profile.PayChannelData.WEIXIN_PAY, -- 微信
			profile.PayChannelData.SMS_UNICOM ,-- 联通沃商店
			profile.PayChannelData.RECHARGE_CARD_PAY ,-- 充值卡
			profile.PayChannelData.NEW_UNION_PAY, --新银联支付
			profile.PayChannelData.SMS_ONLINE, --移动短代
			profile.PayChannelData.HUAJIAN_DIANXIN_PAY, --电信短代
			profile.PayChannelData.HUAJIAN_LIANTONG_PAY, --联通短代
			profile.PayChannelData.EPAY, --宜支付短代
			profile.PayChannelData.YINBEIKEPAY_CMCC, --银贝壳移动
			profile.PayChannelData.YINBEIKEPAY_UNI, --银贝壳联通
			profile.PayChannelData.YINBEIKEPAY_CT,--银贝壳电信
			profile.PayChannelData.HONGRUAN_SDK_CMCC, --红软移动
			profile.PayChannelData.HONGRUAN_SDK_UNICOM, --红软联通
			profile.PayChannelData.HONGRUAN_SDK_CT, --红软电信
			profile.PayChannelData.RECHARGE_WOJIA, --同趣联通wo+
		}
		sendPAYMENT_DATA_LIST(PayData) --发送支付列表请求
		sendBASEID_PLAT_VERSION() --发送版本检测消息
	end
end

--[[--
--判断首页公共消息是否过期
--]]
function logicSendCommonMsgTime()
	local timeStamp = Common.getDataForSqlite(CommSqliteConfig.SendCommonMsgTimeStamp..profile.User.getSelfUserID());
	if timeStamp == nil or timeStamp == "" then
		timeStamp = 0;
	else
		timeStamp = tonumber(timeStamp);
	end
	local nowStamp = Common.getServerTime();
	if (nowStamp - timeStamp) / (3600 * 6) > 1 then
		GameConfig.mnHallInitSendMsg = false;
		GameConfig.isCheckScript = false;
		HallLogic.sendCommonMessageForTime();
	end
end

--[[--
--定时请求公共消息
--]]
function sendCommonMessageForTime()

	if GameConfig.mnHallInitSendMsg == false then
		GameConfig.mnHallInitSendMsg = true;

		CommDialogConfig.setExitDialogCallBack();

		Common.setDataForSqlite(CommSqliteConfig.SendCommonMsgTimeStamp..profile.User.getSelfUserID(), Common.getServerTime());
		--发送转盘信息
		sendTurnTableMessage();

		--发送系统公告消息
		sendMANAGERID_GET_SYSTEM_LIST_NOTICE();

		if profile.User.getSelfUserID() ~= nil then
			sendDBID_USER_PHONE_MSG(profile.User.getSelfUserID());
			local operator = Common.getOperater()
			if operator ~= 0 then
				if Common.getOperater() == Common.CHINA_MOBILE then
					--移动支付方式
					sendMANAGERID_MOBILE_PAYMENT_MODE();
				elseif Common.getOperater() == Common.CHINA_UNICOM then
					--联通支付方式
					sendMANAGERID_CU_PAYMENT_MODE();
				elseif Common.getOperater() == Common.CHINA_TELECOM then
					--电信支付方式
					sendMANAGERID_CT_PAYMENT_MODE();
				end
			end
		end

		--加载本地比赛列表
		profile.Match.loadMatchListTable()
		profile.Match.loadRegConditions()

		sendMANAGERID_VIP_LIST_V3(profile.VIPData.getTimestamp())--vip消息

		sendDBID_BACKPACK_LIST();--背包

		sendPlatformMessage();

		profile.Version.setUserInitiative(false);

		--是否绑定手机运营商
		sendDBID_GET_SMS_NUMBER()--手机绑定消息

		--房间列表
		sendROOMID_ROOM_LIST_NEW(profile.RoomData.getTimestamp())

		--比赛列表
		--sendMATID_MATCH_LIST_NEW(profile.Match.getTimestamp())

		-- 3.03 比赛列表
		sendMATID_V4_MATCH_LIST(0)
		--profile.Match.setMatchTable_V4()
		--是否有新礼包
		sendGIFTBAGID_NEWGIFT_TYPE(0)
		--获取通用配置
		sendDBID_GET_SERVER_CONFIG(ServerConfig.maMessage);
		if profile.NewUserGuide.getisNewUserGuideisEnable() == false then
			sendCOMMONS_SYN_NEWUSERGUIDE_STATE()
		end
		--缓存消息
		sendCacheInfo();

		--初始化图片
		sendMANAGERID_GET_INIT_PIC(profile.InitImageList.getInitImageListTimestamp());
	--请求推送消息
	--SaveLastDay()
	--sendNOTIFICATION_PUSH_LIST_V2()
	end
	--检测脚本升级
	CommDialogConfig.checkScriptVersion();
end

--[[--
--发送游戏公共消息
]]
function sendGameCommonMessage()
	--按钮状态列表消息
	sendMANAGERID_GET_BUTTONS_STATUS();

	--获取VIP状态
	sendMANAGERID_VIPV2_TIP_INFO()
	--发送有关IOS的“邀请奖励”是否能看见的消息
	sendMsgAboutIOSDisplayBtnInvite();

	--定时发送的公共消息
	sendCommonMessageForTime();

	--是否有新礼包
	sendGIFTBAGID_NEWGIFT_TYPE(0);

	--剩余门票
	sendMANAGERID_GET_UNUSED_TICKET_CNT();

	-- 3.03 发送比赛同步消息
	Common.log("sendGameCommonMessage sendMATID_V4_MATCH_SYNC")
	sendMATID_V4_MATCH_SYNC();

	--定时器，更新时间
	lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(setCurrentTime, 3 ,false);

	--初始化比赛时钟
	MatchList.initMatchColock()
	GamePauseResumeListener.addListener()
	--发送退出弹框消息
	sendQuitGuideMsg();
end

--[[--
--发送退出弹框消息
--]]
function sendQuitGuideMsg()
	if profile.AndroidExit.isDetectedAppInstalledComplete() then
		--如果已经检测完应用的安装情况, 则发送退出弹框消息
		sendMANAGERID_QUIT_GUIDE(profile.AndroidExit.getClientInstalledGameIDList());
	end
end

--[[--
--发送有关IOS的“邀请奖励”是否能看见的消息
--]]
function sendMsgAboutIOSDisplayBtnInvite()
	if Common.platform == Common.TargetIos then
		--目前只有ios平台发送 分享V2 IOS是否可以填写好友ID
		sendOPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND();
	end
end

--[[
--panel_top动画后的回调方法
--]]
local function showPanelTopCallBack()
	--panel_top动画停止
	isPanelTopAnimationPlay =  false;

	--显示VIP续费Icon
	showVipStatusIcon();

	--没有财神数据更新
	if hasChangeCaiShenData == nil or #hasChangeCaiShenData == 0 then
		return;
	end

	--财神有改变的数据
	for i = 1, #hasChangeCaiShenData do
		hasChangeCaiShenData[i]();
	end
end

--[[--
--panel_top动画
--]]
local function showPanelTopAnimation()
	do return end
	--panel_top 动画正在播
	isPanelTopAnimationPlay = true;
	panel_top:stopAllActions();
	panel_top:setPosition(ccp(0,GameConfig.ScreenHeight))
	local moveTo = CCMoveTo:create(0.6,ccp(0,GameConfig.ScreenHeight - panel_top:getContentSize().height));
	local array = CCArray:create();
	array:addObject(moveTo);
	array:addObject(CCCallFuncN:create(showPanelTopCallBack));
	local seq = CCSequence:create(array);
	panel_top:runAction(seq)
end

--[[--
--panel_end动画
--]]
local function showPanelEndAnimation()
	panel_end:stopAllActions();
	panel_end:setPosition(ccp(0,- panel_end:getContentSize().height))
	panel_end:runAction(CCMoveTo:create(0.6,ccp(0,0)))
end

--[[--
--panel_hall 动画
--]]
local function showPanelHallAnimation()
	isPanelHallAnimationPlay = true --panel_hall动画正在播

	local panelHallView = HallButtonManage.getShowButtonUIOnMiddle();

	local function callbackShowBtn(index)
		if panelHallView[index] ~= nil then
			panelHallView[index]:setVisible(true);
		end
	end

	local function callbackShowBtnEnd()
		--此处的stopAllActions是为了让大厅的闯关按钮的变为半透明
		if panelHallView[#panelHallView] ~= nil and HallButtonManage.isHallButtonTranslucent(HallButtonManage.getShowButtonIDWithUIOnMiddle(panelHallView[#panelHallView])) then
			--判断该按钮存在且为半透明
			panelHallView[#panelHallView]:stopAllActions();
		end
		--panel_hall动画播放结束
		isPanelHallAnimationPlay = false;
		--大厅动画结束回调
		hallAnimationEndCallBack();
	end

	LordGamePub.showLandscapeList(panelHallView, callbackShowBtn, callbackShowBtnEnd);
end

--[[--
--快速开始动画
--]]
local function btnQuickStartAnimation()
	local function showQuickStartBtn()
		if btn_quickstart ~= nil then
			btn_quickstart:setVisible(true);
		end
	end

	btn_quickstart:setVisible(false);
	local fadeIn = CCFadeIn:create(0.2);
	local array = CCArray:create();
	array:addObject(fadeIn);
	array:addObject(CCCallFuncN:create(showQuickStartBtn));
	local seq = CCSequence:create(array);
	btn_quickstart:runAction(seq);
end

--[[--
--进入大厅动画
--]]
function enterHallAnimation()
	--显示panel_top动画
	showPanelTopAnimation();
	--显示panel_end动画
	showPanelEndAnimation();
	--显示panel_hall动画
	--showPanelHallAnimation();

	--首次进入大厅的动画
	FirstJoinHallAnimation()

	--显示快速开始动画
	--	btnQuickStartAnimation();

	--joinHallAnimation()
end

function caishenTimeSynchronization()
	if LabelAtlas_DaoJiShi ~= nil then
		if LabelAtlas_DaoJiShi:numberOfRunningActions() > 0 then
			return;
		end
		local delay = CCDelayTime:create(1);
		local array = CCArray:create();
		array:addObject(delay);
		array:addObject(CCCallFuncN:create(setTime));
		local seq = CCSequence:create(array);
		LabelAtlas_DaoJiShi:runAction(CCRepeatForever:create(seq));
		if caishenDaojishi > 0 then
			setTime();
		end
	end
end

function sendExchangeMsg()
	if not CommDialogConfig.getNewUserGiudeFinish() then
		--现金奖品列表
		sendOPERID_GET_CASH_AWARD_LIST();
		--碎片兑换
		sendMANAGERID_GET_PRESENTS(profile.Prize.getPrizeListTimestamp());
	--	--奖品兑换
	--	sendMANAGERID_GET_PIECES_SHOP_LIST(profile.SuipianPrize.getPrizeSuipianListTimestamp());
	--	--获取可兑换奖品列表
	--	sendMANAGERID_GET_EXCHANGBLE_AWARDS();
	--	--我的奖品  2信息
	--	sendNEW_GET_PRIZE_LIST(0,30); --充值卡
	--	sendMANAGERID_GET_EXCHANGE_AWARDS(); --兑换的奖品
	--	sendOPERID_GET_CASH_PRIZE_LIST(profile.CashPrize.getCashPrizeTimestamp()); --我的奖品中现金奖品
	end
end

--缓存其他页面信息
function sendCacheInfo()
	local dataTable = {}
	dataTable["gameID"] = GameConfig.GAME_ID
	--sendOPERID_GET_OPER_TASK_LIST(dataTable)
	--商城
	sendDBID_MALL_GOODS_LIST(profile.Shop.getGoodsListTimestamp())
	--礼包
	sendGIFTBAGID_GIFTBAG_LIST()
	--兑换
	sendDBID_EXCHANGE_LIST()
	--现金奖品列表
	sendOPERID_GET_CASH_AWARD_LIST()
end


--判断是否显示礼包
function isShowCountDownGiftPackage()
	if GameConfig.getHallShowMode() == MODE_HALL and profile.Gift.isShowFirstGiftIcon() then
		Common.setButtonVisible(btn_hall_shouchong, true)
	else
		Common.setButtonVisible(btn_hall_shouchong, false)
	end
end

--[[--
--初始化按钮数据
--]]
local function initButtonData()
	profile.ButtonsStatus.loadClientButtonData();
	--初始化大厅按钮实体
	initHallButtonEntity();
	--更新按钮数据
	HallButtonManage.updateButtonEntityData();
	--更新按钮属性(状态、位置)
	HallButtonManage.updateButtonProperty();
end

function initView()
	--top
	img_useravator = cocostudio.getUIImageView(view, "img_useravator")
	img_useravatorbg = cocostudio.getUIImageView(view, "img_useravatorbg")
	img_userinfo = cocostudio.getUIImageView(view, "img_userinfo")
	ImageView_vip = cocostudio.getUIImageView(view, "ImageView_vip");
	maskImageView = cocostudio.getUIImageView(view, "maskImageView");
	LabelAtlas_viplevel = cocostudio.getUILabelAtlas(view, "LabelAtlas_viplevel");
	btn_VIPkaitong = cocostudio.getUIButton(view, "btn_VIPkaitong");
	btn_VIPkaitong:setVisible(false)
	lab_nickname = cocostudio.getUILabel(view, "lab_nickname");
	lab_nickname:setVisible(false)
	Image_NickNameBg = cocostudio.getUIImageView(view, "Image_NickNameBg");
	Image_NickNameBg:setVisible(false);
	--btn_useravator = cocostudio.getUIButton(view, "btn_useravator")
	lab_coin = cocostudio.getUILabel(view, "lab_coin")
	lab_YuanBao = cocostudio.getUILabel(view, "lab_YuanBao");
	btn_YuanBao = cocostudio.getUIButton(view, "btn_YuanBao");

	btn_lucky_game = cocostudio.getUIButton(view, "btn_lucky_game")
	--	btn_task = cocostudio.getUIButton(view, "btn_task")
	btn_caishen = cocostudio.getUIButton(view, "btn_caishen")
	btn_chongzhi = cocostudio.getUIButton(view, "btn_chongzhi")
	btn_FreeCoin = cocostudio.getUIButton(view, "btn_FreeCoin");

	btn_back = cocostudio.getUIButton(view, "btn_back")
	lab_time = cocostudio.getUILabel(view, "lab_time")
	--	lab_time:setColor(ccc3(118, 118, 118))
	lab_time:setZOrder(5)
	panel_hall = cocostudio.getUIPanel(view, "panel_hall")
	panel_top = cocostudio.getUIPanel(view, "panel_top")
	panel_end = cocostudio.getUIPanel(view, "panel_end")
	panel_room = cocostudio.getUIPanel(view, "panel_room")
	panel_match = cocostudio.getUIPanel(view, "panel_match")
	--img_topbg = cocostudio.getUIImageView(view, "--img_topbg")

	--mid
	btn_matchgame = cocostudio.getUIButton(view, "btn_matchgame")
	btn_leisuregame = cocostudio.getUIButton(view, "btn_leisuregame")
	btn_hall_huodong = cocostudio.getUIButton(view, "btn_hall_huodong")
	btn_pk_game = cocostudio.getUIButton(view, "btn_pk_game");
	--	text_chat = cocostudio.getUILabel(view, "text_chat");
	btn_quickstart = cocostudio.getUIButton(view, "btn_quickstart")
	scroll_roomlist = cocostudio.getUIScrollView(view, "scroll_roomlist") --房间列表
	scroll_matchlist = cocostudio.getUIScrollView(view, "scroll_matchlist") --比赛列表
	--mid按钮
	img_laizi = cocostudio.getUIImageView(view, "img_laizi")
	img_happy = cocostudio.getUIImageView(view, "img_happy")
	img_common = cocostudio.getUIImageView(view, "img_common")
	img_mianfei = cocostudio.getUIImageView(view, "img_mianfei")
	img_tianti = cocostudio.getUIImageView(view, "img_tianti")

	--end
	btn_message = cocostudio.getUIButton(view, "btn_message")
	btn_shop = cocostudio.getUIButton(view, "btn_shop")
	btn_gift = cocostudio.getUIButton(view, "btn_gift")
	btn_rankinglist = cocostudio.getUIButton(view, "btn_rankinglist")
	btn_chat = cocostudio.getUIButton(view, "btn_chat")
	--	text_chat =  cocostudio.getUILabel(view, "text_chat")
	panel_menubg = cocostudio.getUIPanel(view, "panel_menubg")
	panel_chat = cocostudio.getUIPanel(view, "panel_chat")
	chatPanelSize = panel_chat:getContentSize();
	chatPanelPoint = panel_chat:getPosition();
	--	textChatPoint = text_chat:getPosition();

	btn_setting = cocostudio.getUIButton(view, "btn_setting")
	--首冲礼包
	btn_hall_shouchong = cocostudio.getUIButton(view, "btn_hall_shouchong")--礼包
	--ImageView_faguang = cocostudio.getUIImageView(view, "--ImageView_faguang")--发光图片
	Common.setButtonVisible(btn_hall_shouchong, false)
	--Imagefaguang()--发光图片显示

	--scroll滚动
	--ImageView_leftshade = cocostudio.getUIImageView(view, "--ImageView_leftshade")
	--ImageView_rightshade = cocostudio.getUIImageView(view, "--ImageView_rightshade")
	img_menubg = cocostudio.getUIImageView(view, "img_menubg")
	zi_common =  cocostudio.getUIImageView(view, "zi_common")
	zi_huanle=  cocostudio.getUIImageView(view, "zi_huanle")
	zi_laizi =  cocostudio.getUIImageView(view, "zi_laizi")
	zi_mfyj =  cocostudio.getUIImageView(view, "zi_mfyj")
	zi_ttzq =  cocostudio.getUIImageView(view, "zi_ttzq")

	--财神倒计时
	LabelAtlas_DaoJiShi = UILabelAtlas:create()
	LabelAtlas_DaoJiShi:setProperty("00:00",Common.getResourcePath("num_caishen_time2.png"), 20, 25,"0")
	LabelAtlas_DaoJiShi:setScale(0.8)
	LabelAtlas_DaoJiShi:setAnchorPoint(ccp(0.5,-1.1))
	btn_caishen:addChild(LabelAtlas_DaoJiShi)
	LabelAtlas_DaoJiShi:setVisible(false)

	--添加跳动的小叹号
	GanTanHao = CCSprite:create(Common.getResourcePath("gift_tan_hao.png"))
	GanTanHao:setScale(1000/1136)
	GanTanHao:setAnchorPoint(ccp(0,-0.5))
	GanTanHao:setZOrder(10);
	GanTanHao:setPosition(btn_caishen:getParent():convertToWorldSpace(btn_caishen:getPosition()))
	view:addChild(GanTanHao)
	GanTanHao:setVisible(false)

	--初始化大厅数据
	initButtonData();
	--设置时间
	setCurrentTime()

	initHallData();

	changeHallView(GameConfig.getHallShowMode(), GameConfig.getHallRoomItem())
	--初始化变量
	isMenuShow = 0
	--panel_chat:runAction(CCMoveBy:create(0.25,ccp(0,-200)))
	--btn_quickstart:runAction(CCMoveBy:create(0.25,ccp(0,-400)))
	--	hideMenuBar()
	--加载头像
	local useravatorIdSD = Common.getDataForSqlite(CommSqliteConfig.SelfAvatorInSD..profile.User.getSelfUserID())
	if useravatorIdSD ~= "" and useravatorIdSD ~= nil then
		img_useravator:loadTexture(useravatorIdSD)
		--img_useravator:setScale(88/img_useravator:getSize().height)
	end
end

--发光旋转图片
function Imagefaguang()
--ImageView_faguang:runAction(CCRepeatForever:create(CCRotateBy:create(5,360)));
end

--[[--
--显示房间列表
--]]
local function showRoomList(itemID)
	--加载房间列表
	--table     0标准 1欢乐玩法 2癞子玩法
	--itemID    0癞子 1  欢乐 2  普通
	local cellSize = 0
	if RoomTable["rooms"]~= nil then
		cellSize = #RoomTable["rooms"]
	end
	if(cellSize == 0 )then
		Common.showProgressDialog("数据加载中,请稍后...")
		return;
	end

	scroll_roomlist:removeAllChildren();
	RoomJiangbeiTable = {};

	local showrooms = {}

	local roomlength = 0

	for x = 1, cellSize do
		--普通
		if itemID == ROOM_ITEM_ROOMCOMMON and RoomTable["rooms"][x].TableType == 0 then
			roomlength = roomlength + 1
			showrooms[roomlength] = {}
			showrooms[roomlength] = RoomTable["rooms"][x]
			--欢乐
		elseif itemID == ROOM_ITEM_ROOMHAPPY and RoomTable["rooms"][x].TableType == 1 then
			roomlength = roomlength + 1
			showrooms[roomlength] = {}
			showrooms[roomlength] = RoomTable["rooms"][x]
			--癞子
		elseif itemID == ROOM_ITEM_ROOMLAIZI and RoomTable["rooms"][x].TableType == 2 then
			roomlength = roomlength + 1
			showrooms[roomlength] = {}
			showrooms[roomlength] = RoomTable["rooms"][x]
		end
	end

	local viewW = 0
	local viewH = 380;
	local viewX = 25
	local viewY = 70;
	local viewWMax = 1044;
	local cellWidth = 261; --每个元素的宽
	local cellHeight = 360; --每个元素的高
	local hangSize = 1
	local lieSize = roomlength
	local spacingW = 8; --横向间隔
	local spacingH = 0 --纵向间隔

	if lieSize * cellWidth + spacingW * (lieSize - 1) <= viewWMax then
		viewW = viewWMax
	else
		viewW = lieSize * cellWidth + spacingW * (lieSize - 1)
	end

	scroll_roomlist:setSize(CCSizeMake(viewW, viewH))
	scroll_roomlist:setInnerContainerSize(CCSizeMake(viewW  + 1, viewH))
	scroll_roomlist:setPosition(ccp(viewX, viewY))
	--适配需要：对列表进行缩放横坐标和纵坐标的缩放
	scroll_roomlist:setScaleX(GameConfig.ScaleAbscissa);
	scroll_roomlist:setScaleY(GameConfig.ScaleOrdinate);

	RoomTableJz = {};
	roomItemList = {};
	for i = 0, roomlength - 1 do
		local RoomID = showrooms[i+1].RoomID
		local RoomName = showrooms[i+1].RoomName
		local TableFee = showrooms[i+1].TableFee --桌费
		local RegCoin = tonumber(showrooms[i+1].RegCoin)
		local RegMaxCoin = tonumber(showrooms[i+1].RegMaxCoin)
		local TableType = showrooms[i+1].TableType --0标准 1欢乐玩法 2癞子玩法
		local playerCnt = showrooms[i+1].playerCnt --激战人数RegUserCnt
		local TitleUrl = showrooms[i+1].TitleUrl --TitleUrl
		local prizeUrl = showrooms[i+1].prizeUrl --prizeUrl
		local EntryConditions =  showrooms[i+1].EntryConditions

		--房间顶部背景
		local imgbg = "bg_fangjian.png"
		--状态
		local layout = ccs.image({
			scale9 = true,
			image = Common.getResourcePath(imgbg),
			size = CCSizeMake(cellWidth, cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		layout:setScale9Enabled(true);
		layout:setAnchorPoint(ccp(0.5, 0.5));

		local button = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			text = "",
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = {
				[ccs.TouchEventType.began] = function(uiwidget)
					layout:setScale(1.05)
				end,
				[ccs.TouchEventType.moved] = function(uiwidget)
				end,
				[ccs.TouchEventType.ended] = function(uiwidget)
					layout:setScale(1)
					local selfcoinnum = tonumber(profile.User.getSelfCoin())
					if  (tonumber(RegMaxCoin) >= selfcoinnum) and  (tonumber(RegCoin) <= selfcoinnum) then
						--金币正合适，进入房间
						Common.showProgressDialog("进入房间中,请稍后...")
						sendEnterRoom(RoomID)
					else
						--大于最大，进入高倍房间，
						--小于最小，弹出破产送金
						--自己的金币，最小金币，最大金币
						RoomGuide.GuideRoomType(selfcoinnum, RegCoin, RegMaxCoin, showrooms, TableType, RoomID)
					end
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
					layout:setScale(1)
				end,
			}
		})

		local imgmidbg = "px1.png"--小人图改从服务器下载

		--		if RoomID == 1 or RoomID == 9 or RoomID == 13 then
		--			imgmidbg = "px1.png"
		--		elseif RoomID == 2 or RoomID == 10 or RoomID == 14 then
		--			imgmidbg = "bg_zhongji.png"
		--		elseif RoomID == 5 or RoomID == 11 or RoomID == 15 then
		--			imgmidbg = "bg_gaoji.png"
		--		else
		--			imgmidbg = "bg_haohua.png"
		--		end

		--房间名称以及人物图
		local roomJiangbei = ccs.image({
			scale9 = true,
			image = Common.getResourcePath(imgmidbg),
			size = CCSizeMake(202, 250),
		})
		roomJiangbei:setScaleX(cellWidth/252)

		--RoomTitleTable  RoomJiangbeiTable
		RoomJiangbeiTable[""..(i + 1)] = roomJiangbei;
		RoomJiangbeiTable[""..(i + 1)]:setVisible(false);
		if prizeUrl ~= nil or prizeUrl ~= "" then
			---- updataRoomJiangbeiGooods  updataRoomTitleGooods
			Common.getPicFile(prizeUrl, (i + 1), true, updataRoomJiangbeiGooods)
		end
		--每局消耗
		local textXiaohao = ccs.label({
			text = RoomName,
			size = CCSizeMake(cellWidth, 30),
			--			color = ccc3(228,78,63),
			color = ccc3(144,51,15),
		})
		textXiaohao:setTextAreaSize(CCSizeMake(cellWidth, 30))
		textXiaohao:setTextHorizontalAlignment(kCCTextAlignmentCenter)
		--激战人数背景
		--		local jzRenshuBg = ccs.button({
		--			scale9 = true,
		--			size = CCSizeMake(cellWidth-80, 40),
		--			pressed = Common.getResourcePath("bg_paihangbang_gonggao.png"),
		--			normal = Common.getResourcePath("bg_paihangbang_gonggao.png"),
		--			text = "",
		--		})
		--激战人数
		local textRen = ccs.label({
			text = "人激战中",
			size = CCSizeMake(cellWidth, 30),
			color = ccc3(249,235,219),
		})
		local textJizhan = ccs.label({
			text = playerCnt,
			size = CCSizeMake(cellWidth, 30),
			color = ccc3(249,235,219),
		})
		RoomTableJz[RoomID] = {}
		RoomTableJz[RoomID].RoomID = RoomID
		RoomTableJz[RoomID].RoomJzLabel = textJizhan

		local textJinbi = ccs.label({
			text = EntryConditions.."进场",
			size = CCSizeMake(cellWidth, 30),
			color = ccc3(93,60,35),
		})

		--左上角标
		local roomjbimgurl = ""
		local roomjbimage = nil
		local roomjbBg = nil;

		if itemID == ROOM_ITEM_ROOMLAIZI or itemID == ROOM_ITEM_ROOMHAPPY then
			if i == 0 then
				roomjbimgurl = "ui_room_label_baoxiangx1.png"
			elseif i == 1 then
				roomjbimgurl = "ui_room_label_baoxiangx2.png"
			elseif i == 2 then
				roomjbimgurl = "ui_room_label_baoxiangx5.png"
			else
				roomjbimgurl = "ui_room_label_baoxiangx10.png"
			end
			roomjbimage = ccs.image({
				scale9 = false,
				image = Common.getResourcePath(roomjbimgurl),
				size = CCSizeMake(98, 99),
			})
			roomjbBg = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("bg_hot.png"),
				size = CCSizeMake(98, 99),
			})
		end

		local tagimage = nil
		local TagUrl = nil
		--普通
		if TableType == 0 then
			TagUrl = nil
			--欢乐
		elseif TableType == 1 then
			TagUrl = "bg_huanle.png"
			--癞子
		elseif TableType == 2 then
			TagUrl = "bg_laizi.png"
		end

		if TagUrl ~= nil then
			tagimage = ccs.image({
				scale9 = false,
				image = Common.getResourcePath(TagUrl),
				size = CCSizeMake(39, 67),
			})
		end

		SET_POS(button,0, 0);
		local roomJiangbeiY = 45; --225
		SET_POS(roomJiangbei, -7, roomJiangbeiY);
		local textXiaohaoY = -75; --105
		SET_POS(textXiaohao, -5, textXiaohaoY);
		local textJizhanX = 63 +(textJizhan:getSize().width -cellWidth)/2;
		local textJizhanY = 47 - cellHeight/ 2;
		SET_POS(textJizhan, textJizhanX, textJizhanY);
		local textRenX = 68 + textJizhan:getSize().width+(textRen:getSize().width - cellWidth)/2;
		local textRenY =47 - cellHeight/ 2;
		SET_POS(textRen, textRenX, textRenY);
		--		local jzRenshuBgY = 40 - cellHeight/ 2;
		--SET_POS(jzRenshuBg, 0, jzRenshuBgY);
		local textJinbiY = 75 - cellHeight/ 2;
		SET_POS(textJinbi, -8 , textJinbiY);

		if tagimage ~= nil then
			local tagimageX = cellWidth / 2 - 51;
			local tagimageY = 146;
			SET_POS(tagimage, tagimageX, tagimageY);
		end

		if roomjbimage ~= nil then
			local roomjbimageX = (roomjbimage:getSize().width - cellWidth)/2+ 13;
			local roomjbimageY = (cellHeight - roomjbimage:getSize().height)/2 - 17;
			SET_POS(roomjbimage, roomjbimageX - 12, roomjbimageY + 12);
			roomjbimage:setZOrder(4);
			SET_POS(roomjbBg, roomjbimageX , roomjbimageY);
			if i <3 then
				SET_POS(roomjbimage, roomjbimageX - 5, roomjbimageY + 12);
				SET_POS(roomjbBg, roomjbimageX + 7, roomjbimageY);
			end
			roomjbBg:setZOrder(3);
		end

		SET_POS(layout, i * (cellWidth + spacingW) + cellWidth /2 + 20, cellHeight/2);

		layout:addChild(roomJiangbei)
		layout:addChild(textXiaohao)
		--		layout:addChild(jzRenshuBg)
		layout:addChild(textJizhan)
		layout:addChild(textRen)
		layout:addChild(textJinbi)

		if tagimage ~= nil then
			layout:addChild(tagimage)
		end

		if roomjbimage ~= nil then
			layout:addChild(roomjbimage)
			layout:addChild(roomjbBg)
		end

		layout:addChild(button)
		table.insert(roomItemList, layout);
		scroll_roomlist:addChild(layout)

	end
	--LordGamePub.moveinAction(scroll_roomlist);
	local function callbackShowImage(index)
		if RoomJiangbeiTable
			[""..index] ~= nil then
			RoomJiangbeiTable[""..index]:setVisible(true);
		end
	end

	local firstJoinRoom = 0
	if is_first_join_room == true then
		firstJoinRoom = 0.5
	end

	--第一次进入房间延迟播放scrollview的动画
	local function Callback()
		scroll_roomlist:setVisible(true)
		LordGamePub.showLandscapeList(roomItemList, callbackShowImage);
	end
	local arr = CCArray:create()
	arr:addObject(CCDelayTime:create(firstJoinRoom))
	arr:addObject(CCCallFuncN:create(Callback))
	scroll_roomlist:runAction(CCSequence:create(arr))

	is_first_join_room = false
end

function setOpenMatch(isOpenSelectMatchInfoV,openMatchNameV)
	isOpenSelectMatchInfo = isOpenSelectMatchInfoV
	openMatchName = openMatchNameV
end

--[[--
--发送财神消息
--]]
function sendCaiShenMsg()
	if HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_CAI_SHEN) then
		--财神开启,才发送有关消息
		sendFORTUNE_TIME_SYNC();
		sendFORTUNE_GET_INFORMATION();
	end
end

--[[--
--发送礼包消息（每天首次从牌桌返回大厅时）
--]]
function sendGiftThenFist()
	if HallGiftShowLogic.isShow == false then
		sendMANAGERID_VIPV2_GET_GIFTBAG(profile.VIPState.getVipStatus(), profile.VIPState.getVipPrice())
		vipTimeStamp()
	end
end


--[[--
--VIP礼包消息是否能调用
--]]--
function isVIPSend()
	local canSend = false;
	local TimeStamp = os.time();
	local enterTable = Common.LoadTable("enterTable");
	if enterTable ~= nil and enterTable[profile.User.getSelfUserID() .. ""] then
		local mTimeStamp = enterTable[profile.User.getSelfUserID() .. ""].TimeStamp;
		local newDate = os.date("*t",TimeStamp);
		local oldDate = os.date("*t",mTimeStamp);
		if TimeStamp > mTimeStamp then
			if newDate.year == oldDate.year and newDate.month == oldDate.month and newDate.day == oldDate.day then
				return false;
			else
				return true;
			end

		else
			return false;
		end
	else
		return true;
	end
end

--[[--
--VIP礼包本地时间戳
--]]--
function vipTimeStamp()
	local enterTable = Common.LoadTable("enterTable");
	if enterTable ~= nil and enterTable[profile.User.getSelfUserID() .. ""] then
		enterTable[profile.User.getSelfUserID() .. ""].TimeStamp = os.time();
	else
		enterTable = {};
		enterTable[profile.User.getSelfUserID() .. ""] = {};
		enterTable[profile.User.getSelfUserID() .. ""].TimeStamp = os.time();
	end
	Common.SaveTable("enterTable", enterTable)
end

function showVipStatusIcon()
	if profile.VIPState.getVipStatus() == 4 then
		--空白
		btn_VIPkaitong:setVisible(false)
	elseif profile.VIPState.getVipStatus() == 2 then
		--优惠
		if GameConfig.getHallShowMode() == MODE_HALL then
			btn_VIPkaitong:setVisible(false)
			GameArmature.showVipSaleArmature(view, 230, 503)
			Common.log("okm........")
		end
	else
		--1：开通3：续费
		btn_VIPkaitong:setVisible(true)
	end
end

function hideVipStatusIcon()
	btn_VIPkaitong:setVisible(false)
	GameArmature.hideVipSaleArmature()
end

--返回大厅的动画效果
function GotoHallAnimation()
	----------------------------------
	--房间窗口上移
	panel_room:setVisible(true)
	panel_room:setPosition(CCPoint(0, 0))

	local pWinSize = CCDirector:sharedDirector():getWinSize()
	local moveby = CCMoveTo:create(0.21, ccp(0, pWinSize.height))
	local easeOut = CCEaseOut:create(moveby, 0.8)

	panel_room:runAction(easeOut)

	joinHallAnimation()
end

--返回大厅的动画效果
function joinHallAnimation()
	local pWinSize = CCDirector:sharedDirector():getWinSize()

	--右上按钮
	local tabRightTopBtn = {}
	tabRightTopBtn[1] = btn_chongzhi
	tabRightTopBtn[2] = btn_FreeCoin
	tabRightTopBtn[3] = btn_hall_huodong
	tabRightTopBtn[4] = btn_caishen
	tabRightTopBtn[5] = btn_hall_shouchong

	for i = 1, 5 do
		tabRightTopBtn[i]:setPosition(ccp(tabRightTopBtn[i]:getPosition().x, 150))
	end

	for i = 1, 5 do
		tabRightTopBtn[i]:setVisible(true)
		local arr = CCArray:create()
		arr:addObject(CCDelayTime:create(0.5))
		arr:addObject(CCMoveTo:create(0.3,ccp(tabRightTopBtn[i]:getPosition().x, 40)))
		local seq_btn = CCSequence:create(arr)
		tabRightTopBtn[i]:runAction(seq_btn)
	end

	--个人信息
	local tabMyselfInfo = {}
	tabMyselfInfo[1] = ImageView_vip
	tabMyselfInfo[2] = LabelAtlas_viplevel
	tabMyselfInfo[3] = btn_VIPkaitong
	tabMyselfInfo[4] = lab_nickname
	tabMyselfInfo[5] = Image_NickNameBg
	tabMyselfInfo[6] = img_useravator

	for i = 1, 6 do
		tabMyselfInfo[i]:setVisible(true)
	end

	if profile.VIPState.getVipStatus() == 4 then
		btn_VIPkaitong:setVisible(false)
	end

	for i = 1, 6 do
		local arr = CCArray:create()
		arr:addObject(CCDelayTime:create(0.5))
		arr:addObject(CCFadeIn:create(0.35))
		local seq_btn = CCSequence:create(arr)
		tabMyselfInfo[i]:runAction(seq_btn)
	end

	--大厅内的4个按钮 逐个向右移动
	panel_hall:setVisible(true)

	local tabHallBtn = {}
	--比赛赢奖未开启时候
	if not HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_MATCH_GAME) then
		tabHallBtn[1] = btn_matchgame
		tabHallBtn[2] = btn_lucky_game
		tabHallBtn[3] = btn_pk_game
		tabHallBtn[4] = btn_leisuregame
	else
		tabHallBtn[1] = btn_lucky_game
		tabHallBtn[2] = btn_pk_game
		tabHallBtn[3] = btn_matchgame
		tabHallBtn[4] = btn_leisuregame
	end

	local beganY = tabHallBtn[1]:getPosition().y
	tabHallBtn[1]:setPosition(ccp(-180*GameConfig.ScaleAbscissa, beganY))
	tabHallBtn[2]:setPosition(ccp(-430*GameConfig.ScaleAbscissa, beganY))
	tabHallBtn[3]:setPosition(ccp(-690*GameConfig.ScaleAbscissa, beganY))
	tabHallBtn[4]:setPosition(ccp(-940*GameConfig.ScaleAbscissa, beganY))
	-- local fValue = 0
	for i=1, 4 do
		tabHallBtn[i]:setVisible(true)
		tabHallBtn[i]:setTouchEnabled(true)

		-- 	local array = CCArray:create()
		-- 	array:addObject(CCDelayTime:create(fValue))
		-- 	array:addObject(CCMoveBy:create(0.25,ccp(pWinSize.width+15, 0)))
		-- 	array:addObject(CCMoveBy:create(0.15,ccp(-25, 0)))
		-- 	array:addObject(CCMoveBy:create(0.15,ccp(10, 0)))
		-- 	tabHallBtn[i]:runAction(CCSequence:create(array))

		-- 	fValue = fValue + 0.1
	end


	--大厅的聊天按钮
	btn_chat:setVisible(true)
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.7))
	array:addObject(CCMoveTo:create(0.3, ccp(30, btn_chat:getPosition().y)))
	btn_chat:runAction(CCSequence:create(array))

	--大厅的快速开始按钮
	btn_quickstart:setVisible(true)
	btn_quickstart:runAction(CCFadeIn:create(0))
	btn_quickstart:setScale(0)

	local scale = CCScaleTo:create(0.25, 1.25)
	local scale1 = CCScaleTo:create(0.15, 0.85)
	local scale2 = CCScaleTo:create(0.15, 1)

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.5))
	array:addObject(scale)
	array:addObject(scale1)
	array:addObject(scale2)
	btn_quickstart:runAction(CCSequence:create(array))
end

--进入房间的动画效果
function GotoRoomAnimation(room_node)
	-------------------------------------------------------------------
	--进入房间，增加新的动画效果
	--房间列表父节点
	local pWinSize = CCDirector:sharedDirector():getWinSize()
	room_node:setPosition(CCPoint(room_node:getPosition().x+pWinSize.width, 0))
	room_node:setVisible(true)


	local function Callback()
		print("动画播放")
	end

	local moveby = CCMoveTo:create(0.25, ccp(0, 0))
	local moveby1 = CCMoveTo:create(0.08, ccp(18, 0))
	local moveby2 = CCMoveTo:create(0.08, ccp(0, 0))
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.2))
	array:addObject(moveby)
	array:addObject(moveby1)
	array:addObject(moveby2)
	array:addObject(CCCallFuncN:create(Callback))
	local seq = CCSequence:create(array)
	room_node:runAction(seq)

	leaveHallAnimation()
end

--离开大厅的动画效果
function leaveHallAnimation()
	local pWinSize = CCDirector:sharedDirector():getWinSize()

	--右上按钮
	local tabRightTopBtn = {}
	tabRightTopBtn[1] = btn_chongzhi
	tabRightTopBtn[2] = btn_FreeCoin
	tabRightTopBtn[3] = btn_hall_huodong
	tabRightTopBtn[4] = btn_caishen
	tabRightTopBtn[5] = btn_hall_shouchong

	for i = 1, 5 do
		tabRightTopBtn[i]:setPosition(ccp(tabRightTopBtn[i]:getPosition().x, 40))
	end

	for i = 1, 5 do
		tabRightTopBtn[i]:setVisible(true)
		local arr = CCArray:create()
		arr:addObject(CCDelayTime:create(0))
		arr:addObject(CCMoveTo:create(0.3,ccp(tabRightTopBtn[i]:getPosition().x, 150)))
		local seq_btn = CCSequence:create(arr)
		tabRightTopBtn[i]:runAction(seq_btn)
	end

	--个人信息
	local tabMyselfInfo = {}
	tabMyselfInfo[1] = ImageView_vip
	tabMyselfInfo[2] = LabelAtlas_viplevel
	tabMyselfInfo[3] = btn_VIPkaitong
	tabMyselfInfo[4] = lab_nickname
	tabMyselfInfo[5] = Image_NickNameBg
	tabMyselfInfo[6] = img_useravator

	for i = 1, 6 do
		tabMyselfInfo[i]:setVisible(true)
	end

	if profile.VIPState.getVipStatus() == 4 then
		btn_VIPkaitong:setVisible(false)
	end

	for i = 1, 6 do
		local arr = CCArray:create()
		arr:addObject(CCDelayTime:create(0))
		arr:addObject(CCFadeOut:create(0.35))
		local seq_btn = CCSequence:create(arr)
		tabMyselfInfo[i]:runAction(seq_btn)
	end

	--大厅内的4个按钮一起向左移动
	local tabBtn = {}
	tabBtn[1] = btn_matchgame--比赛赢奖
	tabBtn[2] = btn_leisuregame--休闲房间
	tabBtn[3] = btn_lucky_game--活动(活动专区)
	tabBtn[4] = btn_pk_game--疯狂闯关

	panel_hall:setVisible(true)

	for i=1, 4 do
		tabBtn[i]:setVisible(true)


		print("%.1f,%.1f", tabBtn[i]:getPosition().x, tabBtn[i]:getPosition().y)
		local arr = CCArray:create()
		arr:addObject(CCDelayTime:create(0.2))
		arr:addObject(CCMoveBy:create(0.25,ccp(-pWinSize.width, 0)))
		local seq_btn = CCSequence:create(arr)
		tabBtn[i]:runAction(seq_btn)
	end

	--大厅的聊天按钮
	btn_chat:setVisible(true)
	btn_chat:runAction(CCMoveTo:create(0.3, ccp(-30, btn_chat:getPosition().y)))

	--大厅的快速开始按钮
	btn_quickstart:setVisible(true)
	btn_quickstart:runAction(CCFadeOut:create(0.25))

	panel_end:stopAllActions();
	panel_end:setPosition(ccp(0, 0))
	panel_end:runAction(CCMoveTo:create(0.6, ccp(0, -panel_end:getContentSize().height)))
	-------------------------------------------------------------------
end

--首次进入大厅的动画效果
function FirstJoinHallAnimation()
	local pWinSize = CCDirector:sharedDirector():getWinSize()

	--大厅内的4个按钮 向左移动
	panel_hall:setVisible(true)
	local tabBtn = {}
	--比赛赢奖未开启时候
	if not HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_MATCH_GAME) then
		tabBtn[1] = btn_matchgame
		tabBtn[2] = btn_lucky_game
		tabBtn[3] = btn_pk_game
		tabBtn[4] = btn_leisuregame
	else
		tabBtn[1] = btn_lucky_game
		tabBtn[2] = btn_pk_game
		tabBtn[3] = btn_matchgame
		tabBtn[4] = btn_leisuregame
	end

	for i=1, 4 do
		--tabBtn[i]:setTouchEnabled(false)
		tabBtn[i]:setPosition(CCPoint(tabBtn[i]:getPosition().x-pWinSize.width, tabBtn[i]:getPosition().y))
	end

	local fValue = 0
	for i=1, 4 do
		tabBtn[i]:setVisible(true)

		local array = CCArray:create()
		array:addObject(CCDelayTime:create(fValue))
		array:addObject(CCMoveBy:create(0.25,ccp(pWinSize.width+15, 0)))
		array:addObject(CCMoveBy:create(0.15,ccp(-25, 0)))
		array:addObject(CCMoveBy:create(0.15,ccp(10, 0)))
		tabBtn[i]:runAction(CCSequence:create(array))

		fValue = fValue + 0.10
	end
end


--[[--
--初始化大厅界面
--#@param #number mode 大厅显示模式
]]
function changeHallView(mode, itemID)
	--bIsChangingHallView = true

	if itemID == nil or  itemID == "" then
		itemID = 0
	end

	GameConfig.setHallShowMode(mode)
	GameConfig.setHallRoomItem(itemID)
	isShowCountDownGiftPackage();
	--隐藏大厅骨骼动画
	GameArmature.hideHallBtnArmature();
	--隐藏财神骨骼动画
	GameArmature.hideCaiShenArmature();

	--切换界面有些按钮要隐藏
	if GameConfig.getHallShowMode() == MODE_HALL then
		btn_VIPkaitong:setTouchEnabled(true)
		--显示公告
--		showSystemNotice();
		--大厅模式
		if CommDialogConfig.getNewUserGiudeFinish() == true then
			--如果不是新用户，新手引导已经完成，发新手任务信息
			sendNewUserTaskIsComplete();
		end
		MatchList.initMatchListData()

		roomItemList = {}
		RoomJiangbeiTable = {}
		RoomTableJz = {}--激战人数

		theCurrentItemID = -1;
		if panel_hall ~= nil then
			panel_hall:setVisible(true)
			panel_hall:setZOrder(2)
			--panel_hall:setTouchEnabled(true)
		end
		--panel_end:setVisible(true);
		panel_room:setVisible(false)
		panel_room:setZOrder(1)
		panel_room:setTouchEnabled(false)
		panel_match:setVisible(false)
		panel_match:setZOrder(1)
		panel_match:setTouchEnabled(false)
		--上方左边按钮
		--img_topbg:setVisible(false)
		lab_time:setVisible(false)
		btn_back:setVisible(false)
		ImageView_vip:setVisible(true);

		LabelAtlas_viplevel:setVisible(true);
		lab_nickname:setVisible(true);
		Image_NickNameBg:setVisible(true);
		btn_back:setTouchEnabled(false)
		--img_userinfo:setPosition(ccp(260,12))
		img_useravator:setVisible(true)
		img_useravator:setTouchEnabled(true)
		img_useravatorbg:setVisible(true)
		--btn_useravator:setTouchEnabled(true)
		--上方右边按钮
		btn_chongzhi:setVisible(true)
		btn_chongzhi:setTouchEnabled(true)
		btn_FreeCoin:setVisible(true)
		btn_FreeCoin:setTouchEnabled(true)
		btn_hall_huodong:setVisible(true)
		btn_hall_huodong:setTouchEnabled(true)
		btn_caishen:setVisible(true)
		btn_caishen:setTouchEnabled(true)
		btn_caishen:setOpacity(255)

		--更新上部按钮的状态
		HallButtonManage.updateTopButtonStatus();
		--进入大厅动画
		enterHallAnimation();

		img_laizi:setTouchEnabled(false)
		img_happy:setTouchEnabled(false)
		img_common:setTouchEnabled(false)
		img_mianfei:setTouchEnabled(false)
		img_tianti:setTouchEnabled(false)

		--清空房间和比赛
		scroll_roomlist:removeAllChildren()
		scroll_roomlist:setTouchEnabled(false)
		scroll_matchlist:removeAllChildren()
		scroll_matchlist:setTouchEnabled(false)

		sendCaiShenMsg();

	--GotoHallAnimation()
	elseif GameConfig.getHallShowMode() == MODE_ROOMLIST then
		btn_VIPkaitong:setTouchEnabled(false)
		MatchList.initMatchListData()

		theCurrentItemID = -1;

		--房间模式
		if panel_hall ~= nil then
			panel_hall:setVisible(false)
			panel_hall:setZOrder(1)
			--panel_hall:setTouchEnabled(false)
		end
		panel_room:setVisible(true)
		panel_room:setZOrder(2)
		panel_room:setTouchEnabled(true)

		panel_match:setVisible(false)
		panel_match:setZOrder(1)
		panel_match:setTouchEnabled(false)
		--上方左边按钮
		--img_topbg:setVisible(true)
		lab_time:setVisible(true)
		btn_back:setVisible(true)
		btn_back:setTouchEnabled(true)
		--img_userinfo:setPosition(ccp(340,46))
		img_useravator:setVisible(false)
		img_useravator:setTouchEnabled(false)
		img_useravatorbg:setVisible(false)
		ImageView_vip:setVisible(false);
		LabelAtlas_viplevel:setVisible(false);
		lab_nickname:setVisible(false)
		Image_NickNameBg:setVisible(false)

		hideVipStatusIcon()

		--btn_useravator:setTouchEnabled(false)
		--上方右边按钮
		btn_chongzhi:setVisible(false)
		btn_chongzhi:setTouchEnabled(false)
		btn_FreeCoin:setVisible(false)
		btn_FreeCoin:setTouchEnabled(false)
		btn_hall_huodong:setVisible(false)
		btn_hall_huodong:setTouchEnabled(false)
		btn_caishen:setVisible(false)
		btn_caishen:setTouchEnabled(false)
		GanTanHao:setVisible(false)

		GameArmature.hideCaiShenArmature();
		removeNewUserGuideArrow();
		removeLightBg();

		--不同的房间按钮现实的背景不同
		--欢乐房间
		if itemID == ROOM_ITEM_ROOMHAPPY then
			img_laizi:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
			img_happy:loadTexture(Common.getResourcePath("btn_macth_press.png"))
			img_common:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
			zi_common:loadTexture(Common.getResourcePath("ui_room_putongchang.png"))
			zi_huanle:loadTexture(Common.getResourcePath("ui_room_huanlechang2.png"))
			zi_laizi:loadTexture(Common.getResourcePath("ui_room_laizichang.png"))

		elseif itemID == ROOM_ITEM_ROOMCOMMON then
			--普通房间
			img_laizi:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
			img_happy:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
			img_common:loadTexture(Common.getResourcePath("btn_macth_press.png"))
			zi_common:loadTexture(Common.getResourcePath("ui_room_putongchang2.png"))
			zi_huanle:loadTexture(Common.getResourcePath("ui_room_huanlechang.png"))
			zi_laizi:loadTexture(Common.getResourcePath("ui_room_laizichang.png"))
		else
			--癞子
			img_laizi:loadTexture(Common.getResourcePath("btn_macth_press.png"))
			img_happy:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
			img_common:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
			zi_common:loadTexture(Common.getResourcePath("ui_room_putongchang.png"))
			zi_huanle:loadTexture(Common.getResourcePath("ui_room_huanlechang.png"))
			zi_laizi:loadTexture(Common.getResourcePath("ui_room_laizichang2.png"))
		end

		showRoomList(itemID)
		img_laizi:setTouchEnabled(true)
		img_happy:setTouchEnabled(true)
		img_common:setTouchEnabled(true)
		img_mianfei:setTouchEnabled(false)
		img_tianti:setTouchEnabled(false);

		--panel_end:setVisible(false)
		scroll_roomlist:setTouchEnabled(true)
		scroll_matchlist:setTouchEnabled(false)

	elseif GameConfig.getHallShowMode() == MODE_MATCHLIST then
		btn_VIPkaitong:setTouchEnabled(false)
		MatchList.initMatchListData()
		scroll_matchlist:removeAllChildren()

		roomItemList = {}
		RoomJiangbeiTable = {}
		RoomTableJz = {}--激战人数

		--比赛
		if panel_hall ~= nil then
			panel_hall:setVisible(false)
			panel_hall:setZOrder(1)
			--panel_hall:setTouchEnabled(false)
		end
		panel_room:setVisible(false)
		panel_room:setZOrder(2)
		panel_room:setTouchEnabled(false)
		panel_match:setVisible(true)
		panel_match:setZOrder(1)
		panel_match:setTouchEnabled(true)
		--上方左边按钮
		--img_topbg:setVisible(true)
		lab_time:setVisible(true)
		btn_back:setVisible(true)
		btn_back:setTouchEnabled(true)
		--img_userinfo:setPosition(ccp(340,46))
		img_useravator:setVisible(false)
		img_useravator:setTouchEnabled(false)
		img_useravatorbg:setVisible(false)
		ImageView_vip:setVisible(false);
		LabelAtlas_viplevel:setVisible(false);
		lab_nickname:setVisible(false)
		Image_NickNameBg:setVisible(false)

		hideVipStatusIcon();

		--btn_useravator:setTouchEnabled(false)
		--上方右边按钮
		btn_chongzhi:setVisible(false)
		btn_chongzhi:setTouchEnabled(false)
		btn_FreeCoin:setVisible(false)
		btn_FreeCoin:setTouchEnabled(false)
		btn_hall_huodong:setVisible(false)
		btn_hall_huodong:setTouchEnabled(false)
		btn_caishen:setVisible(false)
		GanTanHao:setVisible(false)
		GameArmature.hideCaiShenArmature();
		btn_caishen:setTouchEnabled(false)
		removeNewUserGuideArrow();
		removeLightBg();
		--不同的房间按钮现实的背景不同
		if itemID == MatchList.ROOM_ITEM_MATCHTIANTI then
			--天梯
			img_mianfei:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
			img_tianti:loadTexture(Common.getResourcePath("btn_macth_press.png"))
			zi_mfyj:loadTexture(Common.getResourcePath("ui_macth_mianfeiyingjiang.png"))
			zi_ttzq:loadTexture(Common.getResourcePath("ui_macth_tiantizhuanqu2.png"))
		elseif itemID == MatchList.ROOM_ITEM_MATCHMIANFEI then
			--免费赢奖
			img_mianfei:loadTexture(Common.getResourcePath("btn_macth_press.png"))
			img_tianti:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
			zi_mfyj:loadTexture(Common.getResourcePath("ui_macth_mianfeiyingjiang2.png"))
			zi_ttzq:loadTexture(Common.getResourcePath("ui_macth_tiantizhuanqu.png"))
		end

		Common.log("scroll_matchlist:getPosition().x = "..scroll_matchlist:getPosition().x)
		--		scroll_matchlist:setScaleX(GameConfig.ScaleAbscissa);
		--		scroll_matchlist:setScaleY(GameConfig.ScaleOrdinate);

		local firstJoinRoom = 0
		if is_first_join_room == true then
			firstJoinRoom = 0.5
		end

		--第一次进入房间延迟播放scrollview的动画
		local function Callback()
			--panel_end:setVisible(false);
			scroll_roomlist:setTouchEnabled(false)
			scroll_matchlist:setTouchEnabled(true)
			MatchList.showMatchList(itemID, scroll_matchlist, isOpenSelectMatchInfo, openMatchName)
		end

		local arr = CCArray:create()
		arr:addObject(CCDelayTime:create(firstJoinRoom))
		arr:addObject(CCCallFuncN:create(Callback))
		scroll_matchlist:runAction(CCSequence:create(arr))

		is_first_join_room = false


		img_laizi:setTouchEnabled(false)
		img_happy:setTouchEnabled(false)
		img_common:setTouchEnabled(false)
		img_mianfei:setTouchEnabled(true)
		img_tianti:setTouchEnabled(true)


	elseif GameConfig.getHallShowMode() == MODE_MINIGAME then

	end

	--bIsChangingHallView = false;
end

function requestMsg()
	if CommDialogConfig.getScriptUpdataDone() then
		PauseSocket("ScriptUpdataDone");
		Services:getMessageService():removeAllMessage();
		CommDialogConfig.showUnzipLuaPrompt()
	end

	--判断显示红包分享逻辑
	CommShareConfig.showRedGiftShareView();

	if GameConfig.NeedToInstallApp then
		GameConfig.NeedToInstallApp = false;
		--如果已经有下载完的应用需要安装
		Common.installApp(GameConfig.AppFilePath);
	end

	if profile.TableKick.getIsShowBeKick() == true then
		CommDialogConfig.showBeKickedView()
		BeKickedLogic.setIsShowBeKick(true)
		profile.TableKick.setIsShowBeKick(false)
	end

	if TableConsole.bShouldShowJijiangkaisai == true then
		-- show比赛即将开始弹框
		Common.log("Hall show比赛即将开始弹框")

		TableConsole.bShouldShowJijiangkaisai = false
		matchjijiangkaisaiLogic.leftCallbackFunction = function()
			-- 开始小游戏
			if GameLoadModuleConfig.getFruitIsExists() then
				GameConfig.setTheLastBaseLayer(GUI_HALL)
				mvcEngine.createModule(GUI_MINIGAME_FRUIT_MACHINE, LordGamePub.runSenceAction(HallLogic.view,nil,true))
			end
		end
		matchjijiangkaisaiLogic.rightCallbackFunction = function()
			-- 退赛返回房间
			Common.showProgressDialog("进入房间中,请稍后...");
			sendMATID_V4_REFUND(TableConsole.tJijiangkaisaiMatchItem.MatchID)
			MatchList.removeAlarmQueue(TableConsole.tJijiangkaisaiMatchItem.MatchID)
			sendQuickEnterRoom(-1);
		end
		matchjijiangkaisaiLogic.tableMode = 2
		matchjijiangkaisaiLogic.strTitleTips = "【"..TableConsole.tJijiangkaisaiMatchItem.MatchTitle.."】比赛, 将在2分钟后开始, 是否参加？"
		mvcEngine.createModule(GUI_MATCH_JIJIANGKAISHI)
	end

	if TableConsole.bHallShouldShowCertificateAlert == true then
		TableConsole.bHallShouldShowCertificateAlert = false
		local matchCertificate = profile.GameDoc.getMatchCertificate()
		mvcEngine.createModule(GUI_TABLE_CERTIFICATEVIEW)
		CertificateLogic.updataCertificate_V4(matchCertificate)
	end
	--新手引导
	if profile.NewUserGuide.getisNewUserGuideisEnable() then
		NewUserCreateLogic.JumpInterface(HallLogic.view,NewUserCoverOtherLogic.getTaskState());
	end
end

--[[--
--移除btn上的叹号
--@param #CCButton btn 菜单按钮
--]]
function removeTanHaoByTag(btn)
	if btn:getChildByTag(TAG_TAN_HAO) ~= nil then
		btn:removeChildByTag(TAG_TAN_HAO,  true)
	end
end

--[[--
--创建btn上的叹号
--@param #CCButton btn 菜单按钮
--]]
function createTanHaoByTag(btn)
	if btn:getChildByTag(TAG_TAN_HAO)  == nil then
		local btnGanTanHao = UIImageView:create()
		btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
		--btnGanTanHao:setAnchorPoint(ccp(-0.3,0.3))
		btnGanTanHao:setZOrder(4);
		btnGanTanHao:setPosition(ccp(43, 15));
		btn:addChild(btnGanTanHao)
		btnGanTanHao:setTag(TAG_TAN_HAO)
	end
end

--------------------------------按钮事件------------------------
--top
--个人头像
function callback_btn_useravator(component)
	if component == PUSH_DOWN then
		--按下
		img_useravator:setScale(1.2)
	elseif component == RELEASE_UP then
		--抬起
		img_useravator:setScale(1)
		Common.setUmengUserDefinedInfo("hall_btn_click", "个人头像")

		Common.showProgressDialog("数据加载中,请稍后...")
		GameConfig.setTheLastBaseLayer(GUI_HALL)
		--UserInfoLogic.setTab(UserInfoLogic.TAB_TIANTI)
		mvcEngine.createModule(GUI_USERINFO,LordGamePub.runSenceAction(view,nil,true))

	elseif component == CANCEL_UP then
		--取消
		img_useravator:setScale(1)
	end
end
--金币自由兑换
function callback_btn_coin(component)
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
--点击元宝加号
--]]--
function callback_btn_YuanBao(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_HALL);
		mvcEngine.createModule(GUI_RECHARGE_CENTER,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_VIPkaitong(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起

		if profile.VIPState.getVipStatus() == 1 or profile.VIPState.getVipStatus() == 2 then  --开通和优惠状态
			sendMANAGERID_VIPV2_GET_GIFTBAG(profile.VIPState.getVipStatus(), profile.VIPState.getVipPrice())
		elseif profile.VIPState.getVipStatus() == 3 then  --续费状态
			mvcEngine.createModule(GUI_PAYGUIDEPROMPT)
			PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, profile.VIPState.getVipPrice()*1000 * 0.7, 0)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--小游戏
function callback_btn_lucky_game(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		if ServerConfig.enableThirdpartReview() then
			Common.showToast("幸运游戏暂未开放", 2);
			return
		end
		--抬起
		if not HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_LUCKY_GAME) then
			--该按钮不开启时
			local tips = HallButtonManage.getHallButtonToast(HallButtonConfig.BTN_ID_LUCKY_GAME)
			Common.showToast(tips, 2);
			return;
		end
		GameConfig.setTheLastBaseLayer(GUI_HALL);
		mvcEngine.createModule(GUI_MINIGAME)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--每日免费金币按钮
--]]
function callback_btn_FreeCoin(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if not HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_FREE_COIN) then
			--该按钮不开启时
			local tips = HallButtonManage.getHallButtonToast(HallButtonConfig.BTN_ID_FREE_COIN)
			Common.showToast(tips, 2);
			return;
		end

		GameConfig.setTheLastBaseLayer(GUI_HALL);
		mvcEngine.createModule(GUI_FREECOIN);
	elseif component == CANCEL_UP then
	--取消

	end
end

--end
--财神
function callback_btn_caishen(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if not HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_CAI_SHEN) then
			--该按钮不开启时
			local tips = HallButtonManage.getHallButtonToast(HallButtonConfig.BTN_ID_CAI_SHEN)
			Common.showToast(tips, 2);
			return;
		end

		CaiShenLogic.iconPosition = btn_caishen:getParent():convertToWorldSpace(btn_caishen:getPosition())
		mvcEngine.createModule(GUI_CAISHEN)
	elseif component == CANCEL_UP then
	--取消
	end
end

--充值
function callback_btn_chongzhi(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if not HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_RECHARGE) then
			--该按钮不开启时
			local tips = HallButtonManage.getHallButtonToast(HallButtonConfig.BTN_ID_RECHARGE)
			Common.showToast(tips, 2);
			return;
		end

		if GameConfig.PAYMENT_METHOD_STATUS == GameConfig.PAYMENT_ONLY_PURSE and ServerConfig.HAS_GET_PURES_MATCHES == false and Common.getOperater() == Common.CHINA_MOBILE then
			local resultText = "获取数据中,请稍后再试."
			Common.showToast(resultText, 2)
		else
			Common.setUmengUserDefinedInfo("hall_btn_click", "充值")
			GameConfig.setTheLastBaseLayer(GUI_HALL)
			mvcEngine.createModule(GUI_RECHARGE_CENTER,LordGamePub.runSenceAction(view,nil,true))
		end
	elseif component == CANCEL_UP then
	--取消demo Group
	end
end

--比赛
function callback_btn_matchgame(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if not HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_MATCH_GAME) then
			--该按钮不开启时
			local tips = HallButtonManage.getHallButtonToast(HallButtonConfig.BTN_ID_MATCH_GAME)
			Common.showToast(tips, 2);
			return;
		end
		Common.log("callback_btn_matchgame")

		changeHallView(MODE_MATCHLIST, MatchList.ROOM_ITEM_MATCHMIANFEI);
		--		hideMenuBar();
		GotoRoomAnimation(panel_match)

		--[[
		local delay = CCDelayTime:create(1);
		local array = CCArray:create();
		array:addObject(delay);
		local seq = CCSequence:create(array);
		view:runAction(seq);
		]]
	elseif component == CANCEL_UP then
	--取消
	end
end

--休闲房间
function callback_btn_leisuregame(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if not HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_LEISURE_GAME) then
			--该按钮不开启时
			local tips = HallButtonManage.getHallButtonToast(HallButtonConfig.BTN_ID_LEISURE_GAME)
			Common.showToast(tips, 2);
			return;
		end

		scroll_roomlist:setVisible(false)
		changeHallView(MODE_ROOMLIST,ROOM_ITEM_ROOMLAIZI)
		--		hideMenuBar()

		GotoRoomAnimation(panel_room) --进入房间

		btn_matchgame:setTouchEnabled(false) --比赛赢奖
		btn_leisuregame:setTouchEnabled(false)--休闲房间
		btn_lucky_game:setTouchEnabled(false)--活动(活动专区)
		btn_pk_game:setTouchEnabled(false)--疯狂闯关

	elseif component == CANCEL_UP then
	--取消
	end

end

--活动
function callback_btn_hall_huodong(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if not HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_ACTIVITY) then
			--该按钮不开启时
			local tips = HallButtonManage.getHallButtonToast(HallButtonConfig.BTN_ID_ACTIVITY)
			Common.showToast(tips, 2);
			return;
		end

		GameConfig.setTheLastBaseLayer(GUI_HALL)
		mvcEngine.createModule(GUI_HUODONG,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消
	end
end

--快速开始
function callback_btn_quickstart(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then

		--抬起
		-- -1   服务器自动选择 0普通 1欢乐 2癞子
		Common.showProgressDialog("进入房间中,请稍后...");
		sendQuickEnterRoom(-1);

	elseif component == CANCEL_UP then
	--取消
	end

end
--end
function callback_btn_message(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.setUmengUserDefinedInfo("hall_btn_click", "站内信")
		GameConfig.setTheLastBaseLayer(GUI_HALL)
		mvcEngine.createModule(GUI_MESSAGELIST)
	elseif component == CANCEL_UP then
	--取消
	end
end

--商城
function callback_btn_shop(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.setUmengUserDefinedInfo("hall_btn_click", "商城")
		--btn_shop:removeAllChildren();--移除感叹号
		local table = profile.Gift.getGIFTBAGID_NEWGIFT_TYPETable()
		if(table["result"] == 1)then
			ShopLogic.setHongDian(1)
		end
		GameConfig.setTheLastBaseLayer(GUI_HALL)
		mvcEngine.createModule(GUI_SHOP,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消
	end
end
--兑奖
function callback_btn_gift(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.setUmengUserDefinedInfo("hall_btn_click", "兑奖")
		removeTanHaoByTag(btn_gift);--移除感叹号
		GameConfig.setTheLastBaseLayer(GUI_HALL)
		mvcEngine.createModule(GUI_EXCHANGE,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消
	end
end

--排行榜
function callback_btn_rankinglist(component)

	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		btn_nameScale = "btn_rankinglist"
		Common.setButtonScale(btn_rankinglist,btnScaleOverFunc)
		GameConfig.setTheLastBaseLayer(GUI_HALL)
		mvcEngine.createModule(GUI_PAIHANGBANG,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消
	end
end

--设置
function callback_btn_setting(component)

	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--SettingLogic.iconPosition = btn_setting:getParent():convertToWorldSpace(btn_setting:getPosition())
		GameConfig.setTheLastBaseLayer(GUI_HALL);
		mvcEngine.createModule(GUI_SETTING);
		--添加红点
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			HongDianLogic.showHall_more_Verson(SettingLogic.btn_kefu,SettingLogic.btn_version)
		end

	elseif component == CANCEL_UP then
	--取消
	end
end

--返回键
function callback_btn_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if  GameConfig.getHallShowMode() ~= MODE_HALL then
			changeHallView(MODE_HALL)

			GotoHallAnimation()
		end
		--		hideMenuBar()
		is_first_join_room = true
	elseif component == CANCEL_UP then
	--取消
	end
end

--癞子房间
function callback_img_laizi(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--房间模式
		if GameConfig.getHallRoomItem() ~= ROOM_ITEM_ROOMLAIZI then
			changeHallView(MODE_ROOMLIST, ROOM_ITEM_ROOMLAIZI)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end
--欢乐房间
function callback_img_happy(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if GameConfig.getHallRoomItem() ~= ROOM_ITEM_ROOMHAPPY then
			changeHallView(MODE_ROOMLIST, ROOM_ITEM_ROOMHAPPY)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end
--普通房间
function callback_img_common(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if GameConfig.getHallRoomItem() ~= ROOM_ITEM_ROOMCOMMON then
			changeHallView(MODE_ROOMLIST, ROOM_ITEM_ROOMCOMMON)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end
--免费赢奖
function callback_img_mianfei(component)
	--if bIsChangingHallView == true then
	--	return;
	--end

	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if GameConfig.getHallRoomItem() ~= MatchList.ROOM_ITEM_MATCHMIANFEI then
			changeHallView(MODE_MATCHLIST, MatchList.ROOM_ITEM_MATCHMIANFEI)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--天梯
function callback_img_tianti(component)
	--if bIsChangingHallView == true then
	--	return;
	--end

	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if GameConfig.getHallRoomItem() ~= MatchList.ROOM_ITEM_MATCHTIANTI then
			changeHallView(MODE_MATCHLIST, MatchList.ROOM_ITEM_MATCHTIANTI)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end
--聊天
function callback_btn_chat(component)

	if component == PUSH_DOWN then
		if not HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_CHAT) then
			--该按钮不开启时
			local tips = HallButtonManage.getHallButtonToast(HallButtonConfig.BTN_ID_CHAT)
			Common.showToast(tips, 2);
			return;
		end

		--按下(拖动聊天按钮时可以触发)
		Common.setUmengUserDefinedInfo("hall_btn_click", "聊天-展开")
		btn_chat:setVisible(false);
		mvcEngine.createModule(GUI_HALLCHAT)
	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消
	end

end

--首冲礼包
function callback_btn_hall_shouchong(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		sendGIFTBAGID_GET_LOOP_GIFT(1)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--疯狂闯关
--]]
function callback_btn_pk_game(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if not HallButtonManage.isHallButtonAvailable(HallButtonConfig.BTN_ID_PK_GAME) then
			--该按钮不开启时
			local tips = HallButtonManage.getHallButtonToast(HallButtonConfig.BTN_ID_PK_GAME)
			Common.showToast(tips, 2);
			return;
		end

		GameConfig.setTheLastBaseLayer(GUI_HALL)
		mvcEngine.createModule(GUI_CHUANGGUAN)
	elseif component == CANCEL_UP then
	--取消

	end
end


--更新时间，更新房间列表激战人数(每三秒回调一次)
function setCurrentTime()
	--	frashChatMassage();
	--更新时间
	--	if timeIndex % 20 == 0 then
	timeIndex = 0;
	local Hour = os.date("%H", Common.getServerTime());
	local Minute = os.date("%M", Common.getServerTime());
	--		Common.log("zbl..........Hour = " .. Hour .."              Minute = " .. Minute)
	lab_time:setText(Hour..":"..Minute);
	if GameConfig.getHallShowMode() == MODE_ROOMLIST then
		--更新房间列表激战人数
		sendROOMID_ROOM_LIST_NEW(profile.RoomData.getTimestamp())
	elseif GameConfig.getHallShowMode() == MODE_MATCHLIST then
		--发送比赛人数同步
		--sendMATID_V2_MATCH_LIST_SYNC()

		-- 3.03
		Common.log("setCurrentTime sendMATID_V4_MATCH_SYNC")
		sendMATID_V4_MATCH_SYNC()
	end
	--	end
	--	timeIndex = timeIndex + 1;
end

--更新房间列表
function updateRoomTable()
	RoomTable["rooms"] = profile.RoomData.getRoomTable()
	RoomTable["getUpdataRoomCnt"] = profile.RoomData.getUpdataRoomCnt()
	if GameConfig.getHallShowMode() == MODE_ROOMLIST then
		Common.closeProgressDialog()
		if RoomTable["getUpdataRoomCnt"] > 0 then
			--更新房间
			changeHallView(GameConfig.getHallShowMode(), GameConfig.getHallRoomItem())
		else
			--更新激战人数
			for i=1,#RoomTable["rooms"] do
				for j=1,#RoomTableJz do
					if RoomTable["rooms"][i].RoomID == RoomTableJz[j].RoomID then
						RoomTableJz[j].RoomJzLabel:setText(RoomTable["rooms"][i].playerCnt)
					end
				end
			end
		end
	end
end

--[[--
--更新用户数据
]]
function updataUserInfo()
	updataEditUserInfo()
	showVipState()  --vip信息
	local useravatorIdSD = Common.getDataForSqlite(CommSqliteConfig.SelfAvatorInSD..profile.User.getSelfUserID())
	if useravatorIdSD == "" or useravatorIdSD == nil then
		local photoUrl = profile.User.getSelfPhotoUrl()
		if photoUrl ~= nil then
			Common.getPicFile(photoUrl, 0, true, updataUserPhoto)
		end
	end
end

--[[--
--更新用户信息
--]]
function updataEditUserInfo()
	Common.log("hall updataEditUserInfo")

	local nickname = profile.User.getSelfNickName()
	local coinNum = profile.User.getSelfCoin()
	local yuanBaoNum = profile.User.getSelfYuanBao()
	local vipLevel = VIPPub.getUserVipType(profile.User.getSelfVipLevel());

	if nickname ~= nil then
		lab_nickname:setText(nickname)
	end
	lab_coin:setText(""..coinNum)
	lab_YuanBao:setText(""..yuanBaoNum)

	--根据用户金币变化刷新比赛列表
	if GameConfig.getHallShowMode() == MODE_MATCHLIST then
		changeHallView(GameConfig.getHallShowMode(), GameConfig.getHallRoomItem())
	end

end

--[[--
--隐藏panel_chat动画
--]]
local function hidePanelChatAnimation()
	--设置panel_chat隐藏
	local function setPanelChatHide()
		if panel_chat ~= nil then
			panel_chat:setVisible(false);
		end

	end

	--淡出
	local panelActionArray = CCArray:create();
	local fadeOut = CCFadeOut:create(1);
	panelActionArray:addObject(fadeOut)
	panelActionArray:addObject(CCCallFuncN:create(setPanelChatHide))
	panel_chat:runAction(CCSequence:create(panelActionArray))
end

--[[--
--创建系统公告label
--@param #string systemNotice 系统公告(文本)
--@param #number textLenWidth 系统公告label的width
--]]
local function createSystemNoticeLabe(systemNotice,textLenWidth)
	--移除 labelNotice
	if labelNotice ~= nil  and panel_chat ~= nil and panel_chat:getChildByTag(TAG_LABEL_NOTICE) ~= nil then
		labelNotice:stopAllActions();
		panel_chat:removeChild(labelNotice);
		labelNotice = nil;
	end
	--系统公告
	if MiniGame_Duijiang == 1 then
		labelNotice = ccs.label({
			text = systemNotice,
			size = CCSizeMake(textLenWidth, 41),
		})
		labelNotice:setFontSize(25);
		labelNotice:setColor(ccc3(196,186,168));
		labelNotice:setAnchorPoint(ccp(0,0.4));
		labelNotice:setTag(TAG_LABEL_NOTICE);
		labelNotice:setPosition(ccp(chatPanelSize.width + chatPanelPoint.x,20));

		panel_chat:addChild(labelNotice);
		profile.SystemListNotice.setOneSystemNotice()
		--小游戏赢钱公告
	elseif MiniGame_Duijiang == 2 then
		local chatTable = profile.MiniGame.getMinigame_DuiJiang_TableV2()
		labelNotice = ccs.label({
			text = systemNotice,
			size = CCSizeMake(textLenWidth, 41),
		})
		labelNotice:setFontSize(25);
		labelNotice:setColor(ccc3(196,186,168));
		labelNotice:setAnchorPoint(ccp(0,0.4));
		labelNotice:setTag(TAG_LABEL_NOTICE);
		labelNotice:setPosition(ccp(chatPanelSize.width + chatPanelPoint.x,20));
		if chatTable ~= nil and chatTable ~= "" then
			setMiniGameRollInfoJump(chatTable.actionId, chatTable.status)
		end
		profile.MiniGame.setMinigame_DuiJiang_TableNull()
		--小游戏比倍>5次公告
	elseif MiniGame_Duijiang == 3 then
		local chatTable = profile.IM.getIMID_CHAT_ROOM_SEND_REWARD_V3Table();
		labelNotice = ccs.label({
			text = systemNotice,
			size = CCSizeMake(textLenWidth, 41),
		})
		labelNotice:setFontSize(25);
		labelNotice:setColor(ccc3(196,186,168));
		labelNotice:setAnchorPoint(ccp(0,0.4));
		labelNotice:setTag(TAG_LABEL_NOTICE);
		labelNotice:setPosition(ccp(chatPanelSize.width + chatPanelPoint.x,20));
		if chatTable ~= nil and chatTable ~= "" then
			setMiniGameRollInfoJump(chatTable.ActionId, chatTable.ActionParam)
		end
		profile.IM.setIMID_CHAT_ROOM_SEND_REWARD_V3TableNull()
	end
end

--[[--
--创建滚动条跳转机制
--]]
function setMiniGameRollInfoJump(actionId, status)
	local button = ccs.button({
		scale9 = false,
		size = CCSizeMake(500,41),
		pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		text = "",
		capInsets = CCRectMake(0, 0, 0, 0),
		listener = {
			[ccs.TouchEventType.began] = function(uiwidget)
			end,
			[ccs.TouchEventType.moved] = function(uiwidget)
			end,
			[ccs.TouchEventType.ended] = function(uiwidget)
				--通过ActionId，判断是否为同趣小妹跳转小游戏ID
				if  actionId == 0 then
				--老虎机GameID
				elseif actionId ==  ID_FRUIT_MACHINE then
					if status == 1 then
						--水果机
						if GameLoadModuleConfig.getFruitIsExists() then
							GameConfig.setTheLastBaseLayer(GUI_HALL)
							mvcEngine.createModule(GUI_MINIGAME_FRUIT_MACHINE, LordGamePub.runSenceAction(HallLogic.view,nil,true))
						else
							Common.showToast("资源加载中，请稍候…",2)
						end
					elseif status== 2 then
						Common.showToast("您还没有解锁",2)
					elseif status == 3 then
						Common.showToast("您的金币不足",2)
					end

					--金皇冠GameID
				elseif actionId ==  ID_JIN_HUANG_GUAN then
					--金皇冠
					if status == 1 then
						if GameLoadModuleConfig.getJinHuangGuanIsExists() then
							GameConfig.setTheLastBaseLayer(GUI_HALL)
							mvcEngine.createModule(GUI_JINHUANGUAN, LordGamePub.runSenceAction(HallLogic.view,nil,true))
						else
							Common.showToast("资源加载中，请稍候…",2)
						end
					elseif status == 2 then
						Common.showToast("您还没有解锁",2)
					elseif status == 3 then
						Common.showToast("您的金币不足",2)
					end

					--万人金花GameID
				elseif actionId ==  ID_WAN_REN_JIN_HUA then
					if status == 1 then
						if GameLoadModuleConfig.getWanRenJinHuaIsExists() then
							sendJHROOMID_MINI_JINHUA_ENTER_GAME()
							sendJHGAMEID_MINI_JINHUA_HELP() -- 预先获取万人金花帮助信息
							sendJHGAMEID_MINI_JINHUA_HISTORY() -- 预先获取万人金花历史信息
						else
							Common.showToast("资源加载中，请稍候…",2)
						end
					elseif status == 2 then
						Common.showToast("您还没有解锁",2)
					elseif status == 3 then
						Common.showToast("您的金币不足",2)
					end
					--万人水果派
				elseif actionId ==  ID_WAN_REN_FRUIT_MACHINE then
					if status == 1 then
						--万人水果机
						if GameLoadModuleConfig.getWanRenFruitIsExists() then
							sendWRSGJ_INFO(0) --发送基本信息 INFO
							GameConfig.setTheLastBaseLayer(GUI_HALL)
							mvcEngine.createModule(GUI_WRSGJ, LordGamePub.runSenceAction(HallLogic.view,nil,true))
						else
							Common.showToast("资源加载中，请稍候…",2)
						end
					elseif status == 2 then
						Common.showToast("您还没有解锁",2)
					elseif status == 3 then
						Common.showToast("您的金币不足",2)
					end
					--扎金花
				elseif actionId ==  ID_JIN_HUA then
					if status == 1 then
						--炸金花
						if GameLoadModuleConfig.getJinHuaIsExists() then
							sendJHID_ENTER_JH_MINI();--发送进入扎金花大厅消息(服务器不回)
							sendJINHUA_ROOMID_ROOM_LIST(profile.JinHuaRoomData.getTimeStamp());--发送扎金花房间列表消息
							GameConfig.setTheLastBaseLayer(GUI_HALL);
							mvcEngine.createModule(GUI_JINHUAHALL);
						else
							Common.showToast("资源加载中，请稍候…",2)
						end
					elseif status == 2 then
						Common.showToast("您还没有解锁",2)
					elseif status == 3 then
						Common.showToast("您的金币不足",2)
					end
				end
			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
				Common.log("Touch Cancel")
			end,
		}
	})
	labelNotice:setFontSize(25);
	labelNotice:setColor(ccc3(196,186,168));
	labelNotice:setAnchorPoint(ccp(0,0.4));
	labelNotice:setTag(TAG_LABEL_NOTICE);
	labelNotice:setPosition(ccp(chatPanelSize.width + chatPanelPoint.x,20));
	button:setColor(ccc3(196,186,168));
	button:setAnchorPoint(ccp(0,0.4));
	button:setPosition(ccp(chatPanelSize.width + chatPanelPoint.x-600,20));
	button:setScaleX(8)
	panel_chat:addChild(labelNotice);
	panel_chat:addChild(button);
end

--[[--
--显示系统公告
--]]
function showSystemNotice()
	--一条系统公告
	Common.log("MINI_showSystemNotice")
	local systemNotice =  profile.SystemListNotice.getOneSystemNotice();
	local DuiJiangTable = profile.MiniGame.getMinigame_DuiJiang_Table();
	local miniGameRewardInfo = profile.IM.getIMID_CHAT_ROOM_SEND_REWARD_V3Table();

	if (systemNotice == "" or systemNotice == nil) and ( DuiJiangTable == nil or DuiJiangTable == "") then
		Common.log("MINI_showSystemNotice==========1")
		if miniGameRewardInfo == nil or miniGameRewardInfo == "" then
			Common.log("MINI_showSystemNotice==========2")
			hidePanelChatAnimation();
			return;
		end
	else
		panel_chat:setVisible(true);
	end
	if systemNotice ~= ""  then
		--系统公告
		MiniGame_Duijiang = 1
	elseif DuiJiangTable ~= nil and DuiJiangTable ~= "" then
		--小游戏赢钱公告

		MiniGame_Duijiang = 2
	elseif miniGameRewardInfo ~= nil and miniGameRewardInfo ~= "" then
		--小游戏赢彩金公告（比倍>=5次）
		MiniGame_Duijiang = 3
	end
	if MiniGame_Duijiang == 1 then
		--label的宽
		local textLenWidth = string.len(systemNotice) * ONE_WORD_WIDTH;
		--创建系统公告label
		createSystemNoticeLabe(systemNotice,textLenWidth);
		if labelNotice == nil then
			return;
		end
		--播放系统公告
		local moveBy =  CCMoveBy:create(NOTICE_MOVE_TIME*textLenWidth,ccp(-chatPanelPoint.x -textLenWidth-chatPanelSize.width,0))
		local headActioArray = CCArray:create()
		headActioArray:addObject(moveBy)
		headActioArray:addObject(CCCallFuncN:create(showSystemNotice))
		labelNotice:runAction(CCSequence:create(headActioArray))
	elseif MiniGame_Duijiang == 2 then
		systemNotice =  profile.MiniGame.getMinigame_DuiJiang_Table().."   点这里强势进入！"
		--label的宽
		local textLenWidth = string.len(systemNotice) * ONE_WORD_WIDTH;
		--创建系统公告label
		createSystemNoticeLabe(systemNotice,textLenWidth);
		if labelNotice == nil then
			return;
		end
		--播放系统公告
		local moveBy =  CCMoveBy:create(NOTICE_MOVE_TIME*textLenWidth,ccp(-chatPanelPoint.x -textLenWidth-chatPanelSize.width,0))
		local headActioArray = CCArray:create()
		headActioArray:addObject(moveBy)
		headActioArray:addObject(CCCallFuncN:create(showSystemNotice))
		labelNotice:runAction(CCSequence:create(headActioArray))
	elseif MiniGame_Duijiang == 3 then
		systemNotice = profile.IM.getIMID_CHAT_ROOM_SEND_REWARD_V3Table().SpeechText
		--label的宽
		local textLenWidth = string.len(systemNotice) * ONE_WORD_WIDTH;
		--创建系统公告label
		createSystemNoticeLabe(systemNotice,textLenWidth);
		if labelNotice == nil then
			return;
		end
		--播放系统公告
		local moveBy =  CCMoveBy:create(NOTICE_MOVE_TIME*textLenWidth,ccp(-chatPanelPoint.x -textLenWidth-chatPanelSize.width,0))
		local headActioArray = CCArray:create()
		headActioArray:addObject(moveBy)
		headActioArray:addObject(CCCallFuncN:create(showSystemNotice))
		labelNotice:runAction(CCSequence:create(headActioArray))
	end
end

function sendMessageInfo()
	sendDBID_V2_GET_CONVERSATION_LIST(0,10)
end

--判断是否有新的可兑奖奖品,如果有,就显示叹号
function getMANAGERID_GET_EXCHANGBLE_AWARDS()
	local hasNewExchangbleAwards = profile.Prize.getHaveExchangbleAwards()
	if hasNewExchangbleAwards == true then
	--createTanHaoByTag(btn_gift)
	end
end

function setTime()
	if(caishenDaojishi >= 1000)then
		caishenDaojishi = caishenDaojishi - 1000;
	else
		caishenDaojishi = 0;
	end
	local sounds = ((caishenDaojishi/1000)%60) - ((caishenDaojishi/1000)%60)%1
	local minute = ((caishenDaojishi/60000)%60) - ((caishenDaojishi/60000)%60)%1
	local ours = (caishenDaojishi/(1000*3600)) - (caishenDaojishi/(1000*3600))%1
	local oursString = ours > 9 and tostring(ours) or ("0" .. ours)
	local minuteString = minute > 9 and tostring(minute) or ("0" .. minute)
	local soundsString = sounds > 9 and tostring(sounds) or ("0" .. sounds)
	minuteString = minuteString + (60 * ours);
	if LabelAtlas_DaoJiShi ~= nil then
		LabelAtlas_DaoJiShi:setStringValue(minuteString..":"..soundsString)
	end
	--最后三秒进行时间同步
	if(ours == 0 and minute == 0 and sounds < 3 and sounds > 0)then
		--请求财神时间同步
		sendFORTUNE_TIME_SYNC()
	end

end

--[[--
--显示财神骨骼动画
--]]
function showCaiShenArmature()
	if HallButtonManage.getButtonEntity(HallButtonConfig.BTN_ID_CAI_SHEN) ~= nil then
		local CaiShenPosition = btn_caishen:getParent():convertToWorldSpace(btn_caishen:getPosition());
		HallButtonManage.getButtonEntity(HallButtonConfig.BTN_ID_CAI_SHEN):setDecorativeAnimStatus(true);
		HallButtonManage.getButtonEntity(HallButtonConfig.BTN_ID_CAI_SHEN):showDecorativeAnimation(view,CaiShenPosition.x, CaiShenPosition.y);
		btn_caishen:setVisible(false)
		GanTanHao:setVisible(true)
	end
end

--[[--
--隐藏财神骨骼动画
--]]
function hideCaiShenArmature()
	if HallButtonManage.getButtonEntity(HallButtonConfig.BTN_ID_CAI_SHEN) ~= nil then
		HallButtonManage.getButtonEntity(HallButtonConfig.BTN_ID_CAI_SHEN):setDecorativeAnimStatus(false);
		HallButtonManage.getButtonEntity(HallButtonConfig.BTN_ID_CAI_SHEN):removeDecorativeAnimation(view)
		btn_caishen:setVisible(true)
		GanTanHao:setVisible(false)
		btn_caishen:setOpacity(255)
	end
end

function getFORTUNE_TIME_SYNCInfo()
	local dataTable = profile.CaiShen.getFORTUNE_TIME_SYNCTable();
	if(GameConfig.getHallShowMode() ~= MODE_HALL) then
		return;
	end

	--如果panel_top动画在播,则播完动画才能更新财神数据
	if isPanelTopAnimationPlay then
		table.insert(hasChangeCaiShenData,getFORTUNE_TIME_SYNCInfo);
		return;
	end

	if(dataTable["IsOpenFortune"] == 1)then
		caishenDaojishi = dataTable["AwardTime"];
		if(caishenDaojishi > 0)then
			LabelAtlas_DaoJiShi:setVisible(true)
			--隐藏财神骨骼动画
			--hideCaiShenArmature();
		else
			--显示财神骨骼动画
			--showCaiShenArmature();
			LabelAtlas_DaoJiShi:setVisible(false)
		end
	else
		LabelAtlas_DaoJiShi:setVisible(false)
		--隐藏财神骨骼动画
		--hideCaiShenArmature();
	end
end

function getFORTUNE_GET_INFORMATIONInfo()
	if(GameConfig.getHallShowMode() ~= MODE_HALL)then
		return;
	end

	--如果panel_top动画在播,则播完动画才能更新财神数据
	if isPanelTopAnimationPlay then
		table.insert(hasChangeCaiShenData,getFORTUNE_GET_INFORMATIONInfo);
		return;
	end

	if(profile.CaiShen.getFORTUNE_GET_INFORMATIONTable()["FreeAward"] == 1)then
		--是否可以免费领取;0：不可以；1：可以
		--显示财神骨骼动画
		--showCaiShenArmature();
		LabelAtlas_DaoJiShi:setVisible(false);
	elseif(profile.CaiShen.getFORTUNE_TIME_SYNCTable()["IsOpenFortune"] ~= 1)then
		--是否开启财神活动;0：未开启；1：开启
		LabelAtlas_DaoJiShi:setVisible(false);
	--隐藏财神骨骼动画
	--hideCaiShenArmature();
	else
		--倒计时
		caishenTimeSynchronization();
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

function sendMessageInfo()
	sendDBID_V2_GET_CONVERSATION_LIST(0,10)
end

--多少条未读信息
function slot_GetMessageList()
	local allnotreadmsg = 0
	MessageTable["MessageList"] = profile.Message.getMessageTable()

	Common.log("首页大厅未读信息是"..allnotreadmsg)
	--站内信未读

	if(profile.Message.getUserMessage_no_ReadCount() + profile.Message.getSystemMessage_no_ReadCount() > 0 or profile.Message.getisHallMessage_isRed() == true ) then
		createTanHaoByTag(btn_message)

	else
		profile.Message.setisHallMessage_isRed()
		removeTanHaoByTag(btn_message)
	end
end

--[[
function getMATID_START_NOTIFYInfo()
local table = profile.Match.getMATID_START_NOTIFYTable()
Common.showToast(table.Msg,2)
sendMATID_ENTER_MATCH(table.MatchInstanceID)
end
]]

--获取剩余门票
isgetMenPiaoFirst = true

function getMANAGERID_GET_UNUSED_TICKET_CNTInfo()
	local table = profile.Pack.getMANAGERID_GET_UNUSED_TICKET_CNTTable()
	if(isgetMenPiaoFirst)then
		isgetMenPiaoFirst = false
		menpiaoNum = table.number
	end
	menpiaoNum = table.number
end

--获取商城是否有新礼包
function getGIFTBAGID_NEWGIFT_TYPEInfo()
	local table = profile.Gift.getGIFTBAGID_NEWGIFT_TYPETable()
	if(table["result"] == 1)then
		local gantanhao = LordGamePub.getGanTanHao()
		gantanhao:setAnchorPoint(ccp(0,0))
		--createTanHaoByTag(btn_shop)
	end
end

--获取通用配置信号方法
function getDBID_GET_SERVER_CONFIG()
	if Common.getOperater() == Common.CHINA_MOBILE then
		--如果是移动的话,获取手机钱包正则表达式配置
		local PurseConfigTable = profile.ServerConfig.getServerConfigDataTable(ServerConfig.LORD_DENY_SMS_LIST) --获取服务器返回的table
		Common.log("PurseConfigTable.VarValue is ".. PurseConfigTable.VarValue)
		if PurseConfigTable ~= nil then
			--调用java方法存储正则表达式
			Common.SavePurseRegex(PurseConfigTable)
		end
	end
end

--[[--
--被踢消息接收,跳入大厅页面并且弹出被踢提示框
--]]
local function readBeKickOut()
	Common.log("readBeKickOut")
	if profile.TableKick.getIsShowBeKick() == true then
		Common.log("readBeKickOut in true")
		CommDialogConfig.showBeKickedView()
		profile.TableKick.setIsShowBeKick(false)
	end
end

--[[--
--财神按钮的显示和隐藏
--]]
function showOrHideCaiShenBtn()
	--财神按钮可用 and 财神装饰动画正在show
	if HallButtonManage.getButtonDecorativeAnimStatus(HallButtonConfig.BTN_ID_CAI_SHEN) then
		showCaiShenArmature();
	end
end

--[[--
--大厅动画结束后回调方法
--]]
function hallAnimationEndCallBack()
	--如果有新的button数据
	if hasChangeBtnStatusData then
		hasChangeBtnStatusData = false;
		--更新button列表
		updateButtonData();
	else
		--更新大厅中部的按钮状态
		HallButtonManage.updateMiddleButtonStatus();
		--显示大厅中部按钮骨骼动画
		HallButtonManage.showButttonArmatureOnMiddle(view);
	end
end

--[[--
--按钮更新动画
--@param #number buttonID 按钮ID
--]]
function showBtnUpdataAnim(buttonID)
	--解锁动画正在进行
	isUnlockAnimationPlay = true;
	--隐藏大厅骨骼动画
	GameArmature.hideHallBtnArmature();
	mvcEngine.createModule(GUI_HALLCOVER);
	HallCoverLogic.coverHallByBtnId(buttonID);
end

function setLastLayer(flag)
	isLastLayer = flag;
end

function setHaveCertificate(flag)
	isHaveCertificate = flag
end
--[[--
--判断是否弹出VIP礼包或者绑定手机
--]]
function logicVipGiftAndBindPhoneNumber()
	Common.log("isVIPSend")
	if isHaveCertificate then
		--有奖状弹出
		isHaveCertificate = false;
		Common.log("tanchuangjiangzhuang")
		return
	end
	Common.log("tanchuangkaishi")	if isLastLayer then
		isLastLayer = false;
		--如果上一层是牌桌
		if profile.VIPState.getVipStatus() == 2	and isVIPSend()   then
			--优惠状态
			Common.log("isVIPSend")
			local array = CCArray:create()
			array:addObject(CCDelayTime:create(3))
			array:addObject(CCCallFuncN:create(sendGiftThenFist))
			local seq = CCSequence:create(array);
			view:runAction(seq);
		elseif CommShareConfig.MinLimitCoin ~= nil and tonumber(profile.User.getSelfCoin()) <= CommShareConfig.MinLimitCoin then
			local array = CCArray:create()
			array:addObject(CCDelayTime:create(3))
			array:addObject(CCCallFuncN:create(
				function()
					if HallGiftShowLogic.isShow == false then
						CommShareConfig.selectRedGiftShareType()
					end
				end
			))
			local seq = CCSequence:create(array);
			view:runAction(seq);

		else
			local array = CCArray:create()
			array:addObject(CCDelayTime:create(3))
			array:addObject(CCCallFuncN:create(bindingphone))
			local seq = CCSequence:create(array);
			view:runAction(seq);
		end
	end
end

--[[--
--更新按钮数据
--]]
function updateButtonData()
	--如果当前不是大厅或panel_hall的动画正在进行, 不更新
	if GameConfig.getHallShowMode() ~= MODE_HALL or isPanelHallAnimationPlay == true then
		hasChangeBtnStatusData = true;
		return;
	end

	--更新按钮数据
	HallButtonManage.updateButtonEntityData();

	local changeBtnIDTable = profile.ButtonsStatus.getChangeBtnIDTable();
	if changeBtnIDTable == nil or #changeBtnIDTable == 0 then
		--没有改变状态的按钮
		--发送财神消息
		sendCaiShenMsg();
		--更新按钮属性(状态、位置)
		HallButtonManage.updateButtonProperty();
		--显示大厅中部骨骼动画
		HallButtonManage.showButttonArmatureOnMiddle(view);
		--判断是否弹出VIP礼包或者绑定手机
		logicVipGiftAndBindPhoneNumber();
	else
		--按钮更新动画   播放财神动画
		showBtnUpdataAnim(changeBtnIDTable[1]);
	end
end

--[[--
--发送转盘消息
--]]
function sendTurnTableMessage()
	--发送转盘基本信息消息
	sendTURNTABLE_BASIC_INFO(profile.LuckyTurnTable.getTurnTableBasicInfoTimeStamp());
end

--[[--
--发送新手任务是否完成消息
--]]
function sendNewUserTaskIsComplete()
	if(CommDialogConfig.getNewUserTaskFinish() == false)then
		--新手任务未完成
		sendCOMMONS_V3_NEWUSER_TASK_IS_COMPLETE();
	end
end

--[[--
--设置显示新手任务
--]]
function showRenWuLogic()
	NewUserGuideLogic.setDaliyFalg(false)
	RenWuLogic.setJumpRenWu(true);
	sendCOMMONS_V3_NEWUSER_TASK_IS_COMPLETE();
end

--[[--
--新手任务同步消息
--]]
function getCOMMONS_V3_NEWUSER_TASK_IS_COMPLETE()
	local NewUserIsComplete = profile.RenWu.getNEWUSER_TASK_IS_COMPLETE();
	if NewUserIsComplete.taskNum ~= nil and NewUserIsComplete.taskNum < 0 then
		--如果是-1代表全部都完成并且已领奖
		Common.setDataForSqlite(CommSqliteConfig.NewUserTaskIsEnd..profile.User.getSelfUserID(),1);
	end
end

--获取新手引导方案
function getNewUserGuideScheme()
	sendCOMMONS_SYN_NEWUSERGUIDE_STATE();
end

--[[--
--获取大厅模式数值
--]]
function getHallModeValue()
	return MODE_HALL;
end

--[[--
--新手引导完成后,出现的提示点击快速开始的箭头
--]]
function promptClickQuickStartBtn()
	isNewUserGuideArrowShow = true;

	if ImageVie_Arrow == nil or panel_hall:getChildByTag(TAG_ARROW) == nil then
		ImageVie_Arrow = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_gerenziliao_tianti_level_schedule.png"),
		});
	end

	--出现在右边指向"快速开始"
	local position  = btn_quickstart:getPosition();
	ImageVie_Arrow:setPosition(ccp(ARROW_X * GameConfig.ScaleAbscissa, position.y));
	ImageVie_Arrow:setRotation(-180);
	ImageVie_Arrow:setTag(TAG_ARROW);
	ImageVie_Arrow:setTouchEnabled(false);
	panel_hall:addChild(ImageVie_Arrow);

	local array = CCArray:create()
	array:addObject(CCMoveBy:create(0.25, ccp(25,0)))
	array:addObject(CCMoveBy:create(0.25, ccp(-25,0)))
	ImageVie_Arrow:runAction(CCRepeatForever:create(CCSequence:create(array)));
end

--[[--
--根据大小创建发光的背景
--@param #number height 精灵的高(宽)
--@param #number x X轴
--@param #number y Y轴
--@param #number buttonID 按钮ID
--]]
local function createBgLightByPosition( x, y, buttonID)
	local lightSprite = ccs.image({
		scale9 = true,
		image = Common.getResourcePath("light.png"),
	--		size = CCSizeMake(height, height),
	});

	lightSprite:setAnchorPoint(ccp(0.5,0.5))
	lightSprite:setPosition(ccp(x, y));
	lightSprite:setTag(TAG_LIGHT_BG);
	lightSprite:setZOrder(ZOrderLow);
	lightSprite:setTouchEnabled(false);

	if buttonID == HallButtonConfig.BTN_ID_CAI_SHEN then
		--财神
		lightSprite:setScale(0.8);
		panel_top:addChild(lightSprite);
	else
		--比赛赢奖、疯狂闯关
		lightSprite:setScale(1.5);
		panel_hall:addChild(lightSprite);
	end
	return lightSprite;
end

--[[--
--显示开启的按钮
--@param #CCButton ui 按钮
--]]
local function displayOnTheButton(ui)
	ui:setVisible(true);
	ui:setZOrder(ZOrderHigh);
	ui:setTouchEnabled(true);
end

--[[--
--显示发光背景动画
--@param #number buttonID 按钮ID
--]]
local function showLightBgAmin(buttonID)
	--回调旋转发光按钮
	local function callBack()
		if bg_Light ~= nil then
			bg_Light:stopAllActions();
			bg_Light:runAction(CCRepeatForever:create(CCRotateBy:create(5,360)));
		end

		--如果解锁动画已经结束,则更新位置
		if not isUnlockAnimationPlay then
			--更新按钮属性(状态、位置)
			HallButtonManage.updateButtonProperty();
			--显示开启的按钮骨骼动画
			HallButtonManage.showButttonArmatureOnMiddle(view);
			--发送财神消息
			sendCaiShenMsg();
		end
	end

	local uiPosition = HallButtonManage.getButtonCurrentPosition(buttonID);
	bg_Light = createBgLightByPosition( uiPosition.x, uiPosition.y, buttonID);

	--step3：移动结束后,停顿5/24秒后背景发光开始旋转
	local delay = CCDelayTime:create(HallCoverLogic.getTimeTable().DELAY_TO_LIGHT_TIME);
	--step4：背景发光旋转
	local funcRun = CCCallFuncN:create(callBack);
	local arr = CCArray:create();
	arr:addObject(delay);
	arr:addObject(funcRun);
	local seq = CCSequence:create(arr);
	bg_Light:runAction(seq);
end

--[[--
--回调显示比赛赢奖
--@param #CCButton ui 按钮
--@param #number bgScale 背景变大的倍数
--@param #number buttonID 按钮ID
--]]
function callBackToShowButton(ui, buttonID)
	--显示按钮和发光背景
	displayOnTheButton(ui)
	--显示发光背景动画
	showLightBgAmin(buttonID);
end

--[[--
--大厅解锁动画后更新礼包数据
--]]
function updateHallGiftDataAfterUnlockAnim()
	local function callBack()
		--如果当前处于大厅模式,才显示礼包
		if GameConfig.getTheCurrentBaseLayer() == GUI_HALL and GameConfig.getHallShowMode() == MODE_HALL then
			CommDialogConfig.showGiftView();
		end
	end

	--如果有礼包数据
	if hasGiftShowDataChange then
		--需求：解锁动画完成后,2s后显示礼包
		local delay = CCDelayTime:create(2);
		local callFunc = CCCallFuncN:create(callBack);
		local arr = CCArray:create();
		arr:addObject(delay);
		arr:addObject(callFunc);
		view:runAction(CCSequence:create(arr));
		hasGiftShowDataChange = false;
	end
end

--[[--
--移除新手引导提示箭头
--]]
function removeNewUserGuideArrow()
	if ImageVie_Arrow ~= nil and panel_hall:getChildByTag(TAG_ARROW) ~= nil then
		panel_hall:removeChild(ImageVie_Arrow);
		ImageVie_Arrow = nil;
	end
end

--[[--
--移除发光的背景
--]]
function removeLightBg()
	--发光背景加在疯狂闯关和比赛赢奖后
	if bg_Light ~= nil and panel_hall:getChildByTag(TAG_LIGHT_BG) ~= nil then
		panel_hall:removeChild(bg_Light);
		bg_Light = nil;
	end

	--发光背景加在财神后
	if bg_Light ~= nil and panel_top:getChildByTag(TAG_LIGHT_BG) ~= nil then
		panel_top:removeChild(bg_Light);
		bg_Light = nil;
	end
end



--[[--
--显示红点方法
--]]
function showMANAGERID_REQUEST_REDP()
	HongDianLogic.showHallHongDian()
end



--[[--
--VIP状态信息
--]]
function showVipState()
	local viplevel = VIPPub.getUserVipType(math.abs(profile.VIPState.getVipLevel()))

	if profile.VIPState.getVipStatus() == 1 then
		--	1：开通
		btn_VIPkaitong:loadTextures(Common.getResourcePath("btn_kaitong.png"),Common.getResourcePath("btn_kaitong.png"),"")
		if GameConfig.getHallShowMode() == MODE_HALL then
			btn_VIPkaitong:setVisible(true)
			GameArmature.hideVipSaleArmature()
		end
		ImageView_vip:loadTexture(Common.getResourcePath("hall_vip_icon_no.png"))
		maskImageView:setVisible(true)
		LabelAtlas_viplevel:setProperty("0",Common.getResourcePath("num_vip_level.png"), 12, 19,"0")
	elseif profile.VIPState.getVipStatus() == 2 then
		--2：优惠
		btn_VIPkaitong:loadTextures(Common.getResourcePath("btn_youhui.png"),Common.getResourcePath("btn_youhui.png"),"")
		if GameConfig.getHallShowMode() == MODE_HALL and not isPanelTopAnimationPlay then
			--当前大厅且动画已经播放完毕
			btn_VIPkaitong:setVisible(false)
			GameArmature.showVipSaleArmature(view, 230, 503)
		end
		if profile.VIPState.getVipLevel() >= 0 then
			ImageView_vip:loadTexture(Common.getResourcePath("hall_vip_icon.png"))
			maskImageView:setVisible(false)
			LabelAtlas_viplevel:setProperty("0",Common.getResourcePath("num_vip_level.png"), 12, 19,"0")
		else
			ImageView_vip:loadTexture(Common.getResourcePath("hall_vip_icon_no.png"))
			maskImageView:setVisible(true)
			LabelAtlas_viplevel:setProperty("0",Common.getResourcePath("num_vip_level.png"), 12, 19,"0")
		end
		LabelAtlas_viplevel:setStringValue(viplevel)
	elseif profile.VIPState.getVipStatus() == 3 then
		--3：续费
		btn_VIPkaitong:loadTextures(Common.getResourcePath("btn_xufei.png"),Common.getResourcePath("btn_xufei.png"),"")
		if GameConfig.getHallShowMode() == MODE_HALL then
			btn_VIPkaitong:setVisible(true)
			GameArmature.hideVipSaleArmature()
		end
		if profile.VIPState.getVipLevel() >= 0 then
			ImageView_vip:loadTexture(Common.getResourcePath("hall_vip_icon.png"))
			maskImageView:setVisible(false)
			LabelAtlas_viplevel:setProperty("0",Common.getResourcePath("num_vip_level.png"), 12, 19,"0")
		else
			ImageView_vip:loadTexture(Common.getResourcePath("hall_vip_icon_no.png"))
			maskImageView:setVisible(true)
			LabelAtlas_viplevel:setProperty("0",Common.getResourcePath("num_vip_level.png"), 12, 19,"0")
		end
		LabelAtlas_viplevel:setStringValue(viplevel)
	elseif profile.VIPState.getVipStatus() == 4 then
		-- 4:空白
		hideVipStatusIcon()
		ImageView_vip:loadTexture(Common.getResourcePath("hall_vip_icon.png"))
		maskImageView:setVisible(false)
		LabelAtlas_viplevel:setProperty("0",Common.getResourcePath("num_vip_level.png"), 12, 19,"0")
		LabelAtlas_viplevel:setStringValue(viplevel)
	end
end

function showVipGift()
	local vipGiftTable = profile.VIPState.getAlert_INFO();
	local vipResult = vipGiftTable["Result"]
	local vipResultText = vipGiftTable["ResultText"]
	if vipResult == 2 then --请求失败
		Common.showToast(vipResultText, 2)
	end
end
--[[--
--存储最后登录日期
--]]
function SaveLastDay()

	if Common.platform == Common.TargetAndroid then
		--android平台
		Common.log("sharedApplicationmacTargetAndroid")
		local LastDay =  ""..os.date("*t",os.time()).day
		local javaClassName = "com.tongqu.client.utils.AlarmUtils"
		local javaMethodName = "luaCallSetLastDay"
		local javaParams = {
			LastDay,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end
--[[--
--创建闹钟
--]]
function createAlarm(NotificationID,BeforeMillions,ActionID,Title,Content)
	Common.log("sharedApplicationmac")
	if Common.platform == Common.TargetAndroid then
		--android平台
		Common.log("sharedApplicationmacTargetAndroid")
		local str_NotificationID =  NotificationID..""
		local str_BeforeMillions =  BeforeMillions..""
		local str_ActionID = ActionID..""
		local str_Title = Title..""
		local str_Content =  Content..""
		local javaClassName = "com.tongqu.client.utils.AlarmUtils"
		local javaMethodName = "luaCallSetAlarmUtils"
		local javaParams = {
			str_NotificationID,
			str_BeforeMillions,
			str_ActionID,
			str_Title,
			str_Content,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end
--[[--
--删除闹钟
--]]
function removeAlarm(NotificationID)
	if Common.platform == Common.TargetAndroid then
		--android平台
		Common.log("sharedApplicationmacTargetAndroidre")

		local str_NotificationID = NotificationID+5000
		local str_NotificationID2 = str_NotificationID..""
		local javaClassName = "com.tongqu.client.utils.AlarmUtils"
		local javaMethodName = "luaCallRemoveAlarm"
		local javaParams = {
			str_NotificationID2,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end
--[[--
--释放界面的私有数据
--]]
function releaseData()
	Common.log("重置大厅数据")
	RoomTable = {}
	RoomTable["rooms"] = {}
	RoomTable["getUpdataRoomCnt"] = -1
	MiniGame_TanKuang = true
	--释放比赛列表数据
	MatchList.releaseData()
	--是否按钮数据
	HallButtonManage.clearData();
	--清除按钮状态数据,必须清,否则第一次开启就会出现按钮位置出错
	profile.ButtonsStatus.clearChangeButtonData();
	HongDianLogic.setHongDian_local_FuLi()
	--打开比赛
	isOpenSelectMatchInfo = 0
	openMatchName = ""
end

--[[--
--红包分享领取奖励结果
--]]
function getSharingReward()
	CommShareConfig.setRedGiftShareReceiveRewardEnabled(false)
	local SharingRewardTable = profile.ShareToWX.getSharingRewardTable()
	if SharingRewardTable == nil then
		return
	end
	local result = SharingRewardTable.result

	if result == 0 then
		Common.showToast("领奖失败!您今天已经领取过一次奖励了哟~", 2)
	else
		ImageToast.createView(nil,Common.getResourcePath("ic_recharge_guide_jinbi.png"),"x" .. result,"领取奖励成功",2)
	end
end

--[[--
--新用户首次红包分享领取奖励结果
--]]
function getNewUserFirstSharingReward()
	local rewardTable = profile.RedGiftShare.getOPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD()
	if rewardTable == nil then
		return
	end

	if rewardTable["Result"] == 1 then
		for i = 1, #rewardTable["RewardLoop"] do
			ImageToast.createView(rewardTable["RewardLoop"][i]["PrizeUrl"],nil, rewardTable["RewardLoop"][i]["PrizeDes"], "成功领取",  2)
		end
	elseif rewardTable["Result"] == 2 then
		Common.log("领奖失败！")
	end
end

--[[--
--设置MiniGame_TanKuang
--]]
function setMiniGameTanKuang(flag)
	MiniGame_TanKuang = flag
end

--[[--
--绑定手机
--@param #number buttonID 按钮ID
--]]
function bindingphone()
	if MiniGame_TanKuang == true then
		Common.log("tanchuang006")
		local MiniGame_TanKuang_table = Common.LoadShareTable("MiniGame_TanKuang")
		local MiniGame_TanKuang = os.date("*t",os.time())
		if MiniGame_TanKuang_table ~= nil then
			if MiniGame_TanKuang_table.day ~= MiniGame_TanKuang.day then
				sendMINI_COMMON_RECOMMEND()
				Common.SaveShareTable("MiniGame_TanKuang",MiniGame_TanKuang)
			end
		else
			sendMINI_COMMON_RECOMMEND()
			Common.SaveShareTable("MiniGame_TanKuang",MiniGame_TanKuang)
		end
	end
end
function addSlot()
	--framework.addSlot2Signal(MATID_REG_MATCH, MatchList.reg_match)--进入比赛
	--framework.addSlot2Signal(GAMEID_REG_MATCH, MatchList.reg_match)--进入比赛
	--framework.addSlot2Signal(MATID_REFUND, MatchList.refund_match)--退赛
	--framework.addSlot2Signal(MATID_V2_MATCH_LIST_SYNC, MatchList.math_sync)--比赛同步，是否报名
	--framework.addSlot2Signal(MATID_MATCH_CONDITIONS, MatchList.math_condition)--报名条件，是否能报名
	--framework.addSlot2Signal(MATID_ENTER_MATCH, MatchList.getMATID_ENTER_MATCHInfo)
	framework.addSlot2Signal(MINI_COMMON_RECOMMEND, back_MINI_COMMON_RECOMMEND)
	framework.addSlot2Signal(DBID_USER_INFO, updataUserInfo)
	framework.addSlot2Signal(ROOMID_ROOM_LIST_NEW, updateRoomTable)
	framework.addSlot2Signal(IMID_GET_LAST_CHAT_ROOM_SPEAK, frashChatMassageCallback)
	--	framework.addSlot2Signal(IMID_GET_LAST_CHAT_ROOM_SPEAK, frashChatMassageCallback)
	framework.addSlot2Signal(MANAGERID_GET_SYSTEM_LIST_NOTICE, showSystemNotice)
	framework.addSlot2Signal(MINI_COMMON_WINNING_RECORD, showSystemNotice)
	framework.addSlot2Signal(IMID_CHAT_ROOM_SPEAK, HallChatLogic.addChatToList)
	framework.addSlot2Signal(FORTUNE_TIME_SYNC,getFORTUNE_TIME_SYNCInfo)
	framework.addSlot2Signal(DBID_V2_GET_CONVERSATION_LIST, slot_GetMessageList)--站内信
	--framework.addSlot2Signal(MATID_START_NOTIFY,getMATID_START_NOTIFYInfo)
	framework.addSlot2Signal(BASEID_GET_BASEINFO, updataEditUserInfo)
	framework.addSlot2Signal(FORTUNE_GET_INFORMATION,getFORTUNE_GET_INFORMATIONInfo)
	framework.addSlot2Signal(MANAGERID_GET_UNUSED_TICKET_CNT,getMANAGERID_GET_UNUSED_TICKET_CNTInfo)
	framework.addSlot2Signal(GIFTBAGID_NEWGIFT_TYPE,getGIFTBAGID_NEWGIFT_TYPEInfo) --是否有新礼包
	framework.addSlot2Signal(DBID_GET_SERVER_CONFIG,getDBID_GET_SERVER_CONFIG)
	framework.addSlot2Signal(ROOMID_PLAYER_BE_KICKED_OUT, readBeKickOut)
	framework.addSlot2Signal(MANAGERID_GET_EXCHANGBLE_AWARDS,getMANAGERID_GET_EXCHANGBLE_AWARDS)--获取可兑奖的奖品列表

	framework.addSlot2Signal(MATID_V4_MATCH_LIST, MatchList.updateMatchTable)
	framework.addSlot2Signal(MATID_V4_MATCH_SYNC, MatchList.match_sync_V4)
	framework.addSlot2Signal(MATID_V4_REG_MATCH, MatchList.reg_match_V4)
	framework.addSlot2Signal(MATID_V4_REFUND, MatchList.refund_match_V4)

	framework.addSlot2Signal(MANAGERID_GET_BUTTONS_STATUS, updateButtonData)--按钮状态
	framework.addSlot2Signal(COMMONS_V3_NEWUSER_TASK_IS_COMPLETE, getCOMMONS_V3_NEWUSER_TASK_IS_COMPLETE)--新手任务是否完成
	framework.addSlot2Signal(COMMONS_GET_NEWUSERGUIDE_SCHEME, getNewUserGuideScheme)--新手引导方案

	framework.addSlot2Signal(USERS_MONTH_SIGN_BASIC_INFO, MessagesPreReadManage.processUSERS_MONTH_SIGN_BASIC_INFO);	--用户月签基本信息
	--	framework.addSlot2Signal(MANAGERID_GET_HAVE_NEW_GONGGAO, MessagesPreReadManage.processMANAGERID_GET_HAVE_NEW_GONGGAO);--获取新公告
	--	framework.addSlot2Signal(MANAGERID_GET_HAVE_NEW_HUODONG, MessagesPreReadManage.processMANAGERID_GET_HAVE_NEW_HUODONG);--获取新活动
	framework.removeSlotFromSignal(OPERID_GET_DAILY_NOTIFY_INFO, showMeiRiGongGao)
	framework.addSlot2Signal(MANAGERID_REQUEST_REDP, showMANAGERID_REQUEST_REDP) --显示红点回调

	framework.addSlot2Signal(MANAGERID_VIPV2_TIP_INFO, showVipState)
	framework.addSlot2Signal(MANAGERID_VIPV2_GET_GIFTBAG, showVipGift)
	framework.addSlot2Signal(VIP_GIFT_AND_BIND_PHONE_NUMBER, logicVipGiftAndBindPhoneNumber);--礼包或者绑定手机号通知
	framework.addSlot2Signal(OPERID_REQUEST_GAME_SHARING_REWARD, getSharingReward)
	framework.addSlot2Signal(OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD, getNewUserFirstSharingReward)
	framework.addSlot2Signal(IMID_CHAT_ROOM_SEND_REWARD_V3, HallChatLogic.addChatToList())
end
--每日公告
function showMeiRiGongGao()
	MessagesPreReadManage.createDailyLoginPromptView()
end

function back_MINI_COMMON_RECOMMEND()
	mvcEngine.createModule(GUI_MINIGAMEGUIDETANCHUKUANG)
end

function removeSlot()
	--移除大厅按钮骨骼动画
	GameArmature.removeHallBtnArmature(view);
	GameArmature.removeVipSaleArmature(view)
	if LabelAtlas_DaoJiShi ~= nil then
		LabelAtlas_DaoJiShi:stopAllActions();
	end
	--时间定时器
	if (lookTimer) then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
	end

	HallChatLogic.initAllChatData()


	sendIMID_QUIT_CHAT_ROOM()
	framework.removeSlotFromSignal(MINI_COMMON_RECOMMEND, back_MINI_COMMON_RECOMMEND)
	--framework.removeSlotFromSignal(MATID_REG_MATCH, MatchList.reg_match)--进入比赛
	--framework.removeSlotFromSignal(GAMEID_REG_MATCH, MatchList.reg_match)--进入比赛
	--framework.removeSlotFromSignal(MATID_REFUND, MatchList.refund_match)--退赛
	--framework.removeSlotFromSignal(MATID_V2_MATCH_LIST_SYNC, MatchList.math_sync)--比赛同步
	--framework.removeSlotFromSignal(MATID_MATCH_CONDITIONS, MatchList.math_condition)--报名条件
	--framework.removeSlotFromSignal(MATID_ENTER_MATCH, MatchList.getMATID_ENTER_MATCHInfo)
	--framework.removeSlotFromSignal(MATID_MATCH_LIST_NEW, MatchList.updateMatchTable)

	framework.removeSlotFromSignal(DBID_USER_INFO, updataUserInfo)
	--framework.removeSlotFromSignal(ROOMID_ROOM_LIST_NEW,updateRoomTable)
	--framework.removeSlotFromSignal(MATID_MATCH_LIST_NEW,updateMatchTable)
	framework.removeSlotFromSignal(IMID_GET_LAST_CHAT_ROOM_SPEAK, frashChatMassageCallback)

	framework.removeSlotFromSignal(ROOMID_ROOM_LIST_NEW, updateRoomTable)
	framework.removeSlotFromSignal(MANAGERID_GET_SYSTEM_LIST_NOTICE, showSystemNotice)
	framework.removeSlotFromSignal(MINI_COMMON_WINNING_RECORD, showSystemNotice)
	--	framework.removeSlotFromSignal(IMID_GET_LAST_CHAT_ROOM_SPEAK, frashChatMassageCallback)

	framework.removeSlotFromSignal(IMID_CHAT_ROOM_SPEAK, HallChatLogic.addChatToList)
	framework.removeSlotFromSignal(FORTUNE_TIME_SYNC,getFORTUNE_TIME_SYNCInfo)
	framework.removeSlotFromSignal(DBID_V2_GET_CONVERSATION_LIST, slot_GetMessageList)
	--framework.removeSlotFromSignal(MATID_START_NOTIFY,getMATID_START_NOTIFYInfo)
	framework.removeSlotFromSignal(BASEID_GET_BASEINFO, updataEditUserInfo)
	framework.removeSlotFromSignal(FORTUNE_GET_INFORMATION,getFORTUNE_GET_INFORMATIONInfo)
	framework.removeSlotFromSignal(MANAGERID_GET_UNUSED_TICKET_CNT,getMANAGERID_GET_UNUSED_TICKET_CNTInfo)
	framework.removeSlotFromSignal(GIFTBAGID_NEWGIFT_TYPE,getGIFTBAGID_NEWGIFT_TYPEInfo)
	framework.removeSlotFromSignal(DBID_GET_SERVER_CONFIG,getDBID_GET_SERVER_CONFIG)
	framework.removeSlotFromSignal(ROOMID_PLAYER_BE_KICKED_OUT, readBeKickOut)
	framework.removeSlotFromSignal(MANAGERID_GET_EXCHANGBLE_AWARDS,getMANAGERID_GET_EXCHANGBLE_AWARDS)

	framework.removeSlotFromSignal(MATID_V4_MATCH_LIST, MatchList.updateMatchTable)
	framework.removeSlotFromSignal(MATID_V4_MATCH_SYNC, MatchList.match_sync_V4)
	framework.removeSlotFromSignal(MATID_V4_REG_MATCH, MatchList.reg_match_V4)
	framework.removeSlotFromSignal(MATID_V4_REFUND, MatchList.refund_match_V4)

	framework.removeSlotFromSignal(MANAGERID_GET_BUTTONS_STATUS, updateButtonData)--按钮状态

	framework.removeSlotFromSignal(COMMONS_V3_NEWUSER_TASK_IS_COMPLETE, getCOMMONS_V3_NEWUSER_TASK_IS_COMPLETE)--新手任务是否完成
	framework.removeSlotFromSignal(COMMONS_GET_NEWUSERGUIDE_SCHEME, getNewUserGuideScheme)--新手引导方案MANAGERID_REQUEST_REDP
	framework.removeSlotFromSignal(MANAGERID_REQUEST_REDP, showMANAGERID_REQUEST_REDP)--红点消息释放

	framework.removeSlotFromSignal(USERS_MONTH_SIGN_BASIC_INFO, MessagesPreReadManage.processUSERS_MONTH_SIGN_BASIC_INFO);--用户月签基本信息
	--	framework.removeSlotFromSignal(MANAGERID_GET_HAVE_NEW_GONGGAO, MessagesPreReadManage.processMANAGERID_GET_HAVE_NEW_GONGGAO);--获取新公告
	--	framework.removeSlotFromSignal(MANAGERID_GET_HAVE_NEW_HUODONG, MessagesPreReadManage.processMANAGERID_GET_HAVE_NEW_HUODONG);--获取新活动
	framework.removeSlotFromSignal(OPERID_GET_DAILY_NOTIFY_INFO, showMeiRiGongGao)
	framework.removeSlotFromSignal(MANAGERID_VIPV2_TIP_INFO, showVipState)
	framework.removeSlotFromSignal(MANAGERID_VIPV2_GET_GIFTBAG, showVipGift)
	framework.removeSlotFromSignal(VIP_GIFT_AND_BIND_PHONE_NUMBER, logicVipGiftAndBindPhoneNumber);--礼包或者绑定手机号通知
	framework.removeSlotFromSignal(OPERID_REQUEST_GAME_SHARING_REWARD, getSharingReward)
	framework.removeSlotFromSignal(OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD, getNewUserFirstSharingReward)
	framework.removeSlotFromSignal(IMID_CHAT_ROOM_SEND_REWARD_V3, HallLogic.showSystemNotice)
end
