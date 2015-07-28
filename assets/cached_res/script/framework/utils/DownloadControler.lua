module("DownloadControler",package.seeall)

--安装：即表示下载后自动执行安装操作，不需要用户确认。一般在户客户端下载或强制更新时使用。
DOWNLOAD_ACTION_A = 0;
--特殊处理：即表示在执行完下载操作后对所下载目标进行有针对性的特殊操作。需等待用户触发或其他需求。
DOWNLOAD_ACTION_B = 1;
--解压：即表示下载完成后自动进行解压操作，无需用户主动执行操作。一般用于小游戏的下载或更新。
DOWNLOAD_ACTION_C = 2;
--删除：即表示该目标在完成下载后即刻删除，不做任何其他处理。一般用于自动下载APK功能。
DOWNLOAD_ACTION_D = 3;
--通知：即表示下载成功后不做操作，只对用户进行弹通知操作。
DOWNLOAD_ACTION_E = 4;
--弹Toast：即表示下载成功后不做操作，只对用户进行弹Toast操作。
DOWNLOAD_ACTION_F = 5;
--弹启动询问：即表示下载成功后对用户进行启动询问，若用户同意则直接进入所启动程序。一般用于小游戏下载、更新或主体游戏更新。
DOWNLOAD_ACTION_G = 6;
--lua升级文件下载
DOWNLOAD_ACTION_H = 7;

--[[--
-- 校验文件
@param url 文件网络地址
@param dir 本地存储地址
@return true 文件完整，false 文件不完整
--]]
function verifyZipFile(url, dir)
	if Common.platform == Common.TargetWindows then
		--windows平台
		return ""
	elseif Common.platform == Common.TargetIos then
	--ios平台
	elseif Common.platform == Common.TargetAndroid then

		local javaClassName = "com.tongqu.client.game.LuaCallDownloadControler"
		local javaMethodName = "LuaCallVerifyZipFile"
		local javaParams = {
			url,
			dir,
		}
		local ok, ret = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")
		if ret then
			return true
		else
			return false
		end
	end
end

--[[--
-- 下载文件
@param url 下载地址
@param dir 存放路径
@param engineId 通知ID DOWNLOAD_ACTION_A...
@param isRestriction 是否限速
@param isShowDialog 是否显示现在进度界面
@param sDownloadTips 下载提示语,传进来的为"",则会显示默认的提示语
--]]
function getDownloadFile(url, dir, engineId, isRestriction, isShowDialog, sDownloadTips)
	if sDownloadTips == nil or sDownloadTips == "" then
		sDownloadTips = "正在为您下载游戏,请稍后...";
	end

	if Common.platform == Common.TargetWindows then
		--windows平台
		return ""
	elseif Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			ScriptUpdateUrl = url,
			ShowDialog = isShowDialog and  "true" or "",
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "loadNewScript", args)
		if ok then
			return ret
		else
			return nil
		end
	elseif Common.platform == Common.TargetAndroid then

		local javaClassName = "com.tongqu.client.game.LuaCallDownloadControler"
		local javaMethodName = "LuaCallGetDownloadFile"
		local javaParams = {
			url,
			dir,
			engineId,
			isRestriction,
			isShowDialog,
			sDownloadTips,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
-- 下载lua脚本升级文件
@param #String zipUrl zip包下载地址
@param #String delUrl 删除目录下载地址
@param #String dir 存放路径
@param #number engineId 通知ID DOWNLOAD_ACTION_A...
@param #boolean isRestriction 是否限速
@param #boolean isShowDialog 是否显示现在进度界面
@param #String sDownloadTips 下载提示语,传进来的为"",则会显示默认的提示语
@param #function callback 下载完成后回调
@param #boolean restart 是否需要重启更新
--]]
function getDownloadLuaUpdateFile(zipUrl, delUrl, dir, engineId, isRestriction, isShowDialog, sDownloadTips, callback, restart)
	if sDownloadTips == nil or sDownloadTips == "" then
		sDownloadTips = "正在为您下载游戏,请稍后...";
	end

	if Common.platform == Common.TargetWindows then
		--windows平台
		return ""
	elseif Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			ScriptUpdateUrl = delUrl,
			ShowDialog = isShowDialog and  "true" or "",
		}
		luaoc.callStaticMethod("Helper", "loadNewScript", args)

		local args = {
			ScriptUpdateUrl = zipUrl,
			ShowDialog = isShowDialog and  "true" or "",
		}
		luaoc.callStaticMethod("Helper", "loadNewScript", args)

	elseif Common.platform == Common.TargetAndroid then

		local javaClassName = "com.tongqu.client.game.LuaCallDownloadControler"
		local javaMethodName = "getDownloadLuaUpdateFile"
		local javaParams = {
			zipUrl,
			delUrl,
			dir,
			engineId,
			isRestriction,
			isShowDialog,
			sDownloadTips,
			callback,
			restart,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
-- 下载牌桌文件
@param url 下载地址
@param dir 存放路径
@param engineId 通知ID DOWNLOAD_ACTION_A...
@param isRestriction 是否限速
@param isShowDialog 是否显示现在进度界面
@param isTableRes 是否是牌桌资源
@param callBackFunc 回调方法
--]]
function getTableDownloadFile(url, dir, engineId, isRestriction, isShowDialog, isTableRes, isPause, callBackFunc)
	if Common.platform == Common.TargetWindows then
		--windows平台
		return ""
	elseif Common.platform == Common.TargetIos then
	--ios平台
	elseif Common.platform == Common.TargetAndroid then

		local javaClassName = "com.tongqu.client.game.LuaCallDownloadControler"
		local javaMethodName = "LuaCallGetTableDownloadFile"
		local javaParams = {
			url,
			dir,
			engineId,
			isRestriction,
			isShowDialog,
			isTableRes,
			isPause,
			callBackFunc,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
-- 根据url获取zip包路径
@param url 下载地址
--]]
function getZipFilePath(url, dir)
	if Common.platform == Common.TargetWindows then
		--windows平台
		return ""
	elseif Common.platform == Common.TargetIos then
	--ios平台
	elseif Common.platform == Common.TargetAndroid then

		local javaClassName = "com.tongqu.client.game.LuaCallDownloadControler"
		local javaMethodName = "LuaCallGetZipFilePath"
		local javaParams = {
			url,
			dir,
		}
		local ok, ret = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Ljava/lang/String;")
		if ret then
			return ret
		end
	end
