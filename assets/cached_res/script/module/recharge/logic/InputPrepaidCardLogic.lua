module("InputPrepaidCardLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_Bg = nil;--
Button_Ok = nil;--
label_card_number = nil;--
tf_card_number = nil;--
label_tf_password = nil;--
tf_password = nil;--
Label_Carriers = nil;--
Label_YuanBao = nil;--
Label_CardNumber = nil;--
Label_passwordnumber = nil;--
Button_Close = nil;--
defaultValueLabelsTable = {};
currentTxtInput = nil;
currentTxtShow = nil;
defaultValueLabel = "";
RechargeCardInfoTable = {};

-- 支付渠道编码
local YIDONG_FRPID = "SZX";
local LIANTONG_FRPID = "UNICOM";
local DIANXIN_FRPID = "TELECOM";

--[[--
--关闭弹出框
--]]
local function closeTheBox()
	mvcEngine.destroyModule(GUI_INPUTPREPAIDCARD);
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
	local gui = GUI_INPUTPREPAIDCARD;
	view = cocostudio.createView("InputPrepaidCard.json");
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
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_Bg = cocostudio.getUIPanel(view, "Panel_Bg");
	Button_Ok = cocostudio.getUIButton(view, "Button_Ok");
	label_card_number = cocostudio.getUILabel(view, "label_card_number");
	tf_card_number = cocostudio.getUITextField(view, "tf_card_number");
	label_tf_password = cocostudio.getUILabel(view, "label_tf_password");
	tf_password = cocostudio.getUITextField(view, "tf_password");
	Label_Carriers = cocostudio.getUILabel(view, "Label_Carriers");
	Label_YuanBao = cocostudio.getUILabel(view, "Label_YuanBao");
	Label_CardNumber = cocostudio.getUILabel(view, "Label_CardNumber");
	Label_passwordnumber = cocostudio.getUILabel(view, "Label_passwordnumber");
	Button_Close = cocostudio.getUIButton(view, "Button_Close");
	tf_card_number:setVisible(false);
	tf_password:setVisible(false);
end

function initData()
	if RechargeCardInfoTable ~= nil then
		if RechargeCardInfoTable.Pd_frpId == YIDONG_FRPID then
			Label_Carriers:setText("中国移动" .. RechargeCardInfoTable.price / 100 .. "元");
		elseif RechargeCardInfoTable.Pd_frpId == LIANTONG_FRPID then
			Label_Carriers:setText("中国联通" .. RechargeCardInfoTable.price / 100 .. "元");
		else
			Label_Carriers:setText("中国电信" .. RechargeCardInfoTable.price / 100 .. "元");
		end
	end
	Label_YuanBao:setText(RechargeCardInfoTable.goodsName);
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);

	initView();
	LordGamePub.showDialogAmin(Panel_Bg)
	saveShowLabelsDefaultVlaue();
	initData();
end

function requestMsg()

end

--[[--
--设置值
--@param #table data description
--]]
function setValue(data)
	RechargeCardInfoTable = data;
end

--[[--
--保存用于显示的label默认值
--]]
function saveShowLabelsDefaultVlaue()
	defaultValueLabelsTable["cardNumber"] = label_card_number:getStringValue();--卡号
	defaultValueLabelsTable["password"] = label_tf_password:getStringValue();--密码
end

local function logicRechargeCard()
	local isTure = false;
	if RechargeCardInfoTable.Pa8_cardNo == "" then
		Common.showDialog("充值卡号不能为空！")
	elseif RechargeCardInfoTable.Pa9_cardPwd == "" then
		Common.showDialog("充值卡密码不能为空！")
	else
		if string.len(RechargeCardInfoTable.Pa8_cardNo) > 10 and string.len(RechargeCardInfoTable.Pa9_cardPwd) > 10 then
			isTure = true;
		else
			Common.showDialog("充值卡号或密码有误，请检查！")
		end
	end
	return isTure
end

function callback_Button_Ok(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if RechargeCardInfoTable == nil then
			return;
		end
		if RechargeCardInfoTable.Pd_frpId == nil or RechargeCardInfoTable.Pd_frpId == "" then
			Common.showToast("请选择充值卡金额", 2)
			return
		end
		RechargeCardInfoTable.Pa8_cardNo = label_card_number:getStringValue()
		RechargeCardInfoTable.Pa9_cardPwd = label_tf_password:getStringValue()

		Common.log("RechargeCardInfoTable.Pa8_cardNo == "..RechargeCardInfoTable.Pa8_cardNo)
		Common.log("RechargeCardInfoTable.Pa9_cardPwd == "..RechargeCardInfoTable.Pa9_cardPwd)
		Common.log("RechargeCardInfoTable.Pd_frpId == "..RechargeCardInfoTable.Pd_frpId)
		if logicRechargeCard() then
			local isExchange = false
			PaymentMethod.callPayment(RechargeCardInfoTable, profile.PayChannelData.RECHARGE_CARD_PAY,0,isExchange,0)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Close(component)
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
--ios输入框回调
--]]
function callbackInputForIos(valuetable)
	--控件不能为空
	if currentTxtInput == nil or currentTxtShow == nil then
		return;
	end

	local value = valuetable["value"];
	--输入数据为空, return
	if value == nil or value == "" then
		if defaultValueLabel ~= nil then
			--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
			currentTxtShow:setText(defaultValueLabel);
		end
		return;
	end

	--如果用户输入内容,则将输入的内容赋给显示的label
	currentTxtInput:setText(value);
	currentTxtShow:setText(value);
end

--[[--
--充值卡卡号输入框(ios)
--]]
function callback_tf_card_number_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = tf_card_number;
		currentTxtShow = label_card_number;
		defaultValueLabel = defaultValueLabelsTable["cardNumber"];
		Common.showAlertInput(tf_card_number:getStringValue(),0,true,callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--充值卡卡号输入框(Android)
--]]
function callback_tf_card_number()
	--控件不存在,return
	if label_card_number == nil then
		return;
	end

	if tf_card_number:getStringValue() ~= nil and tf_card_number:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_card_number:setText(tf_card_number:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["cardNumber"] ~= nil then
			label_card_number:setText(defaultValueLabelsTable["cardNumber"]);
		end
	end
end

--[[--
--充值卡密码输入框(ios)
--]]
function callback_tf_password_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = tf_password;
		currentTxtShow = label_tf_password;
		defaultValueLabel = defaultValueLabelsTable["password"];
		Common.showAlertInput(tf_password:getStringValue(),0,true,callbackTfPassword)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--充值卡密码输入框(Android)
--]]
function callback_tf_password()
	--控件不存在,return
	if label_tf_password == nil then
		return;
	end

	if tf_password:getStringValue() ~= nil and tf_password:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_tf_password:setText(tf_password:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["password"] ~= nil then
			label_tf_password:setText(defaultValueLabelsTable["password"]);
		end
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
