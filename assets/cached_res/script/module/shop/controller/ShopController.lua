module(...,package.seeall)

Load.LuaRequire("script.module.shop.logic.ShopLogic")

ShopController = class("ShopController",BaseController)
ShopController.__index = ShopController

ShopController.moduleLayer = nil

function ShopController:reset()
	ShopLogic.view = nil
end

function ShopController:getLayer()
	return ShopLogic.view
end

function ShopController:createView()
	ShopLogic.createView()
	framework.setOnKeypadEventListener(ShopLogic.view, ShopLogic.onKeypad)
end

function ShopController:requestMsg()
	ShopLogic.requestMsg()
end

function ShopController:addSlot()
	ShopLogic.addSlot()
end

function ShopController:removeSlot()
	ShopLogic.removeSlot()
end

function ShopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ShopLogic.view,"iv_shop_goods"),ShopLogic.callback_iv_shop_goods,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ShopLogic.view,"iv_shop_coin"),ShopLogic.callback_iv_shop_coin,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ShopLogic.view,"iv_shop_gift"),ShopLogic.callback_iv_shop_gift,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ShopLogic.view,"btn_shop_back"),ShopLogic.callback_btn_shop_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ShopLogic.view,"btn_shop_recharge"),ShopLogic.callback_btn_shop_recharge,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ShopLogic.view,"btn_shop_rechargeyuanbao"),ShopLogic.callback_btn_shop_rechargeyuanbao,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ShopLogic.view,"img_viplibao"),ShopLogic.callback_img_viplibao,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ShopLogic.view,"img_libao"),ShopLogic.callback_img_libao,BUTTON_CLICK)

end

function ShopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ShopLogic.view,"iv_shop_goods"),ShopLogic.callback_iv_shop_goods,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ShopLogic.view,"iv_shop_gift"),ShopLogic.callback_iv_shop_gift,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ShopLogic.view,"iv_shop_coin"),ShopLogic.callback_iv_shop_coin,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ShopLogic.view,"btn_shop_back"),ShopLogic.callback_btn_shop_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ShopLogic.view,"btn_shop_recharge"),ShopLogic.callback_btn_shop_recharge,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ShopLogic.view,"btn_shop_rechargeyuanbao"),ShopLogic.callback_btn_shop_rechargeyuanbao,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function ShopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function ShopController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function ShopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ShopLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(ShopLogic);
		ShopLogic.releaseData();
	end

	ShopLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function ShopController:sleepModule()
	framework.releaseOnKeypadEventListener(ShopLogic.view)
	ShopLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function ShopController:wakeModule()
	framework.setOnKeypadEventListener(ShopLogic.view, ShopLogic.onKeypad)
	ShopLogic.view:setTouchEnabled(true)
end
