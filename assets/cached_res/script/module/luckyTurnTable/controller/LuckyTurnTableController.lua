module(...,package.seeall);

Load.LuaRequire("script.module.luckyTurnTable.logic.LuckyTurnTableLogic");

LuckyTurnTableController = class("LuckyTurnTableController",BaseController);
LuckyTurnTableController.__index = LuckyTurnTableController;

LuckyTurnTableController.moduleLayer = nil;

function LuckyTurnTableController:reset()
	LuckyTurnTableLogic.view = nil;
end

function LuckyTurnTableController:getLayer()
	return LuckyTurnTableLogic.view;
end

function LuckyTurnTableController:createView()
	LuckyTurnTableLogic.createView();
	framework.setOnKeypadEventListener(LuckyTurnTableLogic.view, LuckyTurnTableLogic.onKeypad);
end

function LuckyTurnTableController:requestMsg()
	LuckyTurnTableLogic.requestMsg();
end

function LuckyTurnTableController:addSlot()
	LuckyTurnTableLogic.addSlot();
end

function LuckyTurnTableController:removeSlot()
	LuckyTurnTableLogic.removeSlot();
end

function LuckyTurnTableController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(LuckyTurnTableLogic.view,"Button_Lottery"), LuckyTurnTableLogic.callback_Button_Lottery, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(LuckyTurnTableLogic.view,"ImageView_Return"), LuckyTurnTableLogic.callback_ImageView_Return, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(LuckyTurnTableLogic.view,"ImageView_Help"), LuckyTurnTableLogic.callback_ImageView_Help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function LuckyTurnTableController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(LuckyTurnTableLogic.view,"Button_Lottery"), LuckyTurnTableLogic.callback_Button_Lottery, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(LuckyTurnTableLogic.view,"ImageView_Return"), LuckyTurnTableLogic.callback_ImageView_Return, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(LuckyTurnTableLogic.view,"ImageView_Help"), LuckyTurnTableLogic.callback_ImageView_Help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function LuckyTurnTableController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function LuckyTurnTableController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function LuckyTurnTableController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(LuckyTurnTableLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(LuckyTurnTableLogic);
		LuckyTurnTableLogic.releaseData();
	end

	LuckyTurnTableLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function LuckyTurnTableController:sleepModule()
	framework.releaseOnKeypadEventListener(LuckyTurnTableLogic.view);
	LuckyTurnTableLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function LuckyTurnTableController:wakeModule()
	framework.setOnKeypadEventListener(LuckyTurnTableLogic.view, LuckyTurnTableLogic.onKeypad);
	LuckyTurnTableLogic.view:setTouchEnabled(true);
end
