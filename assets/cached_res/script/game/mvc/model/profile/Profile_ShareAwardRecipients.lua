--
-- Author: FLY
-- Date: 2015-01-26 18:05:57
--领取分享奖励
--
module(..., package.seeall)

local ButtonState = -1;--按钮状态 1显示可用 2显示不可用 3不显示
local ButtonTips = "";--按钮的提示语 只有是ButtonState == 2 时才有提示语
local BindFriendResult = -1;--绑定好友结果1成功 2失败
local BindFriendMsg = "";--成功或失败的提示语
local PrizeList = {};--奖品列表
local ButtonStataList = {};--按钮状态
ButtonStataList.SHOW_AVAILABLE = 1; --1显示可用
ButtonStataList.SHOW_NOT_AVAILABLE = 2; --2显示不可用
ButtonStataList.NOT_SHOW = 3; --3不显示

--[[--
--获取按钮的状态
--]]
function getTouchButtonStateList()
	return ButtonStataList;
end

--[[--
--设置按钮的状态
--@param #number value 状态值
--]]
function setTouchButtonState(value)
	ButtonState = value;
end

--[[--
--按钮是否可见
--@return #boolean true按钮可见 false 按钮不可见
--]]
function isButtonShow()
	if ButtonState == 1 or ButtonState == 2 then
		return true;
	else
		return false;
	end
end

--[[--
--按钮是否可以
--@return @boolean 可用指点击后能够正常进行按钮的逻辑，不可用点击弹Toast
--]]
function isButtonAvailable()
	if ButtonState == 1 then
		return true;
	else
		return false;
	end
end

--[[--
--获取点击按钮的提示语
--]]
function getTouchButtonTips()
	return ButtonTips;
end

--[[--
--获取绑定好友的结果
--]]
function getBindFriendResult()
	return BindFriendResult;
end

--[[--
--获取绑定好友成功或失败的提示语
--]]
function getBindFriendMsg()
	return BindFriendMsg;
end

--[[--
--获取奖品列表
--]]
function getPrizeList()
	return PrizeList;
end

--[[--
--保存分享V2 IOS是否可以填写好友ID
--]]
function readOPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND(dataTable)
	ButtonState = dataTable["State"];
	ButtonTips = dataTable["Msg"];
	framework.emit(OPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND);
end

--[[--
--保存分享V2 IOS绑定好友关系
--]]
function readOPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND(dataTable)
	BindFriendResult = dataTable["State"];
	BindFriendMsg = dataTable["Msg"];
	PrizeList = dataTable["Prize"];
	framework.emit(OPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND);
end

registerMessage(OPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND, readOPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND);
registerMessage(OPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND, readOPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND);