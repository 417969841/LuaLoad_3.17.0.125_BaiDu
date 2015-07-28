module("FruitMachineLogic",package.seeall)

view = nil;

--自定义变量
local WIN = 1
local LOSE = 2
local DEUCE = 3
local hisBackPath = "ui_lhj_bbjl02.png"--历史记录背景图片的路径
local BIG = 1
local SMALL = 2
local gameType = 1
local FRUITSTAKEKEY = "FRUITSTAKEKEY" --存储本地赌注基本信息

isRequestRollMessage = false --是否已经请求了得奖滚动信息
isRollRewardEnabled = true --是否允许彩池奖金进行滚动
isExistRewardBaseInfo = false --是否有打赏基本信息
isAutoPlay = false --判断是否开启了自动按钮
isAllStop = true --是否停止
isWin = false --是否得奖
doubleArray = {} --存储水果机加注变化的数组
stakeIndex = nil --加注列表索引
isAllowEnterBeg = false --是否能够进入比倍
prepareRaiseArray = {} --准备信息的数组(可以下的赌注的金币数量)
WinPoolInfo = {} --老虎机领奖奖池信息
handselInfo = nil --记录彩金数（一个为8的数组，当连对5次或者8次获得的金币数量）
isSuccess = false --是否获胜
isJoinRisk = false --是否能够进入比倍机
currentRewardRate = nil --当前奖池奖励比例
moneyOfWin = 0 --赢得的金币数量
RewardLevel = 200 --打赏底数
allowWinTimes = 0 --允许获胜的次数
userWinTimes = 0 --玩家比倍已经赢的次数
isDouble = 0 --玩家在比倍的时候是否选择了加倍，用来向数组添加，0为没有加倍，1为加倍
currentStake = 0 --当前的赌注
begHeight = 0 --水果机的高
Panel_20 = nil;--
Panel_awardsRect = nil;--
pokerRedPic = {} --红色扑克牌数字的table
pokerBlackPic = {} --黑色扑克牌数字的table
pokerGoldPic = {} --金色扑克牌数字的table
pokerKind = {} --扑克牌的花色的table
scrollSprites = {} --彩池滚动数字table
local currentScrollTag = 10 --记录顶部彩金滚动第一个数值的Tag
local currentRewardPoolNum = nil --当前彩池彩金数
local RewardPoolNum = nil
local isChange = true --判断扑克牌是否改变
clickNum = 0--记录点击的大小
--计算扑克牌中心点的坐标所需要用到的相关坐标点
ImageView_bj1_x = 0 --扑克牌所在的父控件的锚点x坐标
ImageView_bj1_y = 0 --扑克牌所在的父控件的锚点y坐标
Panel_79_x = 0 --ImageView_bj1_x所在的父控件的锚点坐标
Panel_79_y = 0 --ImageView_bj1_y所在的父控件的锚点坐标
isFirstBack = false --用来判断是不是第一次从静止状态再次回到不停的换牌状态
intoBegCoin = 0 --进入比倍机的时候用户所剩的金币
isWinBeg = 0--表示是否赢了的变量：1赢2输3平
currentRaise = 0 --当前的赌注
coinBatchNode = nil --承载金币的BatchNode
coinMoveToPosit = {} --金币飞向终点位置的坐标
windowSize = {} --窗口的大小
FruitMessageOfLastID = 0 --水果机滚动信息的最后一条的ID
trolleyImgCount = 0--拉杆动画当前是第几张图片的记录
isTrolleyMove = false--拉杆是否需要做动画
awardsLayoutTable = {}--记录得奖记录中的label元素（目前是想做5个）
layoutTable = {} --滚动条layout的table
local scrollShowCount = 5 --滚动条目显示的个数
awardsCount = 0 --当前取到中奖纪录的哪一条
--老虎机转动的相关变量
local MAX_SPEED = 0.1 --转动的最大速度为
local MAX_SPEED_COUNT = 6 --在最大速度的情况下转的图片数
--左边
leftTime = 0 --转动的时间
leftInMaxCount = 0 --在最大速度的情况下已经转几圈
leftIsMax = false --判断当前的速度是否到达了最大的速度
isLeftStop = true --左边是否停止
--中间
middleIsMove = false --是否进行移动，当运行过两个水果的时候，开始执行移动的函数，否则不进行为zuixi
middleTime = 0 --转动的时间
middleInMaxCount = 0 --在最大速度的情况下已经转几圈
middleIsMax = false --判断当前的速度是否到达了最大的速度
isMiddleStop = true --中间图片的转动是否停止
--右边
rightIsMove = false --是否进行移动，当运行过两个水果的时候，开始执行移动的函数，否则不进行为zuixi
rightTime = 0 --转动的时间
rightInMaxCount = 0 --在最大速度的情况下已经转几圈
rightIsMax = false --判断当前的速度是否到达了最大的速度
isRightStop = true --中间图片的转动是否停止
--老虎机转动时候需要的相关数据
fruitImgArray = {} --水果机所有水果图片的数组，5张图片
fruitBlackBack = {} --水果机黑色地图的大小
fruitViewAnchor = {} --水果转动层锚点的绝对坐标（即为黑色背景锚点的绝对坐标）
leftPicArray = {} --水果机转动时候的sprit，数组中一共有3个sprit，代表左中右3个转动的动画
middlePicArray = {} --水果机转动时候的sprit，数组中一共有3个sprit，代表左中右3个转动的动画
rightPicArray = {} --水果机转动时候的sprit，数组中一共有3个sprit，代表左中右3个转动的动画
leftLayout = nil --左半部分的layout
middleLayout = nil --中间部分的layout
rightLayout = nil --右半部分的layout
screwLayout = nil --放置转动的layout
fruitImgHeight = 0 --水果图片的高度
fruitImgWidth = 0 --水果图片的高度
ImageView_totalcoinBack = nil;--个人金币数量的背景图片
Panel_scroll_title = nil;--最上面的滚动框的panel
begRecDefImg = {} --比倍机中奖纪录的默认图片（X2,奖池10%，奖池50%）
timestamp = 0 --请求老虎机中奖纪录所需要的参数（最后时间)
winRecordArray = {}--老虎机获奖信息table
isWinLight = false--获奖以后是否仍然在闪动，用来控制自己将自己关闭
imgChange = true --仅仅是为了用作图片改动的标识
lightImage = nil--赢奖时滚动的光环
lightIndex = 1--赢奖时滚动光环序列
spriteNum = 0 --彩金数字滚动个数

local talkRectWidth = 0 --聊天框宽度
local talkRectHeight = 0--聊天框高度

Label_talk = {} --水果机上方滚动文字的table
rightVipRateLable = {} --右侧vip加奖比例说明lable的table
isInitUpAwards = false --  判断是不是第一次执行


historyUserData = nil --历史数据的userData,主要包含三个字段，back(背景),kind(花色),num（数字）
buttonTable = nil --大，小，加倍按钮的集合
resultAnimaPoint = nil --当点击大小以后，输赢飞入动画的展示位置
isFirstGetMsg = true --是否是第一次获取上方的滚动信息



--老虎机界面用到的变量
--由UI工程的到的变量


--new fruit
Button_back = nil;--返回按钮
ImageView_title = nil;--title 幸运水果机
ImageView_record = nil;--会将记录
Button_talk = nil;-- 聊天按钮
--ImageView_liaotiankuang = nil;--
Label_talk = nil;-- 聊天框内的label控件
--ImageView_kuangzuo = nil;--
ScrollView_recordList = nil;--中奖纪录
Button_gift = nil;--礼包
Panel_laohuji = nil;--老虎机的框架panel
Button_fruit_recharge = nil;--水果机界面的充值按钮
Label_fruit_total_coin = nil;--水果机界面的金币总额的label
ImageView_fruit_caicibg = nil;--当前彩池
ImageView_fruit_caici_title = nil;--当前彩池的title
ImageView_fruit_pond_light = nil;--彩池闪烁的灯
ImageView_jiqicv = nil;--
ImageView_jiqi02 = nil;--
ImageView_lagan = nil;--拉杆图片，有动画效果
Button_raise = nil;--加注按钮
LabelAtlas_raise_coin = nil;--进行老虎机游戏的赌注金额,显示金币的label
Button_auto = nil;--自动按钮
Button_stop = nil;--停止按钮
Button_start = nil;--开始按钮
ImageView_fruit_bottom_light = nil;--水果机最底部的灯
ImageView_heisebg = nil;--水果机主机中间的黑色背景
ImageView_win_rules = nil;--
ImageView_fruit_describe = nil;--
ImageView_shelter = nil;--
chatTextFeild = nil;--聊天输入文字(用于输入)
local imageRewardType = nil; --当前领赏类型（美女，领赏）

--比倍机界面用到的变量
--由UI工程得到的变量

Panel_bibeiji = nil;--比倍机界面panel
ImageView_bj1 = nil;--
ImageView_paidaxiao = nil;--poker背景界面
ImageView_poker_kind = nil;--扑克牌花色
ImageView_poker = nil;--扑克牌数字显示
Button_collect = nil;--收钱（小钱袋）
ImageView_dangqian = nil;--
LabelAtlas_win_coin = nil;--赢得的钱数
Panel_bibeijieguo = nil;--
ImageView_result_back2 = nil;-- 比倍赢后第2张展示的背景图片
ImageView_result_poker_kind2 = nil;--比倍赢后第2张展示的花色
ImageView_result_poker2 = nil;--比倍赢后第2张展示的数字
ImageView_result_back1 = nil;--比倍赢后第1张展示的背景图片
ImageView_result_poker_kind1 = nil;--比倍赢后第1张展示的花色
ImageView_result_poker1 = nil;--比倍赢后第1张展示的数字
ImageView_result_back3 = nil;--比倍赢后第3张展示的背景图片
ImageView_result_poker_kind3 = nil;--比倍赢后第3张展示的花色
ImageView_result_poker3 = nil;--比倍赢后第3张展示的数字
ImageView_result_back5 = nil;--比倍赢后第5张展示的背景图片
ImageView_result_poker_kind5 = nil;--比倍赢后第5张展示的花色
ImageView_result_poker5 = nil;--比倍赢后第5张展示的数字
ImageView_result_back6 = nil;--比倍赢后第6张展示的背景图片
ImageView_result_poker_kind6 = nil;--比倍赢后第6张展示的花色
ImageView_result_poker6 = nil;--比倍赢后第6张展示的数字
ImageView_result_back7 = nil;--比倍赢后第7张展示的背景图片
ImageView_result_poker_kind7 = nil;--比倍赢后第7张展示的花色
ImageView_result_poker7 = nil;--比倍赢后第7张展示的数字
ImageView_result_back8 = nil;--比倍赢后第8张展示的背景图片
ImageView_result_poker_kind8 = nil;--比倍赢后第8张展示的花色
ImageView_result_poker8 = nil;--比倍赢后第8张展示的数字
ImageView_result_back4 = nil;--比倍赢后第4张展示的背景图片
ImageView_result_poker_kind4 = nil;--比倍赢后第4张展示的花色
ImageView_result_poker4 = nil;--比倍赢后第4张展示的数字
Button_big = nil;--比倍机猜大
Button_small = nil;--比倍机猜小
Button_double = nil;--比倍机加倍
ImageView_addshuoming = nil;--
ImageView_beg_describe = nil;--
Button_beg_recharge = nil;--
Label_beg_total_coin = nil;--
ImageView_beg_caicibg = nil;--
Label_caichi_rate_main = nil;
Explain_Lable1 = nil;--
Explain_Lable2 = nil;--
Explain_Lable3 = nil;--
Explain_Lable4 = nil;--
Explain_Lable5 = nil;--
Explain_Lable6 = nil;--
Explain_Lable7 = nil;--
Image_Flag = nil;--
ImageView_Right = nil;--
ImageView_Center = nil;--
ImageView_Left = nil;--
Button_Vip = nil;--
Panel_vip = nil;--
Label_beg_total_rate_five = nil;--
Label_beg_total_rate_eight = nil;--
Image_dashang = nil;--
Label_Reward = nil;--
Image_Reward = nil;--

