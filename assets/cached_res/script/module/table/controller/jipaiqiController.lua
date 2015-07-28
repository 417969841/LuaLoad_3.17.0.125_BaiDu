module(...,package.seeall);

Load.LuaRequire("script.module.table.logic.jipaiqiLogic");

jipaiqiController = class("jipaiqiController",BaseController);
jipaiqiController.__index = jipaiqiController;

jipaiqiController.moduleLayer = nil;

function jipaiqiController:reset()
	jipaiqiLogic.view = nil;
end

function jipaiqiController:getLayer()
	return jipaiqiLogic.view;
end

function jipaiqiController:createView()
	jipaiqiLogic.createView();
	framework.setOnKeypadEventListener(jipaiqiLogic.view, jipaiqiLogic.onKeypad);
end

function jipaiqiController:requestMsg()
	jipaiqiLogic.requestMsg();
end

function jipaiqiController:addSlot()
	jipaiqiLogic.addSlot();
end

function jipaiqiController:removeSlot()
	jipaiqiLogic.removeSlot();
end

function jipaiqiController:addCallback()
end

function jipaiqiController:removeCallback()
end

function jipaiqiController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function jipaiqiController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function jipaiqiController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(jipaiqiLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(jipaiqiLogic);
		jipaiqiLogic.releaseData();
	end

	jipaiqiLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function jipaiqiController:sleepModule()
	framework.releaseOnKeypadEventListener(jipaiqiLogic.view);
	jipaiqiLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function jipaiqiController:wakeModule()
	framework.setOnKeypadEventListener(jipaiqiLogic.view, jipaiqiLogic.onKeypad);
	jipaiqiLogic.view:setTouchEnabled(true);
end
