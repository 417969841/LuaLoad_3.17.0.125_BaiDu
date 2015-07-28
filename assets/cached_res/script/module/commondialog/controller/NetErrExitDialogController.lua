module(...,package.seeall);

Load.LuaRequire("script.module.commondialog.logic.NetErrExitDialogLogic");

NetErrExitDialogController = class("NetErrExitDialogController",BaseController);
NetErrExitDialogController.__index = NetErrExitDialogController;

NetErrExitDialogController.moduleLayer = nil;

function NetErrExitDialogController:reset()
	NetErrExitDialogLogic.view = nil;
end

function NetErrExitDialogController:getLayer()
	return NetErrExitDialogLogic.view;
end

function NetErrExitDialogController:createView()
	NetErrExitDialogLogic.createView();
	framework.setOnKeypadEventListener(NetErrExitDialogLogic.view, NetErrExitDialogLogic.onKeypad);
end

function NetErrExitDialogController:requestMsg()
	NetErrExitDialogLogic.requestMsg();
end

function NetErrExitDialogController:addSlot()
	NetErrExitDialogLogic.addSlot();
end

function NetErrExitDialogController:removeSlot()
	NetErrExitDialogLogic.removeSlot();
end

function NetErrExitDialogController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(NetErrExitDialogLogic.view,"btn_logout"), NetErrExitDialogLogic.callback_btn_logout, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(NetErrExitDialogLogic.view,"btn_exit"), NetErrExitDialogLogic.callback_btn_exit, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(NetErrExitDialogLogic.view,"btn_logout_ios"), NetErrExitDialogLogic.callback_btn_logout_ios, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function NetErrExitDialogController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(NetErrExitDialogLogic.view,"btn_logout"), NetErrExitDialogLogic.callback_btn_logout, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(NetErrExitDialogLogic.view,"btn_exit"), NetErrExitDialogLogic.callback_btn_exit, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(NetErrExitDialogLogic.view,"btn_logout_ios"), NetErrExitDialogLogic.callback_btn_logout_ios, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function NetErrExitDialogController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function NetErrExitDialogController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function NetErrExitDialogController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(NetErrExitDialogLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(NetErrExitDialogLogic);
		NetErrExitDialogLogic.releaseData();
	end

	NetErrExitDialogLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function NetErrExitDialogController:sleepModule()
	framework.releaseOnKeypadEventListener(NetErrExitDialogLogic.view);
	NetErrExitDialogLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function NetErrExitDialogController:wakeModule()
	framework.setOnKeypadEventListener(NetErrExitDialogLogic.view, NetErrExitDialogLogic.onKeypad);
	NetErrExitDialogLogic.view:setTouchEnabled(true);
end
