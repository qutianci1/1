-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2022-08-06 16:14:08

local 任务 = {
    名称 = '默认',
    类型 = '错误'
}

function 任务:任务初始化()
end

function 任务:任务取详情()
    return '#B任务不存在'
end

-- --#B◆[新手主线]天气晴好，宜出行，和#R<npc><click>1</click>霞姑娘</npc>#B
-- function rpc:获取任务详情()
--     return "#Bajslkdfjsldfj#R#u#m(##Y我我枯苛asdasd)12312qweqweqweqweqwe3#m#u"
-- end
return 任务
