module("GameResultLogic", package.seeall)

view = nil

ImageView_Background = nil; --大背景
Image_self_money_bg = nil;--自己金币的背景
Image_WinLight = nil;--胜利的高光
Image_58 = nil;--背景小鬼
image_star = {}; --星星
bar_win_progess = nil --胜利进度条
bar_lose_progress = nil--失败进度条
 

Button_close = nil
la_multiple = nil--倍数标签
la_multipleImage = nil--倍数iamge
iv_gameResult = nil--人物cg
--iv_win_lose = nil--胜利/失败图  被毛帅弃用
label_coin_name = nil--输赢消耗类型文字(金币/积分)
--label_self_coin = nil--个人金币数
ImageView_70_0 = nil--天梯背景图
--label_duanwei_name = nil--天梯段位
LoadingBar_duanwei = nil--天梯段位进度
label_duanwei = nil--天梯段位进度数字说明
atLblDuanwei = nil --天梯段位
imgDuanwei = nil --天梯段位图片

isSelfShengli = false --是否胜利


local gameResultPlayer = {};
local gameResultSelfIndex = nil

iv_player_win_loss = {}--用户胜利/失败标签( 下标是牌桌的位置+1 ====== pos+1)
label_player_name = {}--用户名字
iv_player_photo = {}--用户头像
iv_player_vip_level = {}--用户VIP标签
la_player_vip_level = {}--用户VIP等级
label_player_add_coin = {}--用户本局金币加减
label_player_add_integral = {}--用户本局积分加减
iv_player_coin_add = {}--用户金币加成标签
iv_player_playout = {}--用户输光标签

myself_money_value = 0 --自己得金币
myself_score_value = 0 --自己得分
myself_money_setp = 0 --步长

myself_progress_value = 0 --天梯等级进度值

imgJifenPanel = nil --积分panel
imgWinBg = nil --胜利的背景
imgLoseBg = nil --失败的背景

iv_player_bg = {} --用户信息bg

--local touchLayer = nil -- 点击层，用于关闭结束页面
local updateTimeScheduler -- 更新时间定时器

function closeView()
	TableLogic.hideGameResultDifenAndBeishu()
	if view ~= nil then
		mvcEngine.destroyModule(GUI_TABLE_GAME_RESULT)
	end
	 --关闭计时器
	 if updateTimeScheduler then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(updateTimeScheduler)
		updateTimeScheduler = nil
	end
end

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--更新个人头像
--]]
local function updataUserPhoto(path)
	local photoPath = nil
	local m_nPos = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		m_nPos = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		Common.log("path = " .. path)
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		m_nPos = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
	if (photoPath ~= nil and photoPath ~= "" and iv_player_photo ~= nil and iv_player_photo[m_nPos + 1] ~= nil) then
		if m_nPos + 1 ~= 1 then
			--只显示上家、下家的头像
			iv_player_photo[m_nPos + 1]:loadTexture(photoPath)
		end
	end
end

--[[--
--设置是否显示天梯数据
--]]
local function setShowLadderData(visible)
	--label_duanwei_name:setVisible(visible)
	LoadingBar_duanwei:setVisible(visible)
	label_duanwei:setVisible(visible)
	ImageView_70_0:setVisible(visible)
end

