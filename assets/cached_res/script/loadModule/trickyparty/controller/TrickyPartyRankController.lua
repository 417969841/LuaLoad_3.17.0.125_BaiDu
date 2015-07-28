module(...,package.seeall);

Load.LuaRequire("script.loadModule.trickyparty.logic.TrickyPartyRankLogic");

TrickyPartyRankController = class("TrickyPartyRankController",BaseController);
TrickyPartyRankController.__index = TrickyPartyRankController;

TrickyPartyRankController.moduleLayer = nil;

function TrickyPartyRankController:reset()
	TrickyPartyRankLogic.view = nil;
end

function TrickyPartyRankController:getLayer()
	return TrickyPartyRankLogic.view;
end

function TrickyPartyRankController:createView()
	TrickyPartyRankLogic.createView();
	framework.setOnKeypadEventListener(TrickyPartyRankLogic.view, TrickyPartyRankLogic.onKeypad);
end

function TrickyPartyRankController:requestMsg()
	TrickyPartyRankLogic.requestMsg();
end

function TrickyPartyRankController:addSlot()
	TrickyPartyRankLogic.addSlot();
end

function TrickyPartyRankController:removeSlot()
	TrickyPartyRankLogic.removeSlot();
end

function TrickyPartyRankController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyRankLogic.view,"Panel_14"), TrickyPartyRankLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyRankLogic.view,"Button_Close"), TrickyPartyRankLogic.callback_Button_Close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TrickyPartyRankController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyRankLogic.view,"Panel_14"), TrickyPartyRankLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyRankLogic.view,"Button_Close"), TrickyPartyRankLogic.callback_Button_Close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TrickyPartyRankController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function TrickyPartyRankController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function TrickyPartyRankController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TrickyPartyRankLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TrickyPartyRankLogic);
		TrickyPartyRankLogic.releaseData();
	end

	TrickyPartyRankLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function TrickyPartyRankController:sleepModule()
	framework.releaseOnKeypadEventListener(TrickyPartyRankLogic.view);
	TrickyPartyRankLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function TrickyPartyRankController:wakeModule()
	framework.setOnKeypadEventListener(TrickyPartyRankLogic.view, TrickyPartyRankLogic.onKeypad);
	TrickyPartyRankLogic.view:setTouchEnabled(true);
end
