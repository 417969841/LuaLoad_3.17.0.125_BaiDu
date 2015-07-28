module(...,package.seeall);

Load.LuaRequire("script.module.meiridenglutishi.logic.MeiRiDengLuTiShiLogic");

MeiRiDengLuTiShiController = class("MeiRiDengLuTiShiController",BaseController);
MeiRiDengLuTiShiController.__index = MeiRiDengLuTiShiController;

MeiRiDengLuTiShiController.moduleLayer = nil;

function MeiRiDengLuTiShiController:reset()
	MeiRiDengLuTiShiLogic.view = nil;
end

function MeiRiDengLuTiShiController:getLayer()
	return MeiRiDengLuTiShiLogic.view;
end

function MeiRiDengLuTiShiController:createView()
	MeiRiDengLuTiShiLogic.createView();
	framework.setOnKeypadEventListener(MeiRiDengLuTiShiLogic.view, MeiRiDengLuTiShiLogic.onKeypad);
end

function MeiRiDengLuTiShiController:requestMsg()
	MeiRiDengLuTiShiLogic.requestMsg();
end

function MeiRiDengLuTiShiController:addSlot()
	MeiRiDengLuTiShiLogic.addSlot();
end

function MeiRiDengLuTiShiController:removeSlot()
	MeiRiDengLuTiShiLogic.removeSlot();
end

function MeiRiDengLuTiShiController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MeiRiDengLuTiShiLogic.view,"guanbi"), MeiRiDengLuTiShiLogic.callback_guanbi, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MeiRiDengLuTiShiController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MeiRiDengLuTiShiLogic.view,"guanbi"), MeiRiDengLuTiShiLogic.callback_guanbi, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MeiRiDengLuTiShiController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MeiRiDengLuTiShiController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MeiRiDengLuTiShiController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MeiRiDengLuTiShiLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MeiRiDengLuTiShiLogic);
		MeiRiDengLuTiShiLogic.releaseData();
	end

	MeiRiDengLuTiShiLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MeiRiDengLuTiShiController:sleepModule()
	framework.releaseOnKeypadEventListener(MeiRiDengLuTiShiLogic.view);
	MeiRiDengLuTiShiLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MeiRiDengLuTiShiController:wakeModule()
	framework.setOnKeypadEventListener(MeiRiDengLuTiShiLogic.view, MeiRiDengLuTiShiLogic.onKeypad);
	MeiRiDengLuTiShiLogic.view:setTouchEnabled(true);
end
