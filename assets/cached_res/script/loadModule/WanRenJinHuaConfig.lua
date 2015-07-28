--万人金花配置文件
module("WanRenJinHuaConfig",package.seeall)

--层级管理
ModuleTable["WanRenJinHua"] = {}
ModuleTable["WanRenJinHua"]["ControllerPath"] = "script/loadModule/wanrenjinhua/controller/WanRenJinHuaController"
ModuleTable["WanRenJinHua"]["layer"] = "base_layer"
-- 万人金花结果框
ModuleTable["WanRenResultPop"] = {}
ModuleTable["WanRenResultPop"]["ControllerPath"] = "script/loadModule/wanrenjinhuapop/controller/WanRenResultPopController"
ModuleTable["WanRenResultPop"]["layer"] = "second_layer"
-- 万人金花历史框
ModuleTable["WanRenHistoryPop"] = {}
ModuleTable["WanRenHistoryPop"]["ControllerPath"] = "script/loadModule/wanrenjinhuapop/controller/WanRenHistoryPopController"
ModuleTable["WanRenHistoryPop"]["layer"] = "second_layer"
-- 万人金花牌型框
ModuleTable["WanRenCardTypePop"] = {}
ModuleTable["WanRenCardTypePop"]["ControllerPath"] = "script/loadModule/wanrenjinhuapop/controller/WanRenCardTypePopController"
ModuleTable["WanRenCardTypePop"]["layer"] = "second_layer"


local path = "script.loadModule."

---------------------------万人金花--------------------------
Load.LuaRequire(path .. "wanrenjinhua.logic.WanRenJinHuaLogic")
--------------wanrenjinhua/util----------------------------
Load.LuaRequire(path .. "wanrenjinhua.util.WanRenJinHuaConfig")
Load.LuaRequire(path .. "wanrenjinhua.util.WanRenJinHuaSound")
--------------wanrenjinhua/elements----------------------------
Load.LuaRequire(path .. "wanrenjinhua.elements.BetCoinGroup")
Load.LuaRequire(path .. "wanrenjinhua.elements.CoinsOnTable")
Load.LuaRequire(path .. "wanrenjinhua.elements.WanRenJinHuaTableCard")
Load.LuaRequire(path .. "wanrenjinhua.elements.WanRenJinHuaSelfBetNum")
Load.LuaRequire(path .. "wanrenjinhua.elements.WanRenJinHuaSelfWinCoinNum")
Load.LuaRequire(path .. "wanrenjinhua.elements.WanRenJinHuaTimer")
Load.LuaRequire(path .. "wanrenjinhua.elements.WanRenJinHuaUserInfo")
Load.LuaRequire(path .. "wanrenjinhua.elements.WanRenJinHuaBetArea")
Load.LuaRequire(path .. "wanrenjinhua.elements.WanRenJinHuaTitle")
Load.LuaRequire(path .. "wanrenjinhua.elements.WanRenJinHuaMenuButton")
Load.LuaRequire(path .. "wanrenjinhua.elements.WanRenJinHuaDealerInfo")
-----------------------wanrenjinhua/entity----------------------------
Load.LuaRequire(path .. "wanrenjinhua.entity.BetCoinEntity")
Load.LuaRequire(path .. "wanrenjinhua.entity.WanRenJinHuaTableCoinEntity")
Load.LuaRequire(path .. "wanrenjinhua.entity.WanRenJinHuaCardEntity")
Load.LuaRequire(path .. "wanrenjinhua.entity.WanRenJinHuaSelfBetEntity")
Load.LuaRequire(path .. "wanrenjinhua.entity.WanRenJinHuaSelfWinCoinNumEntity")
Load.LuaRequire(path .. "wanrenjinhua.entity.WanRenJinHuaUserInfoEntity")
-----------------------万人金花弹出框----------------------------
Load.LuaRequire(path .. "wanrenjinhuapop.logic.WanRenCardTypePopLogic")
Load.LuaRequire(path .. "wanrenjinhuapop.logic.WanRenHistoryPopLogic")
Load.LuaRequire(path .. "wanrenjinhuapop.logic.WanRenResultPopLogic")

--万人金花版本号
Version = 1;
