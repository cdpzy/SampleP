local fishjoy_scenepath_2 = {
	-- 顶部小
	{t = 1, starts = {x=400, y=1230}, ends = {x=1520, y=1230}, duration = 15, section=-1, sct={x=400,y=660}, dct={x=1520,y=660},},
	-- 顶部大
	{t = 2, starts = {x=2010, y=1380}, ends = {x=-90, y=1380}, duration = 15, section=-1, sct={x=2020,y=480}, dct={x=-100,y=480},},
	-- 底部小
	{t = 1, starts = {x=1520, y=-150}, ends = {x=400, y=-150}, duration = 15, section=-1, sct={x=1520,y=420}, dct={x=400,y=420},},
	-- 底部大
	{t = 2, starts = {x=-90, y=-300}, ends = {x=2010, y=-300}, duration = 15, section=-1, sct={x=-100,y=600}, dct={x=2020,y=600},},
	-- 每条路径鱼的数量，每条鱼落后的点数
	{ c = 40, d = 20}
}

return fishjoy_scenepath_2