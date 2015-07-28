module("HuoDongLogic",package.seeall)

view = nil
Panel_20 = nil;--
Image_yemian = nil;--
huodongInfoTable = nil
OPERID_GET_OPER_TASK_LISTInfo = nil --活动列表消息详情
BackButton = nil;
ImageviewItemTable = {};
ScrollView_huodong = nil;--
guanbi = nil;--

huoDongImageTable = {} --活动图片
layerTable = {}  --层

function onKeypad(event)
	if event == "backClicked" then
		local function actionOver()
			mvcEngine.destroyModule(GUI_HUODONG)
		end
		LordGamePub.closeDialogAmin(Image_yemian, actionOver)
	elseif event == "menuClicked" then
	end
end


--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_HUODONG;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("HuoDong.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("HuoDong.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("HuoDong_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)
	initView()
	initdata()
--	LordGamePub.showDialogAmin(Panel_20, false, nil)
end

function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Image_yemian = cocostudio.getUIImageView(view, "Image_yemian");
	guanbi = cocostudio.getUIImageView(view, "guanbi");
	BackButton = cocostudio.getUIButton(view, "BackButton")
	ScrollView_huodong = cocostudio.getUIScrollView(view, "ScrollView_huodong");
	OPERID_GET_OPER_TASK_LISTInfo = nil
end

--[[--
--初始化数据
--]]--
function initdata()
	local function delaySentMessage()
		sendOPERID_GET_OPER_TASK_LIST_V2(GameLoadModuleConfig.getTaskGameConfigList())
	end
	local array = CCArray:create()
	array:addObject(CCCallFuncN:create(function()
		LordGamePub.showDialogAmin(Panel_20, false, nil)
		end));
	array:addObject(CCDelayTime:create(0.2))
	array:addObject(CCCallFuncN:create(function()
		LordGamePub.runSenceAction(view,delaySentMessage,false)
		end));
    local seq = CCSequence:create(array);
    view:runAction(seq);
    Common.showProgressDialog("正在加载游戏，请稍后...",nil,nil,false)

end



--[[--
--初始化ScrollView
--]]--
function initScrollView()

	---监测服务器红点数据
	for i = 1, #OPERID_GET_OPER_TASK_LISTInfo["operTaskList"] do
		if i == #OPERID_GET_OPER_TASK_LISTInfo["operTaskList"] then
			HongDianLogic.getHongDian_Data_isTure(2, i, OPERID_GET_OPER_TASK_LISTInfo["operTaskList"][i]["taskId"], 1)
		else
			HongDianLogic.getHongDian_Data_isTure(2, i, OPERID_GET_OPER_TASK_LISTInfo["operTaskList"][i]["taskId"])
		end
	end

	local viewWmax = 642

	local AnimationTable = {}


	local huoDongNum = #OPERID_GET_OPER_TASK_LISTInfo["operTaskList"]

	ScrollView_huodong:removeAllChildren()
	ScrollView_huodong:setSize(CCSizeMake(viewWmax, 339))
	ScrollView_huodong:setInnerContainerSize(CCSizeMake(viewWmax,huoDongNum*145))
	ScrollView_huodong:setAnchorPoint(ccp(0,0))

	local cellWidth = 594; --每个元素的宽
	local cellHeight = 145; --每个元素的高

	for i = 1, #OPERID_GET_OPER_TASK_LISTInfo["operTaskList"] do
		local layout = ccs.panel({
			size = CCSizeMake(cellWidth, cellHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		layout:setAnchorPoint(ccp(0.5, 0.5));

		local button = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			text = "",
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = {
				[ccs.TouchEventType.began] = function(uiwidget)
					layout:setScale(1.1)
				end,
				[ccs.TouchEventType.moved] = function(uiwidget)
				end,
				[ccs.TouchEventType.ended] = function(uiwidget)
					layout:setScale(1)
					callClickButton(layout,i)
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
					layout:setScale(1)
				end,
			}
		})


		local imageHuoDong = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_jiazaimoren.png"),
		})


		button:setAnchorPoint(ccp(0.5,0.5))

		SET_POS(button, cellWidth/2, cellHeight/2);
		SET_POS(imageHuoDong, cellWidth/2, cellHeight/2);

		layout:addChild(imageHuoDong)
		layout:addChild(button)

		huoDongImageTable[""..i] = imageHuoDong;
		local huoDongID = OPERID_GET_OPER_TASK_LISTInfo.operTaskList[i].taskId  --ID
		local huoDongURL = OPERID_GET_OPER_TASK_LISTInfo.operTaskList[i].taskPhotoUrl --URL
		local huoDongNAME = OPERID_GET_OPER_TASK_LISTInfo.operTaskList[i].taskTitle  --名字
		local huoDongTIP = OPERID_GET_OPER_TASK_LISTInfo.operTaskList[i].taskTimePrompt  --提示
		if huoDongURL ~= nil and huoDongURL ~= "" then
			Common.getPicFile(huoDongURL, i, true, getHuoDongIcon)
		end

		layerTable[i] = layout
		layerTable[i]:setVisible(false)

		if huoDongNum < 3 then
			SET_POS(layout, cellWidth/2+25,145*(3-i)-35);
		else
			SET_POS(layout, cellWidth/2+25,(huoDongNum-i)*145+60);
		end

		table.insert(AnimationTable, layerTable[i]);
		ScrollView_huodong:addChild(layerTable[i])


		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			if profile.HongDian.getProfile_HongDian_datatable() == 0 then
				Common.log("显示红点HuoDong")
				for f = 1, #profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()[2]["ID"] do
					HongDianLogic.showAllChild_List_NewLabel(2,tonumber(profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()[2]["ID"][f]),layout)
				end
			end
		end

	end


	local function callbackShowImage(index)
		--播放对话回调函数
		if layerTable[index] ~= nil then
			layerTable[index]:setVisible(true);
		end
	end
	LordGamePub.showLandscapeList(AnimationTable, callbackShowImage);  --播放动画
end


function callback_guanbi(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local function actionOver()
			mvcEngine.destroyModule(GUI_HUODONG)
		end
		LordGamePub.closeDialogAmin(Image_yemian, actionOver)
	elseif component == CANCEL_UP then
	--取消

	end
end


--[[--
--点击事件回调
--]]--
function callClickButton(layout,num)
	if(num > #OPERID_GET_OPER_TASK_LISTInfo.operTaskList)then
		Common.showToast("更多活动敬请期待！",2)
		return
	end
	if(OPERID_GET_OPER_TASK_LISTInfo.operTaskList[num].taskId == 4)then
		--爱心女神
		if GameLoadModuleConfig.getGoddessIsExists() then
			mvcEngine.createModule(GUI_AIXINNVSHEN)
		else
			Common.showToast("资源加载中，请稍候…",2)
		end
	elseif(OPERID_GET_OPER_TASK_LISTInfo.operTaskList[num].taskId == 3) then
		--福星高照
		if GameLoadModuleConfig.getBlessingIsExists() then
			mvcEngine.createModule(GUI_FUXINGGAOZHAO)
		else
			Common.showToast("资源加载中，请稍候…",2)
		end
	elseif(OPERID_GET_OPER_TASK_LISTInfo.operTaskList[num].taskId == 6) then
		mvcEngine.createModule(GUI_LUCKY_TURNTABLE)
	elseif(OPERID_GET_OPER_TASK_LISTInfo.operTaskList[num].taskId == 7) then
		--愚人节活动
		if GameLoadModuleConfig.getBlessingIsExists() then
			mvcEngine.createModule(GUI_TRICKYPARTY)
		else
			Common.showToast("资源加载中，请稍候…",2)
		end
	end
	if profile.HongDian.getProfile_HongDian_datatable() == 0 then
		for f = 1, #profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()[2]["ID"] do
			OPERID_GET_OPER_TASK_LISTInfo = profile.HuoDong.getOPERID_GET_OPER_TASK_LIST_V2Table()
			if profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()[2]["ID"][f] == OPERID_GET_OPER_TASK_LISTInfo.operTaskList[num].taskId.."" then
				if profile.HongDian.getProfile_HongDian_datatable() == 0 then
					HongDianLogic.removeList_New_Label(2, layout,OPERID_GET_OPER_TASK_LISTInfo.operTaskList[num].taskId)
					HongDian_datatable = {}
					HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
					HongDian_datatable[2]["ID"][f] = nil
					Common.log(OPERID_GET_OPER_TASK_LISTInfo.operTaskList[num].taskId.."fuxinggaozaomc")
					sendMANAGERID_REMOVE_REDP(2, OPERID_GET_OPER_TASK_LISTInfo.operTaskList[num].taskId)
				end
			end
		end
	end
end

--[[--
--创建活动图片
--]]--
function getHuoDongIcon(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" then
		huoDongImageTable[""..id]:loadTexture(photoPath)
		huoDongImageTable[""..id]:setScale(0.96)
	end
end

function requestMsg()

end


--获取活动列表
function getOPERID_GET_OPER_TASK_LISTInfo()
	OPERID_GET_OPER_TASK_LISTInfo = profile.HuoDong.getOPERID_GET_OPER_TASK_LIST_V2Table()
	initScrollView()
	profile.Marquee.resetMARQUEE_TABLE(1)
	Common.closeProgressDialog()
end


--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(OPERID_GET_OPER_TASK_LIST_V2,getOPERID_GET_OPER_TASK_LISTInfo)
end

function removeSlot()
	framework.removeSlotFromSignal(OPERID_GET_OPER_TASK_LIST_V2,getOPERID_GET_OPER_TASK_LISTInfo)
end
