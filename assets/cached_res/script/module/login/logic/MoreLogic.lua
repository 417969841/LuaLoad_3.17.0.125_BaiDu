module("MoreLogic",package.seeall)

view = nil

--MoreUserTable= {}
--scrollview = nil
--nickname = nil
--btn_close = nil
--panel = nil
----全局变量
--imei = nil
--ImageTable = {} --图片list
--checkListImage = {}
Panel_main = nil;--
Panel = nil;--
Img_TopUser = nil;--
Img_DeleteTopUser = nil;--
Label_TopUserName = nil;--
Img_MiddleUser = nil;--
Img_DeleteMiddleUser = nil;--
Label_MiddleUserName = nil;--
Image_BottomUser = nil;--
Img_DeleteBottomUser = nil;--
Label_BottomUserName = nil;--
ImageView_Bg = nil;


RotationUI = nil;--从另一个界面传递过来的旋转UI
RotationUIup = nil

NickNameTable = {};--昵称信息table
NickNameInfoUITable = {};--昵称详情uitable
DeleteButtonTable = {}; --删除按钮table
NickNameLableTable = {};--昵称labeltable
local panelX = 0--信息面板X轴
local panelY = 0--信息面板Y轴

local ViewTag = {};
ViewTag.LOGIN = 1;--登录展开
ViewTag.RESET = 2;--重置密码展开
CurViewTag = 0;--当前界面tag

function getViewTag()
	return ViewTag;
end

function setCurViewTag(tag)
	CurViewTag = tag;
end

function onKeypad(event)
	if event == "backClicked" then
		mvcEngine.destroyModule(GUI_MORE)
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("More.json")
	local gui = GUI_MORE
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
	Panel_main = cocostudio.getUIPanel(view, "Panel_main");
	Panel = cocostudio.getUIPanel(view, "Panel");
	if panelX > 0 and panelY > 0 then
		Panel:setPosition(ccp(panelX,panelY));
	end
	ImageView_Bg = cocostudio.getUIImageView(view, "ImageView_Bg");

	Img_TopUser = cocostudio.getUIImageView(view, "Img_TopUser");
	Img_DeleteTopUser = cocostudio.getUIImageView(view, "Img_DeleteTopUser");
	Label_TopUserName = cocostudio.getUILabel(view, "Label_TopUserName");
	NickNameInfoUITable[1] = Img_TopUser;
	DeleteButtonTable[1] = Img_DeleteTopUser;
	NickNameLableTable[1] = Label_TopUserName;

	Img_MiddleUser = cocostudio.getUIImageView(view, "Img_MiddleUser");
	Img_DeleteMiddleUser = cocostudio.getUIImageView(view, "Img_DeleteMiddleUser");
	Label_MiddleUserName = cocostudio.getUILabel(view, "Label_MiddleUserName");
	NickNameInfoUITable[2] = Img_MiddleUser;
	DeleteButtonTable[2] = Img_DeleteMiddleUser;
	NickNameLableTable[2] = Label_MiddleUserName;

	Image_BottomUser = cocostudio.getUIImageView(view, "Image_BottomUser");
	Img_DeleteBottomUser = cocostudio.getUIImageView(view, "Img_DeleteBottomUser");
	Label_BottomUserName = cocostudio.getUILabel(view, "Label_BottomUserName");
	NickNameInfoUITable[3] = Image_BottomUser;
	DeleteButtonTable[3] = Img_DeleteBottomUser;
	NickNameLableTable[3] = Label_BottomUserName;
end

--[[--
--刷新数据
--]]
function refreshData()
	NickNameTable = profile.MoreUser.getUsernameTable();
	local j = 0;
	for i = 1, #NickNameInfoUITable do
		if i > #NickNameTable then
			NickNameInfoUITable[#NickNameInfoUITable - j]:setVisible(false);
			j = j + 1;
		else
			if NickNameLableTable[i] ~= nil then
				NickNameLableTable[i]:setText(NickNameTable[i].NickName);
			end
		end
	end
	if j > 0 then
		--少于3个时,背景缩放
		ImageView_Bg:setScaleY(1 - j / #NickNameInfoUITable);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)
	initView()
	refreshData();
--	panel = cocostudio.getUIPanel(view, "Panel")
--	LordGamePub.showDialogAmin(panel)
--
--	imei = Common.getDeviceInfo()
--
--	scrollview = cocostudio.getUIScrollView(view, "scroll_list")
--	btn_close = cocostudio.getUIButton(view, "btn_close")
--
--	--请求数据
--	sendBASEID_GET_IMEIUSERS(imei)
--	checkListImage = {}

end

function requestMsg()

end

--[[--
--设置信息面板的位置
--@param #number x x轴坐标
--@param #number y y轴坐标
--]]
function setPanelPosition(x, y)
	panelX = x - (Panel:getContentSize().width / 2);
	panelY = y - Panel:getContentSize().height;
	Panel:setPosition(ccp(panelX, panelY));
end

--[[--
--设置旋转的信息
--@param #UIImage UI 旋转的UI
--@param #number value 旋转的角度
--]]
function setRotationInfo(UI,UIUP)
	RotationUI = UI;
	RotationUIup = UIUP
end

----关闭页面
--function close()
--	LordGamePub.closeDialogAmin(panel,closePanel)
--end

function closePanel()
	if RotationUI ~= nil and RotationUIup ~= nil then
		RotationUI:setVisible(true)
		RotationUIup:setVisible(false)
	end
	sendBASEID_GET_IMEIUSERS(Common.getDeviceInfo());
	mvcEngine.destroyModule(GUI_MORE)
end

function callback_Img_DeleteTopUser(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if #NickNameTable > 2 then
			local username = Label_TopUserName:getStringValue();
			DeleteUserLogic.setData(1,username);
			mvcEngine.createModule(GUI_DELETEUSER);
		else
			Common.showToast("你好，你目前的专属账号太少了，删除之后不易找回。", 2);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Img_DeleteMiddleUser(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if #NickNameTable > 2 then
			local username = Label_MiddleUserName:getStringValue();
			DeleteUserLogic.setData(2,username)
			mvcEngine.createModule(GUI_DELETEUSER)
		else
			Common.showToast("你好，你目前的专属账号太少了，删除之后不易找回。", 2);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Img_DeleteBottomUser(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if #NickNameTable > 2 then
			local username = Label_BottomUserName:getStringValue();
			DeleteUserLogic.setData(3,username)
			mvcEngine.createModule(GUI_DELETEUSER)
		else
			Common.showToast("你好，你目前的专属账号太少了，删除之后不易找回。", 2);
		end

	elseif component == CANCEL_UP then
	--取消

	end
end

function touchUserInfoLogic(username)
	if CurViewTag == ViewTag.LOGIN then
		profile.MoreUser.setLoginWithMore(username);
	elseif CurViewTag == ViewTag.RESET then
		ResetPasswordLogic.setUsername(username);
	end
	closePanel();
end

function callback_Img_TopUser(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local username = Label_TopUserName:getStringValue();
		touchUserInfoLogic(username);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Img_MiddleUser(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local username = Label_MiddleUserName:getStringValue();
		touchUserInfoLogic(username)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_BottomUser(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local username = Label_BottomUserName:getStringValue();
		touchUserInfoLogic(username);
	elseif component == CANCEL_UP then
	--取消

	end
end


function callback_Panel_main(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--关闭界面
		closePanel()
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
--framework.addSlot2Signal(BASEID_GET_IMEIUSERS, slot_MoreUser)
end

function removeSlot()
--framework.removeSlotFromSignal(BASEID_GET_IMEIUSERS, slot_MoreUser)
end
