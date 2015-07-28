module("ExchangeDetailLogic",package.seeall)

view = nil
local flag = 0   --1兑换奖品  2碎片兑换 3我的奖品4兑换比赛赢得实物奖
--控件
Panel_20 = nil--
lab_name = nil--名称
img_url = nil--url地址
img_lb = nil
lab_jq = nil--消耗
scroll_text = nil--
lab_neirong = nil
img_ok = nil
btn_close = nil--关闭按钮
btn_ok = nil --购买按阿牛
panel  = nil --底层panel
lab_detail = nil;--
Panel_74 = nil;--
ImageView_bg = nil;--
--变量
local value_goodid = nil --物品ID
local value_name = nil --物品名称
local value_url = nil --物品图片URL
local value_prize = nil --物品价格
local value_content = nil
local value_status = nil
local value_date = nil
local value_isComposeAndExchange = nil --是否是合成并兑奖
local value_msg = nil
local value_exchangable_status = nil
local value_need_yuanbao = nil --充值引导需要的元宝数
local self_duijiangsuipian = nil

local self_duijiangquan = nil

local STATUS_NOT_EXCHANGABLE = 0 --不可兑奖
local STATUS_EXCHANGABLE = 1 --可兑奖
local STATUS_COMPASS_AND_EXCHANGABLE = 2 --可合成兑奖
local STATUS_NEED_PAY_GUIDE = 3 --需要充值引导才可合成兑奖

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

