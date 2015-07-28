module(...,package.seeall);

Load.LuaRequire("script.module.hall.logic.RoomCoinNotFitLogic");

RoomCoinNotFitController = class("RoomCoinNotFitController",BaseController);
RoomCoinNotFitController.__index = RoomCoinNotFitController;

RoomCoinNotFitController.moduleLayer = nil;

function RoomCoinNotFitController:reset()
	RoomCoinNotFitLogic.view = nil;
end

function RoomCoinNotFitController:getLayer()
	return RoomCoinNotFitLogic.view;
end

function RoomCoinNotFitController:createView()
	RoomCoinNotFitLogic.createView();
	framework.setOnKeypadEventListener(RoomCoinNotFitLogic.view, RoomCoinNotFitLogic.onKeypad);
end

function RoomCoinNotFitController:requestMsg()
	RoomCoinNotFitLogic.requestMsg();
end

function RoomCoinNotFitController:addSlot()
	RoomCoinNotFitLogic.addSlot();
end

function RoomCoinNotFitController:removeSlot()
	RoomCoinNotFitLogic.removeSlot();
end

function RoomCoinNotFitController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RoomCoinNotFitLogic.view,"btn_close"), RoomCoinNotFitLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(RoomCoinNotFitLogic.view,"btn_go"), RoomCoinNotFitLogic.callback_btn_go, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function RoomCoinNotFitController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RoomCoinNotFitLogic.view,"btn_close"), RoomCoinNotFitLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(RoomCoinNotFitLogic.view,"btn_go"), RoomCoinNotFitLogic.callback_btn_go, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function RoomCoinNotFitController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function RoomCoinNotFitController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function RoomCoinNotFitController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RoomCoinNotFitLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RoomCoinNotFitLogic);
		RoomCoinNotFitLogic.releaseData();
	end

	RoomCoinNotFitLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function RoomCoinNotFitController:sleepModule()
	framework.releaseOnKeypadEventListener(RoomCoinNotFitLogic.view);
	RoomCoinNotFitLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function RoomCoinNotFitController:wakeModule()
	framework.setOnKeypadEventListener(RoomCoinNotFitLogic.view, RoomCoinNotFitLogic.onKeypad);
	RoomCoinNotFitLogic.view:setTouchEnabled(true);
end
