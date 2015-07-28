module(...,package.seeall);

Load.LuaRequire("script.module.recharge.logic.InputPrepaidCardLogic");

InputPrepaidCardController = class("InputPrepaidCardController",BaseController);
InputPrepaidCardController.__index = InputPrepaidCardController;

InputPrepaidCardController.moduleLayer = nil;

function InputPrepaidCardController:reset()
	InputPrepaidCardLogic.view = nil;
end

function InputPrepaidCardController:getLayer()
	return InputPrepaidCardLogic.view;
end

function InputPrepaidCardController:createView()
	InputPrepaidCardLogic.createView();
	framework.setOnKeypadEventListener(InputPrepaidCardLogic.view, InputPrepaidCardLogic.onKeypad);
end

function InputPrepaidCardController:requestMsg()
	InputPrepaidCardLogic.requestMsg();
end

function InputPrepaidCardController:addSlot()
	InputPrepaidCardLogic.addSlot();
end

function InputPrepaidCardController:removeSlot()
	InputPrepaidCardLogic.removeSlot();
end

function InputPrepaidCardController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"Button_Ok"), InputPrepaidCardLogic.callback_Button_Ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"Button_Close"), InputPrepaidCardLogic.callback_Button_Close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"tf_card_number"),InputPrepaidCardLogic.callback_tf_card_number_ios,BUTTON_CLICK)
		framework.bindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"tf_password"),InputPrepaidCardLogic.callback_tf_password_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"tf_card_number"),InputPrepaidCardLogic.callback_tf_card_number,DETACH_WITH_IME)
		framework.bindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"tf_password"),InputPrepaidCardLogic.callback_tf_password,DETACH_WITH_IME)
	end
end

function InputPrepaidCardController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"Button_Ok"), InputPrepaidCardLogic.callback_Button_Ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"Button_Close"), InputPrepaidCardLogic.callback_Button_Close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"tf_card_number"),InputPrepaidCardLogic.callback_tf_card_number_ios,BUTTON_CLICK)
		framework.unbindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"tf_password"),InputPrepaidCardLogic.callback_tf_password_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"tf_card_number"),InputPrepaidCardLogic.callback_tf_card_number,DETACH_WITH_IME)
		framework.unbindEventCallback(cocostudio.getComponent(InputPrepaidCardLogic.view,"tf_password"),InputPrepaidCardLogic.callback_tf_password,DETACH_WITH_IME)
	end
end

function InputPrepaidCardController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function InputPrepaidCardController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function InputPrepaidCardController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(InputPrepaidCardLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(InputPrepaidCardLogic);
		InputPrepaidCardLogic.releaseData();
	end

	InputPrepaidCardLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function InputPrepaidCardController:sleepModule()
	framework.releaseOnKeypadEventListener(InputPrepaidCardLogic.view);
	InputPrepaidCardLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function InputPrepaidCardController:wakeModule()
	framework.setOnKeypadEventListener(InputPrepaidCardLogic.view, InputPrepaidCardLogic.onKeypad);
	InputPrepaidCardLogic.view:setTouchEnabled(true);
end
