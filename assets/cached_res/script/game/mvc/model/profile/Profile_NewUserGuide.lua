module(...,package.seeall)

local isNewUserGuideisEnable = true; --是否使用新手引导
local isNewUserGuideisEnableMessage_back = false --新手引导消息是否响应
--同步新手引导状态
local dataSynNewUserTaskState = {}
--获取新手基本信息
local dataGetNewUserBaseInfo = {}
--领取新手引导奖励
local dataGetNewUserAward = {}
--跳过新手引导
local dataSkipNewUserGuide = {}
--新手引导方案
local dataNewUserGuideScheme = {}

--获得是否完成
function getIsCanSatarTask()
	if dataSynNewUserTaskState["IsComplete"] ~= nil then
		--IsComplete 判断新手引导是否完成，0未完成，1完成，2已跳过
		if dataSynNewUserTaskState["IsComplete"] == 0 then
			--0未完成:从未开始/中断
			return true;
		else
			--1完成，2已跳过
			return false;
		end
	end
end

--[[--
--获取任务是否已经开始
--]]
function getTaskIsStarted()
	if getTaskStateForTaskType(1) == 1 then
		return true;
	else
		return false;
	end
end

--新手引导状态列表
function getSynNewUserTaskState()
	return dataSynNewUserTaskState["TaskState"];
end

--[[--
--根据任务编号取任务状态
--]]
function getTaskStateForTaskType(index)
	if dataSynNewUserTaskState["TaskState"] ~= nil then
		for i = 1, #dataSynNewUserTaskState["TaskState"] do
			if index == dataSynNewUserTaskState["TaskState"][i].TaskType then
				return dataSynNewUserTaskState["TaskState"][i].TaskState
			end
		end
	end
end

--同步新手引导状态信息
function readCOMMONS_SYN_NEWUSERGUIDE_STATE(dataTable)
	isNewUserGuideisEnableMessage_back = true
	if isNewUserGuideisEnable == false then
		return
	end
	isNewUserGuideisEnableMessage_back = true
	dataSynNewUserTaskState = {};
	dataSynNewUserTaskState["IsComplete"] = dataTable["IsComplete"];
	dataSynNewUserTaskState["TaskState"] = dataTable["TaskState"];
	framework.emit(COMMONS_SYN_NEWUSERGUIDE_STATE)
end

--基本信息
function getNewUserGuideBaseInfo()
	return dataGetNewUserBaseInfo["TaskMsgLoop"];
end

--获取新手基本信息
function readCOMMONS_GET_BASEINFO_NEWUSERGUIDE(dataTable)
	if isNewUserGuideisEnable == false then
		return
	end
	dataGetNewUserBaseInfo["TaskMsgLoop"] = dataTable["TaskMsgLoop"];
	framework.emit(COMMONS_GET_BASEINFO_NEWUSERGUIDE);
end

--获取奖励类型
function getNewUserAwardType()
	return dataGetNewUserAward["TaskType"]
end

--是否领取成功
function getAwardIsResult()
	return dataGetNewUserAward["Result"]
		--    return 1
end
--提示语
function getResultTxt()
	return dataGetNewUserAward["ResultTxt"]
end

--获取奖励和地址
function getNewUserAward()
	return dataGetNewUserAward["PrizeLoop"]
end
--领取新手引导奖励
function readCOMMONS_GET_NEWUSERGUIDE_AWARD(dataTable)
	if isNewUserGuideisEnable == false then
		return
	end
	dataGetNewUserAward = {}
	--类型
	dataGetNewUserAward["TaskType"] = dataTable["TaskType"]
	--是否成功，0未成功，1成功
	dataGetNewUserAward["Result"] = dataTable["Result"]
	--提示语
	dataGetNewUserAward["ResultTxt"] = dataTable["ResultTxt"]

	dataGetNewUserAward["PrizeLoop"] = dataTable["PrizeLoop"];

	framework.emit(COMMONS_GET_NEWUSERGUIDE_AWARD);
end

--新手引导是否跳过成功
function getNewUserGuideSkipResult()
	return dataSkipNewUserGuide["SkipResult"]
end

--新手引导跳过提示语
function getNewUserGuideSkipTxt()
	return dataSkipNewUserGuide["SkipTxt"]
end

--新手引导跳过信息
function readCOMMONS_SKIP_NEWUSERGUIDE(dataTable)
	if isNewUserGuideisEnable == false then
		return
	end
	dataSkipNewUserGuide["SkipResult"] = dataTable["SkipResult"];
	dataSkipNewUserGuide["SkipTxt"] = dataTable["SkipTxt"];
	framework.emit(COMMONS_SKIP_NEWUSERGUIDE);
end

--获取新手引导方案
function getCommonNewUserGuideScheme()
	return dataNewUserGuideScheme["isFinishCommon"];
end

--新手引导方案
function readCOMMONS_GET_NEWUSERGUIDE_SCHEME(dataTable)
	if isNewUserGuideisEnable == false then
		return
	end
	dataNewUserGuideScheme["isFinishCommon"] = dataTable["isFinishCommon"];
	Common.log("numberScheme==dataNewUserGuideScheme:"..dataNewUserGuideScheme["isFinishCommon"]);
	framework.emit(COMMONS_GET_NEWUSERGUIDE_SCHEME);
end

--是否使用新手引导
function setIisNewUserGuideisEnableMessage_back(dataTable)
	if dataTable["isOpen"] == 0 then
		isNewUserGuideisEnable = false
		NewUserGuideLogic.setNewUserFlag(false);--设置完成新手引导
		NewUserGuideLogic.setIsCompleteNewUserGuide(true);
		Common.log("setIisNewUserGuideisEnableMessage_back_false")
	end
	Common.log("setIisNewUserGuideisEnableMessage_back")
end

function getisNewUserGuideisEnableMessage_back()
	return isNewUserGuideisEnableMessage_back
end

function getisNewUserGuideisEnable()
	return isNewUserGuideisEnable
end
registerMessage(COMMONS_GET_NEWUSERGUIDE_IS_OPEN,setIisNewUserGuideisEnableMessage_back);
registerMessage(COMMONS_SYN_NEWUSERGUIDE_STATE,readCOMMONS_SYN_NEWUSERGUIDE_STATE);
registerMessage(COMMONS_GET_BASEINFO_NEWUSERGUIDE,readCOMMONS_GET_BASEINFO_NEWUSERGUIDE);
registerMessage(COMMONS_GET_NEWUSERGUIDE_AWARD,readCOMMONS_GET_NEWUSERGUIDE_AWARD);
registerMessage(COMMONS_SKIP_NEWUSERGUIDE,readCOMMONS_SKIP_NEWUSERGUIDE);
registerMessage(COMMONS_GET_NEWUSERGUIDE_SCHEME,readCOMMONS_GET_NEWUSERGUIDE_SCHEME);--新手引导方案