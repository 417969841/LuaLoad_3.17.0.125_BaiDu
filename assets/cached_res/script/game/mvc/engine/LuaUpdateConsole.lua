module("LuaUpdateConsole", package.seeall)

local function buildLuaPath()
	Load.isLoadFromSD = Load.getLoadSDScript()
	if Load.isLoadFromSD then
		Common.log("SD卡重新构建搜索路径 =========== ")
		local target = CCApplication:sharedApplication():getTargetPlatform()
		if target == kTargetWindows then
		elseif target == kTargetAndroid then
			local path = Load.getTrendsSaveFilePath("." .. Load.getAndroidPackagekName()).."?.lua";
			package.path = package.path..";"..path;
			CCFileUtils:sharedFileUtils():addSearchPath(Load.getTrendsSaveFilePath("." .. Load.getAndroidPackagekName()));
		elseif target == kTargetIphone or target == kTargetIpad or target == kTargetMacOS then
		end
	else
		Common.log("包中搜索路径 =========== ")
	end
end

--[[--
--脚本更新完成
--]]
local function luaUpdateDoneCallBack(type)
	if Common.platform == Common.TargetIos then
		Common.log("脚本更新完成  =================== ios")
		reLordAllLua()
	elseif Common.platform == Common.TargetAndroid then
		Common.log("脚本更新完成  =================== "..type)
		if type == "1" then
			--重载
			Common.log("脚本更新完成  =================== 重载")
			reLordAllLua()
		elseif type == "0" then
			--不重载
			Common.log("脚本更新完成  =================== 不重载")
			GameLoadModuleConfig.loadGameModule();
		end
	end
end

--[[--
--脚本解压回调
--]]
function javaToLuaUnzip(progressData)
	--Common.log("javaToLuaUnzip 脚本解压回调 ======== ");
	local progress = nil
	local max = nil
	if Common.platform == Common.TargetIos then
		progress = progressData["progress"]
		max = progressData["max"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(progressData, "#")
		progress = string.sub(progressData, 1, i - 1)
		max = string.sub(progressData, j + 1, -1)
	end

	--Common.log("progress ======= "..progress)
	--Common.log("max ======= "..max)
	--Common.log("math.floor((progress * 100) / max) ======= "..math.floor((progress * 100) / max))
end

--[[--
--判断lua脚本加载
--]]
function logicLuaLord(luaUnzipCallback)
	if luaUnzipCallback == nil then
		luaUnzipCallback = javaToLuaUnzip;
	end
	if Common.platform == Common.TargetWindows then
	--windows平台
	elseif Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			unzipCallback = luaUnzipCallback,
			updateDonecallback = luaUpdateDoneCallBack,
		}
		luaoc.callStaticMethod("Helper", "logicLuaUpdateFile", args)

	elseif Common.platform == Common.TargetAndroid then
		local javaClassName = "com.tongqu.client.game.LuaUpdateConsole"
		local javaMethodName = "logicLuaUpdateFile"
		local javaParams = {
			luaUnzipCallback,
			luaUpdateDoneCallBack,
		};
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
--判断脚本加载目录
--]]
function logicScriptLoadDir()
	if Common.platform == Common.TargetWindows then
	--windows平台
	elseif Common.platform == Common.TargetIos then
	--ios平台
	elseif Common.platform == Common.TargetAndroid then
		local javaClassName = "com.tongqu.client.game.LuaUpdateConsole"
		local javaMethodName = "logicScriptLoadDir"
		local javaParams = {};
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
--重新加载lua加载
--@param #String fileName lua文件
--]]
function reLordLua(fileName)
	Common.log("重新加载lua加载"..fileName)
	Load.isReLoadLua = true;
	local data = Load.LuaRequire(fileName);
	Load.isReLoadLua = false;
	return data;
end

--[[--
--重新加载所有脚本
--]]
function reLordAllLua()
	--停止当前游戏
	mvcEngine.destroyAllModules();
	AudioManager.stopBgMusic(true);
	AudioManager.stopAllSound();
	CCTextureCache:sharedTextureCache():removeAllTextures();
	--Services:getMessageService():closeSocket();

	--判断脚本加载目录
	logicScriptLoadDir();

	--重构搜索路径
	buildLuaPath();

	--重载所有模块
	reLordLua("script.framework.FrameworkRequire");
	reLordLua("script.game.GameRequire");
	reLordLua("script.module.ModuleRequire");

	Common.log("package.path======"..package.path)

	--MassageConnect.startConnect();
	GameStartConfig.GameStart();
end
