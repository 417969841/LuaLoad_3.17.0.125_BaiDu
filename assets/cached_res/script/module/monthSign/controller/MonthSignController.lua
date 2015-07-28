module(...,package.seeall);

Load.LuaRequire("script.module.monthSign.logic.MonthSignLogic");

MonthSignController = class("MonthSignController",BaseController);
MonthSignController.__index = MonthSignController;

MonthSignController.moduleLayer = nil;

function MonthSignController:reset()
	MonthSignLogic.view = nil;
end

function MonthSignController:getLayer()
	return MonthSignLogic.view;
end

function MonthSignController:createView()
	MonthSignLogic.createView();
	framework.setOnKeypadEventListener(MonthSignLogic.view, MonthSignLogic.onKeypad);
end

function MonthSignController:requestMsg()
	MonthSignLogic.requestMsg();
end

function MonthSignController:addSlot()
	MonthSignLogic.addSlot();
end

function MonthSignController:removeSlot()
	MonthSignLogic.removeSlot();
end

function MonthSignController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day25"), MonthSignLogic.callback_ImageView_Day25, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day24"), MonthSignLogic.callback_ImageView_Day24, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day23"), MonthSignLogic.callback_ImageView_Day23, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day22"), MonthSignLogic.callback_ImageView_Day22, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day21"), MonthSignLogic.callback_ImageView_Day21, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day20"), MonthSignLogic.callback_ImageView_Day20, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day19"), MonthSignLogic.callback_ImageView_Day19, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day18"), MonthSignLogic.callback_ImageView_Day18, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day17"), MonthSignLogic.callback_ImageView_Day17, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day16"), MonthSignLogic.callback_ImageView_Day16, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day15"), MonthSignLogic.callback_ImageView_Day15, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day14"), MonthSignLogic.callback_ImageView_Day14, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day13"), MonthSignLogic.callback_ImageView_Day13, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day12"), MonthSignLogic.callback_ImageView_Day12, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day11"), MonthSignLogic.callback_ImageView_Day11, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day10"), MonthSignLogic.callback_ImageView_Day10, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day9"), MonthSignLogic.callback_ImageView_Day9, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day8"), MonthSignLogic.callback_ImageView_Day8, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day7"), MonthSignLogic.callback_ImageView_Day7, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day6"), MonthSignLogic.callback_ImageView_Day6, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day5"), MonthSignLogic.callback_ImageView_Day5, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day4"), MonthSignLogic.callback_ImageView_Day4, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day3"), MonthSignLogic.callback_ImageView_Day3, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day2"), MonthSignLogic.callback_ImageView_Day2, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day1"), MonthSignLogic.callback_ImageView_Day1, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Return"), MonthSignLogic.callback_ImageView_Return, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Help"), MonthSignLogic.callback_ImageView_Help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function MonthSignController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day25"), MonthSignLogic.callback_ImageView_Day25, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day24"), MonthSignLogic.callback_ImageView_Day24, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day23"), MonthSignLogic.callback_ImageView_Day23, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day22"), MonthSignLogic.callback_ImageView_Day22, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day21"), MonthSignLogic.callback_ImageView_Day21, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day20"), MonthSignLogic.callback_ImageView_Day20, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day19"), MonthSignLogic.callback_ImageView_Day19, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day18"), MonthSignLogic.callback_ImageView_Day18, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day17"), MonthSignLogic.callback_ImageView_Day17, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day16"), MonthSignLogic.callback_ImageView_Day16, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day15"), MonthSignLogic.callback_ImageView_Day15, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day14"), MonthSignLogic.callback_ImageView_Day14, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day13"), MonthSignLogic.callback_ImageView_Day13, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day12"), MonthSignLogic.callback_ImageView_Day12, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day11"), MonthSignLogic.callback_ImageView_Day11, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day10"), MonthSignLogic.callback_ImageView_Day10, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day9"), MonthSignLogic.callback_ImageView_Day9, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day8"), MonthSignLogic.callback_ImageView_Day8, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day7"), MonthSignLogic.callback_ImageView_Day7, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day6"), MonthSignLogic.callback_ImageView_Day6, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day5"), MonthSignLogic.callback_ImageView_Day5, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day4"), MonthSignLogic.callback_ImageView_Day4, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day3"), MonthSignLogic.callback_ImageView_Day3, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day2"), MonthSignLogic.callback_ImageView_Day2, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Day1"), MonthSignLogic.callback_ImageView_Day1, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Return"), MonthSignLogic.callback_ImageView_Return, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MonthSignLogic.view,"ImageView_Help"), MonthSignLogic.callback_ImageView_Help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function MonthSignController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MonthSignController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MonthSignController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MonthSignLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MonthSignLogic);
		MonthSignLogic.releaseData();
	end

	MonthSignLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MonthSignController:sleepModule()
	framework.releaseOnKeypadEventListener(MonthSignLogic.view);
	MonthSignLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MonthSignController:wakeModule()
	framework.setOnKeypadEventListener(MonthSignLogic.view, MonthSignLogic.onKeypad);
	MonthSignLogic.view:setTouchEnabled(true);
end
