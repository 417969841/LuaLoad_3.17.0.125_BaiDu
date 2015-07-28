module(...,package.seeall);

Load.LuaRequire("script.loadModule.jinhuapop.logic.JinHuaTableGoodsBuyPopLogic");

JinHuaTableGoodsBuyPopController = class("JinHuaTableGoodsBuyPopController",BaseController);
JinHuaTableGoodsBuyPopController.__index = JinHuaTableGoodsBuyPopController;

JinHuaTableGoodsBuyPopController.moduleLayer = nil;

function JinHuaTableGoodsBuyPopController:reset()
	JinHuaTableGoodsBuyPopLogic.view = nil;
end

function JinHuaTableGoodsBuyPopController:getLayer()
	return JinHuaTableGoodsBuyPopLogic.view;
end

function JinHuaTableGoodsBuyPopController:createView()
	JinHuaTableGoodsBuyPopLogic.createView();
	framework.setOnKeypadEventListener(JinHuaTableGoodsBuyPopLogic.view, JinHuaTableGoodsBuyPopLogic.onKeypad);
end

function JinHuaTableGoodsBuyPopController:requestMsg()
	JinHuaTableGoodsBuyPopLogic.requestMsg();
end

function JinHuaTableGoodsBuyPopController:addSlot()
	JinHuaTableGoodsBuyPopLogic.addSlot();
end

function JinHuaTableGoodsBuyPopController:removeSlot()
	JinHuaTableGoodsBuyPopLogic.removeSlot();
end

function JinHuaTableGoodsBuyPopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableGoodsBuyPopLogic.view,"btn_confirm"), JinHuaTableGoodsBuyPopLogic.callback_btn_confirm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableGoodsBuyPopLogic.view,"btn_close"), JinHuaTableGoodsBuyPopLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function JinHuaTableGoodsBuyPopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableGoodsBuyPopLogic.view,"btn_confirm"), JinHuaTableGoodsBuyPopLogic.callback_btn_confirm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableGoodsBuyPopLogic.view,"btn_close"), JinHuaTableGoodsBuyPopLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function JinHuaTableGoodsBuyPopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function JinHuaTableGoodsBuyPopController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function JinHuaTableGoodsBuyPopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaTableGoodsBuyPopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaTableGoodsBuyPopLogic);
		JinHuaTableGoodsBuyPopLogic.releaseData();
	end

	JinHuaTableGoodsBuyPopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaTableGoodsBuyPopController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaTableGoodsBuyPopLogic.view);
	JinHuaTableGoodsBuyPopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuaTableGoodsBuyPopController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaTableGoodsBuyPopLogic.view, JinHuaTableGoodsBuyPopLogic.onKeypad);
	JinHuaTableGoodsBuyPopLogic.view:setTouchEnabled(true);
end
