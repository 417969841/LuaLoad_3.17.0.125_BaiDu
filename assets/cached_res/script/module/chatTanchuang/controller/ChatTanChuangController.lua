module(...,package.seeall)

Load.LuaRequire("script.module.chatTanchuang.logic.ChatTanChuangLogic")

ChatTanChuangController = class("ChatTanChuangController",BaseController)
ChatTanChuangController.__index = ChatTanChuangController

ChatTanChuangController.moduleLayer = nil

function ChatTanChuangController:reset()
	ChatTanChuangLogic.view = nil
end

function ChatTanChuangController:getLayer()
	return ChatTanChuangLogic.view
end

function ChatTanChuangController:createView()
	ChatTanChuangLogic.createView()
	framework.setOnKeypadEventListener(ChatTanChuangLogic.view, ChatTanChuangLogic.onKeypad)
end

function ChatTanChuangController:requestMsg()
	ChatTanChuangLogic.requestMsg()
end

function ChatTanChuangController:addSlot()
	ChatTanChuangLogic.addSlot()
end

function ChatTanChuangController:removeSlot()
	ChatTanChuangLogic.removeSlot()
end

function ChatTanChuangController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ChatTanChuangLogic.view,"Panel_20"),ChatTanChuangLogic.callback_Panel_20,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ChatTanChuangLogic.view,"Button_PingBi"),ChatTanChuangLogic.callback_Button_PingBi,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ChatTanChuangLogic.view,"Button_JuBao"),ChatTanChuangLogic.callback_Button_JuBao,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ChatTanChuangLogic.view,"Button_ChaKan"),ChatTanChuangLogic.callback_Button_ChaKan,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function ChatTanChuangController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ChatTanChuangLogic.view,"Panel_20"),ChatTanChuangLogic.callback_Panel_20,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatTanChuangLogic.view,"Button_PingBi"),ChatTanChuangLogic.callback_Button_PingBi,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ChatTanChuangLogic.view,"Button_JuBao"),ChatTanChuangLogic.callback_Button_JuBao,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ChatTanChuangLogic.view,"Button_ChaKan"),ChatTanChuangLogic.callback_Button_ChaKan,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function ChatTanChuangController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function ChatTanChuangController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function ChatTanChuangController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ChatTanChuangLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(ChatTanChuangLogic);
		ChatTanChuangLogic.releaseData();
	end

	ChatTanChuangLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function ChatTanChuangController:sleepModule()
	framework.releaseOnKeypadEventListener(ChatTanChuangLogic.view)
	ChatTanChuangLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function ChatTanChuangController:wakeModule()
	framework.setOnKeypadEventListener(ChatTanChuangLogic.view, ChatTanChuangLogic.onKeypad)
	ChatTanChuangLogic.view:setTouchEnabled(true)
end
