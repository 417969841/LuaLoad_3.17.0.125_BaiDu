--
--大厅按钮类
--
HallButton  = {
	--控件
	m_UI = nil,
	-- id
	m_nID = 0,
	--0：正常(开启)\1： 透明(变灰)\2：隐藏
	m_nStatus = 0,

	--当前位置坐标
	tCurrentPosition = {x = 0, y = 0},
	--默认位置坐标
	tDefaultPosition = {x = 0, y = 0},
	--所处的大厅位置 1：panel_top(大厅上部) 2：panel_hall(大厅中部)
	m_nHallLocation = -1,
	--所处当前panel(父控件)的位置
	m_nPanelLocation = -1,

	--是否有动画
	m_bHasAnim = false,
	--未开启的提示语
	m_sToast = "",
	--是否可见
	m_bIsShow = false,
	--是否半透明
	m_bIsTranslucent = false,
	--是否可用
	m_bIsAvailable = false,
	--装饰动画是否正在显示
	m_bIsDecorativeShow = false;
	--显示装饰动画的方法
	showDecorativeFunc  = nil,
	--隐藏装饰动画的方法
	removeDecorativeFunc = nil
};

HallButton.__index = HallButton;

--[[--
--创建大厅按钮
--@param #CCButton ui 按钮UI
--@param #number nID 按钮ID
--@param #boolean bHasAnim 按钮是否有骨骼动画
--]]
function HallButton:new(ui, nID, bHasAnim)
	local self = {};

	setmetatable(self, HallButton);

	self.m_UI = ui;
	self.m_nID = nID;
	self.m_bHasAnim = bHasAnim;

	return self;
end

--[[--
--设置按钮当前的位置
--@return #table 返回按钮的当前位置
--]]
function HallButton:getCurrentPosition()
	if self.tCurrentPosition.x ~= 0 and self.tCurrentPosition.y ~= 0 then
		--如果有当前位置,设置当前位置
		return self.tCurrentPosition;
	else
		return self.tDefaultPosition;
	end
end

--[[--
--获取按钮的缩放值
--]]
function HallButton:getScaleValue()
	return self.m_UI:getScale();
end

--[[--
--设置按钮的缩放值
--@param #number value 想要设置的缩放值
--]]
function HallButton:setScaleValue(value)
	return self.m_UI:setScale(value);
end

--[[--
--设置按钮当前的位置
--@param #number nCurrentX 按钮当前位置X轴
--@param #number nCurrentY 按钮位置的Y轴
--]]
function HallButton:setCurrentPosition(nCurrentX, nCurrentY)
	--当前位置
	self.tCurrentPosition = {x = 0, y = 0};-- 一定要有,不然会去直接操作元表,修改的都是同一数据
	self.tCurrentPosition.x = nCurrentX;
	self.tCurrentPosition.y = nCurrentY;
end

--[[--
--设置按钮默认的位置
--@param #number nDefaultX 按钮默认位置X轴
--@param #number nDefaultY 按钮默认位置的Y轴
--]]
function HallButton:setDefaultPosition(nDefaultX, nDefaultY)
	--默认位置
	self.tDefaultPosition = {x = 0, y = 0};
	self.tDefaultPosition.x = nDefaultX;
	self.tDefaultPosition.y = nDefaultY;
end

--[[--
--更新按钮位置
--]]
function HallButton:updatePosition()
	if self.tCurrentPosition.x ~= 0 and self.tCurrentPosition.y ~= 0 then
		--如果有当前位置,设置当前位置
		self.m_UI:setPosition(ccp(self.tCurrentPosition.x, self.tCurrentPosition.y));
	elseif self.tDefaultPosition.x ~= 0 and self.tDefaultPosition.y ~= 0 then
		--没有当前位置,设置默认位置
		self.m_UI:setPosition(ccp(self.tDefaultPosition.x, self.tDefaultPosition.y));
	end
end

--[[--
--将按钮变半透明
--]]
function HallButton:buttonToTranslucent()
	self.m_UI:setVisible(true);
	self.m_UI:setTouchEnabled(true);
	self.m_UI:setOpacity(127);
end

--[[--
--将按钮隐藏
--]]
function HallButton:buttonToHide()
	self.m_UI:setVisible(false);
	self.m_UI:setTouchEnabled(false);
end

--[[--
--将按钮开启
--]]
function HallButton:buttonToOpen()
	self.m_UI:setVisible(true);
	self.m_UI:setTouchEnabled(true);
	self.m_UI:setOpacity(255);
end

--[[--
--更改按钮状态
--]]
function HallButton:updateStatus()
	if self.m_bIsShow then
		if self.m_bIsTranslucent then
			--半透明
			self:buttonToTranslucent();
		else
			--显示
			self:buttonToOpen();
		end
	else
		--隐藏
		self:buttonToHide();
	end
end

