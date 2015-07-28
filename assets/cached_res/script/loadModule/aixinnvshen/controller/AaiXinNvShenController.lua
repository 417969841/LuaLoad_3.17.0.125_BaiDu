module(...,package.seeall)

Load.LuaRequire("script.loadModule.aixinnvshen.logic.AaiXinNvShenLogic")

AaiXinNvShenController = class("AaiXinNvShenController",BaseController)
AaiXinNvShenController.__index = AaiXinNvShenController

AaiXinNvShenController.moduleLayer = nil

function AaiXinNvShenController:reset()
	AaiXinNvShenLogic.view = nil
end

function AaiXinNvShenController:getLayer()
	return AaiXinNvShenLogic.view
end

function AaiXinNvShenController:createView()
	AaiXinNvShenLogic.createView()
	framework.setOnKeypadEventListener(AaiXinNvShenLogic.view, AaiXinNvShenLogic.onKeypad)
end

function AaiXinNvShenController:requestMsg()
	AaiXinNvShenLogic.requestMsg()
end

function AaiXinNvShenController:addSlot()
	AaiXinNvShenLogic.addSlot()
end

function AaiXinNvShenController:removeSlot()
	AaiXinNvShenLogic.removeSlot()
end

function AaiXinNvShenController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"BackButton"),AaiXinNvShenLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"Button_GuiZe"),AaiXinNvShenLogic.callback_Button_GuiZe,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"Button_ShuaXin"),AaiXinNvShenLogic.callback_Button_ShuaXin,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"Button_DaPai"),AaiXinNvShenLogic.callback_Button_DaPai,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"ImageView_1"),AaiXinNvShenLogic.callback_ImageView_1,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"ImageView_2"),AaiXinNvShenLogic.callback_ImageView_2,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"ImageView_3"),AaiXinNvShenLogic.callback_ImageView_3,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"ImageView_4"),AaiXinNvShenLogic.callback_ImageView_4,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_IN)
end

function AaiXinNvShenController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"BackButton"),AaiXinNvShenLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"Button_GuiZe"),AaiXinNvShenLogic.callback_Button_GuiZe,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"Button_ShuaXin"),AaiXinNvShenLogic.callback_Button_ShuaXin,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"Button_DaPai"),AaiXinNvShenLogic.callback_Button_DaPai,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"ImageView_1"),AaiXinNvShenLogic.callback_ImageView_1,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"ImageView_2"),AaiXinNvShenLogic.callback_ImageView_2,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"ImageView_3"),AaiXinNvShenLogic.callback_ImageView_3,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(AaiXinNvShenLogic.view,"ImageView_4"),AaiXinNvShenLogic.callback_ImageView_4,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_IN)

end

function AaiXinNvShenController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function AaiXinNvShenController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function AaiXinNvShenController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(AaiXinNvShenLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(AaiXinNvShenLogic);
		AaiXinNvShenLogic.releaseData();
	end

	AaiXinNvShenLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function AaiXinNvShenController:sleepModule()
	framework.releaseOnKeypadEventListener(AaiXinNvShenLogic.view)
	AaiXinNvShenLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function AaiXinNvShenController:wakeModule()
	framework.setOnKeypadEventListener(AaiXinNvShenLogic.view, AaiXinNvShenLogic.onKeypad)
	AaiXinNvShenLogic.view:setTouchEnabled(true)
end
