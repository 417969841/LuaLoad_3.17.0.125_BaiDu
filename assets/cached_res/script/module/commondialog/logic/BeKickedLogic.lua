module("BeKickedLogic",package.seeall)

view = nil

--整个窗口
panel = nil
--取消按钮
btn_item_close = nil
--开通vip/升级vip按钮
btn_item_buy_vip = nil
--开通vip/升级vip按钮的字
imageView_vip_text = nil
--VIP等级数字
labelAtlas_vip_number = nil
--踢人者昵称显示栏
label_nickname = nil
--踢人文字栏
label_bekick_text = nil
--下方被踢原因文字栏
label_why_bekick = nil
--建议文字栏
label_propose = nil
--建议玩家充值金额
money = nil
--被踢页面是否正在显示
local isShowBeKick = false


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
	view = cocostudio.createView("BeKicked.json")
	local gui = GUI_BE_KICKED_VIEW
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
	--设置弹出动画
	panel = cocostudio.getUIPanel(view, "Panel_22")
	LordGamePub.showDialogAmin(panel)
	--获取控件
	initBeKickedView()
	--设置控件的显示
	setBeKickedViewInfo()
end

function requestMsg()

end

function initBeKickedView()
	btn_item_close = cocostudio.getUIButton(view,"btn_item_close")
	btn_item_buy_vip = cocostudio.getUIButton(view,"btn_item_buy_vip")
	imageView_vip_text = cocostudio.getUIImageView(view,"ImageView_43")
	labelAtlas_vip_number = cocostudio.getUILabelAtlas(view, "LabelAtlas_64")
	label_nickname = cocostudio.getUILabel(view,"Label_29")
	label_bekick_text = cocostudio.getUILabel(view,"Label_27")
	label_why_bekick = cocostudio.getUILabel(view,"Label_39")
	label_propose = cocostudio.getUILabel(view,"Label_40")
end

function setBeKickedViewInfo()
	--获取踢人者的vipLevel
	local vipLevel = profile.TableKick.getBeKickVipLevel()
	--	local vipLevel = 145
	Common.log("setBeKickedViewInfo vipLevel is " .. vipLevel)
	--将vip等级数字设置到labelAtlas上
	local kickPlayerVipNumber = VIPPub.getUserVipType(vipLevel)
	labelAtlas_vip_number:setStringValue(kickPlayerVipNumber)
	--获取踢人者昵称
	local nickName = profile.TableKick.getBeKickNickName()
	--	local nickName = "你二舅"
	Common.log("setBeKickedViewInfo nickName is " .. nickName)
	--将踢人者昵称设置到页面上
	label_nickname:setText(nickName)
	--设置踢人信息文字
	label_bekick_text:setText("无情的把你踢出了房间")
	--取出玩家vip信息,并判断后设置下方文字与按钮图片
	if profile.User.getSelfVipLevel() > 0 then
		--如果玩家是VIP,则显示对方VIP等级并建议玩家充值,按钮图片用"升级VIP"
		--设置被踢出原因文字
		label_why_bekick:setText("您VIP等级没有对方高,所以才会被踢出房间。")
		--玩家需要变成VIP X (X比踢人者的vip等级高一级) 所需要的金额(元)
		local myVipNumber = VIPPub.getUserVipType(profile.User.getSelfVipLevel())
		money = VIPPub.getUserVipChaNeedMoney(kickPlayerVipNumber - myVipNumber + 1) - profile.User.getSelfAmount() / 100
		--设置文字建议
		label_propose:setText("再充值" .. money / GameConfig.MONEY_TO_YUANBAO .. "元即可提升至VIP" .. kickPlayerVipNumber + 1 .. ",享受【踢不动】的霸气体验!")
		--设置按钮图片
		imageView_vip_text:loadTexture(Common.getResourcePath("ui_room_2level_tiren_btn_shengjivip.png"))
	else
		--如果玩家不是VIP,则提示玩家不是VIP,并建议玩家充值到vip,按钮图片用"开通VIP"
		--设置被踢出原因文字
		label_why_bekick:setText("您还不是VIP,所以才会被踢出房间。")
		--玩家需要变成VIP1所需要的金额(元)
		money = VIPPub.getUserVipChaNeedMoney(1) - profile.User.getSelfAmount() / 100
		--设置文字建议
		label_propose:setText("充值" .. money / GameConfig.MONEY_TO_YUANBAO .. "元即可提升至VIP1,享受【踢不动】的霸气体验!")
		--设置按钮图片
		imageView_vip_text:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_vip.png"))
	end
end

function callback_btn_item_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		isShowBeKick = false
		mvcEngine.destroyModule(GUI_BE_KICKED_VIEW)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_item_buy_vip(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, money, RechargeGuidePositionID.TablePositionG)
	elseif component == CANCEL_UP then
	--取消
	end
end

function setIsShowBeKick(value)
	isShowBeKick = value
end

function getIsShowBeKick()
	return isShowBeKick
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
