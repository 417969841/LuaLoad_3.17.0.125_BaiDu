module(...,package.seeall);

Load.LuaRequire("script.module.commshare.logic.RedGiftShareLogic");

RedGiftShareController = class("RedGiftShareController",BaseController);
RedGiftShareController.__index = RedGiftShareController;

RedGiftShareController.moduleLayer = nil;

function RedGiftShareController:reset()
	RedGiftShareLogic.view = nil;
end

function RedGiftShareController:getLayer()
	return RedGiftShareLogic.view;
end

function RedGiftShareController:createView()
	RedGiftShareLogic.createView();
	framework.setOnKeypadEventListener(RedGiftShareLogic.view, RedGiftShareLogic.onKeypad);
end

function RedGiftShareController:requestMsg()
	RedGiftShareLogic.requestMsg();
end

function RedGiftShareController:addSlot()
	RedGiftShareLogic.addSlot();
end

function RedGiftShareController:removeSlot()
	RedGiftShareLogic.removeSlot();
end

function RedGiftShareController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RedGiftShareLogic.view,"Panel_14"), RedGiftShareLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(RedGiftShareLogic.view,"Panel_hiese"), RedGiftShareLogic.callback_Panel_hiese, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(RedGiftShareLogic.view,"Button_back"), RedGiftShareLogic.callback_Button_back, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RedGiftShareLogic.view,"Image_ToFriends"), RedGiftShareLogic.callback_Image_ToFriends, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RedGiftShareLogic.view,"Image_ToCircle"), RedGiftShareLogic.callback_Image_ToCircle, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RedGiftShareController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RedGiftShareLogic.view,"Panel_14"), RedGiftShareLogic.callback_Panel_14, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(RedGiftShareLogic.view,"Panel_hiese"), RedGiftShareLogic.callback_Panel_hiese, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(RedGiftShareLogic.view,"Button_back"), RedGiftShareLogic.callback_Button_back, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RedGiftShareLogic.view,"Image_ToFriends"), RedGiftShareLogic.callback_Image_ToFriends, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RedGiftShareLogic.view,"Image_ToCircle"), RedGiftShareLogic.callback_Image_ToCircle, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RedGiftShareController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function RedGiftShareController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function RedGiftShareController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RedGiftShareLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RedGiftShareLogic);
		RedGiftShareLogic.releaseData();
	end

	RedGiftShareLogic.view:removeFromParentAndCleanup(true);
	self:reset();
	--如果今日是第一次红包分享且是新用户则分享后进行新手引导判断
	if CommShareConfig.isSuccessShare == false and CommShareConfig.isContinueNewGuide == true then
		--请求新手引导，并请求奖励
		if 	profile.NewUserGuide.getisNewUserGuideisEnable()== true then
			sendCOMMONS_GET_NEWUSERGUIDE_AWARD(1);
		end
		CommShareConfig.isContinueNewGuide = false
	end
	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function RedGiftShareController:sleepModule()
	framework.releaseOnKeypadEventListener(RedGiftShareLogic.view);
	RedGiftShareLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function RedGiftShareController:wakeModule()
	framework.setOnKeypadEventListener(RedGiftShareLogic.view, RedGiftShareLogic.onKeypad);
	RedGiftShareLogic.view:setTouchEnabled(true);
end
