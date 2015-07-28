module("InitiativeShareLogic",package.seeall)

view = nil;

Panel_20 = nil;--
--panel = nil;--
Button_close = nil;--
Image_ToFriends = nil;--
Image_ToCircle = nil;--
Image_Help = nil;--帮助
AtlasLabel_Num = nil;



local isCircle = nil;
local showTitle = nil;
local showMessage = nil;
RewardDescriptionTable = {};--分享奖励说明

function close()
	mvcEngine.destroyModule(GUI_INITIATIVE_SHARE);
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
--		LordGamePub.closeDialogAmin(panel,close);
		close()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
--	panel = cocostudio.getUIPanel(view, "panel");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Image_Help = cocostudio.getUIImageView(view, "Image_Help");
	AtlasLabel_Num = cocostudio.getUILabelAtlas(view, "AtlasLabel_Num");
	Image_ToFriends = cocostudio.getUIButton(view, "Image_ToFriends");
  Image_ToCircle = cocostudio.getUIButton(view, "Image_ToCircle");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("InitiativeShare.json")
	local gui = GUI_INITIATIVE_SHARE
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

function createView()
	showTitle = "你敢来我敢送！玩一局就送2元话费咯！"
	showMessage = "2015年最好玩的斗地主游戏来啦！现在登录游戏就送2元话费，我已经拿到了，快来试试吧！"
	--标记是主动分享
	CommShareConfig.SHARETYPE = CommShareConfig.SHARE_TYPE_INITIATIVE;
	--初始化当前界面
	initLayer();

	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);


	initView();
	--获取奖励说明数据
	getRewardDescriptionData();
	--默认分享到朋友圈
	isCircle = true
--	LordGamePub.showDialogAmin(panel)
	--	sendOPERID_GAME_SHARING_ALL_REWARD()
end

--[[--
--获取奖励说明数据
--]]
function getRewardDescriptionData()
	Common.closeProgressDialog();
	RewardDescriptionTable = profile.ShareToWX.getSharingRewardDescription();
	if RewardDescriptionTable == nil or next(RewardDescriptionTable) == nil then
		sendOPERID_SHARING_REWARD_DESCRIPTION();
		Common.showProgressDialog("加载中，请稍后…");
	else
		AtlasLabel_Num:setStringValue(RewardDescriptionTable.SharingReceivedCoin);
	end
end

function requestMsg()

end

--[[--
--	显示奖励累积文字
--]]--
function showSharingText()
	Common.closeProgressDialog()
	local SharingAllRewardTable = profile.ShareToWX.getSharingAllRewardTable()
	if SharingAllRewardTable == nil then
		return
	end
	local UserCount = SharingAllRewardTable.UserCount
	local Coins = SharingAllRewardTable.Coins
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
--		LordGamePub.closeDialogAmin(panel,close);
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_ToFriends(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		isCircle = false
    LordGamePub.shareToWX(isCircle, showTitle, showMessage)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_ToCircle(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		isCircle = true
		LordGamePub.shareToWX(isCircle, showTitle, showMessage)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--帮助按钮
--]]
function callback_Image_Help(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_INITIATIVE_SHARE_GIFT);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	isCircle = nil
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(OPERID_GAME_SHARING_ALL_REWARD, showSharingText)--显示奖励累积文字
	framework.addSlot2Signal(OPERID_SHARING_REWARD_DESCRIPTION, getRewardDescriptionData)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(OPERID_GAME_SHARING_ALL_REWARD, showSharingText)--显示奖励累积文字
	framework.removeSlotFromSignal(OPERID_SHARING_REWARD_DESCRIPTION, getRewardDescriptionData)
end
