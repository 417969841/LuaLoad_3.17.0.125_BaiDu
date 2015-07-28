module("MatchDetailLogic",package.seeall)

view = nil
--控件
btn_bm = nil --报名按钮
btn_close = nil
panel = nil
Panel_webview = nil
lab_title = nil--标题
img_bm = nil


Panel_baoMingDetails = nil;--
btn_detail_bm = nil;--
btn_jiangli_bm = nil;--
Panel_MatchDetails = nil;--
btn_detail = nil;--
btn_paiming = nil;--
btn_jiangli = nil;--
sv_ranking = nil;--
Image_xiangqing = nil
Image_jiangli = nil
Image_xiangqing_p = nil
Image_paiming_p = nil
Image_jiangli_p = nil

nowEntrance = nil;--
BM_ENTRANCE = 1; --报名入口
TABLE_ENTRANCE = 2; --比赛牌桌入口

local nowChoose = 1 --当前选择的按钮
local isFormCertificate = false --来自奖状
local isCanNotSignUP = false --是否不可报名

local matchTypeClick = 0
local StartTime = ""
local Condition = ""
local MenPiaoId = 0;
local MatchItemData = {} --比赛
local MatchID = -1
local Title = ""

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
	view = cocostudio.createView("MatchDetail.json")
	local gui = GUI_MATCHDETAIL
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
	Panel_webview = cocostudio.getUIPanel(view, "Panel_webview")
	btn_bm = cocostudio.getUIImageView(view, "btn_bm")
	btn_close = cocostudio.getUIButton(view, "btn_close")
	img_bm = cocostudio.getUIImageView(view, "img_bm")

	Panel_baoMingDetails = cocostudio.getUIPanel(view, "Panel_baoMingDetails");
	btn_detail_bm = cocostudio.getUIImageView(view, "btn_detail_bm");
	btn_jiangli_bm = cocostudio.getUIImageView(view, "btn_jiangli_bm");
	Panel_MatchDetails = cocostudio.getUIPanel(view, "Panel_MatchDetails");
	btn_detail = cocostudio.getUIImageView(view, "btn_detail");
	btn_paiming = cocostudio.getUIImageView(view, "btn_paiming");
	btn_jiangli = cocostudio.getUIImageView(view, "btn_jiangli");
	lab_title = cocostudio.getUILabel(view, "lab_title");
	sv_ranking = cocostudio.getUIScrollView(view, "sv_ranking");
	Image_xiangqing = cocostudio.getUIImageView(view, "Image_16")
	Image_jiangli = cocostudio.getUIImageView(view, "Image_16_0_1")

	Image_xiangqing_p = cocostudio.getUIImageView(view, "Image_161")
	Image_paiming_p = cocostudio.getUIImageView(view, "Image_16_0")
	Image_jiangli_p = cocostudio.getUIImageView(view, "Image_161_0_1")


	ChooseBtnState()
	initView(1)
	local function callBack()
		local versioncode = Common.getVersionCode() + Common.getChannelID()--版本号
		local VipLevel = profile.User.getSelfVipLevel()--vip级别
		local vipjb = VIPPub.getUserVipType(VipLevel)--vip
		Common.log("zblaaaVipLevel = " .. VipLevel .."            vipjb= " ..vipjb)
		--测试用
		--		local url = "http://10.10.0.99:8090/TqRechargeAdminMvn/matchV4DetailManager!query.do?id="..MatchID.."&gameID=1&version="..versioncode.."&vipLevel="..vipjb
		--新比赛
		local url = "http://matchdetail.tongqutongqu.cn/tqAdmin/matchV4DetailManager!query.do?id="..MatchID.."&gameID=1&version="..versioncode.."&vipLevel="..vipjb
		--旧比赛
		--		local url = "http://58.68.246.34/tqAdmin/matchDetailManagerNew!query.do?id="..MatchID.."&gameID=1&version="..versioncode.."&vipLevel="..vipjb;
		Common.log("url = "..url)
		local x = Panel_webview:getPosition().x;
		local y = Panel_webview:getPosition().y;
		local w = Panel_webview:getSize().width;
		local h = Panel_webview:getSize().height;
		--		Common.showWebView(url, "", x, y, w, h);
		local selfVip = VIPPub.getUserVipType(profile.User.getSelfVipLevel())
		local key = string.format("MATCH%d_%d", MatchID, selfVip)
		Common.log("callBack========"..key)
		--		CommDialogConfig.commonLoadWebView(url, key, x, y, w, h)
	end

	LordGamePub.showDialogAmin(panel, false, callBack)

	if isFormCertificate then
		--如果是从奖状界面过来
		btn_bm:loadTexture(Common.getResourcePath("btn_gerenziliao0.png"))
		img_bm:loadTexture(Common.getResourcePath("ui_match_2level_btn_baoming.png"))
		return
	end
	if MatchItemData ~= nil then
		setMatchID(MatchItemData.MatchID)
		if MatchItemData.RegStatus == 1 then
			Common.log("RegStatus==1")
			btn_bm:loadTexture(Common.getResourcePath("btn_green.png"))
			img_bm:loadTexture(Common.getResourcePath("ui_match_2level_btn_tuisai.png"))
		else
			Common.log("RegStatus==2")
			btn_bm:loadTexture(Common.getResourcePath("btn_gerenziliao0.png"))
			img_bm:loadTexture(Common.getResourcePath("ui_match_2level_btn_baoming.png"))
		end
	else
		btn_bm:setVisible(false)
		btn_bm:setTouchEnabled(false)
		img_bm:setVisible(false)
	end

	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		btn_bm:setVisible(false)
		btn_bm:setTouchEnabled(false)
	end
