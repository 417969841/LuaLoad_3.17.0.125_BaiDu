module(...,package.seeall)

Load.LuaRequire("script.module.commondialog.logic.HallGiftCloseLogic")

HallGiftCloseController = class("HallGiftCloseController",BaseController)
HallGiftCloseController.__index = HallGiftCloseController

HallGiftCloseController.moduleLayer = nil

function HallGiftCloseController:reset()
	HallGiftCloseLogic.view = nil
end

function HallGiftCloseController:getLayer()
	return HallGiftCloseLogic.view
end

function HallGiftCloseController:createView()
	HallGiftCloseLogic.createView()
	framework.setOnKeypadEventListener(HallGiftCloseLogic.view, HallGiftCloseLogic.onKeypad)
end

function HallGiftCloseController:requestMsg()
	HallGiftCloseLogic.requestMsg()
end

function HallGiftCloseController:addSlot()
	HallGiftCloseLogic.addSlot()
end

function HallGiftCloseController:removeSlot()
	HallGiftCloseLogic.removeSlot()
end

function HallGiftCloseController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(HallGiftCloseLogic.view,"Button_close"),HallGiftCloseLogic.callback_Button_close,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(HallGiftCloseLogic.view,"Button_back"),HallGiftCloseLogic.callback_Button_back,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function HallGiftCloseController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(HallGiftCloseLogic.view,"Button_close"),HallGiftCloseLogic.callback_Button_close,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(HallGiftCloseLogic.view,"Button_back"),HallGiftCloseLogic.callback_Button_back,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function HallGiftCloseController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function HallGiftCloseController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function HallGiftCloseController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(HallGiftCloseLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(HallGiftCloseLogic);
		HallGiftCloseLogic.releaseData();
	end

	HallGiftCloseLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function HallGiftCloseController:sleepModule()
	framework.releaseOnKeypadEventListener(HallGiftCloseLogic.view)
	HallGiftCloseLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function HallGiftCloseController:wakeModule()
	framework.setOnKeypadEventListener(HallGiftCloseLogic.view, HallGiftCloseLogic.onKeypad)
	HallGiftCloseLogic.view:setTouchEnabled(true)
end