miniGameState = 0

tableView = nil
atlasLabelTable = nil

--常量
local SHOW_LAO_HU_JI = 0;
local SHOW_BI_BEI_JI = 1;

local DIR_UP = 0--向上
local DIR_DOWN = 1--向下

--比倍的时候猜大小：1代表大，2代表小.
local BIG = 1
local SMALL = 2

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		Common.log("button_back is clicked == "..miniGameState)
		if (miniGameState == SHOW_LAO_HU_JI) then
			mvcEngine.createModule(GameConfig.getTheLastBaseLayer())
			AudioManager.stopBgMusic(true)
			AudioManager.stopAllSound()
			AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.HALL_BACKGROUND)
		else
			BegMachineLogic.collectMoney()
		end
	elseif event == "menuClicked" then
	--菜单键
	end
end


--[[--
--初始化控件
--]]
local function initView()
	rightVipRateLable = {}
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Label_beg_total_rate_five = cocostudio.getUILabel(view, "Label_126");
	Label_beg_total_rate_eight = cocostudio.getUILabel(view, "Label_126_0");
	Button_back = cocostudio.getUIButton(view, "Button_back");
	ImageView_title = cocostudio.getUIImageView(view, "ImageView_title");
	ImageView_record = cocostudio.getUIImageView(view, "ImageView_record");
	Button_talk = cocostudio.getUIButton(view, "Button_117");
	chatTextFeild = cocostudio.getUITextField(view, "chatTextFeild");
	ImageView_totalcoinBack = cocostudio.getUIImageView(view, "ImageView_totalcoinBack");
	Label_talk = cocostudio.getUILabel(view, "Label_talk");
	ScrollView_recordList = cocostudio.getUIScrollView(view, "ScrollView_recordList");
	Button_gift = cocostudio.getUIButton(view, "Button_gift");
	Panel_laohuji = cocostudio.getUIPanel(view, "Panel_78");
	Button_fruit_recharge = cocostudio.getUIButton(view, "Button_fruit_recharge");
	Label_fruit_total_coin = cocostudio.getUILabel(view, "Label_fruit_total_coin");
	ImageView_fruit_caicibg = cocostudio.getUIImageView(view, "ImageView_fruit_caicibg");
	ImageView_fruit_caici_title = cocostudio.getUIImageView(view, "ImageView_fruit_caici_title");
	ImageView_fruit_pond_light = cocostudio.getUIImageView(view, "ImageView_fruit_pond_light");
	ImageView_jiqicv = cocostudio.getUIImageView(view, "ImageView_jiqicv");
	ImageView_jiqi02 = cocostudio.getUIImageView(view, "ImageView_jiqi02");
	ImageView_lagan = cocostudio.getUIImageView(view, "ImageView_lagan");
	Button_raise = cocostudio.getUIButton(view, "Button_raise");
	LabelAtlas_raise_coin = cocostudio.getUILabelAtlas(view, "LabelAtlas_raise_coin");
	Button_auto = cocostudio.getUIButton(view, "Button_auto");
	Button_stop = cocostudio.getUIButton(view, "Button_stop");
	Button_start = cocostudio.getUIButton(view, "Button_start");
	ImageView_fruit_bottom_light = cocostudio.getUIImageView(view, "ImageView_fruit_bottom_light");
	--	ImageView_heisebg = cocostudio.getUIImageView(view, "ImageView_Right");
	ImageView_Right = cocostudio.getUIImageView(view, "ImageView_Right");
	ImageView_Center = cocostudio.getUIImageView(view, "ImageView_Center");
	ImageView_Left = cocostudio.getUIImageView(view, "ImageView_Left");
	ImageView_win_rules = cocostudio.getUIImageView(view, "ImageView_win_rules");
	ImageView_fruit_describe = cocostudio.getUIImageView(view, "ImageView_fruit_describe");
	ImageView_shelter = cocostudio.getUIImageView(view, "ImageView_shelter");
	Panel_bibeiji = cocostudio.getUIPanel(view, "Panel_79");
	ImageView_bj1 = cocostudio.getUIImageView(view, "ImageView_bj1");
	ImageView_paidaxiao = cocostudio.getUIImageView(view, "ImageView_paidaxiao");
	ImageView_poker_kind = cocostudio.getUIImageView(view, "ImageView_poker_kind");
	ImageView_poker = cocostudio.getUIImageView(view, "ImageView_poker");
	Button_collect = cocostudio.getUIButton(view, "Button_collect");
	ImageView_dangqian = cocostudio.getUIImageView(view, "ImageView_dangqian");
	LabelAtlas_win_coin = cocostudio.getUILabelAtlas(view, "LabelAtlas_win_coin");
	Panel_bibeijieguo = cocostudio.getUIPanel(view, "Panel_bibeijieguo");
	ImageView_result_back2 = cocostudio.getUIImageView(view, "ImageView_result_back2");
	ImageView_result_poker_kind2 = cocostudio.getUIImageView(view, "ImageView_result_poker_kind2");
	ImageView_result_poker2 = cocostudio.getUIImageView(view, "ImageView_result_poker2");
	ImageView_result_back1 = cocostudio.getUIImageView(view, "ImageView_result_back1");
	ImageView_result_poker_kind1 = cocostudio.getUIImageView(view, "ImageView_result_poker_kind1");
	ImageView_result_poker1 = cocostudio.getUIImageView(view, "ImageView_result_poker1");
	ImageView_result_back3 = cocostudio.getUIImageView(view, "ImageView_result_back3");
	ImageView_result_poker_kind3 = cocostudio.getUIImageView(view, "ImageView_result_poker_kind3");
	ImageView_result_poker3 = cocostudio.getUIImageView(view, "ImageView_result_poker3");
	ImageView_result_back8 = cocostudio.getUIImageView(view, "ImageView_result_back8");
	ImageView_result_poker_kind8 = cocostudio.getUIImageView(view, "ImageView_result_poker_kind8");
	ImageView_result_poker8 = cocostudio.getUIImageView(view, "ImageView_result_poker8");
	ImageView_result_back6 = cocostudio.getUIImageView(view, "ImageView_result_back6");
	ImageView_result_poker_kind6 = cocostudio.getUIImageView(view, "ImageView_result_poker_kind6");
	ImageView_result_poker6 = cocostudio.getUIImageView(view, "ImageView_result_poker6");
	ImageView_result_back7 = cocostudio.getUIImageView(view, "ImageView_result_back7");
	ImageView_result_poker_kind7 = cocostudio.getUIImageView(view, "ImageView_result_poker_kind7");
	ImageView_result_poker7 = cocostudio.getUIImageView(view, "ImageView_result_poker7");
	ImageView_result_back5 = cocostudio.getUIImageView(view, "ImageView_result_back5");
	ImageView_result_poker_kind5 = cocostudio.getUIImageView(view, "ImageView_result_poker_kind5");
	ImageView_result_poker5 = cocostudio.getUIImageView(view, "ImageView_result_poker5");
	ImageView_result_back4 = cocostudio.getUIImageView(view, "ImageView_result_back4");
	ImageView_result_poker_kind4 = cocostudio.getUIImageView(view, "ImageView_result_poker_kind4");
	ImageView_result_poker4 = cocostudio.getUIImageView(view, "ImageView_result_poker4");
	Button_big = cocostudio.getUIButton(view, "Button_big");
	Button_small = cocostudio.getUIButton(view, "Button_small");
	Button_double = cocostudio.getUIButton(view, "Button_double");
	ImageView_addshuoming = cocostudio.getUIImageView(view, "ImageView_addshuoming");
	ImageView_beg_describe = cocostudio.getUIImageView(view, "ImageView_beg_describe");
	Button_beg_recharge = cocostudio.getUIButton(view, "Button_beg_recharge");
	Label_beg_total_coin = cocostudio.getUILabel(view, "Label_beg_total_coin");
	ImageView_beg_caicibg = cocostudio.getUIImageView(view, "ImageView_beg_caicibg");
	Panel_scroll_title = cocostudio.getUIPanel(view, "Panel_834");
	Panel_awardsRect = cocostudio.getUIPanel(view, "Panel_837");
	Label_caichi_rate_main = cocostudio.getUILabel(view, "Label_caichi_rate_main");
	Explain_Lable1 = cocostudio.getUILabel(view, "Explain_Lable1");
	Image_dashang = cocostudio.getUIImageView(view, "Image_dashang");
	Label_Reward = cocostudio.getUILabel(view, "Label_Reward");
	Image_Reward = cocostudio.getUIImageView(view, "Image_Reward");
	table.insert(rightVipRateLable, Explain_Lable1)
	Explain_Lable2 = cocostudio.getUILabel(view, "Explain_Lable2");
	table.insert(rightVipRateLable, Explain_Lable2)
	Explain_Lable3 = cocostudio.getUILabel(view, "Explain_Lable3");
	table.insert(rightVipRateLable, Explain_Lable3)
	Explain_Lable4 = cocostudio.getUILabel(view, "Explain_Lable4");
	table.insert(rightVipRateLable, Explain_Lable4)
	Explain_Lable5 = cocostudio.getUILabel(view, "Explain_Lable5");
	table.insert(rightVipRateLable, Explain_Lable5)
	Explain_Lable6 = cocostudio.getUILabel(view, "Explain_Lable6");
	table.insert(rightVipRateLable, Explain_Lable6)
	Explain_Lable7 = cocostudio.getUILabel(view, "Explain_Lable7");
	table.insert(rightVipRateLable, Explain_Lable7)
	Image_Flag = cocostudio.getUIImageView(view, "Image_Flag");
	rightVipRateLable["Flag"] = Image_Flag
	Button_Vip = cocostudio.getUIButton(view, "Button_Vip");
	Panel_vip = cocostudio.getUIPanel(view, "Panel_vip");
	rightVipRateLable["PanelVip"] = Panel_vip
	chatTextFeild:setVisible(false)
