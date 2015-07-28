module("LuckyTurnTableLogic",package.seeall)

view = nil;

Panel_TurnTable = nil;--转盘
Button_Return = nil;--返回
Label_GetPrizeTips = nil;---走马灯(得奖)提示
Button_Lottery = nil;--抽奖按钮
Label_cishu = nil;--抽奖次数
Button_Help = nil;--帮助按钮
turnTableLotteryInfoTable = {}; --转盘抽奖信息
moveApertureSprite = nil; --移动光圈精灵
showPrizeBgSprite = nil;--展示奖品背景

local startLotteryCellIndex = 1;--抽奖动画开始的奖品位置
local lastLotteryCellIndex = 1;--上一个抽奖动画开始的位置
luckyTurnTablePrizeUITable = {};--幸运转盘奖品UI table
turnTablePrizeTable = {}; --转盘奖励
turnTableRunTimes = 0;--转盘转圈的次数
isTurnTableDataUpdate = false; --转盘数据是否已经更新
local TURN_TABLE_RUN_MAX_TIMES = 5;--转盘转圈最多的次数,超过则抽奖失败

--抽奖类型
local FREE_LOTTERY = 0;--免费抽奖
local GOLD_LOTTERY = 1;--金币抽奖
local INGOT_LOTTERY = 2;--元宝抽奖
--tag
local TAG_IMG_PRIZE_TITLE = 1; --奖品标题图片
local TAG_IMG_PRIZE = 2; --奖品图片
--奖品
local ONE_CELL_WIDTH = 131;--奖品所在的ImageView的宽
local ONE_CELL_HEIGHT = 99;--奖品所在的ImageView的高
--时间
local MOVE_ONE_CELL_TIME_1 = 0.3;--慢时间
local MOVE_ONE_CELL_TIME_2 = 0.05;--快时间
--数量
local TURN_TABLE_PRIZE_NUM = 16;--奖品数量
--cell position
local FIRST_CELL_X = 240;--第一个格的X 248;
local FIRST_CELL_Y = 419;--第一个格的Y338;
local CIRCLING_MULTIPLES = 2;--一次循环走的圈数
local turnTablePosition = 3;--转盘走马灯position

allLotteryCellPositionTable = {}; --所有抽奖格的位置坐标(相对于view)
local isLotteryMsgBack = false;--抽奖消息是否已经回来
local url = "http://f.99sai.com/html/rotary/rotary_intro.html";--帮助url

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		mvcEngine.createModule(GameConfig.getTheLastBaseLayer());
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_TurnTable = cocostudio.getUIPanel(view, "Panel_TurnTable");
	Button_Return = cocostudio.getUIButton(view, "Button_Return");
	Label_GetPrizeTips = cocostudio.getUILabel(view, "Label_GetPrizeTips");
	Button_Lottery = cocostudio.getUIButton(view, "Button_Lottery");
	Label_cishu = cocostudio.getUILabel(view, "Label_cishu");
	Button_Help = cocostudio.getUIButton(view, "Button_Help");
end

--[[--
--获取所有抽奖格的位置坐标
--]]
local function getAllLotteryCellPosition()
	--以左上角为开始(第一个格), 顺时针摆放奖品
	for cellIndex = 1 , #turnTablePrizeTable do
		--奖品的ID
		--		local prizeID = turnTablePrizeTable[cellIndex]["prizeID"];
		allLotteryCellPositionTable[cellIndex] = {};
		--		allLotteryCellPositionTable[cellIndex]["prizeID"] = prizeID;
		if cellIndex < 7 then
			allLotteryCellPositionTable[cellIndex]["position"] = ccp(FIRST_CELL_X + ONE_CELL_WIDTH * (cellIndex - 1), FIRST_CELL_Y);
		elseif cellIndex < 10 then
			allLotteryCellPositionTable[cellIndex]["position"] = ccp(FIRST_CELL_X + ONE_CELL_WIDTH * 5, FIRST_CELL_Y - ONE_CELL_HEIGHT * (cellIndex - 6) );
		elseif cellIndex < 15 then
			allLotteryCellPositionTable[cellIndex]["position"] = ccp(FIRST_CELL_X + ONE_CELL_WIDTH * (14 - cellIndex), FIRST_CELL_Y - ONE_CELL_HEIGHT * 3 );
		else
			allLotteryCellPositionTable[cellIndex]["position"] = ccp(FIRST_CELL_X, FIRST_CELL_Y - ONE_CELL_HEIGHT * (17 - cellIndex) );
		end
	end
