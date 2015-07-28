module(...,package.seeall);

Load.LuaRequire("script.module.hall.logic.AndroidExitLogic");

AndroidExitController = class("AndroidExitController",BaseController);
AndroidExitController.__index = AndroidExitController;

AndroidExitController.moduleLayer = nil;

function AndroidExitController:reset()
	AndroidExitLogic.view = nil;
end

function AndroidExitController:getLayer()
	return AndroidExitLogic.view;
end

function AndroidExitController:createView()
	AndroidExitLogic.createView();
	framework.setOnKeypadEventListener(AndroidExitLogic.view, AndroidExitLogic.onKeypad);
end

function AndroidExitController:requestMsg()
	AndroidExitLogic.requestMsg();
end

function AndroidExitController:addSlot()
	AndroidExitLogic.addSlot();
end

function AndroidExitController:removeSlot()
	AndroidExitLogic.removeSlot();
end

function AndroidExitController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(AndroidExitLogic.view,"btn_cancel"), AndroidExitLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(AndroidExitLogic.view,"btn_exit"), AndroidExitLogic.callback_btn_exit, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(AndroidExitLogic.view,"Button_Text"), AndroidExitLogic.callback_Button_Text, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(AndroidExitLogic.view,"btn_Right"), AndroidExitLogic.callback_btn_Right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function AndroidExitController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(AndroidExitLogic.view,"btn_cancel"), AndroidExitLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(AndroidExitLogic.view,"btn_exit"), AndroidExitLogic.callback_btn_exit, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(AndroidExitLogic.view,"Button_Text"), AndroidExitLogic.callback_Button_Text, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(AndroidExitLogic.view,"btn_Right"), AndroidExitLogic.callback_btn_Right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function AndroidExitController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function AndroidExitController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function AndroidExitController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(AndroidExitLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(AndroidExitLogic);
		AndroidExitLogic.releaseData();
	end

	AndroidExitLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function AndroidExitController:sleepModule()
	framework.releaseOnKeypadEventListener(AndroidExitLogic.view);
	AndroidExitLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function AndroidExitController:wakeModule()
	framework.setOnKeypadEventListener(AndroidExitLogic.view, AndroidExitLogic.onKeypad);
	AndroidExitLogic.view:setTouchEnabled(true);
end