function updataImage(dataInApp)
	local photoPath = nil
	if Common.platform == Common.TargetIos then
		photoPath = dataInApp["useravatorInApp"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(dataInApp, "#")
		local id = string.sub(dataInApp, 1, i-1)
		photoPath = string.sub(dataInApp, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and img_url ~= nil then
		img_url:loadTexture(photoPath)
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("ExchangeDetail.json")
	local gui = GUI_EXCHANGEDETAIL
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
	--界面
	lab_name = cocostudio.getUILabel(view,"lab_name")
	lab_jq = cocostudio.getUILabel(view,"lab_jq")
	img_url = cocostudio.getUIImageView(view, "img_url")
	img_lb = cocostudio.getUIImageView(view, "img_lb")
	scroll_text = cocostudio.getUIScrollView(view, "scroll_text")
	lab_neirong = cocostudio.getUILabel(view,"lab_neirong")
	img_ok = cocostudio.getUIImageView(view, "img_ok")
	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_ok = cocostudio.getUIImageView(view, "btn_ok")
	Panel_74 = cocostudio.getUIPanel(view, "Panel_74");
	lab_detail = cocostudio.getUILabel(view, "lab_detail");
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	ImageView_bg = cocostudio.getUIImageView(view, "ImageView_bg");
	self_duijiangquan = profile.User.getDuiJiangQuan()
	self_duijiangsuipian = profile.User.getSelfdjqPieces()

	--设置数据
	lab_name:setText(value_name)
	local s = string.gsub(value_content, "<br>", "")
	lab_neirong:setText(s)
	CommShareConfig.showImageChild = value_url
	Common.getPicFile(value_url, 0, true, updataImage)

	if flag == 3 then
		lab_jq:setVisible(false)
		img_lb:setVisible(false)
		img_ok:loadTexture(Common.getResourcePath("ui_item_btn_ensure.png"))
	elseif flag == 2 then
		lab_jq:setText(value_prize)
		img_lb:loadTexture(Common.getResourcePath("ic_caishen_suipian.png"))
	elseif flag == 1 then
		--img_ok:loadTexture(Common.getResourcePath("ui_item_btn_ensure.png"))
		lab_jq:setText(value_prize)
	elseif flag == 4 then
		lab_jq:setVisible(false)
		img_lb:setVisible(false)
	end

	if value_exchangable_status == nil or value_msg == nil then
		ImageView_bg:setVisible(false)
		return
	end

	if value_exchangable_status == STATUS_NOT_EXCHANGABLE then
		lab_detail:setText(value_msg)
		img_ok:loadTexture(Common.getResourcePath("ui_item_btn_qianwang.png"))
	elseif value_exchangable_status == STATUS_EXCHANGABLE then
		lab_detail:setText(value_msg)
		img_ok:loadTexture(Common.getResourcePath("ui_convertible_btn_exchange.png"))
	elseif value_exchangable_status == STATUS_COMPASS_AND_EXCHANGABLE then
		lab_detail:setText(value_msg)
		img_ok:loadTexture(Common.getResourcePath("hechengduihuan.png"))
	elseif value_exchangable_status == STATUS_NEED_PAY_GUIDE then
		lab_detail:setText(value_msg)
		img_ok:loadTexture(Common.getResourcePath("ui_convertible_btn_exchange.png"))
	else
		lab_detail:setText("")
		img_ok:loadTexture(Common.getResourcePath("ui_item_btn_ensure.png"))
		ImageView_bg:setVisible(false)
	end
end

function requestMsg()
	--如果是新手引导，则执行新手引导
	NewUserCreateLogic.JumpInterface(ExchangeDetailLogic.view,NewUserCoverOtherLogic.getTaskState());
end
--124
function setValue(flagvalue,GoodID,ShortName,Name,Prize,Picture,Description,isComposeAndExchange,status,msg,needYuanBao)
	flag = flagvalue
	value_goodid = GoodID
	value_name = ShortName
	value_url = Picture
	value_prize = Prize
	value_content = Description
	value_isComposeAndExchange = isComposeAndExchange
	value_msg = msg
	value_exchangable_status = status
	value_need_yuanbao = needYuanBao
end
-- 3我的奖品
function setValue2(flagvalue,AwardID,Name,Status,Date,PictureUrl,Description)
	flag = flagvalue
	value_goodid = AwardID
	value_name = Name
	value_url = PictureUrl
	value_status = Status
	value_date = Date
	value_content = Description
end

function callback_btn_ok(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if flag == 1 then
			if value_exchangable_status == STATUS_NOT_EXCHANGABLE then
				Common.showProgressDialog("进入房间中,请稍后...")
				sendQuickEnterRoom(-1)
			elseif value_exchangable_status == STATUS_EXCHANGABLE then
				if value_goodid > 10000 then
					value_goodid = value_goodid - 10000
					sendOPERID_EXCHANGE_LIMITED_AWARD(value_goodid)
					close()
				else
					GetAwardInfoLogic.setGoodID(value_goodid,flag)
					mvcEngine.createModule(GUI_GETAWARDINFO)
				end
			elseif value_exchangable_status == STATUS_COMPASS_AND_EXCHANGABLE then
				Common.log("ababababab1 " .. value_msg)
				if value_goodid > 10000 then
					value_goodid = value_goodid - 10000
					sendOPERID_EXCHANGE_LIMITED_AWARD(value_goodid)
					close();
					--新手引导
					if CommDialogConfig.getNewUserGiudeFinish() == false then
						--屏蔽兑换按钮
						mvcEngine.createModule(GUI_NEWUSERCOVEROTHER);
						NewUserCoverOtherLogic.shieldExchangeButton();
						--预先弹imageToast
						NewUserCoverOtherLogic.showNewUserPrizeToast();
					end
				else
					GetAwardInfoLogic.setGoodID(value_goodid,1)
					mvcEngine.createModule(GUI_GETAWARDINFO)
				end
			elseif value_exchangable_status == STATUS_NEED_PAY_GUIDE then
				if value_need_yuanbao ~= nil then
					mvcEngine.destroyModule(GUI_EXCHANGEDETAIL)
					CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, value_need_yuanbao, RechargeGuidePositionID.ExchangeGuideA)
				end
			end

		elseif flag == 2 then
			--德州的门票提示   游戏开发中，敬请期待！
			local c = "德州扑克"
			local param1, param2 = string.find(value_content, c)
			if param1 and param2 then
				Common.showToast("游戏开发中，敬请期待！", 2)
			else
				if value_exchangable_status == STATUS_EXCHANGABLE then
					sendMANAGERID_PIECES_EXCHANGE(value_goodid)
				elseif value_exchangable_status == STATUS_NOT_EXCHANGABLE then
					Common.showProgressDialog("进入房间中,请稍后...")
					sendQuickEnterRoom(-1)
				end
				--				if self_duijiangsuipian >= value_prize then
				--					sendMANAGERID_PIECES_EXCHANGE(value_goodid)
				--				else
				--					--1:兑奖券不足  2：兑奖券碎片不足
				--					SuipianNotEnoughLogic.setType(2,value_url)
				--					mvcEngine.createModule(GUI_SUIPIANNOTENOUGH)
				--				end
			end
		elseif flag == 3 then
			mvcEngine.destroyModule(GUI_EXCHANGEDETAIL)
		elseif flag ==4 then
			GetAwardInfoLogic.setGoodID(value_goodid,flag)
			mvcEngine.createModule(GUI_GETAWARDINFO)
		end
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
	--LordGamePub.closeDialogAmin(panel,closePanel)
	mvcEngine.destroyModule(GUI_EXCHANGEDETAIL)
end

function closePanel()
	mvcEngine.destroyModule(GUI_EXCHANGEDETAIL)
end

function slot_couvert()
	local GoodID = profile.SuipianPrize.getPriceGoodID()
	local result = profile.SuipianPrize.getResult()
	local ResultText = profile.SuipianPrize.getResultText()
	Common.log("GoodID == "..GoodID);
	if result == 1 then
		if tonumber(GoodID) == 6 then
			profile.SuipianPrize.setPrizeSuipianListTimestamp(0);
			sendMANAGERID_GET_PIECES_SHOP_LIST(0);
		end
		close();
	end
	Common.showToast(ResultText, 2);
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	value_exchangable_status = nil
end

function addSlot()
	framework.addSlot2Signal(MANAGERID_PIECES_EXCHANGE, slot_couvert)
end

function removeSlot()
	framework.removeSlotFromSignal(MANAGERID_PIECES_EXCHANGE, slot_couvert)
end
