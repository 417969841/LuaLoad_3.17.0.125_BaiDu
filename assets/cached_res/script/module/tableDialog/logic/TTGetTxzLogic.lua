module("TTGetTxzLogic",package.seeall)

view = nil
panel = nil
btn_close = nil
btn_gomatch = nil
btn_goshop = nil
lab_content = nil
lab_title = nil
--全局变量
local duan = nil -- 段位

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
	view = cocostudio.createView("TTGetTxz.json")
	local gui = GUI_TTGETTXZ
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
	btn_gomatch = cocostudio.getUIButton(view, "btn_gomatch")
	btn_goshop = cocostudio.getUIButton(view, "btn_goshop")
	lab_content = cocostudio.getUILabel(view, "lab_content")
	lab_title = cocostudio.getUILabel(view, "lab_title")
	--赋值
	local curduan = profile.TianTiData.getDuanWeiName(tonumber(duan))
	local nextduan = profile.TianTiData.getDuanWeiName(tonumber(duan+1))
	local title = "【"..curduan.."组】升级到【"..nextduan.."组】需要"..nextduan.."晋级证x1"
	local content = "【"..nextduan.."晋级证】获取途径"
	lab_title:setText(title)
	lab_content:setText(content)
end
function setValue(duanV)
	duan = duanV
end
function requestMsg()

end
--去比赛
function callback_btn_gomatch(component)
	if component == PUSH_DOWN then
		--按下
	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setHallRoomItem(2)
		GameConfig.setHallShowMode(2)
		mvcEngine.createModule(GUI_HALL)
	elseif component == CANCEL_UP then
		--取消
	end
end

--去商城
function callback_btn_goshop(component)
	if component == PUSH_DOWN then
		--按下
	elseif component == RELEASE_UP then
		--抬起
		ShopLogic.setTab(2)
		mvcEngine.createModule(GUI_SHOP)
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
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_TTGETTXZ)
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
