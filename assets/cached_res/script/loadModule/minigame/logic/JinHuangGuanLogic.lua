module("JinHuangGuanLogic",package.seeall)

view = nil;

--自定义变量
local hisBackPath = "ui_lhj_bbjl02.png"--历史记录背景图片的路径
local gameType = 2 --游戏类型
local miniGameState = 0
local KAISHI = 1 --开始按钮状态
local HUANPAI = 2 --换牌按钮状态
local JHGSTAKEKEY = "JHGSTAKEKEY" --存储本地赌注基本信息

--常量
local SHOW_JIN_HUANG_GUAN = 0;--发牌页
local SHOW_BI_BEI_JI = 1;--比倍机页
local photoViwWidth = 98--牌宽
local photoViwHeight = 144--牌高
local talkRectWidth = 0 --聊天框宽度
local talkRectHeight = 0--聊天框高度
local scrollShowCount = 5 --滚动条目显示的个数


--比倍的时候猜大小：1代表大，2代表小.
local BIG = 1--大
local SMALL = 2--小
local DIR_UP = 0--向上
local DIR_DOWN = 1--向下

isExistRewardBaseInfo = false --是否有打赏基本信息
isStart = false --是否开始
isAllStop = true --是否停止
isWin = false --是否得奖
isInitUpAwards = false --判断是不是第一次执行
doubleArray = {} --存储加注变化的数组
stakeIndex = nil --加注列表索引
isAllowEnterBeg = false --是否能够进入比倍
prepareRaiseArray = nil --准备信息的数组(可以下的赌注的金币数量)
WinPoolInfo = {} --金皇冠领奖奖池信息
isFirstGetMsg = true --是否是第一次获取上方的滚动信息
handselInfo = nil --记录彩金数（一个为8的数组，当连对5次或者8次获得的金币数量）
isSuccess = false --是否获胜
isJoinRisk = false --是否能够进入比倍机
moneyOfWin = 0 --赢得的金币数量
RewardLevel = 200 --打赏底数
nowCoinNumLabelAtlas = nil--本次金币数量
local allowWinTimes = 0 --允许获胜的次数
userWinTimes = 0 --玩家比倍已经赢的次数
isDouble = 0 --玩家在比倍的时候是否选择了加倍，用来向数组添加，0为没有加倍，1为加倍
currentStake = 200 --当前的赌注
begHeight = 0 --发牌区的高
Panel_20 = nil;--金皇冠panel
local isChange = true --判断扑克牌是否改变
intoBegCoin = 0 --进入比倍机的时候用户所剩的金币
coinBatchNode = nil --承载金币的BatchNode
pukeBatchNode = nil --承载扑克的BatchNode
coinMoveToPosit = {} --金币飞向终点位置的坐标
windowSize = {} --窗口的大小
JHGMessageOfLastID = 0 --金皇冠滚动信息的最后一条的ID
awardsLayoutTable = {}--记录得奖记录中的label元素（目前是想做5个）
layoutTable = {} --滚动条layout的table
awardsCount = 0 --当前取到中奖纪录的哪一条
Label_talk = nil;--滚动信息
ScrollView_recordList = nil;--得奖记录
scrollTitleArray = {} --上方滚动文字的table
Panel_scroll_title = nil;--最上面的滚动框的panel
timestamp = 0 --请求金皇冠中奖纪录所需要的参数（最后时间)
winRecordArray = {}--金皇冠获奖信息table
userCurrentCoin = nil --用户的真实金币数
rollPuke_bibeiji_x = 0 --滚动扑克牌所在的父控件的锚点x坐标
rollPuke_bibeiji_y = 0 --滚动扑克牌所在的父控件的锚点y坐标
Panel_rollPuke_x = 0 --rollPuke_bibeiji_x所在的父控件的锚点坐标
Panel_rollPuke_y = 0 --rollPuke_bibeiji_y所在的父控件的锚点坐标
remainArray = {}--保留的扑克
remainList = {}--保留图标
delaytime = 0--换牌延时时间;
lastOfchange = 0 --最后一张被换的牌的tag值
changeInfoArray = nil --接收换牌信息
readyMessageTable = {} --准备信息
panel_jiqiPos = {}--发牌区坐标
pukeList = {} --发牌区扑克牌
pukeIndex = nil --发牌计数
winTypeImage = nil --中奖类型图片
touchRect = nil --发牌触摸区范围
touchLayerTest = nil --触摸层控制发牌
rightVipRateLable = {} --右侧vip加奖比例说明lable的table
local notSendText = nil -- 玩家编辑未发送的文字

--UI参数
Panel_JinHuangGuan = nil
Button_back = nil;--返回按钮
Button_talk = nil;--聊天按钮
Button_gift = nil;--礼包按钮
ImageView_fruit_caicibg = nil;--当前彩池
ImageView_fruit_caici_title = nil;--当前彩池的title
LabelAtlas_fruit_current_jackpot = nil;--彩池中彩金数
ImageView_fruit_pond_light = nil;--彩池闪烁灯
Panel_money = nil;--当前金币
Button_fruit_recharge = nil;--充值金币按钮
Label_fruit_total_coin = nil;--当前用户金币数
Panel_jiqi = nil;--发牌区panel
Button_raise = nil;--加注按钮
LabelAtlas_raise_coin = nil;--加注金币数
Button_stop = nil;--换牌
Button_fruit_rechargebibei = nil;--比倍区充值金币
Panel_BiBeiJi = nil;--比倍机
Button_big = nil;--赌大
Button_small = nil;--赌小
Button_double = nil;--加倍
Button_collect = nil;--收钱
ImageView_paidaxiao = nil;--比倍机转动牌
ImageView_poker_kind = nil;--转动牌花形
ImageView_poker = nil;--转动牌牌值
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
chatTextFeild = nil;--聊天输入文字(用于输入)
Label_caichi_rate_bibei = nil;
Label_caichi_rate_main = nil;
Explain_Lable1 = nil;--
Explain_Lable2 = nil;--
Explain_Lable3 = nil;--
Explain_Lable4 = nil;--
Explain_Lable5 = nil;--
Explain_Lable6 = nil;--
Explain_Lable7 = nil;--
Image_Flag = nil;--


--[[--
--手机按键
--]]
function onKeypad(event)
	if event == "backClicked" then
		--返回键
		if (miniGameState == SHOW_JIN_HUANG_GUAN)then
			mvcEngine.createModule(GameConfig.getTheLastBaseLayer())
		else
			BegMachineLogic.collectMoney()
		end
	elseif event == "menuClicked" then
	--菜单键
	end
end

local touchLocationPoint = {} --触摸开始的点
--[[--
--触摸开始
--需要返回true
--]]
local function onTouchBegan(x, y)
	touchLocationPoint["x"] = x	--触摸开始点X坐标
	touchLocationPoint["y"] = y	--触摸开始点Y坐标
	return true
end

local subDistanceX = nil --触摸滑动的X坐标轴的相对距离
--[[--
--触摸移动
--]]
local function onTouchMoved(x, y)
	subDistanceX = math.abs(touchLocationPoint.x - x)
	if subDistanceX > 100 then --滑动距离大于100触发翻牌
		startCallBack()
	end
end

--[[--
--触摸结束
--]]
local function onTouchEnded(x, y)

end

