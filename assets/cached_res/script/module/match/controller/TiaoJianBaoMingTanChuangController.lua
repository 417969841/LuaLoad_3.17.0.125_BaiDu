module(...,package.seeall)

Load.LuaRequire("script.module.match.logic.TiaoJianBaoMingTanChuangLogic")

TiaoJianBaoMingTanChuangController = class("TiaoJianBaoMingTanChuangController",BaseController)
TiaoJianBaoMingTanChuangController.__index = TiaoJianBaoMingTanChuangController

TiaoJianBaoMingTanChuangController.moduleLayer = nil

function TiaoJianBaoMingTanChuangController:reset()
	TiaoJianBaoMingTanChuangLogic.view = nil
end

function TiaoJianBaoMingTanChuangController:getLayer()
	return TiaoJianBaoMingTanChuangLogic.view
end

function TiaoJianBaoMingTanChuangController:createView()
	TiaoJianBaoMingTanChuangLogic.createView()
	framework.setOnKeypadEventListener(TiaoJianBaoMingTanChuangLogic.view, TiaoJianBaoMingTanChuangLogic.onKeypad)
end

function TiaoJianBaoMingTanChuangController:requestMsg()
	TiaoJianBaoMingTanChuangLogic.requestMsg()
end

function TiaoJianBaoMingTanChuangController:addSlot()
	TiaoJianBaoMingTanChuangLogic.addSlot()
end

function TiaoJianBaoMingTanChuangController:removeSlot()
	TiaoJianBaoMingTanChuangLogic.removeSlot()
end

function TiaoJianBaoMingTanChuangController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TiaoJianBaoMingTanChuangLogic.view,"btn_close"),TiaoJianBaoMingTanChuangLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(TiaoJianBaoMingTanChuangLogic.view,"btn_go"),TiaoJianBaoMingTanChuangLogic.callback_btn_go,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TiaoJianBaoMingTanChuangController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TiaoJianBaoMingTanChuangLogic.view,"btn_close"),TiaoJianBaoMingTanChuangLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(TiaoJianBaoMingTanChuangLogic.view,"btn_go"),TiaoJianBaoMingTanChuangLogic.callback_btn_go,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TiaoJianBaoMingTanChuangController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function TiaoJianBaoMingTanChuangController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function TiaoJianBaoMingTanChuangController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TiaoJianBaoMingTanChuangLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TiaoJianBaoMingTanChuangLogic);
		TiaoJianBaoMingTanChuangLogic.releaseData();
	end

	TiaoJianBaoMingTanChuangLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function TiaoJianBaoMingTanChuangController:sleepModule()
	framework.releaseOnKeypadEventListener(TiaoJianBaoMingTanChuangLogic.view)
	TiaoJianBaoMingTanChuangLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function TiaoJianBaoMingTanChuangController:wakeModule()
	framework.setOnKeypadEventListener(TiaoJianBaoMingTanChuangLogic.view, TiaoJianBaoMingTanChuangLogic.onKeypad)
	TiaoJianBaoMingTanChuangLogic.view:setTouchEnabled(true)
end
