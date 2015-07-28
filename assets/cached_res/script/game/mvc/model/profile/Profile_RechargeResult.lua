module(..., package.seeall)

--充值结果Table
local rechargeResultTable = {}

function getRechargeResultTable()
	return rechargeResultTable
end

function readRechargeResultTable(dataTable)
	rechargeResultTable = dataTable
	framework.emit(DBID_RECHARGE_RESULT_NOTIFICATION)
end

--[[--返回当前VIP Level]]
function getNewVipLevel()
	local newVipLevel = nil
	if rechargeResultTable["newVipLevel"] ~= nil then
		newVipLevel = rechargeResultTable["newVipLevel"]
	end
	return newVipLevel
end

registerMessage(DBID_RECHARGE_RESULT_NOTIFICATION, readRechargeResultTable)