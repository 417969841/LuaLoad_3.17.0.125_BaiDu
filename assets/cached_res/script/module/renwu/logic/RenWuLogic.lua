module("RenWuLogic", package.seeall)

view = nil
DAILYTASKID_CURRENT_TASKInfo = nil
--iconPosition = nil
--GameConfig.ScreenWidth
--GameConfig.ScreenHeight
CurrentButton = 1
panel = nil

Panel_MeiRi = nil;
Button_LingQu = nil;
Label_XinJi = nil;
Label_MiaoShu = nil;
Label_JinDu = nil;
Label_JiangLi = nil;
Label_YuanBaoXiaoHao = nil;
Label_JinBiXiaoHao = nil;
Button_ShuaXinCoin = nil;--
Button_JinBiShuaXin = nil;
Button_YuanBaoTiaoGuo = nil;
--shengyuLabel = nil;
BackButton = nil;
ImageView_DaJiang = nil;
ImageView_GuiZe = nil;
Label_NewUserTitle = nil;
ImageView_LingQu = nil;
ImageView_QianWang = nil;



Image_freeshuaxin = nil;--
ImageView_likewancheng = nil;--




DAILYTASKID_REFRESH_TASKInfo = {};
DAILYTASKID_COMPLETE_TASKInfo = {};
local dataTaskNumber = {};
dataTaskNumber.LAIZI = 10005;--了解癞子玩法，去【休闲房间-癞子场】中打3局牌
dataTaskNumber.TIANTI = 10006;--提升天梯等级
dataTaskNumber.YUANBAO_EXCHANGE_JINBI = 10013;--元宝兑换金币
dataTaskNumber.SUIPIAN_EXCHANGE = 10004;--碎片兑换
dataTaskNumber.MODIFY_USERINFO = 10010;--修改昵称和密码

local modifyUserInfo = false;--true：新手任务中显示用户修改用户名和密码界面
local jumpRenWuFlag = false;--true：新手引导完成并月签后，弹出新手任务

function onKeypad(event)
	if event == "backClicked" then
		local function actionOver()
			mvcEngine.destroyModule(GUI_RENWU)
		end
		LordGamePub.closeDialogAmin(panel, actionOver)
	elseif event == "menuClicked" then
	end
end

--[[--
--设置新手任务中是否弹出新手任务
--]]
function setJumpRenWu(flag)
	jumpRenWuFlag = flag;
end

function getJumpRenWu()
	return jumpRenWuFlag;
end

--[[--
--设置手引导完成并月签后，是否显示用户修改用户名和密码界面
--]]
function setModifyUserInfo(flag)
	modifyUserInfo = flag;
end

function getModifyUserInfo()
	return modifyUserInfo;
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("RenWu.json")
	local gui = GUI_RENWU
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
	panel = cocostudio.getUIPanel(view, "Panel_22")

	Common.showProgressDialog("数据加载中...")

	local function callBack()
		initView()
		ImageView_MeiRi();
		if CommDialogConfig.getNewUserTaskFinish() then
			--每日任务消息
			sendDAILYTASKID_CURRENT_TASK();
		else
			--新手任务基本信息
			sendCOMMONS_V3_NEWUSER_TASK_INFO();
		end
	end
	LordGamePub.showDialogAmin(panel, false, callBack)
	--LordGamePub.comeFromIconPosition(view,iconPosition,actionOver,false)
end



