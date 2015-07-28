module(...,package.seeall);

Load.LuaRequire("script.module.monthSign.logic.ShowMonthSignPrizeLogic");

ShowMonthSignPrizeController = class("ShowMonthSignPrizeController",BaseController);
ShowMonthSignPrizeController.__index = ShowMonthSignPrizeController;

ShowMonthSignPrizeController.moduleLayer = nil;

function ShowMonthSignPrizeController:reset()
	ShowMonthSignPrizeLogic.view = nil;
end

function ShowMonthSignPrizeController:getLayer()
	return ShowMonthSignPrizeLogic.view;
end

function ShowMonthSignPrizeController:createView()
	ShowMonthSignPrizeLogic.createView();
	framework.setOnKeypadEventListener(ShowMonthSignPrizeLogic.view, ShowMonthSignPrizeLogic.onKeypad);
end

function ShowMonthSignPrizeController:requestMsg()
	ShowMonthSignPrizeLogic.requestMsg();
end

function ShowMonthSignPrizeController:addSlot()
	ShowMonthSignPrizeLogic.addSlot();
end

function ShowMonthSignPrizeController:removeSlot()
	ShowMonthSignPrizeLogic.removeSlot();
end

function ShowMonthSignPrizeController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ShowMonthSignPrizeLogic.view,"Panel_ShowPrize"), ShowMonthSignPrizeLogic.callback_Panel_ShowPrize, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function ShowMonthSignPrizeController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ShowMonthSignPrizeLogic.view,"Panel_ShowPrize"), ShowMonthSignPrizeLogic.callback_Panel_ShowPrize, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function ShowMonthSignPrizeController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function ShowMonthSignPrizeController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function ShowMonthSignPrizeController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ShowMonthSignPrizeLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(ShowMonthSignPrizeLogic);
		ShowMonthSignPrizeLogic.releaseData();
	end

	ShowMonthSignPrizeLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function ShowMonthSignPrizeController:sleepModule()
	framework.releaseOnKeypadEventListener(ShowMonthSignPrizeLogic.view);
	ShowMonthSignPrizeLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function ShowMonthSignPrizeController:wakeModule()
	framework.setOnKeypadEventListener(ShowMonthSignPrizeLogic.view, ShowMonthSignPrizeLogic.onKeypad);
	ShowMonthSignPrizeLogic.view:setTouchEnabled(true);
end
