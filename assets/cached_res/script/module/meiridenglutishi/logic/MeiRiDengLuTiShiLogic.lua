module("MeiRiDengLuTiShiLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_1 = nil;--
ScrollView_Gonggao = nil;--
guanbi = nil;--
--公告图片显示图片的空间table
huodongItemTable = {}

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_1 = cocostudio.getUIPanel(view, "Panel_1");
	ScrollView_Gonggao = cocostudio.getUIScrollView(view, "ScrollView_Gonggao");
	guanbi = cocostudio.getUIButton(view, "guanbi");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("MeiRiDengLuTiShi.json")
	local gui = GUI_MEIRIDENGLUTISHI
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end


function createView()
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	initView();
	LordGamePub.showDialogAmin(Panel_14, false, meiRiDengLuOpenCallBack)
end


function meiRiDengLuOpenCallBack()
	showActitvityList(profile.MeiRiDengLu.getDailyNotifyInfoTable())
end

--[[--活动图片下载完毕后,设置图片]]
local function setHuoDongPic(path)
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
	if photoPath ~= nil and photoPath ~= "" and huodongItemTable[""..id] ~= nil then
		huodongItemTable[""..id]:loadTextures(photoPath,photoPath,"");
	end
end

--[[--根据ActionID打开一个广告]]
local function openOneActivity(ActionID)

	--如果是Lua活动
	if ActionID ~= nil then
		if ActionID == "4" then
			if GameLoadModuleConfig.getGoddessIsExists() then
			mvcEngine.createModule(GUI_AIXINNVSHEN)
			else
				Common.showToast("资源加载中，请稍候…",2)
			end
		elseif ActionID == "3" then
			if GameLoadModuleConfig.getBlessingIsExists() then
			mvcEngine.createModule(GUI_FUXINGGAOZHAO)
			else
				Common.showToast("资源加载中，请稍候…",2)
			end
		elseif ActionID == "6" then
			mvcEngine.createModule(GUI_LUCKY_TURNTABLE)
		elseif ActionID == "7" then
			mvcEngine.createModule(GUI_TRICKYPARTY)
		end
	end

end

--[[--
--显示活动列表
--]]
function showActitvityList(dataTable)
	if dataTable == nil then
		return;
	end
	local cellSize = 0
	cellSize = dataTable["NotifyInfoListCnt"]
	if cellSize == nil then
		return
	end
	local leftAndRight = 80 --左右的间距
	local viewW = 800
	local viewHMax = 378
	local viewH = 0
	local viewX = 0
	local viewY = 0
	local cellWidth = viewW --每个元素的宽
	local cellHeight = 280 --每个元素的高
	local lieSize = 1 --列数
	local hangSize = math.floor((cellSize + (lieSize - 1)) / lieSize) --行数
	local spacingW = 0 --横向间隔
	local spacingH = 10 --纵向间隔

	if hangSize * cellHeight + spacingH * (hangSize - 1) > viewHMax then
		viewH = viewHMax;
		viewY = 0;
	else
		viewH = hangSize * cellHeight + spacingH * (hangSize - 1)
		viewY = viewHMax - viewH;
	end

	local OffsetY = cellHeight * hangSize + spacingH * (hangSize - 1) --纵向位移，用于对齐scrollView顶部

	ScrollView_Gonggao:setSize(CCSizeMake(viewW, viewH))
	ScrollView_Gonggao:setInnerContainerSize(CCSizeMake(viewW, cellHeight * (hangSize ) + 300 + spacingH * (hangSize - 1) + 30) )
	ScrollView_Gonggao:setPosition(ccp(viewX-380, viewY - 170))
	--StarNickName	String	本期之星昵称
	local StarNickName = dataTable["StarNickName"]
	--StarAwardPic	String	本期之星获奖图片
	local StarAwardPic = dataTable["StarAwardPic"]
	--StarAwardTimeStamp	Long	本期之星时间戳
	local StarAwardTimeStamp = dataTable["StarAwardTimeStamp"]
	--StarAwardDesc	String	本期之星获奖详细文本
	local StarAwardDesc = dataTable["StarAwardDesc"]
	--标题
	local labelTitle = ccs.label({
		text = "获奖公告",
		color = ccc3(193, 150, 108)
	})
	labelTitle:setFontSize(30)
	--本期之星时间戳
	local StarAwardTimeStampdate = os.date("*t",StarAwardTimeStamp / 1000)

	local labelDate = ccs.label({
		text = StarAwardTimeStampdate.year.."-"..StarAwardTimeStampdate.month.."-"..StarAwardTimeStampdate.day,
		color = ccc3(193, 150, 108)
	})
	labelDate:setFontSize(25)
	--本期之星描述
	local labelDesc = ccs.TextArea({

		text = ""..StarAwardDesc,
		size = CCSizeMake(360, 120)
	})
	labelDesc:setTextAreaSize(CCSizeMake(360, 120))
	labelDesc:setTextHorizontalAlignment(kCCTextAlignmentLeft)
	labelDesc:setZOrder(5);
	labelDesc:setColor(ccc3(193, 150, 108))
	labelDesc:setFontSize(25)
	--本期之星按钮
	local buttonPicHD = ccs.button({
		scale9 = false,
		size = CCSizeMake(viewW-700, 150),
		pressed = "",
		normal = "",
		text = "",
		capInsets = CCRectMake(0, 0, 0, 0),
		listener = {
			[ccs.TouchEventType.began] = function(uiwidget)

			end,
			[ccs.TouchEventType.moved] = function(uiwidget)
			--[[Common.log("Touch Move" .. i)]]
			end,
			[ccs.TouchEventType.ended] = function(uiwidget)

			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
				Common.log("Touch Cancel")
			end,
		}
	})
	huodongItemTable["" .. 1] = buttonPicHD
	if StarAwardPic ~= nil and StarAwardPic ~= "" then
		Common.getPicFile(StarAwardPic, 1, true, setHuoDongPic)
	end
	--本期之星背景图
	--状态
	local splitImage = ccs.image({
		scale9 = false,
		image = Common.getResourcePath("ui_liangdian.png"),
		size = CCSizeMake(cellWidth-500,260),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	splitImage:setScale(1.2)
	local splitImage_backline = ccs.image({
		scale9 = true,
		image = Common.getResourcePath("fengexian.png"),
		size = CCSizeMake(cellWidth+800,15),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	splitImage_backline:setScaleX(11)
	local layout = nil;
	layout =ccs.panel({
		scale9 = false,
		image = "",
		size = CCSizeMake(cellWidth, cellHeight),
		capInsets = CCRectMake(0, 0, 0, 0),
	})

	--设置控件位置
	SET_POS(labelTitle, 85 , 119)
	SET_POS(splitImage_backline, 370,-90)
	SET_POS(labelDate, 640 , 115)
	SET_POS(buttonPicHD, 155 , 20)
	SET_POS(splitImage,155,20)
	SET_POS(labelDesc,525,25)
	SET_POS(layout, 13,  300+OffsetY - cellHeight * (math.floor((0) / lieSize) + 1) - spacingH * math.floor((0) / lieSize) + cellHeight / 2)
	layout:addChild(splitImage_backline)
	layout:addChild(labelDesc)
	layout:addChild(labelTitle)
	layout:addChild(labelDate)
	layout:addChild(splitImage)
	layout:addChild(buttonPicHD)
	ScrollView_Gonggao:addChild(layout)
	local j = 0
	for i = 1, cellSize do
		---如果是活动
		if dataTable["NotifyInfoList"][i]["NofityType"] == 1 then
			--活动的名字
			local NotifyName = dataTable["NotifyInfoList"][i]["NotifyName"]
			--活动的时间
			StarAwardTimeStamp = dataTable["NotifyInfoList"][i]["NotifyStamp"]
			StarAwardTimeStampdate = os.date("*t",StarAwardTimeStamp / 1000)
			local NotifyNametime = StarAwardTimeStampdate.year.."-"..StarAwardTimeStampdate.month.."-"..StarAwardTimeStampdate.day
			--活动图片
			local NotifytaskPhotoUrl = dataTable["NotifyInfoList"][i]["NotifyDes"]
			local labelTitle_HD = ccs.label({
				text = NotifyName,
				color = ccc3(193, 150, 108)
			})
			labelTitle_HD:setFontSize(30)
			local labelDate_HD = ccs.label({
				text =NotifyNametime,
				color = ccc3(193, 150, 108)
			})
			labelDate_HD:setFontSize(25)
			local splitImage_backlineHD = ccs.image({
				scale9 = true,
				image = Common.getResourcePath("fengexian.png"),
				size = CCSizeMake(cellWidth+800,15),
				capInsets = CCRectMake(0, 0, 0, 0),
			})
			splitImage_backlineHD:setScaleX(11)
			--活动按钮
			local buttonPicHD = ccs.button({
				scale9 = false,
				size = CCSizeMake(viewW-150, 130),
				pressed = "",
				normal = "",
				text = "",
				capInsets = CCRectMake(0, 0, 0, 0),
				listener = {
					[ccs.TouchEventType.began] = function(uiwidget)

					end,
					[ccs.TouchEventType.moved] = function(uiwidget)
					--[[Common.log("Touch Move" .. i)]]
					end,
					[ccs.TouchEventType.ended] = function(uiwidget)
						openOneActivity(dataTable["NotifyInfoList"][i]["NotifyParamID"])
					end,
					[ccs.TouchEventType.canceled] = function(uiwidget)
						Common.log("Touch Cancel")
					end,
				}
			})
			j=i+1
			buttonPicHD:setScale(0.8)
			huodongItemTable["" .. j] = buttonPicHD
			if NotifytaskPhotoUrl ~= nil and NotifytaskPhotoUrl ~= "" then
				Common.getPicFile(NotifytaskPhotoUrl, j, true, setHuoDongPic)
			end
			local layoutHD = nil;
			layoutHD =ccs.panel({
				scale9 = false,
				image = "",
				size = CCSizeMake(cellWidth, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
			})
			--		layout:setAnchorPoint(ccp(0.5, 0.5))
			--设置控件位置
			labelTitle_HD:setAnchorPoint(ccp(0, 0.5))
			SET_POS(splitImage_backlineHD, 370,-85)
			SET_POS(labelTitle_HD, 31 , 155)
			SET_POS(labelDate_HD, 650 , 155)
			SET_POS(buttonPicHD, 370 , 40)
			SET_POS(layoutHD, 13, 300+ OffsetY - cellHeight * (math.floor(( i) / lieSize) + 1) - spacingH * math.floor((i ) / lieSize) + cellHeight / 2)
			layoutHD:addChild(splitImage_backlineHD)
			layoutHD:addChild(labelTitle_HD)
			layoutHD:addChild(labelDate_HD)
			layoutHD:addChild(buttonPicHD)
			ScrollView_Gonggao:addChild(layoutHD)
			---如果是公告
		elseif dataTable["NotifyInfoList"][i]["NofityType"] == 0 then
			--公告标题
			local NotifyName = dataTable["NotifyInfoList"][i]["NotifyName"]
			--公告的时间
			StarAwardTimeStamp = dataTable["NotifyInfoList"][i]["NotifyStamp"]
			StarAwardTimeStampdate = os.date("*t",StarAwardTimeStamp / 1000)
			local NotifyNametime = StarAwardTimeStampdate.year.."-"..StarAwardTimeStampdate.month.."-"..StarAwardTimeStampdate.day
			--公告的描述
			local NotifyNameDesc = dataTable["NotifyInfoList"][i]["NotifyDes"]
			local labelTitle_GG = ccs.label({
				text = NotifyName,
				color = ccc3(193, 150, 108)
			})
			labelTitle_GG:setFontSize(30)
			local splitImage_backlineGG = ccs.image({
				scale9 = true,
				image = Common.getResourcePath("fengexian.png"),
				size = CCSizeMake(cellWidth+800,15),
				capInsets = CCRectMake(0, 0, 0, 0),
			})
			splitImage_backlineGG:setScaleX(11)
			local labelDate_GG = ccs.label({
				text =NotifyNametime,
				color = ccc3(193, 150, 108)
			})
			labelDate_GG:setFontSize(25)
			--公告的描述
			local textAreaInfo = ccs.TextArea({
				text = NotifyNameDesc,
				size = CCSizeMake(670, 200),
			})
			textAreaInfo:setTextAreaSize(CCSizeMake(670,200))
			textAreaInfo:setTextHorizontalAlignment(kCCTextAlignmentLeft)
			textAreaInfo:setZOrder(5);
			textAreaInfo:setColor(ccc3(193, 150, 108))
			textAreaInfo:setFontSize(25)
			local labelDesc_GG = ccs.label({
				text =NotifyNameDesc,
				color = ccc3(193, 150, 108)
			})
			labelDesc_GG:setFontSize(25)
			local layoutGG = nil;
			layoutGG =ccs.panel({
				scale9 = false,
				image = "",
				size = CCSizeMake(cellWidth, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
			})
			SET_POS(splitImage_backlineGG, 370,-95)
			SET_POS(labelTitle_GG, 85 , 155)
			SET_POS(labelDate_GG, 650 , 155)
			SET_POS(textAreaInfo, 365, 0)
			SET_POS(layoutGG, 13,  300+OffsetY - cellHeight * (math.floor((i ) / lieSize) + 1) - spacingH * math.floor((i) / lieSize) + cellHeight / 2)
			layoutGG:addChild(splitImage_backlineGG)
			layoutGG:addChild(labelTitle_GG)
			layoutGG:addChild(labelDate_GG)
			layoutGG:addChild(textAreaInfo)
			ScrollView_Gonggao:addChild(layoutGG)
		end
	end
end




function requestMsg()

end

function callback_guanbi(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_MEIRIDENGLUTISHI);
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
