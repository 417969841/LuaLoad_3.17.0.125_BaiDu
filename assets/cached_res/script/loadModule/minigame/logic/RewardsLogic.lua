module("RewardsLogic",package.seeall)

view = nil;

--自定义参数
local miniGameType = 1 --小游戏类型 1 水果机 2 金皇冠  3...
--游戏类型
local FRUITMACHINE = 1 --水果机
local JINHUANGGUAN = 2 --金皇冠
local WANRENFURIT  = 3 --万人水果派
local WEIGHTSTATEONE = 1  --打赏第一次弹出框
local WEIGHTSTATETWO = 2  --打赏第二次弹出框
local rewardType = 1 --红包类型 1 小红包 2 大红包
local SMALLREWARD = 1 --小红包
local BIGREWARD = 2 --大红包
rewardWeightState = 1 --打赏控件类型 1 第一次弹框 2 第二次弹框 3...
rewardTypeInfo = {} --记录每个红包对应的信息

--UI参数
Panel_20 = nil;--背景panel
btn_left = nil;--小红包&确定
left_btnimage = nil;--左按钮图片
btn_right = nil;--大红包&取消
right_btnimage = nil;--右按钮图片
panel_bg = nil;--打赏panel
Label_messagelow = nil;--下label
Label_messagemid = nil;--中label
Label_head = nil;--上label


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
	btn_left = cocostudio.getUIButton(view, "btn_left");
	left_btnimage = cocostudio.getUIImageView(view, "left_btnimage");
	btn_right = cocostudio.getUIButton(view, "btn_right");
	right_btnimage = cocostudio.getUIImageView(view, "right_btnimage");
	panel_bg = cocostudio.getUIPanel(view, "panel_bg");
	Label_messagelow = cocostudio.getUILabel(view, "Label_messagelow");
	Label_messagemid = cocostudio.getUILabel(view, "Label_messagemid");
	Label_head = cocostudio.getUILabel(view, "Label_head");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("load_res/BegMachineAndDropCoin/Rewards.json")
	local gui = GUI_MINIGAME_REWARDS
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
	initData();
	rewardWeightState = WEIGHTSTATEONE
	setRewardWidgetVisibled()
end

--[[--
--初始化打赏页面信息
--]]
function initData()
	local dataTable = profile.MiniGameChat.getMiniGameRewardsInfoTable()
	Label_head:setText(dataTable["PromptOne"])
	Label_messagelow:setText(dataTable["PromptTwo"])
	local recordArray = Common.copyTab(dataTable.RewardMsg)
	for i = 1, #recordArray do
		rewardTypeInfo[dataTable["RewardMsg"][i].RewardType] = dataTable["RewardMsg"][i].RewardInfo
		Common.log("RewardType = "..dataTable["RewardMsg"][i].RewardType.."RewardInfo = "..dataTable["RewardMsg"][i].RewardInfo)
	end
end

--[[--
--控制控件是否可以显示触摸
--]]
function setRewardWidgetVisibled()
	if rewardWeightState == WEIGHTSTATEONE then
		Label_messagemid:setVisible(false)
	elseif rewardWeightState == WEIGHTSTATETWO then
		initSecondRewardWeightInfo()
	end
end

--[[--
--初始化第二次页面信息
--]]
function initSecondRewardWeightInfo()
	Label_messagemid:setText(rewardTypeInfo[rewardType])
	Label_messagemid:setVisible(true)
	Label_messagelow:setVisible(false)
	Label_head:setVisible(false)
	left_btnimage:loadTexture(CommonControl.CommonControlGetResource("ui_ok.png"))
	right_btnimage:loadTexture(CommonControl.CommonControlGetResource("ui_no.png"))
end

--[[--
--打赏结果
--]]
function miniGameRewardResultInfo()
	local resultInfo = profile.MiniGameChat.getMiniGameRewardResultInfo()
	local rewardResult = resultInfo.Successed
	if rewardResult ~= 0 then
		CommonControl.showRewardWordAnimation()
		collectCallBack(true)
	else
		Common.showToast("打赏失败", 2)
		collectCallBack(false)
	end

end

--[[--
--打赏回调回调
--]]
function collectCallBack(flag)
	if flag then
		if CommonControl.miniGameType == FRUITMACHINE then
			FruitMachineLogic.subDisplayCoin()
		elseif CommonControl.miniGameType == JINHUANGGUAN then
			JinHuangGuanLogic.subDisplayCoin()
		elseif CommonControl.miniGameType == WANRENFURIT then
			WanRenFruitMachineLogic.subDisplayCoin()
		end
	end
	BegMachineLogic.isShareEnabled = true
	BegMachineLogic.miniGameShare()
	mvcEngine.destroyModule(GUI_MINIGAME_REWARDS)
end

function requestMsg()

end

function callback_btn_left(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if rewardWeightState == WEIGHTSTATEONE then
			rewardWeightState = WEIGHTSTATETWO --打赏到第二次界面
			rewardType = SMALLREWARD	--设置红包类型
			setRewardWidgetVisibled() --显示打赏第二次页面
		elseif rewardWeightState == WEIGHTSTATETWO then
		Common.log("qwe............." .. CommonControl.miniGameType .. ".................rewardType=" .. rewardType)
			sendIMID_MINI_REWARDS_RESULT(CommonControl.miniGameType, rewardType)--获取打赏结果
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_right(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if rewardWeightState == WEIGHTSTATEONE then
			rewardWeightState = WEIGHTSTATETWO
			rewardType = BIGREWARD
			setRewardWidgetVisibled() --显示打赏第二次页面
		elseif rewardWeightState == WEIGHTSTATETWO then
			collectCallBack(false) --
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		collectCallBack(false)
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
	framework.addSlot2Signal(IMID_MINI_REWARDS_RESULT, miniGameRewardResultInfo)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(IMID_MINI_REWARDS_RESULT, miniGameRewardResultInfo)
end
