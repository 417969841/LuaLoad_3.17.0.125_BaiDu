--水果机&&金皇冠配置文件
module("FruitConfig",package.seeall)

--层级管理
--新版水果机
ModuleTable["FruitMachine"] = {}
ModuleTable["FruitMachine"]["ControllerPath"] = "script/loadModule/minigame/controller/FruitMachineController"
ModuleTable["FruitMachine"]["layer"] = "base_layer"

--打赏
ModuleTable["Rewards"] = {}
ModuleTable["Rewards"]["ControllerPath"] = "script/loadModule/minigame/controller/RewardsController"
ModuleTable["Rewards"]["layer"] = "second_layer"

---------------------------新版水果机----------------------------

local path = "script.loadModule."

Load.LuaRequire(path .. "minigame.logic.CommonControl")
Load.LuaRequire(path .. "minigame.logic.BegMachineLogic")
Load.LuaRequire(path .. "minigame.logic.DropCoinLogic")
Load.LuaRequire(path .. "minigame.logic.FruitMachineLogic")

--水果机版本号
Version = 5;

