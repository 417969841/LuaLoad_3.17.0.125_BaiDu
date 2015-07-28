module("ChuangGuanLogic",package.seeall)

view = nil;

Panel_20 = nil;--
ScrollView_GetPrizeTips = nil;--
Label_GetPrizeTips = nil;--
Button_Begin = nil;--
Button_Help = nil;--
Button_Back = nil;--
Button_Top = nil;--
Label_Relive = nil;--
Label_Stone = nil;--
Button_Buy = nil;--
Button_Refresh = nil;--
Label_Rank = nil;--
ScrollView_Mission = nil;--
Button_LuckyTurn = nil;--
ImageView_Cloud_Left = nil;--
ImageView_Cloud_Right = nil;--
Image_Begin_Inner = nil;--
CrazyList = {} --闯关信息列表
CrazyImageListTable = {} --闯关奖励图片列表
CrazyLabelListTable = {} --闯关奖励文字列表
CrazyNowLevelAwardTable = {} --本关奖励table,做动画用
ImageDiZhu = nil
Label_Relive_count = nil
URL_CLOUD_LFET = "http://f.99sai.com/operational/crazy_stage/cg_leftcloud.png"
URL_CLOUD_RIGHT = "http://f.99sai.com/operational/crazy_stage/cg_rightcloud.png"
PreloadingImageUITable = {}
PreloadingImageURLTable = {}
autoShowRankListInfo = false
local canPlayCrazyStage = false
--全局变量
local size = nil

local viewX = 0--左右间隔
local viewY = 0 --y位置
local viewW = 0   --宽度
local viewH = 0--高度
local cellWidth = 0 --每个元素的宽
local cellHeight = 0 --每个元素的高
local spacingH = 0 --纵向间隔
local cellSize = 0 --元素个数
local goodsPrice = nil --复活石价格

local afterBuyStone = false --是否是在购买复活石之后

local beforeLevel = nil --闯关赛结束前在哪一关

local nowLevel = nil --闯关赛结束后在哪一关

local MAX_SHOW_LEVEL = 11 -- 最多显示多少层

local hasNewLuckyTurnChance = false --是否有新的幸运游戏转盘机会.用于显示红点

local luckyTurnAwardID = 701002 --抽奖ID,用于判断是否有新转盘机会

local point = nil --提示有新转盘机会的红点

local lookTimer = nil --播放领奖动画后再播放地主上楼动画的计时器

--幸运转盘坐标
local luckyTurnPosX = 1070
local luckyTurnPosY = 580

local todayFirstPlay = false --是否是今天第一次打开闯关赛

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		beforeLevel = CrazyList.CurrentLevel
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--创建叹号(红点)
--]]
local function createPoint()
	Common.log("createPoint")
	if point ~= nil then
		Common.log("createPoint point not nil")
		return;
	end

	point = UIImageView:create();
	point:loadTexture(Common.getResourcePath("gift_tan_hao.png"));
	point:setPosition(ccp(30,20));
end

--[[--
--更新奖品列表图片
]]
local function updataCrazyImageList(path)
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
	if photoPath ~= nil and photoPath ~= "" and CrazyImageListTable[""..id] ~= nil then
		CrazyImageListTable[""..id]:setVisible(true);
		CrazyImageListTable[""..id]:loadTextures(photoPath,photoPath,photoPath);
		CrazyImageListTable[""..id]:setScale(1);
		--如果可以领奖,设置奖品动画
		if CrazyList.Receivable == 1 then
			--如果能领奖,播放奖品动画
			CommShareConfig.showCrazySharePanel(CrazyList.CurrentLevel)
			for i = 1,#CrazyNowLevelAwardTable do
				if (""..id) == CrazyNowLevelAwardTable[i] then
					CrazyImageListTable[""..id]:stopAllActions()
					LordGamePub.showShakeAnimate(CrazyImageListTable[""..id])
				end
			end
		end
	end
end

--[[--
--更新预加载图片
--]]--
local function updataPreloadingImageList(path)
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
	if photoPath ~= nil and photoPath ~= "" and PreloadingImageUITable[tonumber(id)] ~= nil then
		Common.log("updataPreloadingImageList not nil")
		PreloadingImageUITable[tonumber(id)]:setVisible(true);
		PreloadingImageUITable[tonumber(id)]:loadTexture(photoPath);
		PreloadingImageUITable[tonumber(id)]:setScale(1);
	end
end


--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	ScrollView_GetPrizeTips = cocostudio.getUIScrollView(view, "ScrollView_GetPrizeTips");
	Label_GetPrizeTips = cocostudio.getUILabel(view, "Label_GetPrizeTips");
	Button_Begin = cocostudio.getUIButton(view, "Button_Begin");
	Button_Help = cocostudio.getUIButton(view, "Button_Help");
	Button_Back = cocostudio.getUIButton(view, "Button_Back");
	Button_Top = cocostudio.getUIButton(view, "Button_Top");
	Label_Stone = cocostudio.getUILabel(view, "Label_Stone");
	Button_Buy = cocostudio.getUIButton(view, "Button_Buy");
	Button_Refresh = cocostudio.getUIButton(view, "Button_Refresh");
	Label_Rank = cocostudio.getUILabel(view, "Label_Rank");
	Button_LuckyTurn = cocostudio.getUIButton(view, "Button_LuckyTurn");
	ScrollView_Mission = cocostudio.getUIScrollView(view, "ScrollView_Mission");
	ImageView_Cloud_Left = cocostudio.getUIImageView(view, "ImageView_Cloud_Left");
	ImageView_Cloud_Right = cocostudio.getUIImageView(view, "ImageView_Cloud_Right");
	Label_Relive = cocostudio.getUILabel(view, "Label_Relive");
	Label_Relive_count = cocostudio.getUILabel(view, "Label_Relive_count");
	Image_begin = cocostudio.getUIImageView(view, "Image_begin");
	Button_LuckyTurn:setVisible(false)
	Button_LuckyTurn:setTouchEnabled(false)
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("ChuangGuan.json")
	local gui = GUI_CHUANGGUAN
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
	size = CCDirector:sharedDirector():getWinSize()
	initView();
	GameConfig.setTheCurrentBaseLayer(GUI_CHUANGGUAN)
	viewX = 0--左右间隔
	viewY = 0 --y位置
	viewW = 1136   --宽度
	viewH = 588--高度
	cellWidth = 1048 --每个元素的宽
	cellHeight = 221 --每个元素的高
	spacingH = 30 --纵向间隔
	showBuildingBg()
	getIsTodayFirstPlay()
	Common.showProgressDialog("数据加载中,请稍后...")
	sendOPERID_CRAZY_STAGE_BASE_INFO()
	preloadingImage()
	profile.Marquee.resetMARQUEE_TABLE(3);--设置抽奖走马灯position
	getMarqueeText();

