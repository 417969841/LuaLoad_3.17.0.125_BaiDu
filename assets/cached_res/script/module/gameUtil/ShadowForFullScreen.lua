module("ShadowForFullScreen", package.seeall)

--[[--
--创建蒙灰图层
--@param #number centreX 中心发光图的左下的X坐标
--@param #number centreY 中心发光图的左下的Y坐标
--@param #number centreW 中心发光图的宽
--@param #number centreH 中心发光图的高
--]]
function createShadowForFullScreenUIImageView(centreX, centreY, centreW, centreH)
	local FullScreenW = 1136;
	local FullScreenH = 640;
	local layout = ccs.panel({
		scale9 = false,
		size = CCSizeMake(FullScreenW, FullScreenH),
		image = "",
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	--layout:setAnchorPoint(ccp(0.5,0.5))

	local shadowCentre = ccs.image({
		scale9 = false,
		size = CCSizeMake(centreW, centreH),
		image = Common.getResourcePath("shadow_centre.png"),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	--shadowCentre:setScale9Enabled(true);
	shadowCentre:setAnchorPoint(ccp(0, 0));
	shadowCentre:setTouchEnabled(false);
	shadowCentre:setScaleX(centreW / 64);
	shadowCentre:setScaleY(centreH / 64);

	local shadowMarginDown = ccs.panel({
		scale9 = true,
		size = CCSizeMake(FullScreenW, centreY),
		image = Common.getResourcePath("shadow_margin.png"),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	--shadowMarginDown:setScale9Enabled(true);
	shadowMarginDown:setAnchorPoint(ccp(0, 0));
	shadowMarginDown:setTouchEnabled(false);

	local shadowMarginTop = ccs.panel({
		scale9 = true,
		size = CCSizeMake(FullScreenW, FullScreenH - centreY - centreH),
		image = Common.getResourcePath("shadow_margin.png"),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	--shadowMarginTop:setScale9Enabled(true);
	shadowMarginTop:setAnchorPoint(ccp(0, 0));
	shadowMarginTop:setTouchEnabled(false);

	local shadowMarginLeft = ccs.panel({
		scale9 = true,
		size = CCSizeMake(centreX, centreH),
		image = Common.getResourcePath("shadow_margin.png"),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	--shadowMarginLeft:setScale9Enabled(true);
	shadowMarginLeft:setAnchorPoint(ccp(0, 0));
	shadowMarginLeft:setTouchEnabled(false);

	local shadowMarginRight = ccs.panel({
		scale9 = true,
		size = CCSizeMake(FullScreenW - centreX - centreW, centreH),
		image = Common.getResourcePath("shadow_margin.png"),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	--shadowMarginRight:setScale9Enabled(true);
	shadowMarginRight:setAnchorPoint(ccp(0, 0));
	shadowMarginRight:setTouchEnabled(false);

	SET_POS(shadowCentre, centreX, centreY);
	SET_POS(shadowMarginDown, 0, 0);
	SET_POS(shadowMarginTop, 0, centreY + centreH);
	SET_POS(shadowMarginLeft, 0, centreY);
	SET_POS(shadowMarginRight, centreX + centreW, centreY);
	SET_POS(layout, 0, 0);

	layout:addChild(shadowCentre);
	layout:addChild(shadowMarginDown);
	layout:addChild(shadowMarginTop);
	layout:addChild(shadowMarginLeft);
	layout:addChild(shadowMarginRight);
	layout:setTouchEnabled(false);

	return layout;
end