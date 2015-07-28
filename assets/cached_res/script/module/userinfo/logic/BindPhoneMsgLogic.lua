module("BindPhoneMsgLogic",package.seeall)

view = nil
local scene = nil
panel  = nil
local flag = 0 --1绑定,2解绑,-1非手机绑定,-2非手机解绑
phonenumList = {}
local phone = 0
local operator = 0  ---运营商
sendmsg = nil
local flag_init = nil
BindPhone = {}
local flag_solt_msg = nil
--控件
lab_msg = nil
lab_bindingtext = nil;--
Label_Binding = nil;--
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
	view = cocostudio.createView("BindPhoneMsg.json")
	local gui = GUI_BINDPHONEMSG
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
	view:setVisible(false)
	lab_msg = cocostudio.getUILabel(view, "lab_msg")
	if(flag == -1) then
		--短信随机码
		sendMANAGERID_GET_BINDING_PHONE_RANDOM()
	elseif(flag == -2) then
		initView()
	end
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
function callback_btn_ok()
	LordGamePub.closeDialogAmin(panel,close)
end

function close()
	GameConfig.isShowHallGiftOrBindPhone = true
	mvcEngine.destroyModule(GUI_BINDPHONEMSG)
	BindPhoneConfig.showHallGift()
	BindPhoneConfig.isShowBindPhone = false
end
function initView()
	lab_bindingtext = cocostudio.getUILabel(view, "lab_bindingtext");
	Label_Binding = cocostudio.getUILabel(view, "Label_Binding");
	view:setVisible(true)
	flag_init = 1
	local ydnum = 0
	local ltnum = 0
	local dxnum = 0
	local num = #phonenumList
	if(num > 2 ) then
		ydnum = phonenumList[1].SmsNumber
		ltnum = phonenumList[2].SmsNumber
		dxnum = phonenumList[3].SmsNumber
	end

	if(flag == -1) then
		--非手机绑定
		lab_msg:setText("您可以使用手机发送短信内容"..sendmsg.."，移动用户发送至"..ydnum.."，联通用户发送至"..ltnum.."，电信用户发送至"..dxnum.."，完成绑定。")
	elseif(flag == -2) then
		--非手机解绑
		Label_Binding:setText("解绑手机号")
		lab_bindingtext:setText("系统检测到您当前设备不支持发送短信。")
		lab_msg:setText("您可以使用手机发送短信内容JB，移动用户发送至"..ydnum.."，联通用户发送至"..ltnum.."，电信用户发送至"..dxnum.."，完成解绑。")
	end
end
function slot_BindMsg()

	sendmsg = profile.BindPhone.getBindPhoneMsg()
	initView()

end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	flag_init = nil
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
