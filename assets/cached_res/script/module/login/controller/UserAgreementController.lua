module(...,package.seeall)

Load.LuaRequire("script.module.login.logic.UserAgreementLogic")

UserAgreementController = class("UserAgreementController",BaseController)
UserAgreementController.__index = UserAgreementController

UserAgreementController.moduleLayer = nil

function UserAgreementController:reset()
	UserAgreementLogic.view = nil
end

function UserAgreementController:getLayer()
	return UserAgreementLogic.view
end

function UserAgreementController:createView()
	UserAgreementLogic.createView()
	framework.setOnKeypadEventListener(UserAgreementLogic.view, UserAgreementLogic.onKeypad)
end

function UserAgreementController:requestMsg()
	UserAgreementLogic.requestMsg()
end

function UserAgreementController:addSlot()
	UserAgreementLogic.addSlot()
end

function UserAgreementController:removeSlot()
	UserAgreementLogic.removeSlot()
end

function UserAgreementController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(UserAgreementLogic.view,"btn_close"),UserAgreementLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function UserAgreementController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(UserAgreementLogic.view,"btn_close"),UserAgreementLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function UserAgreementController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function UserAgreementController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function UserAgreementController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(UserAgreementLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(UserAgreementLogic);
		UserAgreementLogic.releaseData();
	end

	UserAgreementLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function UserAgreementController:sleepModule()
	framework.releaseOnKeypadEventListener(UserAgreementLogic.view)
	UserAgreementLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function UserAgreementController:wakeModule()
	framework.setOnKeypadEventListener(UserAgreementLogic.view, UserAgreementLogic.onKeypad)
	UserAgreementLogic.view:setTouchEnabled(true)
end
