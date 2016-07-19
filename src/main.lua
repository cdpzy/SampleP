function UseBabePrint()
    function babe_tostring(...)
        local num = select("#",...);
        local args = {...};
        local outs = {};
        for i = 1, num do
            if i > 1 then
                outs[#outs+1] = "\t";
            end
            outs[#outs+1] = tostring(args[i]);
        end
        return table.concat(outs);
    end

    local babe_print = print;
    local babe_output = function(...)
        babe_print(...);

        if decoda_output ~= nil then
            local str = babe_tostring(...);
            decoda_output(str);
        end
    end
    print = babe_output;
end

if nil == cc then
    cc = {}
    require "cocos.cocos2d.Cocos2d"
else
    cc.FileUtils:getInstance():setPopupNotify(false)
    cc.FileUtils:getInstance():addSearchPath("src/")
    cc.FileUtils:getInstance():addSearchPath("res/")

    UseBabePrint()

    require "config"
    require "cocos.init"
end


local function main()
    
    local build = require("GeneratePath")
    build:build()

    --鱼阵路径
    local scene = require("ScenePath")
    scene:build()
end

if nil == __G__TRACKBACK__ then
    __G__TRACKBACK__ = function(msg)
        local msg = debug.traceback(msg, 3)
        print(msg)
        return msg
    end
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
