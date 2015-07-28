module(...,package.seeall);

Load.LuaRequire("script.loadModule.wanrenjinhuapop.logic.WanRenCardTypePopLogic");

WanRenCardTypePopController = class("WanRenCardTypePopController",BaseController);
WanRenCardTypePopController.__index = WanRenCardTypePopController;

WanRenCardTypePopController.moduleLayer = nil;

function WanRenCardTypePopController:reset()
	WanRenCardTypePopLogic.view = nil;
end

function WanRenCardTypePopController:getLayer()
	return WanRenCardTypePopLogic.view;
end

function WanRenCardTypePopController:createView()
	WanRenCardTypePopLogic.createView();
	framework.setOnKeypadEventListener(WanRenCardTypePopLogic.view, WanRenCardTypePopLogic.onKeypad);
end

function WanRenCardTypePopController:requestMsg()
	WanRenCardTypePopLogic.requestMsg();
end

function WanRenCardTypePopController:addSlot()
	WanRenCardTypePopLogic.addSlot();
end

function WanRenCardTypePopController:removeSlot()
	WanRenCardTypePopLogic.removeSlot();
end

function WanRenCardTypePopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(WanRenCardTypePopLogic.view,"wanren_card_type_bg_image"), WanRenCardTypePopLogic.callback_wanren_card_type_bg_image, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenCardTypePopLogic.view,"wanren_card_type_close"), WanRenCardTypePopLogic.callback_wanren_card_type_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function WanRenCardTypePopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(WanRenCardTypePopLogic.view,"wanren_card_type_bg_image"), WanRenCardTypePopLogic.callback_wanren_card_type_bg_image, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenCardTypePopLogic.view,"wanren_card_type_close"), WanRenCardTypePopLogic.callback_wanren_card_type_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function WanRenCardTypePopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function WanRenCardTypePopController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function WanRenCardTypePopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(WanRenCardTypePopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(WanRenCardTypePopLogic);
		WanRenCardTypePopLogic.releaseData();
	end

	WanRenCardTypePopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function WanRenCardTypePopController:sleepModule()
	framework.releaseOnKeypadEventListener(WanRenCardTypePopLogic.view);
	WanRenCardTypePopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function WanRenCardTypePopController:wakeModule()
	framework.setOnKeypadEventListener(WanRenCardTypePopLogic.view, WanRenCardTypePopLogic.onKeypad);
	WanRenCardTypePopLogic.view:setTouchEnabled(true);
end
