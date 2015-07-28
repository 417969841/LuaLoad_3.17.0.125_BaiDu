luaj = {}

local callJavaStaticMethod = CCLuaJavaBridge.callStaticMethod

--[[--

生成不需要返回值的方法签名.

签名使用“(依次排列的参数类型)返回值类型”的格式，几个例子如下：

()V	 参数：无，返回值：无

(I)V	 参数：int，返回值：无

(Ljava/lang/String;)Z	 参数：字符串，返回值：布尔值

(IF)Ljava/lang/String;	 参数：整数、浮点数，返回值：字符串

这里列出不同类型对应的 Java 签名字符串：

类型名	 类型

I	 整数，或者 Lua function

F	 浮点数

Z	 布尔值

Ljava/lang/String;	 字符串

V	 Void 空，仅用于指定一个 Java 方法不返回任何值

Java 方法里接收 Lua function 的参数必须定义为 int 类型

@param table args --参数
@param string sig --方法签名（无返回值时为nil）
@return table ，string

]]
local function checkArguments(args, sig)
	if type(args) ~= "table" then args = {} end
	if sig then return args, sig end

	sig = { "(" }
	for i, v in ipairs(args) do
		local t = type(v)
		if t == "number" then
			sig[#sig + 1] = "F"
		elseif t == "boolean" then
			sig[#sig + 1] = "Z"
		elseif t == "function" then
			sig[#sig + 1] = "I"
		else
			sig[#sig + 1] = "Ljava/lang/String;"
		end
	end
	sig[#sig + 1] = ")V"

	return args, table.concat(sig)
end

local function checkArgumentsPro(args, callBack)
	if type(args) ~= "table" then args = {} end

	local sig = { "(" }
	for i, v in ipairs(args) do
		local t = type(v)
		if t == "number" then
			sig[#sig + 1] = "F"
		elseif t == "boolean" then
			sig[#sig + 1] = "Z"
		elseif t == "function" then
			sig[#sig + 1] = "I"
		else
			sig[#sig + 1] = "Ljava/lang/String;"
		end
	end
	sig[#sig + 1] = ")"
	sig[#sig + 1] = callBack

	return args, table.concat(sig)
end

--[[--

调用java静态方法

@param string className --类名
@param string methodName --方法名
@param table args --参数
@param string sig --方法签名（无返回值时为nil）
@return callJavaStaticMethod() 会返回两个值：
luaj 调用 Java 方法时，可能会出现各种错误，因此 luaj 提供了一种机制让 Lua 调用代码可以确定 Java 方法是否成功调用。
当成功时，第一个值为 true，第二个值是 Java 方法的返回值（如果有）。
当失败时，第一个值为 false，第二个值是错误代码。

错误代码定义如下：

错误代码	 描述
-1	 不支持的参数类型或返回值类型
-2	 无效的签名
-3	 没有找到指定的方法
-4	 Java 方法执行时抛出了异常
-5	 Java 虚拟机出错
-6	 Java 虚拟机出错
]]
function luaj.callStaticMethod(className, methodName, args, sig)
	local args, sig = checkArguments(args, sig)
	return callJavaStaticMethod(className, methodName, args, sig)
end
--[[--
@param string className --类名
@param string methodName --方法名
@param table args --参数
@param string callBack --返回值签名
]]
function luaj.callStaticMethodPro(className, methodName, args, callBack)
	local args, sig = checkArgumentsPro(args, callBack)
	return callJavaStaticMethod(className, methodName, args, sig)
end

return luaj