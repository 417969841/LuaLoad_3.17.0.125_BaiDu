module("TrickyPartyRankLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Image_MianBan = nil;--
Label_Paihangbang = nil;--
ScrollView_paihangbang = nil;--
Image_HeiTiao = nil;--
Label_geren = nil;--个人排名
Button_Close = nil;--关闭



local cellWidth = 636
local cellHeight = 60



function onKeypad(event)
	if event == "backClicked" then
		--返回键
		local function actionOver()
			mvcEngine.destroyModule(GUI_TRICKYPARTYRANK)
		end
		LordGamePub.closeDialogAmin(Image_MianBan, actionOver)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_TRICKYPARTYRANK;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("load_res/TrickyParty/TrickyPartyRank.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("load_res/TrickyParty/TrickyPartyRank.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Image_MianBan = cocostudio.getUIImageView(view, "Image_MianBan");
	Label_Paihangbang = cocostudio.getUILabel(view, "Label_Paihangbang");
	ScrollView_paihangbang = cocostudio.getUIScrollView(view, "ScrollView_paihangbang");
	Image_HeiTiao = cocostudio.getUIImageView(view, "Image_HeiTiao");
	Label_geren = cocostudio.getUILabel(view, "Label_geren");
	Button_Close = cocostudio.getUIButton(view, "Button_Close");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	initView();
	sendTRICKYPARTY_RANK_LIST(1)
end

function requestMsg()

end

function callback_Panel_14(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local function actionOver()
			mvcEngine.destroyModule(GUI_TRICKYPARTYRANK)
		end
		LordGamePub.closeDialogAmin(Image_MianBan, actionOver)
	elseif component == CANCEL_UP then
	--取消

	end
end

function processTRICKYPARTY_RANK_LIST()
	local RankTable =  profile.TrickyParty.getTRICKYPARTY_RANK_LIST()
	local selfRank = RankTable["NewUserRank"]
	if(selfRank>0)then
		Label_geren:setText("个人排名: " .. selfRank)
	else
		Label_geren:setText("个人排名: 999+")
	end
	local topCnt = #RankTable["topCnt"]
	ScrollView_paihangbang:removeAllChildren()
	ScrollView_paihangbang:setInnerContainerSize(CCSizeMake(cellWidth, cellHeight * topCnt))


	for i=1,topCnt do
		local ranknum = RankTable["topCnt"][i].rank
		local imageUrl = RankTable["topCnt"][i].userPic
		local vip = RankTable["topCnt"][i].vip
		local username = RankTable["topCnt"][i].userName
		local goodsNumber = RankTable["topCnt"][i].goodsNumber
--		cellHeight = 60
		--底板
		local layout = ccs.image({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			image = "",
			capInsets = CCRectMake(cellWidth, cellHeight, 0, 0),
		})
		Common.log("zbl...topCnt = " .. topCnt .."    i = " .. i)
		SET_POS(layout,3 ,cellHeight * (topCnt- i))

		--背景
		local bgurl
		if i%2 == 0 then
			bgurl = "load_res/TrickyParty/bg_paihangbang_di2.png"
		else
			bgurl = "load_res/TrickyParty/bg_paihangbang_di1.png"
		end
		local imgbg  = ccs.image({
			scale9 = false,
			image = Common.getResourcePath(bgurl),
		})
		imgbg:setScaleX(cellWidth / imgbg:getContentSize().width)
		imgbg:setScaleY(cellHeight / imgbg:getContentSize().height)
		SET_POS(imgbg, cellWidth/2, cellHeight/2);
		layout:addChild(imgbg)


		--名次
		local labelNum
		if i <= 3 then
			labelNum = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("load_res/TrickyParty/ic_paihangbang_num" .. i .. ".png"),
			})
		else
			labelNum = ccs.label({
				text = "NO." .. ranknum
			})
			labelNum:setFontSize(22)
		end
		SET_POS(labelNum,  40, cellHeight/2);
		layout:addChild(labelNum)

		--[[--
		--头像
		local userImage
		if(imageUrl ~= nil and imageUrl ~= "" and i <= 3)then
			local function getUserImage(path)
				local photoPath = nil;
				local id = nil;
				if Common.platform == Common.TargetIos then
					photoPath = path["useravatorInApp"]
					id = path["id"]
				elseif Common.platform == Common.TargetAndroid then
					local i, j = string.find(path, "#")
					id = string.sub(path, 1, i - 1)
					photoPath = string.sub(path, j + 1, -1)
				end

				if photoPath ~= nil and photoPath ~= "" then
					userImage = ccs.image({
						scale9 = false,
						image = photoPath,
					})
					if(userImage == nil) then
						return
					end
					userImage:setScaleX(59/userImage:getContentSize().width)
					userImage:setScaleY(59/userImage:getContentSize().height)
					SET_POS(userImage, 130, cellHeight/2);
					layout:addChild(userImage)
				end
			end
			Common.getPicFile(imageUrl, 1, true, getUserImage)
		elseif(i <= 3)then
			userImage = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("load_res/TrickyParty/hall_portrait_default.png"),
			})
			userImage:setScaleX(59/userImage:getContentSize().width)
			userImage:setScaleY(59/userImage:getContentSize().height)
			SET_POS(userImage, 130, cellHeight/2);
			layout:addChild(userImage)
		end
		--]]--


		--VIP
		if vip > 0 then
			local imageVIP = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("load_res/TrickyParty/hall_vip_icon.png"),
			})
			SET_POS(imageVIP, 160, cellHeight/2);
			layout:addChild(imageVIP)

			local vipNum = VIPPub.getUserVipType(vip)
			Common.log("zbl00000....vipNum= " .. vipNum .. "             vip = " .. vip)
			local labelVIP = ccs.labelAtlas({
				text = vip,
				start = "0",
				image = Common.getResourcePath("load_res/TrickyParty/num_vip_level.png"),
				w = 27,
				h = 32,
			})
			SET_POS(labelVIP, 202, cellHeight/2);
			layout:addChild(labelVIP)
		end

		--名字
		local labelName = ccs.label({
			text = username,
		})
		labelName:setFontSize(22)
		SET_POS(labelName, 300, cellHeight/2);
		layout:addChild(labelName)


		--整蛊道具娃娃
		local imageWawa = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("load_res/TrickyParty/zhenggudaoju.png"),
		})
		SET_POS(imageWawa, 425, cellHeight/2);
		layout:addChild(imageWawa)

		--道具个数
		local labelWawa = ccs.label({
			text = "勤劳值 * " .. goodsNumber,
		})
		labelWawa:setFontSize(22)
		SET_POS(labelWawa, 530, cellHeight/2);
		layout:addChild(labelWawa)




		ScrollView_paihangbang:addChild(layout)
	end
end


--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(TRICKYPARTY_RANK_LIST, processTRICKYPARTY_RANK_LIST)
end

function removeSlot()
	framework.removeSlotFromSignal(TRICKYPARTY_RANK_LIST, processTRICKYPARTY_RANK_LIST)
end
