module(...,package.seeall);

Load.LuaRequire("script.loadModule.jinhuapop.logic.JinHuaTableExitLogic");

JinHuaTableExitController = class("JinHuaTableExitController",BaseController);
JinHuaTableExitController.__index = JinHuaTableExitController;

JinHuaTableExitController.moduleLayer = nil;

function JinHuaTableExitController:reset()
	JinHuaTableExitLogic.view = nil;
end

function JinHuaTableExitController:getLayer()
	return JinHuaTableExitLogic.view;
end

function JinHuaTableExitController:createView()
	JinHuaTableExitLogic.createView();
	framework.setOnKeypadEventListener(JinHuaTableExitLogic.view, JinHuaTableExitLogic.onKeypad);
end

function JinHuaTableExitController:requestMsg()
	JinHuaTableExitLogic.requestMsg();
end

function JinHuaTableExitController:addSlot()
	JinHuaTableExitLogic.addSlot();
end

function JinHuaTableExitController:removeSlot()
	JinHuaTableExitLogic.removeSlot();
end

function JinHuaTableExitController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableExitLogic.view,"btn_close"), JinHuaTableExitLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableExitLogic.view,"Button_Confirm"), JinHuaTableExitLogic.callback_Button_Confirm, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableExitLogic.view,"Button_Download"), JinHuaTableExitLogic.callback_Button_Download, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function JinHuaTableExitController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableExitLogic.view,"btn_close"), JinHuaTableExitLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableExitLogic.view,"Button_Confirm"), JinHuaTableExitLogic.callback_Button_Confirm, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableExitLogic.view,"Button_Download"), JinHuaTableExitLogic.callback_Button_Download, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function JinHuaTableExitController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function JinHuaTableExitController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function JinHuaTableExitController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaTableExitLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaTableExitLogic);
		JinHuaTableExitLogic.releaseData();
	end

	JinHuaTableExitLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaTableExitController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaTableExitLogic.view);
	JinHuaTableExitLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuaTableExitController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaTableExitLogic.view, JinHuaTableExitLogic.onKeypad);
	JinHuaTableExitLogic.view:setTouchEnabled(true);
end
