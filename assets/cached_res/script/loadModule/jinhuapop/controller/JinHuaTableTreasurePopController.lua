module(...,package.seeall);

Load.LuaRequire("script.loadModule.jinhuapop.logic.JinHuaTableTreasurePopLogic");

JinHuaTableTreasurePopController = class("JinHuaTableTreasurePopController",BaseController);
JinHuaTableTreasurePopController.__index = JinHuaTableTreasurePopController;

JinHuaTableTreasurePopController.moduleLayer = nil;

function JinHuaTableTreasurePopController:reset()
	JinHuaTableTreasurePopLogic.view = nil;
end

function JinHuaTableTreasurePopController:getLayer()
	return JinHuaTableTreasurePopLogic.view;
end

function JinHuaTableTreasurePopController:createView()
	JinHuaTableTreasurePopLogic.createView();
	framework.setOnKeypadEventListener(JinHuaTableTreasurePopLogic.view, JinHuaTableTreasurePopLogic.onKeypad);
end

function JinHuaTableTreasurePopController:requestMsg()
	JinHuaTableTreasurePopLogic.requestMsg();
end

function JinHuaTableTreasurePopController:addSlot()
	JinHuaTableTreasurePopLogic.addSlot();
end

function JinHuaTableTreasurePopController:removeSlot()
	JinHuaTableTreasurePopLogic.removeSlot();
end

function JinHuaTableTreasurePopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableTreasurePopLogic.view,"btn_table_treasure_get_prize"), JinHuaTableTreasurePopLogic.callback_btn_table_treasure_get_prize, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function JinHuaTableTreasurePopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableTreasurePopLogic.view,"btn_table_treasure_get_prize"), JinHuaTableTreasurePopLogic.callback_btn_table_treasure_get_prize, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function JinHuaTableTreasurePopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function JinHuaTableTreasurePopController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function JinHuaTableTreasurePopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaTableTreasurePopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaTableTreasurePopLogic);
		JinHuaTableTreasurePopLogic.releaseData();
	end

	JinHuaTableTreasurePopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaTableTreasurePopController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaTableTreasurePopLogic.view);
	JinHuaTableTreasurePopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuaTableTreasurePopController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaTableTreasurePopLogic.view, JinHuaTableTreasurePopLogic.onKeypad);
	JinHuaTableTreasurePopLogic.view:setTouchEnabled(true);
end
