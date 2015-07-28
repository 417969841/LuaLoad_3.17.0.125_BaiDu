module("NewUserCreateLogic",package.seeall)

local yiYuaHuaFei = nil;--一元话费兑换
local yiYuanHuaFeiAward = nil;--一元话费奖励
isUserOnClickCloseBtn = false;--用户是否点击"话费账号"界面关闭按钮
hasNewUserGuideData = false;--是否有新手奖励数据需要更新
local isNewUserGameSync = false;--是否是新手引导断线续玩

--[[--
--设置是否是断线续玩
--@param #boolean flag 是否是断线续玩
--]]
function setNewUserGameSync(flag)
	isNewUserGameSync = flag;
end

--[[--
--获取是否是断线续玩
--]]
function getNewUserGameSync()
	return isNewUserGameSync;
end

function setYiYuanHuaFeiData(data)
	yiYuaHuaFei = data;
end

function setYiYuanHuaFeiAward(dataTable)
	yiYuanHuaFeiAward = dataTable;
end

--设置引导页的显示界面
local function GuideInterface(state)
	if  profile.NewUserGuide.getisNewUserGuideisEnable() == true then
		mvcEngine.createModule(GUI_NEWUSERCOVEROTHER);
		NewUserCoverOtherLogic.setTableShowInterface(state);
	end
end

local function viewResume()
	if profile.NewUserGuide.getisNewUserGuideisEnable() == false then
		view:setTouchEnabled(true)
		view:setKeypadEnabled(true)
	end
end
--[[--
--@param #type view 传递过来的界面
--@param #type getState 获取当前的状态是否一样
--]]
function JumpInterface(view,getState)
	if(not NewUserGuideLogic.getNewUserFlag())then
		Common.log("当前已返回，下面不在执行！");
		return;
	end
	if(view ~= nil)then
		framework.releaseOnKeypadEventListener(view)
		view:setTouchEnabled(false)
		Common.log("把当前页面按钮屏蔽！=======");
	end
	if(view ~= nil)then
		local delay = CCDelayTime:create(5);
		local array = CCArray:create();
		array:addObject(delay);
		array:addObject(CCCallFuncN:create(viewResume));
		local seq = CCSequence:create(array);
		view:runAction(seq);
	end
	--新手引导页是否相同
	if(NewUserCoverOtherLogic.getDataTable().TASK_TWO_TABLE_1_START == getState)then
		--在进行新手引导，跳转到牌桌的宝箱页面
		if(GameConfig.getTheCurrentBaseLayer() == GUI_TABLE)then
			GuideInterface(NewUserCoverOtherLogic.getDataTable().TASK_TWO_TABLE_2_BAOXIANG);
		else
			NewUserGuideLogic.setNewUserFlag(false);
			NewUserGuideLogic.setIsCompleteNewUserGuide(true);
		end
	elseif(NewUserCoverOtherLogic.getDataTable().TASK_TWO_TABLE_2_BAOXIANG == getState)then
		--大厅页面更多中的兑奖按钮
		GuideInterface(NewUserCoverOtherLogic.getDataTable().TASK_THREE_HALL_2_EXCHANGE);

	elseif(NewUserCoverOtherLogic.getDataTable().TASK_THREE_HALL_2_EXCHANGE == getState)then
		--兑换按钮
		GuideInterface(NewUserCoverOtherLogic.getDataTable().TASK_THREE_HALL_3_ONETELEPHONECOST);
	elseif(NewUserCoverOtherLogic.getDataTable().TASK_THREE_HALL_3_ONETELEPHONECOST == getState)then
		--一元话费
		GuideInterface(NewUserCoverOtherLogic.getDataTable().TASK_THREE_HALL_4_EXCHANGE);
	--GuideInterface(NewUserCoverOtherLogic.getDataTable().TASK_FIVE_TELEPHONE_HALL);
	--GuideInterface(NewUserCoverOtherLogic.getDataTable().TASK_FOUR_TELEPHONE_CLOSE);
	--	elseif(NewUserCoverOtherLogic.getDataTable().TASK_THREE_HALL_4_EXCHANGE == getState)then
	--		--兑换确定界面
	--		GuideInterface(NewUserCoverOtherLogic.getDataTable().TASK_THREE_HALL_6_SURE);
	elseif(NewUserCoverOtherLogic.getDataTable().TASK_FOUR_EXCHANGE_BILL_ACCOUNT == getState)then
		--关闭话费界面
		GuideInterface(NewUserCoverOtherLogic.getDataTable().TASK_FOUR_TELEPHONE_CLOSE);
	elseif(NewUserCoverOtherLogic.getDataTable().TASK_FOUR_TELEPHONE_CLOSE == getState)then
		--点击返回
		GuideInterface(NewUserCoverOtherLogic.getDataTable().TASK_FIVE_TELEPHONE_HALL);

	end
	Common.log("界面设置和跳转的页面=====JumpInterface====");
