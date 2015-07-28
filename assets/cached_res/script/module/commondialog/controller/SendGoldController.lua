module(...,package.seeall)

Load.LuaRequire("script.module.commondialog.logic.SendGoldLogic")

SendGoldController = class("SendGoldController",BaseController)
SendGoldController.__index = SendGoldController

SendGoldController.moduleLayer = nil

function SendGoldController:reset()
	SendGoldLogic.view = nil
end

function SendGoldController:getLayer()
	return SendGoldLogic.view
end

function SendGoldController:createView()
	SendGoldLogic.createView()
	framework.setOnKeypadEventListener(SendGoldLogic.view, SendGoldLogic.onKeypad)
end

function SendGoldController:requestMsg()
	SendGoldLogic.requestMsg()
end

function SendGoldController:addSlot()
	SendGoldLogic.addSlot()
end

function SendGoldController:removeSlot()
	SendGoldLogic.removeSlot()
end

function SendGoldController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(SendGoldLogic.view,"btn_close"),SendGoldLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function SendGoldController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(SendGoldLogic.view,"btn_close"),SendGoldLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function SendGoldController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function SendGoldController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function SendGoldController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SendGoldLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(SendGoldLogic);
		SendGoldLogic.releaseData();
	end

	SendGoldLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function SendGoldController:sleepModule()
	framework.releaseOnKeypadEventListener(SendGoldLogic.view)
	SendGoldLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function SendGoldController:wakeModule()
	framework.setOnKeypadEventListener(SendGoldLogic.view, SendGoldLogic.onKeypad)
	SendGoldLogic.view:setTouchEnabled(true)
end
