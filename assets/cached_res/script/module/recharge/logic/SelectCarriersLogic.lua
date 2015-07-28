module("SelectCarriersLogic",package.seeall)

view = nil;

Panel = nil;--
Panel_Bg = nil;--
CheckBox_YiDong = nil;--
CheckBox_LianTong = nil;--
CheckBox_DianXin = nil;--
Button_OK = nil;--

local RechargeCard_YIDONG = 0--移动
local RechargeCard_LIANDONG = 1--联通
local RechargeCard_DIANXIN = 2--电信

CurrentCarriers = 0;--当前运营商

--[[--
--关闭弹出框
--]]
local function closeTheBox()
	mvcEngine.destroyModule(GUI_SELECTCARRIERS);
end

function onKeypad(event)
	if event == "backClicked" then
	--返回键
		closeTheBox()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_SELECTCARRIERS;
	view = cocostudio.createView("SelectCarriers.json");
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel = cocostudio.getUIPanel(view, "Panel");
	Panel_Bg = cocostudio.getUIPanel(view, "Panel_Bg");
	CheckBox_YiDong = cocostudio.getUIImageView(view, "CheckBox_YiDong");
	CheckBox_LianTong = cocostudio.getUIImageView(view, "CheckBox_LianTong");
	CheckBox_DianXin = cocostudio.getUIImageView(view, "CheckBox_DianXin");
	Button_OK = cocostudio.getUIButton(view, "Button_OK");
	CheckBox_YiDong:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);

	initView();
	LordGamePub.showDialogAmin(Panel_Bg)
	CurrentCarriers = 0;
end

function requestMsg()

end

function callback_Panel(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		LordGamePub.closeDialogAmin(Panel_Bg,closeTheBox);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--确认
--]]
function callback_Button_OK(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		RechargeCenterLogic.initCzkList(CurrentCarriers);
		LordGamePub.closeDialogAmin(Panel_Bg,closeTheBox);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--移动
--]]
function callback_CheckBox_YiDong(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		CheckBox_YiDong:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
		CheckBox_LianTong:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
		CheckBox_DianXin:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
		CurrentCarriers = RechargeCard_YIDONG;
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--联通
--]]
function callback_CheckBox_LianTong(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		CheckBox_YiDong:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
		CheckBox_LianTong:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
		CheckBox_DianXin:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
		CurrentCarriers = RechargeCard_LIANDONG;
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--电信
--]]
function callback_CheckBox_DianXin(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		CheckBox_YiDong:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
		CheckBox_LianTong:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
		CheckBox_DianXin:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
		CurrentCarriers = RechargeCard_DIANXIN;
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
