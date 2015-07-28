module(..., package.seeall)

local isEnabledReceiveRedPackage = {} --红包分享V3基本信息
local isOpenedRedPackageFunction = {} --新玩家首次领取红包V3奖励
local redPackageRewardTable = {};--红包V3新玩家首次分享
local redPackageRewardCoin = nil; --得到红包V3老玩家分享操作奖励的金币数

--请求红包分享V3基本信息
function readOPERID_SHARING_V3_BASE_INFO(dataTable)
	isEnabledReceiveRedPackage = dataTable
	framework.emit(OPERID_SHARING_V3_BASE_INFO)
end

function getOPERID_SHARING_V3_BASE_INFO()
	return isEnabledReceiveRedPackage
end

--新玩家首次领取红包V3奖励
function readOPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD(dataTable)
  isOpenedRedPackageFunction = dataTable
  framework.emit(OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD)
end

function getOPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD()
  return isOpenedRedPackageFunction
end

--红包V3新玩家首次分享
function readOPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD(dataTable)
  redPackageRewardTable = dataTable
  framework.emit(OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD)
end

function getOPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD()
  return redPackageRewardTable
end

--请求红包分享V3基本信息
registerMessage(OPERID_SHARING_V3_BASE_INFO, readOPERID_SHARING_V3_BASE_INFO)
--新玩家首次领取红包V3奖励
registerMessage(OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD, readOPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD)
--红包V3新玩家首次分享
registerMessage(OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD, readOPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD)
