module("SetOldSexLogic",package.seeall)

view = nil
local scene = nil

local flag = 0            --0==sex  1==old  2 = sheng 3 = city

scrollview = nil
panel = nil
Button_OK = nil;

cityInProvince = {}
local shengV = nil
local cityV = nil
local shengName = nil
local shengNum = 0

--界面穿的的数据
local userold = nil
local usersex = nil

--全局变量，定义界面大小
local viewW = 526
local viewHMax = 221
local viewH = 0
local viewX = 0
local viewY = 0
local cellWidth = 526 --每个元素的宽
local cellHeight = 58 --每个元素的高
local spacingW = 0 --横向间隔
local spacingH = 20 --纵向间隔
checkListImage = {}
selectValue = "";--选择的值

local oldValue = {};

function onKeypad(event)
	if event == "backClicked" then
	--返回键
		close()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("SetOldSex.json")
	local gui = GUI_SETOLDSEX
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())

	GameStartConfig.addChildForScene(view)
	checkListImage = {}

	scrollview = cocostudio.getUIScrollView(view, "scroll_sexold")
	panel = cocostudio.getUIPanel(view, "panel")
	labTitle = cocostudio.getUILabel(view,"Label_6");
	Button_OK = cocostudio.getUIButton(view, "Button_OK");
	LordGamePub.showDialogAmin(panel)
	initView()
end
function setFlag(value)
	flag = value
end

--[[--
--初始化选择年龄界面
--]]
local function initSelectAgeView()
	local oldValue = profile.User.getAgeTxtTable();
	--		oldValue[1] = "保密"
	--		--最多显示100岁 100 = 86+14
	--		for x = 2 ,86 do
	--			--从16岁开始显示 16 = 2+14
	--			oldValue[x] = x + 14
	--		end
	local oldCnt = #oldValue

	local allheight = cellHeight * oldCnt + spacingH * (oldCnt + 1)
	scrollview:setInnerContainerSize(CCSizeMake(viewW, allheight))

	for i = 0, oldCnt-1 do
		local showyear = nil
		local cur = i+1
		--			if i == 0 then
		--				showyear = "保密"
		--			else
		--				showyear = oldValue[i+1].."岁"
		--			end
		showyear = oldValue[cur];
		local labelName = ccs.label({
			text = string.format(showyear),
			color = ccc3(193,150,108),
		})
		labelName:setFontSize(25)
		--check 圖片地址
		local checkimage = Common.getResourcePath("btn_gerenziliao_select_press.png")
		if(userold == "保密" and i == 0) then
			checkimage = Common.getResourcePath("btn_gerenziliao_select_nor.png")
		elseif(userold == ""..(oldValue[i+1])) then
			checkimage = Common.getResourcePath("btn_gerenziliao_select_nor.png")
		end
		local imageCheck = ccs.image({
			scale9 = false,
			image = checkimage,
			size = CCSizeMake(54 , 54),
		})
		checkListImage[cur] = imageCheck
		imageCheck:setTouchEnabled(false)

		local layout = ccs.button({
			scale9 = false,
			size = CCSizeMake(cellWidth, cellHeight),
			pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = { [ccs.TouchEventType.began]  =
				function(uiwidget)

				end,
				[ccs.TouchEventType.moved]  = function(uiwidget)  end,
				[ccs.TouchEventType.ended]  =
				function(uiwidget)
					setClick(cur)
					selectValue = oldValue[cur];
				end,
				[ccs.TouchEventType.canceled]   = function(uiwidget)  end,}
		})
		layout:setAnchorPoint(ccp(0.5, 0.5))
		layout:setScale9Enabled(true);
		SET_POS(labelName, 30,cellHeight/2)
		SET_POS(imageCheck,-30,cellHeight/2)
		SET_POS(layout,cellWidth / 2,allheight-i*spacingH - (3/ 2+i)*cellHeight)
		layout:addChild(labelName)
		layout:addChild(imageCheck)

		scrollview:addChild(layout)
	end
end

--[[--
--初始化选择省view
--]]
local function initSelectProvinceView()
	local ProvinceCnt = #AddressConfig.province

	local lieSize = 1 --列数
	local hangSize = math.floor((ProvinceCnt + (lieSize - 1)) / lieSize) --行数

	if hangSize * cellHeight > viewHMax then
		viewH = viewHMax
		viewY = 0
	else
		viewH = cellHeight * hangSize + spacingH * (hangSize + 1)
		viewY = viewHMax - hangSize * cellHeight - spacingH * (hangSize+1)
	end

	local allheight = cellHeight * hangSize + spacingH * (hangSize + 1)

	scrollview:setSize(CCSizeMake(viewW, viewH))
	scrollview:setInnerContainerSize(CCSizeMake(viewW, cellHeight * hangSize + spacingH * (hangSize + 1)))

	for i = 0, ProvinceCnt-1 do
		local cur = i+1
		local labelName = ccs.label({
			text = string.format(AddressConfig.province[i+1]),
			color = ccc3(255,255,255),
		})
		labelName:setFontSize(30)
		--check 圖片地址
		local checkimage = Common.getResourcePath("btn_gerenziliao_select_press.png")
		if(shengV == AddressConfig.province[i+1]) then
			checkimage = Common.getResourcePath("btn_gerenziliao_select_nor.png")
		end

		local imageCheck = ccs.image({
			scale9 = false,
			image = checkimage,
			size = CCSizeMake(54 , 54),
		})

		checkListImage[cur] = imageCheck
		imageCheck:setTouchEnabled(false)

		local layout = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = { [ccs.TouchEventType.began]  =
				function(uiwidget)

				end,
				[ccs.TouchEventType.moved]  = function(uiwidget)  end,
				[ccs.TouchEventType.ended]  =
				function(uiwidget)
					setClick(cur)
					setCity(AddressConfig.province[cur],AddressConfig.city[cur][1])
				end,
				[ccs.TouchEventType.canceled]   = function(uiwidget)  end,}
		})
		layout:setAnchorPoint(ccp(0.5, 0.5))
		layout:setScale9Enabled(true);
		SET_POS(labelName, 30,cellHeight/2)
		SET_POS(imageCheck,-30,cellHeight/2)
		SET_POS(layout,cellWidth / 2,allheight-i*spacingH - (3/ 2+i)*cellHeight)
		layout:addChild(labelName)
		layout:addChild(imageCheck)
		scrollview:addChild(layout)
	end
