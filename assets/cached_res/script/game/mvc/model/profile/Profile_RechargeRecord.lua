module(..., package.seeall)
--充值记录
local RechargeRecordTable = {}

function setRechargeRecordTable(dataTable)
	RechargeRecordTable["RechargeRecordData"] = dataTable["RechargeRecordData"]
	framework.emit(GET_RECHARGE_RECORD)
end

function getRechargeRecordTable()
	return RechargeRecordTable["RechargeRecordData"]
end

registerMessage(GET_RECHARGE_RECORD, setRechargeRecordTable)