end

--[[--
--创建移动光圈精灵
--]]
local function createMoveApertureSprite()
	moveApertureSprite = CCSprite:create(Common.getResourcePath("ui_ddz_BG_zhezhao.png"));
	moveApertureSprite:setPosition(allLotteryCellPositionTable[startLotteryCellIndex]["position"]);
	moveApertureSprite:setVisible(false);
	view:addChild(moveApertureSprite);
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("LuckyTurnTable.json")
	local gui = GUI_LUCKY_TURNTABLE
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
	GameConfig.setTheCurrentBaseLayer(GUI_LUCKY_TURNTABLE);
	GameStartConfig.addChildForScene(view);

	initView();
	Button_Lottery:setTouchEnabled(false);
	--获取转盘数据
	getTurnTableData();

	if turnTablePrizeTable ~= nil and #turnTablePrizeTable ~= 0 then
		--有数据
		showTurnTableBasicInfo();
		isTurnTableDataUpdate = true;
	end

	--再次发消息,为了获取用户抽奖次数
	sendTURNTABLE_BASIC_INFO(profile.LuckyTurnTable.getTurnTableBasicInfoTimeStamp());

	profile.Marquee.resetMARQUEE_TABLE(turnTablePosition);--设置抽奖走马灯position
	getMarqueeText();
end

function requestMsg()

end

--[[--
--初始化幸运转盘UI table
--]]
local function initLuckyTurnTablePrizeUITable()
	for i = 1 , #turnTablePrizeTable do
		luckyTurnTablePrizeUITable[i] = {};
		luckyTurnTablePrizeUITable[i]["ImageView_Prize" .. i] = cocostudio.getUIImageView(view, "ImageView_Prize" .. i);--奖品框
		luckyTurnTablePrizeUITable[i]["ImageView_Prize".. i .. "_PrizePic"] = cocostudio.getUIImageView(view, "ImageView_Prize".. i .. "_PrizePic");--奖品图片
		luckyTurnTablePrizeUITable[i]["ImageView_Prize".. i .. "_PrizeTitle"] = cocostudio.getUIImageView(view,"ImageView_Prize".. i .. "_PrizeTitle");--奖品标题(图)
		luckyTurnTablePrizeUITable[i]["Label_Prize".. i .. "_PrizeInfo"] = cocostudio.getUILabel(view, "Label_Prize"..i .."_PrizeInfo");--奖品描述
	end
end

--[[--
--设置开始抽奖动画的位置下标
--@param #number prizeID 奖品ID
--]]
local function setStartLotteryCellIndex(prizeID)
	lastLotteryCellIndex = startLotteryCellIndex;
	for i =1, #turnTablePrizeTable do
		if turnTablePrizeTable[i]["prizeID"] == prizeID then
			startLotteryCellIndex = i;
		end
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
		mvcEngine.createModule(GameConfig.getTheLastBaseLayer());
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--展现奖品动画
--]]
local function showPrizeAnimation()
	--设置抽奖按钮可点
	Button_Lottery:setTouchEnabled(true);
	--Imageurl 网络图片地址 ImagePath 本地图片 strTitle 标题strDetails 内容 time 显示时间
	ImageToast.createView(turnTablePrizeTable[startLotteryCellIndex]["prizePicUrl"],nil, turnTableLotteryInfoTable["PrizeDetails"], "",  2)
end

--[[--
--移动一格
--@param #number cellIndex 奖品位置下标,以左上角为1
--]]
local function moveToOneCell(cellIndex)
	local move =  CCMoveTo:create(0, allLotteryCellPositionTable[cellIndex]["position"]);
	return move;
