module(...,package.seeall)

Load.LuaRequire("script.module.commondialog.logic.HallGiftShowLogic")

HallGiftShowController = class("HallGiftShowController",BaseController)
HallGiftShowController.__index = HallGiftShowController

HallGiftShowController.moduleLayer = nil

function HallGiftShowController:reset()
	HallGiftShowLogic.view = nil
end

function HallGiftShowController:getLayer()
	return HallGiftShowLogic.view
end

function HallGiftShowController:createView()
	HallGiftShowLogic.createView()
end

function HallGiftShowController:requestMsg()
	HallGiftShowLogic.requestMsg()
	framework.setOnKeypadEventListener(HallGiftShowLogic.view, HallGiftShowLogic.onKeypad)
end

function HallGiftShowController:addSlot()
	HallGiftShowLogic.addSlot()
end

function HallGiftShowController:removeSlot()
	HallGiftShowLogic.removeSlot()
end

function HallGiftShowController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(HallGiftShowLogic.view,"btn_buy"), HallGiftShowLogic.callback_btn_buy, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallGiftShowLogic.view,"btn_close"), HallGiftShowLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallGiftShowLogic.view,"btn_alipay"), HallGiftShowLogic.callback_btn_alipay, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallGiftShowLogic.view,"btn_weixin"), HallGiftShowLogic.callback_btn_weixin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function HallGiftShowController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(HallGiftShowLogic.view,"btn_buy"), HallGiftShowLogic.callback_btn_buy, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallGiftShowLogic.view,"btn_close"), HallGiftShowLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallGiftShowLogic.view,"btn_alipay"), HallGiftShowLogic.callback_btn_alipay, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallGiftShowLogic.view,"btn_weixin"), HallGiftShowLogic.callback_btn_weixin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function HallGiftShowController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function HallGiftShowController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function HallGiftShowController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(HallGiftShowLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(HallGiftShowLogic);
		HallGiftShowLogic.releaseData();
	end

	HallGiftShowLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function HallGiftShowController:sleepModule()
	framework.releaseOnKeypadEventListener(HallGiftShowLogic.view)
	HallGiftShowLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function HallGiftShowController:wakeModule()
	framework.setOnKeypadEventListener(HallGiftShowLogic.view, HallGiftShowLogic.onKeypad)
	HallGiftShowLogic.view:setTouchEnabled(true)
end
