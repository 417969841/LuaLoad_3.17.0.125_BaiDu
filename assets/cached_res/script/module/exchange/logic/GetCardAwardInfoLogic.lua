module("GetCardAwardInfoLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
txt_phonecheck = nil;--确认电话(用于输入)
label_phonecheck = nil;--确认电话(用于显示)
txt_id = nil;--身份证(用于输入)
label_id = nil;--身份证(用于显示)
txt_phone = nil;--电话(用于输入)
label_phone = nil;--电话(用于显示)
txt_username = nil;--用户名(用于输入)
label_username = nil;--用户名(用于显示)
btn_close = nil;--
btn_save = nil;--
currentTxtInput = nil; --当前文本输入框
currentTxtShow = nil; --当前文本显示
defaultValueLabelsTable ={}; --label的默认值table
defaultValueLabel = "";--label默认值
local isEnable_moibleByperson = false

local telNumber = nil
local telNumberComfirm = nil
local contactName = nil
local IDNumber = nil
local prizeID = nil
local prizeExchangeType = nil --充值卡兑换类型

local k_AwardCardLogic_Count = 4  --兑换话费页面4个输入框

local award_card_place_text = {"请输入手机号码", "再次确认手机号码", "请填写联系人", "请填写身份证号码"}

edit_awardcard_tab = {} --4个输入框


function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--设置
--]]
function setisEnable_moibleByperson()
	isEnable_moibleByperson = true
end
--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	panel = cocostudio.getUIPanel(view, "panel");

	txt_phonecheck = cocostudio.getUITextField(view, "txt_phonecheck");
	txt_phonecheck:setVisible(false);
	label_phonecheck = cocostudio.getUILabel(view, "Label_phonecheck");

	txt_id = cocostudio.getUITextField(view, "txt_id");
	txt_id:setVisible(false);
	label_id = cocostudio.getUILabel(view, "Label_id");

	txt_phone = cocostudio.getUITextField(view, "txt_phone");
	txt_phone:setVisible(false);
	label_phone = cocostudio.getUILabel(view, "Label_phone");

	txt_username = cocostudio.getUITextField(view, "txt_username");
	txt_username:setVisible(false);
	label_username = cocostudio.getUILabel(view, "Label_username");

	btn_close = cocostudio.getUIButton(view, "btn_close");
	btn_save = cocostudio.getUIButton(view, "btn_save");




	--屏蔽掉之前的输入框
	label_phone:setTouchEnabled(false)
	label_phonecheck:setTouchEnabled(false)
	label_id:setTouchEnabled(false)
	label_username:setTouchEnabled(false)

	txt_phone:setTouchEnabled(false)
	txt_phonecheck:setTouchEnabled(false)
	txt_id:setTouchEnabled(false)
	txt_username:setTouchEnabled(false)

	label_phone:setVisible(false)
	label_phonecheck:setVisible(false)
	label_username:setVisible(false)
	label_id:setVisible(false)

	--创建新的
	createCardAwardInfoEditor()
end

--创建新的输入框
function createCardAwardInfoEditor()
	for i = 1, k_AwardCardLogic_Count do
		local editBoxSize = CCSizeMake(302, 43)
	    edit_awardcard_tab[i] = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
	    edit_awardcard_tab[i]:setPosition(ccp(350, 456-(i-1)*79))
	    edit_awardcard_tab[i]:setAnchorPoint(ccp(0,0))
    	edit_awardcard_tab[i]:setFont("微软雅黑", 22)
    	edit_awardcard_tab[i]:setFontColor(ccc3(0xB3, 0x9C, 0x77))
	    edit_awardcard_tab[i]:setPlaceHolder(award_card_place_text[i])
	    edit_awardcard_tab[i]:setMaxLength(32)
	    edit_awardcard_tab[i]:setReturnType(kKeyboardReturnTypeDone)
	    edit_awardcard_tab[i]:setInputMode(kEditBoxInputModeSingleLine);
	    view:addChild(edit_awardcard_tab[i])
	end
	edit_awardcard_tab[3]:setPositionY(edit_awardcard_tab[3]:getPositionY()+10)
	edit_awardcard_tab[4]:setPositionY(edit_awardcard_tab[4]:getPositionY()+25)
	edit_awardcard_tab[1]:setInputMode(kEditBoxInputModePhoneNumber);
	edit_awardcard_tab[2]:setInputMode(kEditBoxInputModePhoneNumber);
	edit_awardcard_tab[4]:setInputMode(kEditBoxInputModePhoneNumber);
end


