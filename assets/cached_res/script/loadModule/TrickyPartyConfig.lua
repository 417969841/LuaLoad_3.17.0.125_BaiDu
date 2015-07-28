--整蛊派对配置文件
module("TrickyPartyConfig",package.seeall)

local path = "script.loadModule."

ModuleTable["TrickyParty"] = {}
ModuleTable["TrickyParty"]["ControllerPath"] = "script/loadModule/trickyparty/controller/TrickyPartyController"
ModuleTable["TrickyParty"]["layer"] = "base_layer"

Load.LuaRequire(path .. "trickyparty.logic.TrickyPartyLogic")



ModuleTable["TrickyPartyGuide"] = {}
ModuleTable["TrickyPartyGuide"]["ControllerPath"] = "script/loadModule/trickyparty/controller/TrickyPartyGuideController"
ModuleTable["TrickyPartyGuide"]["layer"] = "second_layer"

Load.LuaRequire(path .. "trickyparty.logic.TrickyPartyGuideLogic")


ModuleTable["TrickyPartyRank"] = {}
ModuleTable["TrickyPartyRank"]["ControllerPath"] = "script/loadModule/trickyparty/controller/TrickyPartyRankController"
ModuleTable["TrickyPartyRank"]["layer"] = "second_layer"

Load.LuaRequire(path .. "trickyparty.logic.TrickyPartyRankLogic")

--整蛊排队版本号
--Version = 1;
--Version = 2; --修复友盟异常
Version = 3; --修复个人排名