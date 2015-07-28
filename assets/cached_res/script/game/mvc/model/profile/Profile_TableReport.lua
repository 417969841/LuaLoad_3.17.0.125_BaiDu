module(..., package.seeall)

--举报消息返回Table
local tableReportResultTable = {}

function getReportResultTable()
	return tableReportResultTable
end

function readTableReportResultTable(dataTable)
	tableReportResultTable = dataTable
	framework.emit(MANAGERID_PLAYER_REPORT)
end

function getReportResultText()
	local resultText = nil
	if tableReportResultTable["resultText"] ~= nil then
		resultText = tableReportResultTable["resultText"]
	end
	return resultText
end

registerMessage(MANAGERID_PLAYER_REPORT, readTableReportResultTable)