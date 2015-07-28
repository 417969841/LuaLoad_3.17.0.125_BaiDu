module("mvcEngine", package.seeall)

local needCreateModuleName 		= nil
local needHandleModuleCount 	= 0

local activeModuleTable 		= {}--当前显示的层
local wakeModuleTable 			= {}--需要唤醒的层

local function addNeedHandleModuleCount()
	needHandleModuleCount = needHandleModuleCount+1
end

local function removeModuleFromTable(moduleName)
	local module = nil
	for key, value in pairs(activeModuleTable) do
		if(key == moduleName) then
			module = activeModuleTable[key]
			activeModuleTable[key] = nil
		end
	end
	return module
end

local function doCreateModule()
	local moduleName = needCreateModuleName

	if ModuleTable[moduleName] == nil then
		return;
	end
	local modulePath = ModuleTable[moduleName]["ControllerPath"]

	local control = Load.LuaRequire(modulePath)

	local moduleControl = control[moduleName.."Controller"]:new()

	moduleControl:init()

	moduleControl:setModuleLayer(ModuleTable[moduleName]["layer"])

	activeModuleTable[moduleName] = moduleControl

	needCreateModuleName = nil
end


local function slot_Destory_Sleep_Done()
	needHandleModuleCount = needHandleModuleCount - 1
	Common.log("needHandleModuleCount =========== "..needHandleModuleCount)
	if (needHandleModuleCount <= 0) then
		needHandleModuleCount = 0

		if (needCreateModuleName ~= nil) then
			doCreateModule()
		end

		--有第二层的话，只唤醒第二层，不唤醒第一层
		if (#wakeModuleTable > 0) then
			local haveSecondLayer = false
			for i = 1, #wakeModuleTable do
				if Layer[wakeModuleTable[i]:getModuleLayer()] == 2 and wakeModuleTable[i]:getLayer() ~= nil then
					haveSecondLayer = true
					wakeModuleTable[i]:wakeModule()
				end
			end
			if haveSecondLayer == false then
				for i = 1, #wakeModuleTable do
					if Layer[wakeModuleTable[i]:getModuleLayer()] == 1 and wakeModuleTable[i]:getLayer() ~= nil then
						wakeModuleTable[i]:wakeModule()
					end
				end
			end
			wakeModuleTable = {}
		end

		framework.removeSlotFromSignal(signal.common.Signal_SleepModule_Done, slot_Destory_Sleep_Done)
		framework.removeSlotFromSignal(signal.common.Signal_DestroyModule_Done, slot_Destory_Sleep_Done)

	end
end

--[[--
--休眠或者销毁(打开新界面时调用，等于/高于新打开界面的层级销毁，小于新打开界面的层级休眠)
--]]
local function sleepOrDestroyModules(moduleName, action)
	needCreateModuleName = moduleName
	Common.log("sleepOrDestroyModules  needCreateModuleName == "..needCreateModuleName)

	local destroyModuleTable 	= {}--销毁的层
	local sleepModuleTable 		= {}--休眠的层
	local destroyType = {}--销毁类型

	local layerOfCreateModule = ModuleTable[moduleName]["layer"]
	for key, value in pairs(activeModuleTable) do
		local moduleLayer = value:getModuleLayer()
		if (Layer[layerOfCreateModule] <= Layer[moduleLayer]) then
			if needCreateModuleName == key then
				--界面已经显示，则不销毁数据
				destroyType[#destroyModuleTable + 1] = DESTORY_TYPE_EFFECT
			else
				destroyType[#destroyModuleTable + 1] = DESTORY_TYPE_CLEAN
			end
			--等于/高于新打开界面的层级销毁
			destroyModuleTable[#destroyModuleTable + 1] = value
			activeModuleTable[key] = nil
		elseif (Layer[layerOfCreateModule] > Layer[moduleLayer]) then
			--小于新打开界面的层级休眠
			sleepModuleTable[#sleepModuleTable + 1] = value
		end
	end

	needHandleModuleCount = #destroyModuleTable + #sleepModuleTable + needHandleModuleCount

	if(needHandleModuleCount == 0) then
		slot_Destory_Sleep_Done()
		return;
	end

	if action ~= nil then
		local function destroyModule()
			for j=1, #destroyModuleTable do
				if destroyModuleTable[j]:getLayer() ~= nil then
					destroyModuleTable[j]:destoryModule(destroyType[j])
				end
			end
		end
		for j=1, #destroyModuleTable do
			if destroyModuleTable[j]:getLayer() ~= nil then
				destroyModuleTable[j]:sleepModule()
				if j == #destroyModuleTable then
					local array = CCArray:create()
					array:addObject(action)
					array:addObject(CCCallFuncN:create(destroyModule))
					local seq = CCSequence:create(array)
					destroyModuleTable[j]:getLayer():runAction(seq)
				else
					destroyModuleTable[j]:getLayer():runAction(action)
				end
			end
		end
	else
		for j=1, #destroyModuleTable do
			if destroyModuleTable[j]:getLayer() ~= nil then
				destroyModuleTable[j]:destoryModule(destroyType[j])
			end
		end
	end

	for k=1,#sleepModuleTable do
		if sleepModuleTable[k]:getLayer() ~= nil then
			sleepModuleTable[k]:sleepModule()
		end
	end
end

--[[--
--唤醒或者销毁(关闭界面时调用，高于关闭界面的层级销毁，小于关闭界面的层级唤醒)
--]]
local function wakeOrDestroyModules(moduleName, destroy_type)
	if moduleName == nil then
		return;
	end

	needHandleModuleCount = 0

	local destoryModuleTable = {}
	local module = removeModuleFromTable(moduleName)

	local destoryModuleLayer = ModuleTable[moduleName]["layer"]

	for key, value in pairs(activeModuleTable) do
		local moduleLayer = value:getModuleLayer()
		if(Layer[destoryModuleLayer] < Layer[moduleLayer]) then
			--高于关闭界面的层级销毁
			destoryModuleTable[#destoryModuleTable + 1] = value
			activeModuleTable[key] = nil
		elseif(Layer[destoryModuleLayer] > Layer[moduleLayer]) then
			--小于关闭界面的层级唤醒
			wakeModuleTable[#wakeModuleTable + 1] = value
		end
	end

	needHandleModuleCount = #destoryModuleTable + 1

	if(#destoryModuleTable > 0) then
		for j=1,#destoryModuleTable do
			if destoryModuleTable[j]:getLayer() ~= nil then
				destoryModuleTable[j]:destoryModule(DESTORY_TYPE_CLEAN)
			end
		end
	end

	if destroy_type == nil then
		if module:getLayer() ~= nil then
			module:destoryModule(DESTORY_TYPE_CLEAN)
		end
	else
		if module:getLayer() ~= nil then
			module:destoryModule(destroy_type)
		end
	end
end

--[[--
--@param #string moduleName 要打开的界面
--@param #action action 关闭上一界面的动画(主要用户第一层级)
--]]
function createModule(moduleName, action)
	framework.addSlot2Signal(signal.common.Signal_SleepModule_Done, slot_Destory_Sleep_Done)
	framework.addSlot2Signal(signal.common.Signal_DestroyModule_Done, slot_Destory_Sleep_Done)
	sleepOrDestroyModules(moduleName, action)
end

function destroyModule(moduleName, destroy_type)
	framework.addSlot2Signal(signal.common.Signal_DestroyModule_Done, slot_Destory_Sleep_Done)
	wakeOrDestroyModules(moduleName, destroy_type)
end

--[[--
--此界面是否已经显示
--]]
function moduleExist(moduleName)
	local module = nil
	for key, value in pairs(activeModuleTable) do
		if(key == moduleName) then
			return true
		end
	end
	return false
end

function destroyAllModules()
	local module = nil
	for key, value in pairs(activeModuleTable) do
		if value:getLayer() ~= nil then
			value:destoryModule(DESTORY_TYPE_CLEAN)
		end
	end
	activeModuleTable = {}
end
