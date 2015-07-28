module(...,package.seeall);

Load.LuaRequire("script.loadModule.trickyparty.logic.TrickyPartyGuideLogic");

TrickyPartyGuideController = class("TrickyPartyGuideController",BaseController);
TrickyPartyGuideController.__index = TrickyPartyGuideController;

TrickyPartyGuideController.moduleLayer = nil;

function TrickyPartyGuideController:reset()
	TrickyPartyGuideLogic.view = nil;
end

function TrickyPartyGuideController:getLayer()
	return TrickyPartyGuideLogic.view;
end

function TrickyPartyGuideController:createView()
	TrickyPartyGuideLogic.createView();
	framework.setOnKeypadEventListener(TrickyPartyGuideLogic.view, TrickyPartyGuideLogic.onKeypad);
end

function TrickyPartyGuideController:requestMsg()
	TrickyPartyGuideLogic.requestMsg();
end

function TrickyPartyGuideController:addSlot()
	TrickyPartyGuideLogic.addSlot();
end

function TrickyPartyGuideController:removeSlot()
	TrickyPartyGuideLogic.removeSlot();
end

function TrickyPartyGuideController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyGuideLogic.view,"BackButton"), TrickyPartyGuideLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TrickyPartyGuideController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyGuideLogic.view,"BackButton"), TrickyPartyGuideLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TrickyPartyGuideController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function TrickyPartyGuideController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function TrickyPartyGuideController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TrickyPartyGuideLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TrickyPartyGuideLogic);
		TrickyPartyGuideLogic.releaseData();
	end

	TrickyPartyGuideLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function TrickyPartyGuideController:sleepModule()
	framework.releaseOnKeypadEventListener(TrickyPartyGuideLogic.view);
	TrickyPartyGuideLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function TrickyPartyGuideController:wakeModule()
	framework.setOnKeypadEventListener(TrickyPartyGuideLogic.view, TrickyPartyGuideLogic.onKeypad);
	TrickyPartyGuideLogic.view:setTouchEnabled(true);
end
