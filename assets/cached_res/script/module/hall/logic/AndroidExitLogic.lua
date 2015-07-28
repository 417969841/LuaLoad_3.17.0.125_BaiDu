module("AndroidExitLogic",package.seeall)

view = nil;

Panel_20 = nil;--
btn_cancel = nil;--关闭按钮
Image_iocn = nil;--图标
btn_exit = nil;--退出游戏按钮
Button_Text = nil;--右边文字提示按钮
Label_Tips = nil;--提示文字
panel_bg = nil;--
Label_messagelow = nil;--下面的提示文字
btn_Right = nil;--右边的按钮
ImageView_Right = nil;--右边按钮上的图片
isExitViewShow = false;--退出框是否正在显示

AndroidExitTable = {} --退出引导表
TaskEvent = 0;--右侧按钮的回调事件参数 3．直接进入房间宝盒牌桌 4．打开分享页面 5．跳转到福利 6.  推荐下载的游戏 7.  礼包推荐
FirstParam = "";-- 缺省参数1 TaskEvent == 3 传roomId; TaskEvent == 6 传下载游戏的URL; TaskEvent == 7 传礼包ID
SecondParam= ""--缺省参数2 TaskEvent == 7 购买礼包消费的金币; TaskEvent == 6 传下载游戏的GAME_ID

local ENTER_ROOM = 3; --直接进入房间宝盒牌桌
local TO_SHARE_VIEW = 4; --打开分享页面
local TO_FREE_COIN_VIEW = 5; --跳转到福利
local DOWNLOAD_APP = 6; --推荐下载的游戏
local BUY_GIFT = 7; --购买礼包

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--更新左侧按钮图片
@param string path 图片URL
]]
local function loadLeftCoin(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" then
		Image_iocn:loadTexture(photoPath);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	btn_cancel = cocostudio.getUIButton(view, "btn_cancel");
	Image_iocn = cocostudio.getUIImageView(view, "Image_iocn");
	btn_exit = cocostudio.getUIButton(view, "btn_exit");
	Button_Text = cocostudio.getUIButton(view, "Button_Text");
	Label_Tips = cocostudio.getUILabel(view, "Label_Tips");
	Image_head = cocostudio.getUIImageView(view, "Image_head");
	panel_bg = cocostudio.getUIPanel(view, "panel_bg");
	Label_messagelow = cocostudio.getUILabel(view, "Label_messagelow");
	btn_Right = cocostudio.getUIButton(view, "btn_Right");
	ImageView_Right = cocostudio.getUIImageView(view, "ImageView_Right");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("AndroidExit.json")
	local gui = GUI_ANDROID_EXIT;
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
	isExitViewShow = true;
	initView();

	LordGamePub.showDialogAmin(panel_bg)
	GameStartConfig.addChildForScene(view)

	--初始化退出面板的数据
	initExitPanelData();
end

--[[--
--初始化退出面板的数据
--]]
function initExitPanelData()
	if profile.AndroidExit.getExitDataHasInit() == false then
		--服务器消息未回, 设置缺省的退出引导信息
		setDefaultQuitGuideInfo();
	elseif profile.AndroidExit.getExitDataHasInit() == true then
		--服务器消息已回, 设置退出弹框引导信息
		setQuitGuideInfo();
	end
end

function requestMsg()

end

--[[--
--销毁退出弹框
--]]
local function close()
	mvcEngine.destroyModule(GUI_ANDROID_EXIT)
end

--[[--
--设置缺省的退出引导信息
--]]
function setDefaultQuitGuideInfo()
	Label_Tips:setText("你今天还有未领取的“福利”哦，每日最多可以领取20000+金币呐！");
	Image_iocn:loadTexture(Common.getResourcePath("fuli.png"));
	Label_messagelow:setText("亲爱的,明天再来赠送更多金币!");
	ImageView_Right:loadTexture(Common.getResourcePath("ui_lijiqianwang.png"));
end

--[[--
--设置退出弹框引导信息
--]]
function setQuitGuideInfo()
	--获取退出信息
	AndroidExitTable = profile.AndroidExit.getQuitTable();
	--如果获取退出消息成功
	if AndroidExitTable ~= nil then
		--右侧按钮的回调事件参数
		TaskEvent = AndroidExitTable.TaskEventLeft;
		-- 缺省参数1
		FirstParam = AndroidExitTable.Param1;
		-- 缺省参数2
		SecondParam = AndroidExitTable.Param2;
		--左侧图片背景图片加载
		if AndroidExitTable.PicUrlLeft ~= nil and  AndroidExitTable.PicUrlLeft ~= ""  then
			Common.getPicFile(AndroidExitTable.PicUrlLeft, TaskEvent, true, loadLeftCoin)
		end
		--右侧标签显示内容
		if AndroidExitTable.LabelRightTaskPrize ~= nil and AndroidExitTable.LabelRightTaskPrize ~= "" then
			Label_Tips:setText(AndroidExitTable.LabelRightTaskPrize)
		end
		--下面的提示文字
		Label_messagelow:setText("亲爱的,明天再来赠送更多金币!");
		--右侧按钮显示的图片
		if TaskEvent == ENTER_ROOM then
			--继续游戏
			ImageView_Right:loadTexture(Common.getResourcePath("ui_zi_jixuyouxi.png"));
		elseif TaskEvent == TO_SHARE_VIEW then
			--分享游戏
			ImageView_Right:loadTexture(Common.getResourcePath("fenxiang.png"));
		elseif TaskEvent == DOWNLOAD_APP then
			--立即下载
			ImageView_Right:loadTexture(Common.getResourcePath("xiazai.png"));
		elseif TaskEvent == BUY_GIFT then
			--购买礼包
			ImageView_Right:loadTexture(Common.getResourcePath("libaoxiangqing.png"));
		else
			--默认：前往
			ImageView_Right:loadTexture(Common.getResourcePath("ui_lijiqianwang.png"));
		end
	else
		--如果退出消息获取失败 , 设置缺省的退出引导信息
		setDefaultQuitGuideInfo();
	end
end

--[[--
--下载推荐的应用
--@param #String appUrl 推荐的游戏下载地址
--@param #String sDownloadTips 推荐的游戏下载提示语
--@param #String GameID 推荐的游戏ID
--]]
function downloadTheRecommendedApp(sGameID, appUrl, sDownloadTips)
	--设置下载完成回调的方法 参数：应用ID 回调方法 下载完是否立即安装 true 是 false否
	Common.setDownloadCompleteCallBack(sGameID, LordGamePub.callBackAfterDownloadAppComplete, false);
	--将所有的应用状态设置为已下载(没下完一个应用不会下载另一个)
	profile.AndroidExit.setAllAppDownloadStatus(1);--1是已安装应用
	--清空当前的退出框的profile数据
	profile.AndroidExit.clearData();
	--下载
	if Common.getConnectionType() == Common.NET_WIFI then
		--如果是WIFI,则后台下载 参数：下载地址, 存放路径, 通知ID, 是否限速, 是否显示现在进度界面,下载时的提示语
		DownloadControler.getDownloadFile(appUrl, Common.getAppDownloadPath(), DownloadControler.DOWNLOAD_ACTION_A, true, false, sDownloadTips);
		--弹toast
		Common.showToast("资源正在下载, 请稍后 ...", 2);
	else
		--如果不是WIFI,则显示进度条下载
		DownloadControler.getDownloadFile(appUrl, Common.getAppDownloadPath(), DownloadControler.DOWNLOAD_ACTION_A, true, true, sDownloadTips);
	end

	--如果当前界面正在展示, 关闭当前界面
	if isExitViewShow then
		close();
	end
end

--[[--
--购买推荐的礼包
--@param #number giftID 礼包ID
--@param #number Consume 购买礼包消耗的元宝数
--]]
--function buyTheRecommendedGift(giftID, Consume)
--	if profile.User.getSelfYuanBao() >=  Consume  then
--		--如果元宝数大于等于消费的元宝数,直接购买
--		sendGIFTBAGID_BUY_GIFTBAG(giftID)
--	else
--		--如果元宝数小于消费的元宝数,弹充值引导
--		local num =  Consume - profile.User.getSelfYuanBao()
--		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, num, RechargeGuidePositionID.PayGiftPosition)
--	end
--end

