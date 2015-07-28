module(...,package.seeall);

Load.LuaRequire("script.loadModule.wanrenjinhuapop.logic.WanRenHistoryPopLogic");

WanRenHistoryPopController = class("WanRenHistoryPopController",BaseController);
WanRenHistoryPopController.__index = WanRenHistoryPopController;

WanRenHistoryPopController.moduleLayer = nil;

function WanRenHistoryPopController:reset()
	WanRenHistoryPopLogic.view = nil;
end

function WanRenHistoryPopController:getLayer()
	return WanRenHistoryPopLogic.view;
end

function WanRenHistoryPopController:createView()
	WanRenHistoryPopLogic.createView();
	framework.setOnKeypadEventListener(WanRenHistoryPopLogic.view, WanRenHistoryPopLogic.onKeypad);
end

function WanRenHistoryPopController:requestMsg()
	WanRenHistoryPopLogic.requestMsg();
end

function WanRenHistoryPopController:addSlot()
	WanRenHistoryPopLogic.addSlot();
end

function WanRenHistoryPopController:removeSlot()
	WanRenHistoryPopLogic.removeSlot();
end

function WanRenHistoryPopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(WanRenHistoryPopLogic.view,"wanren_history_close"), WanRenHistoryPopLogic.callback_wanren_history_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function WanRenHistoryPopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(WanRenHistoryPopLogic.view,"wanren_history_close"), WanRenHistoryPopLogic.callback_wanren_history_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function WanRenHistoryPopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function WanRenHistoryPopController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function WanRenHistoryPopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(WanRenHistoryPopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(WanRenHistoryPopLogic);
		WanRenHistoryPopLogic.releaseData();
	end

	WanRenHistoryPopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function WanRenHistoryPopController:sleepModule()
	framework.releaseOnKeypadEventListener(WanRenHistoryPopLogic.view);
	WanRenHistoryPopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function WanRenHistoryPopController:wakeModule()
	framework.setOnKeypadEventListener(WanRenHistoryPopLogic.view, WanRenHistoryPopLogic.onKeypad);
	WanRenHistoryPopLogic.view:setTouchEnabled(true);
end
