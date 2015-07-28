module(...,package.seeall);

Load.LuaRequire("script.module.chuangguan.logic.CrazyRuleLogic");

CrazyRuleController = class("CrazyRuleController",BaseController);
CrazyRuleController.__index = CrazyRuleController;

CrazyRuleController.moduleLayer = nil;

function CrazyRuleController:reset()
	CrazyRuleLogic.view = nil;
end

function CrazyRuleController:getLayer()
	return CrazyRuleLogic.view;
end

function CrazyRuleController:createView()
	CrazyRuleLogic.createView();
	framework.setOnKeypadEventListener(CrazyRuleLogic.view, CrazyRuleLogic.onKeypad);
end

function CrazyRuleController:requestMsg()
	CrazyRuleLogic.requestMsg();
end

function CrazyRuleController:addSlot()
	CrazyRuleLogic.addSlot();
end

function CrazyRuleController:removeSlot()
	CrazyRuleLogic.removeSlot();
end

function CrazyRuleController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CrazyRuleLogic.view,"btn_cancel"), CrazyRuleLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CrazyRuleController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CrazyRuleLogic.view,"btn_cancel"), CrazyRuleLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CrazyRuleController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function CrazyRuleController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function CrazyRuleController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CrazyRuleLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(CrazyRuleLogic);
		CrazyRuleLogic.releaseData();
	end

	CrazyRuleLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function CrazyRuleController:sleepModule()
	framework.releaseOnKeypadEventListener(CrazyRuleLogic.view);
	CrazyRuleLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function CrazyRuleController:wakeModule()
	framework.setOnKeypadEventListener(CrazyRuleLogic.view, CrazyRuleLogic.onKeypad);
	CrazyRuleLogic.view:setTouchEnabled(true);
end
