module(...,package.seeall);

Load.LuaRequire("script.module.login.logic.MoreLogic");

MoreController = class("MoreController",BaseController);
MoreController.__index = MoreController;

MoreController.moduleLayer = nil;

function MoreController:reset()
	MoreLogic.view = nil;
end

function MoreController:getLayer()
	return MoreLogic.view;
end

function MoreController:createView()
	MoreLogic.createView();
	framework.setOnKeypadEventListener(MoreLogic.view, MoreLogic.onKeypad);
end

function MoreController:requestMsg()
	MoreLogic.requestMsg();
end

function MoreController:addSlot()
	MoreLogic.addSlot();
end

function MoreController:removeSlot()
	MoreLogic.removeSlot();
end

function MoreController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MoreLogic.view,"Panel_main"), MoreLogic.callback_Panel_main, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MoreLogic.view,"Img_TopUser"), MoreLogic.callback_Img_TopUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MoreLogic.view,"Img_DeleteTopUser"), MoreLogic.callback_Img_DeleteTopUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MoreLogic.view,"Img_MiddleUser"), MoreLogic.callback_Img_MiddleUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MoreLogic.view,"Img_DeleteMiddleUser"), MoreLogic.callback_Img_DeleteMiddleUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MoreLogic.view,"Image_BottomUser"), MoreLogic.callback_Image_BottomUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MoreLogic.view,"Img_DeleteBottomUser"), MoreLogic.callback_Img_DeleteBottomUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function MoreController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MoreLogic.view,"Panel_main"), MoreLogic.callback_Panel_main, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MoreLogic.view,"Img_TopUser"), MoreLogic.callback_Img_TopUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MoreLogic.view,"Img_DeleteTopUser"), MoreLogic.callback_Img_DeleteTopUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MoreLogic.view,"Img_MiddleUser"), MoreLogic.callback_Img_MiddleUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MoreLogic.view,"Img_DeleteMiddleUser"), MoreLogic.callback_Img_DeleteMiddleUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MoreLogic.view,"Image_BottomUser"), MoreLogic.callback_Image_BottomUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MoreLogic.view,"Img_DeleteBottomUser"), MoreLogic.callback_Img_DeleteBottomUser, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function MoreController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MoreController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MoreController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MoreLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MoreLogic);
		MoreLogic.releaseData();
	end

	MoreLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MoreController:sleepModule()
	framework.releaseOnKeypadEventListener(MoreLogic.view);
	MoreLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MoreController:wakeModule()
	framework.setOnKeypadEventListener(MoreLogic.view, MoreLogic.onKeypad);
	MoreLogic.view:setTouchEnabled(true);
end
