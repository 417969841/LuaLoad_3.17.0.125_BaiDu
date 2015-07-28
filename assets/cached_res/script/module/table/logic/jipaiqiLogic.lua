module("jipaiqiLogic",package.seeall)

view = nil;

Panel_bg = nil;--
Panel_jipaiqi = nil;--
Panel_jipaiqi_text = nil;--
Label_jipai_down_da = nil;--
Label_jipai_down_xiao = nil;--
Label_jipai_down_A = nil;--
Label_jipai_down_K = nil;--
Label_jipai_down_Q = nil;--
Label_jipai_down_J = nil;--
Panel_youxiaoqi = nil;--
Button_jipaizi_add = nil;--
Label_jipai_shengyu2 = nil;--
img_124 = nil

--记牌器上面的数字
Label_jipai_up = {}
Label_jipai_up["Label_jipai_up_3"] = nil
Label_jipai_up["Label_jipai_up_4"] = nil
Label_jipai_up["Label_jipai_up_5"] = nil
Label_jipai_up["Label_jipai_up_6"] = nil
Label_jipai_up["Label_jipai_up_7"] = nil
Label_jipai_up["Label_jipai_up_8"] = nil
Label_jipai_up["Label_jipai_up_9"] = nil
Label_jipai_up["Label_jipai_up_10"] = nil
Label_jipai_up["Label_jipai_up_J"] = nil
Label_jipai_up["Label_jipai_up_Q"] = nil
Label_jipai_up["Label_jipai_up_K"] = nil
Label_jipai_up["Label_jipai_up_A"] = nil
Label_jipai_up["Label_jipai_up_2"] = nil
Label_jipai_up["Label_jipai_up_xiao"] = nil
Label_jipai_up["Label_jipai_up_da"] = nil

--记牌器下面的数字
Label_jipai = {}
Label_jipai["Label_jipai_down_3"] = nil
Label_jipai["Label_jipai_down_4"] = nil
Label_jipai["Label_jipai_down_5"] = nil
Label_jipai["Label_jipai_down_6"] = nil
Label_jipai["Label_jipai_down_7"] = nil
Label_jipai["Label_jipai_down_8"] = nil
Label_jipai["Label_jipai_down_9"] = nil
Label_jipai["Label_jipai_down_10"] = nil
Label_jipai["Label_jipai_down_J"] = nil
Label_jipai["Label_jipai_down_Q"] = nil
Label_jipai["Label_jipai_down_K"] = nil
Label_jipai["Label_jipai_down_A"] = nil
Label_jipai["Label_jipai_down_2"] = nil
Label_jipai["Label_jipai_down_xiao"] = nil
Label_jipai["Label_jipai_down_da"] = nil

bJipaiqiViewDidShow = false -- 记牌器view是否已经显示
bJipaiqiYouxiaoqiViewDidShow = false -- 记牌器购买view是否已经显示

bDidExcludeSelfCards = false;

--[[
显示记牌器有效期view
]]
function showYouxiaoqiJipaiqiView()
	-- 隐藏记牌器view
	hideJipaiqiView()

	img_124:setVisible(true)
  	Panel_youxiaoqi:setVisible(true)
	Button_jipaizi_add:setTouchEnabled(true)
  
	bJipaiqiYouxiaoqiViewDidShow = true
end

--[[
隐藏记牌器有效期view
]]
function hideYouxiaoqiJipaiqiView()
	img_124:setVisible(false)
	Panel_youxiaoqi:setVisible(false)
	Button_jipaizi_add:setTouchEnabled(false)
  
  	bJipaiqiYouxiaoqiViewDidShow = false
end

--[[
显示记牌器view
]]
function showJipaiqiView()
	--隐藏记牌器有效期view
	hideYouxiaoqiJipaiqiView()

	img_124:setVisible(true)
	Panel_jipaiqi_text:setVisible(true)
  
	bJipaiqiViewDidShow = true
end

--[[
隐藏记牌器view
]]
function hideJipaiqiView()
	img_124:setVisible(false)
	Panel_jipaiqi_text:setVisible(false)
  
  	bJipaiqiViewDidShow = false
end

--[[
隐藏记牌器view，而不改变其显示的状态
]]
function hideJipaiqiViewWithoutChangeStatus()
	img_124:setVisible(false)
	Panel_jipaiqi_text:setVisible(false)
