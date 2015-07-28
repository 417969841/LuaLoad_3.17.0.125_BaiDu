module(...,package.seeall)

Load.LuaRequire("script.module.exchange.logic.ExchangeLogic")

ExchangeController = class("ExchangeController",BaseController)
ExchangeController.__index = ExchangeController

ExchangeController.moduleLayer = nil

function ExchangeController:reset()
	ExchangeLogic.view = nil
end

function ExchangeController:getLayer()
	return ExchangeLogic.view
end

function ExchangeController:createView()
	ExchangeLogic.createView()
	framework.setOnKeypadEventListener(ExchangeLogic.view, ExchangeLogic.onKeypad)
end

function ExchangeController:requestMsg()
	ExchangeLogic.requestMsg()
end

function ExchangeController:addSlot()
	ExchangeLogic.addSlot()
end

function ExchangeController:removeSlot()
	ExchangeLogic.removeSlot()
end

function ExchangeController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_back"),ExchangeLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_jiangquan"),ExchangeLogic.callback_btn_jiangquan,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_suipian"),ExchangeLogic.callback_btn_suipian,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_myprice"),ExchangeLogic.callback_btn_myprice,BUTTON_CLICK)
	--framework.bindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_pack_coinrecharge"),ExchangeLogic.callback_btn_pack_coinrecharge,BUTTON_CLICK)
	--framework.bindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_pack_yuanbaorecharge"),ExchangeLogic.callback_btn_pack_yuanbaorecharge,BUTTON_CLICK)

end

function ExchangeController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_back"),ExchangeLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_jiangquan"),ExchangeLogic.callback_btn_jiangquan,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_suipian"),ExchangeLogic.callback_btn_suipian,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_myprice"),ExchangeLogic.callback_btn_myprice,BUTTON_CLICK)
	--framework.unbindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_pack_coinrecharge"),ExchangeLogic.callback_btn_pack_coinrecharge,BUTTON_CLICK)
	--framework.unbindEventCallback(cocostudio.getComponent(ExchangeLogic.view,"btn_pack_yuanbaorecharge"),ExchangeLogic.callback_btn_pack_yuanbaorecharge,BUTTON_CLICK)

end

function ExchangeController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function ExchangeController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function ExchangeController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ExchangeLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(ExchangeLogic);
		ExchangeLogic.releaseData();
	end

	ExchangeLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function ExchangeController:sleepModule()
	framework.releaseOnKeypadEventListener(ExchangeLogic.view)
	ExchangeLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function ExchangeController:wakeModule()
	framework.setOnKeypadEventListener(ExchangeLogic.view, ExchangeLogic.onKeypad)
	ExchangeLogic.view:setTouchEnabled(true)
end