end

--[[
比赛详情页面设置
matchItem:比赛实例
typeIndex:
]]
function setDetailWithMatchItem_V4(matchItem)
	--isReg = matchItem.RegStatus
	--MatchID = matchItem.MatchID
	--OptionsCode = 110
	--MenPiaoId = 11
	MatchItemData = matchItem
end

--[[--
--设置比赛ID
--]]
function setMatchID(matchid)
	MatchID = matchid
end

function requestMsg()

end

function callback_btn_bm(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		MatchBM()
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--关闭界面
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end

--关闭页面
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end

function closePanel()
	mvcEngine.destroyModule(GUI_MATCHDETAIL)
end


--[[--
--初始化界面
--]]--
function  initView(index)
	if  nowEntrance == 1 then
		--牌桌外进入
		if isFormCertificate then
		--从奖状进来
			lab_title:setText(Title)
			Common.log("iiiiiiiiiiiiiiiii传递4  .. matchId = " .. MatchID  .. "    title = " .. Title)
		else
			lab_title:setText(MatchItemData.MatchTitle)
		end
--		sendMATID_V4_MATCHDETAIL(0,profile.User.getSelfVipLevel(),MatchID)
--		sendMATID_V4_AWARDS(0,MatchID) 
	elseif  nowEntrance == 2 then
		--牌桌进入
		lab_title:setText(TableConsole.msMatchTitle)
		--sendMATID_V4_MATCHDETAIL(profile.GameDoc.getmatchDetailsTimeStamp(),profile.User.getSelfVipLevel(),TableConsole.m_nMatchID)
		sendMATID_V4_AWARDS(profile.GameDoc.loadmatchAwardsDetailsTable(TableConsole.m_nMatchID),TableConsole.m_nMatchID)
		sendMATID_V4_RANK(GameConfig.GAME_ID, TableConsole.m_sMatchInstanceID)
	end

	--比赛ID记录  TableConsole.m_nMatchID
	local matchTable = profile.GameDoc.getMATID_V4_MATCHDETAIL()
	local matchAwardsTable = profile.GameDoc.getreadMATID_V4_AWARDS()

	if matchTable["regButtonType"] == 0 then
	--不可报名
		isCanNotSignUP = true
	end

	local x = Panel_webview:getPosition().x;
	local y = Panel_webview:getPosition().y;
	local w = Panel_webview:getSize().width;
	local h = Panel_webview:getSize().height;
	local key = string.format("MATCH%d_%d", MatchID, profile.User.getSelfVipLevel())
	Common.hideWebView()
	if index == 1 then
		--比赛详情
		nowChoose = 1
		if nowEntrance == 1 then
			--1 : 牌桌外报名
			btn_detail_bm:loadTexture(Common.getResourcePath("btn_match_left_select.png"))
			btn_jiangli_bm:loadTexture(Common.getResourcePath("btn_match_left_nor.png"))
			Image_xiangqing:loadTexture(Common.getResourcePath("txt_match_info_select.png"))
			Image_jiangli:loadTexture(Common.getResourcePath("txt_match_rewards_nor.png"))
			Common.log("mmmmmmmmmm.调用详情")
		elseif nowEntrance == 2 then
			--2 : 牌桌内排名
			btn_detail:loadTexture(Common.getResourcePath("btn_match_left_select.png"))
			btn_paiming:loadTexture(Common.getResourcePath("btn_match_middle_nor.png"))
			btn_jiangli:loadTexture(Common.getResourcePath("btn_match_left_nor.png"))
			Image_xiangqing_p:loadTexture(Common.getResourcePath("txt_match_info_select.png"))
			Image_paiming_p:loadTexture(Common.getResourcePath("txt_match_rank_nor.png"))
			Image_jiangli_p:loadTexture(Common.getResourcePath("txt_match_rewards_nor.png"))
			sv_ranking:setVisible(false)
			sv_ranking:setTouchEnabled(false)
		end
		--CommDialogConfig.commonLoadWebView(matchTable["MatchDetail"], key, x, y, w, h)
		Common.showWebView("", matchTable["MatchDetail"], x, y, w, h)
	elseif index == 2 then
		nowChoose = 2
		btn_detail:loadTexture(Common.getResourcePath("btn_match_left_nor.png"))
		btn_paiming:loadTexture(Common.getResourcePath("btn_match_middle_select.png"))
		btn_jiangli:loadTexture(Common.getResourcePath("btn_match_left_nor.png"))
		Image_xiangqing_p:loadTexture(Common.getResourcePath("txt_match_info_nor.png"))
		Image_paiming_p:loadTexture(Common.getResourcePath("txt_match_rank_select.png"))
		Image_jiangli_p:loadTexture(Common.getResourcePath("txt_match_rewards_nor.png"))
		sv_ranking:setVisible(true)
		sv_ranking:setTouchEnabled(true)
	elseif index == 3 then
		--比赛奖励
		nowChoose = 3
		if nowEntrance == 1 then
			--1 : 牌桌外报名
			btn_detail_bm:loadTexture(Common.getResourcePath("btn_match_left_nor.png"))
			btn_jiangli_bm:loadTexture(Common.getResourcePath("btn_match_left_select.png"))
			Image_xiangqing:loadTexture(Common.getResourcePath("txt_match_info_nor.png"))
			Image_jiangli:loadTexture(Common.getResourcePath("txt_match_rewards_select.png"))
			Common.log("mmmmmmmmmm.调用奖励")
		elseif nowEntrance == 2 then
			--2 : 牌桌内排名
			btn_detail:loadTexture(Common.getResourcePath("btn_match_left_nor.png"))
			btn_paiming:loadTexture(Common.getResourcePath("btn_match_middle_nor.png"))
			btn_jiangli:loadTexture(Common.getResourcePath("btn_match_left_select.png"))
			Image_xiangqing_p:loadTexture(Common.getResourcePath("txt_match_info_nor.png"))
			Image_paiming_p:loadTexture(Common.getResourcePath("txt_match_rank_nor.png"))
			Image_jiangli_p:loadTexture(Common.getResourcePath("txt_match_rewards_select.png"))
			sv_ranking:setVisible(false)
			sv_ranking:setTouchEnabled(false)
		end
		--CommDialogConfig.commonLoadWebView(matchAwardsTable["MatchAwards"], key, x, y, w, h)
		Common.showWebView("", matchAwardsTable["MatchAwards"], x, y, w, h)
	end

end

function callback_btn_detail_bm(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if nowChoose ~= 1 then
			initView(1)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_jiangli_bm(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if nowChoose ~= 3 then
			initView(3)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_detail(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if nowChoose ~= 1 then
			initView(1)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_paiming(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if nowChoose ~= 2 then
			initView(2)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_jiangli(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if nowChoose ~= 3 then
			initView(3)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function ChooseBtnState()
	Common.log("zblzzz ..nowEntrance = " .. nowEntrance .. "    BM_ENTRANCE = " .. BM_ENTRANCE  .. "     TABLE_ENTRANCE = " .. TABLE_ENTRANCE)
	if nowEntrance == 1 then
		--1 : 牌桌外报名
		Panel_baoMingDetails:setVisible(true)
		Panel_MatchDetails:setVisible(false)

		btn_detail_bm:setTouchEnabled(true)
		btn_jiangli_bm:setTouchEnabled(true)
		btn_detail:setTouchEnabled(false)
		btn_paiming:setTouchEnabled(false)
		btn_jiangli:setTouchEnabled(false)
	elseif nowEntrance == 2 then
		--2 : 排座内排名
		Panel_baoMingDetails:setVisible(false)
		Panel_MatchDetails:setVisible(true)

		btn_detail_bm:setTouchEnabled(false)
		btn_jiangli_bm:setTouchEnabled(false)
		btn_detail:setTouchEnabled(true)
		btn_paiming:setTouchEnabled(true)
		btn_jiangli:setTouchEnabled(true)
	end
end


--[[--
--3.16新比赛报名
--]]--
function MatchBM()
	if MatchItemData.RegStatus == 1 then
		-- 已报名
		Common.showProgressDialog("正在取消报名，请稍后...")
		sendMATID_V4_REFUND(MatchID)
	else
		-- 未报名
		-- 判断用户金币数是否够交押金
		
		local uCoin = profile.User.getSelfCoin()
		local yajinCoin = MatchItemData.freezeCoin
		if tonumber(uCoin) < tonumber(yajinCoin) then
			close()
			Common.log("用户金币不够交押金")
			mvcEngine.createModule(GUI_PAYGUIDEPROMPT)
			PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, yajinCoin-uCoin, RechargeGuidePositionID.MatchListPositionJ)
			return
		end
		local matchID = profile.GameDoc.getMATID_V4_MATCHDETAIL().matchID
		sendMATID_V4_REG_MATCH(GameConfig.GAME_ID, matchID, 0, 0)
	end
	close()
end



--[[--
--比赛报名
--]]--
function MatchbaoMing()
--	if isFormCertificate then
--	--从奖状进来
--		profile.Match.didBaomingMatch(MatchID, (#MatchItemData.Condition)-1, 0)
--		Common.log("iiiiiiiiiiiiiiiiiiiiiiiiiiMatchID = " .. MatchID)
--		return
--	end
	if MatchItemData.RegStatus == 1 then
		-- 已报名
		-- 3.03退票
		Common.showProgressDialog("正在取消报名，请稍后...")

		sendMATID_V4_REFUND(MatchID)
		close()
	else
		-- 未报名
		-- 判断用户金币数是否够交押金
		local uCoin = profile.User.getSelfCoin()
		local yajinCoin = MatchItemData.freezeCoin
		if tonumber(uCoin) < tonumber(yajinCoin) then
			close()
			Common.log("用户金币不够交押金")
			mvcEngine.createModule(GUI_PAYGUIDEPROMPT)
			PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, yajinCoin-uCoin, RechargeGuidePositionID.MatchListPositionJ)
			return
		end

		--查看比赛的报名条件数量
		if #MatchItemData.Condition > 1 then
			--有多个报名条件
			TiaoJianBaoMingLogic.mathcondition = MatchItemData
			mvcEngine.createModule(GUI_TIAOJIANBAOMING)
		else
			--只有一个报名条件
			if profile.Match.canApplyMatch(MatchItemData) then
				--符合报名条件
				if profile.Match.getValueWithExpression2(MatchItemData.Condition[1][1], ">=", 1) == profile.Match.MatchApplyConditionKeyTable["ticket"] then
					--如果是使用门票报名，弹出报名确认框
					local function startBaoming()
						-- body
						profile.Match.didBaomingMatch(MatchItemData, (#MatchItemData.Condition)-1, 0)
					end
					TimeNotFitLogic.noticeMsg = "【退赛时无法退还门票，确定报名吗？】"
					TimeNotFitLogic.func = startBaoming
					mvcEngine.createModule(GUI_TIMENOTFIT)
					return
				end
				profile.Match.didBaomingMatch(MatchItemData, (#MatchItemData.Condition)-1, 0) --服务器报名类型下标从0开始，这里减1
				close()
			else
				--不符合报名条件
				TiaoJianBaoMingLogic.mathcondition = MatchItemData
				TiaoJianBaoMingLogic.showBaomingtiaojianTanchuang(MatchItemData.Condition[1])
			end
		end

		--[[判断能否报名
		if profile.Match.canApplyMatch(MatchItemData) then
		-- 能报名
		Common.log("prepare apply")
		local accordBaomingCnt = profile.Match.prepareBaomingMatch(MatchItemData)
		if accordBaomingCnt == 0 then
		-- 不符合报名条件
		elseif accordBaomingCnt == 1 then
		Common.log("MatchItemData.Condition[1][1] = "..MatchItemData.Condition[1][1])
		if profile.Match.getValueWithExpression2(MatchItemData.Condition[1][1], ">=", 1) == profile.Match.MatchApplyConditionKeyTable["ticket"] then
		--如果是使用门票报名，弹出报名确认框
		local function startBaoming()
		-- body
		profile.Match.didBaomingMatch(MatchItemData, (#MatchItemData.Condition)-1, 0)
		end
		TimeNotFitLogic.noticeMsg = "【退赛时无法退还门票，确定报名吗？】"
		TimeNotFitLogic.func = startBaoming
		mvcEngine.createModule(GUI_TIMENOTFIT)
		return
		end
		profile.Match.didBaomingMatch(MatchItemData, (#MatchItemData.Condition)-1, 0) -- 服务器报名类型下标从0开始，这里减1
		close()
		elseif accordBaomingCnt > 1 then
		TiaoJianBaoMingLogic.mathcondition = MatchItemData
		mvcEngine.createModule(GUI_TIAOJIANBAOMING)
		end
		else
		-- 不能报名
		Common.log("can't apply")
		TiaoJianBaoMingLogic.mathcondition = MatchItemData
		if #MatchItemData.Condition > 1 then
		mvcEngine.createModule(GUI_TIAOJIANBAOMING)
		else
		TiaoJianBaoMingLogic.showBaomingtiaojianTanchuang(MatchItemData.Condition[1])
		end
		end
		]]
	end
end

--[[--
--设置入口
--]]--
function setNowEntrance(entrance)
	Common.log("zblzzzzzz  entrance == " .. entrance)
	nowEntrance = entrance
end

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

	sv_ranking:setInnerContainerSize(CCSizeMake(viewW, cellHeight * hangSize + spacingH * (hangSize - 1)))
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
		SET_POS(labelName, 375 , 30)
		--设置积分
		SET_POS(labelChip, 640 , 30)
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
end

--[[--
--设置是从奖状过来
--]]--
function setFormCertificate(id,title)
	isFormCertificate = true
	MatchID = id
	Title = title
end

--[[--
--更新界面
--]]--
function  updateLayer()
	initView(1)
end


--[[--
--释放界面的私有数据
--]]
function releaseData()
--	MatchItemData = nil  --不能释放
	isFormCertificate  = false
	isCanNotSignUP = false
end

function addSlot()
	framework.addSlot2Signal(MATID_V4_MATCHDETAIL, updateLayer)
	framework.addSlot2Signal(MATID_V4_RANK, updataUserList_V4)
end

function removeSlot()
	Common.hideWebView()
	framework.removeSlotFromSignal(MATID_V4_MATCHDETAIL, updateLayer)
	framework.removeSlotFromSignal(MATID_V4_RANK, updataUserList_V4)
end
