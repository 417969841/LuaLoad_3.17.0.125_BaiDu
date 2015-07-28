module(..., package.seeall)

local MobilePaymentModeTable = {}
local UnicomMPaymentModeTable = {}
local TelecomPaymentModeTable = {}

--[[--
--获取移动支付方式
--]]
function getMobilePaymentMode()
	return tonumber(MobilePaymentModeTable["PaymentMode"]);
end

--[[--
--移动支付方式
--]]
function readMANAGERID_MOBILE_PAYMENT_MODE(dataTable)
	MobilePaymentModeTable = dataTable;
	framework.emit(MANAGERID_MOBILE_PAYMENT_MODE)
end

--[[--
--获取联通支付方式
--]]
function getUnicomMPaymentMode()
	return tonumber(UnicomMPaymentModeTable["PaymentMode"]);
end

--[[--
--联通支付方式
--]]
function readMANAGERID_CU_PAYMENT_MODE(dataTable)
	UnicomMPaymentModeTable = dataTable;
	framework.emit(MANAGERID_CU_PAYMENT_MODE)
end

--[[--
--获取电信支付方式
--]]
function getTelecomPaymentMode()
	return tonumber(TelecomPaymentModeTable["PaymentMode"]);
end

--[[--
--电信支付方式
--]]
function readMANAGERID_CT_PAYMENT_MODE(dataTable)
	TelecomPaymentModeTable = dataTable;
	framework.emit(MANAGERID_CT_PAYMENT_MODE)
end

registerMessage(MANAGERID_MOBILE_PAYMENT_MODE, readMANAGERID_MOBILE_PAYMENT_MODE)
registerMessage(MANAGERID_CU_PAYMENT_MODE, readMANAGERID_CU_PAYMENT_MODE)
registerMessage(MANAGERID_CT_PAYMENT_MODE, readMANAGERID_CT_PAYMENT_MODE)