function initView()
	Panel_22 = cocostudio.getUIPanel(view, "Panel_22");--整个画布
	Panel_35 = cocostudio.getUIPanel(view, "Panel_35");--每日任务标题和返回按钮
	Panel_MeiRi = cocostudio.getUITextField(view, "Panel_MeiRi")--每日任务下面布局
	ImageView_DaJiang = cocostudio.getUIButton(view, "ImageView_DaJiang")
	ImageView_GuiZe = cocostudio.getUIButton(view, "ImageView_GuiZe")
	ImageView_yuanbao = cocostudio.getUIImageView(view, "ImageView_79");
	Label_RenWuMingCheng = cocostudio.getUILabel(view, "Label_RenWuMingCheng");--显示任务名称

	Label_XinJi = cocostudio.getUILabel(view, "Label_XinJi")--星级
	Label_MiaoShu = cocostudio.getUILabel(view, "Label_MiaoShu")
	Label_JinDu = cocostudio.getUILabel(view, "Label_JinDu")
	Label_JiangLi = cocostudio.getUILabel(view, "Label_JiangLi")
	Label_YuanBaoXiaoHao = cocostudio.getUILabel(view, "Label_YuanBaoXiaoHao")
	Label_JinBiXiaoHao = cocostudio.getUILabel(view, "Label_JinBiXiaoHao")
	Button_ShuaXinCoin = cocostudio.getUIButton(view, "Button_ShuaXinCoin");
	Button_JinBiShuaXin = cocostudio.getUIButton(view, "Button_JinBiShuaXin")
	Button_YuanBaoTiaoGuo = cocostudio.getUIButton(view, "Button_YuanBaoTiaoGuo")
	--返回按钮
	BackButton = cocostudio.getUIButton(view, "BackButton")

	Label_NewUserTitle = cocostudio.getUILabel(view, "Label_NewUserTitle");--新手任务标题
	Label_NewUserImage = cocostudio.getUILabel(view, "Label_NewUserImage");--新手任务奖励图片
	--	shengyuLabel = cocostudio.getUILabel(view,"Label_117")--剩余次数label
	Button_LingQu = cocostudio.getUIButton(view, "Button_LingQu")
	ImageView_LingQu = cocostudio.getUIImageView(view, "ImageView_LingQu");
	ImageView_QianWang = cocostudio.getUIImageView(view, "ImageView_QianWang");
	if CommDialogConfig.getNewUserTaskFinish()then
		--新手任务完成，显示每日任务
		DailyInterface();
	else
		--显示新手任务
		NewUserTaskInterface();
	end


	Image_freeshuaxin = cocostudio.getUIImageView(view, "Image_freeshuaxin");
	Panel_shuaxin = cocostudio.getUIPanel(view, "Panel_shuaxin");
	ImageView_likewancheng = cocostudio.getUIImageView(view, "ImageView_likewancheng");
end

--[[--
--显示每日任务布局
--]]
function DailyInterface()
	Button_LingQu:setTouchEnabled(false);
	ImageView_QianWang:setVisible(false);
	Label_XinJi:setVisible(true);
	Label_RenWuMingCheng:setVisible(true);
	Label_NewUserImage:setVisible(false);
--	Label_NewUserTitle:setVisible(false);
	Label_NewUserTitle:setText("每日任务")
	ImageView_LingQu:setVisible(true);
	Button_LingQu:loadTextureNormal(Common.getResourcePath("btn_gerenziliao0_no.png"));
	ImageView_LingQu:loadTexture(Common.getResourcePath("ui_room_2level_tianjiangdali_btn_no.png"))
end

--[[--
--显示新手任务布局
--]]
function NewUserTaskInterface()
--	ImageView_yuanbao:setVisible(false);
	--	shengyuLabel:setVisible(false);
	ImageView_LingQu:setVisible(false);
	Button_LingQu:setTouchEnabled(true);
--	LordGamePub.NewbreathEffect(Button_LingQu,1.0,1.35);
	Label_RenWuMingCheng:setVisible(false);
	Label_NewUserImage:setVisible(true);
end

function requestMsg()

end

function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local function actionOver()
			mvcEngine.destroyModule(GUI_RENWU)
		end
		LordGamePub.closeDialogAmin(panel, actionOver)
		--LordGamePub.comeFromIconPosition(view,iconPosition,actionOver,true)

	elseif component == CANCEL_UP then
	--取消
	end

end

--[[--
--每日任务
--]]
function ImageView_MeiRi()

	Panel_MeiRi:setVisible(true)
	if(DAILYTASKID_CURRENT_TASKInfo and DAILYTASKID_CURRENT_TASKInfo.TaskID < 0)then
		Common.showToast("您今天的任务已经全部完成！",2)
	end

end

