module(...,package.seeall)

Load.LuaRequire("script.module.renwu.logic.RenWuGuiZeLogic")

RenWuGuiZeController = class("RenWuGuiZeController",BaseController)
RenWuGuiZeController.__index = RenWuGuiZeController

RenWuGuiZeController.moduleLayer = nil

function RenWuGuiZeController:reset()
	RenWuGuiZeLogic.view = nil
end

function RenWuGuiZeController:getLayer()
	return RenWuGuiZeLogic.view
end

function RenWuGuiZeController:createView()
	RenWuGuiZeLogic.createView()
	framework.setOnKeypadEventListener(RenWuGuiZeLogic.view, RenWuGuiZeLogic.onKeypad)
end

function RenWuGuiZeController:requestMsg()
	RenWuGuiZeLogic.requestMsg()
end

function RenWuGuiZeController:addSlot()
	RenWuGuiZeLogic.addSlot()
end

function RenWuGuiZeController:removeSlot()
	RenWuGuiZeLogic.removeSlot()
end

function RenWuGuiZeController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RenWuGuiZeLogic.view,"BackButton"),RenWuGuiZeLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function RenWuGuiZeController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RenWuGuiZeLogic.view,"BackButton"),RenWuGuiZeLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function RenWuGuiZeController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function RenWuGuiZeController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function RenWuGuiZeController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RenWuGuiZeLogic.view)
	self:destroy()
	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RenWuGuiZeLogic);
		RenWuGuiZeLogic.releaseData();
	end

	RenWuGuiZeLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function RenWuGuiZeController:sleepModule()
	framework.releaseOnKeypadEventListener(RenWuGuiZeLogic.view)
	RenWuGuiZeLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function RenWuGuiZeController:wakeModule()
	framework.setOnKeypadEventListener(RenWuGuiZeLogic.view, RenWuGuiZeLogic.onKeypad)
	RenWuGuiZeLogic.view:setTouchEnabled(true)
end
