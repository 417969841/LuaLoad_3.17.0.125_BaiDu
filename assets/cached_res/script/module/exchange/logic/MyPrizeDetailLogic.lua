module("MyPrizeDetailLogic",package.seeall)

view = nil
--控件
lab_name = nil
lab_time = nil
img_photo = nil
panel = nil
btn_close = nil

--value
local awardID = nil
local name = nil
local status = nil
local date = nil
local url = nil
local des = nil

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

local function updataImage(dataInApp)
	local photoPath = nil
	if Common.platform == Common.TargetIos then
		photoPath = dataInApp["useravatorInApp"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(dataInApp, "#")
		local id = string.sub(dataInApp, 1, i-1)
		photoPath = string.sub(dataInApp, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and img_photo ~= nil then
		img_photo:loadTexture(photoPath)
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("MyPrizeDetail.json")
	local gui = GUI_MYPRIZEDETAIL
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
	lab_name = cocostudio.getUILabel(view,"lab_name")
	lab_time = cocostudio.getUILabel(view,"lab_time")
	img_photo = cocostudio.getUIImageView(view, "img_photo")
	btn_close = cocostudio.getUIButton(view, "btn_close")

	lab_name:setText(name)
	local datetab = os.date("*t", math.floor(date/1000))
	lab_time:setText(datetab.year.."年"..datetab.month.."月"..datetab.day.."日")
	Common.getPicFile(url, 0, true, updataImage)
end

function requestMsg()

end

function callback_btn_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end
--关闭
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_MYPRIZEDETAIL)
end
function setValue(AwardIDV,NameV,StatusV,DateV,PictureUrlV,DescriptionV)
	awardID = AwardIDV
	name = NameV
	status = StatusV
	date = DateV
	url = PictureUrlV
	des = DescriptionV
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
