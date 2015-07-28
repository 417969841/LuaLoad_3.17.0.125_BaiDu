module(...,package.seeall)

Load.LuaRequire("script.module.commondialog.logic.RechargePromptLogic")

RechargePromptController = class("RechargePromptController",BaseController)
RechargePromptController.__index = RechargePromptController

RechargePromptController.moduleLayer = nil

function RechargePromptController:reset()
	RechargePromptLogic.view = nil
end

function RechargePromptController:getLayer()
	return RechargePromptLogic.view
end

function RechargePromptController:createView()
	RechargePromptLogic.createView()
	framework.setOnKeypadEventListener(RechargePromptLogic.view, RechargePromptLogic.onKeypad)
end

function RechargePromptController:requestMsg()
	RechargePromptLogic.requestMsg()
end

function RechargePromptController:addSlot()
	RechargePromptLogic.addSlot()
end

function RechargePromptController:removeSlot()
	RechargePromptLogic.removeSlot()
end

function RechargePromptController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RechargePromptLogic.view,"btn_close"),RechargePromptLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function RechargePromptController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RechargePromptLogic.view,"btn_close"),RechargePromptLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function RechargePromptController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function RechargePromptController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function RechargePromptController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RechargePromptLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(RechargePromptLogic);
		RechargePromptLogic.releaseData();
	end

	RechargePromptLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function RechargePromptController:sleepModule()
	framework.releaseOnKeypadEventListener(RechargePromptLogic.view)
	RechargePromptLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function RechargePromptController:wakeModule()
	framework.setOnKeypadEventListener(RechargePromptLogic.view, RechargePromptLogic.onKeypad)
	RechargePromptLogic.view:setTouchEnabled(true)
end
