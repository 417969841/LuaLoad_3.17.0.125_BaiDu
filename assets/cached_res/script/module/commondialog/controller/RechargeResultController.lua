module(...,package.seeall);

Load.LuaRequire("script.module.commondialog.logic.RechargeResultLogic");

RechargeResultController = class("RechargeResultController",BaseController);
RechargeResultController.__index = RechargeResultController;

RechargeResultController.moduleLayer = nil;

function RechargeResultController:reset()
	RechargeResultLogic.view = nil;
end

function RechargeResultController:getLayer()
	return RechargeResultLogic.view;
end

function RechargeResultController:createView()
	RechargeResultLogic.createView();
	framework.setOnKeypadEventListener(RechargeResultLogic.view, RechargeResultLogic.onKeypad);
end

function RechargeResultController:requestMsg()
	RechargeResultLogic.requestMsg();
end

function RechargeResultController:addSlot()
	RechargeResultLogic.addSlot();
end

function RechargeResultController:removeSlot()
	RechargeResultLogic.removeSlot();
end

function RechargeResultController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RechargeResultLogic.view,"Button_close"), RechargeResultLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RechargeResultLogic.view,"Button_ok"), RechargeResultLogic.callback_Button_ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RechargeResultController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RechargeResultLogic.view,"Button_close"), RechargeResultLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeResultLogic.view,"Button_ok"), RechargeResultLogic.callback_Button_ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RechargeResultController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function RechargeResultController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function RechargeResultController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RechargeResultLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RechargeResultLogic);
		RechargeResultLogic.releaseData();
	end

	RechargeResultLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function RechargeResultController:sleepModule()
	framework.releaseOnKeypadEventListener(RechargeResultLogic.view);
	RechargeResultLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function RechargeResultController:wakeModule()
	framework.setOnKeypadEventListener(RechargeResultLogic.view, RechargeResultLogic.onKeypad);
	RechargeResultLogic.view:setTouchEnabled(true);
end
