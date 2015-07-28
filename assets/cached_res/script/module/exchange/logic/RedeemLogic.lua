module("RedeemLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel_PackageExchange = nil;--兑换码兑换panel
txt_code = nil;--兑换码输入框
Label_code = nil;--兑换码展示label
btn_close = nil;--关闭按钮
Label_Tips = nil;--提示语
btn_duihuan = nil;--兑换按钮
Label_Title = nil;--标题

local defaultContent = "";--默认的兑换码输入框内容

local ViewTypeTable = {};--界面类型table
ViewTypeTable.TAG_INVITE_PRIZE = 1;--邀请奖励界面
ViewTypeTable.TAG_REDEMPTION_CODE = 2;--兑换码兑换界面

local ViewType = -1;--当前界面的类型
local OPERATE_SUCCESS = 1;--操作成功

--[[--
--设置当前的界面类型
--@param #number value 类型值
--]]
function setCurViewType(value)
	ViewType = value;
end

--[[--
--获取界面类型
--@param #table ViewTypeTable 界面类型table
--]]
function getViewTypeTable()
	return ViewTypeTable;
end

--[[--
--销毁界面
--]]
local function close()
	mvcEngine.destroyModule(GUI_REDEEM);
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
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	panel_PackageExchange = cocostudio.getUIPanel(view, "panel_PackageExchange");
	txt_code = cocostudio.getUITextField(view, "txt_code");
	txt_code:setVisible(false);
	Label_code = cocostudio.getUILabel(view, "Label_code");
	btn_close = cocostudio.getUIButton(view, "btn_close");
	Label_Tips = cocostudio.getUILabel(view, "Label_Tips");
	btn_duihuan = cocostudio.getUIButton(view, "btn_duihuan");
	Label_Title = cocostudio.getUILabel(view, "Label_Title");
end

--[[--
--初始化控件数据
--]]
local function initViewData()
	if ViewType == ViewTypeTable.TAG_INVITE_PRIZE then
		--邀请奖励界面
		Label_code:setText("请输入邀请人用户ID");
		Label_Tips:setText("请输入邀请人用户ID：");
		Label_Title:setText("邀请奖励");
	elseif ViewType == ViewTypeTable.TAG_REDEMPTION_CODE then
		--兑换码兑换界面
		Label_code:setText("请输入礼包兑换码");
		Label_Tips:setText("请输入XY平台礼包兑换码：");
		Label_Title:setText("礼包兑换");
	end

	defaultContent = Label_code:getStringValue();
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("Redeem.json")
	local gui = GUI_REDEEM;
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
	LordGamePub.showDialogAmin(panel_PackageExchange);
	--初始化控件数据
	initViewData();
end

function requestMsg()

end

--[[--
--ios输入框回调
--]]
function callbackInputForIos(valuetable)
	local value = valuetable["value"];
	--输入数据为空, return
	if value == nil or value == "" then
		if defaultContent ~= nil then
			--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
			Label_code:setText(defaultContent);
		end
		return;
	end

	--如果用户输入内容,则将输入的内容赋给显示的label
	Label_code:setText(value);
	txt_code:setText(value);
end

--[[--
--ios输入框
--]]
function callback_text_code_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.showAlertInput(txt_code:getStringValue(),0,true, callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--安卓输入框
--]]
function callback_text_code()
	--控件不存在,return
	if Label_code == nil then
		return;
	end

	if txt_code:getStringValue() ~= nil and txt_code:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		Label_code:setText(txt_code:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultContent ~= nil then
			Label_code:setText(defaultContent);
		end
	end
end

--[[--
--关闭按钮
--]]
function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(panel_PackageExchange,close);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--兑换逻辑
--@param #String code 输入的文字
--]]
function logicExchange(code)
	if ViewType == ViewTypeTable.TAG_INVITE_PRIZE then
		--邀请奖励界面
		if code == nil or code == "" or code == defaultContent then
			Common.showToast("不输入邀请人ID就无法领取奖励哦！", 2);
			return;
		end
		if  string.len(code) < 4 or tonumber(code) == nil or tonumber(code) == 0 then
			Common.showToast("请输入正确的用户ID", 2);
			return;
		end

		sendOPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND(tonumber(code));

	elseif ViewType == ViewTypeTable.TAG_REDEMPTION_CODE then
		--兑换码兑换界面
		if code == nil or code == "" or string.len(code) < 4 or code == defaultContent then
			Common.showToast("请输入正确的兑换码", 2);
			return;
		end

		sendOPERID_XYPLATFORM_GIFTBAG_EXCHANGE(code);
	end
