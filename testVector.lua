if nil == cc then
    cc = {}
    require "cocos.cocos2d.Cocos2d"
end

local a = cc.p(2,2)
local b = cc.p(2,2)
--local b = cc.p(1,1)

print("e ==========", cc.pDot(a,b))
print("d ==========", cc.pDot(cc.pNormalize(a), cc.pNormalize(b)))

a = cc.p(2, 2)
b = cc.p(4, -4)
print("e ==========", cc.pDot(a,b))
print("d ==========", cc.pDot(cc.pNormalize(a), cc.pNormalize(b)))

-- print("d ==========", cc.pDot(a,a))
-- print("d ==========", cc.pDot(b,b))
-- print("d ==========", cc.pDot(b,a))
-- print("a ==========", cc.pGetLength(a))
-- print("b ==========", cc.pGetLength(b))
-- print("m ==========", cc.pMult(a,b))