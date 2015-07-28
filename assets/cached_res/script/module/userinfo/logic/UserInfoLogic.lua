module("UserInfoLogic",package.seeall)

view = nil
tab = ""
local TAB_COMMON = "common"
local TAB_PACK = "pack"

--------------------panel----------------
panel_basic_basic = nil --基本信息---基本
panel_basic_sns = nil--基本信息---社交
panel_basic_duijiang = nil--基本信息---兑奖
panel_tianti_basic = nil--天梯信息---基本
panel_bag_menu = nil;--背包
Panel_Bag = nil;
Button_Synthesis = nil;--合成
ScrollView_BagInfo = nil;--背包scroll
img_bag_Tickets = nil;--背包-门票
panel_basic_menu = nil
img_Bag = nil;--背包
zi_bag = nil
local panelTabName = nil

------------------上方按钮----------------
btn_back = nil
img_basic = nil

------------------左侧按钮----------------
img_tianti_paiming = nil
img_basic_sns = nil
img_basic_duijiang = nil
------------------基本信息---基本----------------
lab_basic_basic_coin = nil
lab_basic_basic_yuanbao = nil
lab_basic_basic_duijiangquan = nil
lab_basic_basic_suipian = nil

------------------基本信息---社交----------------
img_basic_sns_avator = nil
txt_basic_sns_username = nil --社交 用户名(用于输入)
label_basic_sns_username = nil --社交 用户名(用于显示)
txt_basic_sns_password = nil--社交 密码(用于输入)
label_basic_sns_password = nil--社交 密码(用于显示)
check_basic_sns_sexB = nil
check_basic_sns_sexG = nil
check_basic_sns_sexM = nil
lab_basic_sns_phone = nil
lab_basic_sns_userid = nil
lab_basic_sns_year = nil
lab_basic_sns_address = nil
txt_basic_sns_info = nil--社交 个人签名(用于输入)
lable_basic_sns_info = nil--社交 个人签名(用于显示)
btn_basic_sns_save = nil
Image_save = nil;--社交 保存图片
updateUserinfoTimer = nil --计时器
zi_Tickets = nil;
img_bag_Props = nil;--道具
zi_Props = nil;--道具字
Button_bangding = nil;
--绑定手机
local BindPhone = 0
BindPhoneList = {}
--运营商
local operator = 0
--选中的性别
local userSelectSex = nil


------------------天梯信息---帮助----------------
local tthelpurl = "http://f.99sai.com/lord/ladder/about_ladder.html"
------------------全局变量----------------
local PANEL_BASIC_BASIC = "basic_basic"
local PANEL_BASIC_SNS = "basic_sns"
local PANEL_BASIC_DUIJIANG = "basic_duijiang"
local PANEL_TIANTI_BASIC = "tianti_basic"
local PANEL_TIANTI_PAIMING = "tianti_paiming"
local PANEL_TIANTI_HELP = "tianti_help"
local PANEL_BAG_PROPS = "bag_props"
local PANEL_BAG_TICKETS = "bag_Tickets"

--字
zi_jbxx = nil
--zi_ttxx = nil
--zi_ttjb = nil
zi_ttpm = nil
--zi_ttbz = nil
--zi_jbjb = nil
zi_jbsz = nil
zi_jbdj = nil
zi_bindPhone = nil;

currentChatInputText = nil;-- 当前在编辑的text控件
currentShowText = nil;--当前在编辑的text控件对应的显示label
defaultValueLabelsTable ={}; --label的默认值table
defaultValueLabel = "";--label默认值
BindButtonPosition = nil;--绑定按钮位置
phoneNumPosition = nil;--手机号label位置

--------------------------------------------------------------
-------------------背包相关----------------------------------
local comSucessstart = 0
local comSucessNum = 40
local hechengfunum = 0 --合成符数量
local newGuide = false--是否是新手引导
PropsTable = {};--道具
PackImageGooodsTable = {}
PackImageTicketTable = {}
menPiaoTable = {}--门票
PriceCompound = {};

----------------------------------------------------------------
------------------基本信息---兑奖----------------
txt_basic_duijiang_username = nil --兑奖用户名(用于输入)
label_basic_duijiang_username = nil--兑奖用户名(用于显示)
txt_basic_duijiang_phone = nil --兑奖电话(用于输入)
label_basic_duijiang_phone = nil --兑奖电话(用于显示)
txt_basic_duijiang_address = nil--兑奖地址(用于输入)
label_basic_duijiang_address = nil--兑奖地址(用于显示)


txt_basic_duijiang_email = nil --兑奖 email(用于输入)
label_basic_duijiang_email = nil --兑奖 email(用于显示)
btn_basic_duijiang_save = nil
--btn_basic_duijiang_ok = nil
Image_duijiang_ok = nil --兑奖 保存图片

------------------天梯信息---基本----------------
img_tianti_basic_jb = nil
img_tianti_basic_dj = nil
lab_tianti_basic_pm = nil
lab_tianti_basic_gz = nil
lab_tianti_basic_allps = nil
lab_tianti_basic_sl = nil
btn_tianti_basic_lgz = nil
lab_tianti_basic_bl = nil
ImageView_GuiZe = nil;
lab_tiantidengji = nil --天梯等级
ImageView_2094 = nil --天梯
------------------天梯信息---排名----------------
scroll_ttpm = nil--排行版
--lab_ttMypm = nil--我的牌名
TTListTable = {}--天梯排名table
TTListImageList = {}--天梯排名前三名头像
local startTT = 0--天梯起始
local numTT = 100--天梯数量
local TTLGZ_NOZG = "未获得资格"
local TTLGZ_LG = "您已经领过工资"


----------------------------------------------------------------
local k_Exchange_Count = 3;  --兑换页共3个

--新的输入框
edit_userinfo = nil;  --个人信息输入框
edit_password = nil;  --密码输入框
edit_signname = nil; --个性签名

edit_exchange_tab = {};   --兑奖页输入框


----------------------------------------------------------------


function onKeypad(event)
	if event == "backClicked" then
		Common.hideWebView()
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then
	end
end

--[[--
--保存用于显示的label默认值
--]]
local function saveShowLabelsDefaultVlaue()
	--社交
	defaultValueLabelsTable["snsUserName"] = edit_userinfo:getText();  --label_basic_sns_username:getStringValue();--社交 用户名
	defaultValueLabelsTable["snsPassword"] = edit_password:getText();  --label_basic_sns_password:getStringValue();--社交 密码
	defaultValueLabelsTable["snsInfo"] = edit_signname:getText();  --lable_basic_sns_info:getStringValue(); --社交 个人签名
	--兑奖
	defaultValueLabelsTable["duiJiangUserName"] = edit_exchange_tab[1]:getText(); --label_basic_duijiang_username:getStringValue();--兑奖 用户名
	defaultValueLabelsTable["duiJiangPhone"] = edit_exchange_tab[2]:getText(); --label_basic_duijiang_phone:getStringValue();-- 兑奖 电话
	defaultValueLabelsTable["duiJiangAddress"] = edit_exchange_tab[3]:getText(); --label_basic_duijiang_address:getStringValue();--兑奖 地址
	--defaultValueLabelsTable["duiJiangEmail"] = label_basic_duijiang_email:getStringValue();-- 兑奖 email  弃用之前的邮编
end

--[[--
--初始化用户信息
--]]
local function initUserInfo()
	--基本--
	--	lab_basic_basic_username:setText(profile.User.getSelfNickName())
	lab_basic_basic_coin:setText(profile.User.getSelfCoin())
	lab_basic_basic_yuanbao:setText(profile.User.getSelfYuanBao())
	lab_basic_basic_suipian:setText(profile.User.getSelfdjqPieces())
	lab_basic_basic_duijiangquan:setText(profile.User.getDuiJiangQuan())
	--社交--
	txt_basic_sns_username:setText(profile.User.getSelfNickName());
	label_basic_sns_username:setText(profile.User.getSelfNickName());
	txt_basic_sns_password:setText(profile.User.getSelfPassword());
	label_basic_sns_password:setText(profile.User.getSelfPassword());



	lab_basic_sns_userid:setText("ID:"..profile.User.getSelfUserID())
	local self_year = profile.User.getSelfBirthDay()
	lab_basic_sns_year:setText(profile.User.getAgeTxtByValue(self_year));
	lab_basic_sns_address:setText(profile.User.getSelfCity())
	lable_basic_sns_info:setText(profile.User.getSelfsign()) --个性签名
	--lab_basic_sns_phone:setText(profile.User.)

	--新
	edit_userinfo:setText(profile.User.getSelfNickName());
	edit_password:setText(profile.User.getSelfPassword());
	edit_signname:setText(profile.User.getSelfsign())


	--性别
	local usersex = profile.User.getSelfSex()
	userSelectSex = usersex
	if(usersex == 1) then--男
		check_basic_sns_sexB:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
	elseif(usersex == 2) then--女
		check_basic_sns_sexG:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
	elseif(usersex == 0) then--保密
		check_basic_sns_sexM:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
	end

	--兑奖--
	txt_basic_duijiang_username:setText(Common.getDataForSqlite(CommSqliteConfig.SendAwardUsername..profile.User.getSelfUserID()));
	label_basic_duijiang_username:setText(Common.getDataForSqlite(CommSqliteConfig.SendAwardUsername..profile.User.getSelfUserID()));
	txt_basic_duijiang_phone:setText(Common.getDataForSqlite(CommSqliteConfig.SendAwardPhone..profile.User.getSelfUserID()));
	label_basic_duijiang_phone:setText(Common.getDataForSqlite(CommSqliteConfig.SendAwardPhone..profile.User.getSelfUserID()));
	txt_basic_duijiang_address:setText(Common.getDataForSqlite(CommSqliteConfig.SendAwardAddress..profile.User.getSelfUserID()));
	label_basic_duijiang_address:setText(Common.getDataForSqlite(CommSqliteConfig.SendAwardAddress..profile.User.getSelfUserID()));
	--txt_basic_duijiang_email:setText(Common.getDataForSqlite(CommSqliteConfig.SendAwardEmail..profile.User.getSelfUserID()));
	--label_basic_duijiang_email:setText(Common.getDataForSqlite(CommSqliteConfig.SendAwardEmail..profile.User.getSelfUserID()));

	edit_exchange_tab[1]:setText(Common.getDataForSqlite(CommSqliteConfig.SendAwardUsername..profile.User.getSelfUserID()))
	edit_exchange_tab[2]:setText(Common.getDataForSqlite(CommSqliteConfig.SendAwardPhone..profile.User.getSelfUserID()))
	edit_exchange_tab[3]:setText(Common.getDataForSqlite(CommSqliteConfig.SendAwardAddress..profile.User.getSelfUserID()))

	--统一更新头像
	local photoUrl = profile.User.getSelfPhotoUrl()
	if photoUrl ~= nil then
		Common.getPicFile(photoUrl, 0, true, updateAvator)
	end

	panelTabName = "";
	if tab == TAB_PACK then
		setPanel(PANEL_BAG_PROPS)
		img_basic:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		img_Bag:loadTexture(Common.getResourcePath("btn_macth_press.png"))
	else
		--初始化
		img_basic:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		img_Bag:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		setPanel(PANEL_BASIC_BASIC)
	end