--[[--
--更新用户天梯信息
--]]
local function upDataLadderData()
	local LadderGameOver = profile.TianTiData.getTTGameOverData()
	-- changeDuan byte 段改变情况 0 不变，1升级，-1降级
	--	LadderGameOver["changeDuan"] = nMBaseMessage:readByte();
	-- duan int 段位
	profile.User.setSelfLadderDuan(LadderGameOver["duan"])
	-- changeRank int 等级改变情况 0 不变，1升级，-1降级
	--	LadderGameOver["changeRank"] = nMBaseMessage:readByte();
	-- rank int 等级
	profile.User.setSelfLadderLevel(LadderGameOver["rank"])
	-- score int 当前天梯分
	profile.User.setSelfLadderScore(LadderGameOver["score"])
	-- nextScore int 下一等级的天梯分(升级积分)
	profile.User.setSelfLadderUpScore(LadderGameOver["nextScore"])
	--	-- salary int 工资
	--	LadderGameOver["salary"] = nMBaseMessage:readInt();
	--	LadderGameOver["notice1"] = nMBaseMessage:readString();
	--	LadderGameOver["notice2"] = nMBaseMessage:readString();
	--	--LadderRank	byte	升级或降级对应的天梯分	Loop
	--	LadderGameOver["LadderLevel"] = {}
	--	local LevelCnt = nMBaseMessage:readInt()
	--	for i = 1, LevelCnt do
	--		LadderGameOver["LadderLevel"][i] = {}
	--		local length = nMBaseMessage:readShort()
	--		local pos = nMBaseMessage:getReadPos()
	--		--…duan	int	段
	--		LadderGameOver["LadderLevel"][i].duan = nMBaseMessage:readInt();
	--		--…rank	Int	等级
	--		LadderGameOver["LadderLevel"][i].level = nMBaseMessage:readInt();
	--		--…score	int	分
	--		LadderGameOver["LadderLevel"][i].score = nMBaseMessage:readInt();
	--		nMBaseMessage:setReadPos(pos + length)
	--	end
	--InitScore	int	当前段初始天梯分(降级积分)
	profile.User.setSelfLadderDownScore(LadderGameOver["InitScore"])
	--	--round	Int	回合数
	--	LadderGameOver["round"] = nMBaseMessage:readInt();
	--	--IsReceiveLadder	Byte	是否领过工资	1没领过 0领过 2没有资格
	--	LadderGameOver["IsReceiveLadder"] = nMBaseMessage:readByte();
	--	--Maxduan	Int	历史最高段
	--	LadderGameOver["maxDuan"] = nMBaseMessage:readInt();
	--	--掉落物品列表
	--	LadderGameOver["prizes"] = {}
	--	local prizeNum = nMBaseMessage:readInt()
	--	for i = 1, prizeNum do
	--		LadderGameOver["prizes"][i] = {}
	--		local length = nMBaseMessage:readShort()
	--		local pos = nMBaseMessage:getReadPos()
	--		--…text	Text	掉落物品名称
	--		LadderGameOver["prizes"][i].name = nMBaseMessage:readString();
	--		--…url	text	掉落物品图片
	--		LadderGameOver["prizes"][i].url = nMBaseMessage:readString();
	--		--…count	Int	掉落数目
	--		LadderGameOver["prizes"][i].num = nMBaseMessage:readInt();
	--		nMBaseMessage:setReadPos(pos + length)
	--	end
	--	--tipPrizes	byte	下级奖励提示	Loop
	--	LadderGameOver["tipPrizes"] = {}
	--	local tipPrizeNum = nMBaseMessage:readInt()
	--	for i = 1, tipPrizeNum do
	--		LadderGameOver["tipPrizes"][i] = {}
	--		local length = nMBaseMessage:readShort()
	--		local pos = nMBaseMessage:getReadPos()
	--		--…text	Text	奖励物品名称
	--		LadderGameOver["tipPrizes"][i].name = loopTip.readString();
	--		--…url	text	奖励物品图片
	--		LadderGameOver["tipPrizes"][i].url = loopTip.readString();
	--		--…count	Int	奖励数目
	--		LadderGameOver["tipPrizes"][i].num = loopTip.readInt();
	--		nMBaseMessage:setReadPos(pos + length)
	--	end
	--	--boxIconUrl	text	升级宝箱图标url
	--	LadderGameOver["boxIconUrl"] = nMBaseMessage:readString();
	--	--MaxLevel	Int	历史最高等级（段*100+等级）
	--	LadderGameOver["maxLevel"] = nMBaseMessage:readInt();
	--
	--	--------------------------------------------------------------------
	--
	--		-- changeDuan byte 段改变情况 0 不变，1升级，-1降级
	--		changeDuan = helper.getByte();
	--		-- duan int 段位
	--		oldduan = User.Self.ladderDuan;
	--		User.Self.ladderDuan = helper.getInt();
	--		-- changeRank int 等级改变情况 0 不变，1升级，-1降级
	--		changeRank = helper.getByte();
	--		-- rank int 等级
	--		oldrank = User.Self.ladderLevel;
	--		User.Self.ladderLevel = helper.getInt();
	--		-- score int 当前天梯分
	--		oldscore = User.Self.ladderScore;
	--		User.Self.ladderScore = helper.getInt();
	--		-- nextScore int 下一等级的天梯分
	--		oldUpScore = User.Self.ladderUpScore;
	--		User.Self.ladderUpScore = helper.getInt();
	--		-- salary int 工资
	--		User.Self.salary = helper.getInt();
	--		-- needIdentificationCnt byte 升级段需要的认证符 Loop
	--		-- LoopMessageHelper loop = helper.getLoopMessageHelper();
	--		-- items.clear();
	--		-- while(loop.next()){
	--		-- Item tmp = new Item();
	--		-- -- …type text 类型 1.初级
	--		-- tmp.value = loop.getText();
	--		-- -- …value int 个数
	--		-- tmp.key = loop.getInt();
	--		-- items.add(tmp);
	--		-- }
	--		notice1 = helper.getText();
	--		notice2 = helper.getText();
	--		-- llvLadderLevelIcon.setLevel(oldduan, oldrank);
	--		LoopMessageHelper loopLevel = helper.getLoopMessageHelper();
	--		if (levelMap == null) {
	--			levelMap = new HashMap<Integer, Integer>();
	--		}
	--		while (loopLevel.next()) {
	--			int duan = loopLevel.getInt();
	--			int level = loopLevel.getInt();
	--			int score = loopLevel.getInt();
	--			levelMap.put(duan * 100 + level, score);
	--		}
	--		levelMap.put(User.Self.ladderDuan * 100 + User.Self.ladderLevel, User.Self.ladderUpScore);
	--		oldDownScore = User.Self.ladderDownScore;
	--		User.Self.ladderDownScore = helper.getInt();
	--		int downLevel = User.Self.ladderLevel - 1;
	--		int downDuan = User.Self.ladderDuan;
	--		if (downLevel < 1) {
	--			downDuan = downDuan - 1;
	--			if (downDuan > 0) {
	--				downLevel = 10;
	--				levelMap.put(downDuan * 100 + downLevel, User.Self.ladderDownScore);
	--			} else {
	--				downLevel = 0;
	--				downDuan = 1;
	--				levelMap.put(downDuan * 100 + downLevel, User.Self.ladderDownScore);
	--
	--			}
	--		} else {
	--			levelMap.put(downDuan * 100 + downLevel, User.Self.ladderDownScore);
	--
	--		}
	--		User.Self.round = helper.getInt();
	--		User.Self.salaried = helper.getByte();
	--		round = User.Self.round;
	--		maxDuan = helper.getInt();
	--		LoopMessageHelper loopAward = helper.getLoopMessageHelper();
	--		if (prize == null) {
	--			prize = new ArrayList<AwardInfo>();
	--		}
	--		prize.clear();
	--		while (loopAward.next()) {
	--			AwardInfo info = new AwardInfo();
	--			info.name = loopAward.getText();
	--			info.url = loopAward.getText();
	--			info.num = loopAward.getInt();
	--			prize.add(info);
	--		}
	--		LoopMessageHelper loopTip = helper.getLoopMessageHelper();
	--		if (tipPrize == null) {
	--			tipPrize = new ArrayList<AwardInfo>();
	--		}
	--		tipPrize.clear();
	--		while (loopTip.next()) {
	--			AwardInfo info = new AwardInfo();
	--			info.name = loopTip.getText();
	--			info.url = loopTip.getText();
	--			info.num = loopTip.getInt();
	--			tipPrize.add(info);
	--		}
	--		boxIconUrl = helper.getText();
	--		maxLevel = helper.getInt();
	--
	--		RemoteResMgr.requestRes(boxIconUrl, null, 0, true);
	--		Pub.LOG("boxIconUrl=" + boxIconUrl);
	--		boolean isShowResult = false;
	--		Pub.LOG("round++++++++++++++++++++++++" + round);
	--		-- if (changeDuan != 0 || round == 5) {
	--		if (changeDuan == 1 && User.Self.ladderDuan > maxDuan) {-- 升段要大于最大段
	--
	--			isShowResult = true;
	--		} else if (changeRank == 1) {-- 升级需要过到5或10
	--			if (User.Self.ladderLevel == 10 && maxLevel < User.Self.ladderDuan * 100 + User.Self.ladderLevel) {-- 正好升到10级
	--				isShowResult = true;
	--			} else if (User.Self.ladderLevel >= 5 && maxLevel % 100 < 5) {-- 升到5级以上
	--				isShowResult = true;
	--
	--			}
	--		}
	--		Pub.LOG("ladderNotice maxDuan=" + maxDuan + " maxLevel=" + maxLevel);
	--		return isShowResult;

	local duanwei = profile.User.getSelfLadderDuan()
	local level = profile.User.getSelfLadderLevel()
	local ttjf = profile.User.getSelfLadderScore() --天梯积分
	local nextttjf = profile.User.getSelfLadderUpScore() --下一级需要积分
	local lastttjf = profile.User.getSelfLadderDownScore() --降级需要积分
	local bl = 0
	if nextttjf - lastttjf > 0 then
		bl = (ttjf - lastttjf) / (nextttjf - lastttjf)
		if bl < 0 then
			bl = 0
		end
	end

	Common.log("lastttjf = "..lastttjf)
	Common.log("bl = "..bl)

	imgDuanwei:loadTexture(Common.getResourcePath(profile.TianTiData.getDuanWeiImage(duanwei)))
	atLblDuanwei:setStringValue(""..level)

	--LoadingBar_duanwei:setPercent(bl * 100)--天梯段位进度
	label_duanwei:setText(ttjf.."/"..nextttjf)--天梯段位进度数字说明

	myself_progress_value = bl * 100
end

--[[--
--更新用户信息
--]]
local function upDataPlayerData()
	print("upDataPlayerData")
	local self = gameResultPlayer[gameResultSelfIndex]
	--倍数  取消这个动画
	 la_multiple:setStringValue(TableConsole.getMultiple())
	 la_multiple:setScale(0)
	-- local scaleAction =  CCScaleTo:create(0.25, 1)
	-- local ease = CCEaseOut:create(scaleAction,0.8)
	-- local array = CCArray:create()
	-- if TableConsole.mode == TableConsole.MATCH then
	-- 	array:addObject(CCDelayTime:create(0.5))
	-- end
	-- array:addObject(ease)
	-- local seq = CCSequence:create(array)
	-- la_multiple:runAction(seq)

	--label_self_coin:setText(""..self.m_nChipCnt)

	if TableConsole.mode == TableConsole.ROOM then
		if self.m_nWinChip > 0 then
			isSelfShengli = true
		end
	else
		if self.m_nWinScoreCnt > 0 then
			isSelfShengli = true
		end
	end

	if isSelfShengli == true then
		--自己赢
		--imgWinBg:setVisible(true)
		imgLoseBg:setVisible(false)
		--iv_win_lose:loadTexture(Common.getResourcePath("iv_room_2level_settlement_win_title.png"));
		

		if (self.m_bIsLord) then
			--地主赢
			iv_gameResult:loadTexture(Common.getResourcePath("landlord_room_2level_settlement_win.png"));
		else
			--农民赢
			iv_gameResult:loadTexture(Common.getResourcePath("ic_room_2level_nongminshengli.png"));
		end
	else
		imgLoseBg:setVisible(true)
		--imgWinBg:setVisible(false)
		--iv_win_lose:loadTexture(Common.getResourcePath("iv_room_2level_settlement_failure_title.png"));

		if self.m_bIsLord then
			--地主输
			iv_gameResult:loadTexture(Common.getResourcePath("ic_room_2level_tiren.png"));
		else
			--农民输
			iv_gameResult:loadTexture(Common.getResourcePath("nongminshibai.png"));
		end
	end

	for i = 1, #gameResultPlayer do
		if (gameResultPlayer[i] ~= nil) then
			local p = gameResultPlayer[i]
			local name = "";
			--用户名
			if TableConsole.mode == TableConsole.MATCH then
				if (p.m_nPos == 1) then
					name = "下家";
				elseif (p.m_nPos == 2) then
					name = "上家";
				elseif (p.m_nPos == 0) then
					name = p.m_sNickName;
				end
			elseif TableConsole.mode == TableConsole.ROOM then
				if (p.m_sNickName ~= nil and p.m_sNickName ~= "") then
					name = p.m_sNickName;
				else
					if (p.m_nPos == 1) then
						name = "下家";
					elseif (p.m_nPos == 2) then
						name = "上家";
					elseif (p.m_nPos == 0) then
						name = p.m_sNickName;
					end
				end
			end

			if p.m_nPos + 1 ~= 1 then
				--不显示自己的昵称，只显示上下家的昵称
				label_player_name[p.m_nPos + 1]:setText(name)
			end

			if p.m_nPos ~= 0 then
				--只显示上下家的头像
				if p.m_bIsLord then
					iv_player_photo[p.m_nPos + 1]:loadTexture(Common.getResourcePath("jiesuan_dizhu.png"))
					iv_player_bg[p.m_nPos + 1]:loadTexture(Common.getResourcePath("dizhu_bg.png"))
				else
					iv_player_photo[p.m_nPos + 1]:loadTexture(Common.getResourcePath("jiesuan_nongmin.png"))
					iv_player_bg[p.m_nPos + 1]:loadTexture(Common.getResourcePath("bg_paihangbang_gonggao.png"))
				end
			end

			--输赢结算
			local isShengli = false
			if TableConsole.mode == TableConsole.ROOM then
				if p.m_nWinChip > 0 then
					isShengli = true
				end
			else
				if p.m_nWinScoreCnt > 0 then
					isShengli = true
				end
			end

			if isShengli == true then
				--用户胜利
				if p.m_nPos + 1 == 1 then
					--只显示自己胜利的图片
					--iv_player_win_loss[p.m_nPos + 1]:loadTexture(Common.getResourcePath("iv_room_2level_settlement_win_title.png"));
				end
				
				if (TableConsole.mode == TableConsole.ROOM) then
					if p.m_nPos + 1 ~= 1 then
						label_player_add_coin[p.m_nPos + 1]:setText("金币+" .. p.m_nWinChip);
					end

					myself_money_value = p.m_nWinChip

				elseif (TableConsole.mode == TableConsole.MATCH) then
					if p.m_nPos + 1 == 1 then
						--只显示自己的积分
						label_player_add_integral[p.m_nPos + 1]:setText("积分+" .. p.m_nWinScoreCnt);
					end
          			if p.m_nPos + 1 ~= 1 then
          				label_player_add_coin[p.m_nPos + 1]:setText("金币+" .. p.m_nWinChip);
          			else
          				myself_money_value = p.m_nWinChip
          			end

				end

				if (TableConsole.mode == TableConsole.ROOM) then
					--金币加成
					if VIPPub.getUserVipType(p.mnVipLevel) == VIPPub.VIP_PAST or
						VIPPub.getUserVipType(p.mnVipLevel) == VIPPub.VIP_NO or
						VIPPub.getUserVipType(p.mnVipLevel) == VIPPub.VIP_1 or
						VIPPub.getUserVipType(p.mnVipLevel) == VIPPub.VIP_2 then
						--不加成
						iv_player_coin_add[p.m_nPos + 1]:setVisible(false);
					elseif VIPPub.getUserVipType(p.mnVipLevel) == VIPPub.VIP_3 or
						VIPPub.getUserVipType(p.mnVipLevel) == VIPPub.VIP_4 or
						VIPPub.getUserVipType(p.mnVipLevel) == VIPPub.VIP_5 or
						VIPPub.getUserVipType(p.mnVipLevel) == VIPPub.VIP_6 or
						VIPPub.getUserVipType(p.mnVipLevel) == VIPPub.VIP_7 or
						VIPPub.getUserVipType(p.mnVipLevel) == VIPPub.VIP_8 or
						VIPPub.getUserVipType(p.mnVipLevel) == VIPPub.VIP_9 then
						--金币加成  需要做个动作
						iv_player_coin_add[p.m_nPos + 1]:setVisible(true);

-----------------------------------------------------------
					 	iv_player_coin_add[p.m_nPos + 1]:setVisible(false) --先隐藏
					 	iv_player_coin_add[p.m_nPos + 1]:setScale(2)

						local function nongminWinCallback(node)
							node:setVisible(true)
 							node:stopAllActions();

 							local array = CCArray:create()
							array:addObject(CCScaleTo:create(0.08, 0.6))
							array:addObject(CCScaleTo:create(0.04, 1))
							local seq = CCSequence:create(array)

 							node:runAction(seq)
						end
						local array = CCArray:create()
						array:addObject(CCDelayTime:create(2))  
						array:addObject(CCCallFuncN:create(nongminWinCallback))
						local seq = CCSequence:create(array)
						iv_player_coin_add[p.m_nPos + 1]:runAction(seq)  
-----------------------------------------------------------
					end
				else
					iv_player_coin_add[p.m_nPos + 1]:setVisible(false);
				end
			else
				--用户失败
				if p.m_nPos + 1 == 1 then
					--只显示自己失败的图片
					--iv_player_win_loss[p.m_nPos + 1]:loadTexture(Common.getResourcePath("iv_room_2level_settlement_failure_title.png"));
				end
				
				if (TableConsole.mode == TableConsole.ROOM) then
						label_player_add_coin[p.m_nPos + 1]:setText("金币" .. p.m_nWinChip);

					
					if tonumber(p.m_nCoin) <= 1 then
						iv_player_playout[p.m_nPos + 1]:setVisible(true);

-----------------------------------------------------------
					 	iv_player_playout[p.m_nPos + 1]:setVisible(false) --先隐藏
					 	iv_player_playout[p.m_nPos + 1]:setScale(2)

						local function nongminWinCallback(node)
							node:setVisible(true)
 							node:stopAllActions();
 							
 							local array = CCArray:create()
							array:addObject(CCScaleTo:create(0.08, 0.6))
							array:addObject(CCScaleTo:create(0.04, 1))
							local seq = CCSequence:create(array)

 							node:runAction(seq)
						end
						local array = CCArray:create()
						array:addObject(CCDelayTime:create(2))  
						array:addObject(CCCallFuncN:create(nongminWinCallback))
						local seq = CCSequence:create(array)
						iv_player_playout[p.m_nPos + 1]:runAction(seq)  
-----------------------------------------------------------

					else
						iv_player_playout[p.m_nPos + 1]:setVisible(false);
					end
				elseif TableConsole.mode == TableConsole.MATCH then
					if p.m_nPos + 1 == 1 then
						--只显示自己的积分
						label_player_add_integral[p.m_nPos + 1]:setText("积分" .. p.m_nWinScoreCnt);
					end
          			
          			label_player_add_coin[p.m_nPos + 1]:setText("金币" .. p.m_nWinChip);
				end
				iv_player_coin_add[p.m_nPos + 1]:setVisible(false);
			end

			local vipLvl = VIPPub.getUserVipType(p.mnVipLevel) -- 解析成1位数的VIP等级
			Common.log("upDataPlayerData vipLvl = "..vipLvl)
			if tonumber(vipLvl) > 0 then
				if p.m_nPos + 1 ~= 1 then
					--不处理自己VIP等级图片
					la_player_vip_level[p.m_nPos + 1]:setStringValue(VIPPub.getUserVipType(p.mnVipLevel));
				end
				
				if p.m_nPos + 1 == 1 then
					--label_player_name[p.m_nPos + 1]:setPosition(ccp(-296, 65))
				elseif p.m_nPos + 1 == 2 then
					--label_player_name[p.m_nPos + 1]:setPosition(ccp(-25, 42))
				elseif p.m_nPos + 1 == 3 then
					--label_player_name[p.m_nPos + 1]:setPosition(ccp(-30, 42))
				end
			else
				--隐藏VIP信息
				if p.m_nPos + 1 ~= 1 then
					--不处理自己VIP等级图片
					iv_player_vip_level[p.m_nPos + 1]:setVisible(false);
					la_player_vip_level[p.m_nPos + 1]:setVisible(false);
				end
				
				if p.m_nPos + 1 == 1 then
					--label_player_name[p.m_nPos + 1]:setPosition(ccp(-296 - 50, 65))
				elseif p.m_nPos + 1 == 2 then
					--label_player_name[p.m_nPos + 1]:setPosition(ccp(-30 - 50, 42))
				elseif p.m_nPos + 1 == 3 then
					--label_player_name[p.m_nPos + 1]:setPosition(ccp(-30 - 50, 42))
				end
			end
		end
	end
end

local function initView()
	image_star[1] = cocostudio.getUIImageView(view, "Image_45_0");
	image_star[2] = cocostudio.getUIImageView(view, "Image_45_1");
	image_star[3] = cocostudio.getUIImageView(view, "Image_45_2");
	image_star[4] = cocostudio.getUIImageView(view, "Image_45_2_3");
	image_star[5] = cocostudio.getUIImageView(view, "Image_45_2_4");
	Image_58 = cocostudio.getUIImageView(view, "Image_58");--背景小鬼
	ImageView_Background = cocostudio.getUIImageView(view, "Panel_55");
	Button_close = cocostudio.getUIButton(view, "Button_close")
	iv_gameResult = cocostudio.getUIImageView(view, "iv_gameResult")
	--iv_win_lose = cocostudio.getUIImageView(view, "iv_win_lose")
	la_multiple = cocostudio.getUILabelAtlas(view, "la_multiple")--倍数
	la_multipleImage = cocostudio.getUIImageView(view, "ImageView_37"); 
	la_multipleImage:setScale(0)
	Image_WinLight = cocostudio.getUIImageView(view, "Image_43"); 
	Image_self_money_bg = cocostudio.getUIImageView(view, "Image_48_0");
	--个人特性
	label_coin_name = cocostudio.getUILabel(view, "label_coin_name")
	--label_duanwei_name = cocostudio.getUILabel(view, "label_duanwei_name")
	--label_self_coin = cocostudio.getUILabel(view, "label_self_coin")

	imgDuanwei = cocostudio.getUIImageView(view, "Image_53")
	atLblDuanwei = cocostudio.getUILabelAtlas(view, "AtlasLabel_55")
	label_duanwei = cocostudio.getUILabel(view, "label_duanwei")
	LoadingBar_duanwei = cocostudio.getUILoadingBar(view, "LoadingBar_duanwei")
	LoadingBar_duanwei:setPercent(0)

	ImageView_70_0 = cocostudio.getUIImageView(view, "ImageView_70_0")

	imgWinBg = cocostudio.getUIImageView(view, "Panel_56") --胜利的背景
	imgLoseBg = cocostudio.getUIPanel(view, "Panel_57") --失败的背景

	--输赢标签
	iv_player_win_loss[1] = cocostudio.getUIImageView(view, "iv_win_lose")
	--iv_player_win_loss[2] = cocostudio.getUIImageView(view, "iv_right_win_loss")
	--iv_player_win_loss[3] = cocostudio.getUIImageView(view, "iv_left_win_loss")
	--用户名
	--label_player_name[1] = cocostudio.getUILabel(view, "label_self_name")
	label_player_name[2] = cocostudio.getUILabel(view, "label_right_name")
	label_player_name[3] = cocostudio.getUILabel(view, "label_left_name")
	--用户头像
	--iv_player_photo[1] = cocostudio.getUIImageView(view, "iv_self_photo")--自己的头像
	iv_player_photo[2] = cocostudio.getUIImageView(view, "Image_41")--下家的头像
	iv_player_photo[3] = cocostudio.getUIImageView(view, "Image_39")--上家的头像

	iv_player_bg[2] = cocostudio.getUIImageView(view, "Image_40") --下家
	iv_player_bg[3] = cocostudio.getUIImageView(view, "Image_38") --上家

	--VIP标签
	--iv_player_vip_level[1] = cocostudio.getUIImageView(view, "iv_vip_level")--自己的VIP标签
	iv_player_vip_level[2] = cocostudio.getUIImageView(view, "iv_vip_level_right")--下家的VIP标签
	iv_player_vip_level[3] = cocostudio.getUIImageView(view, "iv_vip_level_left")--上家的VIP标签
	--VIP等级
	--la_player_vip_level[1] = cocostudio.getUILabelAtlas(view, "la_vip_level")--自己的VIP等级
	la_player_vip_level[2] = cocostudio.getUILabelAtlas(view, "la_vip_level_right")--下家的VIP等级
	la_player_vip_level[3] = cocostudio.getUILabelAtlas(view, "la_vip_level_left")--上家的VIP等级
	--本局金币加减
	label_player_add_coin[1] = cocostudio.getUILabel(view, "label_self_add_coin")--自己本局金币加减
	label_player_add_coin[2] = cocostudio.getUILabel(view, "label_right_add_coin")--下家本局金币加减
	label_player_add_coin[3] = cocostudio.getUILabel(view, "label_left_add_coin")--上家本局金币加减
  	--本局积分加减
  	label_player_add_integral[1] = cocostudio.getUILabel(view, "label_self_add_coin_0")--自己本局积分加减
  	--label_player_add_integral[2] = cocostudio.getUILabel(view, "label_right_add_coin_0")--自己本局积分加减
  	--label_player_add_integral[3] = cocostudio.getUILabel(view, "label_left_add_coin_0")--自己本局积分加减

  	imgJifenPanel = cocostudio.getUIImageView(view, "Image_71")

	bar_win_progess = cocostudio.getUILoadingBar(view, "iv_win"); --胜利进度条
	bar_lose_progress = cocostudio.getUILoadingBar(view, "iv_lose");--失败进度条


	--金币加成标签
	iv_player_coin_add[1] = cocostudio.getUIImageView(view, "iv_coin_add")--自己金币加成标签
	iv_player_coin_add[2] = cocostudio.getUIImageView(view, "iv_right_add_coin")--下家金币加成标签
	iv_player_coin_add[3] = cocostudio.getUIImageView(view, "iv_left_add_coin")--上家金币加成标签
	--用户输光标签
	iv_player_playout[1] = cocostudio.getUIImageView(view, "Image_playout_self")--自己金币加成标签
	iv_player_playout[2] = cocostudio.getUIImageView(view, "Image_playout_right")--下家金币加成标签
	iv_player_playout[3] = cocostudio.getUIImageView(view, "Image_playout_left")--上家金币加成标签

	iv_player_playout[1]:setVisible(false);
	iv_player_playout[2]:setVisible(false);
	iv_player_playout[3]:setVisible(false);

	upDataPlayerData();

	playLoseHeadImageAnimation()--失败笑脸动画 


	if TableConsole.mode == TableConsole.ROOM then
		Common.setButtonVisible(Button_close, true);
		setShowLadderData(true);
		upDataLadderData();
	elseif TableConsole.mode == TableConsole.MATCH then
		Common.setButtonVisible(Button_close, false);
		setShowLadderData(false);
	end

	label_player_add_coin[1]:setText("金币+" .. 0);

	if TableConsole.mode == TableConsole.ROOM then
		-- 在房间中

		-- 隐藏积分显示
		imgJifenPanel:setVisible(false)
		--label_player_add_integral[1]:setVisible(false)
		--label_player_add_integral[2]:setVisible(false)
		--label_player_add_integral[3]:setVisible(false)

		-- 将金币的label显示在积分的位置上
		--label_player_add_coin[1]:setPosition(label_player_add_integral[1]:getPosition())
		--label_player_add_coin[2]:setPosition(label_player_add_integral[2]:getPosition())
		--label_player_add_coin[3]:setPosition(label_player_add_integral[3]:getPosition())
	end

	--[[
	touchLayer = CCLayer:create()
	view:addChild(touchLayer)
	touchLayer:setTouchPriority(-99999)
	touchLayer:registerScriptTouchHandler(closeView, false, -99999, true)
	touchLayer:setTouchEnabled(true)
	]]


end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("GameResult.json")
	local gui = GUI_TABLE_GAME_RESULT
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

	

	initView()

	if TableConsole.mode == TableConsole.MATCH then
		local delay = CCDelayTime:create(4)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(CCCallFuncN:create(closeView))
		local seq = CCSequence:create(array)
		view:runAction(seq)
	end

	initState() --初始化控件状态
	--playAnimation();--开始播放动画
	
end

--初始化控件状态
function initState()
	Image_58:setVisible(false);--背景小鬼
	Image_self_money_bg:setVisible(false)--自己金币的背景
	ImageView_70_0:setVisible(false)--进度条背景

	imgWinBg:setVisible(false);--星星的背景
	for i=1, #image_star do
		image_star[i]:setVisible(false)
	end

	--bar_win_progess:setVisible(false)
	--bar_lose_progress:setVisible(false)
end

--播放动画
function playAnimation()
    ImageView_Background:setScale(0)

    --打开动画
	local scaleAction =  CCScaleTo:create(1.2, 1)
	local ease = CCEaseOut:create(scaleAction, 0.8)
	local array = CCArray:create()
    array:addObject(CCDelayTime:create(0))
	array:addObject(ease)
	local seq = CCSequence:create(array)
	ImageView_Background:runAction(seq)
end

--失败笑脸动画
function playLoseHeadImageAnimation()
	local self = gameResultPlayer[gameResultSelfIndex]
	
	-- if TableConsole.mode == TableConsole.ROOM then
	-- 	if self.m_nWinChip > 0 then
	-- 		isSelfShengli = true
	-- 	end
	-- else
	-- 	if self.m_nWinScoreCnt > 0 then
	-- 		isSelfShengli = true
	-- 	end
	-- end

	if isSelfShengli == false then  --如果失败背景
		Image_WinLight:loadTexture(Common.getResourcePath("bg_yinying.png"))
	end

	bar_win_progess:setVisible(false)
	bar_lose_progress:setVisible(false)


 	iv_gameResult:setVisible(false) --人物先隐藏
 	iv_gameResult:setScale(2)

 	--iv_win_lose:setVisible(false) --胜利的牌子
 	
 	if isSelfShengli == true then
 		print("自己赢了得分"..myself_money_value)
 	else
 		print("自己输了得分"..myself_money_value)
 	end
	

 	local function lightCallback(node)--光从小到大后
	    node:stopAllActions() 
	   -- node:runAction(CCRepeatForever:create(CCRotateBy:create(5,360)))
	   	iv_gameResult:setVisible(true) --人物显示出来iv_gameResult

	   	if isSelfShengli == true then   
			playWinStarAnimation() --赢了星星背景动作
		end
	   

	   	local function nongminWinCallback(node)
	   		--播放牌子进度动画
			
			--
			if isSelfShengli == false then  --如果胜利显示小鬼
				Image_58:setVisible(true);--背景小鬼
				ivLoseAnimation()  
			else
				ivWinAnimation()
			end

			playScoreAnimation();--得分，倍数动作
		end
		local array = CCArray:create()
		array:addObject(CCScaleTo:create(0.2, 1))
		array:addObject(CCCallFuncN:create(nongminWinCallback))
		local seq = CCSequence:create(array)
		iv_gameResult:runAction(seq) --人物从大到小
	end

	--高光动作
	Image_WinLight:setVisible(true)
	Image_WinLight:setScale(0)
	 
	local scaleAction =  CCScaleTo:create(0.17, 1.3)
	local ease = CCEaseOut:create(scaleAction, 0.8)

	local scaleAction1 =  CCScaleTo:create(0.08, 1)
	local ease1 = CCEaseOut:create(scaleAction1, 0.8)

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0))
	array:addObject(ease)
	array:addObject(ease1)
	array:addObject(CCCallFuncN:create(lightCallback))
	local seq = CCSequence:create(array)
	Image_WinLight:runAction(seq)--高光动作
