module("BindPhoneLogic",package.seeall)

view = nil
local scene = nil
panel = nil
local flag = 0 --1绑定,2解绑,-1非手机绑定,-2非手机解绑
phonenumList = {}
local phone = 0
local operator = 0  ---运营商
sendmsg = nil

BindPhone = {}

--控件
lab_name = nil
lab_phone = nil
lab_yzm = nil
btn_getYZM = nil --获取验证码
btn_close = nil
btn_bind = nil
lab_content1 = nil
lab_content2 = nil
lab_Bind = nil
isUserPlayRoundMore10 = false
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
	view = cocostudio.createView("BindPhone.json")
	local gui = GUI_BINDPHONE
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

	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)
	scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(view)

	lab_name = cocostudio.getUILabel(view, "lab_name")
	lab_yzm = cocostudio.getUILabel(view, "lab_yzm")
	lab_phone = cocostudio.getUILabel(view, "lab_phone")
	btn_getYZM = cocostudio.getUIButton(view, "btn_getYZM")
--	btn_getYZM:setVisible(false)
--	btn_getYZM:setTouchEnabled(false)
	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_bind = cocostudio.getUIButton(view, "btn_bind")
	lab_content1 = cocostudio.getUILabel(view, "lab_content1")
	lab_content2 = cocostudio.getUILabel(view, "lab_content2")
	lab_Bind = cocostudio.getUILabel(view, "lab_Bind");
	initView()
end

function initView()
	local ydnum = 0
	local ltnum = 0
	local dxnum = 0
	local num = #phonenumList
	if(num > 2 ) then
		ydnum = phonenumList[1].SmsNumber
		ltnum = phonenumList[2].SmsNumber
		dxnum = phonenumList[3].SmsNumber
	end
	--flag = 1
	if(flag == 1) then
		--绑定手机
		lab_name:setText("绑定手机号")
		--lab_Bind:setVisible(true)
--		lab_phone:setText(phone.."(该号码为官方认证接收验证)")
		--lab_content1:setText("亲，现在绑定手机可马上获得2888金币哦！")
		--lab_content2:setText("点击‘确定’后系统将发送一条短信（0.1元，由运营商代收）完成绑定")
	elseif(flag == 2) then
		--解绑手机
		lab_name:setText("解绑手机号")
		--lab_phone:setText(phone.."(该号码为官方认证接收验证)")
		lab_content1:setText("解除绑定后，您将不再享受手机号找回密码功能。")
		--lab_content2:setText("点击‘确定’后系统将发送一条短信（0.1元，由运营商代收）完成解绑")
--		btn_getYZM:setTouchEnabled(false)
		--lab_Bind:setVisible(false)
--		btn_getYZM:setVisible(false)
		--lab_yzm:setText("JB")
	end
	if isUserPlayRoundMore10 == true then
		lab_content1:setText("大财主,绑定手机号能有效防止盗号等金币损失,绑定过程安全快捷！现在绑定还可以获得2888金币哦！")
	end
	sendMANAGERID_GET_BINDING_PHONE_RANDOM()
end
function requestMsg()

end

--绑定手机还是解绑手机  1绑定,2解绑,-1非手机绑定,-2非手机解绑
--手机号码list
--运营商
function setFlag(flagvalue,phonenumvalue,operatorvalue)
	flag = flagvalue
	phonenumList = phonenumvalue
	operator = operatorvalue
	local phonenumListlength = #phonenumList
	if(operator > 0 and phonenumListlength > 2) then
		phone = phonenumList[operator].SmsNumber
	end
end

--拦截弹框前出现的礼包
--table 牌桌用户信息
function stopShowHallGift()
	local num = profile.User.getSelfRound()--盘数
	if num >3 then
		return
	end
	sendDBID_GET_SMS_NUMBER()
	local CardCnt = 1
	for i = 1, TableConsole.getPlayerCnt() do
		CardCnt = TableConsole.getPlayer(TableConsole.getPlayerSeatByPos(i-1)).m_nCardCnt
		if  CardCnt == 0 and num == 2 then
			GameConfig.isShowHallGiftOrBindPhone = false
		end
	end
end

--1 2 打开发短信界面
-- -1 -2 关闭界面
function callback_btn_bind(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if sendmsg == nil or sendmsg == ""   then
			if flag == 1 then
				Common.showToast("请先获取验证码", 2)
				return
			end
		end
		if(flag == 1) then
			if(phone ~= "" and phone ~= nil and sendmsg ~= "" and sendmsg ~=nil ) then
				Common.log("绑定手机信息你发出"..phone..sendmsg)
				Common.sendSMSMessage(phone, sendmsg)
				Common.showToast("绑定手机信息已发出，请稍后", 2)
				----1000金币Toast
				local dataAward = profile.NewUserGuide.getNewUserAward();
				--ImageToast.createView(nil,Common.getResourcePath("ic_recharge_guide_jinbi.png"),"金币","x1000",2);
				close()
			end
		elseif(flag == 2) then
			if(phone ~= "" and phone ~= nil ) then
				Common.log("解绑定手机信息你发出"..phone)
				Common.sendSMSMessage(phone, "JB")
				Common.showToast("解除绑定手机信息已发出，请稍后", 2)
				close()
			end
		end

	elseif component == CANCEL_UP then
	--取消
	end
end
--关闭
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

function close()
	GameConfig.isShowHallGiftOrBindPhone = true
	LordGamePub.closeDialogAmin(panel,closePanel)
	BindPhoneConfig.showHallGift()
	BindPhoneConfig.isShowBindPhone = false
end

function closePanel()
	mvcEngine.destroyModule(GUI_BINDPHONE)
end
--获取验证码
function callback_btn_getYZM(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--短信随机码
		sendMANAGERID_GET_BINDING_PHONE_RANDOM()
	elseif component == CANCEL_UP then
	--取消
	end
end

function slot_BindMsg()
	sendmsg = profile.BindPhone.getBindPhoneMsg()
	--lab_yzm:setText(sendmsg)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	BindPhoneConfig.isShowBindPhone = false
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(MANAGERID_GET_BINDING_PHONE_RANDOM, slot_BindMsg)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(MANAGERID_GET_BINDING_PHONE_RANDOM, slot_BindMsg)

end
