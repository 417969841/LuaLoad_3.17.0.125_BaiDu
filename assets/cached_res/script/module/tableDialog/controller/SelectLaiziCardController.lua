module(...,package.seeall)

Load.LuaRequire("script.module.tableDialog.logic.SelectLaiziCardLogic")

SelectLaiziCardController = class("SelectLaiziCardController",BaseController)
SelectLaiziCardController.__index = SelectLaiziCardController

SelectLaiziCardController.moduleLayer = nil

function SelectLaiziCardController:reset()
	SelectLaiziCardLogic.view = nil
end

function SelectLaiziCardController:getLayer()
	return SelectLaiziCardLogic.view
end

function SelectLaiziCardController:createView()
	SelectLaiziCardLogic.createView()
	framework.setOnKeypadEventListener(SelectLaiziCardLogic.view, SelectLaiziCardLogic.onKeypad)
end

function SelectLaiziCardController:requestMsg()
	SelectLaiziCardLogic.requestMsg()
end

function SelectLaiziCardController:addSlot()
	SelectLaiziCardLogic.addSlot()
end

function SelectLaiziCardController:removeSlot()
	SelectLaiziCardLogic.removeSlot()
end

function SelectLaiziCardController:addCallback()

end

function SelectLaiziCardController:removeCallback()

end

function SelectLaiziCardController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function SelectLaiziCardController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function SelectLaiziCardController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SelectLaiziCardLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(SelectLaiziCardLogic);
		SelectLaiziCardLogic.releaseData();
	end

	SelectLaiziCardLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function SelectLaiziCardController:sleepModule()
	framework.releaseOnKeypadEventListener(SelectLaiziCardLogic.view)
	SelectLaiziCardLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function SelectLaiziCardController:wakeModule()
	framework.setOnKeypadEventListener(SelectLaiziCardLogic.view, SelectLaiziCardLogic.onKeypad)
	SelectLaiziCardLogic.view:setTouchEnabled(true)
end
