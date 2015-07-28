module(...,package.seeall)

Load.LuaRequire("script.module.tableDialog.logic.CertificateLogic")

CertificateController = class("CertificateController",BaseController)
CertificateController.__index = CertificateController

CertificateController.moduleLayer = nil

function CertificateController:reset()
	CertificateLogic.view = nil
end

function CertificateController:getLayer()
	return CertificateLogic.view
end

function CertificateController:createView()
	CertificateLogic.createView()
	framework.setOnKeypadEventListener(CertificateLogic.view, CertificateLogic.onKeypad)
end

function CertificateController:requestMsg()
	CertificateLogic.requestMsg()
end

function CertificateController:addSlot()
	CertificateLogic.addSlot()
end

function CertificateController:removeSlot()
	CertificateLogic.removeSlot()
end

function CertificateController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CertificateLogic.view,"Button_award"),CertificateLogic.callback_Button_award,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(CertificateLogic.view,"Button_again"), CertificateLogic.callback_Button_again, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CertificateController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CertificateLogic.view,"Button_award"),CertificateLogic.callback_Button_award,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(CertificateLogic.view,"Button_again"), CertificateLogic.callback_Button_again, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CertificateController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function CertificateController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function CertificateController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CertificateLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(CertificateLogic);
		CertificateLogic.releaseData();
	end

	CertificateLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function CertificateController:sleepModule()
	framework.releaseOnKeypadEventListener(CertificateLogic.view)
	CertificateLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function CertificateController:wakeModule()
	framework.setOnKeypadEventListener(CertificateLogic.view, CertificateLogic.onKeypad)
	CertificateLogic.view:setTouchEnabled(true)
end
