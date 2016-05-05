--region ScenePath.lua
-- 2016-05-03 ppp 鱼阵路径生成脚本
-- 注意每种鱼阵必须和配置文件匹配
-- 如果不匹配那么可能会出现各种错误
-- 生成如下的点阵组合
-- {posX=0.000000, posY=0.000000, angleX=-23.537057, angleY=-23.537057,}
--endregion



local ScenePathBuilder = {}
local _M = ScenePathBuilder
_M.interval = 1.0 / 30.0
if nil ~= lfs then
    _M.savePathStr = lfs.currentdir() .. "/scenePoint/"
else
    _M.savePathStr = "J:/fishJoy/FishJoyPath2/fishjoypath/simulator/win32/src/"
end

function _M:build()
	self:BuildScene1("fishjoy_scenpath_1")

end

--region 图形描述
-- 上下双直线，中间是几个圆
--  * * * * * * * * * * * * * * * * * * * * * * * * 
--          *  * 
--        *     *
--       *   *   *
--         *   *
--           * 
--  * * * * * * * * * * * * * * * * * * * * * * * * 
--endregion
function _M:BuildScene1(name)
	local conf = require("sceneConfig/" .. "fishjoy_scenepath_1")

	--路径顺序 上,下,圆,圆心 直线从左到右，圆从
	--region 处理上面直线路径
	local baseInterval = conf.t
	local interval = 0
	local baseLen = conf.upx -  conf.updx
	local start = {}
	local shift = {}
	local pos = {}
	local stepLen = 0
	local upPos = {}
	--table.insert(upPos, conf.upc)
	--只计算最后一个，其他的通过偏移索引来
	shift = {}
	stepLen = baseLen / baseInterval * self.interval
	for i = conf.upc, 1, -1 do
		table.insert(shift, math.ceil((conf.upi * (i - 1)) / stepLen))
	end
	table.insert(upPos, shift)

	local v = {}
	v.starts = cc.p(conf.upx + (conf.upc - 1) * conf.upi, conf.upy)
	v.ends = cc.p(conf.updx, conf.upy)
	v.duration = baseInterval / baseLen * (baseLen + conf.upi * (conf.upc -1))
	pos = {}
	self:buildLinear(v, pos, true)
	table.insert(upPos, pos)
	--endregion 

	--region处理下面直线路径
	local dwPos = {}
	baseLen = conf.dwx -  conf.dwdx
	shift = {}
	stepLen = baseLen / baseInterval * self.interval
	for i = conf.upc, 1, -1 do
		table.insert(shift, math.ceil((conf.dwi * (i - 1)) / stepLen))
	end
	table.insert(dwPos, shift)

	v = {}
	v.starts = cc.p(conf.dwx + (conf.dwc - 1) * conf.dwi, conf.dwy)
	v.ends = cc.p(conf.dwdx, conf.dwy)
	v.duration = baseInterval / baseLen * (baseLen + conf.dwi * (conf.dwc -1))
	pos = {}
	self:buildLinear(v, pos, true)

	table.insert(dwPos, pos)
	--endregion

	--处理中心的圆
	local center = nil
	local rpos = {}
	shift = {}
	center = cc.p(conf.cx[#conf.cx], conf.cy)
	local firstPt = {}
	local start = cc.p(conf.cx[#conf.cx] + conf.r, conf.cy)
	local angle = math.pi * 2 / conf.rc
	local ptDiff = {}
	for i = 1, conf.rc do
		firstPt = cc.pRotateByAngle(start, center, angle * (i - 1))

		ptDiff = cc.pSub(firstPt, start)

		table.insert(shift, ptDiff)
	end
	table.insert(rpos, shift)

	local index = {}
	for i =1, #conf.cx do
		table.insert(index, math.ceil((conf.cx[#conf.cx] - conf.cx[i]) / stepLen))
	end
	table.insert(rpos, index)

	v = {}
	v.starts = start --cc.pRotateByAngle(start, center, angle * (i - 1))
	v.ends = cc.p(conf.cdx, v.starts.y)
	v.duration = baseInterval / baseLen * (v.starts.x - conf.cdx)
	pos = {}
	self:buildLinear(v, pos, true)
	table.insert(rpos, pos)


	--处理圆心的鱼
	local cpos = {}
	for _,c in pairs(conf.cx) do
		local v = {}
		v.starts = cc.p(c, conf.cy)
		v.ends = cc.p(conf.cdx, v.starts.y)
		v.duration = baseInterval / baseLen * (v.starts.x - conf.cdx)
		pos = {}
		self:buildLinear(v, pos, true)

		table.insert(cpos, pos)
	end

	self:saveScene1Path(name, conf, upPos, dwPos, rpos, cpos)
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

end

function _M:MoveBy(mvb, duration, delt)
    local newPos = cc.pAdd(self.startPos, cc.pMul(mvb, delt/duration))

    return newPos
end

-- 文件太大加载不了的
-- 切割成4个文件
function _M:saveScene1Pos(tname, t, apos)
	local path = self.savePathStr .. tname .. ".lua"
	print("saveScene1Path savne to ", path)
	local fh = io.open(path, "wb")
	fh:write(string.format("local %s = {\n", tname))
	fh:write(string.format("\tt = %d,\n", t))
	--偏移的索引
	fh:write("\ti = {\n\t\t")
	for i=1, #apos[1] do
		fh:write(string.format("%d,", apos[1][i]))
	end
	fh:write("\n\t},\n")
	--最后一条鱼的路径
	fh:write("\tp = {\n")
	local angle = {}
	local pos = apos[2]
    for j=1, #pos - 1 do
        table.insert(angle, cc.pGetAngle(cc.pSub(pos[j+1], pos[j]), cc.p(0, 1)) * 57.29577951 - 90)
    end
    table.insert(angle, angle[#angle])
    for j=1, #angle do
        fh:write(string.format("\t\t{X=%.2f,Y=%.2f,aX=%.2f},\n", pos[j].x, pos[j].y, angle[j]))
    end
	fh:write("\t}\n")
	fh:write("}\n")
	fh:write(string.format("return %s\n", tname))
	fh:close()	
end

function _M:saveScene1Cycle(tname, t, apos)
	--1 偏移度量， 2 偏移索引 3 路径
	path = self.savePathStr .. tname .. ".lua"
	print("saveScene1Path save to ", path)
	local fh = io.open(path, "wb")
	fh:write(string.format("local %s = {\n", tname))
	fh:write(string.format("\tt = %d,\n", t))

	--偏移度量
	fh:write("\ts = {\n")
	for i = 1, #apos[1] do
		fh:write(string.format("\t\t{x=%.2f,y=%.2f},\n", apos[1][i].x, apos[1][i].y))
	end
	fh:write("\t},\n")

	--偏移索引
	fh:write("\ti = {\n\t\t")
	for i = 1, #apos[2] do
		fh:write(string.format("%d,", apos[2][i]))
	end
	fh:write("\n\t},\n")

	--真正路径
	fh:write("\tp = {\n")

	local angle = {}
	local pos = apos[3]

    for j=1, #pos - 1 do
        table.insert(angle, cc.pGetAngle(cc.pSub(pos[j+1], pos[j]), cc.p(0, 1)) * 57.29577951 - 90)
    end
    table.insert(angle, angle[#angle])
    for j=1, #angle do
        fh:write(string.format("\t\t{X=%.2f,Y=%.2f,aX=%.2f},\n", pos[j].x, pos[j].y, angle[j]))
    end
    fh:write("\t},\n")
	fh:write("}\n")
    fh:write(string.format("return %s\n", tname))
	fh:close()
end

function _M:saveScene1Path(name, conf, upPos, dwPos, rpos, cpos)
	--上
	local tname = name .. "_up"
	self:saveScene1Pos(tname, conf.upt, upPos)
	--下
	tname = name .. "_dw"
	self:saveScene1Pos(tname, conf.dwt, dwPos)

	--圆圈
	tname = name .. "_r"
	self:saveScene1Cycle(tname, conf.dwt, rpos)

	--圆心位置
	tname = name .. "_c"
	path = self.savePathStr .. tname .. ".lua"
	print("saveScene1Path save to ", path)
	local fh = io.open(path, "wb")
	fh:write(string.format("local %s = {\n", tname))
	fh:write(string.format("\tt = %d,\n", conf.ct))
	fh:write("\tp = {\n")
	for i=1, #cpos do
		fh:write("\t\t{\n")
		local angle = {}
		local pos = cpos[i]

	    for j=1, #pos - 1 do
	        table.insert(angle, cc.pGetAngle(cc.pSub(pos[j+1], pos[j]), cc.p(0, 1)) * 57.29577951 - 90)
	    end
	    table.insert(angle, angle[#angle])
	    for j=1, #angle do
	        fh:write(string.format("\t\t\t{X=%.2f,Y=%.2f,aX=%.2f,},\n", pos[j].x, pos[j].y, angle[j]))
	    end
	    fh:write("\t\t},\n")
	end
	fh:write("\t},\n")
	fh:write("}\n")
    fh:write(string.format("return %s\n", tname))
	fh:close()
end


return _M


