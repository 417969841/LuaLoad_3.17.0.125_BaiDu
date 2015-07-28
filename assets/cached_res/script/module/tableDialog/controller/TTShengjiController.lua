module(...,package.seeall)

Load.LuaRequire("script.module.tableDialog.logic.TTShengjiLogic")

TTShengjiController = class("TTShengjiController",BaseController)
TTShengjiController.__index = TTShengjiController

TTShengjiController.moduleLayer = nil

function TTShengjiController:reset()
	TTShengjiLogic.view = nil
end

function TTShengjiController:getLayer()
	return TTShengjiLogic.view
end

function TTShengjiController:createView()
	TTShengjiLogic.createView()
	framework.setOnKeypadEventListener(TTShengjiLogic.view, TTShengjiLogic.onKeypad)
end

function TTShengjiController:requestMsg()
	TTShengjiLogic.requestMsg()
end

function TTShengjiController:addSlot()
	TTShengjiLogic.addSlot()
end

function TTShengjiController:removeSlot()
	TTShengjiLogic.removeSlot()
end

function TTShengjiController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TTShengjiLogic.view,"btn_close"),TTShengjiLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(TTShengjiLogic.view,"btn_lq"),TTShengjiLogic.callback_btn_lq,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function TTShengjiController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TTShengjiLogic.view,"btn_close"),TTShengjiLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(TTShengjiLogic.view,"btn_lq"),TTShengjiLogic.callback_btn_lq,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function TTShengjiController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function TTShengjiController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function TTShengjiController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TTShengjiLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TTShengjiLogic);
		TTShengjiLogic.releaseData();
	end

	TTShengjiLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function TTShengjiController:sleepModule()
	framework.releaseOnKeypadEventListener(TTShengjiLogic.view)
	TTShengjiLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function TTShengjiController:wakeModule()
	framework.setOnKeypadEventListener(TTShengjiLogic.view, TTShengjiLogic.onKeypad)
	TTShengjiLogic.view:setTouchEnabled(true)
end
