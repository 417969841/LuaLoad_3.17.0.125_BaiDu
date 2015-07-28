module("MonthSignLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_MonthSign = nil;--月签
ImageView_mianban = nil;--
Label_SignDaysNum = nil;--已经签到的天数
Button_Help = nil;--帮助
Button_Return = nil;--返回
thisPrizeTips = "";--转盘提示语
ImageView_Day1 = nil;--
ScrollView_monthSign = nil
signImageAnimation = nil
imageIndex = 0
turnSignDay =  nil --轮到第几天签到
allSignDay  = nil --总签到天数

MonthSignUITable = {};--月签列表UI table
signSprite = nil --打勾动画

--signTipsArmature = nil; --签到提示动画
monthSignPrizeTable = {}; --月签奖励列表
userVIPLevelTurnTable = {};--用户VIP等级对应的转盘数
userIsSignDate = {};--用户已签到的信息(包含今天)
TodaySignPrize = {}; ----今天签到信息
vipLevel = 0;--VIP等级
hasSendSignToMonthSign = false;--已发送签到消息
local isAutomaticPopUp = false;--是否自动弹出月签

local nextVipMultipleLotteryTimes = 0; --下一级VIP比当前VIP多的抽签次数
local nextVipMultipleLotteryTimesSum = 0; --下一级VIP比当前VIP多的抽签次数总和
local VipLevelStr = ""; --vip等级
local lotteryTimes = 0;--抽奖次数
local hasBeenSignDayNum = 0;

local tipsInColumn = 0; --提示所在列
local tipsInRow = 0; --提示所在行

openBoxTag = 0;
isMonthSignRewardListMsgBack = false;--月签奖励列表消息是否已经回来

--cell
local ONE_PRIZE_CELL_WIDTH = 210 ; --奖品所在的格子的宽
local ONE_PRIZE_CELL_HEIGHT = 92; --奖品所在的格子的高

--other
local TURN_TABLE_PRIZE_TYPE = 3;--转盘奖品的类型(0：金币 1：道具 2：碎片 3：转盘 -1：今天已签)
local HAS_TURN_TABLE_DAY = 5;--奖品为转盘的天数
local TAG_HAS_SIGN_BG = 13;--签到的遮罩tag
local TAG_SIGN_TIPS = 117;--签到提示动画

local url = "http://f.99sai.com/html/monthly_sign/monthly_sign_intro.html";--帮助url

--[[--
--退出月签
--]]
local function exitMothSign()
	--	mvcEngine.createModule(GameConfig.getTheLastBaseLayer());
	local function actionOver()
		mvcEngine.destroyModule(GUI_MONTHSIGN)
	end
	LordGamePub.closeDialogAmin(ImageView_mianban, actionOver)
	if GameConfig.getTheLastBaseLayer() == GUI_HALL and isAutomaticPopUp then
		isAutomaticPopUp = false;
		--当前是大厅并且是自动弹出的,则显示每日登陆提示界面
		MessagesPreReadManage.createDailyLoginPromptView();
	end
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		exitMothSign();
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--设置是否是自动弹出
--@param #boolean flag true 登录时自动弹出月签 false 不是自动弹出
--]]
function setAutomaticPopUpValue(flag)
	isAutomaticPopUp = flag;
end

