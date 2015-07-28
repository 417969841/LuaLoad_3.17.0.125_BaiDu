module(...,package.seeall);

Load.LuaRequire("script.loadModule.minigame.logic.JinHuangGuanLogic");

JinHuangGuanController = class("JinHuangGuanController",BaseController);
JinHuangGuanController.__index = JinHuangGuanController;

JinHuangGuanController.moduleLayer = nil;

function JinHuangGuanController:reset()
	JinHuangGuanLogic.view = nil;
end

function JinHuangGuanController:getLayer()
	return JinHuangGuanLogic.view;
end

function JinHuangGuanController:createView()
	JinHuangGuanLogic.createView();
	framework.setOnKeypadEventListener(JinHuangGuanLogic.view, JinHuangGuanLogic.onKeypad);
end

function JinHuangGuanController:requestMsg()
	JinHuangGuanLogic.requestMsg();
end

function JinHuangGuanController:addSlot()
	JinHuangGuanLogic.addSlot();
end

function JinHuangGuanController:removeSlot()
	JinHuangGuanLogic.removeSlot();
end

function JinHuangGuanController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_back"), JinHuangGuanLogic.callback_Button_back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_talk"), JinHuangGuanLogic.callback_Button_talk, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_gift"), JinHuangGuanLogic.callback_Button_gift, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_fruit_recharge"), JinHuangGuanLogic.callback_Button_fruit_recharge, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_raise"), JinHuangGuanLogic.callback_Button_raise, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_stop"), JinHuangGuanLogic.callback_Button_stop, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_fruit_rechargebibei"), JinHuangGuanLogic.callback_Button_fruit_rechargebibei, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_big"), JinHuangGuanLogic.callback_Button_big, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_small"), JinHuangGuanLogic.callback_Button_small, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_double"), JinHuangGuanLogic.callback_Button_double, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_collect"), JinHuangGuanLogic.callback_Button_collect, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"chatTextFeild"),JinHuangGuanLogic.callback_ChatTextFeild_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"chatTextFeild"),JinHuangGuanLogic.callback_ChatTextFeild,DETACH_WITH_IME)
	end
end

function JinHuangGuanController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_back"), JinHuangGuanLogic.callback_Button_back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_talk"), JinHuangGuanLogic.callback_Button_talk, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_gift"), JinHuangGuanLogic.callback_Button_gift, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_fruit_recharge"), JinHuangGuanLogic.callback_Button_fruit_recharge, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_raise"), JinHuangGuanLogic.callback_Button_raise, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_stop"), JinHuangGuanLogic.callback_Button_stop, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_fruit_rechargebibei"), JinHuangGuanLogic.callback_Button_fruit_rechargebibei, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_big"), JinHuangGuanLogic.callback_Button_big, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_small"), JinHuangGuanLogic.callback_Button_small, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_double"), JinHuangGuanLogic.callback_Button_double, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"Button_collect"), JinHuangGuanLogic.callback_Button_collect, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"chatTextFeild"),JinHuangGuanLogic.callback_ChatTextFeild_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(JinHuangGuanLogic.view,"chatTextFeild"),JinHuangGuanLogic.callback_ChatTextFeild,DETACH_WITH_IME)
	end
end

function JinHuangGuanController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function JinHuangGuanController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function JinHuangGuanController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuangGuanLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuangGuanLogic);
		JinHuangGuanLogic.releaseData();
	end

	JinHuangGuanLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuangGuanController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuangGuanLogic.view);
	JinHuangGuanLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuangGuanController:wakeModule()
	framework.setOnKeypadEventListener(JinHuangGuanLogic.view, JinHuangGuanLogic.onKeypad);
	JinHuangGuanLogic.view:setTouchEnabled(true);
end