end


--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_USERINFO;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("UserInfo.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("UserInfo.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("UserInfo_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	createUserInfoPageEditor();


	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)
	GameConfig.setTheCurrentBaseLayer(GUI_USERINFO)
	sendLadder_TOP(startTT,numTT)
	sendDBID_BACKPACK_LIST()--背包
	sendMANAGERID_PIECES_COMPOUND_DETAILS_V2()--碎片兑换
	sendMANAGERID_COMPOUND_INFO(comSucessstart,comSucessNum)--兑换信息
	sendTICKET_GET_TICKET_LIST()--门票消息
	initView();

	--保存用于显示的label默认值
	saveShowLabelsDefaultVlaue();
	--初始化用户信息
	initUserInfo();
	Common.closeProgressDialog()
	--初始化基本数据
	--运营商
	local function delaySentMessage()
		operator = Common.getOperater()
		sendDBID_GET_SMS_NUMBER()
		sendMANAGERID_GET_VIP_MSG()
	end
	LordGamePub.runSenceAction(view,delaySentMessage,false)
	if RenWuLogic.getModifyUserInfo() then
		--新手任务，显示修改用户名和密码界面
		logicRenWuModify();
	end


end

--个人信息页的输入框
function createUserInfoPageEditor()
 	--名字输入框
 	local editBoxSize = CCSizeMake(302, 43)
    edit_userinfo = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
    edit_userinfo:setPosition(ccp(333, 412))
    edit_userinfo:setAnchorPoint(ccp(0,0))
    edit_userinfo:setFont("微软雅黑", 22)
    edit_userinfo:setFontColor(ccc3(0xB3, 0x9C, 0x77))
    edit_userinfo:setPlaceHolder("")
    edit_userinfo:setMaxLength(32)
    edit_userinfo:setReturnType(kKeyboardReturnTypeDone)
    edit_userinfo:setInputMode(kEditBoxInputModeSingleLine);
    view:addChild(edit_userinfo)

    --密码输入框
    edit_password = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
    edit_password:setPosition(ccp(333, 338))
    edit_password:setAnchorPoint(ccp(0,0))
    edit_password:setFont("微软雅黑", 22)
    edit_password:setFontColor(ccc3(0xB3, 0x9C, 0x77))
    edit_password:setMaxLength(32)
    edit_password:setReturnType(kKeyboardReturnTypeDone)
    edit_password:setInputMode(kEditBoxInputModeSingleLine);
    view:addChild(edit_password)

    --签名输入框
    edit_signname = CCEditBox:create(CCSizeMake(602, 43), CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
    edit_signname:setPosition(ccp(333, 59))
    edit_signname:setAnchorPoint(ccp(0,0))
	edit_signname:setFont("微软雅黑", 22)
    edit_signname:setFontColor(ccc3(0xB3, 0x9C, 0x77))
    edit_signname:setReturnType(kKeyboardReturnTypeDone)
    edit_signname:setInputMode(kEditBoxInputModeSingleLine);
    view:addChild(edit_signname)
end

function setVisibleForUserInfo(isVisible)
	edit_userinfo:setVisible(isVisible)
	edit_password:setVisible(isVisible)
	edit_signname:setVisible(isVisible)
end

function setEnableForUderInfo(isEnable)
	print(edit_userinfo)
	edit_userinfo:setTouchEnabled(isEnable)
	edit_password:setTouchEnabled(isEnable)
	edit_signname:setTouchEnabled(isEnable)
	--setVisibleForUserInfo(false)
end

--个人信息页的输入框
function createExchangePageEditor()
	for i = 1, k_Exchange_Count do
		local editBoxSize = CCSizeMake(302, 43)
	    edit_exchange_tab[i] = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
	    edit_exchange_tab[i]:setPosition(ccp(376, 303-(i-1)*78.5))
	    edit_exchange_tab[i]:setAnchorPoint(ccp(0,0))
    	edit_exchange_tab[i]:setFont("微软雅黑", 22)
    	edit_exchange_tab[i]:setFontColor(ccc3(0xB3, 0x9C, 0x77))
	    edit_exchange_tab[i]:setPlaceHolder("请填写")
	    edit_exchange_tab[i]:setMaxLength(32)
	    edit_exchange_tab[i]:setReturnType(kKeyboardReturnTypeDone)
	    edit_exchange_tab[i]:setInputMode(kEditBoxInputModeSingleLine);
	    view:addChild(edit_exchange_tab[i])
	end
	edit_exchange_tab[2]:setInputMode(kEditBoxInputModePhoneNumber);
end

function setVisibleForExchangePage(isVisible)
	for i = 1, k_Exchange_Count do
		edit_exchange_tab[i]:setVisible(isVisible)
	end
end


function setTab(tabV)
	tab = tabV
end

--[[--
--获取背包tab
--]]
function getPackTab()
	return TAB_PACK;
end

--兑换信息页的输入框
function createConvertPageEditor()

end

--更新头像
function updateAvator(dataInApp)
	local photoPath = nil
	if Common.platform == Common.TargetIos then
		photoPath = dataInApp["useravatorInApp"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(dataInApp, "#")
		local id = string.sub(dataInApp, 1, i-1)
		photoPath = string.sub(dataInApp, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" then
		--img_basic_basic_useravator:loadTexture(photoPath)
		img_basic_sns_avator:loadTextures(photoPath, photoPath, "")
		Common.setDataForSqlite(CommSqliteConfig.SelfAvatorInSD..profile.User.getSelfUserID(),photoPath)
	end
end

function initView()
	--panel
	Button_bangding = cocostudio.getUIButton(view, "Button_bangding"); --//
	lab_basic_sns_phone = cocostudio.getUILabel(view, "lab_basic_sns_phone")--//
	panel_basic_basic =  cocostudio.getUITextField(view, "panel_basic_basic")--基本信息---基本--//
	panel_basic_duijiang = cocostudio.getUITextField(view, "panel_basic_duijiang")--基本信息---兑奖--//
	panel_tianti_basic = cocostudio.getUITextField(view, "panel_tianti_basic")--天梯信息---基本--//
	panel_basic_menu = cocostudio.getUITextField(view, "panel_basic_menu")--//
	panel_bag_menu = cocostudio.getUIPanel(view, "panel_bag_menu");--//
	Panel_Bag = cocostudio.getUIPanel(view, "Panel_Bag"); --//
	img_bag_Tickets = cocostudio.getUIImageView(view, "img_bag_Tickets");--//
	Image_duanhuanInfo = cocostudio.getUIImageView(view, "Image_duanhuanInfo");--//
	img_Bag = cocostudio.getUIImageView(view, "img_Bag");--//
	zi_bag = cocostudio.getUIImageView(view, "zi_bag");--//
	zi_Tickets = cocostudio.getUIImageView(view, "zi_Tickets");--//
	img_bag_Props = cocostudio.getUIImageView(view, "img_bag_Props");--//
	zi_Props = cocostudio.getUIImageView(view, "zi_Props");--//
	Button_Synthesis = cocostudio.getUIButton(view, "Button_Synthesis");--//
	ScrollView_BagInfo = cocostudio.getUIScrollView(view, "ScrollView_BagInfo");--//
	--上方按钮
	btn_back = cocostudio.getUIButton(view, "btn_back")--//
	img_basic = cocostudio.getUIImageView(view, "img_basic") --//

	--左侧按钮
	img_tianti_paiming = cocostudio.getUIImageView(view, "img_tianti_paiming")--//
	img_basic_sns = cocostudio.getUIImageView(view, "img_basic_sns")--//
	img_basic_duijiang = cocostudio.getUIImageView(view, "img_basic_duijiang")--//
	---------------------------基本信息---基本------------------------------
	lab_basic_basic_coin = cocostudio.getUILabel(view, "lab_basic_basic_coin")--//
	lab_basic_basic_yuanbao = cocostudio.getUILabel(view, "lab_basic_basic_yuanbao")--//
	lab_basic_basic_duijiangquan = cocostudio.getUILabel(view, "lab_basic_basic_duijiangquan")--//
	lab_basic_basic_suipian = cocostudio.getUILabel(view, "lab_basic_basic_suipian")--//
	--------------------------------基本信息---社交---------------------------
	img_basic_sns_avator = cocostudio.getUIButton(view, "img_basic_sns_avator");--//

	txt_basic_sns_username = cocostudio.getUITextField(view, "txt_basic_sns_username");--//
	txt_basic_sns_username:setVisible(false);
	label_basic_sns_username = cocostudio.getUILabel(view, "Label_basic_sns_username");--//

	txt_basic_sns_password = cocostudio.getUITextField(view, "txt_basic_sns_password");--//
	txt_basic_sns_password:setVisible(false);
	label_basic_sns_password = cocostudio.getUILabel(view, "Label_basic_sns_password");--//

	txt_basic_sns_info = cocostudio.getUITextField(view, "txt_basic_sns_info");--//
	txt_basic_sns_info:setVisible(false);
	lable_basic_sns_info = cocostudio.getUILabel(view, "Label_basic_sns_info");--//

	check_basic_sns_sexB = cocostudio.getUIImageView(view, "check_basic_sns_sexB")--//
	check_basic_sns_sexG = cocostudio.getUIImageView(view, "check_basic_sns_sexG")--//
	check_basic_sns_sexM = cocostudio.getUIImageView(view, "check_basic_sns_sexM")--//
	lab_basic_sns_userid = cocostudio.getUILabel(view, "lab_basic_sns_userid")--//
	lab_basic_sns_year = cocostudio.getUILabel(view, "lab_basic_sns_year")--//
	lab_basic_sns_address = cocostudio.getUILabel(view, "lab_basic_sns_address")--//

	btn_basic_sns_save =  cocostudio.getUIImageView(view, "btn_basic_sns_save")--//
	Image_save = cocostudio.getUIImageView(view, "Image_save");--//

	-----------------------------基本信息---兑奖---------------------------
	txt_basic_duijiang_username =  cocostudio.getUITextField(view, "txt_basic_duijiang_username");--//
	txt_basic_duijiang_username:setVisible(false);
	label_basic_duijiang_username =  cocostudio.getUILabel(view, "Label_basic_duijiang_username");--//

	txt_basic_duijiang_phone =  cocostudio.getUITextField(view, "txt_basic_duijiang_phone");--//
	txt_basic_duijiang_phone:setVisible(false);
	label_basic_duijiang_phone =  cocostudio.getUILabel(view, "Label_basic_duijiang_phone");--//

	txt_basic_duijiang_address =  cocostudio.getUITextField(view, "txt_basic_duijiang_address");--//
	txt_basic_duijiang_address:setVisible(false);
	label_basic_duijiang_address =  cocostudio.getUILabel(view, "Label_basic_duijiang_address");--//


	--label_basic_duijiang_email =  cocostudio.getUILabel(view, "Label_basic_duijiang_email");--//

	btn_basic_duijiang_save = cocostudio.getUIImageView(view, "btn_basic_duijiang_save");--//
	Image_duijiang_ok = cocostudio.getUIImageView(view, "Image_duijiang_ok");
	--加载头像
	local useravatorIdSD = Common.getDataForSqlite(CommSqliteConfig.SelfAvatorInSD..profile.User.getSelfUserID())
	if useravatorIdSD ~= nil and useravatorIdSD ~= "" then
		img_basic_sns_avator:loadTextures(useravatorIdSD, useravatorIdSD, "")
		--img_basic_sns_avator:setScale(120/img_basic_sns_avator:getSize().height)
	end
	initTTView();

	--弃用之前的
	txt_basic_sns_username:setTouchEnabled(false)
	txt_basic_sns_password:setTouchEnabled(false)
	txt_basic_sns_info:setTouchEnabled(false)

	label_basic_sns_username:setVisible(false)
	label_basic_sns_password:setVisible(false)
	lable_basic_sns_info:setVisible(false)

     --弃用之前的兑奖信息
	txt_basic_duijiang_username:setTouchEnabled(false) --兑奖用户名(用于输入)
	txt_basic_duijiang_phone:setTouchEnabled(false) --兑奖电话(用于输入)
	txt_basic_duijiang_address:setTouchEnabled(false) --兑奖地址(用于输入)

	label_basic_duijiang_username:setVisible(false) --兑奖用户名(用于显示)
	label_basic_duijiang_phone:setVisible(false)  --兑奖电话(用于显示)
	label_basic_duijiang_address:setVisible(false) --兑奖地址(用于显示)


	createExchangePageEditor();
end

function initTTView()
	--字
	zi_jbxx = cocostudio.getUIImageView(view, "zi_jbxx")--//
	zi_ttpm = cocostudio.getUIImageView(view, "zi_ttpm")--//
	zi_jbsz = cocostudio.getUIImageView(view, "zi_jbsz")--//
	zi_jbdj = cocostudio.getUIImageView(view, "zi_jbdj")--//
	zi_bindPhone = cocostudio.getUIImageView(view, "zi_bindPhone");--//
	zi_jbxx:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_jibenxinxi2.png"))
	-----------------------------天梯信息---基本---------------------------
	img_tianti_basic_jb = cocostudio.getUIImageView(view, "img_tianti_basic_jb")--//
	img_tianti_basic_dj = cocostudio.getUILoadingBar(view, "img_tianti_basic_dj")--//

	lab_tianti_basic_pm = cocostudio.getUILabel(view, "lab_tianti_basic_pm")--//
	lab_tianti_basic_gz = cocostudio.getUILabel(view, "lab_tianti_basic_gz")--//
	lab_tianti_basic_allps = cocostudio.getUILabel(view, "lab_tianti_basic_allps")--//
	lab_tianti_basic_sl = cocostudio.getUILabel(view, "lab_tianti_basic_sl")--//
	btn_tianti_basic_lgz = cocostudio.getUIButton(view, "btn_tianti_basic_lgz")--//
	ImageView_GuiZe = cocostudio.getUIImageView(view, "ImageView_GuiZe");--//
	lab_tianti_basic_bl = cocostudio.getUILabel(view, "lab_tianti_basic_bl")--//
	lab_tiantidengji = cocostudio.getUILabelAtlas(view, "lab_tiantidengji")--//
	ImageView_2094 = cocostudio.getUIImageView(view, "ImageView_2094")

	-----------------------------天梯信息---排名---------------------------
	scroll_ttpm = cocostudio.getUIScrollView(view, "scroll_ttpm")--//

	-----------------------------天梯信息---帮助---------------------------
	----定时器，更新时间
	updateUserinfoTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(isUserInfoUpdate,1,false)

end
--用户信息是否改过
function isUserInfoUpdate()
	--如果是基本信息修改或者兑奖信息  ，则显示修改按钮
	if panelTabName ==  PANEL_BASIC_BASIC   then
		--		btn_basic_duijiang_ok:setTouchEnabled(false)
		--個人基本信息
		local updatelength = 0
		local now_username = edit_userinfo:getText() --label_basic_sns_username:getStringValue()
		local now_userpassword = edit_password:getText()  --label_basic_sns_password:getStringValue()
		local now_userinfo = edit_signname:getText() --lable_basic_sns_info:getStringValue()

		local now_usersex = userSelectSex
		local now_userold = lab_basic_sns_year:getStringValue()
		local now_useraddress = lab_basic_sns_address:getStringValue()

		if now_username ~= profile.User.getSelfNickName() then
			updatelength = updatelength+1
		end
		if now_userpassword ~= profile.User.getSelfPassword() then
			updatelength = updatelength+1
		end
		if now_usersex ~= profile.User.getSelfSex() then
			updatelength = updatelength+1
		end
		if profile.User.getAgeValueByTxt(now_userold) ~= profile.User.getSelfBirthDay() then
			updatelength = updatelength+1
		end
		if now_useraddress ~= profile.User.getSelfCity() then
			updatelength = updatelength+1
		end
		if now_userinfo ~= profile.User.getSelfsign() then
			updatelength = updatelength+1
		end

		if updatelength == 0 then
			btn_basic_sns_save:loadTexture(Common.getResourcePath("btn_gerenziliao0_no.png"))
			Image_save:loadTexture(Common.getResourcePath("btn_gerenziliao_baocun_no.png"))
			btn_basic_sns_save:setTouchEnabled(false)
		else
			btn_basic_sns_save:loadTexture(Common.getResourcePath("btn_gerenziliao0.png"))
			Image_save:loadTexture(Common.getResourcePath("btn_gerenziliao_baocun.png"))
			btn_basic_sns_save:setTouchEnabled(true)
		end

	elseif panelTabName == PANEL_BASIC_DUIJIANG then
		--兌獎信息  btn_basic_sns_save   btn_basic_duijiang_ok
		local updatelengthdj = 0
		local djusername = edit_exchange_tab[1]:getText(); --label_basic_duijiang_username:getStringValue()
		local djphone    = edit_exchange_tab[2]:getText(); --label_basic_duijiang_phone:getStringValue()
		local djaddress  = edit_exchange_tab[3]:getText(); --label_basic_duijiang_address:getStringValue()
		--local djemail = label_basic_duijiang_email:getStringValue()   --弃用邮编


		local djnamesql = Common.getDataForSqlite(CommSqliteConfig.SendAwardUsername..profile.User.getSelfUserID())
		local djphonesql = Common.getDataForSqlite(CommSqliteConfig.SendAwardPhone..profile.User.getSelfUserID())
		local djaddresssql = Common.getDataForSqlite(CommSqliteConfig.SendAwardAddress..profile.User.getSelfUserID())
		local djemailsql = Common.getDataForSqlite(CommSqliteConfig.SendAwardEmail..profile.User.getSelfUserID())

		if djusername ~= nil and djusername ~= "" and djusername ~= djnamesql  then
			updatelengthdj = updatelengthdj+1
		end
		if djphone ~= nil and djphone ~= "" and  djphone ~= djphonesql then
			updatelengthdj = updatelengthdj+1
		end
		if djaddress ~= nil and djaddress ~= "" and  djaddress ~= djaddresssql then
			updatelengthdj = updatelengthdj+1
		end
		if djemail ~= nil and djemail ~= "" and  djemail ~= djemailsql then
			updatelengthdj = updatelengthdj+1
		end
		Common.log("需要修改兑奖个人信息"..updatelengthdj)
		if updatelengthdj == 0 then
			btn_basic_duijiang_save:loadTexture(Common.getResourcePath("btn_gerenziliao0_no.png"))
			Image_duijiang_ok:loadTexture(Common.getResourcePath("btn_gerenziliao_baocun_no.png"))
			btn_basic_duijiang_save:setTouchEnabled(false)
		else
			btn_basic_duijiang_save:loadTexture(Common.getResourcePath("btn_gerenziliao0.png"))
			Image_duijiang_ok:loadTexture(Common.getResourcePath("btn_gerenziliao_baocun.png"))
			btn_basic_duijiang_save:setTouchEnabled(true)
		end
	else

	end

end
--切换panel界面
function setPanel(panelName)
	if panelTabName == panelName then
		return;
	end
	panelTabName = panelName
	--	Common.hideWebView()
	if panelName == PANEL_BASIC_BASIC then
		--基本信息---基本
		setVisibleForUserInfo(true)
		setVisibleForExchangePage(false)

		panel_basic_basic:setVisible(true)
		panel_basic_basic:setZOrder(4)
		panel_basic_basic:setTouchEnabled(true)
		panel_basic_duijiang:setVisible(false)
		panel_basic_duijiang:setZOrder(3)
		panel_basic_duijiang:setTouchEnabled(false)
		panel_tianti_basic:setVisible(false)
		panel_tianti_basic:setZOrder(3)
		panel_tianti_basic:setTouchEnabled(false)
		panel_basic_menu:setVisible(true)
		panel_basic_menu:setZOrder(4)
		panel_basic_menu:setTouchEnabled(true)
		panel_bag_menu:setVisible(false)
		panel_bag_menu:setZOrder(3)
		panel_bag_menu:setTouchEnabled(false)
		Panel_Bag:setVisible(false)
		Panel_Bag:setZOrder(3)
		Panel_Bag:setTouchEnabled(false)
		btn_basic_sns_save:loadTexture(Common.getResourcePath("btn_gerenziliao0_no.png"))

		--tab更新背景
		img_tianti_paiming:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_basic_sns:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		img_basic_duijiang:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))

		zi_ttpm:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_tiantixinxi.png"))
		zi_jbsz:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_gerenxinxi2.png"))
		zi_jbdj:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_duijiang.png"))


	elseif panelName == PANEL_BASIC_DUIJIANG then
		--基本信息---兑奖
		setVisibleForUserInfo(false)
		setVisibleForExchangePage(true)

		panel_basic_basic:setVisible(false)
		panel_basic_basic:setZOrder(3)
		panel_basic_basic:setTouchEnabled(false)
		panel_basic_duijiang:setVisible(true)
		panel_basic_duijiang:setZOrder(4)
		panel_basic_duijiang:setTouchEnabled(true)
		panel_tianti_basic:setVisible(false)
		panel_tianti_basic:setZOrder(3)
		panel_tianti_basic:setTouchEnabled(false)
		panel_basic_menu:setVisible(true)
		panel_basic_menu:setZOrder(4)
		panel_basic_menu:setTouchEnabled(true)
		panel_bag_menu:setVisible(false)
		panel_bag_menu:setZOrder(3)
		panel_bag_menu:setTouchEnabled(false)
		Panel_Bag:setVisible(false)
		Panel_Bag:setZOrder(3)
		Panel_Bag:setTouchEnabled(false)
		--tab更新背景
		img_tianti_paiming:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_basic_sns:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_basic_duijiang:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))

		zi_ttpm:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_tiantixinxi.png"))
		zi_jbsz:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_gerenxinxi.png"))
		zi_jbdj:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_duijiang2.png"))
		--		GameArmature.hideVipSaleArmatureOfUserInfo()

	elseif panelName == PANEL_TIANTI_BASIC then
		--天梯信息---基本
		setVisibleForUserInfo(false)
		setVisibleForExchangePage(false)

		img_tianti_paiming:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		img_basic_sns:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		img_basic_duijiang:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))

		zi_ttpm:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_tiantixinxi2.png"))
		zi_jbsz:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_gerenxinxi.png"))
		zi_jbdj:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_duijiang.png"))
		panel_basic_basic:setVisible(false)
		panel_basic_basic:setZOrder(3)
		panel_basic_basic:setTouchEnabled(false)
		panel_basic_duijiang:setVisible(false)
		panel_basic_duijiang:setZOrder(3)
		panel_basic_duijiang:setTouchEnabled(false)
		panel_tianti_basic:setVisible(true)
		panel_tianti_basic:setZOrder(4)
		panel_tianti_basic:setTouchEnabled(true)
		panel_basic_menu:setVisible(true)
		panel_basic_menu:setZOrder(4)
		panel_basic_menu:setTouchEnabled(true)
		panel_bag_menu:setVisible(false)
		panel_bag_menu:setZOrder(3)
		panel_bag_menu:setTouchEnabled(false)
		Panel_Bag:setVisible(false)
		Panel_Bag:setZOrder(3)
		Panel_Bag:setTouchEnabled(false)

		ttList();
	elseif  panelName == PANEL_BAG_PROPS then
		setVisibleForUserInfo(false)
		setVisibleForExchangePage(false)

		panel_basic_basic:setVisible(false)
		panel_basic_basic:setZOrder(3)
		panel_basic_basic:setTouchEnabled(false)
		panel_basic_duijiang:setVisible(false)
		panel_basic_duijiang:setZOrder(3)
		panel_basic_duijiang:setTouchEnabled(false)
		panel_tianti_basic:setVisible(false)
		panel_tianti_basic:setZOrder(3)
		panel_tianti_basic:setTouchEnabled(false)
		panel_basic_menu:setVisible(false)
		panel_basic_menu:setZOrder(3)
		panel_basic_menu:setTouchEnabled(false)
		panel_bag_menu:setVisible(true)
		panel_bag_menu:setZOrder(4)
		panel_bag_menu:setTouchEnabled(true)
		Panel_Bag:setVisible(true)
		Panel_Bag:setZOrder(4)
		Panel_Bag:setTouchEnabled(true)
		Image_duanhuanInfo:setVisible(true)
		img_bag_Props:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		zi_Props:loadTexture(Common.getResourcePath("ui_beibao_wodedaoju1.png"))
		img_bag_Tickets:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		zi_Tickets:loadTexture(Common.getResourcePath("ui_beibao_wodemenpiao.png"))
		initPropsView();
	elseif  panelName == PANEL_BAG_TICKETS then
		setVisibleForUserInfo(false)
		panel_basic_basic:setVisible(false)
		panel_basic_basic:setZOrder(3)
		panel_basic_basic:setTouchEnabled(false)
		panel_basic_duijiang:setVisible(false)
		panel_basic_duijiang:setZOrder(3)
		panel_basic_duijiang:setTouchEnabled(false)
		panel_tianti_basic:setVisible(false)
		panel_tianti_basic:setZOrder(3)
		panel_tianti_basic:setTouchEnabled(false)
		panel_basic_menu:setVisible(false)
		panel_basic_menu:setZOrder(3)
		panel_basic_menu:setTouchEnabled(false)
		panel_bag_menu:setVisible(true)
		panel_bag_menu:setZOrder(4)
		panel_bag_menu:setTouchEnabled(true)
		Panel_Bag:setVisible(true)
		Panel_Bag:setZOrder(4)
		Panel_Bag:setTouchEnabled(true)
		btn_basic_sns_save:setTouchEnabled(false)
		btn_basic_sns_save:setVisible(false)
		Image_duanhuanInfo:setVisible(false)
		img_bag_Props:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		zi_Props:loadTexture(Common.getResourcePath("ui_beibao_wodedaoju.png"))
		img_bag_Tickets:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		zi_Tickets:loadTexture(Common.getResourcePath("ui_beibao_wodemenpiao1.png"))
		initMenPiaoView();
	end
