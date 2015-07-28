module("CrazyTopLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Button_Close = nil;--
ScrollView_Top = nil;--
Button_jinri = nil;--
Image__jinri = nil;--
Button_zuori = nil;--
Image_zuori = nil;--
CrazyTopList = {} --闯关排行榜
CrazyTopImageListTable = {} --闯关排行头像列表
CrazyTopAwardImageListTable = {} --闯关排行奖品图片列表

local TODAYDATA = 1 --今日排行榜数据
local YESTERDAYDATA = 2 --昨日排行榜数据


local viewX = 0--左右间隔
local viewY = 0 --y位置
local viewW = 1000   --宽度
local viewH = 525--高度
local cellWidth = 1000 --每个元素的宽
local cellHeight = 80 --每个元素的高
local spacingH = 5 --横向间隔
local size = nil --尺寸

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		close()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--更新头像图片
]]
local function updataCrazyTopAvatarImageList(path)
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
	Common.log("updataCrazyTopAvatarImageList id is " .. id)
	if photoPath ~= nil and photoPath ~= "" and CrazyTopImageListTable[""..id] ~= nil then
		Common.log("updataCrazyTopAvatarImageList not nil")
		CrazyTopImageListTable[""..id]:loadTexture(photoPath);
		CrazyTopImageListTable[""..id]:setScale(0.8);
	end
end

--[[--
--更新奖励图片
]]
local function updataCrazyTopAwardImageList(path)
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
	Common.log("updataCrazyTopAvatarImageList id is " .. id)
	if photoPath ~= nil and photoPath ~= "" and CrazyTopAwardImageListTable[""..id] ~= nil then
		Common.log("updataCrazyTopAvatarImageList not nil")
		CrazyTopAwardImageListTable[""..id]:loadTexture(photoPath);
		CrazyTopAwardImageListTable[""..id]:setScale(0.8);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Button_Close = cocostudio.getUIButton(view, "Button_Close");
	ScrollView_Top = cocostudio.getUIScrollView(view, "ScrollView_Top");
	Button_jinri = cocostudio.getUIImageView(view, "Button_jinri");
	Image__jinri = cocostudio.getUIImageView(view, "Image__jinri");
	Button_zuori = cocostudio.getUIImageView(view, "Button_zuori");
	Image_zuori = cocostudio.getUIImageView(view, "Image_zuori");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("CrazyTop.json")
	local gui = GUI_CRAZY_TOP
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
	size = CCDirector:sharedDirector():getWinSize()
	view:setAnchorPoint(ccp(0, 0))
	view:setPosition(size.width * -1,0)
	GameStartConfig.addChildForScene(view)

	initView();
	Common.showProgressDialog("数据加载中,请稍后...")
	local array = CCArray:create()
	array:addObject(CCMoveTo:create(0.3,ccp(0,0)))
	array:addObject(CCDelayTime:create(0.3))
	array:addObject(CCCallFunc:create(showTodayData))
	local seq = CCSequence:create(array)
	view:runAction(seq);
	setShowData(TODAYDATA)
end

--[[--
--显示今日排行榜数据
--]]
function showTodayData()
	Common.hideWebView()
	Common.showProgressDialog("数据加载中,请稍后...")
	CrazyTopList =  profile.CrazyStage.getCrazyStageRankTodayInfo()
	if CrazyTopList == nil or CrazyTopList == "" then
		sendOPERID_CRAZY_STAGE_TODAY_RANK()
	elseif judgeTodayDataByServer() then
		sendOPERID_CRAZY_STAGE_TODAY_RANK()
	else
		Common.log("showTodayData==========")
		initCrazyTopListView()
	end

end

--[[--
--显示昨日排行榜数据
--]]
function showYesterdayData()
	Common.hideWebView()
	Common.showProgressDialog("数据加载中,请稍后...")
	local time = profile.CrazyStage.getCrazyRankTimeStamp()
	if time ~= nil then
		sendOPERID_CRAZY_STAGE_RANK(time)
	else
		sendOPERID_CRAZY_STAGE_RANK(0)
	end
end

--[[--
--判断今日排行榜数据是否需要请求
--]]
function judgeTodayDataByServer()
	local timeStamp = Common.getDataForSqlite(profile.CrazyStage.DATAUPDATETIME)
	local nowStamp = Common.getServerTime()
	if timeStamp == nil or timeStamp == "" then
		Common.setDataForSqlite(profile.CrazyStage.DATAUPDATETIME, nowStamp);
		profile.CrazyStage.isLoadCrazyStageTodayInfoByServer = true --首次加载今日排行榜数据，设置为true
		return true
	else
		nowStamp = tonumber(nowStamp);
		timeStamp = tonumber(timeStamp);
		if (nowStamp - timeStamp) / (300) > 1 then
			profile.CrazyStage.isLoadCrazyStageTodayInfoByServer = true --达到5分钟间隔，向服务器请求今日排行榜数据
			return true
		end
	end
	return false
end

