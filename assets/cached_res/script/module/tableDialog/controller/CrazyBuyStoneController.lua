module(...,package.seeall);

Load.LuaRequire("script.module.tableDialog.logic.CrazyBuyStoneLogic");

CrazyBuyStoneController = class("CrazyBuyStoneController",BaseController);
CrazyBuyStoneController.__index = CrazyBuyStoneController;

CrazyBuyStoneController.moduleLayer = nil;

function CrazyBuyStoneController:reset()
	CrazyBuyStoneLogic.view = nil;
end

function CrazyBuyStoneController:getLayer()
	return CrazyBuyStoneLogic.view;
end

function CrazyBuyStoneController:createView()
	CrazyBuyStoneLogic.createView();
	framework.setOnKeypadEventListener(CrazyBuyStoneLogic.view, CrazyBuyStoneLogic.onKeypad);
end

function CrazyBuyStoneController:requestMsg()
	CrazyBuyStoneLogic.requestMsg();
end

function CrazyBuyStoneController:addSlot()
	CrazyBuyStoneLogic.addSlot();
end

function CrazyBuyStoneController:removeSlot()
	CrazyBuyStoneLogic.removeSlot();
end

function CrazyBuyStoneController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CrazyBuyStoneLogic.view,"btn_cancel"), CrazyBuyStoneLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CrazyBuyStoneLogic.view,"btn_logout"), CrazyBuyStoneLogic.callback_btn_logout, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CrazyBuyStoneController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CrazyBuyStoneLogic.view,"btn_cancel"), CrazyBuyStoneLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CrazyBuyStoneLogic.view,"btn_logout"), CrazyBuyStoneLogic.callback_btn_logout, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CrazyBuyStoneController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function CrazyBuyStoneController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function CrazyBuyStoneController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CrazyBuyStoneLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(CrazyBuyStoneLogic);
		CrazyBuyStoneLogic.releaseData();
	end

	CrazyBuyStoneLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function CrazyBuyStoneController:sleepModule()
	framework.releaseOnKeypadEventListener(CrazyBuyStoneLogic.view);
	CrazyBuyStoneLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function CrazyBuyStoneController:wakeModule()
	framework.setOnKeypadEventListener(CrazyBuyStoneLogic.view, CrazyBuyStoneLogic.onKeypad);
	CrazyBuyStoneLogic.view:setTouchEnabled(true);
end
