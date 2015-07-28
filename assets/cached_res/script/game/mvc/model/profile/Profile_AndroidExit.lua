module(..., package.seeall)

local quitGuideTable = {} --系统站内信消息列表
local DownloadAppUrlTable = {};--下载App的URLtable
local ExitDataHasInit = false; --是否初始化了退出数据

local NOT_DETECTED = -1; --没有检测该应用有没有安装
local HAS_INSTALLED = 1;--已安装应用
local NO_INSTALLED = 0;--没有安装应用
local BUY_GIFT = 7; --购买礼包

local GAMEID_LORD = 1;--斗地主
local GAMEID_POK = 2;--德州扑克
local GAMEID_MAHJONG = 3;--麻将
local GAMEID_JINHUA = 4;--扎金花

local AppInfoTable = {};--应用信息

--斗地主
AppInfoTable[GAMEID_LORD .. ""] = {};
AppInfoTable[GAMEID_LORD .. ""]["PackName"] = "com.tongqu.client.lord";--游戏包名
AppInfoTable[GAMEID_LORD .. ""]["IsInstalled"] = NOT_DETECTED;--是否已经安装 1已安装 0没安装 1 没有检测该应用有没有安装
--德州扑克
AppInfoTable[GAMEID_POK .. ""] = {};
AppInfoTable[GAMEID_POK .. ""]["packName"] = "com.tongqu.client.poker"
AppInfoTable[GAMEID_POK .. ""]["isInstalled"] = NOT_DETECTED;
--麻将
AppInfoTable[GAMEID_MAHJONG .. ""] = {};
AppInfoTable[GAMEID_MAHJONG .. ""]["packName"] = "com.tongqu.client.mahjong";
AppInfoTable[GAMEID_MAHJONG .. ""]["isInstalled"] = NOT_DETECTED;
--扎金花
AppInfoTable[GAMEID_JINHUA .. ""] = {};
AppInfoTable[GAMEID_JINHUA .. ""]["packName"] = "com.tongqu.client.jinhua";
AppInfoTable[GAMEID_JINHUA .. ""]["isInstalled"] = NOT_DETECTED;

--[[--
--获取游戏详情table
--]]
function getAppInfoTable()
	return AppInfoTable;
end

--[[--
--将所有的应用状态设置的下载状态
--@param #number status 下载状态 1 已安装应用 0 没有安装应用
--]]
function setAllAppDownloadStatus(status)
	for key, value in pairs(AppInfoTable) do
		AppInfoTable[key].isInstalled = status;
	end
end

--[[--
--是否已经检测完成应用安装情况
--@param #boolean 是否已经检测完成应用安装情况
--]]
function isDetectedAppInstalledComplete()
	for key, value in pairs(AppInfoTable) do
		if AppInfoTable[key]["isInstalled"] == NOT_DETECTED then
			return false;
		end
	end

	return true;
end

--[[--
--是否有应用没下载完
--@param #boolean flag true 有false 无
--]]
function hasAppNoDownloadCompleted()
	local flag = false
	DownloadAppUrlTable = Common.LoadTable("DownloadAppUrlTable");
	if DownloadAppUrlTable == nil then
		return false;
	end
	for key, value in pairs(DownloadAppUrlTable) do
		if DownloadAppUrlTable[key] ~= nil and DownloadAppUrlTable[key]["AppUrl"] ~= nil then
			flag = true;
			break;
		end
	end
	return flag;
end

--[[--
--获取下载的App的数据
--]]
function getDownloadAppUrlData()
	local appUrlTable = {};
	for key, value in pairs(DownloadAppUrlTable) do
		if DownloadAppUrlTable[key] ~= nil and DownloadAppUrlTable[key]["AppUrl"] ~= nil then
			appUrlTable.GameID = key;
			appUrlTable.AppUrl = DownloadAppUrlTable[key]["AppUrl"];
			appUrlTable.DownloadTips = DownloadAppUrlTable[key]["DownloadTips"];
			break;
		end
	end
	return appUrlTable;
end

--[[--
--根据应用的名字设置游戏是否安装
--@param #String sGameID 应用的ID 例如：斗地主 = "1"
--@param #number isInstalled 是否已经安装 1 已安装 0 没安装
--]]
function setAppIsInstalledByName(sGameID, isInstalled)
	if AppInfoTable[sGameID] ~= nil then
		AppInfoTable[sGameID]["isInstalled"] = isInstalled;
	end
end

--[[--
--获取客户端安装的游戏的ID的拼接字符串
--]]
function getClientInstalledGameIDList()
	local sGameIDList = "";
	for key, value in pairs(AppInfoTable) do
		if AppInfoTable[key]["isInstalled"] == HAS_INSTALLED then
			sGameIDList = sGameIDList .. key .. ",";
		end
	end
	return sGameIDList;
end

--[[--
--获取系统消息列表
--@param #table quitGuideTable 服务器回来的数据
--]]
function getQuitTable()
	return quitGuideTable;
end

--[[--
--初始化退出弹框表
--@param #table dataTable 服务器回来的数据
--]]
function setQuitTable(dataTable)
	quitGuideTable = dataTable;
	ExitDataHasInit = true;
end

--[[--
--是否已经接收服务器的数据
--@return #boolean 是否已经接收服务器的数据
--]]
function getExitDataHasInit()
	return ExitDataHasInit;
end

--[[
--保存下载的AppURL
--@param #String GameID 推荐的游戏ID
--@param #String AppUrl 推荐的游戏下载地址
--@param #String sDownloadTips 推荐的游戏下载提示语
--]]
function saveDownloadAppUrl(GameID, AppUrl, sDownloadTips)
	DownloadAppUrlTable = Common.LoadTable("DownloadAppUrlTable");
	if DownloadAppUrlTable == nil or DownloadAppUrlTable[GameID] == nil then
		DownloadAppUrlTable = {};
		DownloadAppUrlTable[GameID] = {};
		DownloadAppUrlTable[GameID]["AppUrl"] = AppUrl;
		DownloadAppUrlTable[GameID]["DownloadTips"] = sDownloadTips;
	else
		DownloadAppUrlTable[GameID]["AppUrl"] = AppUrl;
		DownloadAppUrlTable[GameID]["DownloadTips"] = sDownloadTips;
	end
	Common.SaveTable("DownloadAppUrlTable", DownloadAppUrlTable)
end

--[[
--删除下载的AppURL
--@param #String GameID 推荐的游戏ID
--]]
function deleteDownloadAppUrl(GameID)
	DownloadAppUrlTable = Common.LoadTable("DownloadAppUrlTable")
	if DownloadAppUrlTable ~= nil and DownloadAppUrlTable[GameID] ~= nil then
		DownloadAppUrlTable[GameID] = {};
		Common.SaveTable("DownloadAppUrlTable", DownloadAppUrlTable)
	end
end

--[[--
--清空数据
--]]
function clearData()
	ExitDataHasInit = false;
	quitGuideTable = {};
end

--注册退出弹框消息
registerMessage(MANAGERID_QUIT_GUIDE, setQuitTable)