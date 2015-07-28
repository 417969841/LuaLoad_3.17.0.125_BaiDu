module(...,package.seeall)

Load.LuaRequire("script.module.userinfo.logic.BindPhoneMsgLogic")

BindPhoneMsgController = class("BindPhoneMsgController",BaseController)
BindPhoneMsgController.__index = BindPhoneMsgController

BindPhoneMsgController.moduleLayer = nil

function BindPhoneMsgController:reset()
	BindPhoneMsgLogic.view = nil
end

function BindPhoneMsgController:getLayer()
	return BindPhoneMsgLogic.view
end

function BindPhoneMsgController:createView()
	BindPhoneMsgLogic.createView()
	framework.setOnKeypadEventListener(BindPhoneMsgLogic.view, BindPhoneMsgLogic.onKeypad)
end

function BindPhoneMsgController:requestMsg()
	BindPhoneMsgLogic.requestMsg()
end

function BindPhoneMsgController:addSlot()
	BindPhoneMsgLogic.addSlot()
end

function BindPhoneMsgController:removeSlot()
	BindPhoneMsgLogic.removeSlot()
end

function BindPhoneMsgController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(BindPhoneMsgLogic.view,"btn_ok"),BindPhoneMsgLogic.callback_btn_ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function BindPhoneMsgController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(BindPhoneMsgLogic.view,"btn_ok"),BindPhoneMsgLogic.callback_btn_ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function BindPhoneMsgController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function BindPhoneMsgController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function BindPhoneMsgController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(BindPhoneMsgLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(BindPhoneMsgLogic);
		BindPhoneMsgLogic.releaseData();
	end

	BindPhoneMsgLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function BindPhoneMsgController:sleepModule()
	framework.releaseOnKeypadEventListener(BindPhoneMsgLogic.view)
	BindPhoneMsgLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function BindPhoneMsgController:wakeModule()
	framework.setOnKeypadEventListener(BindPhoneMsgLogic.view, BindPhoneMsgLogic.onKeypad)
	BindPhoneMsgLogic.view:setTouchEnabled(true)
end