end

--[[--
--移动一格
--@param #number moveNum 移动的次数
--@param #number lotteryCellIndex 移动起始位置
--@param #number timeInterval 移动间隔时间
--]]
local function playLotteryAnimation(moveNum, lotteryCellIndex, timeInterval)
	local array = CCArray:create();
	local cellIndex = 0;
	local move = nil
	moveApertureSprite:stopAllActions();
	--移动结束
	local function moveEnd()
		animationTimeScheduler();
	end
	for j = 1, moveNum do
		if (lotteryCellIndex + j) % TURN_TABLE_PRIZE_NUM == 0 then
			cellIndex = TURN_TABLE_PRIZE_NUM;
		else
			cellIndex = (lotteryCellIndex + j) % TURN_TABLE_PRIZE_NUM;
		end

		array:addObject(CCDelayTime:create(timeInterval));--延时
		move = moveToOneCell(cellIndex);
		array:addObject(move);
		--监听结束
		if isLotteryMsgBack == false and j == TURN_TABLE_PRIZE_NUM * CIRCLING_MULTIPLES then
			array:addObject(CCCallFuncN:create(moveEnd));
		end
	end

	if isLotteryMsgBack then
		array:addObject(CCDelayTime:create(timeInterval));
		array:addObject(CCCallFuncN:create(showPrizeAnimation));
		isLotteryMsgBack = false;
	end

	local seq = CCSequence:create(array);
	moveApertureSprite:runAction(seq);
end

--[[--
--抽奖失败停止抽奖动画
--]]
local function lotteryFailure()
	turnTableRunTimes = 0;
	Button_Lottery:setTouchEnabled(true);
	startLotteryCellIndex = lastLotteryCellIndex;
	--抽奖光圈离开回到抽奖前
	moveApertureSprite:setPosition(allLotteryCellPositionTable[startLotteryCellIndex]["position"]);
	mvcEngine.createModule(GUI_TEXT_TRANSPARENT_BOX);
	local msg = "发送未知错误, 抽奖失败！";
	TextTransparentBoxLogic.setTransparentBoxTipsText(msg)
end

--[[--
--动画定时
--]]
function animationTimeScheduler()
	local moveNum = 0; --移动次数
	local lotteryCellIndex = 0;--移动起始位置
	local timeInterval = 0;--移动间隔时间
	--抽奖消息已回
	if isLotteryMsgBack then
		lotteryCellIndex = lastLotteryCellIndex;
		timeInterval =MOVE_ONE_CELL_TIME_1
		if startLotteryCellIndex > lastLotteryCellIndex then
			moveNum = startLotteryCellIndex - lastLotteryCellIndex;
		else
			moveNum = TURN_TABLE_PRIZE_NUM + startLotteryCellIndex - lastLotteryCellIndex;
		end
	else
		--未回
		turnTableRunTimes = turnTableRunTimes + 1;
		timeInterval =MOVE_ONE_CELL_TIME_2;
		lotteryCellIndex = startLotteryCellIndex;
		moveNum = TURN_TABLE_PRIZE_NUM * CIRCLING_MULTIPLES;
	end
	if turnTableRunTimes > TURN_TABLE_RUN_MAX_TIMES then
		lotteryFailure();
	else
		playLotteryAnimation(moveNum,lotteryCellIndex,timeInterval);
	end
end

--[[--
--不能抽奖弹框
--]]
local function showBoxCanNotLottery()
	mvcEngine.createModule(GUI_TEXT_TRANSPARENT_BOX);
	local msg = "抽奖次数不足，您可以去【疯狂闯关】中获得！";
	TextTransparentBoxLogic.setTransparentBoxTipsText(msg)
	TextTransparentBoxLogic.setShowGoToGuanBtn()
end