end

--[[--
初始化数据
--]]
function initData()
	miniGameState = SHOW_LAO_HU_JI
	CommonControl.setMiniGameType(gameType, view) --设置游戏类型和当前view
	CommonControl.trumpetAnimation(Button_talk)	--播放小喇叭动画
	--	LabelAtlas_fruit_current_jackpot:setStringValue("")
	--充值礼包的图片用的是公共礼包图片
	if GameConfig.GAME_ID ~= 1 then
		--如果不是斗地主隐藏小游戏的礼包
		Button_gift:setVisible(false)
		Button_gift:setTouchEnabled(false)
	end
	if profile.Gift.isShowFirstGiftIcon() then
		--可以购买礼包
		Button_gift:loadTextures(Common.getResourcePath("ic_hall_shouchong.png"),Common.getResourcePath("ic_hall_shouchong.png"),"")
	else
		--可以进行充值
		--Common.setButtonVisible(Button_gift, false)
		Button_gift:loadTextures(CommonControl.CommonControlGetResource("ic_hall_recharge.png"),CommonControl.CommonControlGetResource("ic_hall_recharge.png"),"")
	end
	AudioManager.stopBgMusic(true)
	AudioManager.stopAllSound()
	CommonControl.preloadSound()
	CommonControl.playBackMusic("fanpaiBackGroundSound.mp3",true)--播放背景音乐
	sendIMID_MINI_ENTER_CHAT_ROOM(gameType)
