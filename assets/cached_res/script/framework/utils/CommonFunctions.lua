module("Common", package.seeall)

TargetWindows = "windows"
TargetIos = "ios"
TargetAndroid = "android"

--平台类型
platform = ""

local PackageResourcePath = "res/" --应用包中资源路径

local isDeBug = false --当前是否是debug状态
local exitScheduler = nil -- 退出任务
local hasSendOnlineMsg = false; --是否已经发生在线时长消息

local batteryLevel = -1--电池电量等级

--[[--
--打印log日志
]]
function log(...)
	if isDeBug then
		print(...)
	end
end

--[[--
--是否是debug模式
--]]
function isDebugState()
	return isDeBug
end

--[[--
--弹出debug信息框
-- ]]
function showDebugInfo(info)
	if isDeBug then
		CommDialogConfig.createDebugInfo(info);
	end
end

--[[--
--得到版本编号
--]]
function getScriptVerCode(sVersionCode)
	if platform == TargetWindows then
		--windows平台
		return "";
	elseif platform == TargetIos then
		--ios平台
		local args = {
			Version = sVersionCode,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "returnVersion", args)
		return ret
	elseif platform == TargetAndroid then
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getScriptVerCode"
		local javaParams = {
			sVersionCode
		};
		local ok, ScriptData = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "I")
		return ScriptData;
	end
end

--[[--
--从Assets卡获取脚本数据
--]]
function getScriptDataFromAssets(key)
	if platform == TargetWindows then
		--windows平台
		return "";
	elseif platform == TargetIos then
		--ios平台
		return "";
	elseif platform == TargetAndroid then
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getScriptDataFromAssets"
		local javaParams = {
			key
		};
		local ok, ScriptData = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Ljava/lang/String;")
		return ScriptData;
	end
end

--[[--
--获取是否存在此脚本文件
--@return #type description
--]]
function getScriptIsExists(fileDir, fileName)
	if platform == TargetWindows then
		--windows平台
		return true;
	elseif platform == TargetIos then
		--ios平台
		return true;
	elseif platform == TargetAndroid then
		if Load.isLoadFromSD then
			local javaClassName = "com.tongqu.client.utils.Pub"
			local javaMethodName = "logicScriptIsExistsFromSD"
			local javaParams = {
				fileDir .. fileName
			}
			local ok, InExists = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")

			if ok and InExists then
				return true
			else
				Common.log(fileName .." SD不存在此脚本文件==================")
				return false
			end
		else
			local javaClassName = "com.tongqu.client.utils.Pub"
			local javaMethodName = "logicScriptIsExistsFromAssets"
			local javaParams = {
				fileDir,
				fileName
			}
			local ok, InExists = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")

			if ok and InExists then
				return true
			else
				Common.log(fileName .." Assets不存在此脚本文件==================")
				return false
			end
		end
	end
end

--[[--
--从SD获取脚本数据
--]]
function getScriptDataFromSD(key)
	if platform == TargetWindows then
		--windows平台
		return "";
	elseif platform == TargetIos then
		--ios平台
		return "";
	elseif platform == TargetAndroid then
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getScriptDataFromSD"
		local javaParams = {
			key
		};
		local ok, ScriptVerCode = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Ljava/lang/String;")
		return ScriptVerCode;
	end
end

--[[--
-- 判断脚本文件是否已经复制到SD卡中
--
-- @return true:已经在sd卡中
--]]--
function logicScriptInSD()
	local InSD = false

	if platform == TargetWindows then
		--windows平台
		return InSD
	elseif platform == TargetIos then
		--ios平台
		return CCUserDefault:sharedUserDefault():getBoolForKey("isCopy")
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "logicScriptInSD"
		local javaParams = {  }
		local ok, InSD = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")

		if ok and InSD then
			--SD卡中没有脚本,需要比较版本号
			local sVersionCodeFromAssets = getScriptDataFromAssets("scriptVerName")
			Common.log("logicScriptInSD 包内：sVersionCodeFromAssets === " .. sVersionCodeFromAssets);
			local scriptVersionFromAssets = getScriptVerCode(sVersionCodeFromAssets);
			Common.log("logicScriptInSD 包内：getScriptVerCodeFromAssets === " .. scriptVersionFromAssets);
			local sVersionCodeFromSD = getScriptDataFromSD("scriptVerName")
			Common.log("logicScriptInSD SD卡：sVersionCodeFromSD === " .. sVersionCodeFromSD);
			local scriptVersionFromSD = getScriptVerCode(sVersionCodeFromSD);
			Common.log("logicScriptInSD SD卡：getScriptVerCodeFromSD === " .. scriptVersionFromSD);
			if (scriptVersionFromAssets <= scriptVersionFromSD) then
				Common.log("logicScriptInSD 脚本文件已经复制到SD卡中");
				return true;
			else
				Common.log("logicScriptInSD 脚本文件没有复制到SD卡中");
				return false;
			end
		end
	end
end

--[[--
--下载的zip包存放目录
--@return
--]]--
function getZipDownloadDir()
	local zipFilePath = ""
	if platform == TargetWindows then
		--windows平台
		return zipFilePath
	elseif platform == TargetIos then
		--ios平台
		return zipFilePath
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "getZipDownloadDir"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, zipFilePath = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			return zipFilePath
		else
			return ""
		end
	end
end

--[[--
--脚本文件存放的路径
--@return
--]]--
function getScriptFilePath()
	local ScriptFilePath = ""
	if platform == TargetWindows then
		--windows平台
		return ScriptFilePath
	elseif platform == TargetIos then
		--ios平台
		return  ScriptFilePath
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "getScriptFilePath"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, ScriptFilePath = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			return ScriptFilePath
		else
			return ""
		end
	end
end

