local l_exception_level = EXCEPTION_LEVEL_2

local function l_printExceptionMsg(msg)
    log(msg)
end

local function l_combineLog(exceptionName, luaFile, funName, args)
    l_printExceptionMsg(exceptionName .. " in " .. funName .. " in " .. luaFile .. "[" .. args .. "]")
end

function throwLoadFailException(luaFile, funName, args)
    l_combineLog("LoadFailException", luaFile, funName, args)
end

function throwFileNotFoundException(luaFile, funName, args)
    l_combineLog("FileNotFoundException", luaFile, funName, args)
end

function throwSignalIsNilException(luaFile, funName, args)
    l_combineLog("SignalIsNilException", luaFile, funName, args)
end

function throwSlotNotFoundException(luaFile, funName, args)
    l_combineLog("SlotNotFoundException", luaFile, funName, args)
end

function throwModelDataValueNotFoundException(luaFile, funName, args)
    l_combineLog("ModelDataValueNotFoundException", luaFile, funName, args)
end

function throwGetNilValueFromTableException(luaFile, funName, args)
    l_combineLog("GetNilValueFromTableException", luaFile, funName, args)
end

function throwControllerResetNotDefineException(luaFile, funName, args)
    l_combineLog("ControllerResetNotDefineException", luaFile, funName, args)
end

function throwControllerAddSlotNotDefineException(luaFile, funName, args)
    l_combineLog("ControllerAddSlotNotDefineException", luaFile, funName, args)
end

function throwControllerAddCallbackNotDefineException(luaFile, funName, args)
    l_combineLog("ControllerAddCallbackNotDefineException", luaFile, funName, args)
end

function throwControllerRequestMsgNotDefineException(luaFile, funName, args)
    l_combineLog("ControllerRequestMsgNotDefineException", luaFile, funName, args)
end