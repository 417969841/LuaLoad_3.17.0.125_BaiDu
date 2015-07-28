module("LoginLogic", package.seeall)
view = nil

local usernamevalue = nil
local passwordvalue = nil
local imei = nil
local isChangeAccount = false
local lookTimer = nil --时间计时器
local fx = nil--移动方向 1向左，0向右
--控件
btn_login = nil
btn_reg = nil
txt_username = nil --用户名(用于输入)
label_username = nil --用户名(用于显示)
txt_password = nil --密码(用于输入)
label_password = nil --密码(用于显示)
txt_ip = nil --IP(用于输入)
Label_ip = nil --IP(用于显示)
checkagree = nil
img_bg = nil
btn_more = nil;
Image_more = nil
Image_moreup = nil
currentTxtInput = nil; --当前文本输入框
currentTxtShow = nil; --当前文本显示
defaultValueLabelsTable ={}; --label的默认值table
defaultValueLabel = "";--label默认值

ImageView_username = nil;--
ImageView_password = nil;--
ImageView_ip = nil;--
btn_setIp = nil;--
lable_ip_text = nil;--


edit_username = nil;  --新輸入框
edit_password = nil;
edit_ip = nil;

function onKeypad(event)
	if event == "backClicked" then
		Common.AndroidExitSendOnlineTime()
	elseif event == "menuClicked" then
	end
end

--[[--
--设置是否是切换账号
]]
function setChangeAccount(isChange)
	isChangeAccount = isChange
end

--[[--
--切换账号时初始化数据
]]
function initAllGameData()
	if isChangeAccount == true then
		isChangeAccount = false;
		Common.log("-----------切换账号时初始化数据-------------")
		profile.User.initUserInfo();
		GameConfig.isRegister = false;
		GameConfig.isFirstEnterGame = false;
		HallChatLogic.initAllChatData();
		GameConfig.initGameCommonData();
		profile.Match.clearData();
		--清除大厅公告数据
		profile.SystemListNotice.clearData();
		--清除大厅按钮数据
		profile.ButtonsStatus.clearData();
		--清除支付列表数据
		profile.PayChannelData.releaseRechargeData();
		ImageToast.OverFunction = nil;
		--清除大厅预读消息数据
		MessagesPreReadManage.clearData();
	end
end

--[[--
--初始化控件
--]]
local function initView()
	txt_username = cocostudio.getUITextField(view, "txt_username")
	txt_username:setVisible(false)
	label_username = cocostudio.getUILabel(view, "Label_username")

	txt_password = cocostudio.getUITextField(view, "txt_password")
	txt_password:setVisible(false)
	label_password = cocostudio.getUILabel(view, "Label_password")

	txt_ip = cocostudio.getUITextField(view, "txt_ip")
	txt_ip:setVisible(false)
	Label_ip = cocostudio.getUILabel(view, "Label_ip")

	checkagree = cocostudio.getUICheckBox(view, "check_agree")
	btn_login = cocostudio.getUIButton(view, "btn_login")
	btn_reg = cocostudio.getUIButton(view, "btn_reg")

	img_bg = cocostudio.getUIImageView(view, "img_bg")
	if GameConfig.gameIsFullPackage() then
		img_bg:loadTexture(Common.getResourcePath("lord_game_res/bg_login.png"));
		img_bg:setPosition(ccp(-332,320))
	else
		img_bg:setVisible(false)
	end

	ImageView_username = cocostudio.getUIImageView(view, "ImageView_username");
	ImageView_password = cocostudio.getUIImageView(view, "ImageView_password");
	ImageView_ip = cocostudio.getUIImageView(view, "ImageView_ip");
	btn_setIp = cocostudio.getUIButton(view, "btn_setIp");
	lable_ip_text = cocostudio.getUILabel(view, "lable_ip_text");
	btn_more = cocostudio.getUIButton(view, "btn_more");
	Image_more = cocostudio.getUIImageView(view, "Image_more");
	Image_moreup = cocostudio.getUIImageView(view, "Image_moreup");

	if not Common.isDebugState() then
		ImageView_ip:setVisible(false);
		lable_ip_text:setVisible(false);
		txt_ip:setTouchEnabled(false);
		Common.setButtonVisible(btn_reg, false);
		Common.setButtonVisible(btn_setIp, false);
	end

	checkagree:setSelectedState(true);

	--弃用
	txt_username:setTouchEnabled(false);
	txt_password:setTouchEnabled(false);
	txt_ip:setTouchEnabled(false);

	label_username:setVisible(false)
	label_password:setVisible(false)
	Label_ip:setVisible(false)

	--新的输入框
	createUsernameEditor();
end