end

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[
jipaiqiValidDate:记牌器有效期，单位小时
]]
function updateJipaiqiYouxiaoqiView(jipaiqiValidDate)
	Common.log("jipaiqiValidDate = "..jipaiqiValidDate)
	
	if jipaiqiValidDate > 0 then
		if jipaiqiValidDate > 24 then
			Label_jipai_shengyu2:setText(""..math.floor(jipaiqiValidDate/24).."天")
		elseif jipaiqiValidDate > 1 then
			Label_jipai_shengyu2:setText(""..(jipaiqiValidDate%24).."小时")
		else
			Label_jipai_shengyu2:setText("小于1小时")
		end
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_bg = cocostudio.getUIPanel(view, "Panel_bg");
	Panel_jipaiqi = cocostudio.getUIPanel(view, "Panel_jipaiqi");
	Panel_jipaiqi_text = cocostudio.getUIPanel(view, "Panel_jipaiqi_text");
	Label_jipai_down_da = cocostudio.getUILabel(view, "Label_jipai_down_da");
	Label_jipai_down_xiao = cocostudio.getUILabel(view, "Label_jipai_down_xiao");
	Label_jipai_down_A = cocostudio.getUILabel(view, "Label_jipai_down_A");
	Label_jipai_down_K = cocostudio.getUILabel(view, "Label_jipai_down_K");
	Label_jipai_down_Q = cocostudio.getUILabel(view, "Label_jipai_down_Q");
	Label_jipai_down_J = cocostudio.getUILabel(view, "Label_jipai_down_J");

	Panel_youxiaoqi = cocostudio.getUIPanel(view, "Panel_youxiaoqi");
	Button_jipaizi_add = cocostudio.getUIButton(view, "Button_30");
	Label_jipai_shengyu2 = cocostudio.getUILabel(view, "Label_jipai_shengyu2");
	
	--获取记牌器的剩余时间，单位为小时
	local jipaiqiValidDate = profile.Pack.getJipaiqiValidDate()
	updateJipaiqiYouxiaoqiView(jipaiqiValidDate)

  	img_124 = cocostudio.getUIImageView(view, "Image_124");
  
  	Label_jipai["Label_jipai_down_3"] = cocostudio.getUILabel(view, "Label_jipai_down_3")
	Label_jipai["Label_jipai_down_4"] = cocostudio.getUILabel(view, "Label_jipai_down_4")
	Label_jipai["Label_jipai_down_5"] = cocostudio.getUILabel(view, "Label_jipai_down_5")
	Label_jipai["Label_jipai_down_6"] = cocostudio.getUILabel(view, "Label_jipai_down_6")
	Label_jipai["Label_jipai_down_7"] = cocostudio.getUILabel(view, "Label_jipai_down_7")
	Label_jipai["Label_jipai_down_8"] = cocostudio.getUILabel(view, "Label_jipai_down_8")
	Label_jipai["Label_jipai_down_9"] = cocostudio.getUILabel(view, "Label_jipai_down_9")
	Label_jipai["Label_jipai_down_10"] = cocostudio.getUILabel(view, "Label_jipai_down_10")
	Label_jipai["Label_jipai_down_J"] = cocostudio.getUILabel(view, "Label_jipai_down_J")
	Label_jipai["Label_jipai_down_Q"] = cocostudio.getUILabel(view, "Label_jipai_down_Q")
	Label_jipai["Label_jipai_down_K"] = cocostudio.getUILabel(view, "Label_jipai_down_K")
	Label_jipai["Label_jipai_down_A"] = cocostudio.getUILabel(view, "Label_jipai_down_A")
	Label_jipai["Label_jipai_down_2"] = cocostudio.getUILabel(view, "Label_jipai_down_2")
	Label_jipai["Label_jipai_down_xiao"] = cocostudio.getUILabel(view, "Label_jipai_down_xiao")
	Label_jipai["Label_jipai_down_da"] = cocostudio.getUILabel(view, "Label_jipai_down_da")

	Label_jipai_up["Label_jipai_up_3"] = cocostudio.getUILabel(view, "Label_jipai_up_3")
	Label_jipai_up["Label_jipai_up_4"] = cocostudio.getUILabel(view, "Label_jipai_up_4")
	Label_jipai_up["Label_jipai_up_5"] = cocostudio.getUILabel(view, "Label_jipai_up_5")
	Label_jipai_up["Label_jipai_up_6"] = cocostudio.getUILabel(view, "Label_jipai_up_6")
	Label_jipai_up["Label_jipai_up_7"] = cocostudio.getUILabel(view, "Label_jipai_up_7")
	Label_jipai_up["Label_jipai_up_8"] = cocostudio.getUILabel(view, "Label_jipai_up_8")
	Label_jipai_up["Label_jipai_up_9"] = cocostudio.getUILabel(view, "Label_jipai_up_9")
	Label_jipai_up["Label_jipai_up_10"] = cocostudio.getUILabel(view, "Label_jipai_up_10")
	Label_jipai_up["Label_jipai_up_J"] = cocostudio.getUILabel(view, "Label_jipai_up_J")
	Label_jipai_up["Label_jipai_up_Q"] = cocostudio.getUILabel(view, "Label_jipai_up_Q")
	Label_jipai_up["Label_jipai_up_K"] = cocostudio.getUILabel(view, "Label_jipai_up_K")
	Label_jipai_up["Label_jipai_up_A"] = cocostudio.getUILabel(view, "Label_jipai_up_A")
	Label_jipai_up["Label_jipai_up_2"] = cocostudio.getUILabel(view, "Label_jipai_up_2")
	Label_jipai_up["Label_jipai_up_xiao"] = cocostudio.getUILabel(view, "Label_jipai_up_xiao")
	Label_jipai_up["Label_jipai_up_da"] = cocostudio.getUILabel(view, "Label_jipai_up_da")

	Label_jipai_up["Label_jipai_up_3"]:setText("3")
	Label_jipai_up["Label_jipai_up_4"]:setText("4")
	Label_jipai_up["Label_jipai_up_5"]:setText("5")
	Label_jipai_up["Label_jipai_up_6"]:setText("6")
	Label_jipai_up["Label_jipai_up_7"]:setText("7")
	Label_jipai_up["Label_jipai_up_8"]:setText("8")
	Label_jipai_up["Label_jipai_up_9"]:setText("9")
	Label_jipai_up["Label_jipai_up_10"]:setText("10")
	Label_jipai_up["Label_jipai_up_J"]:setText("J")
	Label_jipai_up["Label_jipai_up_Q"]:setText("Q")
	Label_jipai_up["Label_jipai_up_K"]:setText("K")
	Label_jipai_up["Label_jipai_up_A"]:setText("A")
	Label_jipai_up["Label_jipai_up_2"]:setText("2")
  	
  	bDidExcludeSelfCards = false
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("jipaiqi.json")
	local gui = nil;
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

	initView();

	-- 默认先隐藏记牌器相关view
	hideYouxiaoqiJipaiqiView()
	hideJipaiqiView()

	--如果玩家已购买了记牌器，则打开
	if profile.Pack.getJipaiqiValidDate() > 0 then
		--有记牌器，没开始牌局时，显示有效期
		showYouxiaoqiJipaiqiView()
	end

  	clearJipaiData()
