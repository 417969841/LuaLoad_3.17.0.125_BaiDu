module("TimeNotFitLogic",package.seeall)

view = nil
Panel_20 = nil
noticeMsg = nil
func = nil
func2 = nil
btn_close = nil
btn_go = nil
lab_text = nil
panel = nil

matchItem = nil
local parentModule = nil

function setParentModule(pModule)
  parentModule = pModule
end

function getParentModule()
  return parentModule
end

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
	view = cocostudio.createView("TimeNotFit.json")
	local gui = GUI_TIMENOTFIT
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
	if(noticeMsg)then
		lab_text:setText(noticeMsg)
	end
	--金皇冠弹窗显示问题
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20")
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
		if(func2)then
			func2()
			func2 = nil
		end

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
	mvcEngine.destroyModule(GUI_TIMENOTFIT)
end

--[[
参赛
]]
function callback_btn_go(component)
	if component == PUSH_DOWN then
		--按下
	elseif component == RELEASE_UP then
		--抬起
    	if func then
      		close()
      		func()
      		func = nil
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