end

--[[--
--预加载图片
--]]--
function preloadingImage()
	Common.log("preloadingImage")
	PreloadingImageUITable[1] = ImageView_Cloud_Left
	PreloadingImageUITable[2] = ImageView_Cloud_Right
	PreloadingImageURLTable[1] = URL_CLOUD_LFET
	PreloadingImageURLTable[2] = URL_CLOUD_RIGHT

	for i = 1,#PreloadingImageUITable do
		Common.log("preloadingImage PreloadingImageUITable for")
		if PreloadingImageUITable[i] ~= nil then
			Common.log("preloadingImage PreloadingImageUITable for not nil")
			PreloadingImageUITable[i]:setVisible(false)
		end
	end
	for i = 1,#PreloadingImageURLTable do
		Common.log("preloadingImage PreloadingImageURLTable for")
		if PreloadingImageURLTable[i] ~= nil and  PreloadingImageURLTable[i] ~= ""  then
			Common.log("preloadingImage PreloadingImageURLTable for not nil")
			Common.getPicFile(PreloadingImageURLTable[i], i, true, updataPreloadingImageList)
		end
	end
end

--[[--
--打开排行榜
--]]--
function delayAutoShowRankListInfo()
	local array = CCArray:create()
	local delay = CCDelayTime:create(1)
	array:addObject(delay)
	array:addObject(CCCallFunc:create(
		function()
			mvcEngine.createModule(GUI_CRAZY_TOP)
		end
	))
	local seq = CCSequence:create(array)
	if autoShowRankListInfo == true then
		view:runAction(seq)
	end
end

--[[--
-- 计算是否是今天第一次打开闯关赛
--]]--
function getIsTodayFirstPlay()
	local table = Common.LoadTable("CrazyBaseInfoTable")
	local nowTime = os.time()
	if table == nil then
		table = {}
		todayFirstPlay = true
	else
		local oldTime = table.time
		local nowDate = os.date("*t",nowTime)
		local oldDate = os.date("*t",oldTime)
		if nowDate.year == oldDate.year and nowDate.month == oldDate.month and nowDate.day == oldDate.day then
			todayFirstPlay = false
		else
			todayFirstPlay = true
		end
	end
	table.time = nowTime
	Common.SaveTable("CrazyBaseInfoTable",table)
end

--[[--
--盖假楼当loading背景
--]]--
function showBuildingBg()
	ScrollView_Mission:removeAllChildren()
	cellSize = 5
	ScrollView_Mission:setSize(CCSizeMake(viewW, viewH))
	ScrollView_Mission:setInnerContainerSize(CCSizeMake(viewW,cellHeight * cellSize + 40))
	ScrollView_Mission:setPosition(ccp(viewX - 3, viewY + 52))
	for i = 0,cellSize - 1 do
		local layout_fz = ccs.image({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
			image = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		})
		layout_fz:setScale9Enabled(true);
		layout_fz:setAnchorPoint(ccp(0, 0));
		layout_fz:setZOrder(1)
		local layout_fy = ccs.image({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
			image = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		})
		layout_fy:setScale9Enabled(true);
		layout_fy:setAnchorPoint(ccp(0, 0));
		layout_fy:setZOrder(3)
		--房檐
		local imgLeft_Fy = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_cg_cj_fy.png"),
		})
		imgLeft_Fy:setScaleX(524/512)
		local imgRight_Fy = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_cg_cj_fy.png"),
		})
		imgRight_Fy:setScaleX(-524/512)
		--墙
		local imgLeft_Fz = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_cg_cj_fz.png"),
		})
		local imgRight_Fz = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_cg_cj_fz.png"),
		})
		imgRight_Fz:setScaleX(-1)

		SET_POS(imgLeft_Fz,295, 65)
		SET_POS(imgRight_Fz,cellWidth -296, 65)
		SET_POS(imgLeft_Fy,262, 162)
		SET_POS(imgRight_Fy,cellWidth - 262, 162)
		SET_POS(layout_fz,44, cellHeight * (cellSize - i - 1) + 30)
		SET_POS(layout_fy,44, cellHeight * (cellSize - i - 1) + 30)
		layout_fz:addChild(imgLeft_Fz)
		layout_fz:addChild(imgRight_Fz)
		layout_fy:addChild(imgLeft_Fy)
		layout_fy:addChild(imgRight_Fy)
		ScrollView_Mission:addChild(layout_fz)
		ScrollView_Mission:addChild(layout_fy)
	end
	ScrollView_Mission:jumpToPercentVertical(100)
end

--[[--
刷新页面上的数据
--]]
function refreshViewNumber()
	--判断地主是否为失败如果为失败则显示黑白地主
	if profile.CrazyStage.getCrazyBaseInfostatus() == 1 then

		ImageDiZhu = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("cg_dizhu2.png"),
		})
		ImageDiZhu:setScaleX(-0.5)
		ImageDiZhu:setScaleY(0.5)
	else
		ImageDiZhu = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("cg_dizhu1.png"),
		})
		Common.log("dizhubusi");
		ImageDiZhu:setScaleX(-0.5)
		ImageDiZhu:setScaleY(0.5)
	end
	local array = CCArray:create();
	array:addObject(CCRotateBy:create(0.25,15))
	array:addObject(CCRotateBy:create(0.25,-15))
	array:addObject(CCRotateBy:create(0.25,-15))
	array:addObject(CCRotateBy:create(0.25,15))
	local seq = CCRepeatForever:create(CCSequence:create(array));
	if profile.CrazyStage.getCrazyBaseInfostatus() == 1 then
	else
		ImageDiZhu:runAction(seq);
	end
	Label_Relive_count:setText(""..profile.CrazyStage.getCrazyBaseInfofreeReliveCount())
	Label_Relive:setText(CrazyList.ReliveNumber)
	Common.log("initCrazyListView CurrentRank is " .. CrazyList.CurrentRank)
	Label_Rank:setText(CrazyList.CurrentRank)
	Label_Stone:setText(CrazyList.ReliveStoneNumber)
	if canPlayCrazyStage == false then
		if CrazyList["ReliveStoneNumber"] >= CrazyList["NeedStoneNumber"] then
			CrazyResultLogic.setValue(false,false,false,CrazyList["ReliveStoneNumber"],CrazyList["NeedStoneNumber"],CrazyList.CurrentLevel,false,nil)
			mvcEngine.createModule(GUI_CRAZY_RESULT)
		else
			CrazyBuyStoneLogic.setValue(true,nil,CrazyList["ReliveStoneNumber"],CrazyList["NeedStoneNumber"],CrazyList["ReliveRecharge"],CrazyList["ReliveRechargePrice"],CrazyList["ReliveRechargeNum"])
			mvcEngine.createModule(GUI_CRAZY_BUY_STONE)
		end
	end
	afterBuyStone = false
