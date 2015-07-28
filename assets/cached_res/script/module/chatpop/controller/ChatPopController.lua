module(...,package.seeall)

Load.LuaRequire("script.module.chatpop.logic.ChatPopLogic")

ChatPopController = class("ChatPopController",BaseController)
ChatPopController.__index = ChatPopController

ChatPopController.moduleLayer = nil

function ChatPopController:reset()
	ChatPopLogic.view = nil
end

function ChatPopController:getLayer()
	return ChatPopLogic.view
end

function ChatPopController:createView()
	ChatPopLogic.createView()
	framework.setOnKeypadEventListener(ChatPopLogic.view, ChatPopLogic.onKeypad)
end

function ChatPopController:requestMsg()
	ChatPopLogic.requestMsg()
end

function ChatPopController:addSlot()
	ChatPopLogic.addSlot()
end

function ChatPopController:removeSlot()
	ChatPopLogic.removeSlot()
end

function ChatPopController:addCallback()
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"et_msg_common"),ChatPopLogic.callback_et_msg_common_ios,BUTTON_CLICK)
		framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"et_msg_log"),ChatPopLogic.callback_et_msg_log_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"et_msg_common"),ChatPopLogic.callback_et_msg_common,DETACH_WITH_IME)
		framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"et_msg_log"),ChatPopLogic.callback_et_msg_log,DETACH_WITH_IME)
	end

	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_close"),ChatPopLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"iv_tab_biaoqing"),ChatPopLogic.callback_iv_tab_biaoqing,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"iv_tab_common"),ChatPopLogic.callback_iv_tab_common,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"iv_tab_log"),ChatPopLogic.callback_iv_tab_log,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"iv_biaoqing_tab_common"),ChatPopLogic.callback_iv_biaoqing_tab_common,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"iv_biaoqing_tab_superior"),ChatPopLogic.callback_iv_biaoqing_tab_superior,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_1"),ChatPopLogic.callback_btn_bq_common_1,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_2"),ChatPopLogic.callback_btn_bq_common_2,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_3"),ChatPopLogic.callback_btn_bq_common_3,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_4"),ChatPopLogic.callback_btn_bq_common_4,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_5"),ChatPopLogic.callback_btn_bq_common_5,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_6"),ChatPopLogic.callback_btn_bq_common_6,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_7"),ChatPopLogic.callback_btn_bq_common_7,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_8"),ChatPopLogic.callback_btn_bq_common_8,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_9"),ChatPopLogic.callback_btn_bq_common_9,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_10"),ChatPopLogic.callback_btn_bq_common_10,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_11"),ChatPopLogic.callback_btn_bq_common_11,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_12"),ChatPopLogic.callback_btn_bq_common_12,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_13"),ChatPopLogic.callback_btn_bq_common_13,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_14"),ChatPopLogic.callback_btn_bq_common_14,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_15"),ChatPopLogic.callback_btn_bq_common_15,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_16"),ChatPopLogic.callback_btn_bq_common_16,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_17"),ChatPopLogic.callback_btn_bq_common_17,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_18"),ChatPopLogic.callback_btn_bq_common_18,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_19"),ChatPopLogic.callback_btn_bq_common_19,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_20"),ChatPopLogic.callback_btn_bq_common_20,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_21"),ChatPopLogic.callback_btn_bq_common_21,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_22"),ChatPopLogic.callback_btn_bq_common_22,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_23"),ChatPopLogic.callback_btn_bq_common_23,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_24"),ChatPopLogic.callback_btn_bq_common_24,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_1"),ChatPopLogic.callback_btn_bq_superior_1,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_2"),ChatPopLogic.callback_btn_bq_superior_2,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_3"),ChatPopLogic.callback_btn_bq_superior_3,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_4"),ChatPopLogic.callback_btn_bq_superior_4,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_5"),ChatPopLogic.callback_btn_bq_superior_5,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_6"),ChatPopLogic.callback_btn_bq_superior_6,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_7"),ChatPopLogic.callback_btn_bq_superior_7,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_8"),ChatPopLogic.callback_btn_bq_superior_8,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_9"),ChatPopLogic.callback_btn_bq_superior_9,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_10"),ChatPopLogic.callback_btn_bq_superior_10,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_11"),ChatPopLogic.callback_btn_bq_superior_11,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_12"),ChatPopLogic.callback_btn_bq_superior_12,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_01"),ChatPopLogic.callback_tv_common_1,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_02"),ChatPopLogic.callback_tv_common_2,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_03"),ChatPopLogic.callback_tv_common_3,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_04"),ChatPopLogic.callback_tv_common_4,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_05"),ChatPopLogic.callback_tv_common_5,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_06"),ChatPopLogic.callback_tv_common_6,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_07"),ChatPopLogic.callback_tv_common_7,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_08"),ChatPopLogic.callback_tv_common_8,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_09"),ChatPopLogic.callback_tv_common_9,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_10"),ChatPopLogic.callback_tv_common_10,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_11"),ChatPopLogic.callback_tv_common_11,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_12"),ChatPopLogic.callback_tv_common_12,BUTTON_CLICK, ANIMATION_PREFIX * 2)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_sendmsg_common"),ChatPopLogic.callback_btn_sendmsg_common,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_sendmsg_log"),ChatPopLogic.callback_btn_sendmsg_log,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_buygaoji"),ChatPopLogic.callback_btn_buygaoji,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function ChatPopController:removeCallback()
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"et_msg_common"),ChatPopLogic.callback_et_msg_common_ios,BUTTON_CLICK)
		framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"et_msg_log"),ChatPopLogic.callback_et_msg_log_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"et_msg_common"),ChatPopLogic.callback_et_msg_common,DETACH_WITH_IME)
		framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"et_msg_log"),ChatPopLogic.callback_et_msg_log,DETACH_WITH_IME)
	end

	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_close"),ChatPopLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"iv_tab_biaoqing"),ChatPopLogic.callback_iv_tab_biaoqing,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"iv_tab_common"),ChatPopLogic.callback_iv_tab_common,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"iv_tab_log"),ChatPopLogic.callback_iv_tab_log,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"iv_biaoqing_tab_common"),ChatPopLogic.callback_iv_biaoqing_tab_common,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"iv_biaoqing_tab_superior"),ChatPopLogic.callback_iv_biaoqing_tab_superior,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_1"),ChatPopLogic.callback_btn_bq_common_1,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_2"),ChatPopLogic.callback_btn_bq_common_2,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_3"),ChatPopLogic.callback_btn_bq_common_3,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_4"),ChatPopLogic.callback_btn_bq_common_4,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_5"),ChatPopLogic.callback_btn_bq_common_5,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_6"),ChatPopLogic.callback_btn_bq_common_6,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_7"),ChatPopLogic.callback_btn_bq_common_7,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_8"),ChatPopLogic.callback_btn_bq_common_8,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_9"),ChatPopLogic.callback_btn_bq_common_9,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_10"),ChatPopLogic.callback_btn_bq_common_10,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_11"),ChatPopLogic.callback_btn_bq_common_11,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_12"),ChatPopLogic.callback_btn_bq_common_12,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_13"),ChatPopLogic.callback_btn_bq_common_13,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_14"),ChatPopLogic.callback_btn_bq_common_14,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_15"),ChatPopLogic.callback_btn_bq_common_15,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_16"),ChatPopLogic.callback_btn_bq_common_16,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_17"),ChatPopLogic.callback_btn_bq_common_17,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_18"),ChatPopLogic.callback_btn_bq_common_18,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_19"),ChatPopLogic.callback_btn_bq_common_19,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_20"),ChatPopLogic.callback_btn_bq_common_20,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_21"),ChatPopLogic.callback_btn_bq_common_21,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_22"),ChatPopLogic.callback_btn_bq_common_22,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_23"),ChatPopLogic.callback_btn_bq_common_23,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_common_24"),ChatPopLogic.callback_btn_bq_common_24,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_1"),ChatPopLogic.callback_btn_bq_superior_1,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_2"),ChatPopLogic.callback_btn_bq_superior_2,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_3"),ChatPopLogic.callback_btn_bq_superior_3,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_4"),ChatPopLogic.callback_btn_bq_superior_4,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_5"),ChatPopLogic.callback_btn_bq_superior_5,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_6"),ChatPopLogic.callback_btn_bq_superior_6,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_7"),ChatPopLogic.callback_btn_bq_superior_7,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_8"),ChatPopLogic.callback_btn_bq_superior_8,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_9"),ChatPopLogic.callback_btn_bq_superior_9,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_10"),ChatPopLogic.callback_btn_bq_superior_10,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_11"),ChatPopLogic.callback_btn_bq_superior_11,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_bq_superior_12"),ChatPopLogic.callback_btn_bq_superior_12,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_01"),ChatPopLogic.callback_tv_common_1,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_02"),ChatPopLogic.callback_tv_common_2,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_03"),ChatPopLogic.callback_tv_common_3,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_04"),ChatPopLogic.callback_tv_common_4,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_05"),ChatPopLogic.callback_tv_common_5,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_06"),ChatPopLogic.callback_tv_common_6,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_07"),ChatPopLogic.callback_tv_common_7,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_08"),ChatPopLogic.callback_tv_common_8,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_09"),ChatPopLogic.callback_tv_common_9,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_10"),ChatPopLogic.callback_tv_common_10,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_11"),ChatPopLogic.callback_tv_common_11,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"tv_common_12"),ChatPopLogic.callback_tv_common_12,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_sendmsg_common"),ChatPopLogic.callback_btn_sendmsg_common,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_sendmsg_log"),ChatPopLogic.callback_btn_sendmsg_log,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ChatPopLogic.view,"btn_buygaoji"),ChatPopLogic.callback_btn_buygaoji,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

end

function ChatPopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function ChatPopController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function ChatPopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ChatPopLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(ChatPopLogic);
		ChatPopLogic.releaseData();
	end

	ChatPopLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function ChatPopController:sleepModule()
	framework.releaseOnKeypadEventListener(ChatPopLogic.view)
	ChatPopLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function ChatPopController:wakeModule()
	framework.setOnKeypadEventListener(ChatPopLogic.view, ChatPopLogic.onKeypad)
	ChatPopLogic.view:setTouchEnabled(true)
end