end

--[[--
--牌桌点击开始
--]]
function FinishStateInterface()
	--如果不是新手引导就结束
	if(not NewUserGuideLogic.getNewUserFlag())then
		return;
	end

	--新手引导页是否相同
	if(NewUserGuideLogic.getNewUserFlag() == true)then
		--在进行新手引导，跳转到牌桌的开始页面
		TableLogic.setTableButtonEnabled(false);
		GuideInterface(NewUserCoverOtherLogic.getDataTable().TASK_TWO_TABLE_1_START);
		framework.releaseOnKeypadEventListener(TableLogic.view)
		TableLogic.view:setTouchEnabled(false);
		TableElementLayer.setElementLayerTouchEnabled(false);
		TableCardLayer.setCardLayerTouchEnabled(false);
	end
end

--[[--
--@param #number taskfinish 当前完成状态
--]]
function TaskFinish()
	--完成任务状态界面显示
	local function setFinishState(TaskState)
		mvcEngine.createModule(GUI_NEWUSERGUIDE)
		NewUserGuideLogic.setTaskFinishState(TaskState);
	end
	--任务编号
	local taskType = profile.NewUserGuide.getNewUserAwardType();
	Common.log("TaskFinish ==============taskType == "..taskType);
	if(taskType == 1)then

		if GameConfig.getTheCurrentBaseLayer() ~= GUI_TABLE then
			setFinishState(NewUserGuideLogic.getDataFinishState().oneFinish);
		end
	elseif(taskType == 2)then
		--预读兑奖消息
		HallLogic.sendExchangeMsg()
		setFinishState(NewUserGuideLogic.getDataFinishState().twoFinish);
	elseif(taskType == 3)then
		setFinishState(NewUserGuideLogic.getDataFinishState().fourFinish);
	elseif(taskType == 4)then
		setFinishState(NewUserGuideLogic.getDataFinishState().fourFinish);
		Common.setButtonVisible(NewUserGuideLogic.btn_skip,false);
	end
end

--判断新手引导是否完成，或者是其他终端问题解决办法
function InterruptNewUserTask()
	if profile.NewUserGuide.getTaskIsStarted() then
		--新用户注册过后，新手引导被意外终端，再次登录，则直接跳过！
		sendCOMMONS_SKIP_NEWUSERGUIDE();
		--获取是否有新活动
		--		MeiRiDengLuTiShiLogic.setIsFirstSign(false)
		--		local timeTable = Common.LoadShareTable(MeiRiDengLuTiShiLogic.getHuodongFileName())
		--		if timeTable ~= nil then
		--			sendMANAGERID_GET_HAVE_NEW_HUODONG(timeTable["time"])
		--		else
		--			sendMANAGERID_GET_HAVE_NEW_HUODONG(0)
		--		end

		Common.log("新用户注册过后，新手引导被意外终端，再次登录，直接跳过！");
	else
		GameConfig.isFirstEnterGame = true
		--不是新注册用户，但没有进行过新手引导则进行新手引导！
		if 	profile.NewUserGuide.getisNewUserGuideisEnable()== true then
			sendCOMMONS_GET_BASEINFO_NEWUSERGUIDE();
		end
		sendCOMMONS_GET_NEWUSERGUIDE_AWARD(1)
		NewUserGuideLogic.setNewUserFlag(true);
		Common.log("不是新注册用户，但没有进行过新手引导则进行新手引导！");
	end
end

--[[--
--在播放完一元话费ImageToast后发送完成新手引导第三步
--@param #CCLayer view layer
--]]
function delaySendGetNewUserGuideAardMsg(view)
	local function callBack()
		--完成第三步新手引导
		Common.showProgressDialog("数据加载中...")
		sendCOMMONS_GET_NEWUSERGUIDE_AWARD(3);
	end

	local arr = CCArray:create()
	arr:addObject(CCDelayTime:create(2));
	arr:addObject(CCCallFuncN:create(callBack))
	local ac = CCSequence:create(arr)
	view:runAction(ac);
end

