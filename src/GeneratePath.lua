--BuildFishPath.lua
--根据配置生成鱼路径
--ppp 2016-04-11


local pathTimeConf = require("pathTimeConf")

local BezierTo = {

}

function BezierTo:new(t, conf)
    o = {}

    o.t = t
    --o.conf = conf

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
function BezierTo:getPoint(dt)
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

function BezierTo:bezierat(  a,  b,  c,  d,  t )
    local tmep = math.pow(1-t, 3)*a + 3*t*math.pow(1-t, 2)*b + 3*math.pow(t, 2)*(1-t)*c + math.pow(t, 3)*d
    return tmep
end


local BuildFishPath = {}
local _M = BuildFishPath

_M.interval = 1.0 / 30.0

if nil ~= lfs then
    _M.savePathStr = lfs.currentdir() .. "/"
else
    _M.savePathStr = "J:/fishJoy/FishJoyPath2/fishjoypath/simulator/win32/src/"
end

print("working directory ", _M.savePathStr)
_M.speedConfig = {
    [1] = 100,   [2] = 80,  [3] = 100,  [4] = 110,  [5] = 120,
    [6] = 90,   [7] = 130,  [8] = 120,  [9] = 90,  [10] = 50,
    [11] = 70,  [12] = 80, [13] = 100, [14] = 80, [15] = 80,
    [16] = 90,  [17] = 60, [18] = 60, [19] = 60, [20] = 50,
    [21] = 70,  [22] = 60, [23] = 60, [24] = 50, [25] = 60,
    [26] = 60,  [27] = 65, [28] = 65, [29] = 40, 
}

_M.configs = {
}