--	sendIMID_MINI_REWARDS_BASEINFO(gameType)
	sendDBID_USER_INFO(profile.User.getSelfUserID())
	coinBatchNode = CCLayer:create()
	coinBatchNode:setZOrder(2)
	view:addChild(coinBatchNode)
	coinBatchNode:registerScriptTouchHandler(DropCoinLogic.onTouch)
	isAllStop = true

	fruitBlackBack["height"] = ImageView_Right:getSize().height;
	fruitBlackBack["width"] = ImageView_Right:getSize().width;
	fruitBlackBack["x"] = ImageView_Right:getPosition().x
	fruitBlackBack["y"] = ImageView_Right:getPosition().y

	fruitViewAnchor["x"] = Panel_laohuji:getPosition().x + ImageView_Right:getPosition().x
	fruitViewAnchor["y"] = Panel_laohuji:getPosition().y + ImageView_Right:getPosition().y
	local LayoutW = fruitBlackBack.width
	local LayoutH = fruitBlackBack.height
	--左半部分的layout
	leftLayout = ccs.panel({
		scale9 = false,
		image = "",
		size = CCSizeMake(LayoutW*1.7, LayoutH),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	leftLayout:setAnchorPoint(ccp(0.5,0.5))
	leftLayout:setPosition(ccp(0, 0))
	--中间的layout
	middleLayout = ccs.panel({
		scale9 = false,
		image = "",
		size = CCSizeMake(LayoutW/3, LayoutH),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	middleLayout:setAnchorPoint(ccp(0.5,0.5))
	middleLayout:setPosition(ccp(0, 0))
	--右边的layout
	rightLayout = ccs.panel({
		scale9 = false,
		image = "",
		size = CCSizeMake(LayoutW, LayoutH),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	rightLayout:setAnchorPoint(ccp(0.5,0.5))
	rightLayout:setPosition(ccp(0, 0))

	for i=1,5 do
		local leftImg = ccs.image({
			scale9 = false,
			image = CommonControl.miniGameGetResource(string.format("ui_lhj_shuiguo0%d.png",i)),
			size = CCSizeMake(54, 70),
		})
		leftPicArray[i] = {}
		leftPicArray[i]["img"] = leftImg
		leftPicArray[i]["id"] = i
		local middleImg = ccs.image({
			scale9 = false,
			image = CommonControl.miniGameGetResource(string.format("ui_lhj_shuiguo0%d.png",i)),
			size = CCSizeMake(54, 70),
		})
		middlePicArray[i] = {}
		middlePicArray[i]["img"] = middleImg
		middlePicArray[i]["id"] = i
		local rightImg = ccs.image({
			scale9 = false,
			image = CommonControl.miniGameGetResource(string.format("ui_lhj_shuiguo0%d.png",i)),
			size = CCSizeMake(54, 70),
		})
		rightPicArray[i] = {}
		rightPicArray[i]["img"] = rightImg
		rightPicArray[i]["id"] = i
	end

	fruitImgHeight = math.floor(leftPicArray[1].img:getContentSize().height * 1.3);
	fruitImgWidth = leftPicArray[1].img:getContentSize().width;

	begHeight = Panel_bibeiji:getSize().height;
	ImageView_bj1_x = ImageView_bj1:getPosition().x;
	ImageView_bj1_y = ImageView_bj1:getPosition().y;
	--比倍机锚点坐标
	Panel_79_x = Panel_bibeiji:getPosition().x;
	Panel_79_y = Panel_bibeiji:getPosition().y;
	isChange = true

	--初始化水果机的layout
	for i = 1,5 do
		initFruitScrewLayout(i, true)
		leftLayout:addChild(leftPicArray[i].img)
		middleLayout:addChild(middlePicArray[i].img)
		rightLayout:addChild(rightPicArray[i].img)
	end

	lightImage = ccs.image({
		scale9 = false,
		image = CommonControl.miniGameGetResource("blink_light_1.png"),
		size = CCSizeMake(54, 70),
	})
	lightImage:setAnchorPoint(ccp(0.5,0.5))
	lightImage:setPosition(ccp(-LayoutW, 0))
	ImageView_Left:addChild(lightImage)
	lightImage:setVisible(false)
	--设置第五个水果的位置

	ImageView_Left:addChild(rightLayout)
	ImageView_Center:addChild(middleLayout)
	ImageView_Center:addChild(leftLayout)

	talkRectWidth = Panel_scroll_title:getSize().width
	talkRectHeight = Panel_scroll_title:getSize().height


	Common.setButtonVisible(Button_stop, false)--停止按钮不可见
	sendSLOT_ROLL_MESSAGE() --获取滚动信息和滚动的条目

	sendSLOT_RICK_WINNING_RECORD(0) --获取得奖信息（5秒钟发一次，目前只是实验）

	--	foreverLight() --永远闪烁的灯
	--设置金币飞向位置的坐标
	coinMoveToPosit["x"] = Panel_laohuji:getPosition().x + ImageView_totalcoinBack:getPosition().x
	coinMoveToPosit["y"] = Panel_laohuji:getPosition().y + ImageView_totalcoinBack:getPosition().y
	--获得当前屏幕的大小
	windowSize["width"] = CCDirector:sharedDirector():getWinSize().width
	windowSize["height"] = CCDirector:sharedDirector():getWinSize().height

	doubleArray = {}

	isLeftFirstMove = true
	isMiddleFirstMove = true-- 用来判断是不是左边第一个移动的图片
	isRightFirstMove = true-- 用来判断是不是左边第一个移动的图片
	isFirstGetMsg = true

	initBeg()

	BegMachineLogic.initBegData(gameType, ImageView_paidaxiao, LabelAtlas_win_coin, Label_beg_total_coin, Label_fruit_total_coin, ImageView_poker, ImageView_poker_kind, historyUserData, buttonTable, resultAnimaPoint, view, coinMoveToPosit, coinBatchNode)

	--检测是否有历史比倍记录，如果有则执行收钱操作
	loadHistory()
	--初始化加注基本信息
	initStreak()
end

--[[--
初始化比倍机的相关数据
--]]
function initBeg()
	initHistoryData() --将比倍历史控件放入到数组中
	initButton() --将大小加倍3个按钮放入到table中
	initAnimaPoint()--初始化动画的坐标点
	BegMachineLogic.setHistoryBackPath(hisBackPath) --设置历史记录背景图片的路径
end

--[[--
--初始化加注基本信息
--]]
function initStreak()
	local coin = profile.User.getSelfCoin()
	local num = 1
	local itemTable = Common.LoadTable(FRUITSTAKEKEY)
	if itemTable ~= nil and itemTable[1].rate ~= nil then
		for i = 1, #itemTable do
			if (tonumber(coin) / 20) >= tonumber(itemTable[i].coin) and tonumber(itemTable[i].coin) <= 10000 then
				setRaiseLabel(itemTable[i].coin)
				currentRewardRate = itemTable[i].rate
				updateRaiseRate(currentRewardRate)
				num = i
			elseif (tonumber(coin) / 20) > 0 and (tonumber(coin) / 20) < tonumber(itemTable[1].coin) then
				setRaiseLabel(itemTable[1].coin)
				currentRewardRate = itemTable[1].rate
				updateRaiseRate(currentRewardRate)
				num = 1
			end
		end
		stakeIndex = num
	end
end

--[[--
将比倍历史的空间放入到一个table中
--]]
function initHistoryData()
	historyUserData = {}

	historyUserData[1] = {}
	historyUserData[1].back = ImageView_result_back1
	historyUserData[1].kind = ImageView_result_poker_kind1
	historyUserData[1].num = ImageView_result_poker1

	historyUserData[2] = {}
	historyUserData[2].back = ImageView_result_back2
	historyUserData[2].kind = ImageView_result_poker_kind2
	historyUserData[2].num = ImageView_result_poker2

	historyUserData[3] = {}
	historyUserData[3].back = ImageView_result_back3
	historyUserData[3].kind = ImageView_result_poker_kind3
	historyUserData[3].num = ImageView_result_poker3

	historyUserData[4] = {}
	historyUserData[4].back = ImageView_result_back4
	historyUserData[4].kind = ImageView_result_poker_kind4
	historyUserData[4].num = ImageView_result_poker4

	historyUserData[5] = {}
	historyUserData[5].back = ImageView_result_back5
	historyUserData[5].kind = ImageView_result_poker_kind5
	historyUserData[5].num = ImageView_result_poker5

	historyUserData[6] = {}
	historyUserData[6].back = ImageView_result_back6
	historyUserData[6].kind = ImageView_result_poker_kind6
	historyUserData[6].num = ImageView_result_poker6

	historyUserData[7] = {}
	historyUserData[7].back = ImageView_result_back7
	historyUserData[7].kind = ImageView_result_poker_kind7
	historyUserData[7].num = ImageView_result_poker7

	historyUserData[8] = {}
	historyUserData[8].back = ImageView_result_back8
	historyUserData[8].kind = ImageView_result_poker_kind8
	historyUserData[8].num = ImageView_result_poker8
end

--[[--
将大，小，加倍全部放入到一个table中，以便传给begMachineLogic
--]]
function initButton()
	buttonTable = {}
	buttonTable.big = Button_big
	buttonTable.small = Button_small
	buttonTable.double = Button_double
end

--[[--
初始化点击大小以后，盖章动画的坐标（输赢平）
--]]
function initAnimaPoint()
	resultAnimaPoint = {}
	resultAnimaPoint["x"] = Panel_79_x + ImageView_paidaxiao:getPosition().x + ImageView_bj1_x
	resultAnimaPoint.y = begHeight + Panel_79_y + ImageView_bj1_y + ImageView_paidaxiao:getPosition().y
end



--初始化水果机转动的相关数据layout
function initFruitScrewLayout(num, isInit)
	leftLayout:setPosition(ccp(-fruitBlackBack.width/3, 0))
	middleLayout:setPosition(ccp(0, 0))
	rightLayout:setPosition(ccp(fruitBlackBack.width/3, 0))
	--	for i = 1,4 do
	leftPicArray[num].img:setAnchorPoint(ccp(0.5,0.5))
	leftPicArray[num].img:setPosition(ccp(fruitBlackBack.width/3/2, (num - 1)*fruitImgHeight + fruitBlackBack.height / 2))

	middlePicArray[num].img:setAnchorPoint(ccp(0.5, 0.5))
	middlePicArray[num].img:setPosition(ccp(fruitBlackBack.width/3/2, (num - 1)*fruitImgHeight + fruitBlackBack.height / 2))

	rightPicArray[num].img:setAnchorPoint(ccp(0.5,0.5))
	rightPicArray[num].img:setPosition(ccp(fruitBlackBack.width/3/2,  (num - 1)*fruitImgHeight + fruitBlackBack.height / 2))
	if(num == 5)then
		leftPicArray[num].img:setAnchorPoint(ccp(0.5,0.5))
		leftPicArray[num].img:setPosition(ccp(fruitBlackBack.width/3/2, -fruitImgHeight + fruitBlackBack.height / 2))
		middlePicArray[num].img:setAnchorPoint(ccp(0.5, 0.5))
		middlePicArray[num].img:setPosition(ccp(fruitBlackBack.width/3/2, -fruitImgHeight + fruitBlackBack.height / 2))
		rightPicArray[num].img:setAnchorPoint(ccp(0.5,0.5))
		rightPicArray[num].img:setPosition(ccp(fruitBlackBack.width/3/2,  -fruitImgHeight + fruitBlackBack.height / 2))
	end
	--	end
	--设置第五个水果的位置
	if (not isInit)then
		leftPicArray[4].img:setVisible(false)
		middlePicArray[4].img:setVisible(false)
		rightPicArray[4].img:setVisible(false)
		--		ImageView_shelter:setVisible(false)
	end
end

--[[--
将最上方的水果设置为可以显示
--]]
function visibleFruit()
	ImageView_shelter:setVisible(true)
	leftPicArray[4].img:setVisible(true)
	middlePicArray[4].img:setVisible(true)
	rightPicArray[4].img:setVisible(true)
end

--[[--
设置第五个水果的起始位置
--]]
function lastFruitInitPosition()
	leftPicArray[5].img:setAnchorPoint(ccp(0.5,0.5))
	leftPicArray[5].img:setPosition(ccp(fruitBlackBack.width/3/2, -fruitImgHeight + fruitBlackBack.height / 2))

	middlePicArray[5].img:setAnchorPoint(ccp(0.5, 0.5))
	middlePicArray[5].img:setPosition(ccp(fruitBlackBack.width/3/2, -fruitImgHeight+ fruitBlackBack.height / 2))

	rightPicArray[5].img:setAnchorPoint(ccp(0.5,0.5))
	rightPicArray[5].img:setPosition(ccp(fruitBlackBack.width/3/2,  -fruitImgHeight+ fruitBlackBack.height / 2))

	leftLayout:addChild(leftPicArray[5].img)
	middleLayout:addChild(middlePicArray[5].img)
	rightLayout:addChild(rightPicArray[5].img)
end


isStartFruitCall = false --布尔值，用来判断此处的更新总金币数量是不是因为开始水果机转动的时候来造成的，此数据由开始老虎机设置为true，由本函数设置为false(仅此两处)
local function setUserInfo()
	intoBegCoin = profile.User.getSelfCoin()
	if isStartFruitCall then
		Label_fruit_total_coin:setText(tostring(intoBegCoin))
		Label_beg_total_coin:setText(tostring(intoBegCoin))
		isStartFruitCall = false
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("load_res/FruitMachineRes/FruitMachine.json")
	local gui = GUI_MINIGAME_FRUIT_MACHINE
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
	GameConfig.setTheCurrentBaseLayer(GUI_MINIGAME_FRUIT_MACHINE)
	GameStartConfig.addChildForScene(view)
	initView()
	initRewardPoolBaseInfo()
	initData()
	--进入小游戏请求是否有打赏
	reqRewardOnEnterGame()
	local function delaySentMessage()

	end
	--这个函数不知道是干什么用的，个人认为是展示图片或者loding之类的
	--	LordGamePub.runSenceAction(Panel_20, delaySentMessage, false)
	sendSLOT_READY_INFO()
	setUserInfo()
	setJiQiButton()
end



function setJiQiButton()
	if miniGameState == SHOW_LAO_HU_JI then
		begViewReset()
	elseif miniGameState == SHOW_BI_BEI_JI then
		fruitViewReset()
	end
end


function changePanel(direction)

	if direction == DIR_UP then
		--切换比倍机
		miniGameState = SHOW_BI_BEI_JI
		CommonControl.showAnimaReadyByDir(direction, Panel_laohuji, Panel_bibeiji, "bibeiBackGround.mp3")
		--将水果机的状态和数据初始化
		fruitViewReset()
		--停止并隐藏滚动闪光
		stopLightAnimation()
		BegMachineLogic.changePoker()
		BegMachineLogic.setHandselInfo(handselInfo)
		BegMachineLogic.begCanPress()--设置比倍机界面的按钮可以点击
		BegMachineLogic.clearShareData()
	elseif direction == DIR_DOWN then
		--切换老虎机
		miniGameState = SHOW_LAO_HU_JI
		sendDBID_USER_INFO(profile.User.getSelfUserID())
		CommonControl.showAnimaReadyByDir(direction, Panel_laohuji, Panel_bibeiji, "fanpaiBackGroundSound.mp3", changeToSlotCallBack)
		BegMachineLogic.clearData()
		Label_beg_total_rate_five:setVisible(true)
		Label_beg_total_rate_eight:setVisible(true)
		begViewReset()
		overStartCallBack()
		view:setTouchEnabled(true)
		if BegMachineLogic.isExistReward then
			Common.log("reqIsExistRewardInfo========1")
			sendIMID_MINI_REWARDS_COLLECT(gameType)
			BegMachineLogic.isExistReward = false
		end
		--初始化比倍机的数据
		BegMachineLogic.miniGameShare()
	end
end

--[[--
切换到老虎机的回调函数
--]]
function changeToSlotCallBack()
	visibleFruit()
end


--设置注数
function setRaiseLabel(string)
	string = string or "0"
	LabelAtlas_raise_coin:setStringValue(tostring(string))
end

function requestMsg()

end

function callback_Button_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.log("button_back is clicked == "..miniGameState)
		if (miniGameState == SHOW_LAO_HU_JI)then
			mvcEngine.createModule(GameConfig.getTheLastBaseLayer())
		else
			BegMachineLogic.collectMoney()
		end
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
			sendGIFTBAGID_GET_LOOP_GIFT(102)
		else
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--水果机加注
function callback_Button_raise(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if (prepareRaiseArray == nil or prepareRaiseArray["Raise"] == nil or prepareRaiseArray["Raise"].currentLevel == nil) then
			return
		end
		prepareRaiseArray["Raise"].currentLevel = prepareRaiseArray["Raise"].currentLevel + 1
		prepareRaiseArray["Raise"].currentLevel = prepareRaiseArray["Raise"].currentLevel <= #prepareRaiseArray["Raise"] and prepareRaiseArray["Raise"].currentLevel  or 1
		setRaiseLabel(prepareRaiseArray["Raise"][prepareRaiseArray["Raise"].currentLevel].coin)
		currentRewardRate = prepareRaiseArray["Raise"][prepareRaiseArray["Raise"].currentLevel].rate
		updateRaiseRate(currentRewardRate)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_auto(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		isAutoPlay = true

		startAction(startCommonFunC)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_ImageView_lagan(component)
	if component == PUSH_DOWN then
		--按下
		startAction(startCommonFunC)
	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_start(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		startAction(startCommonFunC)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_dashang(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		BegMachineLogic.getMiniGameRewardsCallBack(imageRewardType)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
点击开始所需要执行的函数，在拉杆和开始的时候调用
--]]
function startAction(callBack)
	currentRaise = tonumber(LabelAtlas_raise_coin:getStringValue())
	local raise = tonumber(currentRaise)
	local currentCoin = tonumber(profile.User.getSelfCoin())
	if (raise <= currentCoin)then
		--			startCommonFunC()
		callBack()
		clickStartCallBack()
		if (isAutoPlay)then
			clickAutoCallBack()
		end
	else
		rechargeGuide(raise - currentCoin)
	end

end


--[[--
点击自动以后每次需要回调的函数
--]]
function autoStart()
	currentRaise = LabelAtlas_raise_coin:getStringValue()
	local raise = tonumber(currentRaise)
	local currentCoin = tonumber(profile.User.getSelfCoin())
	if (raise <= currentCoin)then
		startCommonFunC()
	else
		rechargeGuide(raise - currentCoin)
	end
end

--[[--
执行开始的时候所需要执行的公共函数
--]]
function startCommonFunC()
	sendSLOT_ACCEPT_THE_PRIZE()
	--播放转动声音
	fruitScrollSound()
	isLeftStop = false
	isMiddleStop = false
	isRightStop = false
	isAllStop = false
	leftTime = 0.6
	middleTime = 0.65
	rightTime = 0.7
	leftScrew()
	middleScrew()
	rightScrew()
	isTrolleyMove = true
	trolleyAnimation()
	isStartFruitCall = true
end

function callback_Button_stop(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		clickCancelAutoCallBack()
		if (isAllStop)then
			overStartCallBack()
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_fruit_recharge(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		fruitRechargeCallback()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_beg_recharge(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		fruitRechargeCallback()
	elseif component == CANCEL_UP then
	--取消

	end
end
--成为VIP按钮点击事件
function callback_Button_Vip(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		sendMANAGERID_VIPV2_GET_GIFTBAG(profile.VIPState.getVipStatus(), profile.VIPState.getVipPrice())
	elseif component == CANCEL_UP then
	--取消

	end
end

--收钱的点击事件
function callback_Button_collect(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		BegMachineLogic.collectMoney()
		--抬起
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_big(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		table.insert(doubleArray, isDouble)
		storeHistory()
		isDouble = 0
		BegMachineLogic.stopPokerChange()
		BegMachineLogic.begCallBack(BIG, doubleArray)
		if(handselInfo[#doubleArray] ~= 0) then
			view:setTouchEnabled(false)
		end
		BegMachineLogic.pokerResult()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_small(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--调用点击大小的相关方法
		table.insert(doubleArray, isDouble)
		storeHistory()
		isDouble = 0
		BegMachineLogic.stopPokerChange()
		BegMachineLogic.begCallBack(SMALL, doubleArray)
		if(handselInfo[#doubleArray] ~= 0) then
			view:setTouchEnabled(false)
		end
		BegMachineLogic.pokerResult()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_double(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if (tonumber(intoBegCoin) >= tonumber(LabelAtlas_win_coin:getStringValue())) then
			isDouble = 1;
			--减钱
			intoBegCoin = tonumber(intoBegCoin) - tonumber(LabelAtlas_win_coin:getStringValue())
			Label_beg_total_coin:setText(tostring(intoBegCoin))
			BegMachineLogic.setWinCoin(tonumber(LabelAtlas_win_coin:getStringValue()))
			Button_double:setTouchEnabled(false)
			BegMachineLogic.buttonBegSetState(false)
		else
			BegMachineLogic.buttonBegSetState(false)
			CommonControl.rechargeGuide(tonumber(LabelAtlas_win_coin:getStringValue()) - tonumber(intoBegCoin))
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
弹出充值引导
--]]
function rechargeGuide(coin)
	CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, coin, 0)
end


-----获取准备信息----
function updataReadyInfo()
	local coin = profile.User.getSelfCoin()
	prepareRaiseArray = profile.ShuiGuoJi.getReadyInfo()
	local num = 1
	local itemTable = Common.LoadTable(FRUITSTAKEKEY)
	if itemTable == nil then
		for i = 1, #prepareRaiseArray["Raise"] do
			if (tonumber(coin) / 20) >= tonumber(prepareRaiseArray["Raise"][i].coin) and tonumber(prepareRaiseArray["Raise"][i].coin) <= 10000 then
				setRaiseLabel(prepareRaiseArray["Raise"][i].coin)
				currentRewardRate = prepareRaiseArray["Raise"][i].rate
				updateRaiseRate(currentRewardRate)
				num = i
			elseif (tonumber(coin) / 20) > 0 and (tonumber(coin) / 20) < tonumber(prepareRaiseArray["Raise"][1].coin) then
				setRaiseLabel(prepareRaiseArray["Raise"][1].coin)
				currentRewardRate = prepareRaiseArray["Raise"][1].rate
				updateRaiseRate(currentRewardRate)
				num = 1
			end
		end
		stakeIndex = num
	end
	Common.SaveTable(FRUITSTAKEKEY, prepareRaiseArray["Raise"])
	prepareRaiseArray["Raise"].currentLevel = stakeIndex
	CommonControl.bonusExplain(4, rightVipRateLable, prepareRaiseArray["VipRaise"])
	Common.closeProgressDialog()
end

--[[--
--根据加注设置彩金加奖比例
--]]
function updateRaiseRate(num)
	local rateNum = nil
	if num == nil then
		rateNum = currentRewardRate + 50
	else
		rateNum = num + 2
		Label_beg_total_rate_five:setText(rateNum.."%");--
		Label_beg_total_rate_eight:setText((currentRewardRate + 50).."%");--
	end
	local scaleBig = CCScaleTo:create(0.1, 1.2)
	local scaleSmall = CCScaleTo:create(0.1, 1)
	local array = CCArray:create()
	array:addObject(scaleBig)
	array:addObject(scaleSmall)
	local seq = CCSequence:create(array)
	Label_caichi_rate_main:setText(rateNum.."%");
	Label_caichi_rate_main:runAction(seq)
end

--[[--
--播放转动的声音
--]]
function fruitScrollSound()
	CommonControl.playEffect("shuiguojiredhand.mp3",false)
	local delay = CCDelayTime:create(0.5)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(
		function()
			CommonControl.playEffect("shuiguojiScroll.mp3",true)
		end
	))
	local seq = CCSequence:create(array)
	view:runAction(seq)
end

------获取滚动信息
function getTableOfMessage()
	--已经获取了滚动信息
	isRequestRollMessage = true
	local itemTable = profile.ShuiGuoJi.getTableOfMESSAGEInfo()
	--存储滚动信息
	scrollTitleArray = Common.copyTab(itemTable.WinMsgNum)
	--修改奖池中的奖金
	RewardPoolNum = string.match(itemTable.HandselMsg, "%d+")
	--	LabelAtlas_fruit_current_jackpot:setStringValue(pool)
	if isRollRewardEnabled then
		scrollRewardNumber()
	end
	if itemTable ~= nil and itemTable.WinMsgNum[1] ~= nil then
		FruitMessageOfLastID = itemTable.WinMsgNum[#itemTable.WinMsgNum].ItemID
		if (isFirstGetMsg)then
			movePrizeInfo(Label_talk, talkRectWidth, talkRectHeight, scrollTitleArray)
			isFirstGetMsg = false
		end
	end
end


winImg = {}

---获取老虎机领奖消息
function getTableOfwin()
	local itemTable = profile.ShuiGuoJi.getTableOfPRIZEInfo()
	if itemTable == nil or itemTable.img == nil then
		Common.showToast("数据异常", 2)
	else
		winImg[1],winImg[2],winImg[3] = string.match(itemTable.img,"(.+),(.+),(.+)")
		winImg[1] = tonumber(winImg[1] + 1)
		winImg[2] = tonumber(winImg[2] + 1)
		winImg[3] = tonumber(winImg[3] + 1)
	end

	WinPoolInfo = {}
	BegMachineLogic.isWinReward = (itemTable.Winpool == 1 and  true or false) --是否能获得彩金并能分享
	WinPoolInfo.isGetWinpool = (itemTable.Winpool == 1 and  true or false) --是否能获得奖池奖金
	WinPoolInfo.WinCoinNum = itemTable.WinCoinNum----奖金数量
	WinPoolInfo.pollMsg = itemTable.pollMsg--获得奖池描述

	handselInfo = itemTable.handselPool--彩金信息(5次或者8次的彩金，这是一个数组)
	isSuccess = (itemTable.success == 1 and true or false) --是否获胜
	isJoinRisk = (itemTable.JoinRisk == 1 and true or false) --是否能够进入比倍机

	moneyOfWin = itemTable.coin --赢得的金币数量
	LabelAtlas_win_coin:setStringValue(tostring(moneyOfWin))

	--************需要设置准许赢几次***************
	local num = itemTable["WinTime"][1] + itemTable["WinTime"][2]
	BegMachineLogic.setWinTimes(num)
--		Common.showToast("可以赢" .. num, 2)
end


------获取收钱信息信息
function getTableOfCOLLECT_MONEY()
	local itemTable = profile.ShuiGuoJi.getTableOfCOLLECT_MONEYInfo()
	moneyOfWin = itemTable.Coin
	if(isCollectLast)then
		Common.closeProgressDialog()
	end

	Common.log("itemTable.Coin = "..itemTable.Coin)
	if(itemTable.Successed == 1)then
		if(itemTable.Coin > 0)then
			--	if(itemTable.Successed == 1 and itemTable.Coin > 0)then
			if currentRaise == 0 then
				currentRaise = 200
			end
			local coinNum = itemTable.Coin / (currentRaise / 2)
			if (isCollectLast)then
				DropCoinLogic.dropCoin(coinNum, Label_fruit_total_coin, currentRaise / 2, doRewards, ccp(coinMoveToPosit.x, coinMoveToPosit.y), coinBatchNode, windowSize.width, windowSize.height)
			else
				DropCoinLogic.dropCoin(coinNum, Label_beg_total_coin, currentRaise / 2, doRewards, ccp(coinMoveToPosit.x, coinMoveToPosit.y), coinBatchNode, windowSize.width, windowSize.height)
			end
		else
			collectCallBack()
		end
	end
	--此处应该有的逻辑是掉落金币界面，然后还应该有一个切换回去的动画，动画应该写在其他的地方

	--Important 记得清空
	if(itemTable.Successed == 1)then
		Common.SaveTable(profile.User.getSelfUserID().."FruitMachine",{})--清空本地比倍记录
	end
	--美女感谢
	if itemTable.mmLoveYou ~= "" and itemTable.mmLoveYou ~= nil then
		Common.log("BegMachineLogic==美女感谢"..itemTable.mmLoveYou)
		BegMachineLogic.BelleSpeech = itemTable.mmLoveYou
		imageRewardType = BegMachineLogic.IMAGEREWARDGIRL
		BegMachineLogic.getMiniGameRewards(Image_dashang, Image_Reward, Label_Reward, imageRewardType)
	end
end

--[[--
--获取打赏基本信息判断
--]]
function getMiniGameRewardInfoJudge()
	local dataTable = profile.MiniGameChat.getMiniGameRewardsInfoTable()
	if dataTable["RewardLevel"] ~= nil then
		isExistRewardBaseInfo = true
		Common.log("dataTable.RewardLevel = "..dataTable.RewardLevel)
		RewardLevel = dataTable["RewardLevel"]
	end
end

--[[--
--收钱后打赏
--]]
function doRewards()
--	if moneyOfWin >= RewardLevel and isExistRewardBaseInfo then
--		BegMachineLogic.isShareEnabled = false
--		collectCallBack()
--		BegMachineLogic.showRewardLayer()
--	else
		collectCallBack()
--	end
end

--[[--
--界面减金币操作
--]]
function subDisplayCoin()
	isStartFruitCall = true
	userCurrentCoin = profile.User.getSelfCoin()
	Label_beg_total_coin:setText(tostring(intoBegCoin))
	Label_fruit_total_coin:setText(tostring(intoBegCoin))
end

isCollectLast = false --用来判断是不是收取上次异常退出时，没有收钱的情况
--[[--
收钱时候的动画
--]]
function collectCallBack()
	if (not isCollectLast)then
		changePanel(DIR_DOWN)
	else
		isCollectLast = false
	end
end


function getTableOfSLOT_RICK_WINNING_RECORD()
	local itemTable = profile.ShuiGuoJi.getTableOfSLOT_RICK_WINNING_RECORD()
	timestamp = itemTable.Timestamp
	local recordArray = Common.copyTab(itemTable.RecordList)
	--当有新数据的时候，将数据添加在最后
	for i=1, #recordArray do
		table.insert(winRecordArray, recordArray[i])
	end
	--	awardsCount = 5
	--当第一次收到老虎机活校信息的时候，初始化table
	if (not isInitUpAwards)then
		if (#winRecordArray >= 5) then
			CommonControl.upAwards(ScrollView_recordList, winRecordArray, timestamp, gameType)
			isInitUpAwards = true
		else
			sendSLOT_RICK_WINNING_RECORD(timestamp)
		end
	else
		CommonControl.setUpawards(winRecordArray, timestamp)
	end
end



--判断当前左边和中间是不是已经降至最低素的
isLeftLowest = false
isMiddleLowest = false
isLeftFirstMove = true-- 用来判断是不是左边第一个移动的图片
leftLayoutCurrent = 0--左边layout的当前坐标

--[[--
左边转动的相关代码，中间转动与右边转动与此处相同
--]]
function leftScrew()
	--如果是第一次转动，设置当前展示的图片位置
	if (isLeftFirstMove)then
		isLeftFirstMove = false
		leftLayoutCurrent = leftLayout:getPosition().y + leftPicArray[5].img:getPosition().y + fruitImgHeight
	end
	--在规定的时间内，每次移动一个水果的高度
	local leftMove = CCMoveBy:create(leftTime, ccp(0, -fruitImgHeight))
	local arrayLeft = CCArray:create()
	arrayLeft:addObject(leftMove)
	arrayLeft:addObject(CCCallFuncN:create(leftRunAnima))
	leftLayout:runAction(CCSequence:create(arrayLeft))
end

--左边部分跑动的动画处理，根据move的图片，（即当前最上方的图片，来计算下次需要move的图片以及当前显示的图片）
function leftRunAnima()

	--判断当前哪一张图片是在最下方，然后将其移动到顶部
	for i = 1, 5 do
		if (leftPicArray[i].img:getPosition().y < leftLayoutCurrent)then
			leftPicArray[i].img:setPosition(ccp(leftPicArray[i].img:getPosition().x, leftPicArray[i].img:getPosition().y + 5*fruitImgHeight))
		end
	end
	--记录当前展示图片时候的layout高度
	leftLayoutCurrent = leftLayoutCurrent + fruitImgHeight
	--进行加速（即左方的移动时间变短）
	if ((leftTime > MAX_SPEED) and (not leftIsMax))then
		leftTime = leftTime * 0.5
	else
		leftIsMax = true
	end
	--当达到最大速度的时候，开始进行技术，在最大素的的情况下转过多少张图片
	if (leftIsMax and leftInMaxCount <= MAX_SPEED_COUNT) then
		leftInMaxCount = leftInMaxCount + 1
	end
	--当达到最大速度以后，并且已经转过足够多的图片，开始减速
	if (leftInMaxCount > MAX_SPEED_COUNT) then
		leftTime = leftTime * 1.4
		if (leftTime >= 0.2) then --设置停止的速度为0.25
			leftTime = 0.2
			--减速到最后进行停止
			isLeftStop = isRightImg(leftLayoutCurrent,leftPicArray,winImg[1])
		end
	end

	--如果左边没有停止，则回调leftScrew函数继续进行转动
	if (not isLeftStop) then
		leftScrew()
	end
end


--[[--
@param #num currentShowY 用来表示当前所展示的收
--]]
function isRightImg(currentShowY, pic, img)
	local isStop = false
	for i = 1, 5 do
		Common.log("currentShowY====="..currentShowY.."pic[i].img:getPosition().y===="..pic[i].img:getPosition().y)
		if (math.floor(currentShowY) == math.floor(pic[i].img:getPosition().y) and pic[i].id == img) then
			CommonControl.playEffect("shuiguojiStop.mp3",false)
			isStop = true
			Common.log("isRightImg====")

		end
	end
	return isStop
end

--[[--
--中间部分
--]]
isMiddleFirstMove = true-- 用来判断是不是左边第一个移动的图片
middleLayoutCurrent = 0--左边layout的当前坐标
function middleScrew()
	if (isMiddleFirstMove)then
		isMiddleFirstMove = false
		middleLayoutCurrent = middleLayout:getPosition().y + fruitBlackBack.height / 2
	end
	local middleMove = CCMoveBy:create(middleTime, ccp(0, -fruitImgHeight))
	local arraymiddle = CCArray:create()
	arraymiddle:addObject(middleMove)
	arraymiddle:addObject(CCCallFuncN:create(middleRunAnima))
	middleLayout:runAction(CCSequence:create(arraymiddle))

end

--中间部分跑动的动画处理
function middleRunAnima()

	middleLayoutCurrent = middleLayoutCurrent + fruitImgHeight

	for i = 1, 5 do
		if (middlePicArray[i].img:getPosition().y < middleLayoutCurrent - fruitImgHeight)then
			middlePicArray[i].img:setPosition(ccp(middlePicArray[i].img:getPosition().x, middlePicArray[i].img:getPosition().y + 5*fruitImgHeight))
		end
	end

	if ((middleTime > MAX_SPEED) and (not middleIsMax))then
		middleTime = middleTime * 0.5
	else
		middleIsMax = true
	end
	if (middleIsMax and middleInMaxCount <= MAX_SPEED_COUNT) then
		middleInMaxCount = middleInMaxCount + 1
		if (not isLeftStop) then
			middleInMaxCount = MAX_SPEED_COUNT
		end
	end
	if (middleInMaxCount > MAX_SPEED_COUNT) then
		middleTime = middleTime * 1.4
		if (middleTime >= 0.2) then --设置停止的速度为25
			middleTime = 0.2
			--看看是不是当前的图片
			isMiddleStop = isRightImg(middleLayoutCurrent,middlePicArray,winImg[2])
		end
	end

	if (not isMiddleStop) then
		middleScrew()
	end
end


--[[--
--右边部分
--]]
--右边转动
isRightFirstMove = true-- 用来判断是不是左边第一个移动的图片
rightLayoutCurrent = 0--左边layout的当前坐标
function rightScrew()
	if (isRightFirstMove)then
		isRightFirstMove = false
		rightLayoutCurrent = rightLayout:getPosition().y + rightPicArray[5].img:getPosition().y + fruitImgHeight
	end
	local rightMove = CCMoveBy:create(rightTime, ccp(0, -fruitImgHeight))
	local arrayRight = CCArray:create()
	arrayRight:addObject(rightMove)
	arrayRight:addObject(CCCallFuncN:create(rightRunAnima))
	rightLayout:runAction(CCSequence:create(arrayRight))
end


--[[--
--右边部分跑动的动画处理
--]]
function rightRunAnima()
	rightLayoutCurrent = rightLayoutCurrent + fruitImgHeight

	for i = 1, 5 do
		if (rightPicArray[i].img:getPosition().y < rightLayoutCurrent - fruitImgHeight)then
			rightPicArray[i].img:setPosition(ccp(rightPicArray[i].img:getPosition().x, rightPicArray[i].img:getPosition().y + 5*fruitImgHeight))
		end
	end

	if ((rightTime > MAX_SPEED) and (not rightIsMax))then
		rightTime = rightTime * 0.5
	else
		rightIsMax = true
	end

	if (rightIsMax and rightInMaxCount <= MAX_SPEED_COUNT) then
		rightInMaxCount = rightInMaxCount + 1
		if (not isMiddleStop)then
			rightInMaxCount = MAX_SPEED_COUNT
		end
	end

	if (rightInMaxCount > MAX_SPEED_COUNT) then
		rightTime = rightTime * 1.4
		if (rightTime >= 0.2) then --设置停止的速度为1
			rightTime = 0.2
			--看看是不是当前的图片
			isRightStop = isRightImg(rightLayoutCurrent,rightPicArray,winImg[3])
		end
	end

	if (not isRightStop) then
		rightScrew()
	end
	if (isLeftStop and isMiddleStop and isRightStop)then
		SimpleAudioEngine:sharedEngine():playEffect("shuiguojiStop.mp3", false);
		isAllStop = true
		if (isAllStop)then

			if (not isAutoPlay and not isJoinRisk)then
				--如果没有点击自动按钮的话，回调此函数，可以点击开始和自动按钮
				overStartCallBack()
			end
			--如果中奖，应该执行的相关逻辑
			if isJoinRisk then
				isWinLight = true
				--				fruitWinLight()
				if WinPoolInfo.isGetWinpool then
					--掉落金币
					CommonControl.showWinRewardAnimation()
					local coinNum = math.ceil(WinPoolInfo.WinCoinNum / currentRaise)
					DropCoinLogic.dropCoin(coinNum, Label_fruit_total_coin, currentRaise / 2, fruitWinLogic, ccp(coinMoveToPosit.x, coinMoveToPosit.y), coinBatchNode, windowSize.width, windowSize.height)
				else
					fruitWinLogic()
				end
			else
				initDataNotWin()
				if (isAutoPlay)then
					local delay = CCDelayTime:create(1)
					local array = CCArray:create()
					array:addObject(delay)
					array:addObject(CCCallFuncN:create(autoStart))
					--					array:addObject(CCCallFuncN:create(startCommonFunC))
					local seq = CCSequence:create(array)
					Panel_laohuji:runAction(seq)
				end
			end
		end
	end

end

--停止转动音乐
function stopRollMusic()
	local delay = CCDelayTime:create(0.6)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(
		function ()
			AudioManager.stopAllSound()
		end
	))
	local seq = CCSequence:create(array)
	view:runAction(seq)
end

---本地存储比倍记录--
function storeHistory()
	local itemTable = {}
	itemTable.addHistory = doubleArray
	Common.SaveTable(profile.User.getSelfUserID().."FruitMachine",itemTable)
end
--检测是否有未上传的本地比倍记录，如果有则进行处理--
function loadHistory()
	local itemTable = Common.LoadTable(profile.User.getSelfUserID().."FruitMachine")
	if(itemTable and itemTable.addHistory) then
		isCollectLast = true
		doubleArray = itemTable.addHistory
		Common.showProgressDialog("正在上传上次结果...")
		-------*******收钱操作及动画*******-------
		sendSLOT_RICK_COLLECT_MONEY(itemTable.addHistory)
	end
end

--[[--
--赢钱以后，隔两秒进行比倍机的切换
--]]
function fruitWinLogic()
	runLightAnimation()
	--灯的闪动
	local delay = CCDelayTime:create(2)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(fruitWinToBeg))
	local seq = CCSequence:create(array)
	Panel_laohuji:runAction(seq)
end
--[[--
老虎机或将以后，隔2秒需要做的操作，包括切换界面，设置总金币数量，初始化部分数据
--]]
function fruitWinToBeg()
	if (isAutoPlay) then
		clickCancelAutoCallBack()
	end
	Common.log("fruitWinToBeg----------------------")
	isWinLight = false
	--开始按钮，自动按钮盒比倍按钮可以点击
	--overStartCallBack()
	changePanel(DIR_UP)
	sendDBID_USER_INFO(profile.User.getSelfUserID())
end


--[[--
--点击自动按钮应该执行的操作
--]]
function clickAutoCallBack()
	Common.setButtonVisible(Button_start, false)
	Common.setButtonVisible(Button_auto, false)
	Common.setButtonVisible(Button_stop, true)
	buttonSlotSetState(false)
end


--[[--
--取消自动按钮应该执行的操作
--]]
function clickCancelAutoCallBack()
	Common.setButtonVisible(Button_start, true)
	Common.setButtonVisible(Button_auto, true)
	Common.setButtonVisible(Button_stop, false)

	Button_start:setTouchEnabled(false)
	Button_auto:setTouchEnabled(false)
	ImageView_lagan:setTouchEnabled(false)
	--	buttonSlotSetState(false)

	isAutoPlay = false
end


function buttonSlotSetState(isEnabled)
	if isEnabled then
		Button_start:loadTextures(CommonControl.miniGameGetResource("btn_lhj_kaishi01.png"),CommonControl.miniGameGetResource("btn_lhj_kaishi01.png"),"")
		Button_raise:loadTextures(CommonControl.miniGameGetResource("btn_lhj_jz01_01.png"),CommonControl.miniGameGetResource("btn_lhj_jz01_01.png"),"")
		Button_auto:loadTextures(CommonControl.miniGameGetResource("btn_lhj_zidong01.png"),CommonControl.miniGameGetResource("btn_lhj_zidong01.png"),"")
	else
		Button_start:loadTextures(CommonControl.miniGameGetResource("start_unpress.png"),CommonControl.miniGameGetResource("start_unpress.png"),"")
		Button_raise:loadTextures(CommonControl.miniGameGetResource("raise_unpress.png"),CommonControl.miniGameGetResource("raise_unpress.png"),"")
		Button_auto:loadTextures(CommonControl.miniGameGetResource("auto_unpress.png"),CommonControl.miniGameGetResource("auto_unpress.png"),"")
	end
end


--[[--
--点击开始应该屏蔽的按钮
--]]
function clickStartCallBack()
	Button_start:setTouchEnabled(false)
	Button_auto:setTouchEnabled(false)
	Button_raise:setTouchEnabled(false)
	ImageView_lagan:setTouchEnabled(false)
	buttonSlotSetState(false)
end

--[[--
--老虎机停止以后应该开启的按钮
--]]
function overStartCallBack()
	buttonSlotSetState(true)
	Button_start:setTouchEnabled(true)
	Button_auto:setTouchEnabled(true)
	Button_raise:setTouchEnabled(true)
	ImageView_lagan:setTouchEnabled(true)
end


---------------------*********充值按钮回调函数********---------------------
function fruitRechargeCallback()
	--	GameConfig.setTheLastBaseLayer(GUI_MINIGAME_FRUIT_MACHINE);
	local myyuanbao = profile.User.getSelfYuanBao()
	if myyuanbao >= 50 then
		Common.openConvertCoin()
	else
		--充值引导
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
		PayGuidePromptLogic.setEnterType(true)
	end
end

--[[------------------------闪动动画的的相关函数--------------]]
--[[--
--水果机底部始终闪动的动画
--]]
isForeverLightDef = true --用来判断是否是默认闪动的第一张图片
function foreverLight()
	if (isForeverLightDef)then
		ImageView_fruit_bottom_light:loadTexture(CommonControl.miniGameGetResource("ui_lhj_dh_01.png"))
	else
		ImageView_fruit_bottom_light:loadTexture(CommonControl.miniGameGetResource("ui_lhj_dh_02.png"))
	end
	isForeverLightDef = not isForeverLightDef
	local delay = CCDelayTime:create(0.2)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(foreverLight))
	local seq = CCSequence:create(array)
	ImageView_fruit_bottom_light:runAction(seq)
end

--[[--
--水果机中奖后需要闪烁的动画
--]]
function fruitWinLight()
	if(imgChange)then
		ImageView_fruit_pond_light:loadTexture(CommonControl.miniGameGetResource("ui_lhj_dh_deng01.png"))
		ImageView_jiqicv:loadTexture(CommonControl.miniGameGetResource("ui_lhj_jiqi1_01.png"))
	else
		ImageView_fruit_pond_light:loadTexture(CommonControl.miniGameGetResource("ui_lhj_dh_deng02.png"))
		ImageView_jiqicv:loadTexture(CommonControl.miniGameGetResource("ui_lhj_jiqi1_02.png"))
	end

	CommonControl.playEffect("lightshine.mp3",true)

	imgChange = not imgChange
	local delay = CCDelayTime:create(0.1)
	local array = CCArray:create()
	array:addObject(delay)
	if(isWinLight)then
	--		array:addObject(CCCallFuncN:create(fruitWinLight))
	end
	local seq = CCSequence:create(array)
	ImageView_fruit_caicibg:runAction(seq)
end

--[[--
--拉杆动画
--]]
function trolleyAnimation()
	--	ImageView_lagan:stopAllActions()
	local delay = CCDelayTime:create(0.1)
	local array = CCArray:create()
	local index = trolleyImgCount
	array:addObject(delay)
	if (trolleyImgCount >= 6)then
		index = 11 - trolleyImgCount
	end
	local path = string.format("draw_lhj_bar%d.png",index)
	ImageView_lagan:loadTexture(CommonControl.miniGameGetResource(path));
	trolleyImgCount = trolleyImgCount + 1
	if (isTrolleyMove)then
		array:addObject(CCCallFuncN:create(trolleyAnimation))
	end
	if (trolleyImgCount >=12)then
		isTrolleyMove = false
		trolleyImgCount = 0
	end

	local seq = CCSequence:create(array)
	ImageView_lagan:runAction(seq)
end


--老虎机未中奖的时候需要初始化的数据，
function initDataNotWin()
	--左半部分
	leftIsMax = false --判断当前的速度是否到达了最大的速度
	leftTime = 0 --转动的时间
	leftInMaxCount = 0 --在最大速度的情况下已经转几圈

	--中间部分
	middleIsMax = false
	middleTime = 0
	middleInMaxCount = 0

	--右半部分
	rightInMaxCount = 0
	rightTime = 0
	rightIsMax = false
	stopRollMusic()
end

--初始化老虎机转动时候所需要的数据
function initFruitMachineData()
	--左半部分
	leftTime = 0 --转动的时间
	leftInMaxCount = 0 --在最大速度的情况下已经转几圈
	leftIsMax = false --判断当前的速度是否到达了最大的速度
	isLeftStop = true
	isLeftFirstMove = true
	leftLayoutCurrent = 0

	--中间部分
	middleTime = 0 --转动的时间
	middleInMaxCount = 0 --在最大速度的情况下已经转几圈
	middleIsMax = false --判断当前的速度是否到达了最大的速度
	isMiddleStop = true --中间图片的转动是否停止
	isRightFirstMove = true-- 用来判断是不是左边第一个移动的图片
	rightLayoutCurrent = 0--左边layout的当前坐标

	--右半部分
	rightTime = 0 --转动的时间
	rightInMaxCount = 0 --在最大速度的情况下已经转几圈
	rightIsMax = false --判断当前的速度是否到达了最大的速度
	isRightStop = true --中间图片的转动是否停止
	isMiddleFirstMove = true-- 用来判断是不是左边第一个移动的图片
	middleLayoutCurrent = 0--左边layout的当前坐标
end



-- 水果机停止以后，切换到比倍机界面，对需要清空的资源进行清空
function fruitViewReset()
	for i = 1, 5 do
		initFruitScrewLayout(i, false)
	end
	initFruitMachineData()
end

-- 比倍机停止以后，切换到水果机界面，对需要清空的资源进行清空
function begViewReset()
	doubleArray = {}
	Button_big:stopAllActions()
	--用户赢的次数初始化
	userWinTimes = 0
end

--在金币飞完了以后，重新设置显示金币数量的text
function updataUserInfo()
	Label_fruit_total_coin:setText(tostring(profile.User.getSelfCoin()))
	Label_beg_total_coin:setText(tostring(profile.User.getSelfCoin()))
end

--[[--
--获取小游戏大厅内玩家的发言
--]]
function getMiniGameChatMsg()
	local chatInfoTable = profile.MiniGameChat.getMiniGameChatInfoTable()
	if chatInfoTable.MessageContent ~= nil and chatInfoTable.MessageContent ~= "" then
		--		table.insert(scrollTitleArray, 1, "chat")
		--		scrollTitleArray[1] = {}
		--		scrollTitleArray[1].msg = chatInfoTable.SenderNickname..": "..chatInfoTable.MessageContent
		Label_talk:setText(chatInfoTable.SenderNickname..": "..chatInfoTable.MessageContent)
	elseif chatInfoTable.Result ~= 0 then
		Common.showToast("发言成功", 2)
		--		table.insert(scrollTitleArray, 1, "chat")
		--		scrollTitleArray[1] = {}
		--		scrollTitleArray[1].msg = "我 : "..chatTextFeild:getStringValue()
		Label_talk:setText("我 : "..chatTextFeild:getStringValue())
	else
		Common.showToast("发言失败", 2)
	end
end

--[[--
--破产送金更新金币
--]]--
function updataUserInfoPoChan()
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(2))
	array:addObject(CCCallFuncN:create(
		function()
			Label_fruit_total_coin:setText(tostring(profile.User.getSelfCoin()))
			Label_beg_total_coin:setText(tostring(profile.User.getSelfCoin()))
		end
	))
	local seq = CCSequence:create(array)
	view:runAction(seq)
end

--[[--
--设置小游戏类型
@parm gameType	小游戏类型
@parm currentView	当前view,用于打赏动画
--]]
function setMiniGameType(gameType, currentView)
	miniGameType = gameType
	view = currentView
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(CommonControlGetResource("trumpet.png"), CommonControlGetResource("trumpet.plist"), CommonControlGetResource("trumpet.ExportJson"))
end

--[[--
--移动顶部的奖池信息
--]]
function movePrizeInfo()
	local talkMove = CCMoveBy:create(5, ccp(0, talkRectHeight*2))
	local array = CCArray:create()
	array:addObject(talkMove)
	array:addObject(CCCallFuncN:create(movePrizeLogic))
	Label_talk:runAction(CCSequence:create(array))
end

--[[--
--有调用上面的movePrizeInfo,主要作用是设置Label_takl的text，控制何时向服务器申请获取text
--]]
function movePrizeLogic()
	if (#scrollTitleArray > 1)then
		Label_talk:setText(scrollTitleArray[1].msg)
		Label_talk:setColor(ccc3(212, 99, 33))
		Label_talk:setAnchorPoint(ccp(0, 0.5))
		Label_talk:setPosition(ccp(0, -talkRectHeight/2))
		table.remove(scrollTitleArray, 1)
	end
	if (#scrollTitleArray < 5) and isRequestRollMessage == false then
		local delay = CCDelayTime:create(5)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(CCCallFuncN:create(
			function()
				isRequestRollMessage = false
			end
		))
		local seq = CCSequence:create(array)
		view:runAction(seq)
		--发送申请
		sendSLOT_ROLL_MESSAGE() --获取水果机滚动信息和滚动的条目
	end
	movePrizeInfo()
end

--[[--
--彩池数字控件初始化
--]]
function initRewardPoolBaseInfo()
	isRollRewardEnabled = true
	atlasLabelTable = {}
	local size = ImageView_fruit_pond_light:getSize()
	local pos = ImageView_fruit_caicibg:getPosition()
	tableView = ccTableView.create(CCSize(size.width,size.height*0.8))
	currentScrollTag = 10
	tableView:setDirection(kCCScrollViewDirectionHorizontal)
	tableView:setPosition(ccp(pos.x * 1.22, pos.y))
	tableView.SeparatorWidth = 2
	tableView:setTouchEnabled(false)
	function tableView.numberOfrow()--返回行数
		return 8
	end

	function tableView.HeightOfCellAtNumberOfRow(i)--返回每行的高度
		return 32.5
	end

	function tableView.CellOfAtNumberOfRow(cell,i)--设置cell
		scrollSprites[9-i] = cell
		local num = 90-i*10
		--设置每行的tag,用于动画顺序获取和lable获取
		cell:setTag(num)
		cellSize = cell:getContentSize()
		cell:setColor(ccc3(0,0,0))
		cell:setOpacity(0)
		--当前数，默认为0
		local currentLabel = CCLabelAtlas:create("0",Common.getResourcePath("load_res/FruitMachineRes/num_lhj_caijingundong.png") , 26, 30, 48)
		--根据tag存储每行上的lable
		atlasLabelTable[num] = {}
		atlasLabelTable[num][1] = currentLabel
		currentLabel:setAnchorPoint(ccp(0.5,0.5))
		currentLabel:setPosition(ccp(cellSize.width*0.2,cellSize.height*0.5))
		--下一个数
		local afterLabel = CCLabelAtlas:create("1",Common.getResourcePath("load_res/FruitMachineRes/num_lhj_caijingundong.png") , 26, 30, 48)
		atlasLabelTable[num][2] = afterLabel
		afterLabel:setAnchorPoint(ccp(0.5,0.5))
		afterLabel:setPosition(ccp(cellSize.width*0.2,cellSize.height*1.5))
		--将lable加载tableview的各行上
		cell:addChild(currentLabel)
		cell:addChild(afterLabel)
	end
	--加载tableview
	ccTableView.reloadData(tableView)
	view:addChild(tableView)
end

--[[--
--彩池数字滚动动画
--]]
local function scrollFruitAction(senter,time)
	--滚动距离为一行的高度
	local moveby = CCMoveBy:create(time,ccp(0, -cellSize.height))
	--回调判断是否匹配彩金数的函数
	local callfun = CCCallFuncN:create(changeFruitCallBack)
	local array = CCArray:create()
	array:addObject(moveby)
	array:addObject(callfun)
	local seq = CCSequence:create(array)
	senter:runAction(seq)
end

--[[--
--彩池数字滚动动画回调
--]]
function changeFruitCallBack(senter)
	senter:stopAllActions()
	local senterTag = senter:getTag()
	--当前数
	local currentLabel = atlasLabelTable[senterTag][1]
	--下一个数
	local afterLabel = atlasLabelTable[senterTag][2]
	local currentNum = nil
	currentNum = tonumber(currentLabel:getString())
	--如果是当前行而且匹配彩金数则停止当前行的滚动动画
	if currentScrollTag == senter:getTag() and currentNum  == currentRewardPoolNum[1] then
		--为了能依次获取cell，需要确定一个数字后将tag向下传递
		currentScrollTag = currentScrollTag + 10
		senter:stopAllActions()
		--移除已经匹配彩金数数组中的第一个数字
		table.remove(currentRewardPoolNum, 1)
		--tag为10-80，当达到80需要初始化为10
		if currentScrollTag >= (spriteNum + 1) * 10 then
			currentScrollTag = 10
		end
		currentLabel:setString((currentNum)%10)
		afterLabel:setString((currentNum + 1)%10)
	else
		currentLabel:setString((currentNum + 1)%10)
		afterLabel:setString((currentNum + 2)%10)
		--滚动的动作
		scrollFruitAction(senter,0.05)
	end
	--如果cell滚动到最下面，则将cell重新设置到初始位置
	senter:setPositionY(senter:getPositionY()+cellSize.height)
end

--[[--
--执行彩池数字滚动动画
--]]
function scrollRewardNumber()
	--用于判定外部是否第一次调用本函数
	isRollRewardEnabled = false
	local delay = CCDelayTime:create(15)
	local array = CCArray:create()
	array:addObject(CCCallFuncN:create(
		function()
			local len = string.len(RewardPoolNum)
			currentRewardPoolNum = {}
			--将彩金数分割成数字数组，默认为8位，不足8位用0补位
			spriteNum = 0
			for i = 1, 8 do
				if i <= len then
					currentRewardPoolNum[i] = tonumber(string.sub(RewardPoolNum, -i, -i))
					spriteNum = spriteNum + 1
--				else
--					currentRewardPoolNum[i] = 0
				end
			end
			--依次延时执行tableview每行的滚动动画，最高位为0则不动
			for i = 1, spriteNum do
				local num = spriteNum + 1 - i
				scrollFruitAction(scrollSprites[num],num*0.15+0.1)
			end
		end
	))
	array:addObject(delay)
	local seq = CCSequence:create(array)
	local req = CCRepeatForever:create(seq)
	view:runAction(req)
end

--[[--
--中奖闪烁动画
--]]
function runLightAnimation()
	CommonControl.playEffect("lightshine.mp3",true)
	lightImage:setVisible(true)
	lightIndex = 1
	local delay = CCDelayTime:create(0.15)
	local array = CCArray:create()
	array:addObject(CCCallFuncN:create(
		function()
			if lightIndex > 3 then
				lightIndex = 1
			end
			lightImage:loadTexture(CommonControl.miniGameGetResource(string.format("blink_light_%d.png",lightIndex)))
			lightIndex = lightIndex + 1

		end
	))
	array:addObject(delay)
	local seq = CCSequence:create(array)
	lightImage:runAction(CCRepeatForever:create(seq))
end

--[[--
--中奖闪烁动画
--]]
function stopLightAnimation()
	lightImage:stopAllActions()
	lightImage:setVisible(false)
end

--[[--
--打赏头像
--]]
function getMiniGameRewards()
	Common.log("reqIsExistRewardInfo========2")
	imageRewardType = BegMachineLogic.IMAGEREWARDRECEIVE
	BegMachineLogic.getMiniGameRewards(Image_dashang, Image_Reward, Label_Reward, imageRewardType)
end

--[[--
--进入小游戏领取打赏提示
--]]
function getRewardOnEnterGame()
	local dataTable = profile.IM.getIMID_MINI_GET_REWARDS_V3Table()
	if dataTable ~= nil then
	    --1：成功 2：失败
		if dataTable["result"] == 1 then
			local pictureUrl = dataTable.Pic
			local Description = dataTable.Description

			local Msg = dataTable.Msg
			ImageToast.createView(nil,Common.getResourcePath("ic_recharge_guide_jinbi.png"), "x" .. Description, Msg, 2)
		elseif dataTable["result"] == 2 then
			local Msg = dataTable.Msg
			Common.showToast(Msg, 2)
		end
	end
end

--[[--
--进入小游戏请求打赏
--]]
function reqRewardOnEnterGame()
	--1 ：老虎机 2：金皇冠  checkCode：打赏者ID 0:代表不是通过打赏提示进入的小游戏
	sendIMID_MINI_GET_REWARDS_V3(1, MiniGameGuideConfig.miniGameRewarderId)
	MiniGameGuideConfig.miniGameRewarderId = 0
end


--[[--
--释放界面的私有数据
--]]
function releaseData()
	BegMachineLogic.clearBegUserData()
	CommonControl.clearCommonData()
	DropCoinLogic.clearDropCoinData()
end

function addSlot()
	framework.addSlot2Signal(DBID_USER_INFO, updataUserInfo)
	framework.addSlot2Signal(BASEID_GET_BASEINFO, setUserInfo)
	framework.addSlot2Signal(SLOT_READY_INFO, updataReadyInfo)
	framework.addSlot2Signal(SLOT_ROLL_MESSAGE, getTableOfMessage)
	framework.addSlot2Signal(SLOT_ACCEPT_THE_PRIZE, getTableOfwin)
	framework.addSlot2Signal(SLOT_RICK_COLLECT_MONEY, getTableOfCOLLECT_MONEY)
	framework.addSlot2Signal(SLOT_RICK_WINNING_RECORD, getTableOfSLOT_RICK_WINNING_RECORD)
	framework.addSlot2Signal(IMID_MINI_SEND_MESSAGE, getMiniGameChatMsg)
	framework.addSlot2Signal(IMID_MINI_REWARDS_JUDGE, BegMachineLogic.reqIsExistRewardInfo)
	framework.addSlot2Signal(IMID_MINI_REWARDS_BASEINFO,getMiniGameRewardInfoJudge)
	framework.addSlot2Signal(IMID_MINI_REWARDS_COLLECT, getMiniGameRewards)
	framework.addSlot2Signal(MANAGERID_GIVE_AWAY_GOLD, updataUserInfoPoChan)
	framework.addSlot2Signal(IMID_MINI_GET_REWARDS_V3, getRewardOnEnterGame)
end

function removeSlot()
	framework.removeSlotFromSignal(DBID_USER_INFO, updataUserInfo)
	framework.removeSlotFromSignal(BASEID_GET_BASEINFO, setUserInfo)
	framework.removeSlotFromSignal(SLOT_READY_INFO, updataReadyInfo)
	framework.removeSlotFromSignal(SLOT_ROLL_MESSAGE, getTableOfMessage)
	framework.removeSlotFromSignal(SLOT_ACCEPT_THE_PRIZE, getTableOfwin)
	framework.removeSlotFromSignal(SLOT_RICK_COLLECT_MONEY, getTableOfCOLLECT_MONEY)
	framework.removeSlotFromSignal(SLOT_RICK_WINNING_RECORD, getTableOfSLOT_RICK_WINNING_RECORD)
	framework.removeSlotFromSignal(IMID_MINI_SEND_MESSAGE, getMiniGameChatMsg)
	framework.removeSlotFromSignal(IMID_MINI_REWARDS_JUDGE, BegMachineLogic.reqIsExistRewardInfo)
	framework.removeSlotFromSignal(IMID_MINI_REWARDS_BASEINFO, getMiniGameRewardInfoJudge)
	framework.removeSlotFromSignal(IMID_MINI_REWARDS_COLLECT, getMiniGameRewards)
	AudioManager.stopBgMusic(true)
	AudioManager.stopAllSound()
	AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.HALL_BACKGROUND)
	framework.removeSlotFromSignal(MANAGERID_GIVE_AWAY_GOLD, updataUserInfoPoChan)
	framework.removeSlotFromSignal(IMID_MINI_GET_REWARDS_V3, getRewardOnEnterGame)
end