--创建玩家名输入框
function createUsernameEditor()
	local editBoxSize = CCSizeMake(302, 46)
	local function editBoxTextEventHandle(strEventName,pSender)
		 local edit = tolua.cast(pSender,"CCEditBox")
		 local strFmt
		 if strEventName == "began" then
		 elseif strEventName == "ended" then
		 elseif strEventName == "changed" then
		 elseif strEventName == "return" then
		 	if edit == edit_username then
		 	elseif edit == edit_password then
		 	end
		 end
	end

 	--名字输入框
    edit_username = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
    edit_username:setPosition(ccp(545*GameConfig.ScaleAbscissa, 346*GameConfig.ScaleOrdinate))
    edit_username:setAnchorPoint(ccp(0.5, 0))

    edit_username:setFont("微软雅黑", 22)
    edit_username:setFontColor(ccc3(0xB3, 0x9C, 0x77))
    edit_username:setPlaceHolder("输入账号")
    edit_username:setMaxLength(32)
    edit_username:setReturnType(kKeyboardReturnTypeDone)
    edit_username:setInputMode(kEditBoxInputModeSingleLine);

	edit_username:registerScriptEditBoxHandler(editBoxTextEventHandle)
    view:addChild(edit_username)

    --密码输入框
    edit_password = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
    edit_password:setPosition(ccp(545*GameConfig.ScaleAbscissa, 256*GameConfig.ScaleOrdinate))
    edit_password:setAnchorPoint(ccp(0.5, 0))
    edit_password:setFont("微软雅黑", 22)
    edit_password:setFontColor(ccc3(0xB3, 0x9C, 0x77))
    edit_password:setPlaceHolder("输入密码")
    edit_password:setMaxLength(32)
    edit_password:setReturnType(kKeyboardReturnTypeDone)
    edit_password:setInputMode(kEditBoxInputModeSingleLine);

	edit_password:registerScriptEditBoxHandler(editBoxTextEventHandle)
    view:addChild(edit_password)

    --ip输入框
    edit_ip = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
    edit_ip:setPosition(ccp(300*GameConfig.ScaleAbscissa, 9*GameConfig.ScaleOrdinate))
    edit_ip:setAnchorPoint(ccp(0.5, 0))
    edit_ip:setFont("微软雅黑", 22)
    edit_ip:setFontColor(ccc3(0xB3, 0x9C, 0x77))
    edit_ip:setPlaceHolder("ip")
    edit_ip:setMaxLength(32)
    edit_ip:setReturnType(kKeyboardReturnTypeDone)
    edit_ip:setInputMode(kEditBoxInputModeAny);

	edit_ip:registerScriptEditBoxHandler(editBoxTextEventHandle)
    view:addChild(edit_ip)
	edit_ip:setVisible(Common.isDebugState())
end

--屏蔽输入框
function setEditorEnable(isTouch)
	edit_username:setTouchEnabled(isTouch)
	edit_password:setTouchEnabled(isTouch)
	edit_ip:setTouchEnabled(isTouch)
end