end

--[[--
-- 校验解压后文件完整性（是都解压完全，解压后的文件大小是否一致）
@param dir 解压到的详细路径
@param zipFilePath zip文件详细路径
--]]
function verifyUnZipedFiles(dir, zipFilePath)
	if Common.platform == Common.TargetWindows then
		--windows平台
		return ""
	elseif Common.platform == Common.TargetIos then
	--ios平台
	elseif Common.platform == Common.TargetAndroid then

		local javaClassName = "com.tongqu.client.game.LuaCallDownloadControler"
		local javaMethodName = "LuaCallVerifyUnZipedFiles"
		local javaParams = {
			dir,
			zipFilePath,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
-- zip解压后的文件是否可以使用
@param zipFilePath zip文件详细路径
--]]
function isCanAccessZip(zipFilePath)
	if Common.platform == Common.TargetWindows then
		--windows平台
		return ""
	elseif Common.platform == Common.TargetIos then
	--ios平台
	elseif Common.platform == Common.TargetAndroid then

		local javaClassName = "com.tongqu.client.game.LuaCallDownloadControler"
		local javaMethodName = "LuaCallIsCanAccessZip"
		local javaParams = {
			zipFilePath,
		}
		local ok, ret = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")
		if ret then
			return true
		else
			return false
		end
	end
end

--[[--
-- 文件是否存在
@param @param url 下载地址
--]]
function existsFile(url, dir)
	if Common.platform == Common.TargetWindows then
		--windows平台
		return ""
	elseif Common.platform == Common.TargetIos then
	--ios平台
	elseif Common.platform == Common.TargetAndroid then

		local javaClassName = "com.tongqu.client.game.LuaCallDownloadControler"
		local javaMethodName = "LuaCallExistsFile"
		local javaParams = {
			url,
			dir,
		}
		local ok, ret = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")
		if ret then
			return true
		else
			return false
		end
	end
end

--[[--
-- 校验解压后文件完整性（是都解压完全，解压后的文件大小是否一致）
@param url 下载网址
@param dir 解压到的详细路径
--]]
function startVerifyUnZipedFiles(url, dir)
	local zipFilePath = getZipFilePath(url, dir)
	verifyUnZipedFiles(Common.getTrendsSaveFilePath(dir), zipFilePath)
end

--[[--
--zip包是否可用
--]]
function isZipCanUse(url, dir)
	local isVerifyZipFile = verifyZipFile(url, dir)
	local isExistsFile = existsFile(url, dir)
	if not isVerifyZipFile or not isExistsFile then
		return false
	else
		return true
	end
end

--[[--
--资源是否可用
--]]
function isResourceCanUse(url, dir)
	return isCanAccessZip(getZipFilePath(url, dir))
end