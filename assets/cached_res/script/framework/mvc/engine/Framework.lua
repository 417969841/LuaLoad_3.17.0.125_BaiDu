module("framework", package.seeall)

local l_signalSlotTable = {}--存放信号

local l_callbackEventTable = {}--存放点击事件

local l_callBackOnKeypadEventTable = {}--存放返回键事件(android特有)

--[[--
1、nil
这个最简单，只有值nil属于该类，表示一个无效值（在条件表达式中相当于false）。
2、boolean
包含两个值：false和true。
3、number
表示双精度类型的实浮点数
4、string
表示字符串数组。
5、function
表示调用的函数。
6、userdata
表示任意存储在变量中的C数据结构，这些数据只能通过metatables来访问。
7、thread
表示执行的一条独立线路，这与操作系统中的线程概念并不相同，它是用来支持共例程（corountine）的。
8、table
实现关联数组，Lua的关联数组很灵活，基本可以看作一般数组和字典的组合，能表示多种数据结构。
--]]

--[[--
--清除除了function以外的所有数据
--@param #table moduleTable 界面table
--]]
function moduleCleanUp(moduleTable)
	for key, var in pairs(moduleTable) do
		--Common.log("key ===== "..key, "   var ===== ",type(var));
		if key ~= "view" and key ~= "_PACKAGE" and key ~= "_NAME" and key ~= "_M" then
			if type(var) == "function" then
			--函数
			elseif type(var) == "boolean" then
				--boolean
				moduleTable[key] = false;
			elseif type(var) == "number" then
				--双精度类型的实浮点数
				moduleTable[key] = 0;
			elseif type(var) == "string" then
				--字符串数组
				moduleTable[key] = "";
			elseif type(var) == "userdata" then
				--任意存储在变量中的C数据结构，这些数据只能通过metatables来访问
				moduleTable[key] = nil;
			elseif type(var) == "thread" then
			--执行的一条独立线路
			elseif type(var) == "table" then
				--关联数组
				moduleTable[key] = {};
			end
		end
	end
end

--[[--
--点击事件的回调
--]]
local function callbackHandle(event, component)
	for k, v in pairs(l_callbackEventTable) do
		if(k == component) then
			if(l_callbackEventTable[component][event] ~= nil) then
				local EffectType = nil
				if l_callbackEventTable[component].btnEffectEvent ~= nil then
					EffectType = getButtonEffectType(l_callbackEventTable[component].btnEffectEvent)
				end
				if EffectType ~= nil then
					playButtonSound(EffectType.soundType, event)
					playButtonAnimation(component, EffectType.animationType, event, l_callbackEventTable[component][event])
				else
					if event == RELEASE_UP then
						AudioManager.playLordSound(AudioManager.TableSound.CLICK, false, AudioManager.SOUND);
					end
					l_callbackEventTable[component][event](event)
				end
			end
		end
	end
end

--[[--
--绑定点击事件
--@param #uiWidget register 控件
--@param #Function callback 回调方法
--@param #number event 按钮事件类型
--@param #number btnEffectEvent 按钮点击效果
--]]
function bindEventCallback(register, callback, event, btnEffectEvent)

	if(l_callbackEventTable[register] == nil) then
		l_callbackEventTable[register] = {}
	end

	if event == RELEASE_UP then
		l_callbackEventTable[register][PUSH_DOWN] = callback
		l_callbackEventTable[register][RELEASE_UP] = callback
		l_callbackEventTable[register][CANCEL_UP] = callback
	elseif event == PERCENT_CHANGED then
		l_callbackEventTable[register][PERCENT_CHANGED] = callback
		l_callbackEventTable[register][PUSH_DOWN] = callback
		l_callbackEventTable[register][RELEASE_UP] = callback
		l_callbackEventTable[register][CANCEL_UP] = callback
	else
		l_callbackEventTable[register][event] = callback
	end

	l_callbackEventTable[register].btnEffectEvent = btnEffectEvent;

	register:registerEventScript(callbackHandle)
end

--[[--
--解除点击事件绑定
--@param #uiWidget register 控件
--@param #Function callback 回调方法
--@param #number event 按钮事件类型
--@param #number btnEffectEvent 按钮点击效果
--]]
function unbindEventCallback(register, callback, event, btnEffectEvent)
	if(l_callbackEventTable[register] ~= nil) then

		if(l_callbackEventTable[register][event] ~= nil) then
			if event == RELEASE_UP then
				l_callbackEventTable[register][PUSH_DOWN] = nil
				l_callbackEventTable[register][RELEASE_UP] = nil
				l_callbackEventTable[register][CANCEL_UP] = nil
			else
				l_callbackEventTable[register][event] = nil
			end
		end

		local count = 0
		for k, v in pairs(l_callbackEventTable[register]) do
			count = count + 1
		end
		Common.log("count =========== "..count)
		if(count == 0) then
			l_callbackEventTable[register] = nil
			register:unregisterEventScript()
		end
	end
end

--[[--
--设置view返回键监听
]]
function setOnKeypadEventListener(view, callBackOnKeypad)
	if Common.platform == Common.TargetAndroid then
		local function onKeypadEvent(event)
			if event == "backClicked" then
				AudioManager.playLordSound(AudioManager.TableSound.BACK, false, AudioManager.SOUND);
			elseif event == "menuClicked" then
			end
			callBackOnKeypad(event)
		end
		view:addKeypadEventListener(onKeypadEvent)
		view:setKeypadEnabled(true)
	end
end

--[[--
--释放view返回键监听
]]
function releaseOnKeypadEventListener(view)
	if Common.platform == Common.TargetAndroid then
		view:setKeypadEnabled(false)
	end
end


--[[--
--注册消息信号
--@param #number signal 信号
--@param #Function callbackFunction 回调方法
--]]
function addSlot2Signal(signal, callbackFunction)
	if l_signalSlotTable[signal] == nil then
		l_signalSlotTable[signal] = {}
	end

	for i = 1, #(l_signalSlotTable[signal]) do
		if l_signalSlotTable[signal][i] == callbackFunction then
			return
		end
	end
	l_signalSlotTable[signal][#l_signalSlotTable[signal] +1] = callbackFunction
end

--[[--
--发送消息信号
--@param #number signal 信号
--@param #table dataTable 回调数据(一般为nil)
--]]
function emit(signal, dataTable)
	if l_signalSlotTable[signal] == nil then
		return;
	end
	for i = 1, #(l_signalSlotTable[signal]) do
		l_signalSlotTable[signal][i](dataTable)
	end
end

--[[--
--删除消息信号
--@param #number signal 信号
--@param #Function callbackFunction 回调方法
--]]
function removeSlotFromSignal(signal, callbackFunction)
	if l_signalSlotTable[signal] == nil then
		return;
	end
	for i = 1, #(l_signalSlotTable[signal]) do
		if l_signalSlotTable[signal][i] == callbackFunction then
			table.remove(l_signalSlotTable[signal], i)
			return;
		end
	end
end