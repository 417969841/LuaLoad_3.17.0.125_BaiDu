module(...,package.seeall)

Load.LuaRequire("script.module.pack.logic.BackDetailLogic")

BackDetailController = class("BackDetailController",BaseController)
BackDetailController.__index = BackDetailController

BackDetailController.moduleLayer = nil

function BackDetailController:reset()
	BackDetailLogic.view = nil
end

function BackDetailController:getLayer()
	return BackDetailLogic.view
end

function BackDetailController:createView()
	BackDetailLogic.createView()
	framework.setOnKeypadEventListener(BackDetailLogic.view, BackDetailLogic.onKeypad)
end

function BackDetailController:requestMsg()
	BackDetailLogic.requestMsg()
end

function BackDetailController:addSlot()
	BackDetailLogic.addSlot()
end

function BackDetailController:removeSlot()
	BackDetailLogic.removeSlot()
end

function BackDetailController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(BackDetailLogic.view,"btn_ok"),BackDetailLogic.callback_btn_ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(BackDetailLogic.view,"btn_close"),BackDetailLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function BackDetailController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(BackDetailLogic.view,"btn_ok"),BackDetailLogic.callback_btn_ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(BackDetailLogic.view,"btn_close"),BackDetailLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function BackDetailController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function BackDetailController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function BackDetailController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(BackDetailLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(BackDetailLogic);
		BackDetailLogic.releaseData();
	end

	BackDetailLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function BackDetailController:sleepModule()
	framework.releaseOnKeypadEventListener(BackDetailLogic.view)
	BackDetailLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function BackDetailController:wakeModule()
	framework.setOnKeypadEventListener(BackDetailLogic.view, BackDetailLogic.onKeypad)
	BackDetailLogic.view:setTouchEnabled(true)
end
