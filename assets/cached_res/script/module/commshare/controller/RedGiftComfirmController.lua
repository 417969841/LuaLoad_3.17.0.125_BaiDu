module(...,package.seeall);

Load.LuaRequire("script.module.commshare.logic.RedGiftComfirmLogic");

RedGiftComfirmController = class("RedGiftComfirmController",BaseController);
RedGiftComfirmController.__index = RedGiftComfirmController;

RedGiftComfirmController.moduleLayer = nil;

function RedGiftComfirmController:reset()
	RedGiftComfirmLogic.view = nil;
end

function RedGiftComfirmController:getLayer()
	return RedGiftComfirmLogic.view;
end

function RedGiftComfirmController:createView()
	RedGiftComfirmLogic.createView();
	framework.setOnKeypadEventListener(RedGiftComfirmLogic.view, RedGiftComfirmLogic.onKeypad);
end

function RedGiftComfirmController:requestMsg()
	RedGiftComfirmLogic.requestMsg();
end

function RedGiftComfirmController:addSlot()
	RedGiftComfirmLogic.addSlot();
end

function RedGiftComfirmController:removeSlot()
	RedGiftComfirmLogic.removeSlot();
end

function RedGiftComfirmController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RedGiftComfirmLogic.view,"btn_close"), RedGiftComfirmLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RedGiftComfirmLogic.view,"btn_share"), RedGiftComfirmLogic.callback_btn_share, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RedGiftComfirmController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RedGiftComfirmLogic.view,"btn_close"), RedGiftComfirmLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RedGiftComfirmLogic.view,"btn_share"), RedGiftComfirmLogic.callback_btn_share, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RedGiftComfirmController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function RedGiftComfirmController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function RedGiftComfirmController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RedGiftComfirmLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RedGiftComfirmLogic);
		RedGiftComfirmLogic.releaseData();
	end

	RedGiftComfirmLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function RedGiftComfirmController:sleepModule()
	framework.releaseOnKeypadEventListener(RedGiftComfirmLogic.view);
	RedGiftComfirmLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function RedGiftComfirmController:wakeModule()
	framework.setOnKeypadEventListener(RedGiftComfirmLogic.view, RedGiftComfirmLogic.onKeypad);
	RedGiftComfirmLogic.view:setTouchEnabled(true);
end