--[[--
--触摸监听
--]]
local function onTouch(eventType, x, y)
	if touchRect:containsPoint(ccp(x, y)) then
		if eventType == "began" then
			return onTouchBegan(x, y)
		elseif eventType == "moved" then
			return onTouchMoved(x, y)
		else
			return onTouchEnded(x, y)
		end
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_JinHuangGuan = cocostudio.getUIPanel(view, "Panel_78");
	Panel_BiBeiJi = cocostudio.getUIPanel(view, "Panel_79");
	Button_back = cocostudio.getUIButton(view, "Button_back");
	Button_talk = cocostudio.getUIButton(view, "Button_talk");
	Button_gift = cocostudio.getUIButton(view, "Button_gift");
	chatTextFeild = cocostudio.getUITextField(view, "chatTextFeild");
	ImageView_fruit_caicibg = cocostudio.getUIImageView(view, "ImageView_fruit_caicibg");
	ImageView_fruit_caici_title = cocostudio.getUIImageView(view, "ImageView_fruit_caici_title");
	LabelAtlas_fruit_current_jackpot = cocostudio.getUILabelAtlas(view, "LabelAtlas_fruit_current_jackpot");
	LabelAtlas_fruit_current_jackpot_2 = cocostudio.getUILabelAtlas(view, "LabelAtlas_fruit_current_jackpot2");
	ImageView_fruit_pond_light = cocostudio.getUIImageView(view, "ImageView_fruit_pond_light");
	Panel_money = cocostudio.getUIPanel(view, "Panel_money");
	Button_fruit_recharge = cocostudio.getUIButton(view, "Button_fruit_recharge");
	Label_fruit_total_coin = cocostudio.getUILabel(view, "Label_fruit_total_coin");
	Label_beg_total_coin = cocostudio.getUILabel(view, "Label_fruit_total_coin_0");
	Panel_jiqi = cocostudio.getUIPanel(view, "Panel_jiqi");
	Button_raise = cocostudio.getUIButton(view, "Button_raise");
	LabelAtlas_raise_coin = cocostudio.getUILabelAtlas(view, "LabelAtlas_raise_coin");
	nowCoinNumLabelAtlas = cocostudio.getUILabelAtlas(view, "LabelAtlas_fruit_current_jackpot_0");
	Button_stop = cocostudio.getUIButton(view, "Button_stop");
	ImageView_addshuoming = cocostudio.getUIImageView(view, "ImageView_addshuoming");
	ImageView_beg_describe = cocostudio.getUIImageView(view, "ImageView_beg_describe");
	Panel_money_0 = cocostudio.getUIPanel(view, "Panel_money_0");
	Button_fruit_rechargebibei = cocostudio.getUIButton(view, "Button_fruit_rechargebibei");
	Panel_bibeijiPanel = cocostudio.getUIPanel(view, "Panel_bibeiji");
	Button_big = cocostudio.getUIButton(view, "Button_big");
	Button_small = cocostudio.getUIButton(view, "Button_small");
	Button_double = cocostudio.getUIButton(view, "Button_double");
	Button_collect = cocostudio.getUIButton(view, "Button_collect");
	ImageView_paidaxiao = cocostudio.getUIImageView(view, "ImageView_paidaxiao");
	ImageView_poker_kind = cocostudio.getUIImageView(view, "ImageView_poker_kind");
	ImageView_poker = cocostudio.getUIImageView(view, "ImageView_poker");
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
	ImageView_dangqian = cocostudio.getUIImageView(view, "ImageView_dangqian");
	LabelAtlas_win_coin = cocostudio.getUILabelAtlas(view, "LabelAtlas_win_coin");
	Label_talk = cocostudio.getUILabel(view, "Label_talk");
	Panel_scroll_title = cocostudio.getUIPanel(view, "Panel_834");
	ScrollView_recordList = cocostudio.getUIScrollView(view, "ScrollView_recordList");
	Label_caichi_rate_bibei = cocostudio.getUILabel(view, "Label_caichi_rate_bibei");
	Label_caichi_rate_main = cocostudio.getUILabel(view, "Label_caichi_rate_main");
	Explain_Lable1 = cocostudio.getUILabel(view, "Explain_Lable1");
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


	Button_talk:setTouchEnabled(false)
	chatTextFeild:setVisible(false)
	ButtonSetState(false, KAISHI)
	ButtonSetState(false)
end

