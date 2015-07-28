module(..., package.seeall)

local PaiHangBangGuidePromptTable = {} --每日充值帮引导提示
local PaiHangBangEncourageInfoTable = {} --充值榜鼓励描述

--请求充值榜新手引导文字
function setCOMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG(value)
	PaiHangBangGuidePromptTable["Msg"] = value["MSG"]
	framework.emit(COMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG)
end

function getPaiHangBangGuidePromptTable()
	return PaiHangBangGuidePromptTable
end

--请求充值榜鼓励描述
function setCOMMONS_GET_RECHARGE_ENCOURAGE_MSG(value)
	PaiHangBangEncourageInfoTable = value
	framework.emit(COMMONS_GET_RECHARGE_ENCOURAGE_MSG)
end

function getPaiHangBangEncourageInfoTable()
	return PaiHangBangEncourageInfoTable
end

--请求充值榜鼓励描述
registerMessage(COMMONS_GET_RECHARGE_ENCOURAGE_MSG, setCOMMONS_GET_RECHARGE_ENCOURAGE_MSG)
--请求充值榜新手引导文字
registerMessage(COMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG, setCOMMONS_GET_RECHARGE_NEWUSER_GUIDE_MSG)