--[[--
--查看五星奖励
--]]
function callback_ImageView_DaJiang(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if(Panel_MeiRi:isVisible())then
			RenWuJiangLiInfoLogic.iconPosition = ImageView_DaJiang:getParent():convertToWorldSpace(ImageView_DaJiang:getPosition())
			mvcEngine.createModule(GUI_RENWUJIANGLI)
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

--[[--
--点击感叹号规则
--]]
function callback_ImageView_GuiZe(component)
	if(Panel_MeiRi:isVisible())then
		if component == PUSH_DOWN then
		--按下
		elseif component == RELEASE_UP then
			--抬起
			mvcEngine.createModule(GUI_RENWUGUIZE)
		elseif component == CANCEL_UP then
		--取消
		end
	end
end

--[[--
--元宝完成
--]]
function callback_Button_YuanBaoTiaoGuo(component)
	if(Panel_MeiRi:isVisible())then
		if component == PUSH_DOWN then
		--按下
		elseif component == RELEASE_UP then
			--抬起
			if(CommDialogConfig.getNewUserTaskFinish() == true)then
				--完成新手任务，进行每日任务
				if(not Button_LingQu:isTouchEnabled())then
					if(tonumber(Label_YuanBaoXiaoHao:getStringValue()) > tonumber(profile.User.getSelfYuanBao()))then
						--如果元宝不足则进行充值引导
						CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, tonumber(Label_YuanBaoXiaoHao:getStringValue())- profile.User.getSelfYuanBao(), RechargeGuidePositionID.RiChangRenWuPositionA)
					else
						local dataTable = {}
						dataTable["gameID"] = GameConfig.GAME_ID
						dataTable["tasked"] = DAILYTASKID_CURRENT_TASKInfo.TaskID
						sendDAILYTASKID_COMPLETE_TASK(dataTable)
					end
				else
					Common.showToast("任务已完成,请领取奖励!",2)
				end
			else
				Common.showToast("完成全部5个新手任务才能体验该功能哦！",2)
			end
		elseif component == CANCEL_UP then
		--取消
		end
	end
end



function callback_Button_ShuaXinCoin(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.log("zbl....测试测试")
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--金币刷新
--]]
function callback_Button_JinBiShuaXin(component)
	if(Panel_MeiRi:isVisible())then
		if component == PUSH_DOWN then
		--按下
		elseif component == RELEASE_UP then
			--抬起
			Common.log("zbl....刷新")
			if(CommDialogConfig.getNewUserTaskFinish() == true)then
				--完成新手任务，进行每日任务
				if(not Button_LingQu:isTouchEnabled())then
					if(tonumber(Label_JinBiXiaoHao:getStringValue()) > tonumber(profile.User.getSelfCoin()))then
						--如果金币不足则进行充值引导
						CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, tonumber(Label_JinBiXiaoHao:getStringValue())- tonumber(profile.User.getSelfCoin()), RechargeGuidePositionID.RiChangRenWuPositionA)
					else
						local dataTable = {}
						dataTable["gameID"] = GameConfig.GAME_ID
						dataTable["tasked"] = DAILYTASKID_CURRENT_TASKInfo.TaskID
						sendDAILYTASKID_REFRESH_TASK(dataTable)
					end
				else
					Common.showToast("任务已完成,请领取奖励!",2)
				end
			else
				Common.showToast("完成全部5个新手任务才能体验该功能哦！",2)
			end

		elseif component == CANCEL_UP then
		--取消
		end
	end
end

