module(...,package.seeall)

Load.LuaRequire("script.module.userinfo.logic.UserInfoLogic")

UserInfoController = class("UserInfoController",BaseController)
UserInfoController.__index = UserInfoController

UserInfoController.moduleLayer = nil

function UserInfoController:reset()
	UserInfoLogic.view = nil
end

function UserInfoController:getLayer()
	return UserInfoLogic.view
end

function UserInfoController:createView()
	UserInfoLogic.createView()
	framework.setOnKeypadEventListener(UserInfoLogic.view, UserInfoLogic.onKeypad)
end

function UserInfoController:requestMsg()
	UserInfoLogic.requestMsg()
end

function UserInfoController:addSlot()
	UserInfoLogic.addSlot()
end

function UserInfoController:removeSlot()
	UserInfoLogic.removeSlot()
end

function UserInfoController:addCallback()
	--top
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_back"),UserInfoLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic"),UserInfoLogic.callback_img_basic,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_Bag"),UserInfoLogic.callback_img_Bag,BUTTON_CLICK)
	--framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_changeuser"),UserInfoLogic.callback_btn_changeuser,BUTTON_CLICK)
	--left
--	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_basic"),UserInfoLogic.callback_img_basic_basic,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_sns"),UserInfoLogic.callback_img_basic_sns,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_duijiang"),UserInfoLogic.callback_img_basic_duijiang,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_tianti_paiming"),UserInfoLogic.callback_img_tianti_paiming,BUTTON_CLICK)
--	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_tianti_basic"),UserInfoLogic.callback_img_tianti_basic,BUTTON_CLICK)
--	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_tianti_help"),UserInfoLogic.callback_img_tianti_help,BUTTON_CLICK)
	--basic basic info
--	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_basic_openvip"),UserInfoLogic.callback_btn_basic_basic_openvip,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_basic_addcoin"),UserInfoLogic.callback_btn_basic_basic_addcoin,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_basic_addyuanbao"),UserInfoLogic.callback_btn_basic_basic_addyuanbao,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
--	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"Button_beibao"),UserInfoLogic.callback_Button_beibao,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

	--basic sns info
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_sns_avator"),UserInfoLogic.callback_lab_basic_sns_changeavator,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	--framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"lab_basic_sns_phone"),UserInfoLogic.callback_lab_basic_sns_phone,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"check_basic_sns_sexB"),UserInfoLogic.callback_check_basic_sns_sexB,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"check_basic_sns_sexG"),UserInfoLogic.callback_check_basic_sns_sexG,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"check_basic_sns_sexM"),UserInfoLogic.callback_check_basic_sns_sexM,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"lab_basic_sns_year"),UserInfoLogic.callback_lab_basic_sns_year,BUTTON_CLICK)
--	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_sns_changeold"), UserInfoLogic.callback_img_basic_sns_changeold, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"lab_basic_sns_address"),UserInfoLogic.callback_lab_basic_sns_address,BUTTON_CLICK)
--	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_sns_changehome"), UserInfoLogic.callback_img_basic_sns_changehome, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_sns_save"),UserInfoLogic.callback_btn_basic_sns_save,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	--basic duijiang info
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_duijiang_save"),UserInfoLogic.callback_btn_basic_duijiang_save,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
--	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_duijiang_ok"),UserInfoLogic.callback_btn_basic_duijiang_ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	--tianti basic info
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_tianti_basic_lgz"),UserInfoLogic.callback_btn_tianti_basic_lgz,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
--	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"Button_Invite"), UserInfoLogic.callback_Button_Invite, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_bag_Tickets"), UserInfoLogic.callback_img_bag_Tickets, BUTTON_CLICK);
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_bag_Props"), UserInfoLogic.callback_img_bag_Props, BUTTON_CLICK);
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"Button_Synthesis"), UserInfoLogic.callback_Button_Synthesis, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);

    if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_username"),   UserInfoLogic.callback_txt_basic_sns_username_ios,BUTTON_CLICK);
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_password"),   UserInfoLogic.callback_txt_basic_sns_password_ios,BUTTON_CLICK);
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_info"),   UserInfoLogic.callback_txt_basic_sns_info_ios,BUTTON_CLICK);
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_username"),UserInfoLogic.callback_txt_basic_duijiang_username_ios,BUTTON_CLICK);
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_phone"),   UserInfoLogic.callback_txt_basic_duijiang_phone_ios,BUTTON_CLICK);
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_address"),   UserInfoLogic.callback_txt_basic_duijiang_address_ios,BUTTON_CLICK);
        --framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_email"),   UserInfoLogic.callback_txt_basic_duijiang_email_ios,BUTTON_CLICK);
    elseif Common.platform == Common.TargetAndroid then
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_username"),   UserInfoLogic.callback_txt_basic_sns_username,DETACH_WITH_IME);
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_password"),   UserInfoLogic.callback_txt_basic_sns_password,DETACH_WITH_IME);
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_info"),   UserInfoLogic.callback_txt_basic_sns_info,DETACH_WITH_IME);
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_username"),UserInfoLogic.callback_txt_basic_duijiang_username,DETACH_WITH_IME);
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_phone"),   UserInfoLogic.callback_txt_basic_duijiang_phone,DETACH_WITH_IME);
        framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_address"),   UserInfoLogic.callback_txt_basic_duijiang_address,DETACH_WITH_IME);
        --framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_email"),   UserInfoLogic.callback_txt_basic_duijiang_email,DETACH_WITH_IME);
	end
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"Button_bangding"), UserInfoLogic.callback_Button_bangding, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"ImageView_GuiZe"), UserInfoLogic.callback_ImageView_GuiZe, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function UserInfoController:removeCallback()
	--top
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_back"),UserInfoLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic"),UserInfoLogic.callback_img_basic,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_Bag"),UserInfoLogic.callback_img_Bag,BUTTON_CLICK)
	--framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_changeuser"),UserInfoLogic.callback_btn_changeuser,BUTTON_CLICK)
	--left
