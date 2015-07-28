module(...,package.seeall)

Load.LuaRequire("script.module.shop.logic.BuyCoinConfimLogic")

--管理器

BuyCoinConfimController = class("BuyCoinConfimController",BaseController)
BuyCoinConfimController.__index = BuyCoinConfimController

BuyCoinConfimController.moduleLayer = nil

function BuyCoinConfimController:reset()
	BuyCoinConfimLogic.view = nil
end

function BuyCoinConfimController:getLayer()
	return BuyCoinConfimLogic.view
end

function BuyCoinConfimController:createView()
	BuyCoinConfimLogic.createView()
	framework.setOnKeypadEventListener(BuyCoinConfimLogic.view, BuyCoinConfimLogic.onKeypad)
end

function BuyCoinConfimController:requestMsg()
	BuyCoinConfimLogic.requestMsg()
end

function BuyCoinConfimController:addSlot()
	BuyCoinConfimLogic.addSlot()
end

function BuyCoinConfimController:removeSlot()
	BuyCoinConfimLogic.removeSlot()
end

function BuyCoinConfimController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(BuyCoinConfimLogic.view,"btn_close"),BuyCoinConfimLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(BuyCoinConfimLogic.view,"btn_ok"),BuyCoinConfimLogic.callback_btn_ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function BuyCoinConfimController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(BuyCoinConfimLogic.view,"btn_close"),BuyCoinConfimLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(BuyCoinConfimLogic.view,"btn_ok"),BuyCoinConfimLogic.callback_btn_ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function BuyCoinConfimController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function BuyCoinConfimController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function BuyCoinConfimController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(BuyCoinConfimLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(BuyCoinConfimLogic);
		BuyCoinConfimLogic.releaseData();
	end

	BuyCoinConfimLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function BuyCoinConfimController:sleepModule()
	framework.releaseOnKeypadEventListener(BuyCoinConfimLogic.view)
	BuyCoinConfimLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function BuyCoinConfimController:wakeModule()
	framework.setOnKeypadEventListener(BuyCoinConfimLogic.view, BuyCoinConfimLogic.onKeypad)
	BuyCoinConfimLogic.view:setTouchEnabled(true)
end
