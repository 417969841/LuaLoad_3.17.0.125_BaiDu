module("HallCoverLogic",package.seeall)

view = nil;

Panel_HallCover = nil;--大厅覆盖panel
Image_Title = nil;--标题
Image_Move = nil;--移动的Image
Image_BtnPic = nil;--按钮图片
Image_Light = nil;--发光图片

changeButtonIDTable = {};--更新的按钮ID
buttonID = 0;--按钮ID

local timeTable = {};--时间集

timeTable.MOVE_UP_TIME = 13/24;--向上移动的时间(比赛赢奖从小变大原大小、财神是原来的1.1倍)
timeTable.CAI_SHEN_MOVE_UP_TIME = 20/24;--向上移动的时间(财神第二次向上移动的时间、财神变成原大小)
timeTable.CAI_SHEN_SYNCLINE_MOVE_TIME = 8/24;--财神斜上移动(财神归位、签到移动的时间)
timeTable.MOVE_LEFE_TIME = 10/24;--向左移到最终位置
timeTable.TITLE_FADE_IN_TIME = 10/24;--"开启新功能"标题延时出现
timeTable.TITLE_FADE_OUT_TIME = 3/24;--"开启新功能"标题延时消失
timeTable.ICON_SCALE_TIME = 14/24;--图标变大一次或变小一次的时间
timeTable.PK_GAME_FADE_IN_TIME = 13/24;--闯关赛：13/24秒图标由半透明变为不透明
timeTable.PK_GAME_SCALE_TIME = 16/24;--闯关赛变大或变小的时间
timeTable.PK_GAME_PAUSE_TIME = 6/24;--闯关赛停顿的时间(后左移)
timeTable.DELAY_TO_LIGHT_TIME = 5/24;--解锁成功后延时发光

local ICON_HEIGHT_MUL = 4/5; --财神上移其高度的, 斜上移动
local HALF_OPACITY = 80;--透明值
local ICON_LARGER = 1.1--图片变大的倍数
local ICON_SMALLER = 0.7--图片变小的倍数
local BG_SCALE_LARGER = 1.5; --发光背景变大的倍数
local BG_SCALE_SMALLER = 0.8; --发光背景变小的倍数

local imageMoveTopY = 0;--财神停止时, Image_move的Y轴值
local imageMoveMidX = 0;--财神按钮变大变小时, Image_Move的X轴值
local imageMoveMidY = 0;--财神按钮变大变小时, Image_Move的Y轴值
local panelHallY = 0;--大厅的panel_hall的Y轴
local panelTopY = 0;--大厅的panel_top的Y轴

local changeIDNum = 0; --改变ID的数量

--[[--
--关闭当前层
--]]
local function closeThisLayer()
	changeIDNum = #changeButtonIDTable;

	if changeIDNum == 1 then
		HallLogic.isUnlockAnimationPlay = false;
		--更新首页礼包数据
		HallLogic.updateHallGiftDataAfterUnlockAnim();
		profile.ButtonsStatus.clearChangeBtnIDData();
		mvcEngine.destroyModule(GUI_HALLCOVER);
	else
		--更新两个按钮,连续播
		table.remove(changeButtonIDTable, 1);
		coverHallByBtnId(changeButtonIDTable[1]);
	end
end

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	--		closeThisLayer();
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_HallCover = cocostudio.getUIPanel(view, "Panel_HallCover");
	Image_Title = cocostudio.getUIImageView(view, "Image_Title");
	Image_Move = cocostudio.getUIImageView(view, "Image_Move");
	Image_BtnPic = cocostudio.getUIImageView(view, "Image_BtnPic");
	Image_Light = cocostudio.getUIImageView(view, "Image_Light");
end

