local PathBezierTo = {

}

PathBezierTo.interval = 1.0 / 30.0

function PathBezierTo:new(t, conf)
    o = {}

    o.t = t

    o.prePos = conf.starts
    o.start = conf.starts
    o._elapsed = 0
    o.conf = {}
    o.conf.sct = cc.pSub(conf.sct, o.start)
    o.conf.dct = cc.pSub(conf.dct, o.start)
    o.conf.ends = cc.pSub(conf.ends, o.start)

    self.__index = self
    setmetatable(o, self)

    return o
end

--dt单位是秒
function PathBezierTo:getPoint(dt)
    local updateDt = math.max(0, math.min(1, dt/self.t))

    local xa = 0;
    local xb = self.conf.sct.x;
    local xc = self.conf.dct.x;
    local xd = self.conf.ends.x;

    local ya = 0;
    local yb = self.conf.sct.y;
    local yc = self.conf.dct.y;
    local yd = self.conf.ends.y;

    local x = self:bezierat(xa, xb, xc, xd, updateDt);
    local y = self:bezierat(ya, yb, yc, yd, updateDt);

    local newPos = cc.pAdd(self.start , cc.p(x,y));
    return newPos
end

function PathBezierTo:bezierat(  a,  b,  c,  d,  t )
    local tmep = math.pow(1-t, 3)*a + 3*t*math.pow(1-t, 2)*b + 3*math.pow(t, 2)*(1-t)*c + math.pow(t, 3)*d
    return tmep
end

function PathBezierTo:buildBezier(v, pos, first)
    if first then table.insert(pos, v.starts) end

    local delt = self.interval
    local dpos = nil

    while delt < v.duration do
        dpos = self:getPoint(delt)
        table.insert(pos, dpos)
        delt = delt + self.interval
    end
end

return PathBezierTo