function _M:build()
    self:makeConfigs()

    print("start processing  total ", #self.configs)
    local p = nil
    local curCnt = 1
    local fishType = nil
    local pathID = nil
    local totalTime = nil
    local singleTime = nil
    for k,v in pairs(self.configs) do
        p = require(k)
        fishType, pathID = self:getFishType(k)

        if nil ~= pathTimeConf[fishType] then
            totalTime = pathTimeConf[fishType][pathID]
            print("====handling && total time", fishType, pathID)
            

            --assign duration equally.
            singleTime = totalTime / #p
            singleTime = string.format("%.02f", singleTime)
            singleTime = tonumber(singleTime)
            for _,s in ipairs(p) do
                s.duration = singleTime
            end
        else
            print("there is no time definition for fish ", fishType)
        end

        self:parsePath(p, v, fishType)
        p = nil
        curCnt = curCnt + 1
        print("finished   ", k)
    end
end

function _M:makeConfigs()
    self.configs = {}

    local path = lfs.currentdir() .. "/pathconfig/"

    for file in lfs.dir(path) do
        print("files is ", file)
        if nil ~= string.find(file, ".lua") then
            local pos = string.find(file, "%.")
            local name = string.sub(file, 1, pos - 1)
            print (name)
            self.configs[string.format("pathconfig/%s", name)] = { string.format("genPoint/%s.lua", name), name}
        end
    end
end

function _M:parsePath(p, f, fishType)
    local first = true
    local pos = {}
    local lastEnd = nil --计算的时候可能会有误差，保证连接在一起
    for _, v in pairs(p) do
        if 1 == v.t then
            if nil ~= lastEnd then v.starts = lastEnd end
            self:buildBezier(v, pos, first, fishType)
            lastEnd = pos[#pos]
        elseif 2 == v.t then
            if nil ~= lastEnd then v.starts = lastEnd end
            self:buildLinear(v, pos, first, fishType)
            lastEnd = pos[#pos]
        -- elseif 3 == v.t then
        --     self:buildCycle(v, pos, first)
        else
            assert(false, string.format("unknown fish type %d in file %s", checkv.t, checkstring(f[1])))
        end

        first = false
    end

    self:savePath(pos, f)
end

function _M:getFishType(name)
    local str = name
    local pos = string.find(str, '/')
    str = string.sub(str, pos + 1, #str)
    pos = string.find(str, "_")
    str = string.sub(str, pos + 1, #str)
    pos = string.find(str, "_")
    local ft = string.sub(str, 1, pos - 1)
    local pt = string.sub(str, pos + 1, #str)
    print("==========getFishType===========", ft, pt)
    return math.ceil(tonumber(ft)), math.ceil(tonumber(pt))
end

function _M:savePath(pos, f)
    local angle = {}
    for i=1, #pos - 1 do
        table.insert(angle, cc.pGetAngle(cc.pSub(pos[i+1], pos[i]), cc.p(0, 1)) * 57.29577951 - 90)
    end

    table.insert(angle, angle[#angle])

    local fh = io.open(self.savePathStr .. f[1], "wb")
    fh:write(string.format("local %s = {\n", f[2]))

    for i=1, #angle do
        fh:write(string.format("{X=%.2f,Y=%.2f,aX=%.2f,},\n", pos[i].x, pos[i].y, angle[i]))
    end

    fh:write("}\n")
    fh:write(string.format("return %s\n", f[2]))
    fh:close()
end

_M.bezierStep = 150
_M.simulateInterval = 2000
function _M:getBezierDuraton(v, first, fishType)
    local pos = {}
    if first then table.insert(pos, v.starts) end
    local bezier = BezierTo:new(self.simulateInterval,v)
    local delt = 1
    while delt < self.simulateInterval do
        dpos = bezier:getPoint(delt)
        table.insert(pos, dpos)
        delt = delt + 1
    end

    local len = 0.
    for i=2, #pos do
        len = len + cc.pGetDistance(pos[i], pos [i - 1])
    end

    return len / self.speedConfig[fishType]
end


function _M:buildBezier(v, pos, first, fishType)
    --v.duration = self:getBezierDuraton(v, first, fishType)

    if first then table.insert(pos, v.starts) end

    local delt = self.interval
    local dpos = nil

    self.ss = pos[#pos]
    self.ps = pos[#pos]

    local bezier = BezierTo:new(v.duration,v)
    while delt < v.duration do
        dpos = bezier:getPoint(delt)
        table.insert(pos, dpos)
        delt = delt + self.interval
    end
end

function _M:buildCycle(v, pos, first)
    if first then table.insert(pos, v.starts) end

end

function _M:bezierat(a, b, c, d, t)
    local tmep = math.pow(1-t, 3)*a + 3*t*math.pow(1-t, 2)*b + 3*math.pow(t, 2)*(1-t)*c + math.pow(t, 3)*d
    return tmep
end

function _M:BezierBy(start, second, controlPoint_1, controlPoint_2, duration, time)
    local diff    = cc.pMul(second, math.max(0, self.interval/duration))
    local elapsed = math.max(0, math.min(1, time/duration))
    local newPos  = cc.pAdd(start, diff)
    local x = self:bezierat(0, controlPoint_1.x, controlPoint_2.x, second.x, elapsed)
    local y = self:bezierat(0, controlPoint_1.y, controlPoint_2.y, second.y, elapsed)
    newPos = cc.pAdd(newPos, cc.p(x, y))
    return newPos
end

function cc.pLinePoint(p1, p2, ratio)
    return cc.p((p2.x+p1.x)*ratio, (p2.y+ p1.y)*ratio)
end

function _M:buildLinear(v, pos, first)
    if first then table.insert(pos, v.starts) end

    local delt = self.interval
    local mvb = cc.pSub(v.ends, v.starts)

    self.startPos = v.starts
    self.prevPos = v.starts
    local dpos = nil
    while delt < v.duration do
        dpos = self:MoveBy(mvb, v.duration, delt)
        table.insert(pos, dpos)
        delt = delt + self.interval
    end

    --table.insert(pos, v.ends)
end

function _M:MoveBy(mvb, duration, delt)
    local newPos = cc.pAdd(self.startPos, cc.pMul(mvb, delt/duration))

    return newPos
end

return _M
