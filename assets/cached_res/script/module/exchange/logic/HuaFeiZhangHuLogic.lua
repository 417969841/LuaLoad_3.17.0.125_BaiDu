module("HuaFeiZhangHuLogic",package.seeall)

view = nil;

Panel_20 = nil;--
ImageView_32 = nil;--
btn = nil;--
btn_close = nil;--
Label_Balance = nil
Label_History = nil
Label_Exchangble = nil
local totaily = nil
local exchangble = nil
local history = nil
local awardID = nil
local coinString = nil
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
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	ImageView_32 = cocostudio.getUIImageView(view, "ImageView_22");
	btn = cocostudio.getUIButton(view, "btn");
	btn_close = cocostudio.getUIButton(view, "btn_close");
	Label_Balance = cocostudio.getUILabel(view,"Label_31_0")
	Label_History = cocostudio.getUILabel(view,"Label_31_1")
	Label_Exchangble = cocostudio.getUILabel(view,"Label_31")
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("HuaFeiZhangHu.json")
	local gui = GUI_HUAFEIZHANGHU
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
	initView();
end

function setData(totailyV,exchangbleV,historyV,awardIDV,coinStringV)
	totaily = totailyV
	exchangble = exchangbleV
	history = historyV * exchangbleV
	awardID = awardIDV
	coinString = coinStringV
	Label_Balance:setText(totaily)
	Label_History:setText(history .. " 元")
	Label_Exchangble:setText("满" .. exchangble .. "元可领取")
end

function requestMsg()
	--新手引导
	NewUserCreateLogic.JumpInterface(HuaFeiZhangHuLogic.view,NewUserCoverOtherLogic.getTaskState());
end

function callback_btn(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if totaily < exchangble then
			Common.showToast("您的余额不足,无法兑换",2)
		else
			CardDuihuanWaysLogic.setValue(awardID,2,coinString)
			mvcEngine.createModule(GUI_CARDDUIHUANWAYS)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

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

--关闭
function close()
	LordGamePub.closeDialogAmin(ImageView_32,closePanel)
end

function closePanel()
	mvcEngine.destroyModule(GUI_HUAFEIZHANGHU)
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