--[[--
--展现奖品动画
--]]
local function showPrizeAnimation()
	if TodaySignPrize.TodayReceivePrizeType ~= TURN_TABLE_PRIZE_TYPE then
		--Imageurl 网络图片地址 ImagePath 本地图片 strTitle 标题strDetails 内容 time 显示时间
		ImageToast.createView(monthSignPrizeTable[#userIsSignDate]["prizePicUrl"],nil, TodaySignPrize["TodayPrizeDetails"], "成功领取",  2)
	end
end

--[[--
--显示打钩或叉
--@param #number index 第几天
--]]
local function showTickOrCross(index)
	if MonthSignUITable["day" .. index] == nil or MonthSignUITable["day" .. index]["ImageView_Day" .. index] == nil then
		return;
	end

	local hasSignImageView = MonthSignUITable["day" .. index]["ImageView_Day" .. index];
	if index ~= #userIsSignDate and hasSignImageView:getChildByTag(TAG_HAS_SIGN_BG) == nil then --当天签到不蒙灰
		local changeHasSignBgSprite = UIImageView:create(); --在已签的View上蒙灰
		changeHasSignBgSprite:loadTexture(Common.getResourcePath("box.png"));
		changeHasSignBgSprite:setScaleX(136/changeHasSignBgSprite:getContentSize().width)
		changeHasSignBgSprite:setScaleY(99/changeHasSignBgSprite:getContentSize().height)
		changeHasSignBgSprite:setOpacity(125)
		changeHasSignBgSprite:setZOrder(8);
		changeHasSignBgSprite:setTag(TAG_HAS_SIGN_BG);
		hasSignImageView:addChild(changeHasSignBgSprite);
	end
	local signFlagPicName = "";--签到标志图片
	if userIsSignDate[index].status == 1 then
		signFlagPicName = "ui_yiqian.png";
	else
		signFlagPicName = "ui_weiqian.png";
	end
	--打钩或叉
	local signSprite = UIImageView:create();
	signSprite:loadTexture(Common.getResourcePath(signFlagPicName));
	signSprite:setZOrder(5);
	signSprite:setPosition(ccp(0,5));
	hasSignImageView:addChild(signSprite);
end

--[[--
--打开转盘信息
--@param #number index 下标
--]]
local function openPrizeTurnTableInfo(index)
	--	GameConfig.setTheLastBaseLayer(GUI_MONTHSIGN);
	mvcEngine.createModule(GUI_SINGLE_BTN_TRANSPARENT_BOX);
	--没签
	if index > #userIsSignDate then
		openBoxTag = SingleBtnTransparentBoxLogic.getTransparentBoxTag().NO_SIGN_TO_LOTTERY;
		thisPrizeTips = monthSignPrizeTable[index]["thisPrizeTips2"];
	else
		--已签
		openBoxTag = SingleBtnTransparentBoxLogic.getTransparentBoxTag().HAS_SIGN_TO_LOTTERY;
		thisPrizeTips = "";
	end;
	SingleBtnTransparentBoxLogic.setTransparentBoxTipsText(openBoxTag, thisPrizeTips);
end

--[[--
--打开其他奖品信息
--@param #number index 下标
--]]
local function openOtherPrizeInfo(index)
	--奖品标题
	mvcEngine.createModule(GUI_SHOW_MONTHSIGN_PRIZE);
	ShowMonthSignPrizeLogic.setMonthSignPrizeData(index);
end

--[[--
--删除动态打钩更换静态钩
--@param #number index 下标
--]]
local function removeDynamicTick(index)
	if view:getChildByTag(1001) ~= nil and index % HAS_TURN_TABLE_DAY ~= 0 then
		view:removeChildByTag(1001,  true);
		showTickOrCross(#userIsSignDate);
	end
end

--[[--
--不签到展示奖品
--@param #number index 下标
--]]
local function showPrizeWithNoSign(index)
	if index % HAS_TURN_TABLE_DAY == 0 then
		--转盘奖品
		openPrizeTurnTableInfo(index);
	else
		--其他奖品
		openOtherPrizeInfo(index)
	end
	removeDynamicTick(index)
end

--[[--
--轮到当天签到
--@param #number index 下标
--]]
local function showPrizeWithIsSignDay(index)
	if profile.MonthSign.isSignToday() then
		showPrizeWithNoSign(index);
	elseif hasSendSignToMonthSign == false then
		-- 未签到：发送签到消息(不能重复发送	签到消息)
		sendSIGN_TO_MONTH_SIGN();
		hasSendSignToMonthSign = true;
		--更改今天签到信息
		profile.MonthSign.setTodayIsSign();
		processSignToMonthSign();
	end
end

--[[--
--点击后显示弹框
--@param #number index 下标
--]]
local function touchToShowBox(index)
	--轮到当天签到
	if index ==  #userIsSignDate then
		showPrizeWithIsSignDay(index);
	else
		--不是签到天
		showPrizeWithNoSign(index);
	end
end

--[[--
--点击签到框
--]]
local function tuochImageView(day)
	if isMonthSignRewardListMsgBack and monthSignPrizeTable[day] ~= nil then
		touchToShowBox(day);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_MonthSign = cocostudio.getUIPanel(view, "Panel_MonthSign");
	Label_SignDaysNum = cocostudio.getUILabel(view, "Label_SignDaysNum");
	Button_Help = cocostudio.getUIButton(view, "Button_Help");
	Button_Return = cocostudio.getUIButton(view, "Button_Return");
	ImageView_Day1 = cocostudio.getUIImageView(view, "ImageView_Day1");
	ScrollView_monthSign = cocostudio.getUIScrollView(view, "ScrollView_monthSign");
	ImageView_mianban = cocostudio.getUIImageView(view, "ImageView_mianban");
end


--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("MonthSign.json")
	local gui = GUI_MONTHSIGN
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
	GameStartConfig.addChildForScene(view);
	initView();


	--获取月签数据
	getMonthSignData();

	if monthSignPrizeTable == nil or #monthSignPrizeTable == 0 then
		--数据为空,重新发送消息
		sendMONTH_SIGN_REWARD_LIST(profile.MonthSign.getMonthSignRewardListTimeStamp());
		Common.showProgressDialog("数据加载中,请稍后...");
		Common.log("zbl...是发送1")
	else
		showMonthSignData();
		Common.log("zbl...不是发送")
	end
end

function requestMsg()

end

--[[--
--展示帮助信息
--]]
local function showHelpMsg()
	mvcEngine.createModule(GUI_TEXT_TRANSPARENT_BOX);
	TextTransparentBoxLogic.setTransparentBoxTipsUrl(GameConfig.URL_TABLE_MONTHSIGN_HELP, "URL_TABLE_MONTHSIGN_HELP")
end

--[[--
--帮助按钮
--]]
function callback_ImageView_Help(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		showHelpMsg();
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--返回按钮
--]]
function callback_ImageView_Return(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		exitMothSign();
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--加载月签奖品图片列表图片
--]]
local function loadImageMonthSignPrizePicList(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]

		Common.log("update"..photoPath)
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		--  string.sub(s,i,j) 提取字符串s的第i个到第j个字符。Lua中，第一个字符的索引值为1，最后一个为-1，以此类推，如：
		--  Common.log(string.sub("[hello world]",2,-2))      --输出hello world
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end

	if photoPath == nil or  photoPath == ""then
		return
	end

	if MonthSignUITable["day" .. id] ~= nil and MonthSignUITable["day" .. id]["ImageView_Day" .. id .. "_Prize"] ~= nil then
		MonthSignUITable["day" .. id]["ImageView_Day" .. id .. "_Prize"]:loadTexture(photoPath)
		MonthSignUITable["day" .. id]["ImageView_Day" .. id .. "_Prize"]:setScale(0.8);
	end
end

--[[--
--加载月签奖品标题列表图片
--]]
local function loadImageMonthSignPrizeTitleList(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]

		Common.log("update"..photoPath)
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		Common.log(i, j)
		--  string.sub(s,i,j) 提取字符串s的第i个到第j个字符。Lua中，第一个字符的索引值为1，最后一个为-1，以此类推，如：
		--  Common.log(string.sub("[hello world]",2,-2))      --输出hello world
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath == nil or  photoPath == ""then
		return
	end
	if MonthSignUITable["day" .. id] ~= nil and MonthSignUITable["day" .. id]["ImageView_Day" .. id .. "_Title"] ~= nil then
		MonthSignUITable["day" .. id]["ImageView_Day" .. id .. "_Title"]:loadTexture(photoPath)
	end
end

--[[--
--下载服务器图片
--]]
local function downloadServerPic()
	for index =1 , #monthSignPrizeTable do
		if index % HAS_TURN_TABLE_DAY ~= 0 then
			Common.getPicFile(monthSignPrizeTable[index]["prizeTitleUrl"], index, true, loadImageMonthSignPrizeTitleList);
			LordGamePub.downloadImageForNative(monthSignPrizeTable[index]["prizePicUrl"], index, true, loadImageMonthSignPrizePicList);
		end
	end
end

--[[--
--显示或隐藏下一级vip的提示
--@param #number day 第N天
--@param #number nextVipMultipleLotteryTimes 下一级VIP比当前VIP多的领取的转盘数
--]]
local  function showOrHideNextVipTips(day,nextVipMultipleLotteryTimes)
	--imageView 为空 return
	if MonthSignUITable["day" .. day]["ImageView_Day" .. day .. "_NextVipTips"] == nil then
		return;
	end

	if nextVipMultipleLotteryTimes == 0 then
		MonthSignUITable["day" .. day]["ImageView_Day" .. day .. "_NextVipTips"]:setVisible(false);
	end
end

--[[--
--月签列表的TurnTable数据
--@param #number index 下标
--]]
local function setTurnTableData(index)
	if MonthSignUITable["day" .. index] == nil then
		return;
	end

	if index % HAS_TURN_TABLE_DAY == 0 then
		nextVipMultipleLotteryTimes = userVIPLevelTurnTable[index / HAS_TURN_TABLE_DAY]["nextVipMultiTimes"];
		--显示或隐藏下一级vip的提示
		showOrHideNextVipTips(index,nextVipMultipleLotteryTimes)
		lotteryTimes = userVIPLevelTurnTable[index / HAS_TURN_TABLE_DAY]["times"];
		if MonthSignUITable["day" .. index]["Label_Day" .. index .. "_NextLevelAddTimes"] ~= nil then
			MonthSignUITable["day" .. index]["Label_Day" .. index .. "_NextLevelAddTimes"]:setText("+" .. nextVipMultipleLotteryTimes .."次");
		end
		if MonthSignUITable["day" .. index]["Label_Day" .. index .. "_LotteryTimesInfo"] ~= nil  then
			MonthSignUITable["day" .. index]["Label_Day" .. index .. "_LotteryTimesInfo"]:setText("抽奖" .. lotteryTimes .. "次");
			MonthSignUITable["day" .. index]["Label_Day" .. index .. "_LotteryTimesInfo1"]:setText("抽奖" .. lotteryTimes .. "次");
		end
		nextVipMultipleLotteryTimesSum = nextVipMultipleLotteryTimesSum + nextVipMultipleLotteryTimes;
	else
		if MonthSignUITable["day" .. index]["Label_Day" .. index .. "_PrizeInfo"] ~= nil then
			MonthSignUITable["day" .. index]["Label_Day" .. index .. "_PrizeInfo"]:setText(monthSignPrizeTable[index].thisPrizeNumInfo)
			MonthSignUITable["day" .. index]["Label_Day" .. index .. "_PrizeInfo1"]:setText(monthSignPrizeTable[index].thisPrizeNumInfo)
		end
	end
end

--[[--
--月签列表的VIP数据
--@param #number index 下标
--]]
local function setMonthSignVipData(index)
	vipLevel = VIPPub.getUserVipType(profile.User.getSelfVipLevel());
	if MonthSignUITable["day" .. index] == nil then
		return;
	end

	if index % HAS_TURN_TABLE_DAY == 0 then
		if nextVipMultipleLotteryTimesSum == 0 and MonthSignUITable["day" .. index]["Label_Day" .. index .. "_NextVipLevel"] ~= nil then
			MonthSignUITable["day" .. index]["Label_Day" .. index .. "_NextVipLevel"]:setText("VIP" .. vipLevel);
		elseif MonthSignUITable["day" .. index]["Label_Day" .. index .. "_NextVipLevel"] ~= nil then
			MonthSignUITable["day" .. index]["Label_Day" .. index .. "_NextVipLevel"]:setText("VIP" .. (vipLevel + 1));
		end
	end
end

--[[--
--初始化月签label数据
--]]
local function initMonthSignLabelData()
	--已签到的天数
	Label_SignDaysNum:setText(hasBeenSignDayNum);
	--月签列表
	for i =1 , #monthSignPrizeTable do
		--月签列表的TurnTable数据
		setTurnTableData(i);
	end
	for i =1 , #monthSignPrizeTable do
		setMonthSignVipData(i)
	end

end

--[[--
--获取月签数据
--]]--
function getMonthSignData()
	monthSignPrizeTable = profile.MonthSign.getMonthSignRewardListTable();
	userIsSignDate = profile.MonthSign.getUserIsSignDate();
	userVIPLevelTurnTable = profile.MonthSign.getUserVIPLevelTurnTable();
end

--[[--
--已签到的天数
--]]
local function setHasBeenSignDayNum()
	hasBeenSignDayNum = #userIsSignDate;
	--今天没有签到
	if not profile.MonthSign.isSignToday() then
		hasBeenSignDayNum = hasBeenSignDayNum - 1;
	end
end

local function showZhuanQuanAnimation(kongjian)
	if signImageAnimation ~= nil then
		return
	end
	signImageAnimation = ccs.image({
		image = Common.getResourcePath("zhuanquan1.png"),
	})
	signImageAnimation:setPosition(ccp(0,0))
	kongjian:addChild(signImageAnimation)
	--	signImageAnimation:setPosition(kongjian:getPosition())
	--	ScrollView_monthSign:addChild(signImageAnimation)
	signImageAnimation:setTouchEnabled(false)
	local array = CCArray:create()
	local delay = CCDelayTime:create(0.2)
	array:addObject(CCCallFuncN:create(
		function()
			imageIndex = imageIndex % 3
			local photoUrl = "zhuanquan" .. imageIndex .. ".png"
			signImageAnimation:loadTexture(Common.getResourcePath(photoUrl))
			imageIndex = imageIndex + 1
		end
	))
	array:addObject(delay)
	local seq = CCSequence:create(array)
	local req = CCRepeatForever:create(seq)
	signImageAnimation:runAction(req)
end

--[[--
--签到提示动画
--]]
local function signTipsAnimation()
	turnSignDay =  #userIsSignDate; --轮到第几天签到
	allSignDay  = #monthSignPrizeTable; --总签到天数
	if turnSignDay > 15 then
		--后15天将整个scrollview向上移动100%
		ScrollView_monthSign:scrollToPercentVertical(100,0.1,false)
	end

--	showZhuanQuanAnimation(MonthSignUITable["day" .. turnSignDay]["ImageView_Day" .. turnSignDay])
--	if signImageAnimation ~= nil then
--		if profile.MonthSign.isSignToday() then
----			signImageAnimation:stopAllActions();
--			signImageAnimation:setVisible(false);
--		else
--			signImageAnimation:setVisible(true);
--		end
--	end

	if profile.MonthSign.isSignToday() then
		--已签
	else
		showZhuanQuanAnimation(MonthSignUITable["day" .. turnSignDay]["ImageView_Day" .. turnSignDay])
	end

	Common.log("zbl..签到 .. " ..turnSignDay .. " 天")

end


--[[--
--显示已签(缺签)
--]]
local function showHasBeenSign()
	for i = 1, hasBeenSignDayNum do
		showTickOrCross(i);
	end
end

--[[--
--初始化MonthSignUITable
--]]
local function initMonthSignUITable()
	for i = 1, #monthSignPrizeTable do
		MonthSignUITable["day" .. i] = {};
		MonthSignUITable["day" .. i]["ImageView_Day" .. i] = cocostudio.getUIImageView(view, "ImageView_Day" .. i);
		if i % HAS_TURN_TABLE_DAY == 0 then
			--下一级vip提示
			MonthSignUITable["day" .. i]["ImageView_Day" .. i .. "_NextVipTips"] = cocostudio.getUILabel(view, "ImageView_Day" ..i .. "_NextVipTips");
			--下一级VIP label
			MonthSignUITable["day" .. i]["Label_Day" .. i .. "_NextVipLevel"] = cocostudio.getUILabel(view, "Label_Day" ..i .. "_NextVipLevel");
			--下一级VIP 增加的抽奖数label
			MonthSignUITable["day" .. i]["Label_Day" .. i .. "_NextLevelAddTimes"] = cocostudio.getUILabel(view, "Label_Day" ..i .. "_NextLevelAddTimes");
			--签到抽签次数
			MonthSignUITable["day" .. i]["Label_Day" .. i .. "_LotteryTimesInfo"] = cocostudio.getUILabel(view, "Label_Day" ..i .. "_LotteryTimesInfo");
			MonthSignUITable["day" .. i]["Label_Day" .. i .. "_LotteryTimesInfo1"] = cocostudio.getUILabel(view, "Label_Day" ..i .. "_LotteryTimesInfo1");
		else
			MonthSignUITable["day" .. i]["ImageView_Day" .. i .. "_Prize"] = cocostudio.getUIImageView(view, "ImageView_Day" ..i .. "_Prize");
			--奖品标题图片
			MonthSignUITable["day" .. i]["ImageView_Day" .. i .. "_Title"] = cocostudio.getUIImageView(view, "ImageView_Day" ..i .. "_Title");
			--奖品数量label
			MonthSignUITable["day" .. i]["Label_Day" .. i .. "_PrizeInfo"] = cocostudio.getUILabel(view, "Label_Day" ..i .. "_PrizeInfo");
			MonthSignUITable["day" .. i]["Label_Day" .. i .. "_PrizeInfo1"] = cocostudio.getUILabel(view, "Label_Day" ..i .. "_PrizeInfo1");
		end
	end
end

--[[--
--应答月签奖励列表
--]]
function processMonthSignRewardList()
	Common.closeProgressDialog();
	--获取月签数据
	getMonthSignData();
	--展示月签数据
	showMonthSignData();
end

--[[--
--展示月签数据
--]]
function  showMonthSignData()
	Common.log("zbl...检测调用次数")
	--初始化MonthSignUITable
	initMonthSignUITable();
	--已签到的天数
	setHasBeenSignDayNum();
	--下载服务器图片
	downloadServerPic();
	--初始化月签label数据
	initMonthSignLabelData();
	--签到提示动画
	signTipsAnimation();
	--显示已签(缺签)
	showHasBeenSign();
	isMonthSignRewardListMsgBack = true;
end

--[[--
--打钩动画
--]]
local function tickAnimation()
	Common.log("zbl 。。 调用打勾动画")
	--签到所在的ImageView
	--	local signSprite = CCSprite:create(Common.getResourcePath("ui_yiqian.png", pathTypeInApp))
	if signSprite ~= nil then
		return
	end
	signSprite = ccs.image({
		image = Common.getResourcePath("ui_yiqian.png"),
	})
	signSprite:setScale(20);
	signSprite:setZOrder(100);
	signSprite:setAnchorPoint(ccp(0.5,0.5));
	signSprite:setTag(1001);
	signSprite:setPosition(ccp(0,0));
	signSprite:setTouchEnabled(false)
	--	view:addChild(signSprite);
	MonthSignUITable["day" .. turnSignDay]["ImageView_Day" .. turnSignDay]:setZOrder(10);
	MonthSignUITable["day" .. turnSignDay]["ImageView_Day" .. turnSignDay]:addChild(signSprite)
	local scaleAction =  CCScaleTo:create(0.25, 1);
	local ease = CCEaseOut:create(scaleAction,0.8);
	local array = CCArray:create();
	array:addObject(ease);
	array:addObject(CCDelayTime:create(0.05));
	--回调展示奖品
	array:addObject(CCCallFunc:create(showPrizeAnimation));
	array:addObject(CCCallFunc:create(function()
		MonthSignUITable["day" .. turnSignDay]["ImageView_Day" .. turnSignDay]:setScale(1)
		signSprite:setScale(1)
	end));
	local seq = CCSequence:create(array);
	signSprite:setZOrder(100);
	signSprite:runAction(seq);
end

--[[--
--签到动画
--]]
function signAnimation()
	--打钩动画
	tickAnimation();
	--隐藏提示动画
	--	signTipsArmature:setVisible(false);
	signImageAnimation:stopAllActions();
	signImageAnimation:setVisible(false);
	signImageAnimation:removeFromParent()
	if signImageAnimation == nil then
		Common.log("zbl ..为空")
	else
		Common.log("zbl ..不为空")
	end
end

--[[--
--签到成功
--]]
local function afterSignSuccess()
	--领取转盘奖品：创建前往抽奖界面
	if TodaySignPrize.TodayReceivePrizeType == TURN_TABLE_PRIZE_TYPE then
		mvcEngine.createModule(GUI_SINGLE_BTN_TRANSPARENT_BOX);
		thisPrizeTips = userVIPLevelTurnTable[#userIsSignDate / HAS_TURN_TABLE_DAY].thisPrizeTips1; --提示语
		SingleBtnTransparentBoxLogic.setTransparentBoxTipsText(SingleBtnTransparentBoxLogic.getTransparentBoxTag().NOW_SIGN_TO_LOTTERY, thisPrizeTips);
	else
		--其他奖品：签到动画
		signAnimation();
	end
	Label_SignDaysNum:setText(hasBeenSignDayNum + 1);
end

--[[--
--应答月签签到
--]]
function processSignToMonthSign()
	TodaySignPrize = profile.MonthSign.getTodayPrize();
	--签到成功后做的事
	afterSignSuccess();
end

--[[--
--第25天
--]]--
function callback_ImageView_Day25(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayTwentyFiveIndex = 25;
		tuochImageView(dayTwentyFiveIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第24天
--]]--
function callback_ImageView_Day24(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayTwentyFourIndex = 24;
		tuochImageView(dayTwentyFourIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第23天
--]]--
function callback_ImageView_Day23(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayTwentyThreeIndex = 23;
		tuochImageView(dayTwentyThreeIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第22天
--]]--
function callback_ImageView_Day22(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayTwentyTwoIndex = 22;
		tuochImageView(dayTwentyTwoIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第21天
--]]--
function callback_ImageView_Day21(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayTwentyOneIndex = 21;
		tuochImageView(dayTwentyOneIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第20天
--]]--
function callback_ImageView_Day20(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayTwentyIndex = 20;
		tuochImageView(dayTwentyIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第19天
--]]--
function callback_ImageView_Day19(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayNineteenIndex = 19;
		tuochImageView(dayNineteenIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第18天
--]]--
function callback_ImageView_Day18(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayEighteenIndex = 18;
		tuochImageView(dayEighteenIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第17天
--]]--
function callback_ImageView_Day17(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local daySeventeenIndex = 17;
		tuochImageView(daySeventeenIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第16天
--]]--
function callback_ImageView_Day16(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local daySixteenIndex = 16;
		tuochImageView(daySixteenIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第15天
--]]--
function callback_ImageView_Day15(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayFifteenIndex = 15;
		tuochImageView(dayFifteenIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第14天
--]]--
function callback_ImageView_Day14(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayFourteenIndex = 14;
		tuochImageView(dayFourteenIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第13天
--]]--
function callback_ImageView_Day13(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayThirteenIndex = 13;
		tuochImageView(dayThirteenIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第12天
--]]--
function callback_ImageView_Day12(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayTwelveIndex = 12;
		tuochImageView(dayTwelveIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第11天
--]]--
function callback_ImageView_Day11(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayElevenIndex = 11;
		tuochImageView(dayElevenIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第10天
--]]--
function callback_ImageView_Day10(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayTenIndex = 10;
		tuochImageView(dayTenIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第9天
--]]--
function callback_ImageView_Day9(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayNineIndex = 9;
		tuochImageView(dayNineIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第8天
--]]--
function callback_ImageView_Day8(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayEightIndex = 8;
		tuochImageView(dayEightIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第7天
--]]--
function callback_ImageView_Day7(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local daySevenIndex = 7;
		tuochImageView(daySevenIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第6天
--]]--
function callback_ImageView_Day6(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local daySixIndex = 6;
		tuochImageView(daySixIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第5天
--]]--
function callback_ImageView_Day5(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayFiveIndex = 5;
		tuochImageView(dayFiveIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第4天
--]]--
function callback_ImageView_Day4(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayFourIndex = 4;
		tuochImageView(dayFourIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第3天
--]]--
function callback_ImageView_Day3(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayThreeIndex = 3;
		tuochImageView(dayThreeIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第2天
--]]--
function callback_ImageView_Day2(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local dayTwoIndex = 2;
		tuochImageView(dayTwoIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--第1天
--]]--
function callback_ImageView_Day1(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.log("qiandao....sss")
		local dayOneIndex = 1;
		tuochImageView(dayOneIndex);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
end

function addSlot()
	framework.addSlot2Signal(MONTH_SIGN_REWARD_LIST, processMonthSignRewardList)
	--	framework.addSlot2Signal(SIGN_TO_MONTH_SIGN, processSignToMonthSign)
end

function removeSlot()
	framework.removeSlotFromSignal(MONTH_SIGN_REWARD_LIST, processMonthSignRewardList)
	--	framework.removeSlotFromSignal(SIGN_TO_MONTH_SIGN, processSignToMonthSign)
end
