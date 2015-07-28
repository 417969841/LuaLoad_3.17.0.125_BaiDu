module(...,package.seeall)

Load.LuaRequire("script.module.tableDialog.logic.TTJiangDuanLogic")

TTJiangDuanController = class("TTJiangDuanController",BaseController)
TTJiangDuanController.__index = TTJiangDuanController

TTJiangDuanController.moduleLayer = nil

function TTJiangDuanController:reset()
	TTJiangDuanLogic.view = nil
end

function TTJiangDuanController:getLayer()
	return TTJiangDuanLogic.view
end

function TTJiangDuanController:createView()
	TTJiangDuanLogic.createView()
	framework.setOnKeypadEventListener(TTJiangDuanLogic.view, TTJiangDuanLogic.onKeypad)
end

function TTJiangDuanController:requestMsg()
	TTJiangDuanLogic.requestMsg()
end

function TTJiangDuanController:addSlot()
	TTJiangDuanLogic.addSlot()
end

function TTJiangDuanController:removeSlot()
	TTJiangDuanLogic.removeSlot()
end

function TTJiangDuanController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TTJiangDuanLogic.view,"Button_close"),TTJiangDuanLogic.callback_Button_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TTJiangDuanController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TTJiangDuanLogic.view,"Button_close"),TTJiangDuanLogic.callback_Button_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TTJiangDuanController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function TTJiangDuanController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function TTJiangDuanController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TTJiangDuanLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TTJiangDuanLogic);
		TTJiangDuanLogic.releaseData();
	end

	TTJiangDuanLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function TTJiangDuanController:sleepModule()
	framework.releaseOnKeypadEventListener(TTJiangDuanLogic.view)
	TTJiangDuanLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function TTJiangDuanController:wakeModule()
	framework.setOnKeypadEventListener(TTJiangDuanLogic.view, TTJiangDuanLogic.onKeypad)
	TTJiangDuanLogic.view:setTouchEnabled(true)
end
