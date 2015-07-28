module(...,package.seeall)

Load.LuaRequire("script.module.login.logic.LoadingLogic")

LoadingController = class("LoadingController",BaseController)
LoadingController.__index = LoadingController

LoadingController.moduleLayer = nil

function LoadingController:reset()
	LoadingLogic.view = nil
end

function LoadingController:getLayer()
	return LoadingLogic.view
end

function LoadingController:createView()
	LoadingLogic.createView()
	framework.setOnKeypadEventListener(LoadingLogic.view, LoadingLogic.onKeypad)
end

function LoadingController:requestMsg()
	LoadingLogic.requestMsg()
end

function LoadingController:addSlot()
	LoadingLogic.addSlot()
end

function LoadingController:removeSlot()
	LoadingLogic.removeSlot()
end

function LoadingController:addCallback()
--framework.bindEventCallback(cocostudio.getComponent(LoadingLogic.view,"btn_close"),LoadingLogic.callback_btn_close,BUTTON_CLICK)
end

function LoadingController:removeCallback()
--framework.unbindEventCallback(cocostudio.getComponent(LoadingLogic.view,"btn_close"),LoadingLogic.callback_btn_close,BUTTON_CLICK)
end

function LoadingController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function LoadingController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function LoadingController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(LoadingLogic.view)
	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
	end
	self:destroy()
	LoadingLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function LoadingController:sleepModule()
	framework.releaseOnKeypadEventListener(LoadingLogic.view)
	LoadingLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function LoadingController:wakeModule()
	framework.setOnKeypadEventListener(LoadingLogic.view, LoadingLogic.onKeypad)
	LoadingLogic.view:setTouchEnabled(true)
end
