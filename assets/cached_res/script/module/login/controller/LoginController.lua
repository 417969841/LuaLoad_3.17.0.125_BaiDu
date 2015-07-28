module(...,package.seeall)

Load.LuaRequire("script.module.login.logic.LoginLogic")

LoginController = class("LoginController",BaseController)
LoginController.__index = LoginController

LoginController.moduleLayer = nil

function LoginController:reset()
	LoginLogic.view = nil
end

function LoginController:getLayer()
	return LoginLogic.view
end

function LoginController:createView()
	LoginLogic.createView()
	framework.setOnKeypadEventListener(LoginLogic.view, LoginLogic.onKeypad)
end

function LoginController:requestMsg()
	LoginLogic.requestMsg()
end

function LoginController:addSlot()
	LoginLogic.addSlot()
end

function LoginController:removeSlot()
	LoginLogic.removeSlot()
end

function LoginController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"btn_login"),LoginLogic.callback_btn_login,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"btn_reg"),LoginLogic.callback_btn_reg,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"btn_more"),LoginLogic.callback_btn_more,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"text_resetpass"),LoginLogic.callback_text_resetpass,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_agrees"),LoginLogic.callback_text_useragreement,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"btn_setIp"), LoginLogic.callback_btn_setIp, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);

	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		--framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_username"),LoginLogic.callback_text_username_ios,BUTTON_CLICK)
		--framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_password"),LoginLogic.callback_text_password_ios,BUTTON_CLICK)
		--framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_ip"),LoginLogic.callback_txt_ip_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		--framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_username"),LoginLogic.callback_text_username,DETACH_WITH_IME)
		--framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_password"),LoginLogic.callback_text_password,DETACH_WITH_IME)
		--framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_ip"),LoginLogic.callback_txt_ip,DETACH_WITH_IME)
	end
end

function LoginController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"btn_login"),LoginLogic.callback_btn_login,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"btn_reg"),LoginLogic.callback_btn_reg,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"btn_more"),LoginLogic.callback_btn_more,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"text_resetpass"),LoginLogic.callback_text_resetpass,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_agrees"),LoginLogic.callback_text_useragreement,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"btn_setIp"), LoginLogic.callback_btn_setIp, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);

	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		--framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_username"),LoginLogic.callback_text_username_ios,BUTTON_CLICK)
		--framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_password"),LoginLogic.callback_text_password_ios,BUTTON_CLICK)
		--framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_ip"),LoginLogic.callback_txt_ip_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		--framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_username"),LoginLogic.callback_text_username,DETACH_WITH_IME)
		--framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_password"),LoginLogic.callback_text_password,DETACH_WITH_IME)
		--framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"txt_ip"),LoginLogic.callback_txt_ip,DETACH_WITH_IME)
	end
end

function LoginController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function LoginController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function LoginController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(LoginLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(LoginLogic);
		LoginLogic.releaseData();
	end

	LoginLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function LoginController:sleepModule()
	framework.releaseOnKeypadEventListener(LoginLogic.view)
	LoginLogic.view:setTouchEnabled(false)
	LoginLogic.setEditorEnable(false) --屏蔽输入框
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function LoginController:wakeModule()
	framework.setOnKeypadEventListener(LoginLogic.view, LoginLogic.onKeypad)
	LoginLogic.view:setTouchEnabled(true)
	LoginLogic.setEditorEnable(true)
end
