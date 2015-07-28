module(...,package.seeall);

Load.LuaRequire("script.loadModule.minigame.logic.FruitMachineLogic");

FruitMachineController = class("FruitMachineController",BaseController);
FruitMachineController.__index = FruitMachineController;

FruitMachineController.moduleLayer = nil;

function FruitMachineController:reset()
	FruitMachineLogic.view = nil;
end

function FruitMachineController:getLayer()
	return FruitMachineLogic.view;
end

function FruitMachineController:createView()
	FruitMachineLogic.createView();
	framework.setOnKeypadEventListener(FruitMachineLogic.view, FruitMachineLogic.onKeypad);
end

function FruitMachineController:requestMsg()
	FruitMachineLogic.requestMsg();
end

function FruitMachineController:addSlot()
	FruitMachineLogic.addSlot();
end

function FruitMachineController:removeSlot()
	FruitMachineLogic.removeSlot();
end

function FruitMachineController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_back"), FruitMachineLogic.callback_Button_back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_gift"), FruitMachineLogic.callback_Button_gift, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_fruit_recharge"), FruitMachineLogic.callback_Button_fruit_recharge, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"ImageView_lagan"), FruitMachineLogic.callback_ImageView_lagan, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_raise"), FruitMachineLogic.callback_Button_raise, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_auto"), FruitMachineLogic.callback_Button_auto, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_stop"), FruitMachineLogic.callback_Button_stop, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_start"), FruitMachineLogic.callback_Button_start, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_collect"), FruitMachineLogic.callback_Button_collect, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_big"), FruitMachineLogic.callback_Button_big, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_small"), FruitMachineLogic.callback_Button_small, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_double"), FruitMachineLogic.callback_Button_double, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_beg_recharge"), FruitMachineLogic.callback_Button_beg_recharge, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Panel_vip"), FruitMachineLogic.callback_Panel_vip, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_Vip"), FruitMachineLogic.callback_Button_Vip, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Image_dashang"), FruitMachineLogic.callback_Image_dashang, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"chatTextFeild"),FruitMachineLogic.callback_ChatTextFeild_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"chatTextFeild"),FruitMachineLogic.callback_ChatTextFeild,DETACH_WITH_IME)
	end
end

function FruitMachineController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_back"), FruitMachineLogic.callback_Button_back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_talk"), FruitMachineLogic.callback_Button_talk, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_gift"), FruitMachineLogic.callback_Button_gift, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_fruit_recharge"), FruitMachineLogic.callback_Button_fruit_recharge, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"ImageView_lagan"), FruitMachineLogic.callback_ImageView_lagan, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_raise"), FruitMachineLogic.callback_Button_raise, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_auto"), FruitMachineLogic.callback_Button_auto, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_stop"), FruitMachineLogic.callback_Button_stop, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_start"), FruitMachineLogic.callback_Button_start, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_collect"), FruitMachineLogic.callback_Button_collect, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_big"), FruitMachineLogic.callback_Button_big, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_small"), FruitMachineLogic.callback_Button_small, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_double"), FruitMachineLogic.callback_Button_double, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_beg_recharge"), FruitMachineLogic.callback_Button_beg_recharge, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Panel_vip"), FruitMachineLogic.callback_Panel_vip, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Button_Vip"), FruitMachineLogic.callback_Button_Vip, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"Image_dashang"), FruitMachineLogic.callback_Image_dashang, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"chatTextFeild"),FruitMachineLogic.callback_ChatTextFeild_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(FruitMachineLogic.view,"chatTextFeild"),FruitMachineLogic.callback_ChatTextFeild,DETACH_WITH_IME)
	end
end

function FruitMachineController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function FruitMachineController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function FruitMachineController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(FruitMachineLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(FruitMachineLogic);
		FruitMachineLogic.releaseData();
	end

	FruitMachineLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function FruitMachineController:sleepModule()
	framework.releaseOnKeypadEventListener(FruitMachineLogic.view);
	FruitMachineLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function FruitMachineController:wakeModule()
	framework.setOnKeypadEventListener(FruitMachineLogic.view, FruitMachineLogic.onKeypad);
	FruitMachineLogic.view:setTouchEnabled(true);
end