end

--[[--
--兑换按钮
--]]
function callback_btn_duihuan(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local code = Label_code:getStringValue();
		--兑换的逻辑
		logicExchange(code);
	elseif component == CANCEL_UP then
	--取消

	end
end


--[[--
--应答兑换码消息
--]]
function processOPERID_XYPLATFORM_GIFTBAG_EXCHANGE()
	if profile.XYPlatformGiftBagExchange.getExchangeResult() == OPERATE_SUCCESS then
		--关闭界面
		close();
		--展示奖品
		local XYGiftBagDataTable = profile.XYPlatformGiftBagExchange.getExchangePrizeList();
		for i = 1, #XYGiftBagDataTable do
			ImageToast.createView(XYGiftBagDataTable[i].PrizeUrl,nil,XYGiftBagDataTable[i].PrizeDes,"成功领取奖励",2);
		end
	else
		Common.showToast(profile.XYPlatformGiftBagExchange.getExchangeMsg(), 2);
	end
end

--[[--
--应答分享V2 IOS绑定好友关系
--]]
function processOPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND()
	if profile.ShareAwardRecipients.getBindFriendResult() == OPERATE_SUCCESS then
		--隐藏"邀请奖励"按钮 3：隐藏按钮
		profile.ShareAwardRecipients.setTouchButtonState(profile.ShareAwardRecipients.getTouchButtonStateList().NOT_SHOW);
--		UserInfoLogic.showOrHideInviteBtn();
		--刷新用户金币等
		sendDBID_USER_INFO(profile.User.getSelfUserID());
		--关闭界面

		local prizeList = profile.ShareAwardRecipients.getPrizeList();
		for i = 1, #prizeList do
			ImageToast.createView(prizeList[i].PrizeUrl,nil,prizeList[i].PrizeDes,"成功领取奖励",2);
		end
		RedGiftShareLogic.setIosBindRedGiftRewardState(true)
		close();
		CommShareConfig.selectRedGiftShareType()
	else
		Common.showToast(profile.ShareAwardRecipients.getBindFriendMsg(), 2);
	end
end

--[[--
--新玩家首次领取红包V3奖励
--]]
function newUserReceiveRedGiftReward()
  local rewardTable = profile.RedGiftShare.getOPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD()
  if rewardTable == nil then
    return
  end
  if rewardTable["Result"] == 1 then
    for i = 1, #rewardTable["RewardLoop"] do
      ImageToast.createView(rewardTable["RewardLoop"][i]["PrizeUrl"],nil, rewardTable["RewardLoop"][i]["PrizeDes"], "成功领取",  2)
    end
  elseif rewardTable["Result"] == 2 then
    Common.log("领奖失败！")
  end
end


--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(OPERID_XYPLATFORM_GIFTBAG_EXCHANGE, processOPERID_XYPLATFORM_GIFTBAG_EXCHANGE);
	framework.addSlot2Signal(OPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND, processOPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND);
	framework.addSlot2Signal(OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD, newUserReceiveRedGiftReward)
end

function removeSlot()
	framework.removeSlotFromSignal(OPERID_XYPLATFORM_GIFTBAG_EXCHANGE, processOPERID_XYPLATFORM_GIFTBAG_EXCHANGE);
	framework.removeSlotFromSignal(OPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND, processOPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND);
	framework.removeSlotFromSignal(OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD, newUserReceiveRedGiftReward)
end
