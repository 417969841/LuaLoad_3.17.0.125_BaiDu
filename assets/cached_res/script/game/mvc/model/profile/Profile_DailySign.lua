module(..., package.seeall)

local dailySignRewardDataTable -- 签到内容

function readDailySignRewardDataTable(dataTable)
	dailySignRewardDataTable = dataTable
	framework.emit(MANAGERID_DAILY_SIGN)
end

function getDailySignRewardDataTable()
	return dailySignRewardDataTable
end

registerMessage(MANAGERID_DAILY_SIGN, readDailySignRewardDataTable)