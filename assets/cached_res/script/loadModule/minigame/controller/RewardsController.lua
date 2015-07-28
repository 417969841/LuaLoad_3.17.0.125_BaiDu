module(...,package.seeall);

Load.LuaRequire("script.loadModule.minigame.logic.RewardsLogic");

RewardsController = class("RewardsController",BaseController);
RewardsController.__index = RewardsController;

RewardsController.moduleLayer = nil;

function RewardsController:reset()
	RewardsLogic.view = nil;
end

function RewardsController:getLayer()
	return RewardsLogic.view;
end

function RewardsController:createView()
	RewardsLogic.createView();
	framework.setOnKeypadEventListener(RewardsLogic.view, RewardsLogic.onKeypad);
end

function RewardsController:requestMsg()
	RewardsLogic.requestMsg();
end

function RewardsController:addSlot()
	RewardsLogic.addSlot();
end

function RewardsController:removeSlot()
	RewardsLogic.removeSlot();
end

function RewardsController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RewardsLogic.view,"btn_left"), RewardsLogic.callback_btn_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RewardsLogic.view,"btn_right"), RewardsLogic.callback_btn_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RewardsLogic.view,"btn_cancel"), RewardsLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RewardsController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RewardsLogic.view,"btn_left"), RewardsLogic.callback_btn_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RewardsLogic.view,"btn_right"), RewardsLogic.callback_btn_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RewardsLogic.view,"btn_cancel"), RewardsLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RewardsController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function RewardsController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function RewardsController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RewardsLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RewardsLogic);
		RewardsLogic.releaseData();
	end

	RewardsLogic.view:removeFromParentAndCleanup(true);
	self:reset();
	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function RewardsController:sleepModule()
	framework.releaseOnKeypadEventListener(RewardsLogic.view);
	RewardsLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function RewardsController:wakeModule()
	framework.setOnKeypadEventListener(RewardsLogic.view, RewardsLogic.onKeypad);
	RewardsLogic.view:setTouchEnabled(true);
end