--[[--
--点击右边按钮或文字按钮
--]]
function clickBtnToTheRightOrText()
	if TaskEvent == ENTER_ROOM then
		--直接进入房间宝盒牌桌
		local roomdID = tonumber(FirstParam);--房间ID
		--进入指定的房间
		sendEnterRoom(roomdID);
	elseif TaskEvent == TO_SHARE_VIEW then
		--打开分享页面
		mvcEngine.createModule(GUI_INITIATIVE_SHARE);
	elseif TaskEvent == DOWNLOAD_APP then
		--推荐下载的应用
		local appUrl = FirstParam;--游戏下载地址
		local sGameID = SecondParam;--推荐的游戏ID
		local sDownloadTips = "游戏下载中, 请稍后...";
		downloadTheRecommendedApp(sGameID, appUrl, sDownloadTips);
		--保存下载的AppURL
		profile.AndroidExit.saveDownloadAppUrl(sGameID, appUrl, sDownloadTips);
	else
		--默认：打开福利界面
		mvcEngine.createModule(GUI_FREECOIN);
	end
end

--[[--
--关闭
--]]
function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(panel_bg,close)
	elseif component == CANCEL_UP then
	--取消

	end
end

local function callJavaMethodFunction(null)
	Common.AndroidExitSendOnlineTime()
end

--[[--
--退出游戏
--]]
function callback_btn_exit(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if CommShareConfig.isOpenRedGiftShare() == true and CommShareConfig.isRedGiftShareFirst() == true and CommShareConfig.isExitEnabled == false then
			CommShareConfig.selectRedGiftShareType()
			CommShareConfig.isExitEnabled = true
		else
			local javaClassName = "com.tongqu.client.lord.BaiDuBaseActivity"
			local javaMethodName = "baiDuExitGame"
			local javaParams = {
				callJavaMethodFunction,
			}

			luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--文字提示按钮
--]]
function callback_Button_Text(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		clickBtnToTheRightOrText();
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--右边按钮
--]]
function callback_btn_Right(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		clickBtnToTheRightOrText();
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
--framework.addSlot2Signal(signal, slot)

end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)

end

