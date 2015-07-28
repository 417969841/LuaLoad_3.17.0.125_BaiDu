module("CityListLogic",package.seeall)

view = nil

--公共数据
local sheng = nil
local city = nil

--控件
lab_province = nil
lab_city = nil
local useraddress = nil
panel = nil
btn_save = nil
btn_cancel = nil

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("CityList.json")
	local gui = GUI_CITYLIST
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
	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)

	lab_city = cocostudio.getUILabel(view, "lab_city")
	lab_province = cocostudio.getUILabel(view, "lab_province")
	btn_save = cocostudio.getUIButton(view, "btn_save")
	btn_cancel = cocostudio.getUIButton(view, "btn_cancel")

	if useraddress == "保密" then
		useraddress = "保密-保密"
	end

	if useraddress == "" or useraddress == nil then
		lab_province:setText("保密")
		lab_city:setText("保密")
	else
		local i, j = string.find(useraddress, "-")
		Common.log(i, j)
		--  string.sub(s,i,j) 提取字符串s的第i个到第j个字符。Lua中，第一个字符的索引值为1，最后一个为-1，以此类推，如：
		--  Common.log(string.sub("[hello world]",2,-2))      --输出hello world
		local sheng = string.sub(useraddress, 1, i-1)
		local shi = string.sub(useraddress, j+1, -1)
		Common.log("=========="..sheng..shi..useraddress)
		lab_city:setText(shi)
		lab_province:setText(sheng)

	end
end

function requestMsg()

end

function callback_btn_save(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		close()
		if sheng ~= nil and city ~= nil then
			UserInfoLogic.setAddressFromCityList(sheng.."-"..city)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	--关闭界面
	mvcEngine.destroyModule(GUI_CITYLIST)
end

function callback_lab_province(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		SetOldSexLogic.setFlag(2)
		SetOldSexLogic.setShengValueFromCityList(lab_province:getStringValue())
		mvcEngine.createModule(GUI_SETOLDSEX)
	elseif component == CANCEL_UP then
	--取消
	end
end
function callback_lab_city(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if sheng == "" or sheng == nil then
			sheng = "保密"
		end
		SetOldSexLogic.setFlag(3)
		SetOldSexLogic.setCityValueFromCityList(lab_city:getStringValue(),lab_province:getStringValue())

		mvcEngine.createModule(GUI_SETOLDSEX)
	elseif component == CANCEL_UP then
	--取消
	end
end

--界面传值
function setShengCity(value)
	useraddress = value
end
function setShengFromPop(value)
	lab_province:setText(value)
end
function setCityFromPop(shengvalue, cityvalue)
	if shengvalue ~= nil then
		lab_province:setText(shengvalue)
	end
	if cityvalue ~= nil then
		lab_city:setText(cityvalue)
	end
	sheng = shengvalue
	city = cityvalue
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
--framework.addSlot2Signal(signal, slot)

end
function removeSlot()
--framework.removeSlotFromSignal(signal, slot)

end
