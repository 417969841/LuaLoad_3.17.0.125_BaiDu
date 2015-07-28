--
-- 月签(25天版)profile
--

module(..., package.seeall)


--月签奖励列表
local monthSignRewardListTable = {};
monthSignRewardListTable["timeStamp"] = 0; --时间戳
monthSignRewardListTable["monthSignIntroduction"] = ""; --月签详情介绍
monthSignRewardListTable["monthSignPrize"] = {};--奖励列表数据
--用户月签基本信息
local userMonthSignBasicInfoTable = {};
--月签签到信息
local signToMonthSignTable = {};

--[[--
--加载本地月签奖励列表数据
--]]
local function loadMonthSignRewardListTable()
	if monthSignRewardListTable["timeStamp"] == 0 then
		monthSignRewardListTable = Common.LoadTable("MonthSignRewardListTable");
		if monthSignRewardListTable == nil then
			monthSignRewardListTable = {};
			monthSignRewardListTable["timeStamp"] = 0;
			monthSignRewardListTable["monthSignIntroduction"] = "";
			monthSignRewardListTable["monthSignPrize"] = {};
		end
	end
end

loadMonthSignRewardListTable()

--[[--
--获取月签奖励列表时间戳
--]]
function getMonthSignRewardListTimeStamp()
	return monthSignRewardListTable["timeStamp"];
end

--[[--
--获取月签介绍详情
--]]
function getMonthSignIntroduction()
	return monthSignRewardListTable["monthSignIntroduction"];
end

--[[--
--获取月签奖励列表数据
--]]
function getMonthSignRewardListTable()
	return monthSignRewardListTable["monthSignPrize"];
end

--[[--
--获取用户VIP等级对应的转盘数
--]]
function getUserVIPLevelTurnTable()
	return userMonthSignBasicInfoTable["VIPLevelTurnTable"];
end

--[[--
--获取今天签到的奖品信息
--]]
function getTodayPrize()
	local TodayPrize = {};--今天的奖品
	TodayPrize["TodayReceivePrizeType"] = userMonthSignBasicInfoTable["TodayReceivePrizeType"];
	TodayPrize["TodayPrizeDetails"] = userMonthSignBasicInfoTable["TodayPrizeDetails"];
	return TodayPrize;
end


--[[--
--获取用户已签到的信息(包含今天)
--]]
function getUserIsSignDate()
	return userMonthSignBasicInfoTable["isSignDate"];
end

--[[--
--获取月签签到数据
--]]
function getSignToMonthSignTable()
	return signToMonthSignTable;
end

--[[--
--更改今天签到信息
--]]
function setTodayIsSign()
	local isSignDate = userMonthSignBasicInfoTable["isSignDate"];
	isSignDate[#isSignDate]["status"] =1;
end

--[[--
--今天是否已经签到
--]]
function isSignToday()
	--签到的日期数据，包含签到的当天
	local isSignDate = userMonthSignBasicInfoTable["isSignDate"];
	--今天未签到
	if isSignDate[#isSignDate]["status"] == 0 then
		return false;
	else
		return true;
	end
end

--[[--
--保存月签奖励列表数据
--]]
function readMONTH_SIGN_REWARD_LIST(dataTable)
	if tonumber(monthSignRewardListTable["timeStamp"]) > tonumber(dataTable["timeStamp"]) then
		--如果本地时间戳大于服务器的时间戳,证明数据有错,时间戳重置为0
		monthSignRewardListTable["timeStamp"] = 0;
		Common.log("再次请求月签奖励");
		sendMONTH_SIGN_REWARD_LIST(monthSignRewardListTable["timeStamp"]);
		return;
	end
	if monthSignRewardListTable["timeStamp"] == dataTable["timeStamp"] and #dataTable["monthSignPrize"] == 0 then
		Common.log("使用月签本地数据")
		loadMonthSignRewardListTable()
	else
		monthSignRewardListTable["monthSignPrize"] = dataTable["monthSignPrize"];
		monthSignRewardListTable["monthSignIntroduction"] = dataTable["monthSignIntroduction"];
		monthSignRewardListTable["timeStamp"] = dataTable["timeStamp"];
		--保存月签奖励列表数据
		Common.SaveTable("MonthSignRewardListTable", monthSignRewardListTable)
	end
	framework.emit(MONTH_SIGN_REWARD_LIST);
end

--[[--
--用户月签基本信息
--]]
function readUSERS_MONTH_SIGN_BASIC_INFO(dataTable)
	userMonthSignBasicInfoTable = dataTable;
	framework.emit(USERS_MONTH_SIGN_BASIC_INFO);
end

--[[--
--月签签到信息
--]]
function readSIGN_TO_MONTH_SIGN(dataTable)
	signToMonthSignTable = dataTable;
	framework.emit(SIGN_TO_MONTH_SIGN);
end

--[[--
--清除数据
--]]
function clearData()
	userMonthSignBasicInfoTable = {};
	signToMonthSignTable = {}
end

registerMessage(MONTH_SIGN_REWARD_LIST , readMONTH_SIGN_REWARD_LIST);
registerMessage(USERS_MONTH_SIGN_BASIC_INFO , readUSERS_MONTH_SIGN_BASIC_INFO);
registerMessage(SIGN_TO_MONTH_SIGN , readSIGN_TO_MONTH_SIGN);
