module(...,package.seeall);

Load.LuaRequire("script.module.chuangguan.logic.CrazyTopLogic");

CrazyTopController = class("CrazyTopController",BaseController);
CrazyTopController.__index = CrazyTopController;

CrazyTopController.moduleLayer = nil;

function CrazyTopController:reset()
	CrazyTopLogic.view = nil;
end

function CrazyTopController:getLayer()
	return CrazyTopLogic.view;
end

function CrazyTopController:createView()
	CrazyTopLogic.createView();
	framework.setOnKeypadEventListener(CrazyTopLogic.view, CrazyTopLogic.onKeypad);
end

function CrazyTopController:requestMsg()
	CrazyTopLogic.requestMsg();
end

function CrazyTopController:addSlot()
	CrazyTopLogic.addSlot();
end

function CrazyTopController:removeSlot()
	CrazyTopLogic.removeSlot();
end

function CrazyTopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CrazyTopLogic.view,"Button_Close"), CrazyTopLogic.callback_Button_Close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(CrazyTopLogic.view,"Button_jinri"), CrazyTopLogic.callback_Button_jinri, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(CrazyTopLogic.view,"Button_zuori"), CrazyTopLogic.callback_Button_zuori, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_ZOOM_IN);
end

function CrazyTopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CrazyTopLogic.view,"Button_Close"), CrazyTopLogic.callback_Button_Close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(CrazyTopLogic.view,"Button_jinri"), CrazyTopLogic.callback_Button_jinri, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(CrazyTopLogic.view,"Button_zuori"), CrazyTopLogic.callback_Button_zuori, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_ZOOM_IN);
end

function CrazyTopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function CrazyTopController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function CrazyTopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CrazyTopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(CrazyTopLogic);
		CrazyTopLogic.releaseData();
	end

	CrazyTopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function CrazyTopController:sleepModule()
	framework.releaseOnKeypadEventListener(CrazyTopLogic.view);
	CrazyTopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function CrazyTopController:wakeModule()
	framework.setOnKeypadEventListener(CrazyTopLogic.view, CrazyTopLogic.onKeypad);
	CrazyTopLogic.view:setTouchEnabled(true);
end
