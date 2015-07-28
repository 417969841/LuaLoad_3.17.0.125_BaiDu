module(...,package.seeall)

Load.LuaRequire("script.module.exchange.logic.ExchangeDetailLogic")

ExchangeDetailController = class("ExchangeDetailController",BaseController)
ExchangeDetailController.__index = ExchangeDetailController

ExchangeDetailController.moduleLayer = nil

function ExchangeDetailController:reset()
	ExchangeDetailLogic.view = nil
end

function ExchangeDetailController:getLayer()
	return ExchangeDetailLogic.view
end

function ExchangeDetailController:createView()
	ExchangeDetailLogic.createView()
	framework.setOnKeypadEventListener(ExchangeDetailLogic.view, ExchangeDetailLogic.onKeypad)
end

function ExchangeDetailController:requestMsg()
	ExchangeDetailLogic.requestMsg()
end

function ExchangeDetailController:addSlot()
	ExchangeDetailLogic.addSlot()
end

function ExchangeDetailController:removeSlot()
	ExchangeDetailLogic.removeSlot()
end

function ExchangeDetailController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ExchangeDetailLogic.view,"btn_close"),ExchangeDetailLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ExchangeDetailLogic.view,"btn_ok"),ExchangeDetailLogic.callback_btn_ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function ExchangeDetailController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ExchangeDetailLogic.view,"btn_close"),ExchangeDetailLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ExchangeDetailLogic.view,"btn_ok"),ExchangeDetailLogic.callback_btn_ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function ExchangeDetailController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function ExchangeDetailController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function ExchangeDetailController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ExchangeDetailLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(ExchangeDetailLogic);
		ExchangeDetailLogic.releaseData();
	end

	ExchangeDetailLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function ExchangeDetailController:sleepModule()
	framework.releaseOnKeypadEventListener(ExchangeDetailLogic.view)
	ExchangeDetailLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function ExchangeDetailController:wakeModule()
	framework.setOnKeypadEventListener(ExchangeDetailLogic.view, ExchangeDetailLogic.onKeypad)
	ExchangeDetailLogic.view:setTouchEnabled(true)
end