end

--赢了星星背景动作
function playWinStarAnimation()
	imgWinBg:setVisible(true);--星星的背景
	local fValue = 0.1
	for i=1, #image_star do
		fValue = fValue + 0.1
		image_star[i]:setVisible(false)

		local function CallWinStarCallback(node)
			node:setVisible(true)
		end

		local array = CCArray:create()
		array:addObject(CCDelayTime:create(fValue))
		array:addObject(CCCallFuncN:create(CallWinStarCallback))
		local seq = CCSequence:create(array)
		image_star[i]:runAction(seq)
	end
end

local function updateCurrentTimeOnTitle()
	if isSelfShengli == false then
		label_player_add_coin[1]:setText("金币-" .. myself_money_value);
 		--关闭计时器
	 	if updateTimeScheduler then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(updateTimeScheduler)
			updateTimeScheduler = nil
		end
		return
	end



	if myself_money_value > 100000 then
		myself_money_setp = myself_money_setp + 5000
	elseif myself_money_value > 10000 then
		myself_money_setp = myself_money_setp + 500
	elseif myself_money_value > 1000 then
		myself_money_setp = myself_money_setp + 60
	elseif myself_money_value > 100 then
		myself_money_setp = myself_money_setp + 20
	else
		myself_money_setp = myself_money_setp + 1
	end

 	label_player_add_coin[1]:setText("金币+" .. myself_money_setp);

 	if myself_money_setp >= myself_money_value then
 		 --关闭计时器
	 	if updateTimeScheduler then
	 		label_player_add_coin[1]:setText("金币+" .. myself_money_value);
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(updateTimeScheduler)
			updateTimeScheduler = nil
		end
 	end
