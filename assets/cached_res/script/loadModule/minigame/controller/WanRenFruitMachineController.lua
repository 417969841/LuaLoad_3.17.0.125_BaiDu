module(...,package.seeall);

Load.LuaRequire("script.loadModule.minigame.logic.WanRenFruitMachineLogic");

WanRenFruitMachineController = class("WanRenFruitMachineController",BaseController);
WanRenFruitMachineController.__index = WanRenFruitMachineController;

WanRenFruitMachineController.moduleLayer = nil;

function WanRenFruitMachineController:reset()
	WanRenFruitMachineLogic.view = nil;
end

function WanRenFruitMachineController:getLayer()
	return WanRenFruitMachineLogic.view;
end

function WanRenFruitMachineController:createView()
	WanRenFruitMachineLogic.createView();
	framework.setOnKeypadEventListener(WanRenFruitMachineLogic.view, WanRenFruitMachineLogic.onKeypad);
end

function WanRenFruitMachineController:requestMsg()
	WanRenFruitMachineLogic.requestMsg();
end

function WanRenFruitMachineController:addSlot()
	WanRenFruitMachineLogic.addSlot();
end

function WanRenFruitMachineController:removeSlot()
	WanRenFruitMachineLogic.removeSlot();
end

function WanRenFruitMachineController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_all"), WanRenFruitMachineLogic.callback_Panel_all, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_message"), WanRenFruitMachineLogic.callback_Panel_message, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_xiazhu"), WanRenFruitMachineLogic.callback_Panel_xiazhu, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu"), WanRenFruitMachineLogic.callback_Button_xiazhu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xuya"), WanRenFruitMachineLogic.callback_Button_xuya, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_buttonxiazhu"), WanRenFruitMachineLogic.callback_Panel_buttonxiazhu, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_orange"), WanRenFruitMachineLogic.callback_Button_xiazhu_orange, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_pawpaw"), WanRenFruitMachineLogic.callback_Button_xiazhu_pawpaw, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_bell"), WanRenFruitMachineLogic.callback_Button_xiazhu_bell, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_seven"), WanRenFruitMachineLogic.callback_Button_xiazhu_seven, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_apple"), WanRenFruitMachineLogic.callback_Button_xiazhu_apple, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_watermelon"), WanRenFruitMachineLogic.callback_Button_xiazhu_watermelon, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_star"), WanRenFruitMachineLogic.callback_Button_xiazhu_star, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_bar"), WanRenFruitMachineLogic.callback_Button_xiazhu_bar, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_shuzhi"), WanRenFruitMachineLogic.callback_Panel_shuzhi, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_xiaoxi"), WanRenFruitMachineLogic.callback_Panel_xiaoxi, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_jiesuan"), WanRenFruitMachineLogic.callback_Panel_jiesuan, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_jinbi"), WanRenFruitMachineLogic.callback_Panel_jinbi, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_addgod"), WanRenFruitMachineLogic.callback_Button_addgod, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_lishi"), WanRenFruitMachineLogic.callback_Panel_lishi, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_daojis"), WanRenFruitMachineLogic.callback_Panel_daojis, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_back"), WanRenFruitMachineLogic.callback_Panel_back, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_fanhui"), WanRenFruitMachineLogic.callback_Button_fanhui, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_talk"), WanRenFruitMachineLogic.callback_Button_talk, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_gift"), WanRenFruitMachineLogic.callback_Button_gift, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"chatTextFeild"),WanRenFruitMachineLogic.callback_ChatTextFeild_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"chatTextFeild"),WanRenFruitMachineLogic.callback_ChatTextFeild,DETACH_WITH_IME)
	end
end

function WanRenFruitMachineController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_all"), WanRenFruitMachineLogic.callback_Panel_all, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_message"), WanRenFruitMachineLogic.callback_Panel_message, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_xiazhu"), WanRenFruitMachineLogic.callback_Panel_xiazhu, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu"), WanRenFruitMachineLogic.callback_Button_xiazhu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xuya"), WanRenFruitMachineLogic.callback_Button_xuya, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_buttonxiazhu"), WanRenFruitMachineLogic.callback_Panel_buttonxiazhu, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_orange"), WanRenFruitMachineLogic.callback_Button_xiazhu_orange, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_pawpaw"), WanRenFruitMachineLogic.callback_Button_xiazhu_pawpaw, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_bell"), WanRenFruitMachineLogic.callback_Button_xiazhu_bell, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_seven"), WanRenFruitMachineLogic.callback_Button_xiazhu_seven, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_apple"), WanRenFruitMachineLogic.callback_Button_xiazhu_apple, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_watermelon"), WanRenFruitMachineLogic.callback_Button_xiazhu_watermelon, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_star"), WanRenFruitMachineLogic.callback_Button_xiazhu_star, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_xiazhu_bar"), WanRenFruitMachineLogic.callback_Button_xiazhu_bar, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_shuzhi"), WanRenFruitMachineLogic.callback_Panel_shuzhi, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_xiaoxi"), WanRenFruitMachineLogic.callback_Panel_xiaoxi, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_jiesuan"), WanRenFruitMachineLogic.callback_Panel_jiesuan, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_jinbi"), WanRenFruitMachineLogic.callback_Panel_jinbi, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_addgod"), WanRenFruitMachineLogic.callback_Button_addgod, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_lishi"), WanRenFruitMachineLogic.callback_Panel_lishi, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_daojis"), WanRenFruitMachineLogic.callback_Panel_daojis, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Panel_back"), WanRenFruitMachineLogic.callback_Panel_back, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_fanhui"), WanRenFruitMachineLogic.callback_Button_fanhui, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_talk"), WanRenFruitMachineLogic.callback_Button_talk, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"Button_gift"), WanRenFruitMachineLogic.callback_Button_gift, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"chatTextFeild"),WanRenFruitMachineLogic.callback_ChatTextFeild_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(WanRenFruitMachineLogic.view,"chatTextFeild"),WanRenFruitMachineLogic.callback_ChatTextFeild,DETACH_WITH_IME)
	end
end

function WanRenFruitMachineController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function WanRenFruitMachineController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function WanRenFruitMachineController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(WanRenFruitMachineLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(WanRenFruitMachineLogic);
		WanRenFruitMachineLogic.releaseData();
	end

	WanRenFruitMachineLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function WanRenFruitMachineController:sleepModule()
	framework.releaseOnKeypadEventListener(WanRenFruitMachineLogic.view);
	WanRenFruitMachineLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function WanRenFruitMachineController:wakeModule()
	framework.setOnKeypadEventListener(WanRenFruitMachineLogic.view, WanRenFruitMachineLogic.onKeypad);
	WanRenFruitMachineLogic.view:setTouchEnabled(true);
end
