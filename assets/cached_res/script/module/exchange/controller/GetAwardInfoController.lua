module(...,package.seeall)

Load.LuaRequire("script.module.exchange.logic.GetAwardInfoLogic")

GetAwardInfoController = class("GetAwardInfoController",BaseController)
GetAwardInfoController.__index = GetAwardInfoController

GetAwardInfoController.moduleLayer = nil

function GetAwardInfoController:reset()
	GetAwardInfoLogic.view = nil
end

function GetAwardInfoController:getLayer()
	return GetAwardInfoLogic.view
end

function GetAwardInfoController:createView()
	GetAwardInfoLogic.createView()
	framework.setOnKeypadEventListener(GetAwardInfoLogic.view, GetAwardInfoLogic.onKeypad)
end

function GetAwardInfoController:requestMsg()
	GetAwardInfoLogic.requestMsg()
end

function GetAwardInfoController:addSlot()
	GetAwardInfoLogic.addSlot()
end

function GetAwardInfoController:removeSlot()
	GetAwardInfoLogic.removeSlot()
end

function GetAwardInfoController:addCallback()
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_username"),GetAwardInfoLogic.callback_txt_username_ios,BUTTON_CLICK);
		framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_phone"),GetAwardInfoLogic.callback_txt_phone_ios,BUTTON_CLICK);
		framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_address"),GetAwardInfoLogic.callback_txt_address_ios,BUTTON_CLICK);
		framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_email"),GetAwardInfoLogic.callback_txt_email_ios,BUTTON_CLICK);
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_username"),GetAwardInfoLogic.callback_txt_username,DETACH_WITH_IME);
		framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_phone"),GetAwardInfoLogic.callback_txt_phone,DETACH_WITH_IME);
		framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_address"),GetAwardInfoLogic.callback_txt_address,DETACH_WITH_IME);
		framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_email"),GetAwardInfoLogic.callback_txt_email,DETACH_WITH_IME);
	end

	framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"btn_close"),GetAwardInfoLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"btn_save"),GetAwardInfoLogic.callback_btn_save,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"btn_duihuan"),GetAwardInfoLogic.callback_btn_duihuan,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"btn_cancel"),GetAwardInfoLogic.callback_btn_cancel,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function GetAwardInfoController:removeCallback()
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_username"),GetAwardInfoLogic.callback_txt_username_ios,BUTTON_CLICK);
		framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_phone"),GetAwardInfoLogic.callback_txt_phone_ios,BUTTON_CLICK);
		framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_address"),GetAwardInfoLogic.callback_txt_address_ios,BUTTON_CLICK);
		framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_email"),GetAwardInfoLogic.callback_txt_email_ios,BUTTON_CLICK);
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_username"),GetAwardInfoLogic.callback_txt_username,DETACH_WITH_IME);
		framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_phone"),GetAwardInfoLogic.callback_txt_phone,DETACH_WITH_IME);
		framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_address"),GetAwardInfoLogic.callback_txt_address,DETACH_WITH_IME);
		framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"txt_email"),GetAwardInfoLogic.callback_txt_email,DETACH_WITH_IME);
	end

	framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"btn_close"),GetAwardInfoLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"btn_save"),GetAwardInfoLogic.callback_btn_save,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"btn_duihuan"),GetAwardInfoLogic.callback_btn_save,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(GetAwardInfoLogic.view,"btn_cancel"),GetAwardInfoLogic.callback_btn_cancel,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function GetAwardInfoController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function GetAwardInfoController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function GetAwardInfoController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(GetAwardInfoLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(GetAwardInfoLogic);
		GetAwardInfoLogic.releaseData();
	end

	GetAwardInfoLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function GetAwardInfoController:sleepModule()
	framework.releaseOnKeypadEventListener(GetAwardInfoLogic.view)
	GetAwardInfoLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function GetAwardInfoController:wakeModule()
	framework.setOnKeypadEventListener(GetAwardInfoLogic.view, GetAwardInfoLogic.onKeypad)
	GetAwardInfoLogic.view:setTouchEnabled(true)
end
