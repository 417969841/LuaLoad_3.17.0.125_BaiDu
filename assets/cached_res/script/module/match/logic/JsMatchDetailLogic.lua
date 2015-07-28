module("JsMatchDetailLogic",package.seeall)

view = nil
--控件
btn_ts = nil --退赛按钮
panel = nil
lab_title = nil--标题
--lab_coin = nil--金币
lab_jzrs = nil--激战人数
lab_mzrs = nil--每组人数
lab_bmrs = nil --报名人数
LoadingBar_82 = nil--进度条
DetaleTable = nil
img_good = nil -- 奖品图片

--全局变量
local MatchID = nil

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
	view = cocostudio.createView("JsMatchDetail.json")
	local gui = GUI_JSMATCHDETAIL
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

	btn_ts = cocostudio.getUIButton(view, "BackButton") --退赛按钮
	lab_title = cocostudio.getUILabel(view, "lab_title") --比赛标题
  
  	lab_coin_title = cocostudio.getUILabel(view, "Label_21") -- 最高奖项title
  
  	img_good = cocostudio.getUIImageView(view, "img_good")
  	img_good:loadTexture(DetaleTable.localPrizeImgUrl)
  
	lab_jzrs = cocostudio.getUILabel(view, "Label_21_0") --总的激战人数
	lab_mzrs = cocostudio.getUILabel(view, "Label_21_1") --每组的人数
	lab_bmrs = cocostudio.getUILabel(view, "lab_bmrs") --已报名人数
  
	LoadingBar_82 = cocostudio.getUILoadingBar(view, "LoadingBar_82")
	lab_title:setText(DetaleTable.MatchTitle)

  	lab_coin_title:setText(""..DetaleTable.PrizeDesc)
	lab_mzrs:setText(""..DetaleTable.MaxRegCnt.."人")
	lab_jzrs:setText(""..DetaleTable.playerCnt.."人") 
	lab_bmrs:setText(DetaleTable.RegCnt.."/"..DetaleTable.MaxRegCnt.."人")
	LoadingBar_82:setPercent(DetaleTable.RegCnt/DetaleTable.MaxRegCnt)

	local delay = CCDelayTime:create(1)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(function ()
    	sendMATID_V4_REGCNT(DetaleTable.MatchID)
	end))
	local seq = CCSequence:create(array)
	view:runAction(CCRepeatForever:create(seq))
end

function requestMsg()

end

function setMatchID(value)
	MatchID = value
end

function callback_btn_ts(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.showProgressDialog("正在取消报名，请稍后...")

		-- 3.03退票
		sendMATID_V4_REFUND(DetaleTable.MatchID)

		-- 关闭即时赛弹窗
		mvcEngine.destroyModule(GUI_JSMATCHDETAIL)
	elseif component == CANCEL_UP then
	--取消
	end
end

--关闭页面
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end

function closePanel()
	Common.showProgressDialog("正在取消报名，请稍后...") 
	-- 3.03退票
	sendMATID_V4_REFUND(DetaleTable.MatchID)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

--[[
更新即时赛弹框进度条
tReg:数据同步表
]]
function updateProgressUI(tReg)
	lab_mzrs:setText("每组人数："..tReg.MaxRegCnt.."人")
  
	if(tReg.RegCnt > 0)then
		lab_bmrs:setText(tReg.RegCnt.."/"..tReg.MaxRegCnt.."人")
	end
  
	if(tonumber(tReg.RegCnt) == tonumber(tReg.MaxRegCnt)-1) then
		Common.showProgressDialog("正在进入牌桌...")
	end
  
	if(tReg.RegCnt/tReg.MaxRegCnt*100 > 0)then
		LoadingBar_82:setPercent(tReg.RegCnt/tReg.MaxRegCnt*100)
	end
end

function getMATID_V4_MATCH_LIST_REGCNTInfo()
	local dataTable = profile.Match.getMATID_V2_MATCH_LIST_REGCNTTable()
	updateProgressUI(dataTable)
end

function addSlot()  
	framework.addSlot2Signal(MATID_V4_REGCNT, getMATID_V4_MATCH_LIST_REGCNTInfo)
end

function removeSlot()  
	framework.removeSlotFromSignal(MATID_V4_REGCNT, getMATID_V4_MATCH_LIST_REGCNTInfo)
end
