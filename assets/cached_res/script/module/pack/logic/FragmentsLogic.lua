module("FragmentsLogic",package.seeall)

local scene = nil
view = nil
panel  = nil
PriceCompound = nil
--控件
--lab_duijiangquan = nil
--lab_suipian = nil
--lab_hechengfu = nil
--lab_yuanbao = nil
lab_duijiangquan_1 = nil
lab_duipian_100 = nil
lab_hechengfu_1 = nil
--lab_hechengfuoryuanbao = nil
--img_hechengfu = nil
btn_close = nil
btn_ok = nil

local hechengfunum = 0

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
	local gui = GUI_FRAGMENTS;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("Fragments.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("Fragments.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("Fragments_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())

	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)
	scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(view)

	--控件
	--	lab_duijiangquan = cocostudio.getUILabel(view,"lab_duijiangquan")
	--	lab_suipian = cocostudio.getUILabel(view,"lab_suipian")
	--	lab_hechengfu = cocostudio.getUILabel(view,"lab_hechengfu")
	--	lab_yuanbao = cocostudio.getUILabel(view,"lab_yuanbao")
	lab_duijiangquan_1 = cocostudio.getUILabel(view,"lab_duijiangquan_1")
	lab_duipian_100 = cocostudio.getUILabel(view,"lab_duipian_100")
	lab_hechengfu_1 = cocostudio.getUILabel(view,"lab_hechengfu_1")
	--	lab_hechengfuoryuanbao = cocostudio.getUILabel(view,"lab_hechengfuoryuanbao")
	--	img_hechengfu = cocostudio.getUIImageView(view, "img_hechengfu")
	btn_ok = cocostudio.getUIButton(view, "btn_ok")
	btn_close = cocostudio.getUIButton(view, "btn_close")

	local self_yuanbao = profile.User.getSelfYuanBao()

	--赋值
	--	lab_duijiangquan:setText(profile.User.getDuiJiangQuan())
	--	lab_suipian:setText(PriceCompound["ExistingNum"])
	--	lab_hechengfu:setText("1/".. hechengfunum)
	--	lab_yuanbao:setText(self_yuanbao)
	lab_duijiangquan_1:setText("+1")
	if PriceCompound["NeedNum"] ~= nil then
		lab_duipian_100:setText(PriceCompound["NeedNum"] .. "/".. profile.User.getSelfdjqPieces())
	end
	lab_hechengfu_1:setText("1/".. hechengfunum)
	--	--设置字体颜色，如果碎片不足，设置红色，足设置白色
	--	if hechengfunum <= 0 then
	--		if self_yuanbao <= 0 then
	--			lab_hechengfu_1:setColor(ccc3(255, 0, 0))
	--		else
	--			lab_hechengfu_1:setColor(ccc3(255, 255, 255))
	--		end
	--	else
	--		lab_hechengfu_1:setColor(ccc3(255, 255, 255))
	--	end
	--	if PriceCompound["ExistingNum"] < PriceCompound["NeedNum"] then
	--		lab_duipian_100:setColor(ccc3(255, 0, 0))
	--	else
	--		lab_duipian_100:setColor(ccc3(255, 255, 255))
	--	end
end

function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(panel,close)
	elseif component == CANCEL_UP then
	--取消
	end
end
function close()
	mvcEngine.destroyModule(GUI_FRAGMENTS)
end
function callback_btn_ok(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if tonumber(PriceCompound["ExistingNum"]) < 100 then
			Common.showToast("兑奖券碎片不足，无法合成，去房间开启宝盒可获得大量碎片。", 2)
		else
			sendMANAGERID_COMPOUND_V2(PriceCompound["PiecesID"],1)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function setData(table,hechengfunumV)
	hechengfunum = hechengfunumV
	PriceCompound = table
end

function slot_priceCompound()
	local result = profile.PriceCompound.getResult()
	local resultmsg =  profile.PriceCompound.getResultText()
	if result == 0 then
		Common.showToast(resultmsg, 2)
	else
		close()
--		Common.showToast(resultmsg, 2)
		ImageToast.createView(nil,Common.getResourcePath("ic_duijiang_duijiangjuan.png"),"","您已领取奖励！",2)
		--调用更新
		if UserInfoLogic.lab_basic_basic_suipian ~= nil then
			UserInfoLogic.lab_basic_basic_suipian:setText(profile.User.getSelfdjqPieces());
		end
		if UserInfoLogic.lab_basic_basic_duijiangquan ~= nil then
			UserInfoLogic.lab_basic_basic_duijiangquan:setText(profile.User.getDuiJiangQuan());
		end
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(MANAGERID_COMPOUND_V2, slot_priceCompound)

end

function removeSlot()
	framework.removeSlotFromSignal(MANAGERID_COMPOUND_V2, slot_priceCompound)

end
