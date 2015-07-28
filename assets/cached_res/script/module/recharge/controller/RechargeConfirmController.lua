module(...,package.seeall);

Load.LuaRequire("script.module.recharge.logic.RechargeConfirmLogic");

RechargeConfirmController = class("RechargeConfirmController",BaseController);
RechargeConfirmController.__index = RechargeConfirmController;

RechargeConfirmController.moduleLayer = nil;

function RechargeConfirmController:reset()
	RechargeConfirmLogic.view = nil;
end

function RechargeConfirmController:getLayer()
	return RechargeConfirmLogic.view;
end

function RechargeConfirmController:createView()
	RechargeConfirmLogic.createView();
	framework.setOnKeypadEventListener(RechargeConfirmLogic.view, RechargeConfirmLogic.onKeypad);
end

function RechargeConfirmController:requestMsg()
	RechargeConfirmLogic.requestMsg();
end

function RechargeConfirmController:addSlot()
	RechargeConfirmLogic.addSlot();
end

function RechargeConfirmController:removeSlot()
	RechargeConfirmLogic.removeSlot();
end

function RechargeConfirmController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RechargeConfirmLogic.view,"btn_ok"), RechargeConfirmLogic.callback_btn_ok, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(RechargeConfirmLogic.view,"btn_close"), RechargeConfirmLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function RechargeConfirmController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RechargeConfirmLogic.view,"btn_ok"), RechargeConfirmLogic.callback_btn_ok, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeConfirmLogic.view,"btn_close"), RechargeConfirmLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function RechargeConfirmController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function RechargeConfirmController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function RechargeConfirmController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RechargeConfirmLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RechargeConfirmLogic);
		RechargeConfirmLogic.releaseData();
	end

	RechargeConfirmLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function RechargeConfirmController:sleepModule()
	framework.releaseOnKeypadEventListener(RechargeConfirmLogic.view);
	RechargeConfirmLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function RechargeConfirmController:wakeModule()
	framework.setOnKeypadEventListener(RechargeConfirmLogic.view, RechargeConfirmLogic.onKeypad);
	RechargeConfirmLogic.view:setTouchEnabled(true);
end
