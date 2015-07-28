module(...,package.seeall)

Load.LuaRequire("script.module.userinfo.logic.TiantiZigeNotLogic")

--管理器

TiantiZigeNotController = class("TiantiZigeNotController",BaseController)
TiantiZigeNotController.__index = TiantiZigeNotController

TiantiZigeNotController.moduleLayer = nil

function TiantiZigeNotController:reset()
	TiantiZigeNotLogic.view = nil
end

function TiantiZigeNotController:getLayer()
	return TiantiZigeNotLogic.view
end

function TiantiZigeNotController:createView()
	TiantiZigeNotLogic.createView()
	framework.setOnKeypadEventListener(TiantiZigeNotLogic.view, TiantiZigeNotLogic.onKeypad)
end

function TiantiZigeNotController:requestMsg()
	TiantiZigeNotLogic.requestMsg()
end

function TiantiZigeNotController:addSlot()
	TiantiZigeNotLogic.addSlot()
end

function TiantiZigeNotController:removeSlot()
	TiantiZigeNotLogic.removeSlot()
end

function TiantiZigeNotController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TiantiZigeNotLogic.view,"btn_close"),TiantiZigeNotLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(TiantiZigeNotLogic.view,"btn_cz"),TiantiZigeNotLogic.callback_btn_go,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TiantiZigeNotController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TiantiZigeNotLogic.view,"btn_close"),TiantiZigeNotLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(TiantiZigeNotLogic.view,"btn_cz"),TiantiZigeNotLogic.callback_btn_go,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TiantiZigeNotController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function TiantiZigeNotController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function TiantiZigeNotController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TiantiZigeNotLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TiantiZigeNotLogic);
		TiantiZigeNotLogic.releaseData();
	end

	TiantiZigeNotLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function TiantiZigeNotController:sleepModule()
	framework.releaseOnKeypadEventListener(TiantiZigeNotLogic.view)
	TiantiZigeNotLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function TiantiZigeNotController:wakeModule()
	framework.setOnKeypadEventListener(TiantiZigeNotLogic.view, TiantiZigeNotLogic.onKeypad)
	TiantiZigeNotLogic.view:setTouchEnabled(true)
end
