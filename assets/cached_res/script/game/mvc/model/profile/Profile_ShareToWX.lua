module(..., package.seeall)

local ShareToWXTable = {} --微信分享返回table
local SharingRewardTable = {} --微信分享奖励table
local SharingAllRewardTable = {} --微信分享累积table
local ShareCompleteTable = {} --存储于本地玩家分享时间戳的table
local shareComplete = false --是否已经分享成功
local HasReceivedPrizes = {};--存储于本地玩家领取奖品时间戳的table
local AppDownLoadURL = "";--App下载地址
local RewardDescriptionTable = {};--分享奖励说明

--[[--
-- 获取未领奖时,用户是否已经分享过
--]]--
function getShareComplete(TimeStamp)
	ShareCompleteTable = Common.LoadShareTable("ShareCompleteTable")
	if ShareCompleteTable == nil or ShareCompleteTable[profile.User.getSelfUserID() .. ""] == nil then
		Common.log("getShareComplete ShareCompleteTable is nil")
		return false
	end
	local mTimeStamp = ShareCompleteTable[profile.User.getSelfUserID() .. ""].TimeStamp
	local newDate = os.date("*t",TimeStamp)
	local oldDate = os.date("*t",mTimeStamp)
	if TimeStamp > mTimeStamp then
		if newDate.year == oldDate.year and newDate.month == oldDate.month and newDate.day == oldDate.day then
			shareComplete = true
		end
	else
		Common.log("getShareComplete shareComplete is false")
		shareComplete = false
	end
	return shareComplete
end

--[[--
-- 获取用户今天是否已领奖
--]]--
function getHasReceivedPrizes(TimeStamp)
	local HasReceived = false;--已经领取奖品
	HasReceivedPrizes = Common.LoadShareTable("HasReceivedPrizes");
	if HasReceivedPrizes == nil or HasReceivedPrizes[profile.User.getSelfUserID() .. ""] == nil then
		return false
	end
	local mTimeStamp = HasReceivedPrizes[profile.User.getSelfUserID() .. ""].TimeStamp;
	local newDate = os.date("*t",TimeStamp);
	local oldDate = os.date("*t",mTimeStamp);
	if TimeStamp > mTimeStamp then
		if newDate.year == oldDate.year and newDate.month == oldDate.month and newDate.day == oldDate.day then
			HasReceived = true;
		end
	else
		HasReceived = true;
	end
	return HasReceived;
end

--[[--
-- 接收服务器返回领取奖励table
]]
function setSharingRewardTable(dataTable)
	SharingRewardTable = dataTable
	local mTimeStamp = os.time();
	if SharingRewardTable ~= nil and SharingRewardTable["result"] ~= 0 then
		local HasReceivedPrizes = Common.LoadShareTable("HasReceivedPrizes")
		if HasReceivedPrizes == nil then
			HasReceivedPrizes = {}
		end
		HasReceivedPrizes[profile.User.getSelfUserID() .. ""] = {}
		HasReceivedPrizes[profile.User.getSelfUserID() .. ""].TimeStamp = mTimeStamp
		Common.SaveShareTable("HasReceivedPrizes", HasReceivedPrizes)
	end
	framework.emit(OPERID_REQUEST_GAME_SHARING_REWARD)
end

function getSharingRewardTable()
	return SharingRewardTable
end

--[[--
-- 接收服务器返回领取累积记录table
]]
function setSharingAllRewardTable(dataTable)
	SharingAllRewardTable = dataTable
	framework.emit(OPERID_GAME_SHARING_ALL_REWARD)
end

function getSharingAllRewardTable()
	return SharingAllRewardTable
end

--[[--
--获取App下载地址
--]]
function getAppDownLoadURL()
	return AppDownLoadURL;
end

--[[--
--保存分享V2分享下载地址预读
--]]
function readOPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL(dataTable)
	AppDownLoadURL = dataTable["DownLoadURL"];
	framework.emit(OPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL);
end

--[[--
--获取分享奖励说明数据
--]]
function getSharingRewardDescription()
	return RewardDescriptionTable;
end

--[[--
--保存分享奖励说明数据
--]]
function readOPERID_SHARING_REWARD_DESCRIPTION(dataTable)
	RewardDescriptionTable = dataTable;
	framework.emit(OPERID_SHARING_REWARD_DESCRIPTION);
end

registerMessage(OPERID_REQUEST_GAME_SHARING_REWARD, setSharingRewardTable)
registerMessage(OPERID_GAME_SHARING_ALL_REWARD, setSharingAllRewardTable)
registerMessage(OPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL, readOPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL);
registerMessage(OPERID_SHARING_REWARD_DESCRIPTION, readOPERID_SHARING_REWARD_DESCRIPTION);