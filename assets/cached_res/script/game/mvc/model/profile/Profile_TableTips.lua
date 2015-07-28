module(..., package.seeall)

local tableTips = {}
tableTips["TimeStamp"] = 0
tableTips["AddMsg"]  = {}

local function loadTableYips()
	tableTips = Common.LoadTable("TableTips")
	if tableTips == nil then
		tableTips = {}
		tableTips["TimeStamp"] = 0
		tableTips["AddMsg"]  = {}
	end
end

loadTableYips()

--牌桌提示
function readDBID_V2_WATING_TIPS(dataTable)
	if tableTips["TimeStamp"] ~= dataTable["TimeStamp"] then
		tableTips = dataTable
		Common.SaveTable("TableTips", tableTips)
		Common.log("tips加载网络")
	else
		Common.log("tips加载本地")
	end
	framework.emit(DBID_V2_WATING_TIPS)
end

function getDBID_V2_WATING_TIPS()
	return tableTips
end

--时间戳
function getDBID_V2_WATING_TIPSTime()
	return tableTips["TimeStamp"]
end

registerMessage(DBID_V2_WATING_TIPS, readDBID_V2_WATING_TIPS)