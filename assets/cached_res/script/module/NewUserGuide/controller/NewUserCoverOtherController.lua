module(...,package.seeall);

Load.LuaRequire("script.module.NewUserGuide.logic.NewUserCoverOtherLogic");

NewUserCoverOtherController = class("NewUserCoverOtherController",BaseController);
NewUserCoverOtherController.__index = NewUserCoverOtherController;

NewUserCoverOtherController.moduleLayer = nil;

function NewUserCoverOtherController:reset()
	NewUserCoverOtherLogic.view = nil;
end

function NewUserCoverOtherController:getLayer()
	return NewUserCoverOtherLogic.view;
end

function NewUserCoverOtherController:createView()
	NewUserCoverOtherLogic.createView();
	framework.setOnKeypadEventListener(NewUserCoverOtherLogic.view, NewUserCoverOtherLogic.onKeypad);
end

function NewUserCoverOtherController:requestMsg()
	NewUserCoverOtherLogic.requestMsg();
end

function NewUserCoverOtherController:addSlot()
	NewUserCoverOtherLogic.addSlot();
end

function NewUserCoverOtherController:removeSlot()
	NewUserCoverOtherLogic.removeSlot();
end

function NewUserCoverOtherController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(NewUserCoverOtherLogic.view,"Panel_Button"), NewUserCoverOtherLogic.callback_Panel_Button, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function NewUserCoverOtherController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(NewUserCoverOtherLogic.view,"Panel_Button"), NewUserCoverOtherLogic.callback_Panel_Button, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function NewUserCoverOtherController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function NewUserCoverOtherController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function NewUserCoverOtherController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(NewUserCoverOtherLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(NewUserCoverOtherLogic);
		NewUserCoverOtherLogic.releaseData();
	end

	NewUserCoverOtherLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function NewUserCoverOtherController:sleepModule()
	framework.releaseOnKeypadEventListener(NewUserCoverOtherLogic.view);
	NewUserCoverOtherLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function NewUserCoverOtherController:wakeModule()
	framework.setOnKeypadEventListener(NewUserCoverOtherLogic.view, NewUserCoverOtherLogic.onKeypad);
	NewUserCoverOtherLogic.view:setTouchEnabled(true);
end
