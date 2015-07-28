module(...,package.seeall)

Load.LuaRequire("script.module.customservice.logic.CustomServiceLogic")

CustomServiceController = class("CustomServiceController",BaseController)
CustomServiceController.__index = CustomServiceController

CustomServiceController.moduleLayer = nil

function CustomServiceController:reset()
	CustomServiceLogic.view = nil
end

function CustomServiceController:getLayer()
	return CustomServiceLogic.view
end

function CustomServiceController:createView()
	CustomServiceLogic.createView()
	framework.setOnKeypadEventListener(CustomServiceLogic.view, CustomServiceLogic.onKeypad)
end

function CustomServiceController:requestMsg()
	CustomServiceLogic.requestMsg()
end

function CustomServiceController:addSlot()
	CustomServiceLogic.addSlot()
end

function CustomServiceController:removeSlot()
	CustomServiceLogic.removeSlot()
end

function CustomServiceController:addCallback()
	--main
	framework.bindEventCallback(cocostudio.getComponent(CustomServiceLogic.view,"btn_back"),CustomServiceLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	--客服
	framework.bindEventCallback(cocostudio.getComponent(CustomServiceLogic.view,"btn_send"),CustomServiceLogic.callback_btn_send,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(CustomServiceLogic.view,"txt_sendmsg"),CustomServiceLogic.callback_txt_sendmsg_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(CustomServiceLogic.view,"txt_sendmsg"),CustomServiceLogic.callback_txt_sendmsg,DETACH_WITH_IME)
	end
end

function CustomServiceController:removeCallback()
	--main
	framework.unbindEventCallback(cocostudio.getComponent(CustomServiceLogic.view,"btn_back"),CustomServiceLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	--客服
	framework.unbindEventCallback(cocostudio.getComponent(CustomServiceLogic.view,"btn_send"),CustomServiceLogic.callback_btn_send,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(CustomServiceLogic.view,"txt_sendmsg"),CustomServiceLogic.callback_txt_sendmsg_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(CustomServiceLogic.view,"txt_sendmsg"),CustomServiceLogic.callback_txt_sendmsg,DETACH_WITH_IME)
	end
end

function CustomServiceController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function CustomServiceController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function CustomServiceController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CustomServiceLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(CustomServiceLogic);
		CustomServiceLogic.releaseData();
	end

	CustomServiceLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function CustomServiceController:sleepModule()
	framework.releaseOnKeypadEventListener(CustomServiceLogic.view)
	CustomServiceLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function CustomServiceController:wakeModule()
	framework.setOnKeypadEventListener(CustomServiceLogic.view, CustomServiceLogic.onKeypad)
	CustomServiceLogic.view:setTouchEnabled(true)
end
