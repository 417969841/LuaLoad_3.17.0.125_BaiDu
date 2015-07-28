module(...,package.seeall)

Load.LuaRequire("script.module.message.logic.MessageListLogic")

MessageListController = class("MessageListController",BaseController)
MessageListController.__index = MessageListController

MessageListController.moduleLayer = nil

function MessageListController:reset()
	MessageListLogic.view = nil
end

function MessageListController:getLayer()
	return MessageListLogic.view
end

function MessageListController:createView()
	MessageListLogic.createView()
	framework.setOnKeypadEventListener(MessageListLogic.view, MessageListLogic.onKeypad)
end

function MessageListController:requestMsg()
	MessageListLogic.requestMsg()
end

function MessageListController:addSlot()
	MessageListLogic.addSlot()
end

function MessageListController:removeSlot()
	MessageListLogic.removeSlot()
end

function MessageListController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"img_user"), MessageListLogic.callback_img_user, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"img_server"), MessageListLogic.callback_img_server, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"btn_back"), MessageListLogic.callback_btn_back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Panel_SelfMsg"), MessageListLogic.callback_Panel_SelfMsg, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"btn_send"), MessageListLogic.callback_btn_send, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Image_MyMeg"), MessageListLogic.callback_Image_MyMeg, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Image_SendMsg"), MessageListLogic.callback_Image_SendMsg, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Panel_18"), MessageListLogic.callback_Panel_18, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"btn_Coin"), MessageListLogic.callback_btn_Coin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"btn_YuanBao"), MessageListLogic.callback_btn_YuanBao, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"txt_username"),MessageListLogic.callback_txt_username_ios,BUTTON_CLICK)
		framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"txt_sendmsg"),MessageListLogic.callback_txt_sendmsg_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"txt_username"),MessageListLogic.callback_txt_username,DETACH_WITH_IME)
		framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"txt_sendmsg"),MessageListLogic.callback_txt_sendmsg,DETACH_WITH_IME)
	end

end

function MessageListController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"img_user"), MessageListLogic.callback_img_user, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"img_server"), MessageListLogic.callback_img_server, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"btn_back"), MessageListLogic.callback_btn_back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Panel_SelfMsg"), MessageListLogic.callback_Panel_SelfMsg, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"btn_send"), MessageListLogic.callback_btn_send, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Image_MyMeg"), MessageListLogic.callback_Image_MyMeg, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Image_SendMsg"), MessageListLogic.callback_Image_SendMsg, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Panel_18"), MessageListLogic.callback_Panel_18, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"btn_Coin"), MessageListLogic.callback_btn_Coin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"btn_YuanBao"), MessageListLogic.callback_btn_YuanBao, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"txt_username"),MessageListLogic.callback_txt_username_ios,BUTTON_CLICK)
		framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"txt_sendmsg"),MessageListLogic.callback_txt_sendmsg_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"txt_username"),MessageListLogic.callback_txt_username,DETACH_WITH_IME)
		framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"txt_sendmsg"),MessageListLogic.callback_txt_sendmsg,DETACH_WITH_IME)
	end
end

function MessageListController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function MessageListController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function MessageListController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MessageListLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MessageListLogic);
		MessageListLogic.releaseData();
	end

	MessageListLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function MessageListController:sleepModule()
	framework.releaseOnKeypadEventListener(MessageListLogic.view)
	MessageListLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function MessageListController:wakeModule()
	framework.setOnKeypadEventListener(MessageListLogic.view, MessageListLogic.onKeypad)
	MessageListLogic.view:setTouchEnabled(true)
end
