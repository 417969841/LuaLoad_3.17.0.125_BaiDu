module(...,package.seeall);

Load.LuaRequire("script.module.freeCoin.logic.FreeCoinLogic");

FreeCoinController = class("FreeCoinController",BaseController);
FreeCoinController.__index = FreeCoinController;

FreeCoinController.moduleLayer = nil;

function FreeCoinController:reset()
	FreeCoinLogic.view = nil;
end

function FreeCoinController:getLayer()
	return FreeCoinLogic.view;
end

function FreeCoinController:createView()
	FreeCoinLogic.createView();
	framework.setOnKeypadEventListener(FreeCoinLogic.view, FreeCoinLogic.onKeypad);
end

function FreeCoinController:requestMsg()
	FreeCoinLogic.requestMsg();
end

function FreeCoinController:addSlot()
	FreeCoinLogic.addSlot();
end

function FreeCoinController:removeSlot()
	FreeCoinLogic.removeSlot();
end

function FreeCoinController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(FreeCoinLogic.view,"Button_close"), FreeCoinLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function FreeCoinController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(FreeCoinLogic.view,"Button_close"), FreeCoinLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function FreeCoinController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function FreeCoinController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function FreeCoinController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(FreeCoinLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(FreeCoinLogic);
		FreeCoinLogic.releaseData();
	end

	FreeCoinLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function FreeCoinController:sleepModule()
	framework.releaseOnKeypadEventListener(FreeCoinLogic.view);
	FreeCoinLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function FreeCoinController:wakeModule()
	framework.setOnKeypadEventListener(FreeCoinLogic.view, FreeCoinLogic.onKeypad);
	FreeCoinLogic.view:setTouchEnabled(true);
end
