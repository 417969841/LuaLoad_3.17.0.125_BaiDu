module("ServerConfig", package.seeall)

--服务器通用配置名称

-- 斗地主：不显示平台的渠道
LORD_NO_SHOW_PLATFORM_CHANNEL = "lord_is_show_platform_for_lua";
-- 斗地主：不显示礼包的渠道
LORD_IS_SHOW_GIFT_FOR_LUA = "lord_is_show_gift_for_lua";
-- 斗地主：不显示充值引导的渠道
LORD_IS_SHOW_QUICK_PAY_FOR_LUA = "lord_is_show_quick_pay_for_lua";
-- 渠道是否显示所有支付
SHOW_SMS_PAY_SWITCH = "lord_only_show_sms_way_channel_236";
-- 下载pad版本提示信息
LORD_DOWNLOAD_PAD_PROMPT_MSG = "lord_download_pad_prompt_msg";
-- 关闭/显示老虎机的开关
LORD_SHOW_SLOT_SWITCH = "lord_show_slot_switch";
-- MM APPID和APPKEY
LORD_MM_V2_APPID_AND_APPKEY = "lord_mm_v2_appid_and_appkey";
-- 显示移动快捷支付的二次确认框
LORD_SHOW_YIDONG_RECHARGE_SECONDARY_CONFIRMATION = "lord_show_yidong_recharge_secondary_confirmation";
-- 显示一键注册
LORD_SHOW_AUTO_REGISTER = "lord_show_auto_register";
--是否显示一键注册 否则显示找回密码
isShowAutoRegister = false;

LORD_CMPAY_MT_FILTER = "lord_cmpay_mt_filter" --手机钱包正则表达式配置
HAS_GET_PURES_MATCHES = false --手机钱包正则表达式配置是否已经获取

LORD_OPRATIONAL_BTN_URL = "lord_oprational_btn_url" --获取首页活动icon地址配置
Has_GET_OPRATIONAL_BTN_URL = false  --是否已经获取首页活动icon地址配置

LORD_DENY_SMS_LIST = "lord_deny_sms_list" --获取手机钱包2正则表达式配置

LORD_GIFT_CAN_USE_SMS = "lord_gift_can_use_sms" --礼包和充值引导是否使用短信购买

Lord_Is_Appstore_Review = "lord_is_appstore_review"	--评审开关

maMessage = {
	Lord_Is_Appstore_Review,
	LORD_IS_SHOW_GIFT_FOR_LUA,
	LORD_IS_SHOW_QUICK_PAY_FOR_LUA,
	LORD_GIFT_CAN_USE_SMS,
	LORD_OPRATIONAL_BTN_URL,
	LORD_DENY_SMS_LIST
}

--[[--
--获取是否在礼包充值引导上使用短信
--]]
function getGiftCanUseSms()
	local giftCanUseSms = profile.ServerConfig.getServerConfigDataTable(LORD_GIFT_CAN_USE_SMS) --获取服务器返回的table
	if giftCanUseSms ~= nil and giftCanUseSms.VarValue ~= nil and giftCanUseSms.VarValue ~= "" then
		if giftCanUseSms.VarValue == "1" then
			return true
		else
			return false
		end
	else
		return false
	end
end

--[[--
--获取是否显示礼包
--]]
function getGiftIsShow()
	local GiftIsShow = profile.ServerConfig.getServerConfigDataTable(LORD_IS_SHOW_GIFT_FOR_LUA) --获取服务器返回的table
	if GiftIsShow ~= nil and GiftIsShow.VarValue ~= nil and GiftIsShow.VarValue ~= "" then
		if GiftIsShow.VarValue == "1" then
			return true
		else
			return false
		end
	else
		return false
	end
end

--[[--
--获取是否显示充值引导
--]]
function getQuickPayIsShow()
	local QuickPayIsShow = profile.ServerConfig.getServerConfigDataTable(LORD_IS_SHOW_QUICK_PAY_FOR_LUA) --获取服务器返回的table
	if QuickPayIsShow ~= nil and QuickPayIsShow.VarValue ~= nil and QuickPayIsShow.VarValue ~= "" then
		if QuickPayIsShow.VarValue == "1" then
			return true
		else
			return false
		end
	else
		return false
	end
end

--[[
是否开启第三方评审
]]
function enableThirdpartReview()
--    do return true end

	local enableThirdPayment = profile.ServerConfig.getServerConfigDataTable(Lord_Is_Appstore_Review) --获取服务器返回的table
	if enableThirdPayment ~= nil and enableThirdPayment.VarValue ~= nil and enableThirdPayment.VarValue ~= "" then
		if enableThirdPayment.VarValue == "1" then
			return true
		else
			return false
		end
	else
		return false
	end
end