--[[--
--点击抽奖按钮后
--]]
local function afterTouchLotteryBtn()
	--免费抽奖次数不够
	if profile.LuckyTurnTable.getLotteryNum() < 1 then
		-- 不能抽奖弹框
		showBoxCanNotLottery()
	else
		turnTableRunTimes = 0;
		moveApertureSprite:setVisible(true);
		--设置开始抽奖动画的奖品ID
		setStartLotteryCellIndex(turnTablePrizeTable[startLotteryCellIndex]["prizeID"]);
		--发送转盘抽奖消息(免费抽奖)
		sendTURNTABLE_LOTTERY_INFO(FREE_LOTTERY);
		--设置抽奖按钮不可点
		Button_Lottery:setTouchEnabled(false);
		--动画定时
		animationTimeScheduler();
	end
end

--[[--
--抽奖按钮
--]]
function callback_Button_Lottery(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		afterTouchLotteryBtn();
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--展示帮助信息
--]]
local function showHelpMsg()
	mvcEngine.createModule(GUI_TEXT_TRANSPARENT_BOX);
	--	local url = profile.LuckyTurnTable.getTurnTablePlayIntroduction();
	--	TextTransparentBoxLogic.setTransparentBoxTipsUrl(url)
	TextTransparentBoxLogic.setTransparentBoxTipsUrl(GameConfig.URL_TABLE_LUKEYTURN_HELP, "URL_TABLE_LUKEYTURN_HELP")
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

--[[
--加载转盘奖品列表图片
--]]
local function loadImageTurnTablePrizePicList(path)
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
		id = string.sub(path, 1, i-1);
		photoPath = string.sub(path, j+1, -1)
		Common.log("ID ========== " .. id)
		Common.log("photoPath ======== " .. photoPath)
	end
	--数据为空,return
	if photoPath == nil or photoPath == "" then
		return;
	end
	if luckyTurnTablePrizeUITable[tonumber(id)] == nil then
		return;
	end

	if luckyTurnTablePrizeUITable[tonumber(id)]["ImageView_Prize".. id .. "_PrizePic"] ~= nil then
		luckyTurnTablePrizeUITable[tonumber(id)]["ImageView_Prize".. id .. "_PrizePic"]:loadTexture(photoPath)
	end
end

--[[
--加载转盘奖品列表图片
--]]
local function loadImageTurnTablePrizeTitleList(path)
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
		Common.log("ID ========== " .. id)
		Common.log("photoPath ======== " .. photoPath)
	end
	--数据为空,return
	if photoPath == nil or photoPath == "" then
		return;
	end
	if luckyTurnTablePrizeUITable[tonumber(id)] == nil then
		return;
	end

	if luckyTurnTablePrizeUITable[tonumber(id)]["ImageView_Prize".. id .. "_PrizeTitle"] ~= nil then
		luckyTurnTablePrizeUITable[tonumber(id)]["ImageView_Prize".. id .. "_PrizeTitle"]:loadTexture(photoPath)
	end
end

--[[--
--下载服务器图片
--]]
local function downloadServerPic()
	for index =1 , #turnTablePrizeTable do
		Common.getPicFile(turnTablePrizeTable[index]["PrizeDesUrl"], index, true, loadImageTurnTablePrizeTitleList);
		Common.getPicFile(turnTablePrizeTable[index]["prizePicUrl"], index, true, loadImageTurnTablePrizePicList);
	end
end

--[[--
--初始化转盘 label 数据
--]]
local function initTurnTablePrizeLabelData()
	local thisPrizeInfo = "";
	for i = 1 , #turnTablePrizeTable do
		thisPrizeInfo = turnTablePrizeTable[i]["thisPrizeInfo"] ;--奖品描述
		if thisPrizeInfo ~=nil and thisPrizeInfo ~= "" then
			luckyTurnTablePrizeUITable[i]["Label_Prize".. i .. "_PrizeInfo"]:setText(thisPrizeInfo);
		end
	end
end

--[[--
--设置抽奖次数
--]]
local function setLotteryTimes()
	if profile.LuckyTurnTable.getLotteryNum() == 0 then
		Label_cishu:setColor(ccc3(228,78,63))
	else
		Label_cishu:setColor(ccc3(249,235,219))
	end
	Label_cishu:setText(profile.LuckyTurnTable.getLotteryNum());
end