end

--[[--
画出闯关楼层
--]]
function initCrazyListView()
	Common.log("画出闯关楼层=====initCrazyListView");
	ScrollView_Mission:removeAllChildren()
	CrazyImageListTable = {};
	CrazyLabelListTable = {};
	CrazyNowLevelAwardTable = {};
	cellSize = 0--总数
	if CrazyList["AwardList"] == nil or CrazyList["AwardList"] == "" then
		Common.log("initCrazyListView CrazyList[AwardList] is nil")
	else
		Common.log("initCrazyListView CrazyList[AwardList] not nil")
		Label_Relive:setText(CrazyList.ReliveNumber)
		Label_Rank:setText(CrazyList.CurrentRank)
		Label_Stone:setText(CrazyList.ReliveStoneNumber)
		if beforeLevel ~= nil and beforeLevel < CrazyList.CurrentLevel then
			nowLevel = beforeLevel
			Common.log("initCrazyListView nowLevel == beforeLevel " .. beforeLevel)
		else
			nowLevel = CrazyList.CurrentLevel
			Common.log("initCrazyListView nowLevel == CrazyList.CurrentLevel " .. CrazyList.CurrentLevel)
		end

		if nowLevel < (CrazyList["AwardCnt"] - 9) then
			cellSize = MAX_SHOW_LEVEL
		else
			cellSize = CrazyList["AwardCnt"] - nowLevel + 2
		end

	end

	ScrollView_Mission:setSize(CCSizeMake(viewW, viewH))
	ScrollView_Mission:setInnerContainerSize(CCSizeMake(viewW,cellHeight * cellSize + 40))
	ScrollView_Mission:setPosition(ccp(viewX - 3, viewY + 52))

	for i = 0,cellSize - 1 do
		--层数
		local plies = nil
		--奖励种类个数
		local stageAwardCnt = nil
		if nowLevel == 1 then
			plies = nowLevel + cellSize - i - 1
			stageAwardCnt = CrazyList["AwardList"][cellSize - i - 1 + nowLevel].StageAwardCnt
		else
			plies = nowLevel + cellSize - i - 2
			stageAwardCnt = CrazyList["AwardList"][cellSize - i - 2 + nowLevel].StageAwardCnt
		end
		Common.log("plies is " .. plies .. " and stageAwardCnt is " .. stageAwardCnt)
		--底层layer
		local layout_fz = ccs.image({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
			image = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		})
		layout_fz:setScale9Enabled(true);
		layout_fz:setAnchorPoint(ccp(0, 0));
		layout_fz:setZOrder(1)
		local layout_fy = ccs.image({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
			image = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		})
		layout_fy:setScale9Enabled(true);
		layout_fy:setAnchorPoint(ccp(0, 0));
		layout_fy:setZOrder(3)
		--房檐
		local imgLeft_Fy = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_cg_cj_fy.png"),
		})
		imgLeft_Fy:setScaleX(524/512)
		local imgRight_Fy = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_cg_cj_fy.png"),
		})
		imgRight_Fy:setScaleX(-524/512)
		--墙
		local imgLeft_Fz = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_cg_cj_fz.png"),
		})
		local imgRight_Fz = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_cg_cj_fz.png"),
		})
		imgRight_Fz:setScaleX(-1)
		--楼梯
		local imgLeft_Lt = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_cg_cj_lt.png"),
		})
		imgLeft_Lt:setScaleY(155/128)
		local imgRight_Lt = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_cg_cj_lt.png"),
		})
		imgRight_Lt:setScaleX(-1)
		imgRight_Lt:setScaleY(155/128)

		--楼梯栅栏
		local imgLeft_Ltfs = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("bg_cg_cj_ltfs.png"),
		})
		--奖品按钮
		local button = {}
		local buttonLable = {}
		if plies >= CrazyList.CurrentMaxLevel then
			--大于等于当前层,才画奖励按钮
			for j = 1,stageAwardCnt do
				Common.log("for stageAwardCnt " .. j)
				--图片地址
				local Picture = nil
				--奖励数量
				local Count = nil
				--奖励描述
				local description = nil
				--奖励图片短描述
				local shortDes = nil
				--奖励按钮下标
				local index = "" .. 1 .. i .. j

				if nowLevel == 1 then
					Picture = CrazyList["AwardList"][cellSize - i  - 1 + nowLevel]["StageAwardList"][j].url
					Common.log("Picture is " .. Picture)
					Count = CrazyList["AwardList"][cellSize - i  - 1 + nowLevel]["StageAwardList"][j].count
					description = CrazyList["AwardList"][cellSize - i  - 1 + nowLevel]["StageAwardList"][j].description
					shortDes = CrazyList["AwardList"][cellSize - i  - 1 + nowLevel]["StageAwardList"][j].shortDes
				else
					Picture = CrazyList["AwardList"][cellSize - i  - 2 + nowLevel]["StageAwardList"][j].url
					Common.log("Picture is " .. Picture)
					Count = CrazyList["AwardList"][cellSize - i  - 2 + nowLevel]["StageAwardList"][j].count
					description = CrazyList["AwardList"][cellSize - i  - 2 + nowLevel]["StageAwardList"][j].description
					shortDes = CrazyList["AwardList"][cellSize - i  - 2 + nowLevel]["StageAwardList"][j].shortDes
				end

				button[j] = ccs.button({
					scale9 = false,
					pressed = Common.getResourcePath("ic_cg_baoshi.png"),
					normal = Common.getResourcePath("ic_cg_baoshi.png"),
					text = "",
					listener = {
						[ccs.TouchEventType.began] = function(uiwidget)
							button[j]:setScale(1.1)
						end,
						[ccs.TouchEventType.moved] = function(uiwidget)

						end,
						[ccs.TouchEventType.ended] = function(uiwidget)
							button[j]:setScale(1)
							if CrazyList.CurrentLevel == plies and CrazyList.Receivable == 1 then
								sendOPERID_CRAZY_STAGE_RECEIVE_AWARD()
							elseif CrazyList.CurrentLevel == plies then
								--Common.showToast("闯过本关即可领取" .. Count .. "个" .. description, 2)
								if j == 1 then
									Common.showToast("闯过本关即可领取", 2)
								elseif 2 then
									Common.showToast("闯过本关可获得抽奖次数，有机会抽得话费、充值卡！", 2)
								end

							else
								if j == 1 then
									Common.showToast("闯过本关即可领取", 2)
								elseif j == 2 then
									Common.showToast("闯过本关可获得抽奖次数，有机会抽得话费、充值卡！", 2)
								end
							end
							Common.log("OPERID_CRAZY_STAGE_RECEIVE_AWARD " .. index)
						end,
						[ccs.TouchEventType.canceled] = function(uiwidget)
							button[j]:setScale(1)
						end,
					}
				})
				button[j]:setZOrder(5)
				Common.log("getPicFile " .. index )
				local number = tonumber(index)
				Common.log("getPicFile number " .. number )
				CrazyImageListTable[index] = button[j]
				CrazyImageListTable[index]:setVisible(false);
				if nowLevel == 1 then
					if i == cellSize - 1 then
						--将当前奖品存入列表
						CrazyNowLevelAwardTable[j] = index
					end
				else
					if i == cellSize - 2 then
						--将当前奖品存入列表
						CrazyNowLevelAwardTable[j] = index
					end
				end
				if Picture ~= nil and  Picture ~= ""  then
					Common.getPicFile(Picture, number, true, updataCrazyImageList)
				end

				--奖品下方的文字
				buttonLable[j] = ccs.label({
					text = shortDes,
					color = ccc3(225,225,225),
				})
				buttonLable[j]:setFontSize(26)
				buttonLable[j]:setZOrder(6)
				CrazyLabelListTable[index] = buttonLable[j]
			end
		end
		--第几关的关名
		local imgMissionLeft = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_cg_di.png"),
		})

		local labelAtlasMission = ccs.labelAtlas({
			text = plies .. "",
			image = Common.getResourcePath("ico_cg_zrph_num_small.png"),
			start = "0",
			w = 25,
			h = 32,
		})

		local imgMissionRight = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_cg_guan.png"),
		})

		--小地主头像,重置时候使用
		local imgLordHead = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_cg_smalldizhu.png"),
		})

		--底边
		--		local imgBase = nil
		--一楼左右的墙
		local imgLeftThl = nil
		local imgRightThl = nil
		if plies == 1 then
			imgLeftThl = ccs.image({
				scale9 = true,
				image = Common.getResourcePath("bg_cg_cj_lefthl.png"),
			})
			imgLeftThl:setScaleX(132/128)
			imgRightThl = ccs.image({
				scale9 = true,
				image = Common.getResourcePath("bg_cg_cj_lefthl.png"),
			})
			imgRightThl:setScaleX(-1)
			imgRightThl:setScaleX(132/128)
		end

		local imgFirstFloorText = ccs.image({
			scale9 = true,
			image = Common.getResourcePath("ic_cg_hua.png"),
		})

		--		local imgSecondFloorText = ccs.image({
		--			scale9 = true,
		--			image = Common.getResourcePath("ic_cg_hua2.png"),
		--		})

		--顶层画云
		local imgCloud = nil
		if i == 0 then
			imgCloud = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("cg_cloud2.png"),
			})
			imgCloud:setScale(1136/512)
			imgCloud:setScaleY(-1136/256)
		end

		SET_POS(imgLeft_Fz,295, 65)
		SET_POS(imgRight_Fz,cellWidth -296, 65)
		SET_POS(imgLeft_Fy,262, 162)
		SET_POS(imgRight_Fy,cellWidth - 262, 162)
		if plies % 2 == 0 then
			SET_POS(imgRight_Lt,350, 45)
		else
			SET_POS(imgLeft_Lt,350, 45)
		end
		SET_POS(imgLeft_Ltfs,230, 0)
		SET_POS(imgMissionLeft,cellWidth / 2 - 38, 148)
		SET_POS(labelAtlasMission,cellWidth / 2, 148)
		SET_POS(imgMissionRight,cellWidth / 2 + 38, 148)
		SET_POS(imgLordHead,cellWidth / 2, 148)
		if plies == 1 then
			--			SET_POS(imgBase,518,0)
			SET_POS(imgLeftThl,10,40)
			SET_POS(imgRightThl,cellWidth - 23,40)
		end
		SET_POS(imgFirstFloorText,650,80)
		--		SET_POS(imgSecondFloorText,635,80)
		for j = 1,#button do
			Common.log("SET_POS button " .. j)
			SET_POS(button[j],j * 150 + 518,40)
			SET_POS(buttonLable[j],j * 150 + 518,-10)
		end
		if imgCloud ~= nil then
			SET_POS(imgCloud,cellWidth / 2 + 5,cellHeight)
		end
		SET_POS(layout_fz,44, cellHeight * (cellSize - i - 1) + 30)
		SET_POS(layout_fy,44, cellHeight * (cellSize - i - 1) + 30)
		layout_fz:addChild(imgLeft_Fz)
		layout_fz:addChild(imgRight_Fz)
		if plies % 2 == 0 then
			layout_fz:addChild(imgRight_Lt)
		else
			layout_fz:addChild(imgLeft_Lt)
			layout_fz:addChild(imgLeft_Ltfs)
		end
		if plies == 1 then
			layout_fz:addChild(imgLeftThl)
			layout_fz:addChild(imgRightThl)
			layout_fz:addChild(imgFirstFloorText)
		end
		--		if plies == 2 then
		--			layout_fz:addChild(imgSecondFloorText)
		--		end
		layout_fy:addChild(imgLeft_Fy)
		layout_fy:addChild(imgRight_Fy)
		if CrazyList.CurrentMaxLevel ~= CrazyList.CurrentLevel and plies == CrazyList.CurrentMaxLevel then
			layout_fy:addChild(imgLordHead)
		else
			layout_fy:addChild(imgMissionLeft)
			layout_fy:addChild(labelAtlasMission)
			layout_fy:addChild(imgMissionRight)
		end
		if plies >= CrazyList.CurrentMaxLevel then
			for j = 1,#button do
				Common.log("addChild button " .. j)
				layout_fy:addChild(button[j])
				layout_fy:addChild(buttonLable[j])
			end
		end
		if imgCloud ~= nil and cellSize > MAX_SHOW_LEVEL - 1 then
			--如果看不到最高层时候,才显示云
			layout_fy:addChild(imgCloud)
		end
		ScrollView_Mission:addChild(layout_fz)
		ScrollView_Mission:addChild(layout_fy)
	end

	--判断地主是否为失败如果为失败则显示黑白地主
	if profile.CrazyStage.getCrazyBaseInfostatus() == 1 then

		ImageDiZhu = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("cg_dizhu2.png"),
		})
		ImageDiZhu:setScaleX(-0.5)
		ImageDiZhu:setScaleY(0.5)
	else
		ImageDiZhu = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("cg_dizhu1.png"),
		})
		Common.log("dizhubusi");
		ImageDiZhu:setScaleX(-0.5)
		ImageDiZhu:setScaleY(0.5)
	end
	ButtonDiZhu = ccs.button({
		scale9 = true,
		size = CCSizeMake(ImageDiZhu:getSize().width,ImageDiZhu:getSize().height),
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
				--点击按钮
				GameConfig.setTheLastBaseLayer(GUI_CHUANGGUAN)
				mvcEngine.createModule(GUI_USERINFO)
			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
			end,
		}
	})

	ImageDiZhu:setZOrder(2)
	ButtonDiZhu:setZOrder(3)
	if nowLevel == 1 then
		SET_POS(ImageDiZhu,300, 10)
		SET_POS(ButtonDiZhu,300, 10)
	else
		Common.log("nowLevel is " .. nowLevel)
		if (nowLevel) % 2 == 0 then
			ImageDiZhu:setScaleX(0.5)
			ImageDiZhu:setScaleY(0.5)
			SET_POS(ImageDiZhu,470, 231)
			SET_POS(ButtonDiZhu,470, 231)
		else
			SET_POS(ImageDiZhu,300, 231)
			SET_POS(ButtonDiZhu,300, 231)
		end
		Common.log("11 nowLevel is " .. nowLevel .. ";AwardCnt is " .. CrazyList["AwardCnt"])
		if nowLevel >= CrazyList["AwardCnt"] then
			SET_POS(ImageDiZhu,300, 10)
			SET_POS(ButtonDiZhu,300, 10)
		end
	end
	ImageDiZhu:setAnchorPoint(ccp(0.5, 0))
	ButtonDiZhu:setAnchorPoint(ccp(0.5, 0))
	local array = CCArray:create();
	array:addObject(CCRotateBy:create(0.25,15))
	array:addObject(CCRotateBy:create(0.25,-15))
	array:addObject(CCRotateBy:create(0.25,-15))
	array:addObject(CCRotateBy:create(0.25,15))
	local seq = CCRepeatForever:create(CCSequence:create(array));
	if profile.CrazyStage.getCrazyBaseInfostatus() == 1 then
	else
		ImageDiZhu:runAction(seq);
	end
	Common.closeProgressDialog()
	ScrollView_Mission:addChild(ImageDiZhu)
	ScrollView_Mission:addChild(ButtonDiZhu)
	setOrigin()