--[[--
--初始化数据
--]]
local function initData()
	--改变的按钮ID数据
	changeButtonIDTable = profile.ButtonsStatus.getChangeBtnIDTable();
	panelHallY = HallLogic.panel_hall:getPosition().y;
	panelTopY = HallLogic.panel_top:getPosition().y;
	imageMoveTopY = HallButtonConfig.TOP_Y + panelTopY;
	imageMoveMidX = GameConfig.ScreenWidth / 2;
	imageMoveMidY = HallButtonConfig.MID_Y + panelHallY;
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_HALLCOVER;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("HallCover.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("HallCover.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("HallCover_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	CCDirector:sharedDirector():getRunningScene():addChild(view);

	--初始化控件
	initView();
	--初始化数据
	initData();
end

--[[--
--初始化控件的数据
--]]
local function initViewData()
	if buttonID == HallButtonConfig.BTN_ID_MATCH_GAME then
		--比赛赢奖
		Image_Move:setPosition(ccp(HallButtonConfig.MID_FOUR_BTN_RIGHT_X, imageMoveMidY));
		HallLogic.btn_matchgame:setVisible(false);
		Image_BtnPic:loadTexture(Common.getResourcePath("bisaiyingjiang_hall.png"));
		Image_Light:setScale(BG_SCALE_LARGER)
	elseif buttonID == HallButtonConfig.BTN_ID_CAI_SHEN then
		--财神
		Image_Move:setPosition(ccp(imageMoveMidX, 0));
		Image_BtnPic:loadTexture(Common.getResourcePath("ic_hall_caishen.png"));
		Image_BtnPic:setScale(ICON_SMALLER);
		Image_Light:setScale(BG_SCALE_SMALLER)
	end
end

--[[--
--获取时间集
--]]
function getTimeTable()
	return timeTable;
end

--[[--
--财神上移
--]]
function MoveUpCaiShen()
	local function callBack()
		--Image_Move移动
		imageToMoveAmin(HallButtonConfig.CAI_SHEN_X, imageMoveTopY, HallButtonManage.moveOtherUpperButtons, closeThisLayer, timeTable.CAI_SHEN_SYNCLINE_MOVE_TIME);
	end

	local scaleTo = CCScaleTo:create(timeTable.CAI_SHEN_MOVE_UP_TIME, 1);
	local move = CCMoveTo:create(timeTable.CAI_SHEN_MOVE_UP_TIME,ccp(imageMoveMidX, (imageMoveTopY + imageMoveMidY ) / 2));
	local callFunc = CCCallFuncN:create(callBack);
	local arr = CCArray:create();
	arr:addObject(move);
	arr:addObject(callFunc);
	local seq = CCSequence:create(arr);
	Image_BtnPic:runAction(scaleTo);
	Image_Move:runAction(seq);
end

--[[--
--Image_Move移动
--@param #number x panel移动到的X轴
--@param #number y panel移动到的Y轴
--@param #number hallFunc 回调方法大厅的方法
--@param #number coverFunc 回调方法覆盖层的方法
--@param #number nTime 移动的时间
--]]
function imageToMoveAmin(x, y, hallFunc, coverFunc, nTime)
	Image_Move:stopAllActions();
	local function callBack()
		--如果有回调大厅的方法
		if hallFunc ~= nil then
			hallFunc(nTime);
		end
	end

	local move = CCMoveTo:create(nTime,ccp(x, y));
	local callFuncBack = CCCallFuncN:create(callBack);
	local arr = CCArray:create();
	arr:addObject(CCSpawn:createWithTwoActions(move, callFuncBack));

	--如果有大厅覆盖的方法
	if coverFunc ~= nil then
		local callCoverFunc = CCCallFuncN:create(coverFunc);
		arr:addObject(callCoverFunc);
	end

	local seq = CCSequence:create(arr);
	Image_Move:runAction(seq);
end

--[[--
--回调移动Image_Move
--]]
function callBackToMoveImage()
	if buttonID == HallButtonConfig.BTN_ID_MATCH_GAME then
		--Image_Move移动
		imageToMoveAmin(HallButtonConfig.MID_FOUR_BTN_CENTRE_X, imageMoveMidY, HallButtonManage.exchangePositionsOfMidThreeBtns, closeThisLayer, timeTable.MOVE_LEFE_TIME);
	elseif buttonID == HallButtonConfig.BTN_ID_CAI_SHEN then
		--财神上移
		MoveUpCaiShen();
	end
end

--[[--
--icon的变大变小
--@param #boolean hasMoveUp 所在父控件是否有向上移的动作
--@param #number fadeTime 淡入的时间
--@param #number scaleValue 变大变小之前,当前icon的大小值
--]]
function scaleToIconAmin(hasMoveUp,fadeTime, scaleValue)
	local arr = CCArray:create();
	--step1：从半透明到不透明
	local fadeIn = CCFadeIn:create(fadeTime);
	if hasMoveUp then
		--财神变到scaleValue值
		local scaleTo = CCScaleTo:create(fadeTime, scaleValue);
		arr:addObject(CCSpawn:createWithTwoActions(scaleTo, fadeIn));
	else
		--比赛赢奖淡入
		arr:addObject(fadeIn);
	end
	--step2：变大后变小(两次)
	local scaleBig = CCScaleTo:create(timeTable.ICON_SCALE_TIME, ICON_LARGER * scaleValue);
	local scaleSmall = CCScaleTo:create(timeTable.ICON_SCALE_TIME, scaleValue);
	arr:addObject(scaleBig);
	arr:addObject(scaleSmall);
	arr:addObject(scaleBig);
	arr:addObject(scaleSmall);
	--step3：回调
	local callFunc = CCCallFuncN:create(callBackToMoveImage);
	arr:addObject(callFunc);
	local seq = CCSequence:create(arr);
	Image_BtnPic:runAction(seq);
end

--[[--
--展示icon动画
--]]
function showCoverAnim()
	if buttonID == HallButtonConfig.BTN_ID_MATCH_GAME then
		--比赛赢奖(变大变小)
		scaleToIconAmin(true,timeTable.MOVE_UP_TIME, 1);
	elseif buttonID == HallButtonConfig.BTN_ID_CAI_SHEN then
		--财神(Image_Move移动)
		imageToMoveAmin(imageMoveMidX, imageMoveMidY, nil, nil, timeTable.MOVE_UP_TIME);
		--财神的变大变小
		scaleToIconAmin(true,timeTable.MOVE_UP_TIME, ICON_LARGER);
	end
end

--[[--
--展示标题动画
--]]
function showTitleAnim()
	--step1：半透明到不透明
	local fadeIn = CCFadeIn:create(timeTable.TITLE_FADE_IN_TIME);
	--step2：延时(icon变大变小)
	local delay = CCDelayTime:create(timeTable.ICON_SCALE_TIME * 4);
	--step3：不透明到消失
	local fadeOut = CCFadeOut:create(timeTable.TITLE_FADE_OUT_TIME);
	local array = CCArray:create();
	array:addObject(fadeIn);
	array:addObject(delay);
	array:addObject(fadeOut);
	local seq = CCSequence:create(array);
	Image_Title:runAction(seq);
end

--[[--
--根据按钮ID覆盖大厅
--@param #number value 按钮ID
--]]
function coverHallByBtnId(value)
	buttonID = value;
	--初始化控件的数据
	initViewData();
	--标题动画
	showTitleAnim();
	--动画
	showCoverAnim();
end

function requestMsg()

end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