end

--得分，倍数动作
function playScoreAnimation()
	--回调里处理得分条的移动
	local function playMoneyCallback(node)
		--自己金币的背景
		Image_self_money_bg:setVisible(true);
		Image_self_money_bg:setPosition(ccp(Image_self_money_bg:getPosition().x + 250, Image_self_money_bg:getPosition().y))
		
		--进度条动作播放完毕回调
		local function scoreCallback(node)
			 --在回调里滚动得分
			if not updateTimeScheduler then
				updateTimeScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateCurrentTimeOnTitle, 0.0001, false)
			end
			 -------------
		end

		local moveby = CCMoveBy:create(0.08, ccp(-275, 0))
		local array = CCArray:create()
		array:addObject(CCEaseOut:create(moveby, 0.8))
		array:addObject(CCMoveBy:create(0.04, ccp(25, 0)))
		array:addObject(CCCallFuncN:create(scoreCallback))
		local seq = CCSequence:create(array)
		Image_self_money_bg:runAction(seq)

		-- --进度条动作
		 playProgressBarAnimation()
	end

	local scaleAction =  CCScaleTo:create(0.17, 1.4)
	local scaleAction1 =  CCScaleTo:create(0.08, 0.8)
	local scaleAction2 =  CCScaleTo:create(0.08, 1)

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.5))
	array:addObject(scaleAction)
	array:addObject(scaleAction1)
	array:addObject(scaleAction2)
	array:addObject(CCCallFuncN:create(playMoneyCallback))
	local seq = CCSequence:create(array)

	la_multiple:setVisible(true)--倍数
	la_multiple:setScale(0)
	la_multiple:runAction(seq)

	local array1 = CCArray:create()
	array1:addObject(CCDelayTime:create(0.5))
	array1:addObject(CCScaleTo:create(0.25, 1))
	la_multipleImage:runAction(CCSequence:create(array1))

	-- Image_Beishu:setVisible(true)--倍数
	-- Image_Beishu:setScale(0)
	-- Image_Beishu:runAction(CCScaleTo:create(0.25, 1))

end





function playProgressBarAnimation()
	--进度条背景
	ImageView_70_0:setPosition(ccp(ImageView_70_0:getPosition().x + 250, ImageView_70_0:getPosition().y-20))
	
	--进度条延迟后回调
	local function delayProgressCallback(node)
		node:setVisible(true);
	end

	--进度条动作播放完毕回调
	local function playProgressCallback(node)
		--进度条动作播放完毕
 		--playVipAddAnimation()

 		if isSelfShengli == false then
 			LoadingBar_duanwei:setPercent(myself_progress_value)--天梯段位进度
 		else
 			local fValue = 0 
			local nodeTime = 0
			for i=1, myself_progress_value do
				local function CallWinStarCallback(node)
					LoadingBar_duanwei:setPercent(i)
				end
				local array = CCArray:create()
				array:addObject(CCDelayTime:create(fValue))
				array:addObject(CCCallFuncN:create(CallWinStarCallback))
				local seq = CCSequence:create(array)
				iv_player_vip_level[2]:runAction(seq)

				fValue = fValue + 0.005
			end
 		end
	end

	local moveby = CCMoveBy:create(0.08, ccp(-275, 0))
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.19))
	array:addObject(CCCallFuncN:create(delayProgressCallback))
	array:addObject(CCEaseOut:create(moveby, 0.8))
	array:addObject(CCMoveBy:create(0.04, ccp(25, 0)))
	array:addObject(CCCallFuncN:create(playProgressCallback))
	local seq = CCSequence:create(array)
	ImageView_70_0:runAction(seq)