end

--[[--
-- 设置镜头与地主开始位置
--]]--
function setOrigin()
	--判断是否显示抽奖按钮
	if CrazyList.showLottery == 0 then
		Button_LuckyTurn:setVisible(false)
		Button_LuckyTurn:setTouchEnabled(false)
	else
		Button_LuckyTurn:setVisible(true)
		Button_LuckyTurn:setTouchEnabled(true)
	end
	local isFirstOpenCrazyStage = profile.CrazyStage.getIsFirstOpenCrazyStage()

	if isFirstOpenCrazyStage ~= nil and isFirstOpenCrazyStage == true then
		profile.CrazyStage.setIsFirstOpenCrazyStage(false)
		--如果是第一次进入闯关赛的话,播放展示动画
		local function jumpToUp()
			ScrollView_Mission:scrollToTop(3,true)
		end

		local function jumpToBottom()
			ScrollView_Mission:scrollToBottom(3,true)
		end

		local function openHelp()
			mvcEngine.createModule(GUI_CRAZY_RULE)
			CrazyRuleLogic.setRule(CrazyList.Rule)
		end
		ScrollView_Mission:jumpToPercentVertical(100)
		local array = CCArray:create()
		array:addObject(CCCallFuncN:create(jumpToUp))
		array:addObject(CCDelayTime:create(3))
		array:addObject(CCCallFuncN:create(jumpToBottom))
		array:addObject(CCDelayTime:create(3))
		array:addObject(CCCallFuncN:create(openHelp))
		local seq = CCSequence:create(array)
		view:runAction(seq);
	else
		--不是第一次进闯关赛的话,直接设置镜头位置
		if nowLevel == 1 or nowLevel == CrazyList["AwardCnt"] then
			ScrollView_Mission:jumpToPercentVertical(100)
		else
			ScrollView_Mission:jumpToPercentVertical(100/cellSize * (cellSize - 1))
		end
		if beforeLevel ~= nil then
			if beforeLevel < CrazyList.CurrentLevel then
				upstairsCartoon(beforeLevel)
			end
		end
	end

	--	--如果可以领奖,设置奖品动画
	--	if CrazyList.Receivable == 1 then
	--		Common.log("Receivable 111111111111")
	--		--如果能领奖,播放奖品动画
	--		for i = 1,#CrazyNowLevelAwardTable do
	--			Common.log("Receivable " .. i)
	--			LordGamePub.showShakeAnimate(CrazyNowLevelAwardTable[i])
	--		end
	--	end

	--如果是第一关则显示开始闯关,否则显示下一关
	if CrazyList.CurrentLevel ~= 1 then
