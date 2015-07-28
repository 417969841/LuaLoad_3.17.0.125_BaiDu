module("RedGiftShareLogic",package.seeall)

view = nil;

--自定义变量
local isIosBindRedGiftReward = false --是否是IOS绑定红包领奖
local isSelect = nil --分享类型 false 分享到好友 true 分享到朋友圈
local showTitle = nil --分享标题
local showText = nil --分享内容
hieseIsClicked = false --红包界面是否被点击过
theUITypeOfShow = nil --显示界面的类型
local THEFIRSTSHAREA = 1 --A用户首次分享出现红包
local THESECONDSHAREA = 2 --A用户点击红包后
local THETHIRDSHAREB = 3 --B用户点击红包后


Panel_14 = nil;--
Panel_hiese = nil;--遮罩层
Image_guang = nil;--
Button_back = nil;--
Image_shou = nil;--
Image_hongbao = nil;--
Image_guangban = nil;--
Image_toubu = nil;--
Image_shuoming = nil;--
Label_dibuwenzi = nil;--
Label_smwzheng = nil;--
Image_jinbi = nil;--
Image_fenxiang = nil;--
Label_kylingqu = nil;--
Label_giftName = nil;--
Image_friendshare = nil;----
Image_rewardaword = nil;--
Image_ToFriends = nil;--
Image_ToCircle = nil;--


function onKeypad(event)
	if event == "backClicked" then
		--返回键
		if theUITypeOfShow == THEFIRSTSHAREA then
			mvcEngine.destroyModule(GUI_RED_GIFT_SHARE)
		elseif theUITypeOfShow == THESECONDSHAREA then
			mvcEngine.createModule(GUI_RED_GIFT_SHARE_CONFIRM)
		elseif theUITypeOfShow == THETHIRDSHAREB then
			mvcEngine.destroyModule(GUI_RED_GIFT_SHARE)
		end
		if CommShareConfig.isNewUserEnabled == true then
			CommShareConfig.isNewUserEnabled = false
		end
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_hiese = cocostudio.getUIPanel(view, "Panel_hiese");
	Image_guang = cocostudio.getUIImageView(view, "Image_guang");
	Button_back = cocostudio.getUIButton(view, "Button_back");
	Image_shou = cocostudio.getUIImageView(view, "Image_shou");
	Image_hongbao = cocostudio.getUIImageView(view, "Image_hongbao");
	Image_guangban = cocostudio.getUIImageView(view, "Image_guangban");
	Image_toubu = cocostudio.getUIImageView(view, "Image_toubu");
	Image_shuoming = cocostudio.getUIImageView(view, "Image_shuoming");
	Label_dibuwenzi = cocostudio.getUILabel(view, "Label_dibuwenzi");
	Label_smwzheng = cocostudio.getUILabel(view, "Label_smwzheng");
	Image_jinbi = cocostudio.getUIImageView(view, "Image_jinbi");
	Image_fenxiang = cocostudio.getUIImageView(view, "Image_fenxiang");
	Label_kylingqu = cocostudio.getUILabel(view, "Label_kylingqu");
	Label_giftName = cocostudio.getUILabel(view, "Label_giftName");
	Image_friendshare = cocostudio.getUIImageView(view, "Image_25");
	Image_rewardaword = cocostudio.getUIImageView(view, "Image_rewardaword");
	Image_ToFriends = cocostudio.getUIButton(view, "Image_ToFriends");
	Image_ToCircle = cocostudio.getUIButton(view, "Image_ToCircle");
end


--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("RedGiftShare.json")
	local gui = GUI_RED_GIFT_SHARE
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
	GameConfig.setTheCurrentBaseLayer(GUI_RED_GIFT_SHARE)
	CCDirector:sharedDirector():getRunningScene():addChild(view)

	initView();
	initData()
end

function initData()
	isSelect = true
	hieseIsClicked = false
	showTitle = "红包来了！最高可开出1000元话费的超爽红包（保底两元）倾情放送！"
	showText = "年度最佳斗地主，包含多种趣味小游戏。来就送话费，来就有！绝对的业界良心，卖血发福利，正版官方认证！来，点我？"
	local redGiftBaseInfoTable = CommShareConfig.getRedGiftShareBaseInfo()

	if redGiftBaseInfoTable ~= nil then
		--初始化奖励文本
		Label_giftName:setText(redGiftBaseInfoTable.OldRewardText)
		--初始化退出奖励文本
		RedGiftComfirmLogic.setConfirmLableText(redGiftBaseInfoTable.OldRewardQuitText)
	end
	--隐藏全部控件
	setAllUIVisibleHide()

	if isIosBindRedGiftReward == true and Common.platform == Common.TargetIos then
		theUITypeOfShow = THETHIRDSHAREB
		setNewUserFirstShareUIVisibled()
		isIosBindRedGiftReward = false
		hieseIsClicked = true
		if CommShareConfig.isNewUserEnabled == true then
			CommShareConfig.isNewUserEnabled = false
		end
	else
		--设置分享首次需要显示的控件
		setFirstShareUIVisibled()
	end
end

function setUIVisibledByProgress(progressType)
	theUITypeOfShow = progressType
end

