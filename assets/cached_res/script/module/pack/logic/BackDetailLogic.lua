module("BackDetailLogic",package.seeall)

view = nil
panel = nil

text_packname = nil
text_packdetl = nil
img_pack = nil
img_packbg = nil
btn_ok = nil
btn_close = nil
panel = nil

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
	local gui = GUI_BACKDETAIL;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("BackDetail.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("BackDetail.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("BackDetail_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())

	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)
	GameStartConfig.addChildForScene(view)
	initView()
end

function initView()
	text_packname = cocostudio.getUILabel(view, "text_packname")
	text_packdetl = cocostudio.getUILabel(view, "text_packdetl")
	img_pack = cocostudio.getUIImageView(view, "img_pack")
	img_packbg = cocostudio.getUIImageView(view, "img_packbg")
	btn_ok = cocostudio.getUIButton(view, "btn_ok")
	btn_close = cocostudio.getUIButton(view, "btn_close")
end
function requestMsg()

end

function callback_btn_ok(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消
	end
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
	mvcEngine.destroyModule(GUI_BACKDETAIL)
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
	if photoPath ~= nil and photoPath ~= "" and img_pack ~= nil then
		img_pack:loadTexture(photoPath)
	end
end

function setPackData(name, content, imageurl, bgurl)
	text_packname:setText(name)
	text_packdetl:setText(content)
	img_packbg:loadTexture(bgurl)
	Common.getPicFile(imageurl, 0, true, updataImage)
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