end

--[[--
--门票界面
--]]
function initMenPiaoView()
	ScrollView_BagInfo:removeAllChildren()
	local cellSize = 0
	if(menPiaoTable)then
		cellSize = #menPiaoTable ---门票数量
	end

	local viewW = 0
	local viewH = 0
	local viewX = 0
	local viewY = 0
	local viewWmax = 876;
	local viewHMax = 400;

	local cellWidth = 209; --每个元素的宽
	local cellHeight = 224; --每个元素的高

	local lieSize = 4 --列数
	local hangSize = math.floor((cellSize + (lieSize - 1)) / lieSize) --行数
	local spacingW = 10; --横向间隔
	local spacingH = 20 --纵向间隔
	local leftmargin  = 5;
	viewH = math.ceil((cellSize+1)/lieSize)*(cellHeight+spacingH);
	if  viewH < viewHMax then
		viewH = viewHMax
	end

	ScrollView_BagInfo:setInnerContainerSize(CCSizeMake(viewWmax, viewH));
	ScrollView_BagInfo:setSize(CCSizeMake(viewWmax, viewHMax))
	ScrollView_BagInfo:setPosition(ccp(viewX, viewY))
	--适配需要：对列表进行缩放横坐标和纵坐标的缩放
	ScrollView_BagInfo:setScaleX(GameConfig.ScaleAbscissa);
	ScrollView_BagInfo:setScaleY(GameConfig.ScaleOrdinate);
	if cellSize == 0 then
		local labelName = ccs.label({
			text = "您还没有任何门票",
			color = ccc3(193,150,108),
		})
		labelName:setFontSize(25)
		SET_POS(labelName, ScrollView_BagInfo:getSize().width / 2,ScrollView_BagInfo:getSize().height / 2)
		ScrollView_BagInfo:addChild(labelName)
	else
		PackImageTicketTable = {};
		local TicketItemList = {};
		for i = 0, cellSize - 1 do
			--背景
			local bgurl = "bg_bag_item.png"

			local layout = ccs.image({
				scale9 = false,
				size = CCSizeMake(cellWidth, cellHeight),
				image = Common.getResourcePath(bgurl),
				capInsets = CCRectMake(0, 0, 0, 0),
			})
			layout:setScale9Enabled(true);

			local button = ccs.button({
				scale9 = true,
				size = CCSizeMake(cellWidth, cellHeight),
				pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
				normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
				text = "",
				capInsets = CCRectMake(0, 0, 0, 0),
				listener = {
					[ccs.TouchEventType.began] = function(uiwidget)
						layout:setScale(1.1)
					end,
					[ccs.TouchEventType.moved] = function(uiwidget)
					end,
					[ccs.TouchEventType.ended] = function(uiwidget)
						layout:setScale(1)
						if(menPiaoTable[i+1].TicketStatus == 1)then

							Common.showToast("您已报名此比赛！",2)
							return
						else
							if(GameConfig.GAME_ID == menPiaoTable[i+1].GameID)then
								--打开比赛
								local MatchTable = {}
								MatchTable["MatchList"] = {}
								MatchTable["MatchList"] = profile.Match.getMatchTable()
								if #MatchTable["MatchList"] > 0 then
									for i=1,#MatchTable["MatchList"] do
										if menPiaoTable[i+1].MatchID == MatchTable["MatchList"][i].MatchID then
											MatchDetailLogic.setNowEntrance(MatchDetailLogic.BM_ENTRANCE)
											MatchDetailLogic.setDetailWithMatchItem_V4(MatchTable["MatchList"][i])
											mvcEngine.createModule(GUI_MATCHDETAIL)
										end
									end
								end
							else
								Common.showToast("正在开发中,敬请期待",2)
							end
						end
					end,
					[ccs.TouchEventType.canceled] = function(uiwidget)
						layout:setScale(1)
					end,
				}
			})
			local imageGooods = ccs.image({
				scale9 = false,
				image = "",
			})
			local packID =  menPiaoTable[i+1].TicketId;
			PackImageTicketTable[""..(i + 1)] = imageGooods;
			PackImageTicketTable[""..(i + 1)]:setVisible(false);
			if menPiaoTable[i+1].TicketIcon ~= nil and  menPiaoTable[i+1].TicketIcon ~= ""  then
				Common.getPicFile(menPiaoTable[i+1].TicketIcon, (i + 1), true, updataImageticket)
			end

			SET_POS(button, 0, 0)

			--道具信息
			local labelName = ccs.label({
				text = menPiaoTable[i+1].TicketName,
				size = CCSizeMake(cellWidth - 20, cellHeight / 3),
				color = ccc3(92,60,34),
			})
			labelName:setTextAreaSize(CCSizeMake(150, cellHeight / 2))
			labelName:setFontSize(20)

			--到期时间
			local labetime = ccs.label({
				text = menPiaoTable[i+1].TicketExpirationTime,
				size = CCSizeMake(cellWidth - 20, cellHeight / 3),
			})
			labetime:setTextAreaSize(CCSizeMake(193, 30))
			labetime:setTextHorizontalAlignment(kCCTextAlignmentCenter)
			labetime:setColor(ccc3(249,235,219))
			labetime:setFontSize(20)
			labetime:setZOrder(5);
			local timeBg =  ccs.image({
				scale9 = false,
				image = Common.getResourcePath("bg_exchange_remainder.png"),
				capInsets = CCRectMake(0, 0, 0, 0),
			})
			timeBg:setScaleX(193 / timeBg:getContentSize().width);
			timeBg:setScaleY(30 / timeBg:getContentSize().height);
			timeBg:setZOrder(4);
			layout:setScale9Enabled(true);
			--设置名称位置
			SET_POS(labelName, 0, 150 - cellHeight / 2)
			--设置到期时间位置
			SET_POS(labetime, 0, -60)
			SET_POS(timeBg, 0, -60)
			--设置图片位置
			SET_POS(imageGooods, 0, -5)
			layout:addChild(labetime)
			layout:addChild(timeBg)
			layout:addChild(labelName)
			layout:addChild(imageGooods)
			if(menPiaoTable[i+1].TicketStatus == 1)then
				local baomingIcon  = ccs.image({
					scale9 = false,
					image = Common.getResourcePath("bg_macth_label2.png"),
				})
				SET_POS(baomingIcon, layout:getSize().width*0.22 - cellWidth / 2, layout:getSize().height*0.78 - cellHeight / 2)
				layout:addChild(baomingIcon)

				local labelBaoMing = ccs.label({
					text = "已报名",
					size = CCSizeMake(50, 30),
				})

				labelBaoMing:setRotation(-45)
				SET_POS(labelBaoMing,layout:getSize().width*0.17 -cellWidth / 2, layout:getSize().height*0.82 - cellHeight / 2)
				layout:addChild(labelBaoMing)
			end
			layout:addChild(button)
			--所在的页
			local posX = (cellWidth + spacingW)* (i%lieSize) + cellWidth / 2 + leftmargin;
			local posY = viewH - (cellHeight + spacingH)* math.ceil((i + 1) /lieSize) + cellHeight / 2;
			SET_POS(layout, posX, posY)

			table.insert(TicketItemList, layout);

			ScrollView_BagInfo:addChild(layout)
		end
		local function callbackShowImage(index)
			if PackImageTicketTable[""..index] ~= nil then
				PackImageTicketTable[""..index]:setVisible(true);
			end
		end
		LordGamePub.showLandscapeList(TicketItemList,callbackShowImage);
	end
