module(...,package.seeall);

Load.LuaRequire("script.loadModule.jinhuapop.logic.JinHuaTableConfirmPopLogic");

JinHuaTableConfirmPopController = class("JinHuaTableConfirmPopController",BaseController);
JinHuaTableConfirmPopController.__index = JinHuaTableConfirmPopController;

JinHuaTableConfirmPopController.moduleLayer = nil;

function JinHuaTableConfirmPopController:reset()
	JinHuaTableConfirmPopLogic.view = nil;
end

function JinHuaTableConfirmPopController:getLayer()
	return JinHuaTableConfirmPopLogic.view;
end

function JinHuaTableConfirmPopController:createView()
	JinHuaTableConfirmPopLogic.createView();
	framework.setOnKeypadEventListener(JinHuaTableConfirmPopLogic.view, JinHuaTableConfirmPopLogic.onKeypad);
end

function JinHuaTableConfirmPopController:requestMsg()
	JinHuaTableConfirmPopLogic.requestMsg();
end

function JinHuaTableConfirmPopController:addSlot()
	JinHuaTableConfirmPopLogic.addSlot();
end

function JinHuaTableConfirmPopController:removeSlot()
	JinHuaTableConfirmPopLogic.removeSlot();
end

function JinHuaTableConfirmPopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableConfirmPopLogic.view,"btn_confirm"), JinHuaTableConfirmPopLogic.callback_btn_confirm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableConfirmPopLogic.view,"btn_cancel"), JinHuaTableConfirmPopLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function JinHuaTableConfirmPopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableConfirmPopLogic.view,"btn_confirm"), JinHuaTableConfirmPopLogic.callback_btn_confirm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableConfirmPopLogic.view,"btn_cancel"), JinHuaTableConfirmPopLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function JinHuaTableConfirmPopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function JinHuaTableConfirmPopController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function JinHuaTableConfirmPopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaTableConfirmPopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaTableConfirmPopLogic);
		JinHuaTableConfirmPopLogic.releaseData();
	end

	JinHuaTableConfirmPopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaTableConfirmPopController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaTableConfirmPopLogic.view);
	JinHuaTableConfirmPopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuaTableConfirmPopController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaTableConfirmPopLogic.view, JinHuaTableConfirmPopLogic.onKeypad);
	JinHuaTableConfirmPopLogic.view:setTouchEnabled(true);
end
