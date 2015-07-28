module(...,package.seeall)

Load.LuaRequire("script.loadModule.aixinnvshen.logic.AaiXinNvShenGuiZeLogic")

AaiXinNvShenGuiZeController = class("AaiXinNvShenGuiZeController",BaseController)
AaiXinNvShenGuiZeController.__index = AaiXinNvShenGuiZeController

AaiXinNvShenGuiZeController.moduleLayer = nil

function AaiXinNvShenGuiZeController:reset()
	AaiXinNvShenGuiZeLogic.view = nil
end

function AaiXinNvShenGuiZeController:getLayer()
	return AaiXinNvShenGuiZeLogic.view
end

function AaiXinNvShenGuiZeController:createView()
	AaiXinNvShenGuiZeLogic.createView()
	framework.setOnKeypadEventListener(AaiXinNvShenGuiZeLogic.view, AaiXinNvShenGuiZeLogic.onKeypad)
end

function AaiXinNvShenGuiZeController:requestMsg()
	AaiXinNvShenGuiZeLogic.requestMsg()
end

function AaiXinNvShenGuiZeController:addSlot()
	AaiXinNvShenGuiZeLogic.addSlot()
end

function AaiXinNvShenGuiZeController:removeSlot()
	AaiXinNvShenGuiZeLogic.removeSlot()
end

function AaiXinNvShenGuiZeController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(AaiXinNvShenGuiZeLogic.view,"BackButton"),AaiXinNvShenGuiZeLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function AaiXinNvShenGuiZeController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(AaiXinNvShenGuiZeLogic.view,"BackButton"),AaiXinNvShenGuiZeLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function AaiXinNvShenGuiZeController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function AaiXinNvShenGuiZeController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function AaiXinNvShenGuiZeController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(AaiXinNvShenGuiZeLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(AaiXinNvShenGuiZeLogic);
		AaiXinNvShenGuiZeLogic.releaseData();
	end

	AaiXinNvShenGuiZeLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function AaiXinNvShenGuiZeController:sleepModule()
	framework.releaseOnKeypadEventListener(AaiXinNvShenGuiZeLogic.view)
	AaiXinNvShenGuiZeLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function AaiXinNvShenGuiZeController:wakeModule()
	framework.setOnKeypadEventListener(AaiXinNvShenGuiZeLogic.view, AaiXinNvShenGuiZeLogic.onKeypad)
	AaiXinNvShenGuiZeLogic.view:setTouchEnabled(true)
end