--[[--
--点击领取
--]]
local function listenreButton_LingQu()
	local NewUserInfo = profile.RenWu.getCOMMONS_V3_NEWUSER_TASK_INFO();
	if CommDialogConfig.getNewUserTaskFinish()then
		local dataTable = {}
		dataTable["gameID"] = GameConfig.GAME_ID
		dataTable["tasked"] = DAILYTASKID_CURRENT_TASKInfo.TaskID
		sendDAILYTASKID_GET_AWARD(dataTable)
	elseif(profile.RenWu.getNewUserTaskInfoIsComplete() == true)then
		--请求新手任务奖励
		sendCOMMONS_V3_NEWUSER_TASK_AWARD(NewUserInfo.taskNum);
		Common.log("zbl...." .. NewUserInfo.taskNum)

	elseif(NewUserInfo.taskNum == dataTaskNumber.LAIZI)then
		--了解癞子玩法，去【休闲房间-癞子场】中打3局牌
		Common.showProgressDialog("正在进入癞子牌桌,请稍后...");
		sendQuickEnterRoom(2);
	elseif(NewUserInfo.taskNum == dataTaskNumber.TIANTI)then
		--提升天梯等级
		Common.showProgressDialog("正在进入房间中,请稍后...");
		sendQuickEnterRoom(-1);
	elseif(NewUserInfo.taskNum == dataTaskNumber.YUANBAO_EXCHANGE_JINBI)then
		--元宝兑换金币
		setModifyUserInfo(true);
		local myyuanbao = profile.User.getSelfYuanBao()
		if myyuanbao >= 50 then
			Common.openConvertCoin()
		else
			--充值引导
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
			PayGuidePromptLogic.setEnterType(true)
		end
	elseif(NewUserInfo.taskNum == dataTaskNumber.SUIPIAN_EXCHANGE)then
		--碎片兑换
		setModifyUserInfo(true);
		mvcEngine.createModule(GUI_EXCHANGE,LordGamePub.runSenceAction(view,nil,true))
		ExchangeLogic.callback_btn_suipian(RELEASE_UP);
	elseif(NewUserInfo.taskNum == dataTaskNumber.MODIFY_USERINFO)then
		--修改昵称和密码
		setModifyUserInfo(true);
		HallLogic.callback_btn_useravator(RELEASE_UP);
	end
end

--[[--
--每日任务领取按钮
--]]
function callback_Button_LingQu(component)
	if(Panel_MeiRi:isVisible())then
		if component == PUSH_DOWN then
		--按下
		elseif component == RELEASE_UP then
			--抬起
			-----消除福利红点
			if profile.HongDian.getProfile_HongDian_datatable() == 0 then
				if HongDianLogic.getHongDian_local_FuLi() ~= nil then
					HongDian_datatable = {}
					HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
					HongDian_datatable[1]["ID"][1] = nil
					HongDian_datatable[12]["ID"][1003] = nil
					sendMANAGERID_REMOVE_REDP(1, 1)
					sendMANAGERID_REMOVE_REDP(12, 1003)
--					HongDianLogic.getHongDian_local_FuLi():setVisible(false)
				end
			end
			listenreButton_LingQu();
		elseif component == CANCEL_UP then
		--取消
		end
	end
end

function updata()
	Button_JinBiShuaXin:setTouchEnabled(true)
	Label_MiaoShu:setText("达成条件:"..DAILYTASKID_CURRENT_TASKInfo.Description)
	Label_JinDu:setText("当前进度:"..DAILYTASKID_CURRENT_TASKInfo.Proceeding .."/"..DAILYTASKID_CURRENT_TASKInfo.AllProceeding)
	Label_JiangLi:setText(DAILYTASKID_CURRENT_TASKInfo.Award)
	Label_YuanBaoXiaoHao:setText(DAILYTASKID_CURRENT_TASKInfo.CompletePrice)
	if(DAILYTASKID_CURRENT_TASKInfo["RefreshTime"] and DAILYTASKID_CURRENT_TASKInfo["RefreshTime"] > 0)then
		--		cocostudio.getUIImageView(view,"ImageView_78"):setVisible(false)
		--		Label_JinBiXiaoHao:setVisible(false)
		--		shengyuLabel:setVisible(true)
		--		cocostudio.getUILabelAtlas(view,"LabelAtlas_118"):setStringValue(DAILYTASKID_CURRENT_TASKInfo["RefreshTime"])
		--		cocostudio.getUIImageView(view,"ImageView_67"):loadTexture(Common.getResourcePath("ui_item_btn_mianfeishuaxin.png"))
		Image_freeshuaxin:setVisible(true)
		Panel_shuaxin:setVisible(false);
	else
		--		cocostudio.getUIImageView(view,"ImageView_67"):loadTexture(Common.getResourcePath("ui_item_btn_gold.png"))
		--		shengyuLabel:setVisible(false)
		--		cocostudio.getUIImageView(view,"ImageView_78"):setVisible(true)
		--		Label_JinBiXiaoHao:setVisible(true)
		Image_freeshuaxin:setVisible(false)
		Panel_shuaxin:setVisible(true);
		Label_JinBiXiaoHao:setText(DAILYTASKID_CURRENT_TASKInfo.RefreshPrice)
	end
	if(DAILYTASKID_CURRENT_TASKInfo.Proceeding == DAILYTASKID_CURRENT_TASKInfo.AllProceeding)then
		Button_LingQu:setTouchEnabled(true)
		Button_LingQu:loadTextureNormal(Common.getResourcePath("btn_gerenziliao0.png"))
		ImageView_LingQu:loadTexture(Common.getResourcePath("ui_room_2level_tianjiangdali_btn.png"))
--		LordGamePub.NewbreathEffect(Button_LingQu,1.0,1.35);
		--如果当前任务完成但没有领取奖励
		-- HallLogic.showGanTaoHao();
	else
		Button_LingQu:setTouchEnabled(false)
		Button_LingQu:loadTextureNormal(Common.getResourcePath("btn_gerenziliao0_no.png"))
		ImageView_LingQu:loadTexture(Common.getResourcePath("ui_room_2level_tianjiangdali_btn_no.png"))
		Button_LingQu:stopAllActions()
	end

	--绘制星级
	Label_JiangLi:removeAllChildren()
	local startLevel = (DAILYTASKID_CURRENT_TASKInfo.StarLevel + DAILYTASKID_CURRENT_TASKInfo.CurrentStarLevel)/2
	for i = 1,(startLevel - startLevel%1) do
		local startImageView = UIImageView:create()
		startImageView:loadTexture(Common.getResourcePath("Pai_coler_6.png"))
		startImageView:setScale(0.5)
		startImageView:setPosition(ccp(-winSize.width*0.22 + winSize.width*0.08*i,winSize.height*0))
		Label_XinJi:addChild(startImageView)
	end

	if(startLevel%1 >0)then
		local startImageView = UIImageView:create()
		startImageView:loadTexture(Common.getResourcePath("Pai_coler_7.png"))
		startImageView:setScale(0.5)
		startImageView:setPosition(ccp(-winSize.width*0.22 + winSize.width*0.08*((startLevel - startLevel%1) + 1),winSize.height*0))
		Label_XinJi:addChild(startImageView)
	end
end


--[[--
--获取当前每日任务
--]]
function getDAILYTASKID_CURRENT_TASKInfo()
	Common.closeProgressDialog()
	DAILYTASKID_CURRENT_TASKInfo = profile.DailyTasks.getDAILYTASKID_CURRENT_TASKTable()
	if(DAILYTASKID_CURRENT_TASKInfo.TaskID > 0)then
		--未完成五星任务时,提示语需要变为“奖励:xxxxxxxx”
		DAILYTASKID_CURRENT_TASKInfo.Award = "奖励:"..DAILYTASKID_CURRENT_TASKInfo.Award;
		updata()
		Common.SaveTable(profile.User.getSelfUserID().."RiChangRenWuHistory",DAILYTASKID_CURRENT_TASKInfo)
		Common.log("zbl  5星之下")
	else
		DAILYTASKID_CURRENT_TASKInfo = Common.LoadTable(profile.User.getSelfUserID().."RiChangRenWuHistory")
		if(DAILYTASKID_CURRENT_TASKInfo)then
			--完成五星任务时,提示语需要变为“今日任务已经全部完成，请明天再来！”
			DAILYTASKID_CURRENT_TASKInfo.Award = "今日任务已经全部完成，请明天再来！";
			updata()
		end
		Button_LingQu:setTouchEnabled(false)
		Button_LingQu:loadTextureNormal(Common.getResourcePath("btn_gerenziliao0_no.png"))
		ImageView_LingQu:loadTexture(Common.getResourcePath("ui_room_2level_tianjiangdali_btn_no.png"))

		Button_LingQu:stopAllActions()
		Button_JinBiShuaXin:setTouchEnabled(false)
		Image_freeshuaxin:setVisible(true)
		Panel_shuaxin:setVisible(false);
		Button_JinBiShuaXin:loadTextureNormal(Common.getResourcePath("btn_gerenziliao0_no.png"))
		Image_freeshuaxin:loadTexture(Common.getResourcePath("ui_item_btn_mianfeishuaxin_no.png"))

		Button_YuanBaoTiaoGuo:setTouchEnabled(false)
		Button_YuanBaoTiaoGuo:loadTextureNormal(Common.getResourcePath("btn_gerenziliao0_no.png"))
		ImageView_likewancheng:loadTexture(Common.getResourcePath("ui_item_btn_wing_no.png"))
		--		local wintSprite = UIImageView:create()
		--		wintSprite:setAnchorPoint(ccp(-2,0.5))
		--		wintSprite:loadTexture(Common.getResourcePath("ic_login_sign_pass.png"))
		--		wintSprite:setZOrder(100)
		--		Label_JinDu:addChild(wintSprite)
		--移除感叹号
		-- HallLogic.taskRemoveGanTanHao();
		if(Panel_MeiRi:isVisible())then
			Common.showToast("您今天的任务已经全部完成！",2)
		end
	end