--[[--
--下载应用存放的路径
--@return
--]]--
function getAppDownloadPath()
	local ScriptFilePath = ""
	if platform == TargetWindows then
		--windows平台
		return ScriptFilePath
	elseif platform == TargetIos then
		--ios平台

		return  ScriptFilePath
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getSavePath"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, ScriptFilePath = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			return ScriptFilePath
		else
			return ""
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
			--log("path === " .. path)
			return path
		else
			return ""
		end
	end
end

--[[--

在应用内创建文件夹

@param #string dir 目录,有子文件夹格式：xxxx/，无：""

@return #string 文件的路径
]]
function getTrendsSaveFilePathOwned(dir)
	if platform == TargetWindows then
		--windows平台
		return dir
	elseif platform == TargetIos then
	--ios平台

	elseif platform == TargetAndroid then
	--android平台
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
			--log("PackagekName === " .. PackagekName)
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
	PackageResourcePath = "res/"
elseif target == kTargetAndroid then
	platform = TargetAndroid
	if Load.isLoadFromSD then
		PackageResourcePath = getScriptFilePath().."res/"
	else
		PackageResourcePath = "res/"
	end
elseif target == kTargetIphone or target == kTargetIpad or target == kTargetMacOS then
	platform = TargetIos
	if Load.isLoadFromSD then
		PackageResourcePath = "externRes/res/"
	else
		PackageResourcePath = "res/"
	end
end

log("platform = ".. platform)
log("PackageResourcePath = ".. PackageResourcePath)

--[[--
--获取资源存放路径
--]]
function getPackageResourcePath()
	return PackageResourcePath
end

--[[--
获取资源路径

@param #string filename --资源文件名
@return #string path 返回符合平台的资源路径
]]
function getResourcePath(fileName)
	local path = ""
	if platform == TargetWindows then
		--windows平台资源路径
		path = PackageResourcePath .. fileName
	elseif platform == TargetIos then
		--ios平台资源路径
		path = PackageResourcePath .. fileName
	elseif platform == TargetAndroid then
		--android平台资源路径
		--游戏包中资源
		path = PackageResourcePath .. fileName
	end
	return path
end

--[[--
--获得应用版本号(不带渠道号)
--@return #number 应用版本号
--]]
function getVersionCode()
	if platform == TargetWindows then
		--windows平台
		return 1
	elseif platform == TargetIos then
		--ios平台
		local args = {
			Version = CCUserDefault:sharedUserDefault():getStringForKey("tongquGameVersion"),
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "returnVersion", args)
		return ret
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getVersionCodeNoChannel"
		local javaParams = {}
		local javaMethodSig = "()I"
		local ok, VersionCode = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			--log("VersionCode === " .. VersionCode)
			return tonumber(VersionCode)
		else
			return 0
		end
	end
end

--[[--

获取渠道号

@return #number 渠道号

]]
function getChannelID()
	if platform == TargetWindows then
		--windows平台
		return 0
	elseif platform == TargetIos then
		--ios平台
		return GameConfig.IOSChannelID
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getChannelID"
		local javaParams = {}
		local javaMethodSig = "()I"
		local ok, ChannelID = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			--log("ChannelID === " .. ChannelID)
			return tonumber(ChannelID)
		else
			return 0
		end
	end
end

--[[--

获得推荐人ID

@return #number 应用版本号
]]
function getIntroducerID()
	if platform == TargetWindows then
		--windows平台
		return 0
	elseif platform == TargetIos then
		--ios平台
		--		local args = {
		--			Version = CCUserDefault:sharedUserDefault():getStringForKey("tongquGameVersion"),
		--		}
		--		local ok, ret = luaoc.callStaticMethod("Helper", "returnVersion", args)
		return 0
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getJSONObject"
		local javaParams = {}
		local javaMethodSig = "()I"
		local ok, IntroducerID = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			Common.log("IntroducerID === " .. IntroducerID)
			return IntroducerID
		else
			return 0
		end
	end
end

--[[--

IMIE号和MAC 以html5/android/ios +’_’开头+IMIE_MAC

@return #string IMIE号和MAC

]]
function getDeviceInfo()
	if platform == TargetWindows then
		--windows平台
		return "imei_test"
	elseif platform == TargetIos then
		--ios平台
		local args = {
			userID = "",
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "getUDID", args)
		if ok then
			local udid = ret["udid"]
			log("udid ======= "..udid);
			return "ios_"..udid.."_null"
		else
			return ""
		end
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getDeviceInfo"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, imei = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			log("imei === " .. imei)
			return imei
		else
			return ""
		end
	end
end

--[[--

得到Mac地址

@return #string Mac地址
]]
function getMacAddr()
	if platform == TargetWindows then
		--windows平台
		return "imei_test"
	elseif platform == TargetIos then
		--ios平台

		local args = {
			userID = "",
		}
		local ok, ret = luaoc.callStaticMethod("Assistant", "macaddress", args)
		if ok then
			local macaddress = ret["macaddress"]
			return macaddress
		else
			return "imei_test"
		end

	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getMacAddr"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, MacAddr = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			--log("MacAddr === " .. MacAddr)
			return MacAddr
		else
			return ""
		end
	end
end

UNKNOWN = 0; --未知
CHINA_MOBILE = 1; -- 移动
CHINA_UNICOM = 2; -- 联通
CHINA_TELECOM = 3; -- 电信

--[[--

获取运营商类型

@return #number 运营商
]]

function getOperater()
	if platform == TargetWindows then
		--windows平台
		return CHINA_MOBILE
	elseif platform == TargetIos then
		--ios平台
		local args = {}

		local ok , ret = luaoc.callStaticMethod("Assistant", "yunying", args)
		if ok then
			return tonumber(ret["yunying"])
		else
			return ""
		end
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getOperater"
		local javaParams = {}
		local javaMethodSig = "()I"
		local ok, Operater = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			--log("Operater === " .. Operater)
			return Operater
		else
			return ""
		end
	end
end

