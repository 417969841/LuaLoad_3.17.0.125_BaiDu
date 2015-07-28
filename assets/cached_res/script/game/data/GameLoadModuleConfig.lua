--动态加载模块配置文件
module("GameLoadModuleConfig",package.seeall)


--福星高照GameID
BlessingGameID = 3;
--爱心女神GameID
GoddessGameID = 4;
--幸运转盘GameID
LuckyTurnTableGameID = 6;
--整蛊派对GameID
TrickyPartyID = 7;

--水果机GameID
FruitGameID = 102;
--金皇冠GameID
JinHuangGuanGameID = 103;
--万人金花GameID
WanRenJinHuaGameID = 104;
--万人水果派GameID
WanRenFruitGameID = 105;
--炸金花GameID
JinHuaGameID = 106;
--德州扑克GameID
PokerGameID = 107;

--[[--
--福星高照模块是否存在
--]]
function getBlessingIsExists()
	if Load.isLoadFromSD then
		return Common.getScriptIsExists("script/loadModule/","BlessingConfig.lua")
	else
		return Common.getScriptIsExists("cached_res/script/loadModule","BlessingConfig.lua")
	end
end

--[[--
--爱心女神模块是否存在
--]]
function getGoddessIsExists()
	if Load.isLoadFromSD then
		return Common.getScriptIsExists("script/loadModule/","GoddessConfig.lua")
	else
		return Common.getScriptIsExists("cached_res/script/loadModule","GoddessConfig.lua")
	end
end

--[[--
--整蛊派对模块是否存在
--]]
function getTrickyPartyIsExists()
	if Load.isLoadFromSD then
		return Common.getScriptIsExists("script/loadModule/","TrickyPartyConfig.lua")
	else
		return Common.getScriptIsExists("cached_res/script/loadModule","TrickyPartyConfig.lua")
	end
end

--[[--
--水果机模块是否存在
--]]
function getFruitIsExists()
	if Load.isLoadFromSD then
		return Common.getScriptIsExists("script/loadModule/","FruitConfig.lua")
	else
		return Common.getScriptIsExists("cached_res/script/loadModule","FruitConfig.lua")
	end
end

--[[--
--金皇冠模块是否存在
--]]
function getJinHuangGuanIsExists()
	if Load.isLoadFromSD then
		return Common.getScriptIsExists("script/loadModule/","JinHuangGuanConfig.lua")
	else
		return Common.getScriptIsExists("cached_res/script/loadModule","JinHuangGuanConfig.lua")
	end
end

--[[--
--万人水果派模块是否存在
--]]
function getWanRenFruitIsExists()
	if Load.isLoadFromSD then
		return Common.getScriptIsExists("script/loadModule/","WanRenFruitConfig.lua")
	else
		return Common.getScriptIsExists("cached_res/script/loadModule","WanRenFruitConfig.lua")
	end
end

--[[--
--万人金花模块是否存在
--]]
function getWanRenJinHuaIsExists()
	if Load.isLoadFromSD then
		return Common.getScriptIsExists("script/loadModule/","WanRenJinHuaConfig.lua")
	else
		return Common.getScriptIsExists("cached_res/script/loadModule","WanRenJinHuaConfig.lua")
	end
end

--[[--
--炸金花模块是否存在
--]]
function getJinHuaIsExists()
	if Load.isLoadFromSD then
		return Common.getScriptIsExists("script/loadModule/","JinHuaConfig.lua")
	else
		return Common.getScriptIsExists("cached_res/script/loadModule","JinHuaConfig.lua")
	end
end

--[[--
--德州模块是否存在
--]]
function getPokerIsExists()
	if Load.isLoadFromSD then
		return Common.getScriptIsExists("script/loadModule/","PokerConfig.lua")
	else
		return Common.getScriptIsExists("cached_res/script/loadModule","PokerConfig.lua")
	end
end

--[[--
--加载游戏模块
--]]
function loadGameModule()
	local path = "script.loadModule."
	if getFruitIsExists() then
		--水果机存在
		LuaUpdateConsole.reLordLua(path .. "FruitConfig")
	end

	if getJinHuangGuanIsExists() then
		--金皇冠存在
		LuaUpdateConsole.reLordLua(path .. "JinHuangGuanConfig")
	end

	if getWanRenFruitIsExists() then
		--万人水果机存在
		LuaUpdateConsole.reLordLua(path .. "WanRenFruitConfig")
	end

	if getWanRenJinHuaIsExists() then
		--万人金花存在
		LuaUpdateConsole.reLordLua(path .. "WanRenJinHuaConfig")
	end

	if getJinHuaIsExists() then
		--炸金花存在
		LuaUpdateConsole.reLordLua(path .. "JinHuaConfig")
	end

	if getGoddessIsExists() then
		--爱心女神存在
		LuaUpdateConsole.reLordLua(path .. "GoddessConfig")
	end

	if getTrickyPartyIsExists() then
		--整蛊派对存在
		LuaUpdateConsole.reLordLua(path .. "TrickyPartyConfig")
	end

	if getBlessingIsExists() then
		--福星高照存在
		LuaUpdateConsole.reLordLua(path .. "BlessingConfig")
	end

	if getPokerIsExists() then
		--德州扑克存在
		LuaUpdateConsole.reLordLua(path .. "PokerConfig")
	end
