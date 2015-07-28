--爱心女神配置文件
module("GoddessConfig",package.seeall)

--层级管理
--爱心女神
ModuleTable["AaiXinNvShen"] = {}
ModuleTable["AaiXinNvShen"]["ControllerPath"] = "script/loadModule/aixinnvshen/controller/AaiXinNvShenController"
ModuleTable["AaiXinNvShen"]["layer"] = "base_layer"

--爱心女神规则弹窗
ModuleTable["AaiXinNvShenGuiZe"] = {}
ModuleTable["AaiXinNvShenGuiZe"]["ControllerPath"] = "script/loadModule/aixinnvshen/controller/AaiXinNvShenGuiZeController"
ModuleTable["AaiXinNvShenGuiZe"]["layer"] = "second_layer"

local path = "script.loadModule."

Load.LuaRequire(path .. "aixinnvshen.logic.AaiXinNvShenLogic")
Load.LuaRequire(path .. "aixinnvshen.logic.AaiXinNvShenGuiZeLogic")

--爱心女神版本号
Version = 1;
