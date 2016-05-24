--BuildFishPath.lua
--根据配置生成鱼路径
--ppp 2016-04-11

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

_M.configs = {
    --[源配置文件] = {生成的配置文件, 生成的配置表名称}
	["pathconfig/fishpath_1_1"] = {"genPoint/fishpath_1_1.lua", "fishpath_1_1"},
    ["pathconfig/fishpath_2_1"] = {"genPoint/fishpath_2_1.lua", "fishpath_2_1"},
    ["pathconfig/fishpath_3_1"] = {"genPoint/fishpath_3_1.lua", "fishpath_3_1"},
    ["pathconfig/fishpath_4_1"] = {"genPoint/fishpath_4_1.lua", "fishpath_4_1"},
    ["pathconfig/fishpath_5_1"] = {"genPoint/fishpath_5_1.lua", "fishpath_5_1"},
    ["pathconfig/fishpath_6_1"] = {"genPoint/fishpath_6_1.lua", "fishpath_6_1"},
    ["pathconfig/fishpath_7_1"] = {"genPoint/fishpath_7_1.lua", "fishpath_7_1"},
    ["pathconfig/fishpath_8_1"] = {"genPoint/fishpath_8_1.lua", "fishpath_8_1"},
    ["pathconfig/fishpath_9_1"] = {"genPoint/fishpath_9_1.lua", "fishpath_9_1"},
    ["pathconfig/fishpath_10_1"] = {"genPoint/fishpath_10_1.lua", "fishpath_10_1"},
    ["pathconfig/fishpath_11_1"] = {"genPoint/fishpath_11_1.lua", "fishpath_11_1"},
    ["pathconfig/fishpath_12_1"] = {"genPoint/fishpath_12_1.lua", "fishpath_12_1"},
    ["pathconfig/fishpath_13_1"] = {"genPoint/fishpath_13_1.lua", "fishpath_13_1"},
    ["pathconfig/fishpath_14_1"] = {"genPoint/fishpath_14_1.lua", "fishpath_14_1"},
    ["pathconfig/fishpath_15_1"] = {"genPoint/fishpath_15_1.lua", "fishpath_15_1"},
    ["pathconfig/fishpath_16_1"] = {"genPoint/fishpath_16_1.lua", "fishpath_16_1"},
    ["pathconfig/fishpath_17_1"] = {"genPoint/fishpath_17_1.lua", "fishpath_17_1"},
    ["pathconfig/fishpath_18_1"] = {"genPoint/fishpath_18_1.lua", "fishpath_18_1"},
    ["pathconfig/fishpath_19_1"] = {"genPoint/fishpath_19_1.lua", "fishpath_19_1"},
    ["pathconfig/fishpath_20_1"] = {"genPoint/fishpath_20_1.lua", "fishpath_20_1"},
    ["pathconfig/fishpath_21_1"] = {"genPoint/fishpath_21_1.lua", "fishpath_21_1"},
    ["pathconfig/fishpath_22_1"] = {"genPoint/fishpath_22_1.lua", "fishpath_22_1"},
    ["pathconfig/fishpath_23_1"] = {"genPoint/fishpath_23_1.lua", "fishpath_23_1"},
    ["pathconfig/fishpath_24_1"] = {"genPoint/fishpath_24_1.lua", "fishpath_24_1"},
    ["pathconfig/fishpath_25_1"] = {"genPoint/fishpath_25_1.lua", "fishpath_25_1"},
    ["pathconfig/fishpath_26_1"] = {"genPoint/fishpath_26_1.lua", "fishpath_26_1"},
    ["pathconfig/fishpath_27_1"] = {"genPoint/fishpath_27_1.lua", "fishpath_27_1"}, 
    ["pathconfig/fishpath_28_1"] = {"genPoint/fishpath_28_1.lua", "fishpath_28_1"},
    ["pathconfig/fishpath_29_1"] = {"genPoint/fishpath_29_1.lua", "fishpath_29_1"}, 
}

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

function _M:build()
    local p = nil

    self:makeConfigs()

    print("start processing  total ", #self.configs)

    local curCnt = 1
    for k,v in pairs(self.configs) do
        print("processing curCnt ", curCnt, k)
        p = require(k)
        self:parsePath(p, v)
        p = nil
        curCnt = curCnt + 1
        print("finished   ", k)
    end
end

function _M:parsePath(p, f)
    local first = true
    local pos = {}
    local lastEnd = nil --计算的时候可能会有误差，保证连接在一起
    for _, v in pairs(p) do
        if 1 == v.t then
            if nil ~= lastEnd then v.starts = lastEnd end
            self:buildBezier(v, pos, first)
            lastEnd = pos[#pos]
        elseif 2 == v.t then
            if nil ~= lastEnd then v.starts = lastEnd end
            self:buildLinear(v, pos, first)
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

function _M:buildBezier(v, pos, first)
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
