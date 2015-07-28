module(...,package.seeall);

Load.LuaRequire("script.module.NewUserGuide.logic.NewUserGuideLogic");

NewUserGuideController = class("NewUserGuideController",BaseController);
NewUserGuideController.__index = NewUserGuideController;

NewUserGuideController.moduleLayer = nil;

function NewUserGuideController:reset()
	NewUserGuideLogic.view = nil;
end

function NewUserGuideController:getLayer()
	return NewUserGuideLogic.view;
end

function NewUserGuideController:createView()
	NewUserGuideLogic.createView();
	framework.setOnKeypadEventListener(NewUserGuideLogic.view, NewUserGuideLogic.onKeypad);
end

function NewUserGuideController:requestMsg()
	NewUserGuideLogic.requestMsg();
end

function NewUserGuideController:addSlot()
	NewUserGuideLogic.addSlot();
end

function NewUserGuideController:removeSlot()
	NewUserGuideLogic.removeSlot();
end

function NewUserGuideController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(NewUserGuideLogic.view,"Panel_background"), NewUserGuideLogic.callback_Panel_background, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(NewUserGuideLogic.view,"btn_skip"), NewUserGuideLogic.callback_btn_skip, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function NewUserGuideController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(NewUserGuideLogic.view,"Panel_background"), NewUserGuideLogic.callback_Panel_background, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(NewUserGuideLogic.view,"btn_skip"), NewUserGuideLogic.callback_btn_skip, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function NewUserGuideController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function NewUserGuideController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function NewUserGuideController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(NewUserGuideLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(NewUserGuideLogic);
		NewUserGuideLogic.releaseData();
	end

	NewUserGuideLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function NewUserGuideController:sleepModule()
	framework.releaseOnKeypadEventListener(NewUserGuideLogic.view);
	NewUserGuideLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function NewUserGuideController:wakeModule()
	framework.setOnKeypadEventListener(NewUserGuideLogic.view, NewUserGuideLogic.onKeypad);
	NewUserGuideLogic.view:setTouchEnabled(true);
end
