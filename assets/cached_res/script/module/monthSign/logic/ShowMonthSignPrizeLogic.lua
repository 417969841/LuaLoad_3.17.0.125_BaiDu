module("ShowMonthSignPrizeLogic",package.seeall)

view = nil;

Panel_ShowPrize = nil;--奖品Panel
ImageView_PrizePic = nil;--奖品图片
ImageView_PrizeTitle = nil;--奖品标题(图)（老版本）
Label_PrizeInfoTop = nil;--奖品介绍(上部)
Label_PrizeInfoLower = nil;--奖品介绍(下部)
ImageView_ShowPrize = nil;--奖品背景
Label_PrizeTitle = nil;--奖品标题(字)

monthSignPrizeTable = {}; --月签奖励列表
userIsSignDate = {};--用户已签到的信息(包含今天)
signStatus = 0;--签到状态
showPrizeDay = 0;--展示第几天的奖品

local PRIZE_PIC = 1; --奖品图片
local PRIZE_TITLE = 0; --奖品标题
--status 签到状态
local NO_SIGN_STATUS = 0;--未签到
local HAS_SIGN_STATUS = 1;--已签到
local MISS_SIGN_STATUS = 2;--缺签到

--[[--
--关闭弹出框
--]]
local function closeTheBox()
	mvcEngine.destroyModule(GUI_SHOW_MONTHSIGN_PRIZE);
end

--[[--
--界面关闭动画
--]]
local function thisLayerCloseAmin()
	LordGamePub.closeDialogAmin(ImageView_ShowPrize,closeTheBox);
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		thisLayerCloseAmin();
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_ShowPrize = cocostudio.getUIPanel(view, "Panel_ShowPrize");
	ImageView_PrizePic = cocostudio.getUIImageView(view, "ImageView_PrizePic");
	Label_PrizeInfoTop = cocostudio.getUILabel(view, "Label_PrizeInfoTop");
	ImageView_PrizeTitle = cocostudio.getUIImageView(view, "ImageView_PrizeTitle");
	ImageView_ShowPrize = cocostudio.getUIImageView(view, "ImageView_ShowPrize");
	Label_PrizeInfoLower = cocostudio.getUILabel(view, "Label_PrizeInfoLower");
	Label_PrizeTitle = cocostudio.getUILabel(view, "Label_PrizeTitle");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("ShowMonthSignPrize.json")
	local gui = GUI_SHOW_MONTHSIGN_PRIZE
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
end

--[[--
--加载月签奖品图片
--]]
local function loadImageMonthSignPrize(path)
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

	if photoPath ~= nil and photoPath ~= "" then
		if ImageView_PrizePic  ~= nil and tonumber(id) == PRIZE_PIC then
			ImageView_PrizePic:loadTexture(photoPath)
		elseif ImageView_PrizeTitle  ~= nil and tonumber(id) == PRIZE_TITLE then
			ImageView_PrizeTitle:loadTexture(photoPath)
			ImageView_PrizeTitle:setScale(1.3);
		end
	end

end

--[[--
--初始化label数据
--]]
local function initLabelData()
	local prizeInfoLowerStr = "";
	if #userIsSignDate < showPrizeDay then
		signStatus = NO_SIGN_STATUS;
	else
		signStatus = userIsSignDate[showPrizeDay]["status"];
	end
	if signStatus ==MISS_SIGN_STATUS then
		prizeInfoLowerStr = "已错过";
	elseif  signStatus ==HAS_SIGN_STATUS then
		prizeInfoLowerStr = "已领取";
	elseif signStatus ==NO_SIGN_STATUS then
		prizeInfoLowerStr = monthSignPrizeTable[showPrizeDay].thisPrizeTips2
	end
	Label_PrizeInfoTop:setText(monthSignPrizeTable[showPrizeDay].thisPrizeTips1);
	Label_PrizeInfoLower:setText(prizeInfoLowerStr);
	Label_PrizeTitle:setText(monthSignPrizeTable[showPrizeDay].awardTitle)
end

--[[--
--下载服务器图片数据
--]]
local function downloadServerPic()
	Common.getPicFile(monthSignPrizeTable[showPrizeDay]["prizeTitleUrl"], PRIZE_TITLE, true, loadImageMonthSignPrize);
	Common.getPicFile(monthSignPrizeTable[showPrizeDay]["prizePicUrl"], PRIZE_PIC, true, loadImageMonthSignPrize);
end

--[[--
--设置月签奖品数据
--@param #number day 第几天
--]]
function setMonthSignPrizeData(day)
	monthSignPrizeTable = profile.MonthSign.getMonthSignRewardListTable();
	userIsSignDate = profile.MonthSign.getUserIsSignDate();
	showPrizeDay = day;

	initLabelData();
--	downloadServerPic();
end

function requestMsg()

end

function callback_Panel_ShowPrize(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		thisLayerCloseAmin();
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
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
