module(...,package.seeall)

Load.LuaRequire("script.module.tableDialog.logic.TableNotEndedLogic")

TableNotEndedController = class("TableNotEndedController",BaseController)
TableNotEndedController.__index = TableNotEndedController

TableNotEndedController.moduleLayer = nil

function TableNotEndedController:reset()
	TableNotEndedLogic.view = nil
end

function TableNotEndedController:getLayer()
	return TableNotEndedLogic.view
end

function TableNotEndedController:createView()
	TableNotEndedLogic.createView()
	framework.setOnKeypadEventListener(TableNotEndedLogic.view, TableNotEndedLogic.onKeypad)
end

function TableNotEndedController:requestMsg()
	TableNotEndedLogic.requestMsg()
end

function TableNotEndedController:addSlot()
	TableNotEndedLogic.addSlot()
end

function TableNotEndedController:removeSlot()
	TableNotEndedLogic.removeSlot()
end

function TableNotEndedController:addCallback()
--	framework.bindEventCallback(cocostudio.getComponent(TableNotEndedLogic.view,"Button_ranking"),TableNotEndedLogic.callback_Button_ranking,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(TableNotEndedLogic.view,"Button_details"),TableNotEndedLogic.callback_Button_details,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TableNotEndedController:removeCallback()
--	framework.unbindEventCallback(cocostudio.getComponent(TableNotEndedLogic.view,"Button_ranking"),TableNotEndedLogic.callback_Button_ranking,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(TableNotEndedLogic.view,"Button_details"),TableNotEndedLogic.callback_Button_details,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TableNotEndedController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function TableNotEndedController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function TableNotEndedController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TableNotEndedLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TableNotEndedLogic);
		TableNotEndedLogic.releaseData();
	end

	TableNotEndedLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function TableNotEndedController:sleepModule()
	framework.releaseOnKeypadEventListener(TableNotEndedLogic.view)
	TableNotEndedLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function TableNotEndedController:wakeModule()
	framework.setOnKeypadEventListener(TableNotEndedLogic.view, TableNotEndedLogic.onKeypad)
	TableNotEndedLogic.view:setTouchEnabled(true)
end
