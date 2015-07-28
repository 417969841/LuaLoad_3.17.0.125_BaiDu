module(...,package.seeall);

Load.LuaRequire("script.loadModule.jinHuaHall.logic.JinHuaHallLogic");

JinHuaHallController = class("JinHuaHallController",BaseController);
JinHuaHallController.__index = JinHuaHallController;

JinHuaHallController.moduleLayer = nil;

function JinHuaHallController:reset()
	JinHuaHallLogic.view = nil;
end

function JinHuaHallController:getLayer()
	return JinHuaHallLogic.view;
end

function JinHuaHallController:createView()
	JinHuaHallLogic.createView();
	framework.setOnKeypadEventListener(JinHuaHallLogic.view, JinHuaHallLogic.onKeypad);
end

function JinHuaHallController:requestMsg()
	JinHuaHallLogic.requestMsg();
end

function JinHuaHallController:addSlot()
	JinHuaHallLogic.addSlot();
end

function JinHuaHallController:removeSlot()
	JinHuaHallLogic.removeSlot();
end

function JinHuaHallController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_YuanBao"), JinHuaHallLogic.callback_Button_YuanBao, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
--	framework.bindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"btn_VIPkaitong"), JinHuaHallLogic.callback_btn_VIPkaitong, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_Coin"), JinHuaHallLogic.callback_Button_Coin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Image_Portrait"), JinHuaHallLogic.callback_Image_Portrait, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_Return"), JinHuaHallLogic.callback_Button_Return, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_QuickStart"), JinHuaHallLogic.callback_Button_QuickStart, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_Classic"), JinHuaHallLogic.callback_Button_Classic, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_QianWang"), JinHuaHallLogic.callback_Button_QianWang, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function JinHuaHallController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_YuanBao"), JinHuaHallLogic.callback_Button_YuanBao, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
--	framework.unbindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"btn_VIPkaitong"), JinHuaHallLogic.callback_btn_VIPkaitong, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_Coin"), JinHuaHallLogic.callback_Button_Coin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Image_Portrait"), JinHuaHallLogic.callback_Image_Portrait, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_Return"), JinHuaHallLogic.callback_Button_Return, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_QuickStart"), JinHuaHallLogic.callback_Button_QuickStart, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_Classic"), JinHuaHallLogic.callback_Button_Classic, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaHallLogic.view,"Button_QianWang"), JinHuaHallLogic.callback_Button_QianWang, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function JinHuaHallController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function JinHuaHallController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function JinHuaHallController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaHallLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaHallLogic);
		JinHuaHallLogic.releaseData();
	end

	JinHuaHallLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaHallController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaHallLogic.view);
	JinHuaHallLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuaHallController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaHallLogic.view, JinHuaHallLogic.onKeypad);
	JinHuaHallLogic.view:setTouchEnabled(true);
end
