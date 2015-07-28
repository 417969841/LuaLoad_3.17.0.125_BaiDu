--
-- 大厅公告profile
--

module(..., package.seeall)

--大厅公告table
local systemListNoticeTable = {};
--一条系统公告
local systemNotice = "";

--[[--
--获取一条大厅公告
--]]
function getOneSystemNotice()
	if #systemListNoticeTable > 0 then
		systemNotice = systemListNoticeTable[1]["NoticeMsg"];
		table.remove(systemListNoticeTable, 1);
	else
		systemNotice = "";
	end
	return systemNotice;
end

function setOneSystemNotice()

	systemNotice = nil;
end
--[[--
--读取系统公告
--]]
function readMANAGERID_GET_SYSTEM_LIST_NOTICE(dataTable)
	systemListNoticeTable = dataTable["SystemListNotice"];
	framework.emit(MANAGERID_GET_SYSTEM_LIST_NOTICE);
end

--[[--
--清除数据
--]]
function clearData()
	systemListNoticeTable = {};
end

registerMessage(MANAGERID_GET_SYSTEM_LIST_NOTICE , readMANAGERID_GET_SYSTEM_LIST_NOTICE);