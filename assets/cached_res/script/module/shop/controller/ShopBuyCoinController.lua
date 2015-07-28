module(...,package.seeall)

Load.LuaRequire("script.module.shop.logic.ShopBuyCoinLogic")

ShopBuyCoinController = class("ShopBuyCoinController",BaseController)
ShopBuyCoinController.__index = ShopBuyCoinController

ShopBuyCoinController.moduleLayer = nil

function ShopBuyCoinController:reset()
	ShopBuyCoinLogic.view = nil
end

function ShopBuyCoinController:getLayer()
	return ShopBuyCoinLogic.view
end

function ShopBuyCoinController:createView()
	ShopBuyCoinLogic.createView()
	framework.setOnKeypadEventListener(ShopBuyCoinLogic.view, ShopBuyCoinLogic.onKeypad)
end

function ShopBuyCoinController:requestMsg()
	ShopBuyCoinLogic.requestMsg()
end

function ShopBuyCoinController:addSlot()
	ShopBuyCoinLogic.addSlot()
end

function ShopBuyCoinController:removeSlot()
	ShopBuyCoinLogic.removeSlot()
end

function ShopBuyCoinController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ShopBuyCoinLogic.view,"btn_shop_goods_buy"),ShopBuyCoinLogic.callback_btn_shop_goods_buy,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ShopBuyCoinLogic.view,"btn_close"),ShopBuyCoinLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function ShopBuyCoinController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ShopBuyCoinLogic.view,"btn_shop_goods_buy"),ShopBuyCoinLogic.callback_btn_shop_goods_buy,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ShopBuyCoinLogic.view,"btn_close"),ShopBuyCoinLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function ShopBuyCoinController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function ShopBuyCoinController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function ShopBuyCoinController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ShopBuyCoinLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(ShopBuyCoinLogic);
		ShopBuyCoinLogic.releaseData();
	end

	ShopBuyCoinLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function ShopBuyCoinController:sleepModule()
	framework.releaseOnKeypadEventListener(ShopBuyCoinLogic.view)
	ShopBuyCoinLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function ShopBuyCoinController:wakeModule()
	framework.setOnKeypadEventListener(ShopBuyCoinLogic.view, ShopBuyCoinLogic.onKeypad)
	ShopBuyCoinLogic.view:setTouchEnabled(true)
end
