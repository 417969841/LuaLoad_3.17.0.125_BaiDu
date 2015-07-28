module(...,package.seeall)

Load.LuaRequire("script.module.userinfo.logic.SetOldSexLogic")

SetOldSexController = class("SetOldSexController",BaseController)
SetOldSexController.__index = SetOldSexController

SetOldSexController.moduleLayer = nil

function SetOldSexController:reset()
	SetOldSexLogic.view = nil
end

function SetOldSexController:getLayer()
	return SetOldSexLogic.view
end

function SetOldSexController:createView()
	SetOldSexLogic.createView()
	framework.setOnKeypadEventListener(SetOldSexLogic.view, SetOldSexLogic.onKeypad)
end

function SetOldSexController:requestMsg()
	SetOldSexLogic.requestMsg()
end

function SetOldSexController:addSlot()
	SetOldSexLogic.addSlot()
end

function SetOldSexController:removeSlot()
	SetOldSexLogic.removeSlot()
end

function SetOldSexController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(SetOldSexLogic.view,"panel_main"),SetOldSexLogic.callback_panel_main,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(SetOldSexLogic.view,"Button_OK"), SetOldSexLogic.callback_Button_OK, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function SetOldSexController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(SetOldSexLogic.view,"panel_main"),SetOldSexLogic.callback_panel_main,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(SetOldSexLogic.view,"Button_OK"), SetOldSexLogic.callback_Button_OK, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function SetOldSexController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function SetOldSexController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function SetOldSexController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SetOldSexLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(SetOldSexLogic);
		SetOldSexLogic.releaseData();
	end

	SetOldSexLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function SetOldSexController:sleepModule()
	framework.releaseOnKeypadEventListener(SetOldSexLogic.view)
	SetOldSexLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function SetOldSexController:wakeModule()
	framework.setOnKeypadEventListener(SetOldSexLogic.view, SetOldSexLogic.onKeypad)
	SetOldSexLogic.view:setTouchEnabled(true)
end
