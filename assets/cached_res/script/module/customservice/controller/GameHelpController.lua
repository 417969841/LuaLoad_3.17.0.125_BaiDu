module(...,package.seeall);

Load.LuaRequire("script.module.customservice.logic.GameHelpLogic");

GameHelpController = class("GameHelpController",BaseController);
GameHelpController.__index = GameHelpController;

GameHelpController.moduleLayer = nil;

function GameHelpController:reset()
	GameHelpLogic.view = nil;
end

function GameHelpController:getLayer()
	return GameHelpLogic.view;
end

function GameHelpController:createView()
	GameHelpLogic.createView();
	framework.setOnKeypadEventListener(GameHelpLogic.view, GameHelpLogic.onKeypad);
end

function GameHelpController:requestMsg()
	GameHelpLogic.requestMsg();
end

function GameHelpController:addSlot()
	GameHelpLogic.addSlot();
end

function GameHelpController:removeSlot()
	GameHelpLogic.removeSlot();
end

function GameHelpController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"Panel_14"), GameHelpLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"Panel_1"), GameHelpLogic.callback_Panel_1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"Panel_Help"), GameHelpLogic.callback_Panel_Help, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"btn_close"), GameHelpLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function GameHelpController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"Panel_14"), GameHelpLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"Panel_1"), GameHelpLogic.callback_Panel_1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"Panel_Help"), GameHelpLogic.callback_Panel_Help, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"btn_close"), GameHelpLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function GameHelpController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function GameHelpController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function GameHelpController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(GameHelpLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(GameHelpLogic);
		GameHelpLogic.releaseData();
	end

	GameHelpLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function GameHelpController:sleepModule()
	framework.releaseOnKeypadEventListener(GameHelpLogic.view);
	GameHelpLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function GameHelpController:wakeModule()
	framework.setOnKeypadEventListener(GameHelpLogic.view, GameHelpLogic.onKeypad);
	GameHelpLogic.view:setTouchEnabled(true);
end
