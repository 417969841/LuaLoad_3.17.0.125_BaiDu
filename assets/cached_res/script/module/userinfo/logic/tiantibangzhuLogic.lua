module("tiantibangzhuLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_378 = nil;--
ImageView_mianban = nil;--
lab_title = nil;--
ScrollView_picture = nil;--
lab_text = nil;--
btn_close = nil;--
Panel_32 = nil;--
btn_pre = nil;--
Panel_32_0 = nil;--
btn_next = nil;--
TianTiHelpTable = {}  --天梯帮助Table
ImageTable = {} --图片Table
TextTable = {} --textTable
localnum = 1 --当前页面
local percentTable = {}


function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_378 = cocostudio.getUIPanel(view, "Panel_378");
	ImageView_mianban = cocostudio.getUIImageView(view, "ImageView_mianban");
	lab_title = cocostudio.getUILabel(view, "lab_title");
	ScrollView_picture = cocostudio.getUIScrollView(view, "ScrollView_picture");
	lab_text = cocostudio.getUILabel(view, "lab_text");
	btn_close = cocostudio.getUIButton(view, "btn_close");
	Panel_32 = cocostudio.getUIPanel(view, "Panel_32");
	btn_pre = cocostudio.getUIButton(view, "btn_pre");
	Panel_32_0 = cocostudio.getUIPanel(view, "Panel_32_0");
	btn_next = cocostudio.getUIButton(view, "btn_next");
end

function createView()
	view = cocostudio.createView("tiantibangzhu.json");
	view:setTag(getDiffTag());
	scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(view)
	initView();
	initData()
end

function initData()
	sendLadder_MSG_HELP()
	ScrollView_picture:removeAllChildren()
	ScrollView_picture:setInnerContainerSize(CCSizeMake(378*4+116*2,240))
end
function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		local function actionOver()
			mvcEngine.destroyModule(GUI_TIANTIHELP)
		end
		LordGamePub.closeDialogAmin(ImageView_mianban, actionOver)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_pre(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		localnum = localnum - 1
		moveScrollview()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_next(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		localnum = localnum + 1
		moveScrollview()
	elseif component == CANCEL_UP then
	--取消

	end
end


percentTable = {0,33.4,66.8,100}

function  moveScrollview()
	if localnum <= 0 then
		localnum = 4
	elseif localnum >= 5 then
		localnum = 1
	end
--	Common.log("zbl....localnum===" .. localnum .. "===  " .. percentTable[localnum])
	lab_text:setText(TextTable[localnum])
	ScrollView_picture:scrollToPercentHorizontal(percentTable[localnum],0.1,false)
end
--[[--
--创建活动图片
--]]--
function getPicTure(path)

	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" then
		ImageTable[tonumber(id)]:loadTexture(photoPath)
	end
end


function getHelpMsg()
	TianTiHelpTable = profile.TianTiData.getTianTiHelp().helpMSG
	for i=1, #TianTiHelpTable do
		local url = TianTiHelpTable[i].helpUrl

		TextTable[i] = TianTiHelpTable[i].helpWord
		ImageTable[i] = ccs.image({
			scale9 = false,
			image = "",
		})
		ImageTable[i]:setAnchorPoint(ccp(0,0))
		ImageTable[i]:setPosition(ccp(120+ 378*(i-1),4))
		ScrollView_picture:addChild(ImageTable[i])

		if url ~= nil and url ~= "" then
			Common.getPicFile(url, i, true, getPicTure)
		end
	end

	lab_text:setText(TextTable[1])

	--第一张图(显示最后一张)
	ImageTable[11] = ccs.image({
			scale9 = false,
			image = "",
	})
	ImageTable[11]:setAnchorPoint(ccp(1,0))
	ImageTable[11]:setPosition(ccp(112,4))
	ScrollView_picture:addChild(ImageTable[11])
	Common.getPicFile(TianTiHelpTable[#TianTiHelpTable].helpUrl, 11, true, getPicTure)

	--最后一张图(显示第一张)
	ImageTable[12] = ccs.image({
			scale9 = false,
			image = "",
	})
	ImageTable[12]:setAnchorPoint(ccp(0,0))
	ImageTable[12]:setPosition(ccp(120+#TianTiHelpTable*378,4))
	ScrollView_picture:addChild(ImageTable[12])
	Common.getPicFile(TianTiHelpTable[1].helpUrl, 12, true, getPicTure)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(Ladder_MSG_HELP, getHelpMsg)
end

function removeSlot()
	framework.removeSlotFromSignal(Ladder_MSG_HELP, getHelpMsg)
end
