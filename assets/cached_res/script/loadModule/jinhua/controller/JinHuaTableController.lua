module(...,package.seeall)

Load.LuaRequire("script.loadModule.jinhua.logic.JinHuaTableLogic")

JinHuaTableController = class("JinHuaTableController",BaseController)
JinHuaTableController.__index = JinHuaTableController

JinHuaTableController.moduleLayer = nil

function JinHuaTableController:reset()
	JinHuaTableLogic.view = nil
end

function JinHuaTableController:getLayer()
	return JinHuaTableLogic.view;
end

function JinHuaTableController:createView()
	JinHuaTableLogic.createView()
	framework.setOnKeypadEventListener(JinHuaTableLogic.view, JinHuaTableLogic.onKeypad);
end

function JinHuaTableController:requestMsg()
	JinHuaTableLogic.requestMsg()
end

function JinHuaTableController:addSlot()
	JinHuaTableLogic.addSlot()
end

function JinHuaTableController:removeSlot()
	JinHuaTableLogic.removeSlot()
end

function JinHuaTableController:addCallback()
end

function JinHuaTableController:removeCallback()
end

function JinHuaTableController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function JinHuaTableController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function JinHuaTableController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaTableLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaTableLogic);
		JinHuaTableLogic.releaseData();
	end

	JinHuaTableLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaTableController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaTableLogic.view);
    -- 新手引导
	--    if UserGuideUtil.isUserGuide == false then
	--    	JinHuaTableLogic.getTableParentLayer():setTouchEnabled(false)
	--    	JinHuaTableButtonGroup.getButtonGroupSprite():setEnabled(false)
	--    end
    JinHuaTableLogic.getTableParentLayer():setTouchEnabled(false)
    JinHuaTableButtonGroup.getButtonGroupSprite():setEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function JinHuaTableController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaTableLogic.view, JinHuaTableLogic.onKeypad);
	JinHuaTableLogic.getTableParentLayer():setTouchEnabled(true)
	JinHuaTableButtonGroup.getButtonGroupSprite():setEnabled(true)
end
