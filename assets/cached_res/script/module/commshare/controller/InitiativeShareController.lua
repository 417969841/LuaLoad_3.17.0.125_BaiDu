module(...,package.seeall);

Load.LuaRequire("script.module.commshare.logic.InitiativeShareLogic");

InitiativeShareController = class("InitiativeShareController",BaseController);
InitiativeShareController.__index = InitiativeShareController;

InitiativeShareController.moduleLayer = nil;

function InitiativeShareController:reset()
	InitiativeShareLogic.view = nil;
end

function InitiativeShareController:getLayer()
	return InitiativeShareLogic.view;
end

function InitiativeShareController:createView()
	InitiativeShareLogic.createView();
	framework.setOnKeypadEventListener(InitiativeShareLogic.view, InitiativeShareLogic.onKeypad);
end

function InitiativeShareController:requestMsg()
	InitiativeShareLogic.requestMsg();
end

function InitiativeShareController:addSlot()
	InitiativeShareLogic.addSlot();
end

function InitiativeShareController:removeSlot()
	InitiativeShareLogic.removeSlot();
end

function InitiativeShareController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(InitiativeShareLogic.view,"Image_Help"), InitiativeShareLogic.callback_Image_Help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(InitiativeShareLogic.view,"Button_close"), InitiativeShareLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(InitiativeShareLogic.view,"Image_ToFriends"), InitiativeShareLogic.callback_Image_ToFriends, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(InitiativeShareLogic.view,"Image_ToCircle"), InitiativeShareLogic.callback_Image_ToCircle, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function InitiativeShareController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(InitiativeShareLogic.view,"Image_Help"), InitiativeShareLogic.callback_Image_Help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(InitiativeShareLogic.view,"Button_close"), InitiativeShareLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(InitiativeShareLogic.view,"Image_ToFriends"), InitiativeShareLogic.callback_Image_ToFriends, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(InitiativeShareLogic.view,"Image_ToCircle"), InitiativeShareLogic.callback_Image_ToCircle, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function InitiativeShareController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function InitiativeShareController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function InitiativeShareController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(InitiativeShareLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(InitiativeShareLogic);
		InitiativeShareLogic.releaseData();
	end

	InitiativeShareLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function InitiativeShareController:sleepModule()
	framework.releaseOnKeypadEventListener(InitiativeShareLogic.view);
	InitiativeShareLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function InitiativeShareController:wakeModule()
	framework.setOnKeypadEventListener(InitiativeShareLogic.view, InitiativeShareLogic.onKeypad);
	InitiativeShareLogic.view:setTouchEnabled(true);
end
