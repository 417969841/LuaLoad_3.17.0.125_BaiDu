require("script.LoadFunctions")

local function buildLuaPath()
	Load.isLoadFromSD = Load.getLoadSDScript()
	if Load.isLoadFromSD then
		local target = CCApplication:sharedApplication():getTargetPlatform()
		if target == kTargetWindows then
		elseif target == kTargetAndroid then
			local path = Load.getTrendsSaveFilePath("." .. Load.getAndroidPackagekName()).."?.lua";
			package.path = package.path..";"..path;
			CCFileUtils:sharedFileUtils():addSearchPath(Load.getTrendsSaveFilePath("." .. Load.getAndroidPackagekName()));
		elseif target == kTargetIphone or target == kTargetIpad or target == kTargetMacOS then
		end
	end
end

local function game()

	buildLuaPath()

	Load.LuaRequire("script.framework.FrameworkRequire")
	Load.LuaRequire("script.game.GameRequire")
	Load.LuaRequire("script.module.ModuleRequire")

	Common.log("package.path======"..package.path)

	MassageConnect.startConnect();
	GameStartConfig.GameStart();
end

local function main()
	game()
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
	Load.log("----------------------------------------")
	local debugMsg = "LUA ERROR: " .. tostring(msg) .. "\n"
	local debugInfo = debug.traceback()
	Load.log(debugMsg)
	Load.log(debugInfo)
	Load.uploadingDebugInfo(debugMsg .. debugInfo)
	Load.log("----------------------------------------")
end

xpcall(main, __G__TRACKBACK__)