--[[--
--保存用于显示的label默认值
--]]
local function saveShowLabelsDefaultVlaue()
	defaultValueLabelsTable["phone"] = edit_awardcard_tab[1]:getText() --label_phone:getStringValue();--电话
	defaultValueLabelsTable["phoneCheck"] = edit_awardcard_tab[2]:getText() --label_phonecheck:getStringValue();--确认电话
	defaultValueLabelsTable["id"] = edit_awardcard_tab[3]:getText() --label_id:getStringValue();--身份证
	defaultValueLabelsTable["userName"] = edit_awardcard_tab[4]:getText() --label_username:getStringValue();--用户名
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("GetCardAwardInfo.json")
	local gui = GUI_GETCARDAWARDINFO
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

	if showViewType == 1 then

	else
		--保存用于显示的label默认值
		saveShowLabelsDefaultVlaue();
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
--用户名输入框(ios)
--]]
function callback_txt_username_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = txt_username;
		currentTxtShow = label_username;
		defaultValueLabel = defaultValueLabelsTable["userName"];
		Common.showAlertInput(txt_username:getStringValue(),0,true,callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--用户名输入框(Android)
--]]
function callback_txt_username(component)
	Common.log("component=====callback_txt_username===========" .. component);
	--控件不存在,return
	if label_username == nil then
		return;
	end

	if txt_username:getStringValue() ~= nil and txt_username:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_username:setText(txt_username:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["userName"] ~= nil then
			label_username:setText(defaultValueLabelsTable["userName"]);
		end
	end
end

--[[--
--电话输入框(ios)
--]]
function callback_txt_phone_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = txt_phone;
		currentTxtShow = label_phone;
		defaultValueLabel = defaultValueLabelsTable["phone"];
		Common.showAlertInput(txt_phone:getStringValue(),0,true,callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--电话输入框(Android)
--]]
function callback_txt_phone()
	--控件不存在,return
	if label_phone == nil then
		return;
	end

	if txt_phone:getStringValue() ~= nil and txt_phone:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_phone:setText(txt_phone:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["phone"] ~= nil then
			label_phone:setText(defaultValueLabelsTable["phone"]);
		end
	end
end

--[[--
--确认电话输入框(ios)
--]]
function callback_txt_phonecheck_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = txt_phonecheck;
		currentTxtShow = label_phonecheck;
		defaultValueLabel = defaultValueLabelsTable["phoneCheck"];
		Common.showAlertInput(txt_phonecheck:getStringValue(),0,true,callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--确认电话输入框(Android)
--]]
function callback_txt_phonecheck()
	--控件不存在,return
	if label_phonecheck == nil then
		return;
	end

	if txt_phonecheck:getStringValue() ~= nil and txt_phonecheck:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_phonecheck:setText(txt_phonecheck:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["phoneCheck"] ~= nil then
			label_phonecheck:setText(defaultValueLabelsTable["phoneCheck"]);
		end
	end
end

--[[--
--身份证输入框(ios)
--]]
function callback_txt_id_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = txt_id;
		currentTxtShow = label_id;
		defaultValueLabel = defaultValueLabelsTable["id"];
		Common.showAlertInput(txt_id:getStringValue(),0,true,callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--身份证输入框(Android)
--]]
function callback_txt_id()
	--控件不存在,return
	if label_id == nil then
		return;
	end

	if txt_id:getStringValue() ~= nil and txt_id:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_id:setText(txt_id:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["id"] ~= nil then
			label_id:setText(defaultValueLabelsTable["id"]);
		end
	end
end

function requestMsg()

end

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

function callback_btn_save(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		telNumber = edit_awardcard_tab[1]:getText() --txt_phone:getStringValue()
		telNumberComfirm = edit_awardcard_tab[2]:getText() --txt_phonecheck:getStringValue()
		contactName = edit_awardcard_tab[3]:getText() --txt_username:getStringValue()
		IDNumber = edit_awardcard_tab[4]:getText() --txt_id:getStringValue()

		if telNumber ~= nil and telNumber ~= "" and telNumberComfirm ~= nil and telNumberComfirm ~= "" and contactName ~= nil and contactName ~= "" and IDNumber ~= nil and IDNumber ~= "" then
			if telNumber ~= telNumberComfirm then
				Common.showToast("手机号码不同,请确认", 2)
			elseif string.len(IDNumber) ~= 15 and string.len(IDNumber) ~= 18 then
				Common.showToast("请正确输入身份证号", 2)
			else
				if prizeExchangeType ~= nil then
					local dataTable = {}
					dataTable.PrizeID = prizeID
					dataTable.ContactName = contactName
					dataTable.TelNumber = telNumber
					dataTable.IDNumber = IDNumber
					Common.log("sendOPERID_PRIZE_EXCHANGE_MOBILE_FARE")
--					sendOPERID_PRIZE_EXCHANGE_MOBILE_FARE(dataTable)
					sendMANAGERID_EXCHANGE_AWARD(0, contactName,telNumber,0,0,tonumber(prizeID))
					close()
				elseif prizeID ~= nil then
					local dataTable = {}
					dataTable.PrizeID = prizeID
					dataTable.ContactName = contactName
					dataTable.TelNumber = telNumber
					dataTable.IDNumber = IDNumber
					Common.log("sendOPERID_PRIZE_EXCHANGE_MOBILE_FARE")
					sendMANAGERID_EXCHANGE_AWARD(0, contactName,telNumber,0,0,tonumber(prizeID))
--					sendOPERID_PRIZE_EXCHANGE_MOBILE_FARE(dataTable)
					close()
				end
					if isEnable_moibleByperson == true then
					isEnable_moibleByperson = false
--					sendRechargeable_Card_AWARD_V2(prizeID, contactName, telNumber)
					sendMANAGERID_EXCHANGE_AWARD(tonumber(prizeID),contactName,telNumber,0,0,0)
					Common.log("sendRechargeable_Card_AWARD_V2")
					end
			end
		else
			Common.showToast("请将资料填写完整", 2)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

----------------------------手机充值卡-----------------------------




--关闭
function close()
	LordGamePub.closeDialogAmin(Panel_20,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_GETCARDAWARDINFO)
end

function setValue(prizeIDV)
	prizeID = prizeIDV
end



--[[--
--释放界面的私有数据
--]]
function releaseData()
	prizeID = nil
end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
