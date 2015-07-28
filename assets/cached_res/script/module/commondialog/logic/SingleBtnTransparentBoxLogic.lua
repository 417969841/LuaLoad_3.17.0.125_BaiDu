module("SingleBtnTransparentBoxLogic",package.seeall)
--
--单按钮透明框
--

view = nil;

Panel_Box = nil;--
ImageView_TransparentBox = nil;--透明弹出框
Button_close = nil;--关闭按钮
Label_tipsUpper = nil;--上部提示语
Label_tipsLower = nil;--下部提示语
Button_Confirm = nil;--确认按钮
Label_Confirm = nil;--确认按钮上的文字
local BTN_COMFIRM_RELEASE_UP =1; --确认按钮抬起
local BTN_COMFIRM_PUSH_DOWN =2;--确认按钮按下
local comfirmTextPicName = "";--确认文字图片
local transparentBoxTag = {};--tag table
transparentBoxTag.NOW_SIGN_TO_LOTTERY = 1; --签到时前往抽奖
transparentBoxTag.HAS_SIGN_TO_LOTTERY = 2; --已签时前往抽奖
transparentBoxTag.NO_SIGN_TO_LOTTERY = 3; --未签时前往抽奖
transparentBoxTag.CAN_NOT_LOTTERY =4; --不能抽奖
local openBoxTag = 0; --打开弹出框的tag 判断是否在抽奖时打开

--[[--
--关闭弹出框
--]]
local function closeTheBox()
	mvcEngine.destroyModule(GUI_SINGLE_BTN_TRANSPARENT_BOX);
	if openBoxTag == transparentBoxTag.NOW_SIGN_TO_LOTTERY then
		MonthSignLogic.signAnimation();
	end
end

--[[--
--界面关闭动画
--]]
local function thisLayerCloseAmin()
	LordGamePub.closeDialogAmin(ImageView_TransparentBox,closeTheBox);
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
--获取透明框的tag
--]]
function getTransparentBoxTag()
	return transparentBoxTag;
end

--[[--
--确认按钮更换文字图片
--]]
local function changeTextPicByComfirmBtn()
	Button_Confirm:removeAllChildren();
	if openBoxTag == transparentBoxTag.NO_SIGN_TO_LOTTERY then
		--没签 [查看]
		comfirmTextPicName = "chakan2.png";
	elseif openBoxTag == transparentBoxTag.NOW_SIGN_TO_LOTTERY or openBoxTag == transparentBoxTag.HAS_SIGN_TO_LOTTERY then
		--已签或正在签 [前往]
		comfirmTextPicName = "ui_item_btn_qianwang.png";
	end
	local comfirmTextSprite = UIImageView:create();
	comfirmTextSprite:loadTexture(Common.getResourcePath(comfirmTextPicName, pathTypeInApp));
	Button_Confirm:addChild(comfirmTextSprite);
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_Box = cocostudio.getUIPanel(view, "Panel_Box");
	ImageView_TransparentBox = cocostudio.getUIImageView(view, "ImageView_TransparentBox");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Label_tipsUpper = cocostudio.getUILabel(view, "Label_tipsUpper");
	Label_tipsLower = cocostudio.getUILabel(view, "Label_Lower");
	Button_Confirm = cocostudio.getUIButton(view, "Button_Confirm");
	Label_Confirm = cocostudio.getUILabel(view, "Label_Confirm");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("SingleBtnTransparentBox.json")
	local gui = GUI_SINGLE_BTN_TRANSPARENT_BOX
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
--已签时显示去抽奖信息
--]]
local function hasSignshowToLotteryInfo()
	Label_tipsUpper:setText("您已领取过此抽奖机会");
	Label_tipsLower:setText("是否立刻去抽奖");
end

--[[--
--未签时显示去抽奖信息
--@param #String msg 提示语
--]]
local function noSignshowToLotteryInfo(msg)
	Label_tipsUpper:setText("幸运大抽奖");
	Label_tipsLower:setText(msg);
end

--[[--
--签到时显示去抽奖信息
--@param #String msg 提示语
--]]
local function nowSignshowToLotteryInfo(msg)
	Label_tipsUpper:setText(msg);
	Label_tipsLower:setText("是否立刻去抽奖");
end

--[[--
--展示不能抽奖信息
--@param #String msg 提示语
--]]
local function showCanNotLotteryMsg(msg)
	Label_tipsUpper:setText(msg);
	Label_tipsLower:setText("");
end

--[[--
--设置弹出框提示文字
--@param #number tag 标识
--@param #String msg 提示语
--]]
function setTransparentBoxTipsText(tag, msg)
	--确认按钮更换文字图片
	openBoxTag = tag;
	changeTextPicByComfirmBtn();
	if tag == transparentBoxTag.NOW_SIGN_TO_LOTTERY then
		nowSignshowToLotteryInfo(msg);
	elseif tag == transparentBoxTag.HAS_SIGN_TO_LOTTERY then
		hasSignshowToLotteryInfo();
	elseif tag == transparentBoxTag.NO_SIGN_TO_LOTTERY then
		noSignshowToLotteryInfo(msg);
	elseif tag == transparentBoxTag.CAN_NOT_LOTTERY then
		showCanNotLotteryMsg(msg)
	end
end

function requestMsg()

end

--[[--
--关闭按钮
--]]
function callback_Button_close(component)
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
--确认按钮
--]]
function callback_Button_Confirm(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_LUCKY_TURNTABLE);

	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--触摸面板
--]]
function callback_Panel_Box(component)
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