end

--[[--
--手动刷新任务
--]]
function getDAILYTASKID_REFRESH_TASKInfo()
	DAILYTASKID_REFRESH_TASKInfo = profile.DailyTasks.getDAILYTASKID_REFRESH_TASKTable()
	if(DAILYTASKID_REFRESH_TASKInfo.Result == 0)then
		sendDAILYTASKID_CURRENT_TASK()
	end
	Common.showToast(DAILYTASKID_REFRESH_TASKInfo.Message,2)
end

--[[--
--元宝完成
--]]
function getDAILYTASKID_COMPLETE_TASKInfo()
	DAILYTASKID_COMPLETE_TASKInfo = profile.DailyTasks.getDAILYTASKID_COMPLETE_TASKTable()
	if(DAILYTASKID_COMPLETE_TASKInfo.Result == 0)then
		Label_JinDu:setText("进度:"..DAILYTASKID_CURRENT_TASKInfo.AllProceeding .."/"..DAILYTASKID_CURRENT_TASKInfo.AllProceeding)
		Button_LingQu:setTouchEnabled(true)
		Button_LingQu:loadTextureNormal(Common.getResourcePath("btn_gerenziliao0.png"))
		ImageView_LingQu:loadTexture(Common.getResourcePath("ui_room_2level_tianjiangdali_btn.png"))
--		LordGamePub.NewbreathEffect(Button_LingQu,1.0,1.35);
		--如果当前任务完成但没有领取奖励
		-- HallLogic.showGanTaoHao();
	end
	Common.showToast(DAILYTASKID_COMPLETE_TASKInfo.Message,2)
end

--[[--
--每日任务领取奖励
--]]
function getDAILYTASKID_GET_AWARDInfo()

	local dataTable = profile.DailyTasks.getDAILYTASKID_GET_AWARDTable()

	if(dataTable["Result"] == 1)then
		ImageToast.createView(dataTable["AwardUrl"],nil,dataTable["AwardMessage"],dataTable["Message"],2)
		Common.log("zbl....url=" .. dataTable["AwardUrl"] .. "    Amsg=" .. dataTable["AwardMessage"] .. "    msg=" .. dataTable["Message"])
		sendDAILYTASKID_CURRENT_TASK()
		Button_LingQu:stopAllActions()
--		Button_LingQu:setScale(1.35)  --放大到1.35倍的原因是  UI工程中，按钮的默认放大倍数是1.35倍
		-- HallLogic.taskRemoveGanTanHao();
	else
		mvcEngine.createModule(GUI_RENWUCHOGNZHI)
	end
end

--[[--
--新手任务基本信息
--]]
function getCOMMONS_V3_NEWUSER_TASK_INFO()
	Common.closeProgressDialog();
	local NewUserInfo = profile.RenWu.getCOMMONS_V3_NEWUSER_TASK_INFO();
	if(NewUserInfo ~= nil)then
		Label_NewUserTitle:setText("新手任务"..NewUserInfo.taskTitle);
		Label_MiaoShu:setText("达成条件:"..NewUserInfo.taskRequirement);
		Label_JinDu:setText("当前进度:"..NewUserInfo.taskSchedule);
		Label_JiangLi:setText("奖励:"..NewUserInfo.taskAward);
		if(profile.RenWu.getNewUserTaskInfoIsComplete() == true)then
			--如果当前任务完成但没有领取奖励
			-- HallLogic.showGanTaoHao();
			Button_LingQu:setTouchEnabled(true);
			ImageView_QianWang:setVisible(false);
			ImageView_LingQu:setVisible(true);
			Button_LingQu:loadTextureNormal(Common.getResourcePath("btn_gerenziliao0.png"));
