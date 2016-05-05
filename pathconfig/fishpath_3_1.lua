--example configuration
--t 1 bezier curve 2 linear
--starts start point 
--ends end point
--duration
--section -1 or duration * 30
--sct
--dct
local fishpath_1_1 = {
	{t = 2, starts = {x=960, y=1080}, ends = {x=960, y=540}, duration= 5, section=-1,},
	{t = 2, starts = {x=960, y=540}, ends = {x=0, y=540}, duration= 5, section=-1,},
}

return fishpath_1_1