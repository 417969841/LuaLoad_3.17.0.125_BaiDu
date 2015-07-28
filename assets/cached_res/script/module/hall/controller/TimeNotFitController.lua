module(...,package.seeall)

Load.LuaRequire("script.module.hall.logic.TimeNotFitLogic")

TimeNotFitController = class("TimeNotFitController",BaseController)
TimeNotFitController.__index = TimeNotFitController

TimeNotFitController.moduleLayer = nil

function TimeNotFitController:reset()
	TimeNotFitLogic.view = nil
end

function TimeNotFitController:getLayer()
	return TimeNotFitLogic.view
end

function TimeNotFitController:createView()
	TimeNotFitLogic.createView()
	framework.setOnKeypadEventListener(TimeNotFitLogic.view, TimeNotFitLogic.onKeypad)
end

function TimeNotFitController:requestMsg()
	TimeNotFitLogic.requestMsg()
end

function TimeNotFitController:addSlot()
	TimeNotFitLogic.addSlot()
end

function TimeNotFitController:removeSlot()
	TimeNotFitLogic.removeSlot()
end

function TimeNotFitController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TimeNotFitLogic.view,"btn_close"),TimeNotFitLogic.callback_btn_close,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(TimeNotFitLogic.view,"btn_go"),TimeNotFitLogic.callback_btn_go,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TimeNotFitController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TimeNotFitLogic.view,"btn_close"),TimeNotFitLogic.callback_btn_close,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(TimeNotFitLogic.view,"btn_go"),TimeNotFitLogic.callback_btn_go,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TimeNotFitController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function TimeNotFitController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function TimeNotFitController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TimeNotFitLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(TimeNotFitLogic);
		TimeNotFitLogic.releaseData();
	end

	TimeNotFitLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function TimeNotFitController:sleepModule()
	framework.releaseOnKeypadEventListener(TimeNotFitLogic.view)
	TimeNotFitLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function TimeNotFitController:wakeModule()
	framework.setOnKeypadEventListener(TimeNotFitLogic.view, TimeNotFitLogic.onKeypad)
	TimeNotFitLogic.view:setTouchEnabled(true)
end
