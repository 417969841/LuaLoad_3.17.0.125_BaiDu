module("RoomCoinNotFitLogic",package.seeall)

view = nil
panel = nil
--控件
lab_title = nil
lab_roomname = nil
lab_time = nil
lab_rs = nil
lab_tj = nil
btn_close = nil
btn_go = nil
img_bg = nil
img_jiangbei = nil
--全局变量
local GoToRoomType = {};
GoToRoomType.GO_TO_LOW_ROOM = 1--进入低倍房间
GoToRoomType.GO_TO_HIGH_ROOM = 2--进入高倍房间
GoToRoomType.GO_TO_HIGH_MATCH = 3--进入高倍比赛
GoToRoomType.GO_TO_LOW_MATCH  = 4--进入低倍比赛
local type = 0--1引导进低倍房间  2引导进高倍房间
local guideroomtable = {}

function getGoToRoomType()
	return GoToRoomType;
end

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

local function updataPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		local id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
	if (photoPath ~= nil and photoPath ~= "" and img_jiangbei ~= nil) then
		img_jiangbei:loadTexture(photoPath)
	end
end
local function updataTitle(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		local id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("RoomCoinNotFit.json")
	local gui = GUI_ROOMCOINNOTFIT
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
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)

	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)

	lab_title = cocostudio.getUILabel(view, "lab_title")
	lab_roomname = cocostudio.getUILabel(view, "lab_roomname")
	lab_time = cocostudio.getUILabel(view, "lab_time")
	lab_rs = cocostudio.getUILabel(view, "lab_rs")
	lab_tj = cocostudio.getUILabel(view, "lab_tj")
	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_go = cocostudio.getUIButton(view, "btn_go")
	img_bg = cocostudio.getUIImageView(view, "img_bg")
	img_jiangbei = cocostudio.getUIImageView(view, "img_jiangbei")

	if guideroomtable.prizeUrl ~= nil then
		Common.getPicFile(guideroomtable.prizeUrl, 0, true, updataPhoto)
	end

	if type == getGoToRoomType().GO_TO_LOW_ROOM then
		lab_title:setText("您的金币低于该房间上限，请往低倍房间一展身手！")
		lab_roomname:setText(guideroomtable.RoomName.."房间")
		lab_time:setText(guideroomtable.RoomName)--
		lab_rs:setText(guideroomtable.playerCnt)
		lab_tj:setText(guideroomtable.EntryConditions)
		setRoomItemBg(guideroomtable.TableType)
--		if guideroomtable.TitleUrl ~= nil then
--			Common.getPicFile(guideroomtable.TitleUrl, 0, true, updataTitle)
--		end
	elseif type == getGoToRoomType().GO_TO_HIGH_ROOM then
		lab_title:setText("您的金币超出该房间上限，请前往高倍房间一展身手！")
		lab_roomname:setText(guideroomtable.RoomName.."房间")
		lab_time:setText(guideroomtable.RoomName)--
		lab_rs:setText(guideroomtable.playerCnt)
		lab_tj:setText(guideroomtable.EntryConditions)
		setRoomItemBg(guideroomtable.TableType)
--		if guideroomtable.TitleUrl ~= nil then
--			Common.getPicFile(guideroomtable.TitleUrl, 0, true, updataTitle)
--		end
	elseif type == getGoToRoomType().GO_TO_LOW_MATCH then
		lab_title:setText("您的金币低于该比赛上限，请前往低倍比赛一展身手！")
		lab_roomname:setText(guideroomtable.MatchTitle)
		lab_time:setText(guideroomtable.StartTime)
		lab_rs:setText(guideroomtable.PlayerCnt)
		lab_tj:setText(guideroomtable.Condition)
		setMatchItemBg(guideroomtable.MatchLevel)
--		if guideroomtable.TitlePictureUrl ~= nil then
--			Common.getPicFile(guideroomtable.TitlePictureUrl, 0, true, updataTitle)
--		end
	else
	end
end
--修改推荐房间背景图
function setRoomItemBg(type)
	if type == 1 then
		img_bg:loadTexture(Common.getResourcePath("fangjian.png"))
	elseif type == 2 then
		img_bg:loadTexture(Common.getResourcePath("fangjian.png"))
	else
		img_bg:loadTexture(Common.getResourcePath("fangjian.png"))
	end
end
--修改比赛房间背景图
function setMatchItemBg(type)
	--天梯 2 疯狂闯关1 免费赢奖0
	--1蓝2红3黄
	if type == 1 then
		img_bg:loadTexture(Common.getResourcePath("fangjian.png"))
	elseif type == 2 then
		img_bg:loadTexture(Common.getResourcePath("fangjian.png"))
	else
		img_bg:loadTexture(Common.getResourcePath("fangjian.png"))
	end
end

function requestMsg()

end

function setType(typeV,guideroomtableV)
	type = typeV
	guideroomtable = guideroomtableV
end
--进入
function callback_btn_go(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--关闭界面
		if type == getGoToRoomType().GO_TO_HIGH_ROOM or type == getGoToRoomType().GO_TO_LOW_ROOM then
			sendEnterRoom(guideroomtable.RoomID)--进房间
		else

			local function BaoMing()
				--改成弹出报名条件筛选
				TiaoJianBaoMingLogic.mathcondition = guideroomtable
				TiaoJianBaoMingLogic.MatchID = guideroomtable.MatchID
				mvcEngine.createModule(GUI_TIAOJIANBAOMING)
			end

			local ismag = MatchList.isTimeDistanceTooSmall(math.modf(profile.Match.getMatchStartTime(guideroomtable.MatchID)/1000))
			if(ismag)then
				TimeNotFitLogic.noticeMsg = "该比赛与您已报名的" .."\"" .. ismag .. "\"" .. "开赛时间间隔较近(小于30分钟),确认报名吗？"
				TimeNotFitLogic.func = BaoMing
				mvcEngine.createModule(GUI_TIMENOTFIT)
			else
				BaoMing()
			end
		end
		close()
	elseif component == CANCEL_UP then
		--取消
		btn_go:setScale(1)
	end
end
--关闭
function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--关闭界面
		close()

	elseif component == CANCEL_UP then
	--取消
	end
end
--关闭页面
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_ROOMCOINNOTFIT)
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
