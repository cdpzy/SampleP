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
	{ name = "fish_3_3",
	  size = {450, 186},
	  ellipse = { --width, height, posx, posy
	  	{425, 105, 17, 40},
	  	{85, 186, 178, 0},
	  },
	},
    { name = "fish_2_8",
      size = {300, 140},
      ellipse = { --width, height, posx, posy
        {290, 63, 3, 34},
        {48, 108, 250, 16},
        {34, 136, 184, 1},
      },
    },
    { name = "fish_2_5",
      size = {134, 168},
      ellipse = { --width, height, posx, posy
        {95, 73, 39, 45},
        {50, 169, 67, 1},
        {52, 16, 1, 73}, 
      },
    },
    { name = "fish_2_3",
      size = {128, 72},
      ellipse = { --width, height, posx, posy
        {128, 47, 0, 13},
        {61, 71, 62, 1},
      },
    },
    { name = "fish_2_2",
      size = {176, 70},
      ellipse = { --width, height, posx, posy
        {88, 44, 87, 11},
        {83, 68, 3, 1},
      },
    },
    { name = "fish_1_10",
      size = {112, 121},
      ellipse = { --width, height, posx, posy
        {110, 56, 2, 31},
        {38, 110, 41, 4},
        {32, 94, 2, 17},
      },
    },
    { name = "fish_1_6",
      size = {63, 46},
      ellipse = { --width, height, posx, posy
        {63, 40, 1, 2},
      },
    },
    { name = "fish_1_5",
      size = {160, 70},
      ellipse = { --width, height, posx, posy
        {157, 47, 1, 9},
      },
    },
    { name = "fish_1_4",
      size = {120, 58},
      ellipse = { --width, height, posx, posy
        {111, 32, 2, 14},
      },
    }, 
    { name = "fish_1_3",
      size = {62, 41},
      ellipse = { --width, height, posx, posy
        {64,39,1,2},
      },
    },
    { name = "fish_1_2",
      size = {52, 24},
      ellipse = { --width, height, posx, posy
        {49,23,2,0},
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

local file = io.open("fish_ellipse.lua", "wb")
file:write("--autogen fish collision zone begin.  !!!DO NOT MODIFY!!! COPY&&PAST\n")
file:write("local czConfig = {\n")
for _,v in ipairs(outEllipse) do
	file:write("\t{\n\t\t\"")
	file:write(v[1])
	file:write("\",\n")
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