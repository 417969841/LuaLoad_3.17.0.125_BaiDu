module(...,package.seeall);

Load.LuaRequire("script.module.recharge.logic.SelectCarriersLogic");

SelectCarriersController = class("SelectCarriersController",BaseController);
SelectCarriersController.__index = SelectCarriersController;

SelectCarriersController.moduleLayer = nil;

function SelectCarriersController:reset()
	SelectCarriersLogic.view = nil;
end

function SelectCarriersController:getLayer()
	return SelectCarriersLogic.view;
end

function SelectCarriersController:createView()
	SelectCarriersLogic.createView();
	framework.setOnKeypadEventListener(SelectCarriersLogic.view, SelectCarriersLogic.onKeypad);
end

function SelectCarriersController:requestMsg()
	SelectCarriersLogic.requestMsg();
end

function SelectCarriersController:addSlot()
	SelectCarriersLogic.addSlot();
end

function SelectCarriersController:removeSlot()
	SelectCarriersLogic.removeSlot();
end

function SelectCarriersController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"Panel"), SelectCarriersLogic.callback_Panel, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"Panel_Bg"), SelectCarriersLogic.callback_Panel_Bg, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"CheckBox_YiDong"), SelectCarriersLogic.callback_CheckBox_YiDong, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"CheckBox_LianTong"), SelectCarriersLogic.callback_CheckBox_LianTong, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"CheckBox_DianXin"), SelectCarriersLogic.callback_CheckBox_DianXin, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"Button_OK"), SelectCarriersLogic.callback_Button_OK, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function SelectCarriersController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"Panel"), SelectCarriersLogic.callback_Panel, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"Panel_Bg"), SelectCarriersLogic.callback_Panel_Bg, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"CheckBox_YiDong"), SelectCarriersLogic.callback_CheckBox_YiDong, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"CheckBox_LianTong"), SelectCarriersLogic.callback_CheckBox_LianTong, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"CheckBox_DianXin"), SelectCarriersLogic.callback_CheckBox_DianXin, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(SelectCarriersLogic.view,"Button_OK"), SelectCarriersLogic.callback_Button_OK, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function SelectCarriersController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function SelectCarriersController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function SelectCarriersController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SelectCarriersLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(SelectCarriersLogic);
		SelectCarriersLogic.releaseData();
	end

	SelectCarriersLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function SelectCarriersController:sleepModule()
	framework.releaseOnKeypadEventListener(SelectCarriersLogic.view);
	SelectCarriersLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function SelectCarriersController:wakeModule()
	framework.setOnKeypadEventListener(SelectCarriersLogic.view, SelectCarriersLogic.onKeypad);
	SelectCarriersLogic.view:setTouchEnabled(true);
end
