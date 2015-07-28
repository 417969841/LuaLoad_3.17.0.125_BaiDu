module(...,package.seeall)

Load.LuaRequire("script.module.shop.logic.ShopBuyGoodsLogic")

ShopBuyGoodsController = class("ShopBuyGoodsController",BaseController)
ShopBuyGoodsController.__index = ShopBuyGoodsController

ShopBuyGoodsController.moduleLayer = nil

function ShopBuyGoodsController:reset()
	ShopBuyGoodsLogic.view = nil
end

function ShopBuyGoodsController:getLayer()
	return ShopBuyGoodsLogic.view
end

function ShopBuyGoodsController:createView()
	ShopBuyGoodsLogic.createView()
	framework.setOnKeypadEventListener(ShopBuyGoodsLogic.view, ShopBuyGoodsLogic.onKeypad)
end

function ShopBuyGoodsController:requestMsg()
	ShopBuyGoodsLogic.requestMsg()
end

function ShopBuyGoodsController:addSlot()
	ShopBuyGoodsLogic.addSlot()
end

function ShopBuyGoodsController:removeSlot()
	ShopBuyGoodsLogic.removeSlot()
end

function ShopBuyGoodsController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ShopBuyGoodsLogic.view,"btn_shop_goods_buy"),ShopBuyGoodsLogic.callback_btn_shop_goods_buy,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ShopBuyGoodsLogic.view,"btn_add_goods"),ShopBuyGoodsLogic.callback_btn_add_goods,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE)
	framework.bindEventCallback(cocostudio.getComponent(ShopBuyGoodsLogic.view,"btn_minus_goods"),ShopBuyGoodsLogic.callback_btn_minus_goods,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE)
	framework.bindEventCallback(cocostudio.getComponent(ShopBuyGoodsLogic.view,"btn_close"),ShopBuyGoodsLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function ShopBuyGoodsController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ShopBuyGoodsLogic.view,"btn_shop_goods_buy"),ShopBuyGoodsLogic.callback_btn_shop_goods_buy,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ShopBuyGoodsLogic.view,"btn_add_goods"),ShopBuyGoodsLogic.callback_btn_add_goods,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE)
	framework.unbindEventCallback(cocostudio.getComponent(ShopBuyGoodsLogic.view,"btn_minus_goods"),ShopBuyGoodsLogic.callback_btn_minus_goods,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE)
	framework.unbindEventCallback(cocostudio.getComponent(ShopBuyGoodsLogic.view,"btn_close"),ShopBuyGoodsLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function ShopBuyGoodsController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function ShopBuyGoodsController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function ShopBuyGoodsController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ShopBuyGoodsLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(ShopBuyGoodsLogic);
		ShopBuyGoodsLogic.releaseData();
	end

	ShopBuyGoodsLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function ShopBuyGoodsController:sleepModule()
	framework.releaseOnKeypadEventListener(ShopBuyGoodsLogic.view)
	ShopBuyGoodsLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function ShopBuyGoodsController:wakeModule()
	framework.setOnKeypadEventListener(ShopBuyGoodsLogic.view, ShopBuyGoodsLogic.onKeypad)
	ShopBuyGoodsLogic.view:setTouchEnabled(true)
end