--[[--
--选择排行榜展示的数据
--]]
function setShowData(state)
	--今日排行榜数据
	if state == TODAYDATA then
		Button_jinri:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		Image__jinri:loadTexture(Common.getResourcePath("ui_chuangguan_btn_jinripaihang2.png"))
		Button_zuori:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		Image_zuori:loadTexture(Common.getResourcePath("ui_chuangguan_btn_zuoripaihang1.png"))

	--昨日排行榜数据
	elseif state == YESTERDAYDATA then
		Button_jinri:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		Image__jinri:loadTexture(Common.getResourcePath("ui_chuangguan_btn_jinripaihang1.png"))
		Button_zuori:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		Image_zuori:loadTexture(Common.getResourcePath("ui_chuangguan_btn_zuoripaihang2.png"))
	end
end

function requestMsg()

end

function callback_Button_Close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_jinri(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		setShowData(TODAYDATA)
		showTodayData()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_zuori(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		setShowData(YESTERDAYDATA)
		showYesterdayData()
	elseif component == CANCEL_UP then
	--取消

	end
end


function close()
	local function callBack()
		mvcEngine.destroyModule(GUI_CRAZY_TOP)
	end
	ScrollView_Top:removeAllChildren()
	local array = CCArray:create()
	array:addObject(CCMoveTo:create(0.3,ccp(size.width * -1,0)))
	array:addObject(CCDelayTime:create(0.3))
	array:addObject(CCCallFunc:create(callBack))
	local seq = CCSequence:create(array)
	view:runAction(seq);

end

--[[--
画出排行榜
--]]
function initCrazyTopListView()
	Common.log("画出排行榜=====initCrazyTopListView");
	ScrollView_Top:removeAllChildren()
	CrazyTopImageListTable = {}
	CrazyTopAwardImageListTable = {}
	local cellSize = 0--总数
	if CrazyTopList == nil or CrazyTopList == "" then
		return
	end
	if CrazyTopList["TopList"] == nil or CrazyTopList["TopList"] == "" then

	else
		cellSize = CrazyTopList.TopCnt
		Common.log("cellSize======="..cellSize)
	end
	ScrollView_Top:setSize(CCSizeMake(viewW, viewH))
	ScrollView_Top:setInnerContainerSize(CCSizeMake(viewW,cellHeight * cellSize + (cellSize - 1) * spacingH))
	ScrollView_Top:setPosition(ccp(viewX + 30, viewY + 25))

	for i = 1, cellSize do
		--用户头像地址
		local avatarUrl = CrazyTopList["TopList"][i].userPic
		--VIP等级
		local vipLevel = CrazyTopList["TopList"][i].vip
		--用户名称
		local userName = CrazyTopList["TopList"][i].userName
		Common.log("userName========"..userName)
		--关卡数
		local mission = CrazyTopList["TopList"][i].score
		if mission < 10 then
			mission = "0" .. mission
		end
		--奖励图片
		local awardUrl = CrazyTopList["TopList"][i].url
		--奖励信息
		local awardText = CrazyTopList["TopList"][i].award
		--底层layer
		local layout = nil

			layout = ccs.image({
				scale9 = true,
				size = CCSizeMake(cellWidth, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
				image = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			})

		layout:setScale9Enabled(true);
		layout:setAnchorPoint(ccp(0, 0));

		--奖杯图片和文字 前三名是奖杯,后面是文字
		local cupUrl = ""
		if i == 1 then
			cupUrl = "ic_paihangbang_num1.png"
		elseif i == 2 then
			cupUrl = "ic_paihangbang_num2.png"
		elseif i == 3 then
			cupUrl = "ic_paihangbang_num3.png"
		end

		local imgCup = ccs.image({
			scale9 = false,
			image = Common.getResourcePath(cupUrl),
		})
		imgCup:setAnchorPoint(ccp(0, 0));

		local labelCup = ccs.label({
			text = "No." .. i,
			color = ccc3(249,235,219),
		})
		labelCup:setFontSize(26)
		labelCup:setAnchorPoint(ccp(0, 0));

		--玩家头像
		local imgUserAvatar = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("hall_portrait_default.png"),
		})
		imgUserAvatar:setAnchorPoint(ccp(0, 0));

		CrazyTopImageListTable["" .. i] = imgUserAvatar
		CrazyTopImageListTable["" .. i]:setVisible(true);
		if avatarUrl ~= nil and  avatarUrl ~= ""  then
			Common.getPicFile(avatarUrl, i, true, updataCrazyTopAvatarImageList)
		end
		local imgInfoBg = nil
		--黑条背景
		if i == 1 then
			imgInfoBg = ccs.image({
				scale9 = false,
				size = CCSizeMake(cellWidth - 50, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
				image = Common.getResourcePath("gold.png"),
			})
			imgInfoBg:setScale9Enabled(true);
			imgInfoBg:setAnchorPoint(ccp(0, 0));
		elseif i == 2 then
			imgInfoBg = ccs.image({
				scale9 = false,
				size = CCSizeMake(cellWidth - 50, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
				image = Common.getResourcePath("silver.png"),
			})
			imgInfoBg:setScale9Enabled(true);
			imgInfoBg:setAnchorPoint(ccp(0, 0));
		elseif i == 3 then
			imgInfoBg = ccs.image({
				scale9 = false,
				size = CCSizeMake(cellWidth - 50, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
				image = Common.getResourcePath("copper.png"),
			})
			imgInfoBg:setScale9Enabled(true);
			imgInfoBg:setAnchorPoint(ccp(0, 0));
		end
		if i % 2 == 0 and i ~= 1 and i ~= 2 and i~= 3 then
			imgInfoBg = ccs.image({
				scale9 = true,
				size = CCSizeMake(cellWidth - 50, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
				image = Common.getResourcePath("bg_paihangbang_di2.png"),
			})
			imgInfoBg:setScale9Enabled(true);
			imgInfoBg:setAnchorPoint(ccp(0, 0));
		end
		--VIP图片
		local imgVip = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("hall_vip_icon.png"),
		})
		imgVip:setAnchorPoint(ccp(0, 0));

		--VIP等级labelAtlas
		local labelAtlasVip = ccs.labelAtlas({
			text = vipLevel .. "",
			image = Common.getResourcePath("num_vip_level.png"),
			start = "0",
			w = 12,
			h = 19,
		})
		labelAtlasVip:setAnchorPoint(ccp(0, 0));

		--用户名称
		local labelUserName = ccs.label({
			text = userName,
			color = ccc3(249,235,219),
		})
		labelUserName:setFontSize(26)
		labelUserName:setAnchorPoint(ccp(0, 0));

		--关卡数
		local labelMission = ccs.label({
			text = "第" .. mission .. "关",
			color = ccc3(249,235,219),
		})
		labelMission:setFontSize(26)
		labelMission:setAnchorPoint(ccp(0, 0));

		--奖励图片
		local imgAward = ccs.image({
			scale9 = false,
			--			image = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			image = Common.getResourcePath("ico_cg_zrph_gold.png"),
		})
		imgAward:setAnchorPoint(ccp(0.5, 0.5));
		CrazyTopAwardImageListTable["" .. i] = imgAward
		CrazyTopAwardImageListTable["" .. i]:setVisible(true);
		if awardUrl ~= nil and  awardUrl ~= ""  then
			Common.getPicFile(awardUrl, i, true, updataCrazyTopAwardImageList)
		end

		--奖励文字
		local labelAward = ccs.label({
			text = awardText,
			color = ccc3(249,235,219),
		})
		labelAward:setFontSize(26)
		labelAward:setAnchorPoint(ccp(0, 0));

		if userName == profile.User.getSelfNickName() then
			labelUserName:setColor(ccc3(167,255,255))
			labelMission:setColor(ccc3(167,255,255))
			labelCup:setColor(ccc3(167,255,255))
			labelAward:setColor(ccc3(167,255,255))
		end

		SET_POS(imgCup,35, 10)
		SET_POS(labelCup,35, 17)
		if i % 2 == 0 or i == 1 or i == 3 then
			SET_POS(imgInfoBg,0, 0)
		end
		SET_POS(imgUserAvatar,110, 2)
		SET_POS(imgVip,230, 22)
		SET_POS(labelAtlasVip,288, 27)
		SET_POS(labelUserName,380, 20)
		SET_POS(labelMission,600, 20)
		--		SET_POS(imgAwardBg,730, 20)
		SET_POS(imgAward,830, 40)
		SET_POS(labelAward,862, 25)
		SET_POS(layout,0, cellHeight * (cellSize - i) + spacingH * (cellSize - i))
		if i % 2 == 0 or i == 1 or i == 3 then
			layout:addChild(imgInfoBg)
		end
		if i < 4 then
			layout:addChild(imgCup)
		else
			layout:addChild(labelCup)
		end

		layout:addChild(imgUserAvatar)
		if vipLevel ~= nil and vipLevel > 0 then
			layout:addChild(imgVip)
			layout:addChild(labelAtlasVip)
		end
		layout:addChild(labelUserName)
		layout:addChild(labelMission)
		--		layout:addChild(imgAwardBg)
		layout:addChild(imgAward)
		layout:addChild(labelAward)
		ScrollView_Top:addChild(layout)
	end
	Common.closeProgressDialog()
end

--[[--
排行榜信息加载
--]]
function showCrazyTopList()
	CrazyTopList = profile.CrazyStage.getCrazyStageRank()
	initCrazyTopListView()
end

--[[--
排行榜信息加载
--]]
function showTodayCrazyTopList()
	CrazyTopList = profile.CrazyStage.getCrazyStageRankTodayInfo()
	initCrazyTopListView()
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_RANK,showCrazyTopList)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_TODAY_RANK,showTodayCrazyTopList)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_RANK,showCrazyTopList)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_TODAY_RANK,showTodayCrazyTopList)
end
