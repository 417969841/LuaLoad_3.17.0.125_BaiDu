module(...,package.seeall);

Load.LuaRequire("script.module.tableDialog.logic.MatchDengdaidaozhangLogic");

MatchDengdaidaozhangController = class("MatchDengdaidaozhangController",BaseController);
MatchDengdaidaozhangController.__index = MatchDengdaidaozhangController;

MatchDengdaidaozhangController.moduleLayer = nil;

function MatchDengdaidaozhangController:reset()
	MatchDengdaidaozhangLogic.view = nil;
end

function MatchDengdaidaozhangController:getLayer()
	return MatchDengdaidaozhangLogic.view;
end

function MatchDengdaidaozhangController:createView()
	MatchDengdaidaozhangLogic.createView();
	framework.setOnKeypadEventListener(MatchDengdaidaozhangLogic.view, MatchDengdaidaozhangLogic.onKeypad);
end

function MatchDengdaidaozhangController:requestMsg()
	MatchDengdaidaozhangLogic.requestMsg();
end

function MatchDengdaidaozhangController:addSlot()
	MatchDengdaidaozhangLogic.addSlot();
end

function MatchDengdaidaozhangController:removeSlot()
	MatchDengdaidaozhangLogic.removeSlot();
end

function MatchDengdaidaozhangController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MatchDengdaidaozhangLogic.view,"btn_backtorecharge"), MatchDengdaidaozhangLogic.callback_btn_backtorecharge, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MatchDengdaidaozhangController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MatchDengdaidaozhangLogic.view,"btn_backtorecharge"), MatchDengdaidaozhangLogic.callback_btn_backtorecharge, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MatchDengdaidaozhangController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MatchDengdaidaozhangController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MatchDengdaidaozhangController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MatchDengdaidaozhangLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MatchDengdaidaozhangLogic);
		MatchDengdaidaozhangLogic.releaseData();
	end

	MatchDengdaidaozhangLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MatchDengdaidaozhangController:sleepModule()
	framework.releaseOnKeypadEventListener(MatchDengdaidaozhangLogic.view);
	MatchDengdaidaozhangLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MatchDengdaidaozhangController:wakeModule()
	framework.setOnKeypadEventListener(MatchDengdaidaozhangLogic.view, MatchDengdaidaozhangLogic.onKeypad);
	MatchDengdaidaozhangLogic.view:setTouchEnabled(true);
end
