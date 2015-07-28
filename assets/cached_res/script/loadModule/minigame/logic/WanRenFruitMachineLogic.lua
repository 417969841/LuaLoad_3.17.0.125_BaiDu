module("WanRenFruitMachineLogic",package.seeall)

view = nil;

Panel_all = nil;--
Panel_message = nil;--广播信息
Label_name1 = nil;--广播下注人名字1
Label_xiazhu1 = nil;--广播下注Lable1
Label_fruit1 = nil;--广播下注水果1
Label_coin1 = nil;--广播下注金币1
Label_name2 = nil;--广播下注人名字2
Label_xiazhu2 = nil;--广播下注Lable2
Label_fruit2 = nil;--广播下注水果2
Label_coin2 = nil;--广播下注金币2
Label_name_me = nil;--广播下注人名字3
Label_xiazhu_me = nil;--广播下注Lable3
Label_fruit_me = nil;--广播下注水果3
Label_coin_me = nil;--广播下注金币3
Image_touxiang = nil;--用户自己头像
Image_vip = nil;--VIP
Label_nicheng = nil;--用户昵称
Image_coin = nil;--用户金币
AtlasLabel_vip_level = nil;--VIP等级
Panel_xiazhu = nil;--
Button_xiazhu = nil;--下注按钮
Image_xiazhu = nil;--”单注“字
AtlasLabel_danjia = nil;--下注价格
Image_xiazhudanwei = nil;--下注单位
Button_xuya = nil;--续压按钮
Panel_buttonxiazhu = nil;--下注水果按钮面板
Button_xiazhu_orange = nil;--橘子
Button_xiazhu_pawpaw = nil;--木瓜
Button_xiazhu_bell = nil;--铃铛
Button_xiazhu_seven = nil;--双7
Button_xiazhu_apple = nil;--苹果
Button_xiazhu_watermelon = nil;--西瓜
Button_xiazhu_star = nil;--双星
Button_xiazhu_bar = nil;--bar
Panel_shuzhi = nil;--用户下注信息
Label_all_orange = nil;--橘子所有下注金额
Label_zj_orange = nil;--橘子用户下注金额
Label_zj_pawpaw = nil;--木瓜用户下注金额
Label_all_pawpaw = nil;--木瓜所有下注金额
Label_zj_bell = nil;--铃铛用户下注金额
Label_all_bell = nil;--铃铛所有下注金额
Label_all_seven = nil;--双7所有下注金额
Label_zj_seven = nil;--双7用户下注金额
Label_zj_apple = nil;--苹果用户下注金额
Label_all_apple = nil;--苹果所有下注金额
Label_all_watermelon = nil;--西瓜所有下注金额
Label_zj_watermelon = nil;--西瓜用户下注金额
Label_zj_star = nil;--双星用户下注金额
Label_all_star = nil;--双星所有下注金额
Label_zj_bar = nil;--bar用户下注金额
Label_all_bar = nil;--bar所有下注金额
Panel_xiaoxi = nil;--
Label_gonggao = nil;--公告框
Panel_jiesuan = nil;--结算页面面板
Label_nicheng1 = nil;--第1名昵称
Label_nicheng2 = nil;--第2名昵称
Label_nicheng3 = nil;--第3名昵称
Label_nicheng4 = nil;--第4名昵称
Label_nicheng5 = nil;--第5名昵称
AtlasLabel_jiesuan = nil;--用户赢得金币
Image_zijitis = nil;--用户赢的字体图片
AtlasLabel_getcoin1 = nil;--第1名赢的金币数
AtlasLabel_getcoin2 = nil;--第2名赢的金币数
AtlasLabel_getcoin3 = nil;--第3名赢的金币数
AtlasLabel_getcoin4 = nil;--第4名赢的金币数
AtlasLabel_getcoin5 = nil;--第5名赢的金币数
Panel_jinbi = nil;--用户金币面板
AtlasLabel_coin = nil;--用户金币
Button_addgod = nil;--添加金币按钮
Panel_lishi = nil;--历史记录面板
Image_cover = nil;--覆盖层
Image_new = nil;--
Panel_daojis = nil;--倒计时面板
Image_zhuanpan = nil;--倒计时文字
AtlasLabel_time = nil;--倒计时
Panel_back = nil;--返回面板
Button_fanhui = nil;--返回
Button_talk = nil;--
chatTextFeild = nil;--
Button_gift = nil;--

local ONE_CELL_WIDTH = 80;--奖品所在的ImageView的宽
local ONE_CELL_HEIGHT = 70;--奖品所在的ImageView的高
local FIRST_CELL_X = 330;--第一个格的X 330;
local FIRST_CELL_Y = 445;--第一个格的Y 445;
local lookTimer = nil --时间计时器
local turntableNode = nil --水果转盘层
local doubleTextureY = nil --转盘倍数纹理[黄]
local doubleTextureG = nil --转盘倍数纹理[灰]
local doubleTextureR = nil --转盘倍数纹理[红]
local lightframe = nil --创建光标
local islightframe = false  --判断光标是否在转
local isbet = 1  --押注状态下是否可以押注
local lightlayer = nil  --留下光标层

local betRadio={};  --下注广播
local continueBet = {} --续押
local betTable = {} --押注表
local userBetMsg = {} --用户押注信息
local allCellPositionTable = {} --转盘位置
local betOfOne = 1 --单注选项   1, 2 ,3 ,4 ,5
local betOfOneSend = 200 --推送单注
local localbettime  =  999  --本地押注倒计时
local localalltime  =  0  --本地全局倒计时
local localtimeflag = 0 --本地时间标记
local timeflag = 0 --标记本地倒计时为零时是否可以转圈  0：未调用   1：已调用
local isaccpetinfo = 0 --是否接受INFO基本信息
local isaccpetMsgBack = 0;  --是否接收到起止位置信息   0：未接收，1：已接收
local cellposition = 1 --光标开始默认位置
local lowestcircle = 0 --保证最低圈数，防止还没开始转就收到信息就马上停止转圈
local isSpeedUp = 0 --是否可以加速      ： >5不允许加速
local isSpeedDown = 0 --是否可以减速
local isFirstflag = 1 --刚进来且只让被调用一次   0:不是刚进来   1:刚进来
local isFirstN = 1  --是否刚进来 0:不是  1:是
local isOneTime = 0 --保证第一次调用
local isaccpetresult = 0 --是否接收游戏结果  0:没接收到 1：已接收
local isadjustcircle = 0  -- 0:未调整圈数 1：已经调整
local WRSGJTABLE={}
WRSGJTABLE.info={} --基本信息Info
WRSGJTABLE.tongbu={}  --同步消息
WRSGJTABLE.bet={}   --押注信息
WRSGJTABLE.Result={}  --游戏结果
WRSGJTABLE.position={}  --起止位置信息
WRSGJTABLE.notice={}  --公告信息

local isaccept = 0 --是否接收基本信息
local gamestate --游戏状态(基本)
local WanRenSGJState = 0 --水果机状态（同步）     0:押注  1:开奖
local isHasSendResult = 0  --是否推送结果位置信息
local isHasstartAndStopPosition = 0 --是否推送开始位置信息
local movecircle = 4 --转动圈数
local Timestamp = 1 --时间戳
local getcoin = 1 --游戏结果自己所得金币
local getWinTable = {} --结果中的前5名赢家
local historyTable = {}  --历史记录
local historyFruitSprite = {} --历史记录精灵表格
local radiotable={} --广播表格
local startposition = 1 --移动框起始位置
local endposition = 1 --移动框终止位置
local endpositionReturn = 1   --移动框返回的终止位置
local endpositionReturnTwo = 1   --移动框返回的第二个位置
local endpositionReturnThree = 1   --移动框返回的终止位置
local endpositionTable = {} --移动框终止位置表
local lightdelayed = 0.3  --光标移动默认速度

local isnewbet = 0   --是否是新的一局押注
local continueState = 1 --续压状态    1 亮     2 暗
local xuyabetflag = 0  --点击续压按钮标记  0：未点击  1：已点击
local betstateflag = 1  --押注状态标记
local resultstateflag = 1  --结果状态标记
local nextstartposition = 1  --下局开始位置计数
local resultCountdown = 30  --结果倒计时
local animationflag = 1  -- 前五名赢金币动画标记
local animationTransferflag = 1  --转移金币动画标记
local coinOfme = 0 --自己金币数
local isFirstMoveEnd = 0  --转圈结束阶段让调用一次
local positionSubtract = 0  --结束位置与当前位置的差值
local isReturn = 0  --0:转圈结束阶段在范围外  1：在范围内
for i=1, 5 do  --初始化结果中的前5名赢家
	getWinTable[i] = {}
	getWinTable[i].Name = ""
	getWinTable[i].Coin = 0
	getWinTable[i].VipLevel = 1
end
local isFirstNFlag = true  --第一次调用标识
--local isSYCNBetState = false

local FruitTabel={}
FruitTabel[1]="【苹果】"
FruitTabel[2]="【橙子】"
FruitTabel[3]="【木瓜】"
FruitTabel[4]="【铃铛】"
FruitTabel[5]="【西瓜】"
FruitTabel[6]="【双星】"
FruitTabel[7]="【 7 7 】"
FruitTabel[8]="【 BAR 】"

local valueonezero = 0
local valuetwozero = 0
local valuethreezero = 0
local valuefourzero = 0
local valuefivezero = 0
local wincoin = 0
local mycoin = 0

local gameType = 3
isExistRewardBaseInfo = false --是否有打赏基本信息
isExistReward = false --是否有可领奖记录
RewardLevel = 100000 --打赏底数
windowSize = {}
isWRSGJFlag = false

local fruitBlinkTable ={}  --水果闪烁数组
fruitBlinkTable[1]= false	--苹果
fruitBlinkTable[2]= false	--橙子
fruitBlinkTable[3]= false	--木瓜
fruitBlinkTable[4]= false	--铃铛
fruitBlinkTable[5]= false	--西瓜
fruitBlinkTable[6]= false	--双星
fruitBlinkTable[7]= false	--77
fruitBlinkTable[8]= false	--BAR


