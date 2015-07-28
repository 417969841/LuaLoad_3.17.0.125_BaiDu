module(...,package.seeall);

Load.LuaRequire("script.module.tableDialog.logic.TableReportLogic");

TableReportController = class("TableReportController",BaseController);
TableReportController.__index = TableReportController;

TableReportController.moduleLayer = nil;

function TableReportController:reset()
	TableReportLogic.view = nil;
end

function TableReportController:getLayer()
	return TableReportLogic.view;
end

function TableReportController:createView()
	TableReportLogic.createView();
	framework.setOnKeypadEventListener(TableReportLogic.view, TableReportLogic.onKeypad);
end

function TableReportController:requestMsg()
	TableReportLogic.requestMsg();
end

function TableReportController:addSlot()
	TableReportLogic.addSlot();
end

function TableReportController:removeSlot()
	TableReportLogic.removeSlot();
end

function TableReportController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TableReportLogic.view,"Panel_TableReport"), TableReportLogic.callback_Panel_TableReport, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TableReportLogic.view,"btn_ok"), TableReportLogic.callback_btn_ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableReportLogic.view,"btn_cancel"), TableReportLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TableReportController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TableReportLogic.view,"Panel_TableReport"), TableReportLogic.callback_Panel_TableReport, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TableReportLogic.view,"btn_ok"), TableReportLogic.callback_btn_ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableReportLogic.view,"btn_cancel"), TableReportLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TableReportController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function TableReportController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function TableReportController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TableReportLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TableReportLogic);
		TableReportLogic.releaseData();
	end

	TableReportLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function TableReportController:sleepModule()
	framework.releaseOnKeypadEventListener(TableReportLogic.view);
	TableReportLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function TableReportController:wakeModule()
	framework.setOnKeypadEventListener(TableReportLogic.view, TableReportLogic.onKeypad);
	TableReportLogic.view:setTouchEnabled(true);
end