end

--[[--
--获取小游戏GameID列表
--]]
function getMiniGameConfigList()
	local miniGameConfigList = {}

	if getFruitIsExists() then
		--水果机存在
		local config = {}
		config.GameID = FruitGameID
		config.Version = FruitConfig.Version
		table.insert(miniGameConfigList, config)
	else
		local config = {}
		config.GameID = FruitGameID
		config.Version = -1
		table.insert(miniGameConfigList, config)
	end

	if getJinHuangGuanIsExists() then
		--金皇冠存在
		local config = {}
		config.GameID = JinHuangGuanGameID
		config.Version = JinHuangGuanConfig.Version
		table.insert(miniGameConfigList, config)
	else
		local config = {}
		config.GameID = JinHuangGuanGameID
		config.Version = -1
		table.insert(miniGameConfigList, config)
	end

	if getWanRenFruitIsExists() then
		--万人水果机存在
		local config = {}
		config.GameID = WanRenFruitGameID
		config.Version = WanRenFruitConfig.Version
		table.insert(miniGameConfigList, config)
	else
		local config = {}
		config.GameID = WanRenFruitGameID
		config.Version = -1
		table.insert(miniGameConfigList, config)
	end

	if getWanRenJinHuaIsExists() then
		--万人金花存在
		local config = {}
		config.GameID = WanRenJinHuaGameID
		config.Version = WanRenJinHuaConfig.Version
		table.insert(miniGameConfigList, config)
	else
		local config = {}
		config.GameID = WanRenJinHuaGameID
		config.Version = -1
		table.insert(miniGameConfigList, config)
	end

	if getJinHuaIsExists() then
		--炸金花存在
		local config = {}
		config.GameID = JinHuaGameID
		config.Version = JinHuaConfig.Version
		table.insert(miniGameConfigList, config)
	else
		local config = {}
		config.GameID = JinHuaGameID
		config.Version = -1
		table.insert(miniGameConfigList, config)
	end

	if getPokerIsExists() then
		--德州存在
		local config = {}
		config.GameID = PokerGameID
		config.Version = PokerConfig.Version
		table.insert(miniGameConfigList, config)
	else
		local config = {}
		config.GameID = PokerGameID
		config.Version = -1
		table.insert(miniGameConfigList, config)
	end

	for i = 1, #miniGameConfigList do
		Common.log("miniGameConfigList GameID ======= "..miniGameConfigList[i].GameID)
		Common.log("miniGameConfigList Version ======= "..miniGameConfigList[i].Version)
	end

	return miniGameConfigList;
end

--[[--
--获取活动GameID列表
--]]
function getTaskGameConfigList()
	local miniTaskConfigList = {}

	if getBlessingIsExists() then
		--福星高照存在
		local config = {}
		config.GameID = BlessingGameID
		config.Version = BlessingConfig.Version
		table.insert(miniTaskConfigList, config)
	else
		local config = {}
		config.GameID = BlessingGameID
		config.Version = -1
		table.insert(miniTaskConfigList, config)
	end

	if getGoddessIsExists() then
		--爱心女神存在
		local config = {}
		config.GameID = GoddessGameID
		config.Version = GoddessConfig.Version
		table.insert(miniTaskConfigList, config)
	else
		local config = {}
		config.GameID = GoddessGameID
		config.Version = -1
		table.insert(miniTaskConfigList, config)
	end

	if getTrickyPartyIsExists() then
		--整蛊派对活动
		local config = {}
		config.GameID = TrickyPartyID
		config.Version = TrickyPartyConfig.Version
		table.insert(miniTaskConfigList, config)
	else
		local config = {}
		config.GameID = TrickyPartyID
		config.Version = -1
		table.insert(miniTaskConfigList, config)
	end
	--幸运转盘存在(不用二次加载)
	local config = {}
	config.GameID = LuckyTurnTableGameID
	config.Version = 1
	table.insert(miniTaskConfigList, config)

	for i = 1, #miniTaskConfigList do
		Common.log("miniTaskConfigList GameID ======= "..miniTaskConfigList[i].GameID)
		Common.log("miniTaskConfigList Version ======= "..miniTaskConfigList[i].Version)
	end

	return miniTaskConfigList;
end

