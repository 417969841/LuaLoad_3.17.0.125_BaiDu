--------------此页面在3.16作废
module("MatchRankingLogic",package.seeall)

view = nil
Panel_match_rank = nil
Button_close = nil
sv_ranking = nil
--Label_self_rank = nil
ImageView_23 = nil
Label_30 = nil

m_nReadAllUserCnt = 0;

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
	view = cocostudio.createView("MatchRanking.json")
	local gui = GUI_MATCH_RANKING
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

	Panel_match_rank = cocostudio.getUIPanel(view, "Panel_match_rank")
	ImageView_23 = cocostudio.getUIImageView(view, "ImageView_23")
	LordGamePub.showDialogAmin(ImageView_23, true)

	Button_close = cocostudio.getUIButton(view, "Button_close")
	sv_ranking = cocostudio.getUIScrollView(view, "sv_ranking")
	--Label_self_rank = cocostudio.getUILabel(view, "Label_self_rank")
	Label_30 = cocostudio.getUILabel(view, "Label_30")
	if TableConsole.msMatchTitle ~= nil then
		Label_30:setText(TableConsole.msMatchTitle)
	end
	m_nReadAllUserCnt = 0;
	--sendMATID_V28_ALL_USER_LIST()
  	--Common.log("m_sMatchInstanceID = "..TableConsole.m_sMatchInstanceID)
  	sendMATID_V4_RANK(GameConfig.GAME_ID, TableConsole.m_sMatchInstanceID)
  	--updataUserList_V4()
end

function requestMsg()

end

--[[--
--退出
--]]
local function exit_CallBack()
	mvcEngine.destroyModule(GUI_MATCH_RANKING)
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
		--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(ImageView_23, exit_CallBack)
	elseif component == CANCEL_UP then
		--取消
	end
end

--[[--
--3.03用户列表
--]]
function updataUserList_V4()
 	local AllUserList = profile.GameDoc.getMatchAllUserList()
	--Label_self_rank:setText("我的排名： "..AllUserList["Rank"])
	local cellSize = 0
  	Common.log("RankListCnt = "..#AllUserList["RankList"])
	cellSize = #AllUserList["RankList"]

	local leftAndRight = 80 --左右的间距
	local viewW = 825
	local viewHMax = 290
	local viewH = 0
	local viewX = -413
	local viewY = -144
	local cellWidth = viewW --每个元素的宽
	local cellHeight = 60 --每个元素的高
	local lieSize = 1 --列数
	local hangSize = math.floor((cellSize + (lieSize - 1)) / lieSize) --行数
	local spacingW = 0 --横向间隔
	local spacingH = 10 --纵向间隔

	if hangSize * cellHeight + spacingH * (hangSize - 1) > viewHMax then
		viewH = viewHMax;
		viewY = -144;
	else
		viewH = hangSize * cellHeight + spacingH * (hangSize - 1);
		viewY = viewHMax - viewH - 144;
	end

	local OffsetY = cellHeight * hangSize + spacingH * (hangSize - 1) --纵向位移，用于对齐scrollView顶部

	--sv_ranking:setSize(CCSizeMake(viewW, viewH))
	sv_ranking:setInnerContainerSize(CCSizeMake(viewW, cellHeight * hangSize + spacingH * (hangSize - 1)))
	--sv_ranking:setPosition(ccp(viewX, viewY))
	--sv_ranking:setPosition(ccp(sv_ranking:getPosition().x, viewY))
	for i = 1, cellSize do --下标从0开始，代表第一行显示自己的排名数据
    	local NickName = AllUserList["RankList"][i].NickName
    	local Chip = AllUserList["RankList"][i].score
    	local rank = AllUserList["RankList"][i].rank
    	local lblTextColor = ccc3(249, 235, 219)

    	if i == 1 then
			-- 第一行显示自己的数据,字体颜色也和其他的不一样
      		lblTextColor = ccc3(251, 241, 120)
    	end

		--排名
		local labelRank =  ccs.label({
			text = "No." .. rank,
			color = lblTextColor,
		})
		labelRank:setFontSize(28)
		--昵称
		local labelName = ccs.label({
			text = NickName,
			color = lblTextColor,
		})
		labelName:setFontSize(25)
		--积分
		local labelChip = ccs.label({
			text = Chip,
			color = lblTextColor,
		})
		labelChip:setFontSize(25)


		local layout = nil;
		if i % 2 == 1 then
			layout =ccs.panel({
				scale9 = true,
				image = Common.getResourcePath("bg_paihangbang_di1.png"),
				size = CCSizeMake(cellWidth, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
			})
		else
			layout =ccs.panel({
			scale9 = true,
			image = Common.getResourcePath("bg_paihangbang_di2.png"),
				size = CCSizeMake(cellWidth, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
			})
		end

		layout:setAnchorPoint(ccp(0.5, 0.5))
		--设置排名
		SET_POS(labelRank, 70 , 30)
		--SET_POS(ui_line, 120 , 30)
		--设置名称位置
		SET_POS(labelName, 300 , 30)
		--设置积分
		SET_POS(labelChip, 500 , 30)
		if cellSize > 3 then
			SET_POS(layout, viewW / 2, OffsetY - cellHeight * (math.floor((i-1) / lieSize) + 1) - spacingH * math.floor((i - 1) / lieSize) + cellHeight / 2)
		else
			SET_POS(layout, viewW / 2, OffsetY - cellHeight * (math.floor((i-1) / lieSize)) - spacingH * math.floor((i - 1) / lieSize) + cellHeight / 2)
		end

		layout:addChild(labelRank)
		--layout:addChild(ui_line)
		layout:addChild(labelName)
		layout:addChild(labelChip)
		sv_ranking:addChild(layout)
	end
	--PhotoUrl1st	Text	第一名PhotoUrl	分批次发送时，只在第一个包中发送
	--AllUserList["PhotoUrl1st"]
	--PhotoUrl2nd	Text	第二名PhotoUrl	分批次发送时，只在第一个包中发送
	--AllUserList["PhotoUrl2nd"]
	--PhotoUrl3th	Text	第三名PhotoUrl	分批次发送时，只在第一个包中发送
	--AllUserList["PhotoUrl3th"]
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	--framework.addSlot2Signal(MATID_V28_ALL_USER_LIST, updataUserList)
--  framework.addSlot2Signal(MATID_V4_RANK, updataUserList_V4)
end

function removeSlot()
	--framework.removeSlotFromSignal(MATID_V28_ALL_USER_LIST, updataUserList)
--  framework.removeSlotFromSignal(MATID_V4_RANK, updataUserList_V4)
end
