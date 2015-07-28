module(...,package.seeall);

Load.LuaRequire("script.loadModule.jinhuapop.logic.JinHuaTableCardTypePopLogic");

JinHuaTableCardTypePopController = class("JinHuaTableCardTypePopController",BaseController);
JinHuaTableCardTypePopController.__index = JinHuaTableCardTypePopController;

JinHuaTableCardTypePopController.moduleLayer = nil;

function JinHuaTableCardTypePopController:reset()
	JinHuaTableCardTypePopLogic.view = nil;
end

function JinHuaTableCardTypePopController:getLayer()
	return JinHuaTableCardTypePopLogic.view;
end

function JinHuaTableCardTypePopController:createView()
	JinHuaTableCardTypePopLogic.createView();
	framework.setOnKeypadEventListener(JinHuaTableCardTypePopLogic.view, JinHuaTableCardTypePopLogic.onKeypad);
end

function JinHuaTableCardTypePopController:requestMsg()
	JinHuaTableCardTypePopLogic.requestMsg();
end

function JinHuaTableCardTypePopController:addSlot()
	JinHuaTableCardTypePopLogic.addSlot();
end

function JinHuaTableCardTypePopController:removeSlot()
	JinHuaTableCardTypePopLogic.removeSlot();
end

function JinHuaTableCardTypePopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableCardTypePopLogic.view,"Button_close"), JinHuaTableCardTypePopLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function JinHuaTableCardTypePopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableCardTypePopLogic.view,"Button_close"), JinHuaTableCardTypePopLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function JinHuaTableCardTypePopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function JinHuaTableCardTypePopController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function JinHuaTableCardTypePopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaTableCardTypePopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaTableCardTypePopLogic);
		JinHuaTableCardTypePopLogic.releaseData();
	end

	JinHuaTableCardTypePopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaTableCardTypePopController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaTableCardTypePopLogic.view);
	JinHuaTableCardTypePopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuaTableCardTypePopController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaTableCardTypePopLogic.view, JinHuaTableCardTypePopLogic.onKeypad);
	JinHuaTableCardTypePopLogic.view:setTouchEnabled(true);
end
