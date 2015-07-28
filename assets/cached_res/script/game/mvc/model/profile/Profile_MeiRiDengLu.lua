module(..., package.seeall)

--是否有新公告Table
local haveNewGonggaoResultTable = {}
--是否有新活动Table
local haveNewHuodongResultTable = {}
--本期之星信息Table
local starPlayerInfoTable = {}
--活动页面内容信息Table
local huodongInfoTable = {}
--每日签到信息Table
local dailySignTable = {}
--上一次活动内容的时间戳
local lastTimeStamp = 0;
--新版本消息整合后的table
local dailyNofityInfoTable = {}
--上一次公告的时间戳
local GongGaolastTimeStamp = 0;
--MANAGERID_V3_GET_ACTIVITY_LIST消息是否回复
local MANAGERID_V3_GET_ACTIVITY_LIST_isback = false
--[[--
--加载活动列表数据
--]]
local function loadActivityListTable()
	huodongInfoTable = Common.LoadTable("huodongInfoTable");
	if huodongInfoTable == nil then
		huodongInfoTable = {};
	end
end

--[[--
--设置上一次活动的时间戳值
--]]
function setLastTimeStampValue()
	if huodongInfoTable == nil or huodongInfoTable["time"] == nil then
		lastTimeStamp = 0;
	else
		lastTimeStamp = huodongInfoTable["time"];
	end
end

function getActityTimeStamp()
	return lastTimeStamp;
end

function getMANAGERID_V3_GET_ACTIVITY_LIST_isback()
	return MANAGERID_V3_GET_ACTIVITY_LIST_isback;
end

function ReSetMANAGERID_V3_GET_ACTIVITY_LIST_isback()
	 MANAGERID_V3_GET_ACTIVITY_LIST_isback = false
end
function getHuodongInfoTable()
	return huodongInfoTable
end

function getGongGaoLastTimeStamp()
	return GongGaolastTimeStamp;
end
--[[--
--保存活动列表详情信息
--]]
function readHuodongInfoTable(dataTable)
	if tonumber(lastTimeStamp) > tonumber(dataTable["time"]) then
		--如果本地时间戳大于服务器的时间戳,证明数据有错,时间戳重置为0
		lastTimeStamp = 0;
		sendMONTH_SIGN_REWARD_LIST(lastTimeStamp);
		return;
	end
	if lastTimeStamp == dataTable["time"] then
		Common.log("使用活动本地数据");
	else
		--保存月签奖励列表数据
		huodongInfoTable = dataTable
		Common.SaveTable("huodongInfoTable", huodongInfoTable)
	end
	framework.emit(MANAGERID_V3_GET_ACTIVITY_LIST)
end

function getHaveNewHuodongResultTable()
	return haveNewHuodongResultTable
end

--[[--
--是否有新活动
--@return #boolean 是否有新公告
--]]
function hasNewActivity()
	if  haveNewHuodongResultTable["Result"] == 1 then
		return true;
	else
		return false;
	end
end

function readHaveNewHuodongResultTable(dataTable)
	haveNewHuodongResultTable = dataTable
	framework.emit(MANAGERID_GET_HAVE_NEW_HUODONG)
end

function getHaveNewGonggaoResultTable()
	return haveNewGonggaoResultTable
end

--[[--
--是否有新公告
--@return #boolean 是否有新公告
--]]
function hasNewAnnouncement()
	if  haveNewGonggaoResultTable["Result"] == 1 then
		return true;
	else
		return false;
	end
end

function readHaveNewGonggaoResultTable(dataTable)
	haveNewGonggaoResultTable = dataTable
	framework.emit(MANAGERID_GET_HAVE_NEW_GONGGAO)
end

function getStarPlayerInfoTable()
	return starPlayerInfoTable
end

function readStarPlayerInfoTable(dataTable)
	starPlayerInfoTable = dataTable
	framework.emit(MATID_STAR_INFO)
end

function getDailySignTable()
	return dailySignTable
end

function readDailySignTable(dataTable)
	dailySignTable = dataTable
	framework.emit(MANAGERID_DAILY_SIGN_V4)
end

function readDailyNotifyInfoTable(dataTable)
	dailyNofityInfoTable = dataTable
	GongGaolastTimeStamp = dataTable["GongGaoLastTimeStamp"]
	MANAGERID_V3_GET_ACTIVITY_LIST_isback = true
	Common.setDataForSqlite("GongGaoLastTimeStamp"..profile.User.getSelfUserID(),GongGaolastTimeStamp)
	framework.emit(MANAGERID_V3_GET_ACTIVITY_LIST)
end

function getDailyNotifyInfoTable()
	return dailyNofityInfoTable
end

loadActivityListTable()
setLastTimeStampValue();

registerMessage(MATID_STAR_INFO, readStarPlayerInfoTable)
registerMessage(MANAGERID_GET_HAVE_NEW_GONGGAO, readHaveNewGonggaoResultTable)
registerMessage(MANAGERID_GET_HAVE_NEW_HUODONG, readHaveNewHuodongResultTable)
registerMessage(MANAGERID_V3_GET_ACTIVITY_LIST,readHuodongInfoTable)
registerMessage(MANAGERID_DAILY_SIGN_V4,readDailySignTable)
registerMessage(OPERID_GET_DAILY_NOTIFY_INFO,readDailyNotifyInfoTable)