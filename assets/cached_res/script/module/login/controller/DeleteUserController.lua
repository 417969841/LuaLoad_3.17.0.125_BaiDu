module(...,package.seeall)

Load.LuaRequire("script.module.login.logic.DeleteUserLogic")

DeleteUserController = class("DeleteUserController",BaseController)
DeleteUserController.__index = DeleteUserController

DeleteUserController.moduleLayer = nil

function DeleteUserController:reset()
	DeleteUserLogic.view = nil
end

function DeleteUserController:getLayer()
	return DeleteUserLogic.view
end

function DeleteUserController:createView()
	DeleteUserLogic.createView()
	framework.setOnKeypadEventListener(DeleteUserLogic.view, DeleteUserLogic.onKeypad)
end

function DeleteUserController:requestMsg()
	DeleteUserLogic.requestMsg()
end

function DeleteUserController:addSlot()
	DeleteUserLogic.addSlot()
end

function DeleteUserController:removeSlot()
	DeleteUserLogic.removeSlot()
end

function DeleteUserController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(DeleteUserLogic.view,"btn_close"),DeleteUserLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(DeleteUserLogic.view,"btn_go"),DeleteUserLogic.callback_btn_go,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function DeleteUserController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(DeleteUserLogic.view,"btn_close"),DeleteUserLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(DeleteUserLogic.view,"btn_go"),DeleteUserLogic.callback_btn_go,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function DeleteUserController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function DeleteUserController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function DeleteUserController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(DeleteUserLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(DeleteUserLogic);
		DeleteUserLogic.releaseData();
	end

	DeleteUserLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function DeleteUserController:sleepModule()
	framework.releaseOnKeypadEventListener(DeleteUserLogic.view)
	DeleteUserLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function DeleteUserController:wakeModule()
	framework.setOnKeypadEventListener(DeleteUserLogic.view, DeleteUserLogic.onKeypad)
	DeleteUserLogic.view:setTouchEnabled(true)
end
