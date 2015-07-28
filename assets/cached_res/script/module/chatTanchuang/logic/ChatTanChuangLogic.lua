module("ChatTanChuangLogic",package.seeall)

view = nil
reqUserId  = nil
message = nil
Button_JuBao = nil;
Button_ChaKan = nil;
local selecteduserid = nil;

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
	view = cocostudio.createView("ChatTanChuang.json")
	local gui = GUI_CHATTANCHUANG
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
	local label = cocostudio.getUILabel(view, "Label_23")
	label:setFontSize(35)
	label:setText(message)

	Button_JuBao = cocostudio.getUIButton(view, "Button_JuBao")
	Button_ChaKan = cocostudio.getUIButton(view, "Button_ChaKan")
end

function requestMsg()

end

function callback_Panel_20(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_CHATTANCHUANG)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_PingBi(component)
	local Button_PingBi = cocostudio.getUIButton(view, "Button_PingBi")
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local dataTable = {}
		dataTable["OperateUserID"] = reqUserId
		--OperateType	byte	操作类别	0：屏蔽  1：举报
		dataTable["OperateType"] = 0
		sendIMID_OPERATE_CHAT_USER_TYPE(dataTable)
		Common.showProgressDialog("正在处理您的请求")
		mvcEngine.destroyModule(GUI_CHATTANCHUANG)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_JuBao(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local dataTable = {}
		dataTable["OperateUserID"] = reqUserId
		--OperateType	byte	操作类别	0：屏蔽  1：举报
		dataTable["OperateType"] = 1
		sendIMID_OPERATE_CHAT_USER_TYPE(dataTable)
		Common.showProgressDialog("正在处理您的请求")
		mvcEngine.destroyModule(GUI_CHATTANCHUANG)
	elseif component == CANCEL_UP then
	--取消
	end

end
----[[--
----设置用户ID
----]]
--function setUserID(userid)
--    selecteduserid = userid;
--end

function callback_Button_ChaKan(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableOtherUserInfoLogic.setUserPos(1)
		TableOtherUserInfoLogic.setFromFlag(1) -- 1从大厅聊天跳转而来
		TableOtherUserInfoLogic.setOtherUserInfo(reqUserId)
		mvcEngine.createModule(GUI_TABLE_OTHER_USER_INFO)

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
