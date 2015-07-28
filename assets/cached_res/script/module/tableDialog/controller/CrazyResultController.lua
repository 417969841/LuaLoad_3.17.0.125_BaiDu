module(...,package.seeall);

Load.LuaRequire("script.module.tableDialog.logic.CrazyResultLogic");

CrazyResultController = class("CrazyResultController",BaseController);
CrazyResultController.__index = CrazyResultController;

CrazyResultController.moduleLayer = nil;

function CrazyResultController:reset()
	CrazyResultLogic.view = nil;
end

function CrazyResultController:getLayer()
	return CrazyResultLogic.view;
end

function CrazyResultController:createView()
	CrazyResultLogic.createView();
	framework.setOnKeypadEventListener(CrazyResultLogic.view, CrazyResultLogic.onKeypad);
end

function CrazyResultController:requestMsg()
	CrazyResultLogic.requestMsg();
end

function CrazyResultController:addSlot()
	CrazyResultLogic.addSlot();
end

function CrazyResultController:removeSlot()
	CrazyResultLogic.removeSlot();
end

function CrazyResultController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CrazyResultLogic.view,"Panel_20"), CrazyResultLogic.callback_Panel_20, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CrazyResultLogic.view,"btn_OK"), CrazyResultLogic.callback_btn_OK, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CrazyResultLogic.view,"btn_Close"), CrazyResultLogic.callback_btn_Close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CrazyResultController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CrazyResultLogic.view,"Panel_20"), CrazyResultLogic.callback_Panel_20, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CrazyResultLogic.view,"btn_OK"), CrazyResultLogic.callback_btn_OK, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CrazyResultLogic.view,"btn_Close"), CrazyResultLogic.callback_btn_Close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CrazyResultController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function CrazyResultController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function CrazyResultController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CrazyResultLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(CrazyResultLogic);
		CrazyResultLogic.releaseData();
	end

	CrazyResultLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function CrazyResultController:sleepModule()
	framework.releaseOnKeypadEventListener(CrazyResultLogic.view);
	CrazyResultLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function CrazyResultController:wakeModule()
	framework.setOnKeypadEventListener(CrazyResultLogic.view, CrazyResultLogic.onKeypad);
	CrazyResultLogic.view:setTouchEnabled(true);
end
