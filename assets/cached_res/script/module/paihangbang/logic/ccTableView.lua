-----自定制控件tableView
--[[-----以下是开发者必须实现的方法------
tableView.numberOfrow()--返回行数
tableView.HeightOfCellAtNumberOfRow(i)--返回每行的高度
tableView.CellOfAtNumberOfRow(cell,i)--对cell进行布置
--此外：tableView:setDirection(kCCScrollViewDirectionHorizontal)设置滚动放向,默认是竖直方向
-- 设置分割线: tableView.SeparatorWidth = 2
-- 设置弹性:tableView:setBounceable(true)
--]]
winSize = CCDirector:sharedDirector():getWinSize();

ccTableView = {}

------tableView构造函数---------
function ccTableView.create(scrollSize)
	local tableView = CCScrollView:create(scrollSize)
	tableView.SeparatorWidth = 2
	tableView:ignoreAnchorPointForPosition(false)
	tableView:setBounceable(true)
	tableView:setDirection(kCCScrollViewDirectionVertical)
	tableView:setTouchPriority(-9999)
	return tableView
end

function ccTableView.reloadData(tableView)

	local rowHeight = 40
	local numberOfrow = 0
	local tableViewSize = tableView:boundingBox().size

	if(tableView.numberOfrow() > 0)then
		numberOfrow = tableView.numberOfrow()
	else
		return
	end
	local container = tableView:getChildren():objectAtIndex(0)
	tolua.cast(container,"CCLayer")
	container:removeAllChildrenWithCleanup(true)

	local TheLastCell = nil
	if(tableView:getDirection() == kCCScrollViewDirectionVertical)then
		for i = 1,numberOfrow do
			rowHeight = tableView.HeightOfCellAtNumberOfRow(i)
			local cell = CCLayerColor:create(ccc4(0,0,0,255),tableViewSize.width,rowHeight)
			tableView.CellOfAtNumberOfRow(cell,i)
			if(TheLastCell ~= nil)then
				cell:setPosition(0,TheLastCell:getPositionY()+ TheLastCell:getContentSize().height+tableView.SeparatorWidth)
			else
				cell:setPosition(0,0)
			end
			tableView:addChild(cell)
			TheLastCell = cell
			if(TheLastCell:getPositionY()+ TheLastCell:getContentSize().height+tableView.SeparatorWidth > tableView:getContentSize().height)then
				tableView:setContentSize(CCSize(tableViewSize.width,TheLastCell:getPositionY()+ TheLastCell:getContentSize().height+tableView.SeparatorWidth))
			else
				tableView:setContentSize(CCSize(tableViewSize.width,tableViewSize.height ))
			end
		end

		if(TheLastCell:getPositionY()+ TheLastCell:getContentSize().height+tableView.SeparatorWidth < tableViewSize.height)then
			local childArray = container:getChildren()
			for i = 0,childArray:count() - 1 do
				local child = childArray:objectAtIndex(i)
				child:setPositionY(child:getPositionY() + (tableViewSize.height - TheLastCell:getPositionY()- TheLastCell:getContentSize().height-tableView.SeparatorWidth))
			end
		end

		tableView:setContentOffset(ccp(0,-tableView:getContentSize().height+tableViewSize.height))
	else
		for i = 1,numberOfrow do
			rowHeight = tableView.HeightOfCellAtNumberOfRow(i)
			local cell = CCLayerColor:create(ccc4(0,0,0,255),rowHeight,tableViewSize.height)
			tableView.CellOfAtNumberOfRow(cell,i)
			if(TheLastCell ~= nil)then
				cell:setPosition(TheLastCell:getPositionX()+ TheLastCell:getContentSize().width+tableView.SeparatorWidth,0)
			else
				cell:setPosition(30,0)
			end
			tableView:addChild(cell)
			TheLastCell = cell
			if(TheLastCell:getPositionX()+ TheLastCell:getContentSize().width+tableView.SeparatorWidth + 30> tableViewSize.width )then
				tableView:setContentSize(CCSize(TheLastCell:getPositionX()+ TheLastCell:getContentSize().width+tableView.SeparatorWidth + 30,tableViewSize.height))
			else
				tableView:setContentSize(CCSize(tableViewSize.width,tableViewSize.height))
			end
		end
		tableView:setContentOffset(ccp(0,0))

	end

	local function jianceSpeed(senter)

		if(tableView:isDragging() and tableView:getDirection() == kCCScrollViewDirectionVertical and tableView:getContentOffset().y > tableViewSize.height/4)then

			tableView:setContentOffset(ccp(0,tableViewSize.height/4))
		elseif(tableView:isDragging() and tableView:getDirection() == kCCScrollViewDirectionVertical and tableView:getContentOffset().y < -tableView:getContentSize().height+tableViewSize.height - tableViewSize.height/4)then

			tableView:setContentOffset(ccp(0,-tableView:getContentSize().height+tableViewSize.height - tableViewSize.height/4))

		elseif(tableView:isDragging() and tableView:getDirection() == kCCScrollViewDirectionHorizontal and tableView:getContentOffset().x > tableViewSize.width/4)then

			tableView:setContentOffset(ccp(tableViewSize.width/4,0))
		elseif(tableView:isDragging() and tableView:getDirection() == kCCScrollViewDirectionHorizontal and tableView:getContentOffset().x < -tableView:getContentSize().width+tableViewSize.width - tableViewSize.width/4)then

			tableView:setContentOffset(ccp(-tableView:getContentSize().width+tableViewSize.width - tableViewSize.width/4,0))
		end

		tableView.isMoved = tableView:isTouchMoved()
	end

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.5))
	array:addObject(CCCallFuncN:create(function ()
		tableView:stopAllActions()
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(0.01))
		array:addObject(CCCallFuncN:create(jianceSpeed))
		tableView:runAction(CCRepeatForever:create(CCSequence:create(array)))
	end))
	tableView:runAction(CCSequence:create(array))
end




