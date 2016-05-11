local fishjoy_scenepath_2 = {
	-- 顶部小
	{t = 1, starts = {x=200, y=790}, ends = {x=1080, y=790}, duration = 15, section=-1, sct={x=230,y=380}, dct={x=1050,y=380},},
	-- 顶部大
	{t = 2, starts = {x=1300, y=790}, ends = {x=-20, y=790}, duration = 15, section=-1, sct={x=1016,y=290}, dct={x=264,y=290},},
	-- 底部小
	{t = 1, starts = {x=1080, y=-30}, ends = {x=200, y=-30}, duration = 15, section=-1, sct={x=1050,y=380}, dct={x=230,y=380},},
	-- 底部大
	{t = 2, starts = {x=-20, y=-30}, ends = {x=1300, y=-30}, duration = 15, section=-1, sct={x=264,y=470}, dct={x=1016,y=470},},
	-- 每条路径鱼的数量，每条鱼落后的点数
	{ c = 40, d = 20}
}

return fishjoy_scenepath_2