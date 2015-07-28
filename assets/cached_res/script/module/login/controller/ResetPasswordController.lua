module(...,package.seeall)

Load.LuaRequire("script.module.login.logic.ResetPasswordLogic")

ResetPasswordController = class("ResetPasswordController",BaseController)
ResetPasswordController.__index = ResetPasswordController

ResetPasswordController.moduleLayer = nil

function ResetPasswordController:reset()
	ResetPasswordLogic.view = nil
end

function ResetPasswordController:getLayer()
	return ResetPasswordLogic.view
end

function ResetPasswordController:createView()
	ResetPasswordLogic.createView()
	framework.setOnKeypadEventListener(ResetPasswordLogic.view, ResetPasswordLogic.onKeypad)
end

function ResetPasswordController:requestMsg()
	ResetPasswordLogic.requestMsg()
end

function ResetPasswordController:addSlot()
	ResetPasswordLogic.addSlot()
end

function ResetPasswordController:removeSlot()
	ResetPasswordLogic.removeSlot()
end

function ResetPasswordController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"btn_more"),ResetPasswordLogic.callback_btn_more,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"btn_commit"),ResetPasswordLogic.callback_btn_commit,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"btn_cancel"),ResetPasswordLogic.callback_btn_cancel,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then  
		--framework.bindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"txt_username"),ResetPasswordLogic.callback_txt_username_ios,BUTTON_CLICK)
		--framework.bindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"txt_phonenum"),ResetPasswordLogic.callback_txt_phonenum_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		--framework.bindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"txt_username"),ResetPasswordLogic.callback_txt_username,DETACH_WITH_IME)
		--framework.bindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"txt_phonenum"),ResetPasswordLogic.callback_txt_phonenum,DETACH_WITH_IME)
	end
end

function ResetPasswordController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"btn_more"),ResetPasswordLogic.callback_btn_more,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"btn_commit"),ResetPasswordLogic.callback_btn_commit,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"btn_cancel"),ResetPasswordLogic.callback_btn_cancel,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		--framework.unbindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"txt_username"),ResetPasswordLogic.callback_txt_username_ios,BUTTON_CLICK)
		--framework.unbindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"txt_phonenum"),ResetPasswordLogic.callback_txt_phonenum_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		--framework.unbindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"txt_username"),ResetPasswordLogic.callback_txt_username,DETACH_WITH_IME)
		--framework.unbindEventCallback(cocostudio.getComponent(ResetPasswordLogic.view,"txt_phonenum"),ResetPasswordLogic.callback_txt_phonenum,DETACH_WITH_IME)
	end
end

function ResetPasswordController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function ResetPasswordController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function ResetPasswordController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ResetPasswordLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(ResetPasswordLogic);
		ResetPasswordLogic.releaseData();
	end

	ResetPasswordLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function ResetPasswordController:sleepModule()
	framework.releaseOnKeypadEventListener(ResetPasswordLogic.view)
	ResetPasswordLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function ResetPasswordController:wakeModule()
	framework.setOnKeypadEventListener(ResetPasswordLogic.view, ResetPasswordLogic.onKeypad)
	ResetPasswordLogic.view:setTouchEnabled(true)
end
