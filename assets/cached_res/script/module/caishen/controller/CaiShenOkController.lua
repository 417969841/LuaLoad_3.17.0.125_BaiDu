module(...,package.seeall)

Load.LuaRequire("script.module.caishen.logic.CaiShenOkLogic")

CaiShenOkController = class("CaiShenOkController",BaseController)
CaiShenOkController.__index = CaiShenOkController

CaiShenOkController.moduleLayer = nil

function CaiShenOkController:reset()
	CaiShenOkLogic.view = nil
end

function CaiShenOkController:getLayer()
	return CaiShenOkLogic.view
end

function CaiShenOkController:createView()
	CaiShenOkLogic.createView()
	framework.setOnKeypadEventListener(CaiShenOkLogic.view, CaiShenOkLogic.onKeypad)
end

function CaiShenOkController:requestMsg()
	CaiShenOkLogic.requestMsg()
end

function CaiShenOkController:addSlot()
	CaiShenOkLogic.addSlot()
end

function CaiShenOkController:removeSlot()
	CaiShenOkLogic.removeSlot()
end

function CaiShenOkController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CaiShenOkLogic.view,"BackButton"),CaiShenOkLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function CaiShenOkController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CaiShenOkLogic.view,"BackButton"),CaiShenOkLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function CaiShenOkController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function CaiShenOkController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function CaiShenOkController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CaiShenOkLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(CaiShenOkLogic);
		CaiShenOkLogic.releaseData();
	end

	CaiShenOkLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function CaiShenOkController:sleepModule()
	framework.releaseOnKeypadEventListener(CaiShenOkLogic.view)
	CaiShenOkLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function CaiShenOkController:wakeModule()
	framework.setOnKeypadEventListener(CaiShenOkLogic.view, CaiShenOkLogic.onKeypad)
	CaiShenOkLogic.view:setTouchEnabled(true)
end
