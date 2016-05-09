local PathSinTo = {}
local _M = PathSinTo

_M.interval = 1. / 30.

function _M:new(conf)
	local o = {}
	o.conf = conf

	self.__index = self
	setmetatable(o, self)

	return o
end

function _M:build(pos)
	if 1 == pos.v then
		return self:buildVertical(pos)
	else
		return self:buildHorizontal(pos)
	end
end

function _M:buildVertical(pos)
	local len = pos.l
	
	local stepLen = math.abs(pos.ep - pos.sp) / pos.duration * self.interval
	if pos.sp > pos.ep then stepLen = -stepLen end
	local delt = 0
	local start = 0
	local nstart = 0

	local apos = {}
	local ps = {}
	local pl = {}
	local dis = 0
	for i = 1, #pos.o do
		delt = 0
		ps = {}
		pl = {}
		while math.abs(delt) < len do
			start = pos.sp + delt

			nstart = (start - pos.o[i][2]) / len * 2
			if pos.sp > pos.ep then nstart = -nstart end

			dis = math.sin(nstart * math.pi) * pos.peak

			table.insert(ps, cc.p(pos.o[i][1] +  dis, start))
			table.insert(pl, cc.p(pos.o[i][1] - dis, start))

			delt = delt + stepLen
		end

		table.insert(apos, ps)
		table.insert(apos, pl)
	end

	return apos
end

function _M:buildHorizontal(pos)
	print("unfinished")
end

return _M