function onKeypad(event)
	if event == "backClicked" then
		--返回键
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_all = cocostudio.getUIPanel(view, "Panel_all");
	Panel_message = cocostudio.getUIPanel(view, "Panel_message");
	Label_name1 = cocostudio.getUILabel(view, "Label_name1");
	Label_xiazhu1 = cocostudio.getUILabel(view, "Label_xiazhu1");
	Label_fruit1 = cocostudio.getUILabel(view, "Label_fruit1");
	Label_coin1 = cocostudio.getUILabel(view, "Label_coin1");
	Label_name2 = cocostudio.getUILabel(view, "Label_name2");
	Label_xiazhu2 = cocostudio.getUILabel(view, "Label_xiazhu2");
	Label_fruit2 = cocostudio.getUILabel(view, "Label_fruit2");
	Label_coin2 = cocostudio.getUILabel(view, "Label_coin2");
	Label_name_me = cocostudio.getUILabel(view, "Label_name_me");
	Label_xiazhu_me = cocostudio.getUILabel(view, "Label_xiazhu_me");
	Label_fruit_me = cocostudio.getUILabel(view, "Label_fruit_me");
	Label_coin_me = cocostudio.getUILabel(view, "Label_coin_me");
	Image_touxiang = cocostudio.getUIImageView(view, "Image_touxiang");
	Image_vip = cocostudio.getUIImageView(view, "Image_vip");
	Label_nicheng = cocostudio.getUILabel(view, "Label_nicheng");
	Image_coin = cocostudio.getUIImageView(view, "Image_coin");
	AtlasLabel_vip_level = cocostudio.getUILabelAtlas(view, "AtlasLabel_vip_level");
	Panel_xiazhu = cocostudio.getUIPanel(view, "Panel_xiazhu");
	Button_xiazhu = cocostudio.getUIButton(view, "Button_xiazhu");
	Image_xiazhu = cocostudio.getUIImageView(view, "Image_xiazhu");
	--	Image_xiazhushu = cocostudio.getUIImageView(view, "Image_xiazhushu");
	Image_xiazhudanwei = cocostudio.getUIImageView(view, "Image_xiazhudanwei");
	Button_xuya = cocostudio.getUIButton(view, "Button_xuya");
	Panel_buttonxiazhu = cocostudio.getUIPanel(view, "Panel_buttonxiazhu");
	Button_xiazhu_orange = cocostudio.getUIButton(view, "Button_xiazhu_orange");
	Button_xiazhu_pawpaw = cocostudio.getUIButton(view, "Button_xiazhu_pawpaw");
	Button_xiazhu_bell = cocostudio.getUIButton(view, "Button_xiazhu_bell");
	Button_xiazhu_seven = cocostudio.getUIButton(view, "Button_xiazhu_seven");
	Button_xiazhu_apple = cocostudio.getUIButton(view, "Button_xiazhu_apple");
	Button_xiazhu_watermelon = cocostudio.getUIButton(view, "Button_xiazhu_watermelon");
	Button_xiazhu_star = cocostudio.getUIButton(view, "Button_xiazhu_star");
	Button_xiazhu_bar = cocostudio.getUIButton(view, "Button_xiazhu_bar");
	Panel_shuzhi = cocostudio.getUIPanel(view, "Panel_shuzhi");
	Label_all_orange = cocostudio.getUILabel(view, "Label_all_orange");
	Label_zj_orange = cocostudio.getUILabel(view, "Label_zj_orange");
	Label_zj_pawpaw = cocostudio.getUILabel(view, "Label_zj_pawpaw");
	Label_all_pawpaw = cocostudio.getUILabel(view, "Label_all_pawpaw");
	Label_zj_bell = cocostudio.getUILabel(view, "Label_zj_bell");
	Label_all_bell = cocostudio.getUILabel(view, "Label_all_bell");
	Label_all_seven = cocostudio.getUILabel(view, "Label_all_seven");
	Label_zj_seven = cocostudio.getUILabel(view, "Label_zj_seven");
	Label_zj_apple = cocostudio.getUILabel(view, "Label_zj_apple");
	Label_all_apple = cocostudio.getUILabel(view, "Label_all_apple");
	Label_all_watermelon = cocostudio.getUILabel(view, "Label_all_watermelon");
	Label_zj_watermelon = cocostudio.getUILabel(view, "Label_zj_watermelon");
	Label_zj_star = cocostudio.getUILabel(view, "Label_zj_star");
	Label_all_star = cocostudio.getUILabel(view, "Label_all_star");
	Label_zj_bar = cocostudio.getUILabel(view, "Label_zj_bar");
	Label_all_bar = cocostudio.getUILabel(view, "Label_all_bar");
	Panel_xiaoxi = cocostudio.getUIPanel(view, "Panel_xiaoxi");
	Label_gonggao = cocostudio.getUILabel(view, "Label_gonggao");
	Panel_jiesuan = cocostudio.getUIPanel(view, "Panel_jiesuan");
	Label_nicheng1 = cocostudio.getUILabel(view, "Label_nicheng1");
	Label_nicheng2 = cocostudio.getUILabel(view, "Label_nicheng2");
	Label_nicheng3 = cocostudio.getUILabel(view, "Label_nicheng3");
	Label_nicheng4 = cocostudio.getUILabel(view, "Label_nicheng4");
	Label_nicheng5 = cocostudio.getUILabel(view, "Label_nicheng5");
	AtlasLabel_jiesuan = cocostudio.getUILabelAtlas(view, "AtlasLabel_jiesuan");
	Image_zijitis = cocostudio.getUIImageView(view, "Image_zijitis");
	AtlasLabel_getcoin1 = cocostudio.getUILabelAtlas(view, "AtlasLabel_getcoin1");
	AtlasLabel_getcoin2 = cocostudio.getUILabelAtlas(view, "AtlasLabel_getcoin2");
	AtlasLabel_getcoin3 = cocostudio.getUILabelAtlas(view, "AtlasLabel_getcoin3");
	AtlasLabel_getcoin4 = cocostudio.getUILabelAtlas(view, "AtlasLabel_getcoin4");
	AtlasLabel_getcoin5 = cocostudio.getUILabelAtlas(view, "AtlasLabel_getcoin5");
	Panel_jinbi = cocostudio.getUIPanel(view, "Panel_jinbi");
	AtlasLabel_coin = cocostudio.getUILabelAtlas(view, "AtlasLabel_coin");
	Button_addgod = cocostudio.getUIButton(view, "Button_addgod");
	Panel_lishi = cocostudio.getUIPanel(view, "Panel_lishi");
	Image_cover = cocostudio.getUIImageView(view, "Image_cover");
	Image_lisjilu1 = cocostudio.getUIImageView(view, "Image_lisjilu1");
	Image_lisjilu2 = cocostudio.getUIImageView(view, "Image_lisjilu2");
	Image_lisjilu3 = cocostudio.getUIImageView(view, "Image_lisjilu3");
	Image_lisjilu4 = cocostudio.getUIImageView(view, "Image_lisjilu4");
	Image_lisjilu5 = cocostudio.getUIImageView(view, "Image_lisjilu5");
	Image_new = cocostudio.getUIImageView(view, "Image_new");
	Image_lisjilu6 = cocostudio.getUIImageView(view, "Image_lisjilu6");
	Panel_daojis = cocostudio.getUIPanel(view, "Panel_daojis");
	Image_zhuanpan = cocostudio.getUIImageView(view, "Image_zhuanpan");
	AtlasLabel_time = cocostudio.getUILabelAtlas(view, "AtlasLabel_time");
	Panel_back = cocostudio.getUIPanel(view, "Panel_back");
	Button_fanhui = cocostudio.getUIButton(view, "Button_fanhui");
	AtlasLabel_danjia = cocostudio.getUILabelAtlas(view, "AtlasLabel_danjia");
	Button_talk = cocostudio.getUIButton(view, "Button_talk");
	chatTextFeild = cocostudio.getUITextField(view, "chatTextFeild");
	Button_gift = cocostudio.getUIButton(view, "Button_gift");
end


--[[--
定义声音的路径
--]]
local betSound = "xiazhu.mp3"--万人水果机下注
local CircleSound = "zhuanquan.mp3"--万人水果机转圈
local winSound1 = "zhongjiang1.mp3"--中奖1
local winSound2 = "zhongjiang2.mp3"--中奖2
local loseSound1 = "weizhongjiang1.mp3"--未中奖1
local loseSound2 = "weizhongjiang2.mp3"--未中奖2

--[[--
万人水果机资源路径
--]]
function WanRenSGJGetResources(path)
	return Common.getResourcePath("load_res/WRSGJ/" .. path)
end

--[[--
加载音乐
--]]
-- 缓存背景音乐
function preloadBackgroundMusic(file)
	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(WanRenSGJGetResources(file));
	SimpleAudioEngine:sharedEngine():preloadBackgroundMusic(FilePath)
end

-- 缓存音效
function preloadEffect(file)
	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(WanRenSGJGetResources(file));
	SimpleAudioEngine:sharedEngine():preloadEffect(FilePath)
end

-- 播放音乐
function playBackMusic(file, loop)
	if GameConfig.getGameMusicOff() then
		local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(WanRenSGJGetResources(file));
		SimpleAudioEngine:sharedEngine():playBackgroundMusic(FilePath, loop);
	end
end
-- 播放音效
function playEffect(file,loop)
	if GameConfig.getGameSoundOff() then
		local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(WanRenSGJGetResources(file));
		SimpleAudioEngine:sharedEngine():playEffect(FilePath, loop);
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("load_res/WRSGJ/WanRenFruitMachine.json");
	local gui = GUI_WRSGJ
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
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	GameConfig.setTheCurrentBaseLayer(GUI_WRSGJ)

	initView();
	view:setTouchEnabled(false)
	initWRSGJData();
end

function initWRSGJData()
	CommonControl.setMiniGameType(gameType, view) --设置游戏类型和当前view
	CommonControl.trumpetAnimation(Button_talk) --播放小喇叭动画
	--充值礼包的图片用的是公共礼包图片
	if profile.Gift.isShowFirstGiftIcon() then
		--可以购买礼包
		Button_gift:loadTextures(CommonControl.CommonControlGetResource("ic_hall_shouchong.png"),CommonControl.CommonControlGetResource("ic_hall_shouchong.png"),"")
	else
		--Common.setButtonVisible(Button_gift, false)
		--可以进行充值
		Button_gift:loadTextures(CommonControl.CommonControlGetResource("ic_hall_recharge.png"),CommonControl.CommonControlGetResource("ic_hall_recharge.png"),"")
	end
	AudioManager.stopBgMusic(true)
	AudioManager.stopAllSound()

	sendIMID_MINI_ENTER_CHAT_ROOM(gameType)
	sendIMID_MINI_REWARDS_BASEINFO(gameType)
	doubleTextureY = CCTextureCache:sharedTextureCache():addImage(WanRenSGJGetResources("num_desk_beishu1.png"))
	doubleTextureG = CCTextureCache:sharedTextureCache():addImage(WanRenSGJGetResources("num_desk_beishu2.png"))
	doubleTextureR = CCTextureCache:sharedTextureCache():addImage(WanRenSGJGetResources("num_desk_beishu3.png"))
	--	sendWRSGJ_INFO() --发送基本信息 INFO  --移到入口
	initData() --初始化押注数额
	Label_xiazhu1:setVisible(false)
	Label_xiazhu2:setVisible(false)
	Label_xiazhu_me:setVisible(false)

	for i = 1,8 do  --初始化续压
		continueBet[i] = 0
	end

	updataEditUserInfo()  --读取用户数据（金币，等级）
	getAllLotteryCellPosition(); --获取一周图片位置
	addCache()  --把音效加入缓存
end

function initData()
	Label_zj_apple:setText("0")
	Label_zj_orange:setText("0")
	Label_zj_pawpaw:setText("0")
	Label_zj_bell:setText("0")
	Label_zj_watermelon:setText("0")
	Label_zj_star:setText("0")
	Label_zj_seven:setText("0")
	Label_zj_bar:setText("0")
	Label_name1:setText("")  --广播押注用户名
	Label_fruit1:setText("")   --广播押注类型
	Label_coin1:setText("")   --广播押注金币
	Label_name2:setText("")  --广播押注用户名
	Label_fruit2:setText("")   --广播押注类型
	Label_coin2:setText("")   --广播押注金币
	Label_name_me:setText("")  --广播押注用户名
	Label_fruit_me:setText("")   --广播押注类型
	Label_coin_me:setText("")    --广播押注金币
end

--[[
--加入缓存背景音乐，音效
--]]
function addCache()
	preloadEffect(betSound)
	preloadEffect(CircleSound)
	preloadEffect(winSound1)
	preloadEffect(winSound2)
	preloadEffect(loseSound1)
	preloadEffect(loseSound2)
end

function requestMsg()

end