end

function requestMsg()

end

--[[--
--更新记牌器数据
--]]
function updataJipaiData()
	local isDaXiaoWangNotTakeOut = true -- 大小王是否都没出, 默认值是
	for i = 1, #TableCard_NUM do
		local num = 0; -- 牌值的剩余牌数
		if i > #TableCard_NUM - 2 then
			-- 大小王
			num = 1 - tonumber(TableConsole.cardRecord["What_"..TableCard_NUM[i]]);
			if num == 0 then
				isDaXiaoWangNotTakeOut = false
			end
		else
			-- 其他牌值
			num = 4 - tonumber(TableConsole.cardRecord["What_"..TableCard_NUM[i]]);
		end

		if num == 0 then
			-- 该牌值已经出完, 显示灰色
			Label_jipai["Label_jipai_down_"..TableCard_NUM[i]]:setColor(ccc3(86, 86, 86));
		elseif num == 4 then
			-- 该牌值1张未出, 显示红色
			Label_jipai["Label_jipai_down_"..TableCard_NUM[i]]:setColor(ccc3(156, 9, 16));
		else
			--还剩1~3的牌值，显示默认的蓝色
			Label_jipai["Label_jipai_down_"..TableCard_NUM[i]]:setColor(ccc3(13, 61, 111));
		end

		if TableConsole.mnLaiziCardVal >= 0 then
			-- 癞子牌，显示绿色
			-- 注意：因为服务器返回的值算出来的index，比客户端的要小1(java的数组下标从0开始，而lua的数组从1开始)，这里+1
			local index = TableConsole.getWhatByValue(TableConsole.mnLaiziCardVal) + 1
			Label_jipai_up["Label_jipai_up_"..TableCard_NUM[index]]:setColor(ccc3(28, 142, 19));
		end

		--设置剩余牌值的数量
		Label_jipai["Label_jipai_down_"..TableCard_NUM[i]]:setText(num);
	end

	if isDaXiaoWangNotTakeOut == true then
		-- 显示红色
		Label_jipai["Label_jipai_down_"..TableCard_NUM[14]]:setColor(ccc3(156, 9, 16));
		Label_jipai["Label_jipai_down_"..TableCard_NUM[15]]:setColor(ccc3(156, 9, 16));
	end
end

--[[--
--重置记牌器
--]]
function clearJipaiData()
	for i = 1, #TableCard_NUM do
		Label_jipai["Label_jipai_down_"..TableCard_NUM[i]]:setColor(ccc3(13, 61, 111)); --记牌器下排默认显示蓝色
		Label_jipai_up["Label_jipai_up_"..TableCard_NUM[i]]:setColor(ccc3(20, 20, 20)); --记牌器上排默认显示黑色

		if i > #TableCard_NUM - 2 then
			Label_jipai["Label_jipai_down_"..TableCard_NUM[i]]:setText("1");
		else
			Label_jipai["Label_jipai_down_"..TableCard_NUM[i]]:setText("4");
		end
	end

	--牌局结束后，置为未排除自己手牌
	bDidExcludeSelfCards = false;
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	Label_jipai = {}
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
end