--[[
--获取转盘数据
--]]
function getTurnTableData()
	turnTablePrizeTable = profile.LuckyTurnTable.getTurnTablePrizeTable();
end

--[[--
--展示转盘基本信息
--]]
function  showTurnTableBasicInfo()
	--初始化幸运转盘UI table
	initLuckyTurnTablePrizeUITable();
	getAllLotteryCellPosition();
	createMoveApertureSprite();
	--下载服务器图片
	downloadServerPic();
	--初始化转盘奖励 label数据
--	initTurnTablePrizeLabelData();
	--设置抽奖次数
	setLotteryTimes();
	Button_Lottery:setTouchEnabled(true);
end

--[[--
--应答转盘基本信息消息
--]]
function processTurnTableBasicInfo()
	--获取转盘数据
	getTurnTableData();

	if isTurnTableDataUpdate then
		--如果转盘数据已更新,仅设置抽奖次数
		setLotteryTimes();
	else
		--展示转盘基本信息
		showTurnTableBasicInfo();
	end
end

--[[--
--应答转盘抽奖消息
--]]
function processTurnTableLotteryInfo()
	turnTableLotteryInfoTable = profile.LuckyTurnTable. getTurnTableLotteryInfoTable();
	--抽奖成功
	if turnTableLotteryInfoTable["result"] == 1 then
		isLotteryMsgBack = true;
		--设置开始抽奖动画的cellIndex
		setStartLotteryCellIndex(turnTableLotteryInfoTable["prizeID"]);
		--设置抽奖次数
		setLotteryTimes();
	end
end

--[[
--播放走马灯信息
--]]
function InfoLabelScroll()
	local Text = profile.Marquee.getOPERID_ACTIVITY_MARQUEE();
	if Text == nil then
		Common.log("InfoLabelScroll Text is nil")
		return
	end
	local movetoTime =  0.01
	local winSize = CCDirector:sharedDirector():getWinSize()
	Label_GetPrizeTips:stopAllActions()
	Label_GetPrizeTips:setText(Text)
	Label_GetPrizeTips:setAnchorPoint(ccp(0,0.5))
	Label_GetPrizeTips:setPosition(ccp(winSize.width*1.2,Label_GetPrizeTips:getPosition().y))
	local moveby =  CCMoveBy:create(movetoTime*(Label_GetPrizeTips:getContentSize().width +winSize.width*1.2),ccp(-Label_GetPrizeTips:getContentSize().width - winSize.width*1.2,0))
	local headActioArray = CCArray:create()
	headActioArray:addObject(moveby)
	headActioArray:addObject(CCCallFuncN:create(InfoLabelScroll))
	Label_GetPrizeTips:runAction(CCRepeatForever:create(CCSequence:create(headActioArray)))
end

--[[--
--应答走马灯
--]]
function getMarqueeText()
	Common.log("Signal_OPERID_ACTIVITY_MARQUEE")
	InfoLabelScroll()
end


function callback_Panel_TurnTable(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if TextTransparentBoxLogic.isSecondLayerOpened() then
			TextTransparentBoxLogic.thisLayerCloseAmin();
		end

	elseif component == CANCEL_UP then
	--取消

	end
end


--[[--
--释放界面的私有数据
--]]
function releaseData()
	startLotteryCellIndex = 1;
	lastLotteryCellIndex = 1;
end

function addSlot()
	framework.addSlot2Signal(TURNTABLE_BASIC_INFO, processTurnTableBasicInfo);
	framework.addSlot2Signal(TURNTABLE_LOTTERY_INFO, processTurnTableLotteryInfo);
	framework.addSlot2Signal(OPERID_ACTIVITY_MARQUEE, getMarqueeText);
end

function removeSlot()
	framework.removeSlotFromSignal(TURNTABLE_BASIC_INFO, processTurnTableBasicInfo);
	framework.removeSlotFromSignal(TURNTABLE_LOTTERY_INFO, processTurnTableLotteryInfo);
	framework.removeSlotFromSignal(OPERID_ACTIVITY_MARQUEE, getMarqueeText);
end
