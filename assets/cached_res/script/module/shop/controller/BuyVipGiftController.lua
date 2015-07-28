module(...,package.seeall)

Load.LuaRequire("script.module.shop.logic.BuyVipGiftLogic")

BuyVipGiftController = class("BuyVipGiftController",BaseController)
BuyVipGiftController.__index = BuyVipGiftController

BuyVipGiftController.moduleLayer = nil

function BuyVipGiftController:reset()
	BuyVipGiftLogic.view = nil
end

function BuyVipGiftController:getLayer()
	return BuyVipGiftLogic.view
end

function BuyVipGiftController:createView()
	BuyVipGiftLogic.createView()
	framework.setOnKeypadEventListener(BuyVipGiftLogic.view, BuyVipGiftLogic.onKeypad)
end

function BuyVipGiftController:requestMsg()
	BuyVipGiftLogic.requestMsg()
end

function BuyVipGiftController:addSlot()
	BuyVipGiftLogic.addSlot()
end

function BuyVipGiftController:removeSlot()
	BuyVipGiftLogic.removeSlot()
end

function BuyVipGiftController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(BuyVipGiftLogic.view,"btn_close"),BuyVipGiftLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(BuyVipGiftLogic.view,"btn_buy"),BuyVipGiftLogic.callback_btn_buy,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function BuyVipGiftController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(BuyVipGiftLogic.view,"btn_close"),BuyVipGiftLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(BuyVipGiftLogic.view,"btn_buy"),BuyVipGiftLogic.callback_btn_buy,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function BuyVipGiftController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function BuyVipGiftController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function BuyVipGiftController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(BuyVipGiftLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(BuyVipGiftLogic);
		BuyVipGiftLogic.releaseData();
	end

	BuyVipGiftLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function BuyVipGiftController:sleepModule()
	framework.releaseOnKeypadEventListener(BuyVipGiftLogic.view)
	BuyVipGiftLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function BuyVipGiftController:wakeModule()
	framework.setOnKeypadEventListener(BuyVipGiftLogic.view, BuyVipGiftLogic.onKeypad)
	BuyVipGiftLogic.view:setTouchEnabled(true)
end
