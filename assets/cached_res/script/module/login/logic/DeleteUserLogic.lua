module("DeleteUserLogic",package.seeall)

view = nil
btn_close = nil
btn_go = nil
lab_text = nil
panel = nil
img_ok = nil
local index = -1;
local username = nil

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
	view = cocostudio.createView("DeleteUser.json")
	local gui = GUI_DELETEUSER
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
	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_go = cocostudio.getUIButton(view, "btn_go")
	lab_text = cocostudio.getUILabel(view, "lab_text")
	img_ok = cocostudio.getUIImageView(view, "img_ok")
	img_ok:loadTexture(Common.getResourcePath("ui_item_btn_ensure.png"))
	lab_text:setText("您确定要删除账号‘"..username.."’吗?")
end

function requestMsg()

end

--关闭
function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--关闭界面
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end
--关闭页面
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_DELETEUSER)
	mvcEngine.createModule(GUI_MORE);
end
--删除
function callback_btn_go(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendMANAGERID_DELETE_IMEIUSERS(Common.getDeviceInfo(),username)
		if index ~= -1 then
			profile.MoreUser.deleteOneUserInfo(index);
			profile.MoreUser.setLoginWithMore(profile.MoreUser.getUsernameTable()[1].NickName);
		end
		close()

	elseif component == CANCEL_UP then
	--取消
	end
end

function setData(indexV,usernameV)
	username = usernameV
	index = indexV
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