function initData()
	isStart = false
	miniGameState = SHOW_JIN_HUANG_GUAN
	CommonControl.setMiniGameType(gameType, view) --设置游戏类型和当前view
	CommonControl.trumpetAnimation(Button_talk) --播放小喇叭动画
	LabelAtlas_fruit_current_jackpot:setStringValue("")
	--充值礼包的图片用的是公共礼包图片
	if GameConfig.GAME_ID ~= 1 then
		--如果不是斗地主隐藏小游戏的礼包
		Button_gift:setVisible(false)
		Button_gift:setTouchEnabled(false)
	end
	if profile.Gift.isShowFirstGiftIcon() then
		--可以购买礼包
		Button_gift:loadTextures(CommonControl.CommonControlGetResource("ic_hall_shouchong.png"),CommonControl.CommonControlGetResource("ic_hall_shouchong.png"),"")
	else
		--Common.setButtonVisible(Button_gift, false)
		--可以进行充值
		Button_gift:loadTextures(CommonControl.CommonControlGetResource("ic_hall_recharge.png"),CommonControl.CommonControlGetResource("ic_hall_recharge.png"),"")
	end

	if (not isStart) then
		Button_stop:loadTextures(CommonControl.miniGameGetResource("btn_jhg_kaishi.png"),CommonControl.miniGameGetResource("btn_jhg_kaishi.png"),"")
		Button_collect:loadTextures(CommonControl.miniGameGetResource("btn_jhg_shouqian01.png"),CommonControl.miniGameGetResource("btn_jhg_shouqian01.png"),"")
	end

	--发牌区坐标信息
	panel_jiqiPos["x"] = Panel_jiqi:getPosition().x
	panel_jiqiPos["y"] = Panel_jiqi:getPosition().y
	panel_jiqiPos["height"] = Panel_jiqi:getContentSize().height
	panel_jiqiPos["width"] = Panel_jiqi:getContentSize().width
	--发牌触摸区范围
	touchRect = CCRect(panel_jiqiPos.width*0.4,  panel_jiqiPos.y + panel_jiqiPos.height*0.255, panel_jiqiPos.width, panel_jiqiPos.height)
	--顶部滚动框坐标信息
	talkRectWidth = Panel_scroll_title:getSize().width
	talkRectHeight = Panel_scroll_title:getSize().height
	nowCoinNumLabelAtlas:setStringValue("0")
	LabelAtlas_win_coin:setStringValue("0")

	AudioManager.stopBgMusic(true)
	AudioManager.stopAllSound()
	CommonControl.preloadSound()
	CommonControl.playBackMusic("fanpaiBackGroundSound.mp3", true)--播放背景音乐

	sendDBID_USER_INFO(profile.User.getSelfUserID())
	sendJHG_WINNING_RECORD(0)
	sendIMID_MINI_ENTER_CHAT_ROOM(gameType)
	sendIMID_MINI_REWARDS_BASEINFO(gameType)
	coinBatchNode = CCLayer:create()
	touchLayerTest = CCLayer:create()
	--注册触摸函数
	touchLayerTest:registerScriptTouchHandler(onTouch)
	--点击屏幕加速金币掉落
	coinBatchNode:registerScriptTouchHandler(DropCoinLogic.onTouch)
	touchLayerTest:setTouchEnabled(false)
	view:addChild(touchLayerTest)

	view:addChild(coinBatchNode)
	pukeBatchNode = ccs.panel({
		scale9 = false,
		image = "",
		size = CCSizeMake(panel_jiqiPos.width, panel_jiqiPos.height),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	Panel_jiqi:addChild(pukeBatchNode)

	isAllStop = true
	isFirstGetMsg = true

	winTypeImage = ccs.image({
		scale9 = false,
		size = CCSizeMake(194, 102),
		image = "",
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	winTypeImage:setTouchEnabled(false)
	winTypeImage:setVisible(false)
	winTypeImage:loadTexture(CommonControl.miniGameGetResource("wintype_9.png"))
	SET_POS(winTypeImage, panel_jiqiPos.width/2, panel_jiqiPos.height*0.7)
	Panel_jiqi:addChild(winTypeImage)

	local btnTalkPos = Button_talk:getPosition()


	--设置金币飞向位置的坐标
	coinMoveToPosit["x"] = Panel_JinHuangGuan:getPosition().x + Panel_money:getPosition().x
	coinMoveToPosit["y"] = Panel_JinHuangGuan:getPosition().y + Panel_money:getPosition().y
	--获得当前屏幕的大小
	windowSize["width"] = CCDirector:sharedDirector():getWinSize().width
	windowSize["height"] = CCDirector:sharedDirector():getWinSize().height

	begHeight = Panel_BiBeiJi:getSize().height;
	rollPuke_bibeiji_x = Panel_bibeijiPanel:getPosition().x;
	rollPuke_bibeiji_y = Panel_bibeijiPanel:getPosition().y;
	--比倍机锚点坐标
	Panel_rollPuke_x = Panel_BiBeiJi:getPosition().x;
	Panel_rollPuke_y = Panel_BiBeiJi:getPosition().y;

	doubleArray = {}
	initBeg()
	BegMachineLogic.initBegData(gameType, ImageView_paidaxiao, LabelAtlas_win_coin, Label_beg_total_coin, Label_fruit_total_coin, ImageView_poker, ImageView_poker_kind, historyUserData, buttonTable, resultAnimaPoint, view, coinMoveToPosit, coinBatchNode)
	--检测是否有历史比倍记录，如果有则执行收钱操作
	loadHistory()
	initStreak()
end

--[[--
--初始化加注基本信息
--]]
function initStreak()
	local coin = profile.User.getSelfCoin()
	local num = 1
	local itemTable = Common.LoadTable(JHGSTAKEKEY)
	if itemTable ~= nil and itemTable[1].rate ~= nil then
		for i = 1, #itemTable do
			if (tonumber(coin) / 20) >= tonumber(itemTable[i].coin) and tonumber(itemTable[i].coin) <= 10000 then
				setRaiseLabel(itemTable[i].coin)
				updateRaiseRate(itemTable[i].rate)
				num = i
			elseif (tonumber(coin) / 20) > 0 and (tonumber(coin) / 20) < tonumber(itemTable[1].coin) then
				setRaiseLabel(itemTable[1].coin)
				updateRaiseRate(itemTable[1].rate)
				num = 1
			end
		end
		stakeIndex = num
	end
end

--[[--
--初始化比倍机的相关数据
--]]
function initBeg()
	initHistoryData() --将比倍历史控件放入到数组中
	initButton() --将大小加倍3个按钮放入到table中
	initAnimaPoint()--初始化动画的坐标点
	BegMachineLogic.setHistoryBackPath(hisBackPath) --设置历史记录背景图片的路径
end

--[[--
--将比倍历史的空间放入到一个table中
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
--将大，小，加倍全部放入到一个table中，以便传给begMachineLogic
--]]
function initButton()
	buttonTable = {}
	buttonTable.big = Button_big
	buttonTable.small = Button_small
	buttonTable.double = Button_double
end

--[[--
--初始化点击大小以后，盖章动画的坐标（输赢平）
--]]
function initAnimaPoint()
	resultAnimaPoint = {}
	resultAnimaPoint["x"] = Panel_rollPuke_x + ImageView_paidaxiao:getPosition().x + rollPuke_bibeiji_x
	resultAnimaPoint.y = begHeight + Panel_rollPuke_y + rollPuke_bibeiji_y + ImageView_paidaxiao:getPosition().y
end

isStartFruitCall = false --布尔值，用来判断此处的更新总金币数量是不是因为翻牌时候来造成的
--[[--
--用户当前金币
--]]
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
	view = cocostudio.createView("load_res/JinHuangGuan/JinHuangGuan.json")
	local gui = GUI_JINHUANGUAN
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
	GameConfig.setTheCurrentBaseLayer(GUI_JINHUANGUAN)
	GameStartConfig.addChildForScene(view)

	initView()
	initData()

	local function delaySentMessage()
		sendJHG_READY_INFO() --获取准备信息
		sendJHG_ROLL_MESSAGE() --获取滚动信息和滚动的条目
	end
	--这个函数不知道是干什么用的，个人认为是展示图片或者loding之类的
	LordGamePub.runSenceAction(Panel_20, delaySentMessage, false)
	setUserInfo()
	Label_fruit_total_coin:setText(tostring(profile.User.getSelfCoin()))
	setJiQiButton()
end

function requestMsg()

end

--[[--
--本地存储比倍记录
--]]
function storeHistory()
	local itemTable = {}
	itemTable.addHistory = doubleArray
	Common.SaveTable(profile.User.getSelfUserID().."JINHUANGGUAN",itemTable)
end

--[[--
--检测是否有未上传的本地比倍记录，如果有则进行处理
--]]
function loadHistory()
	local itemTable = Common.LoadTable(profile.User.getSelfUserID().."JINHUANGGUAN")
	if(itemTable and itemTable.addHistory) then
		isCollectLast = true
		doubleArray = itemTable.addHistory
		Common.showProgressDialog("正在上传上次结果...")
		-------*******收钱操作及动画*******-------
		sendJHG_RICK_COLLECT_MONEY(itemTable.addHistory)
	end
end

--[[--
--卡牌创建
--]]
local function cardInit()
	for i=1,5 do
		if (pukeList[i] == nil) then
			pukeList[i] = ccs.button({
				scale9 = false,
				size = CCSizeMake(photoViwWidth, photoViwHeight),
				pressed = CommonControl.miniGameGetResource("ui_jhg_paibeimian.png"),
				normal = CommonControl.miniGameGetResource("ui_jhg_paibeimian.png"),
				text = "",
				capInsets = CCRectMake(0, 0, 0, 0),
				listener = {
					[ccs.TouchEventType.began] = function(uiwidget)
						--贴上选中标签
						if (not (pukeList[i]:getChildByTag(6):isVisible())) then
							CommonControl.playEffect("remainButton.mp3",false) --播放音效
							pukeList[i]:getChildByTag(6):setVisible(true)
							remainArray[i] = pukeList[i]:getTag()
						else
							pukeList[i]:getChildByTag(6):setVisible(false)
							remainArray[i] = nil
						end
					end,
				}
			})

			local remain = ccs.image({
				scale9 = false,
				size = CCSizeMake(78, 68),
				image = "",
				capInsets = CCRectMake(0, 0, 0, 0),
			})
			SET_POS(remain, 0, 0)
			remain:loadTexture(CommonControl.miniGameGetResource("ui_jhg_baoliu.png"))
			remain:setTag(6)
			pukeList[i]:addChild(remain)
			remain:setTouchEnabled(false)
			remain:setVisible(false)
			remain:setZOrder(10)
		end
		pukeList[i]:setScale(1.08)
		pukeList[i]:loadTextures(CommonControl.miniGameGetResource("ui_jhg_paibeimian.png"), CommonControl.miniGameGetResource("ui_jhg_paibeimian.png"),"")
		pukeList[i]:setTouchEnabled(false)
		pukeList[i]:setTag(i)
		SET_POS(pukeList[i], -winSize.width*0.5, winSize.height/2)
		pukeBatchNode:addChild(pukeList[i])
		pukeList[i]:getChildByTag(6):setVisible(false)

	end
	isStart = false
	Button_stop:loadTextures(CommonControl.miniGameGetResource("btn_jhg_kaishi.png"),CommonControl.miniGameGetResource("btn_jhg_kaishi.png"),"")
	ButtonSetState(false, KAISHI)
end

--[[--
--根据参数生成不同的牌
--]]
function createpuke(puke,pukeNum,pukeColor)
	--pukeNum:1-13:A-K,pukeColor:0-3:方块，梅花，红桃，黑桃
	puke:setScale(1.08)
	puke:loadTextures(CommonControl.miniGameGetResource("ui_jhg_paizhengmian.png"),CommonControl.miniGameGetResource("ui_jhg_paizhengmian.png"),"")
	local colorNum = 0;
	if(pukeColor%2 == 0) then
		colorNum = 2
	end
	pukeSize = puke:getContentSize()
	if pukeNum > 13 then
		--大王
		puke.topValue = ccs.image({
			scale9 = false,
			size = CCSizeMake(40, 40),
			image = CommonControl.miniGameGetResource("ui_jhg_joker.png"),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		puke.topValue:setTouchEnabled(false)
		SET_POS(puke.topValue, -pukeSize.width*0.33, pukeSize.height*0.25)
		puke:addChild(puke.topValue)
		puke.topValue:setScaleY(0.6)

		puke.color = ccs.image({
			scale9 = false,
			size = CCSizeMake(40, 40),
			image = CommonControl.miniGameGetResource("ui_jhg_gongsitubiao.png"),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		puke.color:setScale(0.7)
		puke.color:setTouchEnabled(false)
		SET_POS(puke.color, 0, 0)
		puke:addChild(puke.color)
	else
		puke.topValue = ccs.image({
			scale9 = false,
			size = CCSizeMake(photoViwWidth, photoViwHeight),
			image = "",
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		puke.topValue:setScale(0.9)
		puke.topValue:setTouchEnabled(false)
		SET_POS(puke.topValue, -pukeSize.width*0.23, pukeSize.height*0.3)
		puke:addChild(puke.topValue)
		puke.topValue:loadTexture(CommonControl.miniGameGetResource(string.format("card_num_%d_%d.png",pukeNum,colorNum)))

		puke.color = ccs.image({
			scale9 = false,
			size = CCSizeMake(photoViwWidth, photoViwHeight),
			image = "",
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		puke.color:setScale(1.4)
		puke.color:setTouchEnabled(false)
		SET_POS(puke.color, 0, -pukeSize.height*0.1)
		puke:addChild(puke.color)
		puke.color:loadTexture(CommonControl.miniGameGetResource(string.format("Pai_coler_%d.png",pukeColor)))

	end
end

--[[--
--更新卡牌
--]]
function updatePuke( puke,pukeNum,pukeColor )
	puke.topValue:setVisible(true)
	puke.color:setVisible(true)
	puke:loadTextures(CommonControl.miniGameGetResource("ui_jhg_paizhengmian.png"),CommonControl.miniGameGetResource("ui_jhg_paizhengmian.png"),"")
	local colorNum = 0;
	if(pukeColor%2 == 0) then
		colorNum = 2
	end
	if pukeNum > 13 then
		--大王
		puke.topValue:loadTexture(CommonControl.miniGameGetResource("ui_jhg_joker.png"))
		SET_POS(puke.topValue, -pukeSize.width*0.33, pukeSize.height*0.25)
		puke.topValue:setScaleY(0.6)
		puke.color:loadTexture(CommonControl.miniGameGetResource("ui_jhg_gongsitubiao.png"))
		SET_POS(puke.color, 0, 0)
		puke.color:setScale(0.7)
	else
		puke.topValue:loadTexture(CommonControl.miniGameGetResource(string.format("card_num_%d_%d.png",pukeNum,colorNum)))
		SET_POS(puke.topValue, -pukeSize.width*0.23, pukeSize.height*0.3)
		puke.topValue:setScaleY(0.9)
		puke.color:loadTexture(CommonControl.miniGameGetResource(string.format("Pai_coler_%d.png",pukeColor)))
		SET_POS(puke.color, 0, -pukeSize.height*0.1)
		puke.color:setScale(1.4)
	end
end

--[[--
--发牌动画
--]]
local function dispenseCardAction()
	for i = 1,5 do
		local delay = CCDelayTime:create((i-1)*0.07)
		local distanceX = pukeList[i]:getContentSize().width*0.79 + panel_jiqiPos.width/6*1.14*(i-1)
		local distanceY = panel_jiqiPos.y + panel_jiqiPos.height*0.255
		local moveto = CCMoveTo:create(0.8, ccp(distanceX,distanceY))
		local ease = CCEaseOut:create(moveto,0.1)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(ease)
		local callFun = CCCallFuncN:create(JinHuangGuanfapaiCallback)
		array:addObject(callFun)
		if (i == 5) then
			local callFun = CCCallFuncN:create(JinHuangGuanfapaiOverCallback)
			array:addObject(callFun)
		end
		local seq = CCSequence:create(array)
		pukeList[i]:runAction(seq)
	end
end

--[[--
--发牌
--]]
function fapaiInit()
	--初始化发牌动画
	cardInit()
	setVisibleForCardValue()
	pukeBatchNode:setTouchEnabled(false)
	winTypeImage:setVisible(false)
	--清空前一次的保留记录
	remainArray = {}
	dispenseCardAction()
end

--[[--
--获取滚动信息和奖池奖金
--]]
function getscrollMassageInfo()
	--已经获取了滚动信息
	CommonControl.isRequestRollMessage = true
	local itemTable = profile.JinHuangGuan.getTableOfMESSAGEInfo()
	--修改奖池中的奖金
	local pool = string.match(itemTable.HandselMsg, "%d+")
	LabelAtlas_fruit_current_jackpot:setStringValue(pool)
	--存储滚动信息
	scrollTitleArray = Common.copyTab(itemTable.WinMsgNum)
	LabelAtlas_fruit_current_jackpot_2:setStringValue(pool)
	if itemTable ~= nil and itemTable.WinMsgNum[1] ~= nil then
		JHGMessageOfLastID = itemTable.WinMsgNum[#itemTable.WinMsgNum].ItemID
		if (isFirstGetMsg)then
			CommonControl.movePrizeInfo(Label_talk, talkRectWidth, talkRectHeight, scrollTitleArray)
			isFirstGetMsg = false
		else
			CommonControl.setPrizeInfo(scrollTitleArray)
		end
	end
end

--[[--
--设置注数
--]]
function setRaiseLabel(string)
	string = string or "0"
	LabelAtlas_raise_coin:setStringValue(tostring(string))
end

--[[--
--发牌中回调函数
--]]
function JinHuangGuanfapaiCallback(senter,index)
	CommonControl.playEffect("fapai.mp3",false) --播放音效
end

--[[--
--发牌结束后回调函数
--]]
function JinHuangGuanfapaiOverCallback(senter,index)
	ButtonSetState(true, KAISHI)
	touchLayerTest:setTouchEnabled(true)
	ButtonSetState(true)
end

--[[--
--获取准备信息
--]]
function updataReadyInfo()
	Common.closeProgressDialog()
	local coin = profile.User.getSelfCoin()
	Common.closeProgressDialog()
	readyMessageTable = profile.JinHuangGuan.getReadyInfo()
	Common.log("第一次玩",readyMessageTable.IsFirstPlay)
	local itemTable = Common.LoadTable(JHGSTAKEKEY)
	if itemTable == nil then
		local num = 1
		for i = 1, #readyMessageTable["Raise"] do
			if (tonumber(coin) / 20) >= tonumber(readyMessageTable["Raise"][i].coin) and tonumber(readyMessageTable["Raise"][i].coin) <= 10000 then
				setRaiseLabel(readyMessageTable["Raise"][i].coin)
				updateRaiseRate(readyMessageTable["Raise"][i].rate)
				num = i
			elseif (tonumber(coin) / 20) > 0 and (tonumber(coin) / 20) < tonumber(readyMessageTable["Raise"][1].coin) then
				setRaiseLabel(readyMessageTable["Raise"][1].coin)
				updateRaiseRate(readyMessageTable["Raise"][1].rate)
				num = 1
			end
		end
		stakeIndex = num
	end
	Common.SaveTable(JHGSTAKEKEY, readyMessageTable["Raise"])
	readyMessageTable["Raise"].currentLevel = stakeIndex
	CommonControl.bonusExplain(4, rightVipRateLable, readyMessageTable["VipRaise"])
	--是否第一次玩
	isFirstPlay = readyMessageTable.IsFirstPlay == 1 and  true or false
	--发牌
	fapaiInit()
end

--[[--
--根据加注设置彩金加奖比例
--]]
function updateRaiseRate(num)
	Label_caichi_rate_bibei:setText("[彩金加奖"..num.."%]");
	local scaleBig = CCScaleTo:create(0.1, 1.2)
	local scaleSmall = CCScaleTo:create(0.1, 1)
	local array = CCArray:create()
	array:addObject(scaleBig)
	array:addObject(scaleSmall)
	local seq = CCSequence:create(array)
	Label_caichi_rate_main:setText("[彩金加奖"..num.."%]");
	Label_caichi_rate_main:runAction(seq)
end

--[[--
--获取开始信息
--]]
function getStartGameInfo()
	isStart = true
	ButtonSetState(false, KAISHI)
	local itemTable = profile.JinHuangGuan.getTableOfStartInfo()
	-- Common.log("-------------收到金皇冠开始信息--------------")
	remainArray.PaiArray = itemTable.PukeArray
	-- for i = 1,#itemTable.PukeArray do
	-- Common.log("--------------------牌-----------------",itemTable.PukeArray[i].puke)
	-- Common.log("-------------------是否保留-----------------",itemTable.PukeArray[i].isRemain)
	-- end
	--翻牌
	fanpai()
end

--[[--
--获取换牌信息
--]]
function getChangePaiInfo()
	local itemTable = profile.JinHuangGuan.getTableOfJHG_CHANGE_PAIInfo()
	changeInfoArray = itemTable
	local AfterChangeOfPai = {}
	local changepai = 1;
	for i = 1,5 do
		if(remainArray[i] == nil and #itemTable.AfterChangeOfPai > 0)then
			AfterChangeOfPai[i] = itemTable.AfterChangeOfPai[changepai].pai
			remainArray.PaiArray[i].puke = AfterChangeOfPai[i]
			changepai = changepai + 1
		else
			AfterChangeOfPai[i] = nil
		end
	end

	changeInfoArray.AfterChangeOfPai = AfterChangeOfPai

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

	--需要设置准许赢几次
	local num = itemTable["WinTime"][1] + itemTable["WinTime"][2]
	--Common.showToast(string.format("可以赢 %d 次", num), 2)
	BegMachineLogic.setWinTimes(num)  --(itemTable.WinTime)
	JinHuangGuanchagePukeCallback()
end

--[[--
--保留回调函数
--]]
local function remainCallback(senter)
	CommonControl.playEffect("remainButton.mp3",false) --播放音效
	pukeList[pukeIndex]:getChildByTag(6):setVisible(true)
end

--[[--
--翻拍结束执行的系统建议保留函数
--]]
function JinHuangGuanrecommendRemain()
	Common.log("--翻拍结束执行的系统建议保留函数--")
	local pukeArray = pukeBatchNode:getChildren()
	local remainNumber = 0

	for i = 1,5 do
		if(remainArray.PaiArray[i].isRemain == 1) then---如果是服务器所给的建议牌则保留(根据tag值进行判断)----
			pukeList[i]:getChildByTag(6):setVisible(true)
			remainArray[i] = pukeList[i]:getTag()
		else
			remainArray[i] = nil
		end
	end
end

--[[--
--换牌后调用的函数
--]]
function JinHuangGuanchagePukeCallback()
	delaytime = 0;
	--如果有需要换的牌则进行换牌处理，如果没有换牌则直接调用换牌结束的函数
	local selectNumber = 0
	for i = 1,5 do
		if(remainArray[i] ~= nil)then
			selectNumber = selectNumber + 1
		end
	end

	if(selectNumber ~= 5) then
		for i = 1,5 do
			if (not remainArray[i]) then --如果是更换的牌
				pukeIndex = i
				doChagePukeCallback(pukeBatchNode:getChildByTag(i))--对要换的牌执行操作
				delaytime = delaytime + 0.2;
				lastOfchange = i
			end
		end
	else
		changeOVerCallback(0)
	end
end

--[[--
--进行换牌的操作
--]]
function doChagePukeCallback(puke)
	--执行换牌动画
	local function localChangeOverCallBack()
		changeOVerCallback(puke)
	end

	--[[--
	--更新牌面回调函数
	--]]
	local function updatePukeCallBack()
		--senter的tag值是1....5分别代表五张牌的顺序--
		--根据不同的tag值创建不同的扑克扑克消息来自服务器--
		--pukeNum:2-14:2-A,pukeColor:0-3:方块，梅花，红桃，黑桃--
		CommonControl.playEffect("fanpaiAction.mp3",false) --播放音效
		local num, colorNum = transPukeNumber(remainArray.PaiArray[puke:getTag()].puke)
		updatePuke(puke,num,colorNum)
	end
	local delay = CCDelayTime:create(delaytime)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCScaleTo:create(0.2,0,puke:getScaleY()))
	array:addObject(CCCallFuncN:create(updatePukeCallBack))
	array:addObject(CCScaleTo:create(0.2,puke:getScaleX(),puke:getScaleY()))
	array:addObject(CCCallFuncN:create(localChangeOverCallBack))
	local seq = CCSequence:create(array)
	puke:runAction(seq)
end

function setVisibleForCardValue()
	for i=1,5 do
		if pukeList[i].topValue ~= nil then
			pukeList[i].topValue:setVisible(false)
			pukeList[i].color:setVisible(false)
		end
	end
end

--[[--
--换牌结束的回调函数
--]]
function changeOVerCallback(senter)
	if(senter == 0 or senter:getTag()== lastOfchange) then
		--换牌结束后可以在这里调用中奖处理
		if(changeInfoArray.WinType > 0)  then--如果中奖
			local wintype = changeInfoArray.WinType
			if(wintype <= 5) then
				CommonControl.playEffect("bigerTonghua.mp3",false) --播放音效
			else
				CommonControl.playEffect("smallTonghua.mp3",false) --播放音效
			end
			if(wintype <= 3) then --条件待定，如果出发彩金对彩金事件进行处理并播放音效
				CommonControl.playEffect("chufacaijin.mp3",false)
			end

			winPuke(wintype)---参数需要给出中奖编号1..9等奖
			nowCoinNumLabelAtlas:setStringValue(tostring(changeInfoArray.coin))
			LabelAtlas_win_coin:setStringValue(tostring(changeInfoArray.coin))
			local function isblike(num)
				for i = 1,#changeInfoArray.WinPais do
					if(changeInfoArray.WinPais[i].pai == num)then
						return true
					end
				end
				return false
			end

			for i = 1,5 do

				if(isblike(remainArray.PaiArray[i].puke)) then --给出中奖牌型中的牌的位置---添加闪烁动画
					--Common.log("remainArray.PaiArray[i].puke==========="..remainArray.PaiArray[i].puke)
					local puke = pukeList[i]
					local array = CCArray:create()
					puke:runAction(CCBlink:create(1, 3))
				end
			end

		else
			nowCoinNumLabelAtlas:setStringValue("0")
			LabelAtlas_win_coin:setStringValue("0")
			local array = CCArray:create()
			array:addObject(CCDelayTime:create(1.5))
			array:addObject(CCCallFunc:create(fapaiInit))
			array:addObject(CCCallFunc:create(setVisibleForCardValue))
			---没中奖则重新发牌
			nowCoinNumLabelAtlas:runAction(CCSequence:create(array))
		end
	end
end

--[[--
--更新中奖类型提示图片
--]]
function updateWinTypeImage( imageFileName )
	winTypeImage:loadTexture(CommonControl.miniGameGetResource(imageFileName))
	winTypeImage:setVisible(true)

end

--[[--
--中奖的时候调用的函数
--]]
function winPuke(wintype)--参数需要给出中奖编号1..10等奖
	local function winCallBackOrDropCoin()
		if(changeInfoArray.Winpool == 0) then --如果未获得彩金
			winCallback()
		else
			CommonControl.showWinRewardAnimation()
			CommonControl.playEffect("chufacaijin.mp3",false)
			local coinNum = math.ceil(WinPoolInfo.WinCoinNum / currentStake)
			DropCoinLogic.dropCoin(coinNum, Label_fruit_total_coin, currentStake / 2, winCallback, ccp(coinMoveToPosit.x, coinMoveToPosit.y), coinBatchNode, windowSize.width, windowSize.height)
		end
	end
	if wintype == 10 then
		--五条
		updateWinTypeImage("5tiao.png")
	else
		updateWinTypeImage(string.format("wintype_%d.png",wintype))
	end
	winTypeImage:setScale(8)
	local array = CCArray:create()
	local scaleAction =  CCScaleTo:create(0.2, 1)
	local ease = CCEaseOut:create(scaleAction,0.8)
	local delay = CCDelayTime:create(1)
	array:addObject(ease)
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(winCallBackOrDropCoin))
	local seq = CCSequence:create(array)
	winTypeImage:runAction(seq)
end

--[[--
--中奖动画结束后回调，赢钱以后，隔两秒进行比倍机的切换
--]]
function winCallback()
	changePanel(DIR_UP)
	sendDBID_USER_INFO(profile.User.getSelfUserID())
end

function changePanel(direction)

	if direction == DIR_UP then
		--切换比倍机
		miniGameState = SHOW_BI_BEI_JI
		CommonControl.showAnimaReadyByDir(direction, Panel_JinHuangGuan, Panel_BiBeiJi, "bibeiBackGround.mp3", fruitViewReset)
		BegMachineLogic.changePoker()
		BegMachineLogic.setHandselInfo(handselInfo)
		BegMachineLogic.begCanPress()--设置比倍机界面的按钮可以点击
		fruitViewReset()
	elseif direction == DIR_DOWN then
		--切换金皇冠
		view:setTouchEnabled(true)
		miniGameState = SHOW_JIN_HUANG_GUAN
		sendDBID_USER_INFO(profile.User.getSelfUserID())
		CommonControl.showAnimaReadyByDir(direction, Panel_JinHuangGuan, Panel_BiBeiJi, "fanpaiBackGroundSound.mp3", changeToSlotCallBack)
		BegMachineLogic.clearData()
		begViewReset()
		if BegMachineLogic.isExistReward then
--			sendIMID_MINI_REWARDS_COLLECT(gameType)
			BegMachineLogic.isExistReward = false
		end
		--初始化比倍机的数据
		BegMachineLogic.miniGameShare()
	end
end

--[[--
--切换到金皇冠的回调函数
--]]
function changeToSlotCallBack()
	fapaiInit()
end

function setJiQiButton()
	if miniGameState == SHOW_JIN_HUANG_GUAN then
		begViewReset()
	elseif miniGameState == SHOW_BI_BEI_JI then
		fruitViewReset()
	end
end

--[[--
--金皇冠停止以后，切换到比倍机界面，对需要清空的资源进行清空
--]]
function fruitViewReset()
	--初始化发牌动画
	cardInit()
	setVisibleForCardValue()
	pukeBatchNode:setTouchEnabled(false)
	winTypeImage:setVisible(false)
	--清空前一次的保留记录
	remainArray = {}
	nowCoinNumLabelAtlas:setStringValue("0")
end

--[[--
--比倍机停止以后，切换到金皇冠界面，对需要清空的资源进行清空
--]]
function begViewReset()
	doubleArray = {}
	Button_big:stopAllActions()
	--用户赢的次数初始化
	userWinTimes = 0
	Button_collect:setTouchEnabled(true)
end


--[[--
--翻牌结束回调函数
--]]
local function fanpaiCallback(senter)
	--调用系统建议保留牌的函数
	JinHuangGuanrecommendRemain()
	--显示换牌按钮并可选择保留
	Button_stop:loadTextures(CommonControl.miniGameGetResource("btn_jhg_huanpai.png"),CommonControl.miniGameGetResource("btn_jhg_huanpai.png"),"")
	Button_stop:setTouchEnabled(true)
	ButtonSetState(true, HUANPAI)
	for i=1,5 do
		pukeList[i]:setTouchEnabled(true)
	end
end

--[[--
--翻牌
--]]
function fanpai()
	Common.log("*********************开始翻牌*******************")
	--翻牌过程中不能换牌
	pukeIndex = 1

	currentStake = tonumber(LabelAtlas_raise_coin:getStringValue())
	userCurrentCoin = userCurrentCoin - currentStake
	Label_fruit_total_coin:setText(tostring(userCurrentCoin))
	local paiArray = pukeBatchNode:getChildren()
	for i = 1,5 do
		local puke = paiArray:objectAtIndex(i-1)
		local delay = CCDelayTime:create((i-1)*0.2)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(CCScaleTo:create(0.2,0,puke:getScaleY()))
		array:addObject(CCCallFuncN:create(JinHuangGuanshowCardFront))
		array:addObject(CCCallFuncN:create(JinHuangGuanChangePukeIndexFront))
		array:addObject(CCScaleTo:create(0.2,puke:getScaleX(),puke:getScaleY()))
		if (i == 5) then
			array:addObject(CCCallFuncN:create(fanpaiCallback))
		end
		local seq = CCSequence:create(array)
		puke:runAction(seq)
	end
end

--[[--
--翻牌回调函数
--]]
function JinHuangGuanshowCardFront(senter)
	--senter的tag值是1....5分别代表五张牌的顺序--
	--根据不同的tag值创建不同的扑克扑克消息来自服务器--
	--pukeNum:2-14:2-A,pukeColor:0-3:方块，梅花，红桃，黑桃--

	CommonControl.playEffect("fanpaiAction.mp3",false) --播放音效
	local num, colorNum = transPukeNumber(remainArray.PaiArray[pukeIndex].puke)
	if pukeList[pukeIndex].topValue == nil then
		createpuke(pukeList[pukeIndex],num,colorNum)
	else
		updatePuke(pukeList[pukeIndex], num, colorNum)
	end
end

--[[--
--翻牌计数回调函数
--]]
function JinHuangGuanChangePukeIndexFront(senter)
	pukeIndex = pukeIndex + 1
end

function transPukeNumber(pukeNum)
	local num = 0
	local colorNum = 0
	if pukeNum > 52 then
		num = 14
	else
		if(pukeNum%13 < 11) then
			num = (pukeNum%13) + 3
		else
			num = (pukeNum%13) - 10
		end
		colorNum = pukeNum/13 - (pukeNum/13 % 1)
	end
	return num , colorNum
end

--[[--
--充值按钮回调函数
--]]
function fruitRechargeCallback()
	--	GameConfig.setTheLastBaseLayer(GUI_JINHUANGUAN);
	local myyuanbao = profile.User.getSelfYuanBao()
	if myyuanbao >= 50 then
		Common.openConvertCoin()
	else
		--充值引导
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
		PayGuidePromptLogic.setEnterType(true)
	end
end

--[[--
--返回按钮回调函数
--]]
function callback_Button_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if (miniGameState == SHOW_JIN_HUANG_GUAN)then
			mvcEngine.createModule(GameConfig.getTheLastBaseLayer())
		else
			BegMachineLogic.collectMoney()
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--发消息按钮回调函数
--]]
function callback_Button_talk(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--充值按钮回调函数
--]]
function callback_Button_gift(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if profile.Gift.isShowFirstGiftIcon() then
			--可以购买首充
			sendGIFTBAGID_GET_LOOP_GIFT(103)
		else
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--充值金币按钮回调函数
--]]
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

--[[--
--加注按钮按下
--]]
function callback_Button_raise(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if (readyMessageTable["Raise"] == nil) then
			return
		end
		readyMessageTable["Raise"].currentLevel = readyMessageTable["Raise"].currentLevel + 1
		readyMessageTable["Raise"].currentLevel = readyMessageTable["Raise"].currentLevel <= #readyMessageTable["Raise"] and readyMessageTable["Raise"].currentLevel  or 1
		setRaiseLabel(readyMessageTable["Raise"][readyMessageTable["Raise"].currentLevel].coin)
		updateRaiseRate(readyMessageTable["Raise"][readyMessageTable["Raise"].currentLevel].rate)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--开始按钮回调函数
--]]
function startCallBack()
	isStartFruitCall = true
	CommonControl.playEffect("beginAndChangeButton.mp3",false) --播放音效
	userCurrentCoin = profile.User.getSelfCoin()
	Common.log("userCurrentCoin = "..userCurrentCoin)
	local userduzhuNum = LabelAtlas_raise_coin:getStringValue()
	--翻牌
	if(tonumber(userCurrentCoin) >= tonumber(userduzhuNum))then
		currentStake = tonumber(LabelAtlas_raise_coin:getStringValue())
		sendJHG_START_GAME();
		Common.log("*******************发送开始消息**********************")
		ButtonSetState(false, KAISHI)
		touchLayerTest:setTouchEnabled(false)
		ButtonSetState(false)
	else
		--		CCMessageBox("金钱不足", "提示")
		local needCoin = tonumber(userduzhuNum) - tonumber(userCurrentCoin)
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, needCoin, RechargeGuidePositionID.miniGamePositionE)
	end
end

--[[--
--开始和换牌按钮回调函数
--]]
function callback_Button_stop(component)
	if component == PUSH_DOWN then
		--按下
		Common.log("*********************开始按钮被点击*******************")
	elseif component == RELEASE_UP then
		--抬起
		if (not isStart) then
			startCallBack()
		else
			Common.log("*********************换牌按钮被点击*******************")
			CommonControl.playEffect("beginAndChangeButton.mp3",false) --播放音效
			--屏蔽卡牌的触摸监听
			ButtonSetState(false, HUANPAI)
			pukeBatchNode:setTouchEnabled(false)
			for i=1,5 do
				pukeList[i]:setTouchEnabled(false)
			end
			--将数组remainArray发回给服务器，五个位置，不为nil的代表为保留牌
			sendJHG_CHANGE_PAI()
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--比倍机充值金币按钮回调函数
--]]
function callback_Button_fruit_rechargebibei(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		fruitRechargeCallback()
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--大按钮回调函数
--]]
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

--[[--
--小按钮回调函数
--]]
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

--[[--
--加倍按钮回调函数
--]]
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

--[[--
--收钱按钮回调函数
--]]
function callback_Button_collect(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		BegMachineLogic.collectMoney()
		Button_collect:setTouchEnabled(false)
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
--左边滚动信息
--]]
function getJHG_RICK_WINNING_RECORD()
	local itemTable = profile.JinHuangGuan.getTableOfJHG_RICK_WINNING_RECORD()
	timestamp = itemTable.Timestamp
	local recordArray = Common.copyTab(itemTable.RecordList)
	--当有新数据的时候，将数据添加在最后
	for i=1, #recordArray do
		table.insert(winRecordArray, recordArray[i])
	end
	--	awardsCount = 5
	--当第一次收到老虎机活校信息的时候，初始化table
	if (not isInitUpAwards)then
		if (#winRecordArray >= 5)then
			CommonControl.upAwards(ScrollView_recordList, winRecordArray, timestamp, gameType)
			isInitUpAwards = true
		else
			sendJHG_WINNING_RECORD(timestamp)
		end
	else
		CommonControl.setUpawards(winRecordArray, timestamp)
	end
end

--[[--
--获取收钱信息
--]]
function getTableOfCOLLECT_MONEY()
	local itemTable = profile.JinHuangGuan.getTableOfJHG_RICK_COLLECT_MONEYInfo()
	moneyOfWin = itemTable.Coin
	if(isCollectLast)then
		Common.closeProgressDialog()
	end
	if(itemTable.Successed == 1)then
		if(itemTable.Coin > 0)then
			if currentStake == 0 then
				currentStake = 200
			end
			local coinNum = itemTable.Coin / (currentStake / 2)
			if (isCollectLast)then
				DropCoinLogic.dropCoin(coinNum, Label_fruit_total_coin, currentStake / 2, doRewards, ccp(coinMoveToPosit.x, coinMoveToPosit.y), coinBatchNode, windowSize.width, windowSize.height)
			else
				DropCoinLogic.dropCoin(coinNum, Label_beg_total_coin, currentStake / 2, doRewards, ccp(coinMoveToPosit.x, coinMoveToPosit.y), coinBatchNode, windowSize.width, windowSize.height)
			end
		else
			collectCallBack()
		end
	end
	--此处应该有的逻辑是掉落金币界面，然后还应该有一个切换回去的动画，动画应该写在其他的地方
	--Important 记得清空
	if(itemTable.Successed == 1)then
		Common.SaveTable(profile.User.getSelfUserID().."JINHUANGGUAN",{})--清空本地比倍记录
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
		Common.log("RewardLevel = "..RewardLevel)
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
--服务器推送更新金币数量的消息回调setUserInfo，此处是将改变金币的限制条件放开
--]]
function subDisplayCoin()
	isStartFruitCall = true --设置为true可以进行修改金币操作
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

--[[--
--在金币飞完了以后，重新设置显示金币数量的text
--]]
function updataUserInfo()
	Label_fruit_total_coin:setText(tostring(profile.User.getSelfCoin()))
	Label_beg_total_coin:setText(tostring(profile.User.getSelfCoin()))
end

--[[--
--设置加注按钮不可点击时变灰
--]]
function ButtonSetState(isEnabled, buttonType)
	if isEnabled then
		if buttonType == KAISHI then
			Button_stop:setTouchEnabled(isEnabled)
			Button_stop:loadTextures(CommonControl.miniGameGetResource("btn_jhg_kaishi.png"),CommonControl.miniGameGetResource("btn_jhg_kaishi.png"),"")
		elseif buttonType == HUANPAI then
			Button_stop:setTouchEnabled(isEnabled)
			Button_stop:loadTextures(CommonControl.miniGameGetResource("btn_jhg_huanpai.png"),CommonControl.miniGameGetResource("btn_jhg_huanpai.png"),"")
		else
			Button_raise:setTouchEnabled(isEnabled)
			Button_raise:loadTextures(CommonControl.miniGameGetResource("btn_jhg_jiazhu.png"),CommonControl.miniGameGetResource("btn_jhg_jiazhu.png"),"")
		end
	else
		if buttonType == KAISHI then
			Button_stop:setTouchEnabled(isEnabled)
			Button_stop:loadTextures(CommonControl.miniGameGetResource("btn_jhg_kaishi_unpress.png"),CommonControl.miniGameGetResource("btn_jhg_kaishi_unpress.png"),"")
		elseif buttonType == HUANPAI then
			Button_stop:setTouchEnabled(isEnabled)
			Button_stop:loadTextures(CommonControl.miniGameGetResource("btn_jhg_huanpai_unpress.png"),CommonControl.miniGameGetResource("btn_jhg_huanpai_unpress.png"),"")
		else
			Button_raise:setTouchEnabled(isEnabled)
			Button_raise:loadTextures(CommonControl.miniGameGetResource("btn_jhg_jiazhu_unpress.png"),CommonControl.miniGameGetResource("btn_jhg_jiazhu_unpress.png"),"")
		end
	end
end

--[[--
--获取小游戏大厅内玩家的发言
--]]
function getMiniGameChatMsg()
	local chatInfoTable = profile.MiniGameChat.getMiniGameChatInfoTable()
	if chatInfoTable.MessageContent ~= nil and chatInfoTable.MessageContent ~= "" then
		Label_talk:setText(chatInfoTable.SenderNickname..": "..chatInfoTable.MessageContent)
	elseif chatInfoTable.Result ~= 0 then
		Common.showToast("发言成功", 2)
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
--释放界面的私有数据
--]]
function releaseData()
	BegMachineLogic.clearBegUserData()
	CommonControl.clearCommonData()
	DropCoinLogic.clearDropCoinData()
	AudioManager.stopBgMusic(true)
	AudioManager.stopAllSound()
	AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.HALL_BACKGROUND)
	sendIMID_MINI_QUIT_CHAT_ROOM(gameType)
