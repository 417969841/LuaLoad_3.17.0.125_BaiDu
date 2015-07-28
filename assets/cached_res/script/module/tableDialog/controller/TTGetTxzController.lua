module(...,package.seeall)

Load.LuaRequire("script.module.tableDialog.logic.TTGetTxzLogic")

TTGetTxzController = class("TTGetTxzController",BaseController)
TTGetTxzController.__index = TTGetTxzController

TTGetTxzController.moduleLayer = nil

function TTGetTxzController:reset()
	TTGetTxzLogic.view = nil
end

function TTGetTxzController:getLayer()
	return TTGetTxzLogic.view
end

function TTGetTxzController:createView()
	TTGetTxzLogic.createView()
	framework.setOnKeypadEventListener(TTGetTxzLogic.view, TTGetTxzLogic.onKeypad)
end

function TTGetTxzController:requestMsg()
	TTGetTxzLogic.requestMsg()
end

function TTGetTxzController:addSlot()
	TTGetTxzLogic.addSlot()
end

function TTGetTxzController:removeSlot()
	TTGetTxzLogic.removeSlot()
end

function TTGetTxzController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TTGetTxzLogic.view,"btn_close"),TTGetTxzLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(TTGetTxzLogic.view,"btn_gomatch"),TTGetTxzLogic.callback_btn_gomatch,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(TTGetTxzLogic.view,"btn_goshop"),TTGetTxzLogic.callback_btn_goshop,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function TTGetTxzController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TTGetTxzLogic.view,"btn_close"),TTGetTxzLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(TTGetTxzLogic.view,"btn_gomatch"),TTGetTxzLogic.callback_btn_gomatch,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(TTGetTxzLogic.view,"btn_goshop"),TTGetTxzLogic.callback_btn_goshop,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function TTGetTxzController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function TTGetTxzController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function TTGetTxzController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TTGetTxzLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TTGetTxzLogic);
		TTGetTxzLogic.releaseData();
	end

	TTGetTxzLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function TTGetTxzController:sleepModule()
	framework.releaseOnKeypadEventListener(TTGetTxzLogic.view)
	TTGetTxzLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function TTGetTxzController:wakeModule()
	framework.setOnKeypadEventListener(TTGetTxzLogic.view, TTGetTxzLogic.onKeypad)
	TTGetTxzLogic.view:setTouchEnabled(true)
end