--[[--
--设置显示IP
--]]
function setIpLable()
	local ip = "";
	if #MassageConnect.getServerIpList() == 1 then
		ip = MassageConnect.getServerIpList()[1];
	else
		local index = math.random(1, #MassageConnect.getServerIpList());
		ip = MassageConnect.getServerIpList()[index]
	end
	if GameConfig.isConnect then
		lable_ip_text:setText("连接:"..ip);
	else
		lable_ip_text:setText("无连接");
	end
	txt_ip:setText(ip);
	Label_ip:setText(ip);

	--新
	edit_ip:setText(ip);
end

--[[--
--初始化Text label
--]]
local function initTextLabel()
	txt_username:setText("");
	txt_password:setText("");
	if Common.isDebugState() then
		txt_ip:setText("");
		setIpLable();
	end
end

--[[--
--保存用于显示的label默认值
--]]
local function saveShowLabelsDefaultVlaue()
	defaultValueLabelsTable["userName"] = label_username:getStringValue();--用户名
	defaultValueLabelsTable["password"] = label_password:getStringValue();--密码
	defaultValueLabelsTable["ip"] = Label_ip:getStringValue();--ip

	--新
	defaultValueLabelsTable["userName"] = edit_username:getText();
	defaultValueLabelsTable["password"] = edit_password:getText();
	defaultValueLabelsTable["ip"] = edit_ip:getText();
end

--[[--
--初始化当前界面
--]]
--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_LOGIN;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("Login.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("Login.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("Login_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();

	view:setTag(getDiffTag())
	GameConfig.setTheCurrentBaseLayer(GUI_LOGIN)

	GameStartConfig.addChildForScene(view)

	GameConfig.setHallShowMode(0)--大厅模式

	lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(setCurrentBg, 0.05 ,false)
	--定时器，更新时间

	--iemi
	imei = Common.getDeviceInfo()
	Common.log("getDeviceInfo" .. imei)
	 if GameConfig.isConnect then
	 	--建立连接才发送消息
		sendBASEID_GET_IMEIUSERS(imei);
	end

	--界面
	fx = 1

	--初始化控件
	initView();
	--初始化Text label
	initTextLabel();
	--保存用于显示的label默认值
	saveShowLabelsDefaultVlaue();

	--自动登录
	local logininfo = Common.LoadShareUserTable("lastLoginUserInfo")
	if logininfo == nil then

	else
		local UserID = logininfo["UserID"]
		usernamevalue = logininfo["nickname"]
		passwordvalue = logininfo["password"]
		txt_username:setText(usernamevalue)
		label_username:setText(usernamevalue)
		txt_password:setText(passwordvalue)
		label_password:setText(passwordvalue)

		--新
		edit_username:setText(usernamevalue)
		edit_password:setText(passwordvalue)
	end
	openLoginButton()
end

--替换背景
function setCurrentBg()
	local winSize = CCDirector:sharedDirector():getWinSize()
	--背景左边边界值判断
	--1136-1800 = -664
	--Common.log("loginsssss"..img_bg:getPosition().x)
	if img_bg:getPosition().x >= 0 then
		--向左移动
		fx = 1
	elseif img_bg:getPosition().x <= -664 then
		--向右移动
		fx = 0
	end
	if fx == 1 then
		img_bg:setPosition(ccpAdd(img_bg:getPosition(),ccp(-2,0)))
	elseif fx == 0 then
		img_bg:setPosition(ccpAdd(img_bg:getPosition(),ccp(2,0)))
	end
end

function requestMsg()
end

local function login()
	usernamevalue = label_username:getStringValue()
	passwordvalue = label_password:getStringValue()

	--新
	usernamevalue = edit_username:getText()
	passwordvalue = edit_password:getText()

	local agreeflag = checkagree:getSelectedState()

	if agreeflag then
		if (usernamevalue ~= nil and passwordvalue ~= nil) then
			if Common.isDebugState() then
				--请求病毒传播红包分享基本信息(为了不影响新手引导弹出，消息提前发)
				sendOPERID_SHARING_V3_BASE_INFO()
				sendCOMMONS_GET_NEWUSERGUIDE_IS_OPEN()
			end
			sendBASEID_LOGIN(usernamevalue, passwordvalue, imei)
		else
			Common.showToast("用户名或密码不能为空", 2)
		end
	else
		Common.showToast("请先同意同趣游戏用户协议", 2)
	end
end
--TODO

function closeLoginButton()
	Image_more:setVisible(false)
	Image_moreup:setVisible(true)
end

function openLoginButton()
	Image_more:setVisible(true)
	Image_moreup:setVisible(false)
end

function callback_btn_login(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		login();
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_reg(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local agreeflag = checkagree:getSelectedState()
		if agreeflag then
			if Common.isDebugState() then
				--请求病毒传播红包分享基本信息(为了不影响新手引导弹出，消息提前发)
				sendOPERID_SHARING_V3_BASE_INFO()
				sendCOMMONS_GET_NEWUSERGUIDE_IS_OPEN()
			end
			sendBASEID_REGISTER(imei)
		else
			Common.showToast("请先同意同趣游戏用户协议", 2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_text_resetpass(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_RESETPASSWORD)
		ResetPasswordLogic.setUsername(label_username:getStringValue())

		--新
		ResetPasswordLogic.setUsername(edit_username:getText())
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_more(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
	--	MoreLogic.setUsername(label_username:getStringValue())
		if  profile.MoreUser.getNickNameNum() == 0 then
			--如果没有NickName信息,不展开
			return;
		end
		mvcEngine.createModule(GUI_MORE)
		MoreLogic.setCurViewTag(MoreLogic.getViewTag().LOGIN);
		MoreLogic.setPanelPosition(ImageView_username:getPosition().x, ImageView_username:getPosition().y - ImageView_username:getContentSize().height / 2)
--		btn_more:setRotation(180);
		closeLoginButton()

		MoreLogic.setRotationInfo(Image_more,Image_moreup);
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_setIp(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if Common.isDebugState() then
			local ip = Label_ip:getStringValue();
			ip = edit_ip:getText();
			MassageConnect.reConnect(ip);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--保存用户数据
]]
local function saveUserData()
	local userinfo = {}
	local UserID = profile.User.getSelfUserID()
	local username = profile.User.getSelfNickName()
	local password = profile.User.getSelfPassword()
	userinfo["UserID"] = UserID
	userinfo["nickname"] = username
	userinfo["password"] = password
	Common.SaveShareUserTable("lastLoginUserInfo", userinfo)
	--斗地主记录所有登陆昵称和密码
	Common.setDataForSqlite(CommSqliteConfig.UserNicknameAndPassword..username,password)
end

function slot_Login()
	local result = profile.UserLoginReg.getResult()
	local resultText = profile.UserLoginReg.getResultText()
	if (result == 0) then
		initAllGameData();
		local BaseInfo = {}
		BaseInfo = profile.UserLoginReg.getBaseInfo()
		profile.User.setSelfUserID(BaseInfo["UserID"])
		profile.User.setSelfNickName(BaseInfo["NickName"])
		profile.User.setSelfPassword(passwordvalue)
		saveUserData()
		CommUploadConfig.sendException()
		--发送预读消息
		MessagesPreReadManage.sendPreReadingMessages();
		mvcEngine.createModule(GUI_HALL)
	else
		Common.showToast(resultText, 2)
	end

end

function slot_Reg()
	local result = profile.UserLoginReg.getResult()
	local resultText = profile.UserLoginReg.getResultText()
	if (result == 0) then
		initAllGameData();
		local BaseInfo = {}
		BaseInfo = profile.UserLoginReg.getBaseInfo()
		profile.User.setSelfUserID(BaseInfo["UserID"])
		profile.User.setSelfNickName(BaseInfo["NickName"])
		profile.User.setSelfPassword(BaseInfo["Password"])
		saveUserData()
		GameConfig.isRegister = true;
		GameConfig.isFirstEnterGame = true
		--发送预读消息
		MessagesPreReadManage.sendPreReadingMessages();
		mvcEngine.createModule(GUI_HALL);
	else
		Common.showToast(resultText, 2)
	end
end


function slot_MoreUser()
	Common.log("test login == slot_MoreUser");
	txt_username:setText(profile.MoreUser.getLoginWithMore())
	label_username:setText(profile.MoreUser.getLoginWithMore())

	edit_username:setText(profile.MoreUser.getLoginWithMore())
	--	if usernamevalue ~= nil and passwordvalue ~= nil  then
	--		local txt_name = usernamevalue
	--		local txt_pass = passwordvalue
	--		if txt_name == profile.MoreUser.getLoginWithMore() then
	--			password:setText(txt_pass)
	--		else
	--			password:setText("")
	--		end
	--	end
	local passwordvalue = Common.getDataForSqlite(CommSqliteConfig.UserNicknameAndPassword..profile.MoreUser.getLoginWithMore())
	if passwordvalue == nil or passwordvalue == "" then
		txt_password:setText("")
		label_password:setText("")

		edit_password:setText("")
	else
		txt_password:setText(passwordvalue)
		label_password:setText(passwordvalue)

		edit_password:setText(passwordvalue)
	end

end

function callback_text_useragreement(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_USERAGREEMENT)
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
---用户名输入框(ios)
--]]
function callback_text_username_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = txt_username;
		currentTxtShow = label_username;
		defaultValueLabel = defaultValueLabelsTable["userName"];
		Common.showAlertInput(txt_username:getStringValue(),0,true, callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end


--[[-
--用户名输入框(安卓)
--]]
function callback_text_username()
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
--密码输入框(ios)
--]]
function callback_text_password_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = txt_password;
		currentTxtShow = label_password;
		defaultValueLabel = defaultValueLabelsTable["password"];
		Common.showAlertInput(txt_password:getStringValue(),0,true, callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--密码输入框(安卓)
--]]
function callback_text_password()
	--控件不存在,return
	if label_password == nil then
		return;
	end

	if txt_password:getStringValue() ~= nil and txt_password:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_password:setText(txt_password:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["password"] ~= nil then
			label_password:setText(defaultValueLabelsTable["password"]);
		end
	end
end
--[[--
--IP输入框(ios)
--]]
function callback_txt_ip_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = txt_ip;
		currentTxtShow = Label_ip;
		defaultValueLabel = defaultValueLabelsTable["ip"];
		Common.showAlertInput(txt_ip:getStringValue(),0,true, callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--IP输入框(安卓)
--]]
function callback_txt_ip()
	--控件不存在,return
	if Label_ip == nil then
		return;
	end

	if Label_ip:getStringValue() ~= nil and Label_ip:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		Label_ip:setText(txt_ip:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["ip"] ~= nil then
			Label_ip:setText(defaultValueLabelsTable["ip"]);
		end
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	if (lookTimer) then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
	end

end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(BASEID_LOGIN, slot_Login)
	framework.addSlot2Signal(BASEID_REGISTER, slot_Reg)
	framework.addSlot2Signal(signal.common.Signal_BASEID_GET_LOGINCHANEUSERNAMME, slot_MoreUser) --点击more之后username要改
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(BASEID_LOGIN, slot_Login)
	framework.removeSlotFromSignal(BASEID_REGISTER, slot_Reg)
	framework.removeSlotFromSignal(signal.common.Signal_BASEID_GET_LOGINCHANEUSERNAMME, slot_MoreUser)
end