end

function addSlot()
	framework.addSlot2Signal(DBID_USER_INFO, updataUserInfo)
	framework.addSlot2Signal(BASEID_GET_BASEINFO, setUserInfo)
	framework.addSlot2Signal(JHG_READY_INFO,updataReadyInfo)
	framework.addSlot2Signal(JHG_ROLL_MESSAGE,getscrollMassageInfo)
	framework.addSlot2Signal(JHG_START_GAME,getStartGameInfo)
	framework.addSlot2Signal(JHG_CHANGE_PAI,getChangePaiInfo)
	framework.addSlot2Signal(JHG_RICK_COLLECT_MONEY,getTableOfCOLLECT_MONEY)
	framework.addSlot2Signal(JHG_WINNING_RECORD, getJHG_RICK_WINNING_RECORD)
	framework.addSlot2Signal(IMID_MINI_SEND_MESSAGE, getMiniGameChatMsg)
	framework.addSlot2Signal(IMID_MINI_REWARDS_JUDGE, BegMachineLogic.reqIsExistRewardInfo)
	framework.addSlot2Signal(IMID_MINI_REWARDS_BASEINFO, getMiniGameRewardInfoJudge)
	framework.addSlot2Signal(IMID_MINI_REWARDS_COLLECT, BegMachineLogic.getMiniGameRewards)
	framework.addSlot2Signal(MANAGERID_GIVE_AWAY_GOLD, updataUserInfoPoChan)
