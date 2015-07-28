module(..., package.seeall)
local NewUserTaskInfo = {};
local NewUserTaskIsComplete = {};
local NewUserTaskAward = {};

--新手任务基本信息
function getCOMMONS_V3_NEWUSER_TASK_INFO()
	return NewUserTaskInfo;
end

function getNewUserTaskInfoIsComplete()
	--当前任务是否完成，1完成，0未完成
	if(NewUserTaskInfo["isComplete"] == 1)then
		return true;
	else
		return false;
	end
end

--图片地址和描述
function getNewUserPicAndTitle()
	return NewUserTaskInfo["awardList"];
end

--新手任务基本信息
function readCOMMONS_V3_NEWUSER_TASK_INFO(dataTable)
	NewUserTaskInfo = {};
	--当前任务号
	NewUserTaskInfo["taskNum"] = dataTable["taskNum"];
	--当前任务是否完成，1完成，0未完成
	NewUserTaskInfo["isComplete"] = dataTable["isComplete"];
	--任务标题
	NewUserTaskInfo["taskTitle"] = dataTable["taskTitle"];
	--任务达成条件
	NewUserTaskInfo["taskRequirement"] = dataTable["taskRequirement"];
	--任务进度
	NewUserTaskInfo["taskSchedule"] = dataTable["taskSchedule"];
	--任务奖励
	NewUserTaskInfo["taskAward"] = dataTable["taskAward"];
	--图片地址和描述
	NewUserTaskInfo["awardList"] = dataTable["awardList"];
	framework.emit(COMMONS_V3_NEWUSER_TASK_INFO);
end

function getNEWUSER_TASK_IS_COMPLETE()
	return NewUserTaskIsComplete;
end

--新手任务是否完成
function readCOMMONS_V3_NEWUSER_TASK_IS_COMPLETE(dataTable)
	NewUserTaskIsComplete = {};
	--任务完成编号，如果是-1，全部完成，0全部为完成
	NewUserTaskIsComplete["taskNum"] = dataTable["taskNum"];
	framework.emit(COMMONS_V3_NEWUSER_TASK_IS_COMPLETE);
end

function getCOMMONS_V3_NEWUSER_TASK_AWARD()
	return NewUserTaskAward;
end

--新手任务领取奖励
function readCOMMONS_V3_NEWUSER_TASK_AWARD(dataTable)
	NewUserTaskAward = {};
	--当前任务号
	NewUserTaskAward["taskNum"] = dataTable["taskNum"];
	--是否领奖成功，1成功，0未成功
	NewUserTaskAward["isSuccess"] = dataTable["isSuccess"];
	--是否领奖成功，1成功，0未成功
	NewUserTaskAward["allComplete"] = dataTable["allComplete"];
	--提示语
	NewUserTaskAward["ResultTxt"] = dataTable["ResultTxt"];
	--奖励地址和图片
	NewUserTaskAward["awardList"] = dataTable["awardList"];
	framework.emit(COMMONS_V3_NEWUSER_TASK_AWARD);
end
registerMessage(COMMONS_V3_NEWUSER_TASK_INFO,readCOMMONS_V3_NEWUSER_TASK_INFO);
registerMessage(COMMONS_V3_NEWUSER_TASK_IS_COMPLETE,readCOMMONS_V3_NEWUSER_TASK_IS_COMPLETE);
registerMessage(COMMONS_V3_NEWUSER_TASK_AWARD,readCOMMONS_V3_NEWUSER_TASK_AWARD);