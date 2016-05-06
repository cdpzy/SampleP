local PathSinTo = {}

function PathSinTo:new(conf)
	local o = {}
	o.conf = conf

	self.__index = self
	setmemtatable(o, self)

	return o
end

function PathSinTo:build(pos)
	
end

return PathSinTo