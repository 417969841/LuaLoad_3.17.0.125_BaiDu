module(...,package.seeall);

Load.LuaRequire("script.module.commshare.logic.CommShareLogic");

CommShareController = class("CommShareController",BaseController);
CommShareController.__index = CommShareController;

CommShareController.moduleLayer = nil;

function CommShareController:reset()
	CommShareLogic.view = nil;
end

function CommShareController:getLayer()
	return CommShareLogic.view;
end

function CommShareController:createView()
	CommShareLogic.createView();
	framework.setOnKeypadEventListener(CommShareLogic.view, CommShareLogic.onKeypad);
end

function CommShareController:requestMsg()
	CommShareLogic.requestMsg();
end

function CommShareController:addSlot()
	CommShareLogic.addSlot();
end

function CommShareController:removeSlot()
	CommShareLogic.removeSlot();
end

function CommShareController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CommShareLogic.view,"Panel_14"), CommShareLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CommShareLogic.view,"Button_close"), CommShareLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CommShareLogic.view,"Left_Select_Image"), CommShareLogic.callback_Left_Select_Image, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CommShareLogic.view,"Right_Select_Image"), CommShareLogic.callback_Right_Select_Image, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function CommShareController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CommShareLogic.view,"Panel_14"), CommShareLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CommShareLogic.view,"Button_close"), CommShareLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CommShareLogic.view,"Left_Select_Image"), CommShareLogic.callback_Left_Select_Image, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CommShareLogic.view,"Right_Select_Image"), CommShareLogic.callback_Right_Select_Image, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function CommShareController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function CommShareController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function CommShareController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CommShareLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(CommShareLogic);
		CommShareLogic.releaseData();
	end

	CommShareLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function CommShareController:sleepModule()
	framework.releaseOnKeypadEventListener(CommShareLogic.view);
	CommShareLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function CommShareController:wakeModule()
	framework.setOnKeypadEventListener(CommShareLogic.view, CommShareLogic.onKeypad);
	CommShareLogic.view:setTouchEnabled(true);
end