--		Button_Begin:loadTextures(Common.getResourcePath("btn_cg_xiayiguan.png"),Common.getResourcePath("btn_cg_xiayiguan.png"),"")
		Image_begin:loadTexture(Common.getResourcePath("btn_cg_xiayiguan.png"))
	else
--		Button_Begin:loadTextures(Common.getResourcePath("btn_cg_kscg.png"),Common.getResourcePath("btn_cg_kscg.png"),"")
		Image_begin:loadTexture(Common.getResourcePath("btn_cg_kscg.png"))
	end
	LordGamePub.breathEffect(Button_Begin)

	if profile.CrazyStage.getHasNewLuckyTurnChance() == true then
		Common.log("getHasNewLuckyTurnChance is true")
		if Button_LuckyTurn:isVisible() == true then
			Common.log("Button_LuckyTurn:isVisible() is true")
			Button_LuckyTurn:removeAllChildren()
			createPoint()
			Button_LuckyTurn:addChild(point)
		end
	end
end

--[[--
闯关信息加载
--]]
function showCrazyList()

	--读取复活机会
	if profile.CrazyStage.getCrazyBaseInfofreeReliveCount() ~= nil then
		Label_Relive_count:setText(""..profile.CrazyStage.getCrazyBaseInfofreeReliveCount())
	end
	CrazyList = profile.CrazyStage.getCrazyBaseInfo()
	if afterBuyStone == false then
		if profile.CrazyStage.getCrazyBaseInfofreeReliveCount() > 0 or CrazyList["ReliveStoneNumber"] >= CrazyList["NeedStoneNumber"] then
			canPlayCrazyStage = true
		end
		initCrazyListView()
	else
		refreshViewNumber()
	end
	delayAutoShowRankListInfo()
	initYesterdayAwards()
