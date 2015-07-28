--福星高照配置文件
module("BlessingConfig",package.seeall)

--层级管理
--福星高照层级管理
ModuleTable["FuXingGaoZhao"] = {}
ModuleTable["FuXingGaoZhao"]["ControllerPath"] = "script/loadModule/fuxingGaozhao/controller/FuXingGaoZhaoController"
ModuleTable["FuXingGaoZhao"]["layer"] = "base_layer"

local path = "script.loadModule."

Load.LuaRequire(path .. "fuxingGaozhao.logic.FuXingGaoZhaoLogic")

--福星高照版本号
Version = 1;