end

--[[[--
--初始化道具
--]]
function initPropsView()
	ScrollView_BagInfo:removeAllChildren()
	PackImageGooodsTable = {}
	PackImageTicketTable = {}
	local cellSize = 0
	if PropsTable ~= nil  then
		cellSize = #PropsTable
	end

	local viewW = 0
	local viewH = 0
	local viewX = 0

	local viewY = 0
	local viewWmax = 856
	local viewHMax = 290;

	local cellWidth = 95; --每个元素的宽
	local cellHeight = 95; --每个元素的高

	local lieSize = 8 --列数
	local hangSize = math.floor((cellSize + (lieSize - 1)) / lieSize) --行数
	local spacingW = 12; --横向间隔
	local spacingH = 12 --纵向间隔
	local leftmargin  = 10;
	viewH = math.ceil((cellSize+1)/lieSize)*(cellHeight+spacingH);

	if  viewH < viewHMax then
		viewH = viewHMax;
	end
	ScrollView_BagInfo:setSize(CCSizeMake(viewWmax, viewHMax))
	ScrollView_BagInfo:setPosition(ccp(viewX, viewY))
	ScrollView_BagInfo:setInnerContainerSize(CCSizeMake(viewWmax, viewHMax));

	if cellSize == 0 then
		local labelName = ccs.label({
			text = "您还没有任何道具",
			color = ccc3(193,150,108),
		})
		labelName:setFontSize(25)
		SET_POS(labelName, ScrollView_BagInfo:getSize().width / 2,ScrollView_BagInfo:getSize().height / 2)
		ScrollView_BagInfo:addChild(labelName)
	else
		PackImageGooodsTable = {};
		local packItemList = {};
		for i = 0, cellSize - 1 do
			local cur = i+1
			--…ID  物品ID
			local packID = PropsTable[cur].ID
			--…itemNum  物品数量
			local packitemNum = PropsTable[cur].itemNum
			--…backpackName  背包显示名称
			local packbackpackName = PropsTable[cur].backpackName
			--…Name  名称
			local packName = PropsTable[cur].Name
			--…goodsType  商品类型
			local packgoodsType = PropsTable[cur].goodsType
			--…goodsProperty  属性 0时效行，1数量型
			local packgoodsProperty = PropsTable[cur].goodsProperty
			--…IconURL  图标url
			local packIconURL = PropsTable[cur].IconURL
			--…Title  标题
			local packTitle = PropsTable[cur].Title
			--…Description  描述
			local packDescription = PropsTable[cur].Description
			--…PurchaseLowerLimit  购买数量下限
			local packPurchaseLowerLimit = PropsTable[cur].PurchaseLowerLimit
			--…PurchaseUpperLimit  购买数量上限
			local packPurchaseUpperLimit = PropsTable[cur].PurchaseUpperLimit
			--…ConsumeType  消耗类型
			local packConsumeType = PropsTable[cur].ConsumeType
			--…Consume  单价
			local packConsume = PropsTable[cur].Consume
			--…VipConsume  Vip单价
			local packVipConsume = PropsTable[cur].VipConsume
			--…statusTagUrl  状态标签url
			local packstatusTagUrl = PropsTable[cur].statusTagUrl
			--…VipUpperLimit  Vip时效上限
			local packIDVipUpperLimit = PropsTable[cur].VipUpperLimit
			--…backpackUpperLimit  背包存储上限
			local packbackpackUpperLimit = PropsTable[cur].backpackUpperLimit

			--取合成符数量
			if packbackpackName == "合成符" then
				hechengfunum = packitemNum
			end

			local packConsumeValue = nil
			if(packgoodsProperty == 1) then
				if packitemNum == nil or packitemNum == "" then
					packitemNum = 0
				end
				packConsumeValue =packitemNum
			else
				local syhour = packIDVipUpperLimit%24
				local syday = math.floor(packIDVipUpperLimit/24)
				if(syhour == 0 and syday == 0 ) then
					packConsumeValue = "0天"
				else
					packConsumeValue = syday.."天,"..syhour.."小时"
				end
			end
			--背景
			local bgurl = "box.png"

			--底层layer
			local layout = ccs.image({
				scale9 = false,
				size = CCSizeMake(cellWidth, cellHeight),
				image = Common.getResourcePath(bgurl),
				capInsets = CCRectMake(0, 0, 0, 0),
			})
			layout:setScale9Enabled(true);
			layout:setAnchorPoint(ccp(0.5, 0.5))

			local button = ccs.button({
				scale9 = true,
				size = CCSizeMake(cellWidth, cellHeight),
				pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
				normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
				text = "",
				capInsets = CCRectMake(0, 0, 0, 0),
				listener = {
					[ccs.TouchEventType.began] = function(uiwidget)
						layout:setScale(1.1)
					end,
					[ccs.TouchEventType.moved] = function(uiwidget)
					--[[Common.log("Touch Move" .. i)]]
					end,
					[ccs.TouchEventType.ended] = function(uiwidget)
						layout:setScale(1)
						mvcEngine.createModule(GUI_BACKDETAIL)
						BackDetailLogic.setPackData(packbackpackName, packDescription, packIconURL,bgurl)
					end,
					[ccs.TouchEventType.canceled] = function(uiwidget)
						layout:setScale(1)
					end,
				}
			})
			button:setZOrder(5);

			--道具信息
			local labelConsume = ccs.label({
				text = packConsumeValue,
			--				color = ccc3(255, 255, 25),
			})
			labelConsume:setFontSize(22)
			labelConsume:setZOrder(4)
			local imageGooodsBg = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("ui_liangdian.png"),
			})
			imageGooodsBg:setScale(cellWidth / imageGooodsBg:getContentSize().width );
			--道具图片
			local imageGooods = ccs.image({
				scale9 = false,
				image = "",
			})
			imageGooods:setZOrder(3)
			PackImageGooodsTable[""..(i + 1)] = imageGooods
			PackImageGooodsTable[""..(i + 1)]:setVisible(false);
			if packIconURL ~= nil and  packIconURL ~= ""  then
				Common.getPicFile(packIconURL, (i + 1), true, updataImageProps)
			end

			local posX = (cellWidth + spacingW)* ((i)%lieSize + 1) - cellWidth / 2;
			local posY = viewH + cellHeight / 2 - (cellHeight + spacingH)* math.ceil((i+1)/lieSize);
			SET_POS(button, 0, 0)
			SET_POS(imageGooodsBg, 0, 0)
			--设置价格
			SET_POS(labelConsume, 10, -30)
			--设置图标位置
			SET_POS(imageGooods, 0, 0)
			layout:addChild(labelConsume)
			layout:addChild(imageGooods)
			layout:addChild(button)
			layout:addChild(imageGooodsBg)
			SET_POS(layout, posX, posY);
			table.insert(packItemList, layout);
			ScrollView_BagInfo:addChild(layout)
		end
		--TODO

		--满足至少两行格子
		if cellSize <= 16 and cellSize > 0 then
			--背景
			for i=cellSize, 15 do
				local bgurl = "box.png"

				--底层layer
				local layout = ccs.image({
					scale9 = false,
					size = CCSizeMake(cellWidth, cellHeight),
					image = Common.getResourcePath(bgurl),
					capInsets = CCRectMake(0, 0, 0, 0),
				})
				layout:setScale9Enabled(true);
				layout:setAnchorPoint(ccp(0.5, 0.5))
				local posX = (cellWidth + spacingW)* ((i)%lieSize + 1) - cellWidth / 2;
				local posY = viewH + cellHeight / 2 - (cellHeight + spacingH)* math.ceil((i+1)/lieSize);
				SET_POS(layout, posX, posY);
				ScrollView_BagInfo:addChild(layout)
			end
		end

		local function callbackShowImage(index)
			if PackImageGooodsTable[""..index] ~= nil then
				PackImageGooodsTable[""..index]:setVisible(true);
			end
		end
		LordGamePub.showLandscapeList(packItemList, callbackShowImage);
	end
