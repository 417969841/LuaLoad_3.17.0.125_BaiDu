module(...,package.seeall);

Load.LuaRequire("script.loadModule.wanrenjinhuapop.logic.WanRenResultPopLogic");

WanRenResultPopController = class("WanRenResultPopController",BaseController);
WanRenResultPopController.__index = WanRenResultPopController;

WanRenResultPopController.moduleLayer = nil;

function WanRenResultPopController:reset()
	WanRenResultPopLogic.view = nil;
end

function WanRenResultPopController:getLayer()
	return WanRenResultPopLogic.view;
end

function WanRenResultPopController:createView()
	WanRenResultPopLogic.createView();
	framework.setOnKeypadEventListener(WanRenResultPopLogic.view, WanRenResultPopLogic.onKeypad);
end

function WanRenResultPopController:requestMsg()
	WanRenResultPopLogic.requestMsg();
end

function WanRenResultPopController:addSlot()
	WanRenResultPopLogic.addSlot();
end

function WanRenResultPopController:removeSlot()
	WanRenResultPopLogic.removeSlot();
end

function WanRenResultPopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(WanRenResultPopLogic.view,"wanrenjinhua_result_bg_panel"), WanRenResultPopLogic.callback_wanrenjinhua_result_bg_panel, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenResultPopLogic.view,"wanrenjinhua_result_bg_image"), WanRenResultPopLogic.callback_wanrenjinhua_result_bg_image, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function WanRenResultPopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(WanRenResultPopLogic.view,"wanrenjinhua_result_bg_panel"), WanRenResultPopLogic.callback_wanrenjinhua_result_bg_panel, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenResultPopLogic.view,"wanrenjinhua_result_bg_image"), WanRenResultPopLogic.callback_wanrenjinhua_result_bg_image, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function WanRenResultPopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function WanRenResultPopController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function WanRenResultPopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(WanRenResultPopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(WanRenResultPopLogic);
		WanRenResultPopLogic.releaseData();
	end

	WanRenResultPopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function WanRenResultPopController:sleepModule()
	framework.releaseOnKeypadEventListener(WanRenResultPopLogic.view);
	WanRenResultPopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function WanRenResultPopController:wakeModule()
	framework.setOnKeypadEventListener(WanRenResultPopLogic.view, WanRenResultPopLogic.onKeypad);
	WanRenResultPopLogic.view:setTouchEnabled(true);
end
