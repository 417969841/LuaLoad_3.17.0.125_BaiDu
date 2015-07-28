module(...,package.seeall)

Load.LuaRequire("script.module.exchange.logic.CardKhAndPassLogic")

CardKhAndPassController = class("CardKhAndPassController",BaseController)
CardKhAndPassController.__index = CardKhAndPassController

CardKhAndPassController.moduleLayer = nil

function CardKhAndPassController:reset()
	CardKhAndPassLogic.view = nil
end

function CardKhAndPassController:getLayer()
	return CardKhAndPassLogic.view
end

function CardKhAndPassController:createView()
	CardKhAndPassLogic.createView()
	framework.setOnKeypadEventListener(CardKhAndPassLogic.view, CardKhAndPassLogic.onKeypad)
end

function CardKhAndPassController:requestMsg()
	CardKhAndPassLogic.requestMsg()
end

function CardKhAndPassController:addSlot()
	CardKhAndPassLogic.addSlot()
end

function CardKhAndPassController:removeSlot()
	CardKhAndPassLogic.removeSlot()
end

function CardKhAndPassController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CardKhAndPassLogic.view,"btn_close"),CardKhAndPassLogic.callback_btn_close,  BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function CardKhAndPassController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CardKhAndPassLogic.view,"btn_close"),CardKhAndPassLogic.callback_btn_close,  BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function CardKhAndPassController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function CardKhAndPassController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function CardKhAndPassController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CardKhAndPassLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(CardKhAndPassLogic);
		CardKhAndPassLogic.releaseData();
	end

	CardKhAndPassLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function CardKhAndPassController:sleepModule()
	framework.releaseOnKeypadEventListener(CardKhAndPassLogic.view)
	CardKhAndPassLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function CardKhAndPassController:wakeModule()
	framework.setOnKeypadEventListener(CardKhAndPassLogic.view, CardKhAndPassLogic.onKeypad)
	CardKhAndPassLogic.view:setTouchEnabled(true)
end
