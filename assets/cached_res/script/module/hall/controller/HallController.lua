module(...,package.seeall)

Load.LuaRequire("script.module.hall.logic.HallLogic")

HallController = class("HallController",BaseController)
HallController.__index = HallController

HallController.moduleLayer = nil

function HallController:reset()
	HallLogic.view = nil
end

function HallController:getLayer()
	return HallLogic.view
end


function HallController:createView()
	HallLogic.createView()
	framework.setOnKeypadEventListener(HallLogic.view, HallLogic.onKeypad)
end

function HallController:requestMsg()
	HallLogic.requestMsg()
end

function HallController:addSlot()
	HallLogic.addSlot()
end

function HallController:removeSlot()
	HallLogic.removeSlot()
end

function HallController:addCallback()
	--大厅
	--top
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_back"),HallLogic.callback_btn_back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"img_useravator"),HallLogic.callback_btn_useravator,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_coin"),HallLogic.callback_btn_coin,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_lucky_game"),HallLogic.callback_btn_lucky_game,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_caishen"),HallLogic.callback_btn_caishen,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_chongzhi"),HallLogic.callback_btn_chongzhi,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_FreeCoin"), HallLogic.callback_btn_FreeCoin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_VIPkaitong"), HallLogic.callback_btn_VIPkaitong, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_YuanBao"), HallLogic.callback_btn_YuanBao, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	--mid hall
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_matchgame"),HallLogic.callback_btn_matchgame,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_leisuregame"),HallLogic.callback_btn_leisuregame,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_hall_huodong"),HallLogic.callback_btn_hall_huodong,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_quickstart"),HallLogic.callback_btn_quickstart,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_pk_game"), HallLogic.callback_btn_pk_game, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	--mid room
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"img_laizi"),HallLogic.callback_img_laizi,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"img_happy"),HallLogic.callback_img_happy,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"img_common"),HallLogic.callback_img_common,BUTTON_CLICK)
	--mid match
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"img_mianfei"),HallLogic.callback_img_mianfei,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"img_tianti"),HallLogic.callback_img_tianti,BUTTON_CLICK)
	--end
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_message"),HallLogic.callback_btn_message,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_shop"),HallLogic.callback_btn_shop,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_gift"),HallLogic.callback_btn_gift,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_rankinglist"),HallLogic.callback_btn_rankinglist,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_chat"),HallLogic.callback_btn_chat,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_NONE)
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_setting"),HallLogic.callback_btn_setting,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	-- 首冲
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_hall_shouchong"), HallLogic.callback_btn_hall_shouchong, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_ZOOM_IN);
end

function HallController:removeCallback()
	--大厅
	--top
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_back"),HallLogic.callback_btn_back,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT )
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"img_useravator"),HallLogic.callback_btn_useravator,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_coin"),HallLogic.callback_btn_coin,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_lucky_game"),HallLogic.callback_btn_lucky_game,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_caishen"),HallLogic.callback_btn_caishen,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_chongzhi"),HallLogic.callback_btn_chongzhi,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_FreeCoin"), HallLogic.callback_btn_FreeCoin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_VIPkaitong"), HallLogic.callback_btn_VIPkaitong, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_YuanBao"), HallLogic.callback_btn_YuanBao, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	--mid hall
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_matchgame"),HallLogic.callback_btn_matchgame,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_leisuregame"),HallLogic.callback_btn_leisuregame,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_hall_huodong"),HallLogic.callback_btn_hall_huodong,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_quickstart"),HallLogic.callback_btn_quickstart,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_pk_game"), HallLogic.callback_btn_pk_game, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	--mid room
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"img_laizi"),HallLogic.callback_img_laizi,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"img_happy"),HallLogic.callback_img_happy,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"img_common"),HallLogic.callback_img_common,BUTTON_CLICK)
	--mid match
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"img_mianfei"),HallLogic.callback_img_mianfei,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"img_crazy"),HallLogic.callback_img_crazy,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"img_tianti"),HallLogic.callback_img_tianti,BUTTON_CLICK)

	--end
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_message"),HallLogic.callback_btn_message,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_shop"),HallLogic.callback_btn_shop,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_gift"),HallLogic.callback_btn_gift,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_rankinglist"),HallLogic.callback_btn_rankinglist,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_chat"),HallLogic.callback_btn_chat,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_NONE)
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_setting"),HallLogic.callback_btn_setting,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	--首冲
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"btn_hall_shouchong"), HallLogic.callback_btn_hall_shouchong, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_ZOOM_IN);
end

function HallController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function HallController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function HallController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(HallLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(HallLogic);
		HallLogic.releaseData();
	end

	HallLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function HallController:sleepModule()
	framework.releaseOnKeypadEventListener(HallLogic.view)
	HallLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function HallController:wakeModule()
	framework.setOnKeypadEventListener(HallLogic.view, HallLogic.onKeypad)
	HallLogic.view:setTouchEnabled(true)
end
