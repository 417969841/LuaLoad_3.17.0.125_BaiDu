module("FontStyle", package.seeall)

--    --创建个背景
--    CCLayerColor* whiteLayer = CCLayerColor:create(ccc4(0, 205, 205, 255), size.width, size.height);
--    this:addChild(whiteLayer);
--
--    --创建描边
--    local outline = textAddStroke("描边 Stroke", "Arial", 40, ccWHITE, 1);
--    outline:setPosition(ccp(size.width*0.5, size.height*0.7));
--    this:addChild(outline);
--
--    --创建阴影
--    local shadow = textAddShadow("阴影 Shadow", "Arial", 40, ccWHITE, 2, 200);
--    shadow:setPosition(ccp(size.width*0.5, size.height*0.5));
--    this:addChild(shadow);
--
--    --创建描边加阴影
--    local outlineShadow = textAddOutlineAndShadow("描边加阴影 OutlineShadow", "Arial", 40, ccWHITE, 1, 4, 200);
--    outlineShadow:setPosition(ccp(size.width*0.5, size.height*0.3));
--    this:addChild(outlineShadow);

--[[--
UILabel制作文字描边效
--@param #CCLabelTTF center 中心文本(可以传nil)
--@param #string string 文本
--@param #string fontName   文本字体类型
--@param #number fontSize   文本大小
--@param #number centerColor  文本中心颜色
--@param #number marginColor  文本边缘颜色
--@param #number lineWidth  所描边的宽度
--]]
function UILabelAddStroke(label, string, fontSize, centerColor, marginColor, lineWidth)
	local center = label
	--正文UILabel
	if center == nil then
		center = ccs.label({
			text = string,
			color = centerColor,
		})
		center:setFontSize(fontSize)
		center:setTextHorizontalAlignment(1)
		center:setTextVerticalAlignment(1)
	end
	--描边UILabel 上
	local up = ccs.label({
		text = string,
		color = marginColor,
	})
	up:setFontSize(fontSize)
	up:setPosition(ccp(0, 0+lineWidth));
	up:setZOrder(-1)
	up:setTextHorizontalAlignment(1)
	up:setTextVerticalAlignment(1)
	center:addChild(up);

	--描边UILabel 下
	local down = ccs.label({
		text = string,
		color = marginColor,
	})
	down:setFontSize(fontSize)
	down:setPosition(ccp(0, 0-lineWidth));
	down:setZOrder(-1)
	down:setTextHorizontalAlignment(1)
	down:setTextVerticalAlignment(1)
	center:addChild(down);

	--描边UILabel 左
	local left = ccs.label({
		text = string,
		color = marginColor,
	})
	left:setFontSize(fontSize)
	left:setPosition(ccp(0-lineWidth, 0));
	left:setZOrder(-1)
	left:setTextHorizontalAlignment(1)
	left:setTextVerticalAlignment(1)
	center:addChild(left);

	--描边UILabel 上
	local right = ccs.label({
		text = string,
		color = marginColor,
	})
	right:setFontSize(fontSize)
	right:setPosition(ccp(0+lineWidth, 0));
	right:setZOrder(-1)
	right:setTextHorizontalAlignment(1)
	right:setTextVerticalAlignment(1)
	center:addChild(right);

	return center;
end

--[[--
--CCLabelTTF制作文字描边效
--@param #CCLabelTTF label 中心文本(可以传nil)
--@param #string string 文本
--@param #string fontName   文本字体类型
--@param #number fontSize   文本大小
--@param #number centerColor  文本中心颜色
--@param #number marginColor  文本边缘颜色
--@param #number lineWidth  所描边的宽度
--]]
function CCLabelTTFAddStroke(label, string, fontName, fontSize, centerColor, marginColor, lineWidth)
	local center = label
	--正文CCLabelTTF
	if center == nil then
		center = CCLabelTTF:create(string, fontName, fontSize);
		center:setColor(centerColor);
	end

	--描边CCLabelTTF 上
	local up = CCLabelTTF:create(string, fontName, fontSize);
	up:setColor(marginColor);
	up:setPosition(ccp(center:getContentSize().width*0.5, center:getContentSize().height*0.5+lineWidth));
	center:addChild(up,-1);

	--描边CCLabelTTF 下
	local down = CCLabelTTF:create(string, fontName, fontSize);
	down:setColor(marginColor);
	down:setPosition(ccp(center:getContentSize().width*0.5, center:getContentSize().height*0.5-lineWidth));
	center:addChild(down,-1);

	--描边CCLabelTTF 左
	local left = CCLabelTTF:create(string, fontName, fontSize);
	left:setPosition(ccp(center:getContentSize().width*0.5-lineWidth, center:getContentSize().height*0.5));
	left:setColor(marginColor);
	center:addChild(left,-1);

	--描边CCLabelTTF 右
	local right = CCLabelTTF:create(string, fontName, fontSize);
	right:setColor(marginColor);
	right:setPosition(ccp(center:getContentSize().width*0.5+lineWidth,center:getContentSize().height*0.5));
	center:addChild(right,-1);

	return center;
end


--[[--
--CCLabelTTF给文字添加阴影
--@param #string string 文本
--@param #string fontName   文本字体类型
--@param #number fontSize   文本大小
--@param #number color     文本颜色
--@param #number shadowSize     阴影大小
--@param #number shadowOpacity  阴影透明度
--]]
function CCLabelTTFAddShadow(string, fontName, fontSize, color, shadowSize, shadowOpacity)
	local shadow = CCLabelTTF:create(string, fontName, fontSize);
	shadow:setColor(ccc3(0,0,0));
	shadow:setOpacity(shadowOpacity);

	local center = CCLabelTTF:create(string, fontName, fontSize);
	center:setColor(color);
	center:setPosition(ccp(shadow:getContentSize().width*0.5-shadowSize, shadow:getContentSize().height*0.5+shadowSize));
	shadow:addChild(center);

	return shadow;
end


--[[--
--CCLabelTTF既添加描边又添加阴影
--@param #string string 文本
--@param #string fontName   文本字体类型
--@param #number fontSize   文本大小
--@param #number centerColor  文本中心颜色
--@param #number marginColor  文本边缘颜色
--@param #number lineWidth  所描边的宽度
--@param #number shadowSize     阴影大小
--@param #number shadowOpacity  阴影透明度
--]]
function CCLabelTTFAddOutlineAndShadow(label ,string, fontName, fontSize, centerColor, marginColor, lineWidth, shadowSize, shadowOpacity)

	local center = label
	if center == nil then
		center = CCLabelTTFAddStroke(nil, string, fontName, fontSize, centerColor, marginColor, lineWidth);
	end

	local shadow = CCLabelTTF:create(string, fontName, fontSize);
	shadow:setPosition(ccp(center:getContentSize().width*0.5+shadowSize, center:getContentSize().height*0.5-shadowSize));
	shadow:setColor(ccc3(0,0,0));
	shadow:setOpacity(shadowOpacity);
	center:addChild(shadow,-1);

	return center;
end