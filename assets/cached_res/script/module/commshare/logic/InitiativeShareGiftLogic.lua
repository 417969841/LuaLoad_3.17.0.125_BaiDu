module("InitiativeShareGiftLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_Gift = nil;--豪礼panel
Image_Prize = nil;--奖品图
AtlasLabel_ShareReward = nil;--主动分享奖励数
AtlasLabel_FriendsReward = nil;--好友登录奖励数
AtlasLabel_FriendsRechargeReward = nil;--好友充值奖励百分比
Button_Ok = nil;--确定按钮
RewardDescriptionTable = {};--分享奖励说明

--[[--
--关闭界面
--]]
local function close()
	mvcEngine.destroyModule(GUI_INITIATIVE_SHARE_GIFT);
end

function onKeypad(event)
	if event == "backClicked" then
	--返回键
		close();
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_Gift = cocostudio.getUIPanel(view, "Panel_Gift");
	Image_Prize = cocostudio.getUIImageView(view, "Image_Prize");
	AtlasLabel_ShareReward = cocostudio.getUILabelAtlas(view, "AtlasLabel_ShareReward");
	AtlasLabel_FriendsReward = cocostudio.getUILabelAtlas(view, "AtlasLabel_FriendsReward");
	AtlasLabel_FriendsRechargeReward = cocostudio.getUILabelAtlas(view, "AtlasLabel_FriendsRechargeReward");
	Button_Ok = cocostudio.getUIButton(view, "Button_Ok");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("InitiativeShareGift.json")
	local gui = GUI_INITIATIVE_SHARE_GIFT;
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

--[[--
--初始化数据
--]]
local function initData()
	AtlasLabel_ShareReward:setStringValue(RewardDescriptionTable.SharingReceivedCoin);
	AtlasLabel_FriendsReward:setStringValue(RewardDescriptionTable.InviteSuccesCoin);
	AtlasLabel_FriendsRechargeReward:setStringValue(RewardDescriptionTable.CommissionRate);
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	RewardDescriptionTable = profile.ShareToWX.getSharingRewardDescription();

	initView();
	initData();
	LordGamePub.showDialogAmin(Panel_Gift);
end

function requestMsg()

end

function callback_Button_Ok(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		LordGamePub.closeDialogAmin(Panel_Gift,close);
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
