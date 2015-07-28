module(...,package.seeall)

Load.LuaRequire("script.module.tableDialog.logic.TableExitLogic")

TableExitController = class("TableExitController",BaseController)
TableExitController.__index = TableExitController

TableExitController.moduleLayer = nil

function TableExitController:reset()
	TableExitLogic.view = nil
end

function TableExitController:getLayer()
	return TableExitLogic.view
end

function TableExitController:createView()
	TableExitLogic.createView()
	framework.setOnKeypadEventListener(TableExitLogic.view, TableExitLogic.onKeypad)
end

function TableExitController:requestMsg()
	TableExitLogic.requestMsg()
end

function TableExitController:addSlot()
	TableExitLogic.addSlot()
end

function TableExitController:removeSlot()
	TableExitLogic.removeSlot()
end

function TableExitController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TableExitLogic.view,"Button_exit"),TableExitLogic.callback_Button_exit,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(TableExitLogic.view,"Button_back"),TableExitLogic.callback_Button_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TableExitController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TableExitLogic.view,"Button_exit"),TableExitLogic.callback_Button_exit,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(TableExitLogic.view,"Button_back"),TableExitLogic.callback_Button_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TableExitController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function TableExitController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function TableExitController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TableExitLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TableExitLogic);
		TableExitLogic.releaseData();
	end

	TableExitLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function TableExitController:sleepModule()
	framework.releaseOnKeypadEventListener(TableExitLogic.view)
	TableExitLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function TableExitController:wakeModule()
	framework.setOnKeypadEventListener(TableExitLogic.view, TableExitLogic.onKeypad)
	TableExitLogic.view:setTouchEnabled(true)
end
