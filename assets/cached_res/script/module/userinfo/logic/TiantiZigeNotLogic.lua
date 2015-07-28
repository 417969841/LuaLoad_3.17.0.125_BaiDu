module("TiantiZigeNotLogic",package.seeall)

view = nil
btn_close = nil
btn_go = nil
img_bg = nil
Label_Msg = nil;

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("TiantiZigeNot.json")
	local gui = GUI_TIANTIZIGENOT
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
	btn_close =  cocostudio.getUIButton(view, "btn_close")
	btn_go = cocostudio.getUIButton(view, "btn_cz")
	img_bg =  cocostudio.getUIImageView(view, "img_bg")
	Label_Msg = cocostudio.getUILabel(view, "Label_Msg");

	Label_Msg:setText("只有参加比赛《天梯工资排位赛》，    并取得一定名次才能领取天梯工资哦！");

--	local ts = FontStyle.UILabelAddStroke(nil,"只有参加比赛《天梯工资排位赛》，    并", 35, ccc3(255,255,255), ccc3(0,0,0), 1)
--	ts:setPosition(ccp(0, 150))
--	ts:setZOrder(20)
--	img_bg:addChild(ts)
--
--	local ts1 = FontStyle.UILabelAddStroke(nil,"取得一定名次才能领取天梯工资哦！", 35, ccc3(255,255,255), ccc3(0,0,0), 1)
--	ts1:setPosition(ccp(0, 100))
--	ts1:setZOrder(20)
--	img_bg:addChild(ts1)
end

function requestMsg()

end

--关闭
function callback_btn_close(component)
	if component == PUSH_DOWN then
		--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_TIANTIZIGENOT)
	elseif component == CANCEL_UP then
		--取消
	end
end
--前往
function callback_btn_go(component)
	if component == PUSH_DOWN then
		--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_TIANTIZIGENOT)
		GameConfig.setHallRoomItem(1)
		GameConfig.setHallShowMode(2)
		mvcEngine.createModule(GUI_HALL)
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
--注册监听信号
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--移除监听信号
--framework.removeSlotFromSignal(signal, slot)
end
