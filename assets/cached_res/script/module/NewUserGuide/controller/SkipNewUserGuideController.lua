module(...,package.seeall);

Load.LuaRequire("script.module.NewUserGuide.logic.SkipNewUserGuideLogic");

SkipNewUserGuideController = class("SkipNewUserGuideController",BaseController);
SkipNewUserGuideController.__index = SkipNewUserGuideController;

SkipNewUserGuideController.moduleLayer = nil;

function SkipNewUserGuideController:reset()
	SkipNewUserGuideLogic.view = nil;
end

function SkipNewUserGuideController:getLayer()
	return SkipNewUserGuideLogic.view;
end

function SkipNewUserGuideController:createView()
	SkipNewUserGuideLogic.createView();
	framework.setOnKeypadEventListener(SkipNewUserGuideLogic.view, SkipNewUserGuideLogic.onKeypad);
end

function SkipNewUserGuideController:requestMsg()
	SkipNewUserGuideLogic.requestMsg();
end

function SkipNewUserGuideController:addSlot()
	SkipNewUserGuideLogic.addSlot();
end

function SkipNewUserGuideController:removeSlot()
	SkipNewUserGuideLogic.removeSlot();
end

function SkipNewUserGuideController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(SkipNewUserGuideLogic.view,"Button_SkipButton"), SkipNewUserGuideLogic.callback_Button_SkipButton, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(SkipNewUserGuideLogic.view,"Button_JiXu"), SkipNewUserGuideLogic.callback_Button_JiXu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SkipNewUserGuideController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(SkipNewUserGuideLogic.view,"Button_SkipButton"), SkipNewUserGuideLogic.callback_Button_SkipButton, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(SkipNewUserGuideLogic.view,"Button_JiXu"), SkipNewUserGuideLogic.callback_Button_JiXu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SkipNewUserGuideController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function SkipNewUserGuideController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function SkipNewUserGuideController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SkipNewUserGuideLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(SkipNewUserGuideLogic);
		SkipNewUserGuideLogic.releaseData();
	end

	SkipNewUserGuideLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function SkipNewUserGuideController:sleepModule()
	framework.releaseOnKeypadEventListener(SkipNewUserGuideLogic.view);
	SkipNewUserGuideLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function SkipNewUserGuideController:wakeModule()
	framework.setOnKeypadEventListener(SkipNewUserGuideLogic.view, SkipNewUserGuideLogic.onKeypad);
	SkipNewUserGuideLogic.view:setTouchEnabled(true);
end
