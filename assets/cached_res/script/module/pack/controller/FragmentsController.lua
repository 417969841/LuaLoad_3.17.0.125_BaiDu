module(...,package.seeall);

Load.LuaRequire("script.module.pack.logic.FragmentsLogic");

FragmentsController = class("FragmentsController",BaseController);
FragmentsController.__index = FragmentsController;

FragmentsController.moduleLayer = nil;

function FragmentsController:reset()
	FragmentsLogic.view = nil;
end

function FragmentsController:getLayer()
	return FragmentsLogic.view;
end

function FragmentsController:createView()
	FragmentsLogic.createView();
	framework.setOnKeypadEventListener(FragmentsLogic.view, FragmentsLogic.onKeypad);
end

function FragmentsController:requestMsg()
	FragmentsLogic.requestMsg();
end

function FragmentsController:addSlot()
	FragmentsLogic.addSlot();
end

function FragmentsController:removeSlot()
	FragmentsLogic.removeSlot();
end

function FragmentsController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(FragmentsLogic.view,"btn_close"), FragmentsLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(FragmentsLogic.view,"btn_ok"), FragmentsLogic.callback_btn_ok, BUTTON_CLICK);
end

function FragmentsController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(FragmentsLogic.view,"btn_close"), FragmentsLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(FragmentsLogic.view,"btn_ok"), FragmentsLogic.callback_btn_ok, BUTTON_CLICK);
end

function FragmentsController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function FragmentsController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function FragmentsController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(FragmentsLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(FragmentsLogic);
		FragmentsLogic.releaseData();
	end

	FragmentsLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function FragmentsController:sleepModule()
	framework.releaseOnKeypadEventListener(FragmentsLogic.view);
	FragmentsLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function FragmentsController:wakeModule()
	framework.setOnKeypadEventListener(FragmentsLogic.view, FragmentsLogic.onKeypad);
	FragmentsLogic.view:setTouchEnabled(true);
end
