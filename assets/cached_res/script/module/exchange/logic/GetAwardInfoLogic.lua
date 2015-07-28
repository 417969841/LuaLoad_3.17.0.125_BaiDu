module("GetAwardInfoLogic",package.seeall)

view = nil

--控件
txt_username = nil--姓名(用于输入)
label_username = nil--姓名(用于显示)
txt_phone = nil--电话(用于输入)
label_phone = nil--电话(用于显示)
txt_address = nil--地址(用于输入)
label_address = nil--地址(用于显示)
txt_email = nil --邮编(用于输入)
label_email = nil --邮编(用于显示)
btn_save = nil
btn_cancel = nil
btn_duihuan = nil
btn_close = nil
panel = nil

currentTxtInput = nil; --当前文本输入框
currentTxtShow = nil; --当前文本显示
defaultValueLabelsTable ={}; --label的默认值table
defaultValueLabel = "";--label默认值

local goodID = nil
local userID = nil
local flag = nil


local k_AwardInfoLogic_Count = 4  --兑换信息页面4个输入框

local award_place_text = {"收件人", "联系电话", "邮寄地址", "邮政编码"}

edit_awardinfo_tab = {} --4个输入框



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
	txt_username = cocostudio.getUITextField(view,"txt_username");
	txt_username:setVisible(false);
	label_username = cocostudio.getUILabel(view,"Label_username");

	txt_phone = cocostudio.getUITextField(view,"txt_phone");
	txt_phone:setVisible(false);
	label_phone = cocostudio.getUILabel(view,"Label_phone");

	txt_address = cocostudio.getUITextField(view,"txt_address");
	txt_address:setVisible(false);
	label_address = cocostudio.getUILabel(view,"Label_address");

	txt_email = cocostudio.getUITextField(view,"txt_email");
	txt_email:setVisible(false);
	label_email = cocostudio.getUILabel(view,"Label_email");

	btn_save = cocostudio.getUIButton(view, "btn_save")
	btn_cancel = cocostudio.getUIButton(view, "btn_cancel")
	btn_duihuan = cocostudio.getUIButton(view, "btn_duihuan")
	btn_close = cocostudio.getUIButton(view, "btn_close")
	--重新填写和兑换按钮不可用
	btn_cancel:setVisible(false)
	btn_cancel:setTouchEnabled(false)
	btn_duihuan:setVisible(false)
	btn_duihuan:setTouchEnabled(false)

	--屏蔽掉之前的输入框
	txt_username:setTouchEnabled(false)
	txt_phone:setTouchEnabled(false)
	txt_address:setTouchEnabled(false)
	txt_email:setTouchEnabled(false)
	label_username:setTouchEnabled(false)
	label_phone:setTouchEnabled(false)
	label_address:setTouchEnabled(false)
	label_email:setTouchEnabled(false)

	label_username:setVisible(false)
	label_phone:setVisible(false)
	label_address:setVisible(false)
	label_email:setVisible(false)


	--创建新的
	createAwardInfoEditor()
end

--创建新的输入框
function createAwardInfoEditor()
	for i = 1, k_AwardInfoLogic_Count do
		local editBoxSize = CCSizeMake(302, 43)
	    edit_awardinfo_tab[i] = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
	    edit_awardinfo_tab[i]:setPosition(ccp(376, 456-(i-1)*79))
	    edit_awardinfo_tab[i]:setAnchorPoint(ccp(0,0))
    	edit_awardinfo_tab[i]:setFont("微软雅黑", 22)
    	edit_awardinfo_tab[i]:setFontColor(ccc3(0xB3, 0x9C, 0x77))
	    edit_awardinfo_tab[i]:setPlaceHolder(award_place_text[i])
	    edit_awardinfo_tab[i]:setMaxLength(32)
	    edit_awardinfo_tab[i]:setReturnType(kKeyboardReturnTypeDone)
	    edit_awardinfo_tab[i]:setInputMode(kEditBoxInputModeSingleLine);
	    view:addChild(edit_awardinfo_tab[i])
	end
	edit_awardinfo_tab[1]:setPositionY(edit_awardinfo_tab[1]:getPositionY()-5)
	edit_awardinfo_tab[4]:setPositionY(edit_awardinfo_tab[4]:getPositionY()+10)

	edit_awardinfo_tab[2]:setInputMode(kEditBoxInputModePhoneNumber); 
	edit_awardinfo_tab[4]:setInputMode(kEditBoxInputModePhoneNumber); 
end

--[[--
--保存用于显示的label默认值
--]]
local function saveShowLabelsDefaultVlaue()
	defaultValueLabelsTable["userName"] = edit_awardinfo_tab[1]:getText() --label_username:getStringValue();--用户名
	defaultValueLabelsTable["phone"] = edit_awardinfo_tab[2]:getText() --label_phone:getStringValue();--电话
	defaultValueLabelsTable["address"] = edit_awardinfo_tab[3]:getText() --label_address:getStringValue();--地址
	defaultValueLabelsTable["email"] = edit_awardinfo_tab[4]:getText() --label_email:getStringValue();--email
end

