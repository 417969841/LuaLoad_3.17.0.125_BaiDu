module(..., package.seeall)

local VersionData = {}--礼包模块数据

local isUserInitiative = false
--[[--
--获取用户主动检测版本
]]
function getUserInitiative()
	return isUserInitiative
end

--[[--
--设置是否是用户主动检测版本
]]
function setUserInitiative(initiative)
	isUserInitiative = initiative
end

--[[--
--获取本游戏的版本升级信息
]]
function getAppVersionTable()
	local AppVersionTable = nil
	for key, var in ipairs(VersionData) do
		if var.gameName == GameConfig.APP_NAME then
			--if var.gameName == "lord" then
			AppVersionTable = var
			AppVersionTable.isUserInitiative = isUserInitiative
			break
		end
	end

	return AppVersionTable
end

-- 版本检测(BASEID_PLAT_VERSION)
function readBASEID_PLAT_VERSION(dataTable)

	VersionData = dataTable["VersionData"]

	framework.emit(BASEID_PLAT_VERSION)
end

registerMessage(BASEID_PLAT_VERSION, readBASEID_PLAT_VERSION)