NET_WIFI = 1; --wifi
NET_2G = 2;
NET_3G = 3;
NET_4G = 4;
--[[--

获取设备网络类型

@return #number 网络类型
]]
function getConnectionType()
	if platform == TargetWindows then
		--windows平台
		return NET_WIFI
	elseif platform == TargetIos then
		--ios平台

		local args = {}

		local ok , ret = luaoc.callStaticMethod("Assistant", "getNetType", args)
		if ok then
			return ret["nettype"]
		else
			return ""
		end
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getConnectionType"
		local javaParams = {}
		local javaMethodSig = "()I"
		local ok, ConnectionType = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			log("ConnectionType === " .. ConnectionType)
			return ConnectionType
		else
			return ""
		end
	end
end

--[[--

得到当前界面是否是横屏

@return #boolean true:横屏 false:竖屏
]]
function isLandscape()
	if platform == TargetWindows then
		--windows平台
		return true
	elseif platform == TargetIos then
		--ios平台
		return true
	elseif platform == TargetAndroid then
		--android平台

		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "isLandscape"
		local javaParams = {}
		local javaMethodSig = "()Z"
		local ok, Landscape = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			log("Landscape === " .. Landscape)
			return Landscape
		else
			return ""
		end
	end
end

--[[--

获取手机号

@return #string 手机号
]]
function getTelephonyNumber()
	if platform == TargetWindows then
		--windows平台
		return ""
	elseif platform == TargetIos then
		--ios平台
		return ""
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getNumber"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, TelephonyNumber = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			log("TelephonyNumber === " .. TelephonyNumber)
			return TelephonyNumber
		else
			return ""
		end
	end
end

--[[--
--图片是否存在
--]]
function getPicExists(picUrl)
	if picUrl == nil or picUrl == "" then
		return false;
	end
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
		--ios平台
		local args = {
			imgurl = picUrl,
		}
		local ok, exists = luaoc.callStaticMethod("UserAvator", "picExists", args)
		if ok then
			return exists
		else
			return false
		end
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "picExists"
		local javaParams = {
			picUrl,
		}
		local ok, exists = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")
		if ok then
			return exists
		else
			return false
		end
	end
end

--[[--
下载图片文件

@param #String picUrl 图片下载地址
@param #number nResID 下载任务ID
@param #boolean bHighPri 是否紧急任务
@param #function callBackFunction 下载完成后的回调方法

]]
function getPicFile(picUrl, nResID, bHighPri, callBackFunction)
	if picUrl == nil or picUrl == "" then
		return;
	end
	if platform == TargetWindows then
	--windows平台

	elseif platform == TargetIos then
		--ios平台

		local args = {
			imgurl = picUrl,
			callBackFunctionVar = callBackFunction,
			nResIDVal = nResID,
		}
		local ok, ret = luaoc.callStaticMethod("UserAvator", "downAvator", args)
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "downloadImage"
		local javaParams = {
			picUrl,
			nResID,
			callBackFunction
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end

end


local cjson = require("cjson")

--[[--

数据转json

@param #table tab table数据
@return #json 转换后的json数据
]]
local function encode(tab)
	local status, result = pcall(cjson.encode, tab)
	if status then return result end
end

--[[--

json转数据

@param #json jsonData json数据
@return #table 转换后的table数据
]]
local function decode(jsonData)
	local status, result = pcall(cjson.decode, jsonData)
	if status then return result end
end

--应用本地目录
writablePath = CCFileUtils:sharedFileUtils():getWritablePath()

--[[--

存储table数据

@param #string fileName 文件名
@param #table data table数据
]]
function SaveTable(fileName, data)
	local file
	file = io.open(writablePath .. fileName .. ".json", "w")
	if file ~= nil then
		assert(file)
		local wirtjson = encode(data) --转换成json格式
		--log(wirtjson)
		file:write(wirtjson)
		file:close();
	end
end

--[[--

读取json数据,返回table

@param #string fileName 文件名
@return #table table数据
]]
function LoadTable(fileName)
	local file
	file = io.open(writablePath .. fileName .. ".json", "r")
	local table
	if file ~= nil then
		assert(file)
		local readjson = file:read("*a") -- 读取所有内容
		--log(readjson)
		table = decode(readjson) --转成原来存储前的格式
		file:close()
	end
	return table
end

--[[--

存储table数据到SD卡上

@param #string fileName 文件名
@param #table data table数据
]]
function SaveShareTable(fileName, data)
	local file
	if platform == TargetWindows then
		--windows平台
		file = io.open(writablePath .. fileName .. ".json", "w")
	elseif platform == TargetIos then
		--ios平台
		file = io.open(writablePath .. fileName .. ".json", "w")
	elseif platform == TargetAndroid then
		--android平台
		file = io.open(getTrendsSaveFilePath("TqPic") .. fileName .. ".json", "w")
	end
	if file ~= nil then
		assert(file)
		local wirtjson = encode(data) --转换成json格式
		file:write(wirtjson)
		file:close();
	end
end

--[[--

从SD卡上读取json数据,返回table

@param #string fileName 文件名
@return #table table数据
]]
function LoadShareTable(fileName)
	local file
	if platform == TargetWindows then
		--windows平台
		file = io.open(writablePath .. fileName .. ".json", "r")
	elseif platform == TargetIos then
		--ios平台
		file = io.open(writablePath .. fileName .. ".json", "r")
	elseif platform == TargetAndroid then
		--android平台
		file = io.open(getTrendsSaveFilePath("TqPic") .. fileName .. ".json", "r")
	end
	local table
	if file ~= nil then
		assert(file)
		local readjson = file:read("*a") -- 读取所有内容
		table = decode(readjson) --转成原来存储前的格式
		file:close()
	end
	return table
end

--[[--

存储用户数据到SD卡上

@param #string fileName 文件名
@param #table data table数据
]]
function SaveShareUserTable(fileName, data)
	local file
	if platform == TargetWindows then
		--windows平台
		file = io.open(writablePath .. fileName .. ".json", "w")
	elseif platform == TargetIos then
		--ios平台
		file = io.open(writablePath .. fileName .. ".json", "w")
	elseif platform == TargetAndroid then
		--android平台
		local UserID = ""..data["UserID"]
		local nickname = data["nickname"]
		local password = data["password"]
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "SaveShareUserData"
		local javaParams = {
			nickname,
			password,
			UserID,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
		--本地也要存储用户数据
		file = io.open(writablePath .. fileName .. ".json", "w")
	end
	if file ~= nil then
		assert(file)
		local wirtjson = encode(data) --转换成json格式
		file:write(wirtjson)
		file:close();
	end
end

--[[--

从SD卡上读取用户数据,返回table

@param #string fileName 文件名
@return #table table数据
]]
function LoadShareUserTable(fileName)
	local file
	local table = {}
	if platform == TargetWindows then
		--windows平台
		file = io.open(writablePath .. fileName .. ".json", "r")
	elseif platform == TargetIos then
		--ios平台
		file = io.open(writablePath .. fileName .. ".json", "r")
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "LoadShareUserData"
		local javaParams = {
			}
		local ok, userData = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Ljava/lang/String;")
		if ok and userData ~= ""  then
			--读取到SD卡上用户数据
			local UserTable = FGUtilStringSplit(userData, "#")
			table.nickname = UserTable[1]
			table.password = UserTable[2]
			table.UserID = UserTable[3]
		else
			--读取到本地用户数据
			file = io.open(writablePath .. fileName .. ".json", "r")
		end
	end
	if file ~= nil then
		assert(file)
		local readjson = file:read("*a") -- 读取所有内容
		table = decode(readjson) --转成原来存储前的格式
		file:close()
	end
	return table
end

--本地数据库
local SqliteTable = {}

--[[--

存储table数据到本地数据库中

]]
local function SaveSqliteTable()
	local file
	local fileName = "SqliteTable"
	file = io.open(writablePath .. fileName .. ".json", "w")
	if file ~= nil then
		assert(file)
		local wirtjson = encode(SqliteTable) --转换成json格式
		file:write(wirtjson)
		file:close();
	end
end

--[[--

从本地数据库中读取json数据,存入SqliteTable中

]]
local function LoadSqliteTable()

	--log("从本地数据库中读取json数据,存入SqliteTable中")

	local file
	local fileName = "SqliteTable"
	file = io.open(writablePath .. fileName .. ".json", "r")
	if file ~= nil then
		assert(file)
		local readjson = file:read("*a") -- 读取所有内容
		SqliteTable = decode(readjson) --转成原来存储前的格式
		file:close()
	end
end

LoadSqliteTable()

--[[--

存储数据到本地数据库中

@param #string Key 数据索引
@param #obj Value 数值

]]
function setDataForSqlite(Key, Value)
	if SqliteTable == nil then
		SqliteTable = {};
	end
	SqliteTable[Key] = Value
	SaveSqliteTable()
end

--[[--

从本地数据库中获取数据

@param #string Key 数据索引
@return #obj Value 数值(返回数据或者nil)

]]
function getDataForSqlite(Key)
	if SqliteTable ~= nil and SqliteTable[Key] ~= nil then
		return SqliteTable[Key]
	else
		return nil
	end
end

--[[--

上传头像
]]
function uploadAvator(callBackFunction)
	if platform == TargetWindows then
		--windows平台
		return true
	elseif platform == TargetIos then
		--ios平台
		local userID = profile.User.getSelfUserID()
		local password = profile.User.getSelfPassword()

		local args = {
			userID = userID,
			password = password,
			call = callBackFunction,
		}
		local ok, ret = luaoc.callStaticMethod("UserAvator", "changeAvator", args)
		if ok then
			return true
		else
			return false
		end
	elseif platform == TargetAndroid then
		--android平台
		local userID = profile.User.getSelfUserID()
		local password = profile.User.getSelfPassword()
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "uploadingPhoto"
		local javaParams = {
			userID,
			password,
			callBackFunction,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
		return true
	end
end

--[[--
显示loadling弹出框
--]]
function showProgressDialog(msg, x, y,isHightLight)
	if not GameLoadingLogic.isLoadingShow() then
		GameLoadingLogic.showLoadingView(x, y,isHightLight)
	end
	--	if platform == TargetWindows then
	--	--windows平台
	--	elseif platform == TargetIos then
	--		--ios平台
	--
	--
	--		local args = {
	--			flag = msg,
	--		}
	--		local ok, ret = luaoc.callStaticMethod("Helper", "showLoadingView", args)
	--		if ok then
	--			return true
	--		else
	--			return false
	--		end
	--	elseif platform == TargetAndroid then
	--		--android平台
	--		local javaClassName = "com.tongqu.client.utils.Pub"
	--		local javaMethodName = "showProgressDialog"
	--		local javaParams = { msg, }
	--		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	--	end
end

--[[--
关闭loadling弹出框
--]]
function closeProgressDialog()
	if GameLoadingLogic.isLoadingShow() then
		GameLoadingLogic.closeLoadingView()
	end
	--	if platform == TargetWindows then
	--	--windows平台
	--	elseif platform == TargetIos then
	--		--ios平台
	--
	--		local args = {
	--			flag = "0",
	--		}
	--		local ok, ret = luaoc.callStaticMethod("Helper", "hideLoadingView", args)
	--		if ok then
	--			return true
	--		else
	--			return false
	--		end
	--	elseif platform == TargetAndroid then
	--		--android平台
	--		local javaClassName = "com.tongqu.client.utils.Pub"
	--		local javaMethodName = "closeProgressDialog"
	--		local javaParams = {}
	--		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	--	end
end

--[[--
判断loadling弹出框是否显示
--]]
function isProgressDialogShowing()
	return GameLoadingLogic.isLoadingShow();
--	if platform == TargetWindows then
--	--windows平台
--	elseif platform == TargetIos then
--	--ios平台
--	elseif platform == TargetAndroid then
--		--android平台
--		local javaClassName = "com.tongqu.client.utils.Pub"
--		local javaMethodName = "isProgressDialogShowing"
--		local javaParams = {}
--		local ok, ret = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")
--		if ret then
--			return true
--		else
--			return false
--		end
--	end
end

--[[--
打開webview界面(urlValue和codeValue中有一个被赋值，另一个则为"")
--@param #string urlValue 网址
--@param #string codeValue html代码
--@param #number x 显示位置X坐标
--@param #number y 显示位置Y坐标
--@param #number width webview的宽
--@param #number height webview的高
--]]
function showWebView(urlValue, codeValue, x, y, width, height)
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
		--ios平台

		local args = {
			url = urlValue,
			content = codeValue,
			xvalue = x,
			yvalue = y,
			wvalue = width,
			hvalue = height,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "openWebview", args)
		if ok then
			return ret
		else
			return nil
		end
	elseif platform == TargetAndroid then
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "displayWebView"
		local javaParams = {
			x,
			y,
			width,
			height,
			urlValue,
			codeValue,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end

end
--[[--
关闭webview界面
--]]
function hideWebView()
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
		--ios平台
		local args = {
			view = webView,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "hideWebview", args)
		if ok then
			return true
		else
			return false
		end
	elseif platform == TargetAndroid then
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "removeWebView"
		local javaParams = {
			}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end

end

--[[--
--发短信
--@param #string mobile号码
--@param #string message内容
--]]
function sendSMSMessage(mobile, message)
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
		--ios平台

		local args = {
			mobilevalue = mobile,
			messagevalue = message
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "openSendMessage", args)
		if ok then
			return true
		else
			return false
		end

	elseif platform == TargetAndroid then
		--andorid平台
		local javaClassName = "com.tongqu.client.utils.SMSUtils"
		local javaMethodName = "sendSms"
		local javaParams = {
			mobile,
			message,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--发二进制短信
--@param #string mobile号码
--@param #number port端口
--@param #string message内容
--]]
function sendSMSDataMessage(mobile, port, message)
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
	--ios平台
	elseif platform == TargetAndroid then
		--andorid平台
		local javaClassName = "com.tongqu.client.utils.SMSUtils"
		local javaMethodName = "sendDataSms"
		local javaParams = {
			mobile,
			port,
			message,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--获取时间差
--@param #table mnOldTime 记录的时间戳
--@return #number dateDifference时间差(单位：小时)
--@return #table 当前时间戳
]]
function getTimeDifference(mnOldTime)
	--获取系统时间
	local NowTime = os.date("*t", getServerTime())  --如果格式化字符串为"*t"，函数将返回table形式的日期对象。如果为"!*t"，则表示为UTC时间格式。

	local OldTime = {}

	if mnOldTime == nil or mnOldTime == "" then
		OldTime = NowTime
	else
		OldTime = mnOldTime
	end

	--从日期字符串中截取出年月日时分秒  2013010101
	local Y1 = NowTime.year
	local M1 = NowTime.month
	local D1 = NowTime.day
	local H1 = NowTime.hour

	local Y2 = OldTime.year
	local M2 = OldTime.month
	local D2 = OldTime.day
	local H2 = OldTime.hour

	local dateDifference = (Y1-Y2)*365*24+(M1-M2)*30*24+(D1-D2)*24+H1-H2

	return dateDifference, NowTime
end

--[[--
分割字符串  string  分割的字符   返回值table
--]]
function FGUtilStringSplit(str, split_char)
	-------------------------------------------------------
	-- 参数:待分割的字符串,分割字符
	-- 返回:子串表.(含有空串)
	local sub_str_tab = {};
	while (true) do
		local pos = string.find(str, split_char);
		if (not pos) then
			sub_str_tab[#sub_str_tab + 1] = str;
			break;
		end
		local sub_str = string.sub(str, 1, pos - 1);
		sub_str_tab[#sub_str_tab + 1] = sub_str;
		str = string.sub(str, pos + 1, #str);
	end

	return sub_str_tab;
end

--[[--
--上传lua错误日志到友盟
]]
function uploadingDebugInfo(debugInfo)
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
	--ios平台

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

--[[--
--上传统计事件到友盟
]]
function setUmengUserDefinedInfo(key, value)
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
		--ios平台

		local args = {
			keyV= key,
			valueV = value,
		}
		local ok,ret = luaoc.callStaticMethod("Helper", "YMTongjiList", args)

	elseif platform == TargetAndroid then
		--andorid平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "setUmengUserDefinedInfo"
		local javaParams = {
			key,
			value,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--

获取运营商类型

@return #number 运营商
]]

function vibrate()
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
	--ios平台
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "vibrate"
		local javaParams = {}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--弹出框
]]
function showDialog(sMsg)
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
		--ios平台

		local args = {
			msg= sMsg,
		}
		local ok,ret = luaoc.callStaticMethod("Helper", "openAlert", args)

	elseif platform == TargetAndroid then
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "showAndroidDialog"
		local javaParams = {
			sMsg,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end
--[[--
--获取utf8编码字符串正确长度的方法
]]
function utfstrlen(str)
	local len = #str;
	local left = len;
	local cnt = 0;
	local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
	while left ~= 0 do
		local tmp=string.byte(str,-left);
		local i=#arr;
		while arr[i] do
			if tmp>=arr[i] then left=left-i;break;end
			i=i-1;
		end
		cnt=cnt+1;
	end
	return cnt;
end

--[[--
--根据首字节获取UTF8需要的字节数
--截取UTF8字符串
--SubUTF8String("一二三四五六七",1,3) 返回一二三
]]

function GetUTF8CharLength(ch)
	local utf8_look_for_table = {
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
		2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
		3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
		4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 1, 1,
	}
	return utf8_look_for_table[ch]
end
function SubUTF8String(str, begin, length)
	begin = begin or 1
	length = length or -1 --length为-1时代表不限制长度
	local ret = ""
	local len = 0
	local ptr = 1
	repeat
		local char = string.byte(str, ptr)
		local char_len = GetUTF8CharLength(char)
		len = len + 1

		if len>=begin and (length==-1 or len<begin+length) then
			for i=0,char_len-1 do
				ret = ret .. string.char( string.byte(str, ptr + i) )
			end
		end

		ptr = ptr + char_len
	until(ptr>#str)
	return ret
end

--[[--
--获取versionName
--]]
function getVersionName()
	if platform == TargetWindows then
		--windows平台
		return ""
	elseif platform == TargetIos then
		--ios平台
		local Version = CCUserDefault:sharedUserDefault():getStringForKey("tongquGameVersion");
		return Version
			--		local args = {}
			--		local ok, ret = luaoc.callStaticMethod("Assistant", "getVersion", args)
			--		if ok then
			--			return ret["appversion"]
			--		else
			--			return ""
			--		end
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getVersionName"
		local javaParams = {}
		local ok, VersionName = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Ljava/lang/String;")
		if ok then
			log("VersionName === " .. VersionName)
			return VersionName
		else
			return ""
		end
	end
end

Toast_LENGTH_LONG = 1--显示Toast.LENGTH_LONG: 3.5秒
Toast_LENGTH_SHORT = 0--显示Toast.LENGTH_SHORT: 2秒

--[[--
--显示toast
--@param #String showMsg 显示的文字
--@param #number toastTime Toast显示时间(秒)
--]]
function showToast(showMsg, toastTime)
	if showMsg == "" or showMsg ==nil then
		return true
	end

	if platform == TargetWindows then
		--windows平台
		TqToast.Toast(CCDirector:sharedDirector():getRunningScene(), showMsg, toastTime, 0.2)
	elseif platform == TargetIos then
		--ios平台

		local args = {
			msg = showMsg,
			time = toastTime,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "openToast", args)
		if ok then
			return true
		else
			return false
		end

	elseif platform == TargetAndroid then
		--android平台
		local toastType = Toast_LENGTH_LONG
		if toastTime <= 2 then
			toastType = Toast_LENGTH_SHORT
		end
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "showToast"
		local javaParams = {
			showMsg,
			toastType,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--显示弹出输入框 ios专用
--消息  taskId  是否紧急  回调方法
--]]
function showAlertInput(msg, taskidvalue, isImport, callvalue)
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
		--ios平台
		local args = {
			flag = msg,
			call = callvalue,
			taskid = taskidvalue,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "openAlertInput", args)
		if ok then
			return true
		else
			return false
		end

	elseif platform == TargetAndroid then

	end
end

--底层view渐变动画效果
function ViewCCFadeTo(view)

end

--控件平移动画效果    控件  时间     x位移              y位移   延迟时间
function ControlsCCMoveBy(view,time,x,y,delaytime)
	local move = CCMoveBy:create(time, ccp(x,y))
	local arr = CCArray:create()
	arr:addObject(CCDelayTime:create(delaytime))
	arr:addObject(move)
	local seq = CCSequence:create(arr)
	view:runAction(seq)
end

-- 上传客户端异常事件
function uploadClientExceptionInfo(str_info)
	setUmengUserDefinedInfo("throw_exception", "时间:"..os.date().." ID:"..profile.User.getSelfUserID()..str_info)
end

--[[--
--DES解密
--]]
function decryptUseDES(textString, Bytelength, keyValue)
	if platform == TargetWindows then
		--windows平台
		return ""
	elseif platform == TargetIos then
		--ios平台
		local args = {
			cipherText = textString,
			length = Bytelength,
			key = keyValue,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "decryptUseDES", args)
		if ok then
			return ret
		else
			return 0
		end
	elseif platform == TargetAndroid then
		--Android平台
		if(Bytelength ~= 0) then
			local javaClassName = "com.tongqu.client.utils.DecryptUseDES"
			local javaMethodName = "getDecryptForDES"
			local javaParams = {
				textString,
				keyValue,
			}
			local ok, ret = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Ljava/lang/String;")
			if ok then
				return ret
			else
				return 0
			end
		else
			return 0
		end
	end
end

--itunesUpdate itunes升级
function ItunesUpdate()
	if platform == TargetWindows then
		--windows平台
		return ""
	elseif platform == TargetIos then
		--ios平台
		local args = {
			cipherText = textString,
			length = Bytelength,
			key = keyValue,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "itunesUpdate", args)
		if ok then
			return ret
		else
			return 0
		end
	elseif platform == TargetAndroid then

	end
end

--按钮的动画效果，先放大在缩小，在执行方法
--按钮动画,先放大,后缩小
function setButtonScale(button, func)
	local scaleBig = CCScaleTo:create(0.1, 1.2)
	local scaleSmall = CCScaleTo:create(0.1, 1)
	local arr = CCArray:create()
	arr:addObject(scaleBig)
	arr:addObject(scaleSmall)
	if func then
		arr:addObject(CCCallFuncN:create(func))
	end
	local   seq= CCSequence:create(arr)
	button:runAction(seq)
end

--按钮的动画效果，先放大在缩小，在执行方法
--按钮动画,先放大,后缩小
function newSetButtonScale(button, big, small, func)
	local scaleBig = CCScaleTo:create(0.1, big)
	local scaleSmall = CCScaleTo:create(0.1, small)
	local arr = CCArray:create()
	arr:addObject(scaleBig)
	arr:addObject(scaleSmall)
	if func then
		arr:addObject(CCCallFuncN:create(func))
	end
	local   seq= CCSequence:create(arr)
	button:runAction(seq)
end

--点击+金币按钮打开自由兑换界面
--变量本地写死。不请求网络
function openConvertCoin()
	--0=自由兑换=可自由兑换任意数量的金币=1001http://f.99sai.com/mahjong/shop/mj_shop_jindai.png
	ConvertCoinLogic.setGoodsData(10, "自由兑换", "可自由兑换任意数量的金币", 100,"http://f.99sai.com/mahjong/shop/mj_shop_jindai.png",1)
	mvcEngine.createModule(GUI_CONVERTCOIN)
end

--[[--
--设置按钮显示状态并设置触摸监听状态
--]]
function setButtonVisible(button, visible)
	if button ~= nil then
		button:setVisible(visible)
		button:setTouchEnabled(visible)
	end
end

--lua分割字符串  输入字符串，分隔符，返回list
function Split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end

--打电话
function MakePhoneCall(ServerPhone)
	if platform == TargetWindows then
		--windows平台
		return ""
	elseif platform == TargetIos then
	--ios平台
	elseif platform == TargetAndroid then

	end
end

--复制qq号
function CopyQQ(ServerQQ)
	if platform == TargetWindows then
		--windows平台
		return ""
	elseif platform == TargetIos then
	--ios平台
	elseif platform == TargetAndroid then

	end
end

--设置手机钱包正则表达式
function SavePurseRegex(PurseRegexData)
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
		--ios平台
		if PurseRegexData ~= nil then
			ServerConfig.HAS_GET_PURES_MATCHES = true
		end
	elseif platform == TargetAndroid then
		if PurseRegexData ~= nil then
			local javaClassName = "com.pay.PaymentConfig"
			local javaMethodName = "luaCallPurseRegexData"
			local javaParams = {
				PurseRegexData.VarValue,
			}
			luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			ServerConfig.HAS_GET_PURES_MATCHES = true
		end
	end
end

--[[--
--统计在线时长
--]]
function AndroidExitSendOnlineTime()
	if GameConfig.enterGameTime > 0 and hasSendOnlineMsg == false then
		--进入游戏时间大于0：用户进入首页才计算在线时间
		sendSTAID_COMMIT_ACTIVITY_STAY(os.time() - GameConfig.enterGameTime);
		hasSendOnlineMsg = true;
	end

	if exitScheduler == nil then
		exitScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(AndroidExitSendOnlineTime, 0.1, false);
	else
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(exitScheduler)
		exitScheduler = nil;
		hasSendOnlineMsg = false;
		AndroidExit();
	end
end

--[[--
--调用android方法显示是否退后
]]
function AndroidExit()
	mvcEngine.destroyAllModules()
	AudioManager.stopBgMusic(true)
	AudioManager.stopAllSound()
	Services:getMessageService():closeSocket();
	CCDirector:sharedDirector():endToLua();
end

--[[--
--向服务器发送iOS设备的token
]]
function sendIOSDeviceToken()
	local args = {};
	local ok, ret = luaoc.callStaticMethod("AppController", "getDeviceToken", args);
	if ok then
		log("getDeviceToken ============= "..tostring(ret["token"]));
		sendADD_DEVICE_TOKEN(tostring(ret["token"]));
	end

end

--[[--
--复制table
--lua中表之间的赋值是引用的方式进行的，意味着改变一个，另一个也跟着变化。
--如果想要避免这种情况，可以通过自定义的函数复制一份table出来。
--]]
function copyTab(st)
	local tab = {}
	for k, v in pairs(st or {}) do
		if type(v) ~= "table" then
			tab[k] = v
		else
			tab[k] = copyTab(v)
		end
	end
	return tab
end


local index = 100;

function getIndex()
	if index > 999 then
		index = 100
	end
	index = index + 1
	return index
end

--[[--
--获取本地时间戳
--]]
function getNativeTimeStamp()
	return tonumber(os.time()..getIndex());
end

--[[--
--获取服务器时间
--时间戳（秒）
--]]
function getServerTime()
	local systemTime = os.time();
	return systemTime - profile.ServerMsg.getTimeDifference();
end

--[[--
--根据时间戳获取当前时间，格式为xx时xx分
--timeStemp为秒
--]]
function getTimeByTimeStemp(timeStemp)
	return os.date("%H时%M分", tonumber(timeStemp));
end

--[[--
--IOS更新版本
--]]
function upDataGameVersionForIOS(isForce, isTest)
	if platform == TargetIos then
		if GameConfig.PaymentForIphone == GameConfig.PAYMENT_SMS then
		--短代
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_IAP then
		--iap
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_91 then
		--91
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_HAIMA then
			--海马
			--nTest == 1调试模式 0非调试模式
			local args = {
				nTest = isTest,
			};
			luaoc.callStaticMethod("Helper", "HaiMaUpData", args);
		end
	end
end

--[[--
-- 存储错误信息
--]]
function saveExceptionInfo(debugInfo)
	local iosExceptionTable = LoadShareTable(CommUploadConfig.iosExceptionFileName)
	if iosExceptionTable == nil or #iosExceptionTable == 0 then
		iosExceptionTable = {}
	end
	table.insert(iosExceptionTable, debugInfo)
	SaveShareTable(CommUploadConfig.iosExceptionFileName, iosExceptionTable)
end

--[[--
-- 显示带按钮的dialog
--]]
function showButtonDialog(title, message, callBack)
	if platform == TargetWindows then
	--windows平台
	elseif platform == TargetIos then
	--ios平台
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "showAlertDialog"
		local javaParams = {
			title,
			message,
			callBack
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[-- 获取运营商编号IMSI ]]
function getImsi()
	if platform == TargetWindows then
		--windows平台
		return ""
	elseif platform == TargetIos then
		--ios平台
		if getOperater() == 1 then
			return "46000123456789"
		elseif getOperater() == 2 then
			return "46001123456789"
		elseif getOperater() == 3 then
			return "46003123456789"
		else
			return ""
		end
	elseif platform == TargetAndroid then
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getImsi"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, imsi = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			return imsi
		else
			return ""
		end
	end
end

--[[--
--获取SIM卡的ICCID
--]]
function getICCID()
	if platform == TargetWindows then
		--windows平台
		return ""
	elseif platform == TargetIos then
		--ios平台
		return ""
	elseif platform == TargetAndroid then
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getICCID"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, iccid = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			return iccid
		else
			return ""
		end
	end
end

--[[
获取设备剩余电量
返回值:
-1为错误
为百分比数，如10表示10%
]]
function getDeviceBatteryLevel()
	if platform == TargetIos then
		--ios
		local function callBack(params)
			batteryLevel = params.batteryLevel
		end
		local args = {
			callback = callBack,
		};
		luaoc.callStaticMethod("Helper", "getDeviceBatteryLevel", args);
	elseif platform == TargetAndroid then
		--android
		local function callBack(params)
			batteryLevel = params
		end
		local javaClassName = "com.tongqu.client.utils.BroadCastUtils"
		local javaMethodName = "luaCallGetBattery"
		local javaParams = {
			callBack,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V");
	end

	return tonumber(batteryLevel)
end

--[[--
--设备执行震动
--]]
function doVibrate()
	if platform == TargetIos then
		luaoc.callStaticMethod("Helper", "doVibrate", nil);
	elseif platform == TargetAndroid then
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "vibrate"
		local javaParams = {}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--根据包名检查应用是否安装
--@param #String sGameID 应用ID 例如：斗地主 = "1"
--@param #String packName app包名
--]]
function checkAppIsInstalledByPackName(sGameID, packName)
	if platform == TargetWindows then
		--windows平台
		return ""
	elseif platform == TargetIos then
		--ios平台
		return ""
	elseif platform == TargetAndroid then
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "getAppIsInstalledByPackName"
		local javaParams = {
			packName,
			sGameID,
		};
		local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;)I";
		local ok, isInstalledApp = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig);
		if ok then
			return isInstalledApp;
		else
			return 0;
		end
	end