--[[--
--隐藏当前界面所有控件
--]]
function setAllUIVisibleHide()
	Image_shou:stopAllActions()
	Image_guang:setVisible(false)
	Image_shou:setVisible(false)
	Image_hongbao:setVisible(false)
	Image_guangban:setVisible(false)
	Image_toubu:setVisible(false)
	Image_shuoming:setVisible(false)
	Label_dibuwenzi:setVisible(false)
	Label_smwzheng:setVisible(false)
	Image_jinbi:setVisible(false)
	Image_fenxiang:setVisible(false)
	Label_kylingqu:setVisible(false)
	Label_giftName:setVisible(false)
	Image_rewardaword:setVisible(false)
	Image_ToFriends:setVisible(false)
	Image_ToCircle:setVisible(false)
	Image_friendshare:setVisible(false)
end

--[[--
--显示老用户点击红包后的控件
--]]
function setSecondShareUIVisibled()
	CommShareConfig.isNewUserBLoginShare = false
	Image_rewardaword:setVisible(true)
	Image_guang:setVisible(true)
	Label_giftName:setVisible(true)
	Image_jinbi:setVisible(true)
	Label_kylingqu:setVisible(true)
	Image_friendshare:setVisible(true)
	Image_ToFriends:setVisible(true)
	Image_ToCircle:setVisible(true)
	Image_friendshare:setVisible(true)
end

--[[--
--显示红包界面
--]]
function setFirstShareUIVisibled()
	Image_toubu:setVisible(true)
	Image_shuoming:setVisible(true)
	Image_hongbao:setVisible(true)
	Label_dibuwenzi:setVisible(true)
	Image_shou:setVisible(true)
	Image_guangban:setVisible(true)
	runHandClickAnimation()
end

--[[--
--显示新用户首次点击红包后的控件
--]]
function setNewUserFirstShareUIVisibled()
	CommShareConfig.isNewUserBLoginShare = true
	Image_hongbao:setVisible(true)
	Label_smwzheng:setVisible(true)
	Image_fenxiang:setVisible(true)
	Image_friendshare:setVisible(true)
	Image_ToFriends:setVisible(true)
	Image_ToCircle:setVisible(true)
	Image_friendshare:setVisible(true)
end


function requestMsg()

end

function callback_Panel_14(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--红包界面被点击
--]]
function callback_Panel_hiese(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if hieseIsClicked == false then
			if CommShareConfig.isNewUserEnabled == true and  Common.getIntroducerID() ~= 0 then
				--没有领新手红包
				theUITypeOfShow = THETHIRDSHAREB
				setAllUIVisibleHide()
				setNewUserFirstShareUIVisibled()
				--请求新用户红包奖励
				sendOPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD()
				CommShareConfig.isNewUserEnabled = false
			else
				--已经领过新手红包
				theUITypeOfShow = THESECONDSHAREA
				setAllUIVisibleHide()
				setSecondShareUIVisibled()
			end
		end
		hieseIsClicked = true
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_back(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if theUITypeOfShow == THEFIRSTSHAREA then
			mvcEngine.destroyModule(GUI_RED_GIFT_SHARE)
		elseif theUITypeOfShow == THESECONDSHAREA then
			mvcEngine.createModule(GUI_RED_GIFT_SHARE_CONFIRM)
		elseif theUITypeOfShow == THETHIRDSHAREB then
			mvcEngine.destroyModule(GUI_RED_GIFT_SHARE)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_ToFriends(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		isSelect = false
		clickShare()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_ToCircle(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		isSelect = true
		clickShare()
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--设置IOS红包奖励状态
--]]
function setIosBindRedGiftRewardState(flag)
	isIosBindRedGiftReward = flag
end

--[[--
--获得IOS红包奖励状态
--]]
function getIosBindRedGiftRewardState()
	if isIosBindRedGiftReward == nil then
		isIosBindRedGiftReward = false
	end
	return isIosBindRedGiftReward
end

--[[--
--分享
--]]
function clickShare()
	LordGamePub.shareToWX(isSelect, showTitle, showText)
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
--新用户首次红包分享领取奖励结果
--]]
function getNewUserFirstSharingReward()
	local rewardTable = profile.RedGiftShare.getOPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD()
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
--小手点击动画
--]]
function runHandClickAnimation()
	--  Image_shou
	local scaleBig = CCScaleTo:create(0.16, 1.5)
	local scaleSmall = CCScaleTo:create(0.16, 1)
	local array = CCArray:create()
	array:addObject(CCCallFunc:create(
		function()
			Image_guangban:setVisible(false)
		end
	))
	array:addObject(scaleBig)
	array:addObject(CCCallFunc:create(
		function()
			Image_guangban:setVisible(true)
		end
	))
	array:addObject(scaleSmall)
	local seq = CCSequence:create(array)
	Image_shou:runAction(CCRepeatForever:create(seq))
end

--[[--
--关闭界面
--]]
function close()
	mvcEngine.destroyModule(GUI_RED_GIFT_SHARE)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	theUITypeOfShow = nil
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD, newUserReceiveRedGiftReward)
	framework.addSlot2Signal(OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD, getNewUserFirstSharingReward)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD, newUserReceiveRedGiftReward)
	framework.removeSlotFromSignal(OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD, getNewUserFirstSharingReward)
end
