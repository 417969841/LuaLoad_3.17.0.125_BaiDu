--炸金花配置文件
module("JinHuaConfig",package.seeall)

--层级管理
--扎金花牌桌界面
ModuleTable["JinHuaTable"] = {}
ModuleTable["JinHuaTable"]["ControllerPath"] = "script/loadModule/jinhua/controller/JinHuaTableController"
ModuleTable["JinHuaTable"]["layer"] = "base_layer"

--扎金花牌桌设置界面
ModuleTable["JinHuaTableSetPop"] = {}
ModuleTable["JinHuaTableSetPop"]["ControllerPath"] = "script/loadModule/jinhuapop/controller/JinHuaTableSetPopController"
ModuleTable["JinHuaTableSetPop"]["layer"] = "second_layer"
--扎金花牌桌牌型界面
ModuleTable["JinHuaTableCardTypePop"] = {}
ModuleTable["JinHuaTableCardTypePop"]["ControllerPath"] = "script/loadModule/jinhuapop/controller/JinHuaTableCardTypePopController"
ModuleTable["JinHuaTableCardTypePop"]["layer"] = "second_layer"
--扎金花牌桌换牌界面
ModuleTable["JinHuaTableChangeCardPop"] = {}
ModuleTable["JinHuaTableChangeCardPop"]["ControllerPath"] = "script/loadModule/jinhuapop/controller/JinHuaTableChangeCardPopController"
ModuleTable["JinHuaTableChangeCardPop"]["layer"] = "second_layer"
--扎金花牌桌换牌界面
ModuleTable["JinHuaTableTextPop"] = {}
ModuleTable["JinHuaTableTextPop"]["ControllerPath"] = "script/loadModule/jinhuapop/controller/JinHuaTableTextPopController"
ModuleTable["JinHuaTableTextPop"]["layer"] = "second_layer"
--扎金花牌桌确认界面
ModuleTable["JinHuaTableConfirmPop"] = {}
ModuleTable["JinHuaTableConfirmPop"]["ControllerPath"] = "script/loadModule/jinhuapop/controller/JinHuaTableConfirmPopController"
ModuleTable["JinHuaTableConfirmPop"]["layer"] = "second_layer"
--扎金花牌桌道具购买界面
ModuleTable["JinHuaTableGoodsBuyPop"] = {}
ModuleTable["JinHuaTableGoodsBuyPop"]["ControllerPath"] = "script/loadModule/jinhuapop/controller/JinHuaTableGoodsBuyPopController"
ModuleTable["JinHuaTableGoodsBuyPop"]["layer"] = "third_layer"
--扎金花牌桌宝箱界面
ModuleTable["JinHuaTableTreasurePop"] = {}
ModuleTable["JinHuaTableTreasurePop"]["ControllerPath"] = "script/loadModule/jinhuapop/controller/JinHuaTableTreasurePopController"
ModuleTable["JinHuaTableTreasurePop"]["layer"] = "second_layer"

--内扎退出下完整游戏弹出框
ModuleTable["JinHuaTableExit"] = {}
ModuleTable["JinHuaTableExit"]["ControllerPath"] = "script/loadModule/jinhuapop/controller/JinHuaTableExitController"
ModuleTable["JinHuaTableExit"]["layer"] = "second_layer"

--扎金花牌桌聊天界面
ModuleTable["JinHuaChatPop"] = {}
ModuleTable["JinHuaChatPop"]["ControllerPath"] = "script/loadModule/jinhuachatpop/controller/JinHuaChatPopController"
ModuleTable["JinHuaChatPop"]["layer"] = "second_layer"


ModuleTable["JinHuaHall"] = {}
ModuleTable["JinHuaHall"]["ControllerPath"] = "script/loadModule/jinHuaHall/controller/JinHuaHallController"
ModuleTable["JinHuaHall"]["layer"] = "base_layer"


--金花用户信息
ModuleTable["JinHuaUserInfo"] = {}
ModuleTable["JinHuaUserInfo"]["ControllerPath"] = "script/loadModule/jinHuaHall/controller/JinHuaUserInfoController"
ModuleTable["JinHuaUserInfo"]["layer"] = "second_layer"


local path = "script.loadModule."

-------------------扎金花------------------------------
Load.LuaRequire(path .. "jinhua.logic.JinHuaTableLogic")
Load.LuaRequire(path .. "jinhua.logic.JinHuaTableMyOperation")
Load.LuaRequire(path .. "jinHuaHall.logic.JinHuaHallLogic")
Load.LuaRequire(path .. "jinHuaHall.logic.MenuLayer")
-------------------jinhua/table_elements------------------------------
Load.LuaRequire(path .. "jinhua.table_elements.JinHuaPKAnim")
Load.LuaRequire(path .. "jinhua.table_elements.JinHuaTableBackground")
Load.LuaRequire(path .. "jinhua.table_elements.JinHuaTableBubble")
Load.LuaRequire(path .. "jinhua.table_elements.JinHuaTableButtonGroup")
Load.LuaRequire(path .. "jinhua.table_elements.JinHuaTableCard")
Load.LuaRequire(path .. "jinhua.table_elements.JinHuaTableChat")
Load.LuaRequire(path .. "jinhua.table_elements.JinHuaTableCoin")
Load.LuaRequire(path .. "jinhua.table_elements.JinHuaTablePlayer")
Load.LuaRequire(path .. "jinhua.table_elements.JinHuaTableTips")
Load.LuaRequire(path .. "jinhua.table_elements.JinHuaTableTitle")
Load.LuaRequire(path .. "jinhua.table_elements.JinHuaTableTreasure")
-------------------jinhua/table_entity------------------------------
Load.LuaRequire(path .. "jinhua.table_entity.JinHuaBetedCoinLabel")
Load.LuaRequire(path .. "jinhua.table_entity.JinHuaCardSprite")
Load.LuaRequire(path .. "jinhua.table_entity.JinHuaTableCoinEntity")
Load.LuaRequire(path .. "jinhua.table_entity.JinHuaTablePlayerEntity")
-------------------jinhua/table_util------------------------------
Load.LuaRequire(path .. "jinhua.table_util.JinHuaTableConfig")
Load.LuaRequire(path .. "jinhua.table_util.JinHuaTableFunctions")
Load.LuaRequire(path .. "jinhua.table_util.JinHuaTableSound")

-------------------扎金花弹出框------------------------------
Load.LuaRequire(path .. "jinhuapop.logic.JinHuaTableCardTypePopLogic")
Load.LuaRequire(path .. "jinhuapop.logic.JinHuaTableChangeCardPopLogic")
Load.LuaRequire(path .. "jinhuapop.logic.JinHuaTableConfirmPopLogic")
Load.LuaRequire(path .. "jinhuapop.logic.JinHuaTableGoodsBuyPopLogic")
Load.LuaRequire(path .. "jinhuapop.logic.JinHuaTableSetPopLogic")
Load.LuaRequire(path .. "jinhuapop.logic.JinHuaTableTextPopLogic")
Load.LuaRequire(path .. "jinhuapop.logic.JinHuaTableTreasurePopLogic")
Load.LuaRequire(path .. "jinhuapop.logic.JinHuaTableExitLogic")
Load.LuaRequire(path .. "jinHuaHall.logic.JinHuaUserInfoLogic")


--炸金花版本号
Version = 2;

