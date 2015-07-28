module(...,package.seeall)

Load.LuaRequire("script.module.message.logic.MessagePlayerLogic")

MessagePlayerController = class("MessagePlayerController",BaseController)
MessagePlayerController.__index = MessagePlayerController

MessagePlayerController.moduleLayer = nil

function MessagePlayerController:reset()
	MessagePlayerLogic.view = nil
end

function MessagePlayerController:getLayer()
	return MessagePlayerLogic.view
end

function MessagePlayerController:createView()
	MessagePlayerLogic.createView()
	framework.setOnKeypadEventListener(MessagePlayerLogic.view, MessagePlayerLogic.onKeypad)
end

function MessagePlayerController:requestMsg()
	MessagePlayerLogic.requestMsg()
end

function MessagePlayerController:addSlot()
	MessagePlayerLogic.addSlot()
end

function MessagePlayerController:removeSlot()
	MessagePlayerLogic.removeSlot()
end

function MessagePlayerController:addCallback()
	--framework.bindEventCallback(cocostudio.getComponent(MessagePlayerLogic.view,"btn_set"),MessagePlayerLogic.callback_btn_set,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(MessagePlayerLogic.view,"btn_back"),MessagePlayerLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(MessagePlayerLogic.view,"btn_send"),MessagePlayerLogic.callback_btn_send,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(MessagePlayerLogic.view,"txt_sendmsg"),MessagePlayerLogic.callback_txt_sendmsg_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(MessagePlayerLogic.view,"txt_sendmsg"),MessagePlayerLogic.callback_txt_sendmsg,DETACH_WITH_IME)
	end
end

function MessagePlayerController:removeCallback()
	--framework.unbindEventCallback(cocostudio.getComponent(MessagePlayerLogic.view,"btn_set"),MessagePlayerLogic.callback_btn_set,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(MessagePlayerLogic.view,"btn_back"),MessagePlayerLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(MessagePlayerLogic.view,"btn_send"),MessagePlayerLogic.callback_btn_send,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(CustomServiceLogic.view,"txt_sendmsg"),CustomServiceLogic.callback_txt_sendmsg_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(CustomServiceLogic.view,"txt_sendmsg"),CustomServiceLogic.callback_txt_sendmsg,DETACH_WITH_IME)
	end
end

function MessagePlayerController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function MessagePlayerController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function MessagePlayerController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MessagePlayerLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MessagePlayerLogic);
		MessagePlayerLogic.releaseData();
	end

	MessagePlayerLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function MessagePlayerController:sleepModule()
	framework.releaseOnKeypadEventListener(MessagePlayerLogic.view)
	MessagePlayerLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function MessagePlayerController:wakeModule()
	framework.setOnKeypadEventListener(MessagePlayerLogic.view, MessagePlayerLogic.onKeypad)
	MessagePlayerLogic.view:setTouchEnabled(true)
end
