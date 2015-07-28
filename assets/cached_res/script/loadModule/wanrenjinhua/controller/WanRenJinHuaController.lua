module(...,package.seeall)

Load.LuaRequire("script.loadModule.wanrenjinhua.logic.WanRenJinHuaLogic")

WanRenJinHuaController = class("WanRenJinHuaController",BaseController)
WanRenJinHuaController.__index = WanRenJinHuaController

WanRenJinHuaController.moduleLayer = nil

function WanRenJinHuaController:reset()
	WanRenJinHuaLogic.view = nil
end

function WanRenJinHuaController:getLayer()
	return WanRenJinHuaLogic.view;
end

function WanRenJinHuaController:createView()
	Common.log("WanRenJinHua:createView")
	WanRenJinHuaLogic.createView()
	framework.setOnKeypadEventListener(WanRenJinHuaLogic.view, WanRenJinHuaLogic.onKeypad);
end

function WanRenJinHuaController:requestMsg()
	WanRenJinHuaLogic.requestMsg()
end

function WanRenJinHuaController:addSlot()
	WanRenJinHuaLogic.addSlot()
end

function WanRenJinHuaController:removeSlot()
	WanRenJinHuaLogic.removeSlot()
end

function WanRenJinHuaController:addCallback()
end

function WanRenJinHuaController:removeCallback()
end

function WanRenJinHuaController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function WanRenJinHuaController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function WanRenJinHuaController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(WanRenJinHuaLogic.view);
	Common.log("WanRenJinHua:destoryModule")
	self:destroy()
	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(WanRenJinHuaLogic);
		WanRenJinHuaLogic.releaseData();
	end

	WanRenJinHuaLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function WanRenJinHuaController:sleepModule()
	framework.releaseOnKeypadEventListener(WanRenJinHuaLogic.view);
	Common.log("WanRenJinHua:sleepModule")
	framework.emit(signal.common.Signal_SleepModule_Done)
	WanRenJinHuaLogic.setTouchEnable(false)
end

function WanRenJinHuaController:wakeModule()
	framework.setOnKeypadEventListener(WanRenJinHuaLogic.view, WanRenJinHuaLogic.onKeypad);
	Common.log("WanRenJinHua:wakeModule")
	WanRenJinHuaLogic.setTouchEnable(true)
end
