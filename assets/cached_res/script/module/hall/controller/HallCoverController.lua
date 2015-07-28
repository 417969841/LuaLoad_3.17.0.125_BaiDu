module(...,package.seeall);

Load.LuaRequire("script.module.hall.logic.HallCoverLogic");

HallCoverController = class("HallCoverController",BaseController);
HallCoverController.__index = HallCoverController;

HallCoverController.moduleLayer = nil;

function HallCoverController:reset()
	HallCoverLogic.view = nil;
end

function HallCoverController:getLayer()
	return HallCoverLogic.view;
end

function HallCoverController:createView()
	HallCoverLogic.createView();
	framework.setOnKeypadEventListener(HallCoverLogic.view, HallCoverLogic.onKeypad);
end

function HallCoverController:requestMsg()
	HallCoverLogic.requestMsg();
end

function HallCoverController:addSlot()
	HallCoverLogic.addSlot();
end

function HallCoverController:removeSlot()
	HallCoverLogic.removeSlot();
end

function HallCoverController:addCallback()
	
end

function HallCoverController:removeCallback()
	
end

function HallCoverController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function HallCoverController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function HallCoverController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(HallCoverLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(HallCoverLogic);
		HallCoverLogic.releaseData();
	end

	HallCoverLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function HallCoverController:sleepModule()
	framework.releaseOnKeypadEventListener(HallCoverLogic.view);
	HallCoverLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function HallCoverController:wakeModule()
	framework.setOnKeypadEventListener(HallCoverLogic.view, HallCoverLogic.onKeypad);
	HallCoverLogic.view:setTouchEnabled(true);
end
