-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-14 19:39:24
-- @Last Modified time  : 2023-05-14 10:35:42

local NPC = {}
local 对话 = {
[[我是专门为本帮成员驯养坐骑的坐骑驯养师，想要坐骑能够快速的强大起来，来找我吧，我一定会帮助你的。
menu
我要提高坐骑经验
我要进行高级驯养(需要高级坐骑令)
什么都不想做]],
[[我是专门为本帮成员驯养坐骑的坐骑驯养师，想要坐骑能够快速的强大起来，来找我吧，我一定会帮助你的。
menu
我想停止驯养
什么都不想做]],
}
--其它对话
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('驯养坐骑')
    if r then
        return 对话[2]
    end
    return 对话[1]
end

function NPC:NPC菜单(玩家, i)
    if not 玩家.帮派数据.帮派成就 then
        玩家.帮派数据.帮派成就 = 0
    end
    if i == '我要提高坐骑经验' then
        local z = 玩家:取乘骑坐骑()
        if not z then
            return '你需要保持乘骑状态,才可以驯养坐骑'
        end
        return '请选择你要驯养的项目:'..'\nmenu\n1|我要提高坐骑经验\n2|我要提高坐骑技能熟练度。\n3|什么都不想做。'
    elseif i == '我要进行高级驯养(需要高级坐骑令)' then
        local d = 玩家:取物品是否存在('高级坐骑令')
        if d then
            d:减少(1)
            local r = 玩家:取任务('驯养坐骑')
            if r then
                return '你已有同类驯养任务'
            else
                local z = 玩家:取乘骑坐骑()
                玩家:添加任务('驯养坐骑')
                local rr = 玩家:取任务('驯养坐骑')
                if rr then
                    rr.类型 = '熟练'
                    rr.循环 = 0
                    rr.时间 = os.time() + 36000
                    rr.消耗成就 = 0
                    rr.驯养数值 = 0
                    rr.高级驯养 = true
                    if z:是否拥有技能() == 0 then
                        rr:删除()
                        return '你的坐骑并没有学习技能,无法驯养'
                    end
                end
            end
        else
            return '你没有高级坐骑令'
        end
    elseif i == '我想停止驯养' then
        local rr = 玩家:取任务('驯养坐骑')
        if rr then
            rr:删除()
        end
    elseif i == '1' or i == '2' then
        local r = 玩家:取任务('驯养坐骑')
        if r then
            return '你已有同类驯养任务'
        else
            local zq = 玩家:取乘骑坐骑()
            if not zq then
                return '你凑什么热闹'
            end
            玩家:添加任务('驯养坐骑')
            local rr = 玩家:取任务('驯养坐骑')
            if rr then
                if i == '1' then
                    rr.类型 = '经验'
                elseif i == '2' then
                    rr.类型 = '熟练'
                    if zq:是否拥有技能() == 0 then
                        rr:删除()
                        return '你的坐骑并没有学习技能,无法驯养'
                    end
                end
                rr.循环 = 0
                rr.时间 = os.time() + 3600
                rr.消耗成就 = 0
                rr.驯养数值 = 0
                rr.高级驯养 = false

            end
        end
    end
end

return NPC