end

--[[--
-- 初始化昨日奖励信息数据
-- 判断是否需要发送获取昨日奖励数据消息
--]]--
function initYesterdayAwards()
	local CrazyStageTimeTable = Common.LoadTable("CrazyStageTimeTable")
	local oldTimeStamp = nil
	if CrazyStageTimeTable == nil then
		oldTimeStamp = 0
		CrazyStageTimeTable = {}
		CrazyStageTimeTable["" .. profile.User.getSelfUserID()] = CrazyList.TimeStamp / 1000
	else
		for k,v in pairs(CrazyStageTimeTable) do
			if k == "" .. profile.User.getSelfUserID() then
				oldTimeStamp = v
				CrazyStageTimeTable[k] = CrazyList.TimeStamp / 1000
			end
		end
		if oldTimeStamp == nil then
			oldTimeStamp = 0
			CrazyStageTimeTable["" .. profile.User.getSelfUserID()] = CrazyList.TimeStamp / 1000
		end
	end
	Common.SaveTable("CrazyStageTimeTable", CrazyStageTimeTable)
	if oldTimeStamp == nil or oldTimeStamp == 0 then
		sendOPERID_CRAZY_STAGE_YESTERDAY_AWARDS()
	else
		local newTimeStamp = CrazyList.TimeStamp / 1000
		local newDate = os.date("*t",newTimeStamp)
		local oldDate = os.date("*t",oldTimeStamp)
		if newTimeStamp - oldTimeStamp >=  24 * 60 * 60 and newDate.hour > 5 then
			sendOPERID_CRAZY_STAGE_YESTERDAY_AWARDS()
		elseif newTimeStamp > oldTimeStamp then
			if oldDate.day == newDate.day then
				if oldDate.hour > 5 then
					return
				end
				if newDate.hour < 5 then
					return
				end
				sendOPERID_CRAZY_STAGE_YESTERDAY_AWARDS()
			else
				if newDate.hour > 5 then
					sendOPERID_CRAZY_STAGE_YESTERDAY_AWARDS()
				end
			end
		end
	end

end

--[[--
--重置消息回来后的处理
--]]--
function resetInfo()
	local resetTable = profile.CrazyStage.getCrazyStageReset()
	if resetTable ~= nil then
		if resetTable["Success"] == 1 then
			sendOPERID_CRAZY_STAGE_BASE_INFO()
			setBeforeLevel(1)
			Common.showToast("重置成功",2)
			--			beforeLevel = 1
		else
			Common.showToast(resetTable["Message"],2)
		end
	end
end

--[[--
-- 昨日奖励信息消息处理
--]]--
function readYesterdayAwards()
	local yesterdayTable = profile.CrazyStage.getCrazyStageYesterdatAwardsTable()
	if yesterdayTable.AwardsContent ~= nil and yesterdayTable.AwardsContent ~= "" then
		mvcEngine.createModule(GUI_CRAZY_RULE)
		CrazyRuleLogic.setAwardsInfo(yesterdayTable.AwardsContent)
	end
end

local CRAZY_RELIVE_SUCCESS = 1;--复活成功
local CRAZY_RELIVE_FAIL = 0;--复活失败

--[[--
--复活消息回来后的处理
--]]--
function readRelive()
	Common.closeProgressDialog()
	local reliveTable = profile.CrazyStage.getCrazyStageRelive()
	if reliveTable ~= nil then
		if reliveTable["ReliveSuccess"] == CRAZY_RELIVE_SUCCESS then
			Common.showToast("复活成功！您可以继续闯关了，加油！",2)
			afterBuyStone = true
			sendOPERID_CRAZY_STAGE_BASE_INFO()
			Common.showProgressDialog("数据加载中,请稍后...")
			sendOPERID_CRAZY_STAGE_BEGIN()
		else
			Common.showToast(reliveTable["Message"],2)
		end
	end
end
--[[--
--支付推送消息回来后的处理
--]]--
function readRechargeResult()
	Common.log("readRechargeResult")
	local rechargeResultTable = profile.RechargeResult.getRechargeResultTable()
	if rechargeResultTable ~= nil then
		Common.log("readRechargeResult rechargeID is " .. rechargeResultTable["rechargeID"])
		if rechargeResultTable["rechargeID"] ~= nil and rechargeResultTable["rechargeID"] ~= "" then
			if CrazyList["ReliveRecharge"] == rechargeResultTable["rechargeID"]
				or CrazyList["ReliveStroneRecharge"] == rechargeResultTable["rechargeID"] then
				--发送复活消息
				Common.showToast("购买复活石成功",2)
				if CrazyBuyStoneLogic.isShow == true then
					mvcEngine.destroyModule(GUI_CRAZY_BUY_STONE)
				end
				afterBuyStone = true
				sendOPERID_CRAZY_STAGE_BASE_INFO()
			end
		end
	end
