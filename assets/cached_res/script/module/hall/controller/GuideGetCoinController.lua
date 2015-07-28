module(...,package.seeall)

Load.LuaRequire("script.module.hall.logic.GuideGetCoinLogic")

GuideGetCoinController = class("GuideGetCoinController",BaseController)
GuideGetCoinController.__index = GuideGetCoinController

GuideGetCoinController.moduleLayer = nil

function GuideGetCoinController:reset()
	GuideGetCoinLogic.view = nil
end

function GuideGetCoinController:getLayer()
	return GuideGetCoinLogic.view
end

function GuideGetCoinController:createView()
	GuideGetCoinLogic.createView()
	framework.setOnKeypadEventListener(GuideGetCoinLogic.view, GuideGetCoinLogic.onKeypad)
end

function GuideGetCoinController:requestMsg()
	GuideGetCoinLogic.requestMsg()
end

function GuideGetCoinController:addSlot()
	GuideGetCoinLogic.addSlot()
end

function GuideGetCoinController:removeSlot()
	GuideGetCoinLogic.removeSlot()
end

function GuideGetCoinController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(GuideGetCoinLogic.view,"btn_close"),GuideGetCoinLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(GuideGetCoinLogic.view,"btn_cz"),GuideGetCoinLogic.callback_btn_cz,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(GuideGetCoinLogic.view,"btn_go"),GuideGetCoinLogic.callback_btn_go,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(GuideGetCoinLogic.view,"btn_bm"),GuideGetCoinLogic.callback_btn_bm,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function GuideGetCoinController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(GuideGetCoinLogic.view,"btn_close"),GuideGetCoinLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(GuideGetCoinLogic.view,"btn_cz"),GuideGetCoinLogic.callback_btn_cz,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(GuideGetCoinLogic.view,"btn_go"),GuideGetCoinLogic.callback_btn_go,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(GuideGetCoinLogic.view,"btn_bm"),GuideGetCoinLogic.callback_btn_bm,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function GuideGetCoinController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function GuideGetCoinController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function GuideGetCoinController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(GuideGetCoinLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(GuideGetCoinLogic);
		GuideGetCoinLogic.releaseData();
	end

	GuideGetCoinLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function GuideGetCoinController:sleepModule()
	framework.releaseOnKeypadEventListener(GuideGetCoinLogic.view)
	GuideGetCoinLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function GuideGetCoinController:wakeModule()
	framework.setOnKeypadEventListener(GuideGetCoinLogic.view, GuideGetCoinLogic.onKeypad)
	GuideGetCoinLogic.view:setTouchEnabled(true)
end
