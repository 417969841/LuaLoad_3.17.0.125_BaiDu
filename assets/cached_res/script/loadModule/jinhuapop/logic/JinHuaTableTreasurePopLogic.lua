module("JinHuaTableTreasurePopLogic",package.seeall)


view = nil
tableTreasureScrollView = nil
local tableTreasureScrollViewWidth = 340
local tableTreasureScrollViewHeight
local tableTreasureItemHeight = 75
local tableTreasurePicWidth = 65 -- 奖品图片宽
local tableTreasurePicHeight = 70 -- 奖品图片高度
tableTreasureIamgeViewTable = {} -- 存放imageview用来加载图片

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

function createView()
	view = cocostudio.createView("load_res/JinHua/JinHuaTableTreasurePop.json")
	view:setTag(getDiffTag())
	CCDirector:sharedDirector():getRunningScene():addChild(view)

	initTableTreasureScrollView()
end

function updataTreasureImage(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]

		Common.log("update"..photoPath)
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		Common.log(i, j)
		--  string.sub(s,i,j) 提取字符串s的第i个到第j个字符。Lua中，第一个字符的索引值为1，最后一个为-1，以此类推，如：
		--  Common.log(string.sub("[hello world]",2,-2))      --输出hello world
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
		Common.log("ID = " .. id)
		Common.log("photoPath = " .. photoPath)
	end
	tableTreasureIamgeViewTable[tonumber(id)]:loadTexture(photoPath)
end

-- 初始化宝物列表
function initTableTreasureScrollView()
	tableTreasureScrollView = cocostudio.getUIScrollView(view, "sv_table_treasure_prize_content")
	local baohePrizeTable = profile.JinHuaTableTreasure.getTreasurePrizeTable()
	local prizeCount = #baohePrizeTable["TableTreasureData"]
	tableTreasureScrollViewHeight = prizeCount * tableTreasureItemHeight
	tableTreasureScrollView:setInnerContainerSize(CCSizeMake(tableTreasureScrollViewWidth, tableTreasureScrollViewHeight))

	for i=1, prizeCount do
		local label_treasure_name = ccs.label({
			text = baohePrizeTable["TableTreasureData"][i].TreasureDiscription.."："..baohePrizeTable["TableTreasureData"][i].lastTreasureCount,
		})
		label_treasure_name:setAnchorPoint(ccp(0, 0.5))
		label_treasure_name:setColor(ccc3(103, 209, 0))
		SET_POS(label_treasure_name, tableTreasurePicWidth + 20, tableTreasureItemHeight/2)

		local iv_treasure_pic = ccs.image({
			scale9 = false,
			image = "",
			size = CCSizeMake(tableTreasurePicWidth, tableTreasurePicHeight),
		})
		iv_treasure_pic:setAnchorPoint(ccp(0, 0.5))
		SET_POS(iv_treasure_pic, 0, tableTreasureItemHeight/2)

		local layout = ccs.panel({
			size = CCSizeMake(tableTreasureScrollViewWidth, tableTreasureItemHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		layout:addChild(label_treasure_name)
		layout:addChild(iv_treasure_pic)

		SET_POS(layout, 80, tableTreasureScrollViewHeight - i * tableTreasureItemHeight)
		tableTreasureScrollView:addChild(layout)

		tableTreasureIamgeViewTable[i] = iv_treasure_pic
		if baohePrizeTable["TableTreasureData"][i] and baohePrizeTable["TableTreasureData"][i].TreasurePicUrl and baohePrizeTable["TableTreasureData"][i].TreasurePicUrl ~= "" then
			Common.getPicFile(baohePrizeTable["TableTreasureData"][i].TreasurePicUrl, i, true, updataTreasureImage)
		end
	end
end

function requestMsg()
end

function callback_btn_table_treasure_get_prize(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
	--抬起
		JinHuaTableTreasure.showTableTreasureCloseState()
		mvcEngine.destroyModule(GUI_JINHUA_TABLETREASUREPOP)
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