--覆盖页面Panel监听
function ListenerPanel()
	Common.log("点击了Panel按钮NewUserCoverOtherLogic.getTaskState()=="..NewUserCoverOtherLogic.getTaskState())
	if(NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_TWO_TABLE_1_START)then
		Common.log("新手引导========牌桌打牌");
		TableLogic.callback_btn_opencard_start_right(RELEASE_UP);
		mvcEngine.destroyModule(GUI_NEWUSERCOVEROTHER);

	elseif(NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_TWO_TABLE_2_BAOXIANG)then
		Common.log("新手引导========获取宝箱奖励");
		TableElementLayer.baoxiangCallback()

	elseif(NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_THREE_HALL_2_EXCHANGE)then
		Common.log("新手引导=======点击的是大厅中更多中的兑奖");
		HallLogic.callback_btn_gift(RELEASE_UP);

	elseif(NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_THREE_HALL_3_ONETELEPHONECOST)then
		if yiYuaHuaFei ~= nil then
			Common.log("新手引导=======点击的是一元废话领奖物品==yiYuaHuaFei~=nil2");
			ExchangeDetailLogic.setValue(1, yiYuaHuaFei.GoodID, yiYuaHuaFei.ShortName, yiYuaHuaFei.Name, yiYuaHuaFei.Prize, yiYuaHuaFei.Picture, yiYuaHuaFei.Description, true, 2, yiYuaHuaFei.AwardMsg);
			mvcEngine.createModule(GUI_EXCHANGEDETAIL);
			Common.log("新手引导=======点击的是一元废话领奖物品==yiYuaHuaFei~=nil3");
		else
			Common.log("新手引导=======点击的是一元废话领奖物品==yiYuaHuaFei==nil");
		end

	elseif(NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_THREE_HALL_4_EXCHANGE)then
		ExchangeDetailLogic.callback_btn_ok(RELEASE_UP);
	--		Common.log("新手引导=======点击兑换");
	--
	--	elseif(NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_THREE_HALL_6_SURE)then
	--		Common.log("新手引导=======点击确定");
	--TODO

	elseif(NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_FOUR_EXCHANGE_MYPRIZE)then
		--Common.log("新手引导=======点击我的奖品");
		--ExchangeLogic.callback_btn_myprice(RELEASE_UP);
		--GuideInterface(NewUserCoverOtherLogic.getDataTable().TASK_FOUR_EXCHANGE_BILL_ACCOUNT)
		NewUserGuideLogic.setNewUserFlag(false);--设置完成新手引导
		NewUserGuideLogic.setIsCompleteNewUserGuide(true);
		--创建大厅箭头(完成新手引导,大厅出现提示指向"快速开始"的前提)
		HallLogic.promptClickQuickStartBtn();
		mvcEngine.destroyModule(GUI_NEWUSERCOVEROTHER);
		Common.log("完成新手引导====当前结束了新手引导");

	elseif(NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_FOUR_EXCHANGE_BILL_ACCOUNT)then
		Common.log("新手引导=======点击话费界面账户");
		mvcEngine.createModule(GUI_HUAFEIZHANGHU);
		if(yiYuanHuaFeiAward ~= nil)then
			HuaFeiZhangHuLogic.setData(yiYuanHuaFeiAward.TotalityAmount,yiYuanHuaFeiAward.ExchangbleAmount,yiYuanHuaFeiAward.HistoryAmount,yiYuanHuaFeiAward.id - 10000,yiYuanHuaFeiAward.Description)
		else
			Common.log("新手引导yiYuanHuaFeiAward==nil,赋值没有成功！");
		end

	elseif(NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_FOUR_TELEPHONE_CLOSE)then
		Common.log("新手引导=======点击关闭");
		--		sendCOMMONS_GET_NEWUSERGUIDE_AWARD(4);
		--用户已经点击了话费账号的关闭按钮
		isUserOnClickCloseBtn = true;
		--如果有新手奖励数据没更新,进行更新
		if hasNewUserGuideData then
			CommDialogConfig.getCOMMONS_GET_NEWUSERGUIDE_AWARD();
		end
	elseif(NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_FIVE_TELEPHONE_HALL)then
		--设置新手引导完成标志
		NewUserGuideLogic.setNewUserFlag(false);--设置完成新手引导
		NewUserGuideLogic.setIsCompleteNewUserGuide(true);
		mvcEngine.destroyModule(GUI_NEWUSERCOVEROTHER);
		Common.log("完成新手引导====当前结束了新手引导");
		HallLogic.promptClickQuickStartBtn();
	end

end