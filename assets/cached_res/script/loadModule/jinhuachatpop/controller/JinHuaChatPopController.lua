module(...,package.seeall)

Load.LuaRequire("script.loadModule.jinhuachatpop.logic.JinHuaChatPopLogic")

JinHuaChatPopController = class("JinHuaChatPopController",BaseController)
JinHuaChatPopController.__index = JinHuaChatPopController

JinHuaChatPopController.moduleLayer = nil

function JinHuaChatPopController:reset()
	JinHuaChatPopLogic.view = nil
end

function JinHuaChatPopController:getLayer()
	return JinHuaChatPopLogic.view;
end

function JinHuaChatPopController:createView()
	JinHuaChatPopLogic.createView();
	framework.setOnKeypadEventListener(JinHuaChatPopLogic.view, JinHuaChatPopLogic.onKeypad);
end

function JinHuaChatPopController:requestMsg()
	JinHuaChatPopLogic.requestMsg()
end

function JinHuaChatPopController:addSlot()
	JinHuaChatPopLogic.addSlot()
end

function JinHuaChatPopController:removeSlot()
	JinHuaChatPopLogic.removeSlot()
end

function JinHuaChatPopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_close"),JinHuaChatPopLogic.callback_btn_close,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"iv_tab_biaoqing"),JinHuaChatPopLogic.callback_iv_tab_biaoqing,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"iv_tab_common"),JinHuaChatPopLogic.callback_iv_tab_common,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"iv_tab_log"),JinHuaChatPopLogic.callback_iv_tab_log,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"iv_biaoqing_tab_common"),JinHuaChatPopLogic.callback_iv_biaoqing_tab_common,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"iv_biaoqing_tab_superior"),JinHuaChatPopLogic.callback_iv_biaoqing_tab_superior,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_1"),JinHuaChatPopLogic.callback_btn_bq_common_1,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_2"),JinHuaChatPopLogic.callback_btn_bq_common_2,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_3"),JinHuaChatPopLogic.callback_btn_bq_common_3,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_4"),JinHuaChatPopLogic.callback_btn_bq_common_4,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_5"),JinHuaChatPopLogic.callback_btn_bq_common_5,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_6"),JinHuaChatPopLogic.callback_btn_bq_common_6,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_7"),JinHuaChatPopLogic.callback_btn_bq_common_7,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_8"),JinHuaChatPopLogic.callback_btn_bq_common_8,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_9"),JinHuaChatPopLogic.callback_btn_bq_common_9,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_10"),JinHuaChatPopLogic.callback_btn_bq_common_10,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_11"),JinHuaChatPopLogic.callback_btn_bq_common_11,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_12"),JinHuaChatPopLogic.callback_btn_bq_common_12,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_13"),JinHuaChatPopLogic.callback_btn_bq_common_13,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_14"),JinHuaChatPopLogic.callback_btn_bq_common_14,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_15"),JinHuaChatPopLogic.callback_btn_bq_common_15,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_16"),JinHuaChatPopLogic.callback_btn_bq_common_16,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_17"),JinHuaChatPopLogic.callback_btn_bq_common_17,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_18"),JinHuaChatPopLogic.callback_btn_bq_common_18,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_19"),JinHuaChatPopLogic.callback_btn_bq_common_19,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_20"),JinHuaChatPopLogic.callback_btn_bq_common_20,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_21"),JinHuaChatPopLogic.callback_btn_bq_common_21,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_22"),JinHuaChatPopLogic.callback_btn_bq_common_22,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_23"),JinHuaChatPopLogic.callback_btn_bq_common_23,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_24"),JinHuaChatPopLogic.callback_btn_bq_common_24,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_1"),JinHuaChatPopLogic.callback_btn_bq_superior_1,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_2"),JinHuaChatPopLogic.callback_btn_bq_superior_2,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_3"),JinHuaChatPopLogic.callback_btn_bq_superior_3,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_4"),JinHuaChatPopLogic.callback_btn_bq_superior_4,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_5"),JinHuaChatPopLogic.callback_btn_bq_superior_5,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_6"),JinHuaChatPopLogic.callback_btn_bq_superior_6,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_7"),JinHuaChatPopLogic.callback_btn_bq_superior_7,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_8"),JinHuaChatPopLogic.callback_btn_bq_superior_8,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_9"),JinHuaChatPopLogic.callback_btn_bq_superior_9,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_10"),JinHuaChatPopLogic.callback_btn_bq_superior_10,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_11"),JinHuaChatPopLogic.callback_btn_bq_superior_11,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_12"),JinHuaChatPopLogic.callback_btn_bq_superior_12,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_01"),JinHuaChatPopLogic.callback_tv_common_1,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_02"),JinHuaChatPopLogic.callback_tv_common_2,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_03"),JinHuaChatPopLogic.callback_tv_common_3,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_04"),JinHuaChatPopLogic.callback_tv_common_4,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_05"),JinHuaChatPopLogic.callback_tv_common_5,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_06"),JinHuaChatPopLogic.callback_tv_common_6,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_07"),JinHuaChatPopLogic.callback_tv_common_7,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_08"),JinHuaChatPopLogic.callback_tv_common_8,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_09"),JinHuaChatPopLogic.callback_tv_common_9,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_10"),JinHuaChatPopLogic.callback_tv_common_10,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_11"),JinHuaChatPopLogic.callback_tv_common_11,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_12"),JinHuaChatPopLogic.callback_tv_common_12,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_13"),JinHuaChatPopLogic.callback_tv_common_13,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_14"),JinHuaChatPopLogic.callback_tv_common_14,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_15"),JinHuaChatPopLogic.callback_tv_common_15,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_16"),JinHuaChatPopLogic.callback_tv_common_16,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_17"),JinHuaChatPopLogic.callback_tv_common_17,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_sendmsg_common"),JinHuaChatPopLogic.callback_btn_sendmsg_common,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_sendmsg_log"),JinHuaChatPopLogic.callback_btn_sendmsg_log,BUTTON_CLICK)
end

function JinHuaChatPopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_close"),JinHuaChatPopLogic.callback_btn_close,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"iv_tab_biaoqing"),JinHuaChatPopLogic.callback_iv_tab_biaoqing,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"iv_tab_common"),JinHuaChatPopLogic.callback_iv_tab_common,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"iv_tab_log"),JinHuaChatPopLogic.callback_iv_tab_log,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"iv_biaoqing_tab_common"),JinHuaChatPopLogic.callback_iv_biaoqing_tab_common,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"iv_biaoqing_tab_superior"),JinHuaChatPopLogic.callback_iv_biaoqing_tab_superior,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_1"),JinHuaChatPopLogic.callback_btn_bq_common_1,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_2"),JinHuaChatPopLogic.callback_btn_bq_common_2,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_3"),JinHuaChatPopLogic.callback_btn_bq_common_3,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_4"),JinHuaChatPopLogic.callback_btn_bq_common_4,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_5"),JinHuaChatPopLogic.callback_btn_bq_common_5,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_6"),JinHuaChatPopLogic.callback_btn_bq_common_6,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_7"),JinHuaChatPopLogic.callback_btn_bq_common_7,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_8"),JinHuaChatPopLogic.callback_btn_bq_common_8,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_9"),JinHuaChatPopLogic.callback_btn_bq_common_9,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_10"),JinHuaChatPopLogic.callback_btn_bq_common_10,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_11"),JinHuaChatPopLogic.callback_btn_bq_common_11,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_12"),JinHuaChatPopLogic.callback_btn_bq_common_12,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_13"),JinHuaChatPopLogic.callback_btn_bq_common_13,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_14"),JinHuaChatPopLogic.callback_btn_bq_common_14,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_15"),JinHuaChatPopLogic.callback_btn_bq_common_15,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_16"),JinHuaChatPopLogic.callback_btn_bq_common_16,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_17"),JinHuaChatPopLogic.callback_btn_bq_common_17,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_18"),JinHuaChatPopLogic.callback_btn_bq_common_18,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_19"),JinHuaChatPopLogic.callback_btn_bq_common_19,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_20"),JinHuaChatPopLogic.callback_btn_bq_common_20,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_21"),JinHuaChatPopLogic.callback_btn_bq_common_21,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_22"),JinHuaChatPopLogic.callback_btn_bq_common_22,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_23"),JinHuaChatPopLogic.callback_btn_bq_common_23,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_common_24"),JinHuaChatPopLogic.callback_btn_bq_common_24,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_1"),JinHuaChatPopLogic.callback_btn_bq_superior_1,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_2"),JinHuaChatPopLogic.callback_btn_bq_superior_2,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_3"),JinHuaChatPopLogic.callback_btn_bq_superior_3,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_4"),JinHuaChatPopLogic.callback_btn_bq_superior_4,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_5"),JinHuaChatPopLogic.callback_btn_bq_superior_5,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_6"),JinHuaChatPopLogic.callback_btn_bq_superior_6,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_7"),JinHuaChatPopLogic.callback_btn_bq_superior_7,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_8"),JinHuaChatPopLogic.callback_btn_bq_superior_8,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_9"),JinHuaChatPopLogic.callback_btn_bq_superior_9,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_10"),JinHuaChatPopLogic.callback_btn_bq_superior_10,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_11"),JinHuaChatPopLogic.callback_btn_bq_superior_11,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_bq_superior_12"),JinHuaChatPopLogic.callback_btn_bq_superior_12,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_01"),JinHuaChatPopLogic.callback_tv_common_1,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_02"),JinHuaChatPopLogic.callback_tv_common_2,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_03"),JinHuaChatPopLogic.callback_tv_common_3,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_04"),JinHuaChatPopLogic.callback_tv_common_4,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_05"),JinHuaChatPopLogic.callback_tv_common_5,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_06"),JinHuaChatPopLogic.callback_tv_common_6,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_07"),JinHuaChatPopLogic.callback_tv_common_7,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_08"),JinHuaChatPopLogic.callback_tv_common_8,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_09"),JinHuaChatPopLogic.callback_tv_common_9,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_10"),JinHuaChatPopLogic.callback_tv_common_10,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_11"),JinHuaChatPopLogic.callback_tv_common_11,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_12"),JinHuaChatPopLogic.callback_tv_common_12,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_13"),JinHuaChatPopLogic.callback_tv_common_13,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_14"),JinHuaChatPopLogic.callback_tv_common_14,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_15"),JinHuaChatPopLogic.callback_tv_common_15,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_16"),JinHuaChatPopLogic.callback_tv_common_16,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"tv_common_17"),JinHuaChatPopLogic.callback_tv_common_17,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_sendmsg_common"),JinHuaChatPopLogic.callback_btn_sendmsg_common,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaChatPopLogic.view,"btn_sendmsg_log"),JinHuaChatPopLogic.callback_btn_sendmsg_log,BUTTON_CLICK)
end

function JinHuaChatPopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function JinHuaChatPopController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function JinHuaChatPopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaChatPopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaChatPopLogic);
		JinHuaChatPopLogic.releaseData();
	end

	JinHuaChatPopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaChatPopController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaChatPopLogic.view);
	JinHuaChatPopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuaChatPopController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaChatPopLogic.view, JinHuaChatPopLogic.onKeypad);
	JinHuaChatPopLogic.view:setTouchEnabled(true);
end
