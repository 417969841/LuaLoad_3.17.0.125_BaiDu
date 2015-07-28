module("CardKhAndPassLogic",package.seeall)

view = nil
--控件
lab_name = nil
lab_kh = nil
lab_pass = nil
btn_close = nil
panel = nil
lab_bisai = nil
lab_time = nil
lab_gqtime = nil
img_photo = nil
--变量
local itemName = ""
local kh = ""
local pass = ""
local PrizeID = nil
local userID = nil
local name = nil
local status = nil
local date = nil
local url = nil
local des = nil
local flag = 0 ---1界面传的    2从数据库读的

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
	view = cocostudio.createView("CardKhAndPass.json")
	local gui = GUI_CARDKHANDPASS
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
	userID = profile.User.getSelfUserID()

	--控件
	lab_name = cocostudio.getUILabel(view,"lab_name")
	lab_kh = cocostudio.getUILabel(view, "lab_kh")
	lab_pass = cocostudio.getUILabel(view, "lab_pass")
	btn_close = cocostudio.getUIButton(view, "btn_close")
	lab_bisai = cocostudio.getUILabel(view, "lab_bisai")
	lab_time = cocostudio.getUILabel(view, "lab_time")
	lab_gqtime = cocostudio.getUILabel(view, "lab_gqtime")
	img_photo =  cocostudio.getUIImageView(view, "img_photo")
	lab_kh:setText("")
	lab_pass:setText("")

	lab_bisai:setText(name)
	local datetab = nil
	if date ~= nil then
		datetab = os.date("*t", date / 1000)
		lab_time:setText(datetab.year.."年"..datetab.month.."月"..datetab.day.."日")
	end
	lab_gqtime:setText("")

	if flag == 1  then
--		lab_name:setText(itemName)
		lab_kh:setText(kh)
		lab_pass:setText(pass)
	else
--		lab_name:setText(Common.getDataForSqlite(CommSqliteConfig.GetCardKhInGameName..PrizeID..userID))
		lab_kh:setText(Common.getDataForSqlite(CommSqliteConfig.GetCardKh..PrizeID..userID))
		lab_pass:setText(Common.getDataForSqlite(CommSqliteConfig.GetCardPass..PrizeID..userID))
	end

	Common.getPicFile(url, 0, true, updataImage)
end

function requestMsg()

end

function callback_btn_close(component)
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
	mvcEngine.destroyModule(GUI_CARDKHANDPASS)
	if flag == 1 then
		mvcEngine.createModule(GUI_EXCHANGE,LordGamePub.runSenceAction(view,nil,true))
	end
end
function setValue(flagV,PrizeIDV,PrizeNameV,CardNOV,PasswordV)
	flag = flagV
	PrizeID = PrizeIDV
	itemName = PrizeNameV
	kh = CardNOV
	pass = PasswordV
end
--setAwardID(2,AwardID,disName,Status,Date,PictureUrl,Description)
function setAwardID(flagV,AwardIDV,disNameV,StatusV,DateV,PictureUrlV,DescriptionV)
	flag  = flagV
	PrizeID = AwardIDV
	name = disNameV
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

end

function removeSlot()

end