function callback_Panel_all(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_message(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_xiazhu(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

--[[
--单注
--]]
function callback_Button_xiazhu(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		-- Common.log("zbl ....."  ..  #turnTableFriutTable)
		betOfPer(betOfOne)  --设置单注大小
		betOfOne = betOfOne + 1
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[
--续压
--]]
function callback_Button_xuya(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		xuyabetflag = 1--已点续押按钮。不清除续押数据
		for i=1,8 do
			if continueBet[i] > 0 and continueState == 1 then    -- continueState 续押状态   1：允许续压     2：禁止续压
				sendWRSGJ_BET( i-1 ,continueBet[i])
				--				Common.log("zblw....i=" .. i-1 .. "              jin e =" .. continueBet[i])
				Button_xuya:loadTextures(WanRenSGJGetResources("btn_sgp_03_unpress.png"),WanRenSGJGetResources("btn_sgp_03_unpress.png"),"")  --换图
				Button_xuya:setTouchEnabled(false)
			end
		end

		continueState = 2   --续押状态   1：允许续压     2：禁止续压
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_buttonxiazhu(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_xiazhu_orange(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		betOneFruit(1)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_xiazhu_pawpaw(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		betOneFruit(2)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_xiazhu_bell(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		betOneFruit(3)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_xiazhu_seven(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		betOneFruit(6)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_xiazhu_apple(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		betOneFruit(0)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_xiazhu_watermelon(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		betOneFruit(4)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_xiazhu_star(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		betOneFruit(5)
	elseif component == CANCEL_UP then
	--取消

	end
end


function callback_Button_xiazhu_bar(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		betOneFruit(7)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Panel_shuzhi(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_xiaoxi(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_jiesuan(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_jinbi(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

--[[
--添加金币
--]]
function callback_Button_addgod(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.openConvertCoin()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_lishi(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_daojis(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_back(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

--[[
--返回
--]]
function callback_Button_fanhui(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.showBaseLayerAction(view)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_talk(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_gift(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if profile.Gift.isShowFirstGiftIcon() then
			--可以购买首充
			sendGIFTBAGID_GET_LOOP_GIFT(105)
		else
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
		end

	elseif component == CANCEL_UP then
	--取消

	end
end

local function callbackChatInput(valuetable)
	local dataTable = {}
	dataTable["MiniGameType"] = gameType
	if valuetable["value"] ~= nil then
		dataTable["MessageContent"] = valuetable["value"]
		sendIMID_MINI_SEND_MESSAGE(dataTable)
	end
end


--[[--
--输入框回调函数（ios）
--]]
function callback_ChatTextFeild_ios(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.showAlertInput(chatTextFeild:getStringValue(), 0, true, callbackChatInput)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--输入框回调函数（android）
--]]
function callback_ChatTextFeild(component)
	local dataTable = {}
	dataTable["MiniGameType"] = gameType
	if chatTextFeild:getStringValue() ~= nil then
		dataTable["MessageContent"] = chatTextFeild:getStringValue()
		sendIMID_MINI_SEND_MESSAGE(dataTable)
	end
end



--[[--
--更新用户信息
--]]
function updataEditUserInfo()
	local nickname = profile.User.getSelfNickName()
	local coinNum = profile.User.getSelfCoin()
	local vipLevel = VIPPub.getUserVipType(profile.User.getSelfVipLevel());
	if nickname ~= nil then
		Label_nicheng:setText(nickname)
	end
	coinOfme = coinNum
	if WanRenSGJState == 0 then
		AtlasLabel_coin:setStringValue(tostring(coinNum))
	end
	if vipLevel == 0 then
		Image_vip:loadTexture(WanRenSGJGetResources("hall_vip_icon_no.png"))
		AtlasLabel_vip_level:setProperty("0",WanRenSGJGetResources("num_vip_level0.png"), 27, 32,"0")
	else
		Image_vip:loadTexture(WanRenSGJGetResources("hall_vip_icon.png"))
		AtlasLabel_vip_level:setProperty("0",WanRenSGJGetResources("num_vip_level.png"), 27, 32,"0")
		AtlasLabel_vip_level:setStringValue(vipLevel)
	end
	local useravatorIdSD = Common.getDataForSqlite(CommSqliteConfig.SelfAvatorInSD..profile.User.getSelfUserID())
	if useravatorIdSD ~= "" and useravatorIdSD ~= nil then
		Image_touxiang:loadTexture(useravatorIdSD)
		Image_touxiang:setScale(88/Image_touxiang:getSize().height)
	end
end
--[[--
--创建一个数组，放置所有的位置坐标
--]]
function getAllLotteryCellPosition()
	--以左上角为开始(第一个格), 顺时针摆放奖品
	for cellIndex = 1 , 20 do
		allCellPositionTable[cellIndex] = {};
		if cellIndex < 8 then
			allCellPositionTable[cellIndex]["position"] = ccp(FIRST_CELL_X + ONE_CELL_WIDTH * (cellIndex - 1), FIRST_CELL_Y);
		elseif cellIndex < 12 then
			allCellPositionTable[cellIndex]["position"] = ccp(FIRST_CELL_X + ONE_CELL_WIDTH * 6, FIRST_CELL_Y - ONE_CELL_HEIGHT * (cellIndex - 7) );
		elseif cellIndex < 18 then
			allCellPositionTable[cellIndex]["position"] = ccp(FIRST_CELL_X + ONE_CELL_WIDTH * (17 - cellIndex), FIRST_CELL_Y - ONE_CELL_HEIGHT * 4 );
		else
			allCellPositionTable[cellIndex]["position"] = ccp(FIRST_CELL_X, FIRST_CELL_Y - ONE_CELL_HEIGHT * (21 - cellIndex) );
		end
	end
end

--[[--
--押注信息
--]]
function betFriut()

	WRSGJTABLE.bet=profile.WanRenSGJ.getTableWithWRSGJ_BET()
	--	Common.log("zblw...提示:  " .. WRSGJTABLE.bet["Msg"])
	if WRSGJTABLE.bet["Result"] == 1 then
		--押注成功
		if WRSGJTABLE.bet["BetType"] == 0 then
			--苹果
			continueBet[1] = WRSGJTABLE.bet["BetCount"]
			Label_zj_apple:setText(WRSGJTABLE.bet["BetCount"])
		elseif WRSGJTABLE.bet["BetType"] == 1 then
			--橙子
			continueBet[2] = WRSGJTABLE.bet["BetCount"]
			Label_zj_orange:setText(WRSGJTABLE.bet["BetCount"])
		elseif WRSGJTABLE.bet["BetType"] == 2 then
			--木瓜
			continueBet[3] = WRSGJTABLE.bet["BetCount"]
			Label_zj_pawpaw:setText(WRSGJTABLE.bet["BetCount"])
		elseif WRSGJTABLE.bet["BetType"] == 3 then
			--铃铛
			continueBet[4] = WRSGJTABLE.bet["BetCount"]
			Label_zj_bell:setText(WRSGJTABLE.bet["BetCount"])
		elseif WRSGJTABLE.bet["BetType"] == 4 then
			--西瓜
			continueBet[5] = WRSGJTABLE.bet["BetCount"]
			Label_zj_watermelon:setText(WRSGJTABLE.bet["BetCount"])
		elseif WRSGJTABLE.bet["BetType"] == 5 then
			--双星
			continueBet[6] = WRSGJTABLE.bet["BetCount"]
			Label_zj_star:setText(WRSGJTABLE.bet["BetCount"])
		elseif WRSGJTABLE.bet["BetType"] == 6 then
			--77
			continueBet[7] = WRSGJTABLE.bet["BetCount"]
			Label_zj_seven:setText(WRSGJTABLE.bet["BetCount"])
		elseif WRSGJTABLE.bet["BetType"] == 7 then
			--BAR
			continueBet[8] = WRSGJTABLE.bet["BetCount"]
			Label_zj_bar:setText(WRSGJTABLE.bet["BetCount"])
		end
		addRadio("> 您  <",FruitTabel[WRSGJTABLE.bet["BetType"]+1],WRSGJTABLE.bet["BetCount"] .. "金币")--添加自己押注广播信息
		AtlasLabel_coin:setStringValue(coinOfme)
		continueState = 2 --续押状态   1：允许续压     2：禁止续压
		Button_xuya:loadTextures(WanRenSGJGetResources("btn_sgp_03_unpress.png"),WanRenSGJGetResources("btn_sgp_03_unpress.png"),"") --换图，续压不允许
		Button_xuya:setTouchEnabled(false)
	elseif WRSGJTABLE.bet["Result"] == 2 then
		--押注失败，时间已过
		local msg = WRSGJTABLE.bet["Msg"]
		Common.showToast(msg, 2)
	elseif WRSGJTABLE.bet["Result"] == 3 then
		--押注失败，金币不足
--		mvcEngine.createModule(GUI_PAYGUIDEPROMPT)
--		PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, 2000, 0)
		local needCoin = tonumber(betOfOneSend) - tonumber(AtlasLabel_coin:getStringValue())
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, needCoin, RechargeGuidePositionID.TablePositionB)
		PayGuidePromptLogic.setEnterType(true)

	elseif WRSGJTABLE.bet["Result"] == 4 then
		--押注失败：金额超出上限
		local msg = WRSGJTABLE.bet["Msg"]
		Common.showToast(msg, 2)
	end
	allowClick()
	isbet = 1
end
--[[--
--下注广播
--]]
function xiazhuRadio()
	betRadio["xiazhu"] = profile.WanRenSGJ.getTableWithWRSGJ_RADIO()
	Label_name1:setText(betRadio["xiazhu"].username)  --广播押注用户名
	Label_fruit1:setText(FruitTabel[betRadio["xiazhu"].BetType+1])   --广播押注类型
	Label_coin1:setText(betRadio["xiazhu"].Coin .. "金币")   --广播押注金币
end

--[[--
--发送同步消息
--]]--
function setCurrentTime()
	sendWRSGJ_SYNC_MESSAGE(isHasSendResult,Timestamp)
	localtime()  --1秒调用一下本地时间
end

--[[--
--本地时间
--]]--
function localtime()
	if isaccpetinfo == 1 then
		--收到基本信息
		if WanRenSGJState == 1 and isFirstflag == 1 then
			--第一次进来是开奖状态
--			if isSYCNBetState then
--			--如果是进来是押注阶段，然后进入开奖阶段
--				isSYCNBetState = false
--				Common.log("zblsgj ....检测是否调用............")
--				return
--			end
			localbettime = 0 --将本地时间置为0
			isFirstflag = 0  --改变第一次进来标记
			forbidClick()
			moveState() --移动（押注开奖图片）状态
			AtlasLabel_time:setVisible(flase)  --再隐藏一次
			Common.showToast("开奖阶段，暂时不能下注",2)
			--判断时间执行相应选择
			Common.log("zblsgj ....检测.....................................................................................")
			if resultCountdown >18 and  resultCountdown<= 21 then
				-- 18-21秒
				--方案一
				lightdelayed = 0.3
				movecircle = 4
				startLightframeAnimation()
				Common.log("zblsgj ....检测11.......")
			elseif resultCountdown >13 and  resultCountdown<= 18 then
				--  13-18秒
				--方案二
				lightdelayed = 0.1
				movecircle = 2
				startLightframeAnimation()
				Common.log("zblsgj ....检测22.......")
			elseif resultCountdown >9 and  resultCountdown<= 13 then
				--  9-13秒
				--方案二
				lightdelayed = 0.01  --将延时设定为0.01
				movecircle = 1
				startLightframeAnimation()
			elseif resultCountdown >3 and  resultCountdown<= 9 then
				--  3-9秒
				--方案三
				if isaccpetresult == 1 then
					--已接收到结果信息
					showPanel_jiesuan()
				else
					local array = CCArray:create()
					array:addObject(CCDelayTime:create(1));--延时
					array:addObject(CCCallFuncN:create(showPanel_jiesuan))
					local seq = CCSequence:create(array);
					WanRenFruitMachineLogic.view:runAction(seq)
				end
			end
		end
		----------------前面是为刚进来且在结算状态下
		----------------后面为之后的状态
		if isFirstN ==0 then
			--不是刚进来
			Common.log("zblsgj ....检测2222222222222222222222......................................................")
			if localbettime > 0 and localbettime <= 20 then
				--本地押注时间不为0，每一秒-1
				localbettime = localbettime - 1
				AtlasLabel_time:setStringValue(localbettime)
				--显式倒计时
			elseif localbettime == 0 and isaccpetinfo == 1 and isFirstflag == 0 then
				--本地押注时间为0且已接收到基本信息且不是第一次进来 ，开始转圈
				if timeflag == 0 then
					--保证只调用一次
					replacePicture_state_demystify() --换图
					replacePicture_betFruit_OFF() --换图
					forbidClick() --禁止点击
					timeflag = 1
					movecircle = 4
					lightdelayed = 0.3
					startLightframeAnimation()
					Common.log("zblsgj ....检测33.......")
					moveState()
				end
			elseif localbettime > 20 then
			--本地时间大于20
			--没收到同步信息
			end
		end
	end
end

--[[--
--移动每个cell
--]]--
local function moveOneCell()
	if localbettime <= 0 then
		--本地时间小于等于0
		lightframe:stopAllActions()
		local array =CCArray:create()
		local move =  CCMoveTo:create(0, allCellPositionTable[cellposition % 20 + 1]["position"]);
		cellposition = cellposition + 1 --位置加1
		lowestcircle = lowestcircle + 1 --转圈格子数加1
		array:addObject(move)
		array:addObject(CCCallFuncN:create(playbetSound)); --添加音效
		array:addObject(CCDelayTime:create(lightdelayed));--延时
		--		Common.log("zbl....isSpeedUp=" .. isSpeedUp .. "   lightdelayed=" .. lightdelayed)
		if isSpeedUp <=9 and lightdelayed > 0.05 then  --前9个格子加速且保证延时大于0.03（0.03<0.05<0.06）
			lightdelayed = lightdelayed - 0.03
			isSpeedUp = isSpeedUp + 1
		end
		if isaccpetMsgBack == 1  and isadjustcircle == 0 then --如果接收到起止位置且结果位置大于两个且此局未调整
			isadjustcircle = 1
			movecircle = movecircle * 20
		end
		--		Common.log("zzz....lowestcircle=" .. lowestcircle .. "..........movecircle=" .. movecircle)
		if isaccpetMsgBack == 0  then
			array:addObject(CCCallFuncN:create(moveOneCell))
		elseif isaccpetMsgBack == 1 and lowestcircle < movecircle then
			--接收到起止位置，不够4圈  --movecircle
			if  #WRSGJTABLE.position["End"] >=2 and (movecircle/20 - #WRSGJTABLE.position["End"] + 1 >= 0) and isOneTime == 0 then
				--结束位置大于等于两个  且    转的圈数-结束位置+1大于0(eg:本该转4圈，但有2个结束位置,则应该转4-2+1=3)  且   只能调用一次
				isOneTime = 1
				movecircle = movecircle - (#WRSGJTABLE.position["End"] - 1) * 20
				Common.log("zbl..多个位置时是否正确..位置个数=" .. #WRSGJTABLE.position["End"] .. "        movecircle=" .. movecircle)
			end
			array:addObject(CCCallFuncN:create(moveOneCell))
		elseif isaccpetMsgBack == 1 and lowestcircle >= movecircle then
			--已收到起止位置信息,且转了4圈  --movecircle
			array:addObject(CCCallFuncN:create(stopLightframeAnimation)); --结束转圈
			isaccpetMsgBack = 0
		end

		local seq = CCSequence:create(array);
		lightframe:runAction(seq);
	end
end

--[[--
--结束转圈动画（方案二）
--]]--
function stopLightframeAnimation()
	lightframe:stopAllActions()
	local array =CCArray:create()
	local move =  CCMoveTo:create(0, allCellPositionTable[cellposition % 20 + 1]["position"]);
	cellposition = cellposition + 1
	array:addObject(move)
	array:addObject(CCCallFuncN:create(playbetSound)); --添加音效
	array:addObject(CCDelayTime:create(lightdelayed));--延时
	isSpeedDown = isSpeedDown + 1
	if isFirstMoveEnd == 0 then
		--进来第一次就调用
		--		Common.log("zbl....first=" .. cellposition % 20 .. "    end=" .. endposition)
		isFirstMoveEnd = 1
		positionSubtract = (endposition - ((cellposition-1)%20+1))
		if (cellposition-1) % 20 + 1 == endposition then
			--如果进来开始和结束位置就相等
			--			Common.log("qqqqq....进来位置相等")
			isReturn = 1
			array:addObject(CCCallFuncN:create(stopLightframeAnimation))
			local seq = CCSequence:create(array);
			lightframe:runAction(seq);
			return
		end
		if ((endposition - ((cellposition-1)%20+1) < 7) and (endposition - ((cellposition-1)%20+1) > 0 )) or (endposition - ((cellposition-1)%20+1) < -13) then
			--如果进来开始和结束位置就在7个范围内，多转11个格子，这里转1个
			isReturn = 1
			--			Common.log("qqqqq....进来位置<5")
			array:addObject(CCCallFuncN:create(stopLightframeAnimation))
			local seq = CCSequence:create(array);
			lightframe:runAction(seq);
			return
		end
	end
	--	if positionSubtract <= 11 and isReturn ==1 then
	if isReturn == 1 and (positionSubtract <= 11  or (positionSubtract >-14 and positionSubtract < 0))then
		--如果进来开始和结束位置就在7个范围内，多转11个格子，这里转10个
		--		Common.log("zbl....多转")
		positionSubtract = positionSubtract + 1
		array:addObject(CCCallFuncN:create(stopLightframeAnimation))
		local seq = CCSequence:create(array);
		lightframe:runAction(seq);
		return
	end
	if ((endposition - ((cellposition-1)%20+1) <= 8) and (endposition - ((cellposition-1)%20+1) >= 0) ) or (endposition - ((cellposition-1)%20+1) <= -12) then
		--开始和结束位置在8个距离内，减速
		lightdelayed = lightdelayed + 0.08
	end
	if (cellposition-1) % 20 + 1 ~= endposition then
		--当前减速位置小于结束位置
		array:addObject(CCCallFuncN:create(stopLightframeAnimation))
	else
		if #WRSGJTABLE.position["End"] >=2 then
			--结束位置大于两个
			array:addObject(CCCallFuncN:create(moveEnd));
		else
			array:addObject(CCCallFuncN:create(showResult));
			array:addObject(CCDelayTime:create(0.5));
			array:addObject(CCCallFuncN:create(judgeBlink)); --闪烁押注水果标签
			if WanRenSGJState == 1 then
				--结算状态
				local fddeIn = CCFadeIn:create(0);
				local delay = CCDelayTime:create(0.1);
				local fddeOut = CCFadeOut:create(0);
				for i = 1 , 5 do
					array:addObject(fddeOut);
					array:addObject(delay);
					array:addObject(fddeIn);
					array:addObject(delay);
				end
				array:addObject(CCDelayTime:create(1));
				array:addObject(CCCallFuncN:create(showPanel_jiesuan));
			end
		end
	end
	local seq = CCSequence:create(array);
	lightframe:runAction(seq);
end


--[[--
--开始转圈动画（方案二）
--]]--
function startLightframeAnimation()
	--	if localbettime == 0 then
	replacePicture_state_demystify()
	if isHasstartAndStopPosition == 1 then
		--已推送开始位置
		cellposition = startposition
	else
		cellposition = nextstartposition
	end
	lightframe:setPosition(allCellPositionTable[cellposition]["position"])
	lightframe:setVisible(true)
	moveOneCell()
	--	end
end

--[[--
--水果图片[按钮，历史记录]
--]]--
local FruitPicture={}
FruitPicture[1] = WanRenSGJGetResources("ic_sgp_pingguo.png")
FruitPicture[2] = WanRenSGJGetResources("ic_sgp_chengzi.png")
FruitPicture[3] = WanRenSGJGetResources("ic_sgp_mugua.png")
FruitPicture[4] = WanRenSGJGetResources("ic_sgp_lingdang.png")
FruitPicture[5] = WanRenSGJGetResources("ic_sgp_xigua.png")
FruitPicture[6] = WanRenSGJGetResources("ic_sgp_xingxing.png")
FruitPicture[7] = WanRenSGJGetResources("ic_sgp_77.png")
FruitPicture[8] = WanRenSGJGetResources("ic_sgp_bar1.png")
FruitPicture[9] = WanRenSGJGetResources("ic_sgp_luck2.png")
FruitPicture[10] = WanRenSGJGetResources("ic_sgp_luck.png")
--[[--
--水果图片[转盘]
--]]--
local FruitPicture1={}
FruitPicture1[1] = WanRenSGJGetResources("ic_sgp_pingguo1.png")
FruitPicture1[2] = WanRenSGJGetResources("ic_sgp_chengzi1.png")
FruitPicture1[3] = WanRenSGJGetResources("ic_sgp_mugua1.png")
FruitPicture1[4] = WanRenSGJGetResources("ic_sgp_lingdang1.png")
FruitPicture1[5] = WanRenSGJGetResources("ic_sgp_xigua1.png")
FruitPicture1[6] = WanRenSGJGetResources("ic_sgp_xingxing1.png")
FruitPicture1[7] = WanRenSGJGetResources("ic_sgp_771.png")
FruitPicture1[8] = WanRenSGJGetResources("ic_sgp_bar1.png")
FruitPicture1[9] = WanRenSGJGetResources("ic_sgp_luck2.png")
FruitPicture1[10] = WanRenSGJGetResources("ic_sgp_luck.png")

--[[--
--接收服务器返回来的基本消息INFO
--]]--
function processWRSGJ_INFO()
	isaccpetinfo = 1 --已接收基本信息
	view:setTouchEnabled(true)
	WRSGJTABLE.info = profile.WanRenSGJ.getTableWithWRSGJ_INFO() --获取服务器发回来的表格
	gamestate = WRSGJTABLE.info["GameState"]
	turntableNode = CCLayer:create()  --创建水果转盘层
	for i=1,#WRSGJTABLE.info["GoodsList"] do
		--创建底板
		local baseboardSprite = CCSprite:create(WanRenSGJGetResources("ui_sgp_midkuang.png"));
		baseboardSprite:setPosition(allCellPositionTable[i]["position"])
		turntableNode:addChild(baseboardSprite)
		--创建水果
		local fruitSprite = CCSprite:create(FruitPicture1[WRSGJTABLE.info["GoodsList"][i].ImageIndex+1])
		fruitSprite:setPosition(allCellPositionTable[i]["position"])
		turntableNode:addChild(fruitSprite)
		--创建倍数
		--		turntableNode:addChild(doublespritex)
		--创建数字
		if WRSGJTABLE.info["GoodsList"][i].Multiple >= 2 and WRSGJTABLE.info["GoodsList"][i].Multiple <10 then
			--1位数
			local doublespritex = nil
			local doublesprite = nil
			if WRSGJTABLE.info["GoodsList"][i].Multiple == 2 then
				doublespritex = createDouble(10,doubleTextureG)   --创建前面的"X"
				doublesprite = createDouble(WRSGJTABLE.info["GoodsList"][i].Multiple,doubleTextureG)
				--		 	elseif WRSGJTABLE.info["GoodsList"][i].Multiple == 5 then
				--		 		doublespritex = createDouble(10,doubleTextureR)   --创建前面的"X"
				--		 		doublesprite = createDouble(WRSGJTABLE.info["GoodsList"][i].Multiple,doubleTextureR)
			else
				doublespritex = createDouble(10,doubleTextureY)   --创建前面的"X"
				doublesprite = createDouble(WRSGJTABLE.info["GoodsList"][i].Multiple,doubleTextureY)
			end
			turntableNode:addChild(doublespritex)
			doublespritex:setPosition(ccp(allCellPositionTable[i]["position"].x-10,allCellPositionTable[i]["position"].y-20))
			--			local doublesprite = createDouble(WRSGJTABLE.info["GoodsList"][i].Multiple,doubleTextureR)
			doublesprite:setPosition(ccp(allCellPositionTable[i]["position"].x+10,allCellPositionTable[i]["position"].y-20))
			turntableNode:addChild(doublesprite)
		elseif WRSGJTABLE.info["GoodsList"][i].Multiple >= 10 and WRSGJTABLE.info["GoodsList"][i].Multiple <50 then
			--10到50的两位数
			local doublespritex = createDouble(10,doubleTextureY)   --创建前面的"X"
			turntableNode:addChild(doublespritex)
			doublespritex:setPosition(ccp(allCellPositionTable[i]["position"].x-20,allCellPositionTable[i]["position"].y-20))
			local tens = math.floor(WRSGJTABLE.info["GoodsList"][i].Multiple / 10 )  -- 十位
			local tenssprite = createDouble(tens,doubleTextureY)
			tenssprite:setPosition(ccp(allCellPositionTable[i]["position"].x,allCellPositionTable[i]["position"].y-20))
			turntableNode:addChild(tenssprite)
			local unit = WRSGJTABLE.info["GoodsList"][i].Multiple % 10   --个位
			local unitsprite = createDouble(unit,doubleTextureY)
			unitsprite:setPosition(ccp(allCellPositionTable[i]["position"].x+15,allCellPositionTable[i]["position"].y-20))
			turntableNode:addChild(unitsprite)
		elseif WRSGJTABLE.info["GoodsList"][i].Multiple >= 50 and WRSGJTABLE.info["GoodsList"][i].Multiple <100 then
			--50到100的两位数
			local doublespritex = createDouble(10,doubleTextureY)   --创建前面的"X"
			turntableNode:addChild(doublespritex)
			doublespritex:setPosition(ccp(allCellPositionTable[i]["position"].x-20,allCellPositionTable[i]["position"].y))
			local tens =math.floor( WRSGJTABLE.info["GoodsList"][i].Multiple / 10)   -- 十位
			local tenssprite = createDouble(tens,doubleTextureY)
			tenssprite:setPosition(ccp(allCellPositionTable[i]["position"].x,allCellPositionTable[i]["position"].y))
			turntableNode:addChild(tenssprite)
			local unit = WRSGJTABLE.info["GoodsList"][i].Multiple % 10   --个位
			local unitsprite = createDouble(unit,doubleTextureY)
			unitsprite:setPosition(ccp(allCellPositionTable[i]["position"].x+15,allCellPositionTable[i]["position"].y))
			turntableNode:addChild(unitsprite)
		elseif WRSGJTABLE.info["GoodsList"][i].Multiple >= 100 then
			--3位数
			local doublespritex = createDouble(10,doubleTextureY)   --创建前面的"X"
			turntableNode:addChild(doublespritex)
			doublespritex:setPosition(ccp(allCellPositionTable[i]["position"].x-22,allCellPositionTable[i]["position"].y))
			local hundreds =math.floor( WRSGJTABLE.info["GoodsList"][i].Multiple / 100)   --百位
			local hundredssprite = createDouble(hundreds,doubleTextureY)
			hundredssprite:setPosition(ccp(allCellPositionTable[i]["position"].x-6,allCellPositionTable[i]["position"].y))
			turntableNode:addChild(hundredssprite)
			local tens =math.floor( WRSGJTABLE.info["GoodsList"][i].Multiple % 100 / 10 ) -- 十位
			local tenssprite = createDouble(tens,doubleTextureY)
			tenssprite:setPosition(ccp(allCellPositionTable[i]["position"].x+7,allCellPositionTable[i]["position"].y))
			turntableNode:addChild(tenssprite)
			local unit = WRSGJTABLE.info["GoodsList"][i].Multiple % 100 % 10  --个位
			local unitsprite = createDouble(unit,doubleTextureY)
			unitsprite:setPosition(ccp(allCellPositionTable[i]["position"].x+20,allCellPositionTable[i]["position"].y))
			turntableNode:addChild(unitsprite)
		end
	end
	--  历史记录
	for i=1, #WRSGJTABLE.info["HistoryList"] do
		historyTable[i] = WRSGJTABLE.info["HistoryList"][i].ImageIndex + 1
	end
	createHistory()  --创建历史记录控件
	showResult() --显示里面的控件
	lightframe = CCSprite:create(WanRenSGJGetResources("ui_sgp_zhuanpan01.png"));  --创建光标
	lightframe:setPosition(ccp(FIRST_CELL_X,FIRST_CELL_Y))
	turntableNode:addChild(lightframe)
	lightframe:setVisible(false)
	view:addChild(turntableNode)
	if gamestate == 0 then
		--押注状态
		showturntable()
		Common.log("zbl............进入押注状态")
	elseif gamestate == 1 then
		--开奖状态
		Common.log("zbl............进入开奖状态")
		Common.log("zbl............isHasSendResult===" .. isHasSendResult)
	end
	--  押注表
	for i=1,#WRSGJTABLE.info["Raise"] do
		betTable[i] =  WRSGJTABLE.info["Raise"][i].coin
	end
	--  用户押注信息
	--	Common.log("zblmm .... 容量 = " .. #WRSGJTABLE.info["BetCoin"])
	for i=1,#WRSGJTABLE.info["BetCoin"] do
		userBetMsg[i] =  WRSGJTABLE.info["BetCoin"][i].coin
		--		Common.log("zblmm .... userBetMsg = " .. userBetMsg[i])
	end

	isaccept = 1  --已接收基本信息
	AtlasLabel_coin:setStringValue(coinOfme)  --设置自己金币
	showRadioMsg()  --显示广播信息
end
--[[--
--接收服务器返回来的同步信息
--]]--
function processWRSGJ_SYNC_MESSAGE()
	WRSGJTABLE.tongbu = profile.WanRenSGJ.getTableWithWRSGJ_SYNC_MESSAGE() --获取服务器发回来的表格
	if localtimeflag == 0 then
		--调用一次  （当用户退出页面再次进来）
		localbettime = WRSGJTABLE.tongbu["CountZero"]  --每一轮更新本地押注倒计时
		localalltime = WRSGJTABLE.tongbu["countdown"]  --每一轮更新全局押注倒计时
		localtimeflag = 1
	end
	WanRenSGJState = WRSGJTABLE.tongbu["State"]
	if WanRenSGJState == 0 and isaccept ==1 then
		--押注状态且已接收基本信息
		--showturntable()   --之后优化了删除
		if betstateflag == 1 then
			--押注状态标记(保证后面的只调用一次)
			if resultstateflag == 0 then
				--结果状态
				resultstateflag =1
				animationflag = 1
				animationTransferflag = 1
				AtlasLabel_coin:setStringValue(coinOfme)
				Image_zhuanpan:loadTexture(WanRenSGJGetResources("ui_sgp_yaz.png"))  --替换成"押注时间"图片
			end
			for i=1,5 do   --清空前五名
				getWinTable[i].Name = ""
				getWinTable[i].Coin = 0
			end
			localbettime = WRSGJTABLE.tongbu["CountZero"]  --每一轮更新本地押注倒计时
			localalltime = WRSGJTABLE.tongbu["countdown"]  --每一轮更新全局押注倒计时
			sendWRSGJ_NOTICE(1)
--			isHaveAward()
--			isSYCNBetState = true
			isaccpetMsgBack = 0
			lowestcircle = 0
			isSpeedUp = 0 --是否可以加速      ： >5不允许加速
			isSpeedDown = 0 --是否可以减速
			isnewbet = 1 --新的一局押注
			xuyabetflag = 0
			movecircle = 4
			isFirstN = 0
			isaccpetresult = 0
			isadjustcircle = 0
			isFirstMoveEnd = 0
			positionSubtract = 0
			isReturn = 0
			isOneTime = 0
			initData(); --重新一轮，将押注数额初始化为0 广播信息初始化为0
			hideBetMSG()
			moveStateBack()
			showBetFruitLable()
			initBlinkFruit()
			isHasSendResult = 0 --在押注状态设置为未推送
			isHasstartAndStopPosition = 0
			playEffect(betSound, false)
			showturntable()
			islightframe = false
			--lightframe:setVisible(false)
			allowClick()   --允许点击BUTTON
			isbet = 1
			timeflag = 0
			continueState = 1 --续押状态   1：允许续压     2：禁止续压
			Image_new:setVisible(false)
			if isFirstflag ~= 1 then
				--不是刚进来
				if profile.WanRenSGJ.WRSGJ_SYNC_MESSAGE_RADIOTable ~= nil then
					--广播数组不为空
					profile.WanRenSGJ.WRSGJ_SYNC_MESSAGE_RADIOTable = {}  --置空广播数组
				end
			end
			replacePicture_betFruit_ON()
			Button_xuya:loadTextures(WanRenSGJGetResources("btn_sgp_03.png"),WanRenSGJGetResources("btn_sgp_03.png"),"") --续压允许
			Button_xiazhu:loadTextures(WanRenSGJGetResources("btn_sgp_02.png"),WanRenSGJGetResources("btn_sgp_02.png"),"")  --单注允许改变
			betstateflag = 0
		end
	elseif WanRenSGJState == 1 and isaccept ==1 then
		--开奖状态且已收到基本信息
		if resultstateflag == 1 then
			--结果状态为1
			if betstateflag == 0 then
				betstateflag = 1
			end
			resultstateflag = 0
			forbidClick()  --禁止点击BUTTON
			hideBetMSG()
		end
	end
	Label_all_apple:setText(WRSGJTABLE.tongbu["Raise"][1].coin)
	Label_all_orange:setText(WRSGJTABLE.tongbu["Raise"][2].coin)
	Label_all_pawpaw:setText(WRSGJTABLE.tongbu["Raise"][3].coin)
	Label_all_bell:setText(WRSGJTABLE.tongbu["Raise"][4].coin)
	Label_all_watermelon:setText(WRSGJTABLE.tongbu["Raise"][5].coin)
	Label_all_star:setText(WRSGJTABLE.tongbu["Raise"][6].coin)
	Label_all_seven:setText(WRSGJTABLE.tongbu["Raise"][7].coin)
	Label_all_bar:setText(WRSGJTABLE.tongbu["Raise"][8].coin)
	Common.log("zbl......结果界面倒计时" .. WRSGJTABLE.tongbu["countdown"])
	resultCountdown = WRSGJTABLE.tongbu["countdown"]
	Timestamp = WRSGJTABLE.tongbu["Timestamp"] --更新时间戳
	if isaccept == 1 and isFirstNFlag then
		userBetMsgInfo()
		isFirstNFlag = false
	end
end

--[[--
--第一轮转圈结束，加入第二轮
--]]--
function moveEnd()
	lightframe:stopAllActions();
	if #WRSGJTABLE.position["End"] >=2 then  --返回结束位置大于2
		if (endposition == 6 or endposition == 15) and WanRenSGJState == 1 then
			--结束位置在6或者15，且状态为结算状态
			local function callBackReturn()
				playLightframeAnimationReturn(endposition,endpositionReturn )
			end
			local fddeIn = CCFadeIn:create(0);
			local delay = CCDelayTime:create(0.2);
			local fddeOut = CCFadeOut:create(0);
			local callFuncN = CCCallFuncN:create(callBackReturn);
			local arr = CCArray:create();
			arr:addObject(fddeOut);
			arr:addObject(delay);
			arr:addObject(fddeIn);
			arr:addObject(delay);
			arr:addObject(fddeOut);
			arr:addObject(delay);
			arr:addObject(fddeIn);
			arr:addObject(callFuncN);
			lightframe:runAction(CCSequence:create(arr));
			local lightframeleave = CCSprite:create(WanRenSGJGetResources("ui_sgp_zhuanpan01.png"));  --留下光标
			lightframeleave:setPosition(lightframe:getPosition())
			lightlayer:addChild(lightframeleave)
	end
	end
end

--[[--
--第二轮转圈结束，加入第三轮
--]]--
function moveEndTwo()
	lightframe:stopAllActions();
	if #WRSGJTABLE.position["End"] >=3 and WanRenSGJState == 1 then
		--结束位置至少是3个，且为结算状态
		local function callBackReturnTwo()
			playLightframeAnimationReturnTwo(endpositionReturn,endpositionReturnTwo );
		end
		local fddeIn = CCFadeIn:create(0);
		local delay = CCDelayTime:create(0.2);
		local fddeOut = CCFadeOut:create(0);
		local callFunc = CCCallFuncN:create(callBackReturnTwo);
		local arr = CCArray:create();
		arr:addObject(fddeOut);
		arr:addObject(delay);
		arr:addObject(fddeIn);
		arr:addObject(delay);
		arr:addObject(fddeOut);
		arr:addObject(delay);
		arr:addObject(fddeIn);
		arr:addObject(callFunc);
		lightframe:runAction(CCSequence:create(arr));
		local lightframeleave = CCSprite:create(WanRenSGJGetResources("ui_sgp_zhuanpan01.png"));  --留下光标
		lightframeleave:setPosition(lightframe:getPosition())
		lightlayer:addChild(lightframeleave)
	end
end
--[[--
--第三轮转圈结束，加入第四轮
--]]--
function moveEndThree()
	lightframe:stopAllActions();
	if #WRSGJTABLE.position["End"] >=4 and WanRenSGJState == 1 then
		--结束位置至少是4个，且为结算状态
		local function callBackReturnThree()
			playLightframeAnimationReturnThree(endpositionReturnTwo,endpositionReturnThree );
		end
		local fddeIn = CCFadeIn:create(0);
		local delay = CCDelayTime:create(0.2);
		local fddeOut = CCFadeOut:create(0);
		local callFunc = CCCallFuncN:create(callBackReturnThree);
		local arr = CCArray:create();
		arr:addObject(fddeOut);
		arr:addObject(delay);
		arr:addObject(fddeIn);
		arr:addObject(delay);
		arr:addObject(fddeOut);
		arr:addObject(delay);
		arr:addObject(fddeIn);
		arr:addObject(callFunc);
		lightframe:runAction(CCSequence:create(arr));
		local lightframeleave = CCSprite:create(WanRenSGJGetResources("ui_sgp_zhuanpan01.png"));  --留下光标
		lightframeleave:setPosition(lightframe:getPosition())
		lightlayer:addChild(lightframeleave)
	end
end

--[[--
--开始第二轮转圈
--]]--
function playLightframeAnimationReturn(startpoint,endpoint)
	lightframe:stopAllActions()
	local array =CCArray:create()
	local delayed = 0.07
	if endpoint < startpoint then
		for i=1, startpoint-endpoint+1 do
			local move =  CCMoveTo:create(0, allCellPositionTable[startpoint-i+1]["position"]);
			array:addObject(move)
			array:addObject(CCCallFuncN:create(playbetSound)); --添加音效
			array:addObject(CCDelayTime:create(delayed));
		end
	else
		for i=1, startpoint do
			local move =  CCMoveTo:create(0, allCellPositionTable[startpoint-i+1]["position"]);
			array:addObject(move)
			array:addObject(CCCallFuncN:create(playbetSound)); --添加音效
			array:addObject(CCDelayTime:create(delayed));
		end
		if endpoint >= startpoint then
			for i=1, 20-endpoint+1 do
				local move =  CCMoveTo:create(0, allCellPositionTable[20-i+1]["position"]);
				array:addObject(move)
				array:addObject(CCCallFuncN:create(playbetSound)); --添加音效
				array:addObject(CCDelayTime:create(delayed));
			end
		end
	end

	if #WRSGJTABLE.position["End"] >=3 then
		array:addObject(CCCallFuncN:create(moveEndTwo));
	else
		array:addObject(CCCallFuncN:create(showResult));
		array:addObject(CCDelayTime:create(0.5));
		if WanRenSGJState == 1 then
			local fddeIn = CCFadeIn:create(0);
			local delay = CCDelayTime:create(0.1);
			local fddeOut = CCFadeOut:create(0);
			for i = 1 , 5 do
				array:addObject(fddeOut);
				array:addObject(delay);
				array:addObject(fddeIn);
				array:addObject(delay);
			end
			array:addObject(CCDelayTime:create(1));
			array:addObject(CCCallFuncN:create(showPanel_jiesuan));
		end
	end

	local seq = CCSequence:create(array);
	lightframe:runAction(seq);

end
--[[--
--开始第三轮转圈
--]]--
function playLightframeAnimationReturnTwo(startpoint,endpoint)
	lightframe:stopAllActions()
	local array =CCArray:create()
	local delayed = 0.05
	array:addObject(CCDelayTime:create(0.5));

	if endpoint < startpoint then
		for i=1, startpoint-endpoint+1 do
			local move =  CCMoveTo:create(0, allCellPositionTable[startpoint-i+1]["position"]);
			array:addObject(move)
			array:addObject(CCCallFuncN:create(playbetSound)); --添加音效
			array:addObject(CCDelayTime:create(delayed));
		end
	else
		for i=1, startpoint do
			local move =  CCMoveTo:create(0, allCellPositionTable[startpoint-i+1]["position"]);
			array:addObject(move)
			array:addObject(CCCallFuncN:create(playbetSound)); --添加音效
			array:addObject(CCDelayTime:create(delayed));
		end
		if endpoint >= startpoint then
			for i=1, 20-endpoint+1 do
				local move =  CCMoveTo:create(0, allCellPositionTable[20-i+1]["position"]);
				array:addObject(move)
				array:addObject(CCCallFuncN:create(playbetSound)); --添加音效
				array:addObject(CCDelayTime:create(delayed));
			end
		end
	end
	if #WRSGJTABLE.position["End"] >=4 then
		array:addObject(CCCallFuncN:create(moveEndThree));
	else
		array:addObject(CCCallFuncN:create(showResult));
		array:addObject(CCDelayTime:create(0.5));
		if WanRenSGJState == 1 then
			local fddeIn = CCFadeIn:create(0);
			local delay = CCDelayTime:create(0.1);
			local fddeOut = CCFadeOut:create(0);
			for i = 1 , 5 do
				array:addObject(fddeOut);
				array:addObject(delay);
				array:addObject(fddeIn);
				array:addObject(delay);
			end
			array:addObject(CCDelayTime:create(1));
			array:addObject(CCCallFuncN:create(showPanel_jiesuan));
		end
	end
	local seq = CCSequence:create(array);
	lightframe:runAction(seq);
end
--[[--
--开始第四轮转圈
--]]--
function playLightframeAnimationReturnThree(startpoint,endpoint)
	lightframe:stopAllActions()
	local array =CCArray:create()
	local delayed = 0.05
	array:addObject(CCDelayTime:create(0.5));
	if endpoint < startpoint then
		for i=1, startpoint-endpoint+1 do
			local move =  CCMoveTo:create(0, allCellPositionTable[startpoint-i+1]["position"]);
			array:addObject(move)
			array:addObject(CCCallFuncN:create(playbetSound)); --添加音效
			array:addObject(CCDelayTime:create(delayed));
		end
	else
		for i=1, startpoint do
			local move =  CCMoveTo:create(0, allCellPositionTable[startpoint-i+1]["position"]);
			array:addObject(move)
			array:addObject(CCCallFuncN:create(playbetSound)); --添加音效
			array:addObject(CCDelayTime:create(delayed));
		end
		if endpoint >= startpoint then
			for i=1, 20-endpoint+1 do
				local move =  CCMoveTo:create(0, allCellPositionTable[20-i+1]["position"]);
				array:addObject(move)
				array:addObject(CCCallFuncN:create(playbetSound)); --添加音效
				array:addObject(CCDelayTime:create(delayed));
			end
		end
	end
	array:addObject(CCCallFuncN:create(showResult));
	array:addObject(CCDelayTime:create(0.5));
	if WanRenSGJState == 1 then
		local fddeIn = CCFadeIn:create(0);
		local delay = CCDelayTime:create(0.1);
		local fddeOut = CCFadeOut:create(0);
		for i = 1 , 5 do
			array:addObject(fddeOut);
			array:addObject(delay);
			array:addObject(fddeIn);
			array:addObject(delay);
		end
		array:addObject(CCDelayTime:create(1));
		array:addObject(CCCallFuncN:create(showPanel_jiesuan));
	end
	local seq = CCSequence:create(array);
	lightframe:runAction(seq);
end
--[[--
--创建历史记录控件
--]]
function createHistory()
	for i=1,6 do
		historyFruitSprite[i] = ccs.image({
			scale9 = false,
			image = ""
		})
		historyFruitSprite[i]:setPosition(ccp(30+(i-1)*72,37))
		Panel_lishi:addChild(historyFruitSprite[i])
	end
end


--[[--
--替换历史记录显示结果
--]]--
function showResult()
	Image_new:setVisible(true)
	for i=1,#historyTable do
		historyFruitSprite[i]:loadTexture(FruitPicture[historyTable[i]]);
	end
end


--[[--
--显示结算页面
--]]--
function showPanel_jiesuan()
	if WanRenSGJState == 0 then
		--如果是押注状态
		return
	end
	turntableNode:setVisible(false)
	Panel_jiesuan:setVisible(true)
	if lightlayer ~= nil then
		view:removeChild(lightlayer, true)
	end
	local moveto = CCMoveTo:create(0.1, ccp(285,127))
	local array = CCArray:create()
	array:addObject(moveto)
	array:addObject(CCDelayTime:create(0.5));--延时
	array:addObject(CCCallFuncN:create(addAnimationCoin));
	array:addObject(CCDelayTime:create(3));--延时
	if getWinTable["GetCion"] > 0 then
		--赢的金币大于0
		array:addObject(CCCallFuncN:create(addAnimationCoinTransfer));
		local temp = math.random(1,2)
		if temp == 1 then
			playEffect(winSound1, false)
		elseif temp == 2 then
			playEffect(winSound2, false)  --播放音效
		end
	else
		--等于0
		local temp = math.random(1,2)
		if temp == 1 then
			playEffect( loseSound1, false)  --播放音效
		elseif temp == 2 then
			playEffect( loseSound2, false)
		end
	end
	array:addObject(CCDelayTime:create(0.7))
--	array:addObject(CCCallFuncN:create(doRewards))  --打赏
	array:addObject(CCCallFuncN:create(setmycoin));  --金币滚动完之后马上校正一次金币
	Panel_jiesuan:runAction(CCSequence:create(array))

end

--[[--
--显示转盘（移走结算页面）
--]]--
function showturntable()
	Panel_jiesuan:setVisible(false)
	local moveto = CCMoveTo:create(0.1, ccp(285,-360))
	Panel_jiesuan:runAction(moveto)
	turntableNode:setVisible(true)
end

--[[--
--设置自己金币
--]]--
function setmycoin()
	AtlasLabel_coin:setStringValue(coinOfme)
end

--[[--
--押注广播信息
--]]--
function showRadioMsg()
	if WanRenSGJState == 0 then
		--押注状态
		radiotable = profile.WanRenSGJ.getTableWithWRSGJ_SYNC_MESSAGE_RADIO()
		if radiotable.name ~= nil and radiotable.name ~= "" then
			if radiotable.name ~= profile.User.getSelfNickName() then
				--如果不是自己
				addRadio(radiotable.name,radiotable.type,radiotable.coin)
			end
		end
	end
	--[[--
	--后面是控制循环
	--]]--
	local delay = CCDelayTime:create(0.5)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(showRadioMsg))
	local seq = CCSequence:create(array)
	WanRenFruitMachineLogic.view:runAction(seq)
end

--[[--
--给广播添加信息
--]]--
function addRadio(name,type,num)
	--在这里实现滚动的效果
	Label_name1:setText(Label_name2:getStringValue())  --广播押注用户名
	Label_fruit1:setText(Label_fruit2:getStringValue())   --广播押注类型
	Label_coin1:setText(Label_coin2:getStringValue())   --广播押注金币
	Label_name2:setText(Label_name_me:getStringValue())  --广播押注用户名
	Label_fruit2:setText(Label_fruit_me:getStringValue())   --广播押注类型
	Label_coin2:setText(Label_coin_me:getStringValue())   --广播押注金币

	Label_name_me:setText(name)  --广播押注用户名
	Label_fruit_me:setText(type)   --广播押注类型
	Label_coin_me:setText(num)    --广播押注金币

	if Label_name1:getStringValue() == nil or Label_name1:getStringValue() == "" then
		Label_xiazhu1:setVisible(false)
	else
		Label_xiazhu1:setVisible(true)
	end
	if Label_name2:getStringValue() == nil or Label_name2:getStringValue() == "" then
		Label_xiazhu2:setVisible(false)
	else
		Label_xiazhu2:setVisible(true)
	end
	if Label_name_me:getStringValue() == nil or Label_name_me:getStringValue() == "" then
		Label_xiazhu_me:setVisible(false)
	else
		Label_xiazhu_me:setVisible(true)
	end
end


--[[--
--单注
--]]--
function betOfPer(betper)
	betper = betper % 5 + 1
	if WanRenSGJState == 1 then
		return
	end
	if betper == 1 or betper == 2 then
		AtlasLabel_danjia:setStringValue(betTable[betper] / 100)
		Image_xiazhudanwei:loadTexture(WanRenSGJGetResources("ui_sgj_zi_bai.png"))
	elseif betper == 3 or betper == 4 then
		AtlasLabel_danjia:setStringValue(betTable[betper] / 1000)
		Image_xiazhudanwei:loadTexture(WanRenSGJGetResources("ui_sgj_zi_qian.png"))
	elseif betper == 5 then
		AtlasLabel_danjia:setStringValue(betTable[betper] / 10000)
		Image_xiazhudanwei:loadTexture(WanRenSGJGetResources("ui_sgj_zi_wan.png"))
	end
	betOfOneSend = betTable[betper]
end

--[[--
--接收更新游戏结果
--]]--
function processWRSGJ_RESULT()
	isaccpetresult = 1   --接收到结果信息
	WRSGJTABLE.Result = profile.WanRenSGJ.getTableWithWRSGJ_RESULT()
	getWinTable["GetCion"]= WRSGJTABLE.Result["GetCion"]          --赢的金币
	Common.log("zz................赢的金币" .. getWinTable["GetCion"])
	if getWinTable["GetCion"] > 0 then
		AtlasLabel_jiesuan:setStringValue(getWinTable["GetCion"])
		Image_zijitis:loadTexture(WanRenSGJGetResources("ui_gongxi.png"))
	else
		AtlasLabel_jiesuan:setStringValue("0")
		Image_zijitis:loadTexture(WanRenSGJGetResources("ui_weicaizhong.png"))  --换图
	end
	--大赢家信息(前5名)
	for i=1, #WRSGJTABLE.Result["Winner"] do
		--		getWinTable[i] = {}
		getWinTable[i].Name = WRSGJTABLE.Result["Winner"][i].Name
		getWinTable[i].Coin = WRSGJTABLE.Result["Winner"][i].Coin
		getWinTable[i].VipLevel = WRSGJTABLE.Result["Winner"][i].VipLevel
	end

	Label_nicheng1:setText(getWinTable[1].Name)
	Label_nicheng2:setText(getWinTable[2].Name)
	Label_nicheng3:setText(getWinTable[3].Name)
	Label_nicheng4:setText(getWinTable[4].Name)
	Label_nicheng5:setText(getWinTable[5].Name)

	AtlasLabel_getcoin1:setStringValue(0)
	AtlasLabel_getcoin2:setStringValue(0)
	AtlasLabel_getcoin3:setStringValue(0)
	AtlasLabel_getcoin4:setStringValue(0)
	AtlasLabel_getcoin5:setStringValue(0)
	--  历史记录
	for i=1, #WRSGJTABLE.Result["HistoryList"] do
		historyTable[i] = WRSGJTABLE.Result["HistoryList"][i].ImageIndex + 1
		--		Common.log("zz................历史记录" .. historyTable[i])
	end
	updataEditUserInfo()  --更新用户金币
end

--[[--
--转盘起止位置
--]]--
function startAndStopPosition()
	if isHasSendResult == 0 then
		WRSGJTABLE.position = profile.WanRenSGJ.getTableWithWRSGJ_POSITION()
		startposition = WRSGJTABLE.position["Start"] + 1
		endpositionTable = WRSGJTABLE.position["End"]
		if startposition >= 1 and startposition <=20  then
			isHasSendResult = 1 --接收到起止位置消息，将状态设置为已推送
			isHasstartAndStopPosition =1
		end
		for i=1,#WRSGJTABLE.position["End"] do   --收到结束位置
			endpositionTable[i] =  WRSGJTABLE.position["End"][i]
		end
		endposition = endpositionTable[1].endPosition + 1
		nextstartposition = endposition  --把终止位置给下一次起始位置
		decideBlinkFruit(endposition)  --决定押注水果闪烁
		if #WRSGJTABLE.position["End"] >=2 then
			--有两个结束位置
			endpositionReturn = endpositionTable[2].endPosition + 1
			nextstartposition = endpositionReturn
			decideBlinkFruit(endpositionReturn)
		end
		if #WRSGJTABLE.position["End"] >=3 then
			--有三个结束位置
			endpositionReturnTwo = endpositionTable[3].endPosition + 1
			nextstartposition = endpositionReturnTwo
			decideBlinkFruit(endpositionReturnTwo)
		end

		if #WRSGJTABLE.position["End"] >=4 then
			--有四个结束位置
			endpositionReturnThree = endpositionTable[4].endPosition + 1
			nextstartposition = endpositionReturnThree
			decideBlinkFruit(endpositionReturnThree)
		end
		--		lightframe:setVisible(true)
		lightlayer = CCLayer:create()
		view:addChild(lightlayer)
		--		replacePicture_state_demystify()
		isaccpetMsgBack = 1
	end
end

--[[--
--开奖状态替换图片
--]]--
function replacePicture_state_demystify()
	Image_zhuanpan:loadTexture(WanRenSGJGetResources("ui_sgp_dengdai.png"))  --替换成待开奖图片
	Button_xuya:loadTextures(WanRenSGJGetResources("btn_sgp_03_unpress.png"),WanRenSGJGetResources("btn_sgp_03_unpress.png"),"")  --替换续压图片
	Button_xiazhu:loadTextures(WanRenSGJGetResources("btn_sgp_02_unpress.png"),WanRenSGJGetResources("btn_sgp_02_unpress.png"),"") --单注允许改变
end
--[[--
--不允许押注水果（图片变灰）
--]]--
function replacePicture_betFruit_OFF()
	Button_xiazhu_apple:loadTextures(WanRenSGJGetResources("btn_sgp_01_press.png"),WanRenSGJGetResources("btn_sgp_01_press.png"),"")
	Button_xiazhu_orange:loadTextures(WanRenSGJGetResources("btn_sgp_01_press.png"),WanRenSGJGetResources("btn_sgp_01_press.png"),"")
	Button_xiazhu_pawpaw:loadTextures(WanRenSGJGetResources("btn_sgp_01_press.png"),WanRenSGJGetResources("btn_sgp_01_press.png"),"")
	Button_xiazhu_bell:loadTextures(WanRenSGJGetResources("btn_sgp_01_press.png"),WanRenSGJGetResources("btn_sgp_01_press.png"),"")
	Button_xiazhu_seven:loadTextures(WanRenSGJGetResources("btn_sgp_01_press.png"),WanRenSGJGetResources("btn_sgp_01_press.png"),"")
	Button_xiazhu_watermelon:loadTextures(WanRenSGJGetResources("btn_sgp_01_press.png"),WanRenSGJGetResources("btn_sgp_01_press.png"),"")
	Button_xiazhu_star:loadTextures(WanRenSGJGetResources("btn_sgp_01_press.png"),WanRenSGJGetResources("btn_sgp_01_press.png"),"")
	Button_xiazhu_bar:loadTextures(WanRenSGJGetResources("btn_sgp_01_press.png"),WanRenSGJGetResources("btn_sgp_01_press.png"),"")
end

--[[--
--允许押注水果
--]]--
function replacePicture_betFruit_ON()
	Button_xiazhu_apple:loadTextures(WanRenSGJGetResources("btn_sgp_01.png"),WanRenSGJGetResources("btn_sgp_01.png"),"")
	Button_xiazhu_orange:loadTextures(WanRenSGJGetResources("btn_sgp_01.png"),WanRenSGJGetResources("btn_sgp_01.png"),"")
	Button_xiazhu_pawpaw:loadTextures(WanRenSGJGetResources("btn_sgp_01.png"),WanRenSGJGetResources("btn_sgp_01.png"),"")
	Button_xiazhu_bell:loadTextures(WanRenSGJGetResources("btn_sgp_01.png"),WanRenSGJGetResources("btn_sgp_01.png"),"")
	Button_xiazhu_seven:loadTextures(WanRenSGJGetResources("btn_sgp_01.png"),WanRenSGJGetResources("btn_sgp_01.png"),"")
	Button_xiazhu_watermelon:loadTextures(WanRenSGJGetResources("btn_sgp_01.png"),WanRenSGJGetResources("btn_sgp_01.png"),"")
	Button_xiazhu_star:loadTextures(WanRenSGJGetResources("btn_sgp_01.png"),WanRenSGJGetResources("btn_sgp_01.png"),"")
	Button_xiazhu_bar:loadTextures(WanRenSGJGetResources("btn_sgp_01.png"),WanRenSGJGetResources("btn_sgp_01.png"),"")
end

--[[--
--创建转盘加倍倍数
--]]--
function createDouble(value , color)
	local valueWidth = 20 --一个数字的纹理的宽高
	local valueHeight = 20
	local valueIndex = value % 11;
	local rect = CCRectMake(valueWidth * valueIndex, 0, valueWidth, valueWidth)
	local frameValue = CCSpriteFrame:createWithTexture(color , rect)
	local valueSprite = CCSprite:createWithSpriteFrame(frameValue)
	return valueSprite
end

--[[--
--更新前五名赢得金币（动画）
--]]--
function addAnimationCoin()
	local valueone = getWinTable[1].Coin
	local valuetwo = getWinTable[2].Coin
	local valuethree = getWinTable[3].Coin
	local valuefour = getWinTable[4].Coin
	local valuefive = getWinTable[5].Coin

	local tempone = valueone / 100
	local temptwo = valuetwo / 100
	local tempthree = valuethree / 100
	local tempfour = valuefour / 100
	local tempfive = valuefive / 100
	if animationflag == 1 then
		valueonezero = 0
		valuetwozero = 0
		valuethreezero = 0
		valuefourzero = 0
		valuefivezero = 0
		animationflag = 0
	end
	AtlasLabel_getcoin1:setStringValue(valueonezero)
	AtlasLabel_getcoin2:setStringValue(valuetwozero)
	AtlasLabel_getcoin3:setStringValue(valuethreezero)
	AtlasLabel_getcoin4:setStringValue(valuefourzero)
	AtlasLabel_getcoin5:setStringValue(valuefivezero)

	valueonezero = valueonezero + tempone
	valuetwozero = valuetwozero + temptwo
	valuethreezero = valuethreezero + tempthree
	valuefourzero = valuefourzero + tempfour
	valuefivezero = valuefivezero + tempfive

	if valueonezero <= valueone then
		local delay = CCDelayTime:create(0.01)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(CCCallFuncN:create(addAnimationCoin))
		local seq = CCSequence:create(array)
		WanRenFruitMachineLogic.view:runAction(seq)
	end
end

--[[--
--转移金币（动画）
--]]--
function addAnimationCoinTransfer()
	if WanRenSGJState == 0 then
		--如果是押注状态
		return
	end
	local mywincoin = getWinTable["GetCion"]
	local percoin = mywincoin / 100
	if animationTransferflag == 1 then
		wincoin = mywincoin   --此局赢的金币
		mycoin = coinOfme - wincoin	--自己本来的金币数
		animationTransferflag = 0
	end
	AtlasLabel_jiesuan:setStringValue(wincoin)
	AtlasLabel_coin:setStringValue(mycoin)
	wincoin = wincoin - percoin
	mycoin = mycoin + percoin

	local moveCoinArray = CCArray:create()
	local coinsprite = CCSprite:create(WanRenSGJGetResources("slot_drop_coin_img.png"));
	coinsprite:setPosition(ccp(AtlasLabel_jiesuan:getPosition().x+200,AtlasLabel_jiesuan:getPosition().y+100))
	view:addChild(coinsprite)
	local move =  CCMoveTo:create(0.2,ccp(AtlasLabel_coin:getPosition().x+180,Panel_jinbi:getPosition().y+50));
	moveCoinArray:addObject(move)
	local function removecoin()
		view:removeChild(coinsprite, true)
	end
	moveCoinArray:addObject(CCCallFuncN:create(removecoin))
	local moveseq = CCSequence:create(moveCoinArray)
	coinsprite:runAction(moveseq)
	if wincoin >= 0 then
		local delay = CCDelayTime:create(0.01)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(CCCallFuncN:create(addAnimationCoinTransfer))
		local seq = CCSequence:create(array)
		WanRenFruitMachineLogic.view:runAction(seq)
	end
end

--[[--
--播放转圈音效
--]]--
function playbetSound()
	playEffect(	CircleSound,false)
end
--[[--
--禁止点击BUTTON
--]]--
function forbidClick()
	Button_xiazhu_orange:setTouchEnabled(false)
	Button_xiazhu_pawpaw:setTouchEnabled(false)
	Button_xiazhu_bell:setTouchEnabled(false)
	Button_xiazhu_seven:setTouchEnabled(false)
	Button_xiazhu_apple:setTouchEnabled(false)
	Button_xiazhu_watermelon:setTouchEnabled(false)
	Button_xiazhu_star:setTouchEnabled(false)
	Button_xiazhu_bar:setTouchEnabled(false)
	Button_xiazhu:setTouchEnabled(false)
	Button_xuya:setTouchEnabled(false)
end

--[[--
--允许点击BUTTON
--]]--
function allowClick()
	Button_xiazhu_orange:setTouchEnabled(true)
	Button_xiazhu_pawpaw:setTouchEnabled(true)
	Button_xiazhu_bell:setTouchEnabled(true)
	Button_xiazhu_seven:setTouchEnabled(true)
	Button_xiazhu_apple:setTouchEnabled(true)
	Button_xiazhu_watermelon:setTouchEnabled(true)
	Button_xiazhu_star:setTouchEnabled(true)
	Button_xiazhu_bar:setTouchEnabled(true)
	Button_xiazhu:setTouchEnabled(true)
	Button_xuya:setTouchEnabled(true)
end

--[[--
--隐藏[下注]（当没有广播信息时）
--]]--
function hideBetMSG()
	if Label_name1:getStringValue() == nil or Label_name1:getStringValue() == "" then
		Label_xiazhu1:setVisible(false)
	end
	if Label_name2:getStringValue() == nil or Label_name2:getStringValue() == "" then
		Label_xiazhu2:setVisible(false)
	end
	if Label_name_me:getStringValue() == nil or Label_name_me:getStringValue() == "" then
		Label_xiazhu_me:setVisible(false)
	end
end
--[[--
--公告
--]]--
function processWRSGJ_NOTIC()
	WRSGJTABLE.notice = profile.WanRenSGJ.getTableWithWRSGJ_NOTICE()
	for i=1,#WRSGJTABLE.notice["WinMsgNum"] do
		local string = "恭喜玩家 '" .. WRSGJTABLE.notice["WinMsgNum"][i].username .. "' 赢得了" .. WRSGJTABLE.notice["WinMsgNum"][i].coin .."金币，成为了大赢家。"
		Label_gonggao:setText(string)
	end
end
--[[--
--移动倒计时和开奖状态
--]]--
function moveState()
	local array=CCArray:create()
	local function setHide()
		AtlasLabel_time:setVisible(flase)
	end
	array:addObject(CCCallFuncN:create(setHide))
	local move =  CCMoveTo:create(1, ccp(128,34));
	array:addObject(move)
	local seq = CCSequence:create(array);
	Image_zhuanpan:runAction(seq);
end
--[[--
--移回倒计时和开奖状态
--]]--
function moveStateBack()
	local array=CCArray:create()
	local function setappear()
		AtlasLabel_time:setVisible(true)
	end
	local move =  CCMoveTo:create(1, ccp(103,34));
	array:addObject(move)
	array:addObject(CCCallFuncN:create(setappear))
	local seq = CCSequence:create(array);
	Image_zhuanpan:runAction(seq);
end

--[[--
--押注水果
--]]--
function betOneFruit(number)
	if isbet == 1 then
		--可以押注
		if isnewbet == 1 and xuyabetflag == 0 then  --是否是新的一局押注和没有点击续压按钮
			isnewbet = 0
			for i=1,8 do  --清除续压记录
				continueBet[i]=0
			end
		end
		sendWRSGJ_BET( number , betOfOneSend)
		isbet = 0
		forbidClick()
	end
end





--[[--
--获取打赏基本信息判断
--]]
function getMiniGameRewardInfoJudge()
	local dataTable = profile.MiniGameChat.getMiniGameRewardsInfoTable()
	if dataTable["RewardLevel"] ~= nil then
		isExistRewardBaseInfo = true
		RewardLevel = dataTable["RewardLevel"]
	end
end

--[[--
--打赏
--]]
function doRewards()
	if getWinTable["GetCion"] >= RewardLevel and isExistRewardBaseInfo then
		mvcEngine.createModule(GUI_MINIGAME_REWARDS)
	end
end

--[[--
--检测是否有人打赏
--]]
function isHaveAward()
	if isExistReward then
		sendIMID_MINI_REWARDS_COLLECT(gameType)
		isExistReward = false
	end
end


--[[--
--请求是否有打赏信息
--]]
function reqIsExistRewardInfo()
	isExistReward = true
end

--[[--
--界面减金币操作
--服务器推送更新金币数量的消息回调setUserInfo，此处是将改变金币的限制条件放开
--]]
function subDisplayCoin()
	isStartFruitCall = true --设置为true可以进行修改金币操作
end


--------------------打赏领奖-------------------------
--[[--
--打赏领奖
--]]
function getMiniGameRewards()
	Common.log("qwe MiniGameRewards--有打赏")
	view:setTouchEnabled(false)
	local dataTable =  profile.MiniGameChat.getMiniGameRewardRecordInfoTable()
	local recordArray = Common.copyTab(dataTable.PromptMsg)
	local coinNum = dataTable.RewardNum
	getMiniGameRewardsAnimation(recordArray, coinNum)
end

--[[--
--打赏领奖提示语的动画
--]]
function getMiniGameRewardsAnimation(recordArray, coinNum)
	windowSize["width"] = CCDirector:sharedDirector():getWinSize().width
	windowSize["height"] = CCDirector:sharedDirector():getWinSize().height
	coinBatchNode =CCLayer:create()
	view:addChild(coinBatchNode)
	isWRSGJFlag = true
	for i = 1, #recordArray do
		local array = CCArray:create()
		local delay = CCDelayTime:create(0.7)
		array:addObject(CCCallFuncN:create(
			function()
				Common.showToast(string.format("%s:%s",recordArray[i].Name, recordArray[i].Content), 0.7)
			end
		))
		array:addObject(delay)
		if i == 1 then
			array:addObject(CCCallFuncN:create(
				function()
					DropCoinLogic.dropCoin(math.floor(coinNum / 200), AtlasLabel_coin, 200, getMiniGameRewardsCallBack, ccp(AtlasLabel_coin:getPosition().x+180, AtlasLabel_coin:getPosition().y), coinBatchNode, windowSize.width, windowSize.height)
				end
			))
		end
		local seq = CCSequence:create(array)
		view:runAction(seq)
	end
	getMiniGameRewardsCallBack()
end

--[[--
--打赏领奖回调
--]]
function getMiniGameRewardsCallBack()
	view:setTouchEnabled(true)
end



--[[--
--获取小游戏大厅内玩家的发言
--]]
function getMiniGameChatMsg()
	Common.log("qwe..................................................")
	local chatInfoTable = profile.MiniGameChat.getMiniGameChatInfoTable()
	if chatInfoTable.MessageContent ~= nil and chatInfoTable.MessageContent ~= "" then
		Label_gonggao:setText(chatInfoTable.SenderNickname..": "..chatInfoTable.MessageContent)
	elseif chatInfoTable.Result ~= 0 then
		Common.showToast("发言成功", 2)
		Label_gonggao:setText("我 : "..chatTextFeild:getStringValue())
	else
		Common.showToast("发言失败", 2)
	end
end


--[[--
--隐藏所有押注lable
--]]--
function hideBetFruitLable()
	Label_zj_apple:setVisible(false)
	Label_all_apple:setVisible(false)
	Label_zj_watermelon:setVisible(false)
	Label_all_watermelon:setVisible(false)
	Label_zj_star:setVisible(false)
	Label_all_star:setVisible(false)
	Label_zj_bar:setVisible(false)
	Label_all_bar:setVisible(false)
	Label_zj_orange:setVisible(false)
	Label_all_orange:setVisible(false)
	Label_zj_pawpaw:setVisible(false)
	Label_all_pawpaw:setVisible(false)
	Label_zj_bell:setVisible(false)
	Label_all_bell:setVisible(false)
	Label_zj_seven:setVisible(false)
	Label_all_seven:setVisible(false)
end

--[[--
--显示所有押注lable
--]]--
function showBetFruitLable()
	Label_zj_apple:setVisible(true)
	Label_all_apple:setVisible(true)
	Label_zj_watermelon:setVisible(true)
	Label_all_watermelon:setVisible(true)
	Label_zj_star:setVisible(true)
	Label_all_star:setVisible(true)
	Label_zj_bar:setVisible(true)
	Label_all_bar:setVisible(true)
	Label_zj_orange:setVisible(true)
	Label_all_orange:setVisible(true)
	Label_zj_pawpaw:setVisible(true)
	Label_all_pawpaw:setVisible(true)
	Label_zj_bell:setVisible(true)
	Label_all_bell:setVisible(true)
	Label_zj_seven:setVisible(true)
	Label_all_seven:setVisible(true)
end

--[[--
--初始化闪烁水果
--]]--
function initBlinkFruit()
	fruitBlinkTable[1]= false
	fruitBlinkTable[2]= false
	fruitBlinkTable[3]= false
	fruitBlinkTable[4]= false
	fruitBlinkTable[5]= false
	fruitBlinkTable[6]= false
	fruitBlinkTable[7]= false
	fruitBlinkTable[8]= false
end

--[[--
--选择闪烁的水果
--]]--
function choseFruitBlink(object,objects)
	local fddeIn = CCCallFuncN:create(function()
		object:setVisible(true)
		objects:setVisible(true)
	end)
	local fddeOut = CCCallFuncN:create(function()
		object:setVisible(false)
		objects:setVisible(false)
	end)
	local delay = CCDelayTime:create(0.1);
	local array = CCArray:create()
	for i = 1 , 5 do
		array:addObject(fddeOut);
		array:addObject(delay);
		array:addObject(fddeIn);
		array:addObject(delay);
	end
	local seq = CCSequence:create(array);
	view:runAction(seq)
end

--[[--
--执行水果闪烁
--]]--
function judgeBlink()
	hideBetFruitLable()
	if fruitBlinkTable[1] == true then
		choseFruitBlink(Label_zj_apple,Label_all_apple)
		Common.log("zbla...1")
	end
	if fruitBlinkTable[2] == true then
		choseFruitBlink(Label_zj_orange,Label_all_orange)
		Common.log("zbla...2")
	end
	if fruitBlinkTable[3] == true then
		choseFruitBlink(Label_zj_pawpaw,Label_all_pawpaw)
		Common.log("zbla...3")
	end
	if fruitBlinkTable[4] == true then
		choseFruitBlink(Label_zj_bell,Label_all_bell)
		Common.log("zbla...4")
	end
	if fruitBlinkTable[5] == true then
		choseFruitBlink(Label_zj_watermelon,Label_all_watermelon)
		Common.log("zbla...5")
	end
	if fruitBlinkTable[6] == true then
		choseFruitBlink(Label_zj_star,Label_all_star)
		Common.log("zbla...6")
	end
	if fruitBlinkTable[7] == true then
		choseFruitBlink(Label_zj_seven,Label_all_seven)
		Common.log("zbla...7")
	end
	if fruitBlinkTable[8] == true then
		choseFruitBlink(Label_zj_bar,Label_all_bar)
		Common.log("zbla...8")
	end
end

--[[--
--确定闪烁的水果
--]]--
function  decideBlinkFruit(position)
	Common.log("zbla...position=" .. position)
	if position == 1 or position == 18 then  --铃铛
		fruitBlinkTable[4] = true
	elseif position == 2 or position == 13 then --bar
		fruitBlinkTable[8] = true
	elseif position == 3 or position == 11 then  --双7
		fruitBlinkTable[7] = true
	elseif position == 4 or position == 8 or position == 17 then	--苹果
		fruitBlinkTable[1] = true
	elseif position == 5 or position == 9 then	--双星
		fruitBlinkTable[6] = true
	elseif position == 6 or position == 15 then	--LUCK
	elseif position == 7 or position == 14 or position == 16 then --橙子
		fruitBlinkTable[2] = true
	elseif position == 10 or position == 20 then	--西瓜
		fruitBlinkTable[5] = true
	elseif position == 12 or position == 19 then --木瓜
		fruitBlinkTable[3] = true
	end
end

--[[--
--用户押注信息(当用户押完注退出界面，然后再进来时调用)
--]]--
function userBetMsgInfo()
	--苹果
	Label_zj_apple:setText(userBetMsg[1])
	--橙子
	Label_zj_orange:setText(userBetMsg[2])
	--木瓜
	Label_zj_pawpaw:setText(userBetMsg[3])
	--铃铛
	Label_zj_bell:setText(userBetMsg[4])
	--西瓜
	Label_zj_watermelon:setText(userBetMsg[5])
	--双星
	Label_zj_star:setText(userBetMsg[6])
	--77
	Label_zj_seven:setText(userBetMsg[7])
	--BAR
	Label_zj_bar:setText(userBetMsg[8])
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	isHasSendResult = 0  --退出时将位置与结果推送设置为否(开奖阶段进房间)
	localtimeflag = 0
	isaccept = 0 --是否接收基本信息
	betstateflag = 1  --押注状态标记
	resultstateflag = 1  --结果状态标记
	animationflag = 1  -- 前五名赢金币动画标记
	animationTransferflag = 1  --转移金币动画标记
	isFirstflag = 1 --是否第一次进来   0:不是第一次进来   1:第一次进来
	localbettime  =  999  --本地押注倒计时
	isaccpetinfo = 0 --是否接受INFO基本信息
	isaccpetMsgBack = 0;  --是否接收到起止位置信息   0：未接收，1：已接收
	lightdelayed = 0.3  --光标移动默认速度
	lowestcircle = 0 --保证最低圈数，防止还没开始转就收到信息就马上停止转圈
	isSpeedUp = 0 --是否可以加速      ： >5不允许加速
	betOfOne = 1 --单注选项   1, 2 ,3 ,4 ,5
	betOfOneSend = 200 --推送单注
	xuyabetflag = 0  --点击续压按钮标记  0：未点击  1：已点击
	movecircle = 4
	isFirstN = 1  --是否刚进来 0:不是  1:是
	isaccpetresult = 0  --是否接收游戏结果  0:没接收到 1：已接收
	isOneTime = 0


	valueonezero = 0
	valuetwozero = 0
	valuethreezero = 0
	valuefourzero = 0
	valuefivezero = 0
	wincoin = 0
	mycoin = 0
	sendIMID_MINI_QUIT_CHAT_ROOM(gameType)
	isWRSGJFlag = false
	isFirstNFlag = true
	initBlinkFruit()
	AudioManager.stopAllSound()
	WanRenSGJState = 0
end


function addSlot()
	framework.addSlot2Signal(WRSGJ_INFO , processWRSGJ_INFO)  --接收服务器返回来的基本消息INFO
	--定时器，更新时间
	lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(setCurrentTime, 1 ,false);
	framework.addSlot2Signal(WRSGJ_SYNC_MESSAGE , processWRSGJ_SYNC_MESSAGE)  --接收同步消息
	framework.addSlot2Signal(WRSGJ_BET , betFriut)
	framework.addSlot2Signal(WRSGJ_RADIO , xiazhuRadio)
	framework.addSlot2Signal(WRSGJ_RESULT , processWRSGJ_RESULT)
	framework.addSlot2Signal(WRSGJ_POSITION ,startAndStopPosition)
	framework.addSlot2Signal(BASEID_GET_BASEINFO, updataEditUserInfo)
	framework.addSlot2Signal(WRSGJ_NOTICE, processWRSGJ_NOTIC)
	framework.addSlot2Signal(IMID_MINI_SEND_MESSAGE, getMiniGameChatMsg)
	framework.addSlot2Signal(IMID_MINI_REWARDS_JUDGE, reqIsExistRewardInfo)
	framework.addSlot2Signal(IMID_MINI_REWARDS_BASEINFO, getMiniGameRewardInfoJudge)
	framework.addSlot2Signal(IMID_MINI_REWARDS_COLLECT, getMiniGameRewards)
end


function removeSlot()
	framework.removeSlotFromSignal(WRSGJ_INFO , processWRSGJ_INFO)
	--时间定时器
	if (lookTimer) then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
	end
	framework.removeSlotFromSignal(WRSGJ_SYNC_MESSAGE , processWRSGJ_SYNC_MESSAGE)
	framework.removeSlotFromSignal(WRSGJ_BET, betFriut)
	framework.removeSlotFromSignal(WRSGJ_RADIO , xiazhuRadio)
	framework.removeSlotFromSignal(WRSGJ_RESULT , processWRSGJ_RESULT)
	framework.removeSlotFromSignal(WRSGJ_POSITION , startAndStopPosition)
	framework.removeSlotFromSignal(BASEID_GET_BASEINFO, updataEditUserInfo)
	framework.removeSlotFromSignal(WRSGJ_NOTICE, processWRSGJ_NOTIC)
	framework.removeSlotFromSignal(IMID_MINI_SEND_MESSAGE, getMiniGameChatMsg)
	framework.removeSlotFromSignal(IMID_MINI_REWARDS_JUDGE, reqIsExistRewardInfo)
	framework.removeSlotFromSignal(IMID_MINI_REWARDS_BASEINFO, getMiniGameRewardInfoJudge)
	framework.removeSlotFromSignal(IMID_MINI_REWARDS_COLLECT, getMiniGameRewards)
end

