module(...,package.seeall);

Load.LuaRequire("script.module.match.logic.MatchVipNotEnoughLogic");

MatchVipNotEnoughController = class("MatchVipNotEnoughController",BaseController);
MatchVipNotEnoughController.__index = MatchVipNotEnoughController;

MatchVipNotEnoughController.moduleLayer = nil;

function MatchVipNotEnoughController:reset()
	MatchVipNotEnoughLogic.view = nil;
end

function MatchVipNotEnoughController:getLayer()
	return MatchVipNotEnoughLogic.view;
end

function MatchVipNotEnoughController:createView()
	MatchVipNotEnoughLogic.createView();
	framework.setOnKeypadEventListener(MatchVipNotEnoughLogic.view, MatchVipNotEnoughLogic.onKeypad);
end

function MatchVipNotEnoughController:requestMsg()
	MatchVipNotEnoughLogic.requestMsg();
end

function MatchVipNotEnoughController:addSlot()
	MatchVipNotEnoughLogic.addSlot();
end

function MatchVipNotEnoughController:removeSlot()
	MatchVipNotEnoughLogic.removeSlot();
end

function MatchVipNotEnoughController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MatchVipNotEnoughLogic.view,"btn_cz"), MatchVipNotEnoughLogic.callback_btn_cz, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MatchVipNotEnoughLogic.view,"btn_close"), MatchVipNotEnoughLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MatchVipNotEnoughController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MatchVipNotEnoughLogic.view,"btn_cz"), MatchVipNotEnoughLogic.callback_btn_cz, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MatchVipNotEnoughLogic.view,"btn_close"), MatchVipNotEnoughLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MatchVipNotEnoughController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MatchVipNotEnoughController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MatchVipNotEnoughController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MatchVipNotEnoughLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MatchVipNotEnoughLogic);
		MatchVipNotEnoughLogic.releaseData();
	end

	MatchVipNotEnoughLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MatchVipNotEnoughController:sleepModule()
	framework.releaseOnKeypadEventListener(MatchVipNotEnoughLogic.view);
	MatchVipNotEnoughLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MatchVipNotEnoughController:wakeModule()
	framework.setOnKeypadEventListener(MatchVipNotEnoughLogic.view, MatchVipNotEnoughLogic.onKeypad);
	MatchVipNotEnoughLogic.view:setTouchEnabled(true);
end
