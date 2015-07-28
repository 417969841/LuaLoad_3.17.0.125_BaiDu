module("VIPLogic",package.seeall)

view = nil
--控件
btn_back = nil--返回按钮
btn_cz = nil--充值
btn_pre = nil--上一个
btn_next = nil--下一个
btn_viplibao = nil
btn_help = nil --

lab_title = nil--vip级别标题
lab_vipjb1 = nil--
lab_text = nil
--panel
panel_webview = nil
local x,y,w,h = 0
--全局变量
local curPage = 0
local vipjb = 0
local pageFlag = 0

viptable = {}
AllGiftTable = {}--礼包list
--会员页面初始化标识
local VIPHasInit = false
--标记本界面是否由个人资料界面跳转而来
local isInitFromUserInf = 0
local isInitFromChonZhi = false --是否从充值界面跳转而来

function onKeypad(event)
	if event == "backClicked" then
		Common.hideWebView()
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then
	end
end
--[[--
--设置跳转标记
--]]
function isInitFromUserInfoView(flag)
	isInitFromUserInf = flag;
end
--[[--
--设置跳转标记 是从充值界面跳转过来的
--]]
function isInitFromChonZhiView(flag)
	isInitFromChonZhi = true
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("VIP.json")
	local gui = GUI_VIP
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
	initView()--初始化控件
	GameConfig.setTheCurrentBaseLayer(GUI_VIP)
	GameStartConfig.addChildForScene(view)

	local function delaySentMessage()
		if VIPHasInit == false  then
			--如果第一次进入页面,显示loading页面
			VIPHasInit = true
			Common.showProgressDialog("")
			sendMANAGERID_GET_VIP_MSG()
			sendMANAGERID_VIP_LIST_V3(profile.VIPData.getTimestamp())
		else
			--不是第一次进入页面,加载旧信息当做默认信息
			updataUserVip()
			Viplist()
		end
		--如果礼品列表没有请求
		if profile.Shop.getGiftListHasInit() == true then
			setGiftListData();
		else
			--礼包
			sendGIFTBAGID_GIFTBAG_LIST();
		end
	end
	LordGamePub.runSenceAction(view,delaySentMessage,false)

	curPage = 1
	if isInitFromUserInf == 1 then
		vipjb = VIPPub.getUserVipType(profile.User.getSelfVipLevel())
		Common.log("isInitFromUserInf=" .. vipjb)
		if vipjb >= 7 then
		else
			vipjb = vipjb + 1 ;
		end
	else
		vipjb = VIPPub.getUserVipType(profile.User.getSelfVipLevel())
	end
	pageFlag = 0
end

function initView()
	btn_back =  cocostudio.getUIButton(view, "btn_back")
	btn_cz =  cocostudio.getUIButton(view, "btn_cz")
	btn_pre =  cocostudio.getUIButton(view, "btn_pre")
	btn_next =  cocostudio.getUIButton(view, "btn_next")
	btn_viplibao =  cocostudio.getUIButton(view, "btn_viplibao")
	btn_help =  cocostudio.getUIButton(view, "btn_help")

	lab_title = cocostudio.getUILabel(view, "lab_title")
	lab_vipjb1 =  cocostudio.getUILabelAtlas(view, "lab_vipjb1")
	--cocostudio.getUILoadingBar setPercent
	lab_text = cocostudio.getUILabel(view, "lab_text");
	panel_webview = cocostudio.getUIPanel(view, "panel_webview")

	--显示
	lab_vipjb1:setStringValue("1")
	--lab_title:setText(VIPPub.VipInfo[1])
	--webview坐标
	x = panel_webview:getPosition().x
	y = panel_webview:getPosition().y
	w = panel_webview:getSize().width
	h = panel_webview:getSize().height

	btn_pre:setVisible(false)
	btn_pre:setTouchEnabled(false)
	viptable = profile.VIPData.getVipTable()
end

--[[--
--显示webview层容器
--]]
function showVipWebView()
	setPage(curPage)
end

function setPage(pageNum)
	Common.log("page"..pageNum)
	local page = tonumber(pageNum)
	if page <= 1 then
		btn_pre:setVisible(false)
		btn_pre:setTouchEnabled(false)
		btn_next:setVisible(true)
		btn_next:setTouchEnabled(true)
	elseif page >= 7 then
		page = 7;
		btn_pre:setVisible(true)
		btn_pre:setTouchEnabled(true)
		btn_next:setVisible(false)
		btn_next:setTouchEnabled(false)
	else
		btn_pre:setVisible(true)
		btn_pre:setTouchEnabled(true)
		btn_next:setVisible(true)
		btn_next:setTouchEnabled(true)
	end
	Common.hideWebView()
	if page == 0 then
		Common.showWebView("",viptable[1].vipPrivilege,x,y,w,h)
	else
		Common.showWebView("",viptable[page].vipPrivilege,x,y,w,h)
	end
	--显示

	if page >= VIPPub.VIP_1 then
		lab_title:setText(viptable[page].vipQualification)--viptable[vipjbnum].vipQualification
		lab_vipjb1:setStringValue(""..page)
	else
		lab_vipjb1:setStringValue("1")
		lab_title:setText(viptable[1].vipQualification)
	end
	for i=1,#viptable do
		if page == i then
			lab_title:setText(viptable[page].vipQualification)
		end
	end
	curPage = page
end

function requestMsg()

end


