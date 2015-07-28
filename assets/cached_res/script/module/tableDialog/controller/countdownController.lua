module(...,package.seeall);

Load.LuaRequire("script.module.tableDialog.logic.countdownLogic");

countdownController = class("countdownController",BaseController);
countdownController.__index = countdownController;

countdownController.moduleLayer = nil;

function countdownController:reset()
	countdownLogic.view = nil;
end

function countdownController:getLayer()
	return countdownLogic.view;
end

function countdownController:createView()
	countdownLogic.createView();
	framework.setOnKeypadEventListener(countdownLogic.view, countdownLogic.onKeypad);
end

function countdownController:requestMsg()
	countdownLogic.requestMsg();
end

function countdownController:addSlot()
	countdownLogic.addSlot();
end

function countdownController:removeSlot()
	countdownLogic.removeSlot();
end

function countdownController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(countdownLogic.view,"Panelcountdown"), countdownLogic.callback_Panelcountdown, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function countdownController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(countdownLogic.view,"Panelcountdown"), countdownLogic.callback_Panelcountdown, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function countdownController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function countdownController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function countdownController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(countdownLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(countdownLogic);
		countdownLogic.releaseData();
	end

	countdownLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function countdownController:sleepModule()
	framework.releaseOnKeypadEventListener(countdownLogic.view);
	countdownLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function countdownController:wakeModule()
	framework.setOnKeypadEventListener(countdownLogic.view, countdownLogic.onKeypad);
	countdownLogic.view:setTouchEnabled(true);
end
