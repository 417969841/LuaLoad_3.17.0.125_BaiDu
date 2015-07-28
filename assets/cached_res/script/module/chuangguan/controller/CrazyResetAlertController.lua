module(...,package.seeall);

Load.LuaRequire("script.module.chuangguan.logic.CrazyResetAlertLogic");

CrazyResetAlertController = class("CrazyResetAlertController",BaseController);
CrazyResetAlertController.__index = CrazyResetAlertController;

CrazyResetAlertController.moduleLayer = nil;

function CrazyResetAlertController:reset()
	CrazyResetAlertLogic.view = nil;
end

function CrazyResetAlertController:getLayer()
	return CrazyResetAlertLogic.view;
end

function CrazyResetAlertController:createView()
	CrazyResetAlertLogic.createView();
	framework.setOnKeypadEventListener(CrazyResetAlertLogic.view, CrazyResetAlertLogic.onKeypad);
end

function CrazyResetAlertController:requestMsg()
	CrazyResetAlertLogic.requestMsg();
end

function CrazyResetAlertController:addSlot()
	CrazyResetAlertLogic.addSlot();
end

function CrazyResetAlertController:removeSlot()
	CrazyResetAlertLogic.removeSlot();
end

function CrazyResetAlertController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CrazyResetAlertLogic.view,"btn_cancel"), CrazyResetAlertLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CrazyResetAlertLogic.view,"btn_reset"), CrazyResetAlertLogic.callback_btn_reset, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CrazyResetAlertController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CrazyResetAlertLogic.view,"btn_cancel"), CrazyResetAlertLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CrazyResetAlertLogic.view,"btn_reset"), CrazyResetAlertLogic.callback_btn_reset, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CrazyResetAlertController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function CrazyResetAlertController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function CrazyResetAlertController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CrazyResetAlertLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(CrazyResetAlertLogic);
		CrazyResetAlertLogic.releaseData();
	end

	CrazyResetAlertLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function CrazyResetAlertController:sleepModule()
	framework.releaseOnKeypadEventListener(CrazyResetAlertLogic.view);
	CrazyResetAlertLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function CrazyResetAlertController:wakeModule()
	framework.setOnKeypadEventListener(CrazyResetAlertLogic.view, CrazyResetAlertLogic.onKeypad);
	CrazyResetAlertLogic.view:setTouchEnabled(true);
end
