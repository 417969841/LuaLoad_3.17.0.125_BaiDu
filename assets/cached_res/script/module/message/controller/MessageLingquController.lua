module(...,package.seeall)

Load.LuaRequire("script.module.message.logic.MessageLingquLogic")

MessageLingquController = class("MessageLingquController",BaseController)
MessageLingquController.__index = MessageLingquController

MessageLingquController.moduleLayer = nil

function MessageLingquController:reset()
	MessageLingquLogic.view = nil
end

function MessageLingquController:getLayer()
	return MessageLingquLogic.view
end

function MessageLingquController:createView()
	MessageLingquLogic.createView()
	framework.setOnKeypadEventListener(MessageLingquLogic.view, MessageLingquLogic.onKeypad)
end

function MessageLingquController:requestMsg()
	MessageLingquLogic.requestMsg()
end

function MessageLingquController:addSlot()
	MessageLingquLogic.addSlot()
end

function MessageLingquController:removeSlot()
	MessageLingquLogic.removeSlot()
end

function MessageLingquController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MessageLingquLogic.view,"btn_close"),MessageLingquLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(MessageLingquLogic.view,"btn_lq"),MessageLingquLogic.callback_btn_lq,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function MessageLingquController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MessageLingquLogic.view,"btn_close"),MessageLingquLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(MessageLingquLogic.view,"btn_lq"),MessageLingquLogic.callback_btn_lq,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function MessageLingquController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function MessageLingquController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function MessageLingquController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MessageLingquLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MessageLingquLogic);
		MessageLingquLogic.releaseData();
	end

	MessageLingquLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function MessageLingquController:sleepModule()
	framework.releaseOnKeypadEventListener(MessageLingquLogic.view)
	MessageLingquLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function MessageLingquController:wakeModule()
	framework.setOnKeypadEventListener(MessageLingquLogic.view, MessageLingquLogic.onKeypad)
	MessageLingquLogic.view:setTouchEnabled(true)
end
