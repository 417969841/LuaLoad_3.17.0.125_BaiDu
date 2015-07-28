module(...,package.seeall);

Load.LuaRequire("script.module.exchange.logic.HuaFeiZhangHuLogic");

HuaFeiZhangHuController = class("HuaFeiZhangHuController",BaseController);
HuaFeiZhangHuController.__index = HuaFeiZhangHuController;

HuaFeiZhangHuController.moduleLayer = nil;

function HuaFeiZhangHuController:reset()
	HuaFeiZhangHuLogic.view = nil;
end

function HuaFeiZhangHuController:getLayer()
	return HuaFeiZhangHuLogic.view;
end

function HuaFeiZhangHuController:createView()
	HuaFeiZhangHuLogic.createView();
	framework.setOnKeypadEventListener(HuaFeiZhangHuLogic.view, HuaFeiZhangHuLogic.onKeypad);
end

function HuaFeiZhangHuController:requestMsg()
	HuaFeiZhangHuLogic.requestMsg();
end

function HuaFeiZhangHuController:addSlot()
	HuaFeiZhangHuLogic.addSlot();
end

function HuaFeiZhangHuController:removeSlot()
	HuaFeiZhangHuLogic.removeSlot();
end

function HuaFeiZhangHuController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(HuaFeiZhangHuLogic.view,"btn"), HuaFeiZhangHuLogic.callback_btn, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HuaFeiZhangHuLogic.view,"btn_close"), HuaFeiZhangHuLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function HuaFeiZhangHuController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(HuaFeiZhangHuLogic.view,"btn"), HuaFeiZhangHuLogic.callback_btn, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HuaFeiZhangHuLogic.view,"btn_close"), HuaFeiZhangHuLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function HuaFeiZhangHuController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function HuaFeiZhangHuController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function HuaFeiZhangHuController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(HuaFeiZhangHuLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(HuaFeiZhangHuLogic);
		HuaFeiZhangHuLogic.releaseData();
	end

	HuaFeiZhangHuLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function HuaFeiZhangHuController:sleepModule()
	framework.releaseOnKeypadEventListener(HuaFeiZhangHuLogic.view);
	HuaFeiZhangHuLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function HuaFeiZhangHuController:wakeModule()
	framework.setOnKeypadEventListener(HuaFeiZhangHuLogic.view, HuaFeiZhangHuLogic.onKeypad);
	HuaFeiZhangHuLogic.view:setTouchEnabled(true);
end
