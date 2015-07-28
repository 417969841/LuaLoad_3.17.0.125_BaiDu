module("JinHuaTableTextPopLogic",package.seeall)

view = nil

--提示内容
tv_content = nil;
isShow = false

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

function createView()
	view = cocostudio.createView("load_res/JinHua/JinHuaTableTextPop.json")
	view:setTag(getDiffTag())
	CCDirector:sharedDirector():getRunningScene():addChild(view)
	tv_content = cocostudio.getUILabel(view,"tv_content")
	view:runAction(CCSequence:createWithTwoActions(CCFadeOut:create(5),
        CCCallFuncN:create(close)))
end

function close()
  mvcEngine.destroyModule(GUI_JINHUA_TABLETEXTPOP)
end

function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
	--抬起
		mvcEngine.destroyModule(GUI_JINHUA_TABLETEXTPOP)
	elseif component == CANCEL_UP then
	--取消
	end
end

function setMsg(msg)
	tv_content:setText(msg)
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	isShow = true
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end


function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
end
