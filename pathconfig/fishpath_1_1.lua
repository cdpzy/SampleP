--example configuration
--t 1 bezier curve 2 linear 3 cycle(clockwise)
--starts start point 
--ends end point
--duration
--section -1 or duration * 30
--sct
--dct
local fishpath_1_1 = {
	{t = 1, starts = {x=-27, y=90}, ends = {x=690, y=756}, duration = 6, section=-1, sct={x=112.25,y=-19.65}, dct={x=1084.37,y=445.47},},
	{t = 1, starts = {x=690, y=756}, ends = {x=1353, y=786}, duration = 6, section=-1, sct={x=282,y=1212}, dct={x=1200,y=1098},},
	{t = 1, starts = {x=1353, y=786}, ends = {x=1965, y=90}, duration = 6, section=-1, sct={x=1475.17,y=207.56}, dct={x=1902,y=-54},},
}

return fishpath_1_1