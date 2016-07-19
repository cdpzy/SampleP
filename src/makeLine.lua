--MakeLine.lua
--ppp 2016-06-21
--get formula of the line through p1(x1, y1) p2(x2, y2) (x1 ~= x2 && y1 ~= y2)
--y = kx + n
if nil == cc then
    cc = {}
    require "cocos.cocos2d.Cocos2d"
else
    cc.FileUtils:getInstance():setPopupNotify(false)
    cc.FileUtils:getInstance():addSearchPath("src/")
    cc.FileUtils:getInstance():addSearchPath("res/")

    UseBabePrint()

    require "config"
    require "cocos.init"
end

local lineMaker = {}
local _M = lineMaker

--if 
--	p1.y = k * p1.x + n
--	p2.y = k * p2.y + n
--then
--  k =
--  n = 
--return k,n
function _M:getFormula(p1, p2)
	assert(p1.x ~= p2.x or p1.y ~= p2.y, "should not be the same point")
	if p1.x ~= p2.x then
		local k = (p1.y - p2.y) / (p1.x - p2.x)
	else

	end
end

--[[Test Section]]


return _M 