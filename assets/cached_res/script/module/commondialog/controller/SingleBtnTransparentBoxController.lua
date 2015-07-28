module(...,package.seeall);

Load.LuaRequire("script.module.commondialog.logic.SingleBtnTransparentBoxLogic");

SingleBtnTransparentBoxController = class("SingleBtnTransparentBoxController",BaseController);
SingleBtnTransparentBoxController.__index = SingleBtnTransparentBoxController;

SingleBtnTransparentBoxController.moduleLayer = nil;

function SingleBtnTransparentBoxController:reset()
	SingleBtnTransparentBoxLogic.view = nil;
end

function SingleBtnTransparentBoxController:getLayer()
	return SingleBtnTransparentBoxLogic.view;
end

function SingleBtnTransparentBoxController:createView()
	SingleBtnTransparentBoxLogic.createView();
	framework.setOnKeypadEventListener(SingleBtnTransparentBoxLogic.view, SingleBtnTransparentBoxLogic.onKeypad);
end

function SingleBtnTransparentBoxController:requestMsg()
	SingleBtnTransparentBoxLogic.requestMsg();
end

function SingleBtnTransparentBoxController:addSlot()
	SingleBtnTransparentBoxLogic.addSlot();
end

function SingleBtnTransparentBoxController:removeSlot()
	SingleBtnTransparentBoxLogic.removeSlot();
end

function SingleBtnTransparentBoxController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(SingleBtnTransparentBoxLogic.view,"Panel_Box"), SingleBtnTransparentBoxLogic.callback_Panel_Box, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(SingleBtnTransparentBoxLogic.view,"Button_close"), SingleBtnTransparentBoxLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(SingleBtnTransparentBoxLogic.view,"Button_Confirm"), SingleBtnTransparentBoxLogic.callback_Button_Confirm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SingleBtnTransparentBoxController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(SingleBtnTransparentBoxLogic.view,"Panel_Box"), SingleBtnTransparentBoxLogic.callback_Panel_Box, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(SingleBtnTransparentBoxLogic.view,"Button_close"), SingleBtnTransparentBoxLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(SingleBtnTransparentBoxLogic.view,"Button_Confirm"), SingleBtnTransparentBoxLogic.callback_Button_Confirm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SingleBtnTransparentBoxController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function SingleBtnTransparentBoxController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function SingleBtnTransparentBoxController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SingleBtnTransparentBoxLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(SingleBtnTransparentBoxLogic);
		SingleBtnTransparentBoxLogic.releaseData();
	end

	SingleBtnTransparentBoxLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function SingleBtnTransparentBoxController:sleepModule()
	framework.releaseOnKeypadEventListener(SingleBtnTransparentBoxLogic.view);
	SingleBtnTransparentBoxLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function SingleBtnTransparentBoxController:wakeModule()
	framework.setOnKeypadEventListener(SingleBtnTransparentBoxLogic.view, SingleBtnTransparentBoxLogic.onKeypad);
	SingleBtnTransparentBoxLogic.view:setTouchEnabled(true);
end
