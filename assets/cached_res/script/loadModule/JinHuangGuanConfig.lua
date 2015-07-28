--水果机&&金皇冠配置文件
module("JinHuangGuanConfig",package.seeall)

--层级管理

--新版金皇冠
ModuleTable["JinHuangGuan"] = {}
ModuleTable["JinHuangGuan"]["ControllerPath"] = "script/loadModule/minigame/controller/JinHuangGuanController"
ModuleTable["JinHuangGuan"]["layer"] = "base_layer"

local path = "script.loadModule."

---------------------------新版金皇冠----------------------------
Load.LuaRequire(path .. "minigame.logic.JinHuangGuanLogic")


--金皇冠版本号
Version = 3;

