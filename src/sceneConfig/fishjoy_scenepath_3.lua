local fishjoy_scenepath_3 = {
	v = 1, --direcotr, 0 horizontal 1 vertical
	duration = 20, 						-- 整体时间间隔
	d = 20,         					-- 每条鱼之间的时间间隔
	c = 30,								-- 每条路径上面鱼的数量

	--sample config for vertical

	l = 760,    						-- 屏幕内部长度，通常h模式为w，v模式为h
	sp = 800,   						-- 鱼的起始位置，horizontal 为x， vertical为 y
	ep = -70,   						-- 鱼的结束位置，horizontal 为x， vertical为 y

	peak = 200,    	 					-- 偏离的峰值

	t = {{1,2}, {2,1}},					-- 对应鱼的类型，对应4条轨迹
	o = {{280, 760}, {1000, 760}},
}

return fishjoy_scenepath_3