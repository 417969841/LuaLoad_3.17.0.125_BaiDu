module(...,package.seeall)

Load.LuaRequire("script.module.shop.logic.BuyGiftVipNotFitLogic")

BuyGiftVipNotFitController = class("BuyGiftVipNotFitController",BaseController)
BuyGiftVipNotFitController.__index = BuyGiftVipNotFitController

BuyGiftVipNotFitController.moduleLayer = nil

function BuyGiftVipNotFitController:reset()
	BuyGiftVipNotFitLogic.view = nil
end

function BuyGiftVipNotFitController:getLayer()
	return BuyGiftVipNotFitLogic.view
end

function BuyGiftVipNotFitController:createView()
	BuyGiftVipNotFitLogic.createView()
	framework.setOnKeypadEventListener(BuyGiftVipNotFitLogic.view, BuyGiftVipNotFitLogic.onKeypad)
end

function BuyGiftVipNotFitController:requestMsg()
	BuyGiftVipNotFitLogic.requestMsg()
end

function BuyGiftVipNotFitController:addSlot()
	BuyGiftVipNotFitLogic.addSlot()
end

function BuyGiftVipNotFitController:removeSlot()
	BuyGiftVipNotFitLogic.removeSlot()
end

function BuyGiftVipNotFitController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(BuyGiftVipNotFitLogic.view,"btn_close"),BuyGiftVipNotFitLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(BuyGiftVipNotFitLogic.view,"btn_cz"),BuyGiftVipNotFitLogic.callback_btn_cz,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	--framework.bindEventCallback(cocostudio.getComponent(BuyGiftVipNotFitLogic.view,"btn_vip"),BuyGiftVipNotFitLogic.callback_btn_vip,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function BuyGiftVipNotFitController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(BuyGiftVipNotFitLogic.view,"btn_close"),BuyGiftVipNotFitLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(BuyGiftVipNotFitLogic.view,"btn_cz"),BuyGiftVipNotFitLogic.callback_btn_cz,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	--framework.unbindEventCallback(cocostudio.getComponent(BuyGiftVipNotFitLogic.view,"btn_vip"),BuyGiftVipNotFitLogic.callback_btn_vip,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function BuyGiftVipNotFitController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function BuyGiftVipNotFitController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function BuyGiftVipNotFitController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(BuyGiftVipNotFitLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(BuyGiftVipNotFitLogic);
		BuyGiftVipNotFitLogic.releaseData();
	end

	BuyGiftVipNotFitLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function BuyGiftVipNotFitController:sleepModule()
	framework.releaseOnKeypadEventListener(BuyGiftVipNotFitLogic.view)
	BuyGiftVipNotFitLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function BuyGiftVipNotFitController:wakeModule()
	framework.setOnKeypadEventListener(BuyGiftVipNotFitLogic.view, BuyGiftVipNotFitLogic.onKeypad)
	BuyGiftVipNotFitLogic.view:setTouchEnabled(true)
end
