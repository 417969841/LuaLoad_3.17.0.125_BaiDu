module(...,package.seeall);

Load.LuaRequire("script.module.commondialog.logic.SystemPromptDialogLogic");

SystemPromptDialogController = class("SystemPromptDialogController",BaseController);
SystemPromptDialogController.__index = SystemPromptDialogController;

SystemPromptDialogController.moduleLayer = nil;

function SystemPromptDialogController:reset()
	SystemPromptDialogLogic.view = nil;
end

function SystemPromptDialogController:getLayer()
	return SystemPromptDialogLogic.view;
end

function SystemPromptDialogController:createView()
	SystemPromptDialogLogic.createView();
	framework.setOnKeypadEventListener(SystemPromptDialogLogic.view, SystemPromptDialogLogic.onKeypad);
end

function SystemPromptDialogController:requestMsg()
	SystemPromptDialogLogic.requestMsg();
end

function SystemPromptDialogController:addSlot()
	SystemPromptDialogLogic.addSlot();
end

function SystemPromptDialogController:removeSlot()
	SystemPromptDialogLogic.removeSlot();
end

function SystemPromptDialogController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(SystemPromptDialogLogic.view,"btn_logout"), SystemPromptDialogLogic.callback_btn_logout, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SystemPromptDialogController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(SystemPromptDialogLogic.view,"btn_logout"), SystemPromptDialogLogic.callback_btn_logout, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SystemPromptDialogController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function SystemPromptDialogController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function SystemPromptDialogController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SystemPromptDialogLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(SystemPromptDialogLogic);
		SystemPromptDialogLogic.releaseData();
	end

	SystemPromptDialogLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function SystemPromptDialogController:sleepModule()
	framework.releaseOnKeypadEventListener(SystemPromptDialogLogic.view);
	SystemPromptDialogLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function SystemPromptDialogController:wakeModule()
	framework.setOnKeypadEventListener(SystemPromptDialogLogic.view, SystemPromptDialogLogic.onKeypad);
	SystemPromptDialogLogic.view:setTouchEnabled(true);
end