--			LordGamePub.NewbreathEffect(Button_LingQu,1.0,1.35);
		else
			--没有完成，显示前往
			Button_LingQu:setTouchEnabled(true);
			ImageView_QianWang:setVisible(true);
			ImageView_LingQu:setVisible(false);
--			LordGamePub.NewbreathEffect(Button_LingQu,1.0,1.35);
		end
	end
end




--[[--
--显示领取的图片和提示语
--]]
local function awardToasView()
	--判断领取奖励是否成功，0未成功，1成功
	local dataAward = profile.RenWu.getCOMMONS_V3_NEWUSER_TASK_AWARD();
	if(dataAward ~= nil)then
		if(dataAward.awardList ~= nil)then
			for i=1,#dataAward.awardList do
				ImageToast.createView(dataAward.awardList[i].PicUrl,nil,dataAward.awardList[i].PicDescription,dataAward.ResultTxt,2);
			end
		end
	end
end

--[[--
--新手任务领取奖励
--]]
function getCOMMONS_V3_NEWUSER_TASK_AWARD()
	Common.closeProgressDialog();
	local award = profile.RenWu.getCOMMONS_V3_NEWUSER_TASK_AWARD();
	if(award ~= nil)then
		if(award.isSuccess == 1)then
			awardToasView();
			if(award.allComplete == 0)then
				sendCOMMONS_V3_NEWUSER_TASK_INFO();
			--移除感叹号
			-- HallLogic.taskRemoveGanTanHao();
			elseif(award.allComplete == 1)then
				--				Common.log("zbl....完成所有新手任务")
				--				Common.showToast("完成所有新手任务",2)
				--所有新手任务已经完成
				--移除感叹号
				-- HallLogic.taskRemoveGanTanHao();
				--保存新手任务完成
				Common.setDataForSqlite(CommSqliteConfig.NewUserTaskIsEnd..profile.User.getSelfUserID(),1);
				--每日任务消息
				sendDAILYTASKID_CURRENT_TASK();
				DailyInterface();
			end
		end
	end
end
--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(DAILYTASKID_CURRENT_TASK,getDAILYTASKID_CURRENT_TASKInfo)--获取当前每日任务
	framework.addSlot2Signal(DAILYTASKID_REFRESH_TASK,getDAILYTASKID_REFRESH_TASKInfo)--手动刷新任务
	framework.addSlot2Signal(DAILYTASKID_COMPLETE_TASK,getDAILYTASKID_COMPLETE_TASKInfo)--立即完成
	framework.addSlot2Signal(DAILYTASKID_GET_AWARD,getDAILYTASKID_GET_AWARDInfo)--每日任务领取奖励
	framework.addSlot2Signal(COMMONS_V3_NEWUSER_TASK_INFO,getCOMMONS_V3_NEWUSER_TASK_INFO)--新手任务基本信息
	framework.addSlot2Signal(COMMONS_V3_NEWUSER_TASK_AWARD,getCOMMONS_V3_NEWUSER_TASK_AWARD)--新手任务领取奖励
end

function removeSlot()
	framework.removeSlotFromSignal(DAILYTASKID_CURRENT_TASK,getDAILYTASKID_CURRENT_TASKInfo)
	framework.removeSlotFromSignal(DAILYTASKID_REFRESH_TASK,getDAILYTASKID_REFRESH_TASKInfo)
	framework.removeSlotFromSignal(DAILYTASKID_COMPLETE_TASK,getDAILYTASKID_COMPLETE_TASKInfo)
	framework.removeSlotFromSignal(DAILYTASKID_GET_AWARD,getDAILYTASKID_GET_AWARDInfo)
	framework.removeSlotFromSignal(COMMONS_V3_NEWUSER_TASK_INFO,getCOMMONS_V3_NEWUSER_TASK_INFO)
	framework.removeSlotFromSignal(COMMONS_V3_NEWUSER_TASK_AWARD,getCOMMONS_V3_NEWUSER_TASK_AWARD)
end
