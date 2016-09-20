function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

function dump(value, desciption, nesting)
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    local traceback = string.split(debug.traceback("", 2), "\n")
    print("dump from: " .. string.trim(traceback[3]))

    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
        elseif lookupTable[value] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, desciption)
            else
                result[#result +1 ] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    _dump(value, desciption, "- ", 1)

    for i, line in ipairs(result) do
        print(line)
    end
end


local FishConf = {
  {
    name = "fish_33",
    size= {247, 270},
    ellipse = { --width, height, posx, posy
      {244,144,1,63},
      {167,259,4,7},
    },
  },
  {
    name = "fish_32",
    size= {593, 268},
    ellipse = { --width, height, posx, posy
      {255,144,335,36},
      {226,153,13,32},
      {237,61,178,90},
    },
  },
  {
    name = "fish_32",
    size= {593, 268},
    ellipse = { --width, height, posx, posy
      {255,144,335,36},
      {226,153,13,32},
      {237,61,178,90},
    },
  },
	{ name = "fish_31",
      size = {480, 280},
      ellipse = { --width, height, posx, posy
        {252,278,13,14},
      },
    }, 
	{ name = "fish_30",
      size = {480, 280},
      ellipse = { --width, height, posx, posy
        {387,137,74,45},
        {115,178,30,8},
      },
    }, 
	{ name = "fish_24",
	  size = {396, 246},
	  ellipse = { --width, height, posx, posy
	  	{356, 122, 33, 31},
	  	{53, 179, 216, 0},
	  },
	},
    { name = "fish_18",
      size = {315, 172},
      ellipse = { --width, height, posx, posy
        {294, 78, 18, 23},
        {48, 141, 191, 16},
        {52, 103, 262, 18},
      },
    },
    { name = "fish_15",
      size = {149, 200},
      ellipse = { --width, height, posx, posy
        {101, 71, 48, 47},
        {59, 169, 78, 0},
        {52, 17, 13, 73}, 
      },
    },
    { name = "fish_13",
      size = {141, 104},
      ellipse = { --width, height, posx, posy
        {128, 47, 12, 13},
        {63, 75, 71, 0},
      },
    },
    { name = "fish_12",
      size = {189, 99},
      ellipse = { --width, height, posx, posy
        {91, 45, 98, 10},
        {84, 67, 16, 1},
      },
    },
    { name = "fish_10",
      size = {128, 153},
      ellipse = { --width, height, posx, posy
        {114, 60, 14, 29},
        {42, 122, 53, 0},
        {40, 90, 11, 14},
      },
    },
    { name = "fish_6",
      size = {78, 76},
      ellipse = { --width, height, posx, posy
        {63, 40, 15, 0},
      },
    },
    { name = "fish_5",
      size = {174, 101},
      ellipse = { --width, height, posx, posy
        {157, 55, 18, 4},
      },
    },
    { name = "fish_4",
      size = {134, 82},
      ellipse = { --width, height, posx, posy
        {116, 45, 17, 12},
      },
    }, 
    { name = "fish_3",
      size = {77, 73},
      ellipse = { --width, height, posx, posy
        {63,39,14,1},
      },
    },
    { name = "fish_2",
      size = {55, 36},
      ellipse = { --width, height, posx, posy
        {54,20,3,2},
      },
    },        
}

function getCenter(L,H)
	assert(L ~= H)
	if L > H then
		local x = math.sqrt( L * L / 4 - H * H / 4)
		--print("getCenter ", x)
		local x1 = L / 2 - x
		local x2 = L / 2 + x

		return {x1, H / 2.}, {x2, H/2.}
	else
		local x = math.sqrt( H * H / 4 - L * L / 4)
		--print("getCenter ", x)
		local x1 = H / 2 - x
		local x2 = H / 2 + x

		return {L/2., x1}, {L/2., x2}
	end
end

function changeAnchor(size, ellipse, origin)
	origin[1] = origin[1] + ellipse[3]
	origin[2] = origin[2] + ellipse[4]

	-- origin[1] = origin[1] - size[1] / 2
	-- origin[2] = origin[2] - size[2] / 2

	return origin
end

local outEllipse = {}
for _, fish in ipairs(FishConf) do
	print("current handling fish ", fish.name)

	local rst = {}
	
	for _, ellipse in ipairs(fish.ellipse) do
		local conf = {}
		--转换坐标先
		ellipse[4] = fish.size[2] - ellipse[4] - ellipse[2]

    if ellipse[1] == ellipse[2] then
        ellipse[1] = ellipse[1] + 1
    end
		local center1, center2 = getCenter(ellipse[1], ellipse[2])

		changeAnchor(fish.size, ellipse, center1)
		changeAnchor(fish.size, ellipse, center2)

		table.insert(conf, center1[1])
		table.insert(conf, center1[2])
		table.insert(conf, center2[1])
		table.insert(conf, center2[2])
    if ellipse[1] > ellipse[2] then
		  table.insert(conf, ellipse[1])
    else
      table.insert(conf, ellipse[2])
    end  

		table.insert(rst, conf)
	end

	table.insert(outEllipse, {fish.name, rst})
end

--dump(outEllipse, "ellipse", 10)
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

local file = io.open("fish_ellipse.lua", "wb")
file:write("--autogen fish collision zone begin.  !!!DO NOT MODIFY!!! COPY&&PAST\n")
file:write("local czConfig = {\n")
for _,v in ipairs(outEllipse) do
	local a = string.split(v[1], "_")
	file:write(("\t[%d] = { -- %s\n"):format(tonumber(a[2]), v[1]))

	for _,e in ipairs(v[2]) do
		file:write("\t\t{")
		for _,p in ipairs(e) do
			file:write(string.format("%.2f,", p))
		end
		file:write("},\n")
	end
	file:write("\t},\n")
end
file:write("}\n")
file:write("--autogen fish collision zone ends.   !!!DO NOT MODIFY!!! COPY&&PAST\n")
file:close()