--[[--
--更新按钮
--]]
function HallButton:update()
	self:updatePosition();
	self:updateStatus();
end

--[[--
--设置按钮状态
--@param #number nStatus 按钮状态
--]]
function HallButton:setStatus(nStatus)
	self.m_nStatus = nStatus;
	if nStatus == HallButtonConfig.BUTTON_STATUS_OPEN then
		self.m_bIsShow = true;
		self.m_bIsTranslucent = false;
		self.m_bIsAvailable = true;
	elseif nStatus == HallButtonConfig.BUTTON_STATUS_GRAY then
		self.m_bIsShow = true;
		self.m_bIsTranslucent = true;
		self.m_bIsAvailable = false;
	elseif nStatus == HallButtonConfig.BUTTON_STATUS_HIDE then
		self.m_bIsShow = false;
		self.m_bIsTranslucent = false;
		self.m_bIsAvailable = false;
	end
end

--[[
--判断该按钮是否可见
--@return true:可见 false:不可见
--]]
function HallButton:isButtonShow()
	return self.m_bIsShow;
end

--[[
--判断该按钮是否变灰
--@return true:变灰(半透明) false:不变灰
--]]
function HallButton:isButtonTranslucent()
	return self.m_bIsTranslucent;
end

--[[
--判断该按钮是否可用
--@return true:进入点击按钮的正常逻辑 false:弹该按钮未开启的Toast
--]]
function HallButton:isButtonAvailable()
	return self.m_bIsAvailable;
end

--[[
--获取按钮的是否有装饰动画
--]]
function HallButton:hasDecorativeAnimation()
	return self.m_bHasAnim;
end

--[[
--设置按钮的Toast
--@param #String sToast 按钮Toast
--]]
function HallButton:setButtonToast(sToast)
	self.m_sToast = sToast;
end

--[[
--获取按钮的Toast
--]]
function HallButton:getButtonToast()
	return self.m_sToast;
end

--[[
--获取按钮的ui
--]]
function HallButton:getButtonUI()
	return self.m_UI;
end

--[[
--获取按钮的ID
--]]
function HallButton:getButtonID()
	return self.m_nID;
end

--[[--
--获取装饰动画状态
--@return #boolean 装饰动画是否show
--]]
function HallButton:getDecorativeAnimStatus()
	return self.m_bIsDecorativeShow;
end

--[[--
--设置装饰动画状态
--@param #boolean flag 是否显示
--]]
function HallButton:setDecorativeAnimStatus(flag)
	self.m_bIsDecorativeShow = flag;
end

--[[--
-获取所处的大厅位置
--]]
function HallButton:getHallLocation()
	return self.m_nHallLocation;
end

--[[--
-设置所处的大厅位置
--@param #number value 所处的大厅位置 1：panel_top(大厅上部) 2：panel_hall(大厅中部)
--]]
function HallButton:setHallLocation(value)
	self.m_nHallLocation = value
end

--[[--
-获取所处当前panel(父控件)的位置
--]]
function HallButton:getPanelLocation()
	return self.m_nPanelLocation;
end

--[[--
-设置所处当前panel(父控件)的位置
--@param #number value 所处当前panel(父控件)的位置
--]]
function HallButton:setPanelLocation(value)
	self.m_nPanelLocation = value
end

--[[--
--设置装饰动画
--@param #func showFunc 显示装饰按钮的方法
--@param #func showFunc 移除装饰按钮的方法
--]]
function HallButton:setDecorativeAnimation(showFunc, removeFunc)
	self.showDecorativeFunc  = showFunc;
	self.removeDecorativeFunc = removeFunc;
end

--[[--
--显示装饰动画
--@param #CCLayer view 装饰动画所在的view
--@param #number x 装饰动画X轴
--@param #number y 装饰动画Y轴
--]]
function HallButton:showDecorativeAnimation(view, x, y)
	if self.showDecorativeFunc ~= nil then
		self.showDecorativeFunc(view, x, y);
	end
end

--[[--
--删除装饰动画
--@param #CCLayer view 装饰动画所在的view
--]]
function HallButton:removeDecorativeAnimation(view)
	if self.removeDecorativeFunc ~= nil then
		self.removeDecorativeFunc(view);
	end
end

--[[--
--显示按钮自身移动动画
--@param #number x X轴
--@param #number y Y轴
--@param #number time 移动的时间
--@param #number func 回调函数
--]]
function HallButton:showButtonMoveAnimation(x, y, nTime, func)
	local function callBack()
		if func ~= nil then
			func(self.m_UI, self.m_nID);
		end
	end

	local moveTo = CCMoveTo:create(nTime, ccp(x, y));
	local callFunc = CCCallFuncN:create(callBack);
	local arr = CCArray:create();
	arr:addObject(moveTo);
	arr:addObject(callFunc);
	local seq = CCSequence:create(arr);
	self.m_UI:runAction(seq);
end