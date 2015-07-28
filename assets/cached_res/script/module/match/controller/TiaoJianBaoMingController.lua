module(...,package.seeall)

Load.LuaRequire("script.module.match.logic.TiaoJianBaoMingLogic")

TiaoJianBaoMingController = class("TiaoJianBaoMingController",BaseController)
TiaoJianBaoMingController.__index = TiaoJianBaoMingController

TiaoJianBaoMingController.moduleLayer = nil

function TiaoJianBaoMingController:reset()
	TiaoJianBaoMingLogic.view = nil
end

function TiaoJianBaoMingController:getLayer()
	return TiaoJianBaoMingLogic.view
end

function TiaoJianBaoMingController:createView()
	TiaoJianBaoMingLogic.createView()
	framework.setOnKeypadEventListener(TiaoJianBaoMingLogic.view, TiaoJianBaoMingLogic.onKeypad)
end

function TiaoJianBaoMingController:requestMsg()
	TiaoJianBaoMingLogic.requestMsg()
end

function TiaoJianBaoMingController:addSlot()
	TiaoJianBaoMingLogic.addSlot()
end

function TiaoJianBaoMingController:removeSlot()
	TiaoJianBaoMingLogic.removeSlot()
end

function TiaoJianBaoMingController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TiaoJianBaoMingLogic.view,"BackButton"),TiaoJianBaoMingLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TiaoJianBaoMingController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TiaoJianBaoMingLogic.view,"BackButton"),TiaoJianBaoMingLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TiaoJianBaoMingController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function TiaoJianBaoMingController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function TiaoJianBaoMingController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TiaoJianBaoMingLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TiaoJianBaoMingLogic);
		TiaoJianBaoMingLogic.releaseData();
	end

	TiaoJianBaoMingLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function TiaoJianBaoMingController:sleepModule()
	framework.releaseOnKeypadEventListener(TiaoJianBaoMingLogic.view)
	TiaoJianBaoMingLogic.view:setTouchEnabled(false)
	if(TiaoJianBaoMingLogic.tableView)then
		TiaoJianBaoMingLogic.tableView:setTouchEnabled(false)
		TiaoJianBaoMingLogic.sleep(true)
	end
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function TiaoJianBaoMingController:wakeModule()
	framework.setOnKeypadEventListener(TiaoJianBaoMingLogic.view, TiaoJianBaoMingLogic.onKeypad)
	if(TiaoJianBaoMingLogic.tableView)then
		TiaoJianBaoMingLogic.tableView:setTouchEnabled(true)
		TiaoJianBaoMingLogic.sleep(false)
	end
	TiaoJianBaoMingLogic.view:setTouchEnabled(true)
end