--充值
function callback_btn_cz(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_VIP)
		mvcEngine.createModule(GUI_RECHARGE_CENTER,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消
	end
end

--返回
function callback_btn_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		curPage = 0; --置为初始值
		Common.hideWebView()
		LordGamePub.showBaseLayerAction(view)
	elseif component == CANCEL_UP then
	--取消
	end
end

--上一个
function callback_btn_pre(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		setPage(curPage - 1)
	elseif component == CANCEL_UP then
	--取消
	end
end

--下一个
function callback_btn_next(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		setPage(curPage + 1)
	elseif component == CANCEL_UP then
	--取消
	end
end

--vip礼包
function callback_btn_viplibao(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local vipData = profile.User.getSelfVipLevel() --vip级别
		local vipLevel = VIPPub.getUserVipType(vipData)
		local VipGiftID = ""
		local GiftBagType = ""
		local Name = ""
		local IconURL = ""
		local Description = ""
		local Consume = ""
		local needVipMinLevel = ""--最小vip等级
		--vip礼包
		VipGiftID = AllGiftTable["VipGiftData"][curPage].VipGiftID
		--…GiftBagType  礼包类别ID
		GiftBagType = AllGiftTable["VipGiftData"][curPage].GiftBagType
		--…Name  名称
		Name = AllGiftTable["VipGiftData"][curPage].Name
		--…IconURL  图标url
		IconURL = AllGiftTable["VipGiftData"][curPage].IconURL
		--…Description  描述
		Description = AllGiftTable["VipGiftData"][curPage].Title
		Consume = AllGiftTable["VipGiftData"][curPage].Consume
		needVipMinLevel = AllGiftTable["VipGiftData"][curPage].needVipMinLevel
		if curPage <= vipLevel then
			--自己的vip大于。可以购买    Name  IconURL  Description  Consume  needVipMinLevel
			BuyVipGiftLogic.setValue(VipGiftID,Name,IconURL,Description,Consume,needVipMinLevel,BuyVipGiftLogic.getFromType().ISFROMCHONGZHIVIEW)
			mvcEngine.createModule(GUI_BUYVIPGIFT)
		else
			--不能购买
			Common.hideWebView();
			BuyGiftVipNotFitLogic.setNotFitValue(needVipMinLevel,VipGiftID,Name,IconURL,Description,Consume,BuyVipGiftLogic.getFromType().ISFROMCHONGZHIVIEW)
			mvcEngine.createModule(GUI_BUYGIFTVIPNOTFIT)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--帮助
function callback_btn_help(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		VIPDetailLogic.setVipWebViewpage(curPage)
		mvcEngine.createModule(GUI_VIPDETAIL)
	elseif component == CANCEL_UP then
	--取消
	end
end

--更新用户信息
function updataUserVip()
	--VipLevel  VipExpirationDate  Amount  Balance
	local VipLevel = profile.User.getSelfVipLevel()--vip级别
	local VipExpirationDate = profile.User.getVipExpirationDate()--到期日期
	local Amount = profile.User.getSelfAmount()--当月累计
	local Balance = profile.User.getSelfBalance()--到达下一级需要

	local nextjb = VIPPub.getUserVipName(vipjb + 1)
	local datetab = os.date("*t",VipExpirationDate/1000)
	local datenyr = datetab.year.."/"..datetab.month.."/"..datetab.day
	local bl = Amount/(Amount+Balance)--已充值/（已充值+需充值）

	if VipLevel > 0 then
		--vip
--		lab_text:setPosition(ccp(-160,-20))
		lab_text:setFontSize(25)
		--100万
		if Balance >= 100000000 then
			lab_text:setText("您已经达到VIP7，享受最高级特权")
		else
			lab_text:setText("再充值" .. (Balance / 100) .. "元立即成为" .. nextjb..",".."本月充值数额：" .. Amount / 100 ..
				"元"..",".."持续至" .. datenyr)
		end
		btn_help:setPosition(ccp(836,40))

	else
--		lab_text:setPosition(ccp(-60,0))
		lab_text:setFontSize(25)
		lab_text:setText("您还不是VIP，现在仅需充值".. (Balance / 100) .. "元，马上成为VIP1")
		btn_help:setPosition(ccp(700,55))
	end
	pageFlag = pageFlag+1
	setPageFlag()
end
function setPageFlag()
	if pageFlag == 2 then
		if vipjb >= VIPPub.VIP_1 then
			setPage(vipjb)
		else
			setPage(VIPPub.VIP_1)
		end
	end
	--如果是从充值界面跳转过来的
	if isInitFromChonZhi == true  then
		if vipjb >= VIPPub.VIP_1 then
			setPage(vipjb)
		else
			setPage(VIPPub.VIP_1)
		end
	end
end
function Viplist()
	Common.closeProgressDialog()
	viptable = profile.VIPData.getVipTable()
	pageFlag = pageFlag+1
	setPageFlag()
end

function setGiftListData()
	AllGiftTable["VipGiftData"] = profile.Shop.getVipGiftListTable()
	Common.log("AllGiftTable_Num:" .. #AllGiftTable["VipGiftData"]);
end

--[[--
--将初始化标识恢复false,在切换账号时调用
--]]
function releaseHuoDongHasInit()
	VIPHasInit = false
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(MANAGERID_GET_VIP_MSG, updataUserVip)
	framework.addSlot2Signal(MANAGERID_VIP_LIST_V3, Viplist)
	framework.addSlot2Signal(GIFTBAGID_GIFTBAG_LIST, setGiftListData)
end

function removeSlot()
	Common.hideWebView()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(MANAGERID_GET_VIP_MSG, updataUserVip)
	framework.removeSlotFromSignal(MANAGERID_VIP_LIST_V3, Viplist)
	framework.removeSlotFromSignal(GIFTBAGID_GIFTBAG_LIST, setGiftListData)
end
