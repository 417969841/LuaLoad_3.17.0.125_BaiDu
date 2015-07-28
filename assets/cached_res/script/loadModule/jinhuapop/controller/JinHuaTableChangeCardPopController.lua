module(...,package.seeall);

Load.LuaRequire("script.loadModule.jinhuapop.logic.JinHuaTableChangeCardPopLogic");

JinHuaTableChangeCardPopController = class("JinHuaTableChangeCardPopController",BaseController);
JinHuaTableChangeCardPopController.__index = JinHuaTableChangeCardPopController;

JinHuaTableChangeCardPopController.moduleLayer = nil;

function JinHuaTableChangeCardPopController:reset()
	JinHuaTableChangeCardPopLogic.view = nil;
end

function JinHuaTableChangeCardPopController:getLayer()
	return JinHuaTableChangeCardPopLogic.view;
end

function JinHuaTableChangeCardPopController:createView()
	JinHuaTableChangeCardPopLogic.createView();
	framework.setOnKeypadEventListener(JinHuaTableChangeCardPopLogic.view, JinHuaTableChangeCardPopLogic.onKeypad);
end

function JinHuaTableChangeCardPopController:requestMsg()
	JinHuaTableChangeCardPopLogic.requestMsg();
end

function JinHuaTableChangeCardPopController:addSlot()
	JinHuaTableChangeCardPopLogic.addSlot();
end

function JinHuaTableChangeCardPopController:removeSlot()
	JinHuaTableChangeCardPopLogic.removeSlot();
end

function JinHuaTableChangeCardPopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableChangeCardPopLogic.view,"bt_table_changecard_click"), JinHuaTableChangeCardPopLogic.callback_btn_confirm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableChangeCardPopLogic.view,"bt_table_changecard_close"), JinHuaTableChangeCardPopLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function JinHuaTableChangeCardPopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableChangeCardPopLogic.view,"bt_table_changecard_click"), JinHuaTableChangeCardPopLogic.callback_btn_confirm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableChangeCardPopLogic.view,"bt_table_changecard_close"), JinHuaTableChangeCardPopLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function JinHuaTableChangeCardPopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function JinHuaTableChangeCardPopController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function JinHuaTableChangeCardPopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaTableChangeCardPopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaTableChangeCardPopLogic);
		JinHuaTableChangeCardPopLogic.releaseData();
	end

	JinHuaTableChangeCardPopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaTableChangeCardPopController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaTableChangeCardPopLogic.view);
	JinHuaTableChangeCardPopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuaTableChangeCardPopController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaTableChangeCardPopLogic.view, JinHuaTableChangeCardPopLogic.onKeypad);
	JinHuaTableChangeCardPopLogic.view:setTouchEnabled(true);
end
