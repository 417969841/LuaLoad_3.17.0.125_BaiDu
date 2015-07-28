module(...,package.seeall)

Load.LuaRequire("script.module.table.logic.TableLogic")

TableController = class("TableController", BaseController)
TableController.__index = TableController

TableController.moduleLayer = nil

function TableController:reset()
	TableLogic.view = nil
end

function TableController:getLayer()
	return TableLogic.view
end

function TableController:createView()
	TableLogic.createView()
	framework.setOnKeypadEventListener(TableLogic.view, TableLogic.onKeypad)
end

function TableController:requestMsg()
	TableLogic.requestMsg()
end

function TableController:addSlot()
	TableLogic.addSlot()
end

function TableController:removeSlot()
	TableLogic.removeSlot()
end

function TableController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"button_recharge"), TableLogic.callback_button_recharge, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_match_ranking"), TableLogic.callback_btn_match_ranking, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"Button_jipaizi_lijigoumai_0"), TableLogic.callback_Button_jipaizi_lijigoumai_0, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(jipaiqiLogic.view,"Button_30"), TableLogic.callback_Button_jipaizi_add, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"Button_top_show"), TableLogic.callback_Button_top_show, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"button_exit"), TableLogic.callback_button_exit, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"button_chat"), TableLogic.callback_button_chat, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"button_setting"), TableLogic.callback_button_setting, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"button_tuoguan"), TableLogic.callback_button_tuoguan, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"Panel_Table_Info"), TableLogic.callback_Panel_Table_Info, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"button_gift"), TableLogic.callback_button_gift, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_game_start_kick2"), TableLogic.callback_btn_game_start_kick2, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_game_start_kick1"), TableLogic.callback_btn_game_start_kick1, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_game_start"), TableLogic.callback_btn_game_start, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_Trust_Play"), TableLogic.callback_btn_Trust_Play, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_open_initcard"), TableLogic.callback_btn_open_initcard, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_open_takeout_right"), TableLogic.callback_btn_open_takeout_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_open_takeout_left"), TableLogic.callback_btn_open_takeout_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_doublescore_right"), TableLogic.callback_btn_doublescore_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_doublescore_centre"), TableLogic.callback_btn_doublescore_centre, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_doublescore_left"), TableLogic.callback_btn_doublescore_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_grab_landlord_left"), TableLogic.callback_btn_grab_landlord_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_grab_landlord_right"), TableLogic.callback_btn_grab_landlord_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_call_landlord_left"), TableLogic.callback_btn_call_landlord_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_call_landlord_right"), TableLogic.callback_btn_call_landlord_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_callscore_right"), TableLogic.callback_btn_callscore_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_callscore_centre_right"), TableLogic.callback_btn_callscore_centre_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_callscore_centre_left"), TableLogic.callback_btn_callscore_centre_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_callscore_left"), TableLogic.callback_btn_callscore_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_opencard_start_right"), TableLogic.callback_btn_opencard_start_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_opencard_start_left"), TableLogic.callback_btn_opencard_start_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_takeout_right"), TableLogic.callback_btn_takeout_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_takeout_centre"), TableLogic.callback_btn_takeout_centre, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_takeout_left"), TableLogic.callback_btn_takeout_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.bindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_PassCard"), TableLogic.callback_btn_PassCard, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
end

function TableController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"button_recharge"), TableLogic.callback_button_recharge, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_match_ranking"), TableLogic.callback_btn_match_ranking, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"Button_jipaizi_lijigoumai_0"), TableLogic.callback_Button_jipaizi_lijigoumai_0, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(jipaiqiLogic.view,"Button_30"), TableLogic.callback_Button_jipaizi_add, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"Button_top_show"), TableLogic.callback_Button_top_show, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"button_exit"), TableLogic.callback_button_exit, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"button_chat"), TableLogic.callback_button_chat, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"button_setting"), TableLogic.callback_button_setting, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"button_tuoguan"), TableLogic.callback_button_tuoguan, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"Panel_Table_Info"), TableLogic.callback_Panel_Table_Info, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"button_gift"), TableLogic.callback_button_gift, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_game_start_kick2"), TableLogic.callback_btn_game_start_kick2, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_game_start_kick1"), TableLogic.callback_btn_game_start_kick1, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_game_start"), TableLogic.callback_btn_game_start, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_Trust_Play"), TableLogic.callback_btn_Trust_Play, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_open_initcard"), TableLogic.callback_btn_open_initcard, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_open_takeout_right"), TableLogic.callback_btn_open_takeout_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_open_takeout_left"), TableLogic.callback_btn_open_takeout_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_doublescore_right"), TableLogic.callback_btn_doublescore_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_doublescore_centre"), TableLogic.callback_btn_doublescore_centre, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_doublescore_left"), TableLogic.callback_btn_doublescore_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_grab_landlord_left"), TableLogic.callback_btn_grab_landlord_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_grab_landlord_right"), TableLogic.callback_btn_grab_landlord_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_call_landlord_left"), TableLogic.callback_btn_call_landlord_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_call_landlord_right"), TableLogic.callback_btn_call_landlord_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_callscore_right"), TableLogic.callback_btn_callscore_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_callscore_centre_right"), TableLogic.callback_btn_callscore_centre_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_callscore_centre_left"), TableLogic.callback_btn_callscore_centre_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_callscore_left"), TableLogic.callback_btn_callscore_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_opencard_start_right"), TableLogic.callback_btn_opencard_start_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_opencard_start_left"), TableLogic.callback_btn_opencard_start_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_takeout_right"), TableLogic.callback_btn_takeout_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_takeout_centre"), TableLogic.callback_btn_takeout_centre, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_takeout_left"), TableLogic.callback_btn_takeout_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
	framework.unbindEventCallback(cocostudio.getComponent(TableLogic.view,"btn_PassCard"), TableLogic.callback_btn_PassCard, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE);
end

function TableController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function TableController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function TableController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TableLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		TableConsole.releaseTableData();
		framework.moduleCleanUp(TableLogic);
		TableLogic.releaseData();
	end

	TableLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function TableController:sleepModule()
	framework.releaseOnKeypadEventListener(TableLogic.view)
	TableElementLayer.setElementLayerTouchEnabled(false);
	TableCardLayer.setCardLayerTouchEnabled(false);
	TableLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function TableController:wakeModule()
	framework.setOnKeypadEventListener(TableLogic.view, TableLogic.onKeypad)
	TableElementLayer.setElementLayerTouchEnabled(true)
	TableCardLayer.setCardLayerTouchEnabled(true)
	TableLogic.view:setTouchEnabled(true)
end
