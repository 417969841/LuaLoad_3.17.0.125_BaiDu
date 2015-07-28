module(...,package.seeall);

Load.LuaRequire("script.module.paihangbang.logic.RechargeRankCoverLogic");

RechargeRankCoverController = class("RechargeRankCoverController",BaseController);
RechargeRankCoverController.__index = RechargeRankCoverController;

RechargeRankCoverController.moduleLayer = nil;

function RechargeRankCoverController:reset()
	RechargeRankCoverLogic.view = nil;
end

function RechargeRankCoverController:getLayer()
	return RechargeRankCoverLogic.view;
end

function RechargeRankCoverController:createView()
	RechargeRankCoverLogic.createView();
	framework.setOnKeypadEventListener(RechargeRankCoverLogic.view, RechargeRankCoverLogic.onKeypad);
end

function RechargeRankCoverController:requestMsg()
	RechargeRankCoverLogic.requestMsg();
end

function RechargeRankCoverController:addSlot()
	RechargeRankCoverLogic.addSlot();
end

function RechargeRankCoverController:removeSlot()
	RechargeRankCoverLogic.removeSlot();
end

function RechargeRankCoverController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RechargeRankCoverLogic.view,"Panel_bgPrompt"), RechargeRankCoverLogic.callback_Panel_bgPrompt, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(RechargeRankCoverLogic.view,"Panel_Button"), RechargeRankCoverLogic.callback_Panel_Button, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function RechargeRankCoverController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RechargeRankCoverLogic.view,"Panel_bgPrompt"), RechargeRankCoverLogic.callback_Panel_bgPrompt, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeRankCoverLogic.view,"Panel_Button"), RechargeRankCoverLogic.callback_Panel_Button, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function RechargeRankCoverController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function RechargeRankCoverController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function RechargeRankCoverController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RechargeRankCoverLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RechargeRankCoverLogic);
		RechargeRankCoverLogic.releaseData();
	end

	RechargeRankCoverLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function RechargeRankCoverController:sleepModule()
	framework.releaseOnKeypadEventListener(RechargeRankCoverLogic.view);
	RechargeRankCoverLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function RechargeRankCoverController:wakeModule()
	framework.setOnKeypadEventListener(RechargeRankCoverLogic.view, RechargeRankCoverLogic.onKeypad);
	RechargeRankCoverLogic.view:setTouchEnabled(true);
end