--	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_basic"),UserInfoLogic.callback_img_basic_basic,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_sns"),UserInfoLogic.callback_img_basic_sns,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_duijiang"),UserInfoLogic.callback_img_basic_duijiang,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_tianti_paiming"),UserInfoLogic.callback_img_tianti_paiming,BUTTON_CLICK)
--	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_tianti_basic"),UserInfoLogic.callback_img_tianti_basic,BUTTON_CLICK)
--	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_tianti_help"),UserInfoLogic.callback_img_tianti_help,BUTTON_CLICK)
	--basic basic info
--	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_basic_openvip"),UserInfoLogic.callback_btn_basic_basic_openvip,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_basic_addcoin"),UserInfoLogic.callback_btn_basic_basic_addcoin,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_basic_addyuanbao"),UserInfoLogic.callback_btn_basic_basic_addyuanbao,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
--	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"Button_beibao"),UserInfoLogic.callback_Button_beibao,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

	--basic sns info
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_sns_avator"),UserInfoLogic.callback_lab_basic_sns_changeavator,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	--framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"lab_basic_sns_phone"),UserInfoLogic.callback_lab_basic_sns_phone,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"check_basic_sns_sexB"),UserInfoLogic.callback_check_basic_sns_sexB,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"check_basic_sns_sexG"),UserInfoLogic.callback_check_basic_sns_sexG,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"check_basic_sns_sexM"),UserInfoLogic.callback_check_basic_sns_sexM,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"lab_basic_sns_year"),UserInfoLogic.callback_lab_basic_sns_year,BUTTON_CLICK)
--	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_sns_changeold"), UserInfoLogic.callback_img_basic_sns_changeold, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"lab_basic_sns_address"),UserInfoLogic.callback_lab_basic_sns_address,BUTTON_CLICK)
--	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_basic_sns_changehome"), UserInfoLogic.callback_img_basic_sns_changehome, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_sns_save"),UserInfoLogic.callback_btn_basic_sns_save,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	--basic duijiang info
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_duijiang_save"),UserInfoLogic.callback_btn_basic_duijiang_save,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
--	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_basic_duijiang_ok"),UserInfoLogic.callback_btn_basic_duijiang_ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
--	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"Button_Invite"), UserInfoLogic.callback_Button_Invite, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	--tianti basic info
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"btn_tianti_basic_lgz"),UserInfoLogic.callback_btn_tianti_basic_lgz,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_bag_Tickets"), UserInfoLogic.callback_img_bag_Tickets, BUTTON_CLICK);
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"img_bag_Props"), UserInfoLogic.callback_img_bag_Props, BUTTON_CLICK);
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"Button_Synthesis"), UserInfoLogic.callback_Button_Synthesis, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);

     if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_username"),   UserInfoLogic.callback_txt_basic_sns_username_ios,BUTTON_CLICK);
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_password"),   UserInfoLogic.callback_txt_basic_sns_password_ios,BUTTON_CLICK);
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_info"),   UserInfoLogic.callback_txt_basic_sns_info_ios,BUTTON_CLICK);
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_username"),UserInfoLogic.callback_txt_basic_duijiang_username_ios,BUTTON_CLICK);
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_phone"),   UserInfoLogic.callback_txt_basic_duijiang_phone_ios,BUTTON_CLICK);
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_address"),   UserInfoLogic.callback_txt_basic_duijiang_address_ios,BUTTON_CLICK);
        --framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_email"),   UserInfoLogic.callback_txt_basic_duijiang_email_ios,BUTTON_CLICK);
    elseif Common.platform == Common.TargetAndroid then
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_username"),   UserInfoLogic.callback_txt_basic_sns_username,DETACH_WITH_IME);
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_password"),   UserInfoLogic.callback_txt_basic_sns_password,DETACH_WITH_IME);
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_sns_info"),   UserInfoLogic.callback_txt_basic_sns_info,DETACH_WITH_IME);
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_username"),UserInfoLogic.callback_txt_basic_duijiang_username,DETACH_WITH_IME);
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_phone"),   UserInfoLogic.callback_txt_basic_duijiang_phone,DETACH_WITH_IME);
        framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_address"),   UserInfoLogic.callback_txt_basic_duijiang_address,DETACH_WITH_IME);
        --framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"txt_basic_duijiang_email"),   UserInfoLogic.callback_txt_basic_duijiang_email,DETACH_WITH_IME);
	end

	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"Button_bangding"), UserInfoLogic.callback_Button_bangding, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(UserInfoLogic.view,"ImageView_GuiZe"), UserInfoLogic.callback_ImageView_GuiZe, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function UserInfoController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function UserInfoController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function UserInfoController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(UserInfoLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(UserInfoLogic);
		UserInfoLogic.releaseData();
	end

	if UserInfoLogic.view then
		UserInfoLogic.view:removeFromParentAndCleanup(true)
	end
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function UserInfoController:sleepModule()
	framework.releaseOnKeypadEventListener(UserInfoLogic.view)
	UserInfoLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
	UserInfoLogic.setEnableForUderInfo(false)
end

function UserInfoController:wakeModule()
	framework.setOnKeypadEventListener(UserInfoLogic.view, UserInfoLogic.onKeypad)
	UserInfoLogic.view:setTouchEnabled(true)
	UserInfoLogic.setEnableForUderInfo(true)
end
