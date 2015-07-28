module(...,package.seeall)

Load.LuaRequire("script.module.match.logic.JsMatchDetailLogic")

JsMatchDetailController = class("JsMatchDetailController",BaseController)
JsMatchDetailController.__index = JsMatchDetailController

JsMatchDetailController.moduleLayer = nil

function JsMatchDetailController:reset()
	JsMatchDetailLogic.view = nil
end

function JsMatchDetailController:getLayer()
	return JsMatchDetailLogic.view
end

function JsMatchDetailController:createView()
	JsMatchDetailLogic.createView()
	framework.setOnKeypadEventListener(JsMatchDetailLogic.view, JsMatchDetailLogic.onKeypad)
end

function JsMatchDetailController:requestMsg()
	JsMatchDetailLogic.requestMsg()
end

function JsMatchDetailController:addSlot()
	JsMatchDetailLogic.addSlot()
end

function JsMatchDetailController:removeSlot()
	JsMatchDetailLogic.removeSlot()
end

function JsMatchDetailController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JsMatchDetailLogic.view,"BackButton"),JsMatchDetailLogic.callback_btn_ts,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function JsMatchDetailController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JsMatchDetailLogic.view,"BackButton"),JsMatchDetailLogic.callback_btn_ts,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function JsMatchDetailController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function JsMatchDetailController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function JsMatchDetailController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JsMatchDetailLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(JsMatchDetailLogic);
		JsMatchDetailLogic.releaseData();
	end

	JsMatchDetailLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function JsMatchDetailController:sleepModule()
	framework.releaseOnKeypadEventListener(JsMatchDetailLogic.view)
	JsMatchDetailLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function JsMatchDetailController:wakeModule()
	framework.setOnKeypadEventListener(JsMatchDetailLogic.view, JsMatchDetailLogic.onKeypad)
	JsMatchDetailLogic.view:setTouchEnabled(true)
end
