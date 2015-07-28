module(...,package.seeall);

Load.LuaRequire("script.module.exchange.logic.CardDuihuanWaysLogic");

CardDuihuanWaysController = class("CardDuihuanWaysController",BaseController);
CardDuihuanWaysController.__index = CardDuihuanWaysController;

CardDuihuanWaysController.moduleLayer = nil;

function CardDuihuanWaysController:reset()
	CardDuihuanWaysLogic.view = nil;
end

function CardDuihuanWaysController:getLayer()
	return CardDuihuanWaysLogic.view;
end

function CardDuihuanWaysController:createView()
	CardDuihuanWaysLogic.createView();
	framework.setOnKeypadEventListener(CardDuihuanWaysLogic.view, CardDuihuanWaysLogic.onKeypad);
end

function CardDuihuanWaysController:requestMsg()
	CardDuihuanWaysLogic.requestMsg();
end

function CardDuihuanWaysController:addSlot()
	CardDuihuanWaysLogic.addSlot();
end

function CardDuihuanWaysController:removeSlot()
	CardDuihuanWaysLogic.removeSlot();
end

function CardDuihuanWaysController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CardDuihuanWaysLogic.view,"btn_close"), CardDuihuanWaysLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CardDuihuanWaysLogic.view,"Button_ok"), CardDuihuanWaysLogic.callback_Button_ok, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CardDuihuanWaysController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CardDuihuanWaysLogic.view,"btn_close"), CardDuihuanWaysLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CardDuihuanWaysLogic.view,"Button_ok"), CardDuihuanWaysLogic.callback_Button_ok, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CardDuihuanWaysController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function CardDuihuanWaysController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function CardDuihuanWaysController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CardDuihuanWaysLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(CardDuihuanWaysLogic);
		CardDuihuanWaysLogic.releaseData();
	end

	CardDuihuanWaysLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function CardDuihuanWaysController:sleepModule()
	framework.releaseOnKeypadEventListener(CardDuihuanWaysLogic.view);
	CardDuihuanWaysLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function CardDuihuanWaysController:wakeModule()
	framework.setOnKeypadEventListener(CardDuihuanWaysLogic.view, CardDuihuanWaysLogic.onKeypad);
	CardDuihuanWaysLogic.view:setTouchEnabled(true);
end
