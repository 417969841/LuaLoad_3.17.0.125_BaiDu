module("CrazyResultLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
Label_Text = nil;--
ImageView_Fail = nil;--
btn_Close = nil;--
btn_OK = nil;--
--Label_ButtonText = nil;--
ImageView_Baoshi = nil;--
Label_BaoshiNum = nil;--
ImageView_Title = nil;--
ImageView_Win = nil;--
Label_BaoshiNumBefore = nil;--
Label_Text_freecount = nil;--
Label_Text_free = nil;--
local isInTable = nil; --是否是在牌桌中
local isWin = nil; --是否闯关成功
local isDizhu = nil; --是否是地主
local reliveStoneNumber = nil; --拥有复活石数量
local needReliveStone = nil; --复活所需复活石数量
local mission = nil; --在第几关
local isReliveLimited = nil; --是否达到复活上限
local message = nil; --服务器返回来的文字提示

isShow = false;--弹窗是否正在显示
canBeShow = false;--弹窗是否可以显示

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		close()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	panel = cocostudio.getUIPanel(view, "panel");
	Label_Text = cocostudio.getUILabel(view, "Label_Text");
	ImageView_Fail = cocostudio.getUIImageView(view, "ImageView_Fail");
	btn_Close = cocostudio.getUIButton(view, "btn_Close");
	btn_OK = cocostudio.getUIButton(view, "btn_OK");
--	Label_ButtonText = cocostudio.getUILabel(view, "Label_ButtonText");
	ImageView_Baoshi = cocostudio.getUIImageView(view, "ImageView_Baoshi");
	Label_BaoshiNum = cocostudio.getUILabel(view, "Label_BaoshiNum");
	--	ImageView_Title = cocostudio.getUIImageView(view, "ImageView_Title");
	ImageView_Win = cocostudio.getUIImageView(view, "ImageView_Win");
	Label_BaoshiNumBefore = cocostudio.getUILabel(view, "Label_BaoshiNumBefore");
	needReliveStoneLable = cocostudio.getUILabel(view, "needReliveStone");
	Lable_Title = cocostudio.getUILabel(view, "Lable_Title");
	Image_lingjiang = cocostudio.getUIImageView(view, "Image_lingjiang");
	Image_fuhuo = cocostudio.getUIImageView(view, "Image_fuhuo");
	Image_fuhuoneed = cocostudio.getUIImageView(view, "Image_fuhuoneed");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("CrazyResult.json")
	local gui = GUI_CRAZY_RESULT
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
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	isShow = true
	canBeShow = false
	initView();
	showView();
end

function showView()

	if isReliveLimited == true then
		--如果是复活上限弹窗
		Lable_Title:setVisible(false)
		Label_Text:setText("本轮复活次数已达上限，您可以重置后继续挑战。")
--		Label_ButtonText:setText("重  置")
		ImageView_Baoshi:setVisible(false)
		Label_BaoshiNum:setVisible(false)
		Label_BaoshiNumBefore:setVisible(false)
		return
	end

	if isWin == true then
		--如果闯关成功
		Image_lingjiang:setVisible(true)
		Image_lingjiang:loadTexture(Common.getResourcePath("lingjiang.png"))
		Lable_Title:setText("闯关成功")
		Label_Text:setText("恭喜您闯过第" .. mission .. "关")
		ImageView_Baoshi:setVisible(false)
		Label_BaoshiNum:setVisible(false)
		Image_fuhuo:setVisible(false)
		Image_fuhuoneed:setVisible(false)
		Label_BaoshiNumBefore:setVisible(false)
		needReliveStoneLable:setVisible(false)
	else
		--如果闯关失败
		Lable_Title:setText("闯关失败")
		Image_lingjiang:setVisible(false)
		Image_fuhuo:setVisible(true)
		Image_fuhuoneed:setVisible(true)
		Label_Text:setText("您未能通过本关,是否消耗" .. needReliveStone .. "个复活石继续进行闯关")
--		Label_ButtonText:setText("复  活")
		needReliveStoneLable:setText(needReliveStone.."")
		ImageView_Baoshi:setVisible(true)
		Label_BaoshiNum:setVisible(true)
		Label_BaoshiNumBefore:setVisible(true)
		Label_BaoshiNum:setText(reliveStoneNumber .. "个")
		if mission == 1 then
			ImageView_Baoshi:setVisible(false)
			Label_Text:setText("您未能通过本关")
--			Label_ButtonText:setText("确  定")
			needReliveStoneLable:setVisible(false)
			Label_BaoshiNumBefore:setVisible(false)
			Label_BaoshiNum:setVisible(false)
			Image_lingjiang:setVisible(true)
			Image_lingjiang:loadTexture(Common.getResourcePath("ui_item_btn_ensure.png"))
			Image_fuhuo:setVisible(false)
			Image_fuhuoneed:setVisible(false)
		end
	end

	if isWin == true  then
		ImageView_Fail:setVisible(false)
		ImageView_Win:setVisible(true)
	else
		ImageView_Fail:setVisible(true)
		ImageView_Win:setVisible(false)
	end

	if message ~= nil then
		--如果服务器返回的文字不为空,则展示服务器返回的文字提示
		Label_Text:setText(message)
	end
end

function setValue(isInTableV,isWinV,isDizhuV,reliveStoneNumberV,needReliveStoneV,missionV,isReliveLimitedV,messageV)
	isInTable = isInTableV
	isWin = isWinV
	isDizhu = isDizhuV
	reliveStoneNumber = reliveStoneNumberV
	needReliveStone = needReliveStoneV
	mission = missionV
	isReliveLimited = isReliveLimitedV
	message = messageV
end

function requestMsg()

end

function callback_btn_Close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_20(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		return
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_OK(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		relive()
	elseif component == CANCEL_UP then
	--取消

	end
end

function close()
	if HallGiftShowLogic.canBeShow then
		local giftData = profile.Gift.getGiftDataTable()
		mvcEngine.createModule(GUI_GIFT_SHOW_VIEW)
		HallGiftShowLogic.setGiftData(giftData)
	else
		HallGiftShowLogic.nextView = nil
		if GameConfig.getTheCurrentBaseLayer() == GUI_CHUANGGUAN then
			mvcEngine.destroyModule(GUI_CRAZY_RESULT)
		else
			TableConsole.resetCrazy()
			mvcEngine.createModule(GUI_CHUANGGUAN)
		end
	end
	isShow = false
	canBeShow = false
end

function relive()

	if isReliveLimited == true then
		if GameConfig.getTheCurrentBaseLayer() == GUI_CHUANGGUAN then
			mvcEngine.destroyModule(GUI_CRAZY_RESULT)
		end
		sendOPERID_CRAZY_STAGE_RESET()

		return
	end

	if isWin == true then
		TableConsole.resetCrazy()
		mvcEngine.createModule(GUI_CHUANGGUAN)
	else
		if mission ~= 1 then
			Common.showProgressDialog("数据加载中...")
			sendOPERID_CRAZY_STAGE_RELIVE()
		else
			TableLogic.changeGameStartButton(true)
		end
		mvcEngine.destroyModule(GUI_CRAZY_RESULT)
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	message = nil
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(OPERID_CRAZY_STAGE_RESET,close)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(OPERID_CRAZY_STAGE_RESET,close)
end
