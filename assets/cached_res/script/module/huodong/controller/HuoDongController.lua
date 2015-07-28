module(...,package.seeall);

Load.LuaRequire("script.module.huodong.logic.HuoDongLogic");

HuoDongController = class("HuoDongController",BaseController);
HuoDongController.__index = HuoDongController;

HuoDongController.moduleLayer = nil;

function HuoDongController:reset()
	HuoDongLogic.view = nil;
end

function HuoDongController:getLayer()
	return HuoDongLogic.view;
end

function HuoDongController:createView()
	HuoDongLogic.createView();
	framework.setOnKeypadEventListener(HuoDongLogic.view, HuoDongLogic.onKeypad);
end

function HuoDongController:requestMsg()
	HuoDongLogic.requestMsg();
end

function HuoDongController:addSlot()
	HuoDongLogic.addSlot();
end

function HuoDongController:removeSlot()
	HuoDongLogic.removeSlot();
end

function HuoDongController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(HuoDongLogic.view,"guanbi"), HuoDongLogic.callback_guanbi, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function HuoDongController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(HuoDongLogic.view,"guanbi"), HuoDongLogic.callback_guanbi, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function HuoDongController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function HuoDongController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function HuoDongController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(HuoDongLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(HuoDongLogic);
		HuoDongLogic.releaseData();
	end

	HuoDongLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function HuoDongController:sleepModule()
	framework.releaseOnKeypadEventListener(HuoDongLogic.view);
	HuoDongLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function HuoDongController:wakeModule()
	framework.setOnKeypadEventListener(HuoDongLogic.view, HuoDongLogic.onKeypad);
	HuoDongLogic.view:setTouchEnabled(true);
end
