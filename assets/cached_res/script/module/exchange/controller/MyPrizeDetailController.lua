module(...,package.seeall)

Load.LuaRequire("script.module.exchange.logic.MyPrizeDetailLogic")

MyPrizeDetailController = class("MyPrizeDetailController",BaseController)
MyPrizeDetailController.__index = MyPrizeDetailController

MyPrizeDetailController.moduleLayer = nil

function MyPrizeDetailController:reset()
	MyPrizeDetailLogic.view = nil
end

function MyPrizeDetailController:getLayer()
	return MyPrizeDetailLogic.view
end

function MyPrizeDetailController:createView()
	MyPrizeDetailLogic.createView()
	framework.setOnKeypadEventListener(MyPrizeDetailLogic.view, MyPrizeDetailLogic.onKeypad)
end

function MyPrizeDetailController:requestMsg()
	MyPrizeDetailLogic.requestMsg()
end

function MyPrizeDetailController:addSlot()
	MyPrizeDetailLogic.addSlot()
end

function MyPrizeDetailController:removeSlot()
	MyPrizeDetailLogic.removeSlot()
end

function MyPrizeDetailController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MyPrizeDetailLogic.view,"btn_close"),MyPrizeDetailLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function MyPrizeDetailController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MyPrizeDetailLogic.view,"btn_close"),MyPrizeDetailLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function MyPrizeDetailController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function MyPrizeDetailController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function MyPrizeDetailController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MyPrizeDetailLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(MyPrizeDetailLogic);
		MyPrizeDetailLogic.releaseData();
	end

	MyPrizeDetailLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function MyPrizeDetailController:sleepModule()
	framework.releaseOnKeypadEventListener(MyPrizeDetailLogic.view)
	MyPrizeDetailLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function MyPrizeDetailController:wakeModule()
	framework.setOnKeypadEventListener(MyPrizeDetailLogic.view, MyPrizeDetailLogic.onKeypad)
	MyPrizeDetailLogic.view:setTouchEnabled(true)
end
