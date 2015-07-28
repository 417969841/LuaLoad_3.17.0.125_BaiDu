module(...,package.seeall);

Load.LuaRequire("script.loadModule.trickyparty.logic.TrickyPartyLogic");

TrickyPartyController = class("TrickyPartyController",BaseController);
TrickyPartyController.__index = TrickyPartyController;

TrickyPartyController.moduleLayer = nil;

function TrickyPartyController:reset()
	TrickyPartyLogic.view = nil;
end

function TrickyPartyController:getLayer()
	return TrickyPartyLogic.view;
end

function TrickyPartyController:createView()
	TrickyPartyLogic.createView();
	framework.setOnKeypadEventListener(TrickyPartyLogic.view, TrickyPartyLogic.onKeypad);
end

function TrickyPartyController:requestMsg()
	TrickyPartyLogic.requestMsg();
end

function TrickyPartyController:addSlot()
	TrickyPartyLogic.addSlot();
end

function TrickyPartyController:removeSlot()
	TrickyPartyLogic.removeSlot();
end

function TrickyPartyController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Panel_14"), TrickyPartyLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Panel_6"), TrickyPartyLogic.callback_Panel_6, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_Paihangbang"), TrickyPartyLogic.callback_Button_Paihangbang, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_help"), TrickyPartyLogic.callback_Button_help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_fanhui"), TrickyPartyLogic.callback_Button_fanhui, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Panel_39"), TrickyPartyLogic.callback_Panel_39, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_shuaxin"), TrickyPartyLogic.callback_Button_shuaxin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_qianwang"), TrickyPartyLogic.callback_Button_qianwang, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Panel_43"), TrickyPartyLogic.callback_Panel_43, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_lingqu1"), TrickyPartyLogic.callback_Button_lingqu1, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_lingqu2"), TrickyPartyLogic.callback_Button_lingqu2, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_lingqu3"), TrickyPartyLogic.callback_Button_lingqu3, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_lingqu4"), TrickyPartyLogic.callback_Button_lingqu4, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TrickyPartyController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Panel_14"), TrickyPartyLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Panel_6"), TrickyPartyLogic.callback_Panel_6, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_Paihangbang"), TrickyPartyLogic.callback_Button_Paihangbang, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_help"), TrickyPartyLogic.callback_Button_help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_fanhui"), TrickyPartyLogic.callback_Button_fanhui, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Panel_39"), TrickyPartyLogic.callback_Panel_39, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_shuaxin"), TrickyPartyLogic.callback_Button_shuaxin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_qianwang"), TrickyPartyLogic.callback_Button_qianwang, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Panel_43"), TrickyPartyLogic.callback_Panel_43, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_lingqu1"), TrickyPartyLogic.callback_Button_lingqu1, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_lingqu2"), TrickyPartyLogic.callback_Button_lingqu2, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_lingqu3"), TrickyPartyLogic.callback_Button_lingqu3, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TrickyPartyLogic.view,"Button_lingqu4"), TrickyPartyLogic.callback_Button_lingqu4, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TrickyPartyController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function TrickyPartyController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function TrickyPartyController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TrickyPartyLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TrickyPartyLogic);
		TrickyPartyLogic.releaseData();
	end

	TrickyPartyLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function TrickyPartyController:sleepModule()
	framework.releaseOnKeypadEventListener(TrickyPartyLogic.view);
	TrickyPartyLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function TrickyPartyController:wakeModule()
	framework.setOnKeypadEventListener(TrickyPartyLogic.view, TrickyPartyLogic.onKeypad);
	TrickyPartyLogic.view:setTouchEnabled(true);
end
