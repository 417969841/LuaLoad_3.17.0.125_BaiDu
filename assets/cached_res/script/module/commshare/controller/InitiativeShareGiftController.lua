module(...,package.seeall);

Load.LuaRequire("script.module.commshare.logic.InitiativeShareGiftLogic");

InitiativeShareGiftController = class("InitiativeShareGiftController",BaseController);
InitiativeShareGiftController.__index = InitiativeShareGiftController;

InitiativeShareGiftController.moduleLayer = nil;

function InitiativeShareGiftController:reset()
	InitiativeShareGiftLogic.view = nil;
end

function InitiativeShareGiftController:getLayer()
	return InitiativeShareGiftLogic.view;
end

function InitiativeShareGiftController:createView()
	InitiativeShareGiftLogic.createView();
	framework.setOnKeypadEventListener(InitiativeShareGiftLogic.view, InitiativeShareGiftLogic.onKeypad);
end

function InitiativeShareGiftController:requestMsg()
	InitiativeShareGiftLogic.requestMsg();
end

function InitiativeShareGiftController:addSlot()
	InitiativeShareGiftLogic.addSlot();
end

function InitiativeShareGiftController:removeSlot()
	InitiativeShareGiftLogic.removeSlot();
end

function InitiativeShareGiftController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(InitiativeShareGiftLogic.view,"Button_Ok"), InitiativeShareGiftLogic.callback_Button_Ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function InitiativeShareGiftController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(InitiativeShareGiftLogic.view,"Button_Ok"), InitiativeShareGiftLogic.callback_Button_Ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function InitiativeShareGiftController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function InitiativeShareGiftController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function InitiativeShareGiftController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(InitiativeShareGiftLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(InitiativeShareGiftLogic);
		InitiativeShareGiftLogic.releaseData();
	end

	InitiativeShareGiftLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function InitiativeShareGiftController:sleepModule()
	framework.releaseOnKeypadEventListener(InitiativeShareGiftLogic.view);
	InitiativeShareGiftLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function InitiativeShareGiftController:wakeModule()
	framework.setOnKeypadEventListener(InitiativeShareGiftLogic.view, InitiativeShareGiftLogic.onKeypad);
	InitiativeShareGiftLogic.view:setTouchEnabled(true);
end
