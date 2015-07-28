module(...,package.seeall);

Load.LuaRequire("script.module.tableDialog.logic.TableOtherUserInfoLogic");

TableOtherUserInfoController = class("TableOtherUserInfoController",BaseController);
TableOtherUserInfoController.__index = TableOtherUserInfoController;

TableOtherUserInfoController.moduleLayer = nil;

function TableOtherUserInfoController:reset()
	TableOtherUserInfoLogic.view = nil;
end

function TableOtherUserInfoController:getLayer()
	return TableOtherUserInfoLogic.view;
end

function TableOtherUserInfoController:createView()
	TableOtherUserInfoLogic.createView();
	framework.setOnKeypadEventListener(TableOtherUserInfoLogic.view, TableOtherUserInfoLogic.onKeypad);
end

function TableOtherUserInfoController:requestMsg()
	TableOtherUserInfoLogic.requestMsg();
end

function TableOtherUserInfoController:addSlot()
	TableOtherUserInfoLogic.addSlot();
end

function TableOtherUserInfoController:removeSlot()
	TableOtherUserInfoLogic.removeSlot();
end

function TableOtherUserInfoController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"panel_userinfo"), TableOtherUserInfoLogic.callback_panel_userinfo, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"panel"), TableOtherUserInfoLogic.callback_panel, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
--	framework.bindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"btn_close"), TableOtherUserInfoLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"btn_jubao"), TableOtherUserInfoLogic.callback_btn_jubao, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
framework.bindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"btn_dazhaohu"), TableOtherUserInfoLogic.callback_btn_dazhaohu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"btn_faxiaoxi"), TableOtherUserInfoLogic.callback_btn_faxiaoxi, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TableOtherUserInfoController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"panel_userinfo"), TableOtherUserInfoLogic.callback_panel_userinfo, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"panel"), TableOtherUserInfoLogic.callback_panel, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
--	framework.unbindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"btn_close"), TableOtherUserInfoLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"btn_jubao"), TableOtherUserInfoLogic.callback_btn_jubao, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"btn_dazhaohu"), TableOtherUserInfoLogic.callback_btn_dazhaohu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableOtherUserInfoLogic.view,"btn_faxiaoxi"), TableOtherUserInfoLogic.callback_btn_faxiaoxi, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TableOtherUserInfoController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function TableOtherUserInfoController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function TableOtherUserInfoController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TableOtherUserInfoLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TableOtherUserInfoLogic);
		TableOtherUserInfoLogic.releaseData();
	end

	TableOtherUserInfoLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function TableOtherUserInfoController:sleepModule()
	framework.releaseOnKeypadEventListener(TableOtherUserInfoLogic.view);
	TableOtherUserInfoLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function TableOtherUserInfoController:wakeModule()
	framework.setOnKeypadEventListener(TableOtherUserInfoLogic.view, TableOtherUserInfoLogic.onKeypad);
	TableOtherUserInfoLogic.view:setTouchEnabled(true);
end
