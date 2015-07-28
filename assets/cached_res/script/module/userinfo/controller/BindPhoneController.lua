module(...,package.seeall)

Load.LuaRequire("script.module.userinfo.logic.BindPhoneLogic")

BindPhoneController = class("BindPhoneController",BaseController)
BindPhoneController.__index = BindPhoneController

BindPhoneController.moduleLayer = nil

function BindPhoneController:reset()
	BindPhoneLogic.view = nil
end

function BindPhoneController:getLayer()
	return BindPhoneLogic.view
end

function BindPhoneController:createView()
	BindPhoneLogic.createView()
	framework.setOnKeypadEventListener(BindPhoneLogic.view, BindPhoneLogic.onKeypad)
end

function BindPhoneController:requestMsg()
	BindPhoneLogic.requestMsg()
end

function BindPhoneController:addSlot()
	BindPhoneLogic.addSlot()
end

function BindPhoneController:removeSlot()
	BindPhoneLogic.removeSlot()
end

function BindPhoneController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(BindPhoneLogic.view,"btn_bind"),BindPhoneLogic.callback_btn_bind,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(BindPhoneLogic.view,"btn_close"),BindPhoneLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	--framework.bindEventCallback(cocostudio.getComponent(BindPhoneLogic.view,"btn_getYZM"),BindPhoneLogic.callback_btn_getYZM,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function BindPhoneController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(BindPhoneLogic.view,"btn_bind"),BindPhoneLogic.callback_btn_bind,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(BindPhoneLogic.view,"btn_close"),BindPhoneLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	--framework.unbindEventCallback(cocostudio.getComponent(BindPhoneLogic.view,"btn_getYZM"),BindPhoneLogic.callback_btn_getYZM,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function BindPhoneController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function BindPhoneController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function BindPhoneController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(BindPhoneLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(BindPhoneLogic);
		BindPhoneLogic.releaseData();
	end

	BindPhoneLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function BindPhoneController:sleepModule()
	framework.releaseOnKeypadEventListener(BindPhoneLogic.view)
	BindPhoneLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function BindPhoneController:wakeModule()
	framework.setOnKeypadEventListener(BindPhoneLogic.view, BindPhoneLogic.onKeypad)
	BindPhoneLogic.view:setTouchEnabled(true)
end
