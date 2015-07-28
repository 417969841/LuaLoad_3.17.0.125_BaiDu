module(...,package.seeall);

Load.LuaRequire("script.module.tableDialog.logic.TreasureChestsLogic");

TreasureChestsController = class("TreasureChestsController",BaseController);
TreasureChestsController.__index = TreasureChestsController;

TreasureChestsController.moduleLayer = nil;

function TreasureChestsController:reset()
	TreasureChestsLogic.view = nil;
end

function TreasureChestsController:getLayer()
	return TreasureChestsLogic.view;
end

function TreasureChestsController:createView()
	TreasureChestsLogic.createView();
	framework.setOnKeypadEventListener(TreasureChestsLogic.view, TreasureChestsLogic.onKeypad);
end

function TreasureChestsController:requestMsg()
	TreasureChestsLogic.requestMsg();
end

function TreasureChestsController:addSlot()
	TreasureChestsLogic.addSlot();
end

function TreasureChestsController:removeSlot()
	TreasureChestsLogic.removeSlot();
end

function TreasureChestsController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TreasureChestsLogic.view,"Panel_20"), TreasureChestsLogic.callback_Panel_20, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TreasureChestsLogic.view,"box3"), TreasureChestsLogic.callback_box3, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TreasureChestsLogic.view,"box1"), TreasureChestsLogic.callback_box1, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TreasureChestsLogic.view,"box2"), TreasureChestsLogic.callback_box2, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
end

function TreasureChestsController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TreasureChestsLogic.view,"Panel_20"), TreasureChestsLogic.callback_Panel_20, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TreasureChestsLogic.view,"box3"), TreasureChestsLogic.callback_box3, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TreasureChestsLogic.view,"box1"), TreasureChestsLogic.callback_box1, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TreasureChestsLogic.view,"box2"), TreasureChestsLogic.callback_box2, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
end

function TreasureChestsController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function TreasureChestsController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function TreasureChestsController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TreasureChestsLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TreasureChestsLogic);
		TreasureChestsLogic.releaseData();
	end

	TreasureChestsLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function TreasureChestsController:sleepModule()
	framework.releaseOnKeypadEventListener(TreasureChestsLogic.view);
	TreasureChestsLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function TreasureChestsController:wakeModule()
	framework.setOnKeypadEventListener(TreasureChestsLogic.view, TreasureChestsLogic.onKeypad);
	TreasureChestsLogic.view:setTouchEnabled(true);
end