--[[--
--初始化兑奖信息
--]]
local function initAwardInfo()
	userID = profile.User.getSelfUserID();

	local username = Common.getDataForSqlite(CommSqliteConfig.SendAwardUsername..userID);
	if username ~= nil then
		txt_username:setText(username);
		label_username:setText(username);
	end

	local phone = Common.getDataForSqlite(CommSqliteConfig.SendAwardPhone..userID);
	if phone ~= nil then
		txt_phone:setText(phone);
		label_phone:setText(phone);
	end

	local address = Common.getDataForSqlite(CommSqliteConfig.SendAwardAddress..userID);
	if address ~= nil then
		txt_address:setText(address);
		label_address:setText(address);
	end

	local email = Common.getDataForSqlite(CommSqliteConfig.SendAwardEmail..userID);
	if email ~= nil then
		txt_email:setText(email);
		label_email:setText(email);
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("GetAwardInfo.json")
	local gui = GUI_GETAWARDINFO
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
	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)

	--初始化控件
	initView();
	--保存用于显示的label默认值
	saveShowLabelsDefaultVlaue();
	--初始化兑奖信息
	initAwardInfo();
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
function callback_txt_username()
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
--地址输入框(ios)
--]]
function callback_txt_address_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = txt_address;
		currentTxtShow = label_address;
		defaultValueLabel = defaultValueLabelsTable["address"];
		Common.showAlertInput(txt_address:getStringValue(),0,true,callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--地址输入框(Android)
--]]
function callback_txt_address()
	--控件不存在,return
	if label_address == nil then
		return;
	end

	if txt_address:getStringValue() ~= nil and txt_address:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_address:setText(txt_address:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["address"] ~= nil then
			label_address:setText(defaultValueLabelsTable["address"]);
		end
	end
end

--[[--
--email输入框(ios)
--]]
function callback_txt_email_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = txt_email;
		currentTxtShow = label_email;
		defaultValueLabel = defaultValueLabelsTable["email"];
		Common.showAlertInput(txt_email:getStringValue(),0,true,callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--email输入框(Android)
--]]
function callback_txt_email()
	--控件不存在,return
	if label_email == nil then
		return;
	end

	if txt_email:getStringValue() ~= nil and txt_email:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_email:setText(txt_email:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["email"] ~= nil then
			label_email:setText(defaultValueLabelsTable["email"]);
		end
	end
end


function requestMsg()

end

function setGoodID(goodidvalue,flagV)
	flag = flagV
	goodID = goodidvalue
end
--关闭
function callback_btn_back(component)
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
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_GETAWARDINFO)
end
--保存信息
function callback_btn_save(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local username = edit_awardinfo_tab[1]:getText() --txt_username:getStringValue()
		local phonenum = edit_awardinfo_tab[2]:getText() --txt_phone:getStringValue()
		local address = edit_awardinfo_tab[3]:getText() --txt_address:getStringValue()
		local email = edit_awardinfo_tab[4]:getText() --txt_email:getStringValue()
		if username == "" or
		   phonenum == "" or
		   address == "" or
		   email == "" then
			Common.showToast("请将信息填写完整", 2)
		else
			--保存信息
			Common.setDataForSqlite(CommSqliteConfig.SendAwardUsername..userID, username)
			Common.setDataForSqlite(CommSqliteConfig.SendAwardPhone..userID, phonenum)
			Common.setDataForSqlite(CommSqliteConfig.SendAwardAddress..userID, address)
			Common.setDataForSqlite(CommSqliteConfig.SendAwardEmail..userID, email)

			btn_cancel:setVisible(true)
			btn_cancel:setTouchEnabled(true)
			btn_duihuan:setVisible(true)
			btn_duihuan:setTouchEnabled(true)
			btn_save:setVisible(false)
			btn_save:setTouchEnabled(false)
			txt_username:setTouchEnabled(false)
			txt_phone:setTouchEnabled(false)
			txt_address:setTouchEnabled(false)
			txt_email:setTouchEnabled(false)

			for i = 1, k_AwardInfoLogic_Count do
	    		edit_awardinfo_tab[i]:setTouchEnabled(false)
	    		--edit_awardinfo_tab[i]:setVisible(false)
	    	end
		end
	elseif component == CANCEL_UP then
	--取消
	end
end
--兑换
function callback_btn_duihuan(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起

		local username = edit_awardinfo_tab[1]:getText() --label_username:getStringValue()
		local phonenum = edit_awardinfo_tab[2]:getText() --label_phone:getStringValue()
		local address = edit_awardinfo_tab[3]:getText() --label_address:getStringValue()
		local email = edit_awardinfo_tab[4]:getText() --label_email:getStringValue()
		--1是兑奖券兑奖
		if flag == 1 then
			sendMANAGERID_EXCHANGE_AWARD(tonumber(goodID),username,phonenum,email,address,0)
		else
			sendMANAGERID_EXCHANGE_AWARD(0,username,phonenum,email,address,tonumber(goodID))
		end
		Common.showToast("请求已发出，请稍后", 2)
		mvcEngine.destroyModule(GUI_GETAWARDINFO)

	elseif component == CANCEL_UP then
	--取消
	end
end
--重新填写
function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		btn_cancel:setVisible(false)
		btn_cancel:setTouchEnabled(false)
		btn_duihuan:setVisible(false)
		btn_duihuan:setTouchEnabled(false)
		btn_save:setVisible(true)
		btn_save:setTouchEnabled(true)

		txt_username:setTouchEnabled(true)
		txt_username:setText("")
		label_username:setText("")

		txt_phone:setTouchEnabled(true)
		txt_phone:setText("")
		label_phone:setText("")

		txt_address:setTouchEnabled(true)
		txt_address:setText("")
		label_address:setText("")

		txt_email:setTouchEnabled(true)
		txt_email:setText("")
		label_email:setText("")

		for i = 1, k_AwardInfoLogic_Count do
	    	edit_awardinfo_tab[i]:setTouchEnabled(true)
	    	edit_awardinfo_tab[i]:setVisible(true)
	    end

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
end

function removeSlot()
end
