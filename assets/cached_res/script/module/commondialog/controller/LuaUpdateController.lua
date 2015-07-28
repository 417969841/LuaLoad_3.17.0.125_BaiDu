module(...,package.seeall)

Load.LuaRequire("script.module.commondialog.logic.LuaUpdateLogic")

LuaUpdateController = class("LuaUpdateController",BaseController)
LuaUpdateController.__index = LuaUpdateController

LuaUpdateController.moduleLayer = nil

function LuaUpdateController:reset()
	LuaUpdateLogic.view = nil
end

function LuaUpdateController:getLayer()
	return LuaUpdateLogic.view
end

function LuaUpdateController:createView()
	LuaUpdateLogic.createView()
end

function LuaUpdateController:requestMsg()
	LuaUpdateLogic.requestMsg()
end

function LuaUpdateController:addSlot()
	LuaUpdateLogic.addSlot()
end

function LuaUpdateController:removeSlot()
	LuaUpdateLogic.removeSlot()
end

function LuaUpdateController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(LuaUpdateLogic.view,"btn_cancel"),LuaUpdateLogic.callback_btn_cancel,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(LuaUpdateLogic.view,"btn_update"),LuaUpdateLogic.callback_btn_update,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function LuaUpdateController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(LuaUpdateLogic.view,"btn_cancel"),LuaUpdateLogic.callback_btn_cancel,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(LuaUpdateLogic.view,"btn_update"),LuaUpdateLogic.callback_btn_update,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function LuaUpdateController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function LuaUpdateController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function LuaUpdateController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(LuaUpdateLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(LuaUpdateLogic);
		LuaUpdateLogic.releaseData();
	end

	LuaUpdateLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function LuaUpdateController:sleepModule()
	LuaUpdateLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function LuaUpdateController:wakeModule()
	LuaUpdateLogic.view:setTouchEnabled(true)
end