end

--[[--
--设置下载完应用的回调方法
--@param #String sGameID 应用ID 例如：斗地主(GameID = "1")
--@param #Fucntion callBackFunc 回调方法
--@param #boolean isInstalled 下载完是否立即安装 true 是 false 否
--]]
function setDownloadCompleteCallBack(GameID, callBackFunc, isInstalled)
	if platform == TargetWindows then
		--windows平台
		return ""
	elseif platform == TargetIos then
		--ios平台
		return ""
	elseif platform == TargetAndroid then
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "setDownloadAppCompleteInfo"
		local javaParams = {
			GameID,
			callBackFunc,
			isInstalled,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V");
	end
end

--[[--
--ios本地推送通知
]]
function scheduleLocalNotification(mDelaySecond, matchTitle, matchStartTime, matchID)
	Common.log("mDelaySecond = "..mDelaySecond)
	Common.log("matchTitle = "..matchTitle)
	Common.log("matchStartTime = "..matchStartTime)

	if mDelaySecond <= 0 then
		return;
	end

	local args = {
		matchID = matchID,
		delaySecond = mDelaySecond,
		description = "您报名的"..matchTitle.."将在"..matchStartTime.."开始，请做好准备！",
	};
	luaoc.callStaticMethod("Helper", "scheduleLocalNotification", args);
end

--[[--
--添加闹钟
--]]--
function addAlarm(time,MatchInstanceID,MatchID,ServerTime,matchTitle)
	if Common.platform == Common.TargetIos then
		--ios
		-- 提前2分钟弹通知
		Common.log("比赛开始时间:"..Common.getTimeByTimeStemp(time/1000))
		local nLocalPushTimeStamp = time/1000-2*60 -- 本地推送的时间戳（单位：秒）
		local strPushTime = Common.getTimeByTimeStemp(time/1000) -- 开赛时间描述
		Common.scheduleLocalNotification(nLocalPushTimeStamp, matchTitle, strPushTime, MatchID);
	elseif Common.platform == Common.TargetAndroid then
		--android
		local timeV = time - ServerTime
		local javaClassName = "com.tongqu.client.utils.BroadCastUtils"
		local javaMethodName = "luaCallAddAlarm"
		local javaParams = {
			GameConfig.GAME_ID .. "",
			MatchID .. "",
			timeV .. "",
			MatchInstanceID .. "",
			matchTitle .. "",
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
--移除闹钟
--]]--
function removeAlarm(MatchID)
	if Common.platform == Common.TargetIos then
		--ios
		local args = {
			matchID = MatchID,
		};
		luaoc.callStaticMethod("Helper", "cancelNotification", args);
	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = "com.tongqu.client.utils.BroadCastUtils"
		local javaMethodName = "luaCallremoveAlarm"
		local javaParams = {
			GameConfig.GAME_ID .. "",
			MatchID .. "",
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--获取当前应用的包名是不是同趣包名"com.tongqu.client.lord"
--@return #boolean true 是 false 否
--]]
function getCurrentNameOfAppPackageIsTQ()
	if Common.platform == Common.TargetIos then
		--ios
		return true;
	elseif Common.platform == Common.TargetAndroid then
		local TQAppPackageName = Load.AndroidPackageName;--同趣包名
		local javaClassName = "com.tongqu.client.utils.Pub"
		local javaMethodName = "getAndroidPackagekName"
		local javaParams = {};
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, appPackageName = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			if TQAppPackageName == appPackageName then
				return true;
			else
				return false;
			end
		else
			return false;
		end
	end
end

--[[--
--安装app
--@param #String FilePath 应用的本地路径
--]]
function installApp(FilePath)
	if Common.platform == Common.TargetIos then
	--ios

	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "installApp"
		local javaParams = {
			FilePath,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end