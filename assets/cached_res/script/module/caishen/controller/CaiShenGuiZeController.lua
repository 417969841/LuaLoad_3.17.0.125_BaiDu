module(...,package.seeall)

Load.LuaRequire("script.module.caishen.logic.CaiShenGuiZeLogic")

CaiShenGuiZeController = class("CaiShenGuiZeController",BaseController)
CaiShenGuiZeController.__index = CaiShenGuiZeController

CaiShenGuiZeController.moduleLayer = nil

function CaiShenGuiZeController:reset()
	CaiShenGuiZeLogic.view = nil
end

function CaiShenGuiZeController:getLayer()
	return CaiShenGuiZeLogic.view
end

function CaiShenGuiZeController:createView()
	CaiShenGuiZeLogic.createView()
	framework.setOnKeypadEventListener(CaiShenGuiZeLogic.view, CaiShenGuiZeLogic.onKeypad)
end

function CaiShenGuiZeController:requestMsg()
	CaiShenGuiZeLogic.requestMsg()
end

function CaiShenGuiZeController:addSlot()
	CaiShenGuiZeLogic.addSlot()
end

function CaiShenGuiZeController:removeSlot()
	CaiShenGuiZeLogic.removeSlot()
end

function CaiShenGuiZeController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CaiShenGuiZeLogic.view,"BackButton"),CaiShenGuiZeLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function CaiShenGuiZeController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CaiShenGuiZeLogic.view,"BackButton"),CaiShenGuiZeLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function CaiShenGuiZeController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function CaiShenGuiZeController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function CaiShenGuiZeController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CaiShenGuiZeLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(CaiShenGuiZeLogic);
		CaiShenGuiZeLogic.releaseData();
	end

	CaiShenGuiZeLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function CaiShenGuiZeController:sleepModule()
	framework.releaseOnKeypadEventListener(CaiShenGuiZeLogic.view)
	CaiShenGuiZeLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function CaiShenGuiZeController:wakeModule()
	framework.setOnKeypadEventListener(CaiShenGuiZeLogic.view, CaiShenGuiZeLogic.onKeypad)
	CaiShenGuiZeLogic.view:setTouchEnabled(true)
end
