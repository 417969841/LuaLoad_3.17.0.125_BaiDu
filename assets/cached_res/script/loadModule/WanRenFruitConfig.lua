--万人水果派配置文件
module("WanRenFruitConfig",package.seeall)

--层级管理
--万人水果机
ModuleTable["WanRenFruitMachine"] = {}
ModuleTable["WanRenFruitMachine"]["ControllerPath"] = "script/loadModule/minigame/controller/WanRenFruitMachineController"
ModuleTable["WanRenFruitMachine"]["layer"] = "base_layer"

local path = "script.loadModule."

---------------------------万人水果机----------------------------
Load.LuaRequire(path .. "minigame.logic.WanRenFruitMachineLogic")

--万人水果派版本号
Version = 2;
