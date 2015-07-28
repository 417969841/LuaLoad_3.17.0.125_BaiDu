module(..., package.seeall)

--------------------------- 脚本升级 ---------------------------

local ScriptUpdateData = {}--脚本升级数据
local ScriptMD5Data = {}--脚本MD5校验数据

--[[--
--获取脚本升级数据
--]]
function getScriptUpdateData()
	return ScriptUpdateData
end

--3.7.97 lua脚本版本检测(MANAGERID_LUA_SCRIPT_VERSION)
function readMANAGERID_LUA_SCRIPT_VERSION(dataTable)
	ScriptUpdateData = dataTable
	Common.log("脚本版本号 == "..dataTable["ScriptVerCode"])
	Common.log("升级方案 == "..dataTable["updateType"])
	Common.log("升级提示	HTML == "..dataTable["updataTxt"])
	Common.log("脚本升级Url地址 == "..dataTable["ScriptUpdateUrl"])
	Common.log("删除文件列表 == "..dataTable["fileDelListTxtUrl"])
	--		--ScriptVerCode	Int	脚本版本号
	--	dataTable["ScriptVerCode"] = nMBaseMessage:readInt()
	--	--updateType	byte	升级方案	0、不升级--1、提示升级--2、强制升级--3、有新版本，不提升(wifi下后台升级)--4、后台升级(wifi、2G下均后台升级)
	--	dataTable["updateType"] = nMBaseMessage:readByte()
	--	--updataTxt	Text	升级提示	HTML
	--	dataTable["updataTxt"] = nMBaseMessage:readString()
	--	--ScriptUpdateUrl	Text	脚本升级Url地址
	--	dataTable["ScriptUpdateUrl"] = nMBaseMessage:readString()
	--	--fileDelListTxtUrl	Text	删除文件列表
	--	dataTable["fileDelListTxtUrl"] = nMBaseMessage:readString()
	framework.emit(MANAGERID_LUA_SCRIPT_VERSION)
end

--3.7.98 lua脚本版本MD5校验(MANAGERID_LUA_SCRIPT_MD5)
function readMANAGERID_LUA_SCRIPT_MD5(dataTable)
	ScriptMD5Data = dataTable
	framework.emit(MANAGERID_LUA_SCRIPT_MD5)
end

registerMessage(MANAGERID_LUA_SCRIPT_VERSION, readMANAGERID_LUA_SCRIPT_VERSION)
registerMessage(MANAGERID_LUA_SCRIPT_MD5, readMANAGERID_LUA_SCRIPT_MD5)