module("Load", package.seeall)

TargetWindows = "windows"
TargetIos = "ios"
TargetAndroid = "android"
AndroidPackageName = "com.tongqu.client.lord" --Android应用包名
--平台类型
platform = ""

isLoadFromSD = false--是否从SD卡加载脚本

local isDeBug = true--当前是否是debug状态

--[[--
--打印log日志
]]
function log(...)
	if isDeBug then
		print(...)
	end
end

--[[--
--获取是否从SD卡加载脚本文件
--]]
function getLoadSDScript()
	local LoadSDScript = false
	if platform == TargetWindows then
		--windows平台
		return LoadSDScript
	elseif platform == TargetIos then
		--ios平台
		local ok,LoadSDScript = luaoc.callStaticMethod("Helper","isLoadScriptFromcache",{})
		return LoadSDScript
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "getLoadSDScript"
		local javaParams = { }
		local javaMethodSig = "()Z"
		local ok, LoadSDScript = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok and LoadSDScript then
			log("从SD卡加载脚本文件 ============= ")
			return LoadSDScript
		else
			log("从包内加载脚本文件 ============= ")
			return false
		end
	end
end

--[[--

得到写文件的路径()

@param #string dir 目录,有子文件夹格式：xxxx/，无：""

@return #string 文件的路径
]]
function getTrendsSaveFilePath(dir)
	if platform == TargetWindows then
		--windows平台
		return dir
	elseif platform == TargetIos then
		--ios平台
		return dir
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getTrendsSaveFilePath"
		local javaParams = { dir }
		local javaMethodSig = "(Ljava/lang/String;)Ljava/lang/String;"
		local ok, path = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			log("path === " .. path)
			return path
		else
			return ""
		end
	end
end

function getAndroidPackagekName()
	if platform == TargetWindows then
		--windows平台
		return ""
	elseif platform == TargetIos then
		--ios平台
		return ""
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getAndroidPackagekName"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, PackagekName = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			log("PackagekName === " .. PackagekName)
			return PackagekName
		else
			return ""
		end
	end
end


local sharedApplication = CCApplication:sharedApplication()
local target = sharedApplication:getTargetPlatform()
if target == kTargetWindows then
	platform = TargetWindows
elseif target == kTargetAndroid then
	require("script.Luaj")
	platform = TargetAndroid
elseif target == kTargetIphone or target == kTargetIpad or target == kTargetMacOS then
	require("script.Luaoc")
	platform = TargetIos
end

log("platform = ".. platform)

isReLoadLua = false;

function require_ex(_mname)
	if isReLoadLua then
		if package.loaded[_mname] ~= nil then
			--Load.log(string.format("require_ex module[%s] reload", _mname))
			package.loaded[_mname] = nil
		end
		--Load.log(string.format("require_ex = %s", _mname))
	end
	return require(_mname)
end

--[[--
--加载lua文件(加载游戏包外的文件时需要修改)
--]]
function LuaRequire(parameters)
	if Load.isLoadFromSD then
		--log("加载SDK中lua文件 =========== ")
		--SD卡中加载脚本
		if platform == TargetWindows then
		--windows平台
		elseif platform == TargetIos then
			--ios平台
			return require_ex("externRes."..parameters)
		elseif platform == TargetAndroid then
			--andorid平台
			return require_ex("LuaScript."..parameters)
		end
	else
		--游戏包中加载
		--log("加载包中lua文件 =========== ")
		return require_ex(parameters)
	end
end

--[[--
--上传lua错误日志到友盟
]]
function uploadingDebugInfo(debugInfo)
	debugInfo = Common.getVersionName() .. debugInfo

	if Common.isDebugState() then
		Common.showDebugInfo(debugInfo);
	else
		if platform == TargetWindows then
		--windows平台
		elseif platform == TargetIos then
			--ios平台
			Common.saveExceptionInfo(debugInfo)
		elseif platform == TargetAndroid then
			--andorid平台
			local javaClassName = "com.tongqu.client.utils.Pub"
			local javaMethodName = "uploadingDebugInfo"
			local javaParams = {
				debugInfo,
			}
			luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
		end
	end
end
