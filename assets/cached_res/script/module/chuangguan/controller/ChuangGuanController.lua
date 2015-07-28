module(...,package.seeall);

Load.LuaRequire("script.module.chuangguan.logic.ChuangGuanLogic");

ChuangGuanController = class("ChuangGuanController",BaseController);
ChuangGuanController.__index = ChuangGuanController;

ChuangGuanController.moduleLayer = nil;

function ChuangGuanController:reset()
	ChuangGuanLogic.view = nil;
end

function ChuangGuanController:getLayer()
	return ChuangGuanLogic.view;
end

function ChuangGuanController:createView()
	ChuangGuanLogic.createView();
	framework.setOnKeypadEventListener(ChuangGuanLogic.view, ChuangGuanLogic.onKeypad);
end

function ChuangGuanController:requestMsg()
	ChuangGuanLogic.requestMsg();
end

function ChuangGuanController:addSlot()
	ChuangGuanLogic.addSlot();
end

function ChuangGuanController:removeSlot()
	ChuangGuanLogic.removeSlot();
end

function ChuangGuanController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Refresh"), ChuangGuanLogic.callback_Button_Refresh, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Buy"), ChuangGuanLogic.callback_Button_Buy, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Begin"), ChuangGuanLogic.callback_Button_Begin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_LuckyTurn"), ChuangGuanLogic.callback_Button_LuckyTurn, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Back"), ChuangGuanLogic.callback_Button_Back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Top"), ChuangGuanLogic.callback_Button_Top, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Help"), ChuangGuanLogic.callback_Button_Help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function ChuangGuanController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Refresh"), ChuangGuanLogic.callback_Button_Refresh, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Buy"), ChuangGuanLogic.callback_Button_Buy, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Begin"), ChuangGuanLogic.callback_Button_Begin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_LuckyTurn"), ChuangGuanLogic.callback_Button_LuckyTurn, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Back"), ChuangGuanLogic.callback_Button_Back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Top"), ChuangGuanLogic.callback_Button_Top, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(ChuangGuanLogic.view,"Button_Help"), ChuangGuanLogic.callback_Button_Help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function ChuangGuanController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function ChuangGuanController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function ChuangGuanController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ChuangGuanLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(ChuangGuanLogic);
		ChuangGuanLogic.releaseData();
	end

	ChuangGuanLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function ChuangGuanController:sleepModule()
	framework.releaseOnKeypadEventListener(ChuangGuanLogic.view);
	ChuangGuanLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function ChuangGuanController:wakeModule()
	framework.setOnKeypadEventListener(ChuangGuanLogic.view, ChuangGuanLogic.onKeypad);
	ChuangGuanLogic.view:setTouchEnabled(true);
end