end

--是否输光了，是否需要加成
function playVipAddAnimation()
 
end

--胜利的牌子进度动作
function ivWinAnimation()
	bar_win_progess:setVisible(true)
	bar_win_progess:setPercent(0)
	local fValue = 0 
	local nodeTime = 0
	for i=1, 100 do
		local function CallWinStarCallback(node)
			bar_win_progess:setPercent(i)
		end

		print("fValue"..fValue)
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(fValue))
		array:addObject(CCCallFuncN:create(CallWinStarCallback))
		local seq = CCSequence:create(array)
		iv_player_vip_level[2]:runAction(seq)

		fValue = fValue + 0.005
	end
 
end

--失败的牌子进度动作
function ivLoseAnimation()
	bar_lose_progress:setVisible(true)
	bar_lose_progress:setPercent(0)
	local fValue = 0 
	local nodeTime = 0
	for i=1, 100 do
		local function CallWinStarCallback(node)
			bar_lose_progress:setPercent(i)
		end

		print("fValue"..fValue)
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(fValue))
		array:addObject(CCCallFuncN:create(CallWinStarCallback))
		local seq = CCSequence:create(array)
		iv_player_vip_level[2]:runAction(seq)

		fValue = fValue + 0.005
	end
end

--[[--
--设置牌局用户数据
--]]
function setGameResultPlayer(Players, selfIndex)
	gameResultPlayer = Common.copyTab(Players);
	gameResultSelfIndex = selfIndex;
end

function requestMsg()

end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		closeView()
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_panel_20(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		closeView()
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
end

function removeSlot()
	if TableConsole.mode == TableConsole.MATCH then
		--是比赛恢复消息接收
		Common.log("比赛模式下结算界面 RESUME");
		TableConsole.setStatus(TableConsole.STAT_WAITING_TABLE);
		ResumeSocket("readGameResult");

		-- 发送比赛等待分桌请求
		Common.log("TableConsole.m_sMatchInstanceID = "..TableConsole.m_sMatchInstanceID);
		sendMATID_V4_WAITING(TableConsole.m_sMatchInstanceID)
	end
end
