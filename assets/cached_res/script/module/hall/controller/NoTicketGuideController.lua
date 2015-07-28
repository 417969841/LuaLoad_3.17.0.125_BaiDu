module(...,package.seeall)

Load.LuaRequire("script.module.hall.logic.NoTicketGuideLogic")

NoTicketGuideController = class("NoTicketGuideController",BaseController)
NoTicketGuideController.__index = NoTicketGuideController

NoTicketGuideController.moduleLayer = nil

function NoTicketGuideController:reset()
	NoTicketGuideLogic.view = nil
end

function NoTicketGuideController:getLayer()
	return NoTicketGuideLogic.view
end

function NoTicketGuideController:createView()
	NoTicketGuideLogic.createView()
	framework.setOnKeypadEventListener(NoTicketGuideLogic.view, NoTicketGuideLogic.onKeypad)
end

function NoTicketGuideController:requestMsg()
	NoTicketGuideLogic.requestMsg()
end

function NoTicketGuideController:addSlot()
	NoTicketGuideLogic.addSlot()
end

function NoTicketGuideController:removeSlot()
	NoTicketGuideLogic.removeSlot()
end

function NoTicketGuideController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(NoTicketGuideLogic.view,"btn_close"),NoTicketGuideLogic.callback_btn_close,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(NoTicketGuideLogic.view,"btn_go"),NoTicketGuideLogic.callback_btn_go,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function NoTicketGuideController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(NoTicketGuideLogic.view,"btn_close"),NoTicketGuideLogic.callback_btn_close,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(NoTicketGuideLogic.view,"btn_go"),NoTicketGuideLogic.callback_btn_go,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function NoTicketGuideController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function NoTicketGuideController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function NoTicketGuideController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(NoTicketGuideLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(NoTicketGuideLogic);
		NoTicketGuideLogic.releaseData();
	end

	NoTicketGuideLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function NoTicketGuideController:sleepModule()
	framework.releaseOnKeypadEventListener(NoTicketGuideLogic.view)
	NoTicketGuideLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function NoTicketGuideController:wakeModule()
	framework.setOnKeypadEventListener(NoTicketGuideLogic.view, NoTicketGuideLogic.onKeypad)
	NoTicketGuideLogic.view:setTouchEnabled(true)
end