end

function removeSlot()
	framework.removeSlotFromSignal(DBID_USER_INFO, updataUserInfo)
	framework.removeSlotFromSignal(BASEID_GET_BASEINFO, setUserInfo)
	framework.removeSlotFromSignal(JHG_READY_INFO,updataReadyInfo)
	framework.removeSlotFromSignal(JHG_ROLL_MESSAGE,getscrollMassageInfo)
	framework.removeSlotFromSignal(JHG_START_GAME,getStartGameInfo)
	framework.removeSlotFromSignal(JHG_CHANGE_PAI,getChangePaiInfo)
	framework.removeSlotFromSignal(JHG_RICK_COLLECT_MONEY,getTableOfCOLLECT_MONEY)
	framework.removeSlotFromSignal(JHG_WINNING_RECORD, getJHG_RICK_WINNING_RECORD)
	framework.removeSlotFromSignal(IMID_MINI_SEND_MESSAGE, getMiniGameChatMsg)
	framework.removeSlotFromSignal(IMID_MINI_REWARDS_JUDGE, BegMachineLogic.reqIsExistRewardInfo)
	framework.removeSlotFromSignal(IMID_MINI_REWARDS_BASEINFO, getMiniGameRewardInfoJudge)
	framework.removeSlotFromSignal(IMID_MINI_REWARDS_COLLECT, BegMachineLogic.getMiniGameRewards)
	framework.removeSlotFromSignal(MANAGERID_GIVE_AWAY_GOLD, updataUserInfoPoChan)
end
