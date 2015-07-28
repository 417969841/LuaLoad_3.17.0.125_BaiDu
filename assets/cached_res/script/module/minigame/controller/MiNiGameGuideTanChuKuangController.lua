module(...,package.seeall);

Load.LuaRequire("script.module.minigame.logic.MiNiGameGuideTanChuKuangLogic");

MiNiGameGuideTanChuKuangController = class("MiNiGameGuideTanChuKuangController",BaseController);
MiNiGameGuideTanChuKuangController.__index = MiNiGameGuideTanChuKuangController;

MiNiGameGuideTanChuKuangController.moduleLayer = nil;

function MiNiGameGuideTanChuKuangController:reset()
	MiNiGameGuideTanChuKuangLogic.view = nil;
end

function MiNiGameGuideTanChuKuangController:getLayer()
	return MiNiGameGuideTanChuKuangLogic.view;
end

function MiNiGameGuideTanChuKuangController:createView()
	MiNiGameGuideTanChuKuangLogic.createView();
	framework.setOnKeypadEventListener(MiNiGameGuideTanChuKuangLogic.view, MiNiGameGuideTanChuKuangLogic.onKeypad);
end

function MiNiGameGuideTanChuKuangController:requestMsg()
	MiNiGameGuideTanChuKuangLogic.requestMsg();
end

function MiNiGameGuideTanChuKuangController:addSlot()
	MiNiGameGuideTanChuKuangLogic.addSlot();
end

function MiNiGameGuideTanChuKuangController:removeSlot()
	MiNiGameGuideTanChuKuangLogic.removeSlot();
end

function MiNiGameGuideTanChuKuangController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MiNiGameGuideTanChuKuangLogic.view,"Panel_14"), MiNiGameGuideTanChuKuangLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MiNiGameGuideTanChuKuangLogic.view,"btn_close"), MiNiGameGuideTanChuKuangLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MiNiGameGuideTanChuKuangLogic.view,"btn_queding"), MiNiGameGuideTanChuKuangLogic.callback_btn_queding, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MiNiGameGuideTanChuKuangController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MiNiGameGuideTanChuKuangLogic.view,"Panel_14"), MiNiGameGuideTanChuKuangLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MiNiGameGuideTanChuKuangLogic.view,"btn_close"), MiNiGameGuideTanChuKuangLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MiNiGameGuideTanChuKuangLogic.view,"btn_queding"), MiNiGameGuideTanChuKuangLogic.callback_btn_queding, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MiNiGameGuideTanChuKuangController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MiNiGameGuideTanChuKuangController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MiNiGameGuideTanChuKuangController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MiNiGameGuideTanChuKuangLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MiNiGameGuideTanChuKuangLogic);
		MiNiGameGuideTanChuKuangLogic.releaseData();
	end

	MiNiGameGuideTanChuKuangLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MiNiGameGuideTanChuKuangController:sleepModule()
	framework.releaseOnKeypadEventListener(MiNiGameGuideTanChuKuangLogic.view);
	MiNiGameGuideTanChuKuangLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MiNiGameGuideTanChuKuangController:wakeModule()
	framework.setOnKeypadEventListener(MiNiGameGuideTanChuKuangLogic.view, MiNiGameGuideTanChuKuangLogic.onKeypad);
	MiNiGameGuideTanChuKuangLogic.view:setTouchEnabled(true);
end