end

--[[--
--获取道具列表
--]]
function getDBID_BACKPACK_LIST()
	Common.closeProgressDialog()
	PropsTable = profile.Pack.getAll()
	if panelTabName ~= PANEL_BAG_PROPS or PropsTable == nil then
		return;
	end
	initPropsView()
end

function getTICKET_GET_TICKET_LISTInfo()
	menPiaoTable = profile.Pack.getTICKET_GET_TICKET_LISTTable()
	if panelTabName ~= PANEL_BAG_TICKETS or menPiaoTable == nil then
		return;
	end
	initMenPiaoView()
end

function requestMsg()

end

--[[--
--背包-道具-合成
--]]
function callback_Button_Synthesis(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if PriceCompound ~= nil and PriceCompound["PiecesID"] ~= nil and  PropsTable ~= nil then
			FragmentsLogic.setData(PriceCompound, hechengfunum)
			mvcEngine.createModule(GUI_FRAGMENTS)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--背包--道具
--]]
function callback_img_bag_Props(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setPanel(PANEL_BAG_PROPS)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--背包-门票
--]]
function callback_img_bag_Tickets(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setPanel(PANEL_BAG_TICKETS)
	elseif component == CANCEL_UP then
	--取消

	end
end

--返回
function callback_btn_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--		Common.hideWebView()

		LordGamePub.showBaseLayerAction(view)
		if (HallChatLogic.showUserInfoFlag == true) then
			HallChatLogic.showUserInfoFlag = false
		end
	elseif component == CANCEL_UP then
	--取消
	end
end


--基本信息
function callback_img_basic(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		img_basic:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		img_Bag:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		zi_jbxx:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_jibenxinxi2.png"))
		zi_bag:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_beibao.png"))
		setPanel(PANEL_BASIC_BASIC)
	elseif component == CANCEL_UP then
	--取消
	end
end
--我的背包
function callback_img_Bag(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		img_basic:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		img_Bag:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		zi_jbxx:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_jibenxinxi.png"))
		zi_bag:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_beibao2.png"))
		setPanel(PANEL_BAG_PROPS)

	elseif component == CANCEL_UP then
	--取消
	end
end
--左侧按钮
--冲金币
function callback_btn_basic_basic_addcoin(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起

		local myyuanbao = profile.User.getSelfYuanBao()
		if myyuanbao >= 50 then
			Common.openConvertCoin()
		else
			--充值引导
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
			PayGuidePromptLogic.setEnterType(true)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end
--充元宝
function callback_btn_basic_basic_addyuanbao(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起

		GameConfig.setTheLastBaseLayer(GUI_USERINFO)
		mvcEngine.createModule(GUI_SHOP,LordGamePub.runSenceAction(view,nil,true))

	elseif component == CANCEL_UP then
	--取消
	end
end

------------------------------社交信息你---------------------------

function callback_img_basic_sns(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		setPanel(PANEL_BASIC_BASIC)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--做新手任务，显示修改用户名和密码界面
--]]
function logicRenWuModify()
	RenWuLogic.setModifyUserInfo(false);
	setPanel(PANEL_BASIC_BASIC)
end

local function sendUpdataUserInfo()
	sendDBID_USER_INFO(profile.User.getSelfUserID())
end

--修改头像
function callback_lab_basic_sns_changeavator(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.log("上传头像")
		local flag = Common.uploadAvator(sendUpdataUserInfo)
		if Common.platform == Common.TargetIos then
			--ios平台
			if flag then
				Common.showToast("头像上传服务器成功",2)
				sendDBID_USER_INFO(profile.User.getSelfUserID())
			else
				Common.showToast("上传失败", 2)
			end
		elseif Common.platform == Common.TargetAndroid then
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--绑定手机
function callback_Button_bangding(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_USERINFO)
		--setFlag  1绑定,2解绑,-1非手机绑定,-2非手机解绑
		if(operator == 0) then
			if(BindPhone == "" or BindPhone == nil) then
				BindPhoneMsgLogic.setFlag(-1,BindPhoneList,operator)
			else
				BindPhoneMsgLogic.setFlag(-2,BindPhoneList,operator)
			end
			mvcEngine.createModule(GUI_BINDPHONEMSG)
		else
			if(BindPhone == "" or BindPhone == nil) then
				BindPhoneLogic.setFlag(1,BindPhoneList,operator)
			else
				BindPhoneLogic.setFlag(2,BindPhoneList,operator)
			end
			mvcEngine.createModule(GUI_BINDPHONE)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end
--点击男
function callback_check_basic_sns_sexB(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		userSelectSex = 1
		check_basic_sns_sexB:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
		check_basic_sns_sexG:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
		check_basic_sns_sexM:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
	elseif component == CANCEL_UP then
	--取消
	end

end
--点击女
function callback_check_basic_sns_sexG(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		userSelectSex = 2
		check_basic_sns_sexB:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
		check_basic_sns_sexG:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
		check_basic_sns_sexM:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
	elseif component == CANCEL_UP then
	--取消
	end

end
--点击保密
function callback_check_basic_sns_sexM(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		userSelectSex = 0
		check_basic_sns_sexB:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
		check_basic_sns_sexG:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
		check_basic_sns_sexM:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
	elseif component == CANCEL_UP then
	--取消
	end
end
--修改年龄
function callback_lab_basic_sns_year(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		SetOldSexLogic.setYearValue(lab_basic_sns_year:getStringValue())
		SetOldSexLogic.setFlag(1)
		mvcEngine.createModule(GUI_SETOLDSEX)
	elseif component == CANCEL_UP then
	--取消
	end
end
--修改地址
function callback_lab_basic_sns_address(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		CityListLogic.setShengCity(lab_basic_sns_address:getStringValue())
		mvcEngine.createModule(GUI_CITYLIST)
	elseif component == CANCEL_UP then
	--取消
	end
end
--保存
function callback_btn_basic_sns_save(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--保存修改个人信息
		Common.setUmengUserDefinedInfo("user_info_btn_click", "保存")
		local dataTable = {}

		local now_username = edit_userinfo:getText(); --label_basic_sns_username:getStringValue()
		local now_userpassword = edit_password:getText(); --label_basic_sns_password:getStringValue()
		local now_userinfo = edit_signname:getText(); -- lable_basic_sns_info:getStringValue()

		local now_userold = lab_basic_sns_year:getStringValue()

		local username = profile.User.getSelfNickName()
		local password = profile.User.getSelfPassword()
		local now_useraddress = lab_basic_sns_address:getStringValue()
		local changeCnt = 0
		dataTable["editContent"] = {}
		--判断密码不能小于6位
		if Common.utfstrlen(now_userpassword) < 6 then
			Common.showToast("密码不能少于6位哦！",2)
			return
		end

		--3 nickname
		if(now_username ~= username) then
			Common.log(now_username .. username)
			changeCnt = changeCnt + 1
			dataTable["editContent"][changeCnt] = {}
			dataTable["editContent"][changeCnt].attID = 3
			dataTable["editContent"][changeCnt].attVal = now_username
		end
		--4 password
		if(now_userpassword ~= password) then
			Common.log(now_userpassword .. password)
			changeCnt = changeCnt + 1
			dataTable["editContent"][changeCnt] = {}
			dataTable["editContent"][changeCnt].attID = 4
			dataTable["editContent"][changeCnt].attVal = now_userpassword
		end
		--5 sex
		changeCnt = changeCnt + 1
		dataTable["editContent"][changeCnt] = {}
		dataTable["editContent"][changeCnt].attID = 5
		dataTable["editContent"][changeCnt].attVal = userSelectSex
		--6 出生年月
		changeCnt = changeCnt + 1
		dataTable["editContent"][changeCnt] = {}
		dataTable["editContent"][changeCnt].attID = 30
		dataTable["editContent"][changeCnt].attVal = profile.User.getAgeValueByTxt(now_userold);
		--11 city
		changeCnt = changeCnt + 1
		dataTable["editContent"][changeCnt] = {}
		dataTable["editContent"][changeCnt].attID = 11
		dataTable["editContent"][changeCnt].attVal = now_useraddress
		--14 info
		changeCnt = changeCnt + 1
		dataTable["editContent"][changeCnt] = {}
		dataTable["editContent"][changeCnt].attID = 14
		dataTable["editContent"][changeCnt].attVal = now_userinfo

		dataTable["userID"] = profile.User.getSelfUserID()
		dataTable["editCnt"] = changeCnt
		sendBASEID_EDIT_BASEINFO(dataTable)

	elseif component == CANCEL_UP then
	--取消
	end
end
------------------------------兑奖信息-----------------------
function callback_img_basic_duijiang(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		setPanel(PANEL_BASIC_DUIJIANG)
	elseif component == CANCEL_UP then
	--取消
	end
end


--保存兑奖信息
function callback_btn_basic_duijiang_save(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local dj_name  = edit_exchange_tab[1]:getText(); --label_basic_duijiang_username:getStringValue()
		local dj_phone = edit_exchange_tab[2]:getText(); --label_basic_duijiang_phone:getStringValue()
		local dj_address = edit_exchange_tab[3]:getText(); --label_basic_duijiang_address:getStringValue()
		--local dj_email = label_basic_duijiang_email:getStringValue()
		if edit_exchange_tab[1]:getText() == "" or
		   edit_exchange_tab[2]:getText() == "" or
		   edit_exchange_tab[3]:getText() == ""  then
			Common.showToast("请将信息填写完整", 2)
		else
			Common.setDataForSqlite(CommSqliteConfig.SendAwardUsername..profile.User.getSelfUserID(),dj_name )--姓名
			Common.setDataForSqlite(CommSqliteConfig.SendAwardPhone..profile.User.getSelfUserID(), dj_phone)--手机号
			Common.setDataForSqlite(CommSqliteConfig.SendAwardAddress..profile.User.getSelfUserID(), dj_address)--地址
			Common.setDataForSqlite(CommSqliteConfig.SendAwardEmail..profile.User.getSelfUserID(),dj_email )--email
			Common.showToast("保存兑奖信息成功", 2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--初始化天梯信息
--]]
function initTianTiInfo()
	lab_tianti_basic_pm:setText(profile.User.getSelfLadderRanking())--排名
	lab_tianti_basic_allps:setText(profile.User.getSelfRound())--盘数
	lab_tianti_basic_sl:setText(profile.User.getSelfWinRate().."%")--胜率
	lab_tiantidengji:setStringValue(profile.User.getSelfLadderLevel())
	local duanwei = profile.User.getSelfLadderDuan()
	local ttjf = profile.User.getSelfLadderScore()   --天梯积分
	local nextttjf = profile.User.getSelfLadderUpScore()   --下一级需要积分
	local lastttjf = profile.User.getSelfLadderDownScore()--降级需要积分
	local bl = 0
	if nextttjf - lastttjf > 0 then
		bl = (ttjf-lastttjf) / (nextttjf-lastttjf)
	end
	if bl < 0 then
		bl = 0;
	end
	Common.log("bl = "..bl)
	img_tianti_basic_dj:setPercent(bl*100)
	lab_tianti_basic_bl:setText(ttjf .."/"..nextttjf)

	--段位
	img_tianti_basic_jb:loadTexture(Common.getResourcePath(profile.TianTiData.getDuanWeiImage(duanwei)))
	--
	ImageView_2094:loadTexture(Common.getResourcePath(profile.TianTiData.getDuanWeiType(duanwei)))


	--是否领过工资 1没领过 0领过 2没有资格
	local isLinggz = profile.User.getSelfSalaried()
	if isLinggz == 1 then
		lab_tianti_basic_gz:setText(profile.User.getSelfSalary())--工资
	else
		if isLinggz == 0 then
			lab_tianti_basic_gz:setText(TTLGZ_LG)--領過工资
			btn_tianti_basic_lgz:setTouchEnabled(false)
			btn_tianti_basic_lgz:setVisible(false)
		else
			lab_tianti_basic_gz:setText(TTLGZ_NOZG)--沒有領工资
		end
	end
end

---------------------天梯排名---------------------
function callback_img_tianti_paiming(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--初始化天梯信息
		setPanel(PANEL_TIANTI_BASIC)
		initTianTiInfo();
	--发消息
	--Common.showProgressDialog("数据加载中，请稍后...")
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--天梯帮助
--]]
function callback_ImageView_GuiZe(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--TODO
		--		Common.showToast("天梯帮助", 2);
		--zblanniu---
		mvcEngine.createModule(GUI_TIANTIHELP)
	elseif component == CANCEL_UP then
	--取消
	end
end
------------------------天体基本信息----------------

--领工资
function callback_btn_tianti_basic_lgz(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--比赛赢奖按钮是否开启
		if not profile.ButtonsStatus.isButtonAvailable(HallButtonConfig.BTN_ID_MATCH_GAME) then
			--该按钮不开启时
			local tips = profile.ButtonsStatus.getButtonToast(HallButtonConfig.BTN_ID_MATCH_GAME);
			Common.showToast(tips, 2);
			return;
		end

		--没有资格领工资的跳到比赛--天梯排位赛
		--有资格的领工资
		local lgzString = lab_tianti_basic_gz:getStringValue()
		if lgzString == TTLGZ_NOZG then
			--沒資格領
			mvcEngine.createModule(GUI_TIANTIZIGENOT)
		elseif lgzString == TTLGZ_LG then

		else
			sendLADDER_SALARY()
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

------------------------------------------------其他界面调用的方法--------------
function setOldValue(value)
	lab_basic_sns_year:setText(value)
end
function setAddressFromCityList(value)
	lab_basic_sns_address:setText(value)
end
----------------信号回调----
----绑定手机
function bindPhone()
	BindPhone = profile.BindPhone.getBindPhone()
	BindPhoneList = profile.BindPhone.getBindPhoneList()

	if(BindPhone == nil or BindPhone == "" ) then
		lab_basic_sns_phone:setText("手机号是找回密码唯一途径，强烈建议您绑定！")
		zi_bindPhone:loadTexture(Common.getResourcePath("ui_gerenziliao_btn_bangding.png"));
	else
		lab_basic_sns_phone:setText(BindPhone.."   当前绑定")
		zi_bindPhone:loadTexture(Common.getResourcePath("jiechubangding.png"));
	end
end
--更新用户信息
function updataUserInfo()

	local photoUrl = profile.User.getSelfPhotoUrl()
	Common.getPicFile(photoUrl, 0, true, updateAvator)

	if lab_basic_basic_coin ~= nil then
		lab_basic_basic_coin:setText(profile.User.getSelfCoin());
	end
	if lab_basic_basic_suipian ~= nil then
		lab_basic_basic_suipian:setText(profile.User.getSelfdjqPieces());
	end
	if lab_basic_basic_yuanbao ~= nil then
		lab_basic_basic_yuanbao:setText(profile.User.getSelfYuanBao());
	end
	if lab_basic_basic_duijiangquan ~= nil then
		lab_basic_basic_duijiangquan:setText(profile.User.getDuiJiangQuan());
	end

end
--更新完用户信息回调
function modifyUserInfo()
	local result = profile.ModifyUserInfo.getResult()
	local resultTxt = profile.ModifyUserInfo.getResultText()

	local now_username = edit_userinfo:getText(); --label_basic_sns_username:getStringValue()
	local now_userpassword = edit_password:getText(); --label_basic_sns_password:getStringValue()
	local now_userinfo = edit_signname:getText(); -- lable_basic_sns_info:getStringValue()

	local now_usersex = userSelectSex
	local now_userold = lab_basic_sns_year:getStringValue()
	local now_useraddress = lab_basic_sns_address:getStringValue()

	Common.log("setModifyUserInfoSucess" .. resultTxt..result)
	--Common.log("setModifyUserInfoSucess" .. now_userinfo..now_usersex..now_userold..now_useraddress)
	if(result == 0) then

		profile.User.setSelfNickName(now_username)
		profile.User.setSelfPassword(now_userpassword)
		profile.User.setSelfSex(now_usersex)
		profile.User.setSelfBirthDay(profile.User.getAgeValueByTxt(now_userold))
		profile.User.setSelfCity(now_useraddress)
		profile.User.setSelfsign(now_userinfo)
		--更新json文件
		local userinfo = {}
		local username = profile.User.getSelfNickName()
		local password = profile.User.getSelfPassword()
		userinfo["UserID"] = profile.User.getSelfUserID()
		userinfo["nickname"] = username
		userinfo["password"] = password
		Common.SaveShareUserTable("lastLoginUserInfo", userinfo)
		--sendDBID_USER_INFO(profile.User.getSelfUserID())
		--斗地主记录所有登陆昵称和密码
		Common.setDataForSqlite(CommSqliteConfig.UserNicknameAndPassword..username,password)
	end
	Common.showToast(resultTxt, 2)
end

--更新天梯头像
local function updateTTAvator(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if (photoPath ~= nil and photoPath ~= "" and TTListImageList[""..id] ~= nil) then
		TTListImageList[""..id]:loadTexture(photoPath)
		TTListImageList[""..id]:setScale(0.8)
	end
end

--天梯排名
function ttList()
	TTListTable = profile.TianTiData.getTTTable()
	if panelTabName ~= PANEL_TIANTI_BASIC or TTListTable == nil or TTListTable["TtPaihangtable"] == nil then
		return;
	end
	--赋值
	--	lab_ttMypm:setText(profile.User.getSelfLadderRanking())--排名
	--天梯头像
	local cellWidth = 856 --每个元素的宽
	local cellHeight = 90 --每个元素的高
	local length = #TTListTable["TtPaihangtable"]
	scroll_ttpm:setSize(CCSizeMake(cellWidth, 262));
	scroll_ttpm:setInnerContainerSize(CCSizeMake(cellWidth, cellHeight * (length)))
	scroll_ttpm:removeAllChildren()
	--适配需要：对列表进行缩放横坐标和纵坐标的缩放
	scroll_ttpm:setScaleX(GameConfig.ScaleAbscissa);
	scroll_ttpm:setScaleY(GameConfig.ScaleOrdinate);
	for i=1,length do
		local bg = "";
		if i % 2 == 0 then
			bg = "bg_paihangbang_di2.png"
		else
			bg = "bg_paihangbang_di1.png"
		end
		--背景
		local imagebg = ccs.image({
			scale9 = false,
			image = Common.getResourcePath(bg),
			size = CCSizeMake(856, 90),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		imagebg:setScale9Enabled(true);
		imagebg:setZOrder(0);

		local jiangbei = ""
		if i == 1 then
			jiangbei = "ic_paihangbang_num1.png"
		elseif i == 2 then
			jiangbei = "ic_paihangbang_num2.png"
		elseif i == 3 then
			jiangbei = "ic_paihangbang_num3.png"
		end
		--奖杯
		local jiangbeiBg = nil
		if i == 1 or i == 2 or i == 3  then
			jiangbeiBg =  ccs.image({
				scale9 = false,
				image = Common.getResourcePath(jiangbei),
				size = CCSizeMake(54, 58),
			})
		end

		--昵称
		local labelName = ccs.label({
			text = string.format(TTListTable["TtPaihangtable"][i].userName),
		})
		labelName:setFontSize(22)
		--排名
		local labelPm = ccs.label({
			text = string.format("NO."..i),
		})
		labelPm:setFontSize(22)
		labelPm:setAnchorPoint(ccp(0.5, 0.5))
		--前三名头像
		local imageavator = nil
		if i == 1 or i == 2 or i == 3  then
			local imgurl = TTListTable["TtPaihangtable"][i].userPic
			imageavator = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("hall_portrait_default.png"),
				size = CCSizeMake(60,60),
			})
			imageavator:setScale(0.9)

			TTListImageList[""..i] = imageavator
			if imgurl ~= nil and  imgurl ~= ""  then
				Common.getPicFile(imgurl, i, true, updateTTAvator)
			end

		end
		local duanwei = TTListTable["TtPaihangtable"][i].duan;
		--积分图片
		local ttjfpng = ccs.image({
			scale9 = false,
			image = Common.getResourcePath(profile.TianTiData.getDuanWeiImage(duanwei)),
			size = CCSizeMake(95,97),
		})
		ttjfpng:setScale(0.6);
		--积分
		local labelJf = ccs.label({
			text = string.format(TTListTable["TtPaihangtable"][i].score),
		})
		labelJf:setFontSize(22)
		local jfbg = ccs.button({
			scale9 = true,
			size = CCSizeMake(250, 36),
			pressed = Common.getResourcePath("bg_paihangbang_paiming.png"),
			normal = Common.getResourcePath("bg_paihangbang_paiming.png"),
			text = "",
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		jfbg:setScale9Enabled(true);
		--vip
		local viplevel = TTListTable["TtPaihangtable"][i].vip
		local vipjb = VIPPub.getUserVipType(viplevel)
		local vip = nil
		local vipnum = nil
		if tonumber(viplevel) > 0 then
			vip = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("hall_vip_icon.png"),
				size = CCSizeMake(56,54),
			})
			vipnum = ccs.labelAtlas({
				text = vipjb,
				start = "0",
				image = Common.getResourcePath("num_vip_level.png"),
				w = 12,
				h = 19,
			})
		end

		--底层背景layer
		local layout = ccs.panel({
			scale9 = false,
			image = "",
			size = CCSizeMake(cellWidth,cellHeight-5),
			capInsets = CCRectMake(0, 0, 0, 0),
		})

		SET_POS(labelName, layout:getSize().width / 2, layout:getSize().height / 2 - 10)
		SET_POS(labelPm, 50 , layout:getSize().height / 2 - 10)
		if i == 1 or i == 2 or i == 3  then
			SET_POS(jiangbeiBg, jiangbeiBg:getSize().width + 10 , layout:getSize().height / 2 - 10)
			SET_POS(imageavator, 180 , layout:getSize().height / 2 - 10)

		end
		SET_POS(jfbg, 700, layout:getSize().height / 2 - 10)
		if viplevel > 0 then
			SET_POS(vip, 280, layout:getSize().height / 2- 10)
			SET_POS(vipnum, 229+vip:getSize().width, layout:getSize().height / 2 - 10)
		end--ttjfpng
		SET_POS(ttjfpng, 600, layout:getSize().height / 2 - 10)
		SET_POS(labelJf, 750, layout:getSize().height / 2 - 10)
		SET_POS(layout, 0,cellHeight * (length- i) + 10 )
		SET_POS(imagebg, layout:getSize().width / 2,layout:getSize().height / 2 - 10 )

		layout:addChild(imagebg)
		layout:addChild(labelName)
		if i == 1 or i == 2 or i == 3  then
			layout:addChild(jiangbeiBg)
			layout:addChild(imageavator)
		else
			layout:addChild(labelPm)
		end
		layout:addChild(jfbg)
		if viplevel > 0 then
			layout:addChild(vip)
			layout:addChild(vipnum)
		end
		layout:addChild(ttjfpng)
		layout:addChild(labelJf)

		scroll_ttpm:addChild(layout)
	end
	Common.closeProgressDialog()
end

--[[--
--ios 输入框回调
--]]
local function callbackChatInput(valuetable)
	--控件不能为空
	if currentChatInputText == nil or currentShowText == nil then
		return;
	end

	local value = valuetable["value"];

	--输入数据为空, return
	if value == nil or value == "" then
		if defaultValueLabel ~= nil then
			--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
			currentShowText:setText(defaultValueLabel);
		end
		return;
	end

	--如果用户输入内容,则将输入的内容赋给显示的label
	currentChatInputText:setText(value);
	currentShowText:setText(value);
end

--[[--
--社交 用户名输入框(ios)
--]]
function callback_txt_basic_sns_username_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentChatInputText = txt_basic_sns_username;
		currentShowText = label_basic_sns_username;
		defaultValueLabel = defaultValueLabelsTable["snsUserName"];
		Common.showAlertInput(txt_basic_sns_username:getStringValue(), 0, true, callbackChatInput)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--社交 用户名输入框(Android)
--]]
function callback_txt_basic_sns_username()
	--控件不存在,return
	if label_basic_sns_username == nil then
		return;
	end

	if txt_basic_sns_username:getStringValue() ~= nil and txt_basic_sns_username:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_basic_sns_username:setText(txt_basic_sns_username:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["snsUserName"] ~= nil then
			label_basic_sns_username:setText(defaultValueLabelsTable["snsUserName"]);
		end
	end
end

--[[--
--社交 密码输入框(ios)
--]]
function callback_txt_basic_sns_password_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentChatInputText = txt_basic_sns_password;
		currentShowText = label_basic_sns_password;
		defaultValueLabel = defaultValueLabelsTable["snsPassword"];
		Common.showAlertInput(txt_basic_sns_password:getStringValue(), 0, true, callbackChatInput)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--社交 密码输入框(Android)
--]]
function callback_txt_basic_sns_password()
	--控件不存在,return
	if label_basic_sns_password == nil then
		return;
	end

	if txt_basic_sns_password:getStringValue() ~= nil and txt_basic_sns_password:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_basic_sns_password:setText(txt_basic_sns_password:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["snsPassword"] ~= nil then
			label_basic_sns_password:setText(defaultValueLabelsTable["snsPassword"]);
		end
	end
end

--[[--
--社交 个人签名(ios)
--]]
function callback_txt_basic_sns_info_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentChatInputText = txt_basic_sns_info;
		currentShowText = lable_basic_sns_info;
		defaultValueLabel = defaultValueLabelsTable["snsInfo"];
		Common.showAlertInput(txt_basic_sns_info:getStringValue(), 0, true, callbackChatInput)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--社交 个人签名(Android)
--]]
function callback_txt_basic_sns_info()
	--控件不存在,return
	if lable_basic_sns_info == nil then
		return;
	end

	if txt_basic_sns_info:getStringValue() ~= nil and txt_basic_sns_info:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		lable_basic_sns_info:setText(txt_basic_sns_info:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["snsInfo"] ~= nil then
			lable_basic_sns_info:setText(defaultValueLabelsTable["snsInfo"]);
		end
	end
end

--[[--
--兑奖 昵称输入框(ios)
--]]
function callback_txt_basic_duijiang_username_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentChatInputText = txt_basic_duijiang_username;
		currentShowText = label_basic_duijiang_username;
		defaultValueLabel = defaultValueLabelsTable["duiJiangUserName"];
		Common.showAlertInput(txt_basic_duijiang_username:getStringValue(), 0, true, callbackChatInput)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--兑奖 昵称输入框(Android)
--]]
function callback_txt_basic_duijiang_username()
	--控件不存在,return
	if label_basic_duijiang_username == nil then
		return;
	end

	if txt_basic_duijiang_username:getStringValue() ~= nil and txt_basic_duijiang_username:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_basic_duijiang_username:setText(txt_basic_duijiang_username:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["duiJiangUserName"] ~= nil then
			label_basic_duijiang_username:setText(defaultValueLabelsTable["duiJiangUserName"]);
		end
	end
end

--[[--
--兑奖 电话输入框(ios)
--]]
function callback_txt_basic_duijiang_phone_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentChatInputText = txt_basic_duijiang_phone;
		currentShowText = label_basic_duijiang_phone;
		defaultValueLabel = defaultValueLabelsTable["duiJiangPhone"];
		Common.showAlertInput(txt_basic_duijiang_phone:getStringValue(), 0, true, callbackChatInput)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--兑奖 电话输入框(Android)
--]]
function callback_txt_basic_duijiang_phone()
	--控件不存在,return
	if label_basic_duijiang_phone == nil then
		return;
	end

	if txt_basic_duijiang_phone:getStringValue() ~= nil and txt_basic_duijiang_phone:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_basic_duijiang_phone:setText(txt_basic_duijiang_phone:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["duiJiangPhone"] ~= nil then
			label_basic_duijiang_phone:setText(defaultValueLabelsTable["duiJiangPhone"]);
		end
	end
end

--[[--
--兑奖 地址输入框(ios)
--]]
function callback_txt_basic_duijiang_address_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentChatInputText = txt_basic_duijiang_address;
		currentShowText = label_basic_duijiang_address;
		defaultValueLabel = defaultValueLabelsTable["duiJiangAddress"];
		Common.showAlertInput(txt_basic_duijiang_address:getStringValue(), 0, true, callbackChatInput)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--兑奖 地址输入框(Android)
--]]
function callback_txt_basic_duijiang_address()
	--控件不存在,return
	if label_basic_duijiang_address == nil then
		return;
	end

	if txt_basic_duijiang_address:getStringValue() ~= nil and txt_basic_duijiang_address:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_basic_duijiang_address:setText(txt_basic_duijiang_address:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["duiJiangAddress"] ~= nil then
			label_basic_duijiang_address:setText(defaultValueLabelsTable["duiJiangAddress"]);
		end
	end
end

--[[--
--兑奖 email 输入框(ios)
--]]
function callback_txt_basic_duijiang_email_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentChatInputText = txt_basic_duijiang_email;
		--currentShowText = label_basic_duijiang_email; --弃用邮编
		defaultValueLabel = defaultValueLabelsTable["duiJiangEmail"];
		Common.showAlertInput(txt_basic_duijiang_email:getStringValue(), 0, true, callbackChatInput)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--兑奖 email 输入框(Android)
--]]
function callback_txt_basic_duijiang_email()
	--控件不存在,return
	if label_basic_duijiang_email == nil then
		return;
	end

	if txt_basic_duijiang_email:getStringValue() ~= nil and txt_basic_duijiang_email:getStringValue() ~= "" then
		--如果用户输入内容,则将输入的内容赋给显示的label
		label_basic_duijiang_email:setText(txt_basic_duijiang_email:getStringValue());
	else
		--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
		if defaultValueLabelsTable["duiJiangEmail"] ~= nil then
			label_basic_duijiang_email:setText(defaultValueLabelsTable["duiJiangEmail"]);
		end
	end
end

--天梯领工资
function ttLgz()
	local table = profile.TianTiData.getTTLgz()
	local result = table["result"]--1 成功 0 失败
	local text = table["MsgTxt"]
	Common.log("天梯领工资3"..result..text)
	if result == 1 then
		lab_tianti_basic_gz:setText(TTLGZ_LG)
		btn_tianti_basic_lgz:setTouchEnabled(false)
		btn_tianti_basic_lgz:setVisible(false)
	end
	Common.showToast(text, 2)
end

--[[--
--更新门票图片
--]]
function updataImageticket(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end

	if id ~= nil and photoPath ~= nil and photoPath ~= "" and PackImageTicketTable[""..id] ~= nil then
		PackImageTicketTable[""..id]:loadTexture(photoPath)
	end
end

--[[--
--更新道具图片
]]
function updataImageProps(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if id ~= nil and photoPath~= nil and photoPath ~= "" and PackImageGooodsTable[""..id] ~= nil then
		PackImageGooodsTable[""..id]:loadTexture(photoPath)
		PackImageGooodsTable[""..id]:setScale(0.6);
	end
end

--新手引导直接打开合成碎片
function setOpenFrag(newGuideV)
	newGuide = newGuideV
end

--合成兑奖券的界面信息
function showPrice()
	PriceCompound = profile.Pack.getPriceCompoundList()
	if newGuide and PropsTable ~= nil then
		FragmentsLogic.setData(PriceCompound,hechengfunum)
		mvcEngine.createModule(GUI_FRAGMENTS)
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	--	framework.addSlot2Signal(MANAGERID_GET_VIP_MSG, updataUserVip)
	framework.addSlot2Signal(DBID_USER_INFO, updataUserInfo)
	framework.addSlot2Signal(BASEID_EDIT_BASEINFO, modifyUserInfo)
	framework.addSlot2Signal(DBID_GET_SMS_NUMBER, bindPhone)
	framework.addSlot2Signal(LADDER_TOP, ttList)
	framework.addSlot2Signal(LADDER_SALARY, ttLgz)

	framework.addSlot2Signal(DBID_BACKPACK_LIST, getDBID_BACKPACK_LIST)--
	framework.addSlot2Signal(MANAGERID_PIECES_COMPOUND_DETAILS_V2, showPrice)--
	framework.addSlot2Signal(MANAGERID_COMPOUND_INFO, comsucessmsg)--
	framework.addSlot2Signal(TICKET_GET_TICKET_LIST, getTICKET_GET_TICKET_LISTInfo)--
	--	framework.addSlot2Signal(MATID_REG_MATCH, reg_match)--进入比赛
	--	framework.addSlot2Signal(GAMEID_REG_MATCH, reg_match)--进入比赛
	framework.addSlot2Signal(MATID_V4_REG_MATCH, MatchList.reg_match_V4)
end

function removeSlot()
	Common.hideWebView()
	GameArmature.removeVipSaleArmatureOfUserInfo(view)
	--framework.removeSlotFromSignal(signal, slot)
	--	framework.removeSlotFromSignal(MANAGERID_GET_VIP_MSG, updataUserVip)
	framework.removeSlotFromSignal(DBID_USER_INFO, updataUserInfo)
	framework.removeSlotFromSignal(BASEID_EDIT_BASEINFO, modifyUserInfo)
	framework.removeSlotFromSignal(DBID_GET_SMS_NUMBER, bindPhone)
	framework.removeSlotFromSignal(LADDER_TOP, ttList)
	framework.removeSlotFromSignal(LADDER_SALARY, ttLgz)
	if (updateUserinfoTimer) then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(updateUserinfoTimer)
	end

	framework.removeSlotFromSignal(DBID_BACKPACK_LIST, getDBID_BACKPACK_LIST)--
	framework.removeSlotFromSignal(MANAGERID_PIECES_COMPOUND_DETAILS_V2, showPrice)--
	framework.removeSlotFromSignal(MANAGERID_COMPOUND_INFO, comsucessmsg)--
	framework.removeSlotFromSignal(TICKET_GET_TICKET_LIST, getTICKET_GET_TICKET_LISTInfo)--
	--	framework.removeSlotFromSignal(MATID_REG_MATCH, reg_match)--进入比赛
	--	framework.removeSlotFromSignal(GAMEID_REG_MATCH, reg_match)--进入比赛
	framework.removeSlotFromSignal(MATID_V4_REG_MATCH, MatchList.reg_match_V4)
end