end

--[[--
--领奖结果处理
--]]--
function readReceiveResult()
	local receiveResultTable = profile.CrazyStage.getCrazyStageReceiveAward()
	if receiveResultTable ~= nil then
		if receiveResultTable["Success"] == 1 then
			--闯关分享
			--			CommShareConfig.showCrazySharePanel(CrazyList.CurrentLevel)
			local cellSize = 0
			if CrazyList.CurrentLevel < (CrazyList["AwardCnt"] - 9) then
				cellSize = MAX_SHOW_LEVEL
			else
				cellSize = CrazyList["AwardCnt"] - nowLevel + 2
			end
			for i = 1,CrazyList["AwardList"][CrazyList.CurrentLevel].StageAwardCnt do
				Common.log("readReceiveResult " .. CrazyList["AwardList"][CrazyList.CurrentLevel]["StageAwardList"][i].url)
				--领奖动画
				ImageToast.createView(CrazyList["AwardList"][CrazyList.CurrentLevel]["StageAwardList"][i].url, nil, "x" .. CrazyList["AwardList"][CrazyList.CurrentLevel]["StageAwardList"][i].count, CrazyList["AwardList"][CrazyList.CurrentLevel]["StageAwardList"][i].description, 2)
				if nowLevel == 1 then
					CrazyImageListTable["".. 1 .. (cellSize - 1) .. i]:setVisible(false);
					CrazyImageListTable["".. 1 .. (cellSize - 1) .. i]:stopAllActions();
					CrazyLabelListTable["".. 1 .. (cellSize - 1) .. i]:setVisible(false);
				else
					CrazyImageListTable["".. 1 .. (cellSize - 2) .. i]:setVisible(false);
					CrazyImageListTable["".. 1 .. (cellSize - 2) .. i]:stopAllActions();
					CrazyLabelListTable["".. 1 .. (cellSize - 2) .. i]:setVisible(false);
				end

				if CrazyList["AwardList"][CrazyList.CurrentLevel]["StageAwardList"][i].awardID ~= nil and CrazyList["AwardList"][CrazyList.CurrentLevel]["StageAwardList"][i].awardID == luckyTurnAwardID then
					profile.CrazyStage.setHasNewLuckyTurnChance(true)
					if Button_LuckyTurn:isVisible() == true then
						Button_LuckyTurn:removeAllChildren()
						createPoint()
						Button_LuckyTurn:addChild(point)
					end
				end
			end
			local function callMethod()
				--地主上楼动画
				upstairsCartoon(nowLevel)
			end
			lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(callMethod,CrazyList["AwardList"][CrazyList.CurrentLevel].StageAwardCnt * 2,false)

		else
			Common.log("领奖失败")
		end
	end
end

local CRAZY_BEGIN_SUCCESS = 1;--疯狂闯关可以开始
local CRAZY_NEED_COIN = 2;--疯狂闯关金币不足
local CRAZY_NEED_RELIVE = 3;--疯狂闯关需要复活
local CRAZY_NEED_RECEIVE = 4;--疯狂闯关需要领奖
local CRAZY_FINISHED = 5;--疯狂闯关通关
local CRAZY_RELIVE_LIMITED = 6;--复活次数已经到达极限
local CRAZY_OTHER_RESULT = 7;--其他原因
function gameBegin()
	local beginTable = profile.CrazyStage.getCrazyStageBegin()
	if beginTable ~= nil then
		if beginTable.Success == CRAZY_BEGIN_SUCCESS then
			setBeforeLevel(CrazyList.CurrentLevel)
			TableConsole.isCrazyStage = true
			TableConsole.canPlayCrazy = true
			TableConsole.crazyMission = CrazyList.CurrentLevel
		elseif  beginTable.Success == CRAZY_NEED_COIN then
			--金币充值引导
			Common.closeProgressDialog()
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, beginTable.NeedCoin, RechargeGuidePositionID.ReliveStoneB)
			GameConfig.setTheLastBaseLayer(GUI_CHUANGGUAN)
			Common.showToast(beginTable.Message,2)
		elseif beginTable.Success == CRAZY_NEED_RELIVE	then
			--需要复活
			--闯关失败
			Common.closeProgressDialog()
			GameConfig.setTheLastBaseLayer(GUI_CHUANGGUAN)
			if  profile.CrazyStage.getCrazyBaseInfofreeReliveCount() > 0 or CrazyList["ReliveStoneNumber"] >= CrazyList["NeedStoneNumber"] then
				CrazyResultLogic.setValue(false,false,false,CrazyList["ReliveStoneNumber"],CrazyList["NeedStoneNumber"],CrazyList.CurrentLevel,false,nil)
				mvcEngine.createModule(GUI_CRAZY_RESULT)
			else
				CrazyBuyStoneLogic.setValue(true,nil,CrazyList["ReliveStoneNumber"],CrazyList["NeedStoneNumber"],CrazyList["ReliveRecharge"],CrazyList["ReliveRechargePrice"],CrazyList["ReliveRechargeNum"])
				mvcEngine.createModule(GUI_CRAZY_BUY_STONE)
			end
		elseif beginTable.Success == CRAZY_NEED_RECEIVE then
			--需要领奖
			Common.closeProgressDialog()
			Common.showToast("请您领取本关奖励后继续！",2)
		elseif beginTable.Success == CRAZY_FINISHED then
			--已经通关
			Common.closeProgressDialog()
			Common.showToast("太棒了!恭喜您已经通关!",2)
		elseif beginTable.Success == CRAZY_RELIVE_LIMITED then
			--复活次数已达上限
			Common.closeProgressDialog()
			CrazyResultLogic.setValue(false,false,false,CrazyList["ReliveStoneNumber"],CrazyList["NeedStoneNumber"],CrazyList.CurrentLevel,true,nil)
			mvcEngine.createModule(GUI_CRAZY_RESULT)
		elseif beginTable.Success == CRAZY_OTHER_RESULT then
			--其他原因
			Common.closeProgressDialog()
			Common.showToast(beginTable.Message,2)
		end
	end
