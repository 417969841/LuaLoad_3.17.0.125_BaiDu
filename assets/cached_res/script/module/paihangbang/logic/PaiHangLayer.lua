module("PaiHangLayer",package.seeall)
function replacePaiHang(PaiHangBangData,numLayer)
	local tuHaoTable = PaiHangBangData["RankListItemClientList"]

	local roleTotal = #PaiHangBangData["RankListItemClientList"]
	local viewWmax = GameConfig.ScreenWidth  --屏幕宽
	local viewHmax = GameConfig.ScreenHeight  --屏幕高

	local cellWidth = 1044; --每个元素的宽
	local cellWidth_chongzhi = 917 --每日充值榜每个元素的宽
	local cellHeight = 69; --每个元素的高
	local cellInterval = 90 -- 元素的高+间隔

	local positionX = 34
	local scorll2or4pstX = 165  --每日充值榜X坐标
	local scorll2or4pstY = 35  --每日充值榜Y坐标
	PaiHangBangLogic.ScrollView_PaiHangBang:removeAllChildren()
--	--适配需要：对列表进行缩放横坐标和纵坐标的缩放
--	PaiHangBangLogic.ScrollView_PaiHangBang:setScaleX(GameConfig.ScaleAbscissa);
--	PaiHangBangLogic.ScrollView_PaiHangBang:setScaleY(GameConfig.ScaleOrdinate);

	if numLayer == 2 or numLayer == 4 then
		--  2：今日充值排行   4：昨日充值排行
		if numLayer == 2 then
			PaiHangBangLogic.isWhichDay = 1
			PaiHangBangLogic.Image_jinri:loadTexture(Common.getResourcePath("ui_paihangbang_btn_charge_jinripaihang2.png"))
			PaiHangBangLogic.Image_zuori:loadTexture(Common.getResourcePath("ui_paihangbang_btn_charge_zuoripaihang.png"))
			PaiHangBangLogic.Button_jinri:loadTextures(Common.getResourcePath("btn_paihangbang_charge_press.png"),Common.getResourcePath("btn_paihangbang_charge_press.png"),"")
			PaiHangBangLogic.Button_zuori:loadTextures(Common.getResourcePath("btn_paihangbang_charge_nor.png"),Common.getResourcePath("btn_paihangbang_charge_nor.png"),"")
		else
			PaiHangBangLogic.isWhichDay = 2
			PaiHangBangLogic.Image_jinri:loadTexture(Common.getResourcePath("ui_paihangbang_btn_charge_jinripaihang.png"))
			PaiHangBangLogic.Image_zuori:loadTexture(Common.getResourcePath("ui_paihangbang_btn_charge_zuoripaihang2.png"))
			PaiHangBangLogic.Button_jinri:loadTextures(Common.getResourcePath("btn_paihangbang_charge_nor.png"),Common.getResourcePath("btn_paihangbang_charge_nor.png"),"")
			PaiHangBangLogic.Button_zuori:loadTextures(Common.getResourcePath("btn_paihangbang_charge_press.png"),Common.getResourcePath("btn_paihangbang_charge_press.png"),"")
		end

		if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
			--960_640
			scorll2or4pstX = 165
			scorll2or4pstY = 35
			PaiHangBangLogic.ScrollView_PaiHangBang:setSize(CCSizeMake(734, 405))
			PaiHangBangLogic.ScrollView_PaiHangBang:setInnerContainerSize(CCSizeMake(734, cellHeight*roleTotal))
		else
			PaiHangBangLogic.ScrollView_PaiHangBang:setSize(CCSizeMake(cellWidth_chongzhi, 405))
			PaiHangBangLogic.ScrollView_PaiHangBang:setInnerContainerSize(CCSizeMake(cellWidth_chongzhi, cellHeight*roleTotal))
		end
		PaiHangBangLogic.Panel_chongzhongmianban:setVisible(true)
		PaiHangBangLogic.Button_jinri:setTouchEnabled(true);
		PaiHangBangLogic.Button_zuori:setTouchEnabled(true);

		PaiHangBangLogic.ScrollView_PaiHangBang:setPosition(ccp(scorll2or4pstX, scorll2or4pstY))
		PaiHangBangLogic.ScrollView_PaiHangBang:setAnchorPoint(ccp(0,0))

		PaiHangBangLogic.Image_dadiban:setVisible(false)
	else
		PaiHangBangLogic.Panel_chongzhongmianban:setVisible(false)
		PaiHangBangLogic.ScrollView_PaiHangBang:setSize(CCSizeMake(viewWmax, 410))
		PaiHangBangLogic.ScrollView_PaiHangBang:setInnerContainerSize(CCSizeMake(viewWmax, cellHeight*roleTotal))
		if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
			PaiHangBangLogic.ScrollView_PaiHangBang:setPosition(ccp(0, 35))
		else
			PaiHangBangLogic.ScrollView_PaiHangBang:setPosition(ccp(0, 30))
		end
		PaiHangBangLogic.ScrollView_PaiHangBang:setAnchorPoint(ccp(0,0))

		PaiHangBangLogic.Image_dadiban:setVisible(true)
	end

	for i = 1, #PaiHangBangData["RankListItemClientList"] do
		--底板
		local layout = ccs.image({
			scale9 = true,
			size = CCSizeMake(cellWidth, cellHeight),
			image = "",
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		layout:setScale9Enabled(true);
		layout:setAnchorPoint(ccp(0.5, 0.5));

		if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
			layout:setScaleX(GameConfig.ScaleAbscissa)
			layout:setScaleY(GameConfig.ScaleOrdinate);
			positionX  = 26
		end
		if roleTotal <= 6 then
			SET_POS(layout, positionX, cellHeight*(6-i));
		else
			SET_POS(layout, positionX, cellHeight*roleTotal - i*cellHeight);
		end

		--背景
		local bgurl
		if i%2 == 0 then
			bgurl = "bg_paihangbang_di2.png"
		else
			bgurl = "bg_paihangbang_di1.png"
		end
		local imgbg  = ccs.image({
			scale9 = false,
			image = Common.getResourcePath(bgurl),
		})
		if numLayer ==2 or numLayer == 4 then
			imgbg:setScaleX(cellWidth_chongzhi / imgbg:getContentSize().width)
		else
			imgbg:setScaleX(cellWidth / imgbg:getContentSize().width)
		end
		imgbg:setScaleY(cellHeight / imgbg:getContentSize().height)
		SET_POS(imgbg, 0, 0);
		layout:addChild(imgbg)

		--名次
		local labelNum
		if i <= 3 then
			labelNum = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("ic_paihangbang_num" .. i .. ".png"),
			})
		else
			labelNum = ccs.label({
				text = "NO." .. tuHaoTable[i].rankNum
			})
			labelNum:setFontSize(22)
		end

		--头像
		local userImage
		if(string.len(tuHaoTable[i].photoUrl)>0 and i <= 3)then
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
					SET_POS(userImage, cellWidth/2 - 320, cellHeight/2);
					layout:addChild(userImage)
				end
			end
			Common.getPicFile(tuHaoTable[i].photoUrl, 1, true, getUserImage)
		elseif(i <= 3)then
			userImage = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("hall_portrait_default.png"),
			})
			userImage:setScaleX(59/userImage:getContentSize().width)
			userImage:setScaleY(59/userImage:getContentSize().height)
			SET_POS(userImage, cellWidth/2 - 320, cellHeight/2);
			layout:addChild(userImage)
		end
--------------------------------
		--VIP
		if tuHaoTable[i].vipLevel > 0 then
			local imageVIP = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("hall_vip_icon.png"),
			})
			SET_POS(imageVIP, cellWidth/2 - 210, cellHeight/2);
			layout:addChild(imageVIP)

			local vipNum = VIPPub.getUserVipType(tuHaoTable[i].vipLevel)
			local labelVIP = ccs.labelAtlas({
				text = vipNum,
				start = "0",
				image = Common.getResourcePath("num_vip_level.png"),
				w = 12,
				h = 19,
			})
			SET_POS(labelVIP, cellWidth/2 - 186, cellHeight/2);
			layout:addChild(labelVIP)
		end

		--名字
		local labelName = ccs.label({
			text = tuHaoTable[i].nickName,
		})
		labelName:setFontSize(22)

		--金币底板
		local imageDiBan = ccs.image({
			scale9 = true,
			image = Common.getResourcePath("bg_paihangbang_paiming.png"),
			size = CCSizeMake(207, 36),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
--		imageDiBan:setScaleX(250 / imageDiBan:getContentSize().width)
--		imageDiBan:setScaleY(60 / imageDiBan:getContentSize().height)
		imageDiBan:setScale9Enabled(true);

		--金币图片
		local imageCoin = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("ic_hall_recharge_jinbi.png"),
		})

		--金币label
		local labelCoin = ccs.label({
			text = tuHaoTable[i].rankingData,
		})
		labelCoin:setColor(ccc3(255,241,89))
		labelCoin:setFontSize(22)

		imgbg:setAnchorPoint(ccp(0,0))
		labelName:setAnchorPoint(ccp(0.5,0.5))
		imageDiBan:setAnchorPoint(ccp(0,0.5))
		labelCoin:setAnchorPoint(ccp(0,0.5))

		if numLayer ==2 or numLayer == 4 then
			--  2：今日充值排行   4：昨日充值排行
			SET_POS(labelNum, 90, cellHeight/2);
			imageCoin:loadTexture(Common.getResourcePath("ic_hall_recharge_rmb.png"))
			SET_POS(labelName, cellWidth/2, cellHeight/2); --0
			SET_POS(imageDiBan, cellWidth/2 + 100, cellHeight/2);  --230
			SET_POS(imageCoin, cellWidth/2 + 150, cellHeight/2); --50
			SET_POS(labelCoin, cellWidth/2 + 210, cellHeight/2); --60
		else
			-- 1: 每日赚金榜    3:土豪榜
			SET_POS(labelNum, 90, cellHeight/2);
			SET_POS(labelName, cellWidth/2+30, cellHeight/2);
			SET_POS(imageDiBan, cellWidth/2 + 260, cellHeight/2);
			SET_POS(imageCoin, cellWidth/2 + 280, cellHeight/2);
			SET_POS(labelCoin, cellWidth/2 + 330, cellHeight/2);
		end

		layout:addChild(labelNum)
		layout:addChild(labelName)
		layout:addChild(imageDiBan)
		layout:addChild(imageCoin)
		layout:addChild(labelCoin)


		PaiHangBangLogic.ScrollView_PaiHangBang:addChild(layout)
	end

	--个人排名
	if numLayer ==2 or numLayer == 4 then
		PaiHangBangLogic.Image_geren_chongzhi:setVisible(true)
		PaiHangBangLogic.Image_geren:setVisible(false)
--		PaiHangBangLogic.label_geren_chongzhi:setColor(ccc3(167,255,255))
		if PaiHangBangData.selfRankingNum > 0 then
			PaiHangBangLogic.label_geren_chongzhi:setText("我的排名：" .. tostring(PaiHangBangData.selfRankingNum))
		else
			PaiHangBangLogic.label_geren_chongzhi:setText("我的排名：1000+")
		end
	else
		PaiHangBangLogic.Image_geren:setVisible(true)
		PaiHangBangLogic.Image_geren_chongzhi:setVisible(false)
--		PaiHangBangLogic.label_geren:setColor(ccc3(167,255,255))
		if PaiHangBangData.selfRankingNum > 0 then
			PaiHangBangLogic.label_geren:setText("我的排名：" .. tostring(PaiHangBangData.selfRankingNum))
		else
			PaiHangBangLogic.label_geren:setText("我的排名：1000+")
		end
	end

	PaiHangBangLogic.view:stopAllActions()
	Common.closeProgressDialog()
end
