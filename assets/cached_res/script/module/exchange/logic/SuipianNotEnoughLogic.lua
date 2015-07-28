module("SuipianNotEnoughLogic",package.seeall)

view = nil
btn_close = nil--关闭按钮
btn_goconvert = nil --去兑换
btn_gogame = nil --去game
lab_title = nil
lab_help = nil
lab_tip1 = nil
lab_tip2 = nil
img_good = nil
panel = nil
--全局变量
local type = nil--1:兑奖券不足  2：兑奖券碎片不足
local url = nil--图片地址

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

local function updataImage(dataInApp)
	local photoPath = nil
	if Common.platform == Common.TargetIos then
		photoPath = dataInApp["useravatorInApp"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(dataInApp, "#")
		local id = string.sub(dataInApp, 1, i-1)
		photoPath = string.sub(dataInApp, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and img_good ~= nil then
		img_good:loadTexture(photoPath);
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("SuipianNotEnough.json")
	local gui = GUI_SUIPIANNOTENOUGH
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

	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_goconvert = cocostudio.getUIButton(view, "btn_goconvert")
	btn_gogame = cocostudio.getUIButton(view, "btn_gogame")
	lab_title = cocostudio.getUILabel(view,"lab_title")
	lab_help = cocostudio.getUILabel(view,"lab_help")
	lab_tip1 = cocostudio.getUILabel(view,"lab_tip1")
	lab_tip2 = cocostudio.getUILabel(view,"lab_tip2")
	img_good = cocostudio.getUIImageView(view, "img_good")
	--1:兑奖券不足  2：兑奖券碎片不足
	if type == 1 then
		lab_help:setText("如何获取兑奖券？")
		lab_title:setText("兑奖券不足，暂时无法兑换！")
		--		lab_tip1:setText("1.兑奖券快速合成")
	else
		lab_help:setText("如何获取兑奖券碎片")
		lab_title:setText("兑奖券碎片不足，暂时无法兑换！")
		--		lab_tip1:setText("1.房间开宝盒获得")
	end
	lab_tip1:setText("1.在房间中开宝箱")
	Common.getPicFile(url, 0, true, updataImage)
end
--
function setType(typeV,urlV)
	type = typeV
	url = urlV
end

--关闭
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end

function closePanel()
	mvcEngine.destroyModule(GUI_SUIPIANNOTENOUGH)
end

function requestMsg()

end

--关闭
function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end
--去兑换
function callback_btn_goconvert(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--1:兑奖券不足   背包
		--2：兑奖券碎片不足  房间癞子场
		--		if type == 1 then
		--		else
		Common.showProgressDialog("进入房间中,请稍后...")
		sendQuickEnterRoom(-1)
		--		end
	elseif component == CANCEL_UP then
	--取消
	end

end
--去比赛
function callback_btn_gogame(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--1:兑奖券不足   转到比赛
		--2：兑奖券碎片不足  比赛整点秒杀
		if type == 1 then
			GameConfig.setHallRoomItem(1)
			GameConfig.setHallShowMode(2)
			mvcEngine.createModule(GUI_HALL)
			HallLogic.setOpenMatch(1,"海量兑奖券闯关赛")
		else
			GameConfig.setHallRoomItem(0)
			GameConfig.setHallShowMode(2)
			mvcEngine.createModule(GUI_HALL)
			HallLogic.setOpenMatch(1,"整点碎片秒杀赛")
		end
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
end

function removeSlot()
end