end

--设置闯关前的关卡数
function setBeforeLevel(level)
	beforeLevel = level
end

--[[--
执行地主上楼动画
--]]
function upstairsCartoon(Level)
	if lookTimer ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
	end
	if Level >= CrazyList.MaxLevel then
		Common.showToast("恭喜您已经通关",2)
		return
	end
	local function comsucessmsg()
		--楼层上移
		if Level ~= 1 then
			ScrollView_Mission:jumpToPercentVertical(100/(cellSize) * (cellSize - 2))
		end
		ButtonDiZhu:setPosition(ImageDiZhu:getPosition())

		--如果不是第一次触发获取抽奖机会并且是第三层领奖,则直接自动开始闯关,否则播放抽奖按钮轨迹动画
		if CrazyList.showLottery == 0 and CrazyList.CurrentLevel == 3 then
			--播放抽奖按钮动画
			local function luckyTurnCallBack()
				Button_LuckyTurn:removeAllChildren()
				createPoint()
				Button_LuckyTurn:addChild(point)
			end
			local luckyTurnPos = Button_LuckyTurn:getPosition()
			Button_LuckyTurn:setPosition(ccp(luckyTurnPosX / 2,0))
			Button_LuckyTurn:setVisible(true)
			Button_LuckyTurn:setTouchEnabled(true)
			local moveTo = CCMoveTo:create(2,ccp(luckyTurnPosX / 2,luckyTurnPosY / 2))
			local moveTo2 = CCMoveTo:create(1,ccp(43,luckyTurnPosY))
			local ActionArray = CCArray:create()
			ActionArray:addObject(moveTo)
			ActionArray:addObject(moveTo2)
			ActionArray:addObject(CCCallFuncN:create(luckyTurnCallBack))
			Button_LuckyTurn:runAction(CCSequence:create(ActionArray))
		else
			--开始闯关
			Common.showProgressDialog("数据加载中,请稍后...")
			sendOPERID_CRAZY_STAGE_BEGIN()
		end
		if CrazyList.CurrentLevel == beforeLevel then
			CrazyList.CurrentLevel = CrazyList.CurrentLevel + 1
		end
		beforeLevel = CrazyList.CurrentLevel
		CrazyList.Receivable = 0
	end
	if Level % 2 == 0 then
		local array = CCArray:create();
		array:addObject(CCMoveTo:create(1,ccp(ImageDiZhu:getPosition().x - 240,ImageDiZhu:getPosition().y + 221)))
		array:addObject(CCCallFuncN:create(comsucessmsg))
		local seq = CCSequence:create(array);
		ImageDiZhu:runAction(seq);
	else
		local array = CCArray:create();
		array:addObject(CCMoveTo:create(1,ccp(ImageDiZhu:getPosition().x + 240,ImageDiZhu:getPosition().y + 221)))
		array:addObject(CCCallFuncN:create(comsucessmsg))
		local seq = CCSequence:create(array);
		ImageDiZhu:runAction(seq);
	end
end

--[[--
--播放走马灯信息
--]]--
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

function requestMsg()

end

function callback_Button_Begin(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if CrazyList["AwardCnt"] == nil or CrazyList["AwardCnt"] == "" then
		--做保底方案
			return
		end
		Common.log("nowLevel is " .. nowLevel .. ";AwardCnt is " .. CrazyList["AwardCnt"])
		if nowLevel >= CrazyList["AwardCnt"] then
			Common.showToast("您已经通关啦",2)
			return
		end
		GameConfig.setTheLastBaseLayer(GUI_CHUANGGUAN)
		Common.showProgressDialog("数据加载中,请稍后...")
		sendOPERID_CRAZY_STAGE_BEGIN()

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Help(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_CRAZY_RULE)
		CrazyRuleLogic.setRule(CrazyList.Rule)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_LuckyTurn(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_CHUANGGUAN)
		profile.CrazyStage.setHasNewLuckyTurnChance(false)
		mvcEngine.createModule(GUI_LUCKY_TURNTABLE)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Back(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		beforeLevel = CrazyList.CurrentLevel
		LordGamePub.showBaseLayerAction(view)
		--	mvcEngine.createModule(GUI_CRAZY_TOP)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Top(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_CRAZY_TOP)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Buy(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if CrazyList == nil or CrazyList["ReliveStoneNumber"] == nil then
			return
		end
		CrazyBuyStoneLogic.setValue(false,false,CrazyList["ReliveStoneNumber"],CrazyList["NeedStoneNumber"],CrazyList["ReliveStroneRecharge"],CrazyList["ReliveStroneRechartgePrice"], CrazyList["ReliveStroneRechargeNum"])
		mvcEngine.createModule(GUI_CRAZY_BUY_STONE)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Refresh(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--		CrazyResultLogic.setValue(false,false,CrazyList["ReliveStoneNumber"],CrazyList["NeedStoneNumber"],CrazyList.CurrentLevel,true)
		--			mvcEngine.createModule(GUI_CRAZY_RESULT)
		mvcEngine.createModule(GUI_CRAZY_RESET_ALERT)
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()
	if lookTimer ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
	end

	point = nil
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_BASE_INFO,showCrazyList)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_BEGIN,gameBegin)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_RESET,resetInfo)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_RELIVE,readRelive)
	framework.addSlot2Signal(DBID_RECHARGE_RESULT_NOTIFICATION, readRechargeResult)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_RECEIVE_AWARD, readReceiveResult)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_YESTERDAY_AWARDS, readYesterdayAwards)
	framework.addSlot2Signal(OPERID_ACTIVITY_MARQUEE, getMarqueeText);
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_BASE_INFO,showCrazyList)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_BEGIN,gameBegin)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_RESET,resetInfo)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_RELIVE,readRelive)
	framework.removeSlotFromSignal(DBID_RECHARGE_RESULT_NOTIFICATION, readRechargeResult)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_RECEIVE_AWARD, readReceiveResult)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_YESTERDAY_AWARDS, readYesterdayAwards)
	framework.removeSlotFromSignal(OPERID_ACTIVITY_MARQUEE, getMarqueeText);
end