end

--[[--
--初始化选择city view
--]]
local function initSelectCityView()
	cityInProvince = AddressConfig.city[shengNum+1]
	local citysize = #cityInProvince

	local lieSize = 1 --列数
	local hangSize = math.floor((citysize + (lieSize - 1)) / lieSize) --行数

	if hangSize * cellHeight > viewHMax then
		viewH = viewHMax
		viewY = 0
	else
		viewH = cellHeight * hangSize + spacingH * (hangSize + 1)
		viewY = viewHMax - hangSize * cellHeight - spacingH * (hangSize+1)
	end
	local allheight = cellHeight * citysize + spacingH * (citysize + 1)
	scrollview:setSize(CCSizeMake(viewW, viewH))
	scrollview:setInnerContainerSize(CCSizeMake(viewW, cellHeight * hangSize + spacingH * (hangSize + 1)))

	for i = 0, citysize-1 do
		local cur = i+1
		local labelName = ccs.label({
			text = string.format(cityInProvince[i+1]),
			color = ccc3(255,255,255),
		})
		labelName:setFontSize(30)
		--check 圖片地址
		local checkimage = Common.getResourcePath("btn_gerenziliao_select_press.png")
		if( cityV == AddressConfig.city[shengNum+1][i+1]) then
			checkimage = Common.getResourcePath("btn_gerenziliao_select_nor.png")
		end

		local imageCheck = ccs.image({
			scale9 = false,
			image = checkimage,
			size = CCSizeMake(54 , 54),
		})

		checkListImage[cur] = imageCheck
		imageCheck:setTouchEnabled(false)

		local layout = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = { [ccs.TouchEventType.began]  =
				function(uiwidget)

				end,
				[ccs.TouchEventType.moved]  = function(uiwidget)  end,
				[ccs.TouchEventType.ended]  =
				function(uiwidget)
					setClick(cur)
					setCity(AddressConfig.province[shengNum+1],cityInProvince[i+1])
				end,
				[ccs.TouchEventType.canceled]   = function(uiwidget)  end,}
		})
		layout:setAnchorPoint(ccp(0.5, 0.5))
		layout:setScale9Enabled(true);
		SET_POS(labelName, 30,cellHeight/2)
		SET_POS(imageCheck,-30,cellHeight/2)
		SET_POS(layout,cellWidth / 2,allheight-i*spacingH - (3/ 2+i)*cellHeight)
		layout:addChild(labelName)
		layout:addChild(imageCheck)

		scrollview:addChild(layout)
	end
end

function initView()
	if flag == 1 then
		--初始化选择年龄界面
		labTitle:setText("请选择年龄");
		initSelectAgeView();
	elseif flag == 0 then

	elseif flag == 2 then
		--初始化选择省view
		labTitle:setText("请选择省份");
		initSelectProvinceView();
	elseif flag == 3 then
		--初始化选择市view
		labTitle:setText("请选择城市");
		initSelectCityView();
	end
end

function setClick(curV)
	for i=1,#checkListImage do
		checkListImage[i]:loadTexture(Common.getResourcePath("btn_gerenziliao_select_press.png"))
	end
	checkListImage[curV]:loadTexture(Common.getResourcePath("btn_gerenziliao_select_nor.png"))
end

function setCity(shengvalue, cityvalue)
	--mvcEngine.destroyModule(GUI_SETOLDSEX)
	CityListLogic.setCityFromPop(shengvalue, cityvalue)
end

function requestMsg()

end

--panel面板
function callback_panel_main(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_OK(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if flag == 1 then
			--选择年龄界面
			setOld(selectValue)
		elseif flag == 0 then

		elseif flag == 2 then
			--初始化选择省view

		elseif flag == 3 then
			--初始化选择市view

		end
		close();
	elseif component == CANCEL_UP then
	--取消

	end
end

function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end

function closePanel()
	--关闭界面
	mvcEngine.destroyModule(GUI_SETOLDSEX)
end

--界面切换赋值
function setSexValue(value)
	usersex = value
end

function setYearValue(value)
	userold = value
end

--本页面关闭事件
function setSex(value)
	--关闭界面
	if value ~= nil and value ~= "" then
		UserInfoLogic.setSexValue(value)
	end
	--mvcEngine.destroyModule(GUI_SETOLDSEX)
end

function setOld(value)
	--关闭界面
	if value ~= nil and value ~= "" then
		UserInfoLogic.setOldValue(value)
	end
end

function setShengValueFromCityList(value)
	shengV = value
end

function setCityValueFromCityList(cityValue,shengvalue)
	cityV = cityValue
	shengName =  shengvalue
	local ProvinceCnt = #AddressConfig.province
	for i = 0, ProvinceCnt - 1 do
		if AddressConfig.province[i+1] == shengName then
			shengNum = i
			break
		end
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
end

function removeSlot()
end
