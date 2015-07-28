module(...,package.seeall);

Load.LuaRequire("script.module.tableDialog.logic.TableSelfUserInfoLogic");

TableSelfUserInfoController = class("TableSelfUserInfoController",BaseController);
TableSelfUserInfoController.__index = TableSelfUserInfoController;

TableSelfUserInfoController.moduleLayer = nil;

function TableSelfUserInfoController:reset()
	TableSelfUserInfoLogic.view = nil;
end

function TableSelfUserInfoController:getLayer()
	return TableSelfUserInfoLogic.view;
end

function TableSelfUserInfoController:createView()
	TableSelfUserInfoLogic.createView();
	framework.setOnKeypadEventListener(TableSelfUserInfoLogic.view, TableSelfUserInfoLogic.onKeypad);
end

function TableSelfUserInfoController:requestMsg()
	TableSelfUserInfoLogic.requestMsg();
end

function TableSelfUserInfoController:addSlot()
	TableSelfUserInfoLogic.addSlot();
end

function TableSelfUserInfoController:removeSlot()
	TableSelfUserInfoLogic.removeSlot();
end

function TableSelfUserInfoController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TableSelfUserInfoLogic.view,"panel_userinfo"), TableSelfUserInfoLogic.callback_panel_userinfo, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TableSelfUserInfoLogic.view,"panel"), TableSelfUserInfoLogic.callback_panel, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
--	framework.bindEventCallback(cocostudio.getComponent(TableSelfUserInfoLogic.view,"btn_close"), TableSelfUserInfoLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableSelfUserInfoLogic.view,"img_useravator"), TableSelfUserInfoLogic.callback_img_useravator, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function TableSelfUserInfoController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TableSelfUserInfoLogic.view,"panel_userinfo"), TableSelfUserInfoLogic.callback_panel_userinfo, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TableSelfUserInfoLogic.view,"panel"), TableSelfUserInfoLogic.callback_panel, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
--	framework.unbindEventCallback(cocostudio.getComponent(TableSelfUserInfoLogic.view,"btn_close"), TableSelfUserInfoLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableSelfUserInfoLogic.view,"img_useravator"), TableSelfUserInfoLogic.callback_img_useravator, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function TableSelfUserInfoController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function TableSelfUserInfoController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function TableSelfUserInfoController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TableSelfUserInfoLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TableSelfUserInfoLogic);
		TableSelfUserInfoLogic.releaseData();
	end

	TableSelfUserInfoLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function TableSelfUserInfoController:sleepModule()
	framework.releaseOnKeypadEventListener(TableSelfUserInfoLogic.view);
	TableSelfUserInfoLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function TableSelfUserInfoController:wakeModule()
	framework.setOnKeypadEventListener(TableSelfUserInfoLogic.view, TableSelfUserInfoLogic.onKeypad);
	TableSelfUserInfoLogic.view:setTouchEnabled(